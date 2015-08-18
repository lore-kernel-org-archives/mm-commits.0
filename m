From: akpm@linux-foundation.org
Subject: [merged]
 mm-hwpoison-fix-fail-isolate-hugetlbfs-page-w-refcount-held.patch removed
 from -mm tree
Date: Tue, 18 Aug 2015 12:42:20 -0700
Message-ID: <55d38a9c.5M7wAI60u/UeDsbC%akpm__34857.2638271891$1439926952$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbbHRTmU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Aug 2015 15:42:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wanpeng.li@hotmail.com, n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: fix fail isolate hugetlbfs page w/ refcount held
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-fix-fail-isolate-hugetlbfs-page-w-refcount-held.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <wanpeng.li@hotmail.com>
Subject: mm/hwpoison: fix fail isolate hugetlbfs page w/ refcount held

Hugetlbfs pages will get a refcount in get_any_page() or
madvise_hwpoison() if soft offlining through madvise.  The refcount which
is held by the soft offline path should be released if we fail to isolate
hugetlbfs pages.

Fix it by reducing the refcount for both isolation success and failure.

Signed-off-by: Wanpeng Li <wanpeng.li@hotmail.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>	[3.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN mm/memory-failure.c~mm-hwpoison-fix-fail-isolate-hugetlbfs-page-w-refcount-held mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-fix-fail-isolate-hugetlbfs-page-w-refcount-held
+++ a/mm/memory-failure.c
@@ -1569,13 +1569,12 @@ static int soft_offline_huge_page(struct
 	unlock_page(hpage);
 
 	ret = isolate_huge_page(hpage, &pagelist);
-	if (ret) {
-		/*
-		 * get_any_page() and isolate_huge_page() takes a refcount each,
-		 * so need to drop one here.
-		 */
-		put_page(hpage);
-	} else {
+	/*
+	 * get_any_page() and isolate_huge_page() takes a refcount each,
+	 * so need to drop one here.
+	 */
+	put_page(hpage);
+	if (!ret) {
 		pr_info("soft offline: %#lx hugepage failed to isolate\n", pfn);
 		return -EBUSY;
 	}
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

