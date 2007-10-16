From: akpm@linux-foundation.org
Subject: - fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:32:54 -0700
Message-ID: <200710160432.l9G4WsFd008935@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48394 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753957AbXJPEdh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:33:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2 fix
has been removed from the -mm tree.  Its filename was
     fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch

This patch was dropped because it was folded into fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch

------------------------------------------------------
Subject: fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2 fix
From: Mel Gorman <mel@csn.ul.ie>

On (24/07/07 22:01), Andrew Morton didst pronounce:
> On Tue, 13 Mar 2007 10:42:02 +0000 mel@skynet.ie (Mel Gorman) wrote:
>
> > There are problems in the use of SPARSEMEM and pageblock flags that causes
> > problems on ia64.
> >
> > <SNIP>
>
> SuperH allmodconfig blew up:
>
> mm/sparse.c: In function `sparse_init':
> mm/sparse.c:482: error: implicit declaration of function `sparse_early_usemap_alloc'
> mm/sparse.c:482: warning: assignment makes pointer from integer without a cast
> mm/sparse.c: In function `sparse_add_one_section':
> mm/sparse.c:553: error: implicit declaration of function `__kmalloc_section_usemap'
> mm/sparse.c:553: warning: assignment makes pointer from integer without a cast

This error is due to a bad interaction between
generic-virtual-memmap-support-for-sparsemem.patch and
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
. Functions that are needed whether CONFIG_SPARSEMEM_VMEMMAP is set are
not are depending on CONFIG_SPARSEMEM_VMEMMAP . This breaks on arch/sh
for example where SPARSEMEM may be set but not NUMA.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   58 +++++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff -puN mm/sparse.c~fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix mm/sparse.c
--- a/mm/sparse.c~fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix
+++ a/mm/sparse.c
@@ -226,6 +226,35 @@ void *alloc_bootmem_high_node(pg_data_t 
 	return NULL;
 }
 
+static unsigned long usemap_size(void)
+{
+	unsigned long size_bytes;
+	size_bytes = roundup(SECTION_BLOCKFLAGS_BITS, 8) / 8;
+	size_bytes = roundup(size_bytes, sizeof(unsigned long));
+	return size_bytes;
+}
+
+#ifdef CONFIG_MEMORY_HOTPLUG
+static unsigned long *__kmalloc_section_usemap(void)
+{
+	return kmalloc(usemap_size(), GFP_KERNEL);
+}
+#endif /* CONFIG_MEMORY_HOTPLUG */
+
+static unsigned long *sparse_early_usemap_alloc(unsigned long pnum)
+{
+	unsigned long *usemap;
+	struct mem_section *ms = __nr_to_section(pnum);
+	int nid = sparse_early_nid(ms);
+
+	usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
+	if (usemap)
+		return usemap;
+
+	printk(KERN_WARNING "%s: allocation failed\n", __FUNCTION__);
+	return NULL;
+}
+
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
 struct page __init *sparse_early_mem_map_populate(unsigned long pnum, int nid)
 {
@@ -262,35 +291,6 @@ struct page __init *sparse_early_mem_map
 	return NULL;
 }
 
-static unsigned long usemap_size(void)
-{
-	unsigned long size_bytes;
- 	size_bytes = roundup(SECTION_BLOCKFLAGS_BITS, 8) / 8;
-	size_bytes = roundup(size_bytes, sizeof(unsigned long));
-	return size_bytes;
-}
-
-#ifdef CONFIG_MEMORY_HOTPLUG
-static unsigned long *__kmalloc_section_usemap(void)
-{
-	return kmalloc(usemap_size(), GFP_KERNEL);
-}
-#endif /* CONFIG_MEMORY_HOTPLUG */
-
-static unsigned long *sparse_early_usemap_alloc(unsigned long pnum)
-{
-	unsigned long *usemap;
-	struct mem_section *ms = __nr_to_section(pnum);
-	int nid = sparse_early_nid(ms);
-
-	usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
-	if (usemap)
-		return usemap;
-
-	printk(KERN_WARNING "%s: allocation failed\n", __FUNCTION__);
-	return NULL;
-}
-
 /*
  * Allocate the accumulated non-linear sections, allocate a mem_map
  * for each and record the physical to section mapping.
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
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch
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
