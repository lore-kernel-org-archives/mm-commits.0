From: akpm@linux-foundation.org
Subject: - make-queue_delayed_work-friendly-to-flush_fork.patch removed from -mm tree
Date: Wed, 09 May 2007 14:51:57 -0700
Message-ID: <200705092151.l49LpvK0002945@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39817 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759679AbXEIWJA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 18:09:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     make queue_delayed_work() friendly to flush_fork()
has been removed from the -mm tree.  Its filename was
     make-queue_delayed_work-friendly-to-flush_fork.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make queue_delayed_work() friendly to flush_fork()
From: Oleg Nesterov <oleg@tv-sign.ru>

Currently typeof(delayed_work->work.data) is

	"struct workqueue_struct" when the timer is pending

	"struct cpu_workqueue_struct" whe the work is queued

This makes impossible to use flush_fork(delayed_work->work) in addition
to cancel_delayed_work/cancel_rearming_delayed_work, not good.

Change queue_delayed_work/delayed_work_timer_fn to use cwq, not wq. This
complicates (and uglifies) these functions a little bit, but alows us to
use flush_fork(dwork) and imho makes the whole code more consistent.

Also, document the fact that cancel_rearming_delayed_work() doesn't garantee
the completion of work->func() upon return.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff -puN kernel/workqueue.c~make-queue_delayed_work-friendly-to-flush_fork kernel/workqueue.c
--- a/kernel/workqueue.c~make-queue_delayed_work-friendly-to-flush_fork
+++ a/kernel/workqueue.c
@@ -90,18 +90,20 @@ static const cpumask_t *wq_cpu_map(struc
  * Set the workqueue on which a work item is to be run
  * - Must *only* be called if the pending flag is set
  */
-static inline void set_wq_data(struct work_struct *work, void *wq)
+static inline void set_wq_data(struct work_struct *work,
+				struct cpu_workqueue_struct *cwq)
 {
 	unsigned long new;
 
 	BUG_ON(!work_pending(work));
 
-	new = (unsigned long) wq | (1UL << WORK_STRUCT_PENDING);
+	new = (unsigned long) cwq | (1UL << WORK_STRUCT_PENDING);
 	new |= WORK_STRUCT_FLAG_MASK & *work_data_bits(work);
 	atomic_long_set(&work->data, new);
 }
 
-static inline void *get_wq_data(struct work_struct *work)
+static inline
+struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
 {
 	return (void *) (atomic_long_read(&work->data) & WORK_STRUCT_WQ_DATA_MASK);
 }
@@ -157,7 +159,8 @@ EXPORT_SYMBOL_GPL(queue_work);
 void delayed_work_timer_fn(unsigned long __data)
 {
 	struct delayed_work *dwork = (struct delayed_work *)__data;
-	struct workqueue_struct *wq = get_wq_data(&dwork->work);
+	struct cpu_workqueue_struct *cwq = get_wq_data(&dwork->work);
+	struct workqueue_struct *wq = cwq->wq;
 	int cpu = smp_processor_id();
 
 	if (unlikely(is_single_threaded(wq)))
@@ -189,8 +192,9 @@ int fastcall queue_delayed_work(struct w
 		BUG_ON(timer_pending(timer));
 		BUG_ON(!list_empty(&work->entry));
 
-		/* This stores wq for the moment, for the timer_fn */
-		set_wq_data(work, wq);
+		/* This stores cwq for the moment, for the timer_fn */
+		set_wq_data(work,
+			per_cpu_ptr(wq->cpu_wq, raw_smp_processor_id()));
 		timer->expires = jiffies + delay;
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
@@ -221,8 +225,9 @@ int queue_delayed_work_on(int cpu, struc
 		BUG_ON(timer_pending(timer));
 		BUG_ON(!list_empty(&work->entry));
 
-		/* This stores wq for the moment, for the timer_fn */
-		set_wq_data(work, wq);
+		/* This stores cwq for the moment, for the timer_fn */
+		set_wq_data(work,
+			per_cpu_ptr(wq->cpu_wq, raw_smp_processor_id()));
 		timer->expires = jiffies + delay;
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
@@ -562,9 +567,12 @@ void flush_work_keventd(struct work_stru
 EXPORT_SYMBOL(flush_work_keventd);
 
 /**
- * cancel_rearming_delayed_workqueue - reliably kill off a delayed work whose handler rearms the delayed work.
+ * cancel_rearming_delayed_workqueue - kill off a delayed work whose handler rearms the delayed work.
  * @wq:   the controlling workqueue structure
  * @dwork: the delayed work struct
+ *
+ * Note that the work callback function may still be running on return from
+ * cancel_delayed_work(). Run flush_workqueue() or flush_work() to wait on it.
  */
 void cancel_rearming_delayed_workqueue(struct workqueue_struct *wq,
 				       struct delayed_work *dwork)
@@ -579,7 +587,7 @@ void cancel_rearming_delayed_workqueue(s
 EXPORT_SYMBOL(cancel_rearming_delayed_workqueue);
 
 /**
- * cancel_rearming_delayed_work - reliably kill off a delayed keventd work whose handler rearms the delayed work.
+ * cancel_rearming_delayed_work - kill off a delayed keventd work whose handler rearms the delayed work.
  * @dwork: the delayed work struct
  */
 void cancel_rearming_delayed_work(struct delayed_work *dwork)
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
