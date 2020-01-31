From: akpm@linux-foundation.org
Subject: [merged]
 zram-try-to-avoid-worst-case-scenario-on-same-element-pages.patch removed
 from -mm tree
Date: Fri, 31 Jan 2020 15:19:38 -0800
Message-ID: <20200131231938.baJFk_lXA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgAaXTj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:19:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axboe@kernel.dk, minchan@kernel.org, mm-commits@vger.kernel.org, sergey.senozhatsky.work@gmail.com, taejoon.song@lge.com


The patch titled
     Subject: zram: try to avoid worst-case scenario on same element pages
has been removed from the -mm tree.  Its filename was
     zram-try-to-avoid-worst-case-scenario-on-same-element-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Taejoon Song <taejoon.song@lge.com>
Subject: zram: try to avoid worst-case scenario on same element pages

The worst-case scenario on finding same element pages is that almost all
elements are same at the first glance but only last few elements are
different.

Since the same element tends to be grouped from the beginning of the
pages, if we check the first element with the last element before looping
through all elements, we might have some chances to quickly detect
non-same element pages.

1. Test is done under LG webOS TV (64-bit arch)
2. Dump the swap-out pages (~819200 pages)
3. Analyze the pages with simple test script which counts the iteration
   number and measures the speed at off-line

Under 64-bit arch, the worst iteration count is PAGE_SIZE / 8 bytes = 512.
The speed is based on the time to consume page_same_filled() function
only.  The result, on average, is listed as below:

                                   Num of Iter    Speed(MB/s)
Looping-Forward (Orig)                 38            99265
Looping-Backward                       36           102725
Last-element-check (This Patch)        33           125072

The result shows that the average iteration count decreases by 13% and the
speed increases by 25% with this patch.  This patch does not increase the
overall time complexity, though.

I also ran simpler version which uses backward loop.  Just looping
backward also makes some improvement, but less than this patch.

[taejoon.song@lge.com: fix off-by-one]
  Link: http://lkml.kernel.org/r/1578642001-11765-1-git-send-email-taejoon.song@lge.com
Link: http://lkml.kernel.org/r/1575424418-16119-1-git-send-email-taejoon.song@lge.com
Signed-off-by: Taejoon Song <taejoon.song@lge.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-try-to-avoid-worst-case-scenario-on-same-element-pages
+++ a/drivers/block/zram/zram_drv.c
@@ -207,14 +207,17 @@ static inline void zram_fill_page(void *
 
 static bool page_same_filled(void *ptr, unsigned long *element)
 {
-	unsigned int pos;
 	unsigned long *page;
 	unsigned long val;
+	unsigned int pos, last_pos = PAGE_SIZE / sizeof(*page) - 1;
 
 	page = (unsigned long *)ptr;
 	val = page[0];
 
-	for (pos = 1; pos < PAGE_SIZE / sizeof(*page); pos++) {
+	if (val != page[last_pos])
+		return false;
+
+	for (pos = 1; pos < last_pos; pos++) {
 		if (val != page[pos])
 			return false;
 	}
_

Patches currently in -mm which might be from taejoon.song@lge.com are
