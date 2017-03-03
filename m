From: akpm@linux-foundation.org
Subject: + zram-reduce-load-operation-in-page_same_filled.patch added to
 -mm tree
Date: Fri, 03 Mar 2017 15:37:51 -0800
Message-ID: <58b9fe4f.da3asiHiNO3Cpzua%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54276 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752089AbdCCXiH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 18:38:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sangwoo2.park@lge.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: reduce load operation in page_same_filled
has been added to the -mm tree.  Its filename is
     zram-reduce-load-operation-in-page_same_filled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-reduce-load-operation-in-page_same_filled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-reduce-load-operation-in-page_same_filled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sangwoo Park <sangwoo2.park@lge.com>
Subject: zram: reduce load operation in page_same_filled

In page_same_filled function, all elements in the page is compared with
next index value.  The current comparison routine compares the (i)th and
(i+1)th values of the page.

In this case, two load operaions occur for each comparison.  But if we
store first value of the page stores at 'val' variable and using it to
compare with others, the load opearation is reduced.  It reduce load
operation per page by up to 64times.

Link: http://lkml.kernel.org/r/1488428104-7257-1-git-send-email-sangwoo2.park@lge.com
Signed-off-by: Sangwoo Park <sangwoo2.park@lge.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-reduce-load-operation-in-page_same_filled drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-reduce-load-operation-in-page_same_filled
+++ a/drivers/block/zram/zram_drv.c
@@ -177,15 +177,17 @@ static bool page_same_filled(void *ptr,
 {
 	unsigned int pos;
 	unsigned long *page;
+	unsigned long val;
 
 	page = (unsigned long *)ptr;
+	val = page[0];
 
-	for (pos = 0; pos < PAGE_SIZE / sizeof(*page) - 1; pos++) {
-		if (page[pos] != page[pos + 1])
+	for (pos = 1; pos < PAGE_SIZE / sizeof(*page); pos++) {
+		if (val != page[pos])
 			return false;
 	}
 
-	*element = page[pos];
+	*element = val;
 
 	return true;
 }
_

Patches currently in -mm which might be from sangwoo2.park@lge.com are

zram-reduce-load-operation-in-page_same_filled.patch

