From: akpm@linux-foundation.org
Subject: - lumpy-move-to-using-pfn_valid_within.patch removed from -mm tree
Date: Mon, 09 Jul 2007 14:10:45 -0700
Message-ID: <200707092110.l69LAj2H011918@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32818 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754492AbXGIVLc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 17:11:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, bob.picco@hp.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     lumpy: move to using pfn_valid_within()
has been removed from the -mm tree.  Its filename was
     lumpy-move-to-using-pfn_valid_within.patch

This patch was dropped because it was folded into lumpy-reclaim-v4.patch

------------------------------------------------------
Subject: lumpy: move to using pfn_valid_within()
From: Andy Whitcroft <apw@shadowen.org>

Switch to using pfn_valid_within() in lumpy reclaim.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Bob Picco <bob.picco@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/vmscan.c~lumpy-move-to-using-pfn_valid_within mm/vmscan.c
--- a/mm/vmscan.c~lumpy-move-to-using-pfn_valid_within
+++ a/mm/vmscan.c
@@ -721,11 +721,10 @@ static unsigned long isolate_lru_pages(u
 			/* The target page is in the block, ignore it. */
 			if (unlikely(pfn == page_pfn))
 				continue;
-#ifdef CONFIG_HOLES_IN_ZONE
+
 			/* Avoid holes within the zone. */
-			if (unlikely(!pfn_valid(pfn)))
+			if (unlikely(!pfn_valid_within(pfn)))
 				break;
-#endif
 
 			cursor_page = pfn_to_page(pfn);
 			/* Check that we have not crossed a zone boundary. */
_

Patches currently in -mm which might be from apw@shadowen.org are

i386-move-the-kernel-to-16mb-for-numa-q.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
add-a-configure-option-to-group-pages-by-mobility.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
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
handle-kernelcore=-generic.patch
lumpy-reclaim-v4.patch
lumpy-move-to-using-pfn_valid_within.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
update-page-order-at-an-appropriate-time-when-tracking-page_owner.patch
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
allow-page_owner-to-be-set-on-any-architecture.patch
allow-page_owner-to-be-set-on-any-architecture-fix.patch
allow-page_owner-to-be-set-on-any-architecture-fix-fix.patch
