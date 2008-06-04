From: akpm@linux-foundation.org
Subject: - cpusets-restructure-the-function-update_cpumask-and-update_nodemask.patch removed from -mm tree
Date: Tue, 03 Jun 2008 21:01:09 -0700
Message-ID: <200806040401.m54419nZ002759@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751284AbYFDEBR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 00:01:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miaox@cn.fujitsu.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     cpusets: restructure the function update_cpumask() and update_nodemask()
has been removed from the -mm tree.  Its filename was
     cpusets-restructure-the-function-update_cpumask-and-update_nodemask.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets: restructure the function update_cpumask() and update_nodemask()
From: Miao Xie <miaox@cn.fujitsu.com>

extract two functions from update_cpumask() and update_nodemask().They
will be used later for updating tasks' cpus_allowed and mems_allowed after
CPU/NODE offline/online.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Acked-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |  181 +++++++++++++++++++++++++++-------------------
 1 file changed, 108 insertions(+), 73 deletions(-)

diff -puN kernel/cpuset.c~cpusets-restructure-the-function-update_cpumask-and-update_nodemask kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-restructure-the-function-update_cpumask-and-update_nodemask
+++ a/kernel/cpuset.c
@@ -766,6 +766,37 @@ static void cpuset_change_cpumask(struct
 }
 
 /**
+ * update_tasks_cpumask - Update the cpumasks of tasks in the cpuset.
+ * @cs: the cpuset in which each task's cpus_allowed mask needs to be changed
+ *
+ * Called with cgroup_mutex held
+ *
+ * The cgroup_scan_tasks() function will scan all the tasks in a cgroup,
+ * calling callback functions for each.
+ *
+ * Return 0 if successful, -errno if not.
+ */
+static int update_tasks_cpumask(struct cpuset *cs)
+{
+	struct cgroup_scanner scan;
+	struct ptr_heap heap;
+	int retval;
+
+	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, &started_after);
+	if (retval)
+		return retval;
+
+	scan.cg = cs->css.cgroup;
+	scan.test_task = cpuset_test_cpumask;
+	scan.process_task = cpuset_change_cpumask;
+	scan.heap = &heap;
+	retval = cgroup_scan_tasks(&scan);
+
+	heap_free(&heap);
+	return retval;
+}
+
+/**
  * update_cpumask - update the cpus_allowed mask of a cpuset and all tasks in it
  * @cs: the cpuset to consider
  * @buf: buffer of cpu numbers written to this cpuset
@@ -773,8 +804,6 @@ static void cpuset_change_cpumask(struct
 static int update_cpumask(struct cpuset *cs, char *buf)
 {
 	struct cpuset trialcs;
-	struct cgroup_scanner scan;
-	struct ptr_heap heap;
 	int retval;
 	int is_load_balanced;
 
@@ -809,10 +838,6 @@ static int update_cpumask(struct cpuset 
 	if (cpus_equal(cs->cpus_allowed, trialcs.cpus_allowed))
 		return 0;
 
-	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, &started_after);
-	if (retval)
-		return retval;
-
 	is_load_balanced = is_sched_load_balance(&trialcs);
 
 	mutex_lock(&callback_mutex);
@@ -823,12 +848,9 @@ static int update_cpumask(struct cpuset 
 	 * Scan tasks in the cpuset, and update the cpumasks of any
 	 * that need an update.
 	 */
-	scan.cg = cs->css.cgroup;
-	scan.test_task = cpuset_test_cpumask;
-	scan.process_task = cpuset_change_cpumask;
-	scan.heap = &heap;
-	cgroup_scan_tasks(&scan);
-	heap_free(&heap);
+	retval = update_tasks_cpumask(cs);
+	if (retval < 0)
+		return retval;
 
 	if (is_load_balanced)
 		rebuild_sched_domains();
@@ -884,74 +906,25 @@ static void cpuset_migrate_mm(struct mm_
 	mutex_unlock(&callback_mutex);
 }
 
-/*
- * Handle user request to change the 'mems' memory placement
- * of a cpuset.  Needs to validate the request, update the
- * cpusets mems_allowed and mems_generation, and for each
- * task in the cpuset, rebind any vma mempolicies and if
- * the cpuset is marked 'memory_migrate', migrate the tasks
- * pages to the new memory.
- *
- * Call with cgroup_mutex held.  May take callback_mutex during call.
- * Will take tasklist_lock, scan tasklist for tasks in cpuset cs,
- * lock each such tasks mm->mmap_sem, scan its vma's and rebind
- * their mempolicies to the cpusets new mems_allowed.
- */
-
 static void *cpuset_being_rebound;
 
-static int update_nodemask(struct cpuset *cs, char *buf)
+/**
+ * update_tasks_nodemask - Update the nodemasks of tasks in the cpuset.
+ * @cs: the cpuset in which each task's mems_allowed mask needs to be changed
+ * @oldmem: old mems_allowed of cpuset cs
+ *
+ * Called with cgroup_mutex held
+ * Return 0 if successful, -errno if not.
+ */
+static int update_tasks_nodemask(struct cpuset *cs, const nodemask_t *oldmem)
 {
-	struct cpuset trialcs;
-	nodemask_t oldmem;
 	struct task_struct *p;
 	struct mm_struct **mmarray;
 	int i, n, ntasks;
 	int migrate;
 	int fudge;
-	int retval;
 	struct cgroup_iter it;
-
-	/*
-	 * top_cpuset.mems_allowed tracks node_stats[N_HIGH_MEMORY];
-	 * it's read-only
-	 */
-	if (cs == &top_cpuset)
-		return -EACCES;
-
-	trialcs = *cs;
-
-	/*
-	 * An empty mems_allowed is ok iff there are no tasks in the cpuset.
-	 * Since nodelist_parse() fails on an empty mask, we special case
-	 * that parsing.  The validate_change() call ensures that cpusets
-	 * with tasks have memory.
-	 */
-	buf = strstrip(buf);
-	if (!*buf) {
-		nodes_clear(trialcs.mems_allowed);
-	} else {
-		retval = nodelist_parse(buf, trialcs.mems_allowed);
-		if (retval < 0)
-			goto done;
-
-		if (!nodes_subset(trialcs.mems_allowed,
-				node_states[N_HIGH_MEMORY]))
-			return -EINVAL;
-	}
-	oldmem = cs->mems_allowed;
-	if (nodes_equal(oldmem, trialcs.mems_allowed)) {
-		retval = 0;		/* Too easy - nothing to do */
-		goto done;
-	}
-	retval = validate_change(cs, &trialcs);
-	if (retval < 0)
-		goto done;
-
-	mutex_lock(&callback_mutex);
-	cs->mems_allowed = trialcs.mems_allowed;
-	cs->mems_generation = cpuset_mems_generation++;
-	mutex_unlock(&callback_mutex);
+	int retval;
 
 	cpuset_being_rebound = cs;		/* causes mpol_dup() rebind */
 
@@ -1018,7 +991,7 @@ static int update_nodemask(struct cpuset
 
 		mpol_rebind_mm(mm, &cs->mems_allowed);
 		if (migrate)
-			cpuset_migrate_mm(mm, &oldmem, &cs->mems_allowed);
+			cpuset_migrate_mm(mm, oldmem, &cs->mems_allowed);
 		mmput(mm);
 	}
 
@@ -1030,6 +1003,69 @@ done:
 	return retval;
 }
 
+/*
+ * Handle user request to change the 'mems' memory placement
+ * of a cpuset.  Needs to validate the request, update the
+ * cpusets mems_allowed and mems_generation, and for each
+ * task in the cpuset, rebind any vma mempolicies and if
+ * the cpuset is marked 'memory_migrate', migrate the tasks
+ * pages to the new memory.
+ *
+ * Call with cgroup_mutex held.  May take callback_mutex during call.
+ * Will take tasklist_lock, scan tasklist for tasks in cpuset cs,
+ * lock each such tasks mm->mmap_sem, scan its vma's and rebind
+ * their mempolicies to the cpusets new mems_allowed.
+ */
+static int update_nodemask(struct cpuset *cs, char *buf)
+{
+	struct cpuset trialcs;
+	nodemask_t oldmem;
+	int retval;
+
+	/*
+	 * top_cpuset.mems_allowed tracks node_stats[N_HIGH_MEMORY];
+	 * it's read-only
+	 */
+	if (cs == &top_cpuset)
+		return -EACCES;
+
+	trialcs = *cs;
+
+	/*
+	 * An empty mems_allowed is ok iff there are no tasks in the cpuset.
+	 * Since nodelist_parse() fails on an empty mask, we special case
+	 * that parsing.  The validate_change() call ensures that cpusets
+	 * with tasks have memory.
+	 */
+	buf = strstrip(buf);
+	if (!*buf) {
+		nodes_clear(trialcs.mems_allowed);
+	} else {
+		retval = nodelist_parse(buf, trialcs.mems_allowed);
+		if (retval < 0)
+			goto done;
+	}
+	nodes_and(trialcs.mems_allowed, trialcs.mems_allowed,
+						node_states[N_HIGH_MEMORY]);
+	oldmem = cs->mems_allowed;
+	if (nodes_equal(oldmem, trialcs.mems_allowed)) {
+		retval = 0;		/* Too easy - nothing to do */
+		goto done;
+	}
+	retval = validate_change(cs, &trialcs);
+	if (retval < 0)
+		goto done;
+
+	mutex_lock(&callback_mutex);
+	cs->mems_allowed = trialcs.mems_allowed;
+	cs->mems_generation = cpuset_mems_generation++;
+	mutex_unlock(&callback_mutex);
+
+	retval = update_tasks_nodemask(cs, &oldmem);
+done:
+	return retval;
+}
+
 int current_cpuset_is_being_rebound(void)
 {
 	return task_cs(current) == cpuset_being_rebound;
@@ -1942,7 +1978,6 @@ void __init cpuset_init_smp(void)
 }
 
 /**
