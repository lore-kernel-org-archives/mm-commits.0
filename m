From: akpm@linux-foundation.org
Subject: + hugetlb-enforce-quotas-during-reservation-for-shared-mappings.patch added to -mm tree
Date: Tue, 30 Oct 2007 16:23:07 -0700
Message-ID: <200710302323.l9UNN7QL000829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50575 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752515AbXJ3XXs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 19:23:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agl@us.ibm.com, apw@shadowen.org, haveblue@us.ibm.com, hermes@gibson.dropbear.id.au, kenchen@google.com, wli@holomorphy.com


The patch titled
     hugetlb: enforce quotas during reservation for shared mappings
has been added to the -mm tree.  Its filename is
     hugetlb-enforce-quotas-during-reservation-for-shared-mappings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1147,6 +1147,8 @@ int hugetlb_reserve_pages(struct inode *
 	if (chg < 0)
 		return chg;
 
+	if (hugetlb_get_quota(inode->i_mapping, chg))
+		return -ENOSPC;
 	ret = hugetlb_acct_memory(chg);
 	if (ret < 0)
 		return ret;
@@ -1157,5 +1159,6 @@ int hugetlb_reserve_pages(struct inode *
 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed)
 {
 	long chg = region_truncate(&inode->i_mapping->private_list, offset);
-	hugetlb_acct_memory(freed - chg);
+	hugetlb_put_quota(inode->i_mapping, (chg - freed));
+	hugetlb_acct_memory(-(chg - freed));
 }
_

Patches currently in -mm which might be from agl@us.ibm.com are

hugetlb-allow-sticky-directory-mount-option.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
hugetlb-fix-quota-management-for-private-mappings.patch
hugetlb-debit-quota-in-alloc_huge_page.patch
hugetlb-allow-bulk-updating-in-hugetlb__quota.patch
hugetlb-enforce-quotas-during-reservation-for-shared-mappings.patch
