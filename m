From: akpm@linux-foundation.org
Subject: + cpusets-update_cpumask-revision.patch added to -mm tree
Date: Wed, 09 Jan 2008 22:44:53 -0800
Message-ID: <200801100644.m0A6iXj8009372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41646 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752379AbYAJGok (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 01:44:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cpw@sgi.com, menage@google.com, pj@sgi.com, rientjes@google.com


The patch titled
     cpusets: update_cpumask revision
has been added to the -mm tree.  Its filename is
     cpusets-update_cpumask-revision.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets: update_cpumask revision
From: Cliff Wickman <cpw@sgi.com>

Use the new function cgroup_scan_tasks() to step through all tasks in a
cpuset.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |  107 +++++++++++++++++++---------------------------
 1 file changed, 45 insertions(+), 62 deletions(-)

diff -puN kernel/cpuset.c~cpusets-update_cpumask-revision kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-update_cpumask-revision
+++ a/kernel/cpuset.c
@@ -38,7 +38,6 @@
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/pagemap.h>
-#include <linux/prio_heap.h>
 #include <linux/proc_fs.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
@@ -740,22 +739,49 @@ static inline int started_after(void *p1
 	return started_after_time(t1, &t2->start_time, t2);
 }
 
-/*
+/**
+ * cpuset_test_cpumask - test a task's cpus_allowed versus its cpuset's
+ * @tsk: task to test
+ * @scan: struct cgroup_scanner contained in its struct cpuset_hotplug_scanner
+ *
  * Call with manage_mutex held.  May take callback_mutex during call.
+ * Called for each task in a cgroup by cgroup_scan_tasks().
+ * Return nonzero if this tasks's cpus_allowed mask should be changed (in other
+ * words, if its mask is not equal to its cpuset's mask).
  */
+int cpuset_test_cpumask(struct task_struct *tsk, struct cgroup_scanner *scan)
+{
+	return !cpus_equal(tsk->cpus_allowed, (cgroup_cs(scan->cg))->cpus_allowed);
+}
 
+/**
+ * cpuset_change_cpumask - make a task's cpus_allowed the same as its cpuset's
+ * @tsk: task to test
+ * @scan: struct cgroup_scanner containing the cgroup of the task
+ *
+ * Called by cgroup_scan_tasks() for each task in a cgroup whose
+ * cpus_allowed mask needs to be changed.
+ *
+ * We don't need to re-check for the cgroup/cpuset membership, since we're
+ * holding cgroup_lock() at this point.
+ */
+void cpuset_change_cpumask(struct task_struct *tsk, struct cgroup_scanner *scan)
+{
+	set_cpus_allowed(tsk, (cgroup_cs(scan->cg))->cpus_allowed);
+}
+
+/**
+ * update_cpumask - update the cpus_allowed mask of a cpuset and all tasks in it
+ * @cs: the cpuset to consider
+ * @buf: buffer of cpu numbers written to this cpuset
+ */
 static int update_cpumask(struct cpuset *cs, char *buf)
 {
 	struct cpuset trialcs;
-	int retval, i;
-	int is_load_balanced;
-	struct cgroup_iter it;
-	struct cgroup *cgrp = cs->css.cgroup;
-	struct task_struct *p, *dropped;
-	/* Never dereference latest_task, since it's not refcounted */
-	struct task_struct *latest_task = NULL;
+	struct cgroup_scanner scan;
 	struct ptr_heap heap;
-	struct timespec latest_time = { 0, 0 };
+	int retval;
+	int is_load_balanced;
 
 	/* top_cpuset.cpus_allowed tracks cpu_online_map; it's read-only */
 	if (cs == &top_cpuset)
@@ -764,7 +790,7 @@ static int update_cpumask(struct cpuset 
 	trialcs = *cs;
 
 	/*
-	 * An empty cpus_allowed is ok iff there are no tasks in the cpuset.
+	 * An empty cpus_allowed is ok if there are no tasks in the cpuset.
 	 * Since cpulist_parse() fails on an empty mask, we special case
 	 * that parsing.  The validate_change() call ensures that cpusets
 	 * with tasks have cpus.
@@ -785,6 +811,7 @@ static int update_cpumask(struct cpuset 
 	/* Nothing to do if the cpus didn't change */
 	if (cpus_equal(cs->cpus_allowed, trialcs.cpus_allowed))
 		return 0;
+
 	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, &started_after);
 	if (retval)
 		return retval;
@@ -795,62 +822,18 @@ static int update_cpumask(struct cpuset 
 	cs->cpus_allowed = trialcs.cpus_allowed;
 	mutex_unlock(&callback_mutex);
 
- again:
 	/*
 	 * Scan tasks in the cpuset, and update the cpumasks of any
-	 * that need an update. Since we can't call set_cpus_allowed()
-	 * while holding tasklist_lock, gather tasks to be processed
-	 * in a heap structure. If the statically-sized heap fills up,
-	 * overflow tasks that started later, and in future iterations
-	 * only consider tasks that started after the latest task in
-	 * the previous pass. This guarantees forward progress and
-	 * that we don't miss any tasks
+	 * that need an update.
 	 */
-	heap.size = 0;
-	cgroup_iter_start(cgrp, &it);
-	while ((p = cgroup_iter_next(cgrp, &it))) {
-		/* Only affect tasks that don't have the right cpus_allowed */
-		if (cpus_equal(p->cpus_allowed, cs->cpus_allowed))
-			continue;
-		/*
-		 * Only process tasks that started after the last task
-		 * we processed
-		 */
-		if (!started_after_time(p, &latest_time, latest_task))
-			continue;
-		dropped = heap_insert(&heap, p);
-		if (dropped == NULL) {
-			get_task_struct(p);
-		} else if (dropped != p) {
-			get_task_struct(p);
-			put_task_struct(dropped);
-		}
-	}
-	cgroup_iter_end(cgrp, &it);
-	if (heap.size) {
-		for (i = 0; i < heap.size; i++) {
-			struct task_struct *p = heap.ptrs[i];
-			if (i == 0) {
-				latest_time = p->start_time;
-				latest_task = p;
-			}
-			set_cpus_allowed(p, cs->cpus_allowed);
-			put_task_struct(p);
-		}
-		/*
-		 * If we had to process any tasks at all, scan again
-		 * in case some of them were in the middle of forking
-		 * children that didn't notice the new cpumask
-		 * restriction.  Not the most efficient way to do it,
-		 * but it avoids having to take callback_mutex in the
-		 * fork path
-		 */
-		goto again;
-	}
-	heap_free(&heap);
+	scan.cg = cs->css.cgroup;
+	scan.test_task = cpuset_test_cpumask;
+	scan.process_task = cpuset_change_cpumask;
+	scan.heap = &heap;
+	cgroup_scan_tasks(&scan);
+
 	if (is_load_balanced)
 		rebuild_sched_domains();
-
 	return 0;
 }
 
_

Patches currently in -mm which might be from cpw@sgi.com are

cgroups-mechanism-to-process-each-task-in-a-cgroup.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-cleanup.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes.patch
cpusets-update_cpumask-revision.patch
cpusets-update_cpumask-revision-checkpatch-fixes.patch
