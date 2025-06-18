(setq custom-file "~/.emacs.d/.emacs.custom.el")
(add-to-list 'default-frame-alist `(font . "Iosevka-14"))

;; (set-selection-coding-system 'utf-16-le)
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(fido-vertical-mode 1)
(winner-mode 1)
(global-display-line-numbers-mode)     
(drag-stuff-mode 1)

(load-file custom-file)


(add-to-list 'load-path "~/.emacs.d/lang/")

(load "c3-language.el")

;; Change default command shell 
(setq explicit-shell-file-name "powershell.exe")
(setq shell-file-name "powershell.exe")
(setq explicit-powershell.exe-args '("-NoLogo" "-NoProfile" "-ExecutionPolicy" "RemoteSigned" "-Command" "-"))

;; Add Melpa Stable
(require 'package)

(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
   
;; tinymist
(add-to-list 'treesit-language-source-alist
             '(typst "https://github.com/uben0/tree-sitter-typst"))

(add-to-list 'load-path "~/.emacs.d/typst-ts-mode")
(require 'typst-ts-mode)

(with-eval-after-load 'eglot
  (with-eval-after-load 'typst-ts-mode
    (add-to-list 'eglot-server-programs
                 `((typst-ts-mode) .
                   ,(eglot-alternatives `(,typst-ts-lsp-download-path
                                          "tinymist"
                                          "typst-lsp"))))))

(defun duplicate-line-and-move ()
  "Duplicate current line and move point to the same column in the duplicated line."
  (interactive)
  (let* ((col (current-column))
         (line-start (line-beginning-position))
         (line-end (line-end-position))
         (line (buffer-substring line-start line-end)))
    (goto-char line-end)
    (newline)
    (insert line)
    (move-to-column col)))

;; Delete current line
(defun delete-current-line ()
  "Delete current line from start to the end of line (not word or sentence)"
  (interactive)
  (let ((line-start (line-beginning-position))
	(line-end (line-end-position)))
    (delete-region line-start line-end)))

;; Key shortcut
(global-set-key (kbd "C-,") #'duplicate-line-and-move)
(global-set-key (kbd "C-.") #'copy-from-above-command)
(global-set-key (kbd "M-n") #'glasses-mode)
(global-set-key (kbd "C-c c") #'compile)
(global-set-key (kbd "C-c r") #'recompile)
(global-set-key (kbd "C-D") #'delete-current-line)

;; Di Windows (atau beberapa terminal emulator), kombinasi seperti M-<up> tidak selalu
;; dikenali langsung oleh Emacs karena event-nya dikodekan sebagai escape sequence (\e).

(define-key input-decode-map "\e\eOA" [(meta up)])
(define-key input-decode-map "\e\eOB" [(meta down)])
(global-set-key [(meta up)] #'drag-stuff-up)
(global-set-key [(meta down)] #'drag-stuff-down)

;; for time
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(display-time-mode 1)

;; ada mode
(add-to-list 'load-path "~/.emacs.d/old-ada-mode")
(require 'ada-mode)
(cl-loop for ext in '("\\.gpr$" "\\.ada$" "\\.ads$" "\\.adb$")
           do (add-to-list 'auto-mode-alist (cons ext 'ada-mode)))

;;emacs tramp
(setq tramp-default-method "plink")

;; eralng conf
(setq load-path (cons  "C:/Program Files/Erlang OTP/lib/tools-3.6/emacs"
load-path))
(setq erlang-root-dir "C:/Program Files/Erlang OTP")
(setq exec-path (cons "C:/Program Files/Erlang OTP/bin" exec-path))
(require 'erlang-start)


;; add zig lsp
;; (use-package lsp-mode
;;   :ensure t
;;   :hook ((zig-mode . lsp))
;;   :commands lsp)

(remove-hook 'zig-mode-hook #'lsp)
(setq gc-cons-threshold (* 100 1024 1024))
(setq read-process-output-max (* 1024 1024))

