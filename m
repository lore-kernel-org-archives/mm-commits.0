From: akpm@linux-foundation.org
Subject: - cpuset-avoid-changing-cpusets-cpus-when-errno-returned.patch removed from -mm tree
Date: Thu, 18 Sep 2008 13:55:39 -0700
Message-ID: <200809182055.m8IKtdN2019116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754543AbYIRUzv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Sep 2008 16:55:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, miaox@cn.fujitsu.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     cpuset: avoid changing cpuset's cpus when -errno returned
has been removed from the -mm tree.  Its filename was
     cpuset-avoid-changing-cpusets-cpus-when-errno-returned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: avoid changing cpuset's cpus when -errno returned
From: Li Zefan <lizf@cn.fujitsu.com>

After the patch:

commit 0b2f630a28d53b5a2082a5275bc3334b10373508
Author: Miao Xie <miaox@cn.fujitsu.com>
Date:   Fri Jul 25 01:47:21 2008 -0700

    cpusets: restructure the function update_cpumask() and update_nodemask()

It might happen that 'echo 0 > /cpuset/sub/cpus' returned failure but 'cpus'
has been changed, because cpus was changed before calling heap_init() which
may return -ENOMEM.

This patch restores the orginal behavior.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   37 +++++++++++++++----------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

diff -puN kernel/cpuset.c~cpuset-avoid-changing-cpusets-cpus-when-errno-returned kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-avoid-changing-cpusets-cpus-when-errno-returned
+++ a/kernel/cpuset.c
@@ -843,37 +843,25 @@ static void cpuset_change_cpumask(struct
 /**
  * update_tasks_cpumask - Update the cpumasks of tasks in the cpuset.
  * @cs: the cpuset in which each task's cpus_allowed mask needs to be changed
+ * @heap: if NULL, defer allocating heap memory to cgroup_scan_tasks()
  *
  * Called with cgroup_mutex held
  *
  * The cgroup_scan_tasks() function will scan all the tasks in a cgroup,
  * calling callback functions for each.
  *
- * Return 0 if successful, -errno if not.
+ * No return value. It's guaranteed that cgroup_scan_tasks() always returns 0
+ * if @heap != NULL.
  */
-static int update_tasks_cpumask(struct cpuset *cs)
+static void update_tasks_cpumask(struct cpuset *cs, struct ptr_heap *heap)
 {
 	struct cgroup_scanner scan;
-	struct ptr_heap heap;
-	int retval;
-
-	/*
-	 * cgroup_scan_tasks() will initialize heap->gt for us.
-	 * heap_init() is still needed here for we should not change
-	 * cs->cpus_allowed when heap_init() fails.
-	 */
-	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
-	if (retval)
-		return retval;
 
 	scan.cg = cs->css.cgroup;
 	scan.test_task = cpuset_test_cpumask;
 	scan.process_task = cpuset_change_cpumask;
-	scan.heap = &heap;
-	retval = cgroup_scan_tasks(&scan);
-
-	heap_free(&heap);
-	return retval;
+	scan.heap = heap;
+	cgroup_scan_tasks(&scan);
 }
 
 /**
@@ -883,6 +871,7 @@ static int update_tasks_cpumask(struct c
  */
 static int update_cpumask(struct cpuset *cs, const char *buf)
 {
+	struct ptr_heap heap;
 	struct cpuset trialcs;
 	int retval;
 	int is_load_balanced;
@@ -917,6 +906,10 @@ static int update_cpumask(struct cpuset 
 	if (cpus_equal(cs->cpus_allowed, trialcs.cpus_allowed))
 		return 0;
 
+	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
+	if (retval)
+		return retval;
+
 	is_load_balanced = is_sched_load_balance(&trialcs);
 
 	mutex_lock(&callback_mutex);
@@ -927,9 +920,9 @@ static int update_cpumask(struct cpuset 
 	 * Scan tasks in the cpuset, and update the cpumasks of any
 	 * that need an update.
 	 */
-	retval = update_tasks_cpumask(cs);
-	if (retval < 0)
-		return retval;
+	update_tasks_cpumask(cs, &heap);
+
+	heap_free(&heap);
 
 	if (is_load_balanced)
 		async_rebuild_sched_domains();
@@ -1965,7 +1958,7 @@ static void scan_for_empty_cpusets(const
 		     nodes_empty(cp->mems_allowed))
 			remove_tasks_in_empty_cpuset(cp);
 		else {
-			update_tasks_cpumask(cp);
+			update_tasks_cpumask(cp, NULL);
 			update_tasks_nodemask(cp, &oldmems);
 		}
 	}
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
devcgroup-use-kmemdup.patch
devcgroup-remove-unused-variable.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-setup-the-memrlimit-controller-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch

