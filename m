From: akpm@linux-foundation.org
Subject: [merged] thp-skip-file-huge-pmd-on-copy_huge_pmd.patch removed
 from -mm tree
Date: Wed, 27 Jul 2016 12:02:30 -0700
Message-ID: <57990546.TGwpakxBfeuwmdWv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758043AbcG0TCb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:02:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: skip file huge pmd on copy_huge_pmd()
has been removed from the -mm tree.  Its filename was
     thp-skip-file-huge-pmd-on-copy_huge_pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: skip file huge pmd on copy_huge_pmd()

copy_page_range() has a check for "Don't copy ptes where a page fault
will fill them correctly." It works on VMA level. We still copy all page
table entries from private mappings, even if they map page cache.

We can simplify copy_huge_pmd() a bit by skipping file PMDs.

We don't map file private pages with PMDs, so they only can map page
cache. It's safe to skip them as they can be re-faulted later.

Link: http://lkml.kernel.org/r/1466021202-61880-17-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff -puN mm/huge_memory.c~thp-skip-file-huge-pmd-on-copy_huge_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~thp-skip-file-huge-pmd-on-copy_huge_pmd
+++ a/mm/huge_memory.c
@@ -1098,14 +1098,15 @@ int copy_huge_pmd(struct mm_struct *dst_
 	struct page *src_page;
 	pmd_t pmd;
 	pgtable_t pgtable = NULL;
-	int ret;
+	int ret = -ENOMEM;
 
-	if (!vma_is_dax(vma)) {
-		ret = -ENOMEM;
-		pgtable = pte_alloc_one(dst_mm, addr);
-		if (unlikely(!pgtable))
-			goto out;
-	}
+	/* Skip if can be re-fill on fault */
+	if (!vma_is_anonymous(vma))
+		return 0;
+
+	pgtable = pte_alloc_one(dst_mm, addr);
+	if (unlikely(!pgtable))
+		goto out;
 
 	dst_ptl = pmd_lock(dst_mm, dst_pmd);
 	src_ptl = pmd_lockptr(src_mm, src_pmd);
@@ -1113,7 +1114,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 
 	ret = -EAGAIN;
 	pmd = *src_pmd;
-	if (unlikely(!pmd_trans_huge(pmd) && !pmd_devmap(pmd))) {
+	if (unlikely(!pmd_trans_huge(pmd))) {
 		pte_free(dst_mm, pgtable);
 		goto out_unlock;
 	}
@@ -1136,16 +1137,13 @@ int copy_huge_pmd(struct mm_struct *dst_
 		goto out_unlock;
 	}
 
-	if (!vma_is_dax(vma)) {
-		/* thp accounting separate from pmd_devmap accounting */
-		src_page = pmd_page(pmd);
-		VM_BUG_ON_PAGE(!PageHead(src_page), src_page);
-		get_page(src_page);
-		page_dup_rmap(src_page, true);
-		add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
-		atomic_long_inc(&dst_mm->nr_ptes);
-		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
-	}
+	src_page = pmd_page(pmd);
+	VM_BUG_ON_PAGE(!PageHead(src_page), src_page);
+	get_page(src_page);
+	page_dup_rmap(src_page, true);
+	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
+	atomic_long_inc(&dst_mm->nr_ptes);
+	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
 
 	pmdp_set_wrprotect(src_mm, addr, src_pmd);
 	pmd = pmd_mkold(pmd_wrprotect(pmd));
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


