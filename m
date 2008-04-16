From: akpm@linux-foundation.org
Subject: - sysfs-add-sys-dev-charblock-to-lookup-sysfs-path-by-major-minor-update.patch removed from -mm tree
Date: Wed, 16 Apr 2008 15:55:41 -0700
Message-ID: <200804162255.m3GMtfIS011143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752275AbYDPW4T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 18:56:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, gregkh@suse.de, hpa@zytor.com, htejun@gmail.com, kay.sievers@vrfy.org, lkml@rtr.ca, neilb@suse.de, steve@xemacs.org, mm-commits@vger.kernel.org


The patch titled
     sysfs: add /sys/dev/{char,block} to lookup sysfs path by major:minor (update)
has been removed from the -mm tree.  Its filename was
     sysfs-add-sys-dev-charblock-to-lookup-sysfs-path-by-major-minor-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysfs: add /sys/dev/{char,block} to lookup sysfs path by major:minor (update)
From: Dan Williams <dan.j.williams@intel.com>

* fixed up ENOMEM handling in devices_init()
* added a short blurb in Documentation/filesystems/sysfs.txt
* dropped the size of the buffer passed to format_dev_t a bit

Cc: NeilBrown <neilb@suse.de>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>
Acked-by: Mark Lord <lkml@rtr.ca>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: SL Baur <steve@xemacs.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/sysfs.txt |    6 ++++++
 drivers/base/core.c                 |   19 ++++++++++++++-----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff -puN Documentation/filesystems/sysfs.txt~sysfs-add-sys-dev-charblock-to-lookup-sysfs-path-by-major-minor-update Documentation/filesystems/sysfs.txt
--- a/Documentation/filesystems/sysfs.txt~sysfs-add-sys-dev-charblock-to-lookup-sysfs-path-by-major-minor-update
+++ a/Documentation/filesystems/sysfs.txt
@@ -248,6 +248,7 @@ The top level sysfs directory looks like
 block/
 bus/
 class/
+dev/
 devices/
 firmware/
 net/
@@ -274,6 +275,11 @@ fs/ contains a directory for some filesy
 filesystem wanting to export attributes must create its own hierarchy
 below fs/ (see ./fuse.txt for an example).
 
+dev/ contains two directories char/ and block/. Inside these two
+directories there are symlinks named <major>:<minor>.  These symlinks
+point to the sysfs directory for the given device.  /sys/dev provides a
+quick way to lookup the sysfs interface for a device from the result of
+a stat(2) operation.
 
 More information can driver-model specific features can be found in
 Documentation/driver-model/. 
diff -puN drivers/base/core.c~sysfs-add-sys-dev-charblock-to-lookup-sysfs-path-by-major-minor-update drivers/base/core.c
--- a/drivers/base/core.c~sysfs-add-sys-dev-charblock-to-lookup-sysfs-path-by-major-minor-update
+++ a/drivers/base/core.c
@@ -784,7 +784,7 @@ int device_add(struct device *dev)
 	struct device *parent = NULL;
 	struct class_interface *class_intf;
 	int error;
-	char devt_str[25];
+	char devt_str[15];
 
 	dev = get_device(dev);
 	if (!dev || !strlen(dev->bus_id)) {
@@ -944,7 +944,7 @@ void device_del(struct device *dev)
 {
 	struct device *parent = dev->parent;
 	struct class_interface *class_intf;
-	char devt_str[25];
+	char devt_str[15];
 
 	device_pm_remove(dev);
 	if (parent)
@@ -1080,14 +1080,23 @@ int __init devices_init(void)
 		return -ENOMEM;
 	dev_kobj = kobject_create_and_add("dev", NULL);
 	if (!dev_kobj)
-		return -ENOMEM;
+		goto dev_kobj_err;
 	block_kobj = kobject_create_and_add("block", dev_kobj);
 	if (!block_kobj)
-		return -ENOMEM;
+		goto block_kobj_err;
 	char_kobj = kobject_create_and_add("char", dev_kobj);
 	if (!char_kobj)
-		return -ENOMEM;
+		goto char_kobj_err;
+
 	return 0;
+
+ char_kobj_err:
+	kobject_put(block_kobj);
+ block_kobj_err:
+	kobject_put(dev_kobj);
+ dev_kobj_err:
+	kset_unregister(devices_kset);
+	return -ENOMEM;
 }
 
 EXPORT_SYMBOL_GPL(device_for_each_child);
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

git-arm.patch
git-async-tx.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
md-introduce-get_priority_stripe-to-improve-raid456-write-performance.patch
md-raid5c-convert-simple_strtoul-to-strict_strtoul.patch

