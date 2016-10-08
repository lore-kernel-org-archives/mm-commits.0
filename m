From: akpm@linux-foundation.org
Subject: [patch 103/127] mm: remove unnecessary condition in
 remove_inode_hugepages
Date: Fri, 07 Oct 2016 17:02:01 -0700
Message-ID: <57f83779.WbN1wf2XXMZZ7UKx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39529 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932840AbcJHACC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:02:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, zhongjiang@huawei.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com

From: zhong jiang <zhongjiang@huawei.com>
Subject: mm: remove unnecessary condition in remove_inode_hugepages

When the huge page is added to the page cahce (huge_add_to_page_cache),
the page private flag will be cleared.  since this code
(remove_inode_hugepages) will only be called for pages in the page cahce,
PagePrivate(page) will always be false.

The patch remove the code without any functional change.

Link: http://lkml.kernel.org/r/1475113323-29368-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Tested-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |   12 +++++-------
 include/linux/hugetlb.h |    2 +-
 mm/hugetlb.c            |    4 ++--
 3 files changed, 8 insertions(+), 10 deletions(-)

diff -puN fs/hugetlbfs/inode.c~mm-remove-unnecessary-condition-in-remove_inode_hugepages fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-remove-unnecessary-condition-in-remove_inode_hugepages
+++ a/fs/hugetlbfs/inode.c
@@ -416,7 +416,6 @@ static void remove_inode_hugepages(struc
 
 		for (i = 0; i < pagevec_count(&pvec); ++i) {
 			struct page *page = pvec.pages[i];
-			bool rsv_on_error;
 			u32 hash;
 
 			/*
@@ -458,18 +457,17 @@ static void remove_inode_hugepages(struc
 			 * cache (remove_huge_page) BEFORE removing the
 			 * region/reserve map (hugetlb_unreserve_pages).  In
 			 * rare out of memory conditions, removal of the
-			 * region/reserve map could fail.  Before free'ing
-			 * the page, note PagePrivate which is used in case
-			 * of error.
+			 * region/reserve map could fail. Correspondingly,
+			 * the subpool and global reserve usage count can need
+			 * to be adjusted.
 			 */
-			rsv_on_error = !PagePrivate(page);
+			VM_BUG_ON(PagePrivate(page));
 			remove_huge_page(page);
 			freed++;
 			if (!truncate_op) {
 				if (unlikely(hugetlb_unreserve_pages(inode,
 							next, next + 1, 1)))
-					hugetlb_fix_reserve_counts(inode,
-								rsv_on_error);
+					hugetlb_fix_reserve_counts(inode);
 			}
 
 			unlock_page(page);
diff -puN include/linux/hugetlb.h~mm-remove-unnecessary-condition-in-remove_inode_hugepages include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-remove-unnecessary-condition-in-remove_inode_hugepages
+++ a/include/linux/hugetlb.h
@@ -90,7 +90,7 @@ int dequeue_hwpoisoned_huge_page(struct
 bool isolate_huge_page(struct page *page, struct list_head *list);
 void putback_active_hugepage(struct page *page);
 void free_huge_page(struct page *page);
-void hugetlb_fix_reserve_counts(struct inode *inode, bool restore_reserve);
+void hugetlb_fix_reserve_counts(struct inode *inode);
 extern struct mutex *hugetlb_fault_mutex_table;
 u32 hugetlb_fault_mutex_hash(struct hstate *h, struct mm_struct *mm,
 				struct vm_area_struct *vma,
diff -puN mm/hugetlb.c~mm-remove-unnecessary-condition-in-remove_inode_hugepages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-remove-unnecessary-condition-in-remove_inode_hugepages
+++ a/mm/hugetlb.c
@@ -567,13 +567,13 @@ retry:
  * appear as a "reserved" entry instead of simply dangling with incorrect
  * counts.
  */
-void hugetlb_fix_reserve_counts(struct inode *inode, bool restore_reserve)
+void hugetlb_fix_reserve_counts(struct inode *inode)
 {
 	struct hugepage_subpool *spool = subpool_inode(inode);
 	long rsv_adjust;
 
 	rsv_adjust = hugepage_subpool_get_pages(spool, 1);
-	if (restore_reserve && rsv_adjust) {
+	if (rsv_adjust) {
 		struct hstate *h = hstate_inode(inode);
 
 		hugetlb_acct_memory(h, 1);
_
