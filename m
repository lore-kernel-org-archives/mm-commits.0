From: akpm@linux-foundation.org
Subject: - mm-add-setclearpageswapcache-stubs.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:12:15 -0800
Message-ID: <200901072212.n07MCFjg012478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752459AbZAGWMY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:12:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, cl@linux-foundation.org, mel@csn.ul.ie, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm: add Set,ClearPageSwapCache stubs
has been removed from the -mm tree.  Its filename was
     mm-add-setclearpageswapcache-stubs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add Set,ClearPageSwapCache stubs
From: Hugh Dickins <hugh@veritas.com>

If we add NOOP stubs for SetPageSwapCache() and ClearPageSwapCache(), then
we can remove the #ifdef CONFIG_SWAPs from mm/migrate.c.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    1 +
 mm/migrate.c               |    4 ----
 2 files changed, 1 insertion(+), 4 deletions(-)

diff -puN include/linux/page-flags.h~mm-add-setclearpageswapcache-stubs include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-add-setclearpageswapcache-stubs
+++ a/include/linux/page-flags.h
@@ -228,6 +228,7 @@ PAGEFLAG_FALSE(HighMem)
 PAGEFLAG(SwapCache, swapcache)
 #else
 PAGEFLAG_FALSE(SwapCache)
+	SETPAGEFLAG_NOOP(SwapCache) CLEARPAGEFLAG_NOOP(SwapCache)
 #endif
 
 #ifdef CONFIG_UNEVICTABLE_LRU
diff -puN mm/migrate.c~mm-add-setclearpageswapcache-stubs mm/migrate.c
--- a/mm/migrate.c~mm-add-setclearpageswapcache-stubs
+++ a/mm/migrate.c
@@ -300,12 +300,10 @@ static int migrate_page_move_mapping(str
 	 * Now we know that no one else is looking at the page.
 	 */
 	get_page(newpage);	/* add cache reference */
-#ifdef CONFIG_SWAP
 	if (PageSwapCache(page)) {
 		SetPageSwapCache(newpage);
 		set_page_private(newpage, page_private(page));
 	}
-#endif
 
 	radix_tree_replace_slot(pslot, newpage);
 
@@ -373,9 +371,7 @@ static void migrate_page_copy(struct pag
 
 	mlock_migrate_page(newpage, page);
 
-#ifdef CONFIG_SWAP
 	ClearPageSwapCache(page);
-#endif
 	ClearPagePrivate(page);
 	set_page_private(page, 0);
 	/* page->mapping contains a flag for PageAnon() */
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
linux-next.patch
mark-complex-bitopsh-inlines-as-__always_inline.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-pass-clocksource-to-read-callback-sparc-cleanup.patch
bio-zero-inlined-bio_vec.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-shmemc-fix-division-by-zero.patch
getrusage-fill-ru_maxrss-value.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
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
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch
memcg-fix-swap-accounting-leak-v3.patch
memcg-fix-swap-accounting-leak-doc-fix.patch
memcg-fix-shmems-swap-accounting.patch
prio_tree-debugging-patch.patch

