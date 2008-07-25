From: akpm@linux-foundation.org
Subject: - workqueues-make-get_online_cpus-useable-for-work-func.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:00:17 -0700
Message-ID: <200807252300.m6PN0H54003572@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753475AbYGYXDS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:03:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ego@in.ibm.com, heiko.carstens@de.ibm.com, maxk@qualcomm.com, menage@google.com, mingo@elte.hu, peterz@infradead.org, pj@sgi.com, schwidefsky@de.ibm.com, vegard.nossu


The patch titled
     workqueues: make get_online_cpus() useable for work->func()
has been removed from the -mm tree.  Its filename was
     workqueues-make-get_online_cpus-useable-for-work-func.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: workqueues: make get_online_cpus() useable for work->func()
From: Oleg Nesterov <oleg@tv-sign.ru>

workqueue_cpu_callback(CPU_DEAD) flushes cwq->thread under
cpu_maps_update_begin().  This means that the multithreaded workqueues
can't use get_online_cpus() due to the possible deadlock, very bad and
very old problem.

Introduce the new state, CPU_POST_DEAD, which is called after
cpu_hotplug_done() but before cpu_maps_update_done().

Change workqueue_cpu_callback() to use CPU_POST_DEAD instead of CPU_DEAD. 
This means that create/destroy functions can't rely on get_online_cpus()
any longer and should take cpu_add_remove_lock instead.

[akpm@linux-foundation.org: fix CONFIG_SMP=n]
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpu.h      |   15 +++++++++++----
 include/linux/notifier.h |    2 ++
 kernel/cpu.c             |    5 +++++
 kernel/workqueue.c       |   18 +++++++++---------
 4 files changed, 27 insertions(+), 13 deletions(-)

diff -puN include/linux/cpu.h~workqueues-make-get_online_cpus-useable-for-work-func include/linux/cpu.h
--- a/include/linux/cpu.h~workqueues-make-get_online_cpus-useable-for-work-func
+++ a/include/linux/cpu.h
@@ -69,10 +69,11 @@ static inline void unregister_cpu_notifi
 #endif
 
 int cpu_up(unsigned int cpu);
-
 extern void cpu_hotplug_init(void);
+extern void cpu_maps_update_begin(void);
+extern void cpu_maps_update_done(void);
 
-#else
+#else	/* CONFIG_SMP */
 
 static inline int register_cpu_notifier(struct notifier_block *nb)
 {
@@ -87,10 +88,16 @@ static inline void cpu_hotplug_init(void
 {
 }
 
+static inline void cpu_maps_update_begin(void)
+{
+}
+
+static inline void cpu_maps_update_done(void)
+{
+}
+
 #endif /* CONFIG_SMP */
 extern struct sysdev_class cpu_sysdev_class;
-extern void cpu_maps_update_begin(void);
-extern void cpu_maps_update_done(void);
 
 #ifdef CONFIG_HOTPLUG_CPU
 /* Stop CPUs going up and down. */
diff -puN include/linux/notifier.h~workqueues-make-get_online_cpus-useable-for-work-func include/linux/notifier.h
--- a/include/linux/notifier.h~workqueues-make-get_online_cpus-useable-for-work-func
+++ a/include/linux/notifier.h
@@ -214,6 +214,8 @@ static inline int notifier_to_errno(int 
 #define CPU_DEAD		0x0007 /* CPU (unsigned)v dead */
 #define CPU_DYING		0x0008 /* CPU (unsigned)v not running any task,
 				        * not handling interrupts, soon dead */
+#define CPU_POST_DEAD		0x0009 /* CPU (unsigned)v dead, cpu_hotplug
+					* lock is dropped */
 
 /* Used for CPU hotplug events occuring while tasks are frozen due to a suspend
  * operation in progress
diff -puN kernel/cpu.c~workqueues-make-get_online_cpus-useable-for-work-func kernel/cpu.c
--- a/kernel/cpu.c~workqueues-make-get_online_cpus-useable-for-work-func
+++ a/kernel/cpu.c
@@ -285,6 +285,11 @@ out_allowed:
 	set_cpus_allowed_ptr(current, &old_allowed);
 out_release:
 	cpu_hotplug_done();
+	if (!err) {
+		if (raw_notifier_call_chain(&cpu_chain, CPU_POST_DEAD | mod,
+					    hcpu) == NOTIFY_BAD)
+			BUG();
+	}
 	return err;
 }
 
diff -puN kernel/workqueue.c~workqueues-make-get_online_cpus-useable-for-work-func kernel/workqueue.c
--- a/kernel/workqueue.c~workqueues-make-get_online_cpus-useable-for-work-func
+++ a/kernel/workqueue.c
@@ -828,7 +828,7 @@ struct workqueue_struct *__create_workqu
 		err = create_workqueue_thread(cwq, singlethread_cpu);
 		start_workqueue_thread(cwq, -1);
 	} else {
-		get_online_cpus();
+		cpu_maps_update_begin();
 		spin_lock(&workqueue_lock);
 		list_add(&wq->list, &workqueues);
 		spin_unlock(&workqueue_lock);
@@ -840,7 +840,7 @@ struct workqueue_struct *__create_workqu
 			err = create_workqueue_thread(cwq, cpu);
 			start_workqueue_thread(cwq, cpu);
 		}
-		put_online_cpus();
+		cpu_maps_update_done();
 	}
 
 	if (err) {
@@ -854,8 +854,8 @@ EXPORT_SYMBOL_GPL(__create_workqueue_key
 static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
 {
 	/*
-	 * Our caller is either destroy_workqueue() or CPU_DEAD,
-	 * get_online_cpus() protects cwq->thread.
+	 * Our caller is either destroy_workqueue() or CPU_POST_DEAD,
+	 * cpu_add_remove_lock protects cwq->thread.
 	 */
 	if (cwq->thread == NULL)
 		return;
@@ -865,7 +865,7 @@ static void cleanup_workqueue_thread(str
 
 	flush_cpu_workqueue(cwq);
 	/*
-	 * If the caller is CPU_DEAD and cwq->worklist was not empty,
+	 * If the caller is CPU_POST_DEAD and cwq->worklist was not empty,
 	 * a concurrent flush_workqueue() can insert a barrier after us.
 	 * However, in that case run_workqueue() won't return and check
 	 * kthread_should_stop() until it flushes all work_struct's.
@@ -889,14 +889,14 @@ void destroy_workqueue(struct workqueue_
 	const cpumask_t *cpu_map = wq_cpu_map(wq);
 	int cpu;
 
-	get_online_cpus();
+	cpu_maps_update_begin();
 	spin_lock(&workqueue_lock);
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
 
 	for_each_cpu_mask_nr(cpu, *cpu_map)
 		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
-	put_online_cpus();
+ 	cpu_maps_update_done();
 
 	free_percpu(wq->cpu_wq);
 	kfree(wq);
@@ -935,7 +935,7 @@ static int __devinit workqueue_cpu_callb
 
 		case CPU_UP_CANCELED:
 			start_workqueue_thread(cwq, -1);
-		case CPU_DEAD:
+		case CPU_POST_DEAD:
 			cleanup_workqueue_thread(cwq);
 			break;
 		}
@@ -943,7 +943,7 @@ static int __devinit workqueue_cpu_callb
 
 	switch (action) {
 	case CPU_UP_CANCELED:
-	case CPU_DEAD:
+	case CPU_POST_DEAD:
 		cpu_clear(cpu, cpu_populated_map);
 	}
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
tracehook-add-linux-tracehookh.patch
tracehook-exec.patch
tracehook-unexport-ptrace_notify.patch
tracehook-exit.patch
tracehook-clone.patch
tracehook-vfork-done.patch
tracehook-release_task.patch
tracehook-tracehook_tracer_task.patch
tracehook-tracehook_expect_breakpoints.patch
tracehook-tracehook_signal_handler.patch
tracehook-tracehook_consider_ignored_signal.patch
tracehook-tracehook_consider_fatal_signal.patch
tracehook-syscall.patch
tracehook-get_signal_to_deliver.patch
tracehook-job-control.patch
tracehook-death.patch
tracehook-force-signal_pending.patch
tracehook-tif_notify_resume.patch
tracehook-asm-syscallh.patch
tracehook-config_have_arch_tracehook.patch
tracehook-wait_task_inactive.patch
task_current_syscall.patch
proc-pid-syscall.patch

