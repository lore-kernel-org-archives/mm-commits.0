From: akpm@linux-foundation.org
Subject: + hotplug-cpu-move-tasks-in-empty-cpusets-to-parent.patch added to -mm tree
Date: Wed, 09 Jan 2008 22:44:49 -0800
Message-ID: <200801100644.m0A6iTIL009366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43474 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752360AbYAJGoj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 01:44:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cpw@sgi.com, menage@google.com, pj@sgi.com, rientjes@google.com


The patch titled
     hotplug cpu: move tasks in empty cpusets to parent
has been added to the -mm tree.  Its filename is
     hotplug-cpu-move-tasks-in-empty-cpusets-to-parent.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hotplug cpu: move tasks in empty cpusets to parent
From: Cliff Wickman <cpw@sgi.com>

This patch corrects a situation that occurs when one disables all the cpus in
a cpuset.

Currently, the disabled (cpu-less) cpuset inherits the cpus of its parent,
which is incorrect because it may then overlap its cpu-exclusive sibling.

Tasks of an empty cpuset should be moved to the cpuset which is the parent of
their current cpuset.  Or if the parent cpuset has no cpus, to its parent,
etc.

And the empty cpuset should be released (if it is flagged notify_on_release).

Depends on the cgroup_scan_tasks() function (proposed by David Rientjes) to
iterate through all tasks in the cpu-less cpuset.  We are deliberately
avoiding a walk of the tasklist.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    1 
 kernel/cgroup.c        |   22 ++---
 kernel/cpuset.c        |  168 ++++++++++++++++++++++++++++++---------
 3 files changed, 145 insertions(+), 46 deletions(-)

diff -puN include/linux/cgroup.h~hotplug-cpu-move-tasks-in-empty-cpusets-to-parent include/linux/cgroup.h
--- a/include/linux/cgroup.h~hotplug-cpu-move-tasks-in-empty-cpusets-to-parent
+++ a/include/linux/cgroup.h
@@ -317,6 +317,7 @@ struct task_struct *cgroup_iter_next(str
 					struct cgroup_iter *it);
 void cgroup_iter_end(struct cgroup *cont, struct cgroup_iter *it);
 int cgroup_scan_tasks(struct cgroup_scanner *scan);
+int cgroup_attach_task(struct cgroup *, struct task_struct *);
 
 #else /* !CONFIG_CGROUPS */
 
diff -puN kernel/cgroup.c~hotplug-cpu-move-tasks-in-empty-cpusets-to-parent kernel/cgroup.c
--- a/kernel/cgroup.c~hotplug-cpu-move-tasks-in-empty-cpusets-to-parent
+++ a/kernel/cgroup.c
@@ -489,7 +489,7 @@ static struct css_set *find_css_set(
  * Any task can increment and decrement the count field without lock.
  * So in general, code holding cgroup_mutex can't rely on the count
  * field not changing.  However, if the count goes to zero, then only
- * attach_task() can increment it again.  Because a count of zero
+ * cgroup_attach_task() can increment it again.  Because a count of zero
  * means that no tasks are currently attached, therefore there is no
  * way a task attached to that cgroup can fork (the other way to
  * increment the count).  So code holding cgroup_mutex can safely
@@ -520,17 +520,17 @@ static struct css_set *find_css_set(
  *	The task_lock() exception
  *
  * The need for this exception arises from the action of
- * attach_task(), which overwrites one tasks cgroup pointer with
+ * cgroup_attach_task(), which overwrites one tasks cgroup pointer with
  * another.  It does so using cgroup_mutexe, however there are
  * several performance critical places that need to reference
  * task->cgroup without the expense of grabbing a system global
  * mutex.  Therefore except as noted below, when dereferencing or, as
- * in attach_task(), modifying a task'ss cgroup pointer we use
+ * in cgroup_attach_task(), modifying a task'ss cgroup pointer we use
  * task_lock(), which acts on a spinlock (task->alloc_lock) already in
  * the task_struct routinely used for such matters.
  *
  * P.S.  One more locking exception.  RCU is used to guard the
- * update of a tasks cgroup pointer by attach_task()
+ * update of a tasks cgroup pointer by cgroup_attach_task()
  */
 
 /**
@@ -1194,7 +1194,7 @@ static void get_first_subsys(const struc
  * Call holding cgroup_mutex.  May take task_lock of
  * the task 'pid' during call.
  */
-static int attach_task(struct cgroup *cgrp, struct task_struct *tsk)
+int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 {
 	int retval = 0;
 	struct cgroup_subsys *ss;
@@ -1287,7 +1287,7 @@ static int attach_task_by_pid(struct cgr
 		get_task_struct(tsk);
 	}
 
-	ret = attach_task(cgrp, tsk);
+	ret = cgroup_attach_task(cgrp, tsk);
 	put_task_struct(tsk);
 	return ret;
 }
@@ -2514,7 +2514,7 @@ out:
  *  - Used for /proc/<pid>/cgroup.
  *  - No need to task_lock(tsk) on this tsk->cgroup reference, as it
  *    doesn't really matter if tsk->cgroup changes after we read it,
- *    and we take cgroup_mutex, keeping attach_task() from changing it
+ *    and we take cgroup_mutex, keeping cgroup_attach_task() from changing it
  *    anyway.  No need to check that tsk->cgroup != NULL, thanks to
  *    the_top_cgroup_hack in cgroup_exit(), which sets an exiting tasks
  *    cgroup to top_cgroup.
@@ -2625,7 +2625,7 @@ static struct file_operations proc_cgrou
  * A pointer to the shared css_set was automatically copied in
  * fork.c by dup_task_struct().  However, we ignore that copy, since
  * it was not made under the protection of RCU or cgroup_mutex, so
- * might no longer be a valid cgroup pointer.  attach_task() might
+ * might no longer be a valid cgroup pointer.  cgroup_attach_task() might
  * have already changed current->cgroups, allowing the previously
  * referenced cgroup group to be removed and freed.
  *
@@ -2704,8 +2704,8 @@ void cgroup_post_fork(struct task_struct
  *    attach us to a different cgroup, decrementing the count on
  *    the first cgroup that we never incremented.  But in this case,
  *    top_cgroup isn't going away, and either task has PF_EXITING set,
- *    which wards off any attach_task() attempts, or task is a failed
- *    fork, never visible to attach_task.
+ *    which wards off any cgroup_attach_task() attempts, or task is a failed
+ *    fork, never visible to cgroup_attach_task.
  *
  */
 void cgroup_exit(struct task_struct *tsk, int run_callbacks)
@@ -2845,7 +2845,7 @@ int cgroup_clone(struct task_struct *tsk
 	}
 
 	/* All seems fine. Finish by moving the task into the new cgroup */
-	ret = attach_task(child, tsk);
+	ret = cgroup_attach_task(child, tsk);
 	mutex_unlock(&cgroup_mutex);
 
  out_release:
diff -puN kernel/cpuset.c~hotplug-cpu-move-tasks-in-empty-cpusets-to-parent kernel/cpuset.c
--- a/kernel/cpuset.c~hotplug-cpu-move-tasks-in-empty-cpusets-to-parent
+++ a/kernel/cpuset.c
@@ -56,6 +56,8 @@
 #include <asm/atomic.h>
 #include <linux/mutex.h>
 #include <linux/kfifo.h>
+#include <linux/workqueue.h>
+#include <linux/cgroup.h>
 
 /*
  * Tracks how many cpusets are currently defined in system.
@@ -96,6 +98,9 @@ struct cpuset {
 
 	/* partition number for rebuild_sched_domains() */
 	int pn;
+
+	/* used for walking a cpuset heirarchy */
+	struct list_head stack_list;
 };
 
 /* Retrieve the cpuset for a cgroup */
@@ -111,7 +116,10 @@ static inline struct cpuset *task_cs(str
 	return container_of(task_subsys_state(task, cpuset_subsys_id),
 			    struct cpuset, css);
 }
-
+struct cpuset_hotplug_scanner {
+	struct cgroup_scanner scan;
+	struct cgroup *to;
+};
 
 /* bits in struct cpuset flags field */
 typedef enum {
@@ -1687,53 +1695,145 @@ int __init cpuset_init(void)
 	return 0;
 }
 
+/**
+ * cpuset_do_move_task - move a given task to another cpuset
+ * @tsk: pointer to task_struct the task to move
+ * @scan: struct cgroup_scanner contained in its struct cpuset_hotplug_scanner
+ *
+ * Called by cgroup_scan_tasks() for each task in a cgroup.
+ * Return nonzero to stop the walk through the tasks.
+ */
+void cpuset_do_move_task(struct task_struct *tsk, struct cgroup_scanner *scan)
+{
+	struct cpuset_hotplug_scanner *chsp;
+
+	chsp = container_of(scan, struct cpuset_hotplug_scanner, scan);
+	cgroup_attach_task(chsp->to, tsk);
+}
+
+/**
+ * move_member_tasks_to_cpuset - move tasks from one cpuset to another
+ * @from: cpuset in which the tasks currently reside
+ * @to: cpuset to which the tasks will be moved
+ *
+ * Called with manage_sem held
+ * callback_mutex must not be held, as attach_task() will take it.
+ *
+ * The cgroup_scan_tasks() function will scan all the tasks in a cgroup,
+ * calling callback functions for each.
+ */
+static void move_member_tasks_to_cpuset(struct cpuset *from, struct cpuset *to)
+{
+	struct cpuset_hotplug_scanner scan;
+
+	scan.scan.cg = from->css.cgroup;
+	scan.scan.test_task = NULL; /* select all tasks in cgroup */
+	scan.scan.process_task = cpuset_do_move_task;
+	scan.scan.heap = NULL;
+	scan.to = to->css.cgroup;
+
+	if (cgroup_scan_tasks((struct cgroup_scanner *)&scan))
+		printk(
+		"move_member_tasks_to_cpuset: cgroup_scan_tasks failed\n");
+}
+
 /*
  * If common_cpu_mem_hotplug_unplug(), below, unplugs any CPUs
  * or memory nodes, we need to walk over the cpuset hierarchy,
  * removing that CPU or node from all cpusets.  If this removes the
- * last CPU or node from a cpuset, then the guarantee_online_cpus()
- * or guarantee_online_mems() code will use that emptied cpusets
- * parent online CPUs or nodes.  Cpusets that were already empty of
- * CPUs or nodes are left empty.
- *
- * This routine is intentionally inefficient in a couple of regards.
- * It will check all cpusets in a subtree even if the top cpuset of
- * the subtree has no offline CPUs or nodes.  It checks both CPUs and
- * nodes, even though the caller could have been coded to know that
- * only one of CPUs or nodes needed to be checked on a given call.
- * This was done to minimize text size rather than cpu cycles.
+ * last CPU or node from a cpuset, then move the tasks in the empty
+ * cpuset to its next-highest non-empty parent.
  *
- * Call with both manage_mutex and callback_mutex held.
+ * The parent cpuset has some superset of the 'mems' nodes that the
+ * newly empty cpuset held, so no migration of memory is necessary.
  *
- * Recursive, on depth of cpuset subtree.
+ * Called with both manage_sem and callback_sem held
  */
+static void remove_tasks_in_empty_cpuset(struct cpuset *cs)
+{
+	struct cpuset *parent;
+
+	/* the cgroup's css_sets list is in use if there are tasks
+	   in the cpuset; the list is empty if there are none;
+	   the cs->css.refcnt seems always 0 */
+	if (list_empty(&cs->css.cgroup->css_sets))
+		return;
 
-static void guarantee_online_cpus_mems_in_subtree(const struct cpuset *cur)
+	/*
+	 * Find its next-highest non-empty parent, (top cpuset
+	 * has online cpus, so can't be empty).
+	 */
+	parent = cs->parent;
+	while (cpus_empty(parent->cpus_allowed)) {
+		/*
+		 * this empty cpuset should now be considered to
+		 * have been used, and therefore eligible for
+		 * release when empty (if it is notify_on_release)
+		 */
+		parent = parent->parent;
+	}
+
+	move_member_tasks_to_cpuset(cs, parent);
+}
+
+/*
+ * Walk the specified cpuset subtree and look for empty cpusets.
+ * The tasks of such cpuset must be moved to a parent cpuset.
+ *
+ * Note that such a notify_on_release cpuset must have had, at some time,
+ * member tasks or cpuset descendants and cpus and memory, before it can
+ * be a candidate for release.
+ *
+ * Called with manage_mutex held.  We take callback_mutex to modify
+ * cpus_allowed and mems_allowed.
+ *
+ * This walk processes the tree from top to bottom, completing one layer
+ * before dropping down to the next.  It always processes a node before
+ * any of its children.
+ *
+ * For now, since we lack memory hot unplug, we'll never see a cpuset
+ * that has tasks along with an empty 'mems'.  But if we did see such
+ * a cpuset, we'd handle it just like we do if its 'cpus' was empty.
+ */
+static void scan_for_empty_cpusets(const struct cpuset *root)
 {
+	struct cpuset *cp;	/* scans cpusets being updated */
+	struct cpuset *child;	/* scans child cpusets of cp */
+	struct list_head queue;
 	struct cgroup *cont;
-	struct cpuset *c;
 
-	/* Each of our child cpusets mems must be online */
-	list_for_each_entry(cont, &cur->css.cgroup->children, sibling) {
-		c = cgroup_cs(cont);
-		guarantee_online_cpus_mems_in_subtree(c);
-		if (!cpus_empty(c->cpus_allowed))
-			guarantee_online_cpus(c, &c->cpus_allowed);
-		if (!nodes_empty(c->mems_allowed))
-			guarantee_online_mems(c, &c->mems_allowed);
+	INIT_LIST_HEAD(&queue);
+
+	list_add_tail((struct list_head *)&root->stack_list, &queue);
+
+	mutex_lock(&callback_mutex);
+	while (!list_empty(&queue)) {
+		cp = container_of(queue.next, struct cpuset, stack_list);
+		list_del(queue.next);
+		list_for_each_entry(cont, &cp->css.cgroup->children, sibling) {
+			child = cgroup_cs(cont);
+			list_add_tail(&child->stack_list, &queue);
+		}
+		cont = cp->css.cgroup;
+		/* Remove offline cpus and mems from this cpuset. */
+		cpus_and(cp->cpus_allowed, cp->cpus_allowed, cpu_online_map);
+		nodes_and(cp->mems_allowed, cp->mems_allowed, node_online_map);
+		if ((cpus_empty(cp->cpus_allowed) ||
+		     nodes_empty(cp->mems_allowed))) {
+		        /* Move tasks from the empty cpuset to a parent */
+			mutex_unlock(&callback_mutex);
+			remove_tasks_in_empty_cpuset(cp);
+			mutex_lock(&callback_mutex);
+		}
 	}
+	mutex_unlock(&callback_mutex);
+	return;
 }
 
 /*
  * The cpus_allowed and mems_allowed nodemasks in the top_cpuset track
- * cpu_online_map and node_states[N_HIGH_MEMORY].  Force the top cpuset to
- * track what's online after any CPU or memory node hotplug or unplug
- * event.
- *
- * To ensure that we don't remove a CPU or node from the top cpuset
- * that is currently in use by a child cpuset (which would violate
- * the rule that cpusets must be subsets of their parent), we first
- * call the recursive routine guarantee_online_cpus_mems_in_subtree().
+ * cpu_online_map and node_online_map.  Force the top cpuset to track
+ * whats online after any CPU or memory node hotplug or unplug event.
  *
  * Since there are two callers of this routine, one for CPU hotplug
  * events and one for memory node hotplug events, we could have coded
@@ -1744,13 +1844,11 @@ static void guarantee_online_cpus_mems_i
 static void common_cpu_mem_hotplug_unplug(void)
 {
 	cgroup_lock();
-	mutex_lock(&callback_mutex);
 
-	guarantee_online_cpus_mems_in_subtree(&top_cpuset);
 	top_cpuset.cpus_allowed = cpu_online_map;
 	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
+	scan_for_empty_cpusets(&top_cpuset);
 
-	mutex_unlock(&callback_mutex);
 	cgroup_unlock();
 }
 
_

Patches currently in -mm which might be from cpw@sgi.com are

cgroups-mechanism-to-process-each-task-in-a-cgroup.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-cleanup.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes.patch
cpusets-update_cpumask-revision.patch
cpusets-update_cpumask-revision-checkpatch-fixes.patch
