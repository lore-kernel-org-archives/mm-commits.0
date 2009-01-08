From: akpm@linux-foundation.org
Subject: - cgroups-use-hierarchy_mutex-in-memory-controller.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:49:58 -0800
Message-ID: <200901082249.n08MnwhF029194@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760059AbZAHW6x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:58:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: use hierarchy_mutex in memory controller
has been removed from the -mm tree.  Its filename was
     cgroups-use-hierarchy_mutex-in-memory-controller.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: use hierarchy_mutex in memory controller
From: Paul Menage <menage@google.com>

Update the memory controller to use its hierarchy_mutex rather than
calling cgroup_lock() to protected against cgroup_mkdir()/cgroup_rmdir()
from occurring in its hierarchy.

Signed-off-by: Paul Menage <menage@google.com>
Tested-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~cgroups-use-hierarchy_mutex-in-memory-controller mm/memcontrol.c
--- a/mm/memcontrol.c~cgroups-use-hierarchy_mutex-in-memory-controller
+++ a/mm/memcontrol.c
@@ -154,7 +154,7 @@ struct mem_cgroup {
 
 	/*
 	 * While reclaiming in a hiearchy, we cache the last child we
-	 * reclaimed from. Protected by cgroup_lock()
+	 * reclaimed from. Protected by hierarchy_mutex
 	 */
 	struct mem_cgroup *last_scanned_child;
 	/*
@@ -615,7 +615,7 @@ unsigned long mem_cgroup_isolate_pages(u
 
 /*
  * This routine finds the DFS walk successor. This routine should be
- * called with cgroup_mutex held
+ * called with hierarchy_mutex held
  */
 static struct mem_cgroup *
 mem_cgroup_get_next_node(struct mem_cgroup *curr, struct mem_cgroup *root_mem)
@@ -685,7 +685,7 @@ mem_cgroup_get_first_node(struct mem_cgr
 	/*
 	 * Scan all children under the mem_cgroup mem
 	 */
-	cgroup_lock();
+	mutex_lock(&mem_cgroup_subsys.hierarchy_mutex);
 	if (list_empty(&root_mem->css.cgroup->children)) {
 		ret = root_mem;
 		goto done;
@@ -706,7 +706,7 @@ mem_cgroup_get_first_node(struct mem_cgr
 
 done:
 	root_mem->last_scanned_child = ret;
-	cgroup_unlock();
+	mutex_unlock(&mem_cgroup_subsys.hierarchy_mutex);
 	return ret;
 }
 
@@ -770,18 +770,16 @@ static int mem_cgroup_hierarchical_recla
 	while (next_mem != root_mem) {
 		if (mem_cgroup_is_obsolete(next_mem)) {
 			mem_cgroup_put(next_mem);
-			cgroup_lock();
 			next_mem = mem_cgroup_get_first_node(root_mem);
-			cgroup_unlock();
 			continue;
 		}
 		ret = try_to_free_mem_cgroup_pages(next_mem, gfp_mask, noswap,
 						   get_swappiness(next_mem));
 		if (mem_cgroup_check_under_limit(root_mem))
 			return 0;
-		cgroup_lock();
+		mutex_lock(&mem_cgroup_subsys.hierarchy_mutex);
 		next_mem = mem_cgroup_get_next_node(next_mem, root_mem);
-		cgroup_unlock();
+		mutex_unlock(&mem_cgroup_subsys.hierarchy_mutex);
 	}
 	return ret;
 }
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
add-a-refcount-check-in-dput.patch

