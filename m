From: akpm@linux-foundation.org
Subject: + proc-turn-signal_struct-count-into-int-nr_threads.patch added to -mm tree
Date: Fri, 26 Mar 2010 16:01:36 -0700
Message-ID: <201003262301.o2QN1aZa026104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754390Ab0CZXCK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 19:02:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, adobriyan@gmail.com, ebiederm@xmission.com, roland@redhat.com


The patch titled
     proc: turn signal_struct->count into "int nr_threads"
has been added to the -mm tree.  Its filename is
     proc-turn-signal_struct-count-into-int-nr_threads.patch

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
Subject: proc: turn signal_struct->count into "int nr_threads"
From: Oleg Nesterov <oleg@redhat.com>

No functional changes, just s/atomic_t count/int nr_threads/.

With the recent changes this counter has a single user, get_nr_threads()
And, none of its callers need the really accurate number of threads, not
to mention each caller obviously races with fork/exit.  It is only used to
report this value to the user-space, except first_tid() uses it to avoid
the unnecessary while_each_thread() loop in the unlikely case.

It is a bit sad we need a word in struct signal_struct for this, perhaps
we can change get_nr_threads() to approximate the number of threads using
signal->live and kill ->nr_threads later.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init_task.h |    2 +-
 include/linux/sched.h     |    4 ++--
 kernel/exit.c             |    5 +----
 kernel/fork.c             |    8 ++++----
 4 files changed, 8 insertions(+), 11 deletions(-)

diff -puN include/linux/init_task.h~proc-turn-signal_struct-count-into-int-nr_threads include/linux/init_task.h
--- a/include/linux/init_task.h~proc-turn-signal_struct-count-into-int-nr_threads
+++ a/include/linux/init_task.h
@@ -16,7 +16,7 @@ extern struct files_struct init_files;
 extern struct fs_struct init_fs;
 
 #define INIT_SIGNALS(sig) {						\
-	.count		= ATOMIC_INIT(1), 				\
+	.nr_threads	= 1, 						\
 	.wait_chldexit	= __WAIT_QUEUE_HEAD_INITIALIZER(sig.wait_chldexit),\
 	.shared_pending	= { 						\
 		.list = LIST_HEAD_INIT(sig.shared_pending.list),	\
diff -puN include/linux/sched.h~proc-turn-signal_struct-count-into-int-nr_threads include/linux/sched.h
--- a/include/linux/sched.h~proc-turn-signal_struct-count-into-int-nr_threads
+++ a/include/linux/sched.h
@@ -522,8 +522,8 @@ struct thread_group_cputimer {
  */
 struct signal_struct {
 	atomic_t		sigcnt;
-	atomic_t		count;
 	atomic_t		live;
+	int			nr_threads;
 
 	wait_queue_head_t	wait_chldexit;	/* for wait4() */
 
@@ -2154,7 +2154,7 @@ extern bool current_is_single_threaded(v
 
 static inline int get_nr_threads(struct task_struct *tsk)
 {
-	return atomic_read(&tsk->signal->count);
+	return tsk->signal->nr_threads;
 }
 
 /* de_thread depends on thread_group_leader not being a pid based check */
diff -puN kernel/exit.c~proc-turn-signal_struct-count-into-int-nr_threads kernel/exit.c
--- a/kernel/exit.c~proc-turn-signal_struct-count-into-int-nr_threads
+++ a/kernel/exit.c
@@ -84,14 +84,10 @@ static void __exit_signal(struct task_st
 	struct sighand_struct *sighand;
 	struct tty_struct *uninitialized_var(tty);
 
-	BUG_ON(!sig);
-	BUG_ON(!atomic_read(&sig->count));
-
 	sighand = rcu_dereference_check(tsk->sighand,
 					rcu_read_lock_held() ||
 					lockdep_tasklist_lock_is_held());
 	spin_lock(&sighand->siglock);
-	atomic_dec(&sig->count);
 
 	posix_cpu_timers_exit(tsk);
 	if (group_dead) {
@@ -131,6 +127,7 @@ static void __exit_signal(struct task_st
 		sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
 	}
 
+	sig->nr_threads--;
 	__unhash_process(tsk, group_dead);
 
 	/*
diff -puN kernel/fork.c~proc-turn-signal_struct-count-into-int-nr_threads kernel/fork.c
--- a/kernel/fork.c~proc-turn-signal_struct-count-into-int-nr_threads
+++ a/kernel/fork.c
@@ -877,9 +877,9 @@ static int copy_signal(unsigned long clo
 	if (!sig)
 		return -ENOMEM;
 
-	atomic_set(&sig->sigcnt, 1);
-	atomic_set(&sig->count, 1);
+	sig->nr_threads = 1;
 	atomic_set(&sig->live, 1);
+	atomic_set(&sig->sigcnt, 1);
 	init_waitqueue_head(&sig->wait_chldexit);
 	if (clone_flags & CLONE_NEWPID)
 		sig->flags |= SIGNAL_UNKILLABLE;
@@ -1254,9 +1254,9 @@ static struct task_struct *copy_process(
 	}
 
 	if (clone_flags & CLONE_THREAD) {
-		atomic_inc(&current->signal->sigcnt);
-		atomic_inc(&current->signal->count);
+		current->signal->nr_threads++;
 		atomic_inc(&current->signal->live);
+		atomic_inc(&current->signal->sigcnt);
 		p->group_leader = current->group_leader;
 		list_add_tail_rcu(&p->thread_group, &p->group_leader->thread_group);
 	}
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
cpu-timers-simplify-rlimit_cpu-handling.patch
cpu-timers-cleanup-arm_timer.patch
cpu-timers-return-correct-previous-timer-reload-value.patch
cpu-timers-change-sigev_none-timer-implementation.patch
cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch
cpu-timers-optimize-run_posix_cpu_timers.patch
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
signals-clear-signal-tty-when-the-last-thread-exits-fix.patch
signals-kill-the-awful-task_rq_unlock_wait-hack.patch
exit-__exit_signal-use-thread_group_leader-consistently.patch
kill-the-obsolete-thread_group_cputime_free-and-taskstats_tgid_init-helpers.patch
exit-move-taskstats_tgid_free-from-__exit_signal-to-free_signal_struct.patch
check_unshare_flags-kill-the-bogus-clone_sighand-sig-count-check.patch
proc-get_nr_threads-doesnt-need-siglock-any-longer.patch
proc-make-collect_sigign_sigcatch-rcu-safe.patch
proc-make-task_sig-lockless.patch
proc_sched_show_task-use-get_nr_threads.patch
keyctl_session_to_parent-use-thread_group_empty-to-check-singlethreadness.patch
proc-turn-signal_struct-count-into-int-nr_threads.patch
proc-cleanup-remove-unused-assignments.patch

