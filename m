From: akpm@linux-foundation.org
Subject: [merged] nbd-increase-default-and-max-request-sizes.patch removed from -mm tree
Date: Tue, 07 May 2013 10:50:09 -0700
Message-ID: <20130507175009.7AFB131C42F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:34730 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759468Ab3EGRuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:50:10 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so86093ves.2
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:50:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: belczyk@bsd.krakow.pl, axboe@kernel.dk, paul.clements@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nbd: increase default and max request sizes
has been removed from the -mm tree.  Its filename was
     nbd-increase-default-and-max-request-sizes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Belczyk <belczyk@bsd.krakow.pl>
Subject: nbd: increase default and max request sizes

Raise the default max request size for nbd to 128KB (from 127KB) to get it
4KB aligned.  This patch also allows the max request size to be increased
(via /sys/block/nbd<x>/queue/max_sectors_kb) to 32MB.

The patch makes nbd network traffic more efficient by:
- reducing request fragmentation (4KB alignment)
- reducing the number of requests (fewer round trips, less network overhead)

Especially in high latency networks, larger request size can make a dramatic

Signed-off-by: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Michal Belczyk <belczyk@bsd.krakow.pl>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/block/nbd.c~nbd-increase-default-and-max-request-sizes drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-increase-default-and-max-request-sizes
+++ a/drivers/block/nbd.c
@@ -856,6 +856,8 @@ static int __init nbd_init(void)
 		disk->queue->limits.discard_granularity = 512;
 		disk->queue->limits.max_discard_sectors = UINT_MAX;
 		disk->queue->limits.discard_zeroes_data = 0;
+		blk_queue_max_hw_sectors(disk->queue, 65536);
+		disk->queue->limits.max_sectors = 256;
 	}
 
 	if (register_blkdev(NBD_MAJOR, "nbd")) {
_

Patches currently in -mm which might be from belczyk@bsd.krakow.pl are

origin.patch

