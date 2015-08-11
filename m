From: akpm@linux-foundation.org
Subject: +
 mm-hwpoison-replace-most-of-put_page-in-memory-error-handling-by-put_hwpoison_page.patch added to -mm tree
Date: Tue, 11 Aug 2015 16:26:12 -0700
Message-ID: <55ca8494.uQH4qvgvIe3oViiu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38326 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715AbbHKX0N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Aug 2015 19:26:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wanpeng.li@hotmail.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: replace most of put_page in memory error handling by put_hwpoison_page
has been added to the -mm tree.  Its filename is
     mm-hwpoison-replace-most-of-put_page-in-memory-error-handling-by-put_hwpoison_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-replace-most-of-put_page-in-memory-error-handling-by-put_hwpoison_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-replace-most-of-put_page-in-memory-error-handling-by-put_hwpoison_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wanpeng Li <wanpeng.li@hotmail.com>
Subject: mm/hwpoison: replace most of put_page in memory error handling by put_hwpoison_page

Replace most of put_page in memory error handling by put_hwpoison_page,
except the ones at the front of soft_offline_page since the page maybe THP
page and the get refcount in madvise_hwpoison is against the single 4KB
page instead of the logic in get_hwpoison_page.

Signed-off-by: Wanpeng Li <wanpeng.li@hotmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff -puN mm/memory-failure.c~mm-hwpoison-replace-most-of-put_page-in-memory-error-handling-by-put_hwpoison_page mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-replace-most-of-put_page-in-memory-error-handling-by-put_hwpoison_page
+++ a/mm/memory-failure.c
@@ -1173,9 +1173,7 @@ int memory_failure(unsigned long pfn, in
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
@@ -1236,14 +1234,14 @@ int memory_failure(unsigned long pfn, in
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
 
@@ -1257,7 +1255,7 @@ int memory_failure(unsigned long pfn, in
 	if (PageHuge(p) && PageTail(p) && TestSetPageHWPoison(hpage)) {
 		action_result(pfn, MF_MSG_POISONED_HUGE, MF_IGNORED);
 		unlock_page(hpage);
-		put_page(hpage);
+		put_hwpoison_page(hpage);
 		return 0;
 	}
 	/*
@@ -1491,9 +1489,9 @@ int unpoison_memory(unsigned long pfn)
 	}
 	unlock_page(page);
 
-	put_page(page);
+	put_hwpoison_page(page);
 	if (freeit && !(pfn == my_zero_pfn(0) && page_count(p) == 1))
-		put_page(page);
+		put_hwpoison_page(page);
 
 	return 0;
 }
@@ -1553,7 +1551,7 @@ static int get_any_page(struct page *pag
 		/*
 		 * Try to free it.
 		 */
-		put_page(page);
+		put_hwpoison_page(page);
 		shake_page(page, 1);
 
 		/*
@@ -1562,7 +1560,7 @@ static int get_any_page(struct page *pag
 		ret = __get_any_page(page, pfn, 0);
 		if (!PageLRU(page)) {
 			/* Drop page reference which is from __get_any_page() */
-			put_page(page);
+			put_hwpoison_page(page);
 			pr_info("soft_offline: %#lx: unknown non LRU page type %lx\n",
 				pfn, page->flags);
 			return -EIO;
@@ -1585,7 +1583,7 @@ static int soft_offline_huge_page(struct
 	lock_page(hpage);
 	if (PageHWPoison(hpage)) {
 		unlock_page(hpage);
-		put_page(hpage);
+		put_hwpoison_page(hpage);
 		pr_info("soft offline: %#lx hugepage already poisoned\n", pfn);
 		return -EBUSY;
 	}
@@ -1596,7 +1594,7 @@ static int soft_offline_huge_page(struct
 	 * get_any_page() and isolate_huge_page() takes a refcount each,
 	 * so need to drop one here.
 	 */
-	put_page(hpage);
+	put_hwpoison_page(hpage);
 	if (!ret) {
 		pr_info("soft offline: %#lx hugepage failed to isolate\n", pfn);
 		return -EBUSY;
@@ -1645,7 +1643,7 @@ static int __soft_offline_page(struct pa
 	wait_on_page_writeback(page);
 	if (PageHWPoison(page)) {
 		unlock_page(page);
-		put_page(page);
+		put_hwpoison_page(page);
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
 		return -EBUSY;
 	}
@@ -1660,7 +1658,7 @@ static int __soft_offline_page(struct pa
 	 * would need to fix isolation locking first.
 	 */
 	if (ret == 1) {
-		put_page(page);
+		put_hwpoison_page(page);
 		pr_info("soft_offline: %#lx: invalidated\n", pfn);
 		SetPageHWPoison(page);
 		atomic_long_inc(&num_poisoned_pages);
@@ -1677,7 +1675,7 @@ static int __soft_offline_page(struct pa
 	 * Drop page reference which is came from get_any_page()
 	 * successful isolate_lru_page() already took another one.
 	 */
-	put_page(page);
+	put_hwpoison_page(page);
 	if (!ret) {
 		LIST_HEAD(pagelist);
 		inc_zone_page_state(page, NR_ISOLATED_ANON +
_

Patches currently in -mm which might be from wanpeng.li@hotmail.com are

mm-hwpoison-fix-page-refcount-of-unkown-non-lru-page.patch
mm-hwpoison-fix-fail-isolate-hugetlbfs-page-w-refcount-held.patch
mm-hwpoison-fix-panic-due-to-split-huge-zero-page.patch
mm-hwpoison-fix-fail-to-split-thp-w-refcount-held.patch
mm-hwpoison-fix-pagehwpoison-test-set-race.patch
mm-hwpoison-introduce-put_hwpoison_page-to-put-refcount-for-memory-error-handling.patch
mm-hwpoison-introduce-put_hwpoison_page-to-put-refcount-for-memory-error-handling-fix.patch
mm-hwpoison-fix-refcount-of-thp-head-page-in-no-injection-case.patch
mm-hwpoison-replace-most-of-put_page-in-memory-error-handling-by-put_hwpoison_page.patch

