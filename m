From: akpm@linux-foundation.org
Subject: + memcg-swappiness.patch added to -mm tree
Date: Tue, 02 Dec 2008 21:58:23 -0800
Message-ID: <200812030558.mB35wNZs029607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930AbYLCF7M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 00:59:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: swappiness
has been added to the -mm tree.  Its filename is
     memcg-swappiness.patch

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
Subject: memcg: swappiness
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

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
@@ -630,6 +633,22 @@ static bool mem_cgroup_check_under_limit
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
@@ -650,7 +669,8 @@ static int mem_cgroup_hierarchical_recla
 	 * but there might be left over accounting, even after children
 	 * have left.
 	 */
-	ret = try_to_free_mem_cgroup_pages(root_mem, gfp_mask, noswap);
+	ret = try_to_free_mem_cgroup_pages(root_mem, gfp_mask, noswap,
+					   get_swappiness(root_mem));
 	if (mem_cgroup_check_under_limit(root_mem))
 		return 0;
 	if (!root_mem->use_hierarchy)
@@ -666,7 +686,8 @@ static int mem_cgroup_hierarchical_recla
 			cgroup_unlock();
 			continue;
 		}
-		ret = try_to_free_mem_cgroup_pages(next_mem, gfp_mask, noswap);
+		ret = try_to_free_mem_cgroup_pages(next_mem, gfp_mask, noswap,
+						   get_swappiness(next_mem));
 		if (mem_cgroup_check_under_limit(root_mem))
 			return 0;
 		cgroup_lock();
@@ -1394,7 +1415,8 @@ int mem_cgroup_shrink_usage(struct mm_st
 	rcu_read_unlock();
 
 	do {
-		progress = try_to_free_mem_cgroup_pages(mem, gfp_mask, true);
+		progress = try_to_free_mem_cgroup_pages(mem, gfp_mask, true,
+							get_swappiness(mem));
 		progress += mem_cgroup_check_under_limit(mem);
 	} while (!progress && --retry);
 
@@ -1462,7 +1484,9 @@ static int mem_cgroup_resize_limit(struc
 			break;
 
 		progress = try_to_free_mem_cgroup_pages(memcg,
-				GFP_KERNEL, false);
+							GFP_KERNEL,
+							false,
+							get_swappiness(memcg));
   		if (!progress)			retry_count--;
 	}
 
@@ -1506,7 +1530,8 @@ int mem_cgroup_resize_memsw_limit(struct
 			break;
 
 		oldusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
-		try_to_free_mem_cgroup_pages(memcg, GFP_KERNEL, true);
+		try_to_free_mem_cgroup_pages(memcg, GFP_KERNEL, true,
+					     get_swappiness(memcg));
 		curusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
 		if (curusage >= oldusage)
 			retry_count--;
@@ -1637,8 +1662,8 @@ try_to_free:
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
@@ -1858,6 +1883,37 @@ static int mem_control_stat_show(struct 
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
@@ -1896,6 +1952,11 @@ static struct cftype mem_cgroup_files[] 
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
@@ -2087,6 +2148,9 @@ mem_cgroup_create(struct cgroup_subsys *
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
@@ -1752,14 +1752,15 @@ unsigned long try_to_free_pages(struct z
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

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

vmscan-evict-streaming-io-first.patch
mm-gup-persist-for-write-permission.patch
mm-wp-lock-page-before-deciding-cow.patch
mm-reuse_swap_page-replaces-can_share_swap_page.patch
mm-try_to_free_swap-replaces-remove_exclusive_swap_page.patch
mm-try_to_unuse-check-removing-right-swap.patch
mm-remove-try_to_munlock-from-vmscan.patch
mm-remove-gfp_mask-from-add_to_swap.patch
mm-add-add_to_swap-stub.patch
mm-optimize-get_scan_ratio-for-no-swap.patch
memcg-reclaim-shouldnt-change-zone-recent_rotated-statistics.patch
swapfile-swapon-needs-larger-size-type.patch
swapfile-remove-swp_active-mask.patch
swapfile-remove-surplus-whitespace.patch
swapfile-remove-v0-swap-space-message.patch
swapfile-rearrange-scan-and-swap_info.patch
swapfile-swapon-use-discard-trim.patch
swapfile-swap-allocation-use-discard.patch
swapfile-swapon-randomize-if-nonrot.patch
swapfile-swap-allocation-cycle-if-nonrot.patch
swapfile-change-discard-pgoff_t-to-sector_t.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
swapfile-let-others-seed-random.patch
cgroups-make-cgroup-config-a-submenu.patch
cgroups-documentation-updates.patch
cgroups-remove-some-redundant-null-checks.patch
ns_cgroup-remove-unused-spinlock.patch
memcg-fix-a-typo-in-kconfig.patch
cgroups-add-lock-for-child-cgroups-in-cgroup_post_fork.patch
cgroups-fix-cgroup_iter_next-bug.patch
cgroups-dont-put-struct-cgroupfs_root-protected-by-rcu.patch
cgroups-use-task_lock-for-access-tsk-cgroups-safe-in-cgroup_clone.patch
cgroups-call-find_css_set-safely-in-cgroup_attach_task.patch
cgroups-remove-rcu_read_lock-in-cgroupstats_build.patch
cgroups-make-root_list-contains-active-hierarchies-only.patch
cgroups-add-inactive-subsystems-to-rootnodesubsys_list.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code.patch
devcgroup-use-list_for_each_entry_rcu.patch
memcg-introduce-charge-commit-cancel-style-of-functions.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-fix-gfp_mask-of-callers-of-charge.patch
memcg-simple-migration-handling.patch
memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup.patch
memcg-move-all-acccounts-to-parent-at-rmdir.patch
memcg-reduce-size-of-mem_cgroup-by-using-nr_cpu_ids.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-memswap-controller-kconfig.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
memcg-synchronized-lru.patch
memcg-add-mem_cgroup_disabled.patch
memcg-add-mem_cgroup_disabled-fix.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim.patch
memory-cgroup-hierarchy-feature-selector-v4.patch
memory-cgroup-hierarchy-feature-selector-v4-fix.patch
memcontrol-rcu_read_lock-to-protect-mm_match_cgroup.patch
memcg-avoid-unnecessary-system-wide-oom-killer.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
memcg-fix-reclaim-result-checks.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch
cpuset-rcu_read_lock-to-protect-task_cs.patch

