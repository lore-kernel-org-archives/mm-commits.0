From: akpm@linux-foundation.org
Subject: +
 parisc-expose-number-of-page-table-levels-on-kconfig-level.patch added to
 -mm tree
Date: Mon, 23 Feb 2015 12:44:48 -0800
Message-ID: <54eb9140.AHp5VUMh3IclhsrO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44344 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbbBWUot (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 15:44:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, deller@gmx.de, jejb@parisc-linux.org, linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: parisc: expose number of page table levels on Kconfig level
has been added to the -mm tree.  Its filename is
     parisc-expose-number-of-page-table-levels-on-kconfig-level.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/parisc-expose-number-of-page-table-levels-on-kconfig-level.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/parisc-expose-number-of-page-table-levels-on-kconfig-level.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 arch/parisc/include/asm/pgtable.h |   17 ++++++++---------
 arch/parisc/kernel/entry.S        |    4 ++--
 arch/parisc/kernel/head.S         |    4 ++--
 arch/parisc/mm/init.c             |    2 +-
 6 files changed, 19 insertions(+), 15 deletions(-)

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
@@ -93,9 +91,10 @@ extern void purge_tlb_entries(struct mm_
 #define PMD_SHIFT       (PLD_SHIFT + BITS_PER_PTE)
 #define PMD_SIZE	(1UL << PMD_SHIFT)
 #define PMD_MASK	(~(PMD_SIZE-1))
-#if PT_NLEVELS == 3
+#if CONFIG_PGTABLE_LEVELS == 3
 #define BITS_PER_PMD	(PAGE_SHIFT + PMD_ORDER - BITS_PER_PMD_ENTRY)
 #else
+#define __PAGETABLE_PMD_FOLDED
 #define BITS_PER_PMD	0
 #endif
 #define PTRS_PER_PMD    (1UL << BITS_PER_PMD)
@@ -276,7 +275,7 @@ extern unsigned long *empty_zero_page;
 #define pgd_flag(x)	(pgd_val(x) & PxD_FLAG_MASK)
 #define pgd_address(x)	((unsigned long)(pgd_val(x) &~ PxD_FLAG_MASK) << PxD_VALUE_SHIFT)
 
-#if PT_NLEVELS == 3
+#if CONFIG_PGTABLE_LEVELS == 3
 /* The first entry of the permanent pmd is not there if it contains
  * the gateway marker */
 #define pmd_none(x)	(!pmd_val(x) || pmd_flag(x) == PxD_FLAG_ATTACHED)
@@ -286,7 +285,7 @@ extern unsigned long *empty_zero_page;
 #define pmd_bad(x)	(!(pmd_flag(x) & PxD_FLAG_VALID))
 #define pmd_present(x)	(pmd_flag(x) & PxD_FLAG_PRESENT)
 static inline void pmd_clear(pmd_t *pmd) {
-#if PT_NLEVELS == 3
+#if CONFIG_PGTABLE_LEVELS == 3
 	if (pmd_flag(*pmd) & PxD_FLAG_ATTACHED)
 		/* This is the entry pointing to the permanent pmd
 		 * attached to the pgd; cannot clear it */
@@ -298,7 +297,7 @@ static inline void pmd_clear(pmd_t *pmd)
 
 
 
-#if PT_NLEVELS == 3
+#if CONFIG_PGTABLE_LEVELS == 3
 #define pgd_page_vaddr(pgd) ((unsigned long) __va(pgd_address(pgd)))
 #define pgd_page(pgd)	virt_to_page((void *)pgd_page_vaddr(pgd))
 
@@ -308,7 +307,7 @@ static inline void pmd_clear(pmd_t *pmd)
 #define pgd_bad(x)      (!(pgd_flag(x) & PxD_FLAG_VALID))
 #define pgd_present(x)  (pgd_flag(x) & PxD_FLAG_PRESENT)
 static inline void pgd_clear(pgd_t *pgd) {
-#if PT_NLEVELS == 3
+#if CONFIG_PGTABLE_LEVELS == 3
 	if(pgd_flag(*pgd) & PxD_FLAG_ATTACHED)
 		/* This is the permanent pmd attached to the pgd; cannot
 		 * free it */
@@ -392,7 +391,7 @@ static inline pte_t pte_modify(pte_t pte
 
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

mm-rename-foll_mlock-to-foll_populate.patch
mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range.patch
mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate.patch
mm-move-mm_populate-related-code-to-mm-gupc.patch
mm-incorporate-zero-pages-into-transparent-huge-pages.patch
mm-incorporate-zero-pages-into-transparent-huge-pages-fix.patch
alpha-expose-number-of-page-table-levels-on-kconfig-level.patch
arm64-expose-number-of-page-table-levels-on-kconfig-level.patch
arm-expose-number-of-page-table-levels-on-kconfig-level.patch
frv-mark-pud-and-pmd-folded.patch
ia64-expose-number-of-page-table-levels-on-kconfig-level.patch
m32r-mark-pmd-folded.patch
m68k-mark-pmd-folded-and-expose-number-of-page-table-levels.patch
mips-expose-number-of-page-table-levels-on-kconfig-level.patch
mn10300-mark-pud-and-pmd-folded.patch
parisc-expose-number-of-page-table-levels-on-kconfig-level.patch
powerpc-expose-number-of-page-table-levels-on-kconfig-level.patch
s390-expose-number-of-page-table-levels.patch
sh-expose-number-of-page-table-levels.patch
sparc-expose-number-of-page-table-levels.patch
tile-expose-number-of-page-table-levels.patch
um-expose-number-of-page-table-levels.patch
x86-expose-number-of-page-table-levels-on-kconfig-level.patch
mm-define-default-pgtable_levels-to-two.patch
mm-do-not-add-nr_pmds-into-mm_struct-if-pmd-is-folded.patch

