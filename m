From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-rewrite-uncharge-api-fix-double-migration-v2.patch removed
 from -mm tree
Date: Wed, 06 Aug 2014 13:56:14 -0700
Message-ID: <53e2966e.+yX0eOy7rrLa1jy5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:42748 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbaHFU4P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 16:56:15 -0400
Received: by mail-ie0-f202.google.com with SMTP id rl12so584671iec.3
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 13:56:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: rewrite uncharge API fix - double migration
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-rewrite-uncharge-api-fix-double-migration-v2.patch

This patch was dropped because it was folded into mm-memcontrol-rewrite-uncharge-api.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: rewrite uncharge API fix - double migration

Hugh reports:

VM_BUG_ON_PAGE(!(pc->flags & PCG_MEM))
mm/memcontrol.c:6680!
page had count 1 mapcount 0 mapping anon index 0x196
flags locked uptodate reclaim swapbacked, pcflags 1, memcg not root
mem_cgroup_migrate < move_to_new_page < migrate_pages < compact_zone <
compact_zone_order < try_to_compact_pages < __alloc_pages_direct_compact <
__alloc_pages_nodemask < alloc_pages_vma < do_huge_pmd_anonymous_page <
handle_mm_fault < __do_page_fault

mem_cgroup_migrate() assumes that a page is only migrated once and
then freed immediately after.

However, putting the page back on the LRU list and dropping the
isolation refcount is not done atomically.  This allows a PFN-based
migrator like compaction to isolate the page, see the expected
anonymous page refcount of 1, and migrate the page once more.

Properly uncharge the page after it's been migrated, including the
clearing of PCG_USED, so that a subsequent charge migration attempt
will be able to detect it and bail out.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Hugh Dickins <hughd@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-rewrite-uncharge-api-fix-double-migration-v2 mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-rewrite-uncharge-api-fix-double-migration-v2
+++ a/mm/memcontrol.c
@@ -6608,7 +6608,6 @@ void mem_cgroup_migrate(struct page *old
 
 	VM_BUG_ON_PAGE(!(pc->flags & PCG_MEM), oldpage);
 	VM_BUG_ON_PAGE(do_swap_account && !(pc->flags & PCG_MEMSW), oldpage);
-	pc->flags &= ~(PCG_MEM | PCG_MEMSW);
 
 	if (PageTransHuge(oldpage)) {
 		nr_pages <<= compound_order(oldpage);
@@ -6616,6 +6615,13 @@ void mem_cgroup_migrate(struct page *old
 		VM_BUG_ON_PAGE(!PageTransHuge(newpage), newpage);
 	}
 
+	pc->flags = 0;
+
+	local_irq_disable();
+	mem_cgroup_charge_statistics(pc->mem_cgroup, oldpage, -nr_pages);
+	memcg_check_events(pc->mem_cgroup, oldpage);
+	local_irq_enable();
+
 	commit_charge(newpage, pc->mem_cgroup, nr_pages, lrucare);
 }
 
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

