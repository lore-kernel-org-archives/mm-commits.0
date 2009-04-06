From: akpm@linux-foundation.org
Subject: [merged] workqueue-avoid-recursion-in-run_workqueue.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:35:59 -0700
Message-ID: <200904061935.n36JZxgS012277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756751AbZDFTnP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:43:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, dada1@cosmosbay.com, fweisbec@gmail.com, mingo@elte.hu, oleg@redhat.com, peterz@infradead.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     workqueue: avoid recursion in run_workqueue()
has been removed from the -mm tree.  Its filename was
     workqueue-avoid-recursion-in-run_workqueue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: workqueue: avoid recursion in run_workqueue()
From: Lai Jiangshan <laijs@cn.fujitsu.com>

1) lockdep will complain when run_workqueue() performs recursion.

2) The recursive implementation of run_workqueue() means that
   flush_workqueue() and its documentation are inconsistent.  This may
   hide deadlocks and other bugs.

3) The recursion in run_workqueue() will poison cwq->current_work, but
   flush_work() and __cancel_work_timer(), etcetera need a reliable
   cwq->current_work.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   41 +++++++++++------------------------------
 1 file changed, 11 insertions(+), 30 deletions(-)

diff -puN kernel/workqueue.c~workqueue-avoid-recursion-in-run_workqueue kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-avoid-recursion-in-run_workqueue
+++ a/kernel/workqueue.c
@@ -48,8 +48,6 @@ struct cpu_workqueue_struct {
 
 	struct workqueue_struct *wq;
 	struct task_struct *thread;
-
-	int run_depth;		/* Detect run_workqueue() recursion depth */
 } ____cacheline_aligned;
 
 /*
@@ -262,13 +260,6 @@ EXPORT_SYMBOL_GPL(queue_delayed_work_on)
 static void run_workqueue(struct cpu_workqueue_struct *cwq)
 {
 	spin_lock_irq(&cwq->lock);
-	cwq->run_depth++;
-	if (cwq->run_depth > 3) {
-		/* morton gets to eat his hat */
-		printk("%s: recursion depth exceeded: %d\n",
-			__func__, cwq->run_depth);
-		dump_stack();
-	}
 	while (!list_empty(&cwq->worklist)) {
 		struct work_struct *work = list_entry(cwq->worklist.next,
 						struct work_struct, entry);
@@ -311,7 +302,6 @@ static void run_workqueue(struct cpu_wor
 		spin_lock_irq(&cwq->lock);
 		cwq->current_work = NULL;
 	}
-	cwq->run_depth--;
 	spin_unlock_irq(&cwq->lock);
 }
 
@@ -368,29 +358,20 @@ static void insert_wq_barrier(struct cpu
 
 static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
 {
-	int active;
+	int active = 0;
+	struct wq_barrier barr;
 
-	if (cwq->thread == current) {
-		/*
-		 * Probably keventd trying to flush its own queue. So simply run
-		 * it by hand rather than deadlocking.
-		 */
-		run_workqueue(cwq);
-		active = 1;
-	} else {
-		struct wq_barrier barr;
+	WARN_ON(cwq->thread == current);
 
-		active = 0;
-		spin_lock_irq(&cwq->lock);
-		if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
-			insert_wq_barrier(cwq, &barr, &cwq->worklist);
-			active = 1;
-		}
-		spin_unlock_irq(&cwq->lock);
