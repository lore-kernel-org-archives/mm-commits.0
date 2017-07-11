From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-delete-dequeue_hwpoisoned_huge_page.patch removed from -mm tree
Date: Tue, 11 Jul 2017 12:23:13 -0700
Message-ID: <20170711192313.TGkx0YyM5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47572 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933570AbdGKTXO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:23:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com


The patch titled
     Subject: mm: hugetlb: delete dequeue_hwpoisoned_huge_page()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-delete-dequeue_hwpoisoned_huge_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: hugetlb: delete dequeue_hwpoisoned_huge_page()

dequeue_hwpoisoned_huge_page() is no longer used, so let's remove it.

Link: http://lkml.kernel.org/r/1496305019-5493-9-git-send-email-n-horiguchi@ah.jp.nec.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    5 -----
 mm/hugetlb.c            |   34 ----------------------------------
 mm/memory-failure.c     |   11 -----------
 3 files changed, 50 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-delete-dequeue_hwpoisoned_huge_page include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-delete-dequeue_hwpoisoned_huge_page
+++ a/include/linux/hugetlb.h
@@ -116,7 +116,6 @@ int hugetlb_reserve_pages(struct inode *
 						vm_flags_t vm_flags);
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 						long freed);
-int dequeue_hwpoisoned_huge_page(struct page *page);
 bool isolate_huge_page(struct page *page, struct list_head *list);
 void putback_active_hugepage(struct page *page);
 void free_huge_page(struct page *page);
@@ -192,10 +191,6 @@ static inline void hugetlb_show_meminfo(
 #define hugetlb_mcopy_atomic_pte(dst_mm, dst_pte, dst_vma, dst_addr, \
 				src_addr, pagep)	({ BUG(); 0; })
 #define huge_pte_offset(mm, address, sz)	0
-static inline int dequeue_hwpoisoned_huge_page(struct page *page)
-{
-	return 0;
-}
 
 static inline bool isolate_huge_page(struct page *page, struct list_head *list)
 {
diff -puN mm/hugetlb.c~mm-hugetlb-delete-dequeue_hwpoisoned_huge_page mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-delete-dequeue_hwpoisoned_huge_page
+++ a/mm/hugetlb.c
@@ -4746,40 +4746,6 @@ follow_huge_pgd(struct mm_struct *mm, un
 	return pte_page(*(pte_t *)pgd) + ((address & ~PGDIR_MASK) >> PAGE_SHIFT);
 }
 
-#ifdef CONFIG_MEMORY_FAILURE
-
-/*
- * This function is called from memory failure code.
- */
-int dequeue_hwpoisoned_huge_page(struct page *hpage)
-{
-	struct hstate *h = page_hstate(hpage);
-	int nid = page_to_nid(hpage);
-	int ret = -EBUSY;
-
-	spin_lock(&hugetlb_lock);
-	/*
-	 * Just checking !page_huge_active is not enough, because that could be
-	 * an isolated/hwpoisoned hugepage (which have >0 refcount).
-	 */
-	if (!page_huge_active(hpage) && !page_count(hpage)) {
-		/*
-		 * Hwpoisoned hugepage isn't linked to activelist or freelist,
-		 * but dangling hpage->lru can trigger list-debug warnings
-		 * (this happens when we call unpoison_memory() on it),
-		 * so let it point to itself with list_del_init().
-		 */
-		list_del_init(&hpage->lru);
-		set_page_refcounted(hpage);
-		h->free_huge_pages--;
-		h->free_huge_pages_node[nid]--;
-		ret = 0;
-	}
-	spin_unlock(&hugetlb_lock);
-	return ret;
-}
-#endif
-
 bool isolate_huge_page(struct page *page, struct list_head *list)
 {
 	bool ret = true;
diff -puN mm/memory-failure.c~mm-hugetlb-delete-dequeue_hwpoisoned_huge_page mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hugetlb-delete-dequeue_hwpoisoned_huge_page
+++ a/mm/memory-failure.c
@@ -1458,17 +1458,6 @@ int unpoison_memory(unsigned long pfn)
 	}
 
 	if (!get_hwpoison_page(p)) {
-		/*
-		 * Since HWPoisoned hugepage should have non-zero refcount,
-		 * race between memory failure and unpoison seems to happen.
-		 * In such case unpoison fails and memory failure runs
-		 * to the end.
-		 */
-		if (PageHuge(page)) {
-			unpoison_pr_info("Unpoison: Memory failure is now running on free hugepage %#lx\n",
-					 pfn, &unpoison_rs);
-			return 0;
-		}
 		if (TestClearPageHWPoison(p))
 			num_poisoned_pages_dec();
 		unpoison_pr_info("Unpoison: Software-unpoisoned free page %#lx\n",
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are


