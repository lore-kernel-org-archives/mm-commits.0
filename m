From: akpm@linux-foundation.org
Subject: - cpusets-restructure-the-function-update_cpumask-and-update_nodemask.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:59:04 -0700
Message-ID: <200807252259.m6PMx44u003347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754703AbYGYW7m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:59:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miaox@cn.fujitsu.com, lizf@cn.fujitsu.com, pj@sgi.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     cpusets: restructure the function update_cpumask() and update_nodemask()
has been removed from the -mm tree.  Its filename was
     cpusets-restructure-the-function-update_cpumask-and-update_nodemask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets: restructure the function update_cpumask() and update_nodemask()
From: Miao Xie <miaox@cn.fujitsu.com>

Extract two functions from update_cpumask() and update_nodemask().They
will be used later for updating tasks' cpus_allowed and mems_allowed after
CPU/NODE offline/online.

[lizf@cn.fujitsu.com: build fix]
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Acked-by: Paul Jackson <pj@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc:  Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |  181 +++++++++++++++++++++++++++-------------------
 1 file changed, 109 insertions(+), 72 deletions(-)

diff -puN kernel/cpuset.c~cpusets-restructure-the-function-update_cpumask-and-update_nodemask kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-restructure-the-function-update_cpumask-and-update_nodemask
+++ a/kernel/cpuset.c
@@ -764,6 +764,37 @@ static void cpuset_change_cpumask(struct
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
@@ -771,8 +802,6 @@ static void cpuset_change_cpumask(struct
 static int update_cpumask(struct cpuset *cs, const char *buf)
 {
 	struct cpuset trialcs;
-	struct cgroup_scanner scan;
-	struct ptr_heap heap;
 	int retval;
 	int is_load_balanced;
 
@@ -806,10 +835,6 @@ static int update_cpumask(struct cpuset 
 	if (cpus_equal(cs->cpus_allowed, trialcs.cpus_allowed))
 		return 0;
 
-	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, &started_after);
-	if (retval)
-		return retval;
-
 	is_load_balanced = is_sched_load_balance(&trialcs);
 
 	mutex_lock(&callback_mutex);
@@ -820,12 +845,9 @@ static int update_cpumask(struct cpuset 
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
@@ -881,73 +903,25 @@ static void cpuset_migrate_mm(struct mm_
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
 
-static int update_nodemask(struct cpuset *cs, const char *buf)
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
 
@@ -1014,7 +988,7 @@ static int update_nodemask(struct cpuset
 
 		mpol_rebind_mm(mm, &cs->mems_allowed);
 		if (migrate)
-			cpuset_migrate_mm(mm, &oldmem, &cs->mems_allowed);
+			cpuset_migrate_mm(mm, oldmem, &cs->mems_allowed);
 		mmput(mm);
 	}
 
@@ -1026,6 +1000,70 @@ done:
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
+static int update_nodemask(struct cpuset *cs, const char *buf)
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
+	if (!*buf) {
+		nodes_clear(trialcs.mems_allowed);
+	} else {
+		retval = nodelist_parse(buf, trialcs.mems_allowed);
+		if (retval < 0)
+			goto done;
+
+		if (!nodes_subset(trialcs.mems_allowed,
+				node_states[N_HIGH_MEMORY]))
+			return -EINVAL;
+	}
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
@@ -1935,7 +1973,6 @@ void __init cpuset_init_smp(void)
 }
 
 /**
