From: akpm@linux-foundation.org
Subject: - ptrace-never-sleep-in-task_traced-if-sigkilled.patch removed from -mm tree
Date: Sun, 06 Jul 2008 12:22:14 -0700
Message-ID: <200807061922.m66JMEuE021137@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752401AbYGFTWz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 15:22:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, matthew@wil.cx, mingo@elte.hu, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: never sleep in TASK_TRACED if SIGKILL'ed
has been removed from the -mm tree.  Its filename was
     ptrace-never-sleep-in-task_traced-if-sigkilled.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: never sleep in TASK_TRACED if SIGKILL'ed
From: Oleg Nesterov <oleg@tv-sign.ru>

Change ptrace_stop() to check if the task was killed unconditionally and
simplify the "if (killed)" case - we can just return. Note that SIGKILL
can be already dequeued if ptrace_stop() is called from do_exit(), that
is why we use signal_group_exit().

The current behaviour is somewhat unpredictable. If we enter ptrace_stop()
with the pending SIGKILL the result depends on arch_ptrace_stop_needed()
and if it is true it also depends on was this signal private or group-wide
if the caller is do_exit().

With this patch we never sleep in TASK_TRACED with the pending SIGKILL.
This looks very logical, because only SIGKILL can wake up TASK_TRACED
task, and the second SIGKILL (in general) has no effect.

Note: If the tracee was killed because another thread execs, we are not going
to sleep anyway. If this is not desirable, we can check SIGNAL_GROUP_EXIT
instead. But again, the current behaviour is not very predictable.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff -puN kernel/signal.c~ptrace-never-sleep-in-task_traced-if-sigkilled kernel/signal.c
--- a/kernel/signal.c~ptrace-never-sleep-in-task_traced-if-sigkilled
+++ a/kernel/signal.c
@@ -1491,17 +1491,6 @@ static inline int may_ptrace_stop(void)
 }
 
 /*
- * Return nonzero if there is a SIGKILL that should be waking us up.
- * Called with the siglock held.
- */
-static int sigkill_pending(struct task_struct *tsk)
-{
-	return ((sigismember(&tsk->pending.signal, SIGKILL) ||
-		 sigismember(&tsk->signal->shared_pending.signal, SIGKILL)) &&
-		!unlikely(sigismember(&tsk->blocked, SIGKILL)));
-}
-
-/*
  * This must be called with current->sighand->siglock held.
  *
  * This should be the path for all ptrace stops.
@@ -1514,8 +1503,6 @@ static int sigkill_pending(struct task_s
  */
 static void ptrace_stop(int exit_code, int clear_code, siginfo_t *info)
 {
-	int killed = 0;
-
 	if (arch_ptrace_stop_needed(exit_code, info)) {
 		/*
 		 * The arch code has something special to do before a
@@ -1524,16 +1511,15 @@ static void ptrace_stop(int exit_code, i
 		 * calling arch_ptrace_stop, so we must release it now.
 		 * To preserve proper semantics, we must do this before
 		 * any signal bookkeeping like checking group_stop_count.
-		 * Meanwhile, a SIGKILL could come in before we retake the
-		 * siglock.  That must prevent us from sleeping in TASK_TRACED.
-		 * So after regaining the lock, we must check for SIGKILL.
 		 */
 		spin_unlock_irq(&current->sighand->siglock);
 		arch_ptrace_stop(exit_code, info);
 		spin_lock_irq(&current->sighand->siglock);
-		killed = sigkill_pending(current);
 	}
 
+	if (unlikely(signal_group_exit(current->signal)))
+		return;
+
 	/*
 	 * If there is a group stop in progress,
 	 * we must participate in the bookkeeping.
@@ -1548,7 +1534,7 @@ static void ptrace_stop(int exit_code, i
 	__set_current_state(TASK_TRACED);
 	spin_unlock_irq(&current->sighand->siglock);
 	read_lock(&tasklist_lock);
-	if (!unlikely(killed) && may_ptrace_stop()) {
+	if (may_ptrace_stop()) {
 		do_notify_parent_cldstop(current, CLD_TRAPPED);
 		read_unlock(&tasklist_lock);
 		schedule();
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

get_user_pages-fix-possible-page-leak-on-oom.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-collect_signal-remove-the-unneeded-sigismember-check.patch
signals-collect_signal-simplify-the-still_pending-logic.patch
signals-change-collect_signal-to-return-void.patch
__exit_signal-dont-take-rcu-lock.patch
signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued.patch
signals-do_signal_stop-kill-the-signal_unkillable-check.patch
coredump-zap_threads-comments-use-while_each_thread.patch
signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz.patch
kernel-signalc-change-vars-pid-and-tgid-types-to-pid_t.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
ptrace-give-more-respect-to-sigkill.patch
ptrace-never-sleep-in-task_traced-if-sigkilled.patch
ptrace-kill-may_ptrace_stop.patch
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
coredump-elf_core_dump-skip-kernel-threads.patch
workqueues-insert_work-use-list_head-instead-of-int-tail.patch
workqueues-implement-flush_work.patch
workqueues-schedule_on_each_cpu-use-flush_work.patch
workqueues-make-get_online_cpus-useable-for-work-func.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
s390-topology-dont-use-kthread-for-arch_reinit_sched_domains.patch
pidns-remove-now-unused-kill_proc-function.patch
pidns-remove-now-unused-find_pid-function.patch
pidns-remove-find_task_by_pid-unused-for-a-long-time.patch
distinct-tgid-tid-i-o-statistics.patch

