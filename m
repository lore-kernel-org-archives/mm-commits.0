From: akpm@linux-foundation.org
Subject: + cgroups-mechanism-to-process-each-task-in-a-cgroup.patch added to -mm tree
Date: Wed, 09 Jan 2008 22:44:45 -0800
Message-ID: <200801100644.m0A6iPeW009360@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57775 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751AbYAJGog (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 01:44:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cpw@sgi.com, menage@google.com, pj@sgi.com, rientjes@google.com


The patch titled
     cgroups: mechanism to process each task in a cgroup
has been added to the -mm tree.  Its filename is
     cgroups-mechanism-to-process-each-task-in-a-cgroup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: mechanism to process each task in a cgroup
From: Cliff Wickman <cpw@sgi.com>

Provide cgroup_scan_tasks(), which iterates through every task in a cgroup,
calling a test function and a process function for each.  And call the process
function without holding the css_set_lock lock.

The idea is David Rientjes', predicting that such a function will make it much
easier in the future to extend things that require access to each task in a
cgroup without holding the lock,

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |   13 ++
 kernel/cgroup.c        |  198 ++++++++++++++++++++++++++++++++++++---
 2 files changed, 199 insertions(+), 12 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-mechanism-to-process-each-task-in-a-cgroup include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-mechanism-to-process-each-task-in-a-cgroup
+++ a/include/linux/cgroup.h
@@ -14,6 +14,7 @@
 #include <linux/nodemask.h>
 #include <linux/rcupdate.h>
 #include <linux/cgroupstats.h>
+#include <linux/prio_heap.h>
 
 #ifdef CONFIG_CGROUPS
 
@@ -207,6 +208,13 @@ struct cftype {
 	int (*release) (struct inode *inode, struct file *file);
 };
 
+struct cgroup_scanner {
+	struct cgroup *cg;
+	int (*test_task)(struct task_struct *p, struct cgroup_scanner *scan);
+	void (*process_task)(struct task_struct *p, struct cgroup_scanner *scan);
+	struct ptr_heap *heap;
+};
+
 /* Add a new file to the given cgroup directory. Should only be
  * called by subsystems from within a populate() method */
 int cgroup_add_file(struct cgroup *cont, struct cgroup_subsys *subsys,
@@ -299,11 +307,16 @@ struct cgroup_iter {
  *    returns NULL or until you want to end the iteration
  *
  * 3) call cgroup_iter_end() to destroy the iterator.
+ *
+ * Or, call cgroup_scan_tasks() to iterate through every task in a cpuset.
+ *    - cgroup_scan_tasks() holds the css_set_lock when calling the test_task()
+ *      callback, but not while calling the process_task() callback.
  */
 void cgroup_iter_start(struct cgroup *cont, struct cgroup_iter *it);
 struct task_struct *cgroup_iter_next(struct cgroup *cont,
 					struct cgroup_iter *it);
 void cgroup_iter_end(struct cgroup *cont, struct cgroup_iter *it);
+int cgroup_scan_tasks(struct cgroup_scanner *scan);
 
 #else /* !CONFIG_CGROUPS */
 
diff -puN kernel/cgroup.c~cgroups-mechanism-to-process-each-task-in-a-cgroup kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-mechanism-to-process-each-task-in-a-cgroup
+++ a/kernel/cgroup.c
@@ -1695,6 +1695,29 @@ static void cgroup_advance_iter(struct c
 	it->task = cg->tasks.next;
 }
 
+/*
+ * To reduce the fork() overhead for systems that are not actually
+ * using their cgroups capability, we don't maintain the lists running
+ * through each css_set to its tasks until we see the list actually
+ * used - in other words after the first call to cgroup_iter_start().
+ *
+ * The tasklist_lock is not held here, as do_each_thread() and
+ * while_each_thread() are protected by RCU.
+ */
+void cgroup_enable_task_cg_lists(void)
+{
+	struct task_struct *p, *g;
+	write_lock(&css_set_lock);
+	use_task_css_set_links = 1;
+ 	do_each_thread(g, p) {
+		task_lock(p);
+		if (list_empty(&p->cg_list))
+			list_add(&p->cg_list, &p->cgroups->tasks);
+		task_unlock(p);
+ 	} while_each_thread(g, p);
+	write_unlock(&css_set_lock);
+}
+
 void cgroup_iter_start(struct cgroup *cgrp, struct cgroup_iter *it)
 {
 	/*
@@ -1702,18 +1725,9 @@ void cgroup_iter_start(struct cgroup *cg
 	 * we need to enable the list linking each css_set to its
 	 * tasks, and fix up all existing tasks.
 	 */
-	if (!use_task_css_set_links) {
-		struct task_struct *p, *g;
-		write_lock(&css_set_lock);
-		use_task_css_set_links = 1;
- 		do_each_thread(g, p) {
-			task_lock(p);
-			if (list_empty(&p->cg_list))
-				list_add(&p->cg_list, &p->cgroups->tasks);
-			task_unlock(p);
- 		} while_each_thread(g, p);
-		write_unlock(&css_set_lock);
-	}
+	if (!use_task_css_set_links)
+		cgroup_enable_task_cg_lists();
+
 	read_lock(&css_set_lock);
 	it->cg_link = &cgrp->css_sets;
 	cgroup_advance_iter(cgrp, it);
@@ -1746,6 +1760,166 @@ void cgroup_iter_end(struct cgroup *cgrp
 	read_unlock(&css_set_lock);
 }
 
+static inline int started_after_time(struct task_struct *t1,
+				     struct timespec *time,
+				     struct task_struct *t2)
+{
+	int start_diff = timespec_compare(&t1->start_time, time);
+	if (start_diff > 0) {
+		return 1;
+	} else if (start_diff < 0) {
+		return 0;
+	} else {
+		/*
+		 * Arbitrarily, if two processes started at the same
+		 * time, we'll say that the lower pointer value
+		 * started first. Note that t2 may have exited by now
+		 * so this may not be a valid pointer any longer, but
+		 * that's fine - it still serves to distinguish
+		 * between two tasks started (effectively) simultaneously.
+		 */
+		return t1 > t2;
+	}
+}
+
+/*
+ * This function is a callback from heap_insert() and is used to order
+ * the heap.
+ * In this case we order the heap in descending task start time.
+ */
+static inline int started_after(void *p1, void *p2)
+{
+	struct task_struct *t1 = p1;
+	struct task_struct *t2 = p2;
+	return started_after_time(t1, &t2->start_time, t2);
+}
+
+/**
+ * cgroup_scan_tasks - iterate though all the tasks in a cgroup
+ * @scan: struct cgroup_scanner containing arguments for the scan
+ *
+ * Arguments include pointers to callback functions test_task() and
+ * process_task().
+ * Iterate through all the tasks in a cgroup, calling test_task() for each,
+ * and if it returns true, call process_task() for it also.
+ * The test_task pointer may be NULL, meaning always true (select all tasks).
+ * Effectively duplicates cgroup_iter_{start,next,end}()
+ * but does not lock css_set_lock for the call to process_task().
+ * The struct cgroup_scanner may be embedded in any structure of the caller's
+ * creation.
+ * It is guaranteed that process_task() will act on every task that
+ * is a member of the cgroup for the duration of this call. This
+ * function may or may not call process_task() for tasks that exit
+ * or move to a different cgroup during the call, or are forked or
+ * move into the cgroup during the call.
+ *
+ * Note that test_task() may be called with locks held, and may in some
+ * situations be called multiple times for the same task, so it should
+ * be cheap.
+ * If the heap pointer in the struct cgroup_scanner is non-NULL, a heap has been
+ * pre-allocated and will be used for heap operations (and its "gt" member will
+ * be overwritten), else a temporary heap will be used (allocation of which
+ * may cause this function to fail).
+ */
+int cgroup_scan_tasks(struct cgroup_scanner *scan)
+{
+	int retval, i;
+	struct cgroup_iter it;
+	struct task_struct *p, *dropped;
+	/* Never dereference latest_task, since it's not refcounted */
+	struct task_struct *latest_task = NULL;
+	struct ptr_heap tmp_heap;
+	struct ptr_heap *heap;
+	struct timespec latest_time = { 0, 0 };
+
+	if (scan->heap) {
+		/* The caller supplied our heap and pre-allocated its memory */
+		heap = scan->heap;
+		heap->gt = &started_after;
+	} else {
+		/* We need to allocate our own heap memory */
+		heap = &tmp_heap;
+		retval = heap_init(heap, PAGE_SIZE, GFP_KERNEL, &started_after);
+		if (retval)
+			/* cannot allocate the heap */
+			return retval;
+	}
+
+ again:
+	/*
+	 * Scan tasks in the cgroup, using the scanner's "test_task" callback
+	 * to determine which are of interest, and using the scanner's
+	 * "process_task" callback to process any of them that need an update.
+	 * Since we don't want to hold any locks during the task updates,
+	 * gather tasks to be processed in a heap structure.
+	 * The heap is sorted by descending task start time.
+	 * If the statically-sized heap fills up, we overflow tasks that
+	 * started later, and in future iterations only consider tasks that
+	 * started after the latest task in the previous pass. This
+	 * guarantees forward progress and that we don't miss any tasks.
+	 */
+	heap->size = 0;
+	cgroup_iter_start(scan->cg, &it);
+	while ((p = cgroup_iter_next(scan->cg, &it))) {
+		/*
+		 * Only affect tasks that qualify per the caller's callback,
+		 * if he provided one
+		 */
+		if (scan->test_task && !scan->test_task(p, scan))
+			continue;
+		/*
+		 * Only process tasks that started after the last task
+		 * we processed
+		 */
+		if (!started_after_time(p, &latest_time, latest_task))
+			continue;
+		dropped = heap_insert(heap, p);
+		if (dropped == NULL) {
+			/*
+			 * The new task was inserted; the heap wasn't
+			 * previously full
+			 */
+			get_task_struct(p);
+		} else if (dropped != p) {
+			/*
+			 * The new task was inserted, and pushed out a
+			 * different task
+			 */
+			get_task_struct(p);
+			put_task_struct(dropped);
+		}
+		/*
+		 * Else the new task was newer than anything already in
+		 * the heap and wasn't inserted
+		 */
+	}
+
+	cgroup_iter_end(scan->cg, &it);
+	if (heap->size) {
+		for (i = 0; i < heap->size; i++) {
+			struct task_struct *p = heap->ptrs[i];
+			if (i == 0) {
+				latest_time = p->start_time;
+				latest_task = p;
+			}
+			/* Process the task per the caller's callback */
+			scan->process_task(p, scan);
+			put_task_struct(p);
+		}
+		/*
+		 * If we had to process any tasks at all, scan again
+		 * in case some of them were in the middle of forking
+		 * children that didn't get processed.
+		 * Not the most efficient way to do it, but it avoids
+		 * having to take callback_mutex in the fork path
+		 */
+		goto again;
+	}
+	if (heap == &tmp_heap)
+		heap_free(&tmp_heap);
+	return 0;
+}
+
 /*
  * Stuff for reading the 'tasks' file.
  *
_

Patches currently in -mm which might be from cpw@sgi.com are

cgroups-mechanism-to-process-each-task-in-a-cgroup.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-cleanup.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes.patch
cpusets-update_cpumask-revision.patch
cpusets-update_cpumask-revision-checkpatch-fixes.patch
