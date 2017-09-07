From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-swap-delay-splitting-thp-after-swapped-out.patch removed from -mm
 tree
Date: Thu, 07 Sep 2017 11:40:10 -0700
Message-ID: <20170907184010.xF-QTKqGs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57316 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755707AbdIGSkL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:40:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, axboe@kernel.dk, dan.j.williams@intel.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, ross.zwisler@intel.com, shli@kernel.org, vishal.l.verma@intel.com, ying.huang@intel.com


The patch titled
     Subject: mm, THP, swap: delay splitting THP after swapped out
has been removed from the -mm tree.  Its filename was
     mm-thp-swap-delay-splitting-thp-after-swapped-out.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, THP, swap: delay splitting THP after swapped out

In this patch, splitting transparent huge page (THP) during swapping out
is delayed from after adding the THP into the swap cache to after swapping
out finishes.  After the patch, more operations for the anonymous THP
reclaiming, such as writing the THP to the swap device, removing the THP
from the swap cache could be batched.  So that the performance of
anonymous THP swapping out could be improved.

This is the second step for the THP swap support.  The plan is to delay
splitting the THP step by step and avoid splitting the THP finally.

With the patchset, the swap out throughput improves 42% (from about
5.81GB/s to about 8.25GB/s) in the vm-scalability swap-w-seq test case
with 16 processes.  At the same time, the IPI (reflect TLB flushing)
reduced about 78.9%.  The test is done on a Xeon E5 v3 system.  The swap
device used is a RAM simulated PMEM (persistent memory) device.  To test
the sequential swapping out, the test case creates 8 processes, which
sequentially allocate and write to the anonymous pages until the RAM and
part of the swap device is used up.

Link: http://lkml.kernel.org/r/20170724051840.2309-12-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ross Zwisler <ross.zwisler@intel.com> [for brd.c, zram_drv.c, pmem.c]
Cc: Vishal L Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   95 +++++++++++++++++++++++++++-----------------------
 1 file changed, 52 insertions(+), 43 deletions(-)

diff -puN mm/vmscan.c~mm-thp-swap-delay-splitting-thp-after-swapped-out mm/vmscan.c
--- a/mm/vmscan.c~mm-thp-swap-delay-splitting-thp-after-swapped-out
+++ a/mm/vmscan.c
@@ -536,7 +536,9 @@ static inline int is_page_cache_freeable
 	 * that isolated the page, the page cache radix tree and
 	 * optional buffer heads at page->private.
 	 */
-	return page_count(page) - page_has_private(page) == 2;
+	int radix_pins = PageTransHuge(page) && PageSwapCache(page) ?
+		HPAGE_PMD_NR : 1;
+	return page_count(page) - page_has_private(page) == 1 + radix_pins;
 }
 
 static int may_write_to_inode(struct inode *inode, struct scan_control *sc)
@@ -666,6 +668,7 @@ static int __remove_mapping(struct addre
 			    bool reclaimed)
 {
 	unsigned long flags;
+	int refcount;
 
 	BUG_ON(!PageLocked(page));
 	BUG_ON(mapping != page_mapping(page));
@@ -696,11 +699,15 @@ static int __remove_mapping(struct addre
 	 * Note that if SetPageDirty is always performed via set_page_dirty,
 	 * and thus under tree_lock, then this ordering is not required.
 	 */
-	if (!page_ref_freeze(page, 2))
+	if (unlikely(PageTransHuge(page)) && PageSwapCache(page))
+		refcount = 1 + HPAGE_PMD_NR;
+	else
+		refcount = 2;
+	if (!page_ref_freeze(page, refcount))
 		goto cannot_free;
 	/* note: atomic_cmpxchg in page_freeze_refs provides the smp_rmb */
 	if (unlikely(PageDirty(page))) {
-		page_ref_unfreeze(page, 2);
+		page_ref_unfreeze(page, refcount);
 		goto cannot_free;
 	}
 
@@ -1122,58 +1129,56 @@ static unsigned long shrink_page_list(st
 		 * Try to allocate it some swap space here.
 		 * Lazyfree page could be freed directly
 		 */
-		if (PageAnon(page) && PageSwapBacked(page) &&
-		    !PageSwapCache(page)) {
-			if (!(sc->gfp_mask & __GFP_IO))
-				goto keep_locked;
-			if (PageTransHuge(page)) {
-				/* cannot split THP, skip it */
-				if (!can_split_huge_page(page, NULL))
-					goto activate_locked;
-				/*
-				 * Split pages without a PMD map right
-				 * away. Chances are some or all of the
-				 * tail pages can be freed without IO.
-				 */
-				if (!compound_mapcount(page) &&
-				    split_huge_page_to_list(page, page_list))
-					goto activate_locked;
-			}
-			if (!add_to_swap(page)) {
-				if (!PageTransHuge(page))
-					goto activate_locked;
-				/* Split THP and swap individual base pages */
-				if (split_huge_page_to_list(page, page_list))
-					goto activate_locked;
-				if (!add_to_swap(page))
-					goto activate_locked;
-			}
-
-			/* XXX: We don't support THP writes */
-			if (PageTransHuge(page) &&
-				  split_huge_page_to_list(page, page_list)) {
-				delete_from_swap_cache(page);
-				goto activate_locked;
-			}
+		if (PageAnon(page) && PageSwapBacked(page)) {
+			if (!PageSwapCache(page)) {
+				if (!(sc->gfp_mask & __GFP_IO))
+					goto keep_locked;
+				if (PageTransHuge(page)) {
+					/* cannot split THP, skip it */
+					if (!can_split_huge_page(page, NULL))
+						goto activate_locked;
+					/*
+					 * Split pages without a PMD map right
+					 * away. Chances are some or all of the
+					 * tail pages can be freed without IO.
+					 */
+					if (!compound_mapcount(page) &&
+					    split_huge_page_to_list(page,
+								    page_list))
+						goto activate_locked;
+				}
+				if (!add_to_swap(page)) {
+					if (!PageTransHuge(page))
+						goto activate_locked;
+					/* Fallback to swap normal pages */
+					if (split_huge_page_to_list(page,
+								    page_list))
+						goto activate_locked;
+					if (!add_to_swap(page))
+						goto activate_locked;
+				}
 
-			may_enter_fs = 1;
+				may_enter_fs = 1;
 
-			/* Adding to swap updated mapping */
-			mapping = page_mapping(page);
+				/* Adding to swap updated mapping */
+				mapping = page_mapping(page);
+			}
 		} else if (unlikely(PageTransHuge(page))) {
 			/* Split file THP */
 			if (split_huge_page_to_list(page, page_list))
 				goto keep_locked;
 		}
 
-		VM_BUG_ON_PAGE(PageTransHuge(page), page);
-
 		/*
 		 * The page is mapped into the page tables of one or more
 		 * processes. Try to unmap it here.
 		 */
 		if (page_mapped(page)) {
-			if (!try_to_unmap(page, ttu_flags | TTU_BATCH_FLUSH)) {
+			enum ttu_flags flags = ttu_flags | TTU_BATCH_FLUSH;
+
+			if (unlikely(PageTransHuge(page)))
+				flags |= TTU_SPLIT_HUGE_PMD;
+			if (!try_to_unmap(page, flags)) {
 				nr_unmap_fail++;
 				goto activate_locked;
 			}
@@ -1313,7 +1318,11 @@ free_it:
 		 * Is there need to periodically free_page_list? It would
 		 * appear not as the counts should be low
 		 */
-		list_add(&page->lru, &free_pages);
+		if (unlikely(PageTransHuge(page))) {
+			mem_cgroup_uncharge(page);
+			(*get_compound_page_dtor(page))(page);
+		} else
+			list_add(&page->lru, &free_pages);
 		continue;
 
 activate_locked:
_

Patches currently in -mm which might be from ying.huang@intel.com are


