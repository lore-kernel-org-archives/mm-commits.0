From: akpm@linux-foundation.org
Subject: [merged] mm-rename-page-struct-field-helpers.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:53:41 -0800
Message-ID: <20130225205341.A81A731C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:50196 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759761Ab3BYUxm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:53:42 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so348231yhz.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:53:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename page struct field helpers
has been removed from the -mm tree.  Its filename was
     mm-rename-page-struct-field-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: rename page struct field helpers

The function names page_xchg_last_nid(), page_last_nid() and
reset_page_last_nid() were judged to be inconsistent so rename them to a
struct_field_op style pattern.  As it looked jarring to have
reset_page_mapcount() and page_nid_reset_last() beside each other in
memmap_init_zone(), this patch also renames reset_page_mapcount() to
page_mapcount_reset().  There are others like init_page_count() but as it
is used throughout the arch code a rename would likely cause more
conflicts than it is worth.

[akpm@linux-foundation.org: fix zcache]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/zcache/zbud.c            |    2 +-
 drivers/staging/zsmalloc/zsmalloc-main.c |    2 +-
 include/linux/mm.h                       |   20 ++++++++++----------
 mm/huge_memory.c                         |    2 +-
 mm/mempolicy.c                           |    2 +-
 mm/migrate.c                             |    4 ++--
 mm/mmzone.c                              |    4 ++--
 mm/page_alloc.c                          |   10 +++++-----
 mm/slob.c                                |    2 +-
 mm/slub.c                                |    2 +-
 10 files changed, 25 insertions(+), 25 deletions(-)

diff -puN drivers/staging/zcache/zbud.c~mm-rename-page-struct-field-helpers drivers/staging/zcache/zbud.c
--- a/drivers/staging/zcache/zbud.c~mm-rename-page-struct-field-helpers
+++ a/drivers/staging/zcache/zbud.c
@@ -404,7 +404,7 @@ static inline struct page *zbud_unuse_zb
 	else
 		zbud_pers_pageframes--;
 	zbudpage_spin_unlock(zbudpage);
-	reset_page_mapcount(page);
+	page_mapcount_reset(page);
 	init_page_count(page);
 	page->index = 0;
 	return page;
diff -puN drivers/staging/zsmalloc/zsmalloc-main.c~mm-rename-page-struct-field-helpers drivers/staging/zsmalloc/zsmalloc-main.c
--- a/drivers/staging/zsmalloc/zsmalloc-main.c~mm-rename-page-struct-field-helpers
+++ a/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -472,7 +472,7 @@ static void reset_page(struct page *page
 	set_page_private(page, 0);
 	page->mapping = NULL;
 	page->freelist = NULL;
-	reset_page_mapcount(page);
+	page_mapcount_reset(page);
 }
 
 static void free_zspage(struct page *first_page)
diff -puN include/linux/mm.h~mm-rename-page-struct-field-helpers include/linux/mm.h
--- a/include/linux/mm.h~mm-rename-page-struct-field-helpers
+++ a/include/linux/mm.h
@@ -367,7 +367,7 @@ static inline struct page *compound_head
  * both from it and to it can be tracked, using atomic_inc_and_test
  * and atomic_add_negative(-1).
  */
-static inline void reset_page_mapcount(struct page *page)
+static inline void page_mapcount_reset(struct page *page)
 {
 	atomic_set(&(page)->_mapcount, -1);
 }
@@ -658,28 +658,28 @@ static inline int page_to_nid(const stru
 
 #ifdef CONFIG_NUMA_BALANCING
 #ifdef LAST_NID_NOT_IN_PAGE_FLAGS
-static inline int page_xchg_last_nid(struct page *page, int nid)
+static inline int page_nid_xchg_last(struct page *page, int nid)
 {
 	return xchg(&page->_last_nid, nid);
 }
 
-static inline int page_last_nid(struct page *page)
+static inline int page_nid_last(struct page *page)
 {
 	return page->_last_nid;
 }
-static inline void reset_page_last_nid(struct page *page)
+static inline void page_nid_reset_last(struct page *page)
 {
 	page->_last_nid = -1;
 }
 #else
-static inline int page_last_nid(struct page *page)
+static inline int page_nid_last(struct page *page)
 {
 	return (page->flags >> LAST_NID_PGSHIFT) & LAST_NID_MASK;
 }
 
-extern int page_xchg_last_nid(struct page *page, int nid);
+extern int page_nid_xchg_last(struct page *page, int nid);
 
-static inline void reset_page_last_nid(struct page *page)
+static inline void page_nid_reset_last(struct page *page)
 {
 	int nid = (1 << LAST_NID_SHIFT) - 1;
 
@@ -688,17 +688,17 @@ static inline void reset_page_last_nid(s
 }
 #endif /* LAST_NID_NOT_IN_PAGE_FLAGS */
 #else
-static inline int page_xchg_last_nid(struct page *page, int nid)
+static inline int page_nid_xchg_last(struct page *page, int nid)
 {
 	return page_to_nid(page);
 }
 
-static inline int page_last_nid(struct page *page)
+static inline int page_nid_last(struct page *page)
 {
 	return page_to_nid(page);
 }
 
-static inline void reset_page_last_nid(struct page *page)
+static inline void page_nid_reset_last(struct page *page)
 {
 }
 #endif
diff -puN mm/huge_memory.c~mm-rename-page-struct-field-helpers mm/huge_memory.c
--- a/mm/huge_memory.c~mm-rename-page-struct-field-helpers
+++ a/mm/huge_memory.c
@@ -1639,7 +1639,7 @@ static void __split_huge_page_refcount(s
 		page_tail->mapping = page->mapping;
 
 		page_tail->index = page->index + i;
-		page_xchg_last_nid(page_tail, page_last_nid(page));
+		page_nid_xchg_last(page_tail, page_nid_last(page));
 
 		BUG_ON(!PageAnon(page_tail));
 		BUG_ON(!PageUptodate(page_tail));
diff -puN mm/mempolicy.c~mm-rename-page-struct-field-helpers mm/mempolicy.c
--- a/mm/mempolicy.c~mm-rename-page-struct-field-helpers
+++ a/mm/mempolicy.c
@@ -2316,7 +2316,7 @@ int mpol_misplaced(struct page *page, st
 		 * it less likely we act on an unlikely task<->page
 		 * relation.
 		 */
-		last_nid = page_xchg_last_nid(page, polnid);
+		last_nid = page_nid_xchg_last(page, polnid);
 		if (last_nid != polnid)
 			goto out;
 	}
diff -puN mm/migrate.c~mm-rename-page-struct-field-helpers mm/migrate.c
--- a/mm/migrate.c~mm-rename-page-struct-field-helpers
+++ a/mm/migrate.c
@@ -1497,7 +1497,7 @@ static struct page *alloc_misplaced_dst_
 					  __GFP_NOWARN) &
 					 ~GFP_IOFS, 0);
 	if (newpage)
-		page_xchg_last_nid(newpage, page_last_nid(page));
+		page_nid_xchg_last(newpage, page_nid_last(page));
 
 	return newpage;
 }
@@ -1681,7 +1681,7 @@ int migrate_misplaced_transhuge_page(str
 	if (!new_page)
 		goto out_fail;
 
-	page_xchg_last_nid(new_page, page_last_nid(page));
+	page_nid_xchg_last(new_page, page_nid_last(page));
 
 	isolated = numamigrate_isolate_page(pgdat, page);
 	if (!isolated) {
diff -puN mm/mmzone.c~mm-rename-page-struct-field-helpers mm/mmzone.c
--- a/mm/mmzone.c~mm-rename-page-struct-field-helpers
+++ a/mm/mmzone.c
@@ -98,14 +98,14 @@ void lruvec_init(struct lruvec *lruvec)
 }
 
 #if defined(CONFIG_NUMA_BALANCING) && !defined(LAST_NID_NOT_IN_PAGE_FLAGS)
-int page_xchg_last_nid(struct page *page, int nid)
+int page_nid_xchg_last(struct page *page, int nid)
 {
 	unsigned long old_flags, flags;
 	int last_nid;
 
 	do {
 		old_flags = flags = page->flags;
-		last_nid = page_last_nid(page);
+		last_nid = page_nid_last(page);
 
 		flags &= ~(LAST_NID_MASK << LAST_NID_PGSHIFT);
 		flags |= (nid & LAST_NID_MASK) << LAST_NID_PGSHIFT;
diff -puN mm/page_alloc.c~mm-rename-page-struct-field-helpers mm/page_alloc.c
--- a/mm/page_alloc.c~mm-rename-page-struct-field-helpers
+++ a/mm/page_alloc.c
@@ -295,7 +295,7 @@ static void bad_page(struct page *page)
 
 	/* Don't complain about poisoned pages */
 	if (PageHWPoison(page)) {
-		reset_page_mapcount(page); /* remove PageBuddy */
+		page_mapcount_reset(page); /* remove PageBuddy */
 		return;
 	}
 
@@ -327,7 +327,7 @@ static void bad_page(struct page *page)
 	dump_stack();
 out:
 	/* Leave bad fields for debug, except PageBuddy could make trouble */
-	reset_page_mapcount(page); /* remove PageBuddy */
+	page_mapcount_reset(page); /* remove PageBuddy */
 	add_taint(TAINT_BAD_PAGE);
 }
 
@@ -613,7 +613,7 @@ static inline int free_pages_check(struc
 		bad_page(page);
 		return 1;
 	}
-	reset_page_last_nid(page);
+	page_nid_reset_last(page);
 	if (page->flags & PAGE_FLAGS_CHECK_AT_PREP)
 		page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	return 0;
@@ -3894,8 +3894,8 @@ void __meminit memmap_init_zone(unsigned
 		set_page_links(page, zone, nid, pfn);
 		mminit_verify_page_links(page, zone, nid, pfn);
 		init_page_count(page);
-		reset_page_mapcount(page);
-		reset_page_last_nid(page);
+		page_mapcount_reset(page);
+		page_nid_reset_last(page);
 		SetPageReserved(page);
 		/*
 		 * Mark the block movable so that blocks are reserved for
diff -puN mm/slob.c~mm-rename-page-struct-field-helpers mm/slob.c
--- a/mm/slob.c~mm-rename-page-struct-field-helpers
+++ a/mm/slob.c
@@ -360,7 +360,7 @@ static void slob_free(void *block, int s
 			clear_slob_page_free(sp);
 		spin_unlock_irqrestore(&slob_lock, flags);
 		__ClearPageSlab(sp);
-		reset_page_mapcount(sp);
+		page_mapcount_reset(sp);
 		slob_free_pages(b, 0);
 		return;
 	}
diff -puN mm/slub.c~mm-rename-page-struct-field-helpers mm/slub.c
--- a/mm/slub.c~mm-rename-page-struct-field-helpers
+++ a/mm/slub.c
@@ -1408,7 +1408,7 @@ static void __free_slab(struct kmem_cach
 	__ClearPageSlab(page);
 
 	memcg_release_pages(s, order);
-	reset_page_mapcount(page);
+	page_mapcount_reset(page);
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += pages;
 	__free_memcg_kmem_pages(page, order);
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-memmap_init_zone-performance-improvement.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch

