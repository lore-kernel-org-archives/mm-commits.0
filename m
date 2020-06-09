From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-consolidate-pmd_index-and-pmd_offset-definitions.patch removed from -mm
 tree
Date: Mon, 08 Jun 2020 20:13:51 -0700
Message-ID: <20200609031351.0zS-XujKe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgFIDNy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 23:13:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, bcain@codeaurora.org, bp@alien8.de, catalin.marinas@arm.com, chris@zankel.net, dalias@libc.org, davem@davemloft.net, deanbo422@gmail.com, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, mattst88@gmail.com, mingo@redhat.com, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@linux.ibm.com, shorne@gmail.com, tglx@linutronix.de, tony.luck@intel.com, tsbogend@alpha.franken.de, vgupta@synopsys.com, will@kernel.org, willy@infradead.org, ysato@users.sourceforge.jp


The patch titled
     Subject: mm: consolidate pmd_index() and pmd_offset() definitions
has been removed from the -mm tree.  Its filename was
     mm-consolidate-pmd_index-and-pmd_offset-definitions.patch

This patch was dropped because it was folded into mm-consolidate-pte_index-and-pte_offset_-definitions.patch

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: consolidate pmd_index() and pmd_offset() definitions

All architectures define pmd_index() as

	(address >> PMD_SHIFT) & (PTRS_PER_PMD - 1)

and all architectures that have at least three-level page tables define
pmd_offset() as an entry in the array of PMDs indexed by the pmd_index().

For the most architectures the pmd_offset() implementation relies on the
availability of pud_page_vaddr() that converts a PMD entry value to the
virtual address of the page containing PMD array.

Let's use such implementation as a generic and drop most of the
definitions of pmd_index() and pmd_offset() in <asm/pgtable.h> files.

The architectures that didn't provide pud_page_vaddr() are updated to have
that defined.

The generic implementation can be overridden by an architecture and this
ability is currently in use by there architectures:
* alpha has special requirements for memory access ordering
* arm has custom definition of folded 2-level page tables
* s390 has custom definitions of all page table accessors

Link: http://lkml.kernel.org/r/20200514170327.31389-11-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/pgtable.h             |    1 
 arch/arm/include/asm/pgtable-2level.h        |    1 
 arch/arm/include/asm/pgtable-3level.h        |    7 ----
 arch/arm/include/asm/pgtable-nommu.h         |    1 
 arch/arm64/include/asm/pgtable.h             |    8 ++--
 arch/c6x/include/asm/pgtable.h               |    1 
 arch/csky/include/asm/pgtable.h              |    1 
 arch/hexagon/include/asm/pgtable.h           |    9 -----
 arch/ia64/include/asm/pgtable.h              |    4 --
 arch/m68k/include/asm/motorola_pgtable.h     |    7 ----
 arch/microblaze/include/asm/pgtable.h        |    1 
 arch/mips/include/asm/pgtable-32.h           |    1 
 arch/mips/include/asm/pgtable-64.h           |    6 ---
 arch/parisc/include/asm/pgtable.h            |    8 ----
 arch/parisc/kernel/pci-dma.c                 |    2 -
 arch/powerpc/include/asm/book3s/64/pgtable.h |    7 ----
 arch/powerpc/include/asm/nohash/64/pgtable.h |    3 -
 arch/riscv/include/asm/pgtable-64.h          |    7 ----
 arch/riscv/mm/init.c                         |   12 +++----
 arch/s390/include/asm/pgtable.h              |    1 
 arch/sh/include/asm/pgtable-3level.h         |    7 ----
 arch/sh/include/asm/pgtable_32.h             |    1 
 arch/sparc/include/asm/pgtable_32.h          |    9 -----
 arch/sparc/include/asm/pgtable_64.h          |    7 ----
 arch/um/include/asm/pgtable-3level.h         |    4 --
 arch/um/include/asm/pgtable.h                |    4 --
 arch/x86/include/asm/pgtable.h               |   17 ---------
 include/asm-generic/pgtable-nopmd.h          |    1 
 include/linux/pgtable.h                      |   29 +++++++++++++++--
 29 files changed, 44 insertions(+), 123 deletions(-)

--- a/arch/alpha/include/asm/pgtable.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/alpha/include/asm/pgtable.h
@@ -305,6 +305,7 @@ extern inline pmd_t * pmd_offset(pud_t *
 	smp_read_barrier_depends(); /* see above */
 	return ret;
 }
+#define pmd_offset pmd_offset
 
 /* Find an entry in the third-level page table.. */
 extern inline pte_t * pte_offset_kernel(pmd_t * dir, unsigned long address)
--- a/arch/arm64/include/asm/pgtable.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/arm64/include/asm/pgtable.h
@@ -566,11 +566,13 @@ static inline phys_addr_t pud_page_paddr
 	return __pud_to_phys(pud);
 }
 
-/* Find an entry in the second-level page table. */
-#define pmd_index(addr)		(((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
+static inline unsigned long pud_page_vaddr(pud_t pud)
+{
+	return (unsigned long)__va(pud_page_paddr(pud));
+}
 
+/* Find an entry in the second-level page table. */
 #define pmd_offset_phys(dir, addr)	(pud_page_paddr(READ_ONCE(*(dir))) + pmd_index(addr) * sizeof(pmd_t))
-#define pmd_offset(dir, addr)		((pmd_t *)__va(pmd_offset_phys((dir), (addr))))
 
 #define pmd_set_fixmap(addr)		((pmd_t *)set_fixmap_offset(FIX_PMD, addr))
 #define pmd_set_fixmap_offset(pud, addr)	pmd_set_fixmap(pmd_offset_phys(pud, addr))
--- a/arch/arm/include/asm/pgtable-2level.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/arm/include/asm/pgtable-2level.h
@@ -187,6 +187,7 @@ static inline pmd_t *pmd_offset(pud_t *p
 {
 	return (pmd_t *)pud;
 }
+#define pmd_offset pmd_offset
 
 #define pmd_large(pmd)		(pmd_val(pmd) & 2)
 #define pmd_leaf(pmd)		(pmd_val(pmd) & 2)
--- a/arch/arm/include/asm/pgtable-3level.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -133,13 +133,6 @@ static inline pmd_t *pud_page_vaddr(pud_
 	return __va(pud_val(pud) & PHYS_MASK & (s32)PAGE_MASK);
 }
 
-/* Find an entry in the second-level page table.. */
-#define pmd_index(addr)		(((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
-static inline pmd_t *pmd_offset(pud_t *pud, unsigned long addr)
-{
-	return (pmd_t *)pud_page_vaddr(*pud) + pmd_index(addr);
-}
-
 #define pmd_bad(pmd)		(!(pmd_val(pmd) & 2))
 
 #define copy_pmd(pmdpd,pmdps)		\
--- a/arch/arm/include/asm/pgtable-nommu.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/arm/include/asm/pgtable-nommu.h
@@ -22,7 +22,6 @@
 #define pgd_bad(pgd)		(0)
 #define pgd_clear(pgdp)
 #define kern_addr_valid(addr)	(1)
-#define	pmd_offset(a, b)	((void *)0)
 /* FIXME */
 /*
  * PMD_SHIFT determines the size of the area a second-level page table can map
--- a/arch/c6x/include/asm/pgtable.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/c6x/include/asm/pgtable.h
@@ -26,7 +26,6 @@
 #define pgd_clear(pgdp)
 #define kern_addr_valid(addr) (1)
 
-#define pmd_offset(a, b)	((void *)0)
 #define pmd_none(x)		(!pmd_val(x))
 #define pmd_present(x)		(pmd_val(x))
 #define pmd_clear(xp)		do { set_pmd(xp, __pmd(0)); } while (0)
--- a/arch/csky/include/asm/pgtable.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/csky/include/asm/pgtable.h
@@ -221,7 +221,6 @@ static inline pte_t pte_mkyoung(pte_t pt
 }
 
 #define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
-#define pmd_index(address)	(((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
 
 /* to find an entry in a kernel page-table-directory */
 #define pgd_offset_k(address)	pgd_offset(&init_mm, address)
--- a/arch/hexagon/include/asm/pgtable.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/hexagon/include/asm/pgtable.h
@@ -206,15 +206,6 @@ static inline void pte_clear(struct mm_s
 	pte_val(*ptep) = _NULL_PTE;
 }
 
-#ifdef NEED_PMD_INDEX_DESPITE_BEING_2_LEVEL
-/**
- * pmd_index - returns the index of the entry in the PMD page
- * which would control the given virtual address
- */
-#define pmd_index(address) (((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
-
-#endif
-
 /**
  * pgd_index - returns the index of the entry in the PGD page
  * which would control the given virtual address
--- a/arch/ia64/include/asm/pgtable.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/ia64/include/asm/pgtable.h
@@ -389,10 +389,6 @@ pgd_offset (const struct mm_struct *mm,
 	((pud_t *) p4d_page_vaddr(*(dir)) + (((addr) >> PUD_SHIFT) & (PTRS_PER_PUD - 1)))
 #endif
 
-/* Find an entry in the third-level page table.. */
-#define pmd_offset(dir,addr) \
-	((pmd_t *) pud_page_vaddr(*(dir)) + (((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1)))
-
 /* atomic versions of the some PTE manipulations: */
 
 static inline int
--- a/arch/m68k/include/asm/motorola_pgtable.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/m68k/include/asm/motorola_pgtable.h
@@ -211,13 +211,6 @@ static inline pgd_t *pgd_offset_k(unsign
 	return kernel_pg_dir + (address >> PGDIR_SHIFT);
 }
 
-
-/* Find an entry in the second-level page table.. */
-static inline pmd_t *pmd_offset(pud_t *dir, unsigned long address)
-{
-	return (pmd_t *)pud_page_vaddr(*dir) + ((address >> PMD_SHIFT) & (PTRS_PER_PMD-1));
-}
-
 /* Encode and de-code a swap entry (must be !pte_none(e) && !pte_present(e)) */
 #define __swp_type(x)		(((x).val >> 4) & 0xff)
 #define __swp_offset(x)		((x).val >> 12)
--- a/arch/microblaze/include/asm/pgtable.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/microblaze/include/asm/pgtable.h
@@ -21,7 +21,6 @@ extern int mem_init_done;
 #define pgd_bad(pgd)		(0)
 #define pgd_clear(pgdp)
 #define kern_addr_valid(addr)	(1)
-#define	pmd_offset(a, b)	((void *) 0)
 
 #define PAGE_NONE		__pgprot(0) /* these mean nothing to non MMU */
 #define PAGE_SHARED		__pgprot(0) /* these mean nothing to non MMU */
--- a/arch/mips/include/asm/pgtable-32.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/mips/include/asm/pgtable-32.h
@@ -200,7 +200,6 @@ static inline pte_t pfn_pte(unsigned lon
 
 #define pgd_index(address)	(((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
 #define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
-#define pmd_index(address)	(((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
 
 /* to find an entry in a page-table-directory */
 #define pgd_offset(mm, addr)	((mm)->pgd + pgd_index(addr))
--- a/arch/mips/include/asm/pgtable-64.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/mips/include/asm/pgtable-64.h
@@ -324,7 +324,6 @@ static inline void pud_clear(pud_t *pudp
 #define pgd_offset_k(address) pgd_offset(&init_mm, address)
 
 #define pgd_index(address)	(((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
-#define pmd_index(address)	(((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
 
 /* to find an entry in a page-table-directory */
 #define pgd_offset(mm, addr)	((mm)->pgd + pgd_index(addr))
@@ -337,11 +336,6 @@ static inline unsigned long pud_page_vad
 #define pud_phys(pud)		virt_to_phys((void *)pud_val(pud))
 #define pud_page(pud)		(pfn_to_page(pud_phys(pud) >> PAGE_SHIFT))
 
-/* Find an entry in the second-level page table.. */
-static inline pmd_t *pmd_offset(pud_t * pud, unsigned long address)
-{
-	return (pmd_t *) pud_page_vaddr(*pud) + pmd_index(address);
-}
 #endif
 
 /*
--- a/arch/parisc/include/asm/pgtable.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/parisc/include/asm/pgtable.h
@@ -446,14 +446,6 @@ static inline unsigned long pmd_page_vad
 
 /* Find an entry in the second-level page table.. */
 
-#if CONFIG_PGTABLE_LEVELS == 3
-#define pmd_index(addr)         (((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
-#define pmd_offset(dir,address) \
-((pmd_t *) pud_page_vaddr(*(dir)) + pmd_index(address))
-#else
-#define pmd_offset(dir,addr) ((pmd_t *) dir)
-#endif
-
 extern void paging_init (void);
 
 /* Used for deferring calls to flush_dcache_page() */
--- a/arch/parisc/kernel/pci-dma.c~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/parisc/kernel/pci-dma.c
@@ -201,7 +201,7 @@ static inline void unmap_uncached_pmd(pg
 		pgd_clear(dir);
 		return;
 	}
-	pmd = pmd_offset(dir, vaddr);
+	pmd = pmd_offset(pud_offset(p4d_offset(dir, vaddr), vaddr), vaddr);
 	vaddr &= ~PGDIR_MASK;
 	end = vaddr + size;
 	if (end > PGDIR_SIZE)
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1018,11 +1018,6 @@ static inline unsigned long pud_index(un
 	return (address >> PUD_SHIFT) & (PTRS_PER_PUD - 1);
 }
 
-static inline unsigned long pmd_index(unsigned long address)
-{
-	return (address >> PMD_SHIFT) & (PTRS_PER_PMD - 1);
-}
-
 /*
  * Find an entry in a page-table-directory.  We combine the address region
  * (the high order N bits) and the pgd portion of the address.
@@ -1032,8 +1027,6 @@ static inline unsigned long pmd_index(un
 
 #define pud_offset(p4dp, addr)	\
 	(((pud_t *) p4d_page_vaddr(*(p4dp))) + pud_index(addr))
-#define pmd_offset(pudp,addr) \
-	(((pmd_t *) pud_page_vaddr(*(pudp))) + pmd_index(addr))
 
 /* to find an entry in a kernel page-table-directory */
 /* This now only contains the vmalloc pages */
--- a/arch/powerpc/include/asm/nohash/64/pgtable.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/powerpc/include/asm/nohash/64/pgtable.h
@@ -190,9 +190,6 @@ static inline void p4d_set(p4d_t *p4dp,
 
 #define pgd_offset(mm, address)	 ((mm)->pgd + pgd_index(address))
 
-#define pmd_offset(pudp,addr) \
-  (((pmd_t *) pud_page_vaddr(*(pudp))) + (((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1)))
-
 /* to find an entry in a kernel page-table-directory */
 /* This now only contains the vmalloc pages */
 #define pgd_offset_k(address) pgd_offset(&init_mm, address)
--- a/arch/riscv/include/asm/pgtable-64.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/riscv/include/asm/pgtable-64.h
@@ -70,13 +70,6 @@ static inline struct page *pud_page(pud_
 	return pfn_to_page(pud_val(pud) >> _PAGE_PFN_SHIFT);
 }
 
-#define pmd_index(addr) (((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
-
-static inline pmd_t *pmd_offset(pud_t *pud, unsigned long addr)
-{
-	return (pmd_t *)pud_page_vaddr(*pud) + pmd_index(addr);
-}
-
 static inline pmd_t pfn_pmd(unsigned long pfn, pgprot_t prot)
 {
 	return __pmd((pfn << _PAGE_PFN_SHIFT) | pgprot_val(prot));
--- a/arch/riscv/mm/init.c~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/riscv/mm/init.c
@@ -283,21 +283,21 @@ static void __init create_pmd_mapping(pm
 {
 	pte_t *ptep;
 	phys_addr_t pte_phys;
-	uintptr_t pmd_index = pmd_index(va);
+	uintptr_t pmd_idx = pmd_index(va);
 
 	if (sz == PMD_SIZE) {
-		if (pmd_none(pmdp[pmd_index]))
-			pmdp[pmd_index] = pfn_pmd(PFN_DOWN(pa), prot);
+		if (pmd_none(pmdp[pmd_idx]))
+			pmdp[pmd_idx] = pfn_pmd(PFN_DOWN(pa), prot);
 		return;
 	}
 
-	if (pmd_none(pmdp[pmd_index])) {
+	if (pmd_none(pmdp[pmd_idx])) {
 		pte_phys = alloc_pte(va);
-		pmdp[pmd_index] = pfn_pmd(PFN_DOWN(pte_phys), PAGE_TABLE);
+		pmdp[pmd_idx] = pfn_pmd(PFN_DOWN(pte_phys), PAGE_TABLE);
 		ptep = get_pte_virt(pte_phys);
 		memset(ptep, 0, PAGE_SIZE);
 	} else {
-		pte_phys = PFN_PHYS(_pmd_pfn(pmdp[pmd_index]));
+		pte_phys = PFN_PHYS(_pmd_pfn(pmdp[pmd_idx]));
 		ptep = get_pte_virt(pte_phys);
 	}
 
--- a/arch/s390/include/asm/pgtable.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/s390/include/asm/pgtable.h
@@ -1281,6 +1281,7 @@ static inline pmd_t *pmd_offset(pud_t *p
 		return (pmd_t *) pud_deref(*pud) + pmd_index(address);
 	return (pmd_t *) pud;
 }
+#define pmd_offset pmd_offset
 
 static inline unsigned long pmd_page_vaddr(pmd_t pmd)
 {
--- a/arch/sh/include/asm/pgtable_32.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/sh/include/asm/pgtable_32.h
@@ -416,7 +416,6 @@ static inline unsigned long pmd_page_vad
 #define pgd_offset_k(address)	pgd_offset(&init_mm, address)
 
 #define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
-#define pmd_index(address)	(((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
 
 #ifdef CONFIG_X2TLB
 #define pte_ERROR(e) \
--- a/arch/sh/include/asm/pgtable-3level.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/sh/include/asm/pgtable-3level.h
@@ -39,13 +39,6 @@ static inline unsigned long pud_page_vad
 
 /* only used by the stubbed out hugetlb gup code, should never be called */
 #define pud_page(pud)		NULL
-
-#define pmd_index(address)	(((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
-static inline pmd_t *pmd_offset(pud_t *pud, unsigned long address)
-{
-	return (pmd_t *)pud_page_vaddr(*pud) + pmd_index(address);
-}
-
 #define pud_none(x)	(!pud_val(x))
 #define pud_present(x)	(pud_val(x))
 #define pud_clear(xp)	do { set_pud(xp, __pud(0)); } while (0)
--- a/arch/sparc/include/asm/pgtable_32.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/sparc/include/asm/pgtable_32.h
@@ -329,13 +329,6 @@ static inline pte_t pte_modify(pte_t pte
 /* to find an entry in a kernel page-table-directory */
 #define pgd_offset_k(address) pgd_offset(&init_mm, address)
 
-/* Find an entry in the second-level page table.. */
-static inline pmd_t *pmd_offset(pud_t * dir, unsigned long address)
-{
-	return (pmd_t *) pud_page_vaddr(*dir) +
-		((address >> PMD_SHIFT) & (PTRS_PER_PMD - 1));
-}
-
 struct seq_file;
 void mmu_info(struct seq_file *m);
 
@@ -424,7 +417,7 @@ static inline int io_remap_pfn_range(str
 
 	return remap_pfn_range(vma, from, phys_base >> PAGE_SHIFT, size, prot);
 }
-#define io_remap_pfn_range io_remap_pfn_range 
+#define io_remap_pfn_range io_remap_pfn_range
 
 #define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 #define ptep_set_access_flags(__vma, __address, __ptep, __entry, __dirty) \
--- a/arch/sparc/include/asm/pgtable_64.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -901,11 +901,6 @@ static inline unsigned long pud_pfn(pud_
 #define pud_offset(p4dp, address)	\
 	((pud_t *) p4d_page_vaddr(*(p4dp)) + pud_index(address))
 
-/* Find an entry in the second-level page table.. */
-#define pmd_offset(pudp, address)	\
-	((pmd_t *) pud_page_vaddr(*(pudp)) + \
-	 (((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1)))
-
 /* We cannot include <linux/mm_types.h> at this point yet: */
 extern struct mm_struct init_mm;
 
@@ -1070,7 +1065,7 @@ static inline int io_remap_pfn_range(str
 
 	return remap_pfn_range(vma, from, phys_base >> PAGE_SHIFT, size, prot);
 }
-#define io_remap_pfn_range io_remap_pfn_range 
+#define io_remap_pfn_range io_remap_pfn_range
 
 static inline unsigned long __untagged_addr(unsigned long start)
 {
--- a/arch/um/include/asm/pgtable-3level.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/um/include/asm/pgtable-3level.h
@@ -89,10 +89,6 @@ static inline void pud_clear (pud_t *pud
 #define pud_page(pud) phys_to_page(pud_val(pud) & PAGE_MASK)
 #define pud_page_vaddr(pud) ((unsigned long) __va(pud_val(pud) & PAGE_MASK))
 
-/* Find an entry in the second-level page table.. */
-#define pmd_offset(pud, address) ((pmd_t *) pud_page_vaddr(*(pud)) + \
-			pmd_index(address))
-
 static inline unsigned long pte_pfn(pte_t pte)
 {
 	return phys_to_pfn(pte_val(pte));
--- a/arch/um/include/asm/pgtable.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/um/include/asm/pgtable.h
@@ -318,10 +318,6 @@ static inline pte_t pte_modify(pte_t pte
  * control the given virtual address
  */
 #define pmd_page_vaddr(pmd) ((unsigned long) __va(pmd_val(pmd) & PAGE_MASK))
-#define pmd_index(address) (((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
-
-#define pmd_page_vaddr(pmd) \
-	((unsigned long) __va(pmd_val(pmd) & PAGE_MASK))
 
 struct mm_struct;
 extern pte_t *virt_to_pte(struct mm_struct *mm, unsigned long addr);
--- a/arch/x86/include/asm/pgtable.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/arch/x86/include/asm/pgtable.h
@@ -837,17 +837,6 @@ static inline unsigned long pmd_page_vad
 #define pmd_page(pmd)	pfn_to_page(pmd_pfn(pmd))
 
 /*
- * the pmd page can be thought of an array like this: pmd_t[PTRS_PER_PMD]
- *
- * this macro returns the index of the entry in the pmd page which would
- * control the given virtual address
- */
-static inline unsigned long pmd_index(unsigned long address)
-{
-	return (address >> PMD_SHIFT) & (PTRS_PER_PMD - 1);
-}
-
-/*
  * Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
  *
@@ -888,12 +877,6 @@ static inline unsigned long pud_page_vad
  */
 #define pud_page(pud)	pfn_to_page(pud_pfn(pud))
 
-/* Find an entry in the second-level page table.. */
-static inline pmd_t *pmd_offset(pud_t *pud, unsigned long address)
-{
-	return (pmd_t *)pud_page_vaddr(*pud) + pmd_index(address);
-}
-
 #define pud_leaf	pud_large
 static inline int pud_large(pud_t pud)
 {
--- a/include/asm-generic/pgtable-nopmd.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/include/asm-generic/pgtable-nopmd.h
@@ -45,6 +45,7 @@ static inline pmd_t * pmd_offset(pud_t *
 {
 	return (pmd_t *)pud;
 }
+#define pmd_offset pmd_offset
 
 #define pmd_val(x)				(pud_val((x).pud))
 #define __pmd(x)				((pmd_t) { __pud(x) } )
--- a/include/linux/pgtable.h~mm-consolidate-pmd_index-and-pmd_offset-definitions
+++ a/include/linux/pgtable.h
@@ -29,16 +29,30 @@
 #endif
 
 /*
- * the pte page can be thought of an array like this: pte_t[PTRS_PER_PTE]
+ * A page table page can be thought of an array like this: pXd_t[PTRS_PER_PxD]
  *
- * this function returns the index of the entry in the pte page which would
- * control the given virtual address
+ * The pXx_index() functions return the index of the entry in the page
+ * table page which would control the given virtual address
+ *
+ * As these functions may be used by the same code for different levels of
+ * the page table folding, they are always available, regardless of
+ * CONFIG_PGTABLE_LEVELS value. For the folded levels they simply return 0
+ * because in such cases PTRS_PER_PxD equals 1.
  */
+
 static inline unsigned long pte_index(unsigned long address)
 {
 	return (address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
 }
 
+#ifndef pmd_index
+static inline unsigned long pmd_index(unsigned long address)
+{
+	return (address >> PMD_SHIFT) & (PTRS_PER_PMD - 1);
+}
+#define pmd_index pmd_index
+#endif
+
 #ifndef pte_offset_kernel
 static inline pte_t *pte_offset_kernel(pmd_t *pmd, unsigned long address)
 {
@@ -57,6 +71,15 @@ static inline pte_t *pte_offset_kernel(p
 #define pte_unmap(pte) ((void)(pte))	/* NOP */
 #endif
 
+/* Find an entry in the second-level page table.. */
+#ifndef pmd_offset
+static inline pmd_t *pmd_offset(pud_t *pud, unsigned long address)
+{
+	return (pmd_t *)pud_page_vaddr(*pud) + pmd_index(address);
+}
+#define pmd_offset pmd_offset
+#endif
+
 /*
  * In many cases it is known that a virtual address is mapped at PMD or PTE
  * level, so instead of traversing all the page table levels, we can get a
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included.patch
mm-introduce-include-linux-pgtableh.patch
mm-reorder-includes-after-introduction-of-linux-pgtableh.patch
csky-replace-definitions-of-__pxd_offset-with-pxd_index.patch
m68k-mm-motorola-move-comment-about-page-table-allocation-funcitons.patch
m68k-mm-move-cachenocahe_page-definitions-close-to-their-user.patch
x86-mm-simplify-init_trampoline-and-surrounding-logic.patch
mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte.patch
mm-consolidate-pte_index-and-pte_offset_-definitions.patch
mm-consolidate-pud_index-and-pud_offset-definitions.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions.patch
