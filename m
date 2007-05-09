From: akpm@linux-foundation.org
Subject: - unify-queue_delayed_work-and-queue_delayed_work_on.patch removed from -mm tree
Date: Wed, 09 May 2007 14:51:59 -0700
Message-ID: <200705092151.l49LpxPA002949@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758876AbXEIVwa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     unify queue_delayed_work() and queue_delayed_work_on()
has been removed from the -mm tree.  Its filename was
     unify-queue_delayed_work-and-queue_delayed_work_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: unify queue_delayed_work() and queue_delayed_work_on()
From: Oleg Nesterov <oleg@tv-sign.ru>

Change queue_delayed_work() to use queue_delayed_work_on() to avoid the code
duplication (saves 133 bytes).

Q: queue_delayed_work() enqueues &dwork->work directly when delay == 0, why?

[jirislaby@gmail.com: oops fix]
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff -puN kernel/workqueue.c~unify-queue_delayed_work-and-queue_delayed_work_on kernel/workqueue.c
--- a/kernel/workqueue.c~unify-queue_delayed_work-and-queue_delayed_work_on
+++ a/kernel/workqueue.c
@@ -180,28 +180,11 @@ void delayed_work_timer_fn(unsigned long
 int fastcall queue_delayed_work(struct workqueue_struct *wq,
 			struct delayed_work *dwork, unsigned long delay)
 {
-	int ret = 0;
-	struct timer_list *timer = &dwork->timer;
-	struct work_struct *work = &dwork->work;
-
-	timer_stats_timer_set_start_info(timer);
+	timer_stats_timer_set_start_info(&dwork->timer);
 	if (delay == 0)
-		return queue_work(wq, work);
-
-	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
-		BUG_ON(timer_pending(timer));
-		BUG_ON(!list_empty(&work->entry));
+		return queue_work(wq, &dwork->work);
 
-		/* This stores cwq for the moment, for the timer_fn */
-		set_wq_data(work,
-			per_cpu_ptr(wq->cpu_wq, raw_smp_processor_id()));
-		timer->expires = jiffies + delay;
-		timer->data = (unsigned long)dwork;
-		timer->function = delayed_work_timer_fn;
-		add_timer(timer);
-		ret = 1;
-	}
-	return ret;
+	return queue_delayed_work_on(-1, wq, dwork, delay);
 }
 EXPORT_SYMBOL_GPL(queue_delayed_work);
 
@@ -227,11 +210,16 @@ int queue_delayed_work_on(int cpu, struc
 
 		/* This stores cwq for the moment, for the timer_fn */
 		set_wq_data(work,
-			per_cpu_ptr(wq->cpu_wq, raw_smp_processor_id()));
+			per_cpu_ptr(wq->cpu_wq, wq->singlethread ?
+				singlethread_cpu : raw_smp_processor_id()));
 		timer->expires = jiffies + delay;
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
-		add_timer_on(timer, cpu);
+
+		if (unlikely(cpu >= 0))
+			add_timer_on(timer, cpu);
+		else
+			add_timer(timer);
 		ret = 1;
 	}
 	return ret;
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
