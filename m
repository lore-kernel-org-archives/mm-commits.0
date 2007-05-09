From: akpm@linux-foundation.org
Subject: - workqueue-fix-freezeable-workqueues-implementation.patch removed from -mm tree
Date: Wed, 09 May 2007 14:51:33 -0700
Message-ID: <200705092151.l49LpX9D002891@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758887AbXEIWKG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 18:10:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ego@in.ibm.com, vatsa@in.ibm.com, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     workqueue: fix freezeable workqueues implementation
has been removed from the -mm tree.  Its filename was
     workqueue-fix-freezeable-workqueues-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: workqueue: fix freezeable workqueues implementation
From: Oleg Nesterov <oleg@tv-sign.ru>

Currently ->freezeable is per-cpu, this is wrong. CPU_UP_PREPARE creates
cwq->thread which is not freezeable. Move ->freezeable to workqueue_struct.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Gautham shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN kernel/workqueue.c~workqueue-fix-freezeable-workqueues-implementation kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-fix-freezeable-workqueues-implementation
+++ a/kernel/workqueue.c
@@ -49,8 +49,6 @@ struct cpu_workqueue_struct {
 	struct work_struct *current_work;
 
 	int run_depth;		/* Detect run_workqueue() recursion depth */
-
-	int freezeable;		/* Freeze the thread during suspend */
 } ____cacheline_aligned;
 
 /*
@@ -61,6 +59,7 @@ struct workqueue_struct {
 	struct cpu_workqueue_struct *cpu_wq;
 	const char *name;
 	struct list_head list; 	/* Empty if single thread */
+	int freezeable;		/* Freeze threads during suspend */
 };
 
 /* All the per-cpu workqueues on the system, for hotplug cpu to add/remove
@@ -351,7 +350,7 @@ static int worker_thread(void *__cwq)
 	struct k_sigaction sa;
 	sigset_t blocked;
 
-	if (!cwq->freezeable)
+	if (!cwq->wq->freezeable)
 		current->flags |= PF_NOFREEZE;
 
 	set_user_nice(current, -5);
@@ -375,7 +374,7 @@ static int worker_thread(void *__cwq)
 
 	set_current_state(TASK_INTERRUPTIBLE);
 	while (!kthread_should_stop()) {
-		if (cwq->freezeable)
+		if (cwq->wq->freezeable)
 			try_to_freeze();
 
 		add_wait_queue(&cwq->more_work, &wait);
@@ -546,7 +545,7 @@ out:
 EXPORT_SYMBOL_GPL(flush_work);
 
 static struct task_struct *create_workqueue_thread(struct workqueue_struct *wq,
-						   int cpu, int freezeable)
+							int cpu)
 {
 	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
 	struct task_struct *p;
@@ -554,7 +553,6 @@ static struct task_struct *create_workqu
 	spin_lock_init(&cwq->lock);
 	cwq->wq = wq;
 	cwq->thread = NULL;
-	cwq->freezeable = freezeable;
 	INIT_LIST_HEAD(&cwq->worklist);
 	init_waitqueue_head(&cwq->more_work);
 
@@ -586,10 +584,12 @@ struct workqueue_struct *__create_workqu
 	}
 
 	wq->name = name;
+	wq->freezeable = freezeable;
+
 	mutex_lock(&workqueue_mutex);
 	if (singlethread) {
 		INIT_LIST_HEAD(&wq->list);
-		p = create_workqueue_thread(wq, singlethread_cpu, freezeable);
+		p = create_workqueue_thread(wq, singlethread_cpu);
 		if (!p)
 			destroy = 1;
 		else
@@ -597,7 +597,7 @@ struct workqueue_struct *__create_workqu
 	} else {
 		list_add(&wq->list, &workqueues);
 		for_each_online_cpu(cpu) {
-			p = create_workqueue_thread(wq, cpu, freezeable);
+			p = create_workqueue_thread(wq, cpu);
 			if (p) {
 				kthread_bind(p, cpu);
 				wake_up_process(p);
@@ -854,7 +854,7 @@ static int __devinit workqueue_cpu_callb
 		mutex_lock(&workqueue_mutex);
 		/* Create a new workqueue thread for it. */
 		list_for_each_entry(wq, &workqueues, list) {
-			if (!create_workqueue_thread(wq, hotcpu, 0)) {
+			if (!create_workqueue_thread(wq, hotcpu)) {
 				printk("workqueue for %i failed\n", hotcpu);
 				return NOTIFY_BAD;
 			}
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
