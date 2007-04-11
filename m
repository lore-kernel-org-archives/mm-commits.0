From: akpm@linux-foundation.org
Subject: + bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy-fix.patch added to -mm tree
Date: Tue, 10 Apr 2007 17:12:51 -0700
Message-ID: <200704110012.l3B0CpNN023788@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53308 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161062AbXDKAND (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 20:13:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, apw@shadowen.org


The patch titled
     Remove unnecessary check for MIGRATE_RESERVE during boot
has been added to the -mm tree.  Its filename is
     bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove unnecessary check for MIGRATE_RESERVE during boot
From: Mel Gorman <mel@csn.ul.ie>

At boot time, a number of MAX_ORDER_NR_PAGES get marked MIGRATE_RESERVE and
the remainder get marked MIGRATE_MOVABLE.  The blocks are marked MOVABLE in
memmap_init_zone() before any blocks are marked reserve.  A check is made in
memmap_init_zone() for (get_pageblock_migratetype(page) != MIGRATE_RESERVE)
which is a waste of time because the reserve has not been set yet.  This
oversight was because an early version of the MIGRATE_RESERVE patch set blocks
MIGRATE_RESERVE earlier.  This patch gets rid of the redundant check.

This should be considered a fix for
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/page_alloc.c~bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy-fix mm/page_alloc.c
--- a/mm/page_alloc.c~bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy-fix
+++ a/mm/page_alloc.c
@@ -2352,8 +2352,7 @@ void __meminit memmap_init_zone(unsigned
 		 * the start are marked MIGRATE_RESERVE by
 		 * setup_zone_migrate_reserve()
 		 */
-		if ((pfn & (MAX_ORDER_NR_PAGES-1)) == 0 &&
-				get_pageblock_migratetype(page) != MIGRATE_RESERVE)
+		if ((pfn & (MAX_ORDER_NR_PAGES-1)))
 			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 
 		INIT_LIST_HEAD(&page->lru);
_

Patches currently in -mm which might be from mel@csn.ul.ie are

add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-low-memory-that-may-be-migrated.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
move-free-pages-between-lists-on-steal-fix.patch
move-free-pages-between-lists-on-steal-fix-2.patch
move-free-pages-between-lists-on-steal-avoid-unsafe-use-of-struct-pages-in-move_freepages-when-config_holes_in_zone-is-set.patch
move-free-pages-between-lists-on-steal-do-not-cross-section-boundary-when-moving-pages-between-mobility-lists.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
create-the-zone_movable-zone.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
x86-specify-amount-of-kernel-memory-at-boot-time.patch
ppc-and-powerpc-specify-amount-of-kernel-memory-at-boot-time.patch
x86_64-specify-amount-of-kernel-memory-at-boot-time.patch
ia64-specify-amount-of-kernel-memory-at-boot-time.patch
add-documentation-for-additional-boot-parameter-and-sysctl.patch
lumpy-reclaim-v4.patch
lumpy-back-out-removal-of-active-check-in-isolate_lru_pages.patch
lumpy-only-count-taken-pages-as-scanned.patch
add-pfn_valid_within-helper-for-sub-max_order-hole-detection.patch
anti-fragmentation-switch-over-to-pfn_valid_within.patch
lumpy-move-to-using-pfn_valid_within.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy-fix.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
reduce-the-amount-of-time-spent-in-the-per-cpu-allocator.patch
do-not-block-align-pfn-when-looking-up-the-pageblock-pfn.patch
do-not-disable-interrupts-when-reading-min_free_kbytes.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
add-debugging-aid-for-memory-initialisation-problems.patch
