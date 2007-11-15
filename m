From: akpm@linux-foundation.org
Subject: - hugetlb-enforce-quotas-during-reservation-for-shared-mappings.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:09:46 -0800
Message-ID: <200711152109.lAFL9knG015481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34768 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932814AbXKOVSZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:18:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agl@us.ibm.com, apw@shadowen.org, haveblue@us.ibm.com, hermes@gibson.dropbear.id.au, kenchen@google.com, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: enforce quotas during reservation for shared mappings
has been removed from the -mm tree.  Its filename was
     hugetlb-enforce-quotas-during-reservation-for-shared-mappings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hugetlb: enforce quotas during reservation for shared mappings
From: Adam Litke <agl@us.ibm.com>

When a MAP_SHARED mmap of a hugetlbfs file succeeds, huge pages are reserved
to guarantee no problems will occur later when instantiating pages.  If quotas
are in force, page instantiation could fail due to a race with another process
or an oversized (but approved) shared mapping.

To prevent these scenarios, debit the quota for the full reservation amount up
front and credit the unused quota when the reservation is released.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Cc: Ken Chen <kenchen@google.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: David Gibson <hermes@gibson.dropbear.id.au>
Cc: William Lee Irwin III <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-enforce-quotas-during-reservation-for-shared-mappings mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-enforce-quotas-during-reservation-for-shared-mappings
+++ a/mm/hugetlb.c
@@ -367,7 +367,7 @@ static struct page *alloc_huge_page_shar
 	spin_lock(&hugetlb_lock);
 	page = dequeue_huge_page(vma, addr);
 	spin_unlock(&hugetlb_lock);
-	return page;
+	return page ? page : ERR_PTR(-VM_FAULT_OOM);
 }
 
 static struct page *alloc_huge_page_private(struct vm_area_struct *vma,
@@ -375,13 +375,16 @@ static struct page *alloc_huge_page_priv
 {
 	struct page *page = NULL;
 
+	if (hugetlb_get_quota(vma->vm_file->f_mapping, 1))
+		return ERR_PTR(-VM_FAULT_SIGBUS);
+
 	spin_lock(&hugetlb_lock);
 	if (free_huge_pages > resv_huge_pages)
 		page = dequeue_huge_page(vma, addr);
 	spin_unlock(&hugetlb_lock);
 	if (!page)
 		page = alloc_buddy_huge_page(vma, addr);
-	return page;
+	return page ? page : ERR_PTR(-VM_FAULT_OOM);
 }
 
 static struct page *alloc_huge_page(struct vm_area_struct *vma,
@@ -390,19 +393,16 @@ static struct page *alloc_huge_page(stru
 	struct page *page;
 	struct address_space *mapping = vma->vm_file->f_mapping;
 
-	if (hugetlb_get_quota(mapping, 1))
-		return ERR_PTR(-VM_FAULT_SIGBUS);
-
 	if (vma->vm_flags & VM_MAYSHARE)
 		page = alloc_huge_page_shared(vma, addr);
 	else
 		page = alloc_huge_page_private(vma, addr);
-	if (page) {
+
+	if (!IS_ERR(page)) {
 		set_page_refcounted(page);
 		set_page_private(page, (unsigned long) mapping);
-		return page;
-	} else
-		return ERR_PTR(-VM_FAULT_OOM);
+	}
+	return page;
 }
 
 static int __init hugetlb_init(void)
@@ -1148,6 +1148,8 @@ int hugetlb_reserve_pages(struct inode *
 	if (chg < 0)
 		return chg;
 
+	if (hugetlb_get_quota(inode->i_mapping, chg))
+		return -ENOSPC;
 	ret = hugetlb_acct_memory(chg);
 	if (ret < 0)
 		return ret;
@@ -1158,5 +1160,6 @@ int hugetlb_reserve_pages(struct inode *
 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed)
 {
 	long chg = region_truncate(&inode->i_mapping->private_list, offset);
-	hugetlb_acct_memory(freed - chg);
+	hugetlb_put_quota(inode->i_mapping, (chg - freed));
+	hugetlb_acct_memory(-(chg - freed));
 }
_

Patches currently in -mm which might be from agl@us.ibm.com are

origin.patch
hugetlb-allow-sticky-directory-mount-option.patch
