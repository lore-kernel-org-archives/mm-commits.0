From: akpm@linux-foundation.org
Subject: + scsi-expose-an-to-user-space.patch added to -mm tree
Date: Thu, 05 Jul 2007 11:35:54 -0700
Message-ID: <200707051835.l65IZsvV011885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42258 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759963AbXGESgH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 14:36:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristen.c.accardi@intel.com, James.Bottomley@steeleye.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     scsi: expose AN to user space
has been added to the -mm tree.  Its filename is
     scsi-expose-an-to-user-space.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: scsi: expose AN to user space
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Get media change notification capability from disk and pass this information
to genhd by setting appropriate flag.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
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
libata-check-for-an-support.patch
scsi-expose-an-to-user-space.patch
libata-expose-an-to-user-space.patch
scsi-save-disk-in-scsi_device.patch
libata-send-event-when-an-received.patch
cpci_hotplug-convert-to-use-the-kthread-api.patch
