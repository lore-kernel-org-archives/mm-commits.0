From: akpm@linux-foundation.org
Subject: + signals-clear-signal-tty-when-the-last-thread-exits.patch added to -mm tree
Date: Fri, 19 Mar 2010 15:18:31 -0700
Message-ID: <201003192218.o2JMIVpH015489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750986Ab0CSWSz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 18:18:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, alan@linux.intel.com, mingo@elte.hu, peterz@infradead.org, roland@redhat.com


The patch titled
     signals: clear signal->tty when the last thread exits
has been added to the -mm tree.  Its filename is
     signals-clear-signal-tty-when-the-last-thread-exits.patch

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
Subject: signals: clear signal->tty when the last thread exits
From: Oleg Nesterov <oleg@redhat.com>

When the last thread exits signal->tty is freed, but the pointer is not
cleared and points to nowhere.

This is OK.  Nobody should use signal->tty lockless, and it is no longer
possible to take ->siglock.  However this looks wrong even if correct, and
the nice OOPS is better than subtle and hard to find bugs.

Change __exit_signal() to clear signal->tty under ->siglock.

Note: __exit_signal() needs more cleanups.  It should not check "sig !=
NULL" to detect the all-dead case and we have the same issues with
signal->stats.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/exit.c~signals-clear-signal-tty-when-the-last-thread-exits kernel/exit.c
--- a/kernel/exit.c~signals-clear-signal-tty-when-the-last-thread-exits
+++ a/kernel/exit.c
@@ -81,6 +81,7 @@ static void __exit_signal(struct task_st
 {
 	struct signal_struct *sig = tsk->signal;
 	struct sighand_struct *sighand;
+	struct tty_struct *tty;
 
 	BUG_ON(!sig);
 	BUG_ON(!atomic_read(&sig->count));
@@ -94,6 +95,8 @@ static void __exit_signal(struct task_st
 	posix_cpu_timers_exit(tsk);
 	if (thread_group_leader(tsk)) {
 		posix_cpu_timers_exit_group(tsk);
+		tty = sig->tty;
+		sig->tty = NULL;
 	} else {
 		/*
 		 * If there is any task waiting for the group exit
@@ -148,7 +151,7 @@ static void __exit_signal(struct task_st
 		 * see account_group_exec_runtime().
 		 */
 		task_rq_unlock_wait(tsk);
-		tty_kref_put(sig->tty);
+		tty_kref_put(tty);
 	}
 }
 
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

