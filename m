From: akpm@linux-foundation.org
Subject: - workqueue-kill-run_scheduled_work.patch removed from -mm tree
Date: Wed, 09 May 2007 14:51:43 -0700
Message-ID: <200705092151.l49LphM1002911@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758819AbXEIVwQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     workqueue: kill run_scheduled_work()
has been removed from the -mm tree.  Its filename was
     workqueue-kill-run_scheduled_work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: workqueue: kill run_scheduled_work()
From: Oleg Nesterov <oleg@tv-sign.ru>

Because it has no callers.

Actually, I think the whole idea of run_scheduled_work() was not right, not
good to mix "unqueue this work and execute its ->func()" in one function.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/workqueue.h |    1 
 kernel/workqueue.c        |   73 ------------------------------------
 2 files changed, 74 deletions(-)

diff -puN include/linux/workqueue.h~workqueue-kill-run_scheduled_work include/linux/workqueue.h
--- a/include/linux/workqueue.h~workqueue-kill-run_scheduled_work
+++ a/include/linux/workqueue.h
@@ -182,7 +182,6 @@ extern void flush_work(struct workqueue_
 extern void flush_work_keventd(struct work_struct *work);
 
 extern int FASTCALL(schedule_work(struct work_struct *work));
-extern int FASTCALL(run_scheduled_work(struct work_struct *work));
 extern int FASTCALL(schedule_delayed_work(struct delayed_work *work, unsigned long delay));
 
 extern int schedule_delayed_work_on(int cpu, struct delayed_work *work, unsigned long delay);
diff -puN kernel/workqueue.c~workqueue-kill-run_scheduled_work kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-kill-run_scheduled_work
+++ a/kernel/workqueue.c
@@ -98,79 +98,6 @@ static inline void *get_wq_data(struct w
 	return (void *) (atomic_long_read(&work->data) & WORK_STRUCT_WQ_DATA_MASK);
 }
 
-static int __run_work(struct cpu_workqueue_struct *cwq, struct work_struct *work)
-{
-	int ret = 0;
-	unsigned long flags;
-
-	spin_lock_irqsave(&cwq->lock, flags);
-	/*
-	 * We need to re-validate the work info after we've gotten
-	 * the cpu_workqueue lock. We can run the work now iff:
-	 *
-	 *  - the wq_data still matches the cpu_workqueue_struct
-	 *  - AND the work is still marked pending
-	 *  - AND the work is still on a list (which will be this
-	 *    workqueue_struct list)
-	 *
-	 * All these conditions are important, because we
-	 * need to protect against the work being run right
-	 * now on another CPU (all but the last one might be
-	 * true if it's currently running and has not been
-	 * released yet, for example).
-	 */
-	if (get_wq_data(work) == cwq
-	    && work_pending(work)
-	    && !list_empty(&work->entry)) {
-		work_func_t f = work->func;
-		cwq->current_work = work;
-		list_del_init(&work->entry);
-		spin_unlock_irqrestore(&cwq->lock, flags);
-
-		if (!test_bit(WORK_STRUCT_NOAUTOREL, work_data_bits(work)))
-			work_release(work);
-		f(work);
-
-		spin_lock_irqsave(&cwq->lock, flags);
-		cwq->current_work = NULL;
-		ret = 1;
-	}
-	spin_unlock_irqrestore(&cwq->lock, flags);
-	return ret;
-}
-
-/**
- * run_scheduled_work - run scheduled work synchronously
- * @work: work to run
- *
- * This checks if the work was pending, and runs it
- * synchronously if so. It returns a boolean to indicate
- * whether it had any scheduled work to run or not.
- *
- * NOTE! This _only_ works for normal work_structs. You
- * CANNOT use this for delayed work, because the wq data
- * for delayed work will not point properly to the per-
- * CPU workqueue struct, but will change!
- */
-int fastcall run_scheduled_work(struct work_struct *work)
-{
-	for (;;) {
-		struct cpu_workqueue_struct *cwq;
-
-		if (!work_pending(work))
-			return 0;
-		if (list_empty(&work->entry))
-			return 0;
-		/* NOTE! This depends intimately on __queue_work! */
-		cwq = get_wq_data(work);
-		if (!cwq)
-			return 0;
-		if (__run_work(cwq, work))
-			return 1;
-	}
-}
-EXPORT_SYMBOL(run_scheduled_work);
-
 static void insert_work(struct cpu_workqueue_struct *cwq,
 				struct work_struct *work, int tail)
 {
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
