From: akpm@linux-foundation.org
Subject: [folded-merged]
 ptrace-fix-ptrace_listen-race-corrupting-task-state-checkpatch-fixes.patch
 removed from -mm tree
Date: Fri, 07 Apr 2017 15:59:33 -0700
Message-ID: <58e819d5.xak/I+dm0Oo71kAX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36926 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751981AbdDGW7e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Apr 2017 18:59:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bsegall@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace-fix-ptrace_listen-race-corrupting-task-state-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ptrace-fix-ptrace_listen-race-corrupting-task-state-checkpatch-fixes.patch

This patch was dropped because it was folded into ptrace-fix-ptrace_listen-race-corrupting-task-state.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ptrace-fix-ptrace_listen-race-corrupting-task-state-checkpatch-fixes

ERROR: code indent should use tabs where possible
#39: FILE: kernel/ptrace.c:188:
+        * PTRACE_LISTEN can allow ptrace_trap_notify to wake us up$

ERROR: code indent should use tabs where possible
#40: FILE: kernel/ptrace.c:189:
+        * remotely. Recheck state under the lock to close this race.$

ERROR: code indent should use tabs where possible
#41: FILE: kernel/ptrace.c:190:
+        */$

WARNING: please, no spaces at the start of a line
#47: FILE: kernel/ptrace.c:192:
+       if (task->state == __TASK_TRACED) {$

WARNING: suspect code indent for conditional statements (7, 15)
#47: FILE: kernel/ptrace.c:192:
+       if (task->state == __TASK_TRACED) {
+               if (__fatal_signal_pending(task))

ERROR: code indent should use tabs where possible
#48: FILE: kernel/ptrace.c:193:
+               if (__fatal_signal_pending(task))$

WARNING: please, no spaces at the start of a line
#48: FILE: kernel/ptrace.c:193:
+               if (__fatal_signal_pending(task))$

WARNING: suspect code indent for conditional statements (15, 23)
#48: FILE: kernel/ptrace.c:193:
+               if (__fatal_signal_pending(task))
+                       wake_up_state(task, __TASK_TRACED);

ERROR: code indent should use tabs where possible
#49: FILE: kernel/ptrace.c:194:
+                       wake_up_state(task, __TASK_TRACED);$

WARNING: please, no spaces at the start of a line
#49: FILE: kernel/ptrace.c:194:
+                       wake_up_state(task, __TASK_TRACED);$

ERROR: code indent should use tabs where possible
#50: FILE: kernel/ptrace.c:195:
+               else$

WARNING: please, no spaces at the start of a line
#50: FILE: kernel/ptrace.c:195:
+               else$

ERROR: code indent should use tabs where possible
#51: FILE: kernel/ptrace.c:196:
+                       task->state = TASK_TRACED;$

WARNING: please, no spaces at the start of a line
#51: FILE: kernel/ptrace.c:196:
+                       task->state = TASK_TRACED;$

WARNING: please, no spaces at the start of a line
#52: FILE: kernel/ptrace.c:197:
+       }$

total: 7 errors, 8 warnings, 21 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/ptrace-fix-ptrace_listen-race-corrupting-task-state.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Ben Segall <bsegall@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN kernel/ptrace.c~ptrace-fix-ptrace_listen-race-corrupting-task-state-checkpatch-fixes kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-fix-ptrace_listen-race-corrupting-task-state-checkpatch-fixes
+++ a/kernel/ptrace.c
@@ -184,17 +184,17 @@ static void ptrace_unfreeze_traced(struc
 
 	WARN_ON(!task->ptrace || task->parent != current);
 
-       /*
-        * PTRACE_LISTEN can allow ptrace_trap_notify to wake us up
-        * remotely. Recheck state under the lock to close this race.
-        */
+	/*
+	 * PTRACE_LISTEN can allow ptrace_trap_notify to wake us up remotely.
+	 * Recheck state under the lock to close this race.
+	 */
 	spin_lock_irq(&task->sighand->siglock);
-       if (task->state == __TASK_TRACED) {
-               if (__fatal_signal_pending(task))
-                       wake_up_state(task, __TASK_TRACED);
-               else
-                       task->state = TASK_TRACED;
-       }
+	if (task->state == __TASK_TRACED) {
+		if (__fatal_signal_pending(task))
+			wake_up_state(task, __TASK_TRACED);
+		else
+			task->state = TASK_TRACED;
+	}
 	spin_unlock_irq(&task->sighand->siglock);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
ptrace-fix-ptrace_listen-race-corrupting-task-state.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
mm-introduce-memalloc_nofs_saverestore-api-fix.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
mm-page_alloc-count-movable-pages-when-stealing-from-pageblock-fix.patch
swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drm-use-set_memoryh-header-fix.patch
drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
docs-vm-transhuge-fix-few-trivial-typos-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

