From: akpm@linux-foundation.org
Subject: + hotplug-cpu-migrate-a-task-within-its-cpuset.patch added to -mm tree
Date: Mon, 27 Aug 2007 16:49:59 -0700
Message-ID: <200708272350.l7RNo0fF002394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56444 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752505AbXH0Xu3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 19:50:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cpw@sgi.com, clameter@sgi.com, mingo@elte.hu, oleg@tv-sign.ru, pj@sgi.com


The patch titled
     hotplug cpu: migrate a task within its cpuset
has been added to the -mm tree.  Its filename is
     hotplug-cpu-migrate-a-task-within-its-cpuset.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

This patch depends on 2 patches from Oleg Nesterov:
  [PATCH 1/2] do CPU_DEAD migrating under read_lock(tasklist) instead of write_lock_irq(tasklist)
  [PATCH 2/2] migration_call(CPU_DEAD): use spin_lock_irq() instead of task_rq_lock()

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuset.h |    5 +++++
 kernel/cpuset.c        |   15 ++++++++++++++-
 kernel/sched.c         |   12 +++++++++++-
 3 files changed, 30 insertions(+), 2 deletions(-)

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
@@ -86,6 +87,10 @@ static inline cpumask_t cpuset_cpus_allo
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
@@ -1466,10 +1466,23 @@ cpumask_t cpuset_cpus_allowed(struct tas
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
@@ -5145,8 +5145,16 @@ restart:
 
 	/* No more Mr. Nice Guy. */
 	if (dest_cpu == NR_CPUS) {
+		cpumask_t cpus_allowed = cpuset_cpus_allowed_locked();
+		/*
+		 * Try to stay on the same cpuset, where the current cpuset
+		 * may be a subset of all cpus.
+		 * The cpuset_cpus_allowed_locked() variant of
+		 * cpuset_cpus_allowed() will not block
+		 * It must be called within calls to cpuset_lock/cpuset_unlock.
+		 */
 		rq = task_rq_lock(p, &flags);
-		cpus_setall(p->cpus_allowed);
+		p->cpus_allowed = cpus_allowed;
 		dest_cpu = any_online_cpu(p->cpus_allowed);
 		task_rq_unlock(rq, &flags);
 
@@ -5465,6 +5473,7 @@ migration_call(struct notifier_block *nf
 
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
+		cpuset_lock(); /* around calls to cpuset_cpus_allowed_lock() */
 		migrate_live_tasks(cpu);
 		rq = cpu_rq(cpu);
 		kthread_stop(rq->migration_thread);
@@ -5478,6 +5487,7 @@ migration_call(struct notifier_block *nf
 		rq->idle->sched_class = &idle_sched_class;
 		migrate_dead_tasks(cpu);
 		spin_unlock_irq(&rq->lock);
+		cpuset_unlock();
 		migrate_nr_uninterruptible(rq);
 		BUG_ON(rq->nr_running != 0);
 
_

Patches currently in -mm which might be from cpw@sgi.com are

do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist.patch
migration_callcpu_dead-use-spin_lock_irq-instead-of-task_rq_lock.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
