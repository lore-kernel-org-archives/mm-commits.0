From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-make-mem_cgroup_out_of_memory-static.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:56:56 -0800
Message-ID: <20121212195656.B407A82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:40072 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab2LLUFE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 15:05:04 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so120479vcd.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 12:05:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: make mem_cgroup_out_of_memory() static
has been removed from the -mm tree.  Its filename was
     mm-memcg-make-mem_cgroup_out_of_memory-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, memcg: make mem_cgroup_out_of_memory() static

mem_cgroup_out_of_memory() is only referenced from within file scope, so
it can be marked static.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    2 --
 mm/memcontrol.c     |    4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN include/linux/oom.h~mm-memcg-make-mem_cgroup_out_of_memory-static include/linux/oom.h
--- a/include/linux/oom.h~mm-memcg-make-mem_cgroup_out_of_memory-static
+++ a/include/linux/oom.h
@@ -49,8 +49,6 @@ extern void check_panic_on_oom(enum oom_
 extern enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
 		unsigned long totalpages, const nodemask_t *nodemask,
 		bool force_kill);
-extern void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
-				     int order);
 
 extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 		int order, nodemask_t *mask, bool force_kill);
diff -puN mm/memcontrol.c~mm-memcg-make-mem_cgroup_out_of_memory-static mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-make-mem_cgroup_out_of_memory-static
+++ a/mm/memcontrol.c
@@ -1498,8 +1498,8 @@ static u64 mem_cgroup_get_limit(struct m
 	return limit;
 }
 
-void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
-			      int order)
+static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
+				     int order)
 {
 	struct mem_cgroup *iter;
 	unsigned long chosen_points = 0;
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
thp-huge-zero-page-basic-preparation.patch
thp-huge-zero-page-basic-preparation-v6.patch
thp-zap_huge_pmd-zap-huge-zero-pmd.patch
thp-copy_huge_pmd-copy-huge-zero-page.patch
thp-copy_huge_pmd-copy-huge-zero-page-v6.patch
thp-copy_huge_pmd-copy-huge-zero-page-v6-fix.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page-v6.patch
thp-change_huge_pmd-make-sure-we-dont-try-to-make-a-page-writable.patch
thp-change-split_huge_page_pmd-interface.patch
thp-change-split_huge_page_pmd-interface-v6.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
thp-implement-splitting-pmd-for-huge-zero-page-v6.patch
thp-setup-huge-zero-page-on-non-write-page-fault.patch
thp-setup-huge-zero-page-on-non-write-page-fault-fix.patch
thp-lazy-huge-zero-page-allocation.patch
thp-implement-refcounting-for-huge-zero-page.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6.patch
thp-introduce-sysfs-knob-to-disable-huge-zero-page.patch
thp-avoid-race-on-multiple-parallel-page-faults-to-the-same-page.patch
node_states-introduce-n_memory.patch
cpuset-use-n_memory-instead-n_high_memory.patch
procfs-use-n_memory-instead-n_high_memory.patch
memcontrol-use-n_memory-instead-n_high_memory.patch
oom-use-n_memory-instead-n_high_memory.patch
mmmigrate-use-n_memory-instead-n_high_memory.patch
mempolicy-use-n_memory-instead-n_high_memory.patch
hugetlb-use-n_memory-instead-n_high_memory.patch
vmstat-use-n_memory-instead-n_high_memory.patch
kthread-use-n_memory-instead-n_high_memory.patch
init-use-n_memory-instead-n_high_memory.patch
vmscan-use-n_memory-instead-n_high_memory.patch
page_alloc-use-n_memory-instead-n_high_memory-change-the-node_states-initialization.patch
hotplug-update-nodemasks-management.patch
hotplug-update-nodemasks-management-fix.patch
mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled.patch
mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled-fix.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
memory_hotplug-allow-online-offline-memory-to-result-movable-node.patch
mm-oom-cleanup-pagefault-oom-handler.patch
mm-oom-remove-redundant-sleep-in-pagefault-oom-handler.patch
mm-oom-remove-statically-defined-arch-functions-of-same-name.patch
mm-introduce-new-field-managed_pages-to-struct-zone.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix.patch
memcg-do-not-check-for-mm-in-mem_cgroup_count_vm_event-disabled.patch
linux-next.patch
x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch
x86-fix-the-argument-passed-to-sync_global_pgds.patch
irq-tsk-comm-is-an-array.patch
mm-mempolicy-introduce-spinlock-to-read-shared-policy-tree.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

