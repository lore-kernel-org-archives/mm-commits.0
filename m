From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-memcontrol-rewrite-uncharge-api-fix-double-migration.patch removed from
 -mm tree
Date: Thu, 17 Jul 2014 16:16:32 -0700
Message-ID: <53c85950./JQGuVDCPYJU06gO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:47821 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758210AbaGQXQd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jul 2014 19:16:33 -0400
Received: by mail-vc0-f202.google.com with SMTP id hq11so332552vcb.5
        for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2014 16:16:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: rewrite uncharge API fix - double migration
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-rewrite-uncharge-api-fix-double-migration.patch

This patch was dropped because an updated version will be merged

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

Catch pages that have already been migrated and abort migration
gracefully.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-rewrite-uncharge-api-fix-double-migration mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-rewrite-uncharge-api-fix-double-migration
+++ a/mm/memcontrol.c
@@ -6602,7 +6602,10 @@ void mem_cgroup_migrate(struct page *old
 	if (!PageCgroupUsed(pc))
 		return;
 
-	VM_BUG_ON_PAGE(!(pc->flags & PCG_MEM), oldpage);
+	/* Already migrated */
+	if (!(pc->flags & PCG_MEM))
+		return;
+
 	VM_BUG_ON_PAGE(do_swap_account && !(pc->flags & PCG_MEMSW), oldpage);
 	pc->flags &= ~(PCG_MEM | PCG_MEMSW);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

shmem-fix-faulting-into-a-hole-not-taking-i_mutex.patch
shmem-fix-splicing-from-a-hole-while-its-punched.patch
mm-page-writebackc-fix-divide-by-zero-in-bdi_dirty_limits.patch
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
mm-memcontrol-rewrite-charge-api-fix-3.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-2.patch
mm-memcontrol-rewrite-uncharge-api-fix-4.patch
mm-memcontrol-rewrite-uncharge-api-fix-5.patch
mm-memcontrol-rewrite-charge-api-fix-shmem_unuse.patch
mm-memcontrol-rewrite-uncharge-api-fix-uncharge-from-irq-context.patch
mm-memcontrol-rewrite-uncharge-api-fix-double-migration-v2.patch
mm-memcontrol-rewrite-uncharge-api-fix-migrate-before-re-mapping.patch
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
nilfs2-integrate-sysfs-support-into-driver-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

