From: akpm@linux-foundation.org
Subject: - workqueue-dont-save-interrupts-in-run_workqueue.patch removed from -mm tree
Date: Wed, 09 May 2007 14:51:45 -0700
Message-ID: <200705092151.l49Lpjse002918@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758609AbXEIVwH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     workqueue: don't save interrupts in run_workqueue()
has been removed from the -mm tree.  Its filename was
     workqueue-dont-save-interrupts-in-run_workqueue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: workqueue: don't save interrupts in run_workqueue()
From: Oleg Nesterov <oleg@tv-sign.ru>

work->func() may sleep, it's a bug to call run_workqueue() with irqs disabled.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN kernel/workqueue.c~workqueue-dont-save-interrupts-in-run_workqueue kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-dont-save-interrupts-in-run_workqueue
+++ a/kernel/workqueue.c
@@ -227,13 +227,7 @@ EXPORT_SYMBOL_GPL(queue_delayed_work_on)
 
 static void run_workqueue(struct cpu_workqueue_struct *cwq)
 {
-	unsigned long flags;
-
-	/*
-	 * Keep taking off work from the queue until
-	 * done.
-	 */
-	spin_lock_irqsave(&cwq->lock, flags);
+	spin_lock_irq(&cwq->lock);
 	cwq->run_depth++;
 	if (cwq->run_depth > 3) {
 		/* morton gets to eat his hat */
@@ -248,7 +242,7 @@ static void run_workqueue(struct cpu_wor
 
 		cwq->current_work = work;
 		list_del_init(cwq->worklist.next);
-		spin_unlock_irqrestore(&cwq->lock, flags);
+		spin_unlock_irq(&cwq->lock);
 
 		BUG_ON(get_wq_data(work) != cwq);
 		if (!test_bit(WORK_STRUCT_NOAUTOREL, work_data_bits(work)))
@@ -266,11 +260,11 @@ static void run_workqueue(struct cpu_wor
 			dump_stack();
 		}
 
-		spin_lock_irqsave(&cwq->lock, flags);
+		spin_lock_irq(&cwq->lock);
 		cwq->current_work = NULL;
 	}
 	cwq->run_depth--;
-	spin_unlock_irqrestore(&cwq->lock, flags);
+	spin_unlock_irq(&cwq->lock);
 }
 
 /*
@@ -399,6 +393,8 @@ static void flush_cpu_workqueue(struct c
  */
 void fastcall flush_workqueue(struct workqueue_struct *wq)
 {
+	might_sleep();
+
 	if (is_single_threaded(wq))
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, singlethread_cpu));
 	else {
@@ -445,6 +441,8 @@ void flush_work(struct workqueue_struct 
 {
 	struct cpu_workqueue_struct *cwq;
 
+	might_sleep();
+
 	cwq = get_wq_data(work);
 	/* Was it ever queued ? */
 	if (!cwq)
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
libata-core-convert-to-use-cancel_rearming_delayed_work.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
dont-init-pgrp-and-__session-in-init_signals.patch
