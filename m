From: akpm@linux-foundation.org
Subject: [patch 085/102] zram: reduce load operation in
 page_same_filled
Date: Wed, 03 May 2017 14:55:56 -0700
Message-ID: <20170503215556.4QKAEcSJF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52246 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752037AbdECV5E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:57:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, minchan@kernel.org, mm-commits@vger.kernel.org, sangwoo2.park@lge.com, sergey.senozhatsky@gmail.com, torvalds@linux-foundation.org

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
@@ -195,15 +195,17 @@ static bool page_same_filled(void *ptr,
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
