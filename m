From: akpm@linux-foundation.org
Subject: + mm-simplify-nodemask-printing-fix.patch added to -mm tree
Date: Tue, 14 Nov 2017 12:17:45 -0800
Message-ID: <5a0b4f69.qRawLtQhNp3zet0e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54854 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753595AbdKNURq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Nov 2017 15:17:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, joe@perches.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-simplify-nodemask-printing-fix
has been added to the -mm tree.  Its filename is
     mm-simplify-nodemask-printing-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-simplify-nodemask-printing-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-simplify-nodemask-printing-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-simplify-nodemask-printing-fix

fix tile warning, per Arnd

Cc: Joe Perches <joe@perches.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/nodemask.h~mm-simplify-nodemask-printing-fix include/linux/nodemask.h
--- a/include/linux/nodemask.h~mm-simplify-nodemask-printing-fix
+++ a/include/linux/nodemask.h
@@ -104,7 +104,9 @@ extern nodemask_t _unused_nodemask_arg_;
  *
  * Can be used to provide arguments for '%*pb[l]' when printing a nodemask.
  */
-#define nodemask_pr_args(maskp)	(maskp) ? MAX_NUMNODES : 0, (maskp) ? (maskp)->bits : NULL
+#define nodemask_pr_args(maskp)				\
+	((maskp) != NULL) ? MAX_NUMNODES : 0,		\
+	((maskp) != NULL) ? (maskp)->bits : NULL
 
 /*
  * The inline keyword gives the compiler room to decide to inline, or
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
slab-slub-slob-convert-slab_flags_t-to-32-bit-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-drop-migrate-type-checks-from-has_unmovable_pages-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
f2fs-simplify-page-iteration-loops-fix.patch
mm-consolidate-page-table-accounting-fix-fix.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch
mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch
mm-simplify-nodemask-printing-fix.patch
support-resetting-warn_once-checkpatch-fixes.patch
support-resetting-warn_once-for-all-architectures-v2-fix.patch
support-resetting-warn_once-for-all-architectures-v2-fix-fix.patch
support-resetting-warn_once-for-all-architectures-v2-fix-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

