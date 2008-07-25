From: akpm@linux-foundation.org
Subject: - documentation-update-codingstyle-tips-for-emacs-users-v2.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:55:14 -0700
Message-ID: <200807252255.m6PMtEM3002962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753118AbYGYW4B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:56:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, corbet@lwn.net, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     documentation: update CodingStyle tips for Emacs users
has been removed from the -mm tree.  Its filename was
     documentation-update-codingstyle-tips-for-emacs-users-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: documentation: update CodingStyle tips for Emacs users
From: Johannes Weiner <hannes@saeurebad.de>

Describe a setup that integrates better with Emacs' cc-mode and also fixes
up the alignment of continuation lines to really only use tabs.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/CodingStyle |   40 +++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff -puN Documentation/CodingStyle~documentation-update-codingstyle-tips-for-emacs-users-v2 Documentation/CodingStyle
--- a/Documentation/CodingStyle~documentation-update-codingstyle-tips-for-emacs-users-v2
+++ a/Documentation/CodingStyle
@@ -474,25 +474,29 @@ make a good program).
 So, you can either get rid of GNU emacs, or change it to use saner
 values.  To do the latter, you can stick the following in your .emacs file:
 
-(defun linux-c-mode ()
-  "C mode with adjusted defaults for use with the Linux kernel."
-  (interactive)
-  (c-mode)
-  (c-set-style "K&R")
-  (setq tab-width 8)
-  (setq indent-tabs-mode t)
-  (setq c-basic-offset 8))
-
-This will define the M-x linux-c-mode command.  When hacking on a
-module, if you put the string -*- linux-c -*- somewhere on the first
-two lines, this mode will be automatically invoked. Also, you may want
-to add
+(defun c-lineup-arglist-tabs-only (ignored)
+  "Line up argument lists by tabs, not spaces"
+  (let* ((anchor (c-langelem-pos c-syntactic-element))
+	 (column (c-langelem-2nd-pos c-syntactic-element))
+	 (offset (- (1+ column) anchor))
+	 (steps (floor offset c-basic-offset)))
+    (* (max steps 1)
+       c-basic-offset)))
+
+(add-hook 'c-mode-hook
+          (lambda ()
+            (let ((filename (buffer-file-name)))
+              ;; Enable kernel mode for the appropriate files
+              (when (and filename
+                         (string-match "~/src/linux-trees" filename))
+                (setq indent-tabs-mode t)
+                (c-set-style "linux")
+                (c-set-offset 'arglist-cont-nonempty
+                              '(c-lineup-gcc-asm-reg
+                                c-lineup-arglist-tabs-only))))))
 
-(setq auto-mode-alist (cons '("/usr/src/linux.*/.*\\.[ch]$" . linux-c-mode)
-			auto-mode-alist))
-
-to your .emacs file if you want to have linux-c-mode switched on
-automagically when you edit source files under /usr/src/linux.
+This will make emacs go better with the kernel coding style for C
+files below ~/src/linux-trees.
 
 But even if you fail in getting emacs to do sane formatting, not
 everything is lost: use "indent".
_

Patches currently in -mm which might be from hannes@saeurebad.de are

origin.patch
bootmem-move-node-allocation-macros-back-to-have_arch_bootmem_node.patch
linux-next.patch
git-xtensa.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-print-swapcache-page-count-in-show_swap_cache_info.patch
lib-generic-show_mem.patch
alpha-use-generic-show_mem.patch
avr32-use-generic-show_mem.patch
blackfin-use-generic-show_mem.patch
xtensa-use-generic-show_mem.patch
x86-use-generic-show_mem.patch
um-use-generic-show_mem.patch
sparc64-use-generic-show_mem.patch
sh-use-generic-show_mem.patch
s390-use-generic-show_mem.patch
powerpc-use-generic-show_mem.patch
mn10300-use-generic-show_mem.patch
h8300-use-generic-show_mem.patch
mips-use-generic-show_mem.patch
m68knommu-use-generic-show_mem.patch
m68k-use-generic-show_mem.patch
m32r-use-generic-show_mem.patch
frv-use-generic-show_mem.patch
cris-use-generic-show_mem.patch

