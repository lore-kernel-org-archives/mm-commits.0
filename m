From: akpm@linux-foundation.org
Subject: + zram-rework-reset-and-destroy-path.patch added to -mm tree
Date: Tue, 03 Feb 2015 15:11:57 -0800
Message-ID: <54d155bd.g5eCO+QVuvFBNyJa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbbBCXL6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2015 18:11:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, jmarchan@redhat.com, minchan@kernel.org, ngupta@vflare.org, opensource.ganesh@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: rework reset and destroy path
has been added to the -mm tree.  Its filename is
     zram-rework-reset-and-destroy-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-rework-reset-and-destroy-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-rework-reset-and-destroy-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: rework reset and destroy path

We need to return set_capacity(disk, 0) from reset_store() back to
zram_reset_device(), a catch by Ganesh Mahendran.  Potentially, we can
race set_capacity() calls from init and reset paths.

The problem is that zram_reset_device() is also getting called from
zram_exit(), which performs operations in misleading reversed order -- we
first create_device() and then init it, while zram_exit() perform
destroy_device() first and then does zram_reset_device().  This is done to
remove sysfs group before we reset device, so we can continue with device
reset/destruction not being raced by sysfs attr write (f.e.  disksize).

Apart from that, destroy_device() releases zram->disk (but we still have
->disk pointer), so we cannot acces zram->disk in later
zram_reset_device() call, which may cause additional errors in the future.

So, this patch rework and cleanup destroy path.

1) remove several unneeded goto labels in zram_init()

2) factor out zram_init() error path and zram_exit() into
   destroy_devices() function, which takes the number of devices to
   destroy as its argument.

3) remove sysfs group in destroy_devices() first, so we can reorder
   operations -- reset device (as expected) goes before disk destroy and
   queue cleanup.  So we can always access ->disk in zram_reset_device().

4) and, finally, return set_capacity() back under ->init_lock.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reported-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   71 +++++++++++++-------------------
 1 file changed, 30 insertions(+), 41 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-rework-reset-and-destroy-path drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-rework-reset-and-destroy-path
+++ a/drivers/block/zram/zram_drv.c
@@ -732,8 +732,9 @@ static void zram_reset_device(struct zra
 	zram->meta = NULL;
 	/* Reset stats */
 	memset(&zram->stats, 0, sizeof(zram->stats));
-
 	zram->disksize = 0;
+	set_capacity(zram->disk, 0);
+
 	up_write(&zram->init_lock);
 }
 
@@ -826,7 +827,6 @@ static ssize_t reset_store(struct device
 	/* Make sure all pending I/O is finished */
 	fsync_bdev(bdev);
 	zram_reset_device(zram);
-	set_capacity(zram->disk, 0);
 
 	mutex_unlock(&bdev->bd_mutex);
 	revalidate_disk(zram->disk);
@@ -1112,15 +1112,29 @@ out:
 	return ret;
 }
 
-static void destroy_device(struct zram *zram)
+static void destroy_devices(unsigned int nr)
 {
-	sysfs_remove_group(&disk_to_dev(zram->disk)->kobj,
-			&zram_disk_attr_group);
+	struct zram *zram;
+	unsigned int i;
 
-	del_gendisk(zram->disk);
-	put_disk(zram->disk);
+	for (i = 0; i < nr; i++) {
+		zram = &zram_devices[i];
+		/* remove sysfs first, so no one will perform disksize
+		 * store while we destroying devices */
+		sysfs_remove_group(&disk_to_dev(zram->disk)->kobj,
+				&zram_disk_attr_group);
 
-	blk_cleanup_queue(zram->queue);
+		zram_reset_device(zram);
+
+		del_gendisk(zram->disk);
+		put_disk(zram->disk);
+
+		blk_cleanup_queue(zram->queue);
+	}
+
+	kfree(zram_devices);
+	unregister_blkdev(zram_major, "zram");
+	pr_debug("Destroyed %u device(s)\n", nr);
 }
 
 static int __init zram_init(void)
@@ -1130,64 +1144,39 @@ static int __init zram_init(void)
 	if (num_devices > max_num_devices) {
 		pr_warn("Invalid value for num_devices: %u\n",
 				num_devices);
-		ret = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	zram_major = register_blkdev(0, "zram");
 	if (zram_major <= 0) {
 		pr_warn("Unable to get major number\n");
-		ret = -EBUSY;
-		goto out;
+		return -EBUSY;
 	}
 
 	/* Allocate the device array and initialize each one */
 	zram_devices = kzalloc(num_devices * sizeof(struct zram), GFP_KERNEL);
 	if (!zram_devices) {
 		ret = -ENOMEM;
-		goto unregister;
+		goto out_error;
 	}
 
 	for (dev_id = 0; dev_id < num_devices; dev_id++) {
 		ret = create_device(&zram_devices[dev_id], dev_id);
 		if (ret)
-			goto free_devices;
+			goto out_error;
 	}
 
-	pr_info("Created %u device(s) ...\n", num_devices);
-
+	pr_info("Created %u device(s)\n", num_devices);
 	return 0;
 
-free_devices:
-	while (dev_id)
-		destroy_device(&zram_devices[--dev_id]);
-	kfree(zram_devices);
-unregister:
-	unregister_blkdev(zram_major, "zram");
-out:
+out_error:
+	destroy_devices(dev_id);
 	return ret;
 }
 
 static void __exit zram_exit(void)
 {
-	int i;
-	struct zram *zram;
-
-	for (i = 0; i < num_devices; i++) {
-		zram = &zram_devices[i];
-
-		destroy_device(zram);
-		/*
-		 * Shouldn't access zram->disk after destroy_device
-		 * because destroy_device already released zram->disk.
-		 */
-		zram_reset_device(zram);
-	}
-
-	unregister_blkdev(zram_major, "zram");
