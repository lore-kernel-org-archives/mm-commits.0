From: akpm@linux-foundation.org
Subject: [merged]
 mm-convert-page_mkclean_one-to-use-page_vma_mapped_walk.patch removed from
 -mm tree
Date: Mon, 27 Feb 2017 12:26:11 -0800
Message-ID: <58b48b63.JsUxcg/q6GF+sIJ/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60458 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751555AbdB0U16 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:27:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert page_mkclean_one() to use page_vma_mapped_walk()
has been removed from the -mm tree.  Its filename was
     mm-convert-page_mkclean_one-to-use-page_vma_mapped_walk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: convert page_mkclean_one() to use page_vma_mapped_walk()

For consistency, it worth converting all page_check_address() to
page_vma_mapped_walk(), so we could drop the former.

PMD handling here is future-proofing, we don't have users yet. ext4 with
huge pages will be the first.

Link: http://lkml.kernel.org/r/20170129173858.45174-7-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   70 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 46 insertions(+), 24 deletions(-)

diff -puN mm/rmap.c~mm-convert-page_mkclean_one-to-use-page_vma_mapped_walk mm/rmap.c
--- a/mm/rmap.c~mm-convert-page_mkclean_one-to-use-page_vma_mapped_walk
+++ a/mm/rmap.c
@@ -1017,34 +1017,56 @@ int page_referenced(struct page *page,
 static int page_mkclean_one(struct page *page, struct vm_area_struct *vma,
 			    unsigned long address, void *arg)
 {
-	struct mm_struct *mm = vma->vm_mm;
-	pte_t *pte;
-	spinlock_t *ptl;
-	int ret = 0;
+	struct page_vma_mapped_walk pvmw = {
+		.page = page,
+		.vma = vma,
+		.address = address,
+		.flags = PVMW_SYNC,
+	};
 	int *cleaned = arg;
 
-	pte = page_check_address(page, mm, address, &ptl, 1);
-	if (!pte)
-		goto out;
-
-	if (pte_dirty(*pte) || pte_write(*pte)) {
-		pte_t entry;
-
-		flush_cache_page(vma, address, pte_pfn(*pte));
-		entry = ptep_clear_flush(vma, address, pte);
-		entry = pte_wrprotect(entry);
-		entry = pte_mkclean(entry);
-		set_pte_at(mm, address, pte, entry);
-		ret = 1;
+	while (page_vma_mapped_walk(&pvmw)) {
+		int ret = 0;
+		address = pvmw.address;
+		if (pvmw.pte) {
+			pte_t entry;
+			pte_t *pte = pvmw.pte;
+
+			if (!pte_dirty(*pte) && !pte_write(*pte))
+				continue;
+
+			flush_cache_page(vma, address, pte_pfn(*pte));
+			entry = ptep_clear_flush(vma, address, pte);
+			entry = pte_wrprotect(entry);
+			entry = pte_mkclean(entry);
+			set_pte_at(vma->vm_mm, address, pte, entry);
+			ret = 1;
+		} else {
+#ifdef CONFIG_TRANSPARENT_HUGE_PAGECACHE
+			pmd_t *pmd = pvmw.pmd;
+			pmd_t entry;
+
+			if (!pmd_dirty(*pmd) && !pmd_write(*pmd))
+				continue;
+
+			flush_cache_page(vma, address, page_to_pfn(page));
+			entry = pmdp_huge_clear_flush(vma, address, pmd);
+			entry = pmd_wrprotect(entry);
+			entry = pmd_mkclean(entry);
+			set_pmd_at(vma->vm_mm, address, pmd, entry);
+			ret = 1;
+#else
+			/* unexpected pmd-mapped page? */
+			WARN_ON_ONCE(1);
+#endif
+		}
+
+		if (ret) {
+			mmu_notifier_invalidate_page(vma->vm_mm, address);
+			(*cleaned)++;
+		}
 	}
 
-	pte_unmap_unlock(pte, ptl);
