From: akpm@linux-foundation.org
Subject: + signals-kill-the-awful-task_rq_unlock_wait-hack.patch added to -mm tree
Date: Fri, 19 Mar 2010 15:18:33 -0700
Message-ID: <201003192218.o2JMIY14015493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751315Ab0CSWTC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 18:19:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, alan@linux.intel.com, mingo@elte.hu, peterz@infradead.org, roland@redhat.com


The patch titled
     signals: kill the awful task_rq_unlock_wait() hack
has been added to the -mm tree.  Its filename is
     signals-kill-the-awful-task_rq_unlock_wait-hack.patch

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
Subject: signals: kill the awful task_rq_unlock_wait() hack
From: Oleg Nesterov <oleg@redhat.com>

Now that task->signal can't go away we can revert the horrible hack added
by ad474caca3e2a0550b7ce0706527ad5ab389a4d4 ("fix for
account_group_exec_runtime(), make sure ->signal can't be freed under
rq->lock").

And we can do more cleanups sched_stats.h/posix-cpu-timers.c later.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 -
 kernel/exit.c         |    5 -----
 kernel/sched.c        |    8 --------
 3 files changed, 14 deletions(-)

diff -puN include/linux/sched.h~signals-kill-the-awful-task_rq_unlock_wait-hack include/linux/sched.h
--- a/include/linux/sched.h~signals-kill-the-awful-task_rq_unlock_wait-hack
+++ a/include/linux/sched.h
@@ -269,7 +269,6 @@ extern void init_idle(struct task_struct
 extern void init_idle_bootup_task(struct task_struct *idle);
 
 extern int runqueue_is_locked(int cpu);
-extern void task_rq_unlock_wait(struct task_struct *p);
 
 extern cpumask_var_t nohz_cpu_mask;
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
diff -puN kernel/exit.c~signals-kill-the-awful-task_rq_unlock_wait-hack kernel/exit.c
--- a/kernel/exit.c~signals-kill-the-awful-task_rq_unlock_wait-hack
+++ a/kernel/exit.c
@@ -146,11 +146,6 @@ static void __exit_signal(struct task_st
 	if (sig) {
 		flush_sigqueue(&sig->shared_pending);
 		taskstats_tgid_free(sig);
-		/*
-		 * Make sure ->signal can't go away under rq->lock,
-		 * see account_group_exec_runtime().
-		 */
-		task_rq_unlock_wait(tsk);
 		tty_kref_put(tty);
 	}
 }
diff -puN kernel/sched.c~signals-kill-the-awful-task_rq_unlock_wait-hack kernel/sched.c
--- a/kernel/sched.c~signals-kill-the-awful-task_rq_unlock_wait-hack
+++ a/kernel/sched.c
@@ -957,14 +957,6 @@ static struct rq *task_rq_lock(struct ta
 	}
 }
 
-void task_rq_unlock_wait(struct task_struct *p)
-{
-	struct rq *rq = task_rq(p);
-
-	smp_mb(); /* spin-unlock-wait is not a full memory barrier */
-	raw_spin_unlock_wait(&rq->lock);
-}
-
 static void __task_rq_unlock(struct rq *rq)
 	__releases(rq->lock)
 {
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

