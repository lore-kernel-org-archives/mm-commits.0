From: akpm@linux-foundation.org
Subject: [merged] thp-mprotect-pass-vma-down-to-page-table-walkers.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:47:56 -0800
Message-ID: <201101142250.p0EMokCt005438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752901Ab1ANWvA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:51:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, aarcange@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: mprotect: pass vma down to page table walkers
has been removed from the -mm tree.  Its filename was
     thp-mprotect-pass-vma-down-to-page-table-walkers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: mprotect: pass vma down to page table walkers
From: Johannes Weiner <hannes@cmpxchg.org>

Flushing the tlb for huge pmds requires the vma's anon_vma, so pass along
the vma instead of the mm, we can always get the latter when we need it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN mm/mprotect.c~thp-mprotect-pass-vma-down-to-page-table-walkers mm/mprotect.c
--- a/mm/mprotect.c~thp-mprotect-pass-vma-down-to-page-table-walkers
+++ a/mm/mprotect.c
@@ -78,7 +78,7 @@ static void change_pte_range(struct mm_s
 	pte_unmap_unlock(pte - 1, ptl);
 }
 
-static inline void change_pmd_range(struct mm_struct *mm, pud_t *pud,
+static inline void change_pmd_range(struct vm_area_struct *vma, pud_t *pud,
 		unsigned long addr, unsigned long end, pgprot_t newprot,
 		int dirty_accountable)
 {
@@ -88,14 +88,15 @@ static inline void change_pmd_range(stru
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
-		split_huge_page_pmd(mm, pmd);
+		split_huge_page_pmd(vma->vm_mm, pmd);
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
-		change_pte_range(mm, pmd, addr, next, newprot, dirty_accountable);
+		change_pte_range(vma->vm_mm, pmd, addr, next, newprot,
+				 dirty_accountable);
 	} while (pmd++, addr = next, addr != end);
 }
 
-static inline void change_pud_range(struct mm_struct *mm, pgd_t *pgd,
+static inline void change_pud_range(struct vm_area_struct *vma, pgd_t *pgd,
 		unsigned long addr, unsigned long end, pgprot_t newprot,
 		int dirty_accountable)
 {
@@ -107,7 +108,8 @@ static inline void change_pud_range(stru
 		next = pud_addr_end(addr, end);
 		if (pud_none_or_clear_bad(pud))
 			continue;
-		change_pmd_range(mm, pud, addr, next, newprot, dirty_accountable);
+		change_pmd_range(vma, pud, addr, next, newprot,
+				 dirty_accountable);
 	} while (pud++, addr = next, addr != end);
 }
 
@@ -127,7 +129,8 @@ static void change_protection(struct vm_
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd))
 			continue;
-		change_pud_range(mm, pgd, addr, next, newprot, dirty_accountable);
+		change_pud_range(vma, pgd, addr, next, newprot,
+				 dirty_accountable);
 	} while (pgd++, addr = next, addr != end);
 	flush_tlb_range(vma, start, end);
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
writeback-check-skipped-pages-on-wb_sync_all.patch
writeback-check-skipped-pages-on-wb_sync_all-update.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
mm-deactivate-invalidated-pages.patch
mm-deactivate-invalidated-pages-fix.patch

