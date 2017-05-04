From: akpm@linux-foundation.org
Subject: [merged] mm-reclaim-madv_free-pages.patch removed from -mm
 tree
Date: Thu, 04 May 2017 12:09:44 -0700
Message-ID: <20170504190944.raR6JJaAR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50966 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756511AbdEDTJp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:09:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, shli@fb.com


The patch titled
     Subject: mm: reclaim MADV_FREE pages
has been removed from the -mm tree.  Its filename was
     mm-reclaim-madv_free-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shaohua Li <shli@fb.com>
Subject: mm: reclaim MADV_FREE pages

When memory pressure is high, we free MADV_FREE pages.  If the pages are
not dirty in pte, the pages could be freed immediately.  Otherwise we
can't reclaim them.  We put the pages back to anonumous LRU list (by
setting SwapBacked flag) and the pages will be reclaimed in normal swapout
way.

We use normal page reclaim policy.  Since MADV_FREE pages are put into
inactive file list, such pages and inactive file pages are reclaimed
according to their age.  This is expected, because we don't want to
reclaim too many MADV_FREE pages before used once pages.

Based on Minchan's original patch

[minchan@kernel.org: clean up lazyfree page handling]
  Link: http://lkml.kernel.org/r/20170303025237.GB3503@bbox
Link: http://lkml.kernel.org/r/14b8eb1d3f6bf6cc492833f183ac8c304e560484.1487965799.git.shli@fb.com
Signed-off-by: Shaohua Li <shli@fb.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 -
 mm/huge_memory.c     |    2 +
 mm/madvise.c         |    1 
 mm/rmap.c            |   46 +++++++++++++++++------------------------
 mm/vmscan.c          |   34 +++++++++++++++++++-----------
 5 files changed, 46 insertions(+), 39 deletions(-)

diff -puN include/linux/rmap.h~mm-reclaim-madv_free-pages include/linux/rmap.h
--- a/include/linux/rmap.h~mm-reclaim-madv_free-pages
+++ a/include/linux/rmap.h
@@ -298,6 +298,6 @@ static inline int page_mkclean(struct pa
 #define SWAP_AGAIN	1
 #define SWAP_FAIL	2
 #define SWAP_MLOCK	3
-#define SWAP_LZFREE	4
+#define SWAP_DIRTY	4
 
 #endif	/* _LINUX_RMAP_H */
diff -puN mm/huge_memory.c~mm-reclaim-madv_free-pages mm/huge_memory.c
--- a/mm/huge_memory.c~mm-reclaim-madv_free-pages
+++ a/mm/huge_memory.c
@@ -1572,6 +1572,8 @@ bool madvise_free_huge_pmd(struct mmu_ga
 		set_pmd_at(mm, addr, pmd, orig_pmd);
 		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 	}
+
+	mark_page_lazyfree(page);
 	ret = true;
 out:
 	spin_unlock(ptl);
diff -puN mm/madvise.c~mm-reclaim-madv_free-pages mm/madvise.c
--- a/mm/madvise.c~mm-reclaim-madv_free-pages
+++ a/mm/madvise.c
@@ -413,6 +413,7 @@ static int madvise_free_pte_range(pmd_t
 			set_pte_at(mm, addr, pte, ptent);
 			tlb_remove_tlb_entry(tlb, pte, addr);
 		}
+		mark_page_lazyfree(page);
 	}
 out:
 	if (nr_swap) {
diff -puN mm/rmap.c~mm-reclaim-madv_free-pages mm/rmap.c
--- a/mm/rmap.c~mm-reclaim-madv_free-pages
+++ a/mm/rmap.c
@@ -1288,11 +1288,6 @@ void page_remove_rmap(struct page *page,
 	 */
 }
 
-struct rmap_private {
-	enum ttu_flags flags;
-	int lazyfreed;
-};
-
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -1308,8 +1303,7 @@ static int try_to_unmap_one(struct page
 	pte_t pteval;
 	struct page *subpage;
 	int ret = SWAP_AGAIN;
-	struct rmap_private *rp = arg;
-	enum ttu_flags flags = rp->flags;
+	enum ttu_flags flags = (enum ttu_flags)arg;
 
 	/* munlock has nothing to gain from examining un-locked vmas */
 	if ((flags & TTU_MUNLOCK) && !(vma->vm_flags & VM_LOCKED))
@@ -1427,11 +1421,21 @@ static int try_to_unmap_one(struct page
 			VM_BUG_ON_PAGE(!PageSwapCache(page) && PageSwapBacked(page),
 				page);
 
-			if (!PageDirty(page)) {
-				/* It's a freeable page by MADV_FREE */
-				dec_mm_counter(mm, MM_ANONPAGES);
-				rp->lazyfreed++;
-				goto discard;
+			/* MADV_FREE page check */
+			if (!PageSwapBacked(page)) {
+				if (!PageDirty(page)) {
+					dec_mm_counter(mm, MM_ANONPAGES);
+					goto discard;
+				}
+
+				/*
+				 * If the page was redirtied, it cannot be
+				 * discarded. Remap the page to page table.
+				 */
+				set_pte_at(mm, address, pvmw.pte, pteval);
+				ret = SWAP_DIRTY;
+				page_vma_mapped_walk_done(&pvmw);
+				break;
 			}
 
 			if (swap_duplicate(entry) < 0) {
@@ -1499,18 +1503,15 @@ static int page_mapcount_is_zero(struct
  * SWAP_AGAIN	- we missed a mapping, try again later
  * SWAP_FAIL	- the page is unswappable
  * SWAP_MLOCK	- page is mlocked.
+ * SWAP_DIRTY	- page is dirty MADV_FREE page
  */
 int try_to_unmap(struct page *page, enum ttu_flags flags)
 {
 	int ret;
-	struct rmap_private rp = {
-		.flags = flags,
-		.lazyfreed = 0,
-	};
 
 	struct rmap_walk_control rwc = {
 		.rmap_one = try_to_unmap_one,
-		.arg = &rp,
+		.arg = (void *)flags,
 		.done = page_mapcount_is_zero,
 		.anon_lock = page_lock_anon_vma_read,
 	};
@@ -1531,11 +1532,8 @@ int try_to_unmap(struct page *page, enum
 	else
 		ret = rmap_walk(page, &rwc);
 
-	if (ret != SWAP_MLOCK && !page_mapcount(page)) {
+	if (ret != SWAP_MLOCK && !page_mapcount(page))
 		ret = SWAP_SUCCESS;
-		if (rp.lazyfreed && !PageDirty(page))
-			ret = SWAP_LZFREE;
-	}
 	return ret;
 }
 
@@ -1562,14 +1560,10 @@ static int page_not_mapped(struct page *
 int try_to_munlock(struct page *page)
 {
 	int ret;
-	struct rmap_private rp = {
-		.flags = TTU_MUNLOCK,
-		.lazyfreed = 0,
-	};
 
 	struct rmap_walk_control rwc = {
 		.rmap_one = try_to_unmap_one,
-		.arg = &rp,
+		.arg = (void *)TTU_MUNLOCK,
 		.done = page_not_mapped,
 		.anon_lock = page_lock_anon_vma_read,
 
diff -puN mm/vmscan.c~mm-reclaim-madv_free-pages mm/vmscan.c
--- a/mm/vmscan.c~mm-reclaim-madv_free-pages
+++ a/mm/vmscan.c
@@ -906,7 +906,8 @@ static void page_check_dirty_writeback(s
 	 * Anonymous pages are not handled by flushers and must be written
 	 * from reclaim context. Do not stall reclaim based on them
 	 */
-	if (!page_is_file_cache(page)) {
+	if (!page_is_file_cache(page) ||
+	    (PageAnon(page) && !PageSwapBacked(page))) {
 		*dirty = false;
 		*writeback = false;
 		return;
@@ -987,7 +988,8 @@ static unsigned long shrink_page_list(st
 			goto keep_locked;
 
 		/* Double the slab pressure for mapped and swapcache pages */
-		if (page_mapped(page) || PageSwapCache(page))
+		if ((page_mapped(page) || PageSwapCache(page)) &&
+		    !(PageAnon(page) && !PageSwapBacked(page)))
 			sc->nr_scanned++;
 
 		may_enter_fs = (sc->gfp_mask & __GFP_FS) ||
@@ -1113,8 +1115,10 @@ static unsigned long shrink_page_list(st
 		/*
 		 * Anonymous process memory has backing store?
 		 * Try to allocate it some swap space here.
+		 * Lazyfree page could be freed directly
 		 */
-		if (PageAnon(page) && !PageSwapCache(page)) {
+		if (PageAnon(page) && PageSwapBacked(page) &&
+		    !PageSwapCache(page)) {
 			if (!(sc->gfp_mask & __GFP_IO))
 				goto keep_locked;
 			if (!add_to_swap(page, page_list))
@@ -1135,9 +1139,12 @@ static unsigned long shrink_page_list(st
 		 * The page is mapped into the page tables of one or more
 		 * processes. Try to unmap it here.
 		 */
-		if (page_mapped(page) && mapping) {
+		if (page_mapped(page)) {
 			switch (ret = try_to_unmap(page,
 				ttu_flags | TTU_BATCH_FLUSH)) {
+			case SWAP_DIRTY:
+				SetPageSwapBacked(page);
+				/* fall through */
 			case SWAP_FAIL:
 				nr_unmap_fail++;
 				goto activate_locked;
@@ -1145,8 +1152,6 @@ static unsigned long shrink_page_list(st
 				goto keep_locked;
 			case SWAP_MLOCK:
 				goto cull_mlocked;
-			case SWAP_LZFREE:
-				goto lazyfree;
 			case SWAP_SUCCESS:
 				; /* try to free the page below */
 			}
@@ -1258,10 +1263,18 @@ static unsigned long shrink_page_list(st
 			}
 		}
 
-lazyfree:
-		if (!mapping || !__remove_mapping(mapping, page, true))
-			goto keep_locked;
+		if (PageAnon(page) && !PageSwapBacked(page)) {
+			/* follow __remove_mapping for reference */
+			if (!page_ref_freeze(page, 1))
+				goto keep_locked;
+			if (PageDirty(page)) {
+				page_ref_unfreeze(page, 1);
+				goto keep_locked;
+			}
 
+			count_vm_event(PGLAZYFREED);
+		} else if (!mapping || !__remove_mapping(mapping, page, true))
+			goto keep_locked;
 		/*
 		 * At this point, we have no other references and there is
 		 * no way to pick any more up (removed from LRU, removed
@@ -1271,9 +1284,6 @@ lazyfree:
 		 */
 		__ClearPageLocked(page);
 free_it:
-		if (ret == SWAP_LZFREE)
-			count_vm_event(PGLAZYFREED);
