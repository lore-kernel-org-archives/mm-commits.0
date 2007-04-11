From: akpm@linux-foundation.org
Subject: + add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages-fix.patch added to -mm tree
Date: Tue, 10 Apr 2007 17:17:00 -0700
Message-ID: <200704110017.l3B0H0Y2023887@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53409 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161137AbXDKARH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 20:17:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, apw@shadowen.org


The patch titled
     Do not block align PFN when looking up the pageblock PFN
has been added to the -mm tree.  Its filename is
     add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Do not block align PFN when looking up the pageblock PFN
From: Mel Gorman <mel@csn.ul.ie>

The pageblock flags store bits representing a MAX_ORDER_NR_PAGES block of
pages.  When calling get_pageblock_bitmap(), a non-aligned PFN is passed which
is then aligned to the MAX_ORDER_NR_PAGES block.  This alignment is
unnecessary.

This patch should be considered a fix to the patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch .

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/page_alloc.c~add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages-fix mm/page_alloc.c
--- a/mm/page_alloc.c~add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages-fix
+++ a/mm/page_alloc.c
@@ -3432,9 +3432,7 @@ static inline unsigned long *get_pageblo
 							unsigned long pfn)
 {
 #ifdef CONFIG_SPARSEMEM
-	unsigned long blockpfn;
-	blockpfn = pfn & ~(MAX_ORDER_NR_PAGES - 1);
-	return __pfn_to_section(blockpfn)->pageblock_flags;
+	return __pfn_to_section(pfn)->pageblock_flags;
 #else
 	return zone->pageblock_flags;
 #endif /* CONFIG_SPARSEMEM */
_

Patches currently in -mm which might be from mel@csn.ul.ie are

add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-low-memory-that-may-be-migrated.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
add-a-configure-option-to-group-pages-by-mobility-speedup.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
move-free-pages-between-lists-on-steal-fix.patch
move-free-pages-between-lists-on-steal-fix-2.patch
move-free-pages-between-lists-on-steal-avoid-unsafe-use-of-struct-pages-in-move_freepages-when-config_holes_in_zone-is-set.patch
move-free-pages-between-lists-on-steal-do-not-cross-section-boundary-when-moving-pages-between-mobility-lists.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
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
do-not-disable-interrupts-when-reading-min_free_kbytes.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
add-debugging-aid-for-memory-initialisation-problems.patch
