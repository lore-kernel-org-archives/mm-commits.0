From: akpm@linux-foundation.org
Subject: - per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup-bugfix-for-memory-cgroup-per-zone-struct-allocation.patch removed from -mm tree
Date: Thu, 10 Jan 2008 12:29:32 -0800
Message-ID: <200801102029.m0AKTW30007879@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46231 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753087AbYAJU3t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 15:29:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, Lee.Schermerhorn@hp.com, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     bugfix for memory cgroup per-zone-struct allocation
has been removed from the -mm tree.  Its filename was
     per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup-bugfix-for-memory-cgroup-per-zone-struct-allocation.patch

This patch was dropped because it was folded into per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bugfix for memory cgroup per-zone-struct allocation
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This is a fix. tested on my ia64/NUMA box both on SLAB/SLUB.
This patch fixes kmalloc_node() is called against node-without-memory.

It's better to add memory hotplug callback for supporing possible nodes
(memory hotplug) but here just uses kmalloc().

Should be revisited later.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Tested-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup-bugfix-for-memory-cgroup-per-zone-struct-allocation mm/memcontrol.c
--- a/mm/memcontrol.c~per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup-bugfix-for-memory-cgroup-per-zone-struct-allocation
+++ a/mm/memcontrol.c
@@ -1092,8 +1092,18 @@ static int alloc_mem_cgroup_per_zone_inf
 	struct mem_cgroup_per_node *pn;
 	struct mem_cgroup_per_zone *mz;
 	int zone;
-
-	pn = kmalloc_node(sizeof(*pn), GFP_KERNEL, node);
+	/*
+	 * This routine is called against possible nodes.
+	 * But it's BUG to call kmalloc() against offline node.
+	 *
+	 * TODO: this routine can waste much memory for nodes which will
+	 *       never be onlined. It's better to use memory hotplug callback
+	 *       function.
+	 */
+	if (node_state(node, N_HIGH_MEMORY))
+		pn = kmalloc_node(sizeof(*pn), GFP_KERNEL, node);
+	else
+		pn = kmalloc(sizeof(*pn), GFP_KERNEL);
 	if (!pn)
 		return 1;
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

fix-crash-with-flat_memory-and-arch_pfn_offset-=-0.patch
git-x86.patch
swapoff-scan-ptes-preemptibly.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
add-remove_memory-for-ppc64-2.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
mm-dont-waste-swap-on-locked-pages.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-improve-user-interface.patch
memory-controller-make-charging-gfp-mask-aware.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-controller-use-rcu_read_lock-in-mem_cgroup_cache_charge.patch
memcgroup-tidy-up-mem_cgroup_charge_common.patch
memcgroup-fix-hang-with-shmem-tmpfs.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-add-scan_global_lru-macro.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-nid-zid-helper-function-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-mapper_ratio-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-active-inactive-imbalance-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-the-number-of-pages-to-be-scanned-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup-bugfix-for-memory-cgroup-per-zone-struct-allocation.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup-memory-controller-enhancements-for-reclaiming-take2-define-free_mem_cgroup_per_zone_info.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup.patch
memory-controller-remove-control_type-feature.patch
update-documentation-controller-memorytxt.patch
