From: akpm@linux-foundation.org
Subject: [merged]
 mm-use-ptep-pmdp_set_numa-for-updating-_page_numa-bit.patch removed from
 -mm tree
Date: Tue, 18 Feb 2014 12:12:25 -0800
Message-ID: <5303bea9.yHvGXT5v4qwWMTii%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49056 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaBRUM0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 15:12:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, paulus@samba.org, mgorman@suse.de, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com

Subject: [merged] mm-use-ptep-pmdp_set_numa-for-updating-_page_numa-bit.patch removed from -mm tree
To: aneesh.kumar@linux.vnet.ibm.com,benh@kernel.crashing.org,mgorman@suse.de,paulus@samba.org,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 12:12:25 -0800


The patch titled
     Subject: mm: Use ptep/pmdp_set_numa for updating _PAGE_NUMA bit
has been removed from the -mm tree.  Its filename was
     mm-use-ptep-pmdp_set_numa-for-updating-_page_numa-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm: Use ptep/pmdp_set_numa for updating _PAGE_NUMA bit

Archs like ppc64 don't do tlb flush in set_pte/pmd functions.  ppc64 also
doesn't implement flush_tlb_range.  ppc64 require the tlb flushing to be
batched within ptl locks.  The reason to do that is to ensure that the
hash page table is in sync with linux page table.  We track the hpte index
in linux pte and if we clear them without flushing hash and drop the ptl
lock, we can have another cpu update the pte and can end up with double
hash.  We also want to keep set_pte_at simpler by not requiring them to do
hash flush for performance reason.  Hence cannot use them while updating
_PAGE_NUMA bit.  Add new functions for marking pte/pmd numa

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/pgtable.h |   22 +++++++++++++++
 include/asm-generic/pgtable.h      |   39 +++++++++++++++++++++++++++
 mm/huge_memory.c                   |    9 +-----
 mm/mprotect.c                      |    4 --
 4 files changed, 64 insertions(+), 10 deletions(-)

diff -puN arch/powerpc/include/asm/pgtable.h~mm-use-ptep-pmdp_set_numa-for-updating-_page_numa-bit arch/powerpc/include/asm/pgtable.h
--- a/arch/powerpc/include/asm/pgtable.h~mm-use-ptep-pmdp_set_numa-for-updating-_page_numa-bit
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -75,12 +75,34 @@ static inline pte_t pte_mknuma(pte_t pte
 	return pte;
 }
 
+#define ptep_set_numa ptep_set_numa
+static inline void ptep_set_numa(struct mm_struct *mm, unsigned long addr,
+				 pte_t *ptep)
+{
+	if ((pte_val(*ptep) & _PAGE_PRESENT) == 0)
+		VM_BUG_ON(1);
+
+	pte_update(mm, addr, ptep, _PAGE_PRESENT, _PAGE_NUMA, 0);
+	return;
+}
+
 #define pmd_numa pmd_numa
 static inline int pmd_numa(pmd_t pmd)
 {
 	return pte_numa(pmd_pte(pmd));
 }
 
+#define pmdp_set_numa pmdp_set_numa
+static inline void pmdp_set_numa(struct mm_struct *mm, unsigned long addr,
+				 pmd_t *pmdp)
+{
+	if ((pmd_val(*pmdp) & _PAGE_PRESENT) == 0)
+		VM_BUG_ON(1);
+
+	pmd_hugepage_update(mm, addr, pmdp, _PAGE_PRESENT, _PAGE_NUMA);
+	return;
+}
+
 #define pmd_mknonnuma pmd_mknonnuma
 static inline pmd_t pmd_mknonnuma(pmd_t pmd)
 {
diff -puN include/asm-generic/pgtable.h~mm-use-ptep-pmdp_set_numa-for-updating-_page_numa-bit include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-use-ptep-pmdp_set_numa-for-updating-_page_numa-bit
+++ a/include/asm-generic/pgtable.h
@@ -701,6 +701,18 @@ static inline pte_t pte_mknuma(pte_t pte
 }
 #endif
 
+#ifndef ptep_set_numa
+static inline void ptep_set_numa(struct mm_struct *mm, unsigned long addr,
+				 pte_t *ptep)
+{
+	pte_t ptent = *ptep;
+
+	ptent = pte_mknuma(ptent);
+	set_pte_at(mm, addr, ptep, ptent);
+	return;
+}
+#endif
+
 #ifndef pmd_mknuma
 static inline pmd_t pmd_mknuma(pmd_t pmd)
 {
@@ -708,6 +720,18 @@ static inline pmd_t pmd_mknuma(pmd_t pmd
 	return pmd_clear_flags(pmd, _PAGE_PRESENT);
 }
 #endif
+
+#ifndef pmdp_set_numa
+static inline void pmdp_set_numa(struct mm_struct *mm, unsigned long addr,
+				 pmd_t *pmdp)
+{
+	pmd_t pmd = *pmdp;
+
+	pmd = pmd_mknuma(pmd);
+	set_pmd_at(mm, addr, pmdp, pmd);
+	return;
+}
+#endif
 #else
 extern int pte_numa(pte_t pte);
 extern int pmd_numa(pmd_t pmd);
@@ -715,6 +739,8 @@ extern pte_t pte_mknonnuma(pte_t pte);
 extern pmd_t pmd_mknonnuma(pmd_t pmd);
 extern pte_t pte_mknuma(pte_t pte);
 extern pmd_t pmd_mknuma(pmd_t pmd);
+extern void ptep_set_numa(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
+extern void pmdp_set_numa(struct mm_struct *mm, unsigned long addr, pmd_t *pmdp);
 #endif /* CONFIG_ARCH_USES_NUMA_PROT_NONE */
 #else
 static inline int pmd_numa(pmd_t pmd)
@@ -742,10 +768,23 @@ static inline pte_t pte_mknuma(pte_t pte
 	return pte;
 }
 
+static inline void ptep_set_numa(struct mm_struct *mm, unsigned long addr,
+				 pte_t *ptep)
+{
+	return;
+}
+
+
 static inline pmd_t pmd_mknuma(pmd_t pmd)
 {
 	return pmd;
 }
+
+static inline void pmdp_set_numa(struct mm_struct *mm, unsigned long addr,
+				 pmd_t *pmdp)
+{
+	return ;
+}
 #endif /* CONFIG_NUMA_BALANCING */
 
 #endif /* CONFIG_MMU */
diff -puN mm/huge_memory.c~mm-use-ptep-pmdp_set_numa-for-updating-_page_numa-bit mm/huge_memory.c
--- a/mm/huge_memory.c~mm-use-ptep-pmdp_set_numa-for-updating-_page_numa-bit
+++ a/mm/huge_memory.c
@@ -1548,6 +1548,7 @@ int change_huge_pmd(struct vm_area_struc
 				entry = pmd_mknonnuma(entry);
 			entry = pmd_modify(entry, newprot);
 			ret = HPAGE_PMD_NR;
+			set_pmd_at(mm, addr, pmd, entry);
 			BUG_ON(pmd_write(entry));
 		} else {
 			struct page *page = pmd_page(*pmd);
@@ -1560,16 +1561,10 @@ int change_huge_pmd(struct vm_area_struc
 			 */
 			if (!is_huge_zero_page(page) &&
 			    !pmd_numa(*pmd)) {
-				entry = *pmd;
-				entry = pmd_mknuma(entry);
+				pmdp_set_numa(mm, addr, pmd);
 				ret = HPAGE_PMD_NR;
 			}
 		}
-
-		/* Set PMD if cleared earlier */
-		if (ret == HPAGE_PMD_NR)
-			set_pmd_at(mm, addr, pmd, entry);
-
 		spin_unlock(ptl);
 	}
 
diff -puN mm/mprotect.c~mm-use-ptep-pmdp_set_numa-for-updating-_page_numa-bit mm/mprotect.c
--- a/mm/mprotect.c~mm-use-ptep-pmdp_set_numa-for-updating-_page_numa-bit
+++ a/mm/mprotect.c
@@ -69,12 +69,10 @@ static unsigned long change_pte_range(st
 			} else {
 				struct page *page;
 
-				ptent = *pte;
 				page = vm_normal_page(vma, addr, oldpte);
 				if (page && !PageKsm(page)) {
 					if (!pte_numa(oldpte)) {
-						ptent = pte_mknuma(ptent);
-						set_pte_at(mm, addr, pte, ptent);
+						ptep_set_numa(mm, addr, pte);
 						updated = true;
 					}
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

