From: akpm@linux-foundation.org
Subject: + x86_64-sparsemem_vmemmap-2m-page-size-support.patch added to -mm tree
Date: Thu, 19 Jul 2007 16:37:24 -0700
Message-ID: <200707192337.l6JNbObn028696@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40679 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754914AbXGSXiJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 19:38:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, ak@suse.de, apw@shadowen.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     x86_64: SPARSEMEM_VMEMMAP 2M page size support
has been added to the -mm tree.  Its filename is
     x86_64-sparsemem_vmemmap-2m-page-size-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: SPARSEMEM_VMEMMAP 2M page size support
From: Christoph Lameter <clameter@sgi.com>

x86_64 uses 2M page table entries to map its 1-1 kernel space.  We also
implement the virtual memmap using 2M page table entries.  So there is no
additional runtime overhead over FLATMEM, initialisation is slightly more
complex.  As FLATMEM still references memory to obtain the mem_map pointer and
SPARSEMEM_VMEMMAP uses a compile time constant, SPARSEMEM_VMEMMAP should be
superior.

With this SPARSEMEM becomes the most efficient way of handling virt_to_page,
pfn_to_page and friends for UP, SMP and NUMA on x86_64.

[apw@shadowen.org: code resplit, style fixups]
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <ak@suse.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/x86_64/mm.txt  |    1 +
 arch/x86_64/Kconfig          |    8 ++++++++
 arch/x86_64/mm/init.c        |   30 ++++++++++++++++++++++++++++++
 include/asm-x86_64/page.h    |    1 +
 include/asm-x86_64/pgtable.h |    1 +
 5 files changed, 41 insertions(+)

diff -puN Documentation/x86_64/mm.txt~x86_64-sparsemem_vmemmap-2m-page-size-support Documentation/x86_64/mm.txt
--- a/Documentation/x86_64/mm.txt~x86_64-sparsemem_vmemmap-2m-page-size-support
+++ a/Documentation/x86_64/mm.txt
@@ -9,6 +9,7 @@ ffff800000000000 - ffff80ffffffffff (=40
 ffff810000000000 - ffffc0ffffffffff (=46 bits) direct mapping of all phys. memory
 ffffc10000000000 - ffffc1ffffffffff (=40 bits) hole
 ffffc20000000000 - ffffe1ffffffffff (=45 bits) vmalloc/ioremap space
+ffffe20000000000 - ffffe2ffffffffff (=40 bits) virtual memory map (1TB)
 ... unused hole ...
 ffffffff80000000 - ffffffff82800000 (=40 MB)   kernel text mapping, from phys 0
 ... unused hole ...
diff -puN arch/x86_64/Kconfig~x86_64-sparsemem_vmemmap-2m-page-size-support arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~x86_64-sparsemem_vmemmap-2m-page-size-support
+++ a/arch/x86_64/Kconfig
@@ -406,6 +406,14 @@ config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	depends on (NUMA || EXPERIMENTAL)
 
+config SPARSEMEM_VMEMMAP
+	def_bool y
+	depends on SPARSEMEM
+
+config ARCH_POPULATES_SPARSEMEM_VMEMMAP_PMD
+	def_bool y
+	depends on SPARSEMEM_VMEMMAP
+
 config ARCH_MEMORY_PROBE
 	def_bool y
 	depends on MEMORY_HOTPLUG
diff -puN arch/x86_64/mm/init.c~x86_64-sparsemem_vmemmap-2m-page-size-support arch/x86_64/mm/init.c
--- a/arch/x86_64/mm/init.c~x86_64-sparsemem_vmemmap-2m-page-size-support
+++ a/arch/x86_64/mm/init.c
@@ -738,3 +738,33 @@ const char *arch_vma_name(struct vm_area
 		return "[vsyscall]";
 	return NULL;
 }
+
+#ifdef CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP_PMD
+/*
+ * Initialise the sparsemem vmemmap using huge-pages at the PMD level.
+ */
+int __meminit vmemmap_populate_pmd(pud_t *pud, unsigned long addr,
+						unsigned long end, int node)
+{
+	pmd_t *pmd;
+
+	for (pmd = pmd_offset(pud, addr); addr < end;
+						pmd++, addr += PMD_SIZE)
+		if (pmd_none(*pmd)) {
+			pte_t entry;
+			void *p = vmemmap_alloc_block(PMD_SIZE, node);
+			if (!p)
+				return -ENOMEM;
+
+			entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
+			mk_pte_huge(entry);
+			set_pmd(pmd, __pmd(pte_val(entry)));
+
+			printk(KERN_DEBUG " [%lx-%lx] PMD ->%p on node %d\n",
+				addr, addr + PMD_SIZE - 1, p, node);
+		} else
+			vmemmap_verify((pte_t *)pmd, node,
+						pmd_addr_end(addr, end), end);
+	return 0;
+}
+#endif
diff -puN include/asm-x86_64/page.h~x86_64-sparsemem_vmemmap-2m-page-size-support include/asm-x86_64/page.h
--- a/include/asm-x86_64/page.h~x86_64-sparsemem_vmemmap-2m-page-size-support
+++ a/include/asm-x86_64/page.h
@@ -134,6 +134,7 @@ extern unsigned long __phys_addr(unsigne
 	 VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 #define __HAVE_ARCH_GATE_AREA 1	
+#define vmemmap ((struct page *)VMEMMAP_START)
 
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
diff -puN include/asm-x86_64/pgtable.h~x86_64-sparsemem_vmemmap-2m-page-size-support include/asm-x86_64/pgtable.h
--- a/include/asm-x86_64/pgtable.h~x86_64-sparsemem_vmemmap-2m-page-size-support
+++ a/include/asm-x86_64/pgtable.h
@@ -137,6 +137,7 @@ static inline pte_t ptep_get_and_clear_f
 #define MAXMEM		 _AC(0x3fffffffffff, UL)
 #define VMALLOC_START    _AC(0xffffc20000000000, UL)
 #define VMALLOC_END      _AC(0xffffe1ffffffffff, UL)
+#define VMEMMAP_START	 _AC(0xffffe20000000000, UL)
 #define MODULES_VADDR    _AC(0xffffffff88000000, UL)
 #define MODULES_END      _AC(0xfffffffffff00000, UL)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
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
