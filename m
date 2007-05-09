From: akpm@linux-foundation.org
Subject: - cleanup-mostly-unused-iospace-macros.patch removed from -mm tree
Date: Tue, 08 May 2007 19:51:21 -0700
Message-ID: <200705090251.l492pLvq009445@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47700 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032144AbXEICv2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:51:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@gibson.dropbear.id.au, linux-arch@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Clean up mostly unused IOSPACE macros
has been removed from the -mm tree.  Its filename was
     cleanup-mostly-unused-iospace-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Clean up mostly unused IOSPACE macros
From: David Gibson <david@gibson.dropbear.id.au>

Most architectures defined three macros, MK_IOSPACE_PFN(), GET_IOSPACE()
and GET_PFN() in pgtable.h.  However, the only callers of any of these
macros are in Sparc specific code, either in arch/sparc, arch/sparc64 or
drivers/sbus.

This patch removes the redundant macros from all architectures except
sparc and sparc64.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/pgtable.h     |    4 ----
 include/asm-arm/pgtable-nommu.h |    4 ----
 include/asm-arm/pgtable.h       |    4 ----
 include/asm-arm26/pgtable.h     |    4 ----
 include/asm-avr32/pgtable.h     |    4 ----
 include/asm-frv/pgtable.h       |    4 ----
 include/asm-h8300/pgtable.h     |    4 ----
 include/asm-i386/pgtable.h      |    4 ----
 include/asm-ia64/pgtable.h      |    4 ----
 include/asm-m32r/pgtable.h      |    4 ----
 include/asm-m68k/pgtable.h      |    4 ----
 include/asm-m68knommu/pgtable.h |    4 ----
 include/asm-mips/pgtable.h      |    4 ----
 include/asm-parisc/pgtable.h    |    4 ----
 include/asm-ppc/pgtable.h       |    4 ----
 include/asm-sh/pgtable.h        |    4 ----
 include/asm-sh64/pgtable.h      |    4 ----
 include/asm-x86_64/pgtable.h    |    4 ----
 18 files changed, 72 deletions(-)

diff -puN include/asm-alpha/pgtable.h~cleanup-mostly-unused-iospace-macros include/asm-alpha/pgtable.h
--- a/include/asm-alpha/pgtable.h~cleanup-mostly-unused-iospace-macros
+++ a/include/asm-alpha/pgtable.h
@@ -345,10 +345,6 @@ extern inline pte_t mk_swap_pte(unsigned
 #define io_remap_pfn_range(vma, start, pfn, size, prot)	\
 		remap_pfn_range(vma, start, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 #define pte_ERROR(e) \
 	printk("%s:%d: bad pte %016lx.\n", __FILE__, __LINE__, pte_val(e))
 #define pmd_ERROR(e) \
diff -puN include/asm-arm/pgtable-nommu.h~cleanup-mostly-unused-iospace-macros include/asm-arm/pgtable-nommu.h
--- a/include/asm-arm/pgtable-nommu.h~cleanup-mostly-unused-iospace-macros
+++ a/include/asm-arm/pgtable-nommu.h
@@ -83,10 +83,6 @@ extern int is_in_rom(unsigned long);
 #define io_remap_page_range	remap_page_range
 #define io_remap_pfn_range	remap_pfn_range
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 
 /*
  * All 32bit addresses are effectively valid for vmalloc...
diff -puN include/asm-arm/pgtable.h~cleanup-mostly-unused-iospace-macros include/asm-arm/pgtable.h
--- a/include/asm-arm/pgtable.h~cleanup-mostly-unused-iospace-macros
+++ a/include/asm-arm/pgtable.h
@@ -395,10 +395,6 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD
 #define io_remap_pfn_range(vma,from,pfn,size,prot) \
 		remap_pfn_range(vma, from, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 #define pgtable_cache_init() do { } while (0)
 
 #endif /* !__ASSEMBLY__ */
diff -puN include/asm-arm26/pgtable.h~cleanup-mostly-unused-iospace-macros include/asm-arm26/pgtable.h
--- a/include/asm-arm26/pgtable.h~cleanup-mostly-unused-iospace-macros
+++ a/include/asm-arm26/pgtable.h
@@ -297,10 +297,6 @@ static inline pte_t mk_pte_phys(unsigned
 #define io_remap_pfn_range(vma,from,pfn,size,prot) \
 		remap_pfn_range(vma, from, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASMARM_PGTABLE_H */
diff -puN include/asm-avr32/pgtable.h~cleanup-mostly-unused-iospace-macros include/asm-avr32/pgtable.h
--- a/include/asm-avr32/pgtable.h~cleanup-mostly-unused-iospace-macros
+++ a/include/asm-avr32/pgtable.h
@@ -394,10 +394,6 @@ typedef pte_t *pte_addr_t;
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)	\
 	remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 /* No page table caches to initialize (?) */
 #define pgtable_cache_init()	do { } while(0)
 
diff -puN include/asm-frv/pgtable.h~cleanup-mostly-unused-iospace-macros include/asm-frv/pgtable.h
--- a/include/asm-frv/pgtable.h~cleanup-mostly-unused-iospace-macros
+++ a/include/asm-frv/pgtable.h
@@ -509,10 +509,6 @@ static inline int pte_file(pte_t pte)
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
diff -puN include/asm-h8300/pgtable.h~cleanup-mostly-unused-iospace-macros include/asm-h8300/pgtable.h
--- a/include/asm-h8300/pgtable.h~cleanup-mostly-unused-iospace-macros
+++ a/include/asm-h8300/pgtable.h
@@ -55,10 +55,6 @@ extern int is_in_rom(unsigned long);
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 /*
  * All 32bit addresses are effectively valid for vmalloc...
  * Sort of meaningless for non-VM targets.
diff -puN include/asm-i386/pgtable.h~cleanup-mostly-unused-iospace-macros include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~cleanup-mostly-unused-iospace-macros
+++ a/include/asm-i386/pgtable.h
@@ -542,10 +542,6 @@ static inline void paravirt_pagetable_se
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 #include <asm-generic/pgtable.h>
 
 #endif /* _I386_PGTABLE_H */
diff -puN include/asm-ia64/pgtable.h~cleanup-mostly-unused-iospace-macros include/asm-ia64/pgtable.h
--- a/include/asm-ia64/pgtable.h~cleanup-mostly-unused-iospace-macros
+++ a/include/asm-ia64/pgtable.h
@@ -485,10 +485,6 @@ extern void paging_init (void);
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 /*
  * ZERO_PAGE is a global shared page that is always zero: used
  * for zero-mapped memory areas etc..
diff -puN include/asm-m32r/pgtable.h~cleanup-mostly-unused-iospace-macros include/asm-m32r/pgtable.h
--- a/include/asm-m32r/pgtable.h~cleanup-mostly-unused-iospace-macros
+++ a/include/asm-m32r/pgtable.h
@@ -381,10 +381,6 @@ static inline void pmd_set(pmd_t * pmdp,
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)	\
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
diff -puN include/asm-m68k/pgtable.h~cleanup-mostly-unused-iospace-macros include/asm-m68k/pgtable.h
--- a/include/asm-m68k/pgtable.h~cleanup-mostly-unused-iospace-macros
+++ a/include/asm-m68k/pgtable.h
@@ -143,10 +143,6 @@ static inline void update_mmu_cache(stru
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 /* MMU-specific headers */
 
 #ifdef CONFIG_SUN3
diff -puN include/asm-m68knommu/pgtable.h~cleanup-mostly-unused-iospace-macros include/asm-m68knommu/pgtable.h
--- a/include/asm-m68knommu/pgtable.h~cleanup-mostly-unused-iospace-macros
+++ a/include/asm-m68knommu/pgtable.h
@@ -59,10 +59,6 @@ extern int is_in_rom(unsigned long);
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 /*
  * All 32bit addresses are effectively valid for vmalloc...
  * Sort of meaningless for non-VM targets.
diff -puN include/asm-mips/pgtable.h~cleanup-mostly-unused-iospace-macros include/asm-mips/pgtable.h
--- a/include/asm-mips/pgtable.h~cleanup-mostly-unused-iospace-macros
+++ a/include/asm-mips/pgtable.h
@@ -387,10 +387,6 @@ static inline int io_remap_pfn_range(str
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 #endif
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 #include <asm-generic/pgtable.h>
 
 /*
diff -puN include/asm-parisc/pgtable.h~cleanup-mostly-unused-iospace-macros include/asm-parisc/pgtable.h
--- a/include/asm-parisc/pgtable.h~cleanup-mostly-unused-iospace-macros
+++ a/include/asm-parisc/pgtable.h
@@ -528,10 +528,6 @@ static inline void ptep_set_wrprotect(st
 
 #define pgprot_noncached(prot) __pgprot(pgprot_val(prot) | _PAGE_NO_CACHE)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 /* We provide our own get_unmapped_area to provide cache coherency */
 
 #define HAVE_ARCH_UNMAPPED_AREA
diff -puN include/asm-ppc/pgtable.h~cleanup-mostly-unused-iospace-macros include/asm-ppc/pgtable.h
--- a/include/asm-ppc/pgtable.h~cleanup-mostly-unused-iospace-macros
+++ a/include/asm-ppc/pgtable.h
@@ -827,10 +827,6 @@ static inline int io_remap_pfn_range(str
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 #endif
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 /*
  * No page table caches to initialise
  */
diff -puN include/asm-sh/pgtable.h~cleanup-mostly-unused-iospace-macros include/asm-sh/pgtable.h
--- a/include/asm-sh/pgtable.h~cleanup-mostly-unused-iospace-macros
+++ a/include/asm-sh/pgtable.h
@@ -568,10 +568,6 @@ typedef pte_t *pte_addr_t;
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 struct mm_struct;
 
 /*
diff -puN include/asm-sh64/pgtable.h~cleanup-mostly-unused-iospace-macros include/asm-sh64/pgtable.h
--- a/include/asm-sh64/pgtable.h~cleanup-mostly-unused-iospace-macros
+++ a/include/asm-sh64/pgtable.h
@@ -485,10 +485,6 @@ extern void update_mmu_cache(struct vm_a
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 #endif /* !__ASSEMBLY__ */
 
 /*
diff -puN include/asm-x86_64/pgtable.h~cleanup-mostly-unused-iospace-macros include/asm-x86_64/pgtable.h
--- a/include/asm-x86_64/pgtable.h~cleanup-mostly-unused-iospace-macros
+++ a/include/asm-x86_64/pgtable.h
@@ -417,10 +417,6 @@ extern int kern_addr_valid(unsigned long
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#define MK_IOSPACE_PFN(space, pfn)	(pfn)
-#define GET_IOSPACE(pfn)		0
-#define GET_PFN(pfn)			(pfn)
-
 #define HAVE_ARCH_UNMAPPED_AREA
 
 #define pgtable_cache_init()   do { } while (0)
_

Patches currently in -mm which might be from david@gibson.dropbear.id.au are

origin.patch
fix-leaky-resv_huge_pages-when-cpuset-is-in-use.patch
