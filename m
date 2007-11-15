From: akpm@linux-foundation.org
Subject: - hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:09:36 -0800
Message-ID: <200711152109.lAFL9aLS015468@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57407 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763023AbXKOVSi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:18:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agl@us.ibm.com, apw@shadowen.org, haveblue@us.ibm.com, hermes@gibson.dropbear.id.au, kenchen@google.com, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: split alloc_huge_page into private and shared components
has been removed from the -mm tree.  Its filename was
     hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hugetlb: split alloc_huge_page into private and shared components
From: Adam Litke <agl@us.ibm.com>

Hugetlbfs implements a quota system which can limit the amount of memory that
can be used by the filesystem.  Before allocating a new huge page for a file,
the quota is checked and debited.  The quota is then credited when truncating
the file.  I found a few bugs in the code for both MAP_PRIVATE and MAP_SHARED
mappings.  Before detailing the problems and my proposed solutions, we should
agree on a definition of quotas that properly addresses both private and
shared pages.  Since the purpose of quotas is to limit total memory
consumption on a per-filesystem basis, I argue that all pages allocated by the
fs (private and shared) should be charged against quota.

Private Mappings
================

The current code will debit quota for private pages sometimes, but will never
credit it.  At a minimum, this causes a leak in the quota accounting which
renders the accounting essentially useless as it is.  Shared pages have a one
to one mapping with a hugetlbfs file and are easy to account by debiting on
allocation and crediting on truncate.  Private pages are anonymous in nature
and have a many to one relationship with their hugetlbfs files (due to copy on
write).  Because private pages are not indexed by the mapping's radix tree,
thier quota cannot be credited at file truncation time.  Crediting must be
done when the page is unmapped and freed.

Shared Pages
============

I discovered an issue concerning the interaction between the MAP_SHARED
reservation system and quotas.  Since quota is not checked until page
instantiation, an over-quota mmap/reservation will initially succeed.  When
instantiating the first over-quota page, the program will receive SIGBUS. 
This is inconsistent since the reservation is supposed to be a guarantee.  The
solution is to debit the full amount of quota at reservation time and credit
the unused portion when the reservation is released.

This patch series brings quotas back in line by making the following
modifications:
 * Private pages
   - Debit quota in alloc_huge_page()
   - Credit quota in free_huge_page()
 * Shared pages
   - Debit quota for entire reservation at mmap time
   - Credit quota for instantiated pages in free_huge_page()
   - Credit quota for unused reservation at munmap time



This patch:

The shared page reservation and dynamic pool resizing features have made the
allocation of private vs.  shared huge pages quite different.  By splitting
out the private/shared-specific portions of the process into their own
functions, readability is greatly improved.  alloc_huge_page now calls the
proper helper and performs common operations.

[akpm@linux-foundation.org: coding-style cleanups]
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
+						unsigned long addr)
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
+						unsigned long addr)
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

origin.patch
hugetlb-allow-sticky-directory-mount-option.patch
