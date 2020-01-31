From: akpm@linux-foundation.org
Subject: [folded-merged]
 zram-try-to-avoid-worst-case-scenario-on-same-element-pages-update.patch
 removed from -mm tree
Date: Thu, 30 Jan 2020 21:50:34 -0800
Message-ID: <20200131055034.kF7x16YCk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726086AbgAaFuf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 00:50:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axboe@kernel.dk, minchan@kernel.org, mm-commits@vger.kernel.org, sergey.senozhatsky.work@gmail.com, taejoon.song@lge.com


The patch titled
     Subject: zram: try to avoid worst-case scenario on same element pages
has been removed from the -mm tree.  Its filename was
     zram-try-to-avoid-worst-case-scenario-on-same-element-pages-update.patch

This patch was dropped because it was folded into zram-try-to-avoid-worst-case-scenario-on-same-element-pages.patch

------------------------------------------------------
From: Taejoon Song <taejoon.song@lge.com>
Subject: zram: try to avoid worst-case scenario on same element pages

fix off-by-one

Link: http://lkml.kernel.org/r/1578642001-11765-1-git-send-email-taejoon.song@lge.com
Signed-off-by: Taejoon Song <taejoon.song@lge.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-try-to-avoid-worst-case-scenario-on-same-element-pages-update
+++ a/drivers/block/zram/zram_drv.c
@@ -217,7 +217,7 @@ static bool page_same_filled(void *ptr,
 	if (val != page[last_pos])
 		return false;
 
-	for (pos = 1; pos < last_pos - 1; pos++) {
+	for (pos = 1; pos < last_pos; pos++) {
 		if (val != page[pos])
 			return false;
 	}
_

Patches currently in -mm which might be from taejoon.song@lge.com are

zram-try-to-avoid-worst-case-scenario-on-same-element-pages.patch
