From: akpm@linux-foundation.org
Subject: + generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch added to -mm tree
Date: Mon, 06 Aug 2007 11:53:20 -0700
Message-ID: <200708061853.l76IrKMU009368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42363 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763732AbXHFSyJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 14:54:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, clameter@sgi.com, haveblue@us.ibm.com


The patch titled
     vmemmap: simplify initialisation code and reduce duplication
has been added to the -mm tree.  Its filename is
     generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vmemmap: simplify initialisation code and reduce duplication
From: Andy Whitcroft <apw@shadowen.org>

The vmemmap and non-vmemmap implementations of sparse_early_mem_map_alloc()
share a fair amount of code.  Refactor this into a common wrapper, pulling the
differences out to sparse_early_mem_map_populate().  This reduces depandancies
between SPARSMEM and SPARSEMEM_VMEMMAP simplifying separation.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff -puN mm/sparse.c~generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication mm/sparse.c
--- a/mm/sparse.c~generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication
+++ a/mm/sparse.c
@@ -387,33 +387,23 @@ int __meminit vmemmap_populate(struct pa
 }
 #endif /* !CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP */
 
-static struct page * __init sparse_early_mem_map_alloc(unsigned long pnum)
+static struct page __init *sparse_early_mem_map_populate(unsigned long pnum,
+									int nid)
 {
-	struct page *map;
-	struct mem_section *ms = __nr_to_section(pnum);
-	int nid = sparse_early_nid(ms);
-	int error;
-
-	map = pfn_to_page(pnum * PAGES_PER_SECTION);
-	error = vmemmap_populate(map, PAGES_PER_SECTION, nid);
-	if (error) {
-		printk(KERN_ERR "%s: allocation failed. Error=%d\n",
-							__FUNCTION__, error);
-		printk(KERN_ERR "%s: virtual memory map backing failed "
-			"some memory will not be available.\n", __FUNCTION__);
-		ms->section_mem_map = 0;
+	struct page *map = pfn_to_page(pnum * PAGES_PER_SECTION);
+	int error = vmemmap_populate(map, PAGES_PER_SECTION, nid);
+	if (error)
 		return NULL;
-	}
+
 	return map;
 }
 
 #else /* CONFIG_SPARSEMEM_VMEMMAP */
 
-static struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
+static struct page __init *sparse_early_mem_map_populate(unsigned long pnum,
+									int nid)
 {
 	struct page *map;
-	struct mem_section *ms = __nr_to_section(pnum);
-	int nid = sparse_early_nid(ms);
 
 	map = alloc_remap(nid, sizeof(struct page) * PAGES_PER_SECTION);
 	if (map)
@@ -426,14 +416,25 @@ static struct page __init *sparse_early_
 
 	map = alloc_bootmem_node(NODE_DATA(nid),
 			sizeof(struct page) * PAGES_PER_SECTION);
+	return map;
+}
+#endif /* !CONFIG_SPARSEMEM_VMEMMAP */
+
+struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
+{
+	struct page *map;
+	struct mem_section *ms = __nr_to_section(pnum);
+	int nid = sparse_early_nid(ms);
+
+	map = sparse_early_mem_map_populate(pnum, nid);
 	if (map)
 		return map;
 
-	printk(KERN_WARNING "%s: allocation failed\n", __FUNCTION__);
+	printk(KERN_ERR "%s: sparsemem memory map backing failed "
+			"some memory will not be available.\n", __FUNCTION__);
 	ms->section_mem_map = 0;
 	return NULL;
 }
-#endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 
 /*
  * Allocate the accumulated non-linear sections, allocate a mem_map
_

Patches currently in -mm which might be from apw@shadowen.org are

x86_64-get-mp_bus_to_node-as-early-v2.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default-v2.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
pci-device-ensure-sysdata-initialised-v4.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static-fix.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-fix.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
vmemmap-pull-out-the-vmemmap-code-into-its-own-file.patch
vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-a-configure-option-to-group-pages-by-mobility.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
page-owner-tracking-leak-detector.patch
