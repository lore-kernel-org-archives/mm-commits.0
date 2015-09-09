From: akpm@linux-foundation.org
Subject: [merged]
 hugetlbfs-hugetlb_vmtruncate_list-needs-to-take-a-range-to-delete.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:46:14 -0700
Message-ID: <55f08c86.PJWESpIz4NAThnfX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbbIITqP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:46:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, aneesh.kumar@linux.vnet.ibm.com, dave.hansen@linux.intel.com, dave@stgolabs.net, hch@infradead.org, hillf.zj@alibaba-inc.com, hughd@google.com, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: hugetlb_vmtruncate_list() needs to take a range to delete
has been removed from the -mm tree.  Its filename was
     hugetlbfs-hugetlb_vmtruncate_list-needs-to-take-a-range-to-delete.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlbfs: hugetlb_vmtruncate_list() needs to take a range to delete

fallocate hole punch will want to unmap a specific range of pages.  Modify
the existing hugetlb_vmtruncate_list() routine to take a start/end range. 
If end is 0, this indicates all pages after start should be unmapped. 
This is the same as the existing truncate functionality.  Modify existing
callers to add 0 as end of range.

Since the routine will be used in hole punch as well as truncate
operations, it is more appropriately renamed to hugetlb_vmdelete_list().

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-hugetlb_vmtruncate_list-needs-to-take-a-range-to-delete fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-hugetlb_vmtruncate_list-needs-to-take-a-range-to-delete
+++ a/fs/hugetlbfs/inode.c
@@ -349,11 +349,15 @@ static void hugetlbfs_evict_inode(struct
 }
 
 static inline void
-hugetlb_vmtruncate_list(struct rb_root *root, pgoff_t pgoff)
+hugetlb_vmdelete_list(struct rb_root *root, pgoff_t start, pgoff_t end)
 {
 	struct vm_area_struct *vma;
 
-	vma_interval_tree_foreach(vma, root, pgoff, ULONG_MAX) {
+	/*
+	 * end == 0 indicates that the entire range after
+	 * start should be unmapped.
+	 */
+	vma_interval_tree_foreach(vma, root, start, end ? end : ULONG_MAX) {
 		unsigned long v_offset;
 
 		/*
@@ -362,13 +366,20 @@ hugetlb_vmtruncate_list(struct rb_root *
 		 * which overlap the truncated area starting at pgoff,
 		 * and no vma on a 32-bit arch can span beyond the 4GB.
 		 */
-		if (vma->vm_pgoff < pgoff)
-			v_offset = (pgoff - vma->vm_pgoff) << PAGE_SHIFT;
+		if (vma->vm_pgoff < start)
+			v_offset = (start - vma->vm_pgoff) << PAGE_SHIFT;
 		else
 			v_offset = 0;
 
-		unmap_hugepage_range(vma, vma->vm_start + v_offset,
-				     vma->vm_end, NULL);
+		if (end) {
+			end = ((end - start) << PAGE_SHIFT) +
+			       vma->vm_start + v_offset;
+			if (end > vma->vm_end)
+				end = vma->vm_end;
+		} else
+			end = vma->vm_end;
+
+		unmap_hugepage_range(vma, vma->vm_start + v_offset, end, NULL);
 	}
 }
 
@@ -384,7 +395,7 @@ static int hugetlb_vmtruncate(struct ino
 	i_size_write(inode, offset);
 	i_mmap_lock_write(mapping);
 	if (!RB_EMPTY_ROOT(&mapping->i_mmap))
-		hugetlb_vmtruncate_list(&mapping->i_mmap, pgoff);
+		hugetlb_vmdelete_list(&mapping->i_mmap, pgoff, 0);
 	i_mmap_unlock_write(mapping);
 	truncate_hugepages(inode, offset);
 	return 0;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


