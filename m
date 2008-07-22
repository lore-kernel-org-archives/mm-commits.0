From: akpm@linux-foundation.org
Subject: + documentation-update-codingstyle-tips-for-emacs-users-v2.patch added to -mm tree
Date: Tue, 22 Jul 2008 03:12:06 -0700
Message-ID: <200807221012.m6MAC62s022582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752424AbYGVKNO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 06:13:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, corbet@lwn.net, randy.dunlap@oracle.com


The patch titled
     documentation: update CodingStyle tips for Emacs users
has been added to the -mm tree.  Its filename is
     documentation-update-codingstyle-tips-for-emacs-users-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
linux-next.patch
git-xtensa.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
mm-drop-unneeded-pgdat-argument-from-free_area_init_node.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2.patch
vma-page-offset-has-no-callees-drop-it.patch
hugetlb-fix-race-when-reading-proc-meminfo.patch
hugetlb-quota-is-not-freed-for-unused-reserved-private-huge-pages.patch
linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-reorder-code-to-match-new-bootmem-structure.patch
revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-clean-up-bootmemc-file-header.patch
revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-add-documentation-to-api-functions.patch
revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-add-debugging-framework.patch
bootmem-add-debugging-framework-fix.patch
bootmem-revisit-bitmap-size-calculations.patch
bootmem-revisit-bootmem-descriptor-list-handling.patch
bootmem-clean-up-free_all_bootmem_core.patch
bootmem-clean-up-free_all_bootmem_core-fix.patch
bootmem-clean-up-alloc_bootmem_core.patch
bootmem-clean-up-alloc_bootmem_core-fix-new-alloc_bootmem_core.patch
bootmem-free-reserve-helpers.patch
bootmem-free-reserve-helpers-fix.patch
revert-revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-factor-out-the-marking-of-a-pfn-range.patch
bootmem-factor-out-the-marking-of-a-pfn-range-fix.patch
bootmem-respect-goal-more-likely.patch
bootmem-make-__alloc_bootmem_low_node-fall-back-to-other-nodes.patch
bootmem-revisit-alloc_bootmem_section.patch
bootmem-replace-node_boot_start-in-struct-bootmem_data.patch
bootmem-replace-node_boot_start-in-struct-bootmem_data-fix.patch
memory-hotplug-small-fixes-to-bootmem-freeing-for-memory-hotremove.patch
documentation-update-codingstyle-tips-for-emacs-users-v2.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch

