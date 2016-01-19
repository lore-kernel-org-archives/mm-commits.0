From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch.patch removed
 from -mm tree
Date: Tue, 19 Jan 2016 12:14:22 -0800
Message-ID: <569e991e.QWnamvhFxeZ+Pm30%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44471 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbcASUOX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:14:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dave.hansen@linux.intel.com, dave@stgolabs.net, hillf.zj@alibaba-inc.com, hughd@google.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlbfs: unmap pages if page fault raced with hole punch
has been removed from the -mm tree.  Its filename was
     mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/hugetlbfs: unmap pages if page fault raced with hole punch

Page faults can race with fallocate hole punch.  If a page fault happens
between the unmap and remove operations, the page is not removed and
remains within the hole.  This is not the desired behavior.  The race is
difficult to detect in user level code as even in the non-race case, a
page within the hole could be faulted back in before fallocate returns. 
If userfaultfd is expanded to support hugetlbfs in the future, this race
will be easier to observe.

If this race is detected and a page is mapped, the remove operation
(remove_inode_hugepages) will unmap the page before removing.  The unmap
within remove_inode_hugepages occurs with the hugetlb_fault_mutex held so
that no other faults will be processed until the page is removed.

The (unmodified) routine hugetlb_vmdelete_list was moved ahead of
remove_inode_hugepages to satisfy the new reference.

[akpm@linux-foundation.org: move hugetlb_vmdelete_list()]
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |  144 +++++++++++++++++++++--------------------
 1 file changed, 75 insertions(+), 69 deletions(-)

diff -puN fs/hugetlbfs/inode.c~mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch
+++ a/fs/hugetlbfs/inode.c
@@ -324,11 +324,48 @@ static void remove_huge_page(struct page
 	delete_from_page_cache(page);
 }
 
+static void
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
+		unsigned long v_end;
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
+		if (!end)
+			v_end = vma->vm_end;
+		else {
+			v_end = ((end - vma->vm_pgoff) << PAGE_SHIFT)
+							+ vma->vm_start;
+			if (v_end > vma->vm_end)
+				v_end = vma->vm_end;
+		}
+
+		unmap_hugepage_range(vma, vma->vm_start + v_offset, v_end,
+									NULL);
+	}
+}
 
 /*
  * remove_inode_hugepages handles two distinct cases: truncation and hole
  * punch.  There are subtle differences in operation for each case.
-
+ *
  * truncation is indicated by end of range being LLONG_MAX
  *	In this case, we first scan the range and release found pages.
  *	After releasing pages, hugetlb_unreserve_pages cleans up region/reserv
@@ -379,6 +416,7 @@ static void remove_inode_hugepages(struc
 
 		for (i = 0; i < pagevec_count(&pvec); ++i) {
 			struct page *page = pvec.pages[i];
+			bool rsv_on_error;
 			u32 hash;
 
 			/*
@@ -395,37 +433,43 @@ static void remove_inode_hugepages(struc
 							mapping, next, 0);
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
-			lock_page(page);
-			if (likely(!page_mapped(page))) {
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
-			} else {
-				/*
-				 * If page is mapped, it was faulted in after
-				 * being unmapped.  It indicates a race between
-				 * hole punch and page fault.  Do nothing in
-				 * this case.  Getting here in a truncate
-				 * operation is a bug.
-				 */
+			/*
+			 * If page is mapped, it was faulted in after being
+			 * unmapped in caller.  Unmap (again) now after taking
+			 * the fault mutex.  The mutex will prevent faults
+			 * until we finish removing the page.
+			 *
+			 * This race can only happen in the hole punch case.
+			 * Getting here in a truncate operation is a bug.
+			 */
+			if (unlikely(page_mapped(page))) {
 				BUG_ON(truncate_op);
+
+				i_mmap_lock_write(mapping);
+				hugetlb_vmdelete_list(&mapping->i_mmap,
+					next * pages_per_huge_page(h),
+					(next + 1) * pages_per_huge_page(h));
+				i_mmap_unlock_write(mapping);
+			}
+
+			lock_page(page);
+			/*
+			 * We must free the huge page and remove from page
+			 * cache (remove_huge_page) BEFORE removing the
+			 * region/reserve map (hugetlb_unreserve_pages).  In
+			 * rare out of memory conditions, removal of the
+			 * region/reserve map could fail.  Before free'ing
+			 * the page, note PagePrivate which is used in case
+			 * of error.
+			 */
+			rsv_on_error = !PagePrivate(page);
+			remove_huge_page(page);
+			freed++;
+			if (!truncate_op) {
+				if (unlikely(hugetlb_unreserve_pages(inode,
+							next, next + 1, 1)))
+					hugetlb_fix_reserve_counts(inode,
+								rsv_on_error);
 			}
 
 			unlock_page(page);
@@ -452,44 +496,6 @@ static void hugetlbfs_evict_inode(struct
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
-		unsigned long v_end;
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
-		if (!end)
-			v_end = vma->vm_end;
-		else {
-			v_end = ((end - vma->vm_pgoff) << PAGE_SHIFT)
-							+ vma->vm_start;
-			if (v_end > vma->vm_end)
-				v_end = vma->vm_end;
-		}
-
-		unmap_hugepage_range(vma, vma->vm_start + v_offset, v_end,
-									NULL);
-	}
-}
