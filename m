From: akpm@linux-foundation.org
Subject: + mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim.patch added to -mm tree
Date: Thu, 11 Apr 2013 16:44:28 -0700
Message-ID: <20130411234428.913485A41B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:44406 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab3DKXoa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 19:44:30 -0400
Received: by mail-qa0-f73.google.com with SMTP id i20so103811qad.4
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 16:44:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shli@kernel.org, aarcange@redhat.com, hannes@cmpxchg.org, hughd@google.com, liwanp@linux.vnet.ibm.com, minchan@kernel.org, riel@redhat.com, shli@fusionio.com


The patch titled
     Subject: mm: thp: add split tail pages to shrink page list in page reclaim
has been added to the -mm tree.  Its filename is
     mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shaohua Li <shli@kernel.org>
Subject: mm: thp: add split tail pages to shrink page list in page reclaim

In page reclaim, huge page is split.  split_huge_page() adds tail pages to
LRU list.  Since we are reclaiming a huge page, it's better we reclaim all
subpages of the huge page instead of just the head page.  This patch adds
split tail pages to shrink page list so the tail pages can be reclaimed
soon.

Before this patch, run a swap workload:
thp_fault_alloc 3492
thp_fault_fallback 608
thp_collapse_alloc 6
thp_collapse_alloc_failed 0
thp_split 916

With this patch:
thp_fault_alloc 4085
thp_fault_fallback 16
thp_collapse_alloc 90
thp_collapse_alloc_failed 0
thp_split 1272

fallback allocation is reduced a lot.

Signed-off-by: Shaohua Li <shli@fusionio.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   11 ++++++++++-
 include/linux/swap.h    |    4 ++--
 mm/huge_memory.c        |   14 ++++++++------
 mm/swap.c               |   11 ++++++++---
 mm/swap_state.c         |    4 ++--
 mm/vmscan.c             |    2 +-
 6 files changed, 31 insertions(+), 15 deletions(-)

diff -puN include/linux/huge_mm.h~mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim
+++ a/include/linux/huge_mm.h
@@ -99,7 +99,11 @@ extern int copy_pte_range(struct mm_stru
 extern int handle_pte_fault(struct mm_struct *mm,
 			    struct vm_area_struct *vma, unsigned long address,
 			    pte_t *pte, pmd_t *pmd, unsigned int flags);
-extern int split_huge_page(struct page *page);
+extern int split_huge_page_to_list(struct page *page, struct list_head *list);
+static inline int split_huge_page(struct page *page)
+{
+	return split_huge_page_to_list(page, NULL);
+}
 extern void __split_huge_page_pmd(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmd);
 #define split_huge_page_pmd(__vma, __address, __pmd)			\
@@ -186,6 +190,11 @@ extern int do_huge_pmd_numa_page(struct
 #define transparent_hugepage_enabled(__vma) 0
 
 #define transparent_hugepage_flags 0UL
+static inline int
+split_huge_page_to_list(struct page *page, struct list_head *list)
+{
+	return 0;
+}
 static inline int split_huge_page(struct page *page)
 {
 	return 0;
diff -puN include/linux/swap.h~mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim include/linux/swap.h
--- a/include/linux/swap.h~mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim
+++ a/include/linux/swap.h
@@ -236,7 +236,7 @@ extern unsigned long nr_free_pagecache_p
 extern void __lru_cache_add(struct page *, enum lru_list lru);
 extern void lru_cache_add_lru(struct page *, enum lru_list lru);
 extern void lru_add_page_tail(struct page *page, struct page *page_tail,
-			      struct lruvec *lruvec);
+			 struct lruvec *lruvec, struct list_head *head);
 extern void activate_page(struct page *);
 extern void mark_page_accessed(struct page *);
 extern void lru_add_drain(void);
@@ -346,7 +346,7 @@ extern struct address_space swapper_spac
 #define swap_address_space(entry) (&swapper_spaces[swp_type(entry)])
 extern unsigned long total_swapcache_pages(void);
 extern void show_swap_cache_info(void);
-extern int add_to_swap(struct page *);
+extern int add_to_swap(struct page *, struct list_head *list);
 extern int add_to_swap_cache(struct page *, swp_entry_t, gfp_t);
 extern int __add_to_swap_cache(struct page *page, swp_entry_t entry);
 extern void __delete_from_swap_cache(struct page *);
diff -puN mm/huge_memory.c~mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim
+++ a/mm/huge_memory.c
@@ -1559,7 +1559,8 @@ static int __split_huge_page_splitting(s
 	return ret;
 }
 
-static void __split_huge_page_refcount(struct page *page)
+static void __split_huge_page_refcount(struct page *page,
+				       struct list_head *list)
 {
 	int i;
 	struct zone *zone = page_zone(page);
@@ -1645,7 +1646,7 @@ static void __split_huge_page_refcount(s
 		BUG_ON(!PageDirty(page_tail));
 		BUG_ON(!PageSwapBacked(page_tail));
 
-		lru_add_page_tail(page, page_tail, lruvec);
+		lru_add_page_tail(page, page_tail, lruvec, list);
 	}
 	atomic_sub(tail_count, &page->_count);
 	BUG_ON(atomic_read(&page->_count) <= 0);
@@ -1752,7 +1753,8 @@ static int __split_huge_page_map(struct
 
 /* must be called with anon_vma->root->rwsem held */
 static void __split_huge_page(struct page *page,
-			      struct anon_vma *anon_vma)
+			      struct anon_vma *anon_vma,
+			      struct list_head *list)
 {
 	int mapcount, mapcount2;
 	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
@@ -1783,7 +1785,7 @@ static void __split_huge_page(struct pag
 		       mapcount, page_mapcount(page));
 	BUG_ON(mapcount != page_mapcount(page));
 
-	__split_huge_page_refcount(page);
+	__split_huge_page_refcount(page, list);
 
 	mapcount2 = 0;
 	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root, pgoff, pgoff) {
@@ -1798,7 +1800,7 @@ static void __split_huge_page(struct pag
 	BUG_ON(mapcount != mapcount2);
 }
 
-int split_huge_page(struct page *page)
+int split_huge_page_to_list(struct page *page, struct list_head *list)
 {
 	struct anon_vma *anon_vma;
 	int ret = 1;
@@ -1823,7 +1825,7 @@ int split_huge_page(struct page *page)
 		goto out_unlock;
 
 	BUG_ON(!PageSwapBacked(page));
-	__split_huge_page(page, anon_vma);
+	__split_huge_page(page, anon_vma, list);
 	count_vm_event(THP_SPLIT);
 
 	BUG_ON(PageCompound(page));
diff -puN mm/swap.c~mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim mm/swap.c
--- a/mm/swap.c~mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim
+++ a/mm/swap.c
@@ -737,7 +737,7 @@ EXPORT_SYMBOL(__pagevec_release);
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /* used by __split_huge_page_refcount() */
 void lru_add_page_tail(struct page *page, struct page *page_tail,
-		       struct lruvec *lruvec)
+		       struct lruvec *lruvec, struct list_head *list)
 {
 	int uninitialized_var(active);
 	enum lru_list lru;
@@ -749,7 +749,8 @@ void lru_add_page_tail(struct page *page
 	VM_BUG_ON(NR_CPUS != 1 &&
 		  !spin_is_locked(&lruvec_zone(lruvec)->lru_lock));
 
-	SetPageLRU(page_tail);
+	if (!list)
+		SetPageLRU(page_tail);
 
 	if (page_evictable(page_tail)) {
 		if (PageActive(page)) {
@@ -767,7 +768,11 @@ void lru_add_page_tail(struct page *page
 
 	if (likely(PageLRU(page)))
 		list_add_tail(&page_tail->lru, &page->lru);
-	else {
+	else if (list) {
+		/* page reclaim is reclaiming a huge page */
+		get_page(page_tail);
+		list_add_tail(&page_tail->lru, list);
+	} else {
 		struct list_head *list_head;
 		/*
 		 * Head page has not yet been counted, as an hpage,
diff -puN mm/swap_state.c~mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim mm/swap_state.c
--- a/mm/swap_state.c~mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim
+++ a/mm/swap_state.c
@@ -160,7 +160,7 @@ void __delete_from_swap_cache(struct pag
  * Allocate swap space for the page and add the page to the
  * swap cache.  Caller needs to hold the page lock. 
  */
-int add_to_swap(struct page *page)
+int add_to_swap(struct page *page, struct list_head *list)
 {
 	swp_entry_t entry;
 	int err;
@@ -173,7 +173,7 @@ int add_to_swap(struct page *page)
 		return 0;
 
 	if (unlikely(PageTransHuge(page)))
-		if (unlikely(split_huge_page(page))) {
+		if (unlikely(split_huge_page_to_list(page, list))) {
 			swapcache_free(entry, NULL);
 			return 0;
 		}
diff -puN mm/vmscan.c~mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim mm/vmscan.c
--- a/mm/vmscan.c~mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim
+++ a/mm/vmscan.c
@@ -781,7 +781,7 @@ static unsigned long shrink_page_list(st
 		if (PageAnon(page) && !PageSwapCache(page)) {
 			if (!(sc->gfp_mask & __GFP_IO))
 				goto keep_locked;
-			if (!add_to_swap(page))
+			if (!add_to_swap(page, page_list))
 				goto activate_locked;
 			may_enter_fs = 1;
 		}
_

Patches currently in -mm which might be from shli@kernel.org are

linux-next.patch
mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim.patch
kernel-smpc-cleanups.patch

