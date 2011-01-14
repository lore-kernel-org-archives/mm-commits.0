From: akpm@linux-foundation.org
Subject: [merged] thp-mprotect-transparent-huge-page-support.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:47:58 -0800
Message-ID: <201101142250.p0EMomwK005441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752901Ab1ANWu4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:50:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, aarcange@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: mprotect: transparent huge page support
has been removed from the -mm tree.  Its filename was
     thp-mprotect-transparent-huge-page-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: mprotect: transparent huge page support
From: Johannes Weiner <hannes@cmpxchg.org>

Natively handle huge pmds when changing page tables on behalf of
mprotect().

I left out update_mmu_cache() because we do not need it on x86 anyway but
more importantly the interface works on ptes, not pmds.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    2 ++
 mm/huge_memory.c        |   27 +++++++++++++++++++++++++++
 mm/mprotect.c           |    8 +++++++-
 3 files changed, 36 insertions(+), 1 deletion(-)

diff -puN include/linux/huge_mm.h~thp-mprotect-transparent-huge-page-support include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-mprotect-transparent-huge-page-support
+++ a/include/linux/huge_mm.h
@@ -22,6 +22,8 @@ extern int zap_huge_pmd(struct mmu_gathe
 extern int mincore_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 			unsigned long addr, unsigned long end,
 			unsigned char *vec);
+extern int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
+			unsigned long addr, pgprot_t newprot);
 
 enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_FLAG,
diff -puN mm/huge_memory.c~thp-mprotect-transparent-huge-page-support mm/huge_memory.c
--- a/mm/huge_memory.c~thp-mprotect-transparent-huge-page-support
+++ a/mm/huge_memory.c
@@ -948,6 +948,33 @@ int mincore_huge_pmd(struct vm_area_stru
 	return ret;
 }
 
+int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
+		unsigned long addr, pgprot_t newprot)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	int ret = 0;
+
+	spin_lock(&mm->page_table_lock);
+	if (likely(pmd_trans_huge(*pmd))) {
+		if (unlikely(pmd_trans_splitting(*pmd))) {
+			spin_unlock(&mm->page_table_lock);
+			wait_split_huge_page(vma->anon_vma, pmd);
+		} else {
+			pmd_t entry;
+
+			entry = pmdp_get_and_clear(mm, addr, pmd);
+			entry = pmd_modify(entry, newprot);
+			set_pmd_at(mm, addr, pmd, entry);
+			spin_unlock(&vma->vm_mm->page_table_lock);
+			flush_tlb_range(vma, addr, addr + HPAGE_PMD_SIZE);
+			ret = 1;
+		}
+	} else
+		spin_unlock(&vma->vm_mm->page_table_lock);
+
+	return ret;
+}
+
 pmd_t *page_check_address_pmd(struct page *page,
 			      struct mm_struct *mm,
 			      unsigned long address,
diff -puN mm/mprotect.c~thp-mprotect-transparent-huge-page-support mm/mprotect.c
--- a/mm/mprotect.c~thp-mprotect-transparent-huge-page-support
+++ a/mm/mprotect.c
@@ -88,7 +88,13 @@ static inline void change_pmd_range(stru
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
-		split_huge_page_pmd(vma->vm_mm, pmd);
+		if (pmd_trans_huge(*pmd)) {
+			if (next - addr != HPAGE_PMD_SIZE)
+				split_huge_page_pmd(vma->vm_mm, pmd);
+			else if (change_huge_pmd(vma, pmd, addr, newprot))
+				continue;
+			/* fall through */
+		}
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
 		change_pte_range(vma->vm_mm, pmd, addr, next, newprot,
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
writeback-check-skipped-pages-on-wb_sync_all.patch
writeback-check-skipped-pages-on-wb_sync_all-update.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
mm-deactivate-invalidated-pages.patch
mm-deactivate-invalidated-pages-fix.patch

