From: akpm@linux-foundation.org
Subject: + nbd-increase-default-and-max-request-sizes.patch added to -mm tree
Date: Thu, 11 Apr 2013 15:33:02 -0700
Message-ID: <20130411223302.76B9F5A41B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:57589 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab3DKWdD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 18:33:03 -0400
Received: by mail-gg0-f201.google.com with SMTP id q6so194412ggc.2
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 15:33:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: belczyk@bsd.krakow.pl, axboe@kernel.dk, paul.clements@steeleye.com


The patch titled
     Subject: nbd: increase default and max request sizes
has been added to the -mm tree.  Its filename is
     nbd-increase-default-and-max-request-sizes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Michal Belczyk <belczyk@bsd.krakow.pl>
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

nbd-increase-default-and-max-request-sizes.patch

