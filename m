From: akpm@linux-foundation.org
Subject: + ppc64-sparsemem_vmemmap-support.patch added to -mm tree
Date: Thu, 19 Jul 2007 16:37:30 -0700
Message-ID: <200707192337.l6JNbUiT028707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52288 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755809AbXGSXiP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 19:38:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, benh@kernel.crashing.org, clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, paulus@samba.org


The patch titled
     ppc64: SPARSEMEM_VMEMMAP support
has been added to the -mm tree.  Its filename is
     ppc64-sparsemem_vmemmap-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ppc64: SPARSEMEM_VMEMMAP support
From: Andy Whitcroft <apw@shadowen.org>

Enable virtual memmap support for SPARSEMEM on PPC64 systems.  Slice a 16th
off the end of the linear mapping space and use that to hold the vmemmap. 
Uses the same size mapping as uses in the linear 1:1 kernel mapping.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig                |    8 +++
 arch/powerpc/mm/init_64.c           |   64 ++++++++++++++++++++++++++
 include/asm-powerpc/pgtable-ppc64.h |    8 +++
 3 files changed, 80 insertions(+)

diff -puN arch/powerpc/Kconfig~ppc64-sparsemem_vmemmap-support arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~ppc64-sparsemem_vmemmap-support
+++ a/arch/powerpc/Kconfig
@@ -272,6 +272,14 @@ config ARCH_POPULATES_NODE_MAP
 
 source "mm/Kconfig"
 
+config SPARSEMEM_VMEMMAP
+	def_bool y
+	depends on SPARSEMEM
+
+config ARCH_POPULATES_SPARSEMEM_VMEMMAP
+	def_bool y
+	depends on SPARSEMEM_VMEMMAP
+
 config ARCH_MEMORY_PROBE
 	def_bool y
 	depends on MEMORY_HOTPLUG
diff -puN arch/powerpc/mm/init_64.c~ppc64-sparsemem_vmemmap-support arch/powerpc/mm/init_64.c
--- a/arch/powerpc/mm/init_64.c~ppc64-sparsemem_vmemmap-support
+++ a/arch/powerpc/mm/init_64.c
@@ -182,3 +182,67 @@ void pgtable_cache_init(void)
 						     NULL);
 	}
 }
+
+#ifdef CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP
+
+/*
+ * Convert an address within the vmemmap into a pfn.  Note that we have
+ * to do this by hand as the proffered address may not be correctly aligned.
+ * Subtraction of non-aligned pointers produces undefined results.
+ */
+#define VMM_SECTION(addr) \
+		(((((unsigned long)(addr)) - ((unsigned long)(vmemmap))) / \
+		sizeof(struct page)) >> PFN_SECTION_SHIFT)
+#define VMM_SECTION_PAGE(addr)	(VMM_SECTION(addr) << PFN_SECTION_SHIFT)
+
+/*
+ * Check if this vmemmap page is already initialised.  If any section
+ * which overlaps this vmemmap page is initialised then this page is
+ * initialised already.
+ */
+int __meminit vmemmap_populated(unsigned long start, int page_size)
+{
+	unsigned long end = start + page_size;
+
+	for (; start < end; start += (PAGES_PER_SECTION * sizeof(struct page)))
+		if (pfn_valid(VMM_SECTION_PAGE(start)))
+			return 1;
+
+	return 0;
+}
+
+int __meminit vmemmap_populate(struct page *start_page,
+					unsigned long nr_pages, int node)
+{
+	unsigned long mode_rw;
+	unsigned long start = (unsigned long)start_page;
+	unsigned long end = (unsigned long)(start_page + nr_pages);
+	unsigned long page_size = 1 << mmu_psize_defs[mmu_linear_psize].shift;
+
+	mode_rw = _PAGE_ACCESSED | _PAGE_DIRTY | _PAGE_COHERENT | PP_RWXX;
+
+	/* Align to the page size of the linear mapping. */
+	start = _ALIGN_DOWN(start, page_size);
+
+	for (; start < end; start += page_size) {
+		int mapped;
+		void *p;
+
+		if (vmemmap_populated(start, page_size))
+			continue;
+
+		p = vmemmap_alloc_block(page_size, node);
+		if (!p)
+			return -ENOMEM;
+
+		printk(KERN_WARNING "vmemmap %08lx allocated at %p, "
+					"physical %p.\n", start, p, __pa(p));
+
+		mapped = htab_bolt_mapping(start, start + page_size,
+					__pa(p), mode_rw, mmu_linear_psize);
+		BUG_ON(mapped < 0);
+	}
+
+	return 0;
+}
+#endif
diff -puN include/asm-powerpc/pgtable-ppc64.h~ppc64-sparsemem_vmemmap-support include/asm-powerpc/pgtable-ppc64.h
--- a/include/asm-powerpc/pgtable-ppc64.h~ppc64-sparsemem_vmemmap-support
+++ a/include/asm-powerpc/pgtable-ppc64.h
@@ -68,6 +68,14 @@
 #define USER_REGION_ID		(0UL)
 
 /*
+ * Defines the address of the vmemap area, in the top 16th of the
+ * kernel region.
+ */
+#define VMEMMAP_BASE (ASM_CONST(CONFIG_KERNEL_START) + \
+					(0xfUL << (REGION_SHIFT - 4)))
+#define vmemmap ((struct page *)VMEMMAP_BASE)
+
+/*
  * Common bits in a linux-style PTE.  These match the bits in the
  * (hardware-defined) PowerPC PTE as closely as possible. Additional
  * bits may be defined in pgtable-*.h
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
generic-virtual-memmap-support-for-sparsemem.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
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
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
page-owner-tracking-leak-detector.patch
