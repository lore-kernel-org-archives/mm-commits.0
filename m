From: akpm@linux-foundation.org
Subject: - workqueue-introduce-wq_per_cpu-helper.patch removed from -mm tree
Date: Wed, 09 May 2007 14:52:01 -0700
Message-ID: <200705092152.l49Lq1Ue002955@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754756AbXEIVwX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     workqueue: introduce wq_per_cpu() helper
has been removed from the -mm tree.  Its filename was
     workqueue-introduce-wq_per_cpu-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: workqueue: introduce wq_per_cpu() helper
From: Oleg Nesterov <oleg@tv-sign.ru>

Cleanup.  A number of per_cpu_ptr(wq->cpu_wq, cpu) users have to check that
cpu is valid for this wq.  Make a simple helper.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN kernel/workqueue.c~workqueue-introduce-wq_per_cpu-helper kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-introduce-wq_per_cpu-helper
+++ a/kernel/workqueue.c
@@ -86,6 +86,14 @@ static const cpumask_t *wq_cpu_map(struc
 		? &cpu_singlethread_map : &cpu_populated_map;
 }
 
+static
+struct cpu_workqueue_struct *wq_per_cpu(struct workqueue_struct *wq, int cpu)
+{
+	if (unlikely(is_single_threaded(wq)))
+		cpu = singlethread_cpu;
+	return per_cpu_ptr(wq->cpu_wq, cpu);
+}
+
 /*
  * Set the workqueue on which a work item is to be run
  * - Must *only* be called if the pending flag is set
@@ -142,16 +150,14 @@ static void __queue_work(struct cpu_work
  */
 int fastcall queue_work(struct workqueue_struct *wq, struct work_struct *work)
 {
-	int ret = 0, cpu = get_cpu();
+	int ret = 0;
 
 	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
-		if (unlikely(is_single_threaded(wq)))
-			cpu = singlethread_cpu;
 		BUG_ON(!list_empty(&work->entry));
-		__queue_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
+		__queue_work(wq_per_cpu(wq, get_cpu()), work);
+		put_cpu();
 		ret = 1;
 	}
-	put_cpu();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(queue_work);
@@ -161,12 +167,8 @@ void delayed_work_timer_fn(unsigned long
 	struct delayed_work *dwork = (struct delayed_work *)__data;
 	struct cpu_workqueue_struct *cwq = get_wq_data(&dwork->work);
 	struct workqueue_struct *wq = cwq->wq;
-	int cpu = smp_processor_id();
-
-	if (unlikely(is_single_threaded(wq)))
-		cpu = singlethread_cpu;
 
-	__queue_work(per_cpu_ptr(wq->cpu_wq, cpu), &dwork->work);
+	__queue_work(wq_per_cpu(wq, smp_processor_id()), &dwork->work);
 }
 
 /**
@@ -209,9 +211,7 @@ int queue_delayed_work_on(int cpu, struc
 		BUG_ON(!list_empty(&work->entry));
 
 		/* This stores cwq for the moment, for the timer_fn */
-		set_wq_data(work,
-			per_cpu_ptr(wq->cpu_wq, wq->singlethread ?
-				singlethread_cpu : raw_smp_processor_id()));
+		set_wq_data(work, wq_per_cpu(wq, raw_smp_processor_id()));
 		timer->expires = jiffies + delay;
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
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
