From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 59/93] mm: consolidate pte_index() and
 pte_offset_*() definitions
Date: Mon, 08 Jun 2020 21:33:10 -0700
Message-ID: <20200609043310.v9XyWaxbC%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgFIEdR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:33:17 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, bcain@codeaurora.org, bp@alien8.de, catalin.marinas@arm.com, chris@zankel.net, dalias@libc.org, davem@davemloft.net, deanbo422@gmail.com, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux-mm@kvack.org, linux@armlinux.org.uk, mattst88@gmail.com, mingo@redhat.com, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@linux.ibm.com, sfr@canb.auug.org.au, shorne@gmail.com, tglx@linutronix.de, tony.luck@intel.com, torvalds@linux-foundation.org, tsbogend@alpha.franken.de, vgupta@synopsys.com, will@kernel.org

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

[rppt@linux.ibm.com: v2]
  Link: http://lkml.kernel.org/r/20200514170327.31389-11-rppt@kernel.org
[rppt@linux.ibm.com: update]
  Link: http://lkml.kernel.org/r/20200514170327.31389-12-rppt@kernel.org
[rppt@linux.ibm.com: update]
  Link: http://lkml.kernel.org/r/20200514170327.31389-13-rppt@kernel.org
[akpm@linux-foundation.org: fix x86 warning]
[sfr@canb.auug.org.au: fix powerpc build]
  Link: http://lkml.kernel.org/r/20200607153443.GB738695@linux.ibm.com
Link: http://lkml.kernel.org/r/20200514170327.31389-10-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
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

 arch/alpha/include/asm/pgtable.h                |   14 --
 arch/arc/include/asm/pgtable.h                  |   22 ---
 arch/arm/include/asm/pgtable-2level.h           |    1 
 arch/arm/include/asm/pgtable-3level.h           |    7 -
 arch/arm/include/asm/pgtable-nommu.h            |    1 
 arch/arm/include/asm/pgtable.h                  |   23 ---
 arch/arm64/include/asm/pgtable.h                |   36 ++---
 arch/arm64/kernel/hibernate.c                   |    4 
 arch/arm64/mm/kasan_init.c                      |    2 
 arch/arm64/mm/mmu.c                             |    8 -
 arch/c6x/include/asm/pgtable.h                  |    1 
 arch/csky/include/asm/pgtable.h                 |   30 ----
 arch/hexagon/include/asm/pgtable.h              |   52 --------
 arch/ia64/include/asm/pgtable.h                 |   33 -----
 arch/m68k/include/asm/mcf_pgtable.h             |   23 ---
 arch/m68k/include/asm/motorola_pgalloc.h        |    2 
 arch/m68k/include/asm/motorola_pgtable.h        |   34 -----
 arch/m68k/include/asm/sun3_pgtable.h            |   24 ---
 arch/m68k/mm/init.c                             |    2 
 arch/microblaze/include/asm/pgtable.h           |   21 ---
 arch/mips/include/asm/pgtable-32.h              |   22 ---
 arch/mips/include/asm/pgtable-64.h              |   32 ----
 arch/mips/kvm/mmu.c                             |   20 +--
 arch/mips/kvm/trap_emul.c                       |    2 
 arch/nds32/include/asm/pgtable.h                |   18 --
 arch/nios2/include/asm/pgtable.h                |   22 ---
 arch/openrisc/include/asm/pgtable.h             |   31 ----
 arch/parisc/include/asm/pgtable.h               |   32 ----
 arch/parisc/kernel/pci-dma.c                    |    2 
 arch/powerpc/include/asm/book3s/32/pgtable.h    |   20 ---
 arch/powerpc/include/asm/book3s/64/pgtable.h    |   43 ------
 arch/powerpc/include/asm/nohash/32/pgtable.h    |   17 --
 arch/powerpc/include/asm/nohash/64/pgtable-4k.h |    4 
 arch/powerpc/include/asm/nohash/64/pgtable.h    |   22 ---
 arch/powerpc/include/asm/pgtable.h              |    7 +
 arch/riscv/include/asm/pgtable-64.h             |    7 -
 arch/riscv/include/asm/pgtable.h                |   20 ---
 arch/riscv/mm/init.c                            |   30 ++--
 arch/s390/include/asm/pgtable.h                 |   13 --
 arch/s390/mm/pageattr.c                         |    2 
 arch/sh/include/asm/pgtable-3level.h            |    7 -
 arch/sh/include/asm/pgtable_32.h                |   25 ---
 arch/sparc/include/asm/pgalloc_64.h             |    2 
 arch/sparc/include/asm/pgtable_32.h             |   32 +---
 arch/sparc/include/asm/pgtable_64.h             |   31 ----
 arch/um/include/asm/pgtable-3level.h            |    4 
 arch/um/include/asm/pgtable.h                   |   67 ++--------
 arch/unicore32/include/asm/pgtable.h            |   17 --
 arch/x86/include/asm/pgtable.h                  |   71 ----------
 arch/x86/include/asm/pgtable_32.h               |   11 -
 arch/x86/include/asm/pgtable_64.h               |    4 
 arch/xtensa/include/asm/pgtable.h               |   18 --
 include/asm-generic/pgtable-nopmd.h             |    1 
 include/asm-generic/pgtable-nopud.h             |    1 
 include/linux/pgtable.h                         |   91 ++++++++++++++
 55 files changed, 228 insertions(+), 860 deletions(-)

--- a/arch/alpha/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
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
@@ -305,6 +296,7 @@ extern inline pmd_t * pmd_offset(pud_t *
 	smp_read_barrier_depends(); /* see above */
 	return ret;
 }
+#define pmd_offset pmd_offset
 
 /* Find an entry in the third-level page table.. */
 extern inline pte_t * pte_offset_kernel(pmd_t * dir, unsigned long address)
@@ -314,9 +306,7 @@ extern inline pte_t * pte_offset_kernel(
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
@@ -332,13 +317,6 @@ static inline void set_pte_at(struct mm_
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
@@ -568,11 +566,13 @@ static inline phys_addr_t pud_page_paddr
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
@@ -626,11 +626,13 @@ static inline phys_addr_t p4d_page_paddr
 	return __p4d_to_phys(p4d);
 }
 
-/* Find an entry in the frst-level page table. */
-#define pud_index(addr)		(((addr) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
+static inline unsigned long p4d_page_vaddr(p4d_t p4d)
+{
+	return (unsigned long)__va(p4d_page_paddr(p4d));
+}
 
+/* Find an entry in the frst-level page table. */
 #define pud_offset_phys(dir, addr)	(p4d_page_paddr(READ_ONCE(*(dir))) + pud_index(addr) * sizeof(pud_t))
-#define pud_offset(dir, addr)		((pud_t *)__va(pud_offset_phys((dir), (addr))))
 
 #define pud_set_fixmap(addr)		((pud_t *)set_fixmap_offset(FIX_PUD, addr))
 #define pud_set_fixmap_offset(p4d, addr)	pud_set_fixmap(pud_offset_phys(p4d, addr))
@@ -657,16 +659,6 @@ static inline phys_addr_t p4d_page_paddr
 
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
 
--- a/arch/arm64/kernel/hibernate.c~mm-consolidate-pte_index-and-pte_offset_-definitions
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
--- a/arch/arm64/mm/kasan_init.c~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/arm64/mm/kasan_init.c
@@ -190,7 +190,7 @@ void __init kasan_copy_shadow(pgd_t *pgd
 
 	pgdp = pgd_offset_k(KASAN_SHADOW_START);
 	pgdp_end = pgd_offset_k(KASAN_SHADOW_END);
-	pgdp_new = pgd_offset_raw(pgdir, KASAN_SHADOW_START);
+	pgdp_new = pgd_offset_pgd(pgdir, KASAN_SHADOW_START);
 	do {
 		set_pgd(pgdp_new, READ_ONCE(*pgdp));
 	} while (pgdp++, pgdp_new++, pgdp != pgdp_end);
--- a/arch/arm64/mm/mmu.c~mm-consolidate-pte_index-and-pte_offset_-definitions
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
--- a/arch/arm/include/asm/pgtable-2level.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/arm/include/asm/pgtable-2level.h
@@ -187,6 +187,7 @@ static inline pmd_t *pmd_offset(pud_t *p
 {
 	return (pmd_t *)pud;
 }
+#define pmd_offset pmd_offset
 
 #define pmd_large(pmd)		(pmd_val(pmd) & 2)
 #define pmd_leaf(pmd)		(pmd_val(pmd) & 2)
--- a/arch/arm/include/asm/pgtable-3level.h~mm-consolidate-pte_index-and-pte_offset_-definitions
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
--- a/arch/arm/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
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
@@ -183,21 +175,6 @@ static inline pte_t *pmd_page_vaddr(pmd_
 
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
 
--- a/arch/arm/include/asm/pgtable-nommu.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/arm/include/asm/pgtable-nommu.h
@@ -22,7 +22,6 @@
 #define pgd_bad(pgd)		(0)
 #define pgd_clear(pgdp)
 #define kern_addr_valid(addr)	(1)
-#define	pmd_offset(a, b)	((void *)0)
 /* FIXME */
 /*
  * PMD_SHIFT determines the size of the area a second-level page table can map
--- a/arch/c6x/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/c6x/include/asm/pgtable.h
@@ -26,7 +26,6 @@
 #define pgd_clear(pgdp)
 #define kern_addr_valid(addr) (1)
 
-#define pmd_offset(a, b)	((void *)0)
 #define pmd_none(x)		(!pmd_val(x))
 #define pmd_present(x)		(pmd_val(x))
 #define pmd_clear(xp)		do { set_pmd(xp, __pmd(0)); } while (0)
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
@@ -229,14 +220,6 @@ static inline pte_t pte_mkyoung(pte_t pt
 	return pte;
 }
 
-#define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
-#define pmd_index(address)	(((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
-
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(address)	pgd_offset(&init_mm, address)
-
-#define pgd_index(address)	((address) >> PGDIR_SHIFT)
-
 #define __HAVE_PHYS_MEM_ACCESS_PROT
 struct file;
 extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
@@ -280,19 +263,6 @@ static inline pte_t pte_modify(pte_t pte
 		     (pgprot_val(newprot)));
 }
 
-/* to find an entry in a page-table-directory */
-static inline pgd_t *pgd_offset(struct mm_struct *mm, unsigned long address)
-{
-	return mm->pgd + pgd_index(address);
-}
-
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
@@ -206,33 +206,6 @@ static inline void pte_clear(struct mm_s
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
-/**
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
 /**
  * pmd_none - check if pmd_entry is mapped
  * @pmd_entry:  pmd entry
@@ -403,31 +376,14 @@ static inline int pte_exec(pte_t pte)
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
@@ -364,44 +364,13 @@ pgd_index (unsigned long address)
 
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
    here.  */
 #define pgd_offset_gate(mm, addr)	pgd_offset_k(addr)
 
-#if CONFIG_PGTABLE_LEVELS == 4
-/* Find an entry in the second-level page table.. */
-#define pud_offset(dir,addr) \
-	((pud_t *) p4d_page_vaddr(*(dir)) + (((addr) >> PUD_SHIFT) & (PTRS_PER_PUD - 1)))
-#endif
-
-/* Find an entry in the third-level page table.. */
-#define pmd_offset(dir,addr) \
-	((pmd_t *) pud_page_vaddr(*(dir)) + (((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1)))
-
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
@@ -311,24 +311,6 @@ static inline pte_t pte_mkcache(pte_t pt
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
@@ -340,9 +322,6 @@ extern pgd_t kernel_pg_dir[PTRS_PER_PGD]
 
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
 
 
@@ -192,41 +192,9 @@ static inline pte_t pte_mkcache(pte_t pt
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
-
-/* Find an entry in the second-level page table.. */
-static inline pmd_t *pmd_offset(pud_t *dir, unsigned long address)
-{
-	return (pmd_t *)pud_page_vaddr(*dir) + ((address >> PMD_SHIFT) & (PTRS_PER_PMD-1));
-}
-
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
@@ -171,21 +174,6 @@ static inline pte_t pte_mkcache(pte_t pt
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
@@ -21,7 +21,6 @@ extern int mem_init_done;
 #define pgd_bad(pgd)		(0)
 #define pgd_clear(pgdp)
 #define kern_addr_valid(addr)	(1)
-#define	pmd_offset(a, b)	((void *) 0)
 
 #define PAGE_NONE		__pgprot(0) /* these mean nothing to non MMU */
 #define PAGE_SHARED		__pgprot(0) /* these mean nothing to non MMU */
@@ -438,27 +437,15 @@ static inline void ptep_mkdirty(struct m
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
 
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
-
-/* to find an entry in a page-table-directory */
-#define pgd_index(address)	 ((address) >> PGDIR_SHIFT)
-#define pgd_offset(mm, address)	 ((mm)->pgd + pgd_index(address))
-
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
@@ -195,28 +195,6 @@ static inline pte_t pfn_pte(unsigned lon
 
 #define pte_page(x)		pfn_to_page(pte_pfn(x))
 
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
-
-#define pgd_index(address)	(((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
-#define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
-#define pmd_index(address)	(((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
-
-/* to find an entry in a page-table-directory */
-#define pgd_offset(mm, addr)	((mm)->pgd + pgd_index(addr))
-
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
@@ -172,8 +172,6 @@
 
 extern pte_t invalid_pte_table[PTRS_PER_PTE];
 
-#define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
-
 #ifndef __PAGETABLE_PUD_FOLDED
 /*
  * For 4-level pagetables we defines these ourselves, for 3-level the
@@ -222,11 +220,6 @@ static inline unsigned long p4d_page_vad
 
 #define p4d_index(address)	(((address) >> P4D_SHIFT) & (PTRS_PER_P4D - 1))
 
-static inline pud_t *pud_offset(p4d_t *p4d, unsigned long address)
-{
-	return (pud_t *)p4d_page_vaddr(*p4d) + pud_index(address);
-}
-
 static inline void set_p4d(p4d_t *p4d, p4d_t p4dval)
 {
 	*p4d = p4dval;
@@ -320,15 +313,6 @@ static inline void pud_clear(pud_t *pudp
 #define pfn_pmd(pfn, prot)	__pmd(((pfn) << _PFN_SHIFT) | pgprot_val(prot))
 #endif
 
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
-
-#define pgd_index(address)	(((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
-#define pmd_index(address)	(((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
-
-/* to find an entry in a page-table-directory */
-#define pgd_offset(mm, addr)	((mm)->pgd + pgd_index(addr))
-
 #ifndef __PAGETABLE_PMD_FOLDED
 static inline unsigned long pud_page_vaddr(pud_t pud)
 {
@@ -337,24 +321,8 @@ static inline unsigned long pud_page_vad
 #define pud_phys(pud)		virt_to_phys((void *)pud_val(pud))
 #define pud_page(pud)		(pfn_to_page(pud_phys(pud) >> PAGE_SHIFT))
 
-/* Find an entry in the second-level page table.. */
-static inline pmd_t *pmd_offset(pud_t * pud, unsigned long address)
-{
-	return (pmd_t *) pud_page_vaddr(*pud) + pmd_index(address);
-}
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
@@ -344,12 +340,6 @@ static inline pmd_t __mk_pmd(pte_t * pte
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
--- a/arch/nios2/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
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
@@ -236,27 +232,17 @@ static inline void pte_clear(struct mm_s
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
-
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(addr)	pgd_offset(&init_mm, addr)
-
-/* Get the address to the PTE for a vaddr in specific directory */
-#define pte_offset_kernel(dir, addr)			\
-	((pte_t *) pmd_page_vaddr(*(dir)) +		\
-	 (((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)))
+static inline unsigned long pmd_page_vaddr(pmd_t pmd)
+{
+	return pmd_val(pmd);
+}
 
 #define pte_ERROR(e) \
 	pr_err("%s:%d: bad pte %08lx.\n", \
--- a/arch/openrisc/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/openrisc/include/asm/pgtable.h
@@ -363,38 +363,15 @@ static inline void pmd_set(pmd_t *pmdp,
 }
 
 #define pmd_page(pmd)		(pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT))
-#define pmd_page_kernel(pmd)    ((unsigned long) __va(pmd_val(pmd) & PAGE_MASK))
 
-/* to find an entry in a page-table-directory. */
-#define pgd_index(address)      ((address >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
-
-#define __pgd_offset(address)   pgd_index(address)
-
-#define pgd_offset(mm, address) ((mm)->pgd+pgd_index(address))
-
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
+static inline unsigned long pmd_page_vaddr(pmd_t pmd)
+{
+	return ((unsigned long) __va(pmd_val(pmd) & PAGE_MASK));
+}
 
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
@@ -427,40 +427,16 @@ static inline pte_t pte_modify(pte_t pte
 
 #define pte_page(pte)		(pfn_to_page(pte_pfn(pte)))
 
-#define pmd_page_vaddr(pmd)	((unsigned long) __va(pmd_address(pmd)))
+static inline unsigned long pmd_page_vaddr(pmd_t pmd)
+{
+	return ((unsigned long) __va(pmd_address(pmd)));
+}
 
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
 
-#if CONFIG_PGTABLE_LEVELS == 3
-#define pmd_index(addr)         (((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
-#define pmd_offset(dir,address) \
-((pmd_t *) pud_page_vaddr(*(dir)) + pmd_index(address))
-#else
-#define pmd_offset(dir,addr) ((pmd_t *) dir)
-#endif
-
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
--- a/arch/parisc/kernel/pci-dma.c~mm-consolidate-pte_index-and-pte_offset_-definitions
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
@@ -332,26 +335,9 @@ static inline void __ptep_set_access_fla
 #define __HAVE_ARCH_PTE_SAME
 #define pte_same(A,B)	(((pte_val(A) ^ pte_val(B)) & ~_PAGE_HASHPTE) == 0)
 
-#define pmd_page_vaddr(pmd)	\
-	((unsigned long)__va(pmd_val(pmd) & ~(PTE_TABLE_SIZE - 1)))
 #define pmd_page(pmd)		\
 	pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT)
 
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
-
-/* to find an entry in a page-table-directory */
-#define pgd_index(address)	 ((address) >> PGDIR_SHIFT)
-#define pgd_offset(mm, address)	 ((mm)->pgd + pgd_index(address))
-
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
@@ -1005,52 +1005,9 @@ extern struct page *p4d_page(p4d_t p4d);
 /* Pointers in the page table tree are physical addresses */
 #define __pgtable_ptr_val(ptr)	__pa(ptr)
 
-#define pmd_page_vaddr(pmd)	__va(pmd_val(pmd) & ~PMD_MASKED_BITS)
 #define pud_page_vaddr(pud)	__va(pud_val(pud) & ~PUD_MASKED_BITS)
 #define p4d_page_vaddr(p4d)	__va(p4d_val(p4d) & ~P4D_MASKED_BITS)
 
-static inline unsigned long pgd_index(unsigned long address)
-{
-	return (address >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1);
-}
-
-static inline unsigned long pud_index(unsigned long address)
-{
-	return (address >> PUD_SHIFT) & (PTRS_PER_PUD - 1);
-}
-
-static inline unsigned long pmd_index(unsigned long address)
-{
-	return (address >> PMD_SHIFT) & (PTRS_PER_PMD - 1);
-}
-
-static inline unsigned long pte_index(unsigned long address)
-{
-	return (address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
-}
-
-/*
- * Find an entry in a page-table-directory.  We combine the address region
- * (the high order N bits) and the pgd portion of the address.
- */
-
-#define pgd_offset(mm, address)	 ((mm)->pgd + pgd_index(address))
-
-#define pud_offset(p4dp, addr)	\
-	(((pud_t *) p4d_page_vaddr(*(p4dp))) + pud_index(addr))
-#define pmd_offset(pudp,addr) \
-	(((pmd_t *) pud_page_vaddr(*(pudp))) + pmd_index(addr))
-#define pte_offset_kernel(dir,addr) \
-	(((pte_t *) pmd_page_vaddr(*(dir))) + pte_index(addr))
-
-#define pte_offset_map(dir,addr)	pte_offset_kernel((dir), (addr))
-
-static inline void pte_unmap(pte_t *pte) { }
-
-/* to find an entry in a kernel page-table-directory */
-/* This now only contains the vmalloc pages */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
-
 #define pte_ERROR(e) \
 	pr_err("%s:%d: bad pte %08lx.\n", __FILE__, __LINE__, pte_val(e))
 #define pmd_ERROR(e) \
--- a/arch/powerpc/include/asm/nohash/32/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/powerpc/include/asm/nohash/32/pgtable.h
@@ -28,6 +28,8 @@ extern int icache_44x_need_flush;
 #define PMD_TABLE_SIZE	0
 #define PUD_TABLE_SIZE	0
 #define PGD_TABLE_SIZE	(sizeof(pgd_t) << PGD_INDEX_SIZE)
+
+#define PMD_MASKED_BITS (PTE_TABLE_SIZE - 1)
 #endif	/* __ASSEMBLY__ */
 
 #define PTRS_PER_PTE	(1 << PTE_INDEX_SIZE)
@@ -203,10 +205,6 @@ static inline void pmd_clear(pmd_t *pmdp
 	*pmdp = __pmd(0);
 }
 
-
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
-
 /* to find an entry in a page-table-directory */
 #define pgd_index(address)	 ((address) >> PGDIR_SHIFT)
 #define pgd_offset(mm, address)	 ((mm)->pgd + pgd_index(address))
@@ -330,8 +328,6 @@ static inline int pte_young(pte_t pte)
  * of the pte page.  -- paulus
  */
 #ifndef CONFIG_BOOKE
-#define pmd_page_vaddr(pmd)	\
-	((unsigned long)__va(pmd_val(pmd) & ~(PTE_TABLE_SIZE - 1)))
 #define pmd_page(pmd)		\
 	pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT)
 #else
@@ -341,15 +337,6 @@ static inline int pte_young(pte_t pte)
 	pfn_to_page((__pa(pmd_val(pmd)) >> PAGE_SHIFT))
 #endif
 
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
--- a/arch/powerpc/include/asm/nohash/64/pgtable-4k.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/powerpc/include/asm/nohash/64/pgtable-4k.h
@@ -78,10 +78,6 @@ extern struct page *p4d_page(p4d_t p4d);
 
 #endif /* !__ASSEMBLY__ */
 
-#define pud_offset(p4dp, addr)	\
-  (((pud_t *) p4d_page_vaddr(*(p4dp))) + \
-    (((addr) >> PUD_SHIFT) & (PTRS_PER_PUD - 1)))
-
 #define pud_ERROR(e) \
 	pr_err("%s:%d: bad pud %08lx.\n", __FILE__, __LINE__, pud_val(e))
 
--- a/arch/powerpc/include/asm/nohash/64/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/powerpc/include/asm/nohash/64/pgtable.h
@@ -182,28 +182,6 @@ static inline void p4d_set(p4d_t *p4dp,
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
-#define pmd_offset(pudp,addr) \
-  (((pmd_t *) pud_page_vaddr(*(pudp))) + (((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1)))
-
-#define pte_offset_kernel(dir,addr) \
-  (((pte_t *) pmd_page_vaddr(*(dir))) + (((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)))
-
-#define pte_offset_map(dir,addr)	pte_offset_kernel((dir), (addr))
-
-static inline void pte_unmap(pte_t *pte) { }
-
-/* to find an entry in a kernel page-table-directory */
-/* This now only contains the vmalloc pages */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
-
 /* Atomic PTE updates */
 static inline unsigned long pte_update(struct mm_struct *mm,
 				       unsigned long addr,
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
--- a/arch/riscv/include/asm/pgtable-64.h~mm-consolidate-pte_index-and-pte_offset_-definitions
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
--- a/arch/riscv/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
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
@@ -209,16 +199,6 @@ static inline pte_t pfn_pte(unsigned lon
 
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
 
--- a/arch/s390/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/arch/s390/include/asm/pgtable.h
@@ -1229,7 +1229,6 @@ static inline pte_t mk_pte(struct page *
 #define p4d_index(address) (((address) >> P4D_SHIFT) & (PTRS_PER_P4D-1))
 #define pud_index(address) (((address) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
 #define pmd_index(address) (((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
-#define pte_index(address) (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE-1))
 
 #define pmd_deref(pmd) (pmd_val(pmd) & _SEGMENT_ENTRY_ORIGIN)
 #define pud_deref(pud) (pud_val(pud) & _REGION_ENTRY_ORIGIN)
@@ -1260,7 +1259,6 @@ static inline pgd_t *pgd_offset_raw(pgd_
 }
 
 #define pgd_offset(mm, address) pgd_offset_raw(READ_ONCE((mm)->pgd), address)
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
 
 static inline p4d_t *p4d_offset(pgd_t *pgd, unsigned long address)
 {
@@ -1275,6 +1273,7 @@ static inline pud_t *pud_offset(p4d_t *p
 		return (pud_t *) p4d_deref(*p4d) + pud_index(address);
 	return (pud_t *) p4d;
 }
+#define pud_offset pud_offset
 
 static inline pmd_t *pmd_offset(pud_t *pud, unsigned long address)
 {
@@ -1282,17 +1281,13 @@ static inline pmd_t *pmd_offset(pud_t *p
 		return (pmd_t *) pud_deref(*pud) + pmd_index(address);
 	return (pmd_t *) pud;
 }
+#define pmd_offset pmd_offset
 
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
@@ -401,27 +401,12 @@ static inline pte_t pte_modify(pte_t pte
 	return pte;
 }
 
-#define pmd_page_vaddr(pmd)	((unsigned long)pmd_val(pmd))
-#define pmd_page(pmd)		(virt_to_page(pmd_val(pmd)))
-
-/* to find an entry in a page-table-directory. */
-#define pgd_index(address)	(((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
-#define pgd_offset(mm, address)	((mm)->pgd + pgd_index(address))
-
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(address)	pgd_offset(&init_mm, address)
-
-#define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
-#define pmd_index(address)	(((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
-
-/* Find an entry in the third-level page table.. */
-#define pte_index(address)	((address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-#define __pte_offset(address)	pte_index(address)
+static inline unsigned long pmd_page_vaddr(pmd_t pmd)
+{
+	return (unsigned long)pmd_val(pmd);
+}
 
-#define pte_offset_kernel(dir, address) \
-	((pte_t *) pmd_page_vaddr(*(dir)) + pte_index(address))
-#define pte_offset_map(dir, address)		pte_offset_kernel(dir, address)
-#define pte_unmap(pte)		do { } while (0)
+#define pmd_page(pmd)		(virt_to_page(pmd_val(pmd)))
 
 #ifdef CONFIG_X2TLB
 #define pte_ERROR(e) \
--- a/arch/sh/include/asm/pgtable-3level.h~mm-consolidate-pte_index-and-pte_offset_-definitions
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
@@ -315,30 +321,6 @@ static inline pte_t pte_modify(pte_t pte
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
-/* Find an entry in the second-level page table.. */
-static inline pmd_t *pmd_offset(pud_t * dir, unsigned long address)
-{
-	return (pmd_t *) pud_page_vaddr(*dir) +
-		((address >> PMD_SHIFT) & (PTRS_PER_PMD - 1));
-}
-
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
 
@@ -427,7 +409,7 @@ static inline int io_remap_pfn_range(str
 
 	return remap_pfn_range(vma, from, phys_base >> PAGE_SHIFT, size, prot);
 }
-#define io_remap_pfn_range io_remap_pfn_range 
+#define io_remap_pfn_range io_remap_pfn_range
 
 #define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 #define ptep_set_access_flags(__vma, __address, __ptep, __entry, __dirty) \
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
@@ -889,31 +889,6 @@ static inline unsigned long pud_pfn(pud_
 #define p4d_set(p4dp, pudp)	\
 	(p4d_val(*(p4dp)) = (__pa((unsigned long) (pudp))))
 
-/* to find an entry in a page-table-directory. */
-#define pgd_index(address)	(((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
-#define pgd_offset(mm, address)	((mm)->pgd + pgd_index(address))
-
-/* to find an entry in a kernel page-table-directory */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
-
-/* Find an entry in the third-level page table.. */
-#define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
-#define pud_offset(p4dp, address)	\
-	((pud_t *) p4d_page_vaddr(*(p4dp)) + pud_index(address))
-
-/* Find an entry in the second-level page table.. */
-#define pmd_offset(pudp, address)	\
-	((pmd_t *) pud_page_vaddr(*(pudp)) + \
-	 (((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1)))
-
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
 
@@ -1078,7 +1053,7 @@ static inline int io_remap_pfn_range(str
 
 	return remap_pfn_range(vma, from, phys_base >> PAGE_SHIFT, size, prot);
 }
-#define io_remap_pfn_range io_remap_pfn_range 
+#define io_remap_pfn_range io_remap_pfn_range
 
 static inline unsigned long __untagged_addr(unsigned long start)
 {
--- a/arch/um/include/asm/pgtable-3level.h~mm-consolidate-pte_index-and-pte_offset_-definitions
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
--- a/arch/um/include/asm/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
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
@@ -288,53 +288,16 @@ static inline int pte_same(pte_t pte_a,
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
  * control the given virtual address
  */
 #define pmd_page_vaddr(pmd) ((unsigned long) __va(pmd_val(pmd) & PAGE_MASK))
-#define pmd_index(address) (((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
-
-#define pmd_page_vaddr(pmd) \
-	((unsigned long) __va(pmd_val(pmd) & PAGE_MASK))
-
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
 
@@ -221,17 +215,6 @@ PTE_BIT_FUNC(mkyoung,   |= PTE_YOUNG);
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
@@ -856,25 +845,6 @@ static inline unsigned long pmd_index(un
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
@@ -907,12 +877,6 @@ static inline unsigned long pud_page_vad
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
@@ -932,11 +896,6 @@ static inline int pud_large(pud_t pud)
 }
 #endif	/* CONFIG_PGTABLE_LEVELS > 2 */
 
-static inline unsigned long pud_index(unsigned long address)
-{
-	return (address >> PUD_SHIFT) & (PTRS_PER_PUD - 1);
-}
-
 #if CONFIG_PGTABLE_LEVELS > 3
 static inline int p4d_none(p4d_t p4d)
 {
@@ -959,12 +918,6 @@ static inline unsigned long p4d_page_vad
  */
 #define p4d_page(p4d)	pfn_to_page(p4d_pfn(p4d))
 
-/* Find an entry in the third-level page table.. */
-static inline pud_t *pud_offset(p4d_t *p4d, unsigned long address)
-{
-	return (pud_t *)p4d_page_vaddr(*p4d) + pud_index(address);
-}
-
 static inline int p4d_bad(p4d_t p4d)
 {
 	unsigned long ignore_flags = _KERNPG_TABLE | _PAGE_USER;
@@ -1037,30 +990,6 @@ static inline int pgd_none(pgd_t pgd)
 
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
@@ -359,22 +359,6 @@ ptep_set_wrprotect(struct mm_struct *mm,
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
--- a/include/asm-generic/pgtable-nopmd.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/include/asm-generic/pgtable-nopmd.h
@@ -45,6 +45,7 @@ static inline pmd_t * pmd_offset(pud_t *
 {
 	return (pmd_t *)pud;
 }
+#define pmd_offset pmd_offset
 
 #define pmd_val(x)				(pud_val((x).pud))
 #define __pmd(x)				((pmd_t) { __pud(x) } )
--- a/include/asm-generic/pgtable-nopud.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/include/asm-generic/pgtable-nopud.h
@@ -43,6 +43,7 @@ static inline pud_t *pud_offset(p4d_t *p
 {
 	return (pud_t *)p4d;
 }
+#define pud_offset pud_offset
 
 #define pud_val(x)				(p4d_val((x).p4d))
 #define __pud(x)				((pud_t) { __p4d(x) })
--- a/include/linux/pgtable.h~mm-consolidate-pte_index-and-pte_offset_-definitions
+++ a/include/linux/pgtable.h
@@ -29,6 +29,97 @@
 #endif
 
 /*
+ * A page table page can be thought of an array like this: pXd_t[PTRS_PER_PxD]
+ *
+ * The pXx_index() functions return the index of the entry in the page
+ * table page which would control the given virtual address
+ *
+ * As these functions may be used by the same code for different levels of
+ * the page table folding, they are always available, regardless of
+ * CONFIG_PGTABLE_LEVELS value. For the folded levels they simply return 0
+ * because in such cases PTRS_PER_PxD equals 1.
+ */
+
+static inline unsigned long pte_index(unsigned long address)
+{
+	return (address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
+}
+
+#ifndef pmd_index
+static inline unsigned long pmd_index(unsigned long address)
+{
+	return (address >> PMD_SHIFT) & (PTRS_PER_PMD - 1);
+}
+#define pmd_index pmd_index
+#endif
+
+#ifndef pud_index
+static inline unsigned long pud_index(unsigned long address)
+{
+	return (address >> PUD_SHIFT) & (PTRS_PER_PUD - 1);
+}
+#define pud_index pud_index
+#endif
+
+#ifndef pgd_index
+/* Must be a compile-time constant, so implement it as a macro */
+#define pgd_index(a)  (((a) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
+#endif
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
+/* Find an entry in the second-level page table.. */
+#ifndef pmd_offset
+static inline pmd_t *pmd_offset(pud_t *pud, unsigned long address)
+{
+	return (pmd_t *)pud_page_vaddr(*pud) + pmd_index(address);
+}
+#define pmd_offset pmd_offset
+#endif
+
+#ifndef pud_offset
+static inline pud_t *pud_offset(p4d_t *p4d, unsigned long address)
+{
+	return (pud_t *)p4d_page_vaddr(*p4d) + pud_index(address);
+}
+#define pud_offset pud_offset
+#endif
+
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
+/*
  * In many cases it is known that a virtual address is mapped at PMD or PTE
  * level, so instead of traversing all the page table levels, we can get a
  * pointer to the PMD entry in user or kernel page table or translate a virtual
_
