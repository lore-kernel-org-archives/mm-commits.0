From: akpm@linux-foundation.org
Subject: + ia64-sparsemem_vmemmap-16k-page-size-support.patch added to -mm tree
Date: Thu, 19 Jul 2007 16:37:26 -0700
Message-ID: <200707192337.l6JNbQK5028701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54407 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756635AbXGSXiL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 19:38:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, apw@shadowen.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, tony.luck@intel.com


The patch titled
     IA64: SPARSEMEM_VMEMMAP 16K page size support
has been added to the -mm tree.  Its filename is
     ia64-sparsemem_vmemmap-16k-page-size-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: IA64: SPARSEMEM_VMEMMAP 16K page size support
From: Christoph Lameter <clameter@sgi.com>

Equip IA64 sparsemem with a virtual memmap.  This is similar to the existing
CONFIG_VIRTUAL_MEM_MAP functionality for DISCONTIGMEM.  It uses a PAGE_SIZE
mapping.

This is provided as a minimally intrusive solution.  We split the 128TB
VMALLOC area into two 64TB areas and use one for the virtual memmap.

This should replace CONFIG_VIRTUAL_MEM_MAP long term.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig          |    4 ++++
 include/asm-ia64/pgtable.h |    6 ++++++
 2 files changed, 10 insertions(+)

diff -puN arch/ia64/Kconfig~ia64-sparsemem_vmemmap-16k-page-size-support arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~ia64-sparsemem_vmemmap-16k-page-size-support
+++ a/arch/ia64/Kconfig
@@ -355,6 +355,10 @@ config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	depends on ARCH_DISCONTIGMEM_ENABLE
 
+config SPARSEMEM_VMEMMAP
+	def_bool y
+	depends on SPARSEMEM
+
 config ARCH_DISCONTIGMEM_DEFAULT
 	def_bool y if (IA64_SGI_SN2 || IA64_GENERIC || IA64_HP_ZX1 || IA64_HP_ZX1_SWIOTLB)
 	depends on ARCH_DISCONTIGMEM_ENABLE
diff -puN include/asm-ia64/pgtable.h~ia64-sparsemem_vmemmap-16k-page-size-support include/asm-ia64/pgtable.h
--- a/include/asm-ia64/pgtable.h~ia64-sparsemem_vmemmap-16k-page-size-support
+++ a/include/asm-ia64/pgtable.h
@@ -236,8 +236,14 @@ ia64_phys_addr_valid (unsigned long addr
 # define VMALLOC_END		vmalloc_end
   extern unsigned long vmalloc_end;
 #else
+#if defined(CONFIG_SPARSEMEM) && defined(CONFIG_SPARSEMEM_VMEMMAP)
+/* SPARSEMEM_VMEMMAP uses half of vmalloc... */
+# define VMALLOC_END		(RGN_BASE(RGN_GATE) + (1UL << (4*PAGE_SHIFT - 10)))
+# define vmemmap		((struct page *)VMALLOC_END)
+#else
 # define VMALLOC_END		(RGN_BASE(RGN_GATE) + (1UL << (4*PAGE_SHIFT - 9)))
 #endif
+#endif
 
 /* fs/proc/kcore.c */
 #define	kc_vaddr_to_offset(v) ((v) - RGN_BASE(RGN_GATE))
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
try-parent-numa_node-at-first-before-using-default-v2.patch
try-parent-numa_node-at-first-before-using-default-v2-fix.patch
slob-reduce-list-scanning.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
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
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
page-owner-tracking-leak-detector.patch
