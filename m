From: akpm@linux-foundation.org
Subject: [merged] cpuset-avoid-changing-cpusets-mems-when-errno-returned.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:35:02 -0700
Message-ID: <200904061935.n36JZ2q6011854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750784AbZDFUap (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:30:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, a.p.zijlstra@chello.nl, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     cpuset: avoid changing cpuset's mems when errno returned
has been removed from the -mm tree.  Its filename was
     cpuset-avoid-changing-cpusets-mems-when-errno-returned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: avoid changing cpuset's mems when errno returned
From: Li Zefan <lizf@cn.fujitsu.com>

When writing to cpuset.mems, cpuset has to update its mems_allowed before
calling update_tasks_nodemask(), but this function might return -ENOMEM.

To avoid this rare case, we allocate the memory before changing
mems_allowed, and then pass to update_tasks_nodemask().  Similar to what
update_cpumask() does.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff -puN kernel/cpuset.c~cpuset-avoid-changing-cpusets-mems-when-errno-returned kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-avoid-changing-cpusets-mems-when-errno-returned
+++ a/kernel/cpuset.c
@@ -1057,13 +1057,15 @@ static void *cpuset_being_rebound;
  * update_tasks_nodemask - Update the nodemasks of tasks in the cpuset.
  * @cs: the cpuset in which each task's mems_allowed mask needs to be changed
  * @oldmem: old mems_allowed of cpuset cs
+ * @heap: if NULL, defer allocating heap memory to cgroup_scan_tasks()
  *
  * Called with cgroup_mutex held
- * Return 0 if successful, -errno if not.
+ * No return value. It's guaranteed that cgroup_scan_tasks() always returns 0
+ * if @heap != NULL.
  */
-static int update_tasks_nodemask(struct cpuset *cs, const nodemask_t *oldmem)
+static void update_tasks_nodemask(struct cpuset *cs, const nodemask_t *oldmem,
+				 struct ptr_heap *heap)
 {
-	int retval;
 	struct cgroup_scanner scan;
 
 	cpuset_being_rebound = cs;		/* causes mpol_dup() rebind */
@@ -1071,7 +1073,7 @@ static int update_tasks_nodemask(struct 
 	scan.cg = cs->css.cgroup;
 	scan.test_task = NULL;
 	scan.process_task = cpuset_change_nodemask;
-	scan.heap = NULL;
+	scan.heap = heap;
 	scan.data = (nodemask_t *)oldmem;
 
 	/*
@@ -1084,12 +1086,10 @@ static int update_tasks_nodemask(struct 
 	 * It's ok if we rebind the same mm twice; mpol_rebind_mm()
 	 * is idempotent.  Also migrate pages in each mm to new nodes.
 	 */
-	retval = cgroup_scan_tasks(&scan);
+	cgroup_scan_tasks(&scan);
 
 	/* We're done rebinding vmas to this cpuset's new mems_allowed. */
 	cpuset_being_rebound = NULL;
-
-	return retval;
 }
 
 /*
@@ -1110,6 +1110,7 @@ static int update_nodemask(struct cpuset
 {
 	nodemask_t oldmem;
 	int retval;
+	struct ptr_heap heap;
 
 	/*
 	 * top_cpuset.mems_allowed tracks node_stats[N_HIGH_MEMORY];
@@ -1144,12 +1145,18 @@ static int update_nodemask(struct cpuset
 	if (retval < 0)
 		goto done;
 
+	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
+	if (retval < 0)
+		goto done;
+
 	mutex_lock(&callback_mutex);
 	cs->mems_allowed = trialcs->mems_allowed;
 	cs->mems_generation = cpuset_mems_generation++;
 	mutex_unlock(&callback_mutex);
 
-	retval = update_tasks_nodemask(cs, &oldmem);
+	update_tasks_nodemask(cs, &oldmem, &heap);
+
+	heap_free(&heap);
 done:
 	return retval;
 }
@@ -2003,7 +2010,7 @@ static void scan_for_empty_cpusets(struc
 			remove_tasks_in_empty_cpuset(cp);
 		else {
 			update_tasks_cpumask(cp, NULL);
-			update_tasks_nodemask(cp, &oldmems);
+			update_tasks_nodemask(cp, &oldmems, NULL);
 		}
 	}
 }
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
cls_cgroup-remove-unneeded-cgroup_lock.patch

