From: akpm@linux-foundation.org
Subject: + hugetlbfs-new-huge_add_to_page_cache-helper-routine.patch added to -mm tree
Date: Wed, 22 Jul 2015 15:07:34 -0700
Message-ID: <55b01426.9+b5v2x2VSJ99Z7j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbbGVWHg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jul 2015 18:07:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, aneesh.kumar@linux.vnet.ibm.com, dave.hansen@linux.intel.com, dave@stgolabs.net, hch@infradead.org, hillf.zj@alibaba-inc.com, hughd@google.com, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: New huge_add_to_page_cache helper routine
has been added to the -mm tree.  Its filename is
     hugetlbfs-new-huge_add_to_page_cache-helper-routine.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlbfs-new-huge_add_to_page_cache-helper-routine.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlbfs-new-huge_add_to_page_cache-helper-routine.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlbfs: New huge_add_to_page_cache helper routine

Currently, there is only a single place where hugetlbfs pages are added to
the page cache.  The new fallocate code be adding a second one, so break
the functionality out into its own helper.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 ++
 mm/hugetlb.c            |   27 ++++++++++++++++++---------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff -puN include/linux/hugetlb.h~hugetlbfs-new-huge_add_to_page_cache-helper-routine include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlbfs-new-huge_add_to_page_cache-helper-routine
+++ a/include/linux/hugetlb.h
@@ -333,6 +333,8 @@ struct huge_bootmem_page {
 struct page *alloc_huge_page_node(struct hstate *h, int nid);
 struct page *alloc_huge_page_noerr(struct vm_area_struct *vma,
 				unsigned long addr, int avoid_reserve);
+int huge_add_to_page_cache(struct page *page, struct address_space *mapping,
+			pgoff_t idx);
 
 /* arch callback */
 int __init alloc_bootmem_huge_page(struct hstate *h);
diff -puN mm/hugetlb.c~hugetlbfs-new-huge_add_to_page_cache-helper-routine mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlbfs-new-huge_add_to_page_cache-helper-routine
+++ a/mm/hugetlb.c
@@ -3375,6 +3375,23 @@ static bool hugetlbfs_pagecache_present(
 	return page != NULL;
 }
 
+int huge_add_to_page_cache(struct page *page, struct address_space *mapping,
+			   pgoff_t idx)
+{
+	struct inode *inode = mapping->host;
+	struct hstate *h = hstate_inode(inode);
+	int err = add_to_page_cache(page, mapping, idx, GFP_KERNEL);
+
+	if (err)
+		return err;
+	ClearPagePrivate(page);
+
+	spin_lock(&inode->i_lock);
+	inode->i_blocks += blocks_per_huge_page(h);
+	spin_unlock(&inode->i_lock);
+	return 0;
+}
+
 static int hugetlb_no_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			   struct address_space *mapping, pgoff_t idx,
 			   unsigned long address, pte_t *ptep, unsigned int flags)
@@ -3422,21 +3439,13 @@ retry:
 		set_page_huge_active(page);
 
 		if (vma->vm_flags & VM_MAYSHARE) {
-			int err;
-			struct inode *inode = mapping->host;
-
-			err = add_to_page_cache(page, mapping, idx, GFP_KERNEL);
+			int err = huge_add_to_page_cache(page, mapping, idx);
 			if (err) {
 				put_page(page);
 				if (err == -EEXIST)
 					goto retry;
 				goto out;
 			}
-			ClearPagePrivate(page);
