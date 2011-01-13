From: akpm@linux-foundation.org
Subject: [folded] mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction.patch removed from -mm tree
Date: Thu, 13 Jan 2011 15:26:44 -0800
Message-ID: <201101132326.p0DNQimu006963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756782Ab1AMX0w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 18:26:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, hughd@google.com, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: compaction: avoid a potential deadlock due to lock_page() during direct compaction
has been removed from the -mm tree.  Its filename was
     mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction.patch

This patch was dropped because it was folded into mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: compaction: avoid a potential deadlock due to lock_page() during direct compaction
From: Mel Gorman <mel@csn.ul.ie>

Hugh Dickins reported that two instances of cp were locking up when
running on ppc64 in a memory constrained environment.  It also affects
x86-64 but was harder to reproduce.  The deadlock was related to readahead
pages.  When reading ahead, the pages are added locked to the LRU and
queued for IO.  The process is also inserting pages into the page cache
and so is calling radix_preload and entering the page allocator.  When
SLUB is used, this can result in direct compaction finding the page that
was just added to the LRU but still locked by the current process leading
to deadlock.

This patch avoids locking pages in the direct compaction patch because we
cannot be certain the current process is not holding the lock.  To do
this, PF_MEMALLOC is set for compaction.  Compaction should not be
re-entering the page allocator and so will not breach watermarks through
the use of ALLOC_NO_WATERMARKS.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reported-by: Hugh Dickins <hughd@google.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c    |   17 +++++++++++++++++
 mm/page_alloc.c |    3 +++
 2 files changed, 20 insertions(+)

diff -puN mm/migrate.c~mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction mm/migrate.c
--- a/mm/migrate.c~mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction
+++ a/mm/migrate.c
@@ -639,6 +639,23 @@ static int unmap_and_move(new_page_t get
 	if (!trylock_page(page)) {
 		if (!force)
 			goto move_newpage;
+
+		/*
+		 * It's not safe for direct compaction to call lock_page.
+		 * For example, during page readahead pages are added locked
+		 * to the LRU. Later, when the IO completes the pages are
+		 * marked uptodate and unlocked. However, the queueing
+		 * could be merging multiple pages for one bio (e.g.
+		 * mpage_readpages). If an allocation happens for the
+		 * second or third page, the process can end up locking
+		 * the same page twice and deadlocking. Rather than
+		 * trying to be clever about what pages can be locked,
+		 * avoid the use of lock_page for direct compaction
+		 * altogether.
+		 */
+		if (current->flags & PF_MEMALLOC)
+			goto move_newpage;
+
 		lock_page(page);
 	}
 
diff -puN mm/page_alloc.c~mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction mm/page_alloc.c
--- a/mm/page_alloc.c~mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction
+++ a/mm/page_alloc.c
@@ -1815,12 +1815,15 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	int migratetype, unsigned long *did_some_progress)
 {
 	struct page *page;
+	struct task_struct *p = current;
 
 	if (!order || compaction_deferred(preferred_zone))
 		return NULL;
 
+	p->flags |= PF_MEMALLOC;
 	*did_some_progress = try_to_compact_pages(zonelist, order, gfp_mask,
 								nodemask);
+	p->flags &= ~PF_MEMALLOC;
 	if (*did_some_progress != COMPACT_SKIPPED) {
 
 		/* Page migration frees to the PCP lists but we want merging */
_

Patches currently in -mm which might be from mel@csn.ul.ie are

mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch
vmscan-factor-out-kswapd-sleeping-logic-from-kswapd.patch
mm-compaction-add-trace-events-for-memory-compaction-activity.patch
mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch
mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode-fix.patch
mm-kswapd-stop-high-order-balancing-when-any-suitable-zone-is-balanced.patch
mm-kswapd-keep-kswapd-awake-for-high-order-allocations-until-a-percentage-of-the-node-is-balanced.patch
mm-kswapd-use-the-order-that-kswapd-was-reclaiming-at-for-sleeping_prematurely.patch
mm-kswapd-reset-kswapd_max_order-and-classzone_idx-after-reading.patch
mm-kswapd-treat-zone-all_unreclaimable-in-sleeping_prematurely-similar-to-balance_pgdat.patch
mm-kswapd-use-the-classzone-idx-that-kswapd-was-using-for-sleeping_prematurely.patch
thp-fix-bad_page-to-show-the-real-reason-the-page-is-bad.patch
thp-mm-define-madv_hugepage.patch
thp-alter-compound-get_page-put_page.patch
thp-update-futex-compound-knowledge.patch
thp-clear-compound-mapping.patch
thp-add-native_set_pmd_at.patch
thp-add-pmd-paravirt-ops.patch
thp-no-paravirt-version-of-pmd-ops.patch
thp-export-maybe_mkwrite.patch
thp-comment-reminder-in-destroy_compound_page.patch
thp-config_transparent_hugepage.patch
thp-config_transparent_hugepage-fix.patch
thp-special-pmd_trans_-functions.patch
thp-add-pmd-mangling-generic-functions.patch
thp-add-pmd-mangling-generic-functions-fix-pgtableh-build-for-um.patch
thp-bail-out-gup_fast-on-splitting-pmd.patch
thp-pte-alloc-trans-splitting.patch
thp-pte-alloc-trans-splitting-fix.patch
thp-clear-page-compound.patch
thp-add-pmd_huge_pte-to-mm_struct.patch
thp-split_huge_page_mm-vma.patch
thp-split_huge_page-paging.patch
thp-clear_copy_huge_page.patch
thp-_gfp_no_kswapd.patch
thp-dont-alloc-harder-for-gfp-nomemalloc-even-if-nowait.patch
thp-split_huge_page-anon_vma-ordering-dependency.patch
thp-verify-pmd_trans_huge-isnt-leaking.patch
thp-skip-transhuge-pages-in-ksm-for-now.patch
thp-enable-direct-defrag.patch
thp-select-config_compaction-if-transparent_hugepage-enabled.patch
thp-transhuge-isolate_migratepages.patch
thp-disable-transparent-hugepages-by-default-on-small-systems.patch
mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration.patch
mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration-fix.patch
mm-fix-migration-hangs-on-anon_vma-lock.patch
mm-fix-hugepage-migration.patch
mm-page_allocc-dont-cache-current-in-a-local.patch

