From: akpm@linux-foundation.org
Subject: + move-vmalloc_to_page-to-mm-vmalloc.patch added to -mm tree
Date: Mon, 22 Oct 2007 14:32:16 -0700
Message-ID: <200710222132.l9MLWGug016029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40713 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750968AbXJVVcU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Oct 2007 17:32:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     Move vmalloc_to_page() to mm/vmalloc.
has been added to the -mm tree.  Its filename is
     move-vmalloc_to_page-to-mm-vmalloc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Move vmalloc_to_page() to mm/vmalloc.
From: Christoph Lameter <clameter@sgi.com>

We already have page table manipulation for vmalloc in vmalloc.c. Move the
vmalloc_to_page() function there as well.

Move the definitions for vmalloc related functions in mm.h to a newly created
section. A better place would be vmalloc.h but mm.h is basic and may depend
on these functions. An alternative would be to include vmalloc.h in mm.h (like done
for vmstat.h).

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 ++++--
 mm/memory.c        |   40 ----------------------------------------
 mm/vmalloc.c       |   38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+), 42 deletions(-)

diff -puN include/linux/mm.h~move-vmalloc_to_page-to-mm-vmalloc include/linux/mm.h
--- a/include/linux/mm.h~move-vmalloc_to_page-to-mm-vmalloc
+++ a/include/linux/mm.h
@@ -230,6 +230,10 @@ static inline int get_page_unless_zero(s
 	return atomic_inc_not_zero(&page->_count);
 }
 
+/* Support for virtually mapped pages */
+struct page *vmalloc_to_page(void *addr);
+unsigned long vmalloc_to_pfn(void *addr);
+
 static inline struct page *compound_head(struct page *page)
 {
 	if (unlikely(PageTail(page)))
@@ -1073,8 +1077,6 @@ static inline unsigned long vma_pages(st
 
 pgprot_t vm_get_page_prot(unsigned long vm_flags);
 struct vm_area_struct *find_extend_vma(struct mm_struct *, unsigned long addr);
-struct page *vmalloc_to_page(void *addr);
-unsigned long vmalloc_to_pfn(void *addr);
 int remap_pfn_range(struct vm_area_struct *, unsigned long addr,
 			unsigned long pfn, unsigned long size, pgprot_t);
 int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
diff -puN mm/memory.c~move-vmalloc_to_page-to-mm-vmalloc mm/memory.c
--- a/mm/memory.c~move-vmalloc_to_page-to-mm-vmalloc
+++ a/mm/memory.c
@@ -2612,46 +2612,6 @@ int make_pages_present(unsigned long add
 	return ret == len ? 0 : -1;
 }
 
-/* 
- * Map a vmalloc()-space virtual address to the physical page.
- */
-struct page * vmalloc_to_page(void * vmalloc_addr)
-{
-	unsigned long addr = (unsigned long) vmalloc_addr;
-	struct page *page = NULL;
-	pgd_t *pgd = pgd_offset_k(addr);
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *ptep, pte;
-  
-	if (!pgd_none(*pgd)) {
-		pud = pud_offset(pgd, addr);
-		if (!pud_none(*pud)) {
-			pmd = pmd_offset(pud, addr);
-			if (!pmd_none(*pmd)) {
-				ptep = pte_offset_map(pmd, addr);
-				pte = *ptep;
-				if (pte_present(pte))
-					page = pte_page(pte);
-				pte_unmap(ptep);
-			}
-		}
-	}
-	return page;
-}
-
-EXPORT_SYMBOL(vmalloc_to_page);
-
-/*
- * Map a vmalloc()-space virtual address to the physical page frame number.
- */
-unsigned long vmalloc_to_pfn(void * vmalloc_addr)
-{
-	return page_to_pfn(vmalloc_to_page(vmalloc_addr));
-}
-
-EXPORT_SYMBOL(vmalloc_to_pfn);
-
 #if !defined(__HAVE_ARCH_GATE_AREA)
 
 #if defined(AT_SYSINFO_EHDR)
diff -puN mm/vmalloc.c~move-vmalloc_to_page-to-mm-vmalloc mm/vmalloc.c
--- a/mm/vmalloc.c~move-vmalloc_to_page-to-mm-vmalloc
+++ a/mm/vmalloc.c
@@ -166,6 +166,44 @@ int map_vm_area(struct vm_struct *area, 
 }
 EXPORT_SYMBOL_GPL(map_vm_area);
 
+/*
+ * Map a vmalloc()-space virtual address to the physical page.
+ */
+struct page *vmalloc_to_page(void *vmalloc_addr)
+{
+	unsigned long addr = (unsigned long) vmalloc_addr;
+	struct page *page = NULL;
+	pgd_t *pgd = pgd_offset_k(addr);
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *ptep, pte;
+
+	if (!pgd_none(*pgd)) {
+		pud = pud_offset(pgd, addr);
+		if (!pud_none(*pud)) {
+			pmd = pmd_offset(pud, addr);
+			if (!pmd_none(*pmd)) {
+				ptep = pte_offset_map(pmd, addr);
+				pte = *ptep;
+				if (pte_present(pte))
+					page = pte_page(pte);
+				pte_unmap(ptep);
+			}
+		}
+	}
+	return page;
+}
+EXPORT_SYMBOL(vmalloc_to_page);
+
+/*
+ * Map a vmalloc()-space virtual address to the physical page frame number.
+ */
+unsigned long vmalloc_to_pfn(void *vmalloc_addr)
+{
+	return page_to_pfn(vmalloc_to_page(vmalloc_addr));
+}
+EXPORT_SYMBOL(vmalloc_to_pfn);
+
 static struct vm_struct *__get_vm_area_node(unsigned long size, unsigned long flags,
 					    unsigned long start, unsigned long end,
 					    int node, gfp_t gfp_mask)
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
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
mem-policy-fix-mempolicy-usage-in-pci-driver.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
git-x86.patch
slub-avoid-atomic-operation-for-slab_unlock.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
vunmap-return-page-array-passed-on-vmap.patch
slub-move-count_partial.patch
slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio.patch
slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
vm-allow-get_page_unless_zero-on-compound-pages.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
bufferhead-revert-constructor-removal.patch
revoke-core-code.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
