#!/usr/bin/env lfe
;; -*- lfe -*-

(defun main
  ([`(,port-string ,path)]
   (try
     (let ((port (list_to_integer port-string))
           (name (++ "ws" port-string)))
       (serve name port path))
     (catch
       ((tuple _ _ _) (usage)))))
  (['()] (main '["8000" "."]))
  ([_]   (usage)))

(defun usage () (io:fwrite "Usage: ws.lfe <port:8000> <path:.>\n"))

(defun serve (name port path)
  (inets:start)
  (let* [(mime-types '[#("html" "text/html")
                       #("htm"  "text/html")
                       #("css"  "text/css")
                       #("js"   "application/x-javascript")
                       #("svg"  "image/svg+xml")
                       #("png"  "image/png")
                       #("gif"  "image/gif")
                       #("jpg"  "image/jpeg")
                       #("jpeg" "image/jpeg")])
         (`#(ok ,pid) (inets:start
                       'httpd
                       `[#(port            ,port)
                         #(server_name     ,name)
                         #(server_root     ,path)
                         #(document_root   ,path)
                         #(directory_index ["index.html" "index.htm"])
                         #(mime_types      ,mime-types)]))]
    (lfe_io:format "Started listening on http://0.0.0.0:~p serving ~p\n" `(,port ,path))
    (lfe_io:format "Supported MIME types:\n~p\n" `(,mime-types))
    (receive
      ((tuple _ _)
       'ok))))

;; https://github.com/rvirding/lfe/blob/develop/bin/lfec
(defun fix-code-path ()
  (let* ((p0 (code:get_path))
         (p1 (lists:delete "." p0)))
    (code:set_path p1)))

(progn
  (fix-code-path)
  (main script-args))
