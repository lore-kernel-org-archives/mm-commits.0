From: akpm@linux-foundation.org
Subject: +
 mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-v2.patch added to -mm tree
Date: Thu, 14 May 2015 14:06:48 -0700
Message-ID: <55550e68.8giNtbfJTnvJH1PD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48761 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422731AbbENVGt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 May 2015 17:06:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-v2
has been added to the -mm tree.  Its filename is
     mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-v2.patch

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
@@ -885,17 +885,26 @@ static int page_action(struct page_state
 	return (result == MF_RECOVERED || result == MF_DELAYED) ? 0 : -EBUSY;
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
@@ -903,8 +912,9 @@ inline int get_hwpoison_page(struct page
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
@@ -1121,12 +1131,20 @@ int memory_failure(unsigned long pfn, in
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
@@ -1397,10 +1415,17 @@ int unpoison_memory(unsigned long pfn)
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
@@ -1426,7 +1451,7 @@ int unpoison_memory(unsigned long pfn)
 	 * the PG_hwpoison page will be caught and isolated on the entrance to
 	 * the free buddy page pool.
 	 */
-	if (TestClearPageHWPoison(p)) {
+	if (TestClearPageHWPoison(page)) {
 		pr_info("MCE: Software-unpoisoned page %#lx\n", pfn);
 		atomic_long_sub(nr_pages, &num_poisoned_pages);
 		freeit = 1;
@@ -1435,9 +1460,9 @@ int unpoison_memory(unsigned long pfn)
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

tools-vm-fix-page-flags-build.patch
mm-hwpoison-add-comment-describing-when-to-add-new-cases.patch
mm-hwpoison-remove-obsolete-notebook-todo-list.patch
memory-failure-export-page_type-and-action-result.patch
memory-failure-change-type-of-action_results-param-3-to-enum.patch
tracing-add-trace-event-for-memory-failure.patch
mm-memory-failure-split-thp-earlier-in-memory-error-handling.patch
mm-memory-failure-split-thp-earlier-in-memory-error-handling-v2.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-v2.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch
mm-soft-offline-dont-free-target-page-in-successful-page-migration.patch
mm-memory-failure-me_huge_page-does-nothing-for-thp.patch
mm-hugetlb-initialize-order-with-uint_max-in-dissolve_free_huge_pages.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

