From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-consolidate-pgd_index-and-pgd_offset_k-definitions.patch added to -mm
 tree
Date: Fri, 15 May 2020 14:16:21 -0700
Message-ID: <20200515211621.2m68pBfZo%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgEOVQZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 15 May 2020 17:16:25 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, bcain@codeaurora.org, bp@alien8.de, catalin.marinas@arm.com, chris@zankel.net, dalias@libc.org, davem@davemloft.net, deanbo422@gmail.com, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, mattst88@gmail.com, mingo@redhat.com, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@linux.ibm.com, shorne@gmail.com, tglx@linutronix.de, tony.luck@intel.com, tsbogend@alpha.franken.de, vgupta@synopsys.com, will@kernel.org, willy@infradead.org, ysato@users.sourceforge.jp


The patch titled
     Subject: mm: consolidate pgd_index() and pgd_offset{_k}() definitions
has been added to the -mm tree.  Its filename is
     mm-consolidate-pgd_index-and-pgd_offset_k-definitions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-consolidate-pgd_index-and-pgd_offset_k-definitions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-consolidate-pgd_index-and-pgd_offset_k-definitions.patch

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
Subject: mm: consolidate pgd_index() and pgd_offset{_k}() definitions

All architectures tables define pgd_offset() as an entry in the array of
PGDs indexed by the pgd_index(), where pgd_index() is

	(address >> PGD_SHIFT) & (PTRS_PER_PGD - 1)

For the most cases, the pgd_offset() uses mm->pgd as the pointer to the
top-level page directory and the pgd_offset_k() is a helper that presumes
that mm == &init_mm.

Use x86 implementation as the generic one and remove redundant definitions
of PGD accessors in most of arch/*/include/asm/pgtable.h

The generic implementation can be overridden by an architecture and this
ability is currently in use by there architectures:
* ia64 has custom implementation of pgd_index()
* s390 has custom definitions of all page table accessors

Link: http://lkml.kernel.org/r/20200514170327.31389-13-rppt@kernel.org
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

 arch/alpha/include/asm/pgtable.h             |    9 ---
 arch/arc/include/asm/pgtable.h               |    7 --
 arch/arm/include/asm/pgtable.h               |    8 --
 arch/arm64/include/asm/pgtable.h             |   10 ---
 arch/arm64/kernel/hibernate.c                |    4 -
 arch/arm64/mm/kasan_init.c                   |    2 
 arch/arm64/mm/mmu.c                          |    8 +-
 arch/csky/include/asm/pgtable.h              |   11 ---
 arch/hexagon/include/asm/pgtable.h           |   18 ------
 arch/ia64/include/asm/pgtable.h              |   14 ----
 arch/m68k/include/asm/mcf_pgtable.h          |   11 ---
 arch/m68k/include/asm/motorola_pgtable.h     |   16 -----
 arch/m68k/include/asm/sun3_pgtable.h         |    9 ---
 arch/microblaze/include/asm/pgtable.h        |    7 --
 arch/mips/include/asm/pgtable-32.h           |    8 --
 arch/mips/include/asm/pgtable-64.h           |    8 --
 arch/nds32/include/asm/pgtable.h             |    6 --
 arch/nios2/include/asm/pgtable.h             |    8 --
 arch/openrisc/include/asm/pgtable.h          |   10 ---
 arch/parisc/include/asm/pgtable.h            |    9 ---
 arch/powerpc/include/asm/book3s/32/pgtable.h |    7 --
 arch/powerpc/include/asm/book3s/64/pgtable.h |   13 ----
 arch/powerpc/include/asm/nohash/32/pgtable.h |    7 --
 arch/powerpc/include/asm/nohash/64/pgtable.h |   12 ----
 arch/riscv/include/asm/pgtable.h             |   10 ---
 arch/riscv/mm/init.c                         |   12 ++--
 arch/s390/include/asm/pgtable.h              |    1 
 arch/sh/include/asm/pgtable_32.h             |    7 --
 arch/sh/include/asm/pgtable_64.h             |   11 ---
 arch/sparc/include/asm/pgtable_32.h          |    8 --
 arch/sparc/include/asm/pgtable_64.h          |    7 --
 arch/um/include/asm/pgtable.h                |   50 +++++------------
 arch/unicore32/include/asm/pgtable.h         |    8 --
 arch/x86/include/asm/pgtable.h               |   24 --------
 arch/xtensa/include/asm/pgtable.h            |    8 --
 include/linux/pgtable.h                      |   26 ++++++++
 36 files changed, 55 insertions(+), 339 deletions(-)

--- a/arch/alpha/include/asm/pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/alpha/include/asm/pgtable.h
@@ -276,15 +276,6 @@ extern inline pte_t pte_mkwrite(pte_t pt
 extern inline pte_t pte_mkdirty(pte_t pte)	{ pte_val(pte) |= __DIRTY_BITS; return pte; }
 extern inline pte_t pte_mkyoung(pte_t pte)	{ pte_val(pte) |= __ACCESS_BITS; return pte; }
 
-#define PAGE_DIR_OFFSET(tsk,address) pgd_offset((tsk),(address))
-
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(address) pgd_offset(&init_mm, (address))
-
-/* to find an entry in a page-table-directory. */
-#define pgd_index(address)	(((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
-#define pgd_offset(mm, address)	((mm)->pgd+pgd_index(address))
-
 /*
  * The smp_read_barrier_depends() in the following functions are required to
  * order the load of *dir (the pointer in the top level page table) with any
--- a/arch/arc/include/asm/pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/arc/include/asm/pgtable.h
@@ -317,13 +317,6 @@ static inline void set_pte_at(struct mm_
 }
 
 /*
- * All kernel related VM pages are in init's mm.
- */
-#define pgd_offset_k(address)	pgd_offset(&init_mm, address)
-#define pgd_index(addr)		((addr) >> PGDIR_SHIFT)
-#define pgd_offset(mm, addr)	(((mm)->pgd)+pgd_index(addr))
-
-/*
  * Macro to quickly access the PGD entry, utlising the fact that some
  * arch may cache the pointer to Page Directory of "current" task
  * in a MMU register
--- a/arch/arm64/include/asm/pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/arm64/include/asm/pgtable.h
@@ -659,16 +659,6 @@ static inline unsigned long p4d_page_vad
 
 #define pgd_ERROR(pgd)		__pgd_error(__FILE__, __LINE__, pgd_val(pgd))
 
-/* to find an entry in a page-table-directory */
-#define pgd_index(addr)		(((addr) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
-
-#define pgd_offset_raw(pgd, addr)	((pgd) + pgd_index(addr))
-
-#define pgd_offset(mm, addr)	(pgd_offset_raw((mm)->pgd, (addr)))
-
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(addr)	pgd_offset(&init_mm, addr)
-
 #define pgd_set_fixmap(addr)	((pgd_t *)set_fixmap_offset(FIX_PGD, addr))
 #define pgd_clear_fixmap()	clear_fixmap(FIX_PGD)
 
--- a/arch/arm64/kernel/hibernate.c~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/arm64/kernel/hibernate.c
@@ -188,7 +188,7 @@ static int trans_pgd_map_page(pgd_t *tra
 	pmd_t *pmdp;
 	pte_t *ptep;
 
-	pgdp = pgd_offset_raw(trans_pgd, dst_addr);
+	pgdp = pgd_offset_pgd(trans_pgd, dst_addr);
 	if (pgd_none(READ_ONCE(*pgdp))) {
 		pudp = (void *)get_safe_page(GFP_ATOMIC);
 		if (!pudp)
@@ -490,7 +490,7 @@ static int copy_page_tables(pgd_t *dst_p
 	unsigned long addr = start;
 	pgd_t *src_pgdp = pgd_offset_k(start);
 
-	dst_pgdp = pgd_offset_raw(dst_pgdp, start);
+	dst_pgdp = pgd_offset_pgd(dst_pgdp, start);
 	do {
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(READ_ONCE(*src_pgdp)))
--- a/arch/arm64/mm/kasan_init.c~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/arm64/mm/kasan_init.c
@@ -190,7 +190,7 @@ void __init kasan_copy_shadow(pgd_t *pgd
 
 	pgdp = pgd_offset_k(KASAN_SHADOW_START);
 	pgdp_end = pgd_offset_k(KASAN_SHADOW_END);
-	pgdp_new = pgd_offset_raw(pgdir, KASAN_SHADOW_START);
+	pgdp_new = pgd_offset_pgd(pgdir, KASAN_SHADOW_START);
 	do {
 		set_pgd(pgdp_new, READ_ONCE(*pgdp));
 	} while (pgdp++, pgdp_new++, pgdp != pgdp_end);
--- a/arch/arm64/mm/mmu.c~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/arm64/mm/mmu.c
@@ -341,7 +341,7 @@ static void __create_pgd_mapping(pgd_t *
 				 int flags)
 {
 	unsigned long addr, end, next;
-	pgd_t *pgdp = pgd_offset_raw(pgdir, virt);
+	pgd_t *pgdp = pgd_offset_pgd(pgdir, virt);
 
 	/*
 	 * If the virtual and physical address don't have the same offset
@@ -663,13 +663,13 @@ static void __init map_kernel(pgd_t *pgd
 			   &vmlinux_initdata, 0, VM_NO_GUARD);
 	map_kernel_segment(pgdp, _data, _end, PAGE_KERNEL, &vmlinux_data, 0, 0);
 
-	if (!READ_ONCE(pgd_val(*pgd_offset_raw(pgdp, FIXADDR_START)))) {
+	if (!READ_ONCE(pgd_val(*pgd_offset_pgd(pgdp, FIXADDR_START)))) {
 		/*
 		 * The fixmap falls in a separate pgd to the kernel, and doesn't
 		 * live in the carveout for the swapper_pg_dir. We can simply
 		 * re-use the existing dir for the fixmap.
 		 */
-		set_pgd(pgd_offset_raw(pgdp, FIXADDR_START),
+		set_pgd(pgd_offset_pgd(pgdp, FIXADDR_START),
 			READ_ONCE(*pgd_offset_k(FIXADDR_START)));
 	} else if (CONFIG_PGTABLE_LEVELS > 3) {
 		pgd_t *bm_pgdp;
@@ -682,7 +682,7 @@ static void __init map_kernel(pgd_t *pgd
 		 * entry instead.
 		 */
 		BUG_ON(!IS_ENABLED(CONFIG_ARM64_16K_PAGES));
-		bm_pgdp = pgd_offset_raw(pgdp, FIXADDR_START);
+		bm_pgdp = pgd_offset_pgd(pgdp, FIXADDR_START);
 		bm_p4dp = p4d_offset(bm_pgdp, FIXADDR_START);
 		bm_pudp = pud_set_fixmap_offset(bm_p4dp, FIXADDR_START);
 		pud_populate(&init_mm, bm_pudp, lm_alias(bm_pmd));
--- a/arch/arm/include/asm/pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/arm/include/asm/pgtable.h
@@ -166,14 +166,6 @@ extern struct page *empty_zero_page;
 
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 
-/* to find an entry in a page-table-directory */
-#define pgd_index(addr)		((addr) >> PGDIR_SHIFT)
-
-#define pgd_offset(mm, addr)	((mm)->pgd + pgd_index(addr))
-
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(addr)	pgd_offset(&init_mm, addr)
-
 #define pmd_none(pmd)		(!pmd_val(pmd))
 
 static inline pte_t *pmd_page_vaddr(pmd_t pmd)
--- a/arch/csky/include/asm/pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/csky/include/asm/pgtable.h
@@ -220,11 +220,6 @@ static inline pte_t pte_mkyoung(pte_t pt
 	return pte;
 }
 
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(address)	pgd_offset(&init_mm, address)
-
-#define pgd_index(address)	((address) >> PGDIR_SHIFT)
-
 #define __HAVE_PHYS_MEM_ACCESS_PROT
 struct file;
 extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
@@ -268,12 +263,6 @@ static inline pte_t pte_modify(pte_t pte
 		     (pgprot_val(newprot)));
 }
 
-/* to find an entry in a page-table-directory */
-static inline pgd_t *pgd_offset(struct mm_struct *mm, unsigned long address)
-{
-	return mm->pgd + pgd_index(address);
-}
-
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 extern void paging_init(void);
 
--- a/arch/hexagon/include/asm/pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/hexagon/include/asm/pgtable.h
@@ -207,24 +207,6 @@ static inline void pte_clear(struct mm_s
 }
 
 /**
- * pgd_index - returns the index of the entry in the PGD page
- * which would control the given virtual address
- *
- * This returns the *index* for the address in the pgd_t
- */
-#define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
-
-/*
- * pgd_offset - find an offset in a page-table-directory
- */
-#define pgd_offset(mm, addr) ((mm)->pgd + pgd_index(addr))
-
-/*
- * pgd_offset_k - get kernel (init_mm) pgd entry pointer for addr
- */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
-
-/**
  * pmd_none - check if pmd_entry is mapped
  * @pmd_entry:  pmd entry
  *
--- a/arch/ia64/include/asm/pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/ia64/include/asm/pgtable.h
@@ -364,19 +364,7 @@ pgd_index (unsigned long address)
 
 	return (region << (PAGE_SHIFT - 6)) | l1index;
 }
-
-/* The offset in the 1-level directory is given by the 3 region bits
-   (61..63) and the level-1 bits.  */
-static inline pgd_t*
-pgd_offset (const struct mm_struct *mm, unsigned long address)
-{
-	return mm->pgd + pgd_index(address);
-}
-
-/* In the kernel's mapped region we completely ignore the region number
-   (since we know it's in region number 5). */
-#define pgd_offset_k(addr) \
-	(init_mm.pgd + (((addr) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1)))
+#define pgd_index pgd_index
 
 /* Look up a pgd entry in the gate area.  On IA-64, the gate-area
    resides in the kernel-mapped segment, hence we use pgd_offset_k()
--- a/arch/m68k/include/asm/mcf_pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/m68k/include/asm/mcf_pgtable.h
@@ -311,17 +311,6 @@ static inline pte_t pte_mkcache(pte_t pt
 extern pgd_t kernel_pg_dir[PTRS_PER_PGD];
 
 /*
- * Find an entry in a pagetable directory.
- */
-#define pgd_index(address)	((address) >> PGDIR_SHIFT)
-#define pgd_offset(mm, address)	((mm)->pgd + pgd_index(address))
-
-/*
- * Find an entry in a kernel pagetable directory.
- */
-#define pgd_offset_k(address)	pgd_offset(&init_mm, address)
-
-/*
  * Encode and de-code a swap entry (must be !pte_none(e) && !pte_present(e))
  */
 #define __swp_type(x)		((x).val & 0xFF)
--- a/arch/m68k/include/asm/motorola_pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/m68k/include/asm/motorola_pgtable.h
@@ -192,25 +192,9 @@ static inline pte_t pte_mkcache(pte_t pt
 	return pte;
 }
 
-#define PAGE_DIR_OFFSET(tsk,address) pgd_offset((tsk),(address))
-
-#define pgd_index(address)     ((address) >> PGDIR_SHIFT)
-
-/* to find an entry in a page-table-directory */
-static inline pgd_t *pgd_offset(const struct mm_struct *mm,
-				unsigned long address)
-{
-	return mm->pgd + pgd_index(address);
-}
-
 #define swapper_pg_dir kernel_pg_dir
 extern pgd_t kernel_pg_dir[128];
 
-static inline pgd_t *pgd_offset_k(unsigned long address)
-{
-	return kernel_pg_dir + (address >> PGDIR_SHIFT);
-}
-
 /* Encode and de-code a swap entry (must be !pte_none(e) && !pte_present(e)) */
 #define __swp_type(x)		(((x).val >> 4) & 0xff)
 #define __swp_offset(x)		((x).val >> 12)
--- a/arch/m68k/include/asm/sun3_pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/m68k/include/asm/sun3_pgtable.h
@@ -174,15 +174,6 @@ static inline pte_t pte_mkcache(pte_t pt
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 extern pgd_t kernel_pg_dir[PTRS_PER_PGD];
 
-/* Find an entry in a pagetable directory. */
-#define pgd_index(address)     ((address) >> PGDIR_SHIFT)
-
-#define pgd_offset(mm, address) \
-((mm)->pgd + pgd_index(address))
-
-/* Find an entry in a kernel pagetable directory. */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
-
 /* Macros to (de)construct the fake PTEs representing swap pages. */
 #define __swp_type(x)		((x).val & 0x7F)
 #define __swp_offset(x)		(((x).val) >> 7)
--- a/arch/microblaze/include/asm/pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/microblaze/include/asm/pgtable.h
@@ -445,13 +445,6 @@ static inline unsigned long pmd_page_vad
 /* returns struct *page of the pmd entry*/
 #define pmd_page(pmd)	(pfn_to_page(__pa(pmd_val(pmd)) >> PAGE_SHIFT))
 
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
-
-/* to find an entry in a page-table-directory */
-#define pgd_index(address)	 ((address) >> PGDIR_SHIFT)
-#define pgd_offset(mm, address)	 ((mm)->pgd + pgd_index(address))
-
 /* Find an entry in the third-level page table.. */
 
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
--- a/arch/mips/include/asm/pgtable-32.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/mips/include/asm/pgtable-32.h
@@ -195,14 +195,6 @@ static inline pte_t pfn_pte(unsigned lon
 
 #define pte_page(x)		pfn_to_page(pte_pfn(x))
 
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
-
-#define pgd_index(address)	(((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
-
-/* to find an entry in a page-table-directory */
-#define pgd_offset(mm, addr)	((mm)->pgd + pgd_index(addr))
-
 #if defined(CONFIG_CPU_R3K_TLB)
 
 /* Swap entries must have VALID bit cleared. */
--- a/arch/mips/include/asm/pgtable-64.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/mips/include/asm/pgtable-64.h
@@ -313,14 +313,6 @@ static inline void pud_clear(pud_t *pudp
 #define pfn_pmd(pfn, prot)	__pmd(((pfn) << _PFN_SHIFT) | pgprot_val(prot))
 #endif
 
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
-
-#define pgd_index(address)	(((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
-
-/* to find an entry in a page-table-directory */
-#define pgd_offset(mm, addr)	((mm)->pgd + pgd_index(addr))
-
 #ifndef __PAGETABLE_PMD_FOLDED
 static inline unsigned long pud_page_vaddr(pud_t pud)
 {
--- a/arch/nds32/include/asm/pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/nds32/include/asm/pgtable.h
@@ -340,12 +340,6 @@ static inline pmd_t __mk_pmd(pte_t * pte
  *
 */
 
-/* to find an entry in a page-table-directory */
-#define pgd_index(address)      (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
-#define pgd_offset(mm, address)	((mm)->pgd + pgd_index(address))
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(addr)      pgd_offset(&init_mm, addr)
-
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
 	const unsigned long mask = 0xfff;
--- a/arch/nios2/include/asm/pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/nios2/include/asm/pgtable.h
@@ -102,10 +102,6 @@ static inline void set_pmd(pmd_t *pmdptr
 	*pmdptr = pmdval;
 }
 
-/* to find an entry in a page-table-directory */
-#define pgd_index(addr)		(((addr) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
-#define pgd_offset(mm, addr)	((mm)->pgd + pgd_index(addr))
-
 static inline int pte_write(pte_t pte)		\
 	{ return pte_val(pte) & _PAGE_WRITE; }
 static inline int pte_dirty(pte_t pte)		\
@@ -248,10 +244,6 @@ static inline unsigned long pmd_page_vad
 	return pmd_val(pmd);
 }
 
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(addr)	pgd_offset(&init_mm, addr)
-
-
 #define pte_ERROR(e) \
 	pr_err("%s:%d: bad pte %08lx.\n", \
 		__FILE__, __LINE__, pte_val(e))
--- a/arch/openrisc/include/asm/pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/openrisc/include/asm/pgtable.h
@@ -369,16 +369,6 @@ static inline unsigned long pmd_page_vad
 	return ((unsigned long) __va(pmd_val(pmd) & PAGE_MASK));
 }
 
-/* to find an entry in a page-table-directory. */
-#define pgd_index(address)      ((address >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
-
-#define __pgd_offset(address)   pgd_index(address)
-
-#define pgd_offset(mm, address) ((mm)->pgd+pgd_index(address))
-
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
-
 #define __pmd_offset(address) \
 	(((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
 
--- a/arch/parisc/include/asm/pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/parisc/include/asm/pgtable.h
@@ -437,15 +437,6 @@ static inline unsigned long pmd_page_vad
 #define __pmd_page(pmd) ((unsigned long) __va(pmd_address(pmd)))
 #define pmd_page(pmd)	virt_to_page((void *)__pmd_page(pmd))
 
-#define pgd_index(address) ((address) >> PGDIR_SHIFT)
-
-/* to find an entry in a page-table-directory */
-#define pgd_offset(mm, address) \
-((mm)->pgd + ((address) >> PGDIR_SHIFT))
-
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
-
 /* Find an entry in the second-level page table.. */
 
 extern void paging_init (void);
--- a/arch/powerpc/include/asm/book3s/32/pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/powerpc/include/asm/book3s/32/pgtable.h
@@ -354,13 +354,6 @@ static inline void __ptep_set_access_fla
 #define pmd_page(pmd)		\
 	pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT)
 
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
-
-/* to find an entry in a page-table-directory */
-#define pgd_index(address)	 ((address) >> PGDIR_SHIFT)
-#define pgd_offset(mm, address)	 ((mm)->pgd + pgd_index(address))
-
 /*
  * Encode and decode a swap entry.
  * Note that the bits we use in a PTE for representing a swap entry
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1008,19 +1008,6 @@ extern struct page *p4d_page(p4d_t p4d);
 #define pud_page_vaddr(pud)	__va(pud_val(pud) & ~PUD_MASKED_BITS)
 #define p4d_page_vaddr(p4d)	__va(p4d_val(p4d) & ~P4D_MASKED_BITS)
 
-#define pgd_index(address) (((address) >> (PGDIR_SHIFT)) & (PTRS_PER_PGD - 1))
-
-/*
- * Find an entry in a page-table-directory.  We combine the address region
- * (the high order N bits) and the pgd portion of the address.
- */
-
-#define pgd_offset(mm, address)	 ((mm)->pgd + pgd_index(address))
-
-/* to find an entry in a kernel page-table-directory */
-/* This now only contains the vmalloc pages */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
-
 #define pte_ERROR(e) \
 	pr_err("%s:%d: bad pte %08lx.\n", __FILE__, __LINE__, pte_val(e))
 #define pmd_ERROR(e) \
--- a/arch/powerpc/include/asm/nohash/32/pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/powerpc/include/asm/nohash/32/pgtable.h
@@ -358,13 +358,6 @@ static inline int pte_young(pte_t pte)
 	pfn_to_page((__pa(pmd_val(pmd)) >> PAGE_SHIFT))
 #endif
 
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
-
-/* to find an entry in a page-table-directory */
-#define pgd_index(address)	 ((address) >> PGDIR_SHIFT)
-#define pgd_offset(mm, address)	 ((mm)->pgd + pgd_index(address))
-
 /*
  * Encode and decode a swap entry.
  * Note that the bits we use in a PTE for representing a swap entry
--- a/arch/powerpc/include/asm/nohash/64/pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/powerpc/include/asm/nohash/64/pgtable.h
@@ -182,18 +182,6 @@ static inline void p4d_set(p4d_t *p4dp,
 	*p4dp = __p4d(val);
 }
 
-/*
- * Find an entry in a page-table-directory.  We combine the address region
- * (the high order N bits) and the pgd portion of the address.
- */
-#define pgd_index(address) (((address) >> (PGDIR_SHIFT)) & (PTRS_PER_PGD - 1))
-
-#define pgd_offset(mm, address)	 ((mm)->pgd + pgd_index(address))
-
-/* to find an entry in a kernel page-table-directory */
-/* This now only contains the vmalloc pages */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
-
 /* Atomic PTE updates */
 static inline unsigned long pte_update(struct mm_struct *mm,
 				       unsigned long addr,
--- a/arch/riscv/include/asm/pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/riscv/include/asm/pgtable.h
@@ -173,16 +173,6 @@ static inline unsigned long _pgd_pfn(pgd
 	return pgd_val(pgd) >> _PAGE_PFN_SHIFT;
 }
 
-#define pgd_index(addr) (((addr) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
-
-/* Locate an entry in the page global directory */
-static inline pgd_t *pgd_offset(const struct mm_struct *mm, unsigned long addr)
-{
-	return mm->pgd + pgd_index(addr);
-}
-/* Locate an entry in the kernel page global directory */
-#define pgd_offset_k(addr)      pgd_offset(&init_mm, (addr))
-
 static inline struct page *pmd_page(pmd_t pmd)
 {
 	return pfn_to_page(pmd_val(pmd) >> _PAGE_PFN_SHIFT);
--- a/arch/riscv/mm/init.c~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/riscv/mm/init.c
@@ -325,21 +325,21 @@ static void __init create_pgd_mapping(pg
 {
 	pgd_next_t *nextp;
 	phys_addr_t next_phys;
-	uintptr_t pgd_index = pgd_index(va);
+	uintptr_t pgd_idx = pgd_index(va);
 
 	if (sz == PGDIR_SIZE) {
-		if (pgd_val(pgdp[pgd_index]) == 0)
-			pgdp[pgd_index] = pfn_pgd(PFN_DOWN(pa), prot);
+		if (pgd_val(pgdp[pgd_idx]) == 0)
+			pgdp[pgd_idx] = pfn_pgd(PFN_DOWN(pa), prot);
 		return;
 	}
 
-	if (pgd_val(pgdp[pgd_index]) == 0) {
+	if (pgd_val(pgdp[pgd_idx]) == 0) {
 		next_phys = alloc_pgd_next(va);
-		pgdp[pgd_index] = pfn_pgd(PFN_DOWN(next_phys), PAGE_TABLE);
+		pgdp[pgd_idx] = pfn_pgd(PFN_DOWN(next_phys), PAGE_TABLE);
 		nextp = get_pgd_next_virt(next_phys);
 		memset(nextp, 0, PAGE_SIZE);
 	} else {
-		next_phys = PFN_PHYS(_pgd_pfn(pgdp[pgd_index]));
+		next_phys = PFN_PHYS(_pgd_pfn(pgdp[pgd_idx]));
 		nextp = get_pgd_next_virt(next_phys);
 	}
 
--- a/arch/s390/include/asm/pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/s390/include/asm/pgtable.h
@@ -1259,7 +1259,6 @@ static inline pgd_t *pgd_offset_raw(pgd_
 }
 
 #define pgd_offset(mm, address) pgd_offset_raw(READ_ONCE((mm)->pgd), address)
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
 
 static inline p4d_t *p4d_offset(pgd_t *pgd, unsigned long address)
 {
--- a/arch/sh/include/asm/pgtable_32.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/sh/include/asm/pgtable_32.h
@@ -408,13 +408,6 @@ static inline unsigned long pmd_page_vad
 
 #define pmd_page(pmd)		(virt_to_page(pmd_val(pmd)))
 
-/* to find an entry in a page-table-directory. */
-#define pgd_index(address)	(((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
-#define pgd_offset(mm, address)	((mm)->pgd + pgd_index(address))
-
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(address)	pgd_offset(&init_mm, address)
-
 #ifdef CONFIG_X2TLB
 #define pte_ERROR(e) \
 	printk("%s:%d: bad pte %p(%08lx%08lx).\n", __FILE__, __LINE__, \
--- a/arch/sh/include/asm/pgtable_64.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/sh/include/asm/pgtable_64.h
@@ -41,17 +41,6 @@ static __inline__ void set_pte(pte_t *pt
 #define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
 
 /*
- * PGD defines. Top level.
- */
-
-/* To find an entry in a generic PGD. */
-#define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
-#define pgd_offset(mm, address) ((mm)->pgd+pgd_index(address))
-
-/* To find an entry in a kernel PGD. */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
-
-/*
  * PMD level access routines. Same notes as above.
  */
 #define _PMD_EMPTY		0x0
--- a/arch/sparc/include/asm/pgtable_32.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/sparc/include/asm/pgtable_32.h
@@ -321,14 +321,6 @@ static inline pte_t pte_modify(pte_t pte
 		pgprot_val(newprot));
 }
 
-#define pgd_index(address) ((address) >> PGDIR_SHIFT)
-
-/* to find an entry in a page-table-directory */
-#define pgd_offset(mm, address) ((mm)->pgd + pgd_index(address))
-
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
-
 struct seq_file;
 void mmu_info(struct seq_file *m);
 
--- a/arch/sparc/include/asm/pgtable_64.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -889,13 +889,6 @@ static inline unsigned long pud_pfn(pud_
 #define p4d_set(p4dp, pudp)	\
 	(p4d_val(*(p4dp)) = (__pa((unsigned long) (pudp))))
 
-/* to find an entry in a page-table-directory. */
-#define pgd_index(address)	(((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
-#define pgd_offset(mm, address)	((mm)->pgd + pgd_index(address))
-
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
-
 /* We cannot include <linux/mm_types.h> at this point yet: */
 extern struct mm_struct init_mm;
 
--- a/arch/um/include/asm/pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/um/include/asm/pgtable.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* 
+/*
  * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Copyright 2003 PathScale, Inc.
  * Derived from include/asm-i386/pgtable.h
@@ -131,7 +131,7 @@ static inline int pte_none(pte_t pte)
  * Undefined behaviour if not..
  */
 static inline int pte_read(pte_t pte)
-{ 
+{
 	return((pte_get_bits(pte, _PAGE_USER)) &&
 	       !(pte_get_bits(pte, _PAGE_PROTNONE)));
 }
@@ -163,7 +163,7 @@ static inline int pte_newpage(pte_t pte)
 }
 
 static inline int pte_newprot(pte_t pte)
-{ 
+{
 	return(pte_present(pte) && (pte_get_bits(pte, _PAGE_NEWPROT)));
 }
 
@@ -185,31 +185,31 @@ static inline pte_t pte_mkclean(pte_t pt
 	return(pte);
 }
 
-static inline pte_t pte_mkold(pte_t pte)	
-{ 
+static inline pte_t pte_mkold(pte_t pte)
+{
 	pte_clear_bits(pte, _PAGE_ACCESSED);
 	return(pte);
 }
 
 static inline pte_t pte_wrprotect(pte_t pte)
-{ 
+{
 	if (likely(pte_get_bits(pte, _PAGE_RW)))
 		pte_clear_bits(pte, _PAGE_RW);
 	else
 		return pte;
-	return(pte_mknewprot(pte)); 
+	return(pte_mknewprot(pte));
 }
 
 static inline pte_t pte_mkread(pte_t pte)
-{ 
+{
 	if (unlikely(pte_get_bits(pte, _PAGE_USER)))
 		return pte;
 	pte_set_bits(pte, _PAGE_USER);
-	return(pte_mknewprot(pte)); 
+	return(pte_mknewprot(pte));
 }
 
 static inline pte_t pte_mkdirty(pte_t pte)
-{ 
+{
 	pte_set_bits(pte, _PAGE_DIRTY);
 	return(pte);
 }
@@ -220,20 +220,20 @@ static inline pte_t pte_mkyoung(pte_t pt
 	return(pte);
 }
 
-static inline pte_t pte_mkwrite(pte_t pte)	
+static inline pte_t pte_mkwrite(pte_t pte)
 {
 	if (unlikely(pte_get_bits(pte,  _PAGE_RW)))
 		return pte;
 	pte_set_bits(pte, _PAGE_RW);
-	return(pte_mknewprot(pte)); 
+	return(pte_mknewprot(pte));
 }
 
-static inline pte_t pte_mkuptodate(pte_t pte)	
+static inline pte_t pte_mkuptodate(pte_t pte)
 {
 	pte_clear_bits(pte, _PAGE_NEWPAGE);
 	if(pte_present(pte))
 		pte_clear_bits(pte, _PAGE_NEWPROT);
-	return(pte); 
+	return(pte);
 }
 
 static inline pte_t pte_mknewpage(pte_t pte)
@@ -288,30 +288,10 @@ static inline int pte_same(pte_t pte_a,
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
 	pte_set_val(pte, (pte_val(pte) & _PAGE_CHG_MASK), newprot);
-	return pte; 
+	return pte;
 }
 
 /*
- * the pgd page can be thought of an array like this: pgd_t[PTRS_PER_PGD]
- *
- * this macro returns the index of the entry in the pgd page which would
- * control the given virtual address
- */
-#define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
-
-/*
- * pgd_offset() returns a (pgd_t *)
- * pgd_index() is used get the offset into the pgd page's array of pgd_t's;
- */
-#define pgd_offset(mm, address) ((mm)->pgd+pgd_index(address))
-
-/*
- * a shortcut which implies the use of the kernel's pgd, instead
- * of a process's
- */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
-
-/*
  * the pmd page can be thought of an array like this: pmd_t[PTRS_PER_PMD]
  *
  * this macro returns the index of the entry in the pmd page which would
--- a/arch/unicore32/include/asm/pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/unicore32/include/asm/pgtable.h
@@ -215,14 +215,6 @@ PTE_BIT_FUNC(mkyoung,   |= PTE_YOUNG);
  */
 #define mk_pte(page, prot)	pfn_pte(page_to_pfn(page), prot)
 
-/* to find an entry in a page-table-directory */
-#define pgd_index(addr)		((addr) >> PGDIR_SHIFT)
-
-#define pgd_offset(mm, addr)	((mm)->pgd+pgd_index(addr))
-
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(addr)	pgd_offset(&init_mm, addr)
-
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
 	const unsigned long mask = PTE_EXEC | PTE_WRITE | PTE_READ;
--- a/arch/x86/include/asm/pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/x86/include/asm/pgtable.h
@@ -989,30 +989,6 @@ static inline int pgd_none(pgd_t pgd)
 
 #endif	/* __ASSEMBLY__ */
 
-/*
- * the pgd page can be thought of an array like this: pgd_t[PTRS_PER_PGD]
- *
- * this macro returns the index of the entry in the pgd page which would
- * control the given virtual address
- */
-#define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
-
-/*
- * pgd_offset() returns a (pgd_t *)
- * pgd_index() is used get the offset into the pgd page's array of pgd_t's;
- */
-#define pgd_offset_pgd(pgd, address) (pgd + pgd_index((address)))
-/*
- * a shortcut to get a pgd_t in a given mm
- */
-#define pgd_offset(mm, address) pgd_offset_pgd((mm)->pgd, (address))
-/*
- * a shortcut which implies the use of the kernel's pgd, instead
- * of a process's
- */
-#define pgd_offset_k(address) pgd_offset(&init_mm, (address))
-
-
 #define KERNEL_PGD_BOUNDARY	pgd_index(PAGE_OFFSET)
 #define KERNEL_PGD_PTRS		(PTRS_PER_PGD - KERNEL_PGD_BOUNDARY)
 
--- a/arch/xtensa/include/asm/pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/arch/xtensa/include/asm/pgtable.h
@@ -359,14 +359,6 @@ ptep_set_wrprotect(struct mm_struct *mm,
 	update_pte(ptep, pte_wrprotect(pte));
 }
 
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(address)	pgd_offset(&init_mm, address)
-
-/* to find an entry in a page-table-directory */
-#define pgd_offset(mm,address)	((mm)->pgd + pgd_index(address))
-
-#define pgd_index(address)	((address) >> PGDIR_SHIFT)
-
 /*
  * Encode and decode a swap and file entry.
  */
--- a/include/linux/pgtable.h~mm-consolidate-pgd_index-and-pgd_offset_k-definitions
+++ a/include/linux/pgtable.h
@@ -61,6 +61,14 @@ static inline unsigned long pud_index(un
 #define pud_index pud_index
 #endif
 
+#ifndef pgd_index
+static inline unsigned long pgd_index(unsigned long address)
+{
+	return ((address >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1));
+}
+#define pgd_index pgd_index
+#endif
+
 #ifndef pte_offset_kernel
 static inline pte_t *pte_offset_kernel(pmd_t *pmd, unsigned long address)
 {
@@ -96,6 +104,24 @@ static inline pud_t *pud_offset(p4d_t *p
 #define pud_offset pud_offset
 #endif
 
+static inline pgd_t *pgd_offset_pgd(pgd_t *pgd, unsigned long address)
+{
+	return (pgd + pgd_index(address));
+};
+
+/*
+ * a shortcut to get a pgd_t in a given mm
+ */
+#ifndef pgd_offset
+#define pgd_offset(mm, address)		pgd_offset_pgd((mm)->pgd, (address))
+#endif
+
+/*
+ * a shortcut which implies the use of the kernel's pgd, instead
+ * of a process's
+ */
+#define pgd_offset_k(address)		pgd_offset(&init_mm, (address))
+
 /*
  * In many cases it is known that a virtual address is mapped at PMD or PTE
  * level, so instead of traversing all the page table levels, we can get a
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
