From: akpm@linux-foundation.org
Subject: + support-resetting-warn_once-checkpatch-fixes.patch added to -mm tree
Date: Tue, 17 Oct 2017 15:21:32 -0700
Message-ID: <59e6826c.Hcu117bBIWtvKHa5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56408 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966388AbdJQWVd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 18:21:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: support-resetting-warn_once-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     support-resetting-warn_once-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/support-resetting-warn_once-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/support-resetting-warn_once-checkpatch-fixes.patch

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
Subject: support-resetting-warn_once-checkpatch-fixes

ERROR: code indent should use tabs where possible
#124: FILE: kernel/panic.c:604:
+                        clear_warn_once_set,$

WARNING: please, no spaces at the start of a line
#124: FILE: kernel/panic.c:604:
+                        clear_warn_once_set,$

ERROR: code indent should use tabs where possible
#125: FILE: kernel/panic.c:605:
+^I^I        "%lld\n");$

WARNING: please use device_initcall() or more appropriate function instead of __initcall() (see include/linux/init.h)
#135: FILE: kernel/panic.c:615:
+__initcall(register_warn_debugfs);

total: 2 errors, 2 warnings, 87 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/support-resetting-warn_once.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/panic.c~support-resetting-warn_once-checkpatch-fixes kernel/panic.c
--- a/kernel/panic.c~support-resetting-warn_once-checkpatch-fixes
+++ a/kernel/panic.c
@@ -601,8 +601,8 @@ static int clear_warn_once_set(void *dat
 
 DEFINE_SIMPLE_ATTRIBUTE(clear_warn_once_fops,
 			NULL,
-                        clear_warn_once_set,
-		        "%lld\n");
+			clear_warn_once_set,
+			"%lld\n");
 
 static __init int register_warn_debugfs(void)
 {
@@ -612,7 +612,7 @@ static __init int register_warn_debugfs(
 	return 0;
 }
 
-__initcall(register_warn_debugfs);
+device_initcall(register_warn_debugfs);
 #endif
 
 #ifdef CONFIG_CC_STACKPROTECTOR
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-sysctl-make-numa-stats-configurable-fix.patch
mm-sysctl-make-numa-stats-configurable-fix-fix.patch
mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
support-resetting-warn_once-checkpatch-fixes.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

