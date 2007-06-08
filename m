From: akpm@linux-foundation.org
Subject: - update-gregkh-driver-block-device.patch removed from -mm tree
Date: Fri, 08 Jun 2007 10:34:46 -0700
Message-ID: <200706081734.l58HYkkP006310@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55890 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937251AbXFHRfS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 13:35:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kay.sievers@vrfy.org, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     update gregkh-driver-block-device
has been removed from the -mm tree.  Its filename was
     update-gregkh-driver-block-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: update gregkh-driver-block-device
From: Kay Sievers <kay.sievers@vrfy.org>

this fixes the block patch to work with the fault-injection. It broke with
the last manual merge and resync. It contains all of Andrew's fixes without
changing the attribute name, and adds a line of comment to the "device"-link
creation.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c         |    2 +-
 drivers/base/core.c   |    1 +
 fs/partitions/check.c |   10 ++++++----
 3 files changed, 8 insertions(+), 5 deletions(-)

diff -puN block/genhd.c~update-gregkh-driver-block-device block/genhd.c
--- a/block/genhd.c~update-gregkh-driver-block-device
+++ a/block/genhd.c
@@ -471,7 +471,7 @@ static DEVICE_ATTR(size, S_IRUGO, disk_s
 static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, disk_stat_show, NULL);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
-static device_attribute dev_attr_fail =
+static struct device_attribute dev_attr_fail =
 	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, disk_fail_show, disk_fail_store);
 #endif
 
diff -puN drivers/base/core.c~update-gregkh-driver-block-device drivers/base/core.c
--- a/drivers/base/core.c~update-gregkh-driver-block-device
+++ a/drivers/base/core.c
@@ -713,6 +713,7 @@ int device_add(struct device *dev)
 		if (dev->kobj.parent != &dev->class->subsys.kobj)
 			sysfs_create_link(&dev->class->subsys.kobj,
 					  &dev->kobj, dev->bus_id);
+		/* only bus-device parents get a "device"-link */
 		if (parent && parent->bus) {
 			sysfs_create_link(&dev->kobj, &dev->parent->kobj,
 							"device");
diff -puN fs/partitions/check.c~update-gregkh-driver-block-device fs/partitions/check.c
--- a/fs/partitions/check.c~update-gregkh-driver-block-device
+++ a/fs/partitions/check.c
@@ -250,8 +250,8 @@ static DEVICE_ATTR(start, S_IRUGO, part_
 static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
-static struct part_attribute dev_attr_fail =
-	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, part_fail_store, part_fail_read);
+static struct device_attribute dev_attr_fail =
+	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, part_fail_show, part_fail_store);
 #endif
 
 static struct attribute *part_attrs[] = {
@@ -259,9 +259,9 @@ static struct attribute *part_attrs[] = 
 	&dev_attr_size.attr,
 	&dev_attr_stat.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
-	&dev_attr_fail,
+	&dev_attr_fail.attr,
 #endif
-	NULL,
+	NULL
 };
 
 static struct attribute_group part_attr_group = {
@@ -370,6 +370,7 @@ void add_partition(struct gendisk *disk,
 		kobject_uevent(&p->dev.kobj, KOBJ_ADD);
 }
 
+#ifndef CONFIG_SYSFS_DEPRECATED
 static int disk_sysfs_symlinks(struct gendisk *disk)
 {
 	int err = 0;
@@ -381,6 +382,7 @@ static int disk_sysfs_symlinks(struct ge
 		put_device(target);
 	return err;
 }
+#endif
 
 /* Not exported, helper to add_disk(). */
 void register_disk(struct gendisk *disk)
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

revert-gregkh-driver-block-device.patch
git-ieee1394.patch
