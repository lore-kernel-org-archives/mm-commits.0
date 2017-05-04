From: akpm@linux-foundation.org
Subject: [merged]
 mm-dont-assume-anonymous-pages-have-swapbacked-flag.patch removed from -mm
 tree
Date: Thu, 04 May 2017 12:09:38 -0700
Message-ID: <20170504190938.C6drUERga%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50934 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756417AbdEDTJj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:09:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, shli@fb.com


The patch titled
     Subject: mm: don't assume anonymous pages have SwapBacked flag
has been removed from the -mm tree.  Its filename was
     mm-dont-assume-anonymous-pages-have-swapbacked-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shaohua Li <shli@fb.com>
Subject: mm: don't assume anonymous pages have SwapBacked flag

There are a few places the code assumes anonymous pages should have
SwapBacked flag set. MADV_FREE pages are anonymous pages but we are
going to add them to LRU_INACTIVE_FILE list and clear SwapBacked flag
for them. The assumption doesn't hold any more, so fix them.

Link: http://lkml.kernel.org/r/3945232c0df3dd6c4ef001976f35a95f18dcb407.1487965799.git.shli@fb.com
Signed-off-by: Shaohua Li <shli@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 -
 mm/khugepaged.c  |    8 +++-----
 mm/migrate.c     |    3 ++-
 mm/rmap.c        |    3 ++-
 4 files changed, 7 insertions(+), 8 deletions(-)

diff -puN mm/huge_memory.c~mm-dont-assume-anonymous-pages-have-swapbacked-flag mm/huge_memory.c
--- a/mm/huge_memory.c~mm-dont-assume-anonymous-pages-have-swapbacked-flag
+++ a/mm/huge_memory.c
@@ -2399,7 +2399,6 @@ int split_huge_page_to_list(struct page
 
 	VM_BUG_ON_PAGE(is_huge_zero_page(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(!PageSwapBacked(page), page);
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
 
 	if (PageAnon(head)) {
diff -puN mm/khugepaged.c~mm-dont-assume-anonymous-pages-have-swapbacked-flag mm/khugepaged.c
--- a/mm/khugepaged.c~mm-dont-assume-anonymous-pages-have-swapbacked-flag
+++ a/mm/khugepaged.c
@@ -483,8 +483,7 @@ void __khugepaged_exit(struct mm_struct
 
 static void release_pte_page(struct page *page)
 {
-	/* 0 stands for page_is_file_cache(page) == false */
-	dec_node_page_state(page, NR_ISOLATED_ANON + 0);
+	dec_node_page_state(page, NR_ISOLATED_ANON + page_is_file_cache(page));
 	unlock_page(page);
 	putback_lru_page(page);
 }
@@ -532,7 +531,6 @@ static int __collapse_huge_page_isolate(
 
 		VM_BUG_ON_PAGE(PageCompound(page), page);
 		VM_BUG_ON_PAGE(!PageAnon(page), page);
-		VM_BUG_ON_PAGE(!PageSwapBacked(page), page);
 
 		/*
 		 * We can do it before isolate_lru_page because the
@@ -579,8 +577,8 @@ static int __collapse_huge_page_isolate(
 			result = SCAN_DEL_PAGE_LRU;
 			goto out;
 		}
-		/* 0 stands for page_is_file_cache(page) == false */
-		inc_node_page_state(page, NR_ISOLATED_ANON + 0);
+		inc_node_page_state(page,
+				NR_ISOLATED_ANON + page_is_file_cache(page));
 		VM_BUG_ON_PAGE(!PageLocked(page), page);
 		VM_BUG_ON_PAGE(PageLRU(page), page);
 
diff -puN mm/migrate.c~mm-dont-assume-anonymous-pages-have-swapbacked-flag mm/migrate.c
--- a/mm/migrate.c~mm-dont-assume-anonymous-pages-have-swapbacked-flag
+++ a/mm/migrate.c
@@ -1944,7 +1944,8 @@ int migrate_misplaced_transhuge_page(str
 
 	/* Prepare a page as a migration target */
 	__SetPageLocked(new_page);
-	__SetPageSwapBacked(new_page);
+	if (PageSwapBacked(page))
+		__SetPageSwapBacked(new_page);
 
 	/* anon mapping, we can simply copy page->mapping to the new page: */
 	new_page->mapping = page->mapping;
diff -puN mm/rmap.c~mm-dont-assume-anonymous-pages-have-swapbacked-flag mm/rmap.c
--- a/mm/rmap.c~mm-dont-assume-anonymous-pages-have-swapbacked-flag
+++ a/mm/rmap.c
@@ -1424,7 +1424,8 @@ static int try_to_unmap_one(struct page
 			 * Store the swap location in the pte.
 			 * See handle_pte_fault() ...
 			 */
-			VM_BUG_ON_PAGE(!PageSwapCache(page), page);
+			VM_BUG_ON_PAGE(!PageSwapCache(page) && PageSwapBacked(page),
+				page);
 
 			if (!PageDirty(page)) {
 				/* It's a freeable page by MADV_FREE */
_

Patches currently in -mm which might be from shli@fb.com are


