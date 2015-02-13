From: akpm@linux-foundation.org
Subject: [merged] mm-numa-do-not-trap-faults-on-the-huge-zero-page.patch
 removed from -mm tree
Date: Fri, 13 Feb 2015 12:19:30 -0800
Message-ID: <54de5c52.uJNGA0GNm+29NC7+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48608 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbbBMUTb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:19:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, davej@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, mingo@redhat.com, paulus@samba.org, riel@redhat.com, sasha.levin@oracle.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: numa: do not trap faults on the huge zero page
has been removed from the -mm tree.  Its filename was
     mm-numa-do-not-trap-faults-on-the-huge-zero-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: numa: do not trap faults on the huge zero page

Faults on the huge zero page are pointless and there is a BUG_ON to catch
them during fault time.  This patch reintroduces a check that avoids
marking the zero page PAGE_NONE.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    3 ++-
 mm/huge_memory.c        |   13 ++++++++++++-
 mm/memory.c             |    1 -
 mm/mprotect.c           |   14 +++++++++++++-
 4 files changed, 27 insertions(+), 4 deletions(-)

diff -puN include/linux/huge_mm.h~mm-numa-do-not-trap-faults-on-the-huge-zero-page include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-numa-do-not-trap-faults-on-the-huge-zero-page
+++ a/include/linux/huge_mm.h
@@ -31,7 +31,8 @@ extern int move_huge_pmd(struct vm_area_
 			 unsigned long new_addr, unsigned long old_end,
 			 pmd_t *old_pmd, pmd_t *new_pmd);
 extern int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
-			unsigned long addr, pgprot_t newprot);
+			unsigned long addr, pgprot_t newprot,
+			int prot_numa);
 
 enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_FLAG,
diff -puN mm/huge_memory.c~mm-numa-do-not-trap-faults-on-the-huge-zero-page mm/huge_memory.c
--- a/mm/huge_memory.c~mm-numa-do-not-trap-faults-on-the-huge-zero-page
+++ a/mm/huge_memory.c
@@ -1471,7 +1471,7 @@ out:
  *  - HPAGE_PMD_NR is protections changed and TLB flush necessary
  */
 int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long addr, pgprot_t newprot)
+		unsigned long addr, pgprot_t newprot, int prot_numa)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	spinlock_t *ptl;
@@ -1479,6 +1479,17 @@ int change_huge_pmd(struct vm_area_struc
 
 	if (__pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
 		pmd_t entry;
+
+		/*
+		 * Avoid trapping faults against the zero page. The read-only
+		 * data is likely to be read-cached on the local CPU and
+		 * local/remote hits to the zero page are not interesting.
+		 */
+		if (prot_numa && is_huge_zero_pmd(*pmd)) {
+			spin_unlock(ptl);
+			return 0;
+		}
+
 		ret = 1;
 		entry = pmdp_get_and_clear_notify(mm, addr, pmd);
 		entry = pmd_modify(entry, newprot);
diff -puN mm/memory.c~mm-numa-do-not-trap-faults-on-the-huge-zero-page mm/memory.c
--- a/mm/memory.c~mm-numa-do-not-trap-faults-on-the-huge-zero-page
+++ a/mm/memory.c
@@ -3040,7 +3040,6 @@ static int do_numa_page(struct mm_struct
 		pte_unmap_unlock(ptep, ptl);
 		return 0;
 	}
-	BUG_ON(is_zero_pfn(page_to_pfn(page)));
 
 	/*
 	 * Avoid grouping on DSO/COW pages in specific and RO pages
diff -puN mm/mprotect.c~mm-numa-do-not-trap-faults-on-the-huge-zero-page mm/mprotect.c
--- a/mm/mprotect.c~mm-numa-do-not-trap-faults-on-the-huge-zero-page
+++ a/mm/mprotect.c
@@ -76,6 +76,18 @@ static unsigned long change_pte_range(st
 		if (pte_present(oldpte)) {
 			pte_t ptent;
 
+			/*
+			 * Avoid trapping faults against the zero or KSM
+			 * pages. See similar comment in change_huge_pmd.
+			 */
+			if (prot_numa) {
+				struct page *page;
+
+				page = vm_normal_page(vma, addr, oldpte);
+				if (!page || PageKsm(page))
+					continue;
+			}
+
 			ptent = ptep_modify_prot_start(mm, addr, pte);
 			ptent = pte_modify(ptent, newprot);
 
@@ -142,7 +154,7 @@ static inline unsigned long change_pmd_r
 				split_huge_page_pmd(vma, addr, pmd);
 			else {
 				int nr_ptes = change_huge_pmd(vma, pmd, addr,
-						newprot);
+						newprot, prot_numa);
 
 				if (nr_ptes) {
 					if (nr_ptes == HPAGE_PMD_NR) {
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

