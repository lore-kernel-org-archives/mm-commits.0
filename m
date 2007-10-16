From: akpm@linux-foundation.org
Subject: - fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix-fix.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:33:00 -0700
Message-ID: <200710160433.l9G4X0s7008943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36989 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753925AbXJPEdE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:33:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix fix
has been removed from the -mm tree.  Its filename was
     fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix-fix.patch

This patch was dropped because it was folded into fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch

------------------------------------------------------
Subject: fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix fix
From: Mel Gorman <mel@csn.ul.ie>

On (25/07/07 15:49), Mel Gorman didst pronounce:
> > SuperH allmodconfig blew up:
> >
> > mm/sparse.c: In function `sparse_init':
> > mm/sparse.c:482: error: implicit declaration of function `sparse_early_usemap_alloc'
> > mm/sparse.c:482: warning: assignment makes pointer from integer without a cast
> > mm/sparse.c: In function `sparse_add_one_section':
> > mm/sparse.c:553: error: implicit declaration of function `__kmalloc_section_usemap'
> > mm/sparse.c:553: warning: assignment makes pointer from integer without a cast
>
> This error is due to a bad interaction between
> generic-virtual-memmap-support-for-sparsemem.patch and
> fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
> . Functions that are needed whether CONFIG_SPARSEMEM_VMEMMAP is set are
> not are depending on CONFIG_SPARSEMEM_VMEMMAP . This breaks on arch/sh
> for example where SPARSEMEM may be set but not NUMA.
>

This patch only moves code and does not alter it. However, as SPARSEMEM
is set without NUMA, the code move generates a warning on SuperH because
NODE_DATA(nid) is a no-op. The following patch supresses the warning

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/sparse.c~fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix-fix mm/sparse.c
--- a/mm/sparse.c~fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix-fix
+++ a/mm/sparse.c
@@ -251,6 +251,9 @@ static unsigned long *sparse_early_usema
 	if (usemap)
 		return usemap;
 
+	/* Stupid: suppress gcc warning for SPARSEMEM && !NUMA */
+	nid = 0;
+
 	printk(KERN_WARNING "%s: allocation failed\n", __FUNCTION__);
 	return NULL;
 }
_

Patches currently in -mm which might be from mel@csn.ul.ie are

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
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap-update.patch
hugetlb-try-to-grow-hugetlb-pool-for-map_private-mappings.patch
ext2-reservations.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
