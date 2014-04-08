From: akpm@linux-foundation.org
Subject: [merged] zram-move-zram-size-warning-to-documentation.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 14:04:29 -0700
Message-ID: <5344645d.H6a+ddACaMyYe+Tg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56674 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821AbaDHVEa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:04:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

Subject: [merged] zram-move-zram-size-warning-to-documentation.patch removed from -mm tree
To: sergey.senozhatsky@gmail.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:04:29 -0700


The patch titled
     Subject: zram: move zram size warning to documentation
has been removed from the -mm tree.  Its filename was
     zram-move-zram-size-warning-to-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: move zram size warning to documentation

Move zram warning about disksize and size of memory correlation to zram
documentation.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/blockdev/zram.txt |    5 +++++
 drivers/block/zram/zram_drv.c   |   15 ---------------
 2 files changed, 5 insertions(+), 15 deletions(-)

diff -puN Documentation/blockdev/zram.txt~zram-move-zram-size-warning-to-documentation Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-move-zram-size-warning-to-documentation
+++ a/Documentation/blockdev/zram.txt
@@ -33,6 +33,11 @@ Following shows a typical sequence of st
             echo 512M > /sys/block/zram0/disksize
             echo 1G > /sys/block/zram0/disksize
 
+Note:
+There is little point creating a zram of greater than twice the size of memory
+since we expect a 2:1 compression ratio. Note that zram uses about 0.1% of the
+size of the disk when not in use so a huge zram is wasteful.
+
 3) Activate:
 	mkswap /dev/zram0
 	swapon /dev/zram0
diff -puN drivers/block/zram/zram_drv.c~zram-move-zram-size-warning-to-documentation drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-move-zram-size-warning-to-documentation
+++ a/drivers/block/zram/zram_drv.c
@@ -535,23 +535,8 @@ static void zram_reset_device(struct zra
 
 static void zram_init_device(struct zram *zram, struct zram_meta *meta)
 {
-	if (zram->disksize > 2 * (totalram_pages << PAGE_SHIFT)) {
-		pr_info(
-		"There is little point creating a zram of greater than "
-		"twice the size of memory since we expect a 2:1 compression "
-		"ratio. Note that zram uses about 0.1%% of the size of "
-		"the disk when not in use so a huge zram is "
-		"wasteful.\n"
-		"\tMemory Size: %lu kB\n"
-		"\tSize you selected: %llu kB\n"
-		"Continuing anyway ...\n",
-		(totalram_pages << PAGE_SHIFT) >> 10, zram->disksize >> 10
-		);
-	}
-
 	/* zram devices sort of resembles non-rotational disks */
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
