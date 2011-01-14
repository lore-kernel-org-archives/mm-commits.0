From: akpm@linux-foundation.org
Subject: [merged] thp-mincore-transparent-hugepage-support.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:47:51 -0800
Message-ID: <201101142250.p0EMofVL005432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752886Ab1ANWuz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:50:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, aarcange@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: mincore transparent hugepage support
has been removed from the -mm tree.  Its filename was
     thp-mincore-transparent-hugepage-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: mincore transparent hugepage support
From: Johannes Weiner <hannes@cmpxchg.org>

Handle transparent huge page pmd entries natively instead of splitting
them into subpages.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    3 +++
 mm/huge_memory.c        |   25 +++++++++++++++++++++++++
 mm/mincore.c            |    8 +++++++-
 3 files changed, 35 insertions(+), 1 deletion(-)

diff -puN include/linux/huge_mm.h~thp-mincore-transparent-hugepage-support include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-mincore-transparent-hugepage-support
+++ a/include/linux/huge_mm.h
@@ -19,6 +19,9 @@ extern struct page *follow_trans_huge_pm
 extern int zap_huge_pmd(struct mmu_gather *tlb,
 			struct vm_area_struct *vma,
 			pmd_t *pmd);
+extern int mincore_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
+			unsigned long addr, unsigned long end,
+			unsigned char *vec);
 
 enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_FLAG,
diff -puN mm/huge_memory.c~thp-mincore-transparent-hugepage-support mm/huge_memory.c
--- a/mm/huge_memory.c~thp-mincore-transparent-hugepage-support
+++ a/mm/huge_memory.c
@@ -923,6 +923,31 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 	return ret;
 }
 
+int mincore_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
+		unsigned long addr, unsigned long end,
+		unsigned char *vec)
+{
+	int ret = 0;
+
+	spin_lock(&vma->vm_mm->page_table_lock);
+	if (likely(pmd_trans_huge(*pmd))) {
+		ret = !pmd_trans_splitting(*pmd);
+		spin_unlock(&vma->vm_mm->page_table_lock);
+		if (unlikely(!ret))
+			wait_split_huge_page(vma->anon_vma, pmd);
+		else {
+			/*
+			 * All logical pages in the range are present
+			 * if backed by a huge page.
+			 */
+			memset(vec, 1, (end - addr) >> PAGE_SHIFT);
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
diff -puN mm/mincore.c~thp-mincore-transparent-hugepage-support mm/mincore.c
--- a/mm/mincore.c~thp-mincore-transparent-hugepage-support
+++ a/mm/mincore.c
@@ -154,7 +154,13 @@ static void mincore_pmd_range(struct vm_
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
-		split_huge_page_pmd(vma->vm_mm, pmd);
+		if (pmd_trans_huge(*pmd)) {
+			if (mincore_huge_pmd(vma, pmd, addr, next, vec)) {
+				vec += (next - addr) >> PAGE_SHIFT;
+				continue;
+			}
+			/* fall through */
+		}
 		if (pmd_none_or_clear_bad(pmd))
 			mincore_unmapped_range(vma, addr, next, vec);
 		else
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
writeback-check-skipped-pages-on-wb_sync_all.patch
writeback-check-skipped-pages-on-wb_sync_all-update.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
mm-deactivate-invalidated-pages.patch
mm-deactivate-invalidated-pages-fix.patch

