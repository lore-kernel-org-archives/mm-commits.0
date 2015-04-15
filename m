From: akpm@linux-foundation.org
Subject: [merged]
 parisc-expose-number-of-page-table-levels-on-kconfig-level.patch removed
 from -mm tree
Date: Wed, 15 Apr 2015 12:10:05 -0700
Message-ID: <552eb78d.W45aZyYhzokZI21s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421AbbDOTKG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:10:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, deller@gmx.de, jejb@parisc-linux.org, linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: parisc: expose number of page table levels on Kconfig level
has been removed from the -mm tree.  Its filename was
     parisc-expose-number-of-page-table-levels-on-kconfig-level.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: parisc: expose number of page table levels on Kconfig level

We would want to use number of page table level to define mm_struct.
Let's expose it as CONFIG_PGTABLE_LEVELS.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/Kconfig               |    5 +++++
 arch/parisc/include/asm/pgalloc.h |    2 +-
 arch/parisc/include/asm/pgtable.h |   16 +++++++---------
 arch/parisc/kernel/entry.S        |    4 ++--
 arch/parisc/kernel/head.S         |    4 ++--
 arch/parisc/mm/init.c             |    2 +-
 6 files changed, 18 insertions(+), 15 deletions(-)

diff -puN arch/parisc/Kconfig~parisc-expose-number-of-page-table-levels-on-kconfig-level arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~parisc-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/parisc/Kconfig
@@ -103,6 +103,11 @@ config ARCH_MAY_HAVE_PC_FDC
 	depends on BROKEN
 	default y
 
+config PGTABLE_LEVELS
+	int
+	default 3 if 64BIT && PARISC_PAGE_SIZE_4KB
+	default 2
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff -puN arch/parisc/include/asm/pgalloc.h~parisc-expose-number-of-page-table-levels-on-kconfig-level arch/parisc/include/asm/pgalloc.h
--- a/arch/parisc/include/asm/pgalloc.h~parisc-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/parisc/include/asm/pgalloc.h
@@ -51,7 +51,7 @@ static inline void pgd_free(struct mm_st
 	free_pages((unsigned long)pgd, PGD_ALLOC_ORDER);
 }
 
-#if PT_NLEVELS == 3
+#if CONFIG_PGTABLE_LEVELS == 3
 
 /* Three Level Page Table Support for pmd's */
 
diff -puN arch/parisc/include/asm/pgtable.h~parisc-expose-number-of-page-table-levels-on-kconfig-level arch/parisc/include/asm/pgtable.h
--- a/arch/parisc/include/asm/pgtable.h~parisc-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/parisc/include/asm/pgtable.h
@@ -68,13 +68,11 @@ extern void purge_tlb_entries(struct mm_
 #define KERNEL_INITIAL_ORDER	24	/* 0 to 1<<24 = 16MB */
 #define KERNEL_INITIAL_SIZE	(1 << KERNEL_INITIAL_ORDER)
 
-#if defined(CONFIG_64BIT) && defined(CONFIG_PARISC_PAGE_SIZE_4KB)
-#define PT_NLEVELS	3
+#if CONFIG_PGTABLE_LEVELS == 3
 #define PGD_ORDER	1 /* Number of pages per pgd */
 #define PMD_ORDER	1 /* Number of pages per pmd */
 #define PGD_ALLOC_ORDER	2 /* first pgd contains pmd */
 #else
-#define PT_NLEVELS	2
 #define PGD_ORDER	1 /* Number of pages per pgd */
 #define PGD_ALLOC_ORDER	PGD_ORDER
 #endif
@@ -93,7 +91,7 @@ extern void purge_tlb_entries(struct mm_
 #define PMD_SHIFT       (PLD_SHIFT + BITS_PER_PTE)
 #define PMD_SIZE	(1UL << PMD_SHIFT)
 #define PMD_MASK	(~(PMD_SIZE-1))
-#if PT_NLEVELS == 3
+#if CONFIG_PGTABLE_LEVELS == 3
 #define BITS_PER_PMD	(PAGE_SHIFT + PMD_ORDER - BITS_PER_PMD_ENTRY)
 #else
 #define __PAGETABLE_PMD_FOLDED
@@ -277,7 +275,7 @@ extern unsigned long *empty_zero_page;
 #define pgd_flag(x)	(pgd_val(x) & PxD_FLAG_MASK)
 #define pgd_address(x)	((unsigned long)(pgd_val(x) &~ PxD_FLAG_MASK) << PxD_VALUE_SHIFT)
 
-#if PT_NLEVELS == 3
+#if CONFIG_PGTABLE_LEVELS == 3
 /* The first entry of the permanent pmd is not there if it contains
  * the gateway marker */
 #define pmd_none(x)	(!pmd_val(x) || pmd_flag(x) == PxD_FLAG_ATTACHED)
@@ -287,7 +285,7 @@ extern unsigned long *empty_zero_page;
 #define pmd_bad(x)	(!(pmd_flag(x) & PxD_FLAG_VALID))
 #define pmd_present(x)	(pmd_flag(x) & PxD_FLAG_PRESENT)
 static inline void pmd_clear(pmd_t *pmd) {
-#if PT_NLEVELS == 3
+#if CONFIG_PGTABLE_LEVELS == 3
 	if (pmd_flag(*pmd) & PxD_FLAG_ATTACHED)
 		/* This is the entry pointing to the permanent pmd
 		 * attached to the pgd; cannot clear it */
@@ -299,7 +297,7 @@ static inline void pmd_clear(pmd_t *pmd)
 
 
 
-#if PT_NLEVELS == 3
+#if CONFIG_PGTABLE_LEVELS == 3
 #define pgd_page_vaddr(pgd) ((unsigned long) __va(pgd_address(pgd)))
 #define pgd_page(pgd)	virt_to_page((void *)pgd_page_vaddr(pgd))
 
@@ -309,7 +307,7 @@ static inline void pmd_clear(pmd_t *pmd)
 #define pgd_bad(x)      (!(pgd_flag(x) & PxD_FLAG_VALID))
 #define pgd_present(x)  (pgd_flag(x) & PxD_FLAG_PRESENT)
 static inline void pgd_clear(pgd_t *pgd) {
-#if PT_NLEVELS == 3
+#if CONFIG_PGTABLE_LEVELS == 3
 	if(pgd_flag(*pgd) & PxD_FLAG_ATTACHED)
 		/* This is the permanent pmd attached to the pgd; cannot
 		 * free it */
@@ -393,7 +391,7 @@ static inline pte_t pte_modify(pte_t pte
 
 /* Find an entry in the second-level page table.. */
 
-#if PT_NLEVELS == 3
+#if CONFIG_PGTABLE_LEVELS == 3
 #define pmd_offset(dir,address) \
 ((pmd_t *) pgd_page_vaddr(*(dir)) + (((address)>>PMD_SHIFT) & (PTRS_PER_PMD-1)))
 #else
diff -puN arch/parisc/kernel/entry.S~parisc-expose-number-of-page-table-levels-on-kconfig-level arch/parisc/kernel/entry.S
--- a/arch/parisc/kernel/entry.S~parisc-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/parisc/kernel/entry.S
@@ -398,7 +398,7 @@
 	 * can address up to 1TB
 	 */
 	.macro		L2_ptep	pmd,pte,index,va,fault
-#if PT_NLEVELS == 3
+#if CONFIG_PGTABLE_LEVELS == 3
 	extru		\va,31-ASM_PMD_SHIFT,ASM_BITS_PER_PMD,\index
 #else
 # if defined(CONFIG_64BIT)
@@ -436,7 +436,7 @@
 	 * all ILP32 processes and all the kernel for machines with
 	 * under 4GB of memory) */
 	.macro		L3_ptep pgd,pte,index,va,fault
-#if PT_NLEVELS == 3 /* we might have a 2-Level scheme, e.g. with 16kb page size */
+#if CONFIG_PGTABLE_LEVELS == 3 /* we might have a 2-Level scheme, e.g. with 16kb page size */
 	extrd,u		\va,63-ASM_PGDIR_SHIFT,ASM_BITS_PER_PGD,\index
 	copy		%r0,\pte
 	extrd,u,*=	\va,63-ASM_PGDIR_SHIFT,64-ASM_PGDIR_SHIFT,%r0
diff -puN arch/parisc/kernel/head.S~parisc-expose-number-of-page-table-levels-on-kconfig-level arch/parisc/kernel/head.S
--- a/arch/parisc/kernel/head.S~parisc-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/parisc/kernel/head.S
@@ -74,7 +74,7 @@ $bss_loop:
 	mtctl		%r4,%cr24	/* Initialize kernel root pointer */
 	mtctl		%r4,%cr25	/* Initialize user root pointer */
 
-#if PT_NLEVELS == 3
+#if CONFIG_PGTABLE_LEVELS == 3
 	/* Set pmd in pgd */
 	load32		PA(pmd0),%r5
 	shrd            %r5,PxD_VALUE_SHIFT,%r3	
@@ -97,7 +97,7 @@ $bss_loop:
 	stw		%r3,0(%r4)
 	ldo		(PAGE_SIZE >> PxD_VALUE_SHIFT)(%r3),%r3
 	addib,>		-1,%r1,1b
-#if PT_NLEVELS == 3
+#if CONFIG_PGTABLE_LEVELS == 3
 	ldo             ASM_PMD_ENTRY_SIZE(%r4),%r4
 #else
 	ldo             ASM_PGD_ENTRY_SIZE(%r4),%r4
diff -puN arch/parisc/mm/init.c~parisc-expose-number-of-page-table-levels-on-kconfig-level arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c~parisc-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/parisc/mm/init.c
@@ -34,7 +34,7 @@
 extern int  data_start;
 extern void parisc_kernel_start(void);	/* Kernel entry point in head.S */
 
-#if PT_NLEVELS == 3
+#if CONFIG_PGTABLE_LEVELS == 3
 /* NOTE: This layout exactly conforms to the hybrid L2/L3 page table layout
  * with the first pmd adjacent to the pgd and below it. gcc doesn't actually
  * guarantee that global objects will be laid out in memory in the same order
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh.patch
mm-avoid-tail-page-refcounting-on-non-thp-compound-pages.patch
mm-migrate-check-before-clear-pageswapcache.patch
mm-page-writeback-check-before-clear-pagereclaim.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-sanitize-page-mapping-for-tail-pages-v2.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
thp-handle-errors-in-hugepage_init-properly.patch
thp-do-not-adjust-zone-water-marks-if-khugepaged-is-not-started.patch
mm-mmapc-use-while-instead-of-ifgoto.patch
mm-mmapc-use-while-instead-of-ifgoto-fix.patch
mm-uninline-and-cleanup-page-mapping-related-helpers.patch
mm-uninline-and-cleanup-page-mapping-related-helpers-checkpatch-fixes.patch
thp-cleanup-khugepaged-startup.patch
mmv41-new-pfn_mkwrite-same-as-page_mkwrite-for-vm_pfnmap.patch
dax-use-pfn_mkwrite-to-update-c-mtime-freeze-protection.patch
dax-unify-ext2-4_dax_file_operations.patch
linux-next.patch

