From: akpm@linux-foundation.org
Subject: - memcg-swappiness.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:49:27 -0800
Message-ID: <200901082249.n08MnRYf028724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761150AbZAHW6z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:58:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, balbir@in.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: swappiness
has been removed from the -mm tree.  Its filename was
     memcg-swappiness.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: swappiness
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, /proc/sys/vm/swappiness can change swappiness ratio for global
reclaim.  However, memcg reclaim doesn't have tuning parameter for itself.

In general, the optimal swappiness depend on workload.  (e.g.  hpc
workload need to low swappiness than the others.)

Then, per cgroup swappiness improve administrator tunability.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/controllers/memory.txt |    9 ++
 include/linux/swap.h                 |    3 
 mm/memcontrol.c                      |   78 ++++++++++++++++++++++---
 mm/vmscan.c                          |    7 +-
 4 files changed, 86 insertions(+), 11 deletions(-)

diff -puN Documentation/controllers/memory.txt~memcg-swappiness Documentation/controllers/memory.txt
--- a/Documentation/controllers/memory.txt~memcg-swappiness
+++ a/Documentation/controllers/memory.txt
@@ -314,6 +314,15 @@ will be charged as a new owner of it.
 	showing for better debug please see the code for meanings.
 
 
+5.3 swappiness
+  Similar to /proc/sys/vm/swappiness, but affecting a hierarchy of groups only.
+
+  Following cgroup's swapiness can't be changed.
+  - root cgroup (uses /proc/sys/vm/swappiness).
+  - a cgroup which uses hierarchy and it has child cgroup.
+  - a cgroup which uses hierarchy and not the root of hierarchy.
+
+
 6. Hierarchy support
 
 The memory controller supports a deep hierarchy and hierarchical accounting.
diff -puN include/linux/swap.h~memcg-swappiness include/linux/swap.h
--- a/include/linux/swap.h~memcg-swappiness
+++ a/include/linux/swap.h
@@ -214,7 +214,8 @@ static inline void lru_cache_add_active_
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask);
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem,
-						gfp_t gfp_mask, bool noswap);
+						  gfp_t gfp_mask, bool noswap,
+						  unsigned int swappiness);
 extern int __isolate_lru_page(struct page *page, int mode, int file);
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
diff -puN mm/memcontrol.c~memcg-swappiness mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-swappiness
+++ a/mm/memcontrol.c
@@ -164,6 +164,9 @@ struct mem_cgroup {
 	int		obsolete;
 	atomic_t	refcnt;
 
+	unsigned int	swappiness;
+
+
 	unsigned int inactive_ratio;
 
 	/*
@@ -636,6 +639,22 @@ static bool mem_cgroup_check_under_limit
 	return false;
 }
 
+static unsigned int get_swappiness(struct mem_cgroup *memcg)
+{
+	struct cgroup *cgrp = memcg->css.cgroup;
+	unsigned int swappiness;
+
+	/* root ? */
+	if (cgrp->parent == NULL)
+		return vm_swappiness;
+
+	spin_lock(&memcg->reclaim_param_lock);
+	swappiness = memcg->swappiness;
+	spin_unlock(&memcg->reclaim_param_lock);
+
+	return swappiness;
+}
+
 /*
  * Dance down the hierarchy if needed to reclaim memory. We remember the
  * last child we reclaimed from, so that we don't end up penalizing
@@ -656,7 +675,8 @@ static int mem_cgroup_hierarchical_recla
 	 * but there might be left over accounting, even after children
 	 * have left.
 	 */
-	ret = try_to_free_mem_cgroup_pages(root_mem, gfp_mask, noswap);
+	ret = try_to_free_mem_cgroup_pages(root_mem, gfp_mask, noswap,
+					   get_swappiness(root_mem));
 	if (mem_cgroup_check_under_limit(root_mem))
 		return 0;
 	if (!root_mem->use_hierarchy)
@@ -672,7 +692,8 @@ static int mem_cgroup_hierarchical_recla
 			cgroup_unlock();
 			continue;
 		}
-		ret = try_to_free_mem_cgroup_pages(next_mem, gfp_mask, noswap);
+		ret = try_to_free_mem_cgroup_pages(next_mem, gfp_mask, noswap,
+						   get_swappiness(next_mem));
 		if (mem_cgroup_check_under_limit(root_mem))
 			return 0;
 		cgroup_lock();
@@ -1400,7 +1421,8 @@ int mem_cgroup_shrink_usage(struct mm_st
 	rcu_read_unlock();
 
 	do {
-		progress = try_to_free_mem_cgroup_pages(mem, gfp_mask, true);
+		progress = try_to_free_mem_cgroup_pages(mem, gfp_mask, true,
+							get_swappiness(mem));
 		progress += mem_cgroup_check_under_limit(mem);
 	} while (!progress && --retry);
 
@@ -1468,7 +1490,9 @@ static int mem_cgroup_resize_limit(struc
 			break;
 
 		progress = try_to_free_mem_cgroup_pages(memcg,
-				GFP_KERNEL, false);
+							GFP_KERNEL,
+							false,
+							get_swappiness(memcg));
   		if (!progress)			retry_count--;
 	}
 
@@ -1512,7 +1536,8 @@ int mem_cgroup_resize_memsw_limit(struct
 			break;
 
 		oldusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
-		try_to_free_mem_cgroup_pages(memcg, GFP_KERNEL, true);
+		try_to_free_mem_cgroup_pages(memcg, GFP_KERNEL, true,
+					     get_swappiness(memcg));
 		curusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
 		if (curusage >= oldusage)
 			retry_count--;
@@ -1643,8 +1668,8 @@ try_to_free:
 			ret = -EINTR;
 			goto out;
 		}
-		progress = try_to_free_mem_cgroup_pages(mem,
-						  GFP_KERNEL, false);
+		progress = try_to_free_mem_cgroup_pages(mem, GFP_KERNEL,
+						false, get_swappiness(mem));
 		if (!progress) {
 			nr_retries--;
 			/* maybe some writeback is necessary */
@@ -1864,6 +1889,37 @@ static int mem_control_stat_show(struct 
 	return 0;
 }
 
+static u64 mem_cgroup_swappiness_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
+
+	return get_swappiness(memcg);
+}
+
+static int mem_cgroup_swappiness_write(struct cgroup *cgrp, struct cftype *cft,
+				       u64 val)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
+	struct mem_cgroup *parent;
+	if (val > 100)
+		return -EINVAL;
+
+	if (cgrp->parent == NULL)
+		return -EINVAL;
+
+	parent = mem_cgroup_from_cont(cgrp->parent);
+	/* If under hierarchy, only empty-root can set this value */
+	if ((parent->use_hierarchy) ||
+	    (memcg->use_hierarchy && !list_empty(&cgrp->children)))
+		return -EINVAL;
+
+	spin_lock(&memcg->reclaim_param_lock);
+	memcg->swappiness = val;
+	spin_unlock(&memcg->reclaim_param_lock);
+
+	return 0;
+}
+
 
 static struct cftype mem_cgroup_files[] = {
 	{
@@ -1902,6 +1958,11 @@ static struct cftype mem_cgroup_files[] 
 		.write_u64 = mem_cgroup_hierarchy_write,
 		.read_u64 = mem_cgroup_hierarchy_read,
 	},
+	{
+		.name = "swappiness",
+		.read_u64 = mem_cgroup_swappiness_read,
+		.write_u64 = mem_cgroup_swappiness_write,
+	},
 };
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
@@ -2093,6 +2154,9 @@ mem_cgroup_create(struct cgroup_subsys *
 	mem->last_scanned_child = NULL;
 	spin_lock_init(&mem->reclaim_param_lock);
 
+	if (parent)
+		mem->swappiness = get_swappiness(parent);
+
 	return &mem->css;
 free_out:
 	for_each_node_state(node, N_POSSIBLE)
diff -puN mm/vmscan.c~memcg-swappiness mm/vmscan.c
--- a/mm/vmscan.c~memcg-swappiness
+++ a/mm/vmscan.c
@@ -1707,14 +1707,15 @@ unsigned long try_to_free_pages(struct z
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
-						gfp_t gfp_mask,
-					   bool noswap)
+					   gfp_t gfp_mask,
+					   bool noswap,
+					   unsigned int swappiness)
 {
 	struct scan_control sc = {
 		.may_writepage = !laptop_mode,
 		.may_swap = 1,
 		.swap_cluster_max = SWAP_CLUSTER_MAX,
-		.swappiness = vm_swappiness,
+		.swappiness = swappiness,
 		.order = 0,
 		.mem_cgroup = mem_cont,
 		.isolate_pages = mem_cgroup_isolate_pages,
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
ia64-implement-interrupt-enabling-rwlocks.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

