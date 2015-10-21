From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-unmap-pages-to-remove-if-page-fault-raced-with-hole-punch.patch
 added to -mm tree
Date: Wed, 21 Oct 2015 13:39:45 -0700
Message-ID: <5627f811.nMyVMmtoU9tjHBN6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44668 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbbJUUjq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Oct 2015 16:39:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dave.hansen@linux.intel.com, dave@stgolabs.net, hughd@google.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: unmap pages to remove if page fault raced with hole punch
has been added to the -mm tree.  Its filename is
     mm-hugetlb-unmap-pages-to-remove-if-page-fault-raced-with-hole-punch.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-unmap-pages-to-remove-if-page-fault-raced-with-hole-punch.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-unmap-pages-to-remove-if-page-fault-raced-with-hole-punch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/hugetlb: unmap pages to remove if page fault raced with hole punch

Page faults can race with fallocate hole punch.  If a page fault happens
between the unmap and remove operations, the page is not removed and
remains within the hole.  This is not the desired behavior.  If a page is
mapped, the remove operation (remove_inode_hugepages) will unmap the page
before removing.  The unmap within remove_inode_hugepages occurs with the
hugetlb_fault_mutex held so that no other faults can occur until the page
is removed.

The (unmodified) routine hugetlb_vmdelete_list was moved ahead of
remove_inode_hugepages to satisfy the new reference.

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |  123 +++++++++++++++++++++--------------------
 1 file changed, 63 insertions(+), 60 deletions(-)

diff -puN fs/hugetlbfs/inode.c~mm-hugetlb-unmap-pages-to-remove-if-page-fault-raced-with-hole-punch fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-hugetlb-unmap-pages-to-remove-if-page-fault-raced-with-hole-punch
+++ a/fs/hugetlbfs/inode.c
@@ -324,11 +324,44 @@ static void remove_huge_page(struct page
 	delete_from_page_cache(page);
 }
 
+static inline void
+hugetlb_vmdelete_list(struct rb_root *root, pgoff_t start, pgoff_t end)
+{
+	struct vm_area_struct *vma;
+
+	/*
+	 * end == 0 indicates that the entire range after
+	 * start should be unmapped.
+	 */
+	vma_interval_tree_foreach(vma, root, start, end ? end : ULONG_MAX) {
+		unsigned long v_offset;
+
+		/*
+		 * Can the expression below overflow on 32-bit arches?
+		 * No, because the interval tree returns us only those vmas
+		 * which overlap the truncated area starting at pgoff,
+		 * and no vma on a 32-bit arch can span beyond the 4GB.
+		 */
+		if (vma->vm_pgoff < start)
+			v_offset = (start - vma->vm_pgoff) << PAGE_SHIFT;
+		else
+			v_offset = 0;
+
+		if (end) {
+			end = ((end - start) << PAGE_SHIFT) +
+			       vma->vm_start + v_offset;
+			if (end > vma->vm_end)
+				end = vma->vm_end;
+		} else
+			end = vma->vm_end;
+
+		unmap_hugepage_range(vma, vma->vm_start + v_offset, end, NULL);
+	}
+}
 
 /*
  * remove_inode_hugepages handles two distinct cases: truncation and hole
  * punch.  There are subtle differences in operation for each case.
-
  * truncation is indicated by end of range being LLONG_MAX
  *	In this case, we first scan the range and release found pages.
  *	After releasing pages, hugetlb_unreserve_pages cleans up region/reserv
@@ -381,12 +414,25 @@ static void remove_inode_hugepages(struc
 		for (i = 0; i < pagevec_count(&pvec); ++i) {
 			struct page *page = pvec.pages[i];
 			u32 hash;
+			bool rsv_on_error;
 
 			hash = hugetlb_fault_mutex_hash(h, current->mm,
 							&pseudo_vma,
 							mapping, next, 0);
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
+			/*
+			 * If page is mapped, it was faulted in after being
+			 * unmapped in caller.  Unmap (again) now after taking
+			 * the fault mutex.  The mutex will prevent faults
+			 * until we finish removing the page.
+			 */
+			if (page_mapped(page)) {
+				hugetlb_vmdelete_list(&mapping->i_mmap,
+					next * pages_per_huge_page(h),
+					(next + 1) * pages_per_huge_page(h));
+			}
+
 			lock_page(page);
 			if (page->index >= end) {
 				unlock_page(page);
@@ -396,31 +442,23 @@ static void remove_inode_hugepages(struc
 			}
 
 			/*
-			 * If page is mapped, it was faulted in after being
-			 * unmapped.  Do nothing in this race case.  In the
-			 * normal case page is not mapped.
+			 * We must free the huge page and remove from page
+			 * cache (remove_huge_page) BEFORE removing the
+			 * region/reserve map (hugetlb_unreserve_pages).
+			 * In rare out of memory conditions, removal of the
+			 * region/reserve map could fail.  Before free'ing
+			 * the page, note PagePrivate which is used in case
+			 * of error.
 			 */
-			if (!page_mapped(page)) {
-				bool rsv_on_error = !PagePrivate(page);
-				/*
-				 * We must free the huge page and remove
-				 * from page cache (remove_huge_page) BEFORE
-				 * removing the region/reserve map
-				 * (hugetlb_unreserve_pages).  In rare out
-				 * of memory conditions, removal of the
-				 * region/reserve map could fail.  Before
-				 * free'ing the page, note PagePrivate which
-				 * is used in case of error.
-				 */
-				remove_huge_page(page);
-				freed++;
-				if (!truncate_op) {
-					if (unlikely(hugetlb_unreserve_pages(
-							inode, next,
-							next + 1, 1)))
-						hugetlb_fix_reserve_counts(
-							inode, rsv_on_error);
-				}
+			rsv_on_error = !PagePrivate(page);
+			remove_huge_page(page);
+			freed++;
+			if (!truncate_op) {
+				if (unlikely(hugetlb_unreserve_pages(inode,
+								next, next + 1,
+								1)))
+					hugetlb_fix_reserve_counts(inode,
+								rsv_on_error);
 			}
 
 			if (page->index > next)
@@ -450,41 +488,6 @@ static void hugetlbfs_evict_inode(struct
 	clear_inode(inode);
 }
 
-static inline void
-hugetlb_vmdelete_list(struct rb_root *root, pgoff_t start, pgoff_t end)
-{
-	struct vm_area_struct *vma;
-
-	/*
-	 * end == 0 indicates that the entire range after
-	 * start should be unmapped.
-	 */
-	vma_interval_tree_foreach(vma, root, start, end ? end : ULONG_MAX) {
-		unsigned long v_offset;
-
-		/*
-		 * Can the expression below overflow on 32-bit arches?
-		 * No, because the interval tree returns us only those vmas
-		 * which overlap the truncated area starting at pgoff,
-		 * and no vma on a 32-bit arch can span beyond the 4GB.
-		 */
-		if (vma->vm_pgoff < start)
-			v_offset = (start - vma->vm_pgoff) << PAGE_SHIFT;
-		else
-			v_offset = 0;
-
-		if (end) {
-			end = ((end - start) << PAGE_SHIFT) +
-			       vma->vm_start + v_offset;
-			if (end > vma->vm_end)
-				end = vma->vm_end;
-		} else
-			end = vma->vm_end;
-
-		unmap_hugepage_range(vma, vma->vm_start + v_offset, end, NULL);
-	}
-}
