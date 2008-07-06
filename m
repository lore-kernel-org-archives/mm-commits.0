From: akpm@linux-foundation.org
Subject: - ptrace-kill-may_ptrace_stop.patch removed from -mm tree
Date: Sun, 06 Jul 2008 12:22:17 -0700
Message-ID: <200807061922.m66JMHg8021140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753567AbYGFTWq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 15:22:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, matthew@wil.cx, mingo@elte.hu, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: kill may_ptrace_stop()
has been removed from the -mm tree.  Its filename was
     ptrace-kill-may_ptrace_stop.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: kill may_ptrace_stop()
From: Oleg Nesterov <oleg@tv-sign.ru>

Now that ptrace_stop() can't sleep if the tracee was SIGKILL'ed, we don't
need the special mm->core_waiters check in may_ptrace_stop(). It was needed
to prevent the deadlock with the tracer with the same ->mm which waits for
us in coredump_wait()->wait_for_completion(&startup_done), and the the
unkillable tracee waits for PTRACE_CONT from the tracer.

Without this check may_ptrace_stop() becomes trivial and can be removed.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff -puN kernel/signal.c~ptrace-kill-may_ptrace_stop kernel/signal.c
--- a/kernel/signal.c~ptrace-kill-may_ptrace_stop
+++ a/kernel/signal.c
@@ -1470,26 +1470,6 @@ static void do_notify_parent_cldstop(str
 	spin_unlock_irqrestore(&sighand->siglock, flags);
 }
 
-static inline int may_ptrace_stop(void)
-{
-	if (!likely(current->ptrace & PT_PTRACED))
-		return 0;
-	/*
-	 * Are we in the middle of do_coredump?
-	 * If so and our tracer is also part of the coredump stopping
-	 * is a deadlock situation, and pointless because our tracer
-	 * is dead so don't allow us to stop.
-	 * If SIGKILL was already sent before the caller unlocked
-	 * ->siglock we must see ->core_waiters != 0. Otherwise it
-	 * is safe to enter schedule().
-	 */
-	if (unlikely(current->mm->core_waiters) &&
-	    unlikely(current->mm == current->parent->mm))
-		return 0;
-
-	return 1;
-}
-
 /*
  * This must be called with current->sighand->siglock held.
  *
@@ -1534,7 +1514,7 @@ static void ptrace_stop(int exit_code, i
 	__set_current_state(TASK_TRACED);
 	spin_unlock_irq(&current->sighand->siglock);
 	read_lock(&tasklist_lock);
-	if (may_ptrace_stop()) {
+	if (likely(current->ptrace & PT_PTRACED)) {
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

