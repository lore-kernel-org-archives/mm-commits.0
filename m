From: akpm@linux-foundation.org
Subject: [patch 023/119] zram: rename zram_decompress_page to
 __zram_bvec_read
Date: Wed, 06 Sep 2017 16:19:50 -0700
Message-ID: <20170906231950.aDzKdKkP4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49416 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753963AbdIFXTw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:19:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, juno.choi@lge.com, minchan@kernel.org, mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, torvalds@linux-foundation.org

From: Minchan Kim <minchan@kernel.org>
Subject: zram: rename zram_decompress_page to __zram_bvec_read

zram_decompress_page naming is not proper because it doesn't decompress if
page was dedup hit or stored with compression.  Use more abstract term and
consistent with write path function __zram_bvec_write.

Link: http://lkml.kernel.org/r/1498459987-24562-4-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Juneho Choi <juno.choi@lge.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-rename-zram_decompress_page-with-__zram_bvec_read drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-rename-zram_decompress_page-with-__zram_bvec_read
+++ a/drivers/block/zram/zram_drv.c
@@ -518,7 +518,7 @@ static void zram_free_page(struct zram *
 	zram_set_obj_size(zram, index, 0);
 }
 
-static int zram_decompress_page(struct zram *zram, struct page *page, u32 index)
+static int __zram_bvec_read(struct zram *zram, struct page *page, u32 index)
 {
 	int ret;
 	unsigned long handle;
@@ -570,7 +570,7 @@ static int zram_bvec_read(struct zram *z
 			return -ENOMEM;
 	}
 
-	ret = zram_decompress_page(zram, page, index);
+	ret = __zram_bvec_read(zram, page, index);
 	if (unlikely(ret))
 		goto out;
 
@@ -718,7 +718,7 @@ static int zram_bvec_write(struct zram *
 		if (!page)
 			return -ENOMEM;
 
-		ret = zram_decompress_page(zram, page, index);
+		ret = __zram_bvec_read(zram, page, index);
 		if (ret)
 			goto out;
 
_
