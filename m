From: akpm@linux-foundation.org
Subject: + thp-add-x86-32bit-support.patch added to -mm tree
Date: Wed, 15 Dec 2010 15:57:33 -0800
Message-ID: <201012152357.oBFNvXc1013617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755791Ab0LOX5r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 18:57:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, aarcange@redhat.com, riel@redhat.com


The patch titled
     thp: add x86 32bit support
has been added to the -mm tree.  Its filename is
     thp-add-x86-32bit-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: add x86 32bit support
From: Johannes Weiner <hannes@cmpxchg.org>

Add support for transparent hugepages to x86 32bit.

Share the same VM_ bitflag for VM_MAPPED_COPY.  mm/nommu.c will never
support transparent hugepages.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable-2level.h |    9 +
 arch/x86/include/asm/pgtable-3level.h |   23 ++++
 arch/x86/include/asm/pgtable.h        |  117 ++++++++++++++++++++++++
 arch/x86/include/asm/pgtable_64.h     |  109 ----------------------
 arch/x86/mm/pgtable.c                 |    4 
 include/linux/mm.h                    |    7 -
 mm/Kconfig                            |    2 
 7 files changed, 156 insertions(+), 115 deletions(-)

diff -puN arch/x86/include/asm/pgtable-2level.h~thp-add-x86-32bit-support arch/x86/include/asm/pgtable-2level.h
--- a/arch/x86/include/asm/pgtable-2level.h~thp-add-x86-32bit-support
+++ a/arch/x86/include/asm/pgtable-2level.h
@@ -46,6 +46,15 @@ static inline pte_t native_ptep_get_and_
 #define native_ptep_get_and_clear(xp) native_local_ptep_get_and_clear(xp)
 #endif
 
+#ifdef CONFIG_SMP
+static inline pmd_t native_pmdp_get_and_clear(pmd_t *xp)
+{
+	return __pmd(xchg((pmdval_t *)xp, 0));
+}
+#else
+#define native_pmdp_get_and_clear(xp) native_local_pmdp_get_and_clear(xp)
+#endif
+
 /*
  * Bits _PAGE_BIT_PRESENT, _PAGE_BIT_FILE and _PAGE_BIT_PROTNONE are taken,
  * split up the 29 bits of offset into this range:
diff -puN arch/x86/include/asm/pgtable-3level.h~thp-add-x86-32bit-support arch/x86/include/asm/pgtable-3level.h
--- a/arch/x86/include/asm/pgtable-3level.h~thp-add-x86-32bit-support
+++ a/arch/x86/include/asm/pgtable-3level.h
@@ -104,6 +104,29 @@ static inline pte_t native_ptep_get_and_
 #define native_ptep_get_and_clear(xp) native_local_ptep_get_and_clear(xp)
 #endif
 
+#ifdef CONFIG_SMP
+union split_pmd {
+	struct {
+		u32 pmd_low;
+		u32 pmd_high;
+	};
+	pmd_t pmd;
+};
+static inline pmd_t native_pmdp_get_and_clear(pmd_t *pmdp)
+{
+	union split_pmd res, *orig = (union split_pmd *)pmdp;
+
+	/* xchg acts as a barrier before setting of the high bits */
+	res.pmd_low = xchg(&orig->pmd_low, 0);
+	res.pmd_high = orig->pmd_high;
+	orig->pmd_high = 0;
+
+	return res.pmd;
+}
+#else
+#define native_pmdp_get_and_clear(xp) native_local_pmdp_get_and_clear(xp)
+#endif
+
 /*
  * Bits 0, 6 and 7 are taken in the low part of the pte,
  * put the 32 bits of offset into the high part.
diff -puN arch/x86/include/asm/pgtable.h~thp-add-x86-32bit-support arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~thp-add-x86-32bit-support
+++ a/arch/x86/include/asm/pgtable.h
@@ -97,6 +97,11 @@ static inline int pte_young(pte_t pte)
 	return pte_flags(pte) & _PAGE_ACCESSED;
 }
 
+static inline int pmd_young(pmd_t pmd)
+{
+	return pmd_flags(pmd) & _PAGE_ACCESSED;
+}
+
 static inline int pte_write(pte_t pte)
 {
 	return pte_flags(pte) & _PAGE_RW;
@@ -145,6 +150,18 @@ static inline int pmd_large(pmd_t pte)
 		(_PAGE_PSE | _PAGE_PRESENT);
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline int pmd_trans_splitting(pmd_t pmd)
+{
+	return pmd_val(pmd) & _PAGE_SPLITTING;
+}
+
+static inline int pmd_trans_huge(pmd_t pmd)
+{
+	return pmd_val(pmd) & _PAGE_PSE;
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
 static inline pte_t pte_set_flags(pte_t pte, pteval_t set)
 {
 	pteval_t v = native_pte_val(pte);
@@ -219,6 +236,55 @@ static inline pte_t pte_mkspecial(pte_t 
 	return pte_set_flags(pte, _PAGE_SPECIAL);
 }
 
+static inline pmd_t pmd_set_flags(pmd_t pmd, pmdval_t set)
+{
+	pmdval_t v = native_pmd_val(pmd);
+
+	return __pmd(v | set);
+}
+
+static inline pmd_t pmd_clear_flags(pmd_t pmd, pmdval_t clear)
+{
+	pmdval_t v = native_pmd_val(pmd);
+
+	return __pmd(v & ~clear);
+}
+
+static inline pmd_t pmd_mkold(pmd_t pmd)
+{
+	return pmd_clear_flags(pmd, _PAGE_ACCESSED);
+}
+
+static inline pmd_t pmd_wrprotect(pmd_t pmd)
+{
+	return pmd_clear_flags(pmd, _PAGE_RW);
+}
+
+static inline pmd_t pmd_mkdirty(pmd_t pmd)
+{
+	return pmd_set_flags(pmd, _PAGE_DIRTY);
+}
+
+static inline pmd_t pmd_mkhuge(pmd_t pmd)
+{
+	return pmd_set_flags(pmd, _PAGE_PSE);
+}
+
+static inline pmd_t pmd_mkyoung(pmd_t pmd)
+{
+	return pmd_set_flags(pmd, _PAGE_ACCESSED);
+}
+
+static inline pmd_t pmd_mkwrite(pmd_t pmd)
+{
+	return pmd_set_flags(pmd, _PAGE_RW);
+}
+
+static inline pmd_t pmd_mknotpresent(pmd_t pmd)
+{
+	return pmd_clear_flags(pmd, _PAGE_PRESENT);
+}
+
 /*
  * Mask out unsupported bits in a present pgprot.  Non-present pgprots
  * can use those bits for other purposes, so leave them be.
@@ -527,6 +593,14 @@ static inline pte_t native_local_ptep_ge
 	return res;
 }
 
+static inline pmd_t native_local_pmdp_get_and_clear(pmd_t *pmdp)
+{
+	pmd_t res = *pmdp;
+
+	native_pmd_clear(pmdp);
+	return res;
+}
+
 static inline void native_set_pte_at(struct mm_struct *mm, unsigned long addr,
 				     pte_t *ptep , pte_t pte)
 {
@@ -616,6 +690,49 @@ static inline void ptep_set_wrprotect(st
 
 #define flush_tlb_fix_spurious_fault(vma, address)
 
+#define mk_pmd(page, pgprot)   pfn_pmd(page_to_pfn(page), (pgprot))
+
+#define  __HAVE_ARCH_PMDP_SET_ACCESS_FLAGS
+extern int pmdp_set_access_flags(struct vm_area_struct *vma,
+				 unsigned long address, pmd_t *pmdp,
+				 pmd_t entry, int dirty);
+
+#define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
+extern int pmdp_test_and_clear_young(struct vm_area_struct *vma,
+				     unsigned long addr, pmd_t *pmdp);
+
+#define __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
+extern int pmdp_clear_flush_young(struct vm_area_struct *vma,
+				  unsigned long address, pmd_t *pmdp);
+
+
+#define __HAVE_ARCH_PMDP_SPLITTING_FLUSH
+extern void pmdp_splitting_flush(struct vm_area_struct *vma,
+				 unsigned long addr, pmd_t *pmdp);
+
+#define __HAVE_ARCH_PMD_WRITE
+static inline int pmd_write(pmd_t pmd)
+{
+	return pmd_flags(pmd) & _PAGE_RW;
+}
+
+#define __HAVE_ARCH_PMDP_GET_AND_CLEAR
+static inline pmd_t pmdp_get_and_clear(struct mm_struct *mm, unsigned long addr,
+				       pmd_t *pmdp)
+{
+	pmd_t pmd = native_pmdp_get_and_clear(pmdp);
+	pmd_update(mm, addr, pmdp);
+	return pmd;
+}
+
+#define __HAVE_ARCH_PMDP_SET_WRPROTECT
+static inline void pmdp_set_wrprotect(struct mm_struct *mm,
+				      unsigned long addr, pmd_t *pmdp)
+{
+	clear_bit(_PAGE_BIT_RW, (unsigned long *)pmdp);
+	pmd_update(mm, addr, pmdp);
+}
+
 /*
  * clone_pgd_range(pgd_t *dst, pgd_t *src, int count);
  *
diff -puN arch/x86/include/asm/pgtable_64.h~thp-add-x86-32bit-support arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h~thp-add-x86-32bit-support
+++ a/arch/x86/include/asm/pgtable_64.h
@@ -182,115 +182,6 @@ extern void cleanup_highmap(void);
 
 #define __HAVE_ARCH_PTE_SAME
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static inline int pmd_trans_splitting(pmd_t pmd)
-{
-	return pmd_val(pmd) & _PAGE_SPLITTING;
-}
-
-static inline int pmd_trans_huge(pmd_t pmd)
-{
-	return pmd_val(pmd) & _PAGE_PSE;
-}
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-
-#define mk_pmd(page, pgprot)   pfn_pmd(page_to_pfn(page), (pgprot))
-
-#define  __HAVE_ARCH_PMDP_SET_ACCESS_FLAGS
-extern int pmdp_set_access_flags(struct vm_area_struct *vma,
-				 unsigned long address, pmd_t *pmdp,
-				 pmd_t entry, int dirty);
-
-#define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
-extern int pmdp_test_and_clear_young(struct vm_area_struct *vma,
-				     unsigned long addr, pmd_t *pmdp);
-
-#define __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
-extern int pmdp_clear_flush_young(struct vm_area_struct *vma,
-				  unsigned long address, pmd_t *pmdp);
-
-
-#define __HAVE_ARCH_PMDP_SPLITTING_FLUSH
-extern void pmdp_splitting_flush(struct vm_area_struct *vma,
-				 unsigned long addr, pmd_t *pmdp);
-
-#define __HAVE_ARCH_PMD_WRITE
-static inline int pmd_write(pmd_t pmd)
-{
-	return pmd_flags(pmd) & _PAGE_RW;
-}
-
-#define __HAVE_ARCH_PMDP_GET_AND_CLEAR
-static inline pmd_t pmdp_get_and_clear(struct mm_struct *mm, unsigned long addr,
-				       pmd_t *pmdp)
-{
-	pmd_t pmd = native_pmdp_get_and_clear(pmdp);
-	pmd_update(mm, addr, pmdp);
-	return pmd;
-}
-
-#define __HAVE_ARCH_PMDP_SET_WRPROTECT
-static inline void pmdp_set_wrprotect(struct mm_struct *mm,
-				      unsigned long addr, pmd_t *pmdp)
-{
-	clear_bit(_PAGE_BIT_RW, (unsigned long *)&pmdp->pmd);
-	pmd_update(mm, addr, pmdp);
-}
-
-static inline int pmd_young(pmd_t pmd)
-{
-	return pmd_flags(pmd) & _PAGE_ACCESSED;
-}
-
-static inline pmd_t pmd_set_flags(pmd_t pmd, pmdval_t set)
-{
-	pmdval_t v = native_pmd_val(pmd);
-
-	return native_make_pmd(v | set);
-}
-
-static inline pmd_t pmd_clear_flags(pmd_t pmd, pmdval_t clear)
-{
-	pmdval_t v = native_pmd_val(pmd);
-
-	return native_make_pmd(v & ~clear);
-}
-
-static inline pmd_t pmd_mkold(pmd_t pmd)
-{
-	return pmd_clear_flags(pmd, _PAGE_ACCESSED);
-}
-
-static inline pmd_t pmd_wrprotect(pmd_t pmd)
-{
-	return pmd_clear_flags(pmd, _PAGE_RW);
-}
-
-static inline pmd_t pmd_mkdirty(pmd_t pmd)
-{
-	return pmd_set_flags(pmd, _PAGE_DIRTY);
-}
-
-static inline pmd_t pmd_mkhuge(pmd_t pmd)
-{
-	return pmd_set_flags(pmd, _PAGE_PSE);
-}
-
-static inline pmd_t pmd_mkyoung(pmd_t pmd)
-{
-	return pmd_set_flags(pmd, _PAGE_ACCESSED);
-}
-
-static inline pmd_t pmd_mkwrite(pmd_t pmd)
-{
-	return pmd_set_flags(pmd, _PAGE_RW);
-}
-
-static inline pmd_t pmd_mknotpresent(pmd_t pmd)
-{
-	return pmd_clear_flags(pmd, _PAGE_PRESENT);
-}
-
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_X86_PGTABLE_64_H */
diff -puN arch/x86/mm/pgtable.c~thp-add-x86-32bit-support arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c~thp-add-x86-32bit-support
+++ a/arch/x86/mm/pgtable.c
@@ -362,7 +362,7 @@ int pmdp_test_and_clear_young(struct vm_
 
 	if (pmd_young(*pmdp))
 		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,
-					 (unsigned long *) &pmdp->pmd);
+					 (unsigned long *)pmdp);
 
 	if (ret)
 		pmd_update(vma->vm_mm, addr, pmdp);
@@ -404,7 +404,7 @@ void pmdp_splitting_flush(struct vm_area
 	int set;
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 	set = !test_and_set_bit(_PAGE_BIT_SPLITTING,
-				(unsigned long *)&pmdp->pmd);
+				(unsigned long *)pmdp);
 	if (set) {
 		pmd_update(vma->vm_mm, address, pmdp);
 		/* need tlb flush only to serialize against gup-fast */
diff -puN include/linux/mm.h~thp-add-x86-32bit-support include/linux/mm.h
--- a/include/linux/mm.h~thp-add-x86-32bit-support
+++ a/include/linux/mm.h
@@ -102,7 +102,11 @@ extern unsigned int kobjsize(const void 
 #define VM_NORESERVE	0x00200000	/* should the VM suppress accounting */
 #define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
 #define VM_NONLINEAR	0x00800000	/* Is non-linear (remap_file_pages) */
+#ifndef CONFIG_TRANSPARENT_HUGEPAGE
 #define VM_MAPPED_COPY	0x01000000	/* T if mapped copy of data (nommu mmap) */
+#else
+#define VM_HUGEPAGE	0x01000000	/* MADV_HUGEPAGE marked this vma */
+#endif
 #define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
 #define VM_ALWAYSDUMP	0x04000000	/* Always include in core dumps */
 
@@ -111,9 +115,6 @@ extern unsigned int kobjsize(const void 
 #define VM_SAO		0x20000000	/* Strong Access Ordering (powerpc) */
 #define VM_PFN_AT_MMAP	0x40000000	/* PFNMAP vma that is fully mapped at mmap time */
 #define VM_MERGEABLE	0x80000000	/* KSM may merge identical pages */
-#if BITS_PER_LONG > 32
-#define VM_HUGEPAGE	0x100000000UL	/* MADV_HUGEPAGE marked this vma */
-#endif
 
 /* Bits set in the VMA until the stack is in its final location */
 #define VM_STACK_INCOMPLETE_SETUP	(VM_RAND_READ | VM_SEQ_READ)
diff -puN mm/Kconfig~thp-add-x86-32bit-support mm/Kconfig
--- a/mm/Kconfig~thp-add-x86-32bit-support
+++ a/mm/Kconfig
@@ -304,7 +304,7 @@ config NOMMU_INITIAL_TRIM_EXCESS
 
 config TRANSPARENT_HUGEPAGE
 	bool "Transparent Hugepage Support" if EMBEDDED
-	depends on X86_64 && MMU
+	depends on X86 && MMU
 	default y
 	help
 	  Transparent Hugepages allows the kernel to use huge pages and
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-compactionc-avoid-double-mem_cgroup_del_lru.patch
writeback-integrated-background-writeback-work.patch
writeback-trace-wakeup-event-for-background-writeback.patch
writeback-stop-background-kupdate-works-from-livelocking-other-works.patch
writeback-stop-background-kupdate-works-from-livelocking-other-works-update.patch
writeback-avoid-livelocking-wb_sync_all-writeback.patch
writeback-avoid-livelocking-wb_sync_all-writeback-update.patch
writeback-check-skipped-pages-on-wb_sync_all.patch
writeback-check-skipped-pages-on-wb_sync_all-update.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
mm-compaction-add-trace-events-for-memory-compaction-activity.patch
mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch
mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode-fix.patch
mm-deactivate-invalidated-pages.patch
mm-deactivate-invalidated-pages-fix.patch
mm-kswapd-stop-high-order-balancing-when-any-suitable-zone-is-balanced.patch
mm-kswapd-keep-kswapd-awake-for-high-order-allocations-until-a-percentage-of-the-node-is-balanced.patch
mm-kswapd-use-the-order-that-kswapd-was-reclaiming-at-for-sleeping_prematurely.patch
mm-kswapd-reset-kswapd_max_order-and-classzone_idx-after-reading.patch
mm-kswapd-treat-zone-all_unreclaimable-in-sleeping_prematurely-similar-to-balance_pgdat.patch
mm-kswapd-use-the-classzone-idx-that-kswapd-was-using-for-sleeping_prematurely.patch
thp-split_huge_page_mm-vma.patch
thp-transparent-hugepage-core.patch
thp-add-x86-32bit-support.patch
thp-mincore-transparent-hugepage-support.patch
thp-add-pmd_modify.patch
thp-mprotect-pass-vma-down-to-page-table-walkers.patch
thp-mprotect-transparent-huge-page-support.patch
memcg-fix-unit-mismatch-in-memcg-oom-limit-calculation.patch

