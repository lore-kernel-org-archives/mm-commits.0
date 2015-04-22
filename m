From: akpm@linux-foundation.org
Subject: [to-be-updated]
 zram-add-dynamic-device-add-remove-functionality.patch removed from -mm
 tree
Date: Wed, 22 Apr 2015 13:30:07 -0700
Message-ID: <553804cf.D6e1xrs+etZM77eV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49675 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbbDVUaI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Apr 2015 16:30:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: add dynamic device add/remove functionality
has been removed from the -mm tree.  Its filename was
     zram-add-dynamic-device-add-remove-functionality.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: add dynamic device add/remove functionality

We currently don't support on-demand device creation.  The only way to
have N zram devices is to specify num_devices module parameter (default
value 1).  That means that if, for some reason, at some point, user wants
to have N + 1 devies he/she must umount all the existing devices, unload
the module, load the module passing num_devices equals to N + 1.  And do
this again, if needed.

Introduce zram control sysfs class, which has two sysfs attrs:
- zram_add      -- add a new specific (device_id) zram device
- zram_remove   -- remove a specific (device_id) zram device

Usage example:
	# add a new specific zram device
	echo 4 > /sys/class/zram-control/zram_add

	# remove a specific zram device
	echo 4 > /sys/class/zram-control/zram_remove

There is no automatic device_id generation, so user is expected to
provide one.

NOTE, there might be users who already depend on the fact that at
least zram0 device gets always created by zram_init(). Thus, due to
compatibility reasons, along with requested device_id (f.e. 5) zram0
will also be created.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-zram |   23 +++
 Documentation/blockdev/zram.txt            |   21 ++-
 drivers/block/zram/zram_drv.c              |  120 +++++++++++++++++++
 3 files changed, 160 insertions(+), 4 deletions(-)

diff -puN /dev/null Documentation/ABI/testing/sysfs-class-zram
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-class-zram
@@ -0,0 +1,23 @@
+What:		/sys/class/zram-control/
+Date:		March 2015
+KernelVersion:	4.1
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		The zram-control/ class sub-directory belongs to zram
+		device class
+
+What:		/sys/class/zram-control/zram_add
+Date:		March 2015
+KernelVersion:	4.1
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		Add a specific /dev/zramX device, where X is a device_id
+		provided by user
+
+		What:		/sys/class/zram-control/zram_add
+Date:		March 2015
+KernelVersion:	4.1
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		Remove a specific /dev/zramX device, where X is a device_id
+		provided by user
diff -puN Documentation/blockdev/zram.txt~zram-add-dynamic-device-add-remove-functionality Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-add-dynamic-device-add-remove-functionality
+++ a/Documentation/blockdev/zram.txt
@@ -19,7 +19,9 @@ Following shows a typical sequence of st
 1) Load Module:
 	modprobe zram num_devices=4
 	This creates 4 devices: /dev/zram{0,1,2,3}
-	(num_devices parameter is optional. Default: 1)
+
+num_devices parameter is optional and tells zram how many devices should be
+pre-created. Default: 1.
 
 2) Set max number of compression streams
 	Compression backend may use up to max_comp_streams compression streams,
@@ -97,7 +99,18 @@ size of the disk when not in use so a hu
 	mkfs.ext4 /dev/zram1
 	mount /dev/zram1 /tmp
 
-7) Stats:
+7) Add/remove zram devices
+
+zram provides a control interface, which enables dynamic (on-demand) device
+addition and removal.
+
+In order to add a new /dev/zramX device (where X is a unique device id) execute
+	echo X > /sys/class/zram-control/zram_add
+
+To remove the existing /dev/zramX device (where X is a device id) execute
+	echo X > /sys/class/zram-control/zram_remove
+
+8) Stats:
 Per-device statistics are exported as various nodes under /sys/block/zram<id>/
 
 A brief description of exported device attritbutes. For more details please
@@ -172,11 +185,11 @@ line of text and contains the following 
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
@@ -26,6 +26,7 @@
 #include <linux/highmem.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/sysfs.h>
 #include <linux/vmalloc.h>
 #include <linux/err.h>
 #include <linux/idr.h>
@@ -33,12 +34,18 @@
 #include "zram_drv.h"
 
 static DEFINE_IDR(zram_index_idr);
+/* idr index must be protected */
+static DEFINE_MUTEX(zram_index_mutex);
+
 static int zram_major;
 static const char *default_compressor = "lzo";
 
 /* Module params (documentation at end) */
 static unsigned int num_devices = 1;
 
+#define ZRAM_CTL_ADD		1
+#define ZRAM_CTL_REMOVE		2
+
 static inline void deprecated_attr_warn(const char *name)
 {
 	pr_warn_once("%d (%s) Attribute %s (and others) will be removed. %s\n",
@@ -1236,6 +1243,109 @@ static void zram_remove(struct zram *zra
 	kfree(zram);
 }
 
+/* lookup if there is any device pointer that match the given device_id.
+ * return device pointer if so, or ERR_PTR() otherwise. */
+static struct zram *zram_lookup(int dev_id)
+{
+	struct zram *zram;
+
+	zram = idr_find(&zram_index_idr, dev_id);
+	if (zram)
+		return zram;
+	return ERR_PTR(-ENODEV);
+}
+
+/* common zram-control add/remove handler */
+static int zram_control(int cmd, const char *buf)
+{
+	struct zram *zram;
+	int ret = -ENOSYS, err, dev_id;
+
+	/* dev_id is gendisk->first_minor, which is `int' */
+	ret = kstrtoint(buf, 10, &dev_id);
+	if (ret || dev_id < 0)
+		return ret;
+
+	mutex_lock(&zram_index_mutex);
+	zram = zram_lookup(dev_id);
+
+	switch (cmd) {
+	case ZRAM_CTL_ADD:
+		if (!IS_ERR(zram)) {
+			ret = -EEXIST;
+			break;
+		}
+		ret = zram_add(dev_id);
+		break;
+	case ZRAM_CTL_REMOVE:
+		if (IS_ERR(zram)) {
+			ret = PTR_ERR(zram);
+			break;
+		}
+
+		/* First, make ->disksize device attr RO, closing
+		 * ZRAM_CTL_REMOVE vs disksize_store() race window */
+		ret = sysfs_chmod_file(&disk_to_dev(zram->disk)->kobj,
+				&dev_attr_disksize.attr, S_IRUGO);
+		if (ret)
+			break;
+
+		ret = zram_reset_device(zram);
+		if (ret == 0) {
+			/* ->disksize is RO and there are no ->bd_openers */
+			zram_remove(zram);
+			break;
+		}
+
+		/* If there are still device bd_openers, try to make ->disksize
+		 * RW again and return. even if we fail to make ->disksize RW,
+		 * user still has RW ->reset attr. so it's possible to destroy
+		 * that device */
+		err = sysfs_chmod_file(&disk_to_dev(zram->disk)->kobj,
+				&dev_attr_disksize.attr,
+				S_IWUSR | S_IRUGO);
+		if (err)
+			ret = err;
+		break;
+	}
+	mutex_unlock(&zram_index_mutex);
+
+	return ret;
+}
+
+/* zram module control sysfs attributes */
+static ssize_t zram_add_store(struct class *class,
+			struct class_attribute *attr,
+			const char *buf,
+			size_t count)
+{
+	int ret = zram_control(ZRAM_CTL_ADD, buf);
+
+	return ret ? ret : count;
+}
+
+static ssize_t zram_remove_store(struct class *class,
+			struct class_attribute *attr,
+			const char *buf,
+			size_t count)
+{
+	int ret = zram_control(ZRAM_CTL_REMOVE, buf);
+
+	return ret ? ret : count;
+}
+
+static struct class_attribute zram_control_class_attrs[] = {
+	__ATTR_WO(zram_add),
+	__ATTR_WO(zram_remove),
+	__ATTR_NULL,
+};
+
+static struct class zram_control_class = {
+	.name		= "zram-control",
+	.owner		= THIS_MODULE,
+	.class_attrs	= zram_control_class_attrs,
+};
+
 static int zram_exit_cb(int id, void *ptr, void *data)
 {
 	zram_remove(ptr);
@@ -1244,6 +1354,7 @@ static int zram_exit_cb(int id, void *pt
 
 static void destroy_devices(void)
 {
+	class_unregister(&zram_control_class);
 	idr_for_each(&zram_index_idr, &zram_exit_cb, NULL);
 	idr_destroy(&zram_index_idr);
 	unregister_blkdev(zram_major, "zram");
@@ -1260,14 +1371,23 @@ static int __init zram_init(void)
 		return -EINVAL;
 	}
 
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
 
 	for (dev_id = 0; dev_id < num_devices; dev_id++) {
+		mutex_lock(&zram_index_mutex);
 		ret = zram_add(dev_id);
+		mutex_unlock(&zram_index_mutex);
 		if (ret != 0)
 			goto out_error;
 	}
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch
revert-zram-move-compact_store-to-sysfs-functions-area.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
zram-return-zram-device_id-value-from-zram_add.patch
zram-introduce-automatic-device_id-generation.patch
zram-introduce-automatic-device_id-generation-fix.patch
zram-do-not-let-user-enforce-new-device-dev_id.patch

