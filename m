From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-hugetlbfs-fix-bugs-in-hugetlb_vmtruncate_list.patch removed from -mm
 tree
Date: Fri, 08 Jan 2016 16:13:35 -0800
Message-ID: <569050af.5ol80B1rc7YmNGib%akpm__41730.9514749379$1452298429$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52390 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbcAIANg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2016 19:13:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dave.hansen@linux.intel.com, dave@stgolabs.net, hillf.zj@alibaba-inc.com, hughd@google.com, n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/hugetlbfs/inode.c: fix bugs in hugetlb_vmtruncate_list()
has been removed from the -mm tree.  Its filename was
     mm-hugetlbfs-fix-bugs-in-hugetlb_vmtruncate_list.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: fs/hugetlbfs/inode.c: fix bugs in hugetlb_vmtruncate_list()

Hillf Danton noticed bugs in hugetlb_vmtruncate_list().  The argument end
is of type pgoff_t.  It was being converted to a vaddr offset and passed
to unmap_hugepage_range.  However, end was also being used as an argument
to the vma_interval_tree_foreach controlling loop.  In addition, the
conversion of end to vaddr offset was incorrect.

Fixes: 1bfad99ab (" hugetlbfs: hugetlb_vmtruncate_list() needs to take a range")Reported-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: <stable@vger.kernel.org>	[4.3]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN fs/hugetlbfs/inode.c~mm-hugetlbfs-fix-bugs-in-hugetlb_vmtruncate_list fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-hugetlbfs-fix-bugs-in-hugetlb_vmtruncate_list
+++ a/fs/hugetlbfs/inode.c
@@ -461,8 +461,12 @@ hugetlb_vmdelete_list(struct rb_root *ro
 	 * end == 0 indicates that the entire range after
 	 * start should be unmapped.
 	 */
-	vma_interval_tree_foreach(vma, root, start, end ? end : ULONG_MAX) {
+	if (!end)
+		end = ULONG_MAX;
+
+	vma_interval_tree_foreach(vma, root, start, end) {
 		unsigned long v_offset;
+		unsigned long v_end;
 
 		/*
 		 * Can the expression below overflow on 32-bit arches?
@@ -475,15 +479,12 @@ hugetlb_vmdelete_list(struct rb_root *ro
 		else
 			v_offset = 0;
 
-		if (end) {
-			end = ((end - start) << PAGE_SHIFT) +
-			       vma->vm_start + v_offset;
-			if (end > vma->vm_end)
-				end = vma->vm_end;
-		} else
-			end = vma->vm_end;
+		v_end = (end - vma->vm_pgoff) << PAGE_SHIFT;
+		if (v_end > vma->vm_end)
+			v_end = vma->vm_end;
 
-		unmap_hugepage_range(vma, vma->vm_start + v_offset, end, NULL);
+		unmap_hugepage_range(vma, vma->vm_start + v_offset, v_end,
+									NULL);
 	}
 }
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


