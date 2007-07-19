From: akpm@linux-foundation.org
Subject: - remove-alloc_zeroed_user_highpage.patch removed from -mm tree
Date: Thu, 19 Jul 2007 12:59:43 -0700
Message-ID: <200707191959.l6JJxhIA019375@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53972 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758490AbXGSUAx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:00:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     Remove alloc_zeroed_user_highpage()
has been removed from the -mm tree.  Its filename was
     remove-alloc_zeroed_user_highpage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove alloc_zeroed_user_highpage()
From: Mel Gorman <mel@csn.ul.ie>

alloc_zeroed_user_highpage() has no in-tree users and it is not exported.
As it is not exported, it can simply be removed.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |   15 ---------------
 1 file changed, 15 deletions(-)

diff -puN include/linux/highmem.h~remove-alloc_zeroed_user_highpage include/linux/highmem.h
--- a/include/linux/highmem.h~remove-alloc_zeroed_user_highpage
+++ a/include/linux/highmem.h
@@ -103,21 +103,6 @@ __alloc_zeroed_user_highpage(gfp_t movab
 #endif
 
 /**
- * alloc_zeroed_user_highpage - Allocate a zeroed HIGHMEM page for a VMA
- * @vma: The VMA the page is to be allocated for
- * @vaddr: The virtual address the page will be inserted into
- *
- * This function will allocate a page for a VMA that the caller knows will
- * not be able to move in the future using move_pages() or reclaim. If it
- * is known that the page can move, use alloc_zeroed_user_highpage_movable
- */
-static inline struct page *
-alloc_zeroed_user_highpage(struct vm_area_struct *vma, unsigned long vaddr)
-{
-	return __alloc_zeroed_user_highpage(0, vma, vaddr);
-}
-
-/**
  * alloc_zeroed_user_highpage_movable - Allocate a zeroed HIGHMEM page for a VMA that the caller knows can move
  * @vma: The VMA the page is to be allocated for
  * @vaddr: The virtual address the page will be inserted into
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
