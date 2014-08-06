From: akpm@linux-foundation.org
Subject: [folded-merged] mm-memcontrol-rewrite-uncharge-api-fix-2.patch
 removed from -mm tree
Date: Wed, 06 Aug 2014 13:56:05 -0700
Message-ID: <53e29665.NCgLVr2SfM9+4FDq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:34784 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbaHFU4H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 16:56:07 -0400
Received: by mail-yh0-f73.google.com with SMTP id f73so416627yha.0
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 13:56:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, fengguang.wu@intel.com, jet.chen@intel.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: rewrite uncharge API fix 2
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-rewrite-uncharge-api-fix-2.patch

This patch was dropped because it was folded into mm-memcontrol-rewrite-uncharge-api.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: rewrite uncharge API fix 2

It's not entirely clear whether do_swap_account or PCG_MEMSW is the
authoritative answer to whether a page is swap-accounted or not.  This
currently leads to the following memsw counter underflow when swap
accounting is disabled:

[    2.753355] WARNING: CPU: 0 PID: 1 at kernel/res_counter.c:28 res_counter_uncharge_locked+0x48/0x74()
[    2.753355] CPU: 0 PID: 1 Comm: init Not tainted 3.16.0-rc1-00238-gddc5bfe #1
[    2.753355] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.753355]  0000000000000000 ffff880012073c50 ffffffff81a23b9d ffff880012073c88
[    2.753355]  ffffffff810bc765 ffffffff8111fac8 0000000000001000 ffff88001200fa50
[    2.753355]  0000000000000001 ffff88001200fa01 ffff880012073c98 ffffffff810bc84b
[    2.753355] Call Trace:
[    2.753355]  [<ffffffff81a23b9d>] dump_stack+0x19/0x1b
[    2.753355]  [<ffffffff810bc765>] warn_slowpath_common+0x73/0x8c
[    2.753355]  [<ffffffff8111fac8>] ? res_counter_uncharge_locked+0x48/0x74
[    2.753355]  [<ffffffff810bc84b>] warn_slowpath_null+0x1a/0x1c
[    2.753355]  [<ffffffff8111fac8>] res_counter_uncharge_locked+0x48/0x74
[    2.753355]  [<ffffffff8111fd02>] res_counter_uncharge_until+0x4e/0xa9
[    2.753355]  [<ffffffff8111fd70>] res_counter_uncharge+0x13/0x15
[    2.753355]  [<ffffffff8119499c>] mem_cgroup_uncharge_end+0x73/0x8d
[    2.753355]  [<ffffffff8115735e>] release_pages+0x1f2/0x20d
[    2.753355]  [<ffffffff8116cc3a>] tlb_flush_mmu_free+0x28/0x43
[    2.753355]  [<ffffffff8116d5e5>] tlb_flush_mmu+0x20/0x23
[    2.753355]  [<ffffffff8116d5fc>] tlb_finish_mmu+0x14/0x39
[    2.753355]  [<ffffffff811730c1>] unmap_region+0xcd/0xdf
[    2.753355]  [<ffffffff81172b0e>] ? vma_gap_callbacks_propagate+0x18/0x33
[    2.753355]  [<ffffffff81174bf1>] do_munmap+0x252/0x2e0
[    2.753355]  [<ffffffff81174cc3>] vm_munmap+0x44/0x5c
[    2.753355]  [<ffffffff81174cfe>] SyS_munmap+0x23/0x29
[    2.753355]  [<ffffffff81a31567>] system_call_fastpath+0x16/0x1b
[    2.753355] ---[ end trace cfeb07101f6fbdfb ]---

Don't set PCG_MEMSW when swap accounting is disabled, so that uncharging
only has to look at this per-page flag.

mem_cgroup_swapout() could also fully rely on this flag, but as it can
bail out before even looking up the page_cgroup, check do_swap_account as
a performance optimization and only sanity test for PCG_MEMSW.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Michal Hocko <mhocko@suse.cz>
Tested-by: Jet Chen <jet.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-rewrite-uncharge-api-fix-2 mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-rewrite-uncharge-api-fix-2
+++ a/mm/memcontrol.c
@@ -2740,7 +2740,7 @@ static void commit_charge(struct page *p
 	 *   have the page locked
 	 */
 	pc->mem_cgroup = memcg;
-	pc->flags = PCG_USED | PCG_MEM | PCG_MEMSW;
+	pc->flags = PCG_USED | PCG_MEM | (do_swap_account ? PCG_MEMSW : 0);
 
 	if (lrucare) {
 		if (was_on_lru) {
@@ -6602,7 +6602,7 @@ void mem_cgroup_migrate(struct page *old
 		return;
 
 	VM_BUG_ON_PAGE(!(pc->flags & PCG_MEM), oldpage);
-	VM_BUG_ON_PAGE(!(pc->flags & PCG_MEMSW), oldpage);
+	VM_BUG_ON_PAGE(do_swap_account && !(pc->flags & PCG_MEMSW), oldpage);
 	pc->flags &= ~(PCG_MEM | PCG_MEMSW);
 
 	if (PageTransHuge(oldpage)) {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
mm-page-flags-clean-up-the-page-flag-test-set-clear-macros.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-4.patch
mm-memcontrol-rewrite-uncharge-api-fix-5.patch
mm-memcontrol-rewrite-uncharge-api-fix-uncharge-from-irq-context.patch
mm-memcontrol-rewrite-uncharge-api-fix-double-migration-v2.patch
mm-memcontrol-rewrite-uncharge-api-fix-migrate-before-re-mapping.patch
mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration.patch
mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration-2.patch
mm-memcontrol-rewrite-uncharge-api-fix-clear-page-mapping-in-migration.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
memcg-remove-lookup_cgroup_page-prototype.patch
mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim-fix.patch
mm-vmscan-remove-all_unreclaimable.patch
mm-vmscan-remove-all_unreclaimable-fix.patch
mm-vmscan-move-swappiness-out-of-scan_control.patch
mm-vmscan-clean-up-struct-scan_control-v2.patch
mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
mm-replace-init_page_accessed-by-__setpagereferenced.patch
mm-update-the-description-for-vm_total_pages.patch
mm-vmscan-report-the-number-of-file-anon-pages-respectively.patch
mm-pagemap-avoid-unnecessary-overhead-when-tracepoints-are-deactivated.patch
mm-rearrange-zone-fields-into-read-only-page-alloc-statistics-and-page-reclaim-lines.patch
mm-move-zone-pages_scanned-into-a-vmstat-counter.patch
mm-vmscan-only-update-per-cpu-thresholds-for-online-cpu.patch
mm-page_alloc-abort-fair-zone-allocation-policy-when-remotes-nodes-are-encountered.patch
mm-page_alloc-reduce-cost-of-the-fair-zone-allocation-policy.patch
mm-writeback-prevent-race-when-calculating-dirty-limits.patch
slub-remove-kmemcg-id-from-create_unique_id.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch
mm-oom-rename-zonelist-locking-functions.patch
mm-thp-restructure-thp-avoidance-of-light-synchronous-migration.patch
mm-vmscan-fix-an-outdated-comment-still-mentioning-get_scan_ratio.patch
memcg-vmscan-fix-forced-scan-of-anonymous-pages.patch
memcg-vmscan-fix-forced-scan-of-anonymous-pages-fix-cleanups.patch
mm-memcontrol-avoid-charge-statistics-churn-during-page-migration.patch
mm-memcontrol-clean-up-reclaim-size-variable-use-in-try_charge.patch
nilfs2-integrate-sysfs-support-into-driver-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

