From: akpm@linux-foundation.org
Subject: + hugetlb-debit-quota-in-alloc_huge_page.patch added to -mm tree
Date: Tue, 30 Oct 2007 16:22:46 -0700
Message-ID: <200710302322.l9UNMlsQ000809@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34821 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752868AbXJ3XXl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 19:23:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agl@us.ibm.com, apw@shadowen.org, haveblue@us.ibm.com, hermes@gibson.dropbear.id.au, kenchen@google.com, wli@holomorphy.com


The patch titled
     hugetlb: debit quota in alloc_huge_page
has been added to the -mm tree.  Its filename is
     hugetlb-debit-quota-in-alloc_huge_page.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hugetlb: debit quota in alloc_huge_page
From: Adam Litke <agl@us.ibm.com>

Now that quota is credited by free_huge_page(), calls to hugetlb_get_quota()
seem out of place.  The alloc/free API is unbalanced because we handle the
hugetlb_put_quota() but expect the caller to open-code hugetlb_get_quota(). 
Move the get inside alloc_huge_page to clean up this disparity.

This patch has been kept apart from the previous patch because of the somewhat
dodgy ERR_PTR() use herein.  Moving the quota logic means that
alloc_huge_page() has two failure modes.  Quota failure must result in a
SIGBUS while a standard allocation failure is OOM.  Unfortunately, ERR_PTR()
doesn't like the small positive errnos we have in VM_FAULT_* so they must be
negated before they are used.

Does anyone take issue with the way I am using PTR_ERR.  If so, what are your
thoughts on how to clean this up (without needing an if,else if,else block at
each alloc_huge_page() callsite)?

Signed-off-by: Adam Litke <agl@us.ibm.com>
Cc: Ken Chen <kenchen@google.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: David Gibson <hermes@gibson.dropbear.id.au>
Cc: William Lee Irwin III <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-debit-quota-in-alloc_huge_page mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-debit-quota-in-alloc_huge_page
+++ a/mm/hugetlb.c
@@ -388,6 +388,10 @@ static struct page *alloc_huge_page(stru
 				    unsigned long addr)
 {
 	struct page *page;
+	struct address_space *mapping = vma->vm_file->f_mapping;
+
+	if (hugetlb_get_quota(mapping))
+		return ERR_PTR(-VM_FAULT_SIGBUS);
 
 	if (vma->vm_flags & VM_MAYSHARE)
 		page = alloc_huge_page_shared(vma, addr);
@@ -395,9 +399,10 @@ static struct page *alloc_huge_page(stru
 		page = alloc_huge_page_private(vma, addr);
 	if (page) {
 		set_page_refcounted(page);
-		set_page_private(page, (unsigned long) vma->vm_file->f_mapping);
-	}
-	return page;
+		set_page_private(page, (unsigned long) mapping);
+		return page;
+	} else
+		return ERR_PTR(-VM_FAULT_OOM);
 }
 
 static int __init hugetlb_init(void)
@@ -737,15 +742,13 @@ static int hugetlb_cow(struct mm_struct 
 		set_huge_ptep_writable(vma, address, ptep);
 		return 0;
 	}
-	if (hugetlb_get_quota(vma->vm_file->f_mapping))
-		return VM_FAULT_SIGBUS;
 
 	page_cache_get(old_page);
 	new_page = alloc_huge_page(vma, address);
 
-	if (!new_page) {
+	if (IS_ERR(new_page)) {
 		page_cache_release(old_page);
-		return VM_FAULT_OOM;
+		return -PTR_ERR(new_page);
 	}
 
 	spin_unlock(&mm->page_table_lock);
@@ -789,12 +792,9 @@ retry:
 		size = i_size_read(mapping->host) >> HPAGE_SHIFT;
 		if (idx >= size)
 			goto out;
-		if (hugetlb_get_quota(mapping))
-			goto out;
 		page = alloc_huge_page(vma, address);
-		if (!page) {
-			hugetlb_put_quota(mapping);
-			ret = VM_FAULT_OOM;
+		if (IS_ERR(page)) {
+			ret = -PTR_ERR(page);
 			goto out;
 		}
 		clear_huge_page(page, address);
_

Patches currently in -mm which might be from agl@us.ibm.com are

hugetlb-allow-sticky-directory-mount-option.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
hugetlb-fix-quota-management-for-private-mappings.patch
hugetlb-debit-quota-in-alloc_huge_page.patch
hugetlb-allow-bulk-updating-in-hugetlb__quota.patch
hugetlb-enforce-quotas-during-reservation-for-shared-mappings.patch
