From: akpm@linux-foundation.org
Subject: + check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on.patch added to -mm tree
Date: Mon, 23 Jul 2007 13:42:52 -0700
Message-ID: <200707232042.l6NKgqon010836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44911 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761778AbXGWUsv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 16:48:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, chris@zankel.net, davem@davemloft.net, hugh@veritas.com, kyle@mcmartin.ca, rmk@arm.linux.org.uk


The patch titled
     Check for PageSlab in arch flush_dcache_page to avoid triggering VM_BUG_ON
has been added to the -mm tree.  Its filename is
     check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Check for PageSlab in arch flush_dcache_page to avoid triggering VM_BUG_ON
From: Christoph Lameter <clameter@sgi.com>

We added a VM_BUG_ON in include/linux/mm.h to detect page cache functions
used on slab pages.  However, arches that have virtual caches may call
flush_dcache_page for slab pages since they may have been put on scatter
gather lists.

Modify the functions in the affected arches to check for PageSlab() and use
a NULL mapping if such a page is encountered.  This may only be necessary
for parisc and arm since sparc64 and xtensa do not scan over processes
mapping a page but I have modified those two arches also for correctnesses
sake since they use page_mapping() in flush_dcache_page().

If we have done that then we no longer need to return a NULL mapping in
page_mapping() for slab pages (Its a bit strange to have that given the
earlier VM_BUG_ON(PageSlab(page)).

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Christian Zankel <chris@zankel.net>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/flush.c        |   12 +++++++++++-
 arch/parisc/kernel/cache.c |   11 ++++++++++-
 arch/sparc64/mm/init.c     |   10 +++++++++-
 arch/xtensa/mm/init.c      |   11 ++++++++++-
 include/linux/mm.h         |    4 ----
 5 files changed, 40 insertions(+), 8 deletions(-)

diff -puN arch/arm/mm/flush.c~check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on arch/arm/mm/flush.c
--- a/arch/arm/mm/flush.c~check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on
+++ a/arch/arm/mm/flush.c
@@ -188,7 +188,17 @@ static void __flush_dcache_aliases(struc
  */
 void flush_dcache_page(struct page *page)
 {
-	struct address_space *mapping = page_mapping(page);
+	struct address_space *mapping;
+
+	/*
+	 * This function is special in that a page struct obtained via
+	 * virt_to_page from a slab object may be passed to it. However, slab
+	 * allocators may use the mapping field for their own purposes. As a
+	 * result mapping may be != NULL here although the page is not mapped.
+	 * Slab objects are never mapped into user space so use NULL for that
+	 * special case.
+	 */
+	mapping = PageSlab(page) ? NULL : page_mapping(page);
 
 #ifndef CONFIG_SMP
 	if (mapping && !mapping_mapped(mapping))
diff -puN arch/parisc/kernel/cache.c~check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on arch/parisc/kernel/cache.c
--- a/arch/parisc/kernel/cache.c~check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on
+++ a/arch/parisc/kernel/cache.c
@@ -339,7 +339,7 @@ __flush_cache_page(struct vm_area_struct
 
 void flush_dcache_page(struct page *page)
 {
-	struct address_space *mapping = page_mapping(page);
+	struct address_space *mapping;
 	struct vm_area_struct *mpnt;
 	struct prio_tree_iter iter;
 	unsigned long offset;
@@ -347,6 +347,15 @@ void flush_dcache_page(struct page *page
 	pgoff_t pgoff;
 	unsigned long pfn = page_to_pfn(page);
 
+	/*
+	 * This function is special in that a page struct obtained via
+	 * virt_to_page from a slab object may be passed to it. However, slab
+	 * allocators may use the mapping field for their own purposes. As a
+	 * result mapping may be != NULL here although the page is not mapped.
+	 * Slab objects are never mapped into user space so use NULL for that
+	 * special case.
+	 */
+	mapping = PageSlab(page) ? NULL : page_mapping(page);
 
 	if (mapping && !mapping_mapped(mapping)) {
 		set_bit(PG_dcache_dirty, &page->flags);
diff -puN arch/sparc64/mm/init.c~check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on arch/sparc64/mm/init.c
--- a/arch/sparc64/mm/init.c~check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on
+++ a/arch/sparc64/mm/init.c
@@ -339,7 +339,15 @@ void flush_dcache_page(struct page *page
 
 	this_cpu = get_cpu();
 
-	mapping = page_mapping(page);
+	/*
+	 * This function is special in that a page struct obtained via
+	 * virt_to_page from a slab object may be passed to it. However, slab
+	 * allocators may use the mapping field for their own purposes. As a
+	 * result mapping may be != NULL here although the page is not mapped.
+	 * Slab objects are never mapped into user space so use NULL for that
+	 * special case.
+	 */
+	mapping = PageSlab(page) ? NULL : page_mapping(page);
 	if (mapping && !mapping_mapped(mapping)) {
 		int dirty = test_bit(PG_dcache_dirty, &page->flags);
 		if (dirty) {
diff -puN arch/xtensa/mm/init.c~check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on arch/xtensa/mm/init.c
--- a/arch/xtensa/mm/init.c~check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on
+++ a/arch/xtensa/mm/init.c
@@ -433,7 +433,7 @@ void copy_user_page(void* to, void* from
 void flush_dcache_page(struct page *page)
 {
 	unsigned long addr = __pa(page_address(page));
-	struct address_space *mapping = page_mapping(page);
+	struct address_space *mapping;
 
 	__flush_invalidate_dcache_page_phys(addr);
 
@@ -442,6 +442,15 @@ void flush_dcache_page(struct page *page
 
 	/* If this page hasn't been mapped, yet, handle I$/D$ coherency later.*/
 #if 0
+	/*
+	 * This function is special in that a page struct obtained via
+	 * virt_to_page from a slab object may be passed to it. However, slab
+	 * allocators may use the mapping field for their own purposes. As a
+	 * result mapping may be != NULL although the page is not mapped.
+	 * Slab objects are never mapped into user space so use NULL for that
+	 * special case.
+	 */
+	mapping = PageSlab(page) ? NULL : page_mapping(page);
 	if (mapping && !mapping_mapped(mapping))
 		clear_bit(PG_cache_clean, &page->flags);
 	else
diff -puN include/linux/mm.h~check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on include/linux/mm.h
--- a/include/linux/mm.h~check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on
+++ a/include/linux/mm.h
@@ -630,10 +630,6 @@ static inline struct address_space *page
 	VM_BUG_ON(PageSlab(page));
 	if (unlikely(PageSwapCache(page)))
 		mapping = &swapper_space;
-#ifdef CONFIG_SLUB
-	else if (unlikely(PageSlab(page)))
-		mapping = NULL;
-#endif
 	else if (unlikely((unsigned long)mapping & PAGE_MAPPING_ANON))
 		mapping = NULL;
 	return mapping;
_

Patches currently in -mm which might be from clameter@sgi.com are

check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
try-parent-numa_node-at-first-before-using-default-v2.patch
try-parent-numa_node-at-first-before-using-default-v2-fix.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
memory-unplug-v7-migration-by-kernel.patch
memory-unplug-v7-isolate_lru_page-fix.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
page-owner-tracking-leak-detector.patch
