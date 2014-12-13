From: akpm@linux-foundation.org
Subject: [folded-merged]
 zram-implement-rw_page-operation-of-zram-fix-2-cleanup.patch removed from
 -mm tree
Date: Fri, 12 Dec 2014 16:43:22 -0800
Message-ID: <548b8baa.Rwv2Riv95XzLWEE4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38414 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220AbaLMAnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Dec 2014 19:43:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, jmarchan@redhat.com, karam.lee@lge.com, minchan@kernel.org, ngupta@vflare.org, seungho1.park@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-implement-rw_page-operation-of-zram-fix-2-cleanup
has been removed from the -mm tree.  Its filename was
     zram-implement-rw_page-operation-of-zram-fix-2-cleanup.patch

This patch was dropped because it was folded into zram-implement-rw_page-operation-of-zram.patch

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram-implement-rw_page-operation-of-zram-fix-2-cleanup

code cleanup

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Karam Lee <karam.lee@lge.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: <seungho1.park@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-implement-rw_page-operation-of-zram-fix-2-cleanup drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-implement-rw_page-operation-of-zram-fix-2-cleanup
+++ a/drivers/block/zram/zram_drv.c
@@ -956,8 +956,7 @@ static int zram_rw_page(struct block_dev
 	zram = bdev->bd_disk->private_data;
 	if (!valid_io_request(zram, sector, PAGE_SIZE)) {
 		atomic64_inc(&zram->stats.invalid_io);
-		err = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	down_read(&zram->init_lock);
@@ -974,15 +973,11 @@ static int zram_rw_page(struct block_dev
 	bv.bv_offset = 0;
 
 	err = zram_bvec_rw(zram, &bv, index, offset, rw);
-
 out_unlock:
 	up_read(&zram->init_lock);
-out:
-	if (unlikely(err))
-		return err;
