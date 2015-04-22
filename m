From: akpm@linux-foundation.org
Subject: [to-be-updated]
 zram-do-not-let-user-enforce-new-device-dev_id.patch removed from -mm tree
Date: Wed, 22 Apr 2015 13:30:23 -0700
Message-ID: <553804df.Swdr+ZV5fi10ti8A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49706 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131AbbDVUaX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Apr 2015 16:30:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: do not let user enforce new device dev_id
has been removed from the -mm tree.  Its filename was
     zram-do-not-let-user-enforce-new-device-dev_id.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: do not let user enforce new device dev_id

This patch forbids user to enforce device ids for newly added zram
devices, as suggested by Minchan Kim.  There seems to be a little interest
in this functionality and its use-cases are rather non-obvious.

zram_add sysfs attr, thus, is now read only and has only automatic device
id assignment mode.

This operation is no longer allowed:
   echo 1 > /sys/class/zram-control/zram_add
   -bash: /sys/class/zram-control/zram_add: Permission denied

Correct usage example:
   cat /sys/class/zram-control/zram_add
   2

It also removes common zram_control() handler because device creation and
removal do not share a lot of common steps anymore.  Move zram_add and
zram_remove code to zram_add_show() and zram_remove_store()
correspondingly.

LKML reference: https://lkml.org/lkml/2015/3/4/1414

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reported-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-zram |    8 -
 Documentation/blockdev/zram.txt            |   15 +-
 drivers/block/zram/zram_drv.c              |  130 +++++++------------
 3 files changed, 59 insertions(+), 94 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-class-zram~zram-do-not-let-user-enforce-new-device-dev_id Documentation/ABI/testing/sysfs-class-zram
--- a/Documentation/ABI/testing/sysfs-class-zram~zram-do-not-let-user-enforce-new-device-dev_id
+++ a/Documentation/ABI/testing/sysfs-class-zram
@@ -11,11 +11,9 @@ Date:		March 2015
 KernelVersion:	4.1
 Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
 Description:
-		RW attribuite. Write operation adds a specific /dev/zramX
-		device, where X is a device_id provided by user.
-		Read operation will automatically pick up avilable device_id
-		X, add /dev/zramX device and return that device_id X back to
-		user.
+		RO attribute. Read operation will cause zram to add a new
+		device and return its device id back to user (so one can
+		use /dev/zram<id>), or error code.
 
 		What:		/sys/class/zram-control/zram_add
 Date:		March 2015
diff -puN Documentation/blockdev/zram.txt~zram-do-not-let-user-enforce-new-device-dev_id Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-do-not-let-user-enforce-new-device-dev_id
+++ a/Documentation/blockdev/zram.txt
@@ -104,21 +104,20 @@ size of the disk when not in use so a hu
 zram provides a control interface, which enables dynamic (on-demand) device
 addition and removal.
 
-In order to add a new /dev/zramX device (where X is a unique device id) execute
-	echo X > /sys/class/zram-control/zram_add
+In order to add a new /dev/zramX device, perform read operation on zram_add
+attribute. This will return either new device's device id (meaning that you
+can use /dev/zram<id>) or error code.
 
-To remove the existing /dev/zramX device (where X is a device id) execute
-	echo X > /sys/class/zram-control/zram_remove
-
-Additionally, zram also handles automatic device_id generation and assignment.
+Example:
 
 	cat /sys/class/zram-control/zram_add
 	1
 	cat /sys/class/zram-control/zram_add
 	2
 
-this will pick up available device_id X, add corresponding /dev/zramX
-device and return its device_id X back to user (or error code).
+To remove the existing /dev/zramX device (where X is a device id)
+execute
+	echo X > /sys/class/zram-control/zram_remove
 
 8) Stats:
 Per-device statistics are exported as various nodes under /sys/block/zram<id>/
diff -puN drivers/block/zram/zram_drv.c~zram-do-not-let-user-enforce-new-device-dev_id drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-do-not-let-user-enforce-new-device-dev_id
+++ a/drivers/block/zram/zram_drv.c
@@ -43,9 +43,6 @@ static const char *default_compressor = 
 /* Module params (documentation at end) */
 static unsigned int num_devices = 1;
 
-#define ZRAM_CTL_ADD		1
-#define ZRAM_CTL_REMOVE		2
-
 static inline void deprecated_attr_warn(const char *name)
 {
 	pr_warn_once("%d (%s) Attribute %s (and others) will be removed. %s\n",
@@ -1268,79 +1265,7 @@ static struct zram *zram_lookup(int dev_
 	return ERR_PTR(-ENODEV);
 }
 
-/* common zram-control add/remove handler */
-static int zram_control(int cmd, const char *buf)
-{
-	struct zram *zram;
-	int ret = -ENOSYS, err, dev_id;
-
-	/* dev_id is gendisk->first_minor, which is `int' */
-	ret = kstrtoint(buf, 10, &dev_id);
-	if (ret || dev_id < 0)
-		return ret;
-
-	mutex_lock(&zram_index_mutex);
-	zram = zram_lookup(dev_id);
-
-	switch (cmd) {
-	case ZRAM_CTL_ADD:
-		if (!IS_ERR(zram)) {
-			ret = -EEXIST;
-			break;
-		}
-		ret = zram_add(dev_id);
-		break;
-	case ZRAM_CTL_REMOVE:
-		if (IS_ERR(zram)) {
-			ret = PTR_ERR(zram);
-			break;
-		}
-
-		/*
-		 * First, make ->disksize device attr RO, closing
-		 * ZRAM_CTL_REMOVE vs disksize_store() race window
-		 */
-		ret = sysfs_chmod_file(&disk_to_dev(zram->disk)->kobj,
-				&dev_attr_disksize.attr, S_IRUGO);
-		if (ret)
-			break;
-
-		ret = zram_reset_device(zram);
-		if (ret == 0) {
-			/* ->disksize is RO and there are no ->bd_openers */
-			zram_remove(zram);
-			break;
-		}
-
-		/*
-		 * If there are still device bd_openers, try to make ->disksize
-		 * RW again and return. even if we fail to make ->disksize RW,
-		 * user still has RW ->reset attr. so it's possible to destroy
-		 * that device.
-		 */
-		err = sysfs_chmod_file(&disk_to_dev(zram->disk)->kobj,
-				&dev_attr_disksize.attr,
-				S_IWUSR | S_IRUGO);
-		if (err)
-			ret = err;
-		break;
-	}
-	mutex_unlock(&zram_index_mutex);
-
-	return ret;
-}
-
 /* zram module control sysfs attributes */
-static ssize_t zram_add_store(struct class *class,
-			struct class_attribute *attr,
-			const char *buf,
-			size_t count)
-{
-	int ret = zram_control(ZRAM_CTL_ADD, buf);
-
-	return ret ? ret : count;
-}
-
 static ssize_t zram_add_show(struct class *class,
 			struct class_attribute *attr,
 			char *buf)
@@ -1348,10 +1273,7 @@ static ssize_t zram_add_show(struct clas
 	int ret;
 
 	mutex_lock(&zram_index_mutex);
-	/*
-	 * read operation on zram_add is - pick up device_id automatically, add
-	 * corresponding device and return that device_id back to user
-	 */
+	/* pick up available device_id */
 	ret = zram_add(-1);
 	mutex_unlock(&zram_index_mutex);
 
@@ -1365,13 +1287,59 @@ static ssize_t zram_remove_store(struct 
 			const char *buf,
 			size_t count)
 {
-	int ret = zram_control(ZRAM_CTL_REMOVE, buf);
+	struct zram *zram;
+	int ret, err, dev_id;
+
+	mutex_lock(&zram_index_mutex);
+
+	/* dev_id is gendisk->first_minor, which is `int' */
+	ret = kstrtoint(buf, 10, &dev_id);
+	if (ret || dev_id < 0) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	zram = zram_lookup(dev_id);
+	if (IS_ERR(zram)) {
+		ret = PTR_ERR(zram);
+		goto out;
+	}
+
+	/*
+	 * First, make ->disksize device attr RO, closing
+	 * ZRAM_CTL_REMOVE vs disksize_store() race window
+	 */
+	ret = sysfs_chmod_file(&disk_to_dev(zram->disk)->kobj,
+			&dev_attr_disksize.attr, S_IRUGO);
+	if (ret)
+		goto out;
+
+	ret = zram_reset_device(zram);
+	if (ret == 0) {
+		/* ->disksize is RO and there are no ->bd_openers */
+		zram_remove(zram);
+		goto out;
+	}
+
+	/*
+	 * If there are still device bd_openers, try to make ->disksize
+	 * RW again and return. even if we fail to make ->disksize RW,
+	 * user still has RW ->reset attr. so it's possible to destroy
+	 * that device.
+	 */
+	err = sysfs_chmod_file(&disk_to_dev(zram->disk)->kobj,
+			&dev_attr_disksize.attr,
+			S_IWUSR | S_IRUGO);
+	if (err)
+		ret = err;
 
+out:
+	mutex_unlock(&zram_index_mutex);
 	return ret ? ret : count;
 }
 
 static struct class_attribute zram_control_class_attrs[] = {
-	__ATTR_RW(zram_add),
+	__ATTR_RO(zram_add),
 	__ATTR_WO(zram_remove),
 	__ATTR_NULL,
 };
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch
revert-zram-move-compact_store-to-sysfs-functions-area.patch

