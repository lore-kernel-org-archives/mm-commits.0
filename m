From: akpm@linux-foundation.org
Subject: [patch 095/131] drivers/block/zram/zram_drv.c: make
 zram_page_end_io() static
Date: Wed, 15 Nov 2017 17:37:08 -0800
Message-ID: <20171116013708.nbHRCqfZz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40172 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933632AbdKPBhJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:37:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, colin.king@canonical.com, minchan@kernel.org, mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, torvalds@linux-foundation.org

From: Colin Ian King <colin.king@canonical.com>
Subject: drivers/block/zram/zram_drv.c: make zram_page_end_io() static

zram_page_end_io() is local to the source and does not need to be in
global scope, so make it static.

Cleans up sparse warning:
symbol 'zram_page_end_io' was not declared. Should it be static?

Link: http://lkml.kernel.org/r/20171016173336.20320-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.c~zram-make-function-zram_page_end_io-static drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-make-function-zram_page_end_io-static
+++ a/drivers/block/zram/zram_drv.c
@@ -428,7 +428,7 @@ static void put_entry_bdev(struct zram *
 	WARN_ON_ONCE(!was_set);
 }
 
-void zram_page_end_io(struct bio *bio)
+static void zram_page_end_io(struct bio *bio)
 {
 	struct page *page = bio->bi_io_vec[0].bv_page;
 
_
