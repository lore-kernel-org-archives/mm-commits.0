From: akpm@linux-foundation.org
Subject: [folded] utrace-core-kill-exclude_xtrace-logic.patch removed from -mm tree
Date: Tue, 05 May 2009 22:02:38 -0700
Message-ID: <200905060502.n4652c08007631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980AbZEFFEj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2009 01:04:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     utrace-core: kill exclude_xtrace logic
has been removed from the -mm tree.  Its filename was
     utrace-core-kill-exclude_xtrace-logic.patch

This patch was dropped because it was folded into utrace-core.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: utrace-core: kill exclude_xtrace logic
From: Oleg Nesterov <oleg@redhat.com>

exclude_utrace() has no callers. exclude_ptrace() is called under
tasklist_lock + task_lock() but needs utrace->lock.

Remove this logic for now. We will either add utrace-ptrace or rework
this mutual exclusion later.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |   18 +-----------------
 kernel/utrace.c |    8 --------
 2 files changed, 1 insertion(+), 25 deletions(-)

diff -puN kernel/ptrace.c~utrace-core-kill-exclude_xtrace-logic kernel/ptrace.c
--- a/kernel/ptrace.c~utrace-core-kill-exclude_xtrace-logic
+++ a/kernel/ptrace.c
@@ -16,7 +16,6 @@
 #include <linux/pagemap.h>
 #include <linux/smp_lock.h>
 #include <linux/ptrace.h>
-#include <linux/utrace.h>
 #include <linux/security.h>
 #include <linux/signal.h>
 #include <linux/audit.h>
@@ -175,14 +174,6 @@ bool ptrace_may_access(struct task_struc
 	return !err;
 }
 
-/*
- * For experimental use of utrace, exclude ptrace on the same task.
- */
-static inline bool exclude_ptrace(struct task_struct *task)
-{
-	return unlikely(!!task_utrace_flags(task));
-}
-
 int ptrace_attach(struct task_struct *task)
 {
 	int retval;
@@ -221,11 +212,6 @@ repeat:
 		goto repeat;
 	}
 
-	if (exclude_ptrace(task)) {
-		retval = -EBUSY;
-		goto bad;
-	}
-
 	if (!task->mm)
 		goto bad;
 	/* the same process cannot be attached many times */
@@ -602,9 +588,7 @@ int ptrace_traceme(void)
 	 */
 repeat:
 	task_lock(current);
-	if (exclude_ptrace(current)) {
-		ret = -EBUSY;
-	} else if (!(current->ptrace & PT_PTRACED)) {
+	if (!(current->ptrace & PT_PTRACED)) {
 		/*
 		 * See ptrace_attach() comments about the locking here.
 		 */
diff -puN kernel/utrace.c~utrace-core-kill-exclude_xtrace-logic kernel/utrace.c
--- a/kernel/utrace.c~utrace-core-kill-exclude_xtrace-logic
+++ a/kernel/utrace.c
@@ -108,14 +108,6 @@ static struct utrace_engine *matching_en
 }
 
 /*
- * For experimental use, utrace attach is mutually exclusive with ptrace.
- */
-static inline bool exclude_utrace(struct task_struct *task)
-{
-	return unlikely(!!task->ptrace);
-}
-
-/*
  * Called without locks, when we might be the first utrace engine to attach.
  * If this is a newborn thread and we are not the creator, we have to wait
  * for it.  The creator gets the first chance to attach.  The PF_STARTING
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
rcu_sched_grace_period-kill-the-bogus-flush_signals.patch
drivers-staging-epl-do-not-use-clone_sighand-with-allow_signal.patch
slow_work_thread-should-do-the-exclusive-wait.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
allow_signal-kill-the-bogus-mm-check-add-a-note-about-clone_sighand.patch
ptrace-remove-pt_dtrace-from-arch-h8300.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch
ptrace-remove-pt_dtrace-from-arch-m32r.patch
ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment-fix.patch
ptrace-do-not-use-task-ptrace-directly-in-core-kernel.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch
utrace-core-kill-exclude_xtrace-logic.patch
ptrace-ptrace_attach-check-pf_kthread-exit_state-instead-of-mm.patch
ptrace-cleanup-check-set-of-pt_ptraced-during-attach.patch
ptrace-do-not-use-task_lock-for-attach.patch
ptrace_get_task_struct-s-tasklist-rcu-make-it-static.patch
copy_process-remove-the-unneeded-clear_tsk_thread_flagtif_sigpending.patch
elf_core_dump-use-rcu_read_lock-to-access-real_parent.patch
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch

