From: akpm@linux-foundation.org
Subject: [merged]
 mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial.patch
 removed from -mm tree
Date: Sat, 11 Apr 2020 23:45:13 -0700
Message-ID: <20200412064513.qHcr5IYk1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726708AbgDLGpP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 12 Apr 2020 02:45:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, anton.ivanov@cambridgegreys.com, bcain@codeaurora.org, chris@zankel.net, davem@davemloft.net, deanbo422@gmail.com, deller@gmx.de, fenghua.yu@intel.com, geert@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, ink@jurassic.park.msu.ru, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, jdike@addtoit.com, jonas@southpole.se, ley.foon.tan@intel.com, linux@armlinux.org.uk, mattst88@gmail.com, mm-commits@vger.kernel.org, monstr@monstr.eu, nickhu@andestech.com, paulburton@kernel.org, ralf@linux-mips.org, richard@nod.at, rth@twiddle.net, sammy@sammy.net, shorne@gmail.com, stefan.kristiansson@saunalahti.fi, tony.luck@intel.com, tsbogend@alpha.franken.de


The patch titled
     Subject: mm/special: create generic fallbacks for pte_special() and pte_mkspecial()
has been removed from the -mm tree.  Its filename was
     mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/special: create generic fallbacks for pte_special() and pte_mkspecial()

Currently there are many platforms that dont enable ARCH_HAS_PTE_SPECIAL
but required to define quite similar fallback stubs for special page table
entry helpers such as pte_special() and pte_mkspecial(), as they get build
in generic MM without a config check.  This creates two generic fallback
stub definitions for these helpers, eliminating much code duplication.

mips platform has a special case where pte_special() and pte_mkspecial()
visibility is wider than what ARCH_HAS_PTE_SPECIAL enablement requires. 
This restricts those symbol visibility in order to avoid redefinitions
which is now exposed through this new generic stubs and subsequent build
failure.  arm platform set_pte_at() definition needs to be moved into a C
file just to prevent a build failure.

[anshuman.khandual@arm.com: use defined(CONFIG_ARCH_HAS_PTE_SPECIAL) in mips per Thomas]
  Link: http://lkml.kernel.org/r/1583851924-21603-1-git-send-email-anshuman.khandual@arm.com
Link: http://lkml.kernel.org/r/1583802551-15406-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Guo Ren <guoren@kernel.org>			[csky]
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>	[m68k]
Acked-by: Stafford Horne <shorne@gmail.com>		[openrisc]
Acked-by: Helge Deller <deller@gmx.de>			[parisc]
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Sam Creasey <sammy@sammy.net>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/pgtable.h         |    2 
 arch/arm/include/asm/pgtable-2level.h    |    2 
 arch/arm/include/asm/pgtable.h           |   15 -------
 arch/arm/mm/mmu.c                        |   14 ++++++
 arch/csky/include/asm/pgtable.h          |    3 -
 arch/hexagon/include/asm/pgtable.h       |    2 
 arch/ia64/include/asm/pgtable.h          |    2 
 arch/m68k/include/asm/mcf_pgtable.h      |   10 ----
 arch/m68k/include/asm/motorola_pgtable.h |    2 
 arch/m68k/include/asm/sun3_pgtable.h     |    2 
 arch/microblaze/include/asm/pgtable.h    |    4 -
 arch/mips/include/asm/pgtable.h          |   44 ++++++++++++++-------
 arch/nds32/include/asm/pgtable.h         |    9 ----
 arch/nios2/include/asm/pgtable.h         |    3 -
 arch/openrisc/include/asm/pgtable.h      |    2 
 arch/parisc/include/asm/pgtable.h        |    2 
 arch/sparc/include/asm/pgtable_32.h      |    7 ---
 arch/um/include/asm/pgtable.h            |   10 ----
 arch/unicore32/include/asm/pgtable.h     |    3 -
 arch/xtensa/include/asm/pgtable.h        |    3 -
 include/linux/mm.h                       |   12 +++++
 21 files changed, 58 insertions(+), 95 deletions(-)

--- a/arch/alpha/include/asm/pgtable.h~mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial
+++ a/arch/alpha/include/asm/pgtable.h
@@ -268,7 +268,6 @@ extern inline void pud_clear(pud_t * pud
 extern inline int pte_write(pte_t pte)		{ return !(pte_val(pte) & _PAGE_FOW); }
 extern inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
 extern inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
-extern inline int pte_special(pte_t pte)	{ return 0; }
 
 extern inline pte_t pte_wrprotect(pte_t pte)	{ pte_val(pte) |= _PAGE_FOW; return pte; }
 extern inline pte_t pte_mkclean(pte_t pte)	{ pte_val(pte) &= ~(__DIRTY_BITS); return pte; }
@@ -276,7 +275,6 @@ extern inline pte_t pte_mkold(pte_t pte)
 extern inline pte_t pte_mkwrite(pte_t pte)	{ pte_val(pte) &= ~_PAGE_FOW; return pte; }
 extern inline pte_t pte_mkdirty(pte_t pte)	{ pte_val(pte) |= __DIRTY_BITS; return pte; }
 extern inline pte_t pte_mkyoung(pte_t pte)	{ pte_val(pte) |= __ACCESS_BITS; return pte; }
-extern inline pte_t pte_mkspecial(pte_t pte)	{ return pte; }
 
 #define PAGE_DIR_OFFSET(tsk,address) pgd_offset((tsk),(address))
 
--- a/arch/arm/include/asm/pgtable-2level.h~mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial
+++ a/arch/arm/include/asm/pgtable-2level.h
@@ -211,8 +211,6 @@ static inline pmd_t *pmd_offset(pud_t *p
 #define pmd_addr_end(addr,end) (end)
 
 #define set_pte_ext(ptep,pte,ext) cpu_set_pte_ext(ptep,pte,ext)
-#define pte_special(pte)	(0)
-static inline pte_t pte_mkspecial(pte_t pte) { return pte; }
 
 /*
  * We don't have huge page support for short descriptors, for the moment
--- a/arch/arm/include/asm/pgtable.h~mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial
+++ a/arch/arm/include/asm/pgtable.h
@@ -243,19 +243,8 @@ static inline void __sync_icache_dcache(
 extern void __sync_icache_dcache(pte_t pteval);
 #endif
 
-static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
-			      pte_t *ptep, pte_t pteval)
-{
-	unsigned long ext = 0;
-
-	if (addr < TASK_SIZE && pte_valid_user(pteval)) {
-		if (!pte_special(pteval))
-			__sync_icache_dcache(pteval);
-		ext |= PTE_EXT_NG;
-	}
-
-	set_pte_ext(ptep, pteval, ext);
-}
+void set_pte_at(struct mm_struct *mm, unsigned long addr,
+		      pte_t *ptep, pte_t pteval);
 
 static inline pte_t clear_pte_bit(pte_t pte, pgprot_t prot)
 {
--- a/arch/arm/mm/mmu.c~mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial
+++ a/arch/arm/mm/mmu.c
@@ -1646,3 +1646,17 @@ void __init early_mm_init(const struct m
 	build_mem_type_table();
 	early_paging_init(mdesc);
 }
+
+void set_pte_at(struct mm_struct *mm, unsigned long addr,
+			      pte_t *ptep, pte_t pteval)
+{
+	unsigned long ext = 0;
+
+	if (addr < TASK_SIZE && pte_valid_user(pteval)) {
+		if (!pte_special(pteval))
+			__sync_icache_dcache(pteval);
+		ext |= PTE_EXT_NG;
+	}
+
+	set_pte_ext(ptep, pteval, ext);
+}
--- a/arch/csky/include/asm/pgtable.h~mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial
+++ a/arch/csky/include/asm/pgtable.h
@@ -110,9 +110,6 @@ extern unsigned long empty_zero_page[PAG
 extern void load_pgd(unsigned long pg_dir);
 extern pte_t invalid_pte_table[PTRS_PER_PTE];
 
-static inline int pte_special(pte_t pte) { return 0; }
-static inline pte_t pte_mkspecial(pte_t pte) { return pte; }
-
 static inline void set_pte(pte_t *p, pte_t pte)
 {
 	*p = pte;
--- a/arch/hexagon/include/asm/pgtable.h~mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial
+++ a/arch/hexagon/include/asm/pgtable.h
@@ -158,8 +158,6 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD
 
 /* Seems to be zero even in architectures where the zero page is firewalled? */
 #define FIRST_USER_ADDRESS 0UL
-#define pte_special(pte)	0
-#define pte_mkspecial(pte)	(pte)
 
 /*  HUGETLB not working currently  */
 #ifdef CONFIG_HUGETLB_PAGE
--- a/arch/ia64/include/asm/pgtable.h~mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial
+++ a/arch/ia64/include/asm/pgtable.h
@@ -298,7 +298,6 @@ extern unsigned long VMALLOC_END;
 #define pte_exec(pte)		((pte_val(pte) & _PAGE_AR_RX) != 0)
 #define pte_dirty(pte)		((pte_val(pte) & _PAGE_D) != 0)
 #define pte_young(pte)		((pte_val(pte) & _PAGE_A) != 0)
-#define pte_special(pte)	0
 
 /*
  * Note: we convert AR_RWX to AR_RX and AR_RW to AR_R by clearing the 2nd bit in the
@@ -311,7 +310,6 @@ extern unsigned long VMALLOC_END;
 #define pte_mkclean(pte)	(__pte(pte_val(pte) & ~_PAGE_D))
 #define pte_mkdirty(pte)	(__pte(pte_val(pte) | _PAGE_D))
 #define pte_mkhuge(pte)		(__pte(pte_val(pte)))
-#define pte_mkspecial(pte)	(pte)
 
 /*
  * Because ia64's Icache and Dcache is not coherent (on a cpu), we need to
--- a/arch/m68k/include/asm/mcf_pgtable.h~mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial
+++ a/arch/m68k/include/asm/mcf_pgtable.h
@@ -235,11 +235,6 @@ static inline int pte_young(pte_t pte)
 	return pte_val(pte) & CF_PAGE_ACCESSED;
 }
 
-static inline int pte_special(pte_t pte)
-{
-	return 0;
-}
-
 static inline pte_t pte_wrprotect(pte_t pte)
 {
 	pte_val(pte) &= ~CF_PAGE_WRITABLE;
@@ -312,11 +307,6 @@ static inline pte_t pte_mkcache(pte_t pt
 	return pte;
 }
 
-static inline pte_t pte_mkspecial(pte_t pte)
-{
-	return pte;
-}
-
 #define swapper_pg_dir kernel_pg_dir
 extern pgd_t kernel_pg_dir[PTRS_PER_PGD];
 
--- a/arch/m68k/include/asm/motorola_pgtable.h~mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial
+++ a/arch/m68k/include/asm/motorola_pgtable.h
@@ -174,7 +174,6 @@ static inline void pud_set(pud_t *pudp,
 static inline int pte_write(pte_t pte)		{ return !(pte_val(pte) & _PAGE_RONLY); }
 static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
-static inline int pte_special(pte_t pte)	{ return 0; }
 
 static inline pte_t pte_wrprotect(pte_t pte)	{ pte_val(pte) |= _PAGE_RONLY; return pte; }
 static inline pte_t pte_mkclean(pte_t pte)	{ pte_val(pte) &= ~_PAGE_DIRTY; return pte; }
@@ -192,7 +191,6 @@ static inline pte_t pte_mkcache(pte_t pt
 	pte_val(pte) = (pte_val(pte) & _CACHEMASK040) | m68k_supervisor_cachemode;
 	return pte;
 }
-static inline pte_t pte_mkspecial(pte_t pte)	{ return pte; }
 
 #define PAGE_DIR_OFFSET(tsk,address) pgd_offset((tsk),(address))
 
--- a/arch/m68k/include/asm/sun3_pgtable.h~mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial
+++ a/arch/m68k/include/asm/sun3_pgtable.h
@@ -155,7 +155,6 @@ static inline void pmd_clear (pmd_t *pmd
 static inline int pte_write(pte_t pte)		{ return pte_val(pte) & SUN3_PAGE_WRITEABLE; }
 static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & SUN3_PAGE_MODIFIED; }
 static inline int pte_young(pte_t pte)		{ return pte_val(pte) & SUN3_PAGE_ACCESSED; }
-static inline int pte_special(pte_t pte)	{ return 0; }
 
 static inline pte_t pte_wrprotect(pte_t pte)	{ pte_val(pte) &= ~SUN3_PAGE_WRITEABLE; return pte; }
 static inline pte_t pte_mkclean(pte_t pte)	{ pte_val(pte) &= ~SUN3_PAGE_MODIFIED; return pte; }
@@ -168,7 +167,6 @@ static inline pte_t pte_mknocache(pte_t
 //static inline pte_t pte_mkcache(pte_t pte)	{ pte_val(pte) &= SUN3_PAGE_NOCACHE; return pte; }
 // until then, use:
 static inline pte_t pte_mkcache(pte_t pte)	{ return pte; }
-static inline pte_t pte_mkspecial(pte_t pte)	{ return pte; }
 
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 extern pgd_t kernel_pg_dir[PTRS_PER_PGD];
--- a/arch/microblaze/include/asm/pgtable.h~mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial
+++ a/arch/microblaze/include/asm/pgtable.h
@@ -77,10 +77,6 @@ extern pte_t *va_to_pte(unsigned long ad
  * Undefined behaviour if not..
  */
 
-static inline int pte_special(pte_t pte)	{ return 0; }
-
-static inline pte_t pte_mkspecial(pte_t pte)	{ return pte; }
-
 /* Start and end of the vmalloc area. */
 /* Make sure to map the vmalloc area above the pinned kernel memory area
    of 32Mb.  */
--- a/arch/mips/include/asm/pgtable.h~mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial
+++ a/arch/mips/include/asm/pgtable.h
@@ -270,6 +270,36 @@ cache_sync_done:
 extern pgd_t swapper_pg_dir[];
 
 /*
+ * Platform specific pte_special() and pte_mkspecial() definitions
+ * are required only when ARCH_HAS_PTE_SPECIAL is enabled.
+ */
+#if defined(CONFIG_ARCH_HAS_PTE_SPECIAL)
+#if defined(CONFIG_PHYS_ADDR_T_64BIT) && defined(CONFIG_CPU_MIPS32)
+static inline int pte_special(pte_t pte)
+{
+	return pte.pte_low & _PAGE_SPECIAL;
+}
+
+static inline pte_t pte_mkspecial(pte_t pte)
+{
+	pte.pte_low |= _PAGE_SPECIAL;
+	return pte;
+}
+#else
+static inline int pte_special(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_SPECIAL;
+}
+
+static inline pte_t pte_mkspecial(pte_t pte)
+{
+	pte_val(pte) |= _PAGE_SPECIAL;
+	return pte;
+}
+#endif
+#endif /* CONFIG_ARCH_HAS_PTE_SPECIAL */
+
+/*
  * The following only work if pte_present() is true.
  * Undefined behaviour if not..
  */
@@ -277,7 +307,6 @@ extern pgd_t swapper_pg_dir[];
 static inline int pte_write(pte_t pte)	{ return pte.pte_low & _PAGE_WRITE; }
 static inline int pte_dirty(pte_t pte)	{ return pte.pte_low & _PAGE_MODIFIED; }
 static inline int pte_young(pte_t pte)	{ return pte.pte_low & _PAGE_ACCESSED; }
-static inline int pte_special(pte_t pte) { return pte.pte_low & _PAGE_SPECIAL; }
 
 static inline pte_t pte_wrprotect(pte_t pte)
 {
@@ -338,17 +367,10 @@ static inline pte_t pte_mkyoung(pte_t pt
 	}
 	return pte;
 }
-
-static inline pte_t pte_mkspecial(pte_t pte)
-{
-	pte.pte_low |= _PAGE_SPECIAL;
-	return pte;
-}
 #else
 static inline int pte_write(pte_t pte)	{ return pte_val(pte) & _PAGE_WRITE; }
 static inline int pte_dirty(pte_t pte)	{ return pte_val(pte) & _PAGE_MODIFIED; }
 static inline int pte_young(pte_t pte)	{ return pte_val(pte) & _PAGE_ACCESSED; }
-static inline int pte_special(pte_t pte) { return pte_val(pte) & _PAGE_SPECIAL; }
 
 static inline pte_t pte_wrprotect(pte_t pte)
 {
@@ -392,12 +414,6 @@ static inline pte_t pte_mkyoung(pte_t pt
 	return pte;
 }
 
-static inline pte_t pte_mkspecial(pte_t pte)
-{
-	pte_val(pte) |= _PAGE_SPECIAL;
-	return pte;
-}
-
 #ifdef CONFIG_MIPS_HUGE_TLB_SUPPORT
 static inline int pte_huge(pte_t pte)	{ return pte_val(pte) & _PAGE_HUGE; }
 
--- a/arch/nds32/include/asm/pgtable.h~mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial
+++ a/arch/nds32/include/asm/pgtable.h
@@ -286,15 +286,6 @@ PTE_BIT_FUNC(mkclean, &=~_PAGE_D);
 PTE_BIT_FUNC(mkdirty, |=_PAGE_D);
 PTE_BIT_FUNC(mkold, &=~_PAGE_YOUNG);
 PTE_BIT_FUNC(mkyoung, |=_PAGE_YOUNG);
-static inline int pte_special(pte_t pte)
-{
-	return 0;
-}
-
-static inline pte_t pte_mkspecial(pte_t pte)
-{
-	return pte;
-}
 
 /*
  * Mark the prot value as uncacheable and unbufferable.
--- a/arch/nios2/include/asm/pgtable.h~mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial
+++ a/arch/nios2/include/asm/pgtable.h
@@ -113,7 +113,6 @@ static inline int pte_dirty(pte_t pte)
 	{ return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte)		\
 	{ return pte_val(pte) & _PAGE_ACCESSED; }
-static inline int pte_special(pte_t pte)	{ return 0; }
 
 #define pgprot_noncached pgprot_noncached
 
@@ -168,8 +167,6 @@ static inline pte_t pte_mkdirty(pte_t pt
 	return pte;
 }
 
-static inline pte_t pte_mkspecial(pte_t pte)	{ return pte; }
-
 static inline pte_t pte_mkyoung(pte_t pte)
 {
 	pte_val(pte) |= _PAGE_ACCESSED;
--- a/arch/openrisc/include/asm/pgtable.h~mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial
+++ a/arch/openrisc/include/asm/pgtable.h
@@ -236,8 +236,6 @@ static inline int pte_write(pte_t pte) {
 static inline int pte_exec(pte_t pte)  { return pte_val(pte) & _PAGE_EXEC; }
 static inline int pte_dirty(pte_t pte) { return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte) { return pte_val(pte) & _PAGE_ACCESSED; }
-static inline int pte_special(pte_t pte) { return 0; }
-static inline pte_t pte_mkspecial(pte_t pte) { return pte; }
 
 static inline pte_t pte_wrprotect(pte_t pte)
 {
--- a/arch/parisc/include/asm/pgtable.h~mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial
+++ a/arch/parisc/include/asm/pgtable.h
@@ -377,7 +377,6 @@ static inline void pud_clear(pud_t *pud)
 static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
 static inline int pte_write(pte_t pte)		{ return pte_val(pte) & _PAGE_WRITE; }
-static inline int pte_special(pte_t pte)	{ return 0; }
 
 static inline pte_t pte_mkclean(pte_t pte)	{ pte_val(pte) &= ~_PAGE_DIRTY; return pte; }
 static inline pte_t pte_mkold(pte_t pte)	{ pte_val(pte) &= ~_PAGE_ACCESSED; return pte; }
@@ -385,7 +384,6 @@ static inline pte_t pte_wrprotect(pte_t
 static inline pte_t pte_mkdirty(pte_t pte)	{ pte_val(pte) |= _PAGE_DIRTY; return pte; }
 static inline pte_t pte_mkyoung(pte_t pte)	{ pte_val(pte) |= _PAGE_ACCESSED; return pte; }
 static inline pte_t pte_mkwrite(pte_t pte)	{ pte_val(pte) |= _PAGE_WRITE; return pte; }
-static inline pte_t pte_mkspecial(pte_t pte)	{ return pte; }
 
 /*
  * Huge pte definitions.
--- a/arch/sparc/include/asm/pgtable_32.h~mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial
+++ a/arch/sparc/include/asm/pgtable_32.h
@@ -223,11 +223,6 @@ static inline int pte_young(pte_t pte)
 	return pte_val(pte) & SRMMU_REF;
 }
 
-static inline int pte_special(pte_t pte)
-{
-	return 0;
-}
-
 static inline pte_t pte_wrprotect(pte_t pte)
 {
 	return __pte(pte_val(pte) & ~SRMMU_WRITE);
@@ -258,8 +253,6 @@ static inline pte_t pte_mkyoung(pte_t pt
 	return __pte(pte_val(pte) | SRMMU_REF);
 }
 
-#define pte_mkspecial(pte)    (pte)
-
 #define pfn_pte(pfn, prot)		mk_pte(pfn_to_page(pfn), prot)
 
 static inline unsigned long pte_pfn(pte_t pte)
--- a/arch/um/include/asm/pgtable.h~mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial
+++ a/arch/um/include/asm/pgtable.h
@@ -167,11 +167,6 @@ static inline int pte_newprot(pte_t pte)
 	return(pte_present(pte) && (pte_get_bits(pte, _PAGE_NEWPROT)));
 }
 
-static inline int pte_special(pte_t pte)
-{
-	return 0;
-}
-
 /*
  * =================================
  * Flags setting section.
@@ -247,11 +242,6 @@ static inline pte_t pte_mknewpage(pte_t
 	return(pte);
 }
 
-static inline pte_t pte_mkspecial(pte_t pte)
-{
-	return(pte);
-}
-
 static inline void set_pte(pte_t *pteptr, pte_t pteval)
 {
 	pte_copy(*pteptr, pteval);
--- a/arch/unicore32/include/asm/pgtable.h~mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial
+++ a/arch/unicore32/include/asm/pgtable.h
@@ -177,7 +177,6 @@ extern struct page *empty_zero_page;
 #define pte_dirty(pte)		(pte_val(pte) & PTE_DIRTY)
 #define pte_young(pte)		(pte_val(pte) & PTE_YOUNG)
 #define pte_exec(pte)		(pte_val(pte) & PTE_EXEC)
-#define pte_special(pte)	(0)
 
 #define PTE_BIT_FUNC(fn, op) \
 static inline pte_t pte_##fn(pte_t pte) { pte_val(pte) op; return pte; }
@@ -189,8 +188,6 @@ PTE_BIT_FUNC(mkdirty,   |= PTE_DIRTY);
 PTE_BIT_FUNC(mkold,     &= ~PTE_YOUNG);
 PTE_BIT_FUNC(mkyoung,   |= PTE_YOUNG);
 
-static inline pte_t pte_mkspecial(pte_t pte) { return pte; }
-
 /*
  * Mark the prot value as uncacheable.
  */
--- a/arch/xtensa/include/asm/pgtable.h~mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial
+++ a/arch/xtensa/include/asm/pgtable.h
@@ -266,7 +266,6 @@ static inline void paging_init(void) { }
 static inline int pte_write(pte_t pte) { return pte_val(pte) & _PAGE_WRITABLE; }
 static inline int pte_dirty(pte_t pte) { return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte) { return pte_val(pte) & _PAGE_ACCESSED; }
-static inline int pte_special(pte_t pte) { return 0; }
 
 static inline pte_t pte_wrprotect(pte_t pte)	
 	{ pte_val(pte) &= ~(_PAGE_WRITABLE | _PAGE_HW_WRITE); return pte; }
@@ -280,8 +279,6 @@ static inline pte_t pte_mkyoung(pte_t pt
 	{ pte_val(pte) |= _PAGE_ACCESSED; return pte; }
 static inline pte_t pte_mkwrite(pte_t pte)
 	{ pte_val(pte) |= _PAGE_WRITABLE; return pte; }
-static inline pte_t pte_mkspecial(pte_t pte)
-	{ return pte; }
 
 #define pgprot_noncached(prot) (__pgprot(pgprot_val(prot) & ~_PAGE_CA_MASK))
 
--- a/include/linux/mm.h~mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial
+++ a/include/linux/mm.h
@@ -1927,6 +1927,18 @@ static inline void sync_mm_rss(struct mm
 }
 #endif
 
+#ifndef CONFIG_ARCH_HAS_PTE_SPECIAL
+static inline int pte_special(pte_t pte)
+{
+	return 0;
+}
+
+static inline pte_t pte_mkspecial(pte_t pte)
+{
+	return pte;
+}
+#endif
+
 #ifndef CONFIG_ARCH_HAS_PTE_DEVMAP
 static inline int pte_devmap(pte_t pte)
 {
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug-add-tests-validating-architecture-page-table-helpers.patch
