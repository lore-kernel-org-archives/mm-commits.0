From: akpm@linux-foundation.org
Subject: - per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup-memory-controller-enhancements-for-reclaiming-take2-define-free_mem_cgroup_per_zone_info.patch removed from -mm tree
Date: Thu, 10 Jan 2008 12:29:47 -0800
Message-ID: <200801102029.m0AKTm3H007888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50650 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754079AbYAJUaA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 15:30:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     memory controller enhancements for reclaiming take2: define free_mem_cgroup_per_zone_info
has been removed from the -mm tree.  Its filename was
     per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup-memory-controller-enhancements-for-reclaiming-take2-define-free_mem_cgroup_per_zone_info.patch

This patch was dropped because it was folded into per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory controller enhancements for reclaiming take2: define free_mem_cgroup_per_zone_info
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now allocation of per_zone of mem_controller is done by
alloc_mem_cgroup_per_zone_info(). Then it will be good to use
free_mem_cgroup_per_zone_info() for maintainance.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup-memory-controller-enhancements-for-reclaiming-take2-define-free_mem_cgroup_per_zone_info mm/memcontrol.c
--- a/mm/memcontrol.c~per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup-memory-controller-enhancements-for-reclaiming-take2-define-free_mem_cgroup_per_zone_info
+++ a/mm/memcontrol.c
@@ -1118,6 +1118,11 @@ static int alloc_mem_cgroup_per_zone_inf
 	return 0;
 }
 
+static void free_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
+{
+	kfree(mem->info.nodeinfo[node]);
+}
+
 
 static struct mem_cgroup init_mem_cgroup;
 
@@ -1149,7 +1154,7 @@ mem_cgroup_create(struct cgroup_subsys *
 	return &mem->css;
 free_out:
 	for_each_node_state(node, N_POSSIBLE)
-		kfree(mem->info.nodeinfo[node]);
+		free_mem_cgroup_per_zone_info(mem, node);
 	if (cont->parent != NULL)
 		kfree(mem);
 	return NULL;
@@ -1169,7 +1174,7 @@ static void mem_cgroup_destroy(struct cg
 	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
 
 	for_each_node_state(node, N_POSSIBLE)
-		kfree(mem->info.nodeinfo[node]);
+		free_mem_cgroup_per_zone_info(mem, node);
 
 	kfree(mem_cgroup_from_cont(cont));
 }
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
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup-memory-controller-enhancements-for-reclaiming-take2-define-free_mem_cgroup_per_zone_info.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup.patch
memory-controller-remove-control_type-feature.patch
update-documentation-controller-memorytxt.patch
