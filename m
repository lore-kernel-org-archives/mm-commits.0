From: akpm@linux-foundation.org
Subject: [withdrawn] zram-return-zram-device_id-from-zram_add.patch
 removed from -mm tree
Date: Wed, 06 May 2015 12:52:27 -0700
Message-ID: <554a70fb.WoDi7Bsebd9D6D/a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53077 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbbEFTw2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2015 15:52:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: return zram device_id from zram_add()
has been removed from the -mm tree.  Its filename was
     zram-return-zram-device_id-from-zram_add.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: return zram device_id from zram_add()

This patch prepares zram to enable on-demand device creation.
zram_add() performs automatic device_id assignment and returns
new device id (>= 0) or error code (< 0).

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-return-zram-device_id-from-zram_add drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-return-zram-device_id-from-zram_add
+++ a/drivers/block/zram/zram_drv.c
@@ -1151,20 +1151,24 @@ static struct attribute_group zram_disk_
 	.attrs = zram_disk_attrs,
 };
 
-static int zram_add(int device_id)
+/*
+ * Allocate and initialize new zram device. the function returns
+ * '>= 0' device_id upon success, and negative value otherwise.
+ */
+static int zram_add(void)
 {
 	struct zram *zram;
 	struct request_queue *queue;
-	int ret;
+	int ret, device_id;
 
 	zram = kzalloc(sizeof(struct zram), GFP_KERNEL);
 	if (!zram)
 		return -ENOMEM;
 
-	ret = idr_alloc(&zram_index_idr, zram, device_id,
-			device_id + 1, GFP_KERNEL);
+	ret = idr_alloc(&zram_index_idr, zram, 0, 0, GFP_KERNEL);
 	if (ret < 0)
 		goto out_free_dev;
+	device_id = ret;
 
 	init_rwsem(&zram->init_lock);
 
@@ -1238,7 +1242,7 @@ static int zram_add(int device_id)
 	zram->max_comp_streams = 1;
 
 	pr_info("Added device: %s\n", zram->disk->disk_name);
-	return 0;
+	return device_id;
 
 out_free_disk:
 	del_gendisk(zram->disk);
@@ -1285,7 +1289,7 @@ static void destroy_devices(void)
 
 static int __init zram_init(void)
 {
-	int ret, dev_id;
+	int ret;
 
 	zram_major = register_blkdev(0, "zram");
 	if (zram_major <= 0) {
@@ -1293,10 +1297,11 @@ static int __init zram_init(void)
 		return -EBUSY;
 	}
 
-	for (dev_id = 0; dev_id < num_devices; dev_id++) {
-		ret = zram_add(dev_id);
-		if (ret != 0)
+	while (num_devices != 0) {
+		ret = zram_add();
+		if (ret < 0)
 			goto out_error;
+		num_devices--;
 	}
 
 	return 0;
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-close-race-by-open-overriding.patch
zram-add-dynamic-device-add-remove-functionality.patch

