From: akpm@linux-foundation.org
Subject: + arch-fix-has_transparent_hugepage.patch added to -mm tree
Date: Tue, 05 Apr 2016 15:54:05 -0700
Message-ID: <5704420d.gI0+NsZUc8M1gwR+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56536 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbcDEWyH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 18:54:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mgorman@techsingularity.net, quning@gmail.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arch: fix has_transparent_hugepage()
has been added to the -mm tree.  Its filename is
     arch-fix-has_transparent_hugepage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-fix-has_transparent_hugepage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-fix-has_transparent_hugepage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: arch: fix has_transparent_hugepage()

I've just discovered that the useful-sounding has_transparent_hugepage()
is actually an architecture-dependent minefield: on some arches it only
builds if CONFIG_TRANSPARENT_HUGEPAGE=y, on others it's also there when
not, but on some of those (arm and arm64) it then gives the wrong answer;
and on mips alone it's marked __init, which would crash if called later
(but so far it has not been called later).

Straighten this out: make it available to all configs, with a sensible
default in asm-generic/pgtable.h, removing its definitions from those
arches (arc, arm, arm64, sparc, tile) which are served by the default,
adding #define has_transparent_hugepage has_transparent_hugepage to those
(mips, powerpc, s390, x86) which need to override the default at runtime,
and removing the __init from mips (but maybe that kind of code should be
avoided after init: set a static variable the first time it's called).

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/hugepage.h              |    2 -
 arch/arm/include/asm/pgtable-3level.h        |    5 ----
 arch/arm64/include/asm/pgtable.h             |    5 ----
 arch/mips/include/asm/pgtable.h              |    1 
 arch/mips/mm/tlb-r4k.c                       |   21 ++++++++---------
 arch/powerpc/include/asm/book3s/64/pgtable.h |    1 
 arch/powerpc/include/asm/pgtable.h           |    1 
 arch/s390/include/asm/pgtable.h              |    1 
 arch/sparc/include/asm/pgtable_64.h          |    2 -
 arch/tile/include/asm/pgtable.h              |    1 
 arch/x86/include/asm/pgtable.h               |    1 
 include/asm-generic/pgtable.h                |    8 ++++++
 12 files changed, 23 insertions(+), 26 deletions(-)

diff -puN arch/arc/include/asm/hugepage.h~arch-fix-has_transparent_hugepage arch/arc/include/asm/hugepage.h
--- a/arch/arc/include/asm/hugepage.h~arch-fix-has_transparent_hugepage
+++ a/arch/arc/include/asm/hugepage.h
@@ -61,8 +61,6 @@ static inline void set_pmd_at(struct mm_
 extern void update_mmu_cache_pmd(struct vm_area_struct *vma, unsigned long addr,
 				 pmd_t *pmd);
 
-#define has_transparent_hugepage() 1
-
 /* Generic variants assume pgtable_t is struct page *, hence need for these */
 #define __HAVE_ARCH_PGTABLE_DEPOSIT
 extern void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
diff -puN arch/arm/include/asm/pgtable-3level.h~arch-fix-has_transparent_hugepage arch/arm/include/asm/pgtable-3level.h
--- a/arch/arm/include/asm/pgtable-3level.h~arch-fix-has_transparent_hugepage
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -281,11 +281,6 @@ static inline void set_pmd_at(struct mm_
 	flush_pmd_entry(pmdp);
 }
 
-static inline int has_transparent_hugepage(void)
-{
-	return 1;
-}
-
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_PGTABLE_3LEVEL_H */
diff -puN arch/arm64/include/asm/pgtable.h~arch-fix-has_transparent_hugepage arch/arm64/include/asm/pgtable.h
--- a/arch/arm64/include/asm/pgtable.h~arch-fix-has_transparent_hugepage
+++ a/arch/arm64/include/asm/pgtable.h
@@ -304,11 +304,6 @@ static inline pgprot_t mk_sect_prot(pgpr
 
 #define set_pmd_at(mm, addr, pmdp, pmd)	set_pte_at(mm, addr, (pte_t *)pmdp, pmd_pte(pmd))
 
-static inline int has_transparent_hugepage(void)
-{
-	return 1;
-}
-
 #define __pgprot_modify(prot,mask,bits) \
 	__pgprot((pgprot_val(prot) & ~(mask)) | (bits))
 
diff -puN arch/mips/include/asm/pgtable.h~arch-fix-has_transparent_hugepage arch/mips/include/asm/pgtable.h
--- a/arch/mips/include/asm/pgtable.h~arch-fix-has_transparent_hugepage
+++ a/arch/mips/include/asm/pgtable.h
@@ -468,6 +468,7 @@ static inline int io_remap_pfn_range(str
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
+#define has_transparent_hugepage has_transparent_hugepage
 extern int has_transparent_hugepage(void);
 
 static inline int pmd_trans_huge(pmd_t pmd)
diff -puN arch/mips/mm/tlb-r4k.c~arch-fix-has_transparent_hugepage arch/mips/mm/tlb-r4k.c
--- a/arch/mips/mm/tlb-r4k.c~arch-fix-has_transparent_hugepage
+++ a/arch/mips/mm/tlb-r4k.c
@@ -400,19 +400,20 @@ void add_wired_entry(unsigned long entry
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
-int __init has_transparent_hugepage(void)
+int has_transparent_hugepage(void)
 {
-	unsigned int mask;
-	unsigned long flags;
+	static unsigned int mask = -1;
 
-	local_irq_save(flags);
-	write_c0_pagemask(PM_HUGE_MASK);
-	back_to_back_c0_hazard();
-	mask = read_c0_pagemask();
-	write_c0_pagemask(PM_DEFAULT_MASK);
-
-	local_irq_restore(flags);
+	if (mask == -1) {	/* first call comes during __init */
+		unsigned long flags;
 
+		local_irq_save(flags);
+		write_c0_pagemask(PM_HUGE_MASK);
+		back_to_back_c0_hazard();
+		mask = read_c0_pagemask();
+		write_c0_pagemask(PM_DEFAULT_MASK);
+		local_irq_restore(flags);
+	}
 	return mask == PM_HUGE_MASK;
 }
 
diff -puN arch/powerpc/include/asm/book3s/64/pgtable.h~arch-fix-has_transparent_hugepage arch/powerpc/include/asm/book3s/64/pgtable.h
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~arch-fix-has_transparent_hugepage
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -219,6 +219,7 @@ extern void set_pmd_at(struct mm_struct
 		       pmd_t *pmdp, pmd_t pmd);
 extern void update_mmu_cache_pmd(struct vm_area_struct *vma, unsigned long addr,
 				 pmd_t *pmd);
+#define has_transparent_hugepage has_transparent_hugepage
 extern int has_transparent_hugepage(void);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
diff -puN arch/powerpc/include/asm/pgtable.h~arch-fix-has_transparent_hugepage arch/powerpc/include/asm/pgtable.h
--- a/arch/powerpc/include/asm/pgtable.h~arch-fix-has_transparent_hugepage
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -65,7 +65,6 @@ extern int gup_hugepte(pte_t *ptep, unsi
 		       struct page **pages, int *nr);
 #ifndef CONFIG_TRANSPARENT_HUGEPAGE
 #define pmd_large(pmd)		0
-#define has_transparent_hugepage() 0
 #endif
 pte_t *__find_linux_pte_or_hugepte(pgd_t *pgdir, unsigned long ea,
 				   bool *is_thp, unsigned *shift);
diff -puN arch/s390/include/asm/pgtable.h~arch-fix-has_transparent_hugepage arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~arch-fix-has_transparent_hugepage
+++ a/arch/s390/include/asm/pgtable.h
@@ -1223,6 +1223,7 @@ static inline int pmd_trans_huge(pmd_t p
 	return pmd_val(pmd) & _SEGMENT_ENTRY_LARGE;
 }
 
+#define has_transparent_hugepage has_transparent_hugepage
 static inline int has_transparent_hugepage(void)
 {
 	return MACHINE_HAS_HPAGE ? 1 : 0;
diff -puN arch/sparc/include/asm/pgtable_64.h~arch-fix-has_transparent_hugepage arch/sparc/include/asm/pgtable_64.h
--- a/arch/sparc/include/asm/pgtable_64.h~arch-fix-has_transparent_hugepage
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -681,8 +681,6 @@ static inline unsigned long pmd_trans_hu
 	return pte_val(pte) & _PAGE_PMD_HUGE;
 }
 
-#define has_transparent_hugepage() 1
-
 static inline pmd_t pmd_mkold(pmd_t pmd)
 {
 	pte_t pte = __pte(pmd_val(pmd));
diff -puN arch/tile/include/asm/pgtable.h~arch-fix-has_transparent_hugepage arch/tile/include/asm/pgtable.h
--- a/arch/tile/include/asm/pgtable.h~arch-fix-has_transparent_hugepage
+++ a/arch/tile/include/asm/pgtable.h
@@ -487,7 +487,6 @@ static inline pmd_t pmd_modify(pmd_t pmd
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-#define has_transparent_hugepage() 1
 #define pmd_trans_huge pmd_huge_page
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
diff -puN arch/x86/include/asm/pgtable.h~arch-fix-has_transparent_hugepage arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~arch-fix-has_transparent_hugepage
+++ a/arch/x86/include/asm/pgtable.h
@@ -181,6 +181,7 @@ static inline int pmd_trans_huge(pmd_t p
 	return (pmd_val(pmd) & (_PAGE_PSE|_PAGE_DEVMAP)) == _PAGE_PSE;
 }
 
+#define has_transparent_hugepage has_transparent_hugepage
 static inline int has_transparent_hugepage(void)
 {
 	return cpu_has_pse;
diff -puN include/asm-generic/pgtable.h~arch-fix-has_transparent_hugepage include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~arch-fix-has_transparent_hugepage
+++ a/include/asm-generic/pgtable.h
@@ -806,4 +806,12 @@ static inline int pmd_clear_huge(pmd_t *
 #define io_remap_pfn_range remap_pfn_range
 #endif
 
+#ifndef has_transparent_hugepage
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#define has_transparent_hugepage() 1
+#else
+#define has_transparent_hugepage() 0
+#endif
+#endif
+
 #endif /* _ASM_GENERIC_PGTABLE_H */
_

Patches currently in -mm which might be from hughd@google.com are

mm-update_lru_size-warn-and-reset-bad-lru_size.patch
mm-update_lru_size-do-the-__mod_zone_page_state.patch
mm-use-__setpageswapbacked-and-dont-clearpageswapbacked.patch
tmpfs-preliminary-minor-tidyups.patch
mm-proc-sys-vm-stat_refresh-to-force-vmstat-update.patch
huge-mm-move_huge_pmd-does-not-need-new_vma.patch
huge-pagecache-extend-mremap-pmd-rmap-lockout-to-files.patch
huge-pagecache-mmap_sem-is-unlocked-when-truncation-splits-pmd.patch
arch-fix-has_transparent_hugepage.patch

