From: akpm@linux-foundation.org
Subject: [patch 071/119] mm/thp: remove pmd_huge_split_prepare()
Date: Wed, 31 Jan 2018 16:18:24 -0800
Message-ID: <20180201001824.4SulPhCL1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35354 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755806AbeBAAS1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:18:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, catalin.marinas@arm.com, davem@davemloft.net, david.daney@cavium.com, hpa@zytor.com, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, nitin.m.gupta@oracle.com, ralf@linux-mips.org, schwidefsky@de.ibm.com, tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz, vgupta@synopsys.com

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/thp: remove pmd_huge_split_prepare()

Instead of marking the pmd ready for split, invalidate the pmd.  This
should take care of powerpc requirement.  Only side effect is that we mark
the pmd invalid early.  This can result in us blocking access to the page
a bit longer if we race against a thp split.

[kirill.shutemov@linux.intel.com: rebased, dirty THP once]
Link: http://lkml.kernel.org/r/20171213105756.69879-13-kirill.shutemov@linux.intel.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Daney <david.daney@cavium.com>
Cc: David Miller <davem@davemloft.net>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nitin Gupta <nitin.m.gupta@oracle.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Vlastimil Babka <vbabka@suse.cz>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/hash-4k.h  |    2 
 arch/powerpc/include/asm/book3s/64/hash-64k.h |    2 
 arch/powerpc/include/asm/book3s/64/pgtable.h  |    9 --
 arch/powerpc/include/asm/book3s/64/radix.h    |    6 -
 arch/powerpc/mm/pgtable-hash64.c              |   22 ----
 include/asm-generic/pgtable.h                 |    8 -
 mm/huge_memory.c                              |   72 +++++++---------
 7 files changed, 35 insertions(+), 86 deletions(-)

diff -puN arch/powerpc/include/asm/book3s/64/hash-4k.h~mm-thp-remove-pmd_huge_split_prepare arch/powerpc/include/asm/book3s/64/hash-4k.h
--- a/arch/powerpc/include/asm/book3s/64/hash-4k.h~mm-thp-remove-pmd_huge_split_prepare
+++ a/arch/powerpc/include/asm/book3s/64/hash-4k.h
@@ -101,8 +101,6 @@ extern pmd_t hash__pmdp_collapse_flush(s
 extern void hash__pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
 					 pgtable_t pgtable);
 extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
-extern void hash__pmdp_huge_split_prepare(struct vm_area_struct *vma,
-				      unsigned long address, pmd_t *pmdp);
 extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
 				       unsigned long addr, pmd_t *pmdp);
 extern int hash__has_transparent_hugepage(void);
diff -puN arch/powerpc/include/asm/book3s/64/hash-64k.h~mm-thp-remove-pmd_huge_split_prepare arch/powerpc/include/asm/book3s/64/hash-64k.h
--- a/arch/powerpc/include/asm/book3s/64/hash-64k.h~mm-thp-remove-pmd_huge_split_prepare
+++ a/arch/powerpc/include/asm/book3s/64/hash-64k.h
@@ -203,8 +203,6 @@ extern pmd_t hash__pmdp_collapse_flush(s
 extern void hash__pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
 					 pgtable_t pgtable);
 extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
-extern void hash__pmdp_huge_split_prepare(struct vm_area_struct *vma,
-				      unsigned long address, pmd_t *pmdp);
 extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
 				       unsigned long addr, pmd_t *pmdp);
 extern int hash__has_transparent_hugepage(void);
diff -puN arch/powerpc/include/asm/book3s/64/pgtable.h~mm-thp-remove-pmd_huge_split_prepare arch/powerpc/include/asm/book3s/64/pgtable.h
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~mm-thp-remove-pmd_huge_split_prepare
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1140,15 +1140,6 @@ static inline pgtable_t pgtable_trans_hu
 extern pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 			     pmd_t *pmdp);
 
-#define __HAVE_ARCH_PMDP_HUGE_SPLIT_PREPARE
-static inline void pmdp_huge_split_prepare(struct vm_area_struct *vma,
-					   unsigned long address, pmd_t *pmdp)
-{
-	if (radix_enabled())
-		return radix__pmdp_huge_split_prepare(vma, address, pmdp);
-	return hash__pmdp_huge_split_prepare(vma, address, pmdp);
-}
-
 #define pmd_move_must_withdraw pmd_move_must_withdraw
 struct spinlock;
 static inline int pmd_move_must_withdraw(struct spinlock *new_pmd_ptl,
diff -puN arch/powerpc/include/asm/book3s/64/radix.h~mm-thp-remove-pmd_huge_split_prepare arch/powerpc/include/asm/book3s/64/radix.h
--- a/arch/powerpc/include/asm/book3s/64/radix.h~mm-thp-remove-pmd_huge_split_prepare
+++ a/arch/powerpc/include/asm/book3s/64/radix.h
@@ -269,12 +269,6 @@ static inline pmd_t radix__pmd_mkhuge(pm
 		return __pmd(pmd_val(pmd) | _PAGE_PTE | R_PAGE_LARGE);
 	return __pmd(pmd_val(pmd) | _PAGE_PTE);
 }
-static inline void radix__pmdp_huge_split_prepare(struct vm_area_struct *vma,
-					    unsigned long address, pmd_t *pmdp)
-{
-	/* Nothing to do for radix. */
-	return;
-}
 
 extern unsigned long radix__pmd_hugepage_update(struct mm_struct *mm, unsigned long addr,
 					  pmd_t *pmdp, unsigned long clr,
diff -puN arch/powerpc/mm/pgtable-hash64.c~mm-thp-remove-pmd_huge_split_prepare arch/powerpc/mm/pgtable-hash64.c
--- a/arch/powerpc/mm/pgtable-hash64.c~mm-thp-remove-pmd_huge_split_prepare
+++ a/arch/powerpc/mm/pgtable-hash64.c
@@ -296,28 +296,6 @@ pgtable_t hash__pgtable_trans_huge_withd
 	return pgtable;
 }
 
-void hash__pmdp_huge_split_prepare(struct vm_area_struct *vma,
-			       unsigned long address, pmd_t *pmdp)
-{
-	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
-	VM_BUG_ON(REGION_ID(address) != USER_REGION_ID);
-	VM_BUG_ON(pmd_devmap(*pmdp));
-
-	/*
-	 * We can't mark the pmd none here, because that will cause a race
-	 * against exit_mmap. We need to continue mark pmd TRANS HUGE, while
-	 * we spilt, but at the same time we wan't rest of the ppc64 code
-	 * not to insert hash pte on this, because we will be modifying
-	 * the deposited pgtable in the caller of this function. Hence
-	 * clear the _PAGE_USER so that we move the fault handling to
-	 * higher level function and that will serialize against ptl.
-	 * We need to flush existing hash pte entries here even though,
-	 * the translation is still valid, because we will withdraw
-	 * pgtable_t after this.
-	 */
-	pmd_hugepage_update(vma->vm_mm, address, pmdp, 0, _PAGE_PRIVILEGED);
-}
-
 /*
  * A linux hugepage PMD was changed and the corresponding hash table entries
  * neesd to be flushed.
diff -puN include/asm-generic/pgtable.h~mm-thp-remove-pmd_huge_split_prepare include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-thp-remove-pmd_huge_split_prepare
+++ a/include/asm-generic/pgtable.h
@@ -329,14 +329,6 @@ extern pmd_t pmdp_invalidate(struct vm_a
 			    pmd_t *pmdp);
 #endif
 
-#ifndef __HAVE_ARCH_PMDP_HUGE_SPLIT_PREPARE
-static inline void pmdp_huge_split_prepare(struct vm_area_struct *vma,
-					   unsigned long address, pmd_t *pmdp)
-{
-
-}
-#endif
-
 #ifndef __HAVE_ARCH_PTE_SAME
 static inline int pte_same(pte_t pte_a, pte_t pte_b)
 {
diff -puN mm/huge_memory.c~mm-thp-remove-pmd_huge_split_prepare mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-remove-pmd_huge_split_prepare
+++ a/mm/huge_memory.c
@@ -2063,7 +2063,7 @@ static void __split_huge_pmd_locked(stru
 	struct mm_struct *mm = vma->vm_mm;
 	struct page *page;
 	pgtable_t pgtable;
-	pmd_t old, _pmd;
+	pmd_t old_pmd, _pmd;
 	bool young, write, soft_dirty, pmd_migration = false;
 	unsigned long addr;
 	int i;
@@ -2106,23 +2106,50 @@ static void __split_huge_pmd_locked(stru
 		return __split_huge_zero_page_pmd(vma, haddr, pmd);
 	}
 
+	/*
+	 * Up to this point the pmd is present and huge and userland has the
+	 * whole access to the hugepage during the split (which happens in
+	 * place). If we overwrite the pmd with the not-huge version pointing
+	 * to the pte here (which of course we could if all CPUs were bug
+	 * free), userland could trigger a small page size TLB miss on the
+	 * small sized TLB while the hugepage TLB entry is still established in
+	 * the huge TLB. Some CPU doesn't like that.
+	 * See http://support.amd.com/us/Processor_TechDocs/41322.pdf, Erratum
+	 * 383 on page 93. Intel should be safe but is also warns that it's
+	 * only safe if the permission and cache attributes of the two entries
+	 * loaded in the two TLB is identical (which should be the case here).
+	 * But it is generally safer to never allow small and huge TLB entries
+	 * for the same virtual address to be loaded simultaneously. So instead
+	 * of doing "pmd_populate(); flush_pmd_tlb_range();" we first mark the
+	 * current pmd notpresent (atomically because here the pmd_trans_huge
+	 * must remain set at all times on the pmd until the split is complete
+	 * for this pmd), then we flush the SMP TLB and finally we write the
+	 * non-huge version of the pmd entry with pmd_populate.
+	 */
+	old_pmd = pmdp_invalidate(vma, haddr, pmd);
+
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
-	pmd_migration = is_pmd_migration_entry(*pmd);
+	pmd_migration = is_pmd_migration_entry(old_pmd);
 	if (pmd_migration) {
 		swp_entry_t entry;
 
-		entry = pmd_to_swp_entry(*pmd);
+		entry = pmd_to_swp_entry(old_pmd);
 		page = pfn_to_page(swp_offset(entry));
 	} else
 #endif
-		page = pmd_page(*pmd);
+		page = pmd_page(old_pmd);
 	VM_BUG_ON_PAGE(!page_count(page), page);
 	page_ref_add(page, HPAGE_PMD_NR - 1);
-	write = pmd_write(*pmd);
-	young = pmd_young(*pmd);
-	soft_dirty = pmd_soft_dirty(*pmd);
+	if (pmd_dirty(old_pmd))
+		SetPageDirty(page);
+	write = pmd_write(old_pmd);
+	young = pmd_young(old_pmd);
+	soft_dirty = pmd_soft_dirty(old_pmd);
 
-	pmdp_huge_split_prepare(vma, haddr, pmd);
+	/*
+	 * Withdraw the table only after we mark the pmd entry invalid.
+	 * This's critical for some architectures (Power).
+	 */
 	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
 	pmd_populate(mm, &_pmd, pgtable);
 
@@ -2176,35 +2203,6 @@ static void __split_huge_pmd_locked(stru
 	}
 
 	smp_wmb(); /* make pte visible before pmd */
-	/*
-	 * Up to this point the pmd is present and huge and userland has the
-	 * whole access to the hugepage during the split (which happens in
-	 * place). If we overwrite the pmd with the not-huge version pointing
-	 * to the pte here (which of course we could if all CPUs were bug
-	 * free), userland could trigger a small page size TLB miss on the
-	 * small sized TLB while the hugepage TLB entry is still established in
-	 * the huge TLB. Some CPU doesn't like that.
-	 * See http://support.amd.com/us/Processor_TechDocs/41322.pdf, Erratum
-	 * 383 on page 93. Intel should be safe but is also warns that it's
-	 * only safe if the permission and cache attributes of the two entries
-	 * loaded in the two TLB is identical (which should be the case here).
-	 * But it is generally safer to never allow small and huge TLB entries
-	 * for the same virtual address to be loaded simultaneously. So instead
-	 * of doing "pmd_populate(); flush_pmd_tlb_range();" we first mark the
-	 * current pmd notpresent (atomically because here the pmd_trans_huge
-	 * must remain set at all times on the pmd until the split is complete
-	 * for this pmd), then we flush the SMP TLB and finally we write the
-	 * non-huge version of the pmd entry with pmd_populate.
-	 */
-	old = pmdp_invalidate(vma, haddr, pmd);
-
-	/*
-	 * Transfer dirty bit using value returned by pmd_invalidate() to be
-	 * sure we don't race with CPU that can set the bit under us.
-	 */
-	if (pmd_dirty(old))
-		SetPageDirty(page);
