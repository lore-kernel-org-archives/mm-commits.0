From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-v2.patch removed from -mm tree
Date: Wed, 24 Jun 2015 16:46:18 -0700
Message-ID: <558b414a.F5pYyQmU8OhWx0sl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbbFXXqT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jun 2015 19:46:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-v2
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-v2.patch

This patch was dropped because it was folded into mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling.patch

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-v2

ChangeLog v1->v2:
- fix function's comment to kernel-doc format
- remove 'inline' directive in get_hwpoison_page() definition
- separate if blocks instead of using else blocks
- add comment about thp refcounting
- add put_page(hpage) in failure path
- clear PageHWPoison if failed to handle thp
- revert the change removing VM_BUG_ON_PAGE() in put_refcounted_compound_pa=
ge()
- revert the change allowing unpoison_memory() to handle thp

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   53 ++++++++++++++++++++++++++++++------------
 mm/swap.c           |    2 +
 2 files changed, 41 insertions(+), 14 deletions(-)

diff -puN mm/memory-failure.c~mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-v2 mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-v2
+++ a/mm/memory-failure.c
@@ -915,17 +915,26 @@ static int page_action(struct page_state
 	return (result == RECOVERED || result == DELAYED) ? 0 : -EBUSY;
 }
 
-/*
- * Get refcount for memory error handling:
- * - @page: raw page
+/**
+ * get_hwpoison_page() - Get refcount for memory error handling:
+ * @page:	raw error page (hit by memory error)
+ *
+ * Return: return 0 if failed to grab the refcount, otherwise true (some
+ * non-zero value.)
  */
-inline int get_hwpoison_page(struct page *page)
+int get_hwpoison_page(struct page *page)
 {
 	struct page *head = compound_head(page);
 
 	if (PageHuge(head))
 		return get_page_unless_zero(head);
-	else if (PageTransHuge(head))
+
+	/*
+	 * Thp tail page has special refcounting rule (refcount of tail pages
+	 * is stored in ->_mapcount,) so we can't call get_page_unless_zero()
+	 * directly for tail pages.
+	 */
+	if (PageTransHuge(head)) {
 		if (get_page_unless_zero(head)) {
 			if (PageTail(page))
 				get_page(page);
@@ -933,8 +942,9 @@ inline int get_hwpoison_page(struct page
 		} else {
 			return 0;
 		}
-	else
-		return get_page_unless_zero(page);
+	}
+
+	return get_page_unless_zero(page);
 }
 
 /*
@@ -1151,12 +1161,20 @@ int memory_failure(unsigned long pfn, in
 	if (!PageHuge(p) && PageTransHuge(hpage)) {
 		if (!PageAnon(hpage)) {
 			pr_err("MCE: %#lx: non anonymous thp\n", pfn);
+			if (TestClearPageHWPoison(p))
+				atomic_long_sub(nr_pages, &num_poisoned_pages);
 			put_page(p);
+			if (p != hpage)
+				put_page(hpage);
 			return -EBUSY;
 		}
 		if (unlikely(split_huge_page(hpage))) {
 			pr_err("MCE: %#lx: thp split failed\n", pfn);
+			if (TestClearPageHWPoison(p))
+				atomic_long_sub(nr_pages, &num_poisoned_pages);
 			put_page(p);
+			if (p != hpage)
+				put_page(hpage);
 			return -EBUSY;
 		}
 		VM_BUG_ON_PAGE(!page_count(p), p);
@@ -1427,10 +1445,17 @@ int unpoison_memory(unsigned long pfn)
 		return 0;
 	}
 
-	if (PageHuge(page))
-		nr_pages = 1 << compound_order(page);
-	else
-		nr_pages = 1;
+	/*
+	 * unpoison_memory() can encounter thp only when the thp is being
+	 * worked by memory_failure() and the page lock is not held yet.
+	 * In such case, we yield to memory_failure() and make unpoison fail.
+	 */
+	if (!PageHuge(page) && PageTransHuge(page)) {
+		pr_info("MCE: Memory failure is now running on %#lx\n", pfn);
+		return 0;
+	}
+
+	nr_pages = 1 << compound_order(page);
 
 	if (!get_hwpoison_page(p)) {
 		/*
@@ -1456,7 +1481,7 @@ int unpoison_memory(unsigned long pfn)
 	 * the PG_hwpoison page will be caught and isolated on the entrance to
 	 * the free buddy page pool.
 	 */
-	if (TestClearPageHWPoison(p)) {
+	if (TestClearPageHWPoison(page)) {
 		pr_info("MCE: Software-unpoisoned page %#lx\n", pfn);
 		atomic_long_sub(nr_pages, &num_poisoned_pages);
 		freeit = 1;
@@ -1465,9 +1490,9 @@ int unpoison_memory(unsigned long pfn)
 	}
 	unlock_page(page);
 
-	put_page(p);
+	put_page(page);
 	if (freeit && !(pfn == my_zero_pfn(0) && page_count(p) == 1))
-		put_page(p);
+		put_page(page);
 
 	return 0;
 }
diff -puN mm/swap.c~mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-v2 mm/swap.c
--- a/mm/swap.c~mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-v2
+++ a/mm/swap.c
@@ -209,6 +209,8 @@ out_put_single:
 		 */
 		if (put_page_testzero(page_head))
 			VM_BUG_ON_PAGE(1, page_head);
+		/* __split_huge_page_refcount will wait now */
+		VM_BUG_ON_PAGE(page_mapcount(page) <= 0, page);
 		atomic_dec(&page->_mapcount);
 		VM_BUG_ON_PAGE(atomic_read(&page_head->_count) <= 0, page_head);
 		VM_BUG_ON_PAGE(atomic_read(&page->_count) != 0, page);
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-hwpoison-add-comment-describing-when-to-add-new-cases.patch
mm-hwpoison-remove-obsolete-notebook-todo-list.patch
mm-memory-failure-split-thp-earlier-in-memory-error-handling.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch
mm-soft-offline-dont-free-target-page-in-successful-page-migration.patch
mm-memory-failure-me_huge_page-does-nothing-for-thp.patch
mm-hugetlb-introduce-minimum-hugepage-order.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages.patch
memory-failure-export-page_type-and-action-result.patch
memory-failure-change-type-of-action_results-param-3-to-enum.patch
tracing-add-trace-event-for-memory-failure.patch
tracing-add-trace-event-for-memory-failure-fix.patch
mm-hugetlb-document-the-reserve-map-region-tracking-routines.patch
mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add.patch
mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages.patch
mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages-v4.patch
mm-memory-hotplug-print-the-last-vmemmap-region-at-the-end-of-hot-add-memory.patch

