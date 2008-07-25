From: akpm@linux-foundation.org
Subject: - workqueues-insert_work-use-list_head-instead-of-int-tail.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:00:10 -0700
Message-ID: <200807252300.m6PN0A1A003563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810AbYGYXBE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:01:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, jarkao2@gmail.com, maxk@qualcomm.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     workqueues: insert_work: use "list_head *" instead of "int tail"
has been removed from the -mm tree.  Its filename was
     workqueues-insert_work-use-list_head-instead-of-int-tail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 
@@ -146,7 +143,7 @@ static void __queue_work(struct cpu_work
 	unsigned long flags;
 
 	spin_lock_irqsave(&cwq->lock, flags);
-	insert_work(cwq, work, 1);
+	insert_work(cwq, work, &cwq->worklist);
 	spin_unlock_irqrestore(&cwq->lock, flags);
 }
 
@@ -361,14 +358,14 @@ static void wq_barrier_func(struct work_
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
@@ -388,7 +385,7 @@ static int flush_cpu_workqueue(struct cp
 		active = 0;
 		spin_lock_irq(&cwq->lock);
 		if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
-			insert_wq_barrier(cwq, &barr, 1);
+			insert_wq_barrier(cwq, &barr, &cwq->worklist);
 			active = 1;
 		}
 		spin_unlock_irq(&cwq->lock);
@@ -473,7 +470,7 @@ static void wait_on_cpu_work(struct cpu_
 
 	spin_lock_irq(&cwq->lock);
 	if (unlikely(cwq->current_work == work)) {
-		insert_wq_barrier(cwq, &barr, 0);
+		insert_wq_barrier(cwq, &barr, cwq->worklist.next);
 		running = 1;
 	}
 	spin_unlock_irq(&cwq->lock);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
tracehook-add-linux-tracehookh.patch
tracehook-exec.patch
tracehook-unexport-ptrace_notify.patch
tracehook-exit.patch
tracehook-clone.patch
tracehook-vfork-done.patch
tracehook-release_task.patch
tracehook-tracehook_tracer_task.patch
tracehook-tracehook_expect_breakpoints.patch
tracehook-tracehook_signal_handler.patch
tracehook-tracehook_consider_ignored_signal.patch
tracehook-tracehook_consider_fatal_signal.patch
tracehook-syscall.patch
tracehook-get_signal_to_deliver.patch
tracehook-job-control.patch
tracehook-death.patch
tracehook-force-signal_pending.patch
tracehook-tif_notify_resume.patch
tracehook-asm-syscallh.patch
tracehook-config_have_arch_tracehook.patch
tracehook-wait_task_inactive.patch
task_current_syscall.patch
proc-pid-syscall.patch

