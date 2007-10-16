From: akpm@linux-foundation.org
Subject: - generic-virtual-memmap-support-vmemmap-generify-initialisation-via-helpers.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:30:27 -0700
Message-ID: <200710162030.l9GKURVb014405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51317 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966223AbXJPVtP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:49:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     vmemmap: generify initialisation via helpers
has been removed from the -mm tree.  Its filename was
     generic-virtual-memmap-support-vmemmap-generify-initialisation-via-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: vmemmap: generify initialisation via helpers
From: Andy Whitcroft <apw@shadowen.org>

Convert the common vmemmap population into initialisation helpers for use by
architecture vmemmap populators.  All architecture implementing the
SPARSEMEM_VMEMMAP variant supply an architecture specific vmemmap_populate()
initialiser, which may make use of the helpers.

This allows us to clean up and remove the initialisation Kconfig entries. 
With this patch there is a single SPARSEMEM_VMEMMAP_ENABLE Kconfig option to
indicate use of that variant.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    9 +-
 mm/Kconfig          |   13 +++
 mm/sparse-vmemmap.c |  161 ++++++++++++++++--------------------------
 3 files changed, 84 insertions(+), 99 deletions(-)

diff -puN include/linux/mm.h~generic-virtual-memmap-support-vmemmap-generify-initialisation-via-helpers include/linux/mm.h
--- a/include/linux/mm.h~generic-virtual-memmap-support-vmemmap-generify-initialisation-via-helpers
+++ a/include/linux/mm.h
@@ -1219,10 +1219,15 @@ extern int randomize_va_space;
 const char * arch_vma_name(struct vm_area_struct *vma);
 
 struct page *sparse_early_mem_map_populate(unsigned long pnum, int nid);
-int vmemmap_populate(struct page *start_page, unsigned long pages, int node);
-int vmemmap_populate_pmd(pud_t *, unsigned long, unsigned long, int);
+pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
+pud_t *vmemmap_pud_populate(pgd_t *pgd, unsigned long addr, int node);
+pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
+pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node);
 void *vmemmap_alloc_block(unsigned long size, int node);
 void vmemmap_verify(pte_t *, int, unsigned long, unsigned long);
+int vmemmap_populate_basepages(struct page *start_page,
+						unsigned long pages, int node);
+int vmemmap_populate(struct page *start_page, unsigned long pages, int node);
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff -puN mm/Kconfig~generic-virtual-memmap-support-vmemmap-generify-initialisation-via-helpers mm/Kconfig
--- a/mm/Kconfig~generic-virtual-memmap-support-vmemmap-generify-initialisation-via-helpers
+++ a/mm/Kconfig
@@ -112,6 +112,19 @@ config SPARSEMEM_EXTREME
 	def_bool y
 	depends on SPARSEMEM && !SPARSEMEM_STATIC
 
+#
+# SPARSEMEM_VMEMMAP uses a virtually mapped mem_map to optimise pfn_to_page
+# and page_to_pfn.  The most efficient option where kernel virtual space is
+# not under pressure.
+#
+config SPARSEMEM_VMEMMAP_ENABLE
+	def_bool n
+
+config SPARSEMEM_VMEMMAP
+	bool
+	depends on SPARSEMEM
+	default y if (SPARSEMEM_VMEMMAP_ENABLE)
+
 # eventually, we can have this option just 'select SPARSEMEM'
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
diff -puN mm/sparse-vmemmap.c~generic-virtual-memmap-support-vmemmap-generify-initialisation-via-helpers mm/sparse-vmemmap.c
--- a/mm/sparse-vmemmap.c~generic-virtual-memmap-support-vmemmap-generify-initialisation-via-helpers
+++ a/mm/sparse-vmemmap.c
@@ -14,21 +14,8 @@
  * case the overhead consists of a few additional pages that are
  * allocated to create a view of memory for vmemmap.
  *
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
+ * The architecture is expected to provide a vmemmap_populate() function
+ * to instantiate the mapping.
  */
 #include <linux/mm.h>
 #include <linux/mmzone.h>
@@ -60,7 +47,6 @@ void * __meminit vmemmap_alloc_block(uns
 				__pa(MAX_DMA_ADDRESS));
 }
 
-#ifndef CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP
 void __meminit vmemmap_verify(pte_t *pte, int node,
 				unsigned long start, unsigned long end)
 {
@@ -72,103 +58,84 @@ void __meminit vmemmap_verify(pte_t *pte
 			"page_structs\n", start, end - 1);
 }
 
-#ifndef CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP_PMD
-static int __meminit vmemmap_populate_pte(pmd_t *pmd, unsigned long addr,
-					unsigned long end, int node)
+pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node)
 {
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
+	pte_t *pte = pte_offset_kernel(pmd, addr);
+	if (pte_none(*pte)) {
+		pte_t entry;
+		void *p = vmemmap_alloc_block(PAGE_SIZE, node);
+		if (!p)
+			return 0;
+		entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
+		set_pte_at(&init_mm, addr, pte, entry);
+	}
+	return pte;
 }
 
-int __meminit vmemmap_populate_pmd(pud_t *pud, unsigned long addr,
-						unsigned long end, int node)
+pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
 {
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
+	pmd_t *pmd = pmd_offset(pud, addr);
+	if (pmd_none(*pmd)) {
+		void *p = vmemmap_alloc_block(PAGE_SIZE, node);
+		if (!p)
+			return 0;
+		pmd_populate_kernel(&init_mm, pmd, p);
 	}
-	return error;
+	return pmd;
 }
-#endif /* CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP_PMD */
 
-static int __meminit vmemmap_populate_pud(pgd_t *pgd, unsigned long addr,
-						unsigned long end, int node)
+pud_t * __meminit vmemmap_pud_populate(pgd_t *pgd, unsigned long addr, int node)
 {
-	pud_t *pud;
-	int error = 0;
-	unsigned long next;
+	pud_t *pud = pud_offset(pgd, addr);
+	if (pud_none(*pud)) {
+		void *p = vmemmap_alloc_block(PAGE_SIZE, node);
+		if (!p)
+			return 0;
+		pud_populate(&init_mm, pud, p);
+	}
+	return pud;
+}
 
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
+pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
+{
+	pgd_t *pgd = pgd_offset_k(addr);
+	if (pgd_none(*pgd)) {
+		void *p = vmemmap_alloc_block(PAGE_SIZE, node);
+		if (!p)
+			return 0;
+		pgd_populate(&init_mm, pgd, p);
 	}
-	return error;
+	return pgd;
 }
 
-int __meminit vmemmap_populate(struct page *start_page,
-						unsigned long nr, int node)
+int __meminit vmemmap_populate_basepages(struct page *start_page,
+						unsigned long size, int node)
 {
-	pgd_t *pgd;
 	unsigned long addr = (unsigned long)start_page;
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
+	unsigned long end = (unsigned long)(start_page + size);
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	for (; addr < end; addr += PAGE_SIZE) {
+		pgd = vmemmap_pgd_populate(addr, node);
+		if (!pgd)
+			return -ENOMEM;
+		pud = vmemmap_pud_populate(pgd, addr, node);
+		if (!pud)
+			return -ENOMEM;
+		pmd = vmemmap_pmd_populate(pud, addr, node);
+		if (!pmd)
+			return -ENOMEM;
+		pte = vmemmap_pte_populate(pmd, addr, node);
+		if (!pte)
+			return -ENOMEM;
+		vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
 	}
-	return error;
+
+	return 0;
 }
-#endif /* !CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP */
 
 struct page __init *sparse_early_mem_map_populate(unsigned long pnum, int nid)
 {
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
update-checkpatchpl-to-version-010.patch
printk-add-kern_cont-annotation.patch
page-owner-tracking-leak-detector.patch
