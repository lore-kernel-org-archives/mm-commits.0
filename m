From: akpm@linux-foundation.org
Subject: - only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch removed from -mm tree
Date: Mon, 01 Oct 2007 14:34:58 -0700
Message-ID: <200710012134.l91LYw5O004215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54511 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755719AbXJAVfs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2007 17:35:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Only check absolute watermarks for ALLOC_HIGH and ALLOC_HARDER allocations
has been removed from the -mm tree.  Its filename was
     only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Only check absolute watermarks for ALLOC_HIGH and ALLOC_HARDER allocations
From: Mel Gorman <mel@csn.ul.ie>

zone_watermark_ok() checks if there are enough free pages including a reserve.
 High-order allocations additionally check if there are enough free high-order
pages in relation to the watermark adjusted based on the requested size.  If
there are not enough free high-order pages available, 0 is returned so that
the caller enters direct reclaim.

ALLOC_HIGH and ALLOC_HARDER allocations are allowed to dip further into the
reserves but also take into account if the number of free high-order pages
meet the adjusted watermarks.  As these allocations cannot sleep, they cannot
enter direct reclaim so the allocation can fail even though the pages are
available and the number of free pages is well above the watermark for
order-0.

This patch alters the behaviour of zone_watermark_ok() slightly.  Watermarks
are still obeyed but when an allocator is flagged ALLOC_HIGH or ALLOC_HARDER,
we only check that there is sufficient memory over the reserve to satisfy the
allocation, allocation size is ignored.  This patch also documents better what
zone_watermark_ok() is doing.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN mm/page_alloc.c~only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations mm/page_alloc.c
--- a/mm/page_alloc.c~only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations
+++ a/mm/page_alloc.c
@@ -1242,13 +1242,34 @@ int zone_watermark_ok(struct zone *z, in
 	long free_pages = zone_page_state(z, NR_FREE_PAGES) - (1 << order) + 1;
 	int o;
 
+	/*
+	 * Allow ALLOC_HIGH and ALLOC_HARDER to dip further into reserves
+	 * ALLOC_HIGH              => Reduce the required reserve by a half
+	 * ALLOC_HARDER            => Reduce the required reserve by a quarter
+	 * ALLOC_HIGH|ALLOC_HARDER => Reduce the required reserve by 5/8ths
+	 */
 	if (alloc_flags & ALLOC_HIGH)
 		min -= min / 2;
 	if (alloc_flags & ALLOC_HARDER)
 		min -= min / 4;
 
+	/* Ensure there are sufficient total pages less the reserve. */
 	if (free_pages <= min + z->lowmem_reserve[classzone_idx])
 		return 0;
+
+	/*
+	 * If the allocation is flagged ALLOC_HARDER or ALLOC_HIGH, the
+	 * caller cannot enter direct reclaim, so allow them to take a page
+	 * if one exists as the absolute reserves have been met.
+	 */
+	if (alloc_flags & (ALLOC_HARDER | ALLOC_HIGH))
+		return 1;
+
+	/*
+	 * For higher order allocations that can sleep, check that there
+	 * are enough free high-order pages above a reserve adjusted
+	 * based on the requested order.
+	 */
 	for (o = 0; o < order; o++) {
 		/* At the next order, this order's pages become unavailable */
 		free_pages -= z->free_area[o].nr_free << o;
_

Patches currently in -mm which might be from mel@csn.ul.ie are

sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation.patch
sparc64-sparsemem_vmemmap-support.patch
sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-convert-to-new-config-options.patch
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
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap-update.patch
ext2-reservations.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
