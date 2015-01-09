From: akpm@linux-foundation.org
Subject: +
 mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch added
 to -mm tree
Date: Fri, 09 Jan 2015 14:59:10 -0800
Message-ID: <54b05d3e.Jyw+HKbbOJsdK5lM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbbAIW7L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2015 17:59:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, davej@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, mingo@redhat.com, paulus@samba.org, riel@redhat.com, sasha.levin@oracle.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert p[te|md]_mknonnuma and remaining page table manipulations
has been added to the -mm tree.  Its filename is
     mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: convert p[te|md]_mknonnuma and remaining page table manipulations

With PROT_NONE, the traditional page table manipulation functions are
sufficient.

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

 include/linux/huge_mm.h |    3 +--
 mm/huge_memory.c        |   33 +++++++--------------------------
 mm/memory.c             |   10 ++++++----
 mm/mempolicy.c          |    2 +-
 mm/migrate.c            |    2 +-
 mm/mprotect.c           |    2 +-
 mm/pgtable-generic.c    |    2 --
 7 files changed, 17 insertions(+), 37 deletions(-)

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
@@ -1361,9 +1361,8 @@ int do_huge_pmd_numa_page(struct mm_stru
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
@@ -1498,7 +1497,7 @@ out:
  *  - HPAGE_PMD_NR is protections changed and TLB flush necessary
  */
 int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long addr, pgprot_t newprot, int prot_numa)
+		unsigned long addr, pgprot_t newprot)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	spinlock_t *ptl;
@@ -1507,29 +1506,11 @@ int change_huge_pmd(struct vm_area_struc
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
@@ -3015,9 +3015,9 @@ static int do_numa_page(struct mm_struct
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
@@ -3026,7 +3026,9 @@ static int do_numa_page(struct mm_struct
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
@@ -627,7 +627,7 @@ unsigned long change_prot_numa(struct vm
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

mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-vmscan-prevent-kswapd-livelock-due-to-pfmemalloc-throttled-process-being-killed.patch
mm-page_alloc-place-zone_id-check-before-vm_bug_on_page-check.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
mm-numa-do-not-dereference-pmd-outside-of-the-lock-during-numa-hinting-fault.patch
mm-add-p-protnone-helpers-for-use-by-numa-balancing.patch
mm-convert-p_numa-users-to-p_protnone_numa.patch
ppc64-add-paranoid-warnings-for-unexpected-dsisr_protfault.patch
mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch
mm-remove-remaining-references-to-numa-hinting-bits-and-helpers.patch
mm-numa-do-not-trap-faults-on-the-huge-zero-page.patch
x86-mm-restore-original-pte_special-check.patch
mm-numa-add-paranoid-check-around-pte_protnone_numa.patch
mm-numa-avoid-unnecessary-tlb-flushes-when-setting-numa-hinting-entries.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

