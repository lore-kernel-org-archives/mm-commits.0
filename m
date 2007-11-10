From: akpm@linux-foundation.org
Subject: + hugetlb-fix-i_blocks-accounting.patch added to -mm tree
Date: Fri, 09 Nov 2007 17:14:46 -0800
Message-ID: <200711100114.lAA1Ek7D008667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48049 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756120AbXKJBPD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 20:15:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kenchen@google.com, agl@us.ibm.com, david@gibson.dropbear.id.au, pbadari@us.ibm.com


The patch titled
     hugetlb: fix i_blocks accounting
has been added to the -mm tree.  Its filename is
     hugetlb-fix-i_blocks-accounting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hugetlb: fix i_blocks accounting
From: "Ken Chen" <kenchen@google.com>

For administrative purpose, we want to query actual block usage for
hugetlbfs file via fstat.  Currently, hugetlbfs always return 0.  Fix that
up since kernel already has all the information to track it properly.

Signed-off-by: Ken Chen <kenchen@google.com>
Acked-by: Adam Litke <agl@us.ibm.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 ++
 mm/hugetlb.c            |   10 ++++++++++
 2 files changed, 12 insertions(+)

diff -puN include/linux/hugetlb.h~hugetlb-fix-i_blocks-accounting include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-fix-i_blocks-accounting
+++ a/include/linux/hugetlb.h
@@ -168,6 +168,8 @@ struct file *hugetlb_file_setup(const ch
 int hugetlb_get_quota(struct address_space *mapping, long delta);
 void hugetlb_put_quota(struct address_space *mapping, long delta);
 
+#define BLOCKS_PER_HUGEPAGE	(HPAGE_SIZE / 512)
+
 static inline int is_file_hugepages(struct file *file)
 {
 	if (file->f_op == &hugetlbfs_file_operations)
diff -puN mm/hugetlb.c~hugetlb-fix-i_blocks-accounting mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-i_blocks-accounting
+++ a/mm/hugetlb.c
@@ -801,6 +801,7 @@ retry:
 
 		if (vma->vm_flags & VM_SHARED) {
 			int err;
+			struct inode *inode = mapping->host;
 
 			err = add_to_page_cache(page, mapping, idx, GFP_KERNEL);
 			if (err) {
@@ -809,6 +810,10 @@ retry:
 					goto retry;
 				goto out;
 			}
+
+			spin_lock(&inode->i_lock);
+			inode->i_blocks += BLOCKS_PER_HUGEPAGE;
+			spin_unlock(&inode->i_lock);
 		} else
 			lock_page(page);
 	}
@@ -1160,6 +1165,11 @@ int hugetlb_reserve_pages(struct inode *
 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed)
 {
 	long chg = region_truncate(&inode->i_mapping->private_list, offset);
+
+	spin_lock(&inode->i_lock);
+	inode->i_blocks -= BLOCKS_PER_HUGEPAGE * freed;
+	spin_unlock(&inode->i_lock);
+
 	hugetlb_put_quota(inode->i_mapping, (chg - freed));
 	hugetlb_acct_memory(-(chg - freed));
 }
_

Patches currently in -mm which might be from kenchen@google.com are

hugetlb-follow_hugetlb_page-for-write-access.patch
hugetlb-allow-sticky-directory-mount-option.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
hugetlb-fix-quota-management-for-private-mappings.patch
hugetlb-debit-quota-in-alloc_huge_page.patch
hugetlb-allow-bulk-updating-in-hugetlb__quota.patch
hugetlb-enforce-quotas-during-reservation-for-shared-mappings.patch
hugetlb-fix-i_blocks-accounting.patch
