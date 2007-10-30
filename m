From: akpm@linux-foundation.org
Subject: + hugetlb-fix-quota-management-for-private-mappings.patch added to -mm tree
Date: Tue, 30 Oct 2007 16:22:27 -0700
Message-ID: <200710302322.l9UNMR9P000785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34337 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753485AbXJ3XXr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 19:23:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agl@us.ibm.com, apw@shadowen.org, haveblue@us.ibm.com, hermes@gibson.dropbear.id.au, kenchen@google.com, wli@holomorphy.com


The patch titled
     hugetlb: fix quota management for private mappings
has been added to the -mm tree.  Its filename is
     hugetlb-fix-quota-management-for-private-mappings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hugetlb: fix quota management for private mappings
From: Adam Litke <agl@us.ibm.com>

The hugetlbfs quota management system was never taught to handle MAP_PRIVATE
mappings when that support was added.  Currently, quota is debited at page
instantiation and credited at file truncation.  This approach works correctly
for shared pages but is incomplete for private pages.  In addition to
hugetlb_no_page(), private pages can be instantiated by hugetlb_cow(); but
this function does not respect quotas.

Private huge pages are treated very much like normal, anonymous pages.  They
are not "backed" by the hugetlbfs file and are not stored in the mapping's
radix tree.  This means that private pages are invisible to
truncate_hugepages() so that function will not credit the quota.

This patch (based on a prototype provided by Ken Chen) moves quota crediting
for all pages into free_huge_page().  page->private is used to store a pointer
to the mapping to which this page belongs.  This is used to credit quota on
the appropriate hugetlbfs instance.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Cc: Ken Chen <kenchen@google.com>
Cc: Ken Chen <kenchen@google.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: David Gibson <hermes@gibson.dropbear.id.au>
Cc: William Lee Irwin III <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    1 -
 mm/hugetlb.c         |   13 ++++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlb-fix-quota-management-for-private-mappings fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlb-fix-quota-management-for-private-mappings
+++ a/fs/hugetlbfs/inode.c
@@ -364,7 +364,6 @@ static void truncate_hugepages(struct in
 			++next;
 			truncate_huge_page(page);
 			unlock_page(page);
-			hugetlb_put_quota(mapping);
 			freed++;
 		}
 		huge_pagevec_release(&pvec);
diff -puN mm/hugetlb.c~hugetlb-fix-quota-management-for-private-mappings mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-quota-management-for-private-mappings
+++ a/mm/hugetlb.c
@@ -116,7 +116,9 @@ static void update_and_free_page(struct 
 static void free_huge_page(struct page *page)
 {
 	int nid = page_to_nid(page);
+	struct address_space *mapping;
 
+	mapping = (struct address_space *) page_private(page);
 	BUG_ON(page_count(page));
 	INIT_LIST_HEAD(&page->lru);
 
@@ -129,6 +131,9 @@ static void free_huge_page(struct page *
 		enqueue_huge_page(page);
 	}
 	spin_unlock(&hugetlb_lock);
+	if (mapping)
+		hugetlb_put_quota(mapping);
+	set_page_private(page, 0);
 }
 
 /*
@@ -388,8 +393,10 @@ static struct page *alloc_huge_page(stru
 		page = alloc_huge_page_shared(vma, addr);
 	else
 		page = alloc_huge_page_private(vma, addr);
-	if (page)
+	if (page) {
 		set_page_refcounted(page);
+		set_page_private(page, (unsigned long) vma->vm_file->f_mapping);
+	}
 	return page;
 }
 
@@ -730,6 +737,8 @@ static int hugetlb_cow(struct mm_struct 
 		set_huge_ptep_writable(vma, address, ptep);
 		return 0;
 	}
+	if (hugetlb_get_quota(vma->vm_file->f_mapping))
+		return VM_FAULT_SIGBUS;
 
 	page_cache_get(old_page);
 	new_page = alloc_huge_page(vma, address);
@@ -796,7 +805,6 @@ retry:
 			err = add_to_page_cache(page, mapping, idx, GFP_KERNEL);
 			if (err) {
 				put_page(page);
-				hugetlb_put_quota(mapping);
 				if (err == -EEXIST)
 					goto retry;
 				goto out;
@@ -830,7 +838,6 @@ out:
 
 backout:
 	spin_unlock(&mm->page_table_lock);
-	hugetlb_put_quota(mapping);
 	unlock_page(page);
 	put_page(page);
 	goto out;
_

Patches currently in -mm which might be from agl@us.ibm.com are

hugetlb-allow-sticky-directory-mount-option.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
hugetlb-fix-quota-management-for-private-mappings.patch
hugetlb-debit-quota-in-alloc_huge_page.patch
hugetlb-allow-bulk-updating-in-hugetlb__quota.patch
hugetlb-enforce-quotas-during-reservation-for-shared-mappings.patch
