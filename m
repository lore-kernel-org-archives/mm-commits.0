From: akpm@linux-foundation.org
Subject: +
 mm-hwpoison-fix-fail-isolate-hugetlbfs-page-w-refcount-held.patch added to
 -mm tree
Date: Fri, 07 Aug 2015 15:02:46 -0700
Message-ID: <55c52b06.e56yBhABUh5A9a1H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946270AbbHGWCr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2015 18:02:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wanpeng.li@hotmail.com, n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: fix fail isolate hugetlbfs page w/ refcount held
has been added to the -mm tree.  Its filename is
     mm-hwpoison-fix-fail-isolate-hugetlbfs-page-w-refcount-held.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-fix-fail-isolate-hugetlbfs-page-w-refcount-held.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-fix-fail-isolate-hugetlbfs-page-w-refcount-held.patch

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
Subject: mm/hwpoison: fix fail isolate hugetlbfs page w/ refcount held

Hugetlbfs pages will get a refcount in get_any_page() or
madvise_hwpoison() if soft offlining through madvise.  The refcount which
is held by the soft offline path should be released if we fail to isolate
hugetlbfs pages.

Fix it by reducing the refcount for both isolation success and failure.

Signed-off-by: Wanpeng Li <wanpeng.li@hotmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
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

mm-hwpoison-fix-page-refcount-of-unkown-non-lru-page.patch
mm-hwpoison-fix-fail-isolate-hugetlbfs-page-w-refcount-held.patch

