From: akpm@linux-foundation.org
Subject: [merged]
 mm-make-first_user_address-unsigned-long-on-all-archs.patch removed from
 -mm tree
Date: Thu, 12 Feb 2015 11:37:24 -0800
Message-ID: <54dd00f4.3mA44Y2zj6uppDGL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58225 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbbBLThZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:37:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make FIRST_USER_ADDRESS unsigned long on all archs
has been removed from the -mm tree.  Its filename was
     mm-make-first_user_address-unsigned-long-on-all-archs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: make FIRST_USER_ADDRESS unsigned long on all archs

LKP has triggered a compiler warning after my recent patch "mm: account
pmd page tables to the process":

    mm/mmap.c: In function 'exit_mmap':
 >> mm/mmap.c:2857:2: warning: right shift count >= width of type [enabled by default]

The code:

 > 2857                WARN_ON(mm_nr_pmds(mm) >
   2858                                round_up(FIRST_USER_ADDRESS, PUD_SIZE) >> PUD_SHIFT);

In this, on tile, we have FIRST_USER_ADDRESS defined as 0.  round_up() has
the same type -- int.  PUD_SHIFT.

I think the best way to fix it is to define FIRST_USER_ADDRESS as unsigned
long.  On every arch for consistency.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/pgtable.h         |    2 +-
 arch/arc/include/asm/pgtable.h           |    2 +-
 arch/arm/include/asm/pgtable-nommu.h     |    2 +-
 arch/arm64/include/asm/pgtable.h         |    2 +-
 arch/avr32/include/asm/pgtable.h         |    2 +-
 arch/cris/include/asm/pgtable.h          |    2 +-
 arch/frv/include/asm/pgtable.h           |    2 +-
 arch/hexagon/include/asm/pgtable.h       |    2 +-
 arch/ia64/include/asm/pgtable.h          |    2 +-
 arch/m32r/include/asm/pgtable.h          |    2 +-
 arch/m68k/include/asm/pgtable_mm.h       |    2 +-
 arch/microblaze/include/asm/pgtable.h    |    2 +-
 arch/mips/include/asm/pgtable-32.h       |    2 +-
 arch/mn10300/include/asm/pgtable.h       |    2 +-
 arch/nios2/include/asm/pgtable.h         |    2 +-
 arch/openrisc/include/asm/pgtable.h      |    2 +-
 arch/parisc/include/asm/pgtable.h        |    2 +-
 arch/powerpc/include/asm/pgtable-ppc32.h |    2 +-
 arch/powerpc/include/asm/pgtable-ppc64.h |    2 +-
 arch/s390/include/asm/pgtable.h          |    2 +-
 arch/score/include/asm/pgtable.h         |    2 +-
 arch/sh/include/asm/pgtable.h            |    2 +-
 arch/sparc/include/asm/pgtable_32.h      |    2 +-
 arch/sparc/include/asm/pgtable_64.h      |    2 +-
 arch/tile/include/asm/pgtable.h          |    2 +-
 arch/um/include/asm/pgtable-2level.h     |    2 +-
 arch/um/include/asm/pgtable-3level.h     |    2 +-
 arch/x86/include/asm/pgtable_types.h     |    2 +-
 arch/xtensa/include/asm/pgtable.h        |    2 +-
 29 files changed, 29 insertions(+), 29 deletions(-)

diff -puN arch/alpha/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/alpha/include/asm/pgtable.h
--- a/arch/alpha/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/alpha/include/asm/pgtable.h
@@ -45,7 +45,7 @@ struct vm_area_struct;
 #define PTRS_PER_PMD	(1UL << (PAGE_SHIFT-3))
 #define PTRS_PER_PGD	(1UL << (PAGE_SHIFT-3))
 #define USER_PTRS_PER_PGD	(TASK_SIZE / PGDIR_SIZE)
-#define FIRST_USER_ADDRESS	0
+#define FIRST_USER_ADDRESS	0UL
 
 /* Number of pointers that fit on a page:  this will go away. */
 #define PTRS_PER_PAGE	(1UL << (PAGE_SHIFT-3))
diff -puN arch/arc/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/arc/include/asm/pgtable.h
--- a/arch/arc/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/arc/include/asm/pgtable.h
@@ -211,7 +211,7 @@
  * No special requirements for lowest virtual address we permit any user space
  * mapping to be mapped at.
  */
-#define FIRST_USER_ADDRESS      0
+#define FIRST_USER_ADDRESS      0UL
 
 
 /****************************************************************
diff -puN arch/arm/include/asm/pgtable-nommu.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/arm/include/asm/pgtable-nommu.h
--- a/arch/arm/include/asm/pgtable-nommu.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/arm/include/asm/pgtable-nommu.h
@@ -85,7 +85,7 @@ extern unsigned int kobjsize(const void
 #define	VMALLOC_START	0UL
 #define	VMALLOC_END	0xffffffffUL
 
-#define FIRST_USER_ADDRESS      (0)
+#define FIRST_USER_ADDRESS      0UL
 
 #include <asm-generic/pgtable.h>
 
diff -puN arch/arm64/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/arm64/include/asm/pgtable.h
--- a/arch/arm64/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/arm64/include/asm/pgtable.h
@@ -45,7 +45,7 @@
 
 #define vmemmap			((struct page *)(VMALLOC_END + SZ_64K))
 
-#define FIRST_USER_ADDRESS	0
+#define FIRST_USER_ADDRESS	0UL
 
 #ifndef __ASSEMBLY__
 extern void __pte_error(const char *file, int line, unsigned long val);
diff -puN arch/avr32/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/avr32/include/asm/pgtable.h
--- a/arch/avr32/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/avr32/include/asm/pgtable.h
@@ -30,7 +30,7 @@
 #define PGDIR_MASK	(~(PGDIR_SIZE-1))
 
 #define USER_PTRS_PER_PGD	(TASK_SIZE / PGDIR_SIZE)
-#define FIRST_USER_ADDRESS	0
+#define FIRST_USER_ADDRESS	0UL
 
 #ifndef __ASSEMBLY__
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
diff -puN arch/cris/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/cris/include/asm/pgtable.h
--- a/arch/cris/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/cris/include/asm/pgtable.h
@@ -67,7 +67,7 @@ extern void paging_init(void);
  */
 
 #define USER_PTRS_PER_PGD       (TASK_SIZE/PGDIR_SIZE)
-#define FIRST_USER_ADDRESS      0
+#define FIRST_USER_ADDRESS      0UL
 
 /* zero page used for uninitialized stuff */
 #ifndef __ASSEMBLY__
diff -puN arch/frv/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/frv/include/asm/pgtable.h
--- a/arch/frv/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/frv/include/asm/pgtable.h
@@ -140,7 +140,7 @@ extern unsigned long empty_zero_page;
 #define PTRS_PER_PTE		4096
 
 #define USER_PGDS_IN_LAST_PML4	(TASK_SIZE / PGDIR_SIZE)
-#define FIRST_USER_ADDRESS	0
+#define FIRST_USER_ADDRESS	0UL
 
 #define USER_PGD_PTRS		(PAGE_OFFSET >> PGDIR_SHIFT)
 #define KERNEL_PGD_PTRS		(PTRS_PER_PGD - USER_PGD_PTRS)
diff -puN arch/hexagon/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/hexagon/include/asm/pgtable.h
--- a/arch/hexagon/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/hexagon/include/asm/pgtable.h
@@ -171,7 +171,7 @@ extern unsigned long _dflt_cache_att;
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];  /* located in head.S */
 
 /* Seems to be zero even in architectures where the zero page is firewalled? */
-#define FIRST_USER_ADDRESS 0
+#define FIRST_USER_ADDRESS 0UL
 #define pte_special(pte)	0
 #define pte_mkspecial(pte)	(pte)
 
diff -puN arch/ia64/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/ia64/include/asm/pgtable.h
--- a/arch/ia64/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/ia64/include/asm/pgtable.h
@@ -127,7 +127,7 @@
 #define PTRS_PER_PGD_SHIFT	PTRS_PER_PTD_SHIFT
 #define PTRS_PER_PGD		(1UL << PTRS_PER_PGD_SHIFT)
 #define USER_PTRS_PER_PGD	(5*PTRS_PER_PGD/8)	/* regions 0-4 are user regions */
-#define FIRST_USER_ADDRESS	0
+#define FIRST_USER_ADDRESS	0UL
 
 /*
  * All the normal masks have the "page accessed" bits on, as any time
diff -puN arch/m32r/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/m32r/include/asm/pgtable.h
--- a/arch/m32r/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/m32r/include/asm/pgtable.h
@@ -53,7 +53,7 @@ extern unsigned long empty_zero_page[102
 #define PGDIR_MASK	(~(PGDIR_SIZE - 1))
 
 #define USER_PTRS_PER_PGD	(TASK_SIZE / PGDIR_SIZE)
-#define FIRST_USER_ADDRESS	0
+#define FIRST_USER_ADDRESS	0UL
 
 #ifndef __ASSEMBLY__
 /* Just any arbitrary offset to the start of the vmalloc VM area: the
diff -puN arch/m68k/include/asm/pgtable_mm.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/m68k/include/asm/pgtable_mm.h
--- a/arch/m68k/include/asm/pgtable_mm.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/m68k/include/asm/pgtable_mm.h
@@ -66,7 +66,7 @@
 #define PTRS_PER_PGD	128
 #endif
 #define USER_PTRS_PER_PGD	(TASK_SIZE/PGDIR_SIZE)
-#define FIRST_USER_ADDRESS	0
+#define FIRST_USER_ADDRESS	0UL
 
 /* Virtual address region for use by kernel_map() */
 #ifdef CONFIG_SUN3
diff -puN arch/microblaze/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/microblaze/include/asm/pgtable.h
--- a/arch/microblaze/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/microblaze/include/asm/pgtable.h
@@ -72,7 +72,7 @@ extern int mem_init_done;
 #include <asm/mmu.h>
 #include <asm/page.h>
 
-#define FIRST_USER_ADDRESS	0
+#define FIRST_USER_ADDRESS	0UL
 
 extern unsigned long va_to_phys(unsigned long address);
 extern pte_t *va_to_pte(unsigned long address);
diff -puN arch/mips/include/asm/pgtable-32.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/mips/include/asm/pgtable-32.h
--- a/arch/mips/include/asm/pgtable-32.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/mips/include/asm/pgtable-32.h
@@ -57,7 +57,7 @@ extern int add_temporary_entry(unsigned
 #define PTRS_PER_PTE	((PAGE_SIZE << PTE_ORDER) / sizeof(pte_t))
 
 #define USER_PTRS_PER_PGD	(0x80000000UL/PGDIR_SIZE)
-#define FIRST_USER_ADDRESS	0
+#define FIRST_USER_ADDRESS	0UL
 
 #define VMALLOC_START	  MAP_BASE
 
diff -puN arch/mn10300/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/mn10300/include/asm/pgtable.h
--- a/arch/mn10300/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/mn10300/include/asm/pgtable.h
@@ -65,7 +65,7 @@ extern void paging_init(void);
 #define PGDIR_MASK	(~(PGDIR_SIZE - 1))
 
 #define USER_PTRS_PER_PGD	(TASK_SIZE / PGDIR_SIZE)
-#define FIRST_USER_ADDRESS	0
+#define FIRST_USER_ADDRESS	0UL
 
 #define USER_PGD_PTRS		(PAGE_OFFSET >> PGDIR_SHIFT)
 #define KERNEL_PGD_PTRS		(PTRS_PER_PGD - USER_PGD_PTRS)
diff -puN arch/nios2/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/nios2/include/asm/pgtable.h
--- a/arch/nios2/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/nios2/include/asm/pgtable.h
@@ -24,7 +24,7 @@
 #include <asm/pgtable-bits.h>
 #include <asm-generic/pgtable-nopmd.h>
 
-#define FIRST_USER_ADDRESS	0
+#define FIRST_USER_ADDRESS	0UL
 
 #define VMALLOC_START		CONFIG_NIOS2_KERNEL_MMU_REGION_BASE
 #define VMALLOC_END		(CONFIG_NIOS2_KERNEL_REGION_BASE - 1)
diff -puN arch/openrisc/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/openrisc/include/asm/pgtable.h
--- a/arch/openrisc/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/openrisc/include/asm/pgtable.h
@@ -77,7 +77,7 @@ extern void paging_init(void);
  */
 
 #define USER_PTRS_PER_PGD       (TASK_SIZE/PGDIR_SIZE)
-#define FIRST_USER_ADDRESS      0
+#define FIRST_USER_ADDRESS      0UL
 
 /*
  * Kernels own virtual memory area.
diff -puN arch/parisc/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/parisc/include/asm/pgtable.h
--- a/arch/parisc/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/parisc/include/asm/pgtable.h
@@ -134,7 +134,7 @@ extern void purge_tlb_entries(struct mm_
  * pgd entries used up by user/kernel:
  */
 
-#define FIRST_USER_ADDRESS	0
+#define FIRST_USER_ADDRESS	0UL
 
 /* NB: The tlb miss handlers make certain assumptions about the order */
 /*     of the following bits, so be careful (One example, bits 25-31  */
diff -puN arch/powerpc/include/asm/pgtable-ppc32.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/powerpc/include/asm/pgtable-ppc32.h
--- a/arch/powerpc/include/asm/pgtable-ppc32.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/powerpc/include/asm/pgtable-ppc32.h
@@ -45,7 +45,7 @@ extern int icache_44x_need_flush;
 #define PTRS_PER_PGD	(1 << (32 - PGDIR_SHIFT))
 
 #define USER_PTRS_PER_PGD	(TASK_SIZE / PGDIR_SIZE)
-#define FIRST_USER_ADDRESS	0
+#define FIRST_USER_ADDRESS	0UL
 
 #define pte_ERROR(e) \
 	pr_err("%s:%d: bad pte %llx.\n", __FILE__, __LINE__, \
diff -puN arch/powerpc/include/asm/pgtable-ppc64.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/powerpc/include/asm/pgtable-ppc64.h
--- a/arch/powerpc/include/asm/pgtable-ppc64.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/powerpc/include/asm/pgtable-ppc64.h
@@ -12,7 +12,7 @@
 #endif
 #include <asm/barrier.h>
 
-#define FIRST_USER_ADDRESS	0
+#define FIRST_USER_ADDRESS	0UL
 
 /*
  * Size of EA range mapped by our pagetables.
diff -puN arch/s390/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/s390/include/asm/pgtable.h
@@ -99,7 +99,7 @@ extern unsigned long zero_page_mask;
 #endif /* CONFIG_64BIT */
 #define PTRS_PER_PGD	2048
 
-#define FIRST_USER_ADDRESS  0
+#define FIRST_USER_ADDRESS  0UL
 
 #define pte_ERROR(e) \
 	printk("%s:%d: bad pte %p.\n", __FILE__, __LINE__, (void *) pte_val(e))
diff -puN arch/score/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/score/include/asm/pgtable.h
--- a/arch/score/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/score/include/asm/pgtable.h
@@ -27,7 +27,7 @@ extern pte_t invalid_pte_table[PAGE_SIZE
 #define PTRS_PER_PTE	1024
 
 #define USER_PTRS_PER_PGD	(0x80000000UL/PGDIR_SIZE)
-#define FIRST_USER_ADDRESS	0
+#define FIRST_USER_ADDRESS	0UL
 
 #define VMALLOC_START		(0xc0000000UL)
 
diff -puN arch/sh/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/sh/include/asm/pgtable.h
--- a/arch/sh/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/sh/include/asm/pgtable.h
@@ -62,7 +62,7 @@ static inline unsigned long long neff_si
 /* Entries per level */
 #define PTRS_PER_PTE	(PAGE_SIZE / (1 << PTE_MAGNITUDE))
 
-#define FIRST_USER_ADDRESS	0
+#define FIRST_USER_ADDRESS	0UL
 
 #define PHYS_ADDR_MASK29		0x1fffffff
 #define PHYS_ADDR_MASK32		0xffffffff
diff -puN arch/sparc/include/asm/pgtable_32.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/sparc/include/asm/pgtable_32.h
--- a/arch/sparc/include/asm/pgtable_32.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/sparc/include/asm/pgtable_32.h
@@ -44,7 +44,7 @@ unsigned long __init bootmem_init(unsign
 #define PTRS_PER_PMD    	SRMMU_PTRS_PER_PMD
 #define PTRS_PER_PGD    	SRMMU_PTRS_PER_PGD
 #define USER_PTRS_PER_PGD	PAGE_OFFSET / SRMMU_PGDIR_SIZE
-#define FIRST_USER_ADDRESS	0
+#define FIRST_USER_ADDRESS	0UL
 #define PTE_SIZE		(PTRS_PER_PTE*4)
 
 #define PAGE_NONE	SRMMU_PAGE_NONE
diff -puN arch/sparc/include/asm/pgtable_64.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/sparc/include/asm/pgtable_64.h
--- a/arch/sparc/include/asm/pgtable_64.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -93,7 +93,7 @@ bool kern_addr_valid(unsigned long addr)
 #define PTRS_PER_PGD	(1UL << PGDIR_BITS)
 
 /* Kernel has a separate 44bit address space. */
-#define FIRST_USER_ADDRESS	0
+#define FIRST_USER_ADDRESS	0UL
 
 #define pmd_ERROR(e)							\
 	pr_err("%s:%d: bad pmd %p(%016lx) seen at (%pS)\n",		\
diff -puN arch/tile/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/tile/include/asm/pgtable.h
--- a/arch/tile/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/tile/include/asm/pgtable.h
@@ -67,7 +67,7 @@ extern void pgtable_cache_init(void);
 extern void paging_init(void);
 extern void set_page_homes(void);
 
-#define FIRST_USER_ADDRESS	0
+#define FIRST_USER_ADDRESS	0UL
 
 #define _PAGE_PRESENT           HV_PTE_PRESENT
 #define _PAGE_HUGE_PAGE         HV_PTE_PAGE
diff -puN arch/um/include/asm/pgtable-2level.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/um/include/asm/pgtable-2level.h
--- a/arch/um/include/asm/pgtable-2level.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/um/include/asm/pgtable-2level.h
@@ -23,7 +23,7 @@
 #define PTRS_PER_PTE	1024
 #define USER_PTRS_PER_PGD ((TASK_SIZE + (PGDIR_SIZE - 1)) / PGDIR_SIZE)
 #define PTRS_PER_PGD	1024
-#define FIRST_USER_ADDRESS	0
+#define FIRST_USER_ADDRESS	0UL
 
 #define pte_ERROR(e) \
         printk("%s:%d: bad pte %p(%08lx).\n", __FILE__, __LINE__, &(e), \
diff -puN arch/um/include/asm/pgtable-3level.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/um/include/asm/pgtable-3level.h
--- a/arch/um/include/asm/pgtable-3level.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/um/include/asm/pgtable-3level.h
@@ -41,7 +41,7 @@
 #endif
 
 #define USER_PTRS_PER_PGD ((TASK_SIZE + (PGDIR_SIZE - 1)) / PGDIR_SIZE)
-#define FIRST_USER_ADDRESS	0
+#define FIRST_USER_ADDRESS	0UL
 
 #define pte_ERROR(e) \
         printk("%s:%d: bad pte %p(%016lx).\n", __FILE__, __LINE__, &(e), \
diff -puN arch/x86/include/asm/pgtable_types.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/x86/include/asm/pgtable_types.h
--- a/arch/x86/include/asm/pgtable_types.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/x86/include/asm/pgtable_types.h
@@ -4,7 +4,7 @@
 #include <linux/const.h>
 #include <asm/page_types.h>
 
-#define FIRST_USER_ADDRESS	0
+#define FIRST_USER_ADDRESS	0UL
 
 #define _PAGE_BIT_PRESENT	0	/* is present */
 #define _PAGE_BIT_RW		1	/* writeable */
diff -puN arch/xtensa/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs arch/xtensa/include/asm/pgtable.h
--- a/arch/xtensa/include/asm/pgtable.h~mm-make-first_user_address-unsigned-long-on-all-archs
+++ a/arch/xtensa/include/asm/pgtable.h
@@ -57,7 +57,7 @@
 #define PTRS_PER_PGD		1024
 #define PGD_ORDER		0
 #define USER_PTRS_PER_PGD	(TASK_SIZE/PGDIR_SIZE)
-#define FIRST_USER_ADDRESS	0
+#define FIRST_USER_ADDRESS	0UL
 #define FIRST_USER_PGD_NR	(FIRST_USER_ADDRESS >> PGDIR_SHIFT)
 
 /*
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
mm-numa-do-not-dereference-pmd-outside-of-the-lock-during-numa-hinting-fault.patch
mm-add-p-protnone-helpers-for-use-by-numa-balancing.patch
mm-convert-p_numa-users-to-p_protnone_numa.patch
ppc64-add-paranoid-warnings-for-unexpected-dsisr_protfault.patch
mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch
mm-remove-remaining-references-to-numa-hinting-bits-and-helpers.patch
mm-numa-do-not-trap-faults-on-the-huge-zero-page.patch
x86-mm-restore-original-pte_special-check.patch
mm-numa-add-paranoid-check-around-pte_protnone_numa.patch
mm-numa-avoid-unnecessary-tlb-flushes-when-setting-numa-hinting-entries.patch
mm-do-not-use-mm-nr_pmds-on-mmu-configurations.patch
mm-fix-xip-fault-vs-truncate-race.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
vfsext2-introduce-is_daxinode.patch
daxext2-replace-xip-read-and-write-with-dax-i-o.patch
daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-xip_truncate_page-with-dax_truncate_page.patch
dax-replace-xip-documentation-with-dax-documentation.patch
vfs-remove-get_xip_mem.patch
ext2-remove-ext2_xip_verify_sb.patch
ext2-remove-ext2_use_xip.patch
ext2-remove-xipc-and-xiph.patch
vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax.patch
ext2-remove-ext2_aops_xip.patch
ext2-get-rid-of-most-mentions-of-xip-in-ext2.patch
dax-add-dax_zero_page_range.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality.patch
brd-rename-xip-to-dax.patch
powerpc-drop-_page_file-and-pte_file-related-helpers.patch

