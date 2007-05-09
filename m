From: akpm@linux-foundation.org
Subject: - eliminate-lock_cpu_hotplug-in-kernel-schedc.patch removed from -mm tree
Date: Wed, 09 May 2007 14:51:27 -0700
Message-ID: <200705092151.l49LpRBC002879@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758532AbXEIVvy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:51:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ego@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Eliminate lock_cpu_hotplug in kernel/schedc
has been removed from the -mm tree.  Its filename was
     eliminate-lock_cpu_hotplug-in-kernel-schedc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Eliminate lock_cpu_hotplug in kernel/schedc
From: Gautham R Shenoy <ego@in.ibm.com>

Eliminate lock_cpu_hotplug from kernel/sched.c and use sched_hotcpu_mutex
instead to postpone a hotplug event.

In the migration_call hotcpu callback function, take sched_hotcpu_mutex
while handling the event CPU_LOCK_ACQUIRE and release it while handling
CPU_LOCK_RELEASE event.

[akpm@linux-foundation.org: fix deadlock]
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff -puN kernel/sched.c~eliminate-lock_cpu_hotplug-in-kernel-schedc kernel/sched.c
--- a/kernel/sched.c~eliminate-lock_cpu_hotplug-in-kernel-schedc
+++ a/kernel/sched.c
@@ -305,6 +305,7 @@ struct rq {
 };
 
 static DEFINE_PER_CPU(struct rq, runqueues) ____cacheline_aligned_in_smp;
+static DEFINE_MUTEX(sched_hotcpu_mutex);
 
 static inline int cpu_of(struct rq *rq)
 {
@@ -4520,13 +4521,13 @@ long sched_setaffinity(pid_t pid, cpumas
 	struct task_struct *p;
 	int retval;
 
-	lock_cpu_hotplug();
+	mutex_lock(&sched_hotcpu_mutex);
 	read_lock(&tasklist_lock);
 
 	p = find_process_by_pid(pid);
 	if (!p) {
 		read_unlock(&tasklist_lock);
-		unlock_cpu_hotplug();
+		mutex_unlock(&sched_hotcpu_mutex);
 		return -ESRCH;
 	}
 
@@ -4553,7 +4554,7 @@ long sched_setaffinity(pid_t pid, cpumas
 
 out_unlock:
 	put_task_struct(p);
-	unlock_cpu_hotplug();
+	mutex_unlock(&sched_hotcpu_mutex);
 	return retval;
 }
 
@@ -4610,7 +4611,7 @@ long sched_getaffinity(pid_t pid, cpumas
 	struct task_struct *p;
 	int retval;
 
-	lock_cpu_hotplug();
+	mutex_lock(&sched_hotcpu_mutex);
 	read_lock(&tasklist_lock);
 
 	retval = -ESRCH;
@@ -4626,7 +4627,7 @@ long sched_getaffinity(pid_t pid, cpumas
 
 out_unlock:
 	read_unlock(&tasklist_lock);
-	unlock_cpu_hotplug();
+	mutex_unlock(&sched_hotcpu_mutex);
 	if (retval)
 		return retval;
 
@@ -5388,6 +5389,10 @@ migration_call(struct notifier_block *nf
 	struct rq *rq;
 
 	switch (action) {
+	case CPU_LOCK_ACQUIRE:
+		mutex_lock(&sched_hotcpu_mutex);
+		break;
+
 	case CPU_UP_PREPARE:
 		p = kthread_create(migration_thread, hcpu, "migration/%d",cpu);
 		if (IS_ERR(p))
@@ -5433,7 +5438,7 @@ migration_call(struct notifier_block *nf
 		BUG_ON(rq->nr_running != 0);
 
 		/* No need to migrate the tasks: it was best-effort if
-		 * they didn't do lock_cpu_hotplug().  Just wake up
+		 * they didn't take sched_hotcpu_mutex.  Just wake up
 		 * the requestors. */
 		spin_lock_irq(&rq->lock);
 		while (!list_empty(&rq->migration_queue)) {
@@ -5447,6 +5452,9 @@ migration_call(struct notifier_block *nf
 		spin_unlock_irq(&rq->lock);
 		break;
 #endif
+	case CPU_LOCK_RELEASE:
+		mutex_unlock(&sched_hotcpu_mutex);
+		break;
 	}
 	return NOTIFY_OK;
 }
@@ -6822,10 +6830,10 @@ int arch_reinit_sched_domains(void)
 {
 	int err;
 
-	lock_cpu_hotplug();
+	mutex_lock(&sched_hotcpu_mutex);
 	detach_destroy_domains(&cpu_online_map);
 	err = arch_init_sched_domains(&cpu_online_map);
-	unlock_cpu_hotplug();
+	mutex_unlock(&sched_hotcpu_mutex);
 
 	return err;
 }
@@ -6930,12 +6938,12 @@ void __init sched_init_smp(void)
 {
 	cpumask_t non_isolated_cpus;
 
-	lock_cpu_hotplug();
+	mutex_lock(&sched_hotcpu_mutex);
 	arch_init_sched_domains(&cpu_online_map);
 	cpus_andnot(non_isolated_cpus, cpu_possible_map, cpu_isolated_map);
 	if (cpus_empty(non_isolated_cpus))
 		cpu_set(smp_processor_id(), non_isolated_cpus);
-	unlock_cpu_hotplug();
+	mutex_unlock(&sched_hotcpu_mutex);
 	/* XXX: Theoretical race here - CPU may be hotplugged now */
 	hotcpu_notifier(update_sched_domains, 0);
 
_

Patches currently in -mm which might be from ego@in.ibm.com are

origin.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
