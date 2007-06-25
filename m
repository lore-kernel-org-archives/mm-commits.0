From: akpm@linux-foundation.org
Subject: - scsi-expose-an-to-user-space.patch removed from -mm tree
Date: Mon, 25 Jun 2007 15:47:45 -0700
Message-ID: <200706252247.l5PMljrF012902@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45618 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752575AbXFYWrw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 18:47:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristen.c.accardi@intel.com, mm-commits@vger.kernel.org


The patch titled
     scsi: expose AN to user space
has been removed from the -mm tree.  Its filename was
     scsi-expose-an-to-user-space.patch

This patch was dropped because my copy is out of date

------------------------------------------------------
Subject: scsi: expose AN to user space
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Get media change notification capability from disk and pass this information
to genhd by setting appropriate flag.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sd.c          |    3 +++
 drivers/scsi/sr.c          |    2 ++
 include/scsi/scsi_device.h |    2 +-
 3 files changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/sd.c~scsi-expose-an-to-user-space drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~scsi-expose-an-to-user-space
+++ a/drivers/scsi/sd.c
@@ -1668,6 +1668,9 @@ static int sd_probe(struct device *dev)
 	if (sdp->removable)
 		gd->flags |= GENHD_FL_REMOVABLE;
 
+	if (sdp->media_change_notify)
+		gd->flags |= GENHD_FL_MEDIA_CHANGE_NOTIFY;
+
 	dev_set_drvdata(dev, sdkp);
 	add_disk(gd);
 
diff -puN drivers/scsi/sr.c~scsi-expose-an-to-user-space drivers/scsi/sr.c
--- a/drivers/scsi/sr.c~scsi-expose-an-to-user-space
+++ a/drivers/scsi/sr.c
@@ -603,6 +603,8 @@ static int sr_probe(struct device *dev)
 
 	dev_set_drvdata(dev, cd);
 	disk->flags |= GENHD_FL_REMOVABLE;
+	if (sdev->media_change_notify)
+		disk->flags |= GENHD_FL_MEDIA_CHANGE_NOTIFY;
 	add_disk(disk);
 
 	sdev_printk(KERN_DEBUG, sdev,
diff -puN include/scsi/scsi_device.h~scsi-expose-an-to-user-space include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h~scsi-expose-an-to-user-space
+++ a/include/scsi/scsi_device.h
@@ -126,7 +126,7 @@ struct scsi_device {
 	unsigned fix_capacity:1;	/* READ_CAPACITY is too high by 1 */
 	unsigned guess_capacity:1;	/* READ_CAPACITY might be too high by 1 */
 	unsigned retry_hwerror:1;	/* Retry HARDWARE_ERROR */
-
+	unsigned media_change_notify:1; /* dev supports async media notify */
 	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
 
 	unsigned int max_device_blocked; /* what device_blocked counts down from  */
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

git-acpi.patch
scsi-expose-an-to-user-space.patch
libata-expose-an-to-user-space.patch
scsi-save-disk-in-scsi_device.patch
libata-send-event-when-an-received.patch
cpci_hotplug-convert-to-use-the-kthread-api.patch
