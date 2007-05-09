From: akpm@linux-foundation.org
Subject: - workqueue-introduce-cpu_singlethread_map.patch removed from -mm tree
Date: Wed, 09 May 2007 14:51:49 -0700
Message-ID: <200705092151.l49LpnRD002926@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758815AbXEIVwQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     workqueue: introduce cpu_singlethread_map
has been removed from the -mm tree.  Its filename was
     workqueue-introduce-cpu_singlethread_map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: workqueue: introduce cpu_singlethread_map
From: Oleg Nesterov <oleg@tv-sign.ru>

The code like

	if (is_single_threaded(wq))
		do_something(singlethread_cpu);
	else {
		for_each_cpu_mask(cpu, cpu_populated_map)
			do_something(cpu);
	}

looks very annoying. We can add "static cpumask_t cpu_singlethread_map" and
simplify the code. Lessens .text a bit, and imho makes the code more readable.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   55 +++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 30 deletions(-)

diff -puN kernel/workqueue.c~workqueue-introduce-cpu_singlethread_map kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-introduce-cpu_singlethread_map
+++ a/kernel/workqueue.c
@@ -69,6 +69,7 @@ static DEFINE_MUTEX(workqueue_mutex);
 static LIST_HEAD(workqueues);
 
 static int singlethread_cpu __read_mostly;
+static cpumask_t cpu_singlethread_map __read_mostly;
 /* optimization, we could use cpu_possible_map */
 static cpumask_t cpu_populated_map __read_mostly;
 
@@ -78,6 +79,12 @@ static inline int is_single_threaded(str
 	return list_empty(&wq->list);
 }
 
+static const cpumask_t *wq_cpu_map(struct workqueue_struct *wq)
+{
+	return is_single_threaded(wq)
+		? &cpu_singlethread_map : &cpu_populated_map;
+}
+
 /*
  * Set the workqueue on which a work item is to be run
  * - Must *only* be called if the pending flag is set
@@ -393,16 +400,12 @@ static void flush_cpu_workqueue(struct c
  */
 void fastcall flush_workqueue(struct workqueue_struct *wq)
 {
-	might_sleep();
-
-	if (is_single_threaded(wq))
-		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, singlethread_cpu));
-	else {
-		int cpu;
+	const cpumask_t *cpu_map = wq_cpu_map(wq);
+	int cpu
 
-		for_each_cpu_mask(cpu, cpu_populated_map)
-			flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
-	}
+	might_sleep();
+	for_each_cpu_mask(cpu, *cpu_map)
+		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
@@ -439,7 +442,9 @@ static void wait_on_work(struct cpu_work
  */
 void flush_work(struct workqueue_struct *wq, struct work_struct *work)
 {
+	const cpumask_t *cpu_map = wq_cpu_map(wq);
 	struct cpu_workqueue_struct *cwq;
+	int cpu;
 
 	might_sleep();
 
@@ -457,14 +462,8 @@ void flush_work(struct workqueue_struct 
 	work_release(work);
 	spin_unlock_irq(&cwq->lock);
 
-	if (is_single_threaded(wq))
-		wait_on_work(per_cpu_ptr(wq->cpu_wq, singlethread_cpu), work);
-	else {
-		int cpu;
-
-		for_each_cpu_mask(cpu, cpu_populated_map)
-			wait_on_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
-	}
+	for_each_cpu_mask(cpu, *cpu_map)
+		wait_on_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
 }
 EXPORT_SYMBOL_GPL(flush_work);
 
@@ -757,22 +756,17 @@ static void cleanup_workqueue_thread(str
  */
 void destroy_workqueue(struct workqueue_struct *wq)
 {
+	const cpumask_t *cpu_map = wq_cpu_map(wq);
 	struct cpu_workqueue_struct *cwq;
+	int cpu;
 
-	if (is_single_threaded(wq)) {
-		cwq = per_cpu_ptr(wq->cpu_wq, singlethread_cpu);
-		cleanup_workqueue_thread(cwq, singlethread_cpu);
-	} else {
-		int cpu;
+	mutex_lock(&workqueue_mutex);
+	list_del(&wq->list);
+	mutex_unlock(&workqueue_mutex);
 
-		mutex_lock(&workqueue_mutex);
-		list_del(&wq->list);
-		mutex_unlock(&workqueue_mutex);
-
-		for_each_cpu_mask(cpu, cpu_populated_map) {
-			cwq = per_cpu_ptr(wq->cpu_wq, cpu);
-			cleanup_workqueue_thread(cwq, cpu);
-		}
+	for_each_cpu_mask(cpu, *cpu_map) {
+		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
+		cleanup_workqueue_thread(cwq, cpu);
 	}
 
 	free_percpu(wq->cpu_wq);
@@ -831,6 +825,7 @@ void init_workqueues(void)
 {
 	cpu_populated_map = cpu_online_map;
 	singlethread_cpu = first_cpu(cpu_possible_map);
+	cpu_singlethread_map = cpumask_of_cpu(singlethread_cpu);
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);
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
