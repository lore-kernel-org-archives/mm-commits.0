From: akpm@linux-foundation.org
Subject: - move-free-pages-between-lists-on-steal-anti-fragmentation-switch-over-to-pfn_valid_within.patch removed from -mm tree
Date: Tue, 29 May 2007 13:28:24 -0700
Message-ID: <200705292028.l4TKSOhV010713@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752224AbXE2U3Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 16:29:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, andyw@uk.ibm.com, bob.picco@hp.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     anti-fragmentation: switch over to pfn_valid_within()
has been removed from the -mm tree.  Its filename was
     move-free-pages-between-lists-on-steal-anti-fragmentation-switch-over-to-pfn_valid_within.patch

This patch was dropped because it was folded into move-free-pages-between-lists-on-steal.patch

------------------------------------------------------
Subject: anti-fragmentation: switch over to pfn_valid_within()
From: Andy Whitcroft <apw@shadowen.org>

Move to using pfn_valid_within().

Signed-off-by: Andy Whitcroft <andyw@uk.ibm.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Bob Picco <bob.picco@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/page_alloc.c~move-free-pages-between-lists-on-steal-anti-fragmentation-switch-over-to-pfn_valid_within mm/page_alloc.c
--- a/mm/page_alloc.c~move-free-pages-between-lists-on-steal-anti-fragmentation-switch-over-to-pfn_valid_within
+++ a/mm/page_alloc.c
@@ -699,12 +699,10 @@ int move_freepages(struct zone *zone,
 #endif
 
 	for (page = start_page; page <= end_page;) {
-#ifdef CONFIG_HOLES_IN_ZONE
-		if (!pfn_valid(page_to_pfn(page))) {
+		if (!pfn_valid_within(page_to_pfn(page))) {
 			page++;
 			continue;
 		}
-#endif
 
 		if (!PageBuddy(page)) {
 			page++;
_

Patches currently in -mm which might be from apw@shadowen.org are

pci-device-ensure-sysdata-initialised-v2.patch
move-three-functions-that-are-only-needed-for.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
add-a-configure-option-to-group-pages-by-mobility.patch
move-free-pages-between-lists-on-steal.patch
move-free-pages-between-lists-on-steal-anti-fragmentation-switch-over-to-pfn_valid_within.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
group-short-lived-and-reclaimable-kernel-allocations-do-not-annotate-shmem-allocations-explicitly.patch
group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
dont-group-high-order-atomic-allocations-remove-unused-parameter-to-allocflags_to_migratetype.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
remove-alloc_zeroed_user_highpage.patch
create-the-zone_movable-zone.patch
handle-kernelcore=-generic.patch
lumpy-reclaim-v4.patch
lumpy-move-to-using-pfn_valid_within.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
