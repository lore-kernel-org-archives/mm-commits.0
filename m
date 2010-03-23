From: akpm@linux-foundation.org
Subject: + exit-__exit_signal-use-thread_group_leader-consistently.patch added to -mm tree
Date: Mon, 22 Mar 2010 23:10:14 -0400
Message-ID: <201003230611.o2N6B6XH017514@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753528Ab0CWGLW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 02:11:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, balbir@linux.vnet.ibm.com, roland@redhat.com, sgruszka@redhat.com, vfalico@redhat.com


The patch titled
     exit: __exit_signal: use thread_group_leader() consistently
has been added to the -mm tree.  Its filename is
     exit-__exit_signal-use-thread_group_leader-consistently.patch

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
Subject: exit: __exit_signal: use thread_group_leader() consistently
From: Oleg Nesterov <oleg@redhat.com>

Cleanup:

- Add the boolean, group_dead = thread_group_leader(), for clarity.

- Do not test/set sig == NULL to detect the all-dead case, use this
  boolean.

- Pass this boolen to __unhash_process() and use it instead of another
  thread_group_leader() call which needs ->group_leader.

  This can be considered as microoptimization, but hopefully this also
  allows us do do other cleanups later.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Veaceslav Falico <vfalico@redhat.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN kernel/exit.c~exit-__exit_signal-use-thread_group_leader-consistently kernel/exit.c
--- a/kernel/exit.c~exit-__exit_signal-use-thread_group_leader-consistently
+++ a/kernel/exit.c
@@ -59,11 +59,11 @@
 
 static void exit_mm(struct task_struct * tsk);
 
-static void __unhash_process(struct task_struct *p)
+static void __unhash_process(struct task_struct *p, bool group_dead)
 {
 	nr_threads--;
 	detach_pid(p, PIDTYPE_PID);
-	if (thread_group_leader(p)) {
+	if (group_dead) {
 		detach_pid(p, PIDTYPE_PGID);
 		detach_pid(p, PIDTYPE_SID);
 
@@ -80,6 +80,7 @@ static void __unhash_process(struct task
 static void __exit_signal(struct task_struct *tsk)
 {
 	struct signal_struct *sig = tsk->signal;
+	bool group_dead = thread_group_leader(tsk);
 	struct sighand_struct *sighand;
 	struct tty_struct *tty;
 
@@ -93,7 +94,7 @@ static void __exit_signal(struct task_st
 	atomic_dec(&sig->count);
 
 	posix_cpu_timers_exit(tsk);
-	if (thread_group_leader(tsk)) {
+	if (group_dead) {
 		posix_cpu_timers_exit_group(tsk);
 		tty = sig->tty;
 		sig->tty = NULL;
@@ -128,10 +129,9 @@ static void __exit_signal(struct task_st
 		sig->oublock += task_io_get_oublock(tsk);
 		task_io_accounting_add(&sig->ioac, &tsk->ioac);
 		sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
-		sig = NULL; /* Marker for below. */
 	}
 
-	__unhash_process(tsk);
+	__unhash_process(tsk, group_dead);
 
 	/*
 	 * Do this under ->siglock, we can race with another thread
@@ -143,7 +143,7 @@ static void __exit_signal(struct task_st
 
 	__cleanup_sighand(sighand);
 	clear_tsk_thread_flag(tsk,TIF_SIGPENDING);
-	if (sig) {
+	if (group_dead) {
 		flush_sigqueue(&sig->shared_pending);
 		taskstats_tgid_free(sig);
 		tty_kref_put(tty);
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
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
exit-__exit_signal-use-thread_group_leader-consistently.patch
kill-the-obsolete-thread_group_cputime_free-and-taskstats_tgid_init-helpers.patch
exit-move-taskstats_tgid_free-from-__exit_signal-to-free_signal_struct.patch
check_unshare_flags-kill-the-bogus-clone_sighand-sig-count-check.patch

