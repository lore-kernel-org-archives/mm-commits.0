From: akpm@linux-foundation.org
Subject: + cpuset-avoid-changing-cpusets-mems-when-errno-returned.patch added to -mm tree
Date: Thu, 26 Feb 2009 14:57:27 -0800
Message-ID: <200902262257.n1QMvRlg031442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753744AbZBZW5z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 17:57:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com


The patch titled
     cpuset: avoid changing cpuset's mems when errno returned
has been added to the -mm tree.  Its filename is
     cpuset-avoid-changing-cpusets-mems-when-errno-returned.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2002,7 +2009,7 @@ static void scan_for_empty_cpusets(struc
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

linux-next.patch
vfs-add-missing-unlock-in-sget.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch
cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
cgroups-more-documentation-for-remount-and-release_agent.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
use-css-id-in-swap_cgroup-for-saving-memory-v4.patch
cpuset-fix-possible-races-in-cpu-memory-hotplug.patch
cgroups-add-data-field-to-struct-cgroup_scanner.patch
cpuset-rewrite-update_tasks_nodemask.patch
cpuset-avoid-changing-cpusets-mems-when-errno-returned.patch
cpuset-remove-struct-cpuset_hotplug_scanner.patch

