From: akpm@linux-foundation.org
Subject: + x86-expose-number-of-page-table-levels-on-kconfig-level.patch
 added to -mm tree
Date: Mon, 23 Feb 2015 12:45:02 -0800
Message-ID: <54eb914e.vvudWwQaehdXPrro%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbbBWUpD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 15:45:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, hpa@zytor.com, linux@roeck-us.net, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: expose number of page table levels on Kconfig level
has been added to the -mm tree.  Its filename is
     x86-expose-number-of-page-table-levels-on-kconfig-level.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-expose-number-of-page-table-levels-on-kconfig-level.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-expose-number-of-page-table-levels-on-kconfig-level.patch

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
Subject: x86: expose number of page table levels on Kconfig level

We would want to use number of page table level to define mm_struct.
Let's expose it as CONFIG_PGTABLE_LEVELS.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                            |    6 ++++++
 arch/x86/include/asm/paravirt.h             |    8 ++++----
 arch/x86/include/asm/paravirt_types.h       |    8 ++++----
 arch/x86/include/asm/pgalloc.h              |    8 ++++----
 arch/x86/include/asm/pgtable-2level_types.h |    1 -
 arch/x86/include/asm/pgtable-3level_types.h |    2 --
 arch/x86/include/asm/pgtable.h              |    8 ++++----
 arch/x86/include/asm/pgtable_64_types.h     |    1 -
 arch/x86/include/asm/pgtable_types.h        |    4 ++--
 arch/x86/kernel/paravirt.c                  |    6 +++---
 arch/x86/mm/pgtable.c                       |   14 +++++++-------
 arch/x86/xen/mmu.c                          |   14 +++++++-------
 include/trace/events/xen.h                  |    2 +-
 13 files changed, 42 insertions(+), 40 deletions(-)

diff -puN arch/x86/Kconfig~x86-expose-number-of-page-table-levels-on-kconfig-level arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/x86/Kconfig
@@ -279,6 +279,12 @@ config ARCH_SUPPORTS_UPROBES
 config FIX_EARLYCON_MEM
 	def_bool y
 
+config PGTABLE_LEVELS
+	int
+	default 4 if X86_64
+	default 3 if X86_PAE
+	default 2
+
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
 
diff -puN arch/x86/include/asm/paravirt.h~x86-expose-number-of-page-table-levels-on-kconfig-level arch/x86/include/asm/paravirt.h
--- a/arch/x86/include/asm/paravirt.h~x86-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/x86/include/asm/paravirt.h
@@ -545,7 +545,7 @@ static inline void set_pmd(pmd_t *pmdp,
 		PVOP_VCALL2(pv_mmu_ops.set_pmd, pmdp, val);
 }
 
-#if PAGETABLE_LEVELS >= 3
+#if CONFIG_PGTABLE_LEVELS >= 3
 static inline pmd_t __pmd(pmdval_t val)
 {
 	pmdval_t ret;
@@ -585,7 +585,7 @@ static inline void set_pud(pud_t *pudp,
 		PVOP_VCALL2(pv_mmu_ops.set_pud, pudp,
 			    val);
 }
-#if PAGETABLE_LEVELS == 4
+#if CONFIG_PGTABLE_LEVELS == 4
 static inline pud_t __pud(pudval_t val)
 {
 	pudval_t ret;
@@ -636,9 +636,9 @@ static inline void pud_clear(pud_t *pudp
 	set_pud(pudp, __pud(0));
 }
 
-#endif	/* PAGETABLE_LEVELS == 4 */
+#endif	/* CONFIG_PGTABLE_LEVELS == 4 */
 
-#endif	/* PAGETABLE_LEVELS >= 3 */
+#endif	/* CONFIG_PGTABLE_LEVELS >= 3 */
 
 #ifdef CONFIG_X86_PAE
 /* Special-case pte-setting operations for PAE, which can't update a
diff -puN arch/x86/include/asm/paravirt_types.h~x86-expose-number-of-page-table-levels-on-kconfig-level arch/x86/include/asm/paravirt_types.h
--- a/arch/x86/include/asm/paravirt_types.h~x86-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/x86/include/asm/paravirt_types.h
@@ -294,7 +294,7 @@ struct pv_mmu_ops {
 	struct paravirt_callee_save pgd_val;
 	struct paravirt_callee_save make_pgd;
 
-#if PAGETABLE_LEVELS >= 3
+#if CONFIG_PGTABLE_LEVELS >= 3
 #ifdef CONFIG_X86_PAE
 	void (*set_pte_atomic)(pte_t *ptep, pte_t pteval);
 	void (*pte_clear)(struct mm_struct *mm, unsigned long addr,
@@ -308,13 +308,13 @@ struct pv_mmu_ops {
 	struct paravirt_callee_save pmd_val;
 	struct paravirt_callee_save make_pmd;
 
-#if PAGETABLE_LEVELS == 4
+#if CONFIG_PGTABLE_LEVELS == 4
 	struct paravirt_callee_save pud_val;
 	struct paravirt_callee_save make_pud;
 
 	void (*set_pgd)(pgd_t *pudp, pgd_t pgdval);
-#endif	/* PAGETABLE_LEVELS == 4 */
-#endif	/* PAGETABLE_LEVELS >= 3 */
+#endif	/* CONFIG_PGTABLE_LEVELS == 4 */
+#endif	/* CONFIG_PGTABLE_LEVELS >= 3 */
 
 	struct pv_lazy_ops lazy_mode;
 
diff -puN arch/x86/include/asm/pgalloc.h~x86-expose-number-of-page-table-levels-on-kconfig-level arch/x86/include/asm/pgalloc.h
--- a/arch/x86/include/asm/pgalloc.h~x86-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/x86/include/asm/pgalloc.h
@@ -77,7 +77,7 @@ static inline void pmd_populate(struct m
 
 #define pmd_pgtable(pmd) pmd_page(pmd)
 
-#if PAGETABLE_LEVELS > 2
+#if CONFIG_PGTABLE_LEVELS > 2
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
 	struct page *page;
@@ -116,7 +116,7 @@ static inline void pud_populate(struct m
 }
 #endif	/* CONFIG_X86_PAE */
 
-#if PAGETABLE_LEVELS > 3
+#if CONFIG_PGTABLE_LEVELS > 3
 static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgd, pud_t *pud)
 {
 	paravirt_alloc_pud(mm, __pa(pud) >> PAGE_SHIFT);
@@ -142,7 +142,7 @@ static inline void __pud_free_tlb(struct
 	___pud_free_tlb(tlb, pud);
 }
 
-#endif	/* PAGETABLE_LEVELS > 3 */
-#endif	/* PAGETABLE_LEVELS > 2 */
+#endif	/* CONFIG_PGTABLE_LEVELS > 3 */
+#endif	/* CONFIG_PGTABLE_LEVELS > 2 */
 
 #endif /* _ASM_X86_PGALLOC_H */
diff -puN arch/x86/include/asm/pgtable-2level_types.h~x86-expose-number-of-page-table-levels-on-kconfig-level arch/x86/include/asm/pgtable-2level_types.h
--- a/arch/x86/include/asm/pgtable-2level_types.h~x86-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/x86/include/asm/pgtable-2level_types.h
@@ -17,7 +17,6 @@ typedef union {
 #endif	/* !__ASSEMBLY__ */
 
 #define SHARED_KERNEL_PMD	0
-#define PAGETABLE_LEVELS	2
 
 /*
  * traditional i386 two-level paging structure:
diff -puN arch/x86/include/asm/pgtable-3level_types.h~x86-expose-number-of-page-table-levels-on-kconfig-level arch/x86/include/asm/pgtable-3level_types.h
--- a/arch/x86/include/asm/pgtable-3level_types.h~x86-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/x86/include/asm/pgtable-3level_types.h
@@ -24,8 +24,6 @@ typedef union {
 #define SHARED_KERNEL_PMD	1
 #endif
 
-#define PAGETABLE_LEVELS	3
-
 /*
  * PGDIR_SHIFT determines what a top-level page table entry can map
  */
diff -puN arch/x86/include/asm/pgtable.h~x86-expose-number-of-page-table-levels-on-kconfig-level arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~x86-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/x86/include/asm/pgtable.h
@@ -551,7 +551,7 @@ static inline unsigned long pages_to_mb(
 	return npg >> (20 - PAGE_SHIFT);
 }
 
-#if PAGETABLE_LEVELS > 2
+#if CONFIG_PGTABLE_LEVELS > 2
 static inline int pud_none(pud_t pud)
 {
 	return native_pud_val(pud) == 0;
@@ -594,9 +594,9 @@ static inline int pud_large(pud_t pud)
 {
 	return 0;
 }
-#endif	/* PAGETABLE_LEVELS > 2 */
+#endif	/* CONFIG_PGTABLE_LEVELS > 2 */
 
-#if PAGETABLE_LEVELS > 3
+#if CONFIG_PGTABLE_LEVELS > 3
 static inline int pgd_present(pgd_t pgd)
 {
 	return pgd_flags(pgd) & _PAGE_PRESENT;
@@ -633,7 +633,7 @@ static inline int pgd_none(pgd_t pgd)
 {
 	return !native_pgd_val(pgd);
 }
-#endif	/* PAGETABLE_LEVELS > 3 */
+#endif	/* CONFIG_PGTABLE_LEVELS > 3 */
 
 #endif	/* __ASSEMBLY__ */
 
diff -puN arch/x86/include/asm/pgtable_64_types.h~x86-expose-number-of-page-table-levels-on-kconfig-level arch/x86/include/asm/pgtable_64_types.h
--- a/arch/x86/include/asm/pgtable_64_types.h~x86-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/x86/include/asm/pgtable_64_types.h
@@ -20,7 +20,6 @@ typedef struct { pteval_t pte; } pte_t;
 #endif	/* !__ASSEMBLY__ */
 
 #define SHARED_KERNEL_PMD	0
-#define PAGETABLE_LEVELS	4
 
 /*
  * PGDIR_SHIFT determines what a top-level page table entry can map
diff -puN arch/x86/include/asm/pgtable_types.h~x86-expose-number-of-page-table-levels-on-kconfig-level arch/x86/include/asm/pgtable_types.h
--- a/arch/x86/include/asm/pgtable_types.h~x86-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/x86/include/asm/pgtable_types.h
@@ -234,7 +234,7 @@ static inline pgdval_t pgd_flags(pgd_t p
 	return native_pgd_val(pgd) & PTE_FLAGS_MASK;
 }
 
-#if PAGETABLE_LEVELS > 3
+#if CONFIG_PGTABLE_LEVELS > 3
 typedef struct { pudval_t pud; } pud_t;
 
 static inline pud_t native_make_pud(pmdval_t val)
@@ -255,7 +255,7 @@ static inline pudval_t native_pud_val(pu
 }
 #endif
 
-#if PAGETABLE_LEVELS > 2
+#if CONFIG_PGTABLE_LEVELS > 2
 typedef struct { pmdval_t pmd; } pmd_t;
 
 static inline pmd_t native_make_pmd(pmdval_t val)
diff -puN arch/x86/kernel/paravirt.c~x86-expose-number-of-page-table-levels-on-kconfig-level arch/x86/kernel/paravirt.c
--- a/arch/x86/kernel/paravirt.c~x86-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/x86/kernel/paravirt.c
@@ -443,7 +443,7 @@ struct pv_mmu_ops pv_mmu_ops = {
 	.ptep_modify_prot_start = __ptep_modify_prot_start,
 	.ptep_modify_prot_commit = __ptep_modify_prot_commit,
 
-#if PAGETABLE_LEVELS >= 3
+#if CONFIG_PGTABLE_LEVELS >= 3
 #ifdef CONFIG_X86_PAE
 	.set_pte_atomic = native_set_pte_atomic,
 	.pte_clear = native_pte_clear,
@@ -454,13 +454,13 @@ struct pv_mmu_ops pv_mmu_ops = {
 	.pmd_val = PTE_IDENT,
 	.make_pmd = PTE_IDENT,
 
-#if PAGETABLE_LEVELS == 4
+#if CONFIG_PGTABLE_LEVELS == 4
 	.pud_val = PTE_IDENT,
 	.make_pud = PTE_IDENT,
 
 	.set_pgd = native_set_pgd,
 #endif
-#endif /* PAGETABLE_LEVELS >= 3 */
+#endif /* CONFIG_PGTABLE_LEVELS >= 3 */
 
 	.pte_val = PTE_IDENT,
 	.pgd_val = PTE_IDENT,
diff -puN arch/x86/mm/pgtable.c~x86-expose-number-of-page-table-levels-on-kconfig-level arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c~x86-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/x86/mm/pgtable.c
@@ -58,7 +58,7 @@ void ___pte_free_tlb(struct mmu_gather *
 	tlb_remove_page(tlb, pte);
 }
 
-#if PAGETABLE_LEVELS > 2
+#if CONFIG_PGTABLE_LEVELS > 2
 void ___pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
 {
 	struct page *page = virt_to_page(pmd);
@@ -74,14 +74,14 @@ void ___pmd_free_tlb(struct mmu_gather *
 	tlb_remove_page(tlb, page);
 }
 
-#if PAGETABLE_LEVELS > 3
+#if CONFIG_PGTABLE_LEVELS > 3
 void ___pud_free_tlb(struct mmu_gather *tlb, pud_t *pud)
 {
 	paravirt_release_pud(__pa(pud) >> PAGE_SHIFT);
 	tlb_remove_page(tlb, virt_to_page(pud));
 }
-#endif	/* PAGETABLE_LEVELS > 3 */
-#endif	/* PAGETABLE_LEVELS > 2 */
+#endif	/* CONFIG_PGTABLE_LEVELS > 3 */
+#endif	/* CONFIG_PGTABLE_LEVELS > 2 */
 
 static inline void pgd_list_add(pgd_t *pgd)
 {
@@ -117,9 +117,9 @@ static void pgd_ctor(struct mm_struct *m
 	/* If the pgd points to a shared pagetable level (either the
 	   ptes in non-PAE, or shared PMD in PAE), then just copy the
 	   references from swapper_pg_dir. */
-	if (PAGETABLE_LEVELS == 2 ||
-	    (PAGETABLE_LEVELS == 3 && SHARED_KERNEL_PMD) ||
-	    PAGETABLE_LEVELS == 4) {
+	if (CONFIG_PGTABLE_LEVELS == 2 ||
+	    (CONFIG_PGTABLE_LEVELS == 3 && SHARED_KERNEL_PMD) ||
+	    CONFIG_PGTABLE_LEVELS == 4) {
 		clone_pgd_range(pgd + KERNEL_PGD_BOUNDARY,
 				swapper_pg_dir + KERNEL_PGD_BOUNDARY,
 				KERNEL_PGD_PTRS);
diff -puN arch/x86/xen/mmu.c~x86-expose-number-of-page-table-levels-on-kconfig-level arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c~x86-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/x86/xen/mmu.c
@@ -502,7 +502,7 @@ __visible pmd_t xen_make_pmd(pmdval_t pm
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_make_pmd);
 
-#if PAGETABLE_LEVELS == 4
+#if CONFIG_PGTABLE_LEVELS == 4
 __visible pudval_t xen_pud_val(pud_t pud)
 {
 	return pte_mfn_to_pfn(pud.pud);
@@ -589,7 +589,7 @@ static void xen_set_pgd(pgd_t *ptr, pgd_
 
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
 }
-#endif	/* PAGETABLE_LEVELS == 4 */
+#endif	/* CONFIG_PGTABLE_LEVELS == 4 */
 
 /*
  * (Yet another) pagetable walker.  This one is intended for pinning a
@@ -1628,7 +1628,7 @@ static void xen_release_pmd(unsigned lon
 	xen_release_ptpage(pfn, PT_PMD);
 }
 
-#if PAGETABLE_LEVELS == 4
+#if CONFIG_PGTABLE_LEVELS == 4
 static void xen_alloc_pud(struct mm_struct *mm, unsigned long pfn)
 {
 	xen_alloc_ptpage(mm, pfn, PT_PUD);
@@ -2046,7 +2046,7 @@ static void __init xen_post_allocator_in
 	pv_mmu_ops.set_pte = xen_set_pte;
 	pv_mmu_ops.set_pmd = xen_set_pmd;
 	pv_mmu_ops.set_pud = xen_set_pud;
-#if PAGETABLE_LEVELS == 4
+#if CONFIG_PGTABLE_LEVELS == 4
 	pv_mmu_ops.set_pgd = xen_set_pgd;
 #endif
 
@@ -2056,7 +2056,7 @@ static void __init xen_post_allocator_in
 	pv_mmu_ops.alloc_pmd = xen_alloc_pmd;
 	pv_mmu_ops.release_pte = xen_release_pte;
 	pv_mmu_ops.release_pmd = xen_release_pmd;
-#if PAGETABLE_LEVELS == 4
+#if CONFIG_PGTABLE_LEVELS == 4
 	pv_mmu_ops.alloc_pud = xen_alloc_pud;
 	pv_mmu_ops.release_pud = xen_release_pud;
 #endif
@@ -2122,14 +2122,14 @@ static const struct pv_mmu_ops xen_mmu_o
 	.make_pmd = PV_CALLEE_SAVE(xen_make_pmd),
 	.pmd_val = PV_CALLEE_SAVE(xen_pmd_val),
 
-#if PAGETABLE_LEVELS == 4
+#if CONFIG_PGTABLE_LEVELS == 4
 	.pud_val = PV_CALLEE_SAVE(xen_pud_val),
 	.make_pud = PV_CALLEE_SAVE(xen_make_pud),
 	.set_pgd = xen_set_pgd_hyper,
 
 	.alloc_pud = xen_alloc_pmd_init,
 	.release_pud = xen_release_pmd_init,
-#endif	/* PAGETABLE_LEVELS == 4 */
+#endif	/* CONFIG_PGTABLE_LEVELS == 4 */
 
 	.activate_mm = xen_activate_mm,
 	.dup_mmap = xen_dup_mmap,
diff -puN include/trace/events/xen.h~x86-expose-number-of-page-table-levels-on-kconfig-level include/trace/events/xen.h
--- a/include/trace/events/xen.h~x86-expose-number-of-page-table-levels-on-kconfig-level
+++ a/include/trace/events/xen.h
@@ -224,7 +224,7 @@ TRACE_EVENT(xen_mmu_pmd_clear,
 	    TP_printk("pmdp %p", __entry->pmdp)
 	);
 
-#if PAGETABLE_LEVELS >= 4
+#if CONFIG_PGTABLE_LEVELS >= 4
 
 TRACE_EVENT(xen_mmu_set_pud,
 	    TP_PROTO(pud_t *pudp, pud_t pudval),
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

