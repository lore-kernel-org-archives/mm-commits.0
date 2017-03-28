From: akpm@linux-foundation.org
Subject: + mm-thp-swap-support-to-add-delete-thp-to-from-swap-cache.patch
 added to -mm tree
Date: Tue, 28 Mar 2017 15:14:24 -0700
Message-ID: <58dae040.bk47GNi1f1usmFa+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44240 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755865AbdC1WO7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2017 18:14:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, aarcange@redhat.com, ebru.akagunduz@gmail.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, THP, swap: support to add/delete THP to/from swap cache
has been added to the -mm tree.  Its filename is
     mm-thp-swap-support-to-add-delete-thp-to-from-swap-cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-swap-support-to-add-delete-thp-to-from-swap-cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-swap-support-to-add-delete-thp-to-from-swap-cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, THP, swap: support to add/delete THP to/from swap cache

With this patch, a THP (Transparent Huge Page) can be added/deleted
to/from the swap cache as a set of (HPAGE_PMD_NR) sub-pages.

This will be used for the THP (Transparent Huge Page) swap support.  Where
one THP may be added/delted to/from the swap cache.  This will batch the
swap cache operations to reduce the lock acquire/release times for the THP
swap too.

Link: http://lkml.kernel.org/r/20170328053209.25876-7-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    5 +-
 mm/swap_state.c            |   64 ++++++++++++++++++++++-------------
 2 files changed, 45 insertions(+), 24 deletions(-)

diff -puN include/linux/page-flags.h~mm-thp-swap-support-to-add-delete-thp-to-from-swap-cache include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-thp-swap-support-to-add-delete-thp-to-from-swap-cache
+++ a/include/linux/page-flags.h
@@ -326,11 +326,12 @@ PAGEFLAG_FALSE(HighMem)
 #ifdef CONFIG_SWAP
 static __always_inline int PageSwapCache(struct page *page)
 {
+	page = compound_head(page);
 	return PageSwapBacked(page) && test_bit(PG_swapcache, &page->flags);
 
 }
-SETPAGEFLAG(SwapCache, swapcache, PF_NO_COMPOUND)
-CLEARPAGEFLAG(SwapCache, swapcache, PF_NO_COMPOUND)
+SETPAGEFLAG(SwapCache, swapcache, PF_NO_TAIL)
+CLEARPAGEFLAG(SwapCache, swapcache, PF_NO_TAIL)
 #else
 PAGEFLAG_FALSE(SwapCache)
 #endif
diff -puN mm/swap_state.c~mm-thp-swap-support-to-add-delete-thp-to-from-swap-cache mm/swap_state.c
--- a/mm/swap_state.c~mm-thp-swap-support-to-add-delete-thp-to-from-swap-cache
+++ a/mm/swap_state.c
@@ -38,6 +38,7 @@ struct address_space *swapper_spaces[MAX
 static unsigned int nr_swapper_spaces[MAX_SWAPFILES];
 
 #define INC_CACHE_INFO(x)	do { swap_cache_info.x++; } while (0)
+#define ADD_CACHE_INFO(x, nr)	do { swap_cache_info.x += (nr); } while (0)
 
 static struct {
 	unsigned long add_total;
@@ -90,39 +91,52 @@ void show_swap_cache_info(void)
  */
 int __add_to_swap_cache(struct page *page, swp_entry_t entry)
 {
-	int error;
+	int error, i, nr = hpage_nr_pages(page);
 	struct address_space *address_space;
+	struct page *cur_page;
+	swp_entry_t cur_entry;
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageSwapCache(page), page);
 	VM_BUG_ON_PAGE(!PageSwapBacked(page), page);
 
-	get_page(page);
+	page_ref_add(page, nr);
 	SetPageSwapCache(page);
-	set_page_private(page, entry.val);
 
 	address_space = swap_address_space(entry);
+	cur_page = page;
+	cur_entry.val = entry.val;
 	spin_lock_irq(&address_space->tree_lock);
-	error = radix_tree_insert(&address_space->page_tree,
-				  swp_offset(entry), page);
-	if (likely(!error)) {
-		address_space->nrpages++;
-		__inc_node_page_state(page, NR_FILE_PAGES);
-		INC_CACHE_INFO(add_total);
+	for (i = 0; i < nr; i++, cur_page++, cur_entry.val++) {
+		set_page_private(cur_page, cur_entry.val);
+		error = radix_tree_insert(&address_space->page_tree,
+					  swp_offset(cur_entry), cur_page);
+		if (unlikely(error))
+			break;
 	}
-	spin_unlock_irq(&address_space->tree_lock);
-
-	if (unlikely(error)) {
+	if (likely(!error)) {
+		address_space->nrpages += nr;
+		__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, nr);
+		ADD_CACHE_INFO(add_total, nr);
+	} else {
 		/*
 		 * Only the context which have set SWAP_HAS_CACHE flag
 		 * would call add_to_swap_cache().
 		 * So add_to_swap_cache() doesn't returns -EEXIST.
 		 */
 		VM_BUG_ON(error == -EEXIST);
-		set_page_private(page, 0UL);
+		set_page_private(cur_page, 0UL);
+		while (i--) {
+			cur_page--;
+			cur_entry.val--;
+			radix_tree_delete(&address_space->page_tree,
+					  swp_offset(cur_entry));
+			set_page_private(cur_page, 0UL);
+		}
 		ClearPageSwapCache(page);
-		put_page(page);
+		page_ref_sub(page, nr);
 	}
+	spin_unlock_irq(&address_space->tree_lock);
 
 	return error;
 }
@@ -132,7 +146,7 @@ int add_to_swap_cache(struct page *page,
 {
 	int error;
 
-	error = radix_tree_maybe_preload(gfp_mask);
+	error = radix_tree_maybe_preload_order(gfp_mask, compound_order(page));
 	if (!error) {
 		error = __add_to_swap_cache(page, entry);
 		radix_tree_preload_end();
@@ -148,6 +162,7 @@ void __delete_from_swap_cache(struct pag
 {
 	swp_entry_t entry;
 	struct address_space *address_space;
+	int i, nr = hpage_nr_pages(page);
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
@@ -155,12 +170,17 @@ void __delete_from_swap_cache(struct pag
 
 	entry.val = page_private(page);
 	address_space = swap_address_space(entry);
-	radix_tree_delete(&address_space->page_tree, swp_offset(entry));
-	set_page_private(page, 0);
+	for (i = 0; i < nr; i++, entry.val++) {
+		struct page *cur_page = page + i;
+
+		radix_tree_delete(&address_space->page_tree,
+				  swp_offset(entry));
+		set_page_private(cur_page, 0);
+	}
 	ClearPageSwapCache(page);
-	address_space->nrpages--;
-	__dec_node_page_state(page, NR_FILE_PAGES);
-	INC_CACHE_INFO(del_total);
+	address_space->nrpages -= nr;
+	__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, -nr);
+	ADD_CACHE_INFO(del_total, nr);
 }
 
 /**
@@ -237,8 +257,8 @@ void delete_from_swap_cache(struct page
 	__delete_from_swap_cache(page);
 	spin_unlock_irq(&address_space->tree_lock);
 
-	swapcache_free(entry);
-	put_page(page);
+	__swapcache_free(entry, PageTransHuge(page));
+	page_ref_sub(page, hpage_nr_pages(page));
 }
 
 /* 
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-swap-fix-a-race-in-free_swap_and_cache.patch
mm-swap-fix-comment-in-__read_swap_cache_async.patch
mm-swap-improve-readability-via-make-spin_lock-unlock-balanced.patch
mm-swap-avoid-lock-swap_avail_lock-when-held-cluster-lock.patch
mm-swap-make-swap-cluster-size-same-of-thp-size-on-x86_64.patch
mm-memcg-support-to-charge-uncharge-multiple-swap-entries.patch
mm-thp-swap-add-swap-cluster-allocate-free-functions.patch
mm-thp-swap-add-get_huge_swap_page.patch
mm-thp-swap-support-to-clear-swap_has_cache-for-huge-page.patch
mm-thp-swap-support-to-add-delete-thp-to-from-swap-cache.patch
mm-thp-add-can_split_huge_page.patch
mm-thp-swap-support-to-split-thp-in-swap-cache.patch
mm-thp-swap-delay-splitting-thp-during-swap-out.patch

