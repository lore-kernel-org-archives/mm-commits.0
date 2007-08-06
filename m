From: akpm@linux-foundation.org
Subject: + generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch added to -mm tree
Date: Mon, 06 Aug 2007 11:53:52 -0700
Message-ID: <200708061853.l76IrqMp009476@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37495 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757483AbXHFSyf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 14:54:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, clameter@sgi.com, haveblue@us.ibm.com


The patch titled
     vmemmap: pull out the vmemmap code into its own file
has been added to the -mm tree.  Its filename is
     generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vmemmap: pull out the vmemmap code into its own file
From: Andy Whitcroft <apw@shadowen.org>

Pull out the SPARSEMEM_VMEMMAP support into its own file.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    1 
 mm/Makefile         |    1 
 mm/sparse-vmemmap.c |  181 ++++++++++++++++++++++++++++++++++++++++++
 mm/sparse.c         |  180 -----------------------------------------
 4 files changed, 185 insertions(+), 178 deletions(-)

diff -puN include/linux/mm.h~generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file include/linux/mm.h
--- a/include/linux/mm.h~generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file
+++ a/include/linux/mm.h
@@ -1216,6 +1216,7 @@ extern int randomize_va_space;
 
 const char * arch_vma_name(struct vm_area_struct *vma);
 
+struct page *sparse_early_mem_map_populate(unsigned long pnum, int nid);
 int vmemmap_populate(struct page *start_page, unsigned long pages, int node);
 int vmemmap_populate_pmd(pud_t *, unsigned long, unsigned long, int);
 void *vmemmap_alloc_block(unsigned long size, int node);
diff -puN mm/Makefile~generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file mm/Makefile
--- a/mm/Makefile~generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file
+++ a/mm/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_SWAP)	+= page_io.o swap_sta
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o
 obj-$(CONFIG_NUMA) 	+= mempolicy.o
 obj-$(CONFIG_SPARSEMEM)	+= sparse.o
+obj-$(CONFIG_SPARSEMEM_VMEMMAP) += sparse-vmemmap.o
 obj-$(CONFIG_SHMEM) += shmem.o
 obj-$(CONFIG_TMPFS_POSIX_ACL) += shmem_acl.o
 obj-$(CONFIG_TINY_SHMEM) += tiny-shmem.o
diff -puN mm/sparse.c~generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file mm/sparse.c
--- a/mm/sparse.c~generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file
+++ a/mm/sparse.c
@@ -224,184 +224,8 @@ void *alloc_bootmem_high_node(pg_data_t 
 	return NULL;
 }
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-/*
- * Virtual Memory Map support
- *
- * (C) 2007 sgi. Christoph Lameter <clameter@sgi.com>.
- *
- * Virtual memory maps allow VM primitives pfn_to_page, page_to_pfn,
- * virt_to_page, page_address() to be implemented as a base offset
- * calculation without memory access.
- *
- * However, virtual mappings need a page table and TLBs. Many Linux
- * architectures already map their physical space using 1-1 mappings
- * via TLBs. For those arches the virtual memmory map is essentially
- * for free if we use the same page size as the 1-1 mappings. In that
- * case the overhead consists of a few additional pages that are
- * allocated to create a view of memory for vmemmap.
- *
- * Special Kconfig settings:
- *
- * CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP
- *
- * 	The architecture has its own functions to populate the memory
- * 	map and provides a vmemmap_populate function.
- *
- * CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP_PMD
- *
- * 	The architecture provides functions to populate the pmd level
- * 	of the vmemmap mappings.  Allowing mappings using large pages
- * 	where available.
- *
- * 	If neither are set then PAGE_SIZE mappings are generated which
- * 	require one PTE/TLB per PAGE_SIZE chunk of the virtual memory map.
- */
-
-/*
- * Allocate a block of memory to be used to back the virtual memory map
- * or to back the page tables that are used to create the mapping.
- * Uses the main allocators if they are available, else bootmem.
- */
-void * __meminit vmemmap_alloc_block(unsigned long size, int node)
-{
-	/* If the main allocator is up use that, fallback to bootmem. */
-	if (slab_is_available()) {
-		struct page *page = alloc_pages_node(node,
-				GFP_KERNEL | __GFP_ZERO, get_order(size));
-		if (page)
-			return page_address(page);
-		return NULL;
-	} else
-		return __alloc_bootmem_node(NODE_DATA(node), size, size,
-				__pa(MAX_DMA_ADDRESS));
-}
-
-#ifndef CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP
-void __meminit vmemmap_verify(pte_t *pte, int node,
-				unsigned long start, unsigned long end)
-{
-	unsigned long pfn = pte_pfn(*pte);
-	int actual_node = early_pfn_to_nid(pfn);
-
-	if (actual_node != node)
-		printk(KERN_WARNING "[%lx-%lx] potential offnode "
-			"page_structs\n", start, end - 1);
-}
-
-#ifndef CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP_PMD
-static int __meminit vmemmap_populate_pte(pmd_t *pmd, unsigned long addr,
-					unsigned long end, int node)
-{
-	pte_t *pte;
-
-	for (pte = pte_offset_kernel(pmd, addr); addr < end;
-						pte++, addr += PAGE_SIZE)
-		if (pte_none(*pte)) {
-			pte_t entry;
-			void *p = vmemmap_alloc_block(PAGE_SIZE, node);
-			if (!p)
-				return -ENOMEM;
-
-			entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
-			set_pte(pte, entry);
-
-		} else
-			vmemmap_verify(pte, node, addr + PAGE_SIZE, end);
-
-	return 0;
-}
-
-int __meminit vmemmap_populate_pmd(pud_t *pud, unsigned long addr,
-						unsigned long end, int node)
-{
-	pmd_t *pmd;
-	int error = 0;
-	unsigned long next;
-
-	for (pmd = pmd_offset(pud, addr); addr < end && !error;
-						pmd++, addr = next) {
-		if (pmd_none(*pmd)) {
-			void *p = vmemmap_alloc_block(PAGE_SIZE, node);
-			if (!p)
-				return -ENOMEM;
-
-			pmd_populate_kernel(&init_mm, pmd, p);
-		} else
-			vmemmap_verify((pte_t *)pmd, node,
-					pmd_addr_end(addr, end), end);
-		next = pmd_addr_end(addr, end);
-		error = vmemmap_populate_pte(pmd, addr, next, node);
-	}
-	return error;
-}
-#endif /* CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP_PMD */
-
-static int __meminit vmemmap_populate_pud(pgd_t *pgd, unsigned long addr,
-						unsigned long end, int node)
-{
-	pud_t *pud;
-	int error = 0;
-	unsigned long next;
-
-	for (pud = pud_offset(pgd, addr); addr < end && !error;
-						pud++, addr = next) {
-		if (pud_none(*pud)) {
-			void *p = vmemmap_alloc_block(PAGE_SIZE, node);
-			if (!p)
-				return -ENOMEM;
-
-			pud_populate(&init_mm, pud, p);
-		}
-		next = pud_addr_end(addr, end);
-		error = vmemmap_populate_pmd(pud, addr, next, node);
-	}
-	return error;
-}
-
-int __meminit vmemmap_populate(struct page *start_page,
-						unsigned long nr, int node)
-{
-	pgd_t *pgd;
-	unsigned long addr = (unsigned long)start_page;
-	unsigned long end = (unsigned long)(start_page + nr);
-	unsigned long next;
-	int error = 0;
-
-	printk(KERN_DEBUG "[%lx-%lx] Virtual memory section"
-		" (%ld pages) node %d\n", addr, end - 1, nr, node);
-
-	for (pgd = pgd_offset_k(addr); addr < end && !error;
-					pgd++, addr = next) {
-		if (pgd_none(*pgd)) {
-			void *p = vmemmap_alloc_block(PAGE_SIZE, node);
-			if (!p)
-				return -ENOMEM;
-
-			pgd_populate(&init_mm, pgd, p);
-		}
-		next = pgd_addr_end(addr,end);
-		error = vmemmap_populate_pud(pgd, addr, next, node);
-	}
-	return error;
-}
-#endif /* !CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP */
-
-static struct page __init *sparse_early_mem_map_populate(unsigned long pnum,
-									int nid)
-{
-	struct page *map = pfn_to_page(pnum * PAGES_PER_SECTION);
-	int error = vmemmap_populate(map, PAGES_PER_SECTION, nid);
-	if (error)
-		return NULL;
-
-	return map;
-}
-
-#else /* CONFIG_SPARSEMEM_VMEMMAP */
-
-static struct page __init *sparse_early_mem_map_populate(unsigned long pnum,
-									int nid)
+#ifndef CONFIG_SPARSEMEM_VMEMMAP
+struct page __init *sparse_early_mem_map_populate(unsigned long pnum, int nid)
 {
 	struct page *map;
 
diff -puN /dev/null mm/sparse-vmemmap.c
--- /dev/null
+++ a/mm/sparse-vmemmap.c
@@ -0,0 +1,181 @@
+/*
+ * Virtual Memory Map support
+ *
+ * (C) 2007 sgi. Christoph Lameter <clameter@sgi.com>.
+ *
+ * Virtual memory maps allow VM primitives pfn_to_page, page_to_pfn,
+ * virt_to_page, page_address() to be implemented as a base offset
+ * calculation without memory access.
+ *
+ * However, virtual mappings need a page table and TLBs. Many Linux
+ * architectures already map their physical space using 1-1 mappings
+ * via TLBs. For those arches the virtual memmory map is essentially
+ * for free if we use the same page size as the 1-1 mappings. In that
+ * case the overhead consists of a few additional pages that are
+ * allocated to create a view of memory for vmemmap.
+ *
+ * Special Kconfig settings:
+ *
+ * CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP
+ *
+ * 	The architecture has its own functions to populate the memory
+ * 	map and provides a vmemmap_populate function.
+ *
+ * CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP_PMD
+ *
+ * 	The architecture provides functions to populate the pmd level
+ * 	of the vmemmap mappings.  Allowing mappings using large pages
+ * 	where available.
+ *
+ * 	If neither are set then PAGE_SIZE mappings are generated which
+ * 	require one PTE/TLB per PAGE_SIZE chunk of the virtual memory map.
+ */
+#include <linux/mm.h>
+#include <linux/mmzone.h>
+#include <linux/bootmem.h>
+#include <linux/highmem.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/vmalloc.h>
+#include <asm/dma.h>
+#include <asm/pgalloc.h>
+#include <asm/pgtable.h>
+
+/*
+ * Allocate a block of memory to be used to back the virtual memory map
+ * or to back the page tables that are used to create the mapping.
+ * Uses the main allocators if they are available, else bootmem.
+ */
+void * __meminit vmemmap_alloc_block(unsigned long size, int node)
+{
+	/* If the main allocator is up use that, fallback to bootmem. */
+	if (slab_is_available()) {
+		struct page *page = alloc_pages_node(node,
+				GFP_KERNEL | __GFP_ZERO, get_order(size));
+		if (page)
+			return page_address(page);
+		return NULL;
+	} else
+		return __alloc_bootmem_node(NODE_DATA(node), size, size,
+				__pa(MAX_DMA_ADDRESS));
+}
+
+#ifndef CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP
+void __meminit vmemmap_verify(pte_t *pte, int node,
+				unsigned long start, unsigned long end)
+{
+	unsigned long pfn = pte_pfn(*pte);
+	int actual_node = early_pfn_to_nid(pfn);
+
+	if (actual_node != node)
+		printk(KERN_WARNING "[%lx-%lx] potential offnode "
+			"page_structs\n", start, end - 1);
+}
+
+#ifndef CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP_PMD
+static int __meminit vmemmap_populate_pte(pmd_t *pmd, unsigned long addr,
+					unsigned long end, int node)
+{
+	pte_t *pte;
+
+	for (pte = pte_offset_kernel(pmd, addr); addr < end;
+						pte++, addr += PAGE_SIZE)
+		if (pte_none(*pte)) {
+			pte_t entry;
+			void *p = vmemmap_alloc_block(PAGE_SIZE, node);
+			if (!p)
+				return -ENOMEM;
+
+			entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
+			set_pte(pte, entry);
+
+		} else
+			vmemmap_verify(pte, node, addr + PAGE_SIZE, end);
+
+	return 0;
+}
+
+int __meminit vmemmap_populate_pmd(pud_t *pud, unsigned long addr,
+						unsigned long end, int node)
+{
+	pmd_t *pmd;
+	int error = 0;
+	unsigned long next;
+
+	for (pmd = pmd_offset(pud, addr); addr < end && !error;
+						pmd++, addr = next) {
+		if (pmd_none(*pmd)) {
+			void *p = vmemmap_alloc_block(PAGE_SIZE, node);
+			if (!p)
+				return -ENOMEM;
+
+			pmd_populate_kernel(&init_mm, pmd, p);
+		} else
+			vmemmap_verify((pte_t *)pmd, node,
+					pmd_addr_end(addr, end), end);
+		next = pmd_addr_end(addr, end);
+		error = vmemmap_populate_pte(pmd, addr, next, node);
+	}
+	return error;
+}
+#endif /* CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP_PMD */
+
+static int __meminit vmemmap_populate_pud(pgd_t *pgd, unsigned long addr,
+						unsigned long end, int node)
+{
+	pud_t *pud;
+	int error = 0;
+	unsigned long next;
+
+	for (pud = pud_offset(pgd, addr); addr < end && !error;
+						pud++, addr = next) {
+		if (pud_none(*pud)) {
+			void *p = vmemmap_alloc_block(PAGE_SIZE, node);
+			if (!p)
+				return -ENOMEM;
+
+			pud_populate(&init_mm, pud, p);
+		}
+		next = pud_addr_end(addr, end);
+		error = vmemmap_populate_pmd(pud, addr, next, node);
+	}
+	return error;
+}
+
+int __meminit vmemmap_populate(struct page *start_page,
+						unsigned long nr, int node)
+{
+	pgd_t *pgd;
+	unsigned long addr = (unsigned long)start_page;
+	unsigned long end = (unsigned long)(start_page + nr);
+	unsigned long next;
+	int error = 0;
+
+	printk(KERN_DEBUG "[%lx-%lx] Virtual memory section"
+		" (%ld pages) node %d\n", addr, end - 1, nr, node);
+
+	for (pgd = pgd_offset_k(addr); addr < end && !error;
+					pgd++, addr = next) {
+		if (pgd_none(*pgd)) {
+			void *p = vmemmap_alloc_block(PAGE_SIZE, node);
+			if (!p)
+				return -ENOMEM;
+
+			pgd_populate(&init_mm, pgd, p);
+		}
+		next = pgd_addr_end(addr,end);
+		error = vmemmap_populate_pud(pgd, addr, next, node);
+	}
+	return error;
+}
+#endif /* !CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP */
+
+struct page __init *sparse_early_mem_map_populate(unsigned long pnum, int nid)
+{
+	struct page *map = pfn_to_page(pnum * PAGES_PER_SECTION);
+	int error = vmemmap_populate(map, PAGES_PER_SECTION, nid);
+	if (error)
+		return NULL;
+
+	return map;
+}
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
generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
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
