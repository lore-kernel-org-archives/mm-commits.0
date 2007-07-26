From: akpm@linux-foundation.org
Subject: + allow-nodes-to-exist-that-only-contain-zone_movable.patch added to -mm tree
Date: Thu, 26 Jul 2007 00:43:11 -0700
Message-ID: <200707260743.l6Q7hBhh020774@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42935 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753826AbXGZHoN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 03:44:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie


The patch titled
     Allow nodes to exist that only contain ZONE_MOVABLE
has been added to the -mm tree.  Its filename is
     allow-nodes-to-exist-that-only-contain-zone_movable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Allow nodes to exist that only contain ZONE_MOVABLE
From: Mel Gorman <mel@csn.ul.ie>

With the introduction of kernelcore=, a configurable zone is created on
request.  In some cases, this value will be small enough that some nodes
contain only ZONE_MOVABLE.  On some NUMA configurations when this occurs,
arch-independent zone-sizing will get the size of the memory holes within
the node incorrect.  The value of present_pages goes negative and the boot
fails.

This patch fixes the bug in the calculation of the size of the hole.  The
test case is to boot test a NUMA machine with a low value of kernelcore=
before and after the patch is applied.  While this bug exists in early
kernel it cannot be triggered in practice.

This patch has been boot-tested on a variety machines with and without
kernelcore= set.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~allow-nodes-to-exist-that-only-contain-zone_movable mm/page_alloc.c
--- a/mm/page_alloc.c~allow-nodes-to-exist-that-only-contain-zone_movable
+++ a/mm/page_alloc.c
@@ -2775,11 +2775,11 @@ unsigned long __meminit __absent_pages_i
 	if (i == -1)
 		return 0;
 
+	prev_end_pfn = min(early_node_map[i].start_pfn, range_end_pfn);
+
 	/* Account for ranges before physical memory on this node */
 	if (early_node_map[i].start_pfn > range_start_pfn)
-		hole_pages = early_node_map[i].start_pfn - range_start_pfn;
-
-	prev_end_pfn = early_node_map[i].start_pfn;
+		hole_pages = prev_end_pfn - range_start_pfn;
 
 	/* Find all holes for the zone within the node */
 	for (; i != -1; i = next_active_region_index_in_nid(i, nid)) {
_

Patches currently in -mm which might be from mel@csn.ul.ie are

allow-nodes-to-exist-that-only-contain-zone_movable.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
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
