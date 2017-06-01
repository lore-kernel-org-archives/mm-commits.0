From: akpm@linux-foundation.org
Subject: + mm-hugetlb-delete-dequeue_hwpoisoned_huge_page.patch added to
 -mm tree
Date: Thu, 01 Jun 2017 15:38:11 -0700
Message-ID: <59309753.Z6iXYP0tNSA0bb/Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41716 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751141AbdFAWiM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2017 18:38:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: delete dequeue_hwpoisoned_huge_page()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-delete-dequeue_hwpoisoned_huge_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-delete-dequeue_hwpoisoned_huge_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-delete-dequeue_hwpoisoned_huge_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-drop-null-return-check-of-pte_offset_map_lock.patch
mm-hugetlb-prevent-reuse-of-hwpoisoned-free-hugepages.patch
mm-hugetlb-return-immediately-for-hugetlb-page-in-__delete_from_page_cache.patch
mm-hwpoison-change-pagehwpoison-behavior-on-hugetlb-pages.patch
mm-soft-offline-dissolve-free-hugepage-if-soft-offlined.patch
mm-hwpoison-introduce-memory_failure_hugetlb.patch
mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error.patch
mm-hugetlb-delete-dequeue_hwpoisoned_huge_page.patch
mm-hwpoison-introduce-idenfity_page_state.patch

