From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch-fix.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 16:34:06 -0800
Message-ID: <56998ffe.Y51BB7K+D//+WOB+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38058 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617AbcAPAeH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 19:34:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave.hansen@linux.intel.com, dave@stgolabs.net, hillf.zj@alibaba-inc.com, hughd@google.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch-fix.patch

This patch was dropped because it was folded into mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch-fix

move hugetlb_vmdelete_list()

Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   76 ++++++++++++++++++++---------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff -puN fs/hugetlbfs/inode.c~mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch-fix fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch-fix
+++ a/fs/hugetlbfs/inode.c
@@ -324,6 +324,44 @@ static void remove_huge_page(struct page
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
+
 /*
  * remove_inode_hugepages handles two distinct cases: truncation and hole
  * punch.  There are subtle differences in operation for each case.
@@ -458,44 +496,6 @@ static void hugetlbfs_evict_inode(struct
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
