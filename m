From: akpm@linux-foundation.org
Subject: [merged] zram-add-dynamic-device-add-remove-functionality.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:46:28 -0700
Message-ID: <5591aea4.IrBB8ZLKYggcf1XE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbbF2Uq3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:46:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: add dynamic device add/remove functionality
has been removed from the -mm tree.  Its filename was
     zram-add-dynamic-device-add-remove-functionality.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: add dynamic device add/remove functionality

We currently don't support on-demand device creation.  The one and only
way to have N zram devices is to specify num_devices module parameter
(default value: 1).  IOW if, for some reason, at some point, user wants to
have N + 1 devies he/she must umount all the existing devices, unload the
module, load the module passing num_devices equals to N + 1.  And do this
again, if needed.

This patch introduces zram control sysfs class, which has two sysfs
attrs:
- hot_add      -- add a new zram device
- hot_remove   -- remove a specific (device_id) zram device

hot_add sysfs attr is read-only and has only automatic device id
assignment mode (as requested by Minchan Kim).  read operation performed
on this attr creates a new zram device and returns back its device_id or
error status.

Usage example:
	# add a new specific zram device
	cat /sys/class/zram-control/hot_add
	2

	# remove a specific zram device
	echo 4 > /sys/class/zram-control/hot_remove

Returning zram_add() error code back to user (-ENOMEM in this case)

	cat /sys/class/zram-control/hot_add
	cat: /sys/class/zram-control/hot_add: Cannot allocate memory

NOTE, there might be users who already depend on the fact that at least
zram0 device gets always created by zram_init(). Preserve this behavior.

[minchan@kernel.org: use zram->claim to avoid lockdep splat]
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-zram |   24 ++++
 Documentation/blockdev/zram.txt            |   23 +++-
 drivers/block/zram/zram_drv.c              |  100 ++++++++++++++++++-
 3 files changed, 141 insertions(+), 6 deletions(-)

diff -puN /dev/null Documentation/ABI/testing/sysfs-class-zram
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-class-zram
@@ -0,0 +1,24 @@
+What:		/sys/class/zram-control/
+Date:		August 2015
+KernelVersion:	4.2
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		The zram-control/ class sub-directory belongs to zram
+		device class
+
+What:		/sys/class/zram-control/hot_add
+Date:		August 2015
+KernelVersion:	4.2
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		RO attribute. Read operation will cause zram to add a new
+		device and return its device id back to user (so one can
+		use /dev/zram<id>), or error code.
+
+What:		/sys/class/zram-control/hot_remove
+Date:		August 2015
+KernelVersion:	4.2
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		WO attribute. Remove a specific /dev/zramX device, where X
+		is a device_id provided by user.
diff -puN Documentation/blockdev/zram.txt~zram-add-dynamic-device-add-remove-functionality Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-add-dynamic-device-add-remove-functionality
+++ a/Documentation/blockdev/zram.txt
@@ -99,7 +99,24 @@ size of the disk when not in use so a hu
 	mkfs.ext4 /dev/zram1
 	mount /dev/zram1 /tmp
 
-7) Stats:
+7) Add/remove zram devices
+
+zram provides a control interface, which enables dynamic (on-demand) device
+addition and removal.
+
+In order to add a new /dev/zramX device, perform read operation on hot_add
+attribute. This will return either new device's device id (meaning that you
+can use /dev/zram<id>) or error code.
+
+Example:
+	cat /sys/class/zram-control/hot_add
+	1
+
+To remove the existing /dev/zramX device (where X is a device id)
+execute
+	echo X > /sys/class/zram-control/hot_remove
+
+8) Stats:
 Per-device statistics are exported as various nodes under /sys/block/zram<id>/
 
 A brief description of exported device attritbutes. For more details please
@@ -174,11 +191,11 @@ line of text and contains the following
 	zero_pages
 	num_migrated
 
-8) Deactivate:
+9) Deactivate:
 	swapoff /dev/zram0
 	umount /dev/zram1
 
-9) Reset:
+10) Reset:
 	Write any positive value to 'reset' sysfs node
 	echo 1 > /sys/block/zram0/reset
 	echo 1 > /sys/block/zram1/reset
diff -puN drivers/block/zram/zram_drv.c~zram-add-dynamic-device-add-remove-functionality drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-add-dynamic-device-add-remove-functionality
+++ a/drivers/block/zram/zram_drv.c
@@ -29,10 +29,14 @@
 #include <linux/vmalloc.h>
 #include <linux/err.h>
 #include <linux/idr.h>
+#include <linux/sysfs.h>
 
 #include "zram_drv.h"
 
 static DEFINE_IDR(zram_index_idr);
+/* idr index must be protected */
+static DEFINE_MUTEX(zram_index_mutex);
+
 static int zram_major;
 static const char *default_compressor = "lzo";
 
@@ -1273,24 +1277,104 @@ out_free_dev:
 	return ret;
 }
 
-static void zram_remove(struct zram *zram)
+static int zram_remove(struct zram *zram)
 {
-	pr_info("Removed device: %s\n", zram->disk->disk_name);
+	struct block_device *bdev;
+
+	bdev = bdget_disk(zram->disk, 0);
+	if (!bdev)
+		return -ENOMEM;
+
+	mutex_lock(&bdev->bd_mutex);
+	if (bdev->bd_openers || zram->claim) {
+		mutex_unlock(&bdev->bd_mutex);
+		bdput(bdev);
+		return -EBUSY;
+	}
+
+	zram->claim = true;
+	mutex_unlock(&bdev->bd_mutex);
+
 	/*
 	 * Remove sysfs first, so no one will perform a disksize
-	 * store while we destroy the devices
+	 * store while we destroy the devices. This also helps during
+	 * hot_remove -- zram_reset_device() is the last holder of
+	 * ->init_lock, no later/concurrent disksize_store() or any
+	 * other sysfs handlers are possible.
 	 */
 	sysfs_remove_group(&disk_to_dev(zram->disk)->kobj,
 			&zram_disk_attr_group);
 
+	/* Make sure all the pending I/O are finished */
+	fsync_bdev(bdev);
 	zram_reset_device(zram);
+	bdput(bdev);
+
+	pr_info("Removed device: %s\n", zram->disk->disk_name);
+
 	idr_remove(&zram_index_idr, zram->disk->first_minor);
 	blk_cleanup_queue(zram->disk->queue);
 	del_gendisk(zram->disk);
 	put_disk(zram->disk);
 	kfree(zram);
+	return 0;
+}
+
+/* zram-control sysfs attributes */
+static ssize_t hot_add_show(struct class *class,
+			struct class_attribute *attr,
+			char *buf)
+{
+	int ret;
+
+	mutex_lock(&zram_index_mutex);
+	ret = zram_add();
+	mutex_unlock(&zram_index_mutex);
+
+	if (ret < 0)
+		return ret;
+	return scnprintf(buf, PAGE_SIZE, "%d\n", ret);
+}
+
+static ssize_t hot_remove_store(struct class *class,
+			struct class_attribute *attr,
+			const char *buf,
+			size_t count)
+{
+	struct zram *zram;
+	int ret, dev_id;
+
+	/* dev_id is gendisk->first_minor, which is `int' */
+	ret = kstrtoint(buf, 10, &dev_id);
+	if (ret)
+		return ret;
+	if (dev_id < 0)
+		return -EINVAL;
+
+	mutex_lock(&zram_index_mutex);
+
+	zram = idr_find(&zram_index_idr, dev_id);
+	if (zram)
+		ret = zram_remove(zram);
+	else
+		ret = -ENODEV;
+
+	mutex_unlock(&zram_index_mutex);
+	return ret ? ret : count;
 }
 
+static struct class_attribute zram_control_class_attrs[] = {
+	__ATTR_RO(hot_add),
+	__ATTR_WO(hot_remove),
+	__ATTR_NULL,
+};
+
+static struct class zram_control_class = {
+	.name		= "zram-control",
+	.owner		= THIS_MODULE,
+	.class_attrs	= zram_control_class_attrs,
+};
+
 static int zram_remove_cb(int id, void *ptr, void *data)
 {
 	zram_remove(ptr);
@@ -1299,6 +1383,7 @@ static int zram_remove_cb(int id, void *
 
 static void destroy_devices(void)
 {
+	class_unregister(&zram_control_class);
 	idr_for_each(&zram_index_idr, &zram_remove_cb, NULL);
 	idr_destroy(&zram_index_idr);
 	unregister_blkdev(zram_major, "zram");
@@ -1308,14 +1393,23 @@ static int __init zram_init(void)
 {
 	int ret;
 
+	ret = class_register(&zram_control_class);
+	if (ret) {
+		pr_warn("Unable to register zram-control class\n");
+		return ret;
+	}
+
 	zram_major = register_blkdev(0, "zram");
 	if (zram_major <= 0) {
 		pr_warn("Unable to get major number\n");
+		class_unregister(&zram_control_class);
 		return -EBUSY;
 	}
 
 	while (num_devices != 0) {
+		mutex_lock(&zram_index_mutex);
 		ret = zram_add();
+		mutex_unlock(&zram_index_mutex);
 		if (ret < 0)
 			goto out_error;
 		num_devices--;
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch

