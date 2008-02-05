From: akpm@linux-foundation.org
Subject: - move-vmalloc_to_page-to-mm-vmalloc.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:29:33 -0800
Message-ID: <200802052229.m15MTEnC011962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52678 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932069AbYBEWms (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Move vmalloc_to_page() to mm/vmalloc.
has been removed from the -mm tree.  Its filename was
     move-vmalloc_to_page-to-mm-vmalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Move vmalloc_to_page() to mm/vmalloc.
From: Christoph Lameter <clameter@sgi.com>

We already have page table manipulation for vmalloc in vmalloc.c. Move the
vmalloc_to_page() function there as well.

Move the definitions for vmalloc related functions in mm.h to a newly created
section.  A better place would be vmalloc.h but mm.h is basic and may depend
on these functions.  An alternative would be to include vmalloc.h in mm.h
(like done for vmstat.h).

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
@@ -231,6 +231,10 @@ static inline int get_page_unless_zero(s
 	return atomic_inc_not_zero(&page->_count);
 }
 
+/* Support for virtually mapped pages */
+struct page *vmalloc_to_page(void *addr);
+unsigned long vmalloc_to_pfn(void *addr);
+
 static inline struct page *compound_head(struct page *page)
 {
 	if (unlikely(PageTail(page)))
@@ -1089,8 +1093,6 @@ static inline unsigned long vma_pages(st
 
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
@@ -2618,46 +2618,6 @@ int make_pages_present(unsigned long add
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
gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab-slabinfo-fallback-from-sys-kernel-slab-to-sys-slab.patch
git-unionfs.patch
git-slub.patch
percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-include-sectionsh-to-avoid-defining-linker-variables.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
