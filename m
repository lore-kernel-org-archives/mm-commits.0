From: akpm@linux-foundation.org
Subject: [merged] zram-remove-request_queue-from-struct-zram.patch removed from -mm tree
Date: Fri, 13 Feb 2015 12:21:26 -0800
Message-ID: <54de5cc6.FD1QMoU9TRO/J8U2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48971 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbBMUV1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:21:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, jmarchan@redhat.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: remove request_queue from struct zram
has been removed from the -mm tree.  Its filename was
     zram-remove-request_queue-from-struct-zram.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: remove request_queue from struct zram

`struct zram' contains both `struct gendisk' and `struct request_queue'. 
the latter can be deleted, because zram->disk carries ->queue pointer, and
->queue carries zram pointer:

create_device()
	zram->queue->queuedata = zram
	zram->disk->queue = zram->queue
	zram->disk->private_data = zram

so zram->queue is not needed, we can access all necessary data anyway.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   16 ++++++++--------
 drivers/block/zram/zram_drv.h |    1 -
 2 files changed, 8 insertions(+), 9 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-remove-request_queue-from-struct-zram drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-remove-request_queue-from-struct-zram
+++ a/drivers/block/zram/zram_drv.c
@@ -1061,19 +1061,19 @@ static struct attribute_group zram_disk_
 
 static int create_device(struct zram *zram, int device_id)
 {
+	struct request_queue *queue;
 	int ret = -ENOMEM;
 
 	init_rwsem(&zram->init_lock);
 
-	zram->queue = blk_alloc_queue(GFP_KERNEL);
-	if (!zram->queue) {
+	queue = blk_alloc_queue(GFP_KERNEL);
+	if (!queue) {
 		pr_err("Error allocating disk queue for device %d\n",
 			device_id);
 		goto out;
 	}
 
-	blk_queue_make_request(zram->queue, zram_make_request);
-	zram->queue->queuedata = zram;
+	blk_queue_make_request(queue, zram_make_request);
 
 	 /* gendisk structure */
 	zram->disk = alloc_disk(1);
@@ -1086,7 +1086,8 @@ static int create_device(struct zram *zr
 	zram->disk->major = zram_major;
 	zram->disk->first_minor = device_id;
 	zram->disk->fops = &zram_devops;
-	zram->disk->queue = zram->queue;
+	zram->disk->queue = queue;
+	zram->disk->queue->queuedata = zram;
 	zram->disk->private_data = zram;
 	snprintf(zram->disk->disk_name, 16, "zram%d", device_id);
 
@@ -1137,7 +1138,7 @@ out_free_disk:
 	del_gendisk(zram->disk);
 	put_disk(zram->disk);
 out_free_queue:
-	blk_cleanup_queue(zram->queue);
+	blk_cleanup_queue(queue);
 out:
 	return ret;
 }
@@ -1158,10 +1159,9 @@ static void destroy_devices(unsigned int
 
 		zram_reset_device(zram);
 
+		blk_cleanup_queue(zram->disk->queue);
 		del_gendisk(zram->disk);
 		put_disk(zram->disk);
