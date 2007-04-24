From: akpm@linux-foundation.org
Subject: + create-the-zone_movable-zone-align-zone_movable-to-a-max_order_nr_pages-boundary.patch added to -mm tree
Date: Tue, 24 Apr 2007 14:05:56 -0700
Message-ID: <200704242105.l3OL5ujG019275@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423118AbXDXVGd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Apr 2007 17:06:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, apw@shadowen.org


The patch titled
     Align ZONE_MOVABLE to a MAX_ORDER_NR_PAGES boundary
has been added to the -mm tree.  Its filename is
     create-the-zone_movable-zone-align-zone_movable-to-a-max_order_nr_pages-boundary.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Align ZONE_MOVABLE to a MAX_ORDER_NR_PAGES boundary
From: Mel Gorman <mel@csn.ul.ie>

The boot memory allocator makes assumptions on the alignment of zone
boundaries even though the buddy allocator has no requirements on the
alignment of zones.  This may cause boot problems in situations where
ZONE_MOVABLE is populated because the bootmem allocator assumes zones are
at least order-log2(BITS_PER_LONG) aligned.  As the two potential users
(huge pages and memory hot-remove) of ZONE_MOVABLE would prefer a higher
alignment, this patch aligns the start of the zone instead of fixing the

This patch rounds the start of ZONE_MOVABLE in each node to a
MAX_ORDER_NR_PAGES boundary.  If the rounding pushes the start of
ZONE_MOVABLE above the end of the node then the zone will contain no memory
and will not be used at runtime.  The value is rounded up instead of down
as it is better to have the kernel-portion of memory larger than requested
instead of smaller.  The impact is that the kernel-usable portion of memory
because a minimum guarantee instead of the exact size requested by the
user.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/page_alloc.c~create-the-zone_movable-zone-align-zone_movable-to-a-max_order_nr_pages-boundary mm/page_alloc.c
--- a/mm/page_alloc.c~create-the-zone_movable-zone-align-zone_movable-to-a-max_order_nr_pages-boundary
+++ a/mm/page_alloc.c
@@ -3445,6 +3445,11 @@ restart:
 	usable_nodes--;
 	if (usable_nodes && required_kernelcore > usable_nodes)
 		goto restart;
+
+	/* Align start of ZONE_MOVABLE on all nids to MAX_ORDER_NR_PAGES */
+	for (nid = 0; nid < MAX_NUMNODES; nid++)
+		zone_movable_pfn[nid] =
+			roundup(zone_movable_pfn[nid], MAX_ORDER_NR_PAGES);
 }
 
 /**
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
create-the-zone_movable-zone-align-zone_movable-to-a-max_order_nr_pages-boundary.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
x86-specify-amount-of-kernel-memory-at-boot-time.patch
ppc-and-powerpc-specify-amount-of-kernel-memory-at-boot-time.patch
x86_64-specify-amount-of-kernel-memory-at-boot-time.patch
ia64-specify-amount-of-kernel-memory-at-boot-time.patch
add-documentation-for-additional-boot-parameter-and-sysctl.patch
handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64.patch
lumpy-reclaim-v4.patch
lumpy-back-out-removal-of-active-check-in-isolate_lru_pages.patch
lumpy-only-count-taken-pages-as-scanned.patch
kswapd-use-reclaim-order-in-background-reclaim.patch
lumpy-increase-pressure-at-the-end-of-the-inactive-list.patch
introduce-high_order-delineating-easily-reclaimable-orders.patch
add-pfn_valid_within-helper-for-sub-max_order-hole-detection.patch
anti-fragmentation-switch-over-to-pfn_valid_within.patch
lumpy-move-to-using-pfn_valid_within.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy-fix.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
do-not-disable-interrupts-when-reading-min_free_kbytes.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
add-debugging-aid-for-memory-initialisation-problems.patch
