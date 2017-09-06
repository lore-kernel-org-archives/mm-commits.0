From: akpm@linux-foundation.org
Subject: [folded-merged] zram-read-page-from-backing-device-fix.patch
 removed from -mm tree
Date: Wed, 06 Sep 2017 15:59:09 -0700
Message-ID: <59b07dbd.XVXhisEUnGevMCIJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45958 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752066AbdIFW7K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 18:59:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xieyisheng1@huawei.com, juno.choi@lge.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-read-page-from-backing-device-fix
has been removed from the -mm tree.  Its filename was
     zram-read-page-from-backing-device-fix.patch

This patch was dropped because it was folded into zram-read-page-from-backing-device.patch

------------------------------------------------------
From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: zram-read-page-from-backing-device-fix

* read_from_bdev_async() return 1 to avoid call page_endio() in zram_rw_page()

Link: http://lkml.kernel.org/r/1502707447-6944-1-git-send-email-xieyisheng1@huawei.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Juneho Choi <juno.choi@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.c~zram-read-page-from-backing-device-fix drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-read-page-from-backing-device-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -455,7 +455,7 @@ void zram_page_end_io(struct bio *bio)
 }
 
 /*
- * Returns 0 if the submission is successful.
+ * Returns 1 if the submission is successful.
  */
 static int read_from_bdev_async(struct zram *zram, struct bio_vec *bvec,
 			unsigned long entry, struct bio *parent)
_

Patches currently in -mm which might be from xieyisheng1@huawei.com are

zram-read-page-from-backing-device.patch

