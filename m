From: akpm@linux-foundation.org
Subject: + mm-update-the-comment-in-__isolate_free_page.patch added to -mm tree
Date: Wed, 22 Jun 2016 15:03:18 -0700
Message-ID: <576b0b26.fQR+R3v5u26kte9+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45487 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbcFVWDT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jun 2016 18:03:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: update the comment in __isolate_free_page
has been added to the -mm tree.  Its filename is
     mm-update-the-comment-in-__isolate_free_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-update-the-comment-in-__isolate_free_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-update-the-comment-in-__isolate_free_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: zhong jiang <zhongjiang@huawei.com>
Subject: mm: update the comment in __isolate_free_page

We need to assure the comment is consistent with the code.

Link: http://lkml.kernel.org/r/1466171914-21027-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-update-the-comment-in-__isolate_free_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-update-the-comment-in-__isolate_free_page
+++ a/mm/page_alloc.c
@@ -2514,7 +2514,7 @@ int __isolate_free_page(struct page *pag
 	zone->free_area[order].nr_free--;
 	rmv_page_order(page);
 
-	/* Set the pageblock if the isolated page is at least a pageblock */
+	/* Set the pageblock if the isolated page is at least half of a pageblock */
 	if (order >= pageblock_order - 1) {
 		struct page *endpage = page + (1 << order) - 1;
 		for (; page < endpage; page += pageblock_nr_pages) {
_

Patches currently in -mm which might be from zhongjiang@huawei.com are

mm-update-the-comment-in-__isolate_free_page.patch

