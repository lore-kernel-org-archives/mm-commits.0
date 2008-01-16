From: akpm@linux-foundation.org
Subject: - hugetlbfs-fix-quota-leak.patch removed from -mm tree
Date: Tue, 15 Jan 2008 17:38:32 -0800
Message-ID: <200801160138.m0G1cWTJ013918@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58699 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755450AbYAPBi6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 20:38:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenchen@google.com, agl@us.ibm.com, david@gibson.dropbear.id.au, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     hugetlbfs: fix quota leak
has been removed from the -mm tree.  Its filename was
     hugetlbfs-fix-quota-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlbfs: fix quota leak
From: "Ken Chen" <kenchen@google.com>

In the error path of both shared and private hugetlb page allocation, the file
system quota is never undone, leading to fs quota leak.  Fix them up.

[akpm@linux-foundation.org: cleanup, micro-optimise]
Signed-off-by: Ken Chen <kenchen@google.com>
Acked-by: Adam Litke <agl@us.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: William Lee Irwin III <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN mm/hugetlb.c~hugetlbfs-fix-quota-leak mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlbfs-fix-quota-leak
+++ a/mm/hugetlb.c
@@ -418,9 +418,14 @@ static struct page *alloc_huge_page_priv
 	if (free_huge_pages > resv_huge_pages)
 		page = dequeue_huge_page(vma, addr);
 	spin_unlock(&hugetlb_lock);
-	if (!page)
+	if (!page) {
 		page = alloc_buddy_huge_page(vma, addr);
-	return page ? page : ERR_PTR(-VM_FAULT_OOM);
+		if (!page) {
+			hugetlb_put_quota(vma->vm_file->f_mapping, 1);
+			return ERR_PTR(-VM_FAULT_OOM);
+		}
+	}
+	return page;
 }
 
 static struct page *alloc_huge_page(struct vm_area_struct *vma,
@@ -1206,8 +1211,10 @@ int hugetlb_reserve_pages(struct inode *
 	if (hugetlb_get_quota(inode->i_mapping, chg))
 		return -ENOSPC;
 	ret = hugetlb_acct_memory(chg);
-	if (ret < 0)
+	if (ret < 0) {
+		hugetlb_put_quota(inode->i_mapping, chg);
 		return ret;
+	}
 	region_add(&inode->i_mapping->private_list, from, to);
 	return 0;
 }
_

Patches currently in -mm which might be from kenchen@google.com are

origin.patch
hugetlb-allow-sticky-directory-mount-option.patch
