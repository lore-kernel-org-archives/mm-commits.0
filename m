From: akpm@linux-foundation.org
Subject: + ptrace-optimize-exit_ptrace-for-the-likely-case.patch added to -mm tree
Date: Thu, 29 Jul 2010 13:58:13 -0700
Message-ID: <201007292058.o6TKwDiF000884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755034Ab0G2U60 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jul 2010 16:58:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, roland@redhat.com, yanmin_zhang@linux.intel.com


The patch titled
     ptrace: optimize exit_ptrace() for the likely case
has been added to the -mm tree.  Its filename is
     ptrace-optimize-exit_ptrace-for-the-likely-case.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: optimize exit_ptrace() for the likely case
From: Oleg Nesterov <oleg@redhat.com>

exit_ptrace() takes tasklist_lock unconditionally.  We need this lock to
avoid the race with ptrace_traceme(), it acts as a barrier.

Change its caller, forget_original_parent(), to call exit_ptrace() under
tasklist_lock.  Change exit_ptrace() to drop and reacquire this lock if
needed.

This allows us to add the fastpath list_empty(ptraced) check.  In the
likely no-tracees case exit_ptrace() just returns and we avoid the lock()
+ unlock() sequence.

"Zhang, Yanmin" <yanmin_zhang@linux.intel.com> suggested to add this
check, and he reports that this change adds about 11% improvement in some
tests.

Suggested-and-tested-by: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c   |    7 +++++--
 kernel/ptrace.c |   12 +++++++++---
 2 files changed, 14 insertions(+), 5 deletions(-)

diff -puN kernel/exit.c~ptrace-optimize-exit_ptrace-for-the-likely-case kernel/exit.c
--- a/kernel/exit.c~ptrace-optimize-exit_ptrace-for-the-likely-case
+++ a/kernel/exit.c
@@ -771,9 +771,12 @@ static void forget_original_parent(struc
 	struct task_struct *p, *n, *reaper;
 	LIST_HEAD(dead_children);
 
-	exit_ptrace(father);
-
 	write_lock_irq(&tasklist_lock);
+	/*
+	 * Note that exit_ptrace() and find_new_reaper() might
+	 * drop tasklist_lock and reacquire it.
+	 */
+	exit_ptrace(father);
 	reaper = find_new_reaper(father);
 
 	list_for_each_entry_safe(p, n, &father->children, sibling) {
diff -puN kernel/ptrace.c~ptrace-optimize-exit_ptrace-for-the-likely-case kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-optimize-exit_ptrace-for-the-likely-case
+++ a/kernel/ptrace.c
@@ -324,26 +324,32 @@ int ptrace_detach(struct task_struct *ch
 }
 
 /*
- * Detach all tasks we were using ptrace on.
+ * Detach all tasks we were using ptrace on. Called with tasklist held
+ * for writing, and returns with it held too. But note it can release
+ * and reacquire the lock.
  */
 void exit_ptrace(struct task_struct *tracer)
 {
 	struct task_struct *p, *n;
 	LIST_HEAD(ptrace_dead);
 
-	write_lock_irq(&tasklist_lock);
+	if (likely(list_empty(&tracer->ptraced)))
+		return;
+
 	list_for_each_entry_safe(p, n, &tracer->ptraced, ptrace_entry) {
 		if (__ptrace_detach(tracer, p))
 			list_add(&p->ptrace_entry, &ptrace_dead);
 	}
-	write_unlock_irq(&tasklist_lock);
 
+	write_unlock_irq(&tasklist_lock);
 	BUG_ON(!list_empty(&tracer->ptraced));
 
 	list_for_each_entry_safe(p, n, &ptrace_dead, ptrace_entry) {
 		list_del_init(&p->ptrace_entry);
 		release_task(p);
 	}
+
+	write_lock_irq(&tasklist_lock);
 }
 
 int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len)
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-pf_exiting-check-should-take-mm-into-account.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-dump_tasks-use-find_lock_task_mm-too.patch
oom-improve-commentary-in-dump_tasks.patch
oom-dump_tasks-use-find_lock_task_mm-too-dump_tasks-use-find_lock_task_mm-too-fix.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-fix.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-introduce-find_lock_task_mm-to-fix-mm-false-positives-fix.patch
oom-dont-try-to-kill-oom_unkillable-child.patch
oom-oom_kill_process-doesnt-select-kthread-child.patch
oom-make-oom_unkillable_task-helper-function.patch
oom-oom_kill_process-needs-to-check-that-p-is-unkillable.patch
oom-proc-pid-oom_score-treat-kernel-thread-honestly.patch
oom-kill-duplicate-oom_disable-check.patch
oom-move-oom_disable-check-from-oom_kill_task-to-out_of_memory.patch
oom-cleanup-has_intersects_mems_allowed.patch
oom-remove-child-mm-check-from-oom_kill_process.patch
oom-give-the-dying-task-a-higher-priority.patch
oom-multi-threaded-process-coredump-dont-make-deadlock.patch
oom-move-badness-declaration-into-oomh.patch
oom-move-badness-declaration-into-oomh-fix.patch
sys_personality-remove-the-bogus-checks-in-sys_personality-__set_personality-path.patch
memcg-use-find_lock_task_mm-in-memory-cgroups-oom.patch
ptrace-optimize-exit_ptrace-for-the-likely-case.patch
pids-alloc_pidmap-remove-the-unnecessary-boundary-checks.patch
aio-do-not-return-erestartsys-and-friends-from-aio.patch

