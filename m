From: akpm@linux-foundation.org
Subject: [merged]
 mm-hwpoison-replace-most-of-put_page-in-memory-error-handling-by-put_hwpoison_page.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:52:00 -0700
Message-ID: <55f08de0.353BZHguHjt0vQ9Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbbIITxE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:53:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wanpeng.li@hotmail.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: replace most of put_page in memory error handling by put_hwpoison_page
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-replace-most-of-put_page-in-memory-error-handling-by-put_hwpoison_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <wanpeng.li@hotmail.com>
Subject: mm/hwpoison: replace most of put_page in memory error handling by put_hwpoison_page

Replace most instances of put_page() in memory error handling with
put_hwpoison_page().

Signed-off-by: Wanpeng Li <wanpeng.li@hotmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff -puN mm/memory-failure.c~mm-hwpoison-replace-most-of-put_page-in-memory-error-handling-by-put_hwpoison_page mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-replace-most-of-put_page-in-memory-error-handling-by-put_hwpoison_page
+++ a/mm/memory-failure.c
@@ -1174,9 +1174,7 @@ int memory_failure(unsigned long pfn, in
 				pr_err("MCE: %#lx: thp split failed\n", pfn);
 			if (TestClearPageHWPoison(p))
 				atomic_long_sub(nr_pages, &num_poisoned_pages);
-			put_page(p);
-			if (p != hpage)
-				put_page(hpage);
+			put_hwpoison_page(p);
 			return -EBUSY;
 		}
 		VM_BUG_ON_PAGE(!page_count(p), p);
@@ -1237,14 +1235,14 @@ int memory_failure(unsigned long pfn, in
 		printk(KERN_ERR "MCE %#lx: just unpoisoned\n", pfn);
 		atomic_long_sub(nr_pages, &num_poisoned_pages);
 		unlock_page(hpage);
-		put_page(hpage);
+		put_hwpoison_page(hpage);
 		return 0;
 	}
 	if (hwpoison_filter(p)) {
 		if (TestClearPageHWPoison(p))
 			atomic_long_sub(nr_pages, &num_poisoned_pages);
 		unlock_page(hpage);
-		put_page(hpage);
+		put_hwpoison_page(hpage);
 		return 0;
 	}
 
@@ -1258,7 +1256,7 @@ int memory_failure(unsigned long pfn, in
 	if (PageHuge(p) && PageTail(p) && TestSetPageHWPoison(hpage)) {
 		action_result(pfn, MF_MSG_POISONED_HUGE, MF_IGNORED);
 		unlock_page(hpage);
-		put_page(hpage);
+		put_hwpoison_page(hpage);
 		return 0;
 	}
 	/*
@@ -1492,9 +1490,9 @@ int unpoison_memory(unsigned long pfn)
 	}
 	unlock_page(page);
 
-	put_page(page);
+	put_hwpoison_page(page);
 	if (freeit && !(pfn == my_zero_pfn(0) && page_count(p) == 1))
-		put_page(page);
+		put_hwpoison_page(page);
 
 	return 0;
 }
@@ -1554,7 +1552,7 @@ static int get_any_page(struct page *pag
 		/*
 		 * Try to free it.
 		 */
-		put_page(page);
+		put_hwpoison_page(page);
 		shake_page(page, 1);
 
 		/*
@@ -1563,7 +1561,7 @@ static int get_any_page(struct page *pag
 		ret = __get_any_page(page, pfn, 0);
 		if (!PageLRU(page)) {
 			/* Drop page reference which is from __get_any_page() */
-			put_page(page);
+			put_hwpoison_page(page);
 			pr_info("soft_offline: %#lx: unknown non LRU page type %lx\n",
 				pfn, page->flags);
 			return -EIO;
@@ -1586,7 +1584,7 @@ static int soft_offline_huge_page(struct
 	lock_page(hpage);
 	if (PageHWPoison(hpage)) {
 		unlock_page(hpage);
-		put_page(hpage);
+		put_hwpoison_page(hpage);
 		pr_info("soft offline: %#lx hugepage already poisoned\n", pfn);
 		return -EBUSY;
 	}
@@ -1597,7 +1595,7 @@ static int soft_offline_huge_page(struct
 	 * get_any_page() and isolate_huge_page() takes a refcount each,
 	 * so need to drop one here.
 	 */
-	put_page(hpage);
+	put_hwpoison_page(hpage);
 	if (!ret) {
 		pr_info("soft offline: %#lx hugepage failed to isolate\n", pfn);
 		return -EBUSY;
@@ -1646,7 +1644,7 @@ static int __soft_offline_page(struct pa
 	wait_on_page_writeback(page);
 	if (PageHWPoison(page)) {
 		unlock_page(page);
-		put_page(page);
+		put_hwpoison_page(page);
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
 		return -EBUSY;
 	}
@@ -1661,7 +1659,7 @@ static int __soft_offline_page(struct pa
 	 * would need to fix isolation locking first.
 	 */
 	if (ret == 1) {
-		put_page(page);
+		put_hwpoison_page(page);
 		pr_info("soft_offline: %#lx: invalidated\n", pfn);
 		SetPageHWPoison(page);
 		atomic_long_inc(&num_poisoned_pages);
@@ -1678,7 +1676,7 @@ static int __soft_offline_page(struct pa
 	 * Drop page reference which is came from get_any_page()
 	 * successful isolate_lru_page() already took another one.
 	 */
-	put_page(page);
+	put_hwpoison_page(page);
 	if (!ret) {
 		LIST_HEAD(pagelist);
 		inc_zone_page_state(page, NR_ISOLATED_ANON +
@@ -1741,7 +1739,7 @@ int soft_offline_page(struct page *page,
 	if (PageHWPoison(page)) {
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
 		if (flags & MF_COUNT_INCREASED)
-			put_page(page);
+			put_hwpoison_page(page);
 		return -EBUSY;
 	}
 	if (!PageHuge(page) && PageTransHuge(hpage)) {
@@ -1749,7 +1747,7 @@ int soft_offline_page(struct page *page,
 			pr_info("soft offline: %#lx: failed to split THP\n",
 				pfn);
 			if (flags & MF_COUNT_INCREASED)
-				put_page(page);
+				put_hwpoison_page(page);
 			return -EBUSY;
 		}
 	}
_

Patches currently in -mm which might be from wanpeng.li@hotmail.com are


