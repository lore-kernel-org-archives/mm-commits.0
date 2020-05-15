From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-consolidate-pte_index-and-pte_offset_-definitions.patch added to -mm
 tree
Date: Fri, 15 May 2020 14:15:51 -0700
Message-ID: <20200515211551.b4sdpehxi%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgEOVPz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 15 May 2020 17:15:55 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, bcain@codeaurora.org, bp@alien8.de, catalin.marinas@arm.com, chris@zankel.net, dalias@libc.org, davem@davemloft.net, deanbo422@gmail.com, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, mattst88@gmail.com, mingo@redhat.com, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@linux.ibm.com, shorne@gmail.com, tglx@linutronix.de, tony.luck@intel.com, tsbogend@alpha.franken.de, vgupta@synopsys.com, will@kernel.org, willy@infradead.org, ysato@users.sourceforge.jp


The patch titled
     Subject: mm: consolidate pte_index() and pte_offset_*() definitions
has been added to the -mm tree.  Its filename is
     mm-consolidate-pte_index-and-pte_offset_-definitions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-consolidate-pte_index-and-pte_offset_-definitions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-consolidate-pte_index-and-pte_offset_-definitions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: consolidate pte_index() and pte_offset_*() definitions

All architectures define pte_index() as

	(address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)

and all architectures define pte_offset_kernel() as an entry in the array
of PTEs indexed by the pte_index().

For the most architectures the pte_offset_kernel() implementation relies
on the availability of pmd_page_vaddr() that converts a PMD entry value to
the virtual address of the page containing PTEs array.

Let's move x86 definitions of the PTE accessors to the generic place in
<linux/pgtable.h> and then simply drop the respective definitions from the
other architectures.

The architectures that didn't provide pmd_page_vaddr() are updated to have
that defined.

The generic implementation of pte_offset_kernel() can be overridden by an
architecture and alpha makes use of this because it has special ordering
requirements for its version of pte_offset_kernel().

Link: http://lkml.kernel.org/r/20200514170327.31389-10-rppt@kernel.org
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

 arch/alpha/include/asm/pgtable.h             |    4 --
 arch/arc/include/asm/pgtable.h               |   15 --------
 arch/arm/include/asm/pgtable.h               |   15 --------
 arch/arm64/include/asm/pgtable.h             |   10 ++---
 arch/csky/include/asm/pgtable.h              |   16 ---------
 arch/hexagon/include/asm/pgtable.h           |   25 ++------------
 arch/ia64/include/asm/pgtable.h              |    9 -----
 arch/m68k/include/asm/mcf_pgtable.h          |   12 -------
 arch/m68k/include/asm/motorola_pgalloc.h     |    2 -
 arch/m68k/include/asm/motorola_pgtable.h     |   11 ------
 arch/m68k/include/asm/sun3_pgtable.h         |   15 +++-----
 arch/m68k/mm/init.c                          |    2 -
 arch/microblaze/include/asm/pgtable.h        |   13 ++-----
 arch/mips/include/asm/pgtable-32.h           |   12 -------
 arch/mips/include/asm/pgtable-64.h           |   11 ------
 arch/mips/kvm/mmu.c                          |   20 +++++------
 arch/mips/kvm/trap_emul.c                    |    2 -
 arch/nds32/include/asm/pgtable.h             |   12 ++-----
 arch/nios2/include/asm/pgtable.h             |   14 ++------
 arch/openrisc/include/asm/pgtable.h          |   23 ++-----------
 arch/parisc/include/asm/pgtable.h            |   15 ++------
 arch/powerpc/include/asm/book3s/32/pgtable.h |   13 +------
 arch/powerpc/include/asm/book3s/64/pgtable.h |    8 ----
 arch/powerpc/include/asm/nohash/32/pgtable.h |   13 +------
 arch/powerpc/include/asm/nohash/64/pgtable.h |    7 ----
 arch/powerpc/include/asm/pgtable.h           |    7 ++++
 arch/riscv/include/asm/pgtable.h             |   10 -----
 arch/riscv/mm/init.c                         |    6 +--
 arch/s390/include/asm/pgtable.h              |   10 +----
 arch/s390/mm/pageattr.c                      |    2 -
 arch/sh/include/asm/pgtable_32.h             |   15 ++------
 arch/sh/include/asm/pgtable_64.h             |   12 -------
 arch/sparc/include/asm/pgalloc_64.h          |    2 -
 arch/sparc/include/asm/pgtable_32.h          |   15 +++-----
 arch/sparc/include/asm/pgtable_64.h          |   12 +------
 arch/sparc/mm/srmmu.c                        |   10 -----
 arch/um/include/asm/pgtable.h                |   13 -------
 arch/unicore32/include/asm/pgtable.h         |    9 -----
 arch/x86/include/asm/pgtable.h               |   19 -----------
 arch/x86/include/asm/pgtable_32.h            |   11 ------
 arch/x86/include/asm/pgtable_64.h            |    4 --
 arch/xtensa/include/asm/pgtable.h            |   10 -----
 include/linux/pgtable.h                      |   29 +++++++++++++++++
 43 files changed, 113 insertions(+), 382 deletions(-)

--- a/arch/alpha/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/alpha/include/asm/pgtable.h
@@ -314,9 +314,7 @@ extern inline pte_t * pte_offset_kernel(
 	smp_read_barrier_depends(); /* see above */
 	return ret;
 }
-
-#define pte_offset_map(dir,addr)	pte_offset_kernel((dir),(addr))
-#define pte_unmap(pte)			do { } while (0)
+#define pte_offset_kernel pte_offset_kernel
 
 extern pgd_t swapper_pg_dir[1024];
 
--- a/arch/arc/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/arc/include/asm/pgtable.h
@@ -248,9 +248,6 @@
 extern char empty_zero_page[PAGE_SIZE];
 #define ZERO_PAGE(vaddr)	(virt_to_page(empty_zero_page))
 
-#define pte_unmap(pte)		do { } while (0)
-#define pte_unmap_nested(pte)		do { } while (0)
-
 #define set_pte(pteptr, pteval)	((*(pteptr)) = (pteval))
 #define set_pmd(pmdptr, pmdval)	(*(pmdptr) = pmdval)
 
@@ -282,18 +279,6 @@ static inline void pmd_set(pmd_t *pmdp,
 
 /* Don't use virt_to_pfn for macros below: could cause truncations for PAE40*/
 #define pte_pfn(pte)		(pte_val(pte) >> PAGE_SHIFT)
-#define __pte_index(addr)	(((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-
-/*
- * pte_offset gets a @ptr to PMD entry (PGD in our 2-tier paging system)
- * and returns ptr to PTE entry corresponding to @addr
- */
-#define pte_offset(dir, addr) ((pte_t *)(pmd_page_vaddr(*dir)) +\
-					 __pte_index(addr))
-
-/* No mapping of Page Tables in high mem etc, so following same as above */
-#define pte_offset_kernel(dir, addr)		pte_offset(dir, addr)
-#define pte_offset_map(dir, addr)		pte_offset(dir, addr)
 
 /* Zoo of pte_xxx function */
 #define pte_read(pte)		(pte_val(pte) & _PAGE_READ)
--- a/arch/arm64/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/arm64/include/asm/pgtable.h
@@ -506,15 +506,13 @@ static inline phys_addr_t pmd_page_paddr
 	return __pmd_to_phys(pmd);
 }
 
-static inline void pte_unmap(pte_t *pte) { }
+static inline unsigned long pmd_page_vaddr(pmd_t pmd)
+{
+	return (unsigned long)__va(pmd_page_paddr(pmd));
+}
 
 /* Find an entry in the third-level page table. */
-#define pte_index(addr)		(((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-
 #define pte_offset_phys(dir,addr)	(pmd_page_paddr(READ_ONCE(*(dir))) + pte_index(addr) * sizeof(pte_t))
-#define pte_offset_kernel(dir,addr)	((pte_t *)__va(pte_offset_phys((dir), (addr))))
-
-#define pte_offset_map(dir,addr)	pte_offset_kernel((dir), (addr))
 
 #define pte_set_fixmap(addr)		((pte_t *)set_fixmap_offset(FIX_PTE, addr))
 #define pte_set_fixmap_offset(pmd, addr)	pte_set_fixmap(pte_offset_phys(pmd, addr))
--- a/arch/arm/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/arm/include/asm/pgtable.h
@@ -183,21 +183,6 @@ static inline pte_t *pmd_page_vaddr(pmd_
 
 #define pmd_page(pmd)		pfn_to_page(__phys_to_pfn(pmd_val(pmd) & PHYS_MASK))
 
-#ifndef CONFIG_HIGHPTE
-#define __pte_map(pmd)		pmd_page_vaddr(*(pmd))
-#define __pte_unmap(pte)	do { } while (0)
-#else
-#define __pte_map(pmd)		(pte_t *)kmap_atomic(pmd_page(*(pmd)))
-#define __pte_unmap(pte)	kunmap_atomic(pte)
-#endif
-
-#define pte_index(addr)		(((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-
-#define pte_offset_kernel(pmd,addr)	(pmd_page_vaddr(*(pmd)) + pte_index(addr))
-
-#define pte_offset_map(pmd,addr)	(__pte_map(pmd) + pte_index(addr))
-#define pte_unmap(pte)			__pte_unmap(pte)
-
 #define pte_pfn(pte)		((pte_val(pte) & PHYS_MASK) >> PAGE_SHIFT)
 #define pfn_pte(pfn,prot)	__pte(__pfn_to_phys(pfn) | pgprot_val(prot))
 
--- a/arch/csky/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/csky/include/asm/pgtable.h
@@ -32,13 +32,6 @@
 #define pgd_ERROR(e) \
 	pr_err("%s:%d: bad pgd %08lx.\n", __FILE__, __LINE__, pgd_val(e))
 
-/* Find an entry in the third-level page table.. */
-#define __pte_offset_t(address) \
-	(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-#define pte_offset_kernel(dir, address) \
-	(pmd_page_vaddr(*(dir)) + __pte_offset_t(address))
-#define pte_offset_map(dir, address) \
-	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset_t(address))
 #define pmd_page(pmd)	(pfn_to_page(pmd_phys(pmd) >> PAGE_SHIFT))
 #define pte_clear(mm, addr, ptep)	set_pte((ptep), \
 	(((unsigned int) addr & PAGE_OFFSET) ? __pte(_PAGE_GLOBAL) : __pte(0)))
@@ -54,8 +47,6 @@
 #define _PAGE_CHG_MASK	(PAGE_MASK | _PAGE_ACCESSED | _PAGE_MODIFIED | \
 			 _CACHE_MASK)
 
-#define pte_unmap(pte)	((void)(pte))
-
 #define __swp_type(x)			(((x).val >> 4) & 0xff)
 #define __swp_offset(x)			((x).val >> 12)
 #define __swp_entry(type, offset)	((swp_entry_t) {((type) << 4) | \
@@ -286,13 +277,6 @@ static inline pgd_t *pgd_offset(struct m
 	return mm->pgd + pgd_index(address);
 }
 
-/* Find an entry in the third-level page table.. */
-static inline pte_t *pte_offset(pmd_t *dir, unsigned long address)
-{
-	return (pte_t *) (pmd_page_vaddr(*dir)) +
-		((address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1));
-}
-
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 extern void paging_init(void);
 
--- a/arch/hexagon/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/hexagon/include/asm/pgtable.h
@@ -403,31 +403,14 @@ static inline int pte_exec(pte_t pte)
  */
 #define set_pte_at(mm, addr, ptep, pte) set_pte(ptep, pte)
 
-/*
- * May need to invoke the virtual machine as well...
- */
-#define pte_unmap(pte)		do { } while (0)
-#define pte_unmap_nested(pte)	do { } while (0)
-
-/*
- * pte_offset_map - returns the linear address of the page table entry
- * corresponding to an address
- */
-#define pte_offset_map(dir, address)                                    \
-	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
-
-#define pte_offset_map_nested(pmd, addr) pte_offset_map(pmd, addr)
-
-/* pte_offset_kernel - kernel version of pte_offset */
-#define pte_offset_kernel(dir, address) \
-	((pte_t *) (unsigned long) __va(pmd_val(*dir) & PAGE_MASK) \
-				+  __pte_offset(address))
+static inline unsigned long pmd_page_vaddr(pmd_t pmd)
+{
+	return (unsigned long)__va(pmd_val(pmd) & PAGE_MASK);
+}
 
 /* ZERO_PAGE - returns the globally shared zero page */
 #define ZERO_PAGE(vaddr) (virt_to_page(&empty_zero_page))
 
-#define __pte_offset(address) (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-
 /*
  * Swap/file PTE definitions.  If _PAGE_PRESENT is zero, the rest of the PTE is
  * interpreted as swap information.  The remaining free bits are interpreted as
--- a/arch/ia64/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/ia64/include/asm/pgtable.h
@@ -393,15 +393,6 @@ pgd_offset (const struct mm_struct *mm,
 #define pmd_offset(dir,addr) \
 	((pmd_t *) pud_page_vaddr(*(dir)) + (((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1)))
 
-/*
- * Find an entry in the third-level page table.  This looks more complicated than it
- * should be because some platforms place page tables in high memory.
- */
-#define pte_index(addr)	 	(((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-#define pte_offset_kernel(dir,addr)	((pte_t *) pmd_page_vaddr(*(dir)) + pte_index(addr))
-#define pte_offset_map(dir,addr)	pte_offset_kernel(dir, addr)
-#define pte_unmap(pte)			do { } while (0)
-
 /* atomic versions of the some PTE manipulations: */
 
 static inline int
--- a/arch/m68k/include/asm/mcf_pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/m68k/include/asm/mcf_pgtable.h
@@ -170,7 +170,7 @@ static inline void pgd_set(pgd_t *pgdp,
 }
 
 #define __pte_page(pte)	((unsigned long) (pte_val(pte) & PAGE_MASK))
-#define __pmd_page(pmd)	((unsigned long) (pmd_val(pmd)))
+#define pmd_page_vaddr(pmd)	((unsigned long) (pmd_val(pmd)))
 
 static inline int pte_none(pte_t pte)
 {
@@ -322,13 +322,6 @@ extern pgd_t kernel_pg_dir[PTRS_PER_PGD]
 #define pgd_offset_k(address)	pgd_offset(&init_mm, address)
 
 /*
- * Find an entry in the third-level pagetable.
- */
-#define __pte_offset(address)	((address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-#define pte_offset_kernel(dir, address) \
-	((pte_t *) __pmd_page(*(dir)) + __pte_offset(address))
-
-/*
  * Encode and de-code a swap entry (must be !pte_none(e) && !pte_present(e))
  */
 #define __swp_type(x)		((x).val & 0xFF)
@@ -340,9 +333,6 @@ extern pgd_t kernel_pg_dir[PTRS_PER_PGD]
 
 #define pmd_page(pmd)		(pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT))
 
-#define pte_offset_map(pmdp, addr) ((pte_t *)__pmd_page(*pmdp) + \
-				       __pte_offset(addr))
-#define pte_unmap(pte)		((void) 0)
 #define pfn_pte(pfn, prot)	__pte(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
 #define pte_pfn(pte)		(pte_val(pte) >> PAGE_SHIFT)
 
--- a/arch/m68k/include/asm/motorola_pgalloc.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/m68k/include/asm/motorola_pgalloc.h
@@ -88,7 +88,7 @@ static inline void pmd_populate(struct m
 {
 	pmd_set(pmd, page);
 }
-#define pmd_pgtable(pmd) ((pgtable_t)__pmd_page(pmd))
+#define pmd_pgtable(pmd) ((pgtable_t)pmd_page_vaddr(pmd))
 
 static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
 {
--- a/arch/m68k/include/asm/motorola_pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/m68k/include/asm/motorola_pgtable.h
@@ -128,7 +128,7 @@ static inline void pud_set(pud_t *pudp,
 }
 
 #define __pte_page(pte) ((unsigned long)__va(pte_val(pte) & PAGE_MASK))
-#define __pmd_page(pmd) ((unsigned long)__va(pmd_val(pmd) & _TABLE_MASK))
+#define pmd_page_vaddr(pmd) ((unsigned long)__va(pmd_val(pmd) & _TABLE_MASK))
 #define pud_page_vaddr(pud) ((unsigned long)__va(pud_val(pud) & _TABLE_MASK))
 
 
@@ -218,15 +218,6 @@ static inline pmd_t *pmd_offset(pud_t *d
 	return (pmd_t *)pud_page_vaddr(*dir) + ((address >> PMD_SHIFT) & (PTRS_PER_PMD-1));
 }
 
-/* Find an entry in the third-level page table.. */
-static inline pte_t *pte_offset_kernel(pmd_t *pmdp, unsigned long address)
-{
-	return (pte_t *)__pmd_page(*pmdp) + ((address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1));
-}
-
-#define pte_offset_map(pmdp,address) ((pte_t *)__pmd_page(*pmdp) + (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)))
-#define pte_unmap(pte)		((void)0)
-
 /* Encode and de-code a swap entry (must be !pte_none(e) && !pte_present(e)) */
 #define __swp_type(x)		(((x).val >> 4) & 0xff)
 #define __swp_offset(x)		((x).val >> 12)
--- a/arch/m68k/include/asm/sun3_pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/m68k/include/asm/sun3_pgtable.h
@@ -112,8 +112,11 @@ static inline pte_t pte_modify(pte_t pte
 
 #define __pte_page(pte) \
 ((unsigned long) __va ((pte_val (pte) & SUN3_PAGE_PGNUM_MASK) << PAGE_SHIFT))
-#define __pmd_page(pmd) \
-((unsigned long) __va (pmd_val (pmd) & PAGE_MASK))
+
+static inline unsigned long pmd_page_vaddr(pmd_t pmd)
+{
+	return (unsigned long)__va(pmd_val(pmd) & PAGE_MASK);
+}
 
 static inline int pte_none (pte_t pte) { return !pte_val (pte); }
 static inline int pte_present (pte_t pte) { return pte_val (pte) & SUN3_PAGE_VALID; }
@@ -127,7 +130,7 @@ static inline void pte_clear (struct mm_
 ({ pte_t __pte; pte_val(__pte) = pfn | pgprot_val(pgprot); __pte; })
 
 #define pte_page(pte)		virt_to_page(__pte_page(pte))
-#define pmd_page(pmd)		virt_to_page(__pmd_page(pmd))
+#define pmd_page(pmd)		virt_to_page(pmd_page_vaddr(pmd))
 
 
 static inline int pmd_none2 (pmd_t *pmd) { return !pmd_val (*pmd); }
@@ -180,12 +183,6 @@ extern pgd_t kernel_pg_dir[PTRS_PER_PGD]
 /* Find an entry in a kernel pagetable directory. */
 #define pgd_offset_k(address) pgd_offset(&init_mm, address)
 
-/* Find an entry in the third-level pagetable. */
-#define pte_index(address) ((address >> PAGE_SHIFT) & (PTRS_PER_PTE-1))
-#define pte_offset_kernel(pmd, address) ((pte_t *) __pmd_page(*pmd) + pte_index(address))
-#define pte_offset_map(pmd, address) ((pte_t *)page_address(pmd_page(*pmd)) + pte_index(address))
-#define pte_unmap(pte) do { } while (0)
-
 /* Macros to (de)construct the fake PTEs representing swap pages. */
 #define __swp_type(x)		((x).val & 0x7F)
 #define __swp_offset(x)		(((x).val) >> 7)
--- a/arch/m68k/mm/init.c~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/m68k/mm/init.c
@@ -141,7 +141,7 @@ static inline void init_pointer_tables(v
 			if (!pmd_present(*pmd))
 				continue;
 
-			pte_dir = (pte_t *)__pmd_page(*pmd);
+			pte_dir = (pte_t *)pmd_page_vaddr(*pmd);
 			init_pointer_table(pte_dir, TABLE_PTE);
 		}
 	}
--- a/arch/microblaze/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/microblaze/include/asm/pgtable.h
@@ -438,7 +438,10 @@ static inline void ptep_mkdirty(struct m
 /* Convert pmd entry to page */
 /* our pmd entry is an effective address of pte table*/
 /* returns effective address of the pmd entry*/
-#define pmd_page_kernel(pmd)	((unsigned long) (pmd_val(pmd) & PAGE_MASK))
+static inline unsigned long pmd_page_vaddr(pmd_t pmd)
+{
+	return ((unsigned long) (pmd_val(pmd) & PAGE_MASK));
+}
 
 /* returns struct *page of the pmd entry*/
 #define pmd_page(pmd)	(pfn_to_page(__pa(pmd_val(pmd)) >> PAGE_SHIFT))
@@ -451,14 +454,6 @@ static inline void ptep_mkdirty(struct m
 #define pgd_offset(mm, address)	 ((mm)->pgd + pgd_index(address))
 
 /* Find an entry in the third-level page table.. */
-#define pte_index(address)		\
-	(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-#define pte_offset_kernel(dir, addr)	\
-	((pte_t *) pmd_page_kernel(*(dir)) + pte_index(addr))
-#define pte_offset_map(dir, addr)		\
-	((pte_t *) kmap_atomic(pmd_page(*(dir))) + pte_index(addr))
-
-#define pte_unmap(pte)		kunmap_atomic(pte)
 
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 
--- a/arch/mips/include/asm/pgtable-32.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/mips/include/asm/pgtable-32.h
@@ -205,18 +205,6 @@ static inline pte_t pfn_pte(unsigned lon
 /* to find an entry in a page-table-directory */
 #define pgd_offset(mm, addr)	((mm)->pgd + pgd_index(addr))
 
-/* Find an entry in the third-level page table.. */
-#define __pte_offset(address)						\
-	(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-#define pte_offset(dir, address)					\
-	((pte_t *) pmd_page_vaddr(*(dir)) + __pte_offset(address))
-#define pte_offset_kernel(dir, address)					\
-	((pte_t *) pmd_page_vaddr(*(dir)) + __pte_offset(address))
-
-#define pte_offset_map(dir, address)					\
-	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
-#define pte_unmap(pte) ((void)(pte))
-
 #if defined(CONFIG_CPU_R3K_TLB)
 
 /* Swap entries must have VALID bit cleared. */
--- a/arch/mips/include/asm/pgtable-64.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/mips/include/asm/pgtable-64.h
@@ -344,17 +344,6 @@ static inline pmd_t *pmd_offset(pud_t *
 }
 #endif
 
-/* Find an entry in the third-level page table.. */
-#define __pte_offset(address)						\
-	(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-#define pte_offset(dir, address)					\
-	((pte_t *) pmd_page_vaddr(*(dir)) + __pte_offset(address))
-#define pte_offset_kernel(dir, address)					\
-	((pte_t *) pmd_page_vaddr(*(dir)) + __pte_offset(address))
-#define pte_offset_map(dir, address)					\
-	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
-#define pte_unmap(pte) ((void)(pte))
-
 /*
  * Initialize a new pgd / pmd table with invalid pointers.
  */
--- a/arch/mips/kvm/mmu.c~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/mips/kvm/mmu.c
@@ -168,7 +168,7 @@ static pte_t *kvm_mips_walk_pgd(pgd_t *p
 		clear_page(new_pte);
 		pmd_populate_kernel(NULL, pmd, new_pte);
 	}
-	return pte_offset(pmd, addr);
+	return pte_offset_kernel(pmd, addr);
 }
 
 /* Caller must hold kvm->mm_lock */
@@ -187,8 +187,8 @@ static pte_t *kvm_mips_pte_for_gpa(struc
 static bool kvm_mips_flush_gpa_pte(pte_t *pte, unsigned long start_gpa,
 				   unsigned long end_gpa)
 {
-	int i_min = __pte_offset(start_gpa);
-	int i_max = __pte_offset(end_gpa);
+	int i_min = pte_index(start_gpa);
+	int i_max = pte_index(end_gpa);
 	bool safe_to_remove = (i_min == 0 && i_max == PTRS_PER_PTE - 1);
 	int i;
 
@@ -215,7 +215,7 @@ static bool kvm_mips_flush_gpa_pmd(pmd_t
 		if (!pmd_present(pmd[i]))
 			continue;
 
-		pte = pte_offset(pmd + i, 0);
+		pte = pte_offset_kernel(pmd + i, 0);
 		if (i == i_max)
 			end = end_gpa;
 
@@ -312,8 +312,8 @@ static int kvm_mips_##name##_pte(pte_t *
 				 unsigned long end)			\
 {									\
 	int ret = 0;							\
-	int i_min = __pte_offset(start);				\
-	int i_max = __pte_offset(end);					\
+	int i_min = pte_index(start);				\
+	int i_max = pte_index(end);					\
 	int i;								\
 	pte_t old, new;							\
 									\
@@ -346,7 +346,7 @@ static int kvm_mips_##name##_pmd(pmd_t *
 		if (!pmd_present(pmd[i]))				\
 			continue;					\
 									\
-		pte = pte_offset(pmd + i, 0);				\
+		pte = pte_offset_kernel(pmd + i, 0);				\
 		if (i == i_max)						\
 			cur_end = end;					\
 									\
@@ -842,8 +842,8 @@ void kvm_trap_emul_invalidate_gva(struct
 static bool kvm_mips_flush_gva_pte(pte_t *pte, unsigned long start_gva,
 				   unsigned long end_gva)
 {
-	int i_min = __pte_offset(start_gva);
-	int i_max = __pte_offset(end_gva);
+	int i_min = pte_index(start_gva);
+	int i_max = pte_index(end_gva);
 	bool safe_to_remove = (i_min == 0 && i_max == PTRS_PER_PTE - 1);
 	int i;
 
@@ -877,7 +877,7 @@ static bool kvm_mips_flush_gva_pmd(pmd_t
 		if (!pmd_present(pmd[i]))
 			continue;
 
-		pte = pte_offset(pmd + i, 0);
+		pte = pte_offset_kernel(pmd + i, 0);
 		if (i == i_max)
 			end = end_gva;
 
--- a/arch/mips/kvm/trap_emul.c~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/mips/kvm/trap_emul.c
@@ -594,7 +594,7 @@ static void kvm_mips_emul_free_gva_pt(pg
 				pmd_va = pud_va | (k << PMD_SHIFT);
 				if (pmd_va >= end)
 					break;
-				pte = pte_offset(pmd + k, 0);
+				pte = pte_offset_kernel(pmd + k, 0);
 				pte_free_kernel(NULL, pte);
 			}
 			pmd_free(NULL, pmd);
--- a/arch/nds32/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/nds32/include/asm/pgtable.h
@@ -186,14 +186,10 @@ extern void paging_init(void);
 #define pte_clear(mm,addr,ptep)	set_pte_at((mm),(addr),(ptep), __pte(0))
 #define pte_page(pte)		(pfn_to_page(pte_pfn(pte)))
 
-#define pte_index(address)                   (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-#define pte_offset_kernel(dir, address)	     ((pte_t *)pmd_page_kernel(*(dir)) + pte_index(address))
-#define pte_offset_map(dir, address)	     ((pte_t *)page_address(pmd_page(*(dir))) + pte_index(address))
-#define pte_offset_map_nested(dir, address)  pte_offset_map(dir, address)
-#define pmd_page_kernel(pmd)	  	     ((unsigned long) __va(pmd_val(pmd) & PAGE_MASK))
-
-#define pte_unmap(pte)		do { } while (0)
-#define pte_unmap_nested(pte)	do { } while (0)
+static unsigned long pmd_page_vaddr(pmd_t pmd)
+{
+	return ((unsigned long) __va(pmd_val(pmd) & PAGE_MASK));
+}
 
 #define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
 /*
--- a/arch/nios2/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/nios2/include/asm/pgtable.h
@@ -236,27 +236,21 @@ static inline void pte_clear(struct mm_s
  */
 #define mk_pte(page, prot)	(pfn_pte(page_to_pfn(page), prot))
 
-#define pte_unmap(pte)	do { } while (0)
-
 /*
  * Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
  */
 #define pmd_phys(pmd)		virt_to_phys((void *)pmd_val(pmd))
 #define pmd_page(pmd)		(pfn_to_page(pmd_phys(pmd) >> PAGE_SHIFT))
-#define pmd_page_vaddr(pmd)	pmd_val(pmd)
 
-#define pte_offset_map(dir, addr)			\
-	((pte_t *) page_address(pmd_page(*dir)) +	\
-	 (((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)))
+static inline unsigned long pmd_page_vaddr(pmd_t pmd)
+{
+	return pmd_val(pmd);
+}
 
 /* to find an entry in a kernel page-table-directory */
 #define pgd_offset_k(addr)	pgd_offset(&init_mm, addr)
 
-/* Get the address to the PTE for a vaddr in specific directory */
-#define pte_offset_kernel(dir, addr)			\
-	((pte_t *) pmd_page_vaddr(*(dir)) +		\
-	 (((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)))
 
 #define pte_ERROR(e) \
 	pr_err("%s:%d: bad pte %08lx.\n", \
--- a/arch/openrisc/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/openrisc/include/asm/pgtable.h
@@ -363,7 +363,11 @@ static inline void pmd_set(pmd_t *pmdp,
 }
 
 #define pmd_page(pmd)		(pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT))
-#define pmd_page_kernel(pmd)    ((unsigned long) __va(pmd_val(pmd) & PAGE_MASK))
+
+static inline unsigned long pmd_page_vaddr(pmd_t pmd)
+{
+	return ((unsigned long) __va(pmd_val(pmd) & PAGE_MASK));
+}
 
 /* to find an entry in a page-table-directory. */
 #define pgd_index(address)      ((address >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
@@ -378,23 +382,6 @@ static inline void pmd_set(pmd_t *pmdp,
 #define __pmd_offset(address) \
 	(((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
 
-/*
- * the pte page can be thought of an array like this: pte_t[PTRS_PER_PTE]
- *
- * this macro returns the index of the entry in the pte page which would
- * control the given virtual address
- */
-#define __pte_offset(address)                   \
-	(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-#define pte_offset_kernel(dir, address)         \
-	((pte_t *) pmd_page_kernel(*(dir)) +  __pte_offset(address))
-#define pte_offset_map(dir, address)	        \
-	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
-#define pte_offset_map_nested(dir, address)     \
-	pte_offset_map(dir, address)
-
-#define pte_unmap(pte)          do { } while (0)
-#define pte_unmap_nested(pte)   do { } while (0)
 #define pte_pfn(x)		((unsigned long)(((x).pte)) >> PAGE_SHIFT)
 #define pfn_pte(pfn, prot)  __pte((((pfn) << PAGE_SHIFT)) | pgprot_val(prot))
 
--- a/arch/parisc/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/parisc/include/asm/pgtable.h
@@ -429,7 +429,10 @@ static inline pte_t pte_modify(pte_t pte
 
 #define pte_page(pte)		(pfn_to_page(pte_pfn(pte)))
 
-#define pmd_page_vaddr(pmd)	((unsigned long) __va(pmd_address(pmd)))
+static inline unsigned long pmd_page_vaddr(pmd_t pmd)
+{
+	return ((unsigned long) __va(pmd_address(pmd)));
+}
 
 #define __pmd_page(pmd) ((unsigned long) __va(pmd_address(pmd)))
 #define pmd_page(pmd)	virt_to_page((void *)__pmd_page(pmd))
@@ -453,16 +456,6 @@ static inline pte_t pte_modify(pte_t pte
 #define pmd_offset(dir,addr) ((pmd_t *) dir)
 #endif
 
-/* Find an entry in the third-level page table.. */ 
-#define pte_index(address) (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE-1))
-#define pte_offset_kernel(pmd, address) \
-	((pte_t *) pmd_page_vaddr(*(pmd)) + pte_index(address))
-#define pte_offset_map(pmd, address) pte_offset_kernel(pmd, address)
-#define pte_unmap(pte) do { } while (0)
-
-#define pte_unmap(pte)			do { } while (0)
-#define pte_unmap_nested(pte)		do { } while (0)
-
 extern void paging_init (void);
 
 /* Used for deferring calls to flush_dcache_page() */
--- a/arch/powerpc/include/asm/book3s/32/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/powerpc/include/asm/book3s/32/pgtable.h
@@ -112,6 +112,9 @@ static inline bool pte_user(pte_t pte)
 #define PMD_TABLE_SIZE	0
 #define PUD_TABLE_SIZE	0
 #define PGD_TABLE_SIZE	(sizeof(pgd_t) << PGD_INDEX_SIZE)
+
+/* Bits to mask out from a PMD to get to the PTE page */
+#define PMD_MASKED_BITS		(PTE_TABLE_SIZE - 1)
 #endif	/* __ASSEMBLY__ */
 
 #define PTRS_PER_PTE	(1 << PTE_INDEX_SIZE)
@@ -348,8 +351,6 @@ static inline void __ptep_set_access_fla
 #define __HAVE_ARCH_PTE_SAME
 #define pte_same(A,B)	(((pte_val(A) ^ pte_val(B)) & ~_PAGE_HASHPTE) == 0)
 
-#define pmd_page_vaddr(pmd)	\
-	((unsigned long)__va(pmd_val(pmd) & ~(PTE_TABLE_SIZE - 1)))
 #define pmd_page(pmd)		\
 	pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT)
 
@@ -360,14 +361,6 @@ static inline void __ptep_set_access_fla
 #define pgd_index(address)	 ((address) >> PGDIR_SHIFT)
 #define pgd_offset(mm, address)	 ((mm)->pgd + pgd_index(address))
 
-/* Find an entry in the third-level page table.. */
-#define pte_index(address)		\
-	(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-#define pte_offset_kernel(dir, addr)	\
-	((pte_t *) pmd_page_vaddr(*(dir)) + pte_index(addr))
-#define pte_offset_map(dir, addr)	pte_offset_kernel((dir), (addr))
-static inline void pte_unmap(pte_t *pte) { }
-
 /*
  * Encode and decode a swap entry.
  * Note that the bits we use in a PTE for representing a swap entry
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1005,14 +1005,12 @@ extern struct page *p4d_page(p4d_t p4d);
 /* Pointers in the page table tree are physical addresses */
 #define __pgtable_ptr_val(ptr)	__pa(ptr)
 
-#define pmd_page_vaddr(pmd)	__va(pmd_val(pmd) & ~PMD_MASKED_BITS)
 #define pud_page_vaddr(pud)	__va(pud_val(pud) & ~PUD_MASKED_BITS)
 #define p4d_page_vaddr(p4d)	__va(p4d_val(p4d) & ~P4D_MASKED_BITS)
 
 #define pgd_index(address) (((address) >> (PGDIR_SHIFT)) & (PTRS_PER_PGD - 1))
 #define pud_index(address) (((address) >> (PUD_SHIFT)) & (PTRS_PER_PUD - 1))
 #define pmd_index(address) (((address) >> (PMD_SHIFT)) & (PTRS_PER_PMD - 1))
-#define pte_index(address) (((address) >> (PAGE_SHIFT)) & (PTRS_PER_PTE - 1))
 
 /*
  * Find an entry in a page-table-directory.  We combine the address region
@@ -1025,12 +1023,6 @@ extern struct page *p4d_page(p4d_t p4d);
 	(((pud_t *) p4d_page_vaddr(*(p4dp))) + pud_index(addr))
 #define pmd_offset(pudp,addr) \
 	(((pmd_t *) pud_page_vaddr(*(pudp))) + pmd_index(addr))
-#define pte_offset_kernel(dir,addr) \
-	(((pte_t *) pmd_page_vaddr(*(dir))) + pte_index(addr))
-
-#define pte_offset_map(dir,addr)	pte_offset_kernel((dir), (addr))
-
-static inline void pte_unmap(pte_t *pte) { }
 
 /* to find an entry in a kernel page-table-directory */
 /* This now only contains the vmalloc pages */
--- a/arch/powerpc/include/asm/nohash/32/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/powerpc/include/asm/nohash/32/pgtable.h
@@ -29,6 +29,8 @@ extern int icache_44x_need_flush;
 #define PMD_TABLE_SIZE	0
 #define PUD_TABLE_SIZE	0
 #define PGD_TABLE_SIZE	(sizeof(pgd_t) << PGD_INDEX_SIZE)
+
+#define PMD_MASKED_BITS (PTE_TABLE_SIZE - 1)
 #endif	/* __ASSEMBLY__ */
 
 #define PTRS_PER_PTE	(1 << PTE_INDEX_SIZE)
@@ -347,8 +349,6 @@ static inline int pte_young(pte_t pte)
  * of the pte page.  -- paulus
  */
 #ifndef CONFIG_BOOKE
-#define pmd_page_vaddr(pmd)	\
-	((unsigned long)__va(pmd_val(pmd) & ~(PTE_TABLE_SIZE - 1)))
 #define pmd_page(pmd)		\
 	pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT)
 #else
@@ -365,15 +365,6 @@ static inline int pte_young(pte_t pte)
 #define pgd_index(address)	 ((address) >> PGDIR_SHIFT)
 #define pgd_offset(mm, address)	 ((mm)->pgd + pgd_index(address))
 
-/* Find an entry in the third-level page table.. */
-#define pte_index(address)		\
-	(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-#define pte_offset_kernel(dir, addr)	\
-	(pmd_bad(*(dir)) ? NULL : (pte_t *)pmd_page_vaddr(*(dir)) + \
-				  pte_index(addr))
-#define pte_offset_map(dir, addr)	pte_offset_kernel((dir), (addr))
-static inline void pte_unmap(pte_t *pte) { }
-
 /*
  * Encode and decode a swap entry.
  * Note that the bits we use in a PTE for representing a swap entry
--- a/arch/powerpc/include/asm/nohash/64/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/powerpc/include/asm/nohash/64/pgtable.h
@@ -193,13 +193,6 @@ static inline void p4d_set(p4d_t *p4dp,
 #define pmd_offset(pudp,addr) \
   (((pmd_t *) pud_page_vaddr(*(pudp))) + (((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1)))
 
-#define pte_offset_kernel(dir,addr) \
-  (((pte_t *) pmd_page_vaddr(*(dir))) + (((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)))
-
-#define pte_offset_map(dir,addr)	pte_offset_kernel((dir), (addr))
-
-static inline void pte_unmap(pte_t *pte) { }
-
 /* to find an entry in a kernel page-table-directory */
 /* This now only contains the vmalloc pages */
 #define pgd_offset_k(address) pgd_offset(&init_mm, address)
--- a/arch/powerpc/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -57,6 +57,13 @@ static inline pgprot_t pte_pgprot(pte_t
 	return __pgprot(pte_flags);
 }
 
+#ifndef pmd_page_vaddr
+static inline unsigned long pmd_page_vaddr(pmd_t pmd)
+{
+	return ((unsigned long)__va(pmd_val(pmd) & ~PMD_MASKED_BITS));
+}
+#define pmd_page_vaddr pmd_page_vaddr
+#endif
 /*
  * ZERO_PAGE is a global shared page that is always zero: used
  * for zero-mapped memory areas etc..
--- a/arch/riscv/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/riscv/include/asm/pgtable.h
@@ -209,16 +209,6 @@ static inline pte_t pfn_pte(unsigned lon
 
 #define mk_pte(page, prot)       pfn_pte(page_to_pfn(page), prot)
 
-#define pte_index(addr) (((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-
-static inline pte_t *pte_offset_kernel(pmd_t *pmd, unsigned long addr)
-{
-	return (pte_t *)pmd_page_vaddr(*pmd) + pte_index(addr);
-}
-
-#define pte_offset_map(dir, addr)	pte_offset_kernel((dir), (addr))
-#define pte_unmap(pte)			((void)(pte))
-
 static inline int pte_present(pte_t pte)
 {
 	return (pte_val(pte) & (_PAGE_PRESENT | _PAGE_PROT_NONE));
--- a/arch/riscv/mm/init.c~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/riscv/mm/init.c
@@ -235,12 +235,12 @@ static void __init create_pte_mapping(pt
 				      uintptr_t va, phys_addr_t pa,
 				      phys_addr_t sz, pgprot_t prot)
 {
-	uintptr_t pte_index = pte_index(va);
+	uintptr_t pte_idx = pte_index(va);
 
 	BUG_ON(sz != PAGE_SIZE);
 
-	if (pte_none(ptep[pte_index]))
-		ptep[pte_index] = pfn_pte(PFN_DOWN(pa), prot);
+	if (pte_none(ptep[pte_idx]))
+		ptep[pte_idx] = pfn_pte(PFN_DOWN(pa), prot);
 }
 
 #ifndef __PAGETABLE_PMD_FOLDED
--- a/arch/s390/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/s390/include/asm/pgtable.h
@@ -1229,7 +1229,6 @@ static inline pte_t mk_pte(struct page *
 #define p4d_index(address) (((address) >> P4D_SHIFT) & (PTRS_PER_P4D-1))
 #define pud_index(address) (((address) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
 #define pmd_index(address) (((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
-#define pte_index(address) (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE-1))
 
 #define pmd_deref(pmd) (pmd_val(pmd) & _SEGMENT_ENTRY_ORIGIN)
 #define pud_deref(pud) (pud_val(pud) & _REGION_ENTRY_ORIGIN)
@@ -1283,16 +1282,11 @@ static inline pmd_t *pmd_offset(pud_t *p
 	return (pmd_t *) pud;
 }
 
-static inline pte_t *pte_offset(pmd_t *pmd, unsigned long address)
+static inline unsigned long pmd_page_vaddr(pmd_t pmd)
 {
-	return (pte_t *) pmd_deref(*pmd) + pte_index(address);
+	return (unsigned long) pmd_deref(pmd);
 }
 
-#define pte_offset_kernel(pmd, address) pte_offset(pmd, address)
-#define pte_offset_map(pmd, address) pte_offset_kernel(pmd, address)
-
-static inline void pte_unmap(pte_t *pte) { }
-
 static inline bool gup_fast_permitted(unsigned long start, unsigned long end)
 {
 	return end <= current->mm->context.asce_limit;
--- a/arch/s390/mm/pageattr.c~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/s390/mm/pageattr.c
@@ -85,7 +85,7 @@ static int walk_pte_level(pmd_t *pmdp, u
 {
 	pte_t *ptep, new;
 
-	ptep = pte_offset(pmdp, addr);
+	ptep = pte_offset_kernel(pmdp, addr);
 	do {
 		new = *ptep;
 		if (pte_none(new))
--- a/arch/sh/include/asm/pgtable_32.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/sh/include/asm/pgtable_32.h
@@ -401,7 +401,11 @@ static inline pte_t pte_modify(pte_t pte
 	return pte;
 }
 
-#define pmd_page_vaddr(pmd)	((unsigned long)pmd_val(pmd))
+static inline unsigned long pmd_page_vaddr(pmd_t pmd)
+{
+	return (unsigned long)pmd_val(pmd);
+}
+
 #define pmd_page(pmd)		(virt_to_page(pmd_val(pmd)))
 
 /* to find an entry in a page-table-directory. */
@@ -414,15 +418,6 @@ static inline pte_t pte_modify(pte_t pte
 #define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
 #define pmd_index(address)	(((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
 
-/* Find an entry in the third-level page table.. */
-#define pte_index(address)	((address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-#define __pte_offset(address)	pte_index(address)
-
-#define pte_offset_kernel(dir, address) \
-	((pte_t *) pmd_page_vaddr(*(dir)) + pte_index(address))
-#define pte_offset_map(dir, address)		pte_offset_kernel(dir, address)
-#define pte_unmap(pte)		do { } while (0)
-
 #ifdef CONFIG_X2TLB
 #define pte_ERROR(e) \
 	printk("%s:%d: bad pte %p(%08lx%08lx).\n", __FILE__, __LINE__, \
--- a/arch/sh/include/asm/pgtable_64.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/sh/include/asm/pgtable_64.h
@@ -70,18 +70,6 @@ static __inline__ void set_pte(pte_t *pt
 #define pmd_page(pmd) \
 	(virt_to_page(pmd_val(pmd)))
 
-/* PMD to PTE dereferencing */
-#define pte_index(address) \
-		((address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-
-#define __pte_offset(address)	pte_index(address)
-
-#define pte_offset_kernel(dir, addr) \
-		((pte_t *) ((pmd_val(*(dir))) & PAGE_MASK) + pte_index((addr)))
-
-#define pte_offset_map(dir,addr)	pte_offset_kernel(dir, addr)
-#define pte_unmap(pte)		do { } while (0)
-
 #ifndef __ASSEMBLY__
 /*
  * PTEL coherent flags.
--- a/arch/sparc/include/asm/pgalloc_64.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/sparc/include/asm/pgalloc_64.h
@@ -67,7 +67,7 @@ void pte_free(struct mm_struct *mm, pgta
 
 #define pmd_populate_kernel(MM, PMD, PTE)	pmd_set(MM, PMD, PTE)
 #define pmd_populate(MM, PMD, PTE)		pmd_set(MM, PMD, PTE)
-#define pmd_pgtable(PMD)			((pte_t *)__pmd_page(PMD))
+#define pmd_pgtable(PMD)			((pte_t *)pmd_page_vaddr(PMD))
 
 void pgtable_free(void *table, bool is_page);
 
--- a/arch/sparc/include/asm/pgtable_32.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/sparc/include/asm/pgtable_32.h
@@ -146,6 +146,12 @@ static inline unsigned long __pmd_page(p
 	return (unsigned long)__nocache_va(v << 4);
 }
 
+static inline unsigned long pmd_page_vaddr(pmd_t pmd)
+{
+	unsigned long v = pmd_val(pmd) & SRMMU_PTD_PMASK;
+	return (unsigned long)__nocache_va(v << 4);
+}
+
 static inline unsigned long pud_page_vaddr(pud_t pud)
 {
 	if (srmmu_device_memory(pud_val(pud))) {
@@ -330,15 +336,6 @@ static inline pmd_t *pmd_offset(pud_t *
 		((address >> PMD_SHIFT) & (PTRS_PER_PMD - 1));
 }
 
-/* Find an entry in the third-level page table.. */
-pte_t *pte_offset_kernel(pmd_t * dir, unsigned long address);
-
-/*
- * This shortcut works on sun4m (and sun4d) because the nocache area is static.
- */
-#define pte_offset_map(d, a)		pte_offset_kernel(d,a)
-#define pte_unmap(pte)		do{}while(0)
-
 struct seq_file;
 void mmu_info(struct seq_file *m);
 
--- a/arch/sparc/include/asm/pgtable_64.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -835,7 +835,7 @@ static inline void pmd_set(struct mm_str
 
 #define pud_set(pudp, pmdp)	\
 	(pud_val(*(pudp)) = (__pa((unsigned long) (pmdp))))
-static inline unsigned long __pmd_page(pmd_t pmd)
+static inline unsigned long pmd_page_vaddr(pmd_t pmd)
 {
 	pte_t pte = __pte(pmd_val(pmd));
 	unsigned long pfn;
@@ -855,7 +855,7 @@ static inline unsigned long pud_page_vad
 	return ((unsigned long) __va(pfn << PAGE_SHIFT));
 }
 
-#define pmd_page(pmd) 			virt_to_page((void *)__pmd_page(pmd))
+#define pmd_page(pmd) 			virt_to_page((void *)pmd_page_vaddr(pmd))
 #define pud_page(pud) 			virt_to_page((void *)pud_page_vaddr(pud))
 #define pmd_clear(pmdp)			(pmd_val(*(pmdp)) = 0UL)
 #define pud_present(pud)		(pud_val(pud) != 0U)
@@ -906,14 +906,6 @@ static inline unsigned long pud_pfn(pud_
 	((pmd_t *) pud_page_vaddr(*(pudp)) + \
 	 (((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1)))
 
-/* Find an entry in the third-level page table.. */
-#define pte_index(address)			\
-	 ((address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-#define pte_offset_kernel(dir, address)	\
-	((pte_t *) __pmd_page(*(dir)) + pte_index(address))
-#define pte_offset_map(dir, address)	pte_offset_kernel((dir), (address))
-#define pte_unmap(pte)			do { } while (0)
-
 /* We cannot include <linux/mm_types.h> at this point yet: */
 extern struct mm_struct init_mm;
 
--- a/arch/sparc/mm/srmmu.c~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/sparc/mm/srmmu.c
@@ -139,16 +139,6 @@ void pmd_set(pmd_t *pmdp, pte_t *ptep)
 	set_pte((pte_t *)&pmd_val(*pmdp), __pte(SRMMU_ET_PTD | ptp));
 }
 
-/* Find an entry in the third-level page table.. */
-pte_t *pte_offset_kernel(pmd_t *dir, unsigned long address)
-{
-	void *pte;
-
-	pte = __nocache_va((pmd_val(*dir) & SRMMU_PTD_PMASK) << 4);
-	return (pte_t *) pte +
-	    ((address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1));
-}
-
 /*
  * size: bytes to allocate in the nocache area.
  * align: bytes, number to align at.
--- a/arch/um/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/um/include/asm/pgtable.h
@@ -323,19 +323,6 @@ static inline pte_t pte_modify(pte_t pte
 #define pmd_page_vaddr(pmd) \
 	((unsigned long) __va(pmd_val(pmd) & PAGE_MASK))
 
-/*
- * the pte page can be thought of an array like this: pte_t[PTRS_PER_PTE]
- *
- * this macro returns the index of the entry in the pte page which would
- * control the given virtual address
- */
-#define pte_index(address) (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-#define pte_offset_kernel(dir, address) \
-	((pte_t *) pmd_page_vaddr(*(dir)) +  pte_index(address))
-#define pte_offset_map(dir, address) \
-	((pte_t *)page_address(pmd_page(*(dir))) + pte_index(address))
-#define pte_unmap(pte) do { } while (0)
-
 struct mm_struct;
 extern pte_t *virt_to_pte(struct mm_struct *mm, unsigned long addr);
 
--- a/arch/unicore32/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/unicore32/include/asm/pgtable.h
@@ -153,12 +153,6 @@ extern struct page *empty_zero_page;
 #define pte_none(pte)			(!pte_val(pte))
 #define pte_clear(mm, addr, ptep)	set_pte(ptep, __pte(0))
 #define pte_page(pte)			(pfn_to_page(pte_pfn(pte)))
-#define pte_offset_kernel(dir, addr)	(pmd_page_vaddr(*(dir)) \
-						+ __pte_index(addr))
-
-#define pte_offset_map(dir, addr)	(pmd_page_vaddr(*(dir)) \
-						+ __pte_index(addr))
-#define pte_unmap(pte)			do { } while (0)
 
 #define set_pte(ptep, pte)	cpu_set_pte(ptep, pte)
 
@@ -229,9 +223,6 @@ PTE_BIT_FUNC(mkyoung,   |= PTE_YOUNG);
 /* to find an entry in a kernel page-table-directory */
 #define pgd_offset_k(addr)	pgd_offset(&init_mm, addr)
 
-/* Find an entry in the third-level page table.. */
-#define __pte_index(addr)	(((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
 	const unsigned long mask = PTE_EXEC | PTE_WRITE | PTE_READ;
--- a/arch/x86/include/asm/pgtable_32.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/x86/include/asm/pgtable_32.h
@@ -45,17 +45,6 @@ void sync_initial_page_table(void);
 # include <asm/pgtable-2level.h>
 #endif
 
-#if defined(CONFIG_HIGHPTE)
-#define pte_offset_map(dir, address)					\
-	((pte_t *)kmap_atomic(pmd_page(*(dir))) +		\
-	 pte_index((address)))
-#define pte_unmap(pte) kunmap_atomic((pte))
-#else
-#define pte_offset_map(dir, address)					\
-	((pte_t *)page_address(pmd_page(*(dir))) + pte_index((address)))
-#define pte_unmap(pte) do { } while (0)
-#endif
-
 /* Clear a kernel PTE and flush it from the TLB */
 #define kpte_clear_flush(ptep, vaddr)		\
 do {						\
--- a/arch/x86/include/asm/pgtable_64.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/x86/include/asm/pgtable_64.h
@@ -186,10 +186,6 @@ extern void sync_global_pgds(unsigned lo
 
 /* PTE - Level 1 access. */
 
-/* x86-64 always has all page tables mapped. */
-#define pte_offset_map(dir, address) pte_offset_kernel((dir), (address))
-#define pte_unmap(pte) ((void)(pte))/* NOP */
-
 /*
  * Encode and de-code a swap entry
  *
--- a/arch/x86/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/x86/include/asm/pgtable.h
@@ -855,25 +855,6 @@ static inline unsigned long pmd_index(un
  */
 #define mk_pte(page, pgprot)   pfn_pte(page_to_pfn(page), (pgprot))
 
-/*
- * the pte page can be thought of an array like this: pte_t[PTRS_PER_PTE]
- *
- * this function returns the index of the entry in the pte page which would
- * control the given virtual address
- *
- * Also define macro so we can test if pte_index is defined for arch.
- */
-#define pte_index pte_index
-static inline unsigned long pte_index(unsigned long address)
-{
-	return (address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
-}
-
-static inline pte_t *pte_offset_kernel(pmd_t *pmd, unsigned long address)
-{
-	return (pte_t *)pmd_page_vaddr(*pmd) + pte_index(address);
-}
-
 static inline int pmd_bad(pmd_t pmd)
 {
 	return (pmd_flags(pmd) & ~_PAGE_USER) != _KERNPG_TABLE;
--- a/arch/xtensa/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/xtensa/include/asm/pgtable.h
@@ -267,7 +267,7 @@ static inline int pte_write(pte_t pte) {
 static inline int pte_dirty(pte_t pte) { return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte) { return pte_val(pte) & _PAGE_ACCESSED; }
 
-static inline pte_t pte_wrprotect(pte_t pte)	
+static inline pte_t pte_wrprotect(pte_t pte)
 	{ pte_val(pte) &= ~(_PAGE_WRITABLE | _PAGE_HW_WRITE); return pte; }
 static inline pte_t pte_mkclean(pte_t pte)
 	{ pte_val(pte) &= ~(_PAGE_DIRTY | _PAGE_HW_WRITE); return pte; }
@@ -367,14 +367,6 @@ ptep_set_wrprotect(struct mm_struct *mm,
 
 #define pgd_index(address)	((address) >> PGDIR_SHIFT)
 
-/* Find an entry in the third-level page table.. */
-#define pte_index(address)	(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-#define pte_offset_kernel(dir,addr) 					\
-	((pte_t*) pmd_page_vaddr(*(dir)) + pte_index(addr))
-#define pte_offset_map(dir,addr)	pte_offset_kernel((dir),(addr))
-#define pte_unmap(pte)		do { } while (0)
-
-
 /*
  * Encode and decode a swap and file entry.
  */
--- a/include/linux/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/include/linux/pgtable.h
@@ -29,6 +29,35 @@
 #endif
 
 /*
+ * the pte page can be thought of an array like this: pte_t[PTRS_PER_PTE]
+ *
+ * this function returns the index of the entry in the pte page which would
+ * control the given virtual address
+ */
+static inline unsigned long pte_index(unsigned long address)
+{
+	return (address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
+}
+
+#ifndef pte_offset_kernel
+static inline pte_t *pte_offset_kernel(pmd_t *pmd, unsigned long address)
+{
+	return (pte_t *)pmd_page_vaddr(*pmd) + pte_index(address);
+}
+#define pte_offset_kernel pte_offset_kernel
+#endif
+
+#if defined(CONFIG_HIGHPTE)
+#define pte_offset_map(dir, address)				\
+	((pte_t *)kmap_atomic(pmd_page(*(dir))) +		\
+	 pte_index((address)))
+#define pte_unmap(pte) kunmap_atomic((pte))
+#else
+#define pte_offset_map(dir, address)	pte_offset_kernel((dir), (address))
+#define pte_unmap(pte) ((void)(pte))	/* NOP */
+#endif
+
+/*
  * In many cases it is known that a virtual address is mapped at PMD or PTE
  * level, so instead of traversing all the page table levels, we can get a
  * pointer to the PMD entry in user or kernel page table or translate a virtual
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-memblock-replace-dereferences-of-memblock_regionnid-with-api-calls.patch
mm-make-early_pfn_to_nid-and-related-defintions-close-to-each-other.patch
mm-remove-config_have_memblock_node_map-option.patch
mm-free_area_init-use-maximal-zone-pfns-rather-than-zone-sizes.patch
mm-use-free_area_init-instead-of-free_area_init_nodes.patch
alpha-simplify-detection-of-memory-zone-boundaries.patch
arm-simplify-detection-of-memory-zone-boundaries.patch
arm64-simplify-detection-of-memory-zone-boundaries-for-uma-configs.patch
csky-simplify-detection-of-memory-zone-boundaries.patch
m68k-mm-simplify-detection-of-memory-zone-boundaries.patch
parisc-simplify-detection-of-memory-zone-boundaries.patch
sparc32-simplify-detection-of-memory-zone-boundaries.patch
unicore32-simplify-detection-of-memory-zone-boundaries.patch
xtensa-simplify-detection-of-memory-zone-boundaries.patch
mm-remove-early_pfn_in_nid-and-config_nodes_span_other_nodes.patch
mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order.patch
mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix-2.patch
mm-rename-free_area_init_node-to-free_area_init_memoryless_node.patch
mm-clean-up-free_area_init_node-and-its-helpers.patch
mm-simplify-find_min_pfn_with_active_regions.patch
docs-vm-update-memory-models-documentation.patch
h8300-remove-usage-of-__arch_use_5level_hack.patch
arm-add-support-for-folded-p4d-page-tables.patch
arm-add-support-for-folded-p4d-page-tables-fix.patch
arm64-add-support-for-folded-p4d-page-tables.patch
hexagon-remove-__arch_use_5level_hack.patch
ia64-add-support-for-folded-p4d-page-tables.patch
nios2-add-support-for-folded-p4d-page-tables.patch
openrisc-add-support-for-folded-p4d-page-tables.patch
powerpc-add-support-for-folded-p4d-page-tables.patch
powerpc-add-support-for-folded-p4d-page-tables-fix.patch
sh-drop-__pxd_offset-macros-that-duplicate-pxd_index-ones.patch
sh-add-support-for-folded-p4d-page-tables.patch
unicore32-remove-__arch_use_5level_hack.patch
asm-generic-remove-pgtable-nop4d-hackh.patch
mm-remove-__arch_has_5level_hack-and-include-asm-generic-5level-fixuph.patch
mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included.patch
mm-introduce-include-linux-pgtableh.patch
mm-reorder-includes-after-introduction-of-linux-pgtableh.patch
csky-replace-definitions-of-__pxd_offset-with-pxd_index.patch
m68k-mm-motorola-move-comment-about-page-table-allocation-funcitons.patch
m68k-mm-move-cachenocahe_page-definitions-close-to-their-user.patch
x86-mm-simplify-init_trampoline-and-surrounding-logic.patch
mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte.patch
mm-consolidate-pte_index-and-pte_offset_-definitions.patch
mm-consolidate-pmd_index-and-pmd_offset-definitions.patch
mm-consolidate-pud_index-and-pud_offset-definitions.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions.patch
