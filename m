From: akpm@linux-foundation.org
Subject: - ppc64-sparsemem_vmemmap-support.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:30:35 -0700
Message-ID: <200710162030.l9GKUZJq014420@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54420 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965381AbXJPVzA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:55:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, benh@kernel.crashing.org, clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, paulus@samba.org, pbadari@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ppc64: SPARSEMEM_VMEMMAP support
has been removed from the -mm tree.  Its filename was
     ppc64-sparsemem_vmemmap-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ppc64: SPARSEMEM_VMEMMAP support
From: Andy Whitcroft <apw@shadowen.org>

Enable virtual memmap support for SPARSEMEM on PPC64 systems.  Slice a 16th
off the end of the linear mapping space and use that to hold the vmemmap. 
Uses the same size mapping as uses in the linear 1:1 kernel mapping.

[pbadari@gmail.com: fix warning]
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig                |    1 
 arch/powerpc/mm/init_64.c           |   67 ++++++++++++++++++++++++++
 include/asm-powerpc/pgtable-ppc64.h |    8 +++
 3 files changed, 76 insertions(+)

diff -puN arch/powerpc/Kconfig~ppc64-sparsemem_vmemmap-support arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~ppc64-sparsemem_vmemmap-support
+++ a/arch/powerpc/Kconfig
@@ -295,6 +295,7 @@ config ARCH_FLATMEM_ENABLE
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	depends on PPC64
+	select SPARSEMEM_VMEMMAP_ENABLE
 
 config ARCH_SPARSEMEM_DEFAULT
 	def_bool y
diff -puN arch/powerpc/mm/init_64.c~ppc64-sparsemem_vmemmap-support arch/powerpc/mm/init_64.c
--- a/arch/powerpc/mm/init_64.c~ppc64-sparsemem_vmemmap-support
+++ a/arch/powerpc/mm/init_64.c
@@ -183,3 +183,70 @@ void pgtable_cache_init(void)
 						     zero_ctor);
 	}
 }
+
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+/*
+ * Given an address within the vmemmap, determine the pfn of the page that
+ * represents the start of the section it is within.  Note that we have to
+ * do this by hand as the proffered address may not be correctly aligned.
+ * Subtraction of non-aligned pointers produces undefined results.
+ */
+unsigned long __meminit vmemmap_section_start(unsigned long page)
+{
+	unsigned long offset = page - ((unsigned long)(vmemmap));
+
+	/* Return the pfn of the start of the section. */
+	return (offset / sizeof(struct page)) & PAGE_SECTION_MASK;
+}
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
+		if (pfn_valid(vmemmap_section_start(start)))
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
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
update-checkpatchpl-to-version-010.patch
printk-add-kern_cont-annotation.patch
page-owner-tracking-leak-detector.patch
