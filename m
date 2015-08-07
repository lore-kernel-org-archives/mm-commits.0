From: akpm@linux-foundation.org
Subject: + mm-hwpoison-fix-page-refcount-of-unkown-non-lru-page.patch
 added to -mm tree
Date: Fri, 07 Aug 2015 14:58:09 -0700
Message-ID: <55c529f1.LMlK2We2Kz24y3Vo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946332AbbHGV6K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2015 17:58:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wanpeng.li@hotmail.com, n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: fix page refcount of unkown non LRU page
has been added to the -mm tree.  Its filename is
     mm-hwpoison-fix-page-refcount-of-unkown-non-lru-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-fix-page-refcount-of-unkown-non-lru-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-fix-page-refcount-of-unkown-non-lru-page.patch

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
Subject: mm/hwpoison: fix page refcount of unkown non LRU page

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

mm-hwpoison-fix-page-refcount-of-unkown-non-lru-page.patch

