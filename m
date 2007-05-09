From: akpm@linux-foundation.org
Subject: - workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch removed from -mm tree
Date: Wed, 09 May 2007 14:51:35 -0700
Message-ID: <200705092151.l49LpZVI002896@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758673AbXEIVwG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ego@in.ibm.com, vatsa@in.ibm.com, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     workqueue: fix flush_workqueue() vs CPU_DEAD race
has been removed from the -mm tree.  Its filename was
     workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: workqueue: fix flush_workqueue() vs CPU_DEAD race
From: Oleg Nesterov <oleg@tv-sign.ru>

Many thanks to Srivatsa Vaddagiri for the helpful discussion and for spotting
the bug in my previous attempt.

work->func() (and thus flush_workqueue()) must not use workqueue_mutex,
this leads to deadlock when CPU_DEAD does kthread_stop(). However without
this mutex held we can't detect CPU_DEAD in progress, which can move pending
works to another CPU while the dead one is not on cpu_online_map.

Change flush_workqueue() to use for_each_possible_cpu(). This means that
flush_cpu_workqueue() may hit CPU which is already dead. However in that
case

	!list_empty(&cwq->worklist) || cwq->current_work != NULL

means that CPU_DEAD in progress, it will do kthread_stop() + take_over_work()
so we can proceed and insert a barrier. We hold cwq->lock, so we are safe.

Also, add migrate_sequence incremented by take_over_work() under cwq->lock.
If take_over_work() happened before we checked this CPU, we should see the
new value after spin_unlock().

Further possible changes:

	remove CPU_DEAD handling (along with take_over_work, migrate_sequence)
	from workqueue.c. CPU_DEAD just sets cwq->please_exit_after_flush flag.

	CPU_UP_PREPARE->create_workqueue_thread() clears this flag, and creates
	the new thread if cwq->thread == NULL.

This way the workqueue/cpu-hotplug interaction is almost zero, workqueue_mutex
just protects "workqueues" list, CPU_LOCK_ACQUIRE/CPU_LOCK_RELEASE go away.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Gautham shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   44 ++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff -puN kernel/workqueue.c~workqueue-fix-flush_workqueue-vs-cpu_dead-race kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-fix-flush_workqueue-vs-cpu_dead-race
+++ a/kernel/workqueue.c
@@ -64,6 +64,7 @@ struct workqueue_struct {
 
 /* All the per-cpu workqueues on the system, for hotplug cpu to add/remove
    threads to each one as cpus come/go. */
+static long migrate_sequence __read_mostly;
 static DEFINE_MUTEX(workqueue_mutex);
 static LIST_HEAD(workqueues);
 
@@ -421,13 +422,7 @@ static void flush_cpu_workqueue(struct c
 		 * Probably keventd trying to flush its own queue. So simply run
 		 * it by hand rather than deadlocking.
 		 */
-		preempt_enable();
-		/*
-		 * We can still touch *cwq here because we are keventd, and
-		 * hot-unplug will be waiting us to exit.
-		 */
 		run_workqueue(cwq);
-		preempt_disable();
 	} else {
 		struct wq_barrier barr;
 		int active = 0;
@@ -439,11 +434,8 @@ static void flush_cpu_workqueue(struct c
 		}
 		spin_unlock_irq(&cwq->lock);
 
-		if (active) {
-			preempt_enable();
+		if (active)
 			wait_for_completion(&barr.done);
-			preempt_disable();
-		}
 	}
 }
 
@@ -462,17 +454,21 @@ static void flush_cpu_workqueue(struct c
  */
 void fastcall flush_workqueue(struct workqueue_struct *wq)
 {
-	preempt_disable();		/* CPU hotplug */
 	if (is_single_threaded(wq)) {
 		/* Always use first cpu's area. */
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, singlethread_cpu));
 	} else {
+		long sequence;
 		int cpu;
+again:
+		sequence = migrate_sequence;
 
-		for_each_online_cpu(cpu)
+		for_each_possible_cpu(cpu)
 			flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
+
+		if (unlikely(sequence != migrate_sequence))
+			goto again;
 	}
-	preempt_enable();
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
@@ -544,17 +540,21 @@ out:
 }
 EXPORT_SYMBOL_GPL(flush_work);
 
-static struct task_struct *create_workqueue_thread(struct workqueue_struct *wq,
-							int cpu)
+static void init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
 {
 	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
-	struct task_struct *p;
 
-	spin_lock_init(&cwq->lock);
 	cwq->wq = wq;
-	cwq->thread = NULL;
+	spin_lock_init(&cwq->lock);
 	INIT_LIST_HEAD(&cwq->worklist);
 	init_waitqueue_head(&cwq->more_work);
+}
+
+static struct task_struct *create_workqueue_thread(struct workqueue_struct *wq,
+							int cpu)
+{
+	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
+	struct task_struct *p;
 
 	if (is_single_threaded(wq))
 		p = kthread_create(worker_thread, cwq, "%s", wq->name);
@@ -589,6 +589,7 @@ struct workqueue_struct *__create_workqu
 	mutex_lock(&workqueue_mutex);
 	if (singlethread) {
 		INIT_LIST_HEAD(&wq->list);
+		init_cpu_workqueue(wq, singlethread_cpu);
 		p = create_workqueue_thread(wq, singlethread_cpu);
 		if (!p)
 			destroy = 1;
@@ -596,7 +597,11 @@ struct workqueue_struct *__create_workqu
 			wake_up_process(p);
 	} else {
 		list_add(&wq->list, &workqueues);
-		for_each_online_cpu(cpu) {
+		for_each_possible_cpu(cpu) {
+			init_cpu_workqueue(wq, cpu);
+			if (!cpu_online(cpu))
+				continue;
+
 			p = create_workqueue_thread(wq, cpu);
 			if (p) {
 				kthread_bind(p, cpu);
@@ -831,6 +836,7 @@ static void take_over_work(struct workqu
 
 	spin_lock_irq(&cwq->lock);
 	list_replace_init(&cwq->worklist, &list);
+	migrate_sequence++;
 
 	while (!list_empty(&list)) {
 		printk("Taking work for %s\n", wq->name);
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
