From: akpm@linux-foundation.org
Subject: - workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch removed from -mm tree
Date: Wed, 09 May 2007 14:51:40 -0700
Message-ID: <200705092151.l49Lpe8r002908@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758815AbXEIVwH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ego@in.ibm.com, vatsa@in.ibm.com, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     workqueue: don't migrate pending works from the dead CPU
has been removed from the -mm tree.  Its filename was
     workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: workqueue: don't migrate pending works from the dead CPU
From: Oleg Nesterov <oleg@tv-sign.ru>

Currently CPU_DEAD uses kthread_stop() to stop cwq->thread and then
transfers cwq->worklist to another CPU.  However, it is very unlikely that
worker_thread() will notice kthread_should_stop() before flushing
cwq->worklist.  It is only possible if worker_thread() was preempted after
run_workqueue(cwq), a new work_struct was added, and CPU_DEAD happened
before cwq->thread has a chance to run.

This means that take_over_work() mostly adds unneeded complications.  Note
also that kthread_stop() is not good per se, wake_up_process() may confuse
work->func() if it sleeps waiting for some event.

Remove take_over_work() and migrate_sequence complications.  CPU_DEAD sets
the cwq->should_stop flag (introduced by this patch) and waits for
cwq->thread to flush cwq->worklist and exit.  Because the dead CPU is not
on cpu_online_map, no more works can be added to that cwq.

cpu_populated_map was introduced to optimize for_each_possible_cpu(), it is
not strictly needed, and it is more a documentation in fact.

Saves 418 bytes.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Gautham shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |  430 +++++++++++++++++++++----------------------
 1 file changed, 211 insertions(+), 219 deletions(-)

diff -puN kernel/workqueue.c~workqueue-dont-migrate-pending-works-from-the-dead-cpu kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-dont-migrate-pending-works-from-the-dead-cpu
+++ a/kernel/workqueue.c
@@ -43,10 +43,11 @@ struct cpu_workqueue_struct {
 
 	struct list_head worklist;
 	wait_queue_head_t more_work;
+	struct work_struct *current_work;
 
 	struct workqueue_struct *wq;
 	struct task_struct *thread;
-	struct work_struct *current_work;
+	int should_stop;
 
 	int run_depth;		/* Detect run_workqueue() recursion depth */
 } ____cacheline_aligned;
@@ -64,11 +65,12 @@ struct workqueue_struct {
 
 /* All the per-cpu workqueues on the system, for hotplug cpu to add/remove
    threads to each one as cpus come/go. */
-static long migrate_sequence __read_mostly;
 static DEFINE_MUTEX(workqueue_mutex);
 static LIST_HEAD(workqueues);
 
-static int singlethread_cpu;
+static int singlethread_cpu __read_mostly;
+/* optimization, we could use cpu_possible_map */
+static cpumask_t cpu_populated_map __read_mostly;
 
 /* If it's single threaded, it isn't in the list of workqueues. */
 static inline int is_single_threaded(struct workqueue_struct *wq)
@@ -344,10 +346,28 @@ static void run_workqueue(struct cpu_wor
 	spin_unlock_irqrestore(&cwq->lock, flags);
 }
 
+/*
+ * NOTE: the caller must not touch *cwq if this func returns true
+ */
+static int cwq_should_stop(struct cpu_workqueue_struct *cwq)
+{
+	int should_stop = cwq->should_stop;
+
+	if (unlikely(should_stop)) {
+		spin_lock_irq(&cwq->lock);
+		should_stop = cwq->should_stop && list_empty(&cwq->worklist);
+		if (should_stop)
+			cwq->thread = NULL;
+		spin_unlock_irq(&cwq->lock);
+	}
+
+	return should_stop;
+}
+
 static int worker_thread(void *__cwq)
 {
 	struct cpu_workqueue_struct *cwq = __cwq;
-	DECLARE_WAITQUEUE(wait, current);
+	DEFINE_WAIT(wait);
 	struct k_sigaction sa;
 	sigset_t blocked;
 
@@ -373,23 +393,21 @@ static int worker_thread(void *__cwq)
 	siginitset(&sa.sa.sa_mask, sigmask(SIGCHLD));
 	do_sigaction(SIGCHLD, &sa, (struct k_sigaction *)0);
 
-	set_current_state(TASK_INTERRUPTIBLE);
-	while (!kthread_should_stop()) {
+	for (;;) {
 		if (cwq->wq->freezeable)
 			try_to_freeze();
 
-		add_wait_queue(&cwq->more_work, &wait);
-		if (list_empty(&cwq->worklist))
+		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
+		if (!cwq->should_stop && list_empty(&cwq->worklist))
 			schedule();
-		else
-			__set_current_state(TASK_RUNNING);
-		remove_wait_queue(&cwq->more_work, &wait);
-
-		if (!list_empty(&cwq->worklist))
-			run_workqueue(cwq);
-		set_current_state(TASK_INTERRUPTIBLE);
+		finish_wait(&cwq->more_work, &wait);
+
+		if (cwq_should_stop(cwq))
+			break;
+
+		run_workqueue(cwq);
 	}
-	__set_current_state(TASK_RUNNING);
+
 	return 0;
 }
 
@@ -454,20 +472,13 @@ static void flush_cpu_workqueue(struct c
  */
 void fastcall flush_workqueue(struct workqueue_struct *wq)
 {
-	if (is_single_threaded(wq)) {
-		/* Always use first cpu's area. */
+	if (is_single_threaded(wq))
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, singlethread_cpu));
-	} else {
-		long sequence;
+	else {
 		int cpu;
-again:
-		sequence = migrate_sequence;
 
-		for_each_possible_cpu(cpu)
+		for_each_cpu_mask(cpu, cpu_populated_map)
 			flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
-
-		if (unlikely(sequence != migrate_sequence))
-			goto again;
 	}
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
@@ -485,11 +496,8 @@ static void wait_on_work(struct cpu_work
 	}
 	spin_unlock_irq(&cwq->lock);
 
-	if (unlikely(running)) {
-		mutex_unlock(&workqueue_mutex);
+	if (unlikely(running))
 		wait_for_completion(&barr.done);
-		mutex_lock(&workqueue_mutex);
-	}
 }
 
 /**
@@ -510,155 +518,31 @@ void flush_work(struct workqueue_struct 
 {
 	struct cpu_workqueue_struct *cwq;
 
-	mutex_lock(&workqueue_mutex);
 	cwq = get_wq_data(work);
 	/* Was it ever queued ? */
 	if (!cwq)
-		goto out;
+		return;
 
 	/*
-	 * This work can't be re-queued, and the lock above protects us
-	 * from take_over_work(), no need to re-check that get_wq_data()
-	 * is still the same when we take cwq->lock.
+	 * This work can't be re-queued, no need to re-check that
+	 * get_wq_data() is still the same when we take cwq->lock.
 	 */
 	spin_lock_irq(&cwq->lock);
 	list_del_init(&work->entry);
 	work_release(work);
 	spin_unlock_irq(&cwq->lock);
 
-	if (is_single_threaded(wq)) {
-		/* Always use first cpu's area. */
+	if (is_single_threaded(wq))
 		wait_on_work(per_cpu_ptr(wq->cpu_wq, singlethread_cpu), work);
-	} else {
+	else {
 		int cpu;
 
-		for_each_online_cpu(cpu)
+		for_each_cpu_mask(cpu, cpu_populated_map)
 			wait_on_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
 	}
-out:
-	mutex_unlock(&workqueue_mutex);
 }
 EXPORT_SYMBOL_GPL(flush_work);
 
-static void init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
-{
-	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
-
-	cwq->wq = wq;
-	spin_lock_init(&cwq->lock);
-	INIT_LIST_HEAD(&cwq->worklist);
-	init_waitqueue_head(&cwq->more_work);
-}
-
-static struct task_struct *create_workqueue_thread(struct workqueue_struct *wq,
-							int cpu)
-{
-	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
-	struct task_struct *p;
-
-	if (is_single_threaded(wq))
-		p = kthread_create(worker_thread, cwq, "%s", wq->name);
-	else
-		p = kthread_create(worker_thread, cwq, "%s/%d", wq->name, cpu);
-	if (IS_ERR(p))
-		return NULL;
-	cwq->thread = p;
-	return p;
-}
-
-struct workqueue_struct *__create_workqueue(const char *name,
-					    int singlethread, int freezeable)
-{
-	int cpu, destroy = 0;
-	struct workqueue_struct *wq;
-	struct task_struct *p;
-
-	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
-	if (!wq)
-		return NULL;
-
-	wq->cpu_wq = alloc_percpu(struct cpu_workqueue_struct);
-	if (!wq->cpu_wq) {
-		kfree(wq);
-		return NULL;
-	}
-
-	wq->name = name;
-	wq->freezeable = freezeable;
-
-	mutex_lock(&workqueue_mutex);
-	if (singlethread) {
-		INIT_LIST_HEAD(&wq->list);
-		init_cpu_workqueue(wq, singlethread_cpu);
-		p = create_workqueue_thread(wq, singlethread_cpu);
-		if (!p)
-			destroy = 1;
-		else
-			wake_up_process(p);
-	} else {
-		list_add(&wq->list, &workqueues);
-		for_each_possible_cpu(cpu) {
-			init_cpu_workqueue(wq, cpu);
-			if (!cpu_online(cpu))
-				continue;
-
-			p = create_workqueue_thread(wq, cpu);
-			if (p) {
-				kthread_bind(p, cpu);
-				wake_up_process(p);
-			} else
-				destroy = 1;
-		}
-	}
-	mutex_unlock(&workqueue_mutex);
-
-	/*
-	 * Was there any error during startup? If yes then clean up:
-	 */
-	if (destroy) {
-		destroy_workqueue(wq);
-		wq = NULL;
-	}
-	return wq;
-}
-EXPORT_SYMBOL_GPL(__create_workqueue);
-
-static void cleanup_workqueue_thread(struct workqueue_struct *wq, int cpu)
-{
-	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
-
-	if (cwq->thread) {
-		kthread_stop(cwq->thread);
-		cwq->thread = NULL;
-	}
-}
-
-/**
- * destroy_workqueue - safely terminate a workqueue
- * @wq: target workqueue
- *
- * Safely destroy a workqueue. All work currently pending will be done first.
- */
-void destroy_workqueue(struct workqueue_struct *wq)
-{
-	int cpu;
-
-	flush_workqueue(wq);
-
-	/* We don't need the distraction of CPUs appearing and vanishing. */
-	mutex_lock(&workqueue_mutex);
-	if (is_single_threaded(wq))
-		cleanup_workqueue_thread(wq, singlethread_cpu);
-	else {
-		for_each_online_cpu(cpu)
-			cleanup_workqueue_thread(wq, cpu);
-		list_del(&wq->list);
-	}
-	mutex_unlock(&workqueue_mutex);
-	free_percpu(wq->cpu_wq);
-	kfree(wq);
-}
-EXPORT_SYMBOL_GPL(destroy_workqueue);
 
 static struct workqueue_struct *keventd_wq;
 
@@ -822,85 +706,193 @@ int current_is_keventd(void)
 
 }
 
-/* Take the work from this (downed) CPU. */
-static void take_over_work(struct workqueue_struct *wq, unsigned int cpu)
+static struct cpu_workqueue_struct *
+init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
 {
 	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
-	struct list_head list;
-	struct work_struct *work;
 
-	spin_lock_irq(&cwq->lock);
-	list_replace_init(&cwq->worklist, &list);
-	migrate_sequence++;
+	cwq->wq = wq;
+	spin_lock_init(&cwq->lock);
+	INIT_LIST_HEAD(&cwq->worklist);
+	init_waitqueue_head(&cwq->more_work);
 
-	while (!list_empty(&list)) {
-		printk("Taking work for %s\n", wq->name);
-		work = list_entry(list.next,struct work_struct,entry);
-		list_del(&work->entry);
-		__queue_work(per_cpu_ptr(wq->cpu_wq, smp_processor_id()), work);
-	}
-	spin_unlock_irq(&cwq->lock);
+	return cwq;
 }
 
-/* We're holding the cpucontrol mutex here */
-static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
-				  unsigned long action,
-				  void *hcpu)
+static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
+{
+	struct workqueue_struct *wq = cwq->wq;
+	const char *fmt = is_single_threaded(wq) ? "%s" : "%s/%d";
+	struct task_struct *p;
+
+	p = kthread_create(worker_thread, cwq, fmt, wq->name, cpu);
+	/*
+	 * Nobody can add the work_struct to this cwq,
+	 *	if (caller is __create_workqueue)
+	 *		nobody should see this wq
+	 *	else // caller is CPU_UP_PREPARE
+	 *		cpu is not on cpu_online_map
+	 * so we can abort safely.
+	 */
+	if (IS_ERR(p))
+		return PTR_ERR(p);
+
+	cwq->thread = p;
+	cwq->should_stop = 0;
+	if (!is_single_threaded(wq))
+		kthread_bind(p, cpu);
+
+	if (is_single_threaded(wq) || cpu_online(cpu))
+		wake_up_process(p);
+
+	return 0;
+}
+
+struct workqueue_struct *__create_workqueue(const char *name,
+					    int singlethread, int freezeable)
 {
-	unsigned int hotcpu = (unsigned long)hcpu;
 	struct workqueue_struct *wq;
+	struct cpu_workqueue_struct *cwq;
+	int err = 0, cpu;
 
-	switch (action) {
-	case CPU_UP_PREPARE:
+	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
+	if (!wq)
+		return NULL;
+
+	wq->cpu_wq = alloc_percpu(struct cpu_workqueue_struct);
+	if (!wq->cpu_wq) {
+		kfree(wq);
+		return NULL;
+	}
+
+	wq->name = name;
+	wq->freezeable = freezeable;
+
+	if (singlethread) {
+		INIT_LIST_HEAD(&wq->list);
+		cwq = init_cpu_workqueue(wq, singlethread_cpu);
+		err = create_workqueue_thread(cwq, singlethread_cpu);
+	} else {
 		mutex_lock(&workqueue_mutex);
-		/* Create a new workqueue thread for it. */
-		list_for_each_entry(wq, &workqueues, list) {
-			if (!create_workqueue_thread(wq, hotcpu)) {
-				printk("workqueue for %i failed\n", hotcpu);
-				return NOTIFY_BAD;
-			}
+		list_add(&wq->list, &workqueues);
+
+		for_each_possible_cpu(cpu) {
+			cwq = init_cpu_workqueue(wq, cpu);
+			if (err || !cpu_online(cpu))
+				continue;
+			err = create_workqueue_thread(cwq, cpu);
 		}
-		break;
+		mutex_unlock(&workqueue_mutex);
+	}
 
-	case CPU_ONLINE:
-		/* Kick off worker threads. */
-		list_for_each_entry(wq, &workqueues, list) {
-			struct cpu_workqueue_struct *cwq;
+	if (err) {
+		destroy_workqueue(wq);
+		wq = NULL;
+	}
+	return wq;
+}
+EXPORT_SYMBOL_GPL(__create_workqueue);
 
-			cwq = per_cpu_ptr(wq->cpu_wq, hotcpu);
-			kthread_bind(cwq->thread, hotcpu);
-			wake_up_process(cwq->thread);
-		}
+static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
+{
+	struct wq_barrier barr;
+	int alive = 0;
+
+	spin_lock_irq(&cwq->lock);
+	if (cwq->thread != NULL) {
+		insert_wq_barrier(cwq, &barr, 1);
+		cwq->should_stop = 1;
+		alive = 1;
+	}
+	spin_unlock_irq(&cwq->lock);
+
+	if (alive) {
+		wait_for_completion(&barr.done);
+
+		while (unlikely(cwq->thread != NULL))
+			cpu_relax();
+		/*
+		 * Wait until cwq->thread unlocks cwq->lock,
+		 * it won't touch *cwq after that.
+		 */
+		smp_rmb();
+		spin_unlock_wait(&cwq->lock);
+	}
+}
+
+/**
+ * destroy_workqueue - safely terminate a workqueue
+ * @wq: target workqueue
+ *
+ * Safely destroy a workqueue. All work currently pending will be done first.
+ */
+void destroy_workqueue(struct workqueue_struct *wq)
+{
+	struct cpu_workqueue_struct *cwq;
+
+	if (is_single_threaded(wq)) {
+		cwq = per_cpu_ptr(wq->cpu_wq, singlethread_cpu);
+		cleanup_workqueue_thread(cwq, singlethread_cpu);
+	} else {
+		int cpu;
+
+		mutex_lock(&workqueue_mutex);
+		list_del(&wq->list);
 		mutex_unlock(&workqueue_mutex);
-		break;
 
-	case CPU_UP_CANCELED:
-		list_for_each_entry(wq, &workqueues, list) {
-			if (!per_cpu_ptr(wq->cpu_wq, hotcpu)->thread)
-				continue;
-			/* Unbind so it can run. */
-			kthread_bind(per_cpu_ptr(wq->cpu_wq, hotcpu)->thread,
-				     any_online_cpu(cpu_online_map));
-			cleanup_workqueue_thread(wq, hotcpu);
+		for_each_cpu_mask(cpu, cpu_populated_map) {
+			cwq = per_cpu_ptr(wq->cpu_wq, cpu);
+			cleanup_workqueue_thread(cwq, cpu);
 		}
-		mutex_unlock(&workqueue_mutex);
-		break;
+	}
+
+	free_percpu(wq->cpu_wq);
+	kfree(wq);
+}
+EXPORT_SYMBOL_GPL(destroy_workqueue);
 
-	case CPU_DOWN_PREPARE:
+static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
+						unsigned long action,
+						void *hcpu)
+{
+	unsigned int cpu = (unsigned long)hcpu;
+	struct cpu_workqueue_struct *cwq;
+	struct workqueue_struct *wq;
+
+	switch (action) {
+	case CPU_LOCK_ACQUIRE:
 		mutex_lock(&workqueue_mutex);
-		break;
+		return NOTIFY_OK;
 
-	case CPU_DOWN_FAILED:
+	case CPU_LOCK_RELEASE:
 		mutex_unlock(&workqueue_mutex);
-		break;
+		return NOTIFY_OK;
 
-	case CPU_DEAD:
-		list_for_each_entry(wq, &workqueues, list)
-			cleanup_workqueue_thread(wq, hotcpu);
-		list_for_each_entry(wq, &workqueues, list)
-			take_over_work(wq, hotcpu);
-		mutex_unlock(&workqueue_mutex);
-		break;
+	case CPU_UP_PREPARE:
+		cpu_set(cpu, cpu_populated_map);
+	}
+
+	list_for_each_entry(wq, &workqueues, list) {
+		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
+
+		switch (action) {
+		case CPU_UP_PREPARE:
+			if (!create_workqueue_thread(cwq, cpu))
+				break;
+			printk(KERN_ERR "workqueue for %i failed\n", cpu);
+			return NOTIFY_BAD;
+
+		case CPU_ONLINE:
+			wake_up_process(cwq->thread);
+			break;
+
+		case CPU_UP_CANCELED:
+			if (cwq->thread)
+				wake_up_process(cwq->thread);
+		case CPU_DEAD:
+			cleanup_workqueue_thread(cwq, cpu);
+			break;
+		}
 	}
 
 	return NOTIFY_OK;
@@ -908,9 +900,9 @@ static int __devinit workqueue_cpu_callb
 
 void init_workqueues(void)
 {
+	cpu_populated_map = cpu_online_map;
 	singlethread_cpu = first_cpu(cpu_possible_map);
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);
 }
-
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
