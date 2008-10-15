From: akpm@linux-foundation.org
Subject: - mm-page-allocator-minor-speedup.patch removed from -mm tree
Date: Wed, 15 Oct 2008 14:31:26 -0700
Message-ID: <200810152131.m9FLVQar007676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753540AbYJOVcQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 17:32:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: page allocator minor speedup
has been removed from the -mm tree.  Its filename was
     mm-page-allocator-minor-speedup.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: page allocator minor speedup
From: Nick Piggin <npiggin@suse.de>

Now that we don't put a ZERO_PAGE in the pagetables any more, and the
"remove PageReserved from core mm" patch has had a long time to mature,
let's remove the page reserved logic from the allocator.

This saves several branches and about 100 bytes in some important paths.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    6 +++---
 mm/page_alloc.c            |   31 +++++--------------------------
 2 files changed, 8 insertions(+), 29 deletions(-)

diff -puN include/linux/page-flags.h~mm-page-allocator-minor-speedup include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-page-allocator-minor-speedup
+++ a/include/linux/page-flags.h
@@ -377,7 +377,7 @@ static inline void __ClearPageTail(struc
 #define PAGE_FLAGS	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
 			 1 << PG_buddy | 1 << PG_writeback | \
 			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active | \
-			 __PG_UNEVICTABLE | __PG_MLOCKED)
+			 __PG_UNEVICTABLE | __PG_MLOCKED | 1 << PG_reserved)
 
 /*
  * Flags checked in bad_page().  Pages on the free list should not have
@@ -390,7 +390,7 @@ static inline void __ClearPageTail(struc
  * Flags checked when a page is freed.  Pages being freed should not have
  * these flags set.  It they are, there is a problem.
  */
-#define PAGE_FLAGS_CHECK_AT_FREE (PAGE_FLAGS | 1 << PG_reserved)
+#define PAGE_FLAGS_CHECK_AT_FREE (PAGE_FLAGS)
 
 /*
  * Flags checked when a page is prepped for return by the page allocator.
@@ -398,7 +398,7 @@ static inline void __ClearPageTail(struc
  * is a problem.
  */
 #define PAGE_FLAGS_CHECK_AT_PREP (PAGE_FLAGS | \
-		1 << PG_reserved | 1 << PG_dirty | 1 << PG_swapbacked)
+		1 << PG_dirty | 1 << PG_swapbacked)
 
 #endif /* !__GENERATING_BOUNDS_H */
 #endif	/* PAGE_FLAGS_H */
diff -puN mm/page_alloc.c~mm-page-allocator-minor-speedup mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page-allocator-minor-speedup
+++ a/mm/page_alloc.c
@@ -449,7 +449,7 @@ static inline void __free_one_page(struc
 	zone->free_area[order].nr_free++;
 }
 
-static inline int free_pages_check(struct page *page)
+static inline void free_pages_check(struct page *page)
 {
 	free_page_mlock(page);
 	if (unlikely(page_mapcount(page) |
@@ -462,12 +462,6 @@ static inline int free_pages_check(struc
 		__ClearPageDirty(page);
 	if (PageSwapBacked(page))
 		__ClearPageSwapBacked(page);
-	/*
-	 * For now, we report if PG_reserved was found set, but do not
-	 * clear it, and do not free the page.  But we shall soon need
-	 * to do more, for when the ZERO_PAGE count wraps negative.
-	 */
-	return PageReserved(page);
 }
 
 /*
@@ -512,12 +506,9 @@ static void __free_pages_ok(struct page 
 {
 	unsigned long flags;
 	int i;
-	int reserved = 0;
 
 	for (i = 0 ; i < (1 << order) ; ++i)
-		reserved += free_pages_check(page + i);
-	if (reserved)
-		return;
+		free_pages_check(page + i);
 
 	if (!PageHighMem(page)) {
 		debug_check_no_locks_freed(page_address(page),PAGE_SIZE<<order);
@@ -596,7 +587,7 @@ static inline void expand(struct zone *z
 /*
  * This page is about to be returned from the page allocator
  */
-static int prep_new_page(struct page *page, int order, gfp_t gfp_flags)
+static void prep_new_page(struct page *page, int order, gfp_t gfp_flags)
 {
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
@@ -605,13 +596,6 @@ static int prep_new_page(struct page *pa
 		(page->flags & PAGE_FLAGS_CHECK_AT_PREP)))
 		bad_page(page);
 
-	/*
-	 * For now, we report if PG_reserved was found set, but do not
-	 * clear it, and do not allocate the page: as a safety net.
-	 */
-	if (PageReserved(page))
-		return 1;
-
 	page->flags &= ~(1 << PG_uptodate | 1 << PG_error | 1 << PG_reclaim |
 			1 << PG_referenced | 1 << PG_arch_1 |
 			1 << PG_owner_priv_1 | 1 << PG_mappedtodisk
@@ -630,8 +614,6 @@ static int prep_new_page(struct page *pa
 
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
-
-	return 0;
 }
 
 /*
@@ -980,8 +962,7 @@ static void free_hot_cold_page(struct pa
 
 	if (PageAnon(page))
 		page->mapping = NULL;
-	if (free_pages_check(page))
-		return;
+	free_pages_check(page);
 
 	if (!PageHighMem(page)) {
 		debug_check_no_locks_freed(page_address(page), PAGE_SIZE);
@@ -1049,7 +1030,6 @@ static struct page *buffered_rmqueue(str
 	int cpu;
 	int migratetype = allocflags_to_migratetype(gfp_flags);
 
-again:
 	cpu  = get_cpu();
 	if (likely(order == 0)) {
 		struct per_cpu_pages *pcp;
@@ -1097,8 +1077,7 @@ again:
 	put_cpu();
 
 	VM_BUG_ON(bad_range(zone, page));
-	if (prep_new_page(page, order, gfp_flags))
-		goto again;
+	prep_new_page(page, order, gfp_flags);
 	return page;
 
 failed:
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics.patch
mm-pagecache-insertion-fewer-atomics.patch
mm-unlockless-reclaim.patch
mm-page-lock-use-lock-bitops.patch
fs-buffer-lock-use-lock-bitops.patch
mm-page-allocator-minor-speedup.patch
mm-rewrite-vmap-layer.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
ecryptfs-convert-to-use-new-aops.patch
ecryptfs-convert-to-use-new-aops-update.patch
afs-convert-to-new-aops.patch
afs-convert-to-new-aops-update.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

