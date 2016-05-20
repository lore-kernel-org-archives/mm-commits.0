From: akpm@linux-foundation.org
Subject: [patch 075/117] mm: use __SetPageSwapBacked and dont
 ClearPageSwapBacked
Date: Thu, 19 May 2016 17:12:41 -0700
Message-ID: <573e5679.qfPRGfA9FzDniJxv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831AbcETAMn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:12:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hughd@google.com, aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mgorman@techsingularity.net, quning@gmail.com, yang.shi@linaro.org

From: Hugh Dickins <hughd@google.com>
Subject: mm: use __SetPageSwapBacked and dont ClearPageSwapBacked

v3.16 commit 07a427884348 ("mm: shmem: avoid atomic operation during
shmem_getpage_gfp") rightly replaced one instance of SetPageSwapBacked by
__SetPageSwapBacked, pointing out that the newly allocated page is not yet
visible to other users (except speculative get_page_unless_zero- ers, who
may not update page flags before their further checks).

That was part of a series in which Mel was focused on tmpfs profiles: but
almost all SetPageSwapBacked uses can be so optimized, with the same
justification.  Remove ClearPageSwapBacked from __read_swap_cache_async()
error path: it's not an error to free a page with PG_swapbacked set.

Follow a convention of __SetPageLocked, __SetPageSwapBacked instead of
doing it differently in different places; but that's for tidiness - if the
ordering actually mattered, we should not be using the __variants.

There's probably scope for further __SetPageFlags in other places, but
SwapBacked is the one I'm interested in at the moment.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Reviewed-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c    |    6 +++---
 mm/rmap.c       |    2 +-
 mm/shmem.c      |    4 ++--
 mm/swap_state.c |    3 +--
 4 files changed, 7 insertions(+), 8 deletions(-)

diff -puN mm/migrate.c~mm-use-__setpageswapbacked-and-dont-clearpageswapbacked mm/migrate.c
--- a/mm/migrate.c~mm-use-__setpageswapbacked-and-dont-clearpageswapbacked
+++ a/mm/migrate.c
@@ -332,7 +332,7 @@ int migrate_page_move_mapping(struct add
 		newpage->index = page->index;
 		newpage->mapping = page->mapping;
 		if (PageSwapBacked(page))
-			SetPageSwapBacked(newpage);
+			__SetPageSwapBacked(newpage);
 
 		return MIGRATEPAGE_SUCCESS;
 	}
@@ -378,7 +378,7 @@ int migrate_page_move_mapping(struct add
 	newpage->index = page->index;
 	newpage->mapping = page->mapping;
 	if (PageSwapBacked(page))
-		SetPageSwapBacked(newpage);
+		__SetPageSwapBacked(newpage);
 
 	get_page(newpage);	/* add cache reference */
 	if (PageSwapCache(page)) {
@@ -1791,7 +1791,7 @@ int migrate_misplaced_transhuge_page(str
 
 	/* Prepare a page as a migration target */
 	__SetPageLocked(new_page);
-	SetPageSwapBacked(new_page);
+	__SetPageSwapBacked(new_page);
 
 	/* anon mapping, we can simply copy page->mapping to the new page: */
 	new_page->mapping = page->mapping;
diff -puN mm/rmap.c~mm-use-__setpageswapbacked-and-dont-clearpageswapbacked mm/rmap.c
--- a/mm/rmap.c~mm-use-__setpageswapbacked-and-dont-clearpageswapbacked
+++ a/mm/rmap.c
@@ -1249,7 +1249,7 @@ void page_add_new_anon_rmap(struct page
 	int nr = compound ? hpage_nr_pages(page) : 1;
 
 	VM_BUG_ON_VMA(address < vma->vm_start || address >= vma->vm_end, vma);
-	SetPageSwapBacked(page);
+	__SetPageSwapBacked(page);
 	if (compound) {
 		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 		/* increment count (starts at -1) */
diff -puN mm/shmem.c~mm-use-__setpageswapbacked-and-dont-clearpageswapbacked mm/shmem.c
--- a/mm/shmem.c~mm-use-__setpageswapbacked-and-dont-clearpageswapbacked
+++ a/mm/shmem.c
@@ -1085,8 +1085,8 @@ static int shmem_replace_page(struct pag
 	flush_dcache_page(newpage);
 
 	__SetPageLocked(newpage);
+	__SetPageSwapBacked(newpage);
 	SetPageUptodate(newpage);
-	SetPageSwapBacked(newpage);
 	set_page_private(newpage, swap_index);
 	SetPageSwapCache(newpage);
 
@@ -1276,8 +1276,8 @@ repeat:
 			goto decused;
 		}
 
-		__SetPageSwapBacked(page);
 		__SetPageLocked(page);
+		__SetPageSwapBacked(page);
 		if (sgp == SGP_WRITE)
 			__SetPageReferenced(page);
 
diff -puN mm/swap_state.c~mm-use-__setpageswapbacked-and-dont-clearpageswapbacked mm/swap_state.c
--- a/mm/swap_state.c~mm-use-__setpageswapbacked-and-dont-clearpageswapbacked
+++ a/mm/swap_state.c
@@ -358,7 +358,7 @@ struct page *__read_swap_cache_async(swp
 
 		/* May fail (-ENOMEM) if radix-tree node allocation failed. */
 		__SetPageLocked(new_page);
-		SetPageSwapBacked(new_page);
+		__SetPageSwapBacked(new_page);
 		err = __add_to_swap_cache(new_page, entry);
 		if (likely(!err)) {
 			radix_tree_preload_end();
@@ -370,7 +370,6 @@ struct page *__read_swap_cache_async(swp
 			return new_page;
 		}
 		radix_tree_preload_end();
-		ClearPageSwapBacked(new_page);
 		__ClearPageLocked(new_page);
 		/*
 		 * add_to_swap_cache() doesn't return -EEXIST, so we can safely
_
