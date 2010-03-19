From: akpm@linux-foundation.org
Subject: + signals-make-task_struct-signal-immutable-refcountable.patch added to -mm tree
Date: Fri, 19 Mar 2010 15:18:28 -0700
Message-ID: <201003192218.o2JMISft015486@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750986Ab0CSWS5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 18:18:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, alan@linux.intel.com, mingo@elte.hu, peterz@infradead.org, roland@redhat.com


The patch titled
     signals: make task_struct->signal immutable/refcountable
has been added to the -mm tree.  Its filename is
     signals-make-task_struct-signal-immutable-refcountable.patch

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
Subject: signals: make task_struct->signal immutable/refcountable
From: Oleg Nesterov <oleg@redhat.com>

We have a lot of problems with accessing task_struct->signal, it can
"disappear" at any moment.  Even current can't use its ->signal safely
after exit_notify().  ->siglock helps, but it is not convenient, not
always possible, and sometimes it makes sense to use task->signal even
after this task has already dead.

This patch adds the reference counter, sigcnt, into signal_struct.  This
reference is owned by task_struct and it is dropped in
__put_task_struct().  Perhaps it makes sense to export
get/put_signal_struct() later, but currently I don't see the immediate
reason.

Rename __cleanup_signal() to free_signal_struct() and unexport it.  With
the previous changes it does nothing except kmem_cache_free().

Change __exit_signal() to not clear/free ->signal, it will be freed when
the last reference to any thread in the thread group goes away.

Note:
	- when the last thead exits signal->tty can point to nowhere, see
	  the next patch.

	- with or without this patch signal_struct->count should go away,
	  or at least it should be "int nr_threads" for fs/proc. This will
	  be addressed later.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 kernel/exit.c         |    3 ---
 kernel/fork.c         |   23 ++++++++++++++++-------
 3 files changed, 17 insertions(+), 11 deletions(-)

diff -puN include/linux/sched.h~signals-make-task_struct-signal-immutable-refcountable include/linux/sched.h
--- a/include/linux/sched.h~signals-make-task_struct-signal-immutable-refcountable
+++ a/include/linux/sched.h
@@ -522,6 +522,7 @@ struct thread_group_cputimer {
  * the locking of signal_struct.
  */
 struct signal_struct {
+	atomic_t		sigcnt;
 	atomic_t		count;
 	atomic_t		live;
 
@@ -2103,7 +2104,6 @@ extern void flush_thread(void);
 extern void exit_thread(void);
 
 extern void exit_files(struct task_struct *);
-extern void __cleanup_signal(struct signal_struct *);
 extern void __cleanup_sighand(struct sighand_struct *);
 
 extern void exit_itimers(struct signal_struct *);
diff -puN kernel/exit.c~signals-make-task_struct-signal-immutable-refcountable kernel/exit.c
--- a/kernel/exit.c~signals-make-task_struct-signal-immutable-refcountable
+++ a/kernel/exit.c
@@ -135,8 +135,6 @@ static void __exit_signal(struct task_st
 	 * doing sigqueue_free() if we have SIGQUEUE_PREALLOC signals.
 	 */
 	flush_sigqueue(&tsk->pending);
-
-	tsk->signal = NULL;
 	tsk->sighand = NULL;
 	spin_unlock(&sighand->siglock);
 
@@ -151,7 +149,6 @@ static void __exit_signal(struct task_st
 		 */
 		task_rq_unlock_wait(tsk);
 		tty_kref_put(sig->tty);
-		__cleanup_signal(sig);
 	}
 }
 
diff -puN kernel/fork.c~signals-make-task_struct-signal-immutable-refcountable kernel/fork.c
--- a/kernel/fork.c~signals-make-task_struct-signal-immutable-refcountable
+++ a/kernel/fork.c
@@ -165,6 +165,18 @@ void free_task(struct task_struct *tsk)
 }
 EXPORT_SYMBOL(free_task);
 
+static inline void free_signal_struct(struct signal_struct *sig)
+{
+	thread_group_cputime_free(sig);
+	kmem_cache_free(signal_cachep, sig);
+}
+
+static inline void put_signal_struct(struct signal_struct *sig)
+{
+	if (atomic_dec_and_test(&sig->sigcnt))
+		free_signal_struct(sig);
+}
+
 void __put_task_struct(struct task_struct *tsk)
 {
 	WARN_ON(!tsk->exit_state);
@@ -173,6 +185,7 @@ void __put_task_struct(struct task_struc
 
 	exit_creds(tsk);
 	delayacct_tsk_free(tsk);
+	put_signal_struct(tsk->signal);
 
 	if (!profile_handoff_task(tsk))
 		free_task(tsk);
@@ -864,6 +877,7 @@ static int copy_signal(unsigned long clo
 	if (!sig)
 		return -ENOMEM;
 
+	atomic_set(&sig->sigcnt, 1);
 	atomic_set(&sig->count, 1);
 	atomic_set(&sig->live, 1);
 	init_waitqueue_head(&sig->wait_chldexit);
@@ -889,12 +903,6 @@ static int copy_signal(unsigned long clo
 	return 0;
 }
 
-void __cleanup_signal(struct signal_struct *sig)
-{
-	thread_group_cputime_free(sig);
-	kmem_cache_free(signal_cachep, sig);
-}
-
 static void copy_flags(unsigned long clone_flags, struct task_struct *p)
 {
 	unsigned long new_flags = p->flags;
@@ -1245,6 +1253,7 @@ static struct task_struct *copy_process(
 	}
 
 	if (clone_flags & CLONE_THREAD) {
+		atomic_inc(&current->signal->sigcnt);
 		atomic_inc(&current->signal->count);
 		atomic_inc(&current->signal->live);
 		p->group_leader = current->group_leader;
@@ -1291,7 +1300,7 @@ bad_fork_cleanup_mm:
 		mmput(p->mm);
 bad_fork_cleanup_signal:
 	if (!(clone_flags & CLONE_THREAD))
-		__cleanup_signal(p->signal);
+		free_signal_struct(p->signal);
 bad_fork_cleanup_sighand:
 	__cleanup_sighand(p->sighand);
 bad_fork_cleanup_fs:
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch
cpu-timers-simplify-rlimit_cpu-handling.patch
cpu-timers-cleanup-arm_timer.patch
cpu-timers-return-correct-previous-timer-reload-value.patch
cpu-timers-change-sigev_none-timer-implementation.patch
cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch
cpu-timers-optimize-run_posix_cpu_timers.patch
proc-cleanup-remove-unused-assignments.patch
kmod-add-init-function-to-usermodehelper.patch
exec-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch
umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init.patch
umh-creds-kill-subprocess_info-cred-logic.patch
call_usermodehelper-no-need-to-unblock-signals.patch
wait_for_helper-sigchld-from-user-space-can-lead-to-use-after-free.patch
call_usermodehelper-simplify-fix-umh_no_wait-case.patch
call_usermodehelper-umh_wait_exec-ignores-kernel_thread-failure.patch
coredump-factor-out-the-not-ispipe-file-checks.patch
coredump-cleanup-ispipe-code.patch
coredump-factor-out-put_cred-calls.patch
coredump-shift-down_writemmap_sem-into-coredump_wait.patch
exit-exit_notify-can-trust-signal-notify_count-0.patch
exit-change-zap_other_threads-to-count-sub-threads.patch
exit-avoid-sig-count-in-de_thread-__exit_signal-synchronization.patch
exit-avoid-sig-count-in-__exit_signal-to-detect-the-group-dead-case.patch
posix-cpu-timers-avoid-task-signal-=-null-checks.patch
ia64-ptrace_attach_sync_user_rbs-avoid-task-signal-=-null-checks.patch
fork-exit-move-tty_kref_put-outside-of-__cleanup_signal.patch
signals-make-task_struct-signal-immutable-refcountable.patch
signals-clear-signal-tty-when-the-last-thread-exits.patch
signals-kill-the-awful-task_rq_unlock_wait-hack.patch

