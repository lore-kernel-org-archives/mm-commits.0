From: akpm@linux-foundation.org
Subject: - uml-fix-page-table-data-sizes.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:36:38 -0800
Message-ID: <200802052236.m15MaJ56012706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41570 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761152AbYBEWl4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix page table data sizes
has been removed from the -mm tree.  Its filename was
     uml-fix-page-table-data-sizes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: fix page table data sizes
From: Jeff Dike <jdike@addtoit.com>

Get the sizes of various pieces of data right when using three-level
page tables.  pgd and pmd entries remain at 32 bits in a 32-bit
compilation because page tables will remain in low memory.  So,
PGDIR_SHIFT, the PTRS_PER_* values, set_pud, set_pmd are conditional
on 64BIT.

More use of phys_t is made when there are physical memory addresses
floating around.

ObCheckpatchViolationJustification - the new typedef is an alternate
definition of pmd_t, which I can't really live without.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/mem.c            |   17 +++++++++--------
 include/asm-um/page.h           |    6 +++---
 include/asm-um/pgtable-3level.h |   21 ++++++++++++++++++++-
 include/asm-um/pgtable.h        |    2 +-
 4 files changed, 33 insertions(+), 13 deletions(-)

diff -puN arch/um/kernel/mem.c~uml-fix-page-table-data-sizes arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~uml-fix-page-table-data-sizes
+++ a/arch/um/kernel/mem.c
@@ -132,7 +132,7 @@ static void __init fixrange_init(unsigne
 		if (pud_none(*pud))
 			one_md_table_init(pud);
 		pmd = pmd_offset(pud, vaddr);
-		for (; (j < PTRS_PER_PMD) && (vaddr != end); pmd++, j++) {
+		for (; (j < PTRS_PER_PMD) && (vaddr < end); pmd++, j++) {
 			one_page_table_init(pmd);
 			vaddr += PMD_SIZE;
 		}
@@ -191,22 +191,23 @@ static void __init fixaddr_user_init( vo
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
-	unsigned long paddr, vaddr = FIXADDR_USER_START;
+	phys_t p;
+	unsigned long v, vaddr = FIXADDR_USER_START;
 
-	if (  ! size )
+	if (!size)
 		return;
 
 	fixrange_init( FIXADDR_USER_START, FIXADDR_USER_END, swapper_pg_dir);
-	paddr = (unsigned long)alloc_bootmem_low_pages( size);
-	memcpy( (void *)paddr, (void *)FIXADDR_USER_START, size);
-	paddr = __pa(paddr);
+	v = (unsigned long) alloc_bootmem_low_pages(size);
+	memcpy((void *) v , (void *) FIXADDR_USER_START, size);
+	p = __pa(v);
 	for ( ; size > 0; size -= PAGE_SIZE, vaddr += PAGE_SIZE,
-		      paddr += PAGE_SIZE) {
+		      p += PAGE_SIZE) {
 		pgd = swapper_pg_dir + pgd_index(vaddr);
 		pud = pud_offset(pgd, vaddr);
 		pmd = pmd_offset(pud, vaddr);
 		pte = pte_offset_kernel(pmd, vaddr);
-		pte_set_val( (*pte), paddr, PAGE_READONLY);
+		pte_set_val(*pte, p, PAGE_READONLY);
 	}
 #endif
 }
diff -puN include/asm-um/page.h~uml-fix-page-table-data-sizes include/asm-um/page.h
--- a/include/asm-um/page.h~uml-fix-page-table-data-sizes
+++ a/include/asm-um/page.h
@@ -30,7 +30,7 @@ struct page;
 #if defined(CONFIG_3_LEVEL_PGTABLES) && !defined(CONFIG_64BIT)
 
 typedef struct { unsigned long pte_low, pte_high; } pte_t;
-typedef struct { unsigned long long pmd; } pmd_t;
+typedef struct { unsigned long pmd; } pmd_t;
 typedef struct { unsigned long pgd; } pgd_t;
 #define pte_val(x) ((x).pte_low | ((unsigned long long) (x).pte_high << 32))
 
@@ -106,8 +106,8 @@ extern unsigned long uml_physmem;
 #define __pa(virt) to_phys((void *) (unsigned long) (virt))
 #define __va(phys) to_virt((unsigned long) (phys))
 
-#define phys_to_pfn(p) ((p) >> PAGE_SHIFT)
-#define pfn_to_phys(pfn) ((pfn) << PAGE_SHIFT)
+#define phys_to_pfn(p) ((pfn_t) ((p) >> PAGE_SHIFT))
+#define pfn_to_phys(pfn) ((phys_t) ((pfn) << PAGE_SHIFT))
 
 #define pfn_valid(pfn) ((pfn) < max_mapnr)
 #define virt_addr_valid(v) pfn_valid(phys_to_pfn(__pa(v)))
diff -puN include/asm-um/pgtable-3level.h~uml-fix-page-table-data-sizes include/asm-um/pgtable-3level.h
--- a/include/asm-um/pgtable-3level.h~uml-fix-page-table-data-sizes
+++ a/include/asm-um/pgtable-3level.h
@@ -11,7 +11,11 @@
 
 /* PGDIR_SHIFT determines what a third-level page table entry can map */
 
+#ifdef CONFIG_64BIT
 #define PGDIR_SHIFT	30
+#else
+#define PGDIR_SHIFT	31
+#endif
 #define PGDIR_SIZE	(1UL << PGDIR_SHIFT)
 #define PGDIR_MASK	(~(PGDIR_SIZE-1))
 
@@ -28,9 +32,15 @@
  */
 
 #define PTRS_PER_PTE 512
+#ifdef CONFIG_64BIT
 #define PTRS_PER_PMD 512
-#define USER_PTRS_PER_PGD ((TASK_SIZE + (PGDIR_SIZE - 1)) / PGDIR_SIZE)
 #define PTRS_PER_PGD 512
+#else
+#define PTRS_PER_PMD 1024
+#define PTRS_PER_PGD 1024
+#endif
+
+#define USER_PTRS_PER_PGD ((TASK_SIZE + (PGDIR_SIZE - 1)) / PGDIR_SIZE)
 #define FIRST_USER_ADDRESS	0
 
 #define pte_ERROR(e) \
@@ -49,7 +59,12 @@
 #define pud_populate(mm, pud, pmd) \
 	set_pud(pud, __pud(_PAGE_TABLE + __pa(pmd)))
 
+#ifdef CONFIG_64BIT
 #define set_pud(pudptr, pudval) set_64bit((phys_t *) (pudptr), pud_val(pudval))
+#else
+#define set_pud(pudptr, pudval) (*(pudptr) = (pudval))
+#endif
+
 static inline int pgd_newpage(pgd_t pgd)
 {
 	return(pgd_val(pgd) & _PAGE_NEWPAGE);
@@ -57,7 +72,11 @@ static inline int pgd_newpage(pgd_t pgd)
 
 static inline void pgd_mkuptodate(pgd_t pgd) { pgd_val(pgd) &= ~_PAGE_NEWPAGE; }
 
+#ifdef CONFIG_64BIT
 #define set_pmd(pmdptr, pmdval) set_64bit((phys_t *) (pmdptr), pmd_val(pmdval))
+#else
+#define set_pmd(pmdptr, pmdval) (*(pmdptr) = (pmdval))
+#endif
 
 struct mm_struct;
 extern pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address);
diff -puN include/asm-um/pgtable.h~uml-fix-page-table-data-sizes include/asm-um/pgtable.h
--- a/include/asm-um/pgtable.h~uml-fix-page-table-data-sizes
+++ a/include/asm-um/pgtable.h
@@ -262,7 +262,7 @@ static inline void set_pte(pte_t *pteptr
 
 #define phys_to_page(phys) pfn_to_page(phys_to_pfn(phys))
 #define __virt_to_page(virt) phys_to_page(__pa(virt))
-#define page_to_phys(page) pfn_to_phys(page_to_pfn(page))
+#define page_to_phys(page) pfn_to_phys((pfn_t) page_to_pfn(page))
 #define virt_to_page(addr) __virt_to_page((const unsigned long) addr)
 
 #define mk_pte(page, pgprot) \
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
