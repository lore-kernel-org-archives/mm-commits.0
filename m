From: akpm@linux-foundation.org
Subject: - badpage-keep-any-bad-page-out-of-circulation.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:13:58 -0800
Message-ID: <200901072213.n07MDw2l013959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757274AbZAGWOX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, cl@linux-foundation.org, mel@csn.ul.ie, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     badpage: keep any bad page out of circulation
has been removed from the -mm tree.  Its filename was
     badpage-keep-any-bad-page-out-of-circulation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: badpage: keep any bad page out of circulation
From: Hugh Dickins <hugh@veritas.com>

Until now the bad_page() checkers have special-cased PageReserved, keeping
those pages out of circulation thereafter.  Now extend the special case to
all: we want to keep ANY page with bad state out of circulation - the
"free" page may well be in use by something.

Leave the bad state of those pages untouched, for examination by
debuggers; except for PageBuddy - leaving that set would risk bringing the
page back.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   52 +++++++++++++++++++++-------------------------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff -puN mm/page_alloc.c~badpage-keep-any-bad-page-out-of-circulation mm/page_alloc.c
--- a/mm/page_alloc.c~badpage-keep-any-bad-page-out-of-circulation
+++ a/mm/page_alloc.c
@@ -231,9 +231,9 @@ static void bad_page(struct page *page)
 	printk(KERN_EMERG "Trying to fix it up, but a reboot is needed\n"
 		KERN_EMERG "Backtrace:\n");
 	dump_stack();
-	set_page_count(page, 0);
-	reset_page_mapcount(page);
-	page->mapping = NULL;
+
+	/* Leave bad fields for debug, except PageBuddy could make trouble */
+	__ClearPageBuddy(page);
 	add_taint(TAINT_BAD_PAGE);
 }
 
@@ -290,25 +290,31 @@ void prep_compound_gigantic_page(struct 
 }
 #endif
 
-static void destroy_compound_page(struct page *page, unsigned long order)
+static int destroy_compound_page(struct page *page, unsigned long order)
 {
 	int i;
 	int nr_pages = 1 << order;
+	int bad = 0;
 
-	if (unlikely(compound_order(page) != order))
+	if (unlikely(compound_order(page) != order) ||
+	    unlikely(!PageHead(page))) {
 		bad_page(page);
+		bad++;
+	}
 
-	if (unlikely(!PageHead(page)))
-			bad_page(page);
 	__ClearPageHead(page);
+
 	for (i = 1; i < nr_pages; i++) {
 		struct page *p = page + i;
 
-		if (unlikely(!PageTail(p) |
-				(p->first_page != page)))
+		if (unlikely(!PageTail(p) | (p->first_page != page))) {
 			bad_page(page);
+			bad++;
+		}
 		__ClearPageTail(p);
 	}
+
+	return bad;
 }
 
 static inline void prep_zero_page(struct page *page, int order, gfp_t gfp_flags)
@@ -428,7 +434,8 @@ static inline void __free_one_page(struc
 	int migratetype = get_pageblock_migratetype(page);
 
 	if (unlikely(PageCompound(page)))
-		destroy_compound_page(page, order);
+		if (unlikely(destroy_compound_page(page, order)))
+			return;
 
 	page_idx = page_to_pfn(page) & ((1 << MAX_ORDER) - 1);
 
@@ -465,15 +472,10 @@ static inline int free_pages_check(struc
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
 		(page_count(page) != 0)  |
-		(page->flags & PAGE_FLAGS_CHECK_AT_FREE)))
+		(page->flags & PAGE_FLAGS_CHECK_AT_FREE))) {
 		bad_page(page);
-	/*
-	 * For now, we report if PG_reserved was found set, but do not
-	 * clear it, and do not free the page.  But we shall soon need
-	 * to do more, for when the ZERO_PAGE count wraps negative.
-	 */
-	if (PageReserved(page))
 		return 1;
+	}
 	if (page->flags & PAGE_FLAGS_CHECK_AT_PREP)
 		page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	return 0;
@@ -521,11 +523,11 @@ static void __free_pages_ok(struct page 
 {
 	unsigned long flags;
 	int i;
-	int reserved = 0;
+	int bad = 0;
 
 	for (i = 0 ; i < (1 << order) ; ++i)
-		reserved += free_pages_check(page + i);
-	if (reserved)
+		bad += free_pages_check(page + i);
+	if (bad)
 		return;
 
 	if (!PageHighMem(page)) {
@@ -610,17 +612,11 @@ static int prep_new_page(struct page *pa
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
 		(page_count(page) != 0)  |
-		(page->flags & PAGE_FLAGS_CHECK_AT_PREP)))
+		(page->flags & PAGE_FLAGS_CHECK_AT_PREP))) {
 		bad_page(page);
-
-	/*
-	 * For now, we report if PG_reserved was found set, but do not
-	 * clear it, and do not allocate the page: as a safety net.
-	 */
-	if (PageReserved(page))
 		return 1;
+	}
 
-	page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	set_page_private(page, 0);
 	set_page_refcounted(page);
 
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

