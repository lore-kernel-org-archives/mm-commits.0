From: akpm@linux-foundation.org
Subject: [withdrawn] zram-use-idr-instead-of-zram_devices-array.patch
 removed from -mm tree
Date: Wed, 06 May 2015 12:52:18 -0700
Message-ID: <554a70f2.0nxs9ecIS6ktAxiL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbbEFTwT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2015 15:52:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, Julia.Lawall@lip6.fr, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: use idr instead of `zram_devices' array
has been removed from the -mm tree.  Its filename was
     zram-use-idr-instead-of-zram_devices-array.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: use idr instead of `zram_devices' array

This patch makes some preparations for on-demand device add/remove
functionality.

Remove `zram_devices' array and switch to id-to-pointer translation (idr).
 idr doesn't bloat zram struct with additional members, f.e.  list_head,
yet still provides ability to match the device_id with the device pointer.

No user-space visible changes.

[do not lose -ENOMEM return code when `queue' allocation has failed]
Reported-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   86 ++++++++++++++++++--------------
 1 file changed, 49 insertions(+), 37 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-use-idr-instead-of-zram_devices-array drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-use-idr-instead-of-zram_devices-array
+++ a/drivers/block/zram/zram_drv.c
@@ -28,12 +28,12 @@
 #include <linux/string.h>
 #include <linux/vmalloc.h>
 #include <linux/err.h>
+#include <linux/idr.h>
 
 #include "zram_drv.h"
 
-/* Globals */
+static DEFINE_IDR(zram_index_idr);
 static int zram_major;
-static struct zram *zram_devices;
 static const char *default_compressor = "lzo";
 
 /* Module params (documentation at end) */
@@ -1152,10 +1152,20 @@ static struct attribute_group zram_disk_
 	.attrs = zram_disk_attrs,
 };
 
-static int create_device(struct zram *zram, int device_id)
+static int zram_add(int device_id)
 {
+	struct zram *zram;
 	struct request_queue *queue;
-	int ret = -ENOMEM;
+	int ret;
+
+	zram = kzalloc(sizeof(struct zram), GFP_KERNEL);
+	if (!zram)
+		return -ENOMEM;
+
+	ret = idr_alloc(&zram_index_idr, zram, device_id,
+			device_id + 1, GFP_KERNEL);
+	if (ret < 0)
+		goto out_free_dev;
 
 	init_rwsem(&zram->init_lock);
 
@@ -1163,12 +1173,13 @@ static int create_device(struct zram *zr
 	if (!queue) {
 		pr_err("Error allocating disk queue for device %d\n",
 			device_id);
-		goto out;
+		ret = -ENOMEM;
+		goto out_free_idr;
 	}
 
 	blk_queue_make_request(queue, zram_make_request);
 
-	 /* gendisk structure */
+	/* gendisk structure */
 	zram->disk = alloc_disk(1);
 	if (!zram->disk) {
 		pr_warn("Error allocating disk structure for device %d\n",
@@ -1233,34 +1244,42 @@ out_free_disk:
 	put_disk(zram->disk);
 out_free_queue:
 	blk_cleanup_queue(queue);
-out:
+out_free_idr:
+	idr_remove(&zram_index_idr, device_id);
+out_free_dev:
+	kfree(zram);
 	return ret;
 }
 
-static void destroy_devices(unsigned int nr)
+static void zram_remove(struct zram *zram)
 {
-	struct zram *zram;
-	unsigned int i;
-
-	for (i = 0; i < nr; i++) {
-		zram = &zram_devices[i];
-		/*
-		 * Remove sysfs first, so no one will perform a disksize
-		 * store while we destroy the devices
-		 */
-		sysfs_remove_group(&disk_to_dev(zram->disk)->kobj,
-				&zram_disk_attr_group);
+	/*
+	 * Remove sysfs first, so no one will perform a disksize
+	 * store while we destroy the devices
+	 */
+	sysfs_remove_group(&disk_to_dev(zram->disk)->kobj,
+			&zram_disk_attr_group);
 
-		zram_reset_device(zram);
+	zram_reset_device(zram);
+	idr_remove(&zram_index_idr, zram->disk->first_minor);
+	blk_cleanup_queue(zram->disk->queue);
+	del_gendisk(zram->disk);
+	put_disk(zram->disk);
+	kfree(zram);
+}
 
-		blk_cleanup_queue(zram->disk->queue);
-		del_gendisk(zram->disk);
-		put_disk(zram->disk);
-	}
+static int zram_remove_cb(int id, void *ptr, void *data)
+{
+	zram_remove(ptr);
+	return 0;
+}
 
-	kfree(zram_devices);
+static void destroy_devices(void)
+{
+	idr_for_each(&zram_index_idr, &zram_remove_cb, NULL);
+	idr_destroy(&zram_index_idr);
 	unregister_blkdev(zram_major, "zram");
-	pr_info("Destroyed %u device(s)\n", nr);
+	pr_info("Destroyed device(s)\n");
 }
 
 static int __init zram_init(void)
@@ -1279,16 +1298,9 @@ static int __init zram_init(void)
 		return -EBUSY;
 	}
 
-	/* Allocate the device array and initialize each one */
-	zram_devices = kzalloc(num_devices * sizeof(struct zram), GFP_KERNEL);
-	if (!zram_devices) {
-		unregister_blkdev(zram_major, "zram");
-		return -ENOMEM;
-	}
-
 	for (dev_id = 0; dev_id < num_devices; dev_id++) {
-		ret = create_device(&zram_devices[dev_id], dev_id);
-		if (ret)
+		ret = zram_add(dev_id);
+		if (ret != 0)
 			goto out_error;
 	}
 
@@ -1296,13 +1308,13 @@ static int __init zram_init(void)
 	return 0;
 
 out_error:
-	destroy_devices(dev_id);
+	destroy_devices();
 	return ret;
 }
 
 static void __exit zram_exit(void)
 {
-	destroy_devices(num_devices);
+	destroy_devices();
 }
 
 module_init(zram_init);
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-reorganize-code-layout.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
zram-return-zram-device_id-from-zram_add.patch
zram-close-race-by-open-overriding.patch
zram-add-dynamic-device-add-remove-functionality.patch

