From: akpm@linux-foundation.org
Subject: [merged]
 mm-convert-page_mapped_in_vma-to-use-page_vma_mapped_walk.patch removed
 from -mm tree
Date: Mon, 27 Feb 2017 12:26:23 -0800
Message-ID: <58b48b6f.7arvKe+u3VPBpfkH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60512 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751635AbdB0U16 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:27:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert page_mapped_in_vma() to use page_vma_mapped_walk()
has been removed from the -mm tree.  Its filename was
     mm-convert-page_mapped_in_vma-to-use-page_vma_mapped_walk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: convert page_mapped_in_vma() to use page_vma_mapped_walk()

For consistency, it worth converting all page_check_address() to
page_vma_mapped_walk(), so we could drop the former.

Link: http://lkml.kernel.org/r/20170129173858.45174-11-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |   30 ++++++++++++++++++++++++++++++
 mm/rmap.c            |   26 --------------------------
 2 files changed, 30 insertions(+), 26 deletions(-)

diff -puN mm/page_vma_mapped.c~mm-convert-page_mapped_in_vma-to-use-page_vma_mapped_walk mm/page_vma_mapped.c
--- a/mm/page_vma_mapped.c~mm-convert-page_mapped_in_vma-to-use-page_vma_mapped_walk
+++ a/mm/page_vma_mapped.c
@@ -186,3 +186,33 @@ next_pte:	do {
 		}
 	}
 }
+
+/**
+ * page_mapped_in_vma - check whether a page is really mapped in a VMA
+ * @page: the page to test
+ * @vma: the VMA to test
+ *
+ * Returns 1 if the page is mapped into the page tables of the VMA, 0
+ * if the page is not mapped into the page tables of this VMA.  Only
+ * valid for normal file or anonymous VMAs.
+ */
+int page_mapped_in_vma(struct page *page, struct vm_area_struct *vma)
+{
+	struct page_vma_mapped_walk pvmw = {
+		.page = page,
+		.vma = vma,
+		.flags = PVMW_SYNC,
+	};
+	unsigned long start, end;
+
+	start = __vma_address(page, vma);
+	end = start + PAGE_SIZE * (hpage_nr_pages(page) - 1);
+
+	if (unlikely(end < vma->vm_start || start >= vma->vm_end))
+		return 0;
+	pvmw.address = max(start, vma->vm_start);
+	if (!page_vma_mapped_walk(&pvmw))
+		return 0;
+	page_vma_mapped_walk_done(&pvmw);
+	return 1;
+}
diff -puN mm/rmap.c~mm-convert-page_mapped_in_vma-to-use-page_vma_mapped_walk mm/rmap.c
--- a/mm/rmap.c~mm-convert-page_mapped_in_vma-to-use-page_vma_mapped_walk
+++ a/mm/rmap.c
@@ -756,32 +756,6 @@ check:
 	return NULL;
 }
 
-/**
- * page_mapped_in_vma - check whether a page is really mapped in a VMA
- * @page: the page to test
- * @vma: the VMA to test
- *
- * Returns 1 if the page is mapped into the page tables of the VMA, 0
- * if the page is not mapped into the page tables of this VMA.  Only
- * valid for normal file or anonymous VMAs.
- */
-int page_mapped_in_vma(struct page *page, struct vm_area_struct *vma)
-{
-	unsigned long address;
-	pte_t *pte;
-	spinlock_t *ptl;
-
-	address = __vma_address(page, vma);
-	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
-		return 0;
-	pte = page_check_address(page, vma->vm_mm, address, &ptl, 1);
-	if (!pte)			/* the page is not in this mm */
-		return 0;
-	pte_unmap_unlock(pte, ptl);
-
-	return 1;
-}
