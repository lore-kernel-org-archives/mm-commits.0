From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hwpoison-replace-most-of-put_page-in-memory-error-handling-by-put_hwpoison_page-fix.patch removed from -mm tree
Date: Tue, 08 Sep 2015 14:44:40 -0700
Message-ID: <55ef56c8.npFdn3y1aTz0QECE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbbIHVom (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 17:44:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wanpeng.li@hotmail.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: replace most of put_page in memory error handling by put_hwpoison_page fix
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-replace-most-of-put_page-in-memory-error-handling-by-put_hwpoison_page-fix.patch

This patch was dropped because it was folded into mm-hwpoison-replace-most-of-put_page-in-memory-error-handling-by-put_hwpoison_page.patch

------------------------------------------------------
From: Wanpeng Li <wanpeng.li@hotmail.com>
Subject: mm/hwpoison: replace most of put_page in memory error handling by put_hwpoison_page fix

Signed-off-by: Wanpeng Li <wanpeng.li@hotmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory-failure.c~mm-hwpoison-replace-most-of-put_page-in-memory-error-handling-by-put_hwpoison_page-fix mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-replace-most-of-put_page-in-memory-error-handling-by-put_hwpoison_page-fix
+++ a/mm/memory-failure.c
@@ -1739,7 +1739,7 @@ int soft_offline_page(struct page *page,
 	if (PageHWPoison(page)) {
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
 		if (flags & MF_COUNT_INCREASED)
-			put_page(page);
+			put_hwpoison_page(page);
 		return -EBUSY;
 	}
 	if (!PageHuge(page) && PageTransHuge(hpage)) {
@@ -1747,7 +1747,7 @@ int soft_offline_page(struct page *page,
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

mm-hwpoison-fix-fail-to-split-thp-w-refcount-held.patch
mm-hwpoison-fix-pagehwpoison-test-set-race.patch
mm-hwpoison-introduce-put_hwpoison_page-to-put-refcount-for-memory-error-handling.patch
mm-hwpoison-fix-refcount-of-thp-head-page-in-no-injection-case.patch
mm-hwpoison-replace-most-of-put_page-in-memory-error-handling-by-put_hwpoison_page.patch
mm-hwpoison-fix-race-between-soft_offline_page-and-unpoison_memory.patch

