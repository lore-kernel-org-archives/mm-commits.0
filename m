From: akpm@linux-foundation.org
Subject: [to-be-updated] zram-use-idr-instead-of-zram_devices-array.patch
 removed from -mm tree
Date: Wed, 22 Apr 2015 13:30:00 -0700
Message-ID: <553804c8.WoCeZguklLh5T56k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49661 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbbDVUaA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Apr 2015 16:30:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: use idr instead of `zram_devices' array
has been removed from the -mm tree.  Its filename was
     zram-use-idr-instead-of-zram_devices-array.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: use idr instead of `zram_devices' array

This patch makes some preparations for dynamic device ADD/REMOVE
functionality via /dev/zram-control interface.

Remove `zram_devices' array and switch to id-to-pointer translation (idr).
 idr doesn't bloat zram struct with additional members, f.e.  list_head,
yet still provides ability to match the device_id with the device pointer.
 No user-space visible changes.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   81 ++++++++++++++++++--------------
 1 file changed, 46 insertions(+), 35 deletions(-)

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
@@ -1129,18 +1129,28 @@ static struct attribute_group zram_disk_
 	.attrs = zram_disk_attrs,
 };
 
-static int create_device(struct zram *zram, int device_id)
+static int zram_add(int device_id)
 {
+	struct zram *zram;
 	struct request_queue *queue;
 	int ret = -ENOMEM;
 
+	zram = kzalloc(sizeof(struct zram), GFP_KERNEL);
+	if (!zram)
+		return ret;
+
+	ret = idr_alloc(&zram_index_idr, zram, device_id,
+			device_id + 1, GFP_KERNEL);
+	if (ret < 0)
+		goto out_free_dev;
+
 	init_rwsem(&zram->init_lock);
 
 	queue = blk_alloc_queue(GFP_KERNEL);
 	if (!queue) {
 		pr_err("Error allocating disk queue for device %d\n",
 			device_id);
-		goto out;
+		goto out_free_idr;
 	}
 
 	blk_queue_make_request(queue, zram_make_request);
@@ -1210,34 +1220,42 @@ out_free_disk:
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
+static int zram_exit_cb(int id, void *ptr, void *data)
+{
+	zram_remove(ptr);
+	return 0;
+}
 
-	kfree(zram_devices);
+static void destroy_devices(void)
+{
+	idr_for_each(&zram_index_idr, &zram_exit_cb, NULL);
+	idr_destroy(&zram_index_idr);
 	unregister_blkdev(zram_major, "zram");
-	pr_info("Destroyed %u device(s)\n", nr);
+	pr_info("Destroyed device(s)\n");
 }
 
 static int __init zram_init(void)
@@ -1256,16 +1274,9 @@ static int __init zram_init(void)
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
 
@@ -1273,13 +1284,13 @@ static int __init zram_init(void)
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

origin.patch
revert-zram-move-compact_store-to-sysfs-functions-area.patch
zram-factor-out-device-reset-from-reset_store.patch
zram-reorganize-code-layout.patch
zram-add-dynamic-device-add-remove-functionality.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
zram-return-zram-device_id-value-from-zram_add.patch
zram-introduce-automatic-device_id-generation.patch
zram-introduce-automatic-device_id-generation-fix.patch
zram-do-not-let-user-enforce-new-device-dev_id.patch

