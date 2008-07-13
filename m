From: akpm@linux-foundation.org
Subject: + pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on-cleanup.patch added to -mm tree
Date: Sat, 12 Jul 2008 18:25:27 -0700
Message-ID: <200807130125.m6D1PRtL030559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752507AbYGMBZ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Jul 2008 21:25:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, harbour@sfinx.od.ua, pavel@ucw.cz, rjw@sisk.pl, rui.zhang@intel.com


The patch titled
     pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on-cleanup
has been added to the -mm tree.  Its filename is
     pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on-cleanup
From: Oleg Nesterov <oleg@tv-sign.ru>

The comment above __queue_work() is wrong, we don't need to disable
preemtion.

What it actually means is: the caller of __queue_work() must ensure
we can't race with CPU_DEAD, but preempt_disable() can't help for
queue_work_on(). CPU can die even before preempt_disable().

Remove preempt_disable() and update the comment.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Rus <harbour@sfinx.od.ua>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/workqueue.c~pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on-cleanup kernel/workqueue.c
--- a/kernel/workqueue.c~pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on-cleanup
+++ a/kernel/workqueue.c
@@ -140,7 +140,6 @@ static void insert_work(struct cpu_workq
 	wake_up(&cwq->more_work);
 }
 
-/* Preempt must be disabled. */
 static void __queue_work(struct cpu_workqueue_struct *cwq,
 			 struct work_struct *work)
 {
@@ -183,7 +182,8 @@ EXPORT_SYMBOL_GPL(queue_work);
  *
  * Returns 0 if @work was already on a queue, non-zero otherwise.
  *
- * We queue the work to a specific CPU
+ * We queue the work to a specific CPU, the caller must ensure it
+ * can't go away.
  */
 int
 queue_work_on(int cpu, struct workqueue_struct *wq, struct work_struct *work)
@@ -192,9 +192,7 @@ queue_work_on(int cpu, struct workqueue_
 
 	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
 		BUG_ON(!list_empty(&work->entry));
-		preempt_disable();
 		__queue_work(wq_per_cpu(wq, cpu), work);
-		preempt_enable();
 		ret = 1;
 	}
 	return ret;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on.patch
pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on-cleanup.patch
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
ptrace-simplify-ptrace_stop-sigkill_pending-path.patch
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
coredump-elf_core_dump-skip-kernel-threads.patch
coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state.patch
coredump-move-mm-core_waiters-into-struct-core_state.patch
coredump-simplify-core_state-nr_threads-calculation.patch
coredump-turn-core_state-nr_threads-into-atomic_t.patch
workqueues-insert_work-use-list_head-instead-of-int-tail.patch
workqueues-implement-flush_work.patch
workqueues-schedule_on_each_cpu-use-flush_work.patch
workqueues-make-get_online_cpus-useable-for-work-func.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
s390-topology-dont-use-kthread-for-arch_reinit_sched_domains.patch
workqueues-lockdep-annotations-for-flush_work.patch
pidns-remove-now-unused-kill_proc-function.patch
pidns-remove-now-unused-find_pid-function.patch
pidns-remove-find_task_by_pid-unused-for-a-long-time.patch
distinct-tgid-tid-i-o-statistics.patch

