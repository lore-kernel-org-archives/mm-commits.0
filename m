From: akpm@linux-foundation.org
Subject: - define-page_file_cache-function.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:32:35 -0700
Message-ID: <200810202032.m9KKWZA8010440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753887AbYJTUkJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:40:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, hugh@veritas.com, lee.schermerhorn@hp.com, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     define page_file_cache() function
has been removed from the -mm tree.  Its filename was
     define-page_file_cache-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: define page_file_cache() function
From: Rik van Riel <riel@redhat.com>

Define page_file_cache() function to answer the question:
	is page backed by a file?

Originally part of Rik van Riel's split-lru patch.  Extracted to make
available for other, independent reclaim patches.

Moved inline function to linux/mm_inline.h where it will be needed by
subsequent "split LRU" and "noreclaim" patches.

Unfortunately this needs to use a page flag, since the PG_swapbacked state
needs to be preserved all the way to the point where the page is last
removed from the LRU.  Trying to derive the status from other info in the
page resulted in wrong VM statistics in earlier split VM patchsets.

The total number of page flags in use on a 32 bit machine after this patch
is 19.

[akpm@linux-foundation.org: fix up out-of-order merge fallout]
[hugh@veritas.com: splitlru: shmem_getpage SetPageSwapBacked sooner[
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: MinChan Kim <minchan.kim@gmail.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h  |   27 +++++++++++++++++++++++++++
 include/linux/page-flags.h |    8 ++++++--
 mm/memory.c                |    3 +++
 mm/migrate.c               |    2 ++
 mm/page_alloc.c            |    2 ++
 mm/shmem.c                 |    1 +
 mm/swap_state.c            |    3 +++
 7 files changed, 44 insertions(+), 2 deletions(-)

diff -puN include/linux/mm_inline.h~define-page_file_cache-function include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~define-page_file_cache-function
+++ a/include/linux/mm_inline.h
@@ -1,3 +1,28 @@
+#ifndef LINUX_MM_INLINE_H
+#define LINUX_MM_INLINE_H
+
+/**
+ * page_is_file_cache - should the page be on a file LRU or anon LRU?
+ * @page: the page to test
+ *
+ * Returns !0 if @page is page cache page backed by a regular filesystem,
+ * or 0 if @page is anonymous, tmpfs or otherwise ram or swap backed.
+ * Used by functions that manipulate the LRU lists, to sort a page
+ * onto the right LRU list.
+ *
+ * We would like to get this info without a page flag, but the state
+ * needs to survive until the page is last deleted from the LRU, which
+ * could be as far down as __page_cache_release.
+ */
+static inline int page_is_file_cache(struct page *page)
+{
+	if (PageSwapBacked(page))
+		return 0;
+
+	/* The page is page cache backed by a normal filesystem. */
+	return 1;
+}
+
 static inline void
 add_page_to_lru_list(struct zone *zone, struct page *page, enum lru_list l)
 {
@@ -65,3 +90,5 @@ static inline enum lru_list page_lru(str
 
 	return lru;
 }
+
+#endif
diff -puN include/linux/page-flags.h~define-page_file_cache-function include/linux/page-flags.h
--- a/include/linux/page-flags.h~define-page_file_cache-function
+++ a/include/linux/page-flags.h
@@ -93,6 +93,7 @@ enum pageflags {
 	PG_mappedtodisk,	/* Has blocks allocated on-disk */
 	PG_reclaim,		/* To be reclaimed asap */
 	PG_buddy,		/* Page is free, on buddy lists */
+	PG_swapbacked,		/* Page is backed by RAM/swap */
 #ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
 	PG_uncached,		/* Page has been mapped as uncached */
 #endif
@@ -176,6 +177,7 @@ PAGEFLAG(SavePinned, savepinned);			/* X
 PAGEFLAG(Reserved, reserved) __CLEARPAGEFLAG(Reserved, reserved)
 PAGEFLAG(Private, private) __CLEARPAGEFLAG(Private, private)
 	__SETPAGEFLAG(Private, private)
+PAGEFLAG(SwapBacked, swapbacked) __CLEARPAGEFLAG(SwapBacked, swapbacked)
 
 __PAGEFLAG(SlobPage, slob_page)
 __PAGEFLAG(SlobFree, slob_free)
@@ -334,7 +336,8 @@ static inline void __ClearPageTail(struc
  * Flags checked in bad_page().  Pages on the free list should not have
  * these flags set.  It they are, there is a problem.
  */
-#define PAGE_FLAGS_CLEAR_WHEN_BAD (PAGE_FLAGS | 1 << PG_reclaim | 1 << PG_dirty)
+#define PAGE_FLAGS_CLEAR_WHEN_BAD (PAGE_FLAGS | \
+		1 << PG_reclaim | 1 << PG_dirty | 1 << PG_swapbacked)
 
 /*
  * Flags checked when a page is freed.  Pages being freed should not have
@@ -347,7 +350,8 @@ static inline void __ClearPageTail(struc
  * Pages being prepped should not have these flags set.  It they are, there
  * is a problem.
  */
-#define PAGE_FLAGS_CHECK_AT_PREP (PAGE_FLAGS | 1 << PG_reserved | 1 << PG_dirty)
+#define PAGE_FLAGS_CHECK_AT_PREP (PAGE_FLAGS | \
+		1 << PG_reserved | 1 << PG_dirty | 1 << PG_swapbacked)
 
 #endif /* !__GENERATING_BOUNDS_H */
 #endif	/* PAGE_FLAGS_H */
diff -puN mm/memory.c~define-page_file_cache-function mm/memory.c
--- a/mm/memory.c~define-page_file_cache-function
+++ a/mm/memory.c
@@ -1888,6 +1888,7 @@ gotten:
 		ptep_clear_flush_notify(vma, address, page_table);
 		set_pte_at(mm, address, page_table, entry);
 		update_mmu_cache(vma, address, entry);
+		SetPageSwapBacked(new_page);
 		lru_cache_add_active(new_page);
 		page_add_new_anon_rmap(new_page, vma, address);
 
@@ -2382,6 +2383,7 @@ static int do_anonymous_page(struct mm_s
 	if (!pte_none(*page_table))
 		goto release;
 	inc_mm_counter(mm, anon_rss);
+	SetPageSwapBacked(page);
 	lru_cache_add_active(page);
 	page_add_new_anon_rmap(page, vma, address);
 	set_pte_at(mm, address, page_table, entry);
@@ -2523,6 +2525,7 @@ static int __do_fault(struct mm_struct *
 		set_pte_at(mm, address, page_table, entry);
 		if (anon) {
                         inc_mm_counter(mm, anon_rss);
+			SetPageSwapBacked(page);
                         lru_cache_add_active(page);
                         page_add_new_anon_rmap(page, vma, address);
 		} else {
diff -puN mm/migrate.c~define-page_file_cache-function mm/migrate.c
--- a/mm/migrate.c~define-page_file_cache-function
+++ a/mm/migrate.c
@@ -572,6 +572,8 @@ static int move_to_new_page(struct page 
 	/* Prepare mapping for the new page.*/
 	newpage->index = page->index;
 	newpage->mapping = page->mapping;
+	if (PageSwapBacked(page))
+		SetPageSwapBacked(newpage);
 
 	mapping = page_mapping(page);
 	if (!mapping)
diff -puN mm/page_alloc.c~define-page_file_cache-function mm/page_alloc.c
--- a/mm/page_alloc.c~define-page_file_cache-function
+++ a/mm/page_alloc.c
@@ -462,6 +462,8 @@ static inline int free_pages_check(struc
 		bad_page(page);
 	if (PageDirty(page))
 		__ClearPageDirty(page);
+	if (PageSwapBacked(page))
+		__ClearPageSwapBacked(page);
 	/*
 	 * For now, we report if PG_reserved was found set, but do not
 	 * clear it, and do not free the page.  But we shall soon need
diff -puN mm/shmem.c~define-page_file_cache-function mm/shmem.c
--- a/mm/shmem.c~define-page_file_cache-function
+++ a/mm/shmem.c
@@ -1367,6 +1367,7 @@ repeat:
 				error = -ENOMEM;
 				goto failed;
 			}
+			SetPageSwapBacked(filepage);
 
 			/* Precharge page while we can wait, compensate after */
 			error = mem_cgroup_cache_charge(filepage, current->mm,
diff -puN mm/swap_state.c~define-page_file_cache-function mm/swap_state.c
--- a/mm/swap_state.c~define-page_file_cache-function
+++ a/mm/swap_state.c
@@ -75,6 +75,7 @@ int add_to_swap_cache(struct page *page,
 	BUG_ON(!PageLocked(page));
 	BUG_ON(PageSwapCache(page));
 	BUG_ON(PagePrivate(page));
+	BUG_ON(!PageSwapBacked(page));
 	error = radix_tree_preload(gfp_mask);
 	if (!error) {
 		page_cache_get(page);
@@ -303,6 +304,7 @@ struct page *read_swap_cache_async(swp_e
 		 * May fail (-ENOMEM) if radix-tree node allocation failed.
 		 */
 		set_page_locked(new_page);
+		SetPageSwapBacked(new_page);
 		err = add_to_swap_cache(new_page, entry, gfp_mask & GFP_KERNEL);
 		if (likely(!err)) {
 			/*
@@ -312,6 +314,7 @@ struct page *read_swap_cache_async(swp_e
 			swap_readpage(NULL, new_page);
 			return new_page;
 		}
+		ClearPageSwapBacked(new_page);
 		clear_page_locked(new_page);
 		swap_free(entry);
 	} while (err != -ENOMEM);
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
linux-next.patch

