From: akpm@linux-foundation.org
Subject: [merged]
 mm-remove-remaining-references-to-numa-hinting-bits-and-helpers.patch
 removed from -mm tree
Date: Fri, 13 Feb 2015 12:19:27 -0800
Message-ID: <54de5c4f.yLEAz5ACEeWKP8l9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48597 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbbBMUT2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:19:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, broonie@kernel.org, davej@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, mingo@redhat.com, paulus@samba.org, riel@redhat.com, sasha.levin@oracle.com, sfr@canb.auug.org.au, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove remaining references to NUMA hinting bits and helpers
has been removed from the -mm tree.  Its filename was
     mm-remove-remaining-references-to-numa-hinting-bits-and-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: remove remaining references to NUMA hinting bits and helpers

This patch removes the NUMA PTE bits and associated helpers.  As a
side-effect it increases the maximum possible swap space on x86-64.

One potential source of problems is races between the marking of PTEs
PROT_NONE, NUMA hinting faults and migration.  It must be guaranteed that
a PTE being protected is not faulted in parallel, seen as a pte_none and
corrupting memory.  The base case is safe but transhuge has problems in
the past due to an different migration mechanism and a dependance on page
lock to serialise migrations and warrants a closer look.

task_work hinting update			parallel fault
------------------------			--------------
change_pmd_range
  change_huge_pmd
    __pmd_trans_huge_lock
      pmdp_get_and_clear
						__handle_mm_fault
						pmd_none
						  do_huge_pmd_anonymous_page
						  read? pmd_lock blocks until hinting complete, fail !pmd_none test
						  write? __do_huge_pmd_anonymous_page acquires pmd_lock, checks pmd_none
      pmd_modify
      set_pmd_at

task_work hinting update			parallel migration
------------------------			------------------
change_pmd_range
  change_huge_pmd
    __pmd_trans_huge_lock
      pmdp_get_and_clear
						__handle_mm_fault
						  do_huge_pmd_numa_page
						    migrate_misplaced_transhuge_page
						    pmd_lock waits for updates to complete, recheck pmd_same
      pmd_modify
      set_pmd_at

Both of those are safe and the case where a transhuge page is inserted
during a protection update is unchanged.  The case where two processes try
migrating at the same time is unchanged by this series so should still be
ok.  I could not find a case where we are accidentally depending on the
PTE not being cleared and flushed.  If one is missed, it'll manifest as
corruption problems that start triggering shortly after this series is
merged and only happen when NUMA balancing is enabled.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/pgtable.h    |   54 --------
 arch/powerpc/include/asm/pte-common.h |    5 
 arch/powerpc/include/asm/pte-hash64.h |    6 
 arch/x86/include/asm/pgtable.h        |   22 ---
 arch/x86/include/asm/pgtable_64.h     |    5 
 arch/x86/include/asm/pgtable_types.h  |   41 ------
 include/asm-generic/pgtable.h         |  155 ------------------------
 include/linux/swapops.h               |    2 
 8 files changed, 7 insertions(+), 283 deletions(-)

diff -puN arch/powerpc/include/asm/pgtable.h~mm-remove-remaining-references-to-numa-hinting-bits-and-helpers arch/powerpc/include/asm/pgtable.h
--- a/arch/powerpc/include/asm/pgtable.h~mm-remove-remaining-references-to-numa-hinting-bits-and-helpers
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -55,64 +55,12 @@ static inline int pmd_protnone(pmd_t pmd
 {
 	return pte_protnone(pmd_pte(pmd));
 }
-
-static inline int pte_present(pte_t pte)
-{
-	return pte_val(pte) & _PAGE_NUMA_MASK;
-}
-
-#define pte_present_nonuma pte_present_nonuma
-static inline int pte_present_nonuma(pte_t pte)
-{
-	return pte_val(pte) & (_PAGE_PRESENT);
-}
-
-#define ptep_set_numa ptep_set_numa
-static inline void ptep_set_numa(struct mm_struct *mm, unsigned long addr,
-				 pte_t *ptep)
-{
-	if ((pte_val(*ptep) & _PAGE_PRESENT) == 0)
-		VM_BUG_ON(1);
-
-	pte_update(mm, addr, ptep, _PAGE_PRESENT, _PAGE_NUMA, 0);
-	return;
-}
-
-#define pmdp_set_numa pmdp_set_numa
-static inline void pmdp_set_numa(struct mm_struct *mm, unsigned long addr,
-				 pmd_t *pmdp)
-{
-	if ((pmd_val(*pmdp) & _PAGE_PRESENT) == 0)
-		VM_BUG_ON(1);
-
-	pmd_hugepage_update(mm, addr, pmdp, _PAGE_PRESENT, _PAGE_NUMA);
-	return;
-}
-
-/*
- * Generic NUMA pte helpers expect pteval_t and pmdval_t types to exist
- * which was inherited from x86. For the purposes of powerpc pte_basic_t and
- * pmd_t are equivalent
- */
-#define pteval_t pte_basic_t
-#define pmdval_t pmd_t
-static inline pteval_t ptenuma_flags(pte_t pte)
-{
-	return pte_val(pte) & _PAGE_NUMA_MASK;
-}
-
-static inline pmdval_t pmdnuma_flags(pmd_t pmd)
-{
-	return pmd_val(pmd) & _PAGE_NUMA_MASK;
-}
-
-# else
+#endif /* CONFIG_NUMA_BALANCING */
 
 static inline int pte_present(pte_t pte)
 {
 	return pte_val(pte) & _PAGE_PRESENT;
 }
-#endif /* CONFIG_NUMA_BALANCING */
 
 /* Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
diff -puN arch/powerpc/include/asm/pte-common.h~mm-remove-remaining-references-to-numa-hinting-bits-and-helpers arch/powerpc/include/asm/pte-common.h
--- a/arch/powerpc/include/asm/pte-common.h~mm-remove-remaining-references-to-numa-hinting-bits-and-helpers
+++ a/arch/powerpc/include/asm/pte-common.h
@@ -104,11 +104,6 @@ extern unsigned long bad_call_to_PMD_PAG
 			 _PAGE_USER | _PAGE_ACCESSED | _PAGE_RO | \
 			 _PAGE_RW | _PAGE_HWWRITE | _PAGE_DIRTY | _PAGE_EXEC)
 
-#ifdef CONFIG_NUMA_BALANCING
-/* Mask of bits that distinguish present and numa ptes */
-#define _PAGE_NUMA_MASK (_PAGE_NUMA|_PAGE_PRESENT)
-#endif
-
 /*
  * We define 2 sets of base prot bits, one for basic pages (ie,
  * cacheable kernel and user pages) and one for non cacheable
diff -puN arch/powerpc/include/asm/pte-hash64.h~mm-remove-remaining-references-to-numa-hinting-bits-and-helpers arch/powerpc/include/asm/pte-hash64.h
--- a/arch/powerpc/include/asm/pte-hash64.h~mm-remove-remaining-references-to-numa-hinting-bits-and-helpers
+++ a/arch/powerpc/include/asm/pte-hash64.h
@@ -27,12 +27,6 @@
 #define _PAGE_RW		0x0200 /* software: user write access allowed */
 #define _PAGE_BUSY		0x0800 /* software: PTE & hash are busy */
 
-/*
- * Used for tracking numa faults
- */
-#define _PAGE_NUMA	0x00000010 /* Gather numa placement stats */
-
-
 /* No separate kernel read-only */
 #define _PAGE_KERNEL_RW		(_PAGE_RW | _PAGE_DIRTY) /* user access blocked by key */
 #define _PAGE_KERNEL_RO		 _PAGE_KERNEL_RW
diff -puN arch/x86/include/asm/pgtable.h~mm-remove-remaining-references-to-numa-hinting-bits-and-helpers arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-remove-remaining-references-to-numa-hinting-bits-and-helpers
+++ a/arch/x86/include/asm/pgtable.h
@@ -300,7 +300,7 @@ static inline pmd_t pmd_mkwrite(pmd_t pm
 
 static inline pmd_t pmd_mknotpresent(pmd_t pmd)
 {
-	return pmd_clear_flags(pmd, _PAGE_PRESENT);
+	return pmd_clear_flags(pmd, _PAGE_PRESENT | _PAGE_PROTNONE);
 }
 
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
@@ -443,13 +443,6 @@ static inline int pte_same(pte_t a, pte_
 
 static inline int pte_present(pte_t a)
 {
-	return pte_flags(a) & (_PAGE_PRESENT | _PAGE_PROTNONE |
-			       _PAGE_NUMA);
-}
-
-#define pte_present_nonuma pte_present_nonuma
-static inline int pte_present_nonuma(pte_t a)
-{
 	return pte_flags(a) & (_PAGE_PRESENT | _PAGE_PROTNONE);
 }
 
@@ -459,7 +452,7 @@ static inline bool pte_accessible(struct
 	if (pte_flags(a) & _PAGE_PRESENT)
 		return true;
 
-	if ((pte_flags(a) & (_PAGE_PROTNONE | _PAGE_NUMA)) &&
+	if ((pte_flags(a) & _PAGE_PROTNONE) &&
 			mm_tlb_flush_pending(mm))
 		return true;
 
@@ -479,8 +472,7 @@ static inline int pmd_present(pmd_t pmd)
 	 * the _PAGE_PSE flag will remain set at all times while the
 	 * _PAGE_PRESENT bit is clear).
 	 */
-	return pmd_flags(pmd) & (_PAGE_PRESENT | _PAGE_PROTNONE | _PAGE_PSE |
-				 _PAGE_NUMA);
+	return pmd_flags(pmd) & (_PAGE_PRESENT | _PAGE_PROTNONE | _PAGE_PSE);
 }
 
 #ifdef CONFIG_NUMA_BALANCING
@@ -555,11 +547,6 @@ static inline pte_t *pte_offset_kernel(p
 
 static inline int pmd_bad(pmd_t pmd)
 {
-#ifdef CONFIG_NUMA_BALANCING
-	/* pmd_numa check */
-	if ((pmd_flags(pmd) & (_PAGE_NUMA|_PAGE_PRESENT)) == _PAGE_NUMA)
-		return 0;
-#endif
 	return (pmd_flags(pmd) & ~_PAGE_USER) != _KERNPG_TABLE;
 }
 
@@ -878,19 +865,16 @@ static inline void update_mmu_cache_pmd(
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
 {
-	VM_BUG_ON(pte_present_nonuma(pte));
 	return pte_set_flags(pte, _PAGE_SWP_SOFT_DIRTY);
 }
 
 static inline int pte_swp_soft_dirty(pte_t pte)
 {
-	VM_BUG_ON(pte_present_nonuma(pte));
 	return pte_flags(pte) & _PAGE_SWP_SOFT_DIRTY;
 }
 
 static inline pte_t pte_swp_clear_soft_dirty(pte_t pte)
 {
-	VM_BUG_ON(pte_present_nonuma(pte));
 	return pte_clear_flags(pte, _PAGE_SWP_SOFT_DIRTY);
 }
 #endif
diff -puN arch/x86/include/asm/pgtable_64.h~mm-remove-remaining-references-to-numa-hinting-bits-and-helpers arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h~mm-remove-remaining-references-to-numa-hinting-bits-and-helpers
+++ a/arch/x86/include/asm/pgtable_64.h
@@ -142,12 +142,7 @@ static inline int pgd_large(pgd_t pgd) {
 
 /* Encode and de-code a swap entry */
 #define SWP_TYPE_BITS 5
-#ifdef CONFIG_NUMA_BALANCING
-/* Automatic NUMA balancing needs to be distinguishable from swap entries */
-#define SWP_OFFSET_SHIFT (_PAGE_BIT_PROTNONE + 2)
-#else
 #define SWP_OFFSET_SHIFT (_PAGE_BIT_PROTNONE + 1)
-#endif
 
 #define MAX_SWAPFILES_CHECK() BUILD_BUG_ON(MAX_SWAPFILES_SHIFT > SWP_TYPE_BITS)
 
diff -puN arch/x86/include/asm/pgtable_types.h~mm-remove-remaining-references-to-numa-hinting-bits-and-helpers arch/x86/include/asm/pgtable_types.h
--- a/arch/x86/include/asm/pgtable_types.h~mm-remove-remaining-references-to-numa-hinting-bits-and-helpers
+++ a/arch/x86/include/asm/pgtable_types.h
@@ -27,14 +27,6 @@
 #define _PAGE_BIT_SOFT_DIRTY	_PAGE_BIT_SOFTW3 /* software dirty tracking */
 #define _PAGE_BIT_NX           63       /* No execute: only valid after cpuid check */
 
-/*
- * Swap offsets on configurations that allow automatic NUMA balancing use the
- * bits after _PAGE_BIT_GLOBAL. To uniquely distinguish NUMA hinting PTEs from
- * swap entries, we use the first bit after _PAGE_BIT_GLOBAL and shrink the
- * maximum possible swap space from 16TB to 8TB.
- */
-#define _PAGE_BIT_NUMA		(_PAGE_BIT_GLOBAL+1)
-
 /* If _PAGE_BIT_PRESENT is clear, we use these: */
 /* - if the user mapped it with PROT_NONE; pte_present gives true */
 #define _PAGE_BIT_PROTNONE	_PAGE_BIT_GLOBAL
@@ -76,21 +68,6 @@
 #endif
 
 /*
- * _PAGE_NUMA distinguishes between a numa hinting minor fault and a page
- * that is not present. The hinting fault gathers numa placement statistics
- * (see pte_numa()). The bit is always zero when the PTE is not present.
- *
- * The bit picked must be always zero when the pmd is present and not
- * present, so that we don't lose information when we set it while
- * atomically clearing the present bit.
- */
-#ifdef CONFIG_NUMA_BALANCING
-#define _PAGE_NUMA	(_AT(pteval_t, 1) << _PAGE_BIT_NUMA)
-#else
-#define _PAGE_NUMA	(_AT(pteval_t, 0))
-#endif
-
-/*
  * Tracking soft dirty bit when a page goes to a swap is tricky.
  * We need a bit which can be stored in pte _and_ not conflict
  * with swap entry format. On x86 bits 6 and 7 are *not* involved
@@ -122,8 +99,8 @@
 /* Set of bits not changed in pte_modify */
 #define _PAGE_CHG_MASK	(PTE_PFN_MASK | _PAGE_PCD | _PAGE_PWT |		\
 			 _PAGE_SPECIAL | _PAGE_ACCESSED | _PAGE_DIRTY |	\
-			 _PAGE_SOFT_DIRTY | _PAGE_NUMA)
-#define _HPAGE_CHG_MASK (_PAGE_CHG_MASK | _PAGE_PSE | _PAGE_NUMA)
+			 _PAGE_SOFT_DIRTY)
+#define _HPAGE_CHG_MASK (_PAGE_CHG_MASK | _PAGE_PSE)
 
 /*
  * The cache modes defined here are used to translate between pure SW usage
@@ -324,20 +301,6 @@ static inline pteval_t pte_flags(pte_t p
 	return native_pte_val(pte) & PTE_FLAGS_MASK;
 }
 
-#ifdef CONFIG_NUMA_BALANCING
-/* Set of bits that distinguishes present, prot_none and numa ptes */
-#define _PAGE_NUMA_MASK (_PAGE_NUMA|_PAGE_PROTNONE|_PAGE_PRESENT)
-static inline pteval_t ptenuma_flags(pte_t pte)
-{
-	return pte_flags(pte) & _PAGE_NUMA_MASK;
-}
-
-static inline pmdval_t pmdnuma_flags(pmd_t pmd)
-{
-	return pmd_flags(pmd) & _PAGE_NUMA_MASK;
-}
-#endif /* CONFIG_NUMA_BALANCING */
-
 #define pgprot_val(x)	((x).pgprot)
 #define __pgprot(x)	((pgprot_t) { (x) } )
 
diff -puN include/asm-generic/pgtable.h~mm-remove-remaining-references-to-numa-hinting-bits-and-helpers include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-remove-remaining-references-to-numa-hinting-bits-and-helpers
+++ a/include/asm-generic/pgtable.h
@@ -244,10 +244,6 @@ static inline int pmd_same(pmd_t pmd_a,
 # define pte_accessible(mm, pte)	((void)(pte), 1)
 #endif
 
-#ifndef pte_present_nonuma
-#define pte_present_nonuma(pte) pte_present(pte)
-#endif
-
 #ifndef flush_tlb_fix_spurious_fault
 #define flush_tlb_fix_spurious_fault(vma, address) flush_tlb_page(vma, address)
 #endif
@@ -693,157 +689,6 @@ static inline int pmd_protnone(pmd_t pmd
 }
 #endif /* CONFIG_NUMA_BALANCING */
 
-#ifdef CONFIG_NUMA_BALANCING
-/*
- * _PAGE_NUMA distinguishes between an unmapped page table entry, an entry that
- * is protected for PROT_NONE and a NUMA hinting fault entry. If the
- * architecture defines __PAGE_PROTNONE then it should take that into account
- * but those that do not can rely on the fact that the NUMA hinting scanner
- * skips inaccessible VMAs.
- *
- * pte/pmd_present() returns true if pte/pmd_numa returns true. Page
- * fault triggers on those regions if pte/pmd_numa returns true
- * (because _PAGE_PRESENT is not set).
- */
-#ifndef pte_numa
-static inline int pte_numa(pte_t pte)
-{
-	return ptenuma_flags(pte) == _PAGE_NUMA;
-}
-#endif
-
-#ifndef pmd_numa
-static inline int pmd_numa(pmd_t pmd)
-{
-	return pmdnuma_flags(pmd) == _PAGE_NUMA;
-}
-#endif
-
-/*
- * pte/pmd_mknuma sets the _PAGE_ACCESSED bitflag automatically
- * because they're called by the NUMA hinting minor page fault. If we
- * wouldn't set the _PAGE_ACCESSED bitflag here, the TLB miss handler
- * would be forced to set it later while filling the TLB after we
- * return to userland. That would trigger a second write to memory
- * that we optimize away by setting _PAGE_ACCESSED here.
- */
-#ifndef pte_mknonnuma
-static inline pte_t pte_mknonnuma(pte_t pte)
-{
-	pteval_t val = pte_val(pte);
-
-	val &= ~_PAGE_NUMA;
-	val |= (_PAGE_PRESENT|_PAGE_ACCESSED);
-	return __pte(val);
-}
-#endif
-
-#ifndef pmd_mknonnuma
-static inline pmd_t pmd_mknonnuma(pmd_t pmd)
-{
-	pmdval_t val = pmd_val(pmd);
-
-	val &= ~_PAGE_NUMA;
-	val |= (_PAGE_PRESENT|_PAGE_ACCESSED);
-
-	return __pmd(val);
-}
-#endif
-
-#ifndef pte_mknuma
-static inline pte_t pte_mknuma(pte_t pte)
-{
-	pteval_t val = pte_val(pte);
-
-	VM_BUG_ON(!(val & _PAGE_PRESENT));
-
-	val &= ~_PAGE_PRESENT;
-	val |= _PAGE_NUMA;
-
-	return __pte(val);
-}
-#endif
-
-#ifndef ptep_set_numa
-static inline void ptep_set_numa(struct mm_struct *mm, unsigned long addr,
-				 pte_t *ptep)
-{
-	pte_t ptent = *ptep;
-
-	ptent = pte_mknuma(ptent);
-	set_pte_at(mm, addr, ptep, ptent);
-	return;
-}
-#endif
-
-#ifndef pmd_mknuma
-static inline pmd_t pmd_mknuma(pmd_t pmd)
-{
-	pmdval_t val = pmd_val(pmd);
-
-	val &= ~_PAGE_PRESENT;
-	val |= _PAGE_NUMA;
-
-	return __pmd(val);
-}
-#endif
-
-#ifndef pmdp_set_numa
-static inline void pmdp_set_numa(struct mm_struct *mm, unsigned long addr,
-				 pmd_t *pmdp)
-{
-	pmd_t pmd = *pmdp;
-
-	pmd = pmd_mknuma(pmd);
-	set_pmd_at(mm, addr, pmdp, pmd);
-	return;
-}
-#endif
-#else
-static inline int pmd_numa(pmd_t pmd)
-{
-	return 0;
-}
-
-static inline int pte_numa(pte_t pte)
-{
-	return 0;
-}
-
-static inline pte_t pte_mknonnuma(pte_t pte)
-{
-	return pte;
-}
-
-static inline pmd_t pmd_mknonnuma(pmd_t pmd)
-{
-	return pmd;
-}
-
-static inline pte_t pte_mknuma(pte_t pte)
-{
-	return pte;
-}
-
-static inline void ptep_set_numa(struct mm_struct *mm, unsigned long addr,
-				 pte_t *ptep)
-{
-	return;
-}
-
-
-static inline pmd_t pmd_mknuma(pmd_t pmd)
-{
-	return pmd;
-}
-
-static inline void pmdp_set_numa(struct mm_struct *mm, unsigned long addr,
-				 pmd_t *pmdp)
-{
-	return ;
-}
-#endif /* CONFIG_NUMA_BALANCING */
