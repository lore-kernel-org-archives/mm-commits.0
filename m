From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 58/93] mm: pgtable: add shortcuts for accessing
 kernel PMD and PTE
Date: Mon, 08 Jun 2020 21:33:05 -0700
Message-ID: <20200609043305.Mix1qSGey%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgFIEdI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:33:08 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, bcain@codeaurora.org, bp@alien8.de, catalin.marinas@arm.com, chris@zankel.net, dalias@libc.org, davem@davemloft.net, deanbo422@gmail.com, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux-mm@kvack.org, linux@armlinux.org.uk, mattst88@gmail.com, mingo@redhat.com, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@linux.ibm.com, shorne@gmail.com, tglx@linutronix.de, tony.luck@intel.com, torvalds@linux-foundation.org, tsbogend@alpha.franken.de, vgupta@synopsys.com, will@kernel.org, willy@infradead.orgy

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: pgtable: add shortcuts for accessing kernel PMD and PTE

The powerpc 32-bit implementation of pgtable has nice shortcuts for
accessing kernel PMD and PTE for a given virtual address.  Make these
helpers available for all architectures.

[rppt@linux.ibm.com: microblaze: fix page table traversal in setup_rt_frame()]
  Link: http://lkml.kernel.org/r/20200518191511.GD1118872@kernel.org
[akpm@linux-foundation.org: s/pmd_ptr_k/pmd_off_k/ in various powerpc places]
Link: http://lkml.kernel.org/r/20200514170327.31389-9-rppt@kernel.org
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

 arch/arc/mm/highmem.c                 |   10 -------
 arch/arm/mach-sa1100/assabet.c        |    2 -
 arch/arm/mm/highmem.c                 |    4 +--
 arch/arm/mm/ioremap.c                 |   31 +++---------------------
 arch/arm/mm/mm.h                      |    5 ---
 arch/arm/mm/mmu.c                     |    7 -----
 arch/hexagon/include/asm/fixmap.h     |    4 ---
 arch/m68k/mm/motorola.c               |   22 +----------------
 arch/microblaze/kernel/signal.c       |    8 ------
 arch/microblaze/mm/init.c             |    9 ------
 arch/mips/include/asm/fixmap.h        |    3 --
 arch/mips/mm/c-r3k.c                  |   10 +------
 arch/mips/mm/c-r4k.c                  |   10 +------
 arch/mips/mm/c-tx39.c                 |   10 +------
 arch/mips/mm/highmem.c                |    2 -
 arch/nds32/include/asm/pgtable.h      |    2 -
 arch/nds32/mm/init.c                  |   13 +---------
 arch/nds32/mm/proc.c                  |    6 ----
 arch/parisc/mm/fixmap.c               |    6 ----
 arch/powerpc/include/asm/pgtable.h    |   19 --------------
 arch/powerpc/mm/book3s32/mmu.c        |    2 -
 arch/powerpc/mm/book3s32/tlb.c        |    4 +--
 arch/powerpc/mm/kasan/8xx.c           |    4 +--
 arch/powerpc/mm/kasan/book3s_32.c     |    2 -
 arch/powerpc/mm/kasan/kasan_init_32.c |    8 +++---
 arch/powerpc/mm/nohash/40x.c          |    4 +--
 arch/powerpc/mm/nohash/8xx.c          |    2 -
 arch/powerpc/mm/pgtable_32.c          |    4 +--
 arch/s390/mm/pageattr.c               |   10 -------
 arch/sh/mm/cache-sh4.c                |    8 ------
 arch/sh/mm/kmap.c                     |    5 ---
 arch/sparc/mm/highmem.c               |   12 +--------
 arch/sparc/mm/init_64.c               |    6 ----
 arch/sparc/mm/io-unit.c               |   10 +------
 arch/sparc/mm/iommu.c                 |    8 ------
 arch/um/kernel/mem.c                  |   10 -------
 arch/um/kernel/trap.c                 |    8 ------
 arch/unicore32/mm/mm.h                |   10 -------
 arch/x86/mm/init_32.c                 |   26 ++------------------
 arch/xtensa/include/asm/fixmap.h      |    8 ------
 arch/xtensa/mm/highmem.c              |    2 -
 arch/xtensa/mm/kasan_init.c           |   10 +------
 arch/xtensa/mm/mmu.c                  |    5 ---
 include/linux/pgtable.h               |   24 ++++++++++++++++++
 44 files changed, 80 insertions(+), 295 deletions(-)

--- a/arch/arc/mm/highmem.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/arc/mm/highmem.c
@@ -92,17 +92,9 @@ EXPORT_SYMBOL(kunmap_atomic_high);
 
 static noinline pte_t * __init alloc_kmap_pgtable(unsigned long kvaddr)
 {
-	pgd_t *pgd_k;
-	p4d_t *p4d_k;
-	pud_t *pud_k;
-	pmd_t *pmd_k;
+	pmd_t *pmd_k = pmd_off_k(kvaddr);
 	pte_t *pte_k;
 
-	pgd_k = pgd_offset_k(kvaddr);
-	p4d_k = p4d_offset(pgd_k, kvaddr);
-	pud_k = pud_offset(p4d_k, kvaddr);
-	pmd_k = pmd_offset(pud_k, kvaddr);
-
 	pte_k = (pte_t *)memblock_alloc_low(PAGE_SIZE, PAGE_SIZE);
 	if (!pte_k)
 		panic("%s: Failed to allocate %lu bytes align=0x%lx\n",
--- a/arch/arm/mach-sa1100/assabet.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/arm/mach-sa1100/assabet.c
@@ -632,7 +632,7 @@ static void __init map_sa1100_gpio_regs(
 	int prot = PMD_TYPE_SECT | PMD_SECT_AP_WRITE | PMD_DOMAIN(DOMAIN_IO);
 	pmd_t *pmd;
 
-	pmd = pmd_offset(pud_offset(p4d_offset(pgd_offset_k(virt), virt), virt), virt);
+	pmd = pmd_off_k(virt);
 	*pmd = __pmd(phys | prot);
 	flush_pmd_entry(pmd);
 }
--- a/arch/arm/mm/highmem.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/arm/mm/highmem.c
@@ -18,7 +18,7 @@
 static inline void set_fixmap_pte(int idx, pte_t pte)
 {
 	unsigned long vaddr = __fix_to_virt(idx);
-	pte_t *ptep = pte_offset_kernel(pmd_off_k(vaddr), vaddr);
+	pte_t *ptep = virt_to_kpte(vaddr);
 
 	set_pte_ext(ptep, pte, 0);
 	local_flush_tlb_kernel_page(vaddr);
@@ -26,7 +26,7 @@ static inline void set_fixmap_pte(int id
 
 static inline pte_t get_fixmap_pte(unsigned long vaddr)
 {
-	pte_t *ptep = pte_offset_kernel(pmd_off_k(vaddr), vaddr);
+	pte_t *ptep = virt_to_kpte(vaddr);
 
 	return *ptep;
 }
--- a/arch/arm/mm/ioremap.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/arm/mm/ioremap.c
@@ -141,16 +141,8 @@ void __check_vmalloc_seq(struct mm_struc
 static void unmap_area_sections(unsigned long virt, unsigned long size)
 {
 	unsigned long addr = virt, end = virt + (size & ~(SZ_1M - 1));
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmdp;
-
-	flush_cache_vunmap(addr, end);
-	pgd = pgd_offset_k(addr);
-	p4d = p4d_offset(pgd, addr);
-	pud = pud_offset(p4d, addr);
-	pmdp = pmd_offset(pud, addr);
+	pmd_t *pmdp = pmd_off_k(addr);
+
 	do {
 		pmd_t pmd = *pmdp;
 
@@ -191,10 +183,7 @@ remap_area_sections(unsigned long virt,
 		    size_t size, const struct mem_type *type)
 {
 	unsigned long addr = virt, end = virt + size;
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
+	pmd_t *pmd = pmd_off_k(addr);
 
 	/*
 	 * Remove and free any PTE-based mapping, and
@@ -202,10 +191,6 @@ remap_area_sections(unsigned long virt,
 	 */
 	unmap_area_sections(virt, size);
 
-	pgd = pgd_offset_k(addr);
-	p4d = p4d_offset(pgd, addr);
-	pud = pud_offset(p4d, addr);
-	pmd = pmd_offset(pud, addr);
 	do {
 		pmd[0] = __pmd(__pfn_to_phys(pfn) | type->prot_sect);
 		pfn += SZ_1M >> PAGE_SHIFT;
@@ -225,21 +210,13 @@ remap_area_supersections(unsigned long v
 			 size_t size, const struct mem_type *type)
 {
 	unsigned long addr = virt, end = virt + size;
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
+	pmd_t *pmd = pmd_off_k(addr);
 
 	/*
 	 * Remove and free any PTE-based mapping, and
 	 * sync the current kernel mapping.
 	 */
 	unmap_area_sections(virt, size);
-
-	pgd = pgd_offset_k(virt);
-	p4d = p4d_offset(pgd, addr);
-	pud = pud_offset(p4d, addr);
-	pmd = pmd_offset(pud, addr);
 	do {
 		unsigned long super_pmd_val, i;
 
--- a/arch/arm/mm/mm.h~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/arm/mm/mm.h
@@ -35,11 +35,6 @@ static inline pte_t get_top_pte(unsigned
 	return *ptep;
 }
 
-static inline pmd_t *pmd_off_k(unsigned long virt)
-{
-	return pmd_offset(pud_offset(p4d_offset(pgd_offset_k(virt), virt), virt), virt);
-}
-
 struct mem_type {
 	pteval_t prot_pte;
 	pteval_t prot_pte_s2;
--- a/arch/arm/mm/mmu.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/arm/mm/mmu.c
@@ -356,12 +356,7 @@ static pte_t *pte_offset_late_fixmap(pmd
 
 static inline pmd_t * __init fixmap_pmd(unsigned long addr)
 {
-	pgd_t *pgd = pgd_offset_k(addr);
-	p4d_t *p4d = p4d_offset(pgd, addr);
-	pud_t *pud = pud_offset(p4d, addr);
-	pmd_t *pmd = pmd_offset(pud, addr);
-
-	return pmd;
+	return pmd_off_k(addr);
 }
 
 void __init early_fixmap_init(void)
--- a/arch/hexagon/include/asm/fixmap.h~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/hexagon/include/asm/fixmap.h
@@ -15,8 +15,4 @@
 
 #include <asm-generic/fixmap.h>
 
-#define kmap_get_fixmap_pte(vaddr) \
-	pte_offset_kernel(pmd_offset(pud_offset(p4d_offset(pgd_offset_k(vaddr), \
-				(vaddr)), (vaddr)), (vaddr)), (vaddr))
-
 #endif
--- a/arch/m68k/mm/motorola.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/m68k/mm/motorola.c
@@ -54,17 +54,8 @@ static inline void nocache_page(void *va
 	unsigned long addr = (unsigned long)vaddr;
 
 	if (CPU_IS_040_OR_060) {
-		pgd_t *dir;
-		p4d_t *p4dp;
-		pud_t *pudp;
-		pmd_t *pmdp;
-		pte_t *ptep;
+		pte_t *ptep = virt_to_kpte(addr);
 
-		dir = pgd_offset_k(addr);
-		p4dp = p4d_offset(dir, addr);
-		pudp = pud_offset(p4dp, addr);
-		pmdp = pmd_offset(pudp, addr);
-		ptep = pte_offset_kernel(pmdp, addr);
 		*ptep = pte_mknocache(*ptep);
 	}
 }
@@ -74,17 +65,8 @@ static inline void cache_page(void *vadd
 	unsigned long addr = (unsigned long)vaddr;
 
 	if (CPU_IS_040_OR_060) {
-		pgd_t *dir;
-		p4d_t *p4dp;
-		pud_t *pudp;
-		pmd_t *pmdp;
-		pte_t *ptep;
+		pte_t *ptep = virt_to_kpte(addr);
 
-		dir = pgd_offset_k(addr);
-		p4dp = p4d_offset(dir, addr);
-		pudp = pud_offset(p4dp, addr);
-		pmdp = pmd_offset(pudp, addr);
-		ptep = pte_offset_kernel(pmdp, addr);
 		*ptep = pte_mkcache(*ptep);
 	}
 }
--- a/arch/microblaze/kernel/signal.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/microblaze/kernel/signal.c
@@ -159,9 +159,6 @@ static int setup_rt_frame(struct ksignal
 	int err = 0, sig = ksig->sig;
 	unsigned long address = 0;
 #ifdef CONFIG_MMU
-	pgd_t *pgdp;
-	p4d_t *p4dp;
-	pud_t *pudp;
 	pmd_t *pmdp;
 	pte_t *ptep;
 #endif
@@ -197,10 +194,7 @@ static int setup_rt_frame(struct ksignal
 
 	address = ((unsigned long)frame->tramp);
 #ifdef CONFIG_MMU
-	pgdp = pgd_offset(current->mm, address);
-	p4dp = p4d_offset(pgdp, address);
-	pudp = pud_offset(p4dp, address);
-	pmdp = pmd_offset(pudp, address);
+	pmdp = pmd_off(current->mm, address);
 
 	preempt_disable();
 	ptep = pte_offset_map(pmdp, address);
--- a/arch/microblaze/mm/init.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/microblaze/mm/init.c
@@ -50,15 +50,6 @@ unsigned long lowmem_size;
 pte_t *kmap_pte;
 EXPORT_SYMBOL(kmap_pte);
 
-static inline pte_t *virt_to_kpte(unsigned long vaddr)
-{
-	pgd_t *pgd = pgd_offset_k(vaddr);
-	p4d_t *p4d = p4d_offset(pgd, vaddr);
-	pud_t *pud = pud_offset(p4d, vaddr);
-
-	return pte_offset_kernel(pmd_offset(pud, vaddr), vaddr);
-}
-
 static void __init highmem_init(void)
 {
 	pr_debug("%x\n", (u32)PKMAP_BASE);
--- a/arch/mips/include/asm/fixmap.h~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/mips/include/asm/fixmap.h
@@ -69,9 +69,6 @@ enum fixed_addresses {
 
 #include <asm-generic/fixmap.h>
 
-#define kmap_get_fixmap_pte(vaddr)					\
-	pte_offset_kernel(pmd_offset(pud_offset(p4d_offset(pgd_offset_k(vaddr), (vaddr)), (vaddr)), (vaddr)), (vaddr))
-
 /*
  * Called from pgtable_init()
  */
--- a/arch/mips/mm/c-r3k.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/mips/mm/c-r3k.c
@@ -239,9 +239,6 @@ static void r3k_flush_cache_page(struct
 	unsigned long kaddr = KSEG0ADDR(pfn << PAGE_SHIFT);
 	int exec = vma->vm_flags & VM_EXEC;
 	struct mm_struct *mm = vma->vm_mm;
-	pgd_t *pgdp;
-	p4d_t *p4dp;
-	pud_t *pudp;
 	pmd_t *pmdp;
 	pte_t *ptep;
 
@@ -252,11 +249,8 @@ static void r3k_flush_cache_page(struct
 	if (cpu_context(smp_processor_id(), mm) == 0)
 		return;
 
-	pgdp = pgd_offset(mm, addr);
-	p4dp = p4d_offset(pgdp, addr);
-	pudp = pud_offset(p4dp, addr);
-	pmdp = pmd_offset(pudp, addr);
-	ptep = pte_offset(pmdp, addr);
+	pmdp = pmd_off(mm, addr);
+	ptep = pte_offset_kernel(pmdp, addr);
 
 	/* Invalid => no such page in the cache.  */
 	if (!(pte_val(*ptep) & _PAGE_PRESENT))
--- a/arch/mips/mm/c-r4k.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/mips/mm/c-r4k.c
@@ -652,9 +652,6 @@ static inline void local_r4k_flush_cache
 	int exec = vma->vm_flags & VM_EXEC;
 	struct mm_struct *mm = vma->vm_mm;
 	int map_coherent = 0;
-	pgd_t *pgdp;
-	p4d_t *p4dp;
-	pud_t *pudp;
 	pmd_t *pmdp;
 	pte_t *ptep;
 	void *vaddr;
@@ -667,11 +664,8 @@ static inline void local_r4k_flush_cache
 		return;
 
 	addr &= PAGE_MASK;
-	pgdp = pgd_offset(mm, addr);
-	p4dp = p4d_offset(pgdp, addr);
-	pudp = pud_offset(p4dp, addr);
-	pmdp = pmd_offset(pudp, addr);
-	ptep = pte_offset(pmdp, addr);
+	pmdp = pmd_off(mm, addr);
+	ptep = pte_offset_kernel(pmdp, addr);
 
 	/*
 	 * If the page isn't marked valid, the page cannot possibly be
--- a/arch/mips/mm/c-tx39.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/mips/mm/c-tx39.c
@@ -168,9 +168,6 @@ static void tx39_flush_cache_page(struct
 {
 	int exec = vma->vm_flags & VM_EXEC;
 	struct mm_struct *mm = vma->vm_mm;
-	pgd_t *pgdp;
-	p4d_t *p4dp;
-	pud_t *pudp;
 	pmd_t *pmdp;
 	pte_t *ptep;
 
@@ -182,11 +179,8 @@ static void tx39_flush_cache_page(struct
 		return;
 
 	page &= PAGE_MASK;
-	pgdp = pgd_offset(mm, page);
-	p4dp = p4d_offset(pgdp, page);
-	pudp = pud_offset(p4dp, page);
-	pmdp = pmd_offset(pudp, page);
-	ptep = pte_offset(pmdp, page);
+	pmdp = pmd_off(mm, page);
+	ptep = pte_offset_kernel(pmdp, page);
 
 	/*
 	 * If the page isn't marked valid, the page cannot possibly be
--- a/arch/mips/mm/highmem.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/mips/mm/highmem.c
@@ -90,5 +90,5 @@ void __init kmap_init(void)
 
 	/* cache the first kmap pte */
 	kmap_vstart = __fix_to_virt(FIX_KMAP_BEGIN);
-	kmap_pte = kmap_get_fixmap_pte(kmap_vstart);
+	kmap_pte = virt_to_kpte(kmap_vstart);
 }
--- a/arch/nds32/include/asm/pgtable.h~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/nds32/include/asm/pgtable.h
@@ -195,8 +195,6 @@ extern void paging_init(void);
 #define pte_unmap(pte)		do { } while (0)
 #define pte_unmap_nested(pte)	do { } while (0)
 
-#define pmd_off_k(address)	pmd_offset(pud_offset(p4d_offset(pgd_offset_k(address), (address)), (address)), (address))
-
 #define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
 /*
  * Set a level 1 translation table entry, and clean it out of
--- a/arch/nds32/mm/init.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/nds32/mm/init.c
@@ -98,9 +98,6 @@ static pmd_t *fixmap_pmd_p;
 static void __init fixedrange_init(void)
 {
 	unsigned long vaddr;
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
 	pmd_t *pmd;
 #ifdef CONFIG_HIGHMEM
 	pte_t *pte;
@@ -110,10 +107,7 @@ static void __init fixedrange_init(void)
 	 * Fixed mappings:
 	 */
 	vaddr = __fix_to_virt(__end_of_fixed_addresses - 1);
-	pgd = swapper_pg_dir + pgd_index(vaddr);
-	p4d = p4d_offset(pgd, vaddr);
-	pud = pud_offset(p4d, vaddr);
-	pmd = pmd_offset(pud, vaddr);
+	pmd = pmd_off_k(vaddr);
 	fixmap_pmd_p = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
 	if (!fixmap_pmd_p)
 		panic("%s: Failed to allocate %lu bytes align=0x%lx\n",
@@ -126,10 +120,7 @@ static void __init fixedrange_init(void)
 	 */
 	vaddr = PKMAP_BASE;
 
-	pgd = swapper_pg_dir + pgd_index(vaddr);
-	p4d = p4d_offset(pgd, vaddr);
-	pud = pud_offset(p4d, vaddr);
-	pmd = pmd_offset(pud, vaddr);
+	pmd = pmd_off_k(vaddr);
 	pte = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
 	if (!pte)
 		panic("%s: Failed to allocate %lu bytes align=0x%lx\n",
--- a/arch/nds32/mm/proc.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/nds32/mm/proc.c
@@ -15,14 +15,10 @@ extern struct cache_info L1_cache_info[2
 
 int va_kernel_present(unsigned long addr)
 {
-	p4d_t *p4d;
-	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *ptep, pte;
 
-	p4d = p4d_offset(pgd_offset_k(addr), addr);
-	pud = pud_offset(p4d, addr);
-	pmd = pmd_offset(pud, addr);
+	pmd = pmd_off_k(addr);
 	if (!pmd_none(*pmd)) {
 		ptep = pte_offset_map(pmd, addr);
 		pte = *ptep;
--- a/arch/parisc/mm/fixmap.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/parisc/mm/fixmap.c
@@ -33,11 +33,7 @@ void notrace set_fixmap(enum fixed_addre
 void notrace clear_fixmap(enum fixed_addresses idx)
 {
 	unsigned long vaddr = __fix_to_virt(idx);
-	pgd_t *pgd = pgd_offset_k(vaddr);
-	p4d_t *p4d = p4d_offset(pgd, vaddr);
-	pud_t *pud = pud_offset(p4d, vaddr);
-	pmd_t *pmd = pmd_offset(pud, vaddr);
-	pte_t *pte = pte_offset_kernel(pmd, vaddr);
+	pte_t *pte = virt_to_kpte(vaddr);
 
 	if (WARN_ON(pte_none(*pte)))
 		return;
--- a/arch/powerpc/include/asm/pgtable.h~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -41,25 +41,6 @@ struct mm_struct;
 
 #ifndef __ASSEMBLY__
 
-#ifdef CONFIG_PPC32
-static inline pmd_t *pmd_ptr(struct mm_struct *mm, unsigned long va)
-{
-	return pmd_offset(pud_offset(p4d_offset(pgd_offset(mm, va), va), va), va);
-}
-
-static inline pmd_t *pmd_ptr_k(unsigned long va)
-{
-	return pmd_offset(pud_offset(p4d_offset(pgd_offset_k(va), va), va), va);
-}
-
-static inline pte_t *virt_to_kpte(unsigned long vaddr)
-{
-	pmd_t *pmd = pmd_ptr_k(vaddr);
-
-	return pmd_none(*pmd) ? NULL : pte_offset_kernel(pmd, vaddr);
-}
-#endif
-
 #include <asm/tlbflush.h>
 
 /* Keep these as a macros to avoid include dependency mess */
--- a/arch/powerpc/mm/book3s32/mmu.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/powerpc/mm/book3s32/mmu.c
@@ -320,7 +320,7 @@ void hash_preload(struct mm_struct *mm,
 
 	if (!Hash)
 		return;
-	pmd = pmd_ptr(mm, ea);
+	pmd = pmd_off(mm, ea);
 	if (!pmd_none(*pmd))
 		add_hash_page(mm->context.id, ea, pmd_val(*pmd));
 }
--- a/arch/powerpc/mm/book3s32/tlb.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/powerpc/mm/book3s32/tlb.c
@@ -90,7 +90,7 @@ static void flush_range(struct mm_struct
 	if (start >= end)
 		return;
 	end = (end - 1) | ~PAGE_MASK;
-	pmd = pmd_ptr(mm, start);
+	pmd = pmd_off(mm, start);
 	for (;;) {
 		pmd_end = ((start + PGDIR_SIZE) & PGDIR_MASK) - 1;
 		if (pmd_end > end)
@@ -148,7 +148,7 @@ void flush_tlb_page(struct vm_area_struc
 		return;
 	}
 	mm = (vmaddr < TASK_SIZE)? vma->vm_mm: &init_mm;
-	pmd = pmd_ptr(mm, vmaddr);
+	pmd = pmd_off(mm, vmaddr);
 	if (!pmd_none(*pmd))
 		flush_hash_pages(mm->context.id, vmaddr, pmd_val(*pmd), 1);
 }
--- a/arch/powerpc/mm/kasan/8xx.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/powerpc/mm/kasan/8xx.c
@@ -10,7 +10,7 @@
 static int __init
 kasan_init_shadow_8M(unsigned long k_start, unsigned long k_end, void *block)
 {
-	pmd_t *pmd = pmd_ptr_k(k_start);
+	pmd_t *pmd = pmd_off_k(k_start);
 	unsigned long k_cur, k_next;
 
 	for (k_cur = k_start; k_cur != k_end; k_cur = k_next, pmd += 2, block += SZ_8M) {
@@ -59,7 +59,7 @@ int __init kasan_init_region(void *start
 		return ret;
 
 	for (; k_cur < k_end; k_cur += PAGE_SIZE) {
-		pmd_t *pmd = pmd_ptr_k(k_cur);
+		pmd_t *pmd = pmd_off_k(k_cur);
 		void *va = block + k_cur - k_start;
 		pte_t pte = pfn_pte(PHYS_PFN(__pa(va)), PAGE_KERNEL);
 
--- a/arch/powerpc/mm/kasan/book3s_32.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/powerpc/mm/kasan/book3s_32.c
@@ -46,7 +46,7 @@ int __init kasan_init_region(void *start
 	kasan_update_early_region(k_start, k_cur, __pte(0));
 
 	for (; k_cur < k_end; k_cur += PAGE_SIZE) {
-		pmd_t *pmd = pmd_ptr_k(k_cur);
+		pmd_t *pmd = pmd_off_k(k_cur);
 		void *va = block + k_cur - k_start;
 		pte_t pte = pfn_pte(PHYS_PFN(__pa(va)), PAGE_KERNEL);
 
--- a/arch/powerpc/mm/kasan/kasan_init_32.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/powerpc/mm/kasan/kasan_init_32.c
@@ -33,7 +33,7 @@ int __init kasan_init_shadow_page_tables
 	pmd_t *pmd;
 	unsigned long k_cur, k_next;
 
-	pmd = pmd_ptr_k(k_start);
+	pmd = pmd_off_k(k_start);
 
 	for (k_cur = k_start; k_cur != k_end; k_cur = k_next, pmd++) {
 		pte_t *new;
@@ -69,7 +69,7 @@ int __init __weak kasan_init_region(void
 		return -ENOMEM;
 
 	for (k_cur = k_start & PAGE_MASK; k_cur < k_end; k_cur += PAGE_SIZE) {
-		pmd_t *pmd = pmd_ptr_k(k_cur);
+		pmd_t *pmd = pmd_off_k(k_cur);
 		void *va = block + k_cur - k_start;
 		pte_t pte = pfn_pte(PHYS_PFN(__pa(va)), PAGE_KERNEL);
 
@@ -86,7 +86,7 @@ kasan_update_early_region(unsigned long
 	phys_addr_t pa = __pa(kasan_early_shadow_page);
 
 	for (k_cur = k_start; k_cur != k_end; k_cur += PAGE_SIZE) {
-		pmd_t *pmd = pmd_ptr_k(k_cur);
+		pmd_t *pmd = pmd_off_k(k_cur);
 		pte_t *ptep = pte_offset_kernel(pmd, k_cur);
 
 		if ((pte_val(*ptep) & PTE_RPN_MASK) != pa)
@@ -184,7 +184,7 @@ void __init kasan_early_init(void)
 	unsigned long addr = KASAN_SHADOW_START;
 	unsigned long end = KASAN_SHADOW_END;
 	unsigned long next;
-	pmd_t *pmd = pmd_ptr_k(addr);
+	pmd_t *pmd = pmd_off_k(addr);
 
 	BUILD_BUG_ON(KASAN_SHADOW_START & ~PGDIR_MASK);
 
--- a/arch/powerpc/mm/nohash/40x.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/powerpc/mm/nohash/40x.c
@@ -103,7 +103,7 @@ unsigned long __init mmu_mapin_ram(unsig
 		pmd_t *pmdp;
 		unsigned long val = p | _PMD_SIZE_16M | _PAGE_EXEC | _PAGE_RW;
 
-		pmdp = pmd_ptr_k(v);
+		pmdp = pmd_off_k(v);
 		*pmdp++ = __pmd(val);
 		*pmdp++ = __pmd(val);
 		*pmdp++ = __pmd(val);
@@ -118,7 +118,7 @@ unsigned long __init mmu_mapin_ram(unsig
 		pmd_t *pmdp;
 		unsigned long val = p | _PMD_SIZE_4M | _PAGE_EXEC | _PAGE_RW;
 
-		pmdp = pmd_ptr_k(v);
+		pmdp = pmd_off_k(v);
 		*pmdp = __pmd(val);
 
 		v += LARGE_PAGE_SIZE_4M;
--- a/arch/powerpc/mm/nohash/8xx.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/powerpc/mm/nohash/8xx.c
@@ -74,7 +74,7 @@ static pte_t __init *early_hugepd_alloc_
 static int __ref __early_map_kernel_hugepage(unsigned long va, phys_addr_t pa,
 					     pgprot_t prot, int psize, bool new)
 {
-	pmd_t *pmdp = pmd_ptr_k(va);
+	pmd_t *pmdp = pmd_off_k(va);
 	pte_t *ptep;
 
 	if (WARN_ON(psize != MMU_PAGE_512K && psize != MMU_PAGE_8M))
--- a/arch/powerpc/mm/pgtable_32.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/powerpc/mm/pgtable_32.c
@@ -40,7 +40,7 @@ notrace void __init early_ioremap_init(v
 {
 	unsigned long addr = ALIGN_DOWN(FIXADDR_START, PGDIR_SIZE);
 	pte_t *ptep = (pte_t *)early_fixmap_pagetable;
-	pmd_t *pmdp = pmd_ptr_k(addr);
+	pmd_t *pmdp = pmd_off_k(addr);
 
 	for (; (s32)(FIXADDR_TOP - addr) > 0;
 	     addr += PGDIR_SIZE, ptep += PTRS_PER_PTE, pmdp++)
@@ -78,7 +78,7 @@ int __ref map_kernel_page(unsigned long
 	int err = -ENOMEM;
 
 	/* Use upper 10 bits of VA to index the first level map */
-	pd = pmd_ptr_k(va);
+	pd = pmd_off_k(va);
 	/* Use middle 10 bits of VA to index the second-level map */
 	if (likely(slab_is_available()))
 		pg = pte_alloc_kernel(pd, va);
--- a/arch/s390/mm/pageattr.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/s390/mm/pageattr.c
@@ -337,19 +337,11 @@ void __kernel_map_pages(struct page *pag
 {
 	unsigned long address;
 	int nr, i, j;
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
 	pte_t *pte;
 
 	for (i = 0; i < numpages;) {
 		address = page_to_phys(page + i);
-		pgd = pgd_offset_k(address);
-		p4d = p4d_offset(pgd, address);
-		pud = pud_offset(p4d, address);
-		pmd = pmd_offset(pud, address);
-		pte = pte_offset_kernel(pmd, address);
+		pte = virt_to_kpte(address);
 		nr = (unsigned long)pte >> ilog2(sizeof(long));
 		nr = PTRS_PER_PTE - (nr & (PTRS_PER_PTE - 1));
 		nr = min(numpages - i, nr);
--- a/arch/sh/mm/cache-sh4.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/sh/mm/cache-sh4.c
@@ -207,9 +207,6 @@ static void sh4_flush_cache_page(void *a
 	struct page *page;
 	unsigned long address, pfn, phys;
 	int map_coherent = 0;
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
 	void *vaddr;
@@ -223,10 +220,7 @@ static void sh4_flush_cache_page(void *a
 	if (cpu_context(smp_processor_id(), vma->vm_mm) == NO_CONTEXT)
 		return;
 
-	pgd = pgd_offset(vma->vm_mm, address);
-	p4d = p4d_offset(pgd, address);
-	pud = pud_offset(p4d, address);
-	pmd = pmd_offset(pud, address);
+	pmd = pmd_off(vma->vm_mm, address);
 	pte = pte_offset_kernel(pmd, address);
 
 	/* If the page isn't present, there is nothing to do here. */
--- a/arch/sh/mm/kmap.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/sh/mm/kmap.c
@@ -14,9 +14,6 @@
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 
-#define kmap_get_fixmap_pte(vaddr)                                     \
-	pte_offset_kernel(pmd_offset(pud_offset(p4d_offset(pgd_offset_k(vaddr), (vaddr)), (vaddr)), (vaddr)), vaddr)
-
 static pte_t *kmap_coherent_pte;
 
 void __init kmap_coherent_init(void)
@@ -25,7 +22,7 @@ void __init kmap_coherent_init(void)
 
 	/* cache the first coherent kmap pte */
 	vaddr = __fix_to_virt(FIX_CMAP_BEGIN);
-	kmap_coherent_pte = kmap_get_fixmap_pte(vaddr);
+	kmap_coherent_pte = virt_to_kpte(vaddr);
 }
 
 void *kmap_coherent(struct page *page, unsigned long addr)
--- a/arch/sparc/mm/highmem.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/sparc/mm/highmem.c
@@ -36,18 +36,10 @@ static pte_t *kmap_pte;
 
 void __init kmap_init(void)
 {
-	unsigned long address;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *dir;
-
-	address = __fix_to_virt(FIX_KMAP_BEGIN);
-	p4d = p4d_offset(pgd_offset_k(address), address);
-	pud = pud_offset(p4d, address);
-	dir = pmd_offset(pud, address);
+	unsigned long address = __fix_to_virt(FIX_KMAP_BEGIN);
 
         /* cache the first kmap pte */
-        kmap_pte = pte_offset_kernel(dir, address);
+        kmap_pte = virt_to_kpte(address);
 }
 
 void *kmap_atomic_high_prot(struct page *page, pgprot_t prot)
--- a/arch/sparc/mm/init_64.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/sparc/mm/init_64.c
@@ -503,11 +503,7 @@ void __kprobes flush_icache_range(unsign
 			if (kaddr >= PAGE_OFFSET)
 				paddr = kaddr & mask;
 			else {
-				pgd_t *pgdp = pgd_offset_k(kaddr);
-				p4d_t *p4dp = p4d_offset(pgdp, kaddr);
-				pud_t *pudp = pud_offset(p4dp, kaddr);
-				pmd_t *pmdp = pmd_offset(pudp, kaddr);
-				pte_t *ptep = pte_offset_kernel(pmdp, kaddr);
+				pte_t *ptep = virt_to_kpte(kaddr);
 
 				paddr = pte_val(*ptep) & mask;
 			}
--- a/arch/sparc/mm/iommu.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/sparc/mm/iommu.c
@@ -348,9 +348,6 @@ static void *sbus_iommu_alloc(struct dev
 	while(addr < end) {
 		page = va;
 		{
-			pgd_t *pgdp;
-			p4d_t *p4dp;
-			pud_t *pudp;
 			pmd_t *pmdp;
 			pte_t *ptep;
 
@@ -361,10 +358,7 @@ static void *sbus_iommu_alloc(struct dev
 			else
 				__flush_page_to_ram(page);
 
-			pgdp = pgd_offset(&init_mm, addr);
-			p4dp = p4d_offset(pgdp, addr);
-			pudp = pud_offset(p4dp, addr);
-			pmdp = pmd_offset(pudp, addr);
+			pmdp = pmd_off_k(addr);
 			ptep = pte_offset_map(pmdp, addr);
 
 			set_pte(ptep, mk_pte(virt_to_page(page), dvma_prot));
--- a/arch/sparc/mm/io-unit.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/sparc/mm/io-unit.c
@@ -240,21 +240,15 @@ static void *iounit_alloc(struct device
 	while(addr < end) {
 		page = va;
 		{
-			pgd_t *pgdp;
-			p4d_t *p4dp;
-			pud_t *pudp;
 			pmd_t *pmdp;
 			pte_t *ptep;
 			long i;
 
-			pgdp = pgd_offset(&init_mm, addr);
-			p4dp = p4d_offset(pgdp, addr);
-			pudp = pud_offset(p4dp, addr);
-			pmdp = pmd_offset(pudp, addr);
+			pmdp = pmd_off_k(addr);
 			ptep = pte_offset_map(pmdp, addr);
 
 			set_pte(ptep, mk_pte(virt_to_page(page), dvma_prot));
-			
+
 			i = ((addr - IOUNIT_DMA_BASE) >> PAGE_SHIFT);
 
 			iopte = iounit->page_table + i;
--- a/arch/um/kernel/mem.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/um/kernel/mem.c
@@ -125,10 +125,6 @@ static void __init fixaddr_user_init( vo
 {
 #ifdef CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA
 	long size = FIXADDR_USER_END - FIXADDR_USER_START;
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
 	pte_t *pte;
 	phys_t p;
 	unsigned long v, vaddr = FIXADDR_USER_START;
@@ -146,11 +142,7 @@ static void __init fixaddr_user_init( vo
 	p = __pa(v);
 	for ( ; size > 0; size -= PAGE_SIZE, vaddr += PAGE_SIZE,
 		      p += PAGE_SIZE) {
-		pgd = swapper_pg_dir + pgd_index(vaddr);
-		p4d = p4d_offset(pgd, vaddr);
-		pud = pud_offset(p4d, vaddr);
-		pmd = pmd_offset(pud, vaddr);
-		pte = pte_offset_kernel(pmd, vaddr);
+		pte = virt_to_kpte(vaddr);
 		pte_set_val(*pte, p, PAGE_READONLY);
 	}
 #endif
--- a/arch/um/kernel/trap.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/um/kernel/trap.c
@@ -26,9 +26,6 @@ int handle_page_fault(unsigned long addr
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
 	int err = -EFAULT;
@@ -102,10 +99,7 @@ good_area:
 			}
 		}
 
-		pgd = pgd_offset(mm, address);
-		p4d = p4d_offset(pgd, address);
-		pud = pud_offset(p4d, address);
-		pmd = pmd_offset(pud, address);
+		pmd = pmd_off(mm, address);
 		pte = pte_offset_kernel(pmd, address);
 	} while (!pte_present(*pte));
 	err = 0;
--- a/arch/unicore32/mm/mm.h~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/unicore32/mm/mm.h
@@ -14,16 +14,6 @@ extern int sysctl_overcommit_memory;
 
 #define TOP_PTE(x)	pte_offset_kernel(top_pmd, x)
 
-static inline pmd_t *pmd_off(pgd_t *pgd, unsigned long virt)
-{
-	return pmd_offset((pud_t *)pgd, virt);
-}
-
-static inline pmd_t *pmd_off_k(unsigned long virt)
-{
-	return pmd_off(pgd_offset_k(virt), virt);
-}
-
 struct mem_type {
 	unsigned int prot_pte;
 	unsigned int prot_l1;
--- a/arch/x86/mm/init_32.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/x86/mm/init_32.c
@@ -395,15 +395,6 @@ repeat:
 
 pte_t *kmap_pte;
 
-static inline pte_t *kmap_get_fixmap_pte(unsigned long vaddr)
-{
-	pgd_t *pgd = pgd_offset_k(vaddr);
-	p4d_t *p4d = p4d_offset(pgd, vaddr);
-	pud_t *pud = pud_offset(p4d, vaddr);
-	pmd_t *pmd = pmd_offset(pud, vaddr);
-	return pte_offset_kernel(pmd, vaddr);
-}
-
 static void __init kmap_init(void)
 {
 	unsigned long kmap_vstart;
@@ -412,28 +403,17 @@ static void __init kmap_init(void)
 	 * Cache the first kmap pte:
 	 */
 	kmap_vstart = __fix_to_virt(FIX_KMAP_BEGIN);
-	kmap_pte = kmap_get_fixmap_pte(kmap_vstart);
+	kmap_pte = virt_to_kpte(kmap_vstart);
 }
 
 #ifdef CONFIG_HIGHMEM
 static void __init permanent_kmaps_init(pgd_t *pgd_base)
 {
-	unsigned long vaddr;
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
+	unsigned long vaddr = PKMAP_BASE;
 
-	vaddr = PKMAP_BASE;
 	page_table_range_init(vaddr, vaddr + PAGE_SIZE*LAST_PKMAP, pgd_base);
 
-	pgd = swapper_pg_dir + pgd_index(vaddr);
-	p4d = p4d_offset(pgd, vaddr);
-	pud = pud_offset(p4d, vaddr);
-	pmd = pmd_offset(pud, vaddr);
-	pte = pte_offset_kernel(pmd, vaddr);
-	pkmap_page_table = pte;
+	pkmap_page_table = virt_to_kpte(vaddr);
 }
 
 void __init add_highpages_with_active_regions(int nid,
--- a/arch/xtensa/include/asm/fixmap.h~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/xtensa/include/asm/fixmap.h
@@ -76,12 +76,4 @@ static inline unsigned long virt_to_fix(
 
 #endif
 
-#define kmap_get_fixmap_pte(vaddr) \
-	pte_offset_kernel( \
-		pmd_offset(pud_offset(p4d_offset(pgd_offset_k(vaddr), \
-						 (vaddr)), \
-				      (vaddr)), \
-			   (vaddr)), \
-		(vaddr))
-
 #endif
--- a/arch/xtensa/mm/highmem.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/xtensa/mm/highmem.c
@@ -86,6 +86,6 @@ void __init kmap_init(void)
 	BUILD_BUG_ON(PKMAP_BASE < TLBTEMP_BASE_1 + TLBTEMP_SIZE);
 	/* cache the first kmap pte */
 	kmap_vstart = __fix_to_virt(FIX_KMAP_BEGIN);
-	kmap_pte = kmap_get_fixmap_pte(kmap_vstart);
+	kmap_pte = virt_to_kpte(kmap_vstart);
 	kmap_waitqueues_init();
 }
--- a/arch/xtensa/mm/kasan_init.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/xtensa/mm/kasan_init.c
@@ -19,10 +19,7 @@
 void __init kasan_early_init(void)
 {
 	unsigned long vaddr = KASAN_SHADOW_START;
-	pgd_t *pgd = pgd_offset_k(vaddr);
-	p4d_t *p4d = p4d_offset(pgd, vaddr);
-	pud_t *pud = pud_offset(p4d, vaddr);
-	pmd_t *pmd = pmd_offset(pud, vaddr);
+	pmd_t *pmd = pmd_off_k(vaddr);
 	int i;
 
 	for (i = 0; i < PTRS_PER_PTE; ++i)
@@ -43,10 +40,7 @@ static void __init populate(void *start,
 	unsigned long n_pmds = n_pages / PTRS_PER_PTE;
 	unsigned long i, j;
 	unsigned long vaddr = (unsigned long)start;
-	pgd_t *pgd = pgd_offset_k(vaddr);
-	p4d_t *p4d = p4d_offset(pgd, vaddr);
-	pud_t *pud = pud_offset(p4d, vaddr);
-	pmd_t *pmd = pmd_offset(pud, vaddr);
+	pmd_t *pmd = pmd_off_k(vaddr);
 	pte_t *pte = memblock_alloc(n_pages * sizeof(pte_t), PAGE_SIZE);
 
 	if (!pte)
--- a/arch/xtensa/mm/mmu.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/arch/xtensa/mm/mmu.c
@@ -21,10 +21,7 @@
 #if defined(CONFIG_HIGHMEM)
 static void * __init init_pmd(unsigned long vaddr, unsigned long n_pages)
 {
-	pgd_t *pgd = pgd_offset_k(vaddr);
-	p4d_t *p4d = p4d_offset(pgd, vaddr);
-	pud_t *pud = pud_offset(p4d, vaddr);
-	pmd_t *pmd = pmd_offset(pud, vaddr);
+	pmd_t *pmd = pmd_off_k(vaddr);
 	pte_t *pte;
 	unsigned long i;
 
--- a/include/linux/pgtable.h~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte
+++ a/include/linux/pgtable.h
@@ -28,6 +28,30 @@
 #define USER_PGTABLES_CEILING	0UL
 #endif
 
+/*
+ * In many cases it is known that a virtual address is mapped at PMD or PTE
+ * level, so instead of traversing all the page table levels, we can get a
+ * pointer to the PMD entry in user or kernel page table or translate a virtual
+ * address to the pointer in the PTE in the kernel page tables with simple
+ * helpers.
+ */
+static inline pmd_t *pmd_off(struct mm_struct *mm, unsigned long va)
+{
+	return pmd_offset(pud_offset(p4d_offset(pgd_offset(mm, va), va), va), va);
+}
+
+static inline pmd_t *pmd_off_k(unsigned long va)
+{
+	return pmd_offset(pud_offset(p4d_offset(pgd_offset_k(va), va), va), va);
+}
+
+static inline pte_t *virt_to_kpte(unsigned long vaddr)
+{
+	pmd_t *pmd = pmd_off_k(vaddr);
+
+	return pmd_none(*pmd) ? NULL : pte_offset_kernel(pmd, vaddr);
+}
+
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 extern int ptep_set_access_flags(struct vm_area_struct *vma,
 				 unsigned long address, pte_t *ptep,
_
