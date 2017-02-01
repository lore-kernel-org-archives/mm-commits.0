From: akpm@linux-foundation.org
Subject: + mm-convert-page_mapped_in_vma-to-use-page_vma_mapped_walk.patch added to -mm tree
Date: Tue, 31 Jan 2017 16:10:24 -0800
Message-ID: <58912770.X8UeG4Yap53Od5vX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36414 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbdBAAKr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 19:10:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert page_mapped_in_vma() to use page_vma_mapped_walk()
has been added to the -mm tree.  Its filename is
     mm-convert-page_mapped_in_vma-to-use-page_vma_mapped_walk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-convert-page_mapped_in_vma-to-use-page_vma_mapped_walk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-convert-page_mapped_in_vma-to-use-page_vma_mapped_walk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
  * Check that @page is mapped at @address into @mm. In contrast to
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-sleeping-function-called-from-invalid-context-shmem_undo_range.patch
mm-drop-zap_details-ignore_dirty.patch
mm-drop-zap_details-check_swap_entries.patch
mm-drop-unused-argument-of-zap_page_range.patch
oom-reaper-use-madvise_dontneed-logic-to-decide-if-unmap-the-vma.patch
uprobes-split-thps-before-trying-replace-them.patch
mm-introduce-page_vma_mapped_walk.patch
mm-fix-handling-pte-mapped-thps-in-page_referenced.patch
mm-fix-handling-pte-mapped-thps-in-page_idle_clear_pte_refs.patch
mm-rmap-check-all-vmas-that-pte-mapped-thp-can-be-part-of.patch
mm-convert-page_mkclean_one-to-use-page_vma_mapped_walk.patch
mm-convert-try_to_unmap_one-to-use-page_vma_mapped_walk.patch
mm-ksm-convert-write_protect_page-to-use-page_vma_mapped_walk.patch
mm-uprobes-convert-__replace_page-to-use-page_vma_mapped_walk.patch
mm-convert-page_mapped_in_vma-to-use-page_vma_mapped_walk.patch
mm-drop-page_check_address_transhuge.patch
mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk.patch

