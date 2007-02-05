From: akpm@linux-foundation.org
Subject: - workqueue-rework-threads-hotplug-management.patch removed from -mm tree
Date: Mon, 05 Feb 2007 13:57:30 -0800
Message-ID: <200702052157.l15LvUcV032529@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35527 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964786AbXBEV5u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 16:57:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ego@in.ibm.com, vatsa@in.ibm.com, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     workqueue: rework threads/hotplug management
has been removed from the -mm tree.  Its filename was
     workqueue-rework-threads-hotplug-management.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: workqueue: rework threads/hotplug management
From: Oleg Nesterov <oleg@tv-sign.ru>

With this patch workqueue_mutex is used only to protect workqueues list,
all workqueue operations can run in parallel with cpuhotplug callback path.
 take_over_work(), migrate_sequence, CPU_LOCK_ACQUIRE/RELEASE go away.

CPU_DEAD just sets cwq->should_stop and returns.  After that cwq->thread
runs unbound until it flushes cwq->worklist, then exits.  So this patch
slightly increases the probability that work_struct will be processed by
the "wrong" CPU, but we can't avoid this with CONFIG_HOTPLUG_CPU anyway.

CPU_UP_PREPARE creates the new cwq->thread if it's not NULL, CPU_ONLINE binds
it to the new cpu.

This all greatly simplifies the workqueues/cpu-hotplug interaction and imho
makes the code better.  Shrinks both the source and compiled code (430
bytes).  In particular, we can take workqueue_mutex in work->func() or
create/destroy workqueues from the cpuhotplug callback path.

The ugly part of this patch is that it adds "static int embryonic_cpu", it's
used by __create_workqueue() when it runs between CPU_UP_PREPARE/CPU_ONLINE.

cpu_populated_map was introduced to optimize for_each_possible_cpu(), it is
not strictly needed, and it is more a documentation in fact.

Further possible changes:

	- don't use kthread_create(), we don't use kthread_stop()

	- don't do kthread_bind() when create_workqueue_thread()
	  is called by CPU_UP_PREPARE, this is noop because of the
	  wake_up_process() below.

	- make cpu_populated_map per workqueue_struct, this allows
	  us to remove some "is_single_threaded(wq)" checks, and we
	  can clear the bit when cwq->thread exits.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Gautham shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/workqueue.c |  441 +++++++++++++++++++++----------------------
 1 files changed, 220 insertions(+), 221 deletions(-)

diff -puN kernel/workqueue.c~workqueue-rework-threads-hotplug-management kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-rework-threads-hotplug-management
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
@@ -64,11 +65,10 @@ struct workqueue_struct {
 
 /* All the per-cpu workqueues on the system, for hotplug cpu to add/remove
    threads to each one as cpus come/go. */
-static long migrate_sequence __read_mostly;
 static DEFINE_MUTEX(workqueue_mutex);
 static LIST_HEAD(workqueues);
 
-static int singlethread_cpu;
+static int singlethread_cpu __read_mostly;
 
 /* If it's single threaded, it isn't in the list of workqueues. */
 static inline int is_single_threaded(struct workqueue_struct *wq)
@@ -344,10 +344,28 @@ static void run_workqueue(struct cpu_wor
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
 
@@ -373,23 +391,21 @@ static int worker_thread(void *__cwq)
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
 
@@ -415,6 +431,9 @@ static void insert_wq_barrier(struct cpu
 	insert_work(cwq, &barr->work, tail);
 }
 
+/* optimization, we could use cpu_possible_map */
+static cpumask_t cpu_populated_map __read_mostly;
+
 static void flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
 {
 	if (cwq->thread == current) {
@@ -454,20 +473,13 @@ static void flush_cpu_workqueue(struct c
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
@@ -485,11 +497,8 @@ static void wait_on_work(struct cpu_work
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
@@ -510,155 +519,31 @@ void flush_work(struct workqueue_struct 
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
 
@@ -822,95 +707,209 @@ int current_is_keventd(void)
 
 }
 
-/* Take the work from this (downed) CPU. */
-static void take_over_work(struct workqueue_struct *wq, unsigned int cpu)
+static struct cpu_workqueue_struct *
+init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
 {
 	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
-	struct list_head list;
-	struct work_struct *work;
+
+	cwq->wq = wq;
+	spin_lock_init(&cwq->lock);
+	INIT_LIST_HEAD(&cwq->worklist);
+	init_waitqueue_head(&cwq->more_work);
+
+	return cwq;
+}
+
+static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
+{
+	struct task_struct *p;
 
 	spin_lock_irq(&cwq->lock);
-	list_replace_init(&cwq->worklist, &list);
-	migrate_sequence++;
+	cwq->should_stop = 0;
+	p = cwq->thread;
+	spin_unlock_irq(&cwq->lock);
 
-	while (!list_empty(&list)) {
-		printk("Taking work for %s\n", wq->name);
-		work = list_entry(list.next,struct work_struct,entry);
-		list_del(&work->entry);
-		__queue_work(per_cpu_ptr(wq->cpu_wq, smp_processor_id()), work);
+	if (!p) {
+		struct workqueue_struct *wq = cwq->wq;
+		const char *fmt = is_single_threaded(wq) ? "%s" : "%s/%d";
+
+		p = kthread_create(worker_thread, cwq, fmt, wq->name, cpu);
+		/*
+		 * Nobody can add the work_struct to this cwq,
+		 *	if (caller is __create_workqueue)
+		 *		nobody should see this wq
+		 *	else // caller is CPU_UP_PREPARE
+		 *		cpu is not on cpu_online_map
+		 * so we can abort safely.
+		 */
+		if (IS_ERR(p))
+			return PTR_ERR(p);
+
+		cwq->thread = p;
+		if (!is_single_threaded(wq))
+			kthread_bind(p, cpu);
+		/*
+		 * Cancels affinity if the caller is CPU_UP_PREPARE.
+		 * Needs a cleanup, but OK.
+		 */
+		wake_up_process(p);
 	}
-	spin_unlock_irq(&cwq->lock);
+
+	return 0;
 }
 
-/* We're holding the cpucontrol mutex here */
-static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
-				  unsigned long action,
-				  void *hcpu)
+static int embryonic_cpu __read_mostly = -1;
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
-		mutex_lock(&workqueue_mutex);
-		/* Create a new workqueue thread for it. */
-		list_for_each_entry(wq, &workqueues, list) {
-			if (!create_workqueue_thread(wq, hotcpu)) {
-				printk("workqueue for %i failed\n", hotcpu);
-				return NOTIFY_BAD;
-			}
-		}
-		break;
+	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
+	if (!wq)
+		return NULL;
 
-	case CPU_ONLINE:
-		/* Kick off worker threads. */
-		list_for_each_entry(wq, &workqueues, list) {
-			struct cpu_workqueue_struct *cwq;
-
-			cwq = per_cpu_ptr(wq->cpu_wq, hotcpu);
-			kthread_bind(cwq->thread, hotcpu);
-			wake_up_process(cwq->thread);
-		}
-		mutex_unlock(&workqueue_mutex);
-		break;
+	wq->cpu_wq = alloc_percpu(struct cpu_workqueue_struct);
+	if (!wq->cpu_wq) {
+		kfree(wq);
+		return NULL;
+	}
 
-	case CPU_UP_CANCELED:
-		list_for_each_entry(wq, &workqueues, list) {
-			if (!per_cpu_ptr(wq->cpu_wq, hotcpu)->thread)
+	wq->name = name;
+	wq->freezeable = freezeable;
+
+	if (singlethread) {
+		INIT_LIST_HEAD(&wq->list);
+		cwq = init_cpu_workqueue(wq, singlethread_cpu);
+		err = create_workqueue_thread(cwq, singlethread_cpu);
+	} else {
+		mutex_lock(&workqueue_mutex);
+		list_add(&wq->list, &workqueues);
+
+		for_each_possible_cpu(cpu) {
+			cwq = init_cpu_workqueue(wq, cpu);
+			if (err || !(cpu_online(cpu) || cpu == embryonic_cpu))
 				continue;
-			/* Unbind so it can run. */
-			kthread_bind(per_cpu_ptr(wq->cpu_wq, hotcpu)->thread,
-				     any_online_cpu(cpu_online_map));
-			cleanup_workqueue_thread(wq, hotcpu);
+			err = create_workqueue_thread(cwq, cpu);
 		}
 		mutex_unlock(&workqueue_mutex);
-		break;
+	}
 
-	case CPU_DOWN_PREPARE:
-		mutex_lock(&workqueue_mutex);
-		break;
+	if (err) {
+		destroy_workqueue(wq);
+		wq = NULL;
+	}
+	return wq;
+}
+EXPORT_SYMBOL_GPL(__create_workqueue);
 
-	case CPU_DOWN_FAILED:
-		mutex_unlock(&workqueue_mutex);
-		break;
+static void cleanup_workqueue_thread(struct workqueue_struct *wq, int cpu)
+{
+	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
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
+	if (is_single_threaded(wq))
+		cleanup_workqueue_thread(wq, singlethread_cpu);
+	else {
+		int cpu;
 
-	case CPU_DEAD:
-		list_for_each_entry(wq, &workqueues, list)
-			cleanup_workqueue_thread(wq, hotcpu);
-		list_for_each_entry(wq, &workqueues, list)
-			take_over_work(wq, hotcpu);
+		mutex_lock(&workqueue_mutex);
+		list_del(&wq->list);
 		mutex_unlock(&workqueue_mutex);
-		break;
+
+		for_each_cpu_mask(cpu, cpu_populated_map)
+			cleanup_workqueue_thread(wq, cpu);
+	}
+
+	free_percpu(wq->cpu_wq);
+	kfree(wq);
+}
+EXPORT_SYMBOL_GPL(destroy_workqueue);
+
+static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
+						unsigned long action,
+						void *hcpu)
+{
+	struct workqueue_struct *wq;
+	struct cpu_workqueue_struct *cwq;
+	unsigned int cpu = (unsigned long)hcpu;
+	int ret = NOTIFY_OK;
+
+	mutex_lock(&workqueue_mutex);
+	embryonic_cpu = -1;
+	if (action == CPU_UP_PREPARE) {
+		cpu_set(cpu, cpu_populated_map);
+		embryonic_cpu = cpu;
+	}
+
+	list_for_each_entry(wq, &workqueues, list) {
+		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
+
+		switch (action) {
+		case CPU_UP_PREPARE:
+			if (create_workqueue_thread(cwq, cpu))
+				ret = NOTIFY_BAD;
+			break;
+
+		case CPU_ONLINE:
+			set_cpus_allowed(cwq->thread, cpumask_of_cpu(cpu));
+			break;
+
+		case CPU_UP_CANCELED:
+		case CPU_DEAD:
+			cwq->should_stop = 1;
+			wake_up(&cwq->more_work);
+			break;
+		}
+
+		if (ret != NOTIFY_OK) {
+			printk(KERN_ERR "workqueue for %i failed\n", cpu);
+			break;
+		}
 	}
+	mutex_unlock(&workqueue_mutex);
 
-	return NOTIFY_OK;
+	return ret;
 }
 
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

git-dvb.patch
git-block.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
vt-refactor-console-sak-processing.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
kill_pid_info-kill-acquired_tasklist_lock.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
_proc_do_string-fix-short-reads.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
posix-timers-rcu-optimization-for-clock_gettime.patch
posix-timers-rcu-optimization-for-clock_gettime-fix.patch
reimplement-flush_workqueue.patch
implement-flush_work.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
flush_cpu_workqueue-dont-flush-an-empty-worklist.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
slab-use-cpu_lock_.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
workqueue-rework-threads-hotplug-management.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
hotplug-allow-modules-to-use-the-cpu-hotplug-notifiers.patch
