From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 080/118] drivers/block/zram/zram_drv.c: fix error
 return codes not being returned in writeback_store
Date: Thu, 30 Jan 2020 22:15:25 -0800
Message-ID: <20200131061525.XGegLk6eX%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGP1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:15:27 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, colin.king@canonical.com, linux-mm@kvack.org, minchan@kernel.org, mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, torvalds@linux-foundation.org

From: Colin Ian King <colin.king@canonical.com>
Subject: drivers/block/zram/zram_drv.c: fix error return codes not being returned in writeback_store

Currently when an error code -EIO or -ENOSPC in the for-loop of
writeback_store the error code is being overwritten by a ret = len
assignment at the end of the function and the error codes are being lost. 
Fix this by assigning ret = len at the start of the function and remove
the assignment from the end, hence allowing ret to be preserved when error
codes are assigned to it.

Addresses Coverity ("Unused value")

Link: http://lkml.kernel.org/r/20191128122958.178290-1-colin.king@canonical.com
Fixes: a939888ec38b ("zram: support idle/huge page writeback")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-error-return-codes-not-being-returned-in-writeback_store
+++ a/drivers/block/zram/zram_drv.c
@@ -629,7 +629,7 @@ static ssize_t writeback_store(struct de
 	struct bio bio;
 	struct bio_vec bio_vec;
 	struct page *page;
-	ssize_t ret;
+	ssize_t ret = len;
 	int mode;
 	unsigned long blk_idx = 0;
 
@@ -765,7 +765,6 @@ next:
 
 	if (blk_idx)
 		free_block_bdev(zram, blk_idx);
-	ret = len;
 	__free_page(page);
 release_init_lock:
 	up_read(&zram->init_lock);
_
