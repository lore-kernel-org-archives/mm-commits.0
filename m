From: akpm@linux-foundation.org
Subject: [merged]
 powerpc-mm-add-new-set-flag-argument-to-pte-pmd-update-function.patch
 removed from -mm tree
Date: Tue, 18 Feb 2014 12:12:21 -0800
Message-ID: <5303bea5.9uZdeuvCJ+lAJXjj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaBRUMW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 15:12:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, paulus@samba.org, mgorman@suse.de, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com

Subject: [merged] powerpc-mm-add-new-set-flag-argument-to-pte-pmd-update-function.patch removed from -mm tree
To: aneesh.kumar@linux.vnet.ibm.com,benh@kernel.crashing.org,mgorman@suse.de,paulus@samba.org,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 12:12:21 -0800


The patch titled
     Subject: powerpc: mm: add new set flag argument to pte/pmd update function
has been removed from the -mm tree.  Its filename was
     powerpc-mm-add-new-set-flag-argument-to-pte-pmd-update-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: powerpc: mm: add new set flag argument to pte/pmd update function

We will use this later to set the _PAGE_NUMA bit.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/hugetlb.h       |    2 -
 arch/powerpc/include/asm/pgtable-ppc64.h |   26 ++++++++++++---------
 arch/powerpc/mm/pgtable_64.c             |   12 +++++----
 arch/powerpc/mm/subpage-prot.c           |    2 -
 4 files changed, 24 insertions(+), 18 deletions(-)

diff -puN arch/powerpc/include/asm/hugetlb.h~powerpc-mm-add-new-set-flag-argument-to-pte-pmd-update-function arch/powerpc/include/asm/hugetlb.h
--- a/arch/powerpc/include/asm/hugetlb.h~powerpc-mm-add-new-set-flag-argument-to-pte-pmd-update-function
+++ a/arch/powerpc/include/asm/hugetlb.h
@@ -127,7 +127,7 @@ static inline pte_t huge_ptep_get_and_cl
 					    unsigned long addr, pte_t *ptep)
 {
 #ifdef CONFIG_PPC64
-	return __pte(pte_update(mm, addr, ptep, ~0UL, 1));
+	return __pte(pte_update(mm, addr, ptep, ~0UL, 0, 1));
 #else
 	return __pte(pte_update(ptep, ~0UL, 0));
 #endif
diff -puN arch/powerpc/include/asm/pgtable-ppc64.h~powerpc-mm-add-new-set-flag-argument-to-pte-pmd-update-function arch/powerpc/include/asm/pgtable-ppc64.h
--- a/arch/powerpc/include/asm/pgtable-ppc64.h~powerpc-mm-add-new-set-flag-argument-to-pte-pmd-update-function
+++ a/arch/powerpc/include/asm/pgtable-ppc64.h
@@ -195,6 +195,7 @@ extern void hpte_need_flush(struct mm_st
 static inline unsigned long pte_update(struct mm_struct *mm,
 				       unsigned long addr,
 				       pte_t *ptep, unsigned long clr,
+				       unsigned long set,
 				       int huge)
 {
 #ifdef PTE_ATOMIC_UPDATES
@@ -205,14 +206,15 @@ static inline unsigned long pte_update(s
 	andi.	%1,%0,%6\n\
 	bne-	1b \n\
 	andc	%1,%0,%4 \n\
+	or	%1,%1,%7\n\
 	stdcx.	%1,0,%3 \n\
 	bne-	1b"
 	: "=&r" (old), "=&r" (tmp), "=m" (*ptep)
-	: "r" (ptep), "r" (clr), "m" (*ptep), "i" (_PAGE_BUSY)
+	: "r" (ptep), "r" (clr), "m" (*ptep), "i" (_PAGE_BUSY), "r" (set)
 	: "cc" );
 #else
 	unsigned long old = pte_val(*ptep);
-	*ptep = __pte(old & ~clr);
+	*ptep = __pte((old & ~clr) | set);
 #endif
 	/* huge pages use the old page table lock */
 	if (!huge)
@@ -231,9 +233,9 @@ static inline int __ptep_test_and_clear_
 {
 	unsigned long old;
 
-       	if ((pte_val(*ptep) & (_PAGE_ACCESSED | _PAGE_HASHPTE)) == 0)
+	if ((pte_val(*ptep) & (_PAGE_ACCESSED | _PAGE_HASHPTE)) == 0)
 		return 0;
-	old = pte_update(mm, addr, ptep, _PAGE_ACCESSED, 0);
+	old = pte_update(mm, addr, ptep, _PAGE_ACCESSED, 0, 0);
 	return (old & _PAGE_ACCESSED) != 0;
 }
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
@@ -252,7 +254,7 @@ static inline void ptep_set_wrprotect(st
 	if ((pte_val(*ptep) & _PAGE_RW) == 0)
 		return;
 
-	pte_update(mm, addr, ptep, _PAGE_RW, 0);
+	pte_update(mm, addr, ptep, _PAGE_RW, 0, 0);
 }
 
 static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
@@ -261,7 +263,7 @@ static inline void huge_ptep_set_wrprote
 	if ((pte_val(*ptep) & _PAGE_RW) == 0)
 		return;
 
-	pte_update(mm, addr, ptep, _PAGE_RW, 1);
+	pte_update(mm, addr, ptep, _PAGE_RW, 0, 1);
 }
 
 /*
@@ -284,14 +286,14 @@ static inline void huge_ptep_set_wrprote
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 				       unsigned long addr, pte_t *ptep)
 {
-	unsigned long old = pte_update(mm, addr, ptep, ~0UL, 0);
+	unsigned long old = pte_update(mm, addr, ptep, ~0UL, 0, 0);
 	return __pte(old);
 }
 
 static inline void pte_clear(struct mm_struct *mm, unsigned long addr,
 			     pte_t * ptep)
 {
-	pte_update(mm, addr, ptep, ~0UL, 0);
+	pte_update(mm, addr, ptep, ~0UL, 0, 0);
 }
 
 
@@ -506,7 +508,9 @@ extern int pmdp_set_access_flags(struct
 
 extern unsigned long pmd_hugepage_update(struct mm_struct *mm,
 					 unsigned long addr,
-					 pmd_t *pmdp, unsigned long clr);
+					 pmd_t *pmdp,
+					 unsigned long clr,
+					 unsigned long set);
 
 static inline int __pmdp_test_and_clear_young(struct mm_struct *mm,
 					      unsigned long addr, pmd_t *pmdp)
@@ -515,7 +519,7 @@ static inline int __pmdp_test_and_clear_
 
 	if ((pmd_val(*pmdp) & (_PAGE_ACCESSED | _PAGE_HASHPTE)) == 0)
 		return 0;
-	old = pmd_hugepage_update(mm, addr, pmdp, _PAGE_ACCESSED);
+	old = pmd_hugepage_update(mm, addr, pmdp, _PAGE_ACCESSED, 0);
 	return ((old & _PAGE_ACCESSED) != 0);
 }
 
@@ -542,7 +546,7 @@ static inline void pmdp_set_wrprotect(st
 	if ((pmd_val(*pmdp) & _PAGE_RW) == 0)
 		return;
 
-	pmd_hugepage_update(mm, addr, pmdp, _PAGE_RW);
+	pmd_hugepage_update(mm, addr, pmdp, _PAGE_RW, 0);
 }
 
 #define __HAVE_ARCH_PMDP_SPLITTING_FLUSH
diff -puN arch/powerpc/mm/pgtable_64.c~powerpc-mm-add-new-set-flag-argument-to-pte-pmd-update-function arch/powerpc/mm/pgtable_64.c
--- a/arch/powerpc/mm/pgtable_64.c~powerpc-mm-add-new-set-flag-argument-to-pte-pmd-update-function
+++ a/arch/powerpc/mm/pgtable_64.c
@@ -510,7 +510,8 @@ int pmdp_set_access_flags(struct vm_area
 }
 
 unsigned long pmd_hugepage_update(struct mm_struct *mm, unsigned long addr,
-				  pmd_t *pmdp, unsigned long clr)
+				  pmd_t *pmdp, unsigned long clr,
+				  unsigned long set)
 {
 
 	unsigned long old, tmp;
@@ -526,14 +527,15 @@ unsigned long pmd_hugepage_update(struct
 		andi.	%1,%0,%6\n\
 		bne-	1b \n\
 		andc	%1,%0,%4 \n\
+		or	%1,%1,%7\n\
 		stdcx.	%1,0,%3 \n\
 		bne-	1b"
 	: "=&r" (old), "=&r" (tmp), "=m" (*pmdp)
-	: "r" (pmdp), "r" (clr), "m" (*pmdp), "i" (_PAGE_BUSY)
+	: "r" (pmdp), "r" (clr), "m" (*pmdp), "i" (_PAGE_BUSY), "r" (set)
 	: "cc" );
 #else
 	old = pmd_val(*pmdp);
-	*pmdp = __pmd(old & ~clr);
+	*pmdp = __pmd((old & ~clr) | set);
 #endif
 	if (old & _PAGE_HASHPTE)
 		hpte_do_hugepage_flush(mm, addr, pmdp);
@@ -708,7 +710,7 @@ void set_pmd_at(struct mm_struct *mm, un
 void pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 		     pmd_t *pmdp)
 {
-	pmd_hugepage_update(vma->vm_mm, address, pmdp, _PAGE_PRESENT);
+	pmd_hugepage_update(vma->vm_mm, address, pmdp, _PAGE_PRESENT, 0);
 }
 
 /*
@@ -835,7 +837,7 @@ pmd_t pmdp_get_and_clear(struct mm_struc
 	unsigned long old;
 	pgtable_t *pgtable_slot;
 
-	old = pmd_hugepage_update(mm, addr, pmdp, ~0UL);
+	old = pmd_hugepage_update(mm, addr, pmdp, ~0UL, 0);
 	old_pmd = __pmd(old);
 	/*
 	 * We have pmd == none and we are holding page_table_lock.
diff -puN arch/powerpc/mm/subpage-prot.c~powerpc-mm-add-new-set-flag-argument-to-pte-pmd-update-function arch/powerpc/mm/subpage-prot.c
--- a/arch/powerpc/mm/subpage-prot.c~powerpc-mm-add-new-set-flag-argument-to-pte-pmd-update-function
+++ a/arch/powerpc/mm/subpage-prot.c
@@ -78,7 +78,7 @@ static void hpte_flush_range(struct mm_s
 	pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
 	arch_enter_lazy_mmu_mode();
 	for (; npages > 0; --npages) {
-		pte_update(mm, addr, pte, 0, 0);
+		pte_update(mm, addr, pte, 0, 0, 0);
 		addr += PAGE_SIZE;
 		++pte;
 	}
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

origin.patch
mm-hugetlb-unify-region-structure-handling.patch
mm-hugetlb-improve-cleanup-resv_map-parameters.patch
mm-hugetlb-remove-resv_map_put.patch
mm-hugetlb-use-vma_resv_map-map-types.patch
mm-hugetlb-improve-page-fault-scalability.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch

