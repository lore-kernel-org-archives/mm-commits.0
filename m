From: akpm@linux-foundation.org
Subject: + hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch added to -mm tree
Date: Tue, 30 Oct 2007 16:18:45 -0700
Message-ID: <200710302318.l9UNIj6S000622@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38569 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223AbXJ3XTs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 19:19:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agl@us.ibm.com, apw@shadowen.org, haveblue@us.ibm.com, hermes@gibson.dropbear.id.au, kenchen@google.com, wli@holomorphy.com


The patch titled
     hugetlb: split alloc_huge_page into private and shared components
has been added to the -mm tree.  Its filename is
     hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hugetlb: split alloc_huge_page into private and shared components
From: Adam Litke <agl@us.ibm.com>

The shared page reservation and dynamic pool resizing features have made the
allocation of private vs.  shared huge pages quite different.  By splitting
out the private/shared-specific portions of the process into their own
functions, readability is greatly improved.  alloc_huge_page now calls the
proper helper and performs common operations.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Cc: Ken Chen <kenchen@google.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: David Gibson <hermes@gibson.dropbear.id.au>
Cc: William Lee Irwin III <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   46 +++++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-split-alloc_huge_page-into-private-and-shared-components mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-split-alloc_huge_page-into-private-and-shared-components
+++ a/mm/hugetlb.c
@@ -353,35 +353,43 @@ void return_unused_surplus_pages(unsigne
 	}
 }
 
-static struct page *alloc_huge_page(struct vm_area_struct *vma,
-				    unsigned long addr)
+
+static struct page *alloc_huge_page_shared(struct vm_area_struct *vma,
+			 			unsigned long addr)
 {
-	struct page *page = NULL;
-	int use_reserved_page = vma->vm_flags & VM_MAYSHARE;
+	struct page *page;
 
 	spin_lock(&hugetlb_lock);
-	if (!use_reserved_page && (free_huge_pages <= resv_huge_pages))
-		goto fail;
-
 	page = dequeue_huge_page(vma, addr);
-	if (!page)
-		goto fail;
-
 	spin_unlock(&hugetlb_lock);
-	set_page_refcounted(page);
 	return page;
+}
 
-fail:
-	spin_unlock(&hugetlb_lock);
+static struct page *alloc_huge_page_private(struct vm_area_struct *vma,
+			 			unsigned long addr)
+{
+	struct page *page = NULL;
 
-	/*
-	 * Private mappings do not use reserved huge pages so the allocation
-	 * may have failed due to an undersized hugetlb pool.  Try to grab a
-	 * surplus huge page from the buddy allocator.
-	 */
-	if (!use_reserved_page)
+	spin_lock(&hugetlb_lock);
+	if (free_huge_pages > resv_huge_pages)
+		page = dequeue_huge_page(vma, addr);
+	spin_unlock(&hugetlb_lock);
+	if (!page)
 		page = alloc_buddy_huge_page(vma, addr);
+	return page;
+}
 
+static struct page *alloc_huge_page(struct vm_area_struct *vma,
+				    unsigned long addr)
+{
+	struct page *page;
+
+	if (vma->vm_flags & VM_MAYSHARE)
+		page = alloc_huge_page_shared(vma, addr);
+	else
+		page = alloc_huge_page_private(vma, addr);
+	if (page)
+		set_page_refcounted(page);
 	return page;
 }
 
_

Patches currently in -mm which might be from agl@us.ibm.com are

hugetlb-allow-sticky-directory-mount-option.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch
hugetlb-fix-quota-management-for-private-mappings.patch
hugetlb-debit-quota-in-alloc_huge_page.patch
hugetlb-allow-bulk-updating-in-hugetlb__quota.patch
hugetlb-enforce-quotas-during-reservation-for-shared-mappings.patch
