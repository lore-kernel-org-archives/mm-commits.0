From: akpm@linux-foundation.org
Subject: [merged]
 zram-clear-disk-io-accounting-when-reset-zram-device.patch removed from -mm tree
Date: Thu, 11 Jun 2015 14:01:25 -0700
Message-ID: <5579f725.9ATarrhneVJYxdi3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbbFKVBZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Jun 2015 17:01:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weijie.yang@samsung.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: clear disk io accounting when reset zram device
has been removed from the -mm tree.  Its filename was
     zram-clear-disk-io-accounting-when-reset-zram-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: zram: clear disk io accounting when reset zram device

Clear zram disk io accounting when resetting the zram device.  Otherwise
the residual io accounting stat will affect the diskstat in the next zram
active cycle.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/block/zram/zram_drv.c~zram-clear-disk-io-accounting-when-reset-zram-device drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-clear-disk-io-accounting-when-reset-zram-device
+++ a/drivers/block/zram/zram_drv.c
@@ -805,7 +805,9 @@ static void zram_reset_device(struct zra
 	memset(&zram->stats, 0, sizeof(zram->stats));
 	zram->disksize = 0;
 	zram->max_comp_streams = 1;
+
 	set_capacity(zram->disk, 0);
+	part_stat_set_all(&zram->disk->part0, 0);
 
 	up_write(&zram->init_lock);
 	/* I/O operation under all of CPU are done so let's free */
_

Patches currently in -mm which might be from weijie.yang@samsung.com are

origin.patch
mm-page_isolation-check-pfn-validity-before-access.patch

