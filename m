From: akpm@linux-foundation.org
Subject: + workqueues-insert_work-use-list_head-instead-of-int-tail.patch added to -mm tree
Date: Mon, 30 Jun 2008 16:42:51 -0700
Message-ID: <200806302342.m5UNgpq6031525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753259AbYF3XnN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 19:43:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, jarkao2@gmail.com, maxk@qualcomm.com, peterz@infradead.org


The patch titled
     workqueues: insert_work: use "list_head *" instead of "int tail"
has been added to the -mm tree.  Its filename is
     workqueues-insert_work-use-list_head-instead-of-int-tail.patch

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
Subject: workqueues: insert_work: use "list_head *" instead of "int tail"
From: Oleg Nesterov <oleg@tv-sign.ru>

insert_work() inserts the new work_struct before or after cwq->worklist,
depending on the "int tail" parameter. Change it to accept "list_head *"
instead, this shrinks .text a bit and allows us to insert the barrier
after specific work_struct.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Jarek Poplawski <jarkao2@gmail.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN kernel/workqueue.c~workqueues-insert_work-use-list_head-instead-of-int-tail kernel/workqueue.c
--- a/kernel/workqueue.c~workqueues-insert_work-use-list_head-instead-of-int-tail
+++ a/kernel/workqueue.c
@@ -125,7 +125,7 @@ struct cpu_workqueue_struct *get_wq_data
 }
 
 static void insert_work(struct cpu_workqueue_struct *cwq,
-				struct work_struct *work, int tail)
+			struct work_struct *work, struct list_head *head)
 {
 	set_wq_data(work, cwq);
 	/*
@@ -133,10 +133,7 @@ static void insert_work(struct cpu_workq
 	 * result of list_add() below, see try_to_grab_pending().
 	 */
 	smp_wmb();
-	if (tail)
-		list_add_tail(&work->entry, &cwq->worklist);
-	else
-		list_add(&work->entry, &cwq->worklist);
+	list_add_tail(&work->entry, head);
 	wake_up(&cwq->more_work);
 }
 
@@ -147,7 +144,7 @@ static void __queue_work(struct cpu_work
 	unsigned long flags;
 
 	spin_lock_irqsave(&cwq->lock, flags);
-	insert_work(cwq, work, 1);
+	insert_work(cwq, work, &cwq->worklist);
 	spin_unlock_irqrestore(&cwq->lock, flags);
 }
 
@@ -337,14 +334,14 @@ static void wq_barrier_func(struct work_
 }
 
 static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
-					struct wq_barrier *barr, int tail)
+			struct wq_barrier *barr, struct list_head *head)
 {
 	INIT_WORK(&barr->work, wq_barrier_func);
 	__set_bit(WORK_STRUCT_PENDING, work_data_bits(&barr->work));
 
 	init_completion(&barr->done);
 
-	insert_work(cwq, &barr->work, tail);
+	insert_work(cwq, &barr->work, head);
 }
 
 static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
@@ -364,7 +361,7 @@ static int flush_cpu_workqueue(struct cp
 		active = 0;
 		spin_lock_irq(&cwq->lock);
 		if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
-			insert_wq_barrier(cwq, &barr, 1);
+			insert_wq_barrier(cwq, &barr, &cwq->worklist);
 			active = 1;
 		}
 		spin_unlock_irq(&cwq->lock);
@@ -449,7 +446,7 @@ static void wait_on_cpu_work(struct cpu_
 
 	spin_lock_irq(&cwq->lock);
 	if (unlikely(cwq->current_work == work)) {
-		insert_wq_barrier(cwq, &barr, 0);
+		insert_wq_barrier(cwq, &barr, cwq->worklist.next);
 		running = 1;
 	}
 	spin_unlock_irq(&cwq->lock);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

get_user_pages-fix-possible-page-leak-on-oom.patch
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
pidns-remove-now-unused-kill_proc-function.patch
pidns-remove-now-unused-find_pid-function.patch
pidns-remove-find_task_by_pid-unused-for-a-long-time.patch
distinct-tgid-tid-i-o-statistics.patch

