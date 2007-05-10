From: akpm@linux-foundation.org
Subject: + genhd-send-async-notification-on-media-change.patch added to -mm tree
Date: Wed, 09 May 2007 22:12:27 -0700
Message-ID: <200705100512.l4A5CRfd012739@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37859 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755177AbXEJFM3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 01:12:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristen.c.accardi@intel.com


The patch titled
     genhd: send async notification on media change
has been added to the -mm tree.  Its filename is
     genhd-send-async-notification-on-media-change.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: genhd: send async notification on media change
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Send an uevent to user space to indicate that a media change event has
occurred.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c         |   23 +++++++++++++++++++++++
 include/linux/genhd.h |    4 +++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff -puN block/genhd.c~genhd-send-async-notification-on-media-change block/genhd.c
--- a/block/genhd.c~genhd-send-async-notification-on-media-change
+++ a/block/genhd.c
@@ -696,6 +696,27 @@ struct seq_operations diskstats_op = {
 	.show	= diskstats_show
 };
 
+static void media_change_notify_thread(struct work_struct *work)
+{
+	struct gendisk *gd = container_of(work, struct gendisk, async_notify);
+	char event[] = "MEDIA_CHANGE=1";
+	char *envp[] = { event, NULL };
+
+	/*
+	 * set enviroment vars to indicate which event this is for
+	 * so that user space will know to go check the media status.
+	 */
+	kobject_uevent_env(&gd->kobj, KOBJ_CHANGE, envp);
+	put_device(gd->driverfs_dev);
+}
+
+void genhd_media_change_notify(struct gendisk *disk)
+{
+	get_device(disk->driverfs_dev);
+	schedule_work(&disk->async_notify);
+}
+EXPORT_SYMBOL_GPL(genhd_media_change_notify);
+
 struct gendisk *alloc_disk(int minors)
 {
 	return alloc_disk_node(minors, -1);
@@ -725,6 +746,8 @@ struct gendisk *alloc_disk_node(int mino
 		kobj_set_kset_s(disk,block_subsys);
 		kobject_init(&disk->kobj);
 		rand_initialize_disk(disk);
+		INIT_WORK(&disk->async_notify,
+			media_change_notify_thread);
 	}
 	return disk;
 }
diff -puN include/linux/genhd.h~genhd-send-async-notification-on-media-change include/linux/genhd.h
--- a/include/linux/genhd.h~genhd-send-async-notification-on-media-change
+++ a/include/linux/genhd.h
@@ -66,6 +66,7 @@ struct partition {
 #include <linux/smp.h>
 #include <linux/string.h>
 #include <linux/fs.h>
+#include <linux/workqueue.h>
 
 struct partition {
 	unsigned char boot_ind;		/* 0x80 - active */
@@ -139,6 +140,7 @@ struct gendisk {
 #else
 	struct disk_stats dkstats;
 #endif
+	struct work_struct async_notify;
 };
 
 /* Structure for sysfs attributes on block devices */
@@ -420,7 +422,7 @@ extern struct gendisk *alloc_disk_node(i
 extern struct gendisk *alloc_disk(int minors);
 extern struct kobject *get_disk(struct gendisk *disk);
 extern void put_disk(struct gendisk *disk);
-
+extern void genhd_media_change_notify(struct gendisk *disk);
 extern void blk_register_region(dev_t dev, unsigned long range,
 			struct module *module,
 			struct kobject *(*probe)(dev_t, int *, void *),
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

origin.patch
acpi-dock-cleanup-the-uid-patch.patch
acpi-dock-fix-opps-after-dock-driver-fails-to-initialize.patch
acpi-dock-use-dynamically-allocated-platform-device.patch
acpi-dock-add-immediate_undock-option.patch
acpi-dock-unsuppress-uevents.patch
acpi-dock-send-envp-with-uevent.patch
acpi-bay-unsuppress-uevents.patch
libata-check-for-an-support.patch
genhd-expose-an-to-user-space.patch
scsi-expose-an-to-user-space.patch
libata-expose-an-to-user-space.patch
genhd-send-async-notification-on-media-change.patch
scsi-save-disk-in-scsi_device.patch
libata-send-event-when-an-received.patch
cpci_hotplug-convert-to-use-the-kthread-api.patch
