From: akpm@linux-foundation.org
Subject: + fix-calculation-in-move_freepages_block-for-counting-pages.patch added to -mm tree
Date: Tue, 29 May 2007 13:35:52 -0700
Message-ID: <200705292035.l4TKZqPw010891@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757247AbXE2UhA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 16:37:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, apw@shadowen.org, clameter@sgi.com


The patch titled
     Fix calculation in move_freepages_block for counting pages
has been added to the -mm tree.  Its filename is
     fix-calculation-in-move_freepages_block-for-counting-pages.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix calculation in move_freepages_block for counting pages
From: Mel Gorman <mel@csn.ul.ie>

move_freepages_block() returns the number of blocks moved.  This value is used
to determine if a block of pages should be stolen for the exclusive use of a
migrate type or not.  However, the value returned is being used correctly. 
This patch fixes the calculation to return the number of base pages that have
been moved.

This should be considered a fix to the patch
move-free-pages-between-lists-on-steal.patch

Credit to Andy Whitcroft for spotting the problem.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~fix-calculation-in-move_freepages_block-for-counting-pages mm/page_alloc.c
--- a/mm/page_alloc.c~fix-calculation-in-move_freepages_block-for-counting-pages
+++ a/mm/page_alloc.c
@@ -712,7 +712,7 @@ int move_freepages(struct zone *zone,
 {
 	struct page *page;
 	unsigned long order;
-	int blocks_moved = 0;
+	int pages_moved = 0;
 
 #ifndef CONFIG_HOLES_IN_ZONE
 	/*
@@ -741,10 +741,10 @@ int move_freepages(struct zone *zone,
 		list_add(&page->lru,
 			&zone->free_area[order].free_list[migratetype]);
 		page += 1 << order;
-		blocks_moved++;
+		pages_moved += 1 << order;
 	}
 
-	return blocks_moved;
+	return pages_moved;
 }
 
 int move_freepages_block(struct zone *zone, struct page *page, int migratetype)
@@ -827,7 +827,7 @@ static struct page *__rmqueue_fallback(s
 								start_migratetype);
 
 				/* Claim the whole block if over half of it is free */
-				if ((pages << current_order) >= (1 << (MAX_ORDER-2)))
+				if (pages >= (1 << (MAX_ORDER-2)))
 					set_pageblock_migratetype(page,
 								start_migratetype);
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

x86_64-extract-helper-function-from-e820_register_active_regions.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
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
remove-alloc_zeroed_user_highpage.patch
create-the-zone_movable-zone.patch
create-the-zone_movable-zone-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch
handle-kernelcore=-generic.patch
lumpy-reclaim-v4.patch
lumpy-move-to-using-pfn_valid_within.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
add-debugging-aid-for-memory-initialisation-problems.patch
