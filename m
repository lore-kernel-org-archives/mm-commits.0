From: akpm@linux-foundation.org
Subject: [merged]
 mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch removed from -mm tree
Date: Fri, 13 Feb 2015 12:19:24 -0800
Message-ID: <54de5c4c.hHxSb+eVr6/Q2UUf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48582 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbbBMUTZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:19:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, davej@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, mingo@redhat.com, paulus@samba.org, riel@redhat.com, sasha.levin@oracle.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert p[te|md]_mknonnuma and remaining page table manipulations
has been removed from the -mm tree.  Its filename was
     mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: convert p[te|md]_mknonnuma and remaining page table manipulations

With PROT_NONE, the traditional page table manipulation functions are
sufficient.

[andre.przywara@arm.com: fix compiler warning in pmdp_invalidate()]
[akpm@linux-foundation.org: fix build with STRICT_MM_TYPECHECKS]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable-3level.h |    5 ++-
 include/linux/huge_mm.h               |    3 --
 mm/huge_memory.c                      |   33 +++++-------------------
 mm/memory.c                           |   10 ++++---
 mm/mempolicy.c                        |    2 -
 mm/migrate.c                          |    2 -
 mm/mprotect.c                         |    2 -
 mm/pgtable-generic.c                  |    2 -
 8 files changed, 21 insertions(+), 38 deletions(-)

diff -puN arch/arm/include/asm/pgtable-3level.h~mm-convert-p_mknonnuma-and-remaining-page-table-manipulations arch/arm/include/asm/pgtable-3level.h
--- a/arch/arm/include/asm/pgtable-3level.h~mm-convert-p_mknonnuma-and-remaining-page-table-manipulations
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -257,7 +257,10 @@ PMD_BIT_FUNC(mkyoung,   |= PMD_SECT_AF);
 #define mk_pmd(page,prot)	pfn_pmd(page_to_pfn(page),prot)
 
 /* represent a notpresent pmd by zero, this is used by pmdp_invalidate */
-#define pmd_mknotpresent(pmd)	(__pmd(0))
+static inline pmd_t pmd_mknotpresent(pmd_t pmd)
+{
+	return __pmd(0);
+}
 
 static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
 {
diff -puN include/linux/huge_mm.h~mm-convert-p_mknonnuma-and-remaining-page-table-manipulations include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-convert-p_mknonnuma-and-remaining-page-table-manipulations
+++ a/include/linux/huge_mm.h
@@ -31,8 +31,7 @@ extern int move_huge_pmd(struct vm_area_
 			 unsigned long new_addr, unsigned long old_end,
 			 pmd_t *old_pmd, pmd_t *new_pmd);
 extern int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
-			unsigned long addr, pgprot_t newprot,
-			int prot_numa);
+			unsigned long addr, pgprot_t newprot);
 
 enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_FLAG,
diff -puN mm/huge_memory.c~mm-convert-p_mknonnuma-and-remaining-page-table-manipulations mm/huge_memory.c
--- a/mm/huge_memory.c~mm-convert-p_mknonnuma-and-remaining-page-table-manipulations
+++ a/mm/huge_memory.c
@@ -1355,9 +1355,8 @@ int do_huge_pmd_numa_page(struct mm_stru
 	goto out;
 clear_pmdnuma:
 	BUG_ON(!PageLocked(page));
-	pmd = pmd_mknonnuma(pmd);
+	pmd = pmd_modify(pmd, vma->vm_page_prot);
 	set_pmd_at(mm, haddr, pmdp, pmd);
-	VM_BUG_ON(pmd_protnone(*pmdp));
 	update_mmu_cache_pmd(vma, addr, pmdp);
 	unlock_page(page);
 out_unlock:
@@ -1472,7 +1471,7 @@ out:
  *  - HPAGE_PMD_NR is protections changed and TLB flush necessary
  */
 int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long addr, pgprot_t newprot, int prot_numa)
+		unsigned long addr, pgprot_t newprot)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	spinlock_t *ptl;
@@ -1481,29 +1480,11 @@ int change_huge_pmd(struct vm_area_struc
 	if (__pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
 		pmd_t entry;
 		ret = 1;
-		if (!prot_numa) {
-			entry = pmdp_get_and_clear_notify(mm, addr, pmd);
-			if (pmd_protnone(entry))
-				entry = pmd_mknonnuma(entry);
-			entry = pmd_modify(entry, newprot);
-			ret = HPAGE_PMD_NR;
-			set_pmd_at(mm, addr, pmd, entry);
-			BUG_ON(pmd_write(entry));
-		} else {
-			struct page *page = pmd_page(*pmd);
-
-			/*
-			 * Do not trap faults against the zero page. The
-			 * read-only data is likely to be read-cached on the
-			 * local CPU cache and it is less useful to know about
-			 * local vs remote hits on the zero page.
-			 */
-			if (!is_huge_zero_page(page) &&
-			    !pmd_protnone(*pmd)) {
-				pmdp_set_numa(mm, addr, pmd);
-				ret = HPAGE_PMD_NR;
-			}
-		}
+		entry = pmdp_get_and_clear_notify(mm, addr, pmd);
+		entry = pmd_modify(entry, newprot);
+		ret = HPAGE_PMD_NR;
+		set_pmd_at(mm, addr, pmd, entry);
+		BUG_ON(pmd_write(entry));
 		spin_unlock(ptl);
 	}
 
diff -puN mm/memory.c~mm-convert-p_mknonnuma-and-remaining-page-table-manipulations mm/memory.c
--- a/mm/memory.c~mm-convert-p_mknonnuma-and-remaining-page-table-manipulations
+++ a/mm/memory.c
@@ -3018,9 +3018,9 @@ static int do_numa_page(struct mm_struct
 	* validation through pte_unmap_same(). It's of NUMA type but
 	* the pfn may be screwed if the read is non atomic.
 	*
-	* ptep_modify_prot_start is not called as this is clearing
-	* the _PAGE_NUMA bit and it is not really expected that there
-	* would be concurrent hardware modifications to the PTE.
+	* We can safely just do a "set_pte_at()", because the old
+	* page table entry is not accessible, so there would be no
+	* concurrent hardware modifications to the PTE.
 	*/
 	ptl = pte_lockptr(mm, pmd);
 	spin_lock(ptl);
@@ -3029,7 +3029,9 @@ static int do_numa_page(struct mm_struct
 		goto out;
 	}
 
-	pte = pte_mknonnuma(pte);
+	/* Make it present again */
+	pte = pte_modify(pte, vma->vm_page_prot);
+	pte = pte_mkyoung(pte);
 	set_pte_at(mm, addr, ptep, pte);
 	update_mmu_cache(vma, addr, ptep);
 
diff -puN mm/mempolicy.c~mm-convert-p_mknonnuma-and-remaining-page-table-manipulations mm/mempolicy.c
--- a/mm/mempolicy.c~mm-convert-p_mknonnuma-and-remaining-page-table-manipulations
+++ a/mm/mempolicy.c
@@ -569,7 +569,7 @@ unsigned long change_prot_numa(struct vm
 {
 	int nr_updated;
 
-	nr_updated = change_protection(vma, addr, end, vma->vm_page_prot, 0, 1);
+	nr_updated = change_protection(vma, addr, end, PAGE_NONE, 0, 1);
 	if (nr_updated)
 		count_vm_numa_events(NUMA_PTE_UPDATES, nr_updated);
 
diff -puN mm/migrate.c~mm-convert-p_mknonnuma-and-remaining-page-table-manipulations mm/migrate.c
--- a/mm/migrate.c~mm-convert-p_mknonnuma-and-remaining-page-table-manipulations
+++ a/mm/migrate.c
@@ -1847,7 +1847,7 @@ out_fail:
 out_dropref:
 	ptl = pmd_lock(mm, pmd);
 	if (pmd_same(*pmd, entry)) {
-		entry = pmd_mknonnuma(entry);
+		entry = pmd_modify(entry, vma->vm_page_prot);
 		set_pmd_at(mm, mmun_start, pmd, entry);
 		update_mmu_cache_pmd(vma, address, &entry);
 	}
diff -puN mm/mprotect.c~mm-convert-p_mknonnuma-and-remaining-page-table-manipulations mm/mprotect.c
--- a/mm/mprotect.c~mm-convert-p_mknonnuma-and-remaining-page-table-manipulations
+++ a/mm/mprotect.c
@@ -142,7 +142,7 @@ static inline unsigned long change_pmd_r
 				split_huge_page_pmd(vma, addr, pmd);
 			else {
 				int nr_ptes = change_huge_pmd(vma, pmd, addr,
-						newprot, prot_numa);
+						newprot);
 
 				if (nr_ptes) {
 					if (nr_ptes == HPAGE_PMD_NR) {
diff -puN mm/pgtable-generic.c~mm-convert-p_mknonnuma-and-remaining-page-table-manipulations mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~mm-convert-p_mknonnuma-and-remaining-page-table-manipulations
+++ a/mm/pgtable-generic.c
@@ -193,8 +193,6 @@ void pmdp_invalidate(struct vm_area_stru
 		     pmd_t *pmdp)
 {
 	pmd_t entry = *pmdp;
-	if (pmd_protnone(entry))
-		entry = pmd_mknonnuma(entry);
 	set_pmd_at(vma->vm_mm, address, pmdp, pmd_mknotpresent(entry));
 	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 }
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

