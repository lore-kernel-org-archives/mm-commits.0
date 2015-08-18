From: akpm@linux-foundation.org
Subject: [merged]
 mm-hwpoison-fix-page-refcount-of-unkown-non-lru-page.patch removed from -mm tree
Date: Tue, 18 Aug 2015 12:42:17 -0700
Message-ID: <55d38a99.ML69zwGK3um1m20U%akpm__2339.1442293816$1439926949$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbbHRTmS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Aug 2015 15:42:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wanpeng.li@hotmail.com, n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: fix page refcount of unknown non LRU page
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-fix-page-refcount-of-unkown-non-lru-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <wanpeng.li@hotmail.com>
Subject: mm/hwpoison: fix page refcount of unknown non LRU page

After trying to drain pages from pagevec/pageset, we try to get reference
count of the page again, however, the reference count of the page is not
reduced if the page is still not on LRU list.

Fix it by adding the put_page() to drop the page reference which is from
__get_any_page().

Signed-off-by: Wanpeng Li <wanpeng.li@hotmail.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>	[3.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/memory-failure.c~mm-hwpoison-fix-page-refcount-of-unkown-non-lru-page mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-fix-page-refcount-of-unkown-non-lru-page
+++ a/mm/memory-failure.c
@@ -1538,6 +1538,8 @@ static int get_any_page(struct page *pag
 		 */
 		ret = __get_any_page(page, pfn, 0);
 		if (!PageLRU(page)) {
+			/* Drop page reference which is from __get_any_page() */
+			put_page(page);
 			pr_info("soft_offline: %#lx: unknown non LRU page type %lx\n",
 				pfn, page->flags);
 			return -EIO;
_

Patches currently in -mm which might be from wanpeng.li@hotmail.com are

mm-hwpoison-fix-fail-to-split-thp-w-refcount-held.patch
mm-hwpoison-fix-pagehwpoison-test-set-race.patch
mm-hwpoison-introduce-put_hwpoison_page-to-put-refcount-for-memory-error-handling.patch
mm-hwpoison-fix-refcount-of-thp-head-page-in-no-injection-case.patch
mm-hwpoison-replace-most-of-put_page-in-memory-error-handling-by-put_hwpoison_page.patch
mm-hwpoison-replace-most-of-put_page-in-memory-error-handling-by-put_hwpoison_page-fix.patch
mm-hwpoison-introduce-num_poisoned_pages-wrappers.patch
mm-hwpoison-fix-race-between-soft_offline_page-and-unpoison_memory.patch
mm-hwpoison-dont-try-to-unpoison-containment-failed-pages.patch

