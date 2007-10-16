From: akpm@linux-foundation.org
Subject: - cpuset-remove-sched-domain-hooks-from-cpusets.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:39:36 -0700
Message-ID: <200710162039.l9GKda5g015558@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53331 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934983AbXJPVh3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:37:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pj@sgi.com, clameter@engr.sgi.com, dino@in.ibm.com, mingo@elte.hu, nickpiggin@yahoo.com.au, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     cpuset: remove sched domain hooks from cpusets
has been removed from the -mm tree.  Its filename was
     cpuset-remove-sched-domain-hooks-from-cpusets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cpuset: remove sched domain hooks from cpusets
From: Paul Jackson <pj@sgi.com>

Remove the cpuset hooks that defined sched domains depending on the setting
of the 'cpu_exclusive' flag.

The cpu_exclusive flag can only be set on a child if it is set on the
parent.

This made that flag painfully unsuitable for use as a flag defining a
partitioning of a system.

It was entirely unobvious to a cpuset user what partitioning of sched
domains they would be causing when they set that one cpu_exclusive bit on
one cpuset, because it depended on what CPUs were in the remainder of that
cpusets siblings and child cpusets, after subtracting out other
cpu_exclusive cpusets.

Furthermore, there was no way on production systems to query the
result.

Using the cpu_exclusive flag for this was simply wrong from the get go.

Fortunately, it was sufficiently borked that so far as I know, almost no
successful use has been made of this.  One real time group did use it to
affectively isolate CPUs from any load balancing efforts.  They are willing
to adapt to alternative mechanisms for this, such as someway to manipulate
the list of isolated CPUs on a running system.  They can do without this
present cpu_exclusive based mechanism while we develop an alternative.

There is a real risk, to the best of my understanding, of users
accidentally setting up a partitioned scheduler domains, inhibiting desired
load balancing across all their CPUs, due to the nonobvious (from the
cpuset perspective) side affects of the cpu_exclusive flag.

Furthermore, since there was no way on a running system to see what one was
doing with sched domains, this change will be invisible to any using code. 
Unless they have real insight to the scheduler load balancing choices, they
will be unable to detect that this change has been made in the kernel's
behaviour.

Initial discussion on lkml of this patch has generated much comment.  My
(probably controversial) take on that discussion is that it has reached a
rough concensus that the current cpuset cpu_exclusive mechanism for
defining sched domains is borked.  There is no concensus on the
replacement.  But since we can remove this mechanism, and since its
continued presence risks causing unwanted partitioning of the schedulers
load balancing, we should remove it while we can, as we proceed to work the
replacement scheduler domain mechanisms.

Signed-off-by: Paul Jackson <pj@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpusets.txt |   17 -------
 include/linux/sched.h     |    3 -
 kernel/cpuset.c           |   84 ------------------------------------
 kernel/sched.c            |   29 ------------
 4 files changed, 2 insertions(+), 131 deletions(-)

diff -puN Documentation/cpusets.txt~cpuset-remove-sched-domain-hooks-from-cpusets Documentation/cpusets.txt
--- a/Documentation/cpusets.txt~cpuset-remove-sched-domain-hooks-from-cpusets
+++ a/Documentation/cpusets.txt
@@ -87,9 +87,6 @@ This can be especially valuable on:
       and a database), or
     * NUMA systems running large HPC applications with demanding
       performance characteristics.
-    * Also cpu_exclusive cpusets are useful for servers running orthogonal
-      workloads such as RT applications requiring low latency and HPC
-      applications that are throughput sensitive
 
 These subsets, or "soft partitions" must be able to be dynamically
 adjusted, as the job mix changes, without impacting other concurrently
@@ -132,8 +129,6 @@ Cpusets extends these two mechanisms as 
  - A cpuset may be marked exclusive, which ensures that no other
    cpuset (except direct ancestors and descendents) may contain
    any overlapping CPUs or Memory Nodes.
-   Also a cpu_exclusive cpuset would be associated with a sched
-   domain.
  - You can list all the tasks (by pid) attached to any cpuset.
 
 The implementation of cpusets requires a few, simple hooks
@@ -145,9 +140,6 @@ into the rest of the kernel, none in per
    allowed in that tasks cpuset.
  - in sched.c migrate_all_tasks(), to keep migrating tasks within
    the CPUs allowed by their cpuset, if possible.
- - in sched.c, a new API partition_sched_domains for handling
-   sched domain changes associated with cpu_exclusive cpusets
-   and related changes in both sched.c and arch/ia64/kernel/domain.c
  - in the mbind and set_mempolicy system calls, to mask the requested
    Memory Nodes by what's allowed in that tasks cpuset.
  - in page_alloc.c, to restrict memory to allowed nodes.
@@ -232,15 +224,6 @@ If a cpuset is cpu or mem exclusive, no 
 a direct ancestor or descendent, may share any of the same CPUs or
 Memory Nodes.
 
-A cpuset that is cpu_exclusive has a scheduler (sched) domain
-associated with it.  The sched domain consists of all CPUs in the
-current cpuset that are not part of any exclusive child cpusets.
-This ensures that the scheduler load balancing code only balances
-against the CPUs that are in the sched domain as defined above and
-not all of the CPUs in the system. This removes any overhead due to
-load balancing code trying to pull tasks outside of the cpu_exclusive
-cpuset only to be prevented by the tasks' cpus_allowed mask.
-
 A cpuset that is mem_exclusive restricts kernel allocations for
 page, buffer and other data commonly shared by the kernel across
 multiple users.  All cpusets, whether mem_exclusive or not, restrict
diff -puN include/linux/sched.h~cpuset-remove-sched-domain-hooks-from-cpusets include/linux/sched.h
--- a/include/linux/sched.h~cpuset-remove-sched-domain-hooks-from-cpusets
+++ a/include/linux/sched.h
@@ -729,9 +729,6 @@ struct sched_domain {
 #endif
 };
 
-extern int partition_sched_domains(cpumask_t *partition1,
-				    cpumask_t *partition2);
-
 #endif	/* CONFIG_SMP */
 
 /*
diff -puN kernel/cpuset.c~cpuset-remove-sched-domain-hooks-from-cpusets kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-remove-sched-domain-hooks-from-cpusets
+++ a/kernel/cpuset.c
@@ -755,68 +755,13 @@ static int validate_change(const struct 
 }
 
 /*
- * For a given cpuset cur, partition the system as follows
- * a. All cpus in the parent cpuset's cpus_allowed that are not part of any
- *    exclusive child cpusets
- * b. All cpus in the current cpuset's cpus_allowed that are not part of any
- *    exclusive child cpusets
- * Build these two partitions by calling partition_sched_domains
- *
- * Call with manage_mutex held.  May nest a call to the
- * lock_cpu_hotplug()/unlock_cpu_hotplug() pair.
- * Must not be called holding callback_mutex, because we must
- * not call lock_cpu_hotplug() while holding callback_mutex.
- */
-
-static void update_cpu_domains(struct cpuset *cur)
-{
-	struct cpuset *c, *par = cur->parent;
-	cpumask_t pspan, cspan;
-
-	if (par == NULL || cpus_empty(cur->cpus_allowed))
-		return;
-
-	/*
-	 * Get all cpus from parent's cpus_allowed not part of exclusive
-	 * children
-	 */
-	pspan = par->cpus_allowed;
-	list_for_each_entry(c, &par->children, sibling) {
-		if (is_cpu_exclusive(c))
-			cpus_andnot(pspan, pspan, c->cpus_allowed);
-	}
-	if (!is_cpu_exclusive(cur)) {
-		cpus_or(pspan, pspan, cur->cpus_allowed);
-		if (cpus_equal(pspan, cur->cpus_allowed))
-			return;
-		cspan = CPU_MASK_NONE;
-	} else {
-		if (cpus_empty(pspan))
-			return;
-		cspan = cur->cpus_allowed;
-		/*
-		 * Get all cpus from current cpuset's cpus_allowed not part
-		 * of exclusive children
-		 */
-		list_for_each_entry(c, &cur->children, sibling) {
-			if (is_cpu_exclusive(c))
-				cpus_andnot(cspan, cspan, c->cpus_allowed);
-		}
-	}
-
-	lock_cpu_hotplug();
-	partition_sched_domains(&pspan, &cspan);
-	unlock_cpu_hotplug();
-}
-
-/*
  * Call with manage_mutex held.  May take callback_mutex during call.
  */
 
 static int update_cpumask(struct cpuset *cs, char *buf)
 {
 	struct cpuset trialcs;
-	int retval, cpus_unchanged;
+	int retval;
 
 	/* top_cpuset.cpus_allowed tracks cpu_online_map; it's read-only */
 	if (cs == &top_cpuset)
@@ -843,12 +788,9 @@ static int update_cpumask(struct cpuset 
 	retval = validate_change(cs, &trialcs);
 	if (retval < 0)
 		return retval;
-	cpus_unchanged = cpus_equal(cs->cpus_allowed, trialcs.cpus_allowed);
 	mutex_lock(&callback_mutex);
 	cs->cpus_allowed = trialcs.cpus_allowed;
 	mutex_unlock(&callback_mutex);
-	if (is_cpu_exclusive(cs) && !cpus_unchanged)
-		update_cpu_domains(cs);
 	return 0;
 }
 
@@ -1085,7 +1027,7 @@ static int update_flag(cpuset_flagbits_t
 {
 	int turning_on;
 	struct cpuset trialcs;
-	int err, cpu_exclusive_changed;
+	int err;
 
 	turning_on = (simple_strtoul(buf, NULL, 10) != 0);
 
@@ -1098,14 +1040,10 @@ static int update_flag(cpuset_flagbits_t
 	err = validate_change(cs, &trialcs);
 	if (err < 0)
 		return err;
-	cpu_exclusive_changed =
-		(is_cpu_exclusive(cs) != is_cpu_exclusive(&trialcs));
 	mutex_lock(&callback_mutex);
 	cs->flags = trialcs.flags;
 	mutex_unlock(&callback_mutex);
 
-	if (cpu_exclusive_changed)
-                update_cpu_domains(cs);
 	return 0;
 }
 
@@ -1965,17 +1903,6 @@ static int cpuset_mkdir(struct inode *di
 	return cpuset_create(c_parent, dentry->d_name.name, mode | S_IFDIR);
 }
 
-/*
- * Locking note on the strange update_flag() call below:
- *
- * If the cpuset being removed is marked cpu_exclusive, then simulate
- * turning cpu_exclusive off, which will call update_cpu_domains().
- * The lock_cpu_hotplug() call in update_cpu_domains() must not be
- * made while holding callback_mutex.  Elsewhere the kernel nests
- * callback_mutex inside lock_cpu_hotplug() calls.  So the reverse
- * nesting would risk an ABBA deadlock.
- */
-
 static int cpuset_rmdir(struct inode *unused_dir, struct dentry *dentry)
 {
 	struct cpuset *cs = dentry->d_fsdata;
@@ -1995,13 +1922,6 @@ static int cpuset_rmdir(struct inode *un
 		mutex_unlock(&manage_mutex);
 		return -EBUSY;
 	}
-	if (is_cpu_exclusive(cs)) {
-		int retval = update_flag(CS_CPU_EXCLUSIVE, cs, "0");
-		if (retval < 0) {
-			mutex_unlock(&manage_mutex);
-			return retval;
-		}
-	}
 	parent = cs->parent;
 	mutex_lock(&callback_mutex);
 	set_bit(CS_REMOVED, &cs->flags);
diff -puN kernel/sched.c~cpuset-remove-sched-domain-hooks-from-cpusets kernel/sched.c
--- a/kernel/sched.c~cpuset-remove-sched-domain-hooks-from-cpusets
+++ a/kernel/sched.c
@@ -6348,35 +6348,6 @@ static void detach_destroy_domains(const
 	arch_destroy_sched_domains(cpu_map);
 }
 
-/*
- * Partition sched domains as specified by the cpumasks below.
- * This attaches all cpus from the cpumasks to the NULL domain,
- * waits for a RCU quiescent period, recalculates sched
- * domain information and then attaches them back to the
- * correct sched domains
- * Call with hotplug lock held
- */
-int partition_sched_domains(cpumask_t *partition1, cpumask_t *partition2)
-{
-	cpumask_t change_map;
-	int err = 0;
-
-	cpus_and(*partition1, *partition1, cpu_online_map);
-	cpus_and(*partition2, *partition2, cpu_online_map);
-	cpus_or(change_map, *partition1, *partition2);
-
-	/* Detach sched domains from all of the affected cpus */
-	detach_destroy_domains(&change_map);
-	if (!cpus_empty(*partition1))
-		err = build_sched_domains(partition1);
-	if (!err && !cpus_empty(*partition2))
-		err = build_sched_domains(partition2);
-
-	register_sched_domain_sysctl();
-
-	return err;
-}
-
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
 static int arch_reinit_sched_domains(void)
 {
_

Patches currently in -mm which might be from pj@sgi.com are

origin.patch
git-scsi-misc.patch
git-scsi-misc-include-fix.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-automatic-userspace-notification-of-idle-containers-fix.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
task-containers-enable-containers-by-default-in-some-configs.patch
whitespace-fixes-cpuset.patch
cpuset-sched_load_balance-flag.patch
cpuset-sched_load_balance-flag-fix.patch
cpusets-decrustify-cpuset-mask-update-code.patch
cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch
control-groups-replace-cont-with-cgrp-and-other-misc.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
