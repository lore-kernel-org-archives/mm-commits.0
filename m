From: akpm@linux-foundation.org
Subject: + genhd-expose-an-to-user-space.patch added to -mm tree
Date: Wed, 09 May 2007 22:12:23 -0700
Message-ID: <200705100512.l4A5CNU9012730@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754775AbXEJFMZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 01:12:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristen.c.accardi@intel.com


The patch titled
     genhd: expose AN to user space
has been added to the -mm tree.  Its filename is
     genhd-expose-an-to-user-space.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: genhd: expose AN to user space
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Allow user space to determine if a disk supports Asynchronous Notification of
media changes.  This is done by adding a new sysfs file "capability_flags",
which is documented in (insert file name).  This sysfs file will export all
disk capabilities flags to user space.  We also define a new flag to define
the media change notification capability.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/block/capability.txt |   15 +++++++++++++++
 block/genhd.c                      |   10 +++++++++-
 include/linux/genhd.h              |    1 +
 3 files changed, 25 insertions(+), 1 deletion(-)

diff -puN /dev/null Documentation/block/capability.txt
--- /dev/null
+++ a/Documentation/block/capability.txt
@@ -0,0 +1,15 @@
+Generic Block Device Capability
+===============================================================================
+This file documents the sysfs file block/<disk>/capability
+
+capability is a hex word indicating which capabilities a specific disk
+supports.  For more information on bits not listed here, see
+include/linux/genhd.h
+
+Capability				Value
+-------------------------------------------------------------------------------
+GENHD_FL_MEDIA_CHANGE_NOTIFY		4
+	When this bit is set, the disk supports Asynchronous Notification
+	of media change events.  These events will be broadcast to user
+	space via kernel uevent.
+
diff -puN block/genhd.c~genhd-expose-an-to-user-space block/genhd.c
--- a/block/genhd.c~genhd-expose-an-to-user-space
+++ a/block/genhd.c
@@ -423,7 +423,10 @@ static ssize_t disk_size_read(struct gen
 {
 	return sprintf(page, "%llu\n", (unsigned long long)get_capacity(disk));
 }
-
+static ssize_t disk_capability_read(struct gendisk *disk, char *page)
+{
+	return sprintf(page, "%x\n", disk->flags);
+}
 static ssize_t disk_stats_read(struct gendisk * disk, char *page)
 {
 	preempt_disable();
@@ -466,6 +469,10 @@ static struct disk_attribute disk_attr_s
 	.attr = {.name = "size", .mode = S_IRUGO },
 	.show	= disk_size_read
 };
+static struct disk_attribute disk_attr_capability = {
+	.attr = {.name = "capability", .mode = S_IRUGO },
+	.show	= disk_capability_read
+};
 static struct disk_attribute disk_attr_stat = {
 	.attr = {.name = "stat", .mode = S_IRUGO },
 	.show	= disk_stats_read
@@ -506,6 +513,7 @@ static struct attribute * default_attrs[
 	&disk_attr_removable.attr,
 	&disk_attr_size.attr,
 	&disk_attr_stat.attr,
+	&disk_attr_capability.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&disk_attr_fail.attr,
 #endif
diff -puN include/linux/genhd.h~genhd-expose-an-to-user-space include/linux/genhd.h
--- a/include/linux/genhd.h~genhd-expose-an-to-user-space
+++ a/include/linux/genhd.h
@@ -94,6 +94,7 @@ struct hd_struct {
 
 #define GENHD_FL_REMOVABLE			1
 #define GENHD_FL_DRIVERFS			2
+#define GENHD_FL_MEDIA_CHANGE_NOTIFY		4
 #define GENHD_FL_CD				8
 #define GENHD_FL_UP				16
 #define GENHD_FL_SUPPRESS_PARTITION_INFO	32
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
