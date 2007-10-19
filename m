From: akpm@linux-foundation.org
Subject: - hotplug-cpu-migrate-a-task-within-its-cpuset.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:53:27 -0700
Message-ID: <200710192253.l9JMrR9K024427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56433 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760682AbXJSXGU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cpw@sgi.com, clameter@sgi.com, mingo@elte.hu, oleg@tv-sign.ru, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     hotplug cpu: migrate a task within its cpuset
has been removed from the -mm tree.  Its filename was
     hotplug-cpu-migrate-a-task-within-its-cpuset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hotplug cpu: migrate a task within its cpuset
From: Cliff Wickman <cpw@sgi.com>

When a cpu is disabled, move_task_off_dead_cpu() is called for tasks that have
been running on that cpu.

Currently, such a task is migrated:
 1) to any cpu on the same node as the disabled cpu, which is both online
    and among that task's cpus_allowed
 2) to any cpu which is both online and among that task's cpus_allowed

It is typical of a multithreaded application running on a large NUMA system to
have its tasks confined to a cpuset so as to cluster them near the memory that
they share.  Furthermore, it is typical to explicitly place such a task on a
specific cpu in that cpuset.  And in that case the task's cpus_allowed
includes only a single cpu.

This patch would insert a preference to migrate such a task to some cpu within
its cpuset (and set its cpus_allowed to its entire cpuset).

With this patch, migrate the task to:
 1) to any cpu on the same node as the disabled cpu, which is both online
    and among that task's cpus_allowed
 2) to any online cpu within the task's cpuset
 3) to any cpu which is both online and among that task's cpus_allowed

In order to do this, move_task_off_dead_cpu() must make a call to
cpuset_cpus_allowed_locked(), a new subset of cpuset_cpus_allowed(), that will
not block.  (name change - per Oleg's suggestion)

Calls are made to cpuset_lock() and cpuset_unlock() in migration_call() to set
the cpuset mutex during the whole migrate_live_tasks() and
migrate_dead_tasks() procedure.

[akpm@linux-foundation.org: build fix]
[pj@sgi.com: Fix indentation and spacing]
Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpu-hotplug.txt |    4 +++-
 include/linux/cpuset.h        |    5 +++++
 kernel/cpuset.c               |   15 ++++++++++++++-
 kernel/sched.c                |   12 +++++++++++-
 4 files changed, 33 insertions(+), 3 deletions(-)

diff -puN Documentation/cpu-hotplug.txt~hotplug-cpu-migrate-a-task-within-its-cpuset Documentation/cpu-hotplug.txt
--- a/Documentation/cpu-hotplug.txt~hotplug-cpu-migrate-a-task-within-its-cpuset
+++ a/Documentation/cpu-hotplug.txt
@@ -220,7 +220,9 @@ A: The following happen, listed in no pa
   CPU_DOWN_PREPARE or CPU_DOWN_PREPARE_FROZEN, depending on whether or not the
   CPU is being offlined while tasks are frozen due to a suspend operation in
   progress
-- All process is migrated away from this outgoing CPU to a new CPU
+- All processes are migrated away from this outgoing CPU to new CPUs.
+  The new CPU is chosen from each process' current cpuset, which may be
+  a subset of all online CPUs.
 - All interrupts targeted to this CPU is migrated to a new CPU
 - timers/bottom half/task lets are also migrated to a new CPU
 - Once all services are migrated, kernel calls an arch specific routine
diff -puN include/linux/cpuset.h~hotplug-cpu-migrate-a-task-within-its-cpuset include/linux/cpuset.h
--- a/include/linux/cpuset.h~hotplug-cpu-migrate-a-task-within-its-cpuset
+++ a/include/linux/cpuset.h
@@ -21,6 +21,7 @@ extern int cpuset_init_early(void);
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
 extern cpumask_t cpuset_cpus_allowed(struct task_struct *p);
+extern cpumask_t cpuset_cpus_allowed_locked(struct task_struct *p);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
@@ -87,6 +88,10 @@ static inline cpumask_t cpuset_cpus_allo
 {
 	return cpu_possible_map;
 }
+static inline cpumask_t cpuset_cpus_allowed_locked(struct task_struct *p)
+{
+	return cpu_possible_map;
+}
 
 static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
 {
diff -puN kernel/cpuset.c~hotplug-cpu-migrate-a-task-within-its-cpuset kernel/cpuset.c
--- a/kernel/cpuset.c~hotplug-cpu-migrate-a-task-within-its-cpuset
+++ a/kernel/cpuset.c
@@ -1818,10 +1818,23 @@ cpumask_t cpuset_cpus_allowed(struct tas
 	cpumask_t mask;
 
 	mutex_lock(&callback_mutex);
+	mask = cpuset_cpus_allowed_locked(tsk);
+	mutex_unlock(&callback_mutex);
+
+	return mask;
+}
+
+/**
+ * cpuset_cpus_allowed_locked - return cpus_allowed mask from a tasks cpuset.
+ * Must be  called with callback_mutex held.
+ **/
+cpumask_t cpuset_cpus_allowed_locked(struct task_struct *tsk)
+{
+	cpumask_t mask;
+
 	task_lock(tsk);
 	guarantee_online_cpus(task_cs(tsk), &mask);
 	task_unlock(tsk);
-	mutex_unlock(&callback_mutex);
 
 	return mask;
 }
diff -puN kernel/sched.c~hotplug-cpu-migrate-a-task-within-its-cpuset kernel/sched.c
--- a/kernel/sched.c~hotplug-cpu-migrate-a-task-within-its-cpuset
+++ a/kernel/sched.c
@@ -5160,8 +5160,16 @@ static void move_task_off_dead_cpu(int d
 
 		/* No more Mr. Nice Guy. */
 		if (dest_cpu == NR_CPUS) {
+			cpumask_t cpus_allowed = cpuset_cpus_allowed_locked(p);
+			/*
+			 * Try to stay on the same cpuset, where the
+			 * current cpuset may be a subset of all cpus.
+			 * The cpuset_cpus_allowed_locked() variant of
+			 * cpuset_cpus_allowed() will not block.  It must be
+			 * called within calls to cpuset_lock/cpuset_unlock.
+			 */
 			rq = task_rq_lock(p, &flags);
-			cpus_setall(p->cpus_allowed);
+			p->cpus_allowed = cpus_allowed;
 			dest_cpu = any_online_cpu(p->cpus_allowed);
 			task_rq_unlock(rq, &flags);
 
@@ -5527,6 +5535,7 @@ migration_call(struct notifier_block *nf
 
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
+		cpuset_lock(); /* around calls to cpuset_cpus_allowed_lock() */
 		migrate_live_tasks(cpu);
 		rq = cpu_rq(cpu);
 		kthread_stop(rq->migration_thread);
@@ -5540,6 +5549,7 @@ migration_call(struct notifier_block *nf
 		rq->idle->sched_class = &idle_sched_class;
 		migrate_dead_tasks(cpu);
 		spin_unlock_irq(&rq->lock);
+		cpuset_unlock();
 		migrate_nr_uninterruptible(rq);
 		BUG_ON(rq->nr_running != 0);
 
_

Patches currently in -mm which might be from cpw@sgi.com are

origin.patch
