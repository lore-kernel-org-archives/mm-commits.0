From: akpm@linux-foundation.org
Subject: - w1-w1_slave_read_id-read-bug-use-device_attribute.patch removed from -mm tree
Date: Wed, 30 Jul 2008 20:01:52 -0700
Message-ID: <200807310301.m6V31qY1000487@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763214AbYGaDB4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 23:01:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fries.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     w1: w1_slave_read_id read bug, use device_attribute
has been removed from the -mm tree.  Its filename was
     w1-w1_slave_read_id-read-bug-use-device_attribute.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1: w1_slave_read_id read bug, use device_attribute
From: David Fries <david@fries.net>

Fix bug reading the id sysfs file.  If less than the full 8 bytes were
read, the next read would start at the first byte instead of continuing. 
It needed the offset added to memcpy, or the better solution was to
replace it with the device attribute instead of bin attribute.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1.c |   35 ++++++++++-------------------------
 1 file changed, 10 insertions(+), 25 deletions(-)

diff -puN drivers/w1/w1.c~w1-w1_slave_read_id-read-bug-use-device_attribute drivers/w1/w1.c
--- a/drivers/w1/w1.c~w1-w1_slave_read_id-read-bug-use-device_attribute
+++ a/drivers/w1/w1.c
@@ -103,35 +103,20 @@ static ssize_t w1_slave_read_name(struct
 	return sprintf(buf, "%s\n", sl->name);
 }
 
-static ssize_t w1_slave_read_id(struct kobject *kobj,
-				struct bin_attribute *bin_attr,
-				char *buf, loff_t off, size_t count)
+static ssize_t w1_slave_read_id(struct device *dev,
+	struct device_attribute *attr, char *buf)
 {
-	struct w1_slave *sl = kobj_to_w1_slave(kobj);
-
-	if (off > 8) {
-		count = 0;
-	} else {
-		if (off + count > 8)
-			count = 8 - off;
-
-		memcpy(buf, (u8 *)&sl->reg_num, count);
-	}
+	struct w1_slave *sl = dev_to_w1_slave(dev);
+	ssize_t count = sizeof(sl->reg_num);
 
+	memcpy(buf, (u8 *)&sl->reg_num, count);
 	return count;
 }
 
 static struct device_attribute w1_slave_attr_name =
 	__ATTR(name, S_IRUGO, w1_slave_read_name, NULL);
-
-static struct bin_attribute w1_slave_attr_bin_id = {
-      .attr = {
-              .name = "id",
-              .mode = S_IRUGO,
-      },
-      .size = 8,
-      .read = w1_slave_read_id,
-};
+static struct device_attribute w1_slave_attr_id =
+	__ATTR(id, S_IRUGO, w1_slave_read_id, NULL);
 
 /* Default family */
 
@@ -641,7 +626,7 @@ static int __w1_attach_slave_device(stru
 	}
 
 	/* Create "id" entry */
-	err = sysfs_create_bin_file(&sl->dev.kobj, &w1_slave_attr_bin_id);
+	err = device_create_file(&sl->dev, &w1_slave_attr_id);
 	if (err < 0) {
 		dev_err(&sl->dev,
 			"sysfs file creation for [%s] failed. err=%d\n",
@@ -663,7 +648,7 @@ static int __w1_attach_slave_device(stru
 	return 0;
 
 out_rem2:
-	sysfs_remove_bin_file(&sl->dev.kobj, &w1_slave_attr_bin_id);
+	device_remove_file(&sl->dev, &w1_slave_attr_id);
 out_rem1:
 	device_remove_file(&sl->dev, &w1_slave_attr_name);
 out_unreg:
@@ -745,7 +730,7 @@ void w1_slave_detach(struct w1_slave *sl
 	msg.type = W1_SLAVE_REMOVE;
 	w1_netlink_send(sl->master, &msg);
 
-	sysfs_remove_bin_file(&sl->dev.kobj, &w1_slave_attr_bin_id);
+	device_remove_file(&sl->dev, &w1_slave_attr_id);
 	device_remove_file(&sl->dev, &w1_slave_attr_name);
 	device_unregister(&sl->dev);
 
_

Patches currently in -mm which might be from david@fries.net are

w1-w1_slave_read_id-read-bug-use-device_attribute.patch
w1-w1_therm-fix-user-buffer-overflow-and-cat.patch
w1-w1_family-remove-unused-variable-need_exit.patch
w1-w1_therm-consistent-mutex-access-code-cleanup.patch
w1-w1_intc-use-first-available-master-number.patch
w1-w1c-s-printk-dev_dbg.patch
w1-w1_ioc-reset-comments-and-msleep.patch
w1-ds1wmc-msleep-for-reset.patch
w1-ds2490c-correct-print-message.patch
w1-ds2490c-add-support-for-strong-pullup.patch
w1-ds2490c-add-support-for-strong-pullup-checkpatch-fixes.patch
w1-ds2490c-ds_write_bit-grouping-error-disable-readback.patch
w1-ds2490c-disable-bit-read-and-write.patch
w1-ds2490c-simplify-and-fix-ds_touch_bit.patch
w1-ds2490c-ds_dump_status-rework.patch
w1-ds2490c-ds_reset-remove-ds_wait_status.patch
w1-ds2490c-reset-ds2490-in-init.patch
w1-ds2490c-magic-number-work.patch
w1-ds2490c-ds_write_block-remove-extra-ds_wait_status.patch
w1-documentation-w1-masters-ds2490-update.patch
w1-ds2490c-optimize-ds_set_pullup.patch
w1-ds2490c-optimize-ds_set_pullup-checkpatch-fixes.patch

