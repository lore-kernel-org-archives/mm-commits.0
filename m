From: akpm@linux-foundation.org
Subject: + scsi-save-disk-in-scsi_device.patch added to -mm tree
Date: Thu, 05 Jul 2007 11:35:58 -0700
Message-ID: <200707051835.l65IZw02011891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40061 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759912AbXGESgW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 14:36:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristen.c.accardi@intel.com, James.Bottomley@steeleye.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     SCSI: save disk in scsi_device
has been added to the -mm tree.  Its filename is
     scsi-save-disk-in-scsi_device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SCSI: save disk in scsi_device
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Give anyone who has access to scsi_device access to the genhd struct as well.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sd.c          |    1 +
 drivers/scsi/sr.c          |    1 +
 include/scsi/scsi_device.h |    2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/sd.c~scsi-save-disk-in-scsi_device drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~scsi-save-disk-in-scsi_device
+++ a/drivers/scsi/sd.c
@@ -1673,6 +1673,7 @@ static int sd_probe(struct device *dev)
 
 	dev_set_drvdata(dev, sdkp);
 	add_disk(gd);
+	sdp->disk = gd;
 
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
diff -puN drivers/scsi/sr.c~scsi-save-disk-in-scsi_device drivers/scsi/sr.c
--- a/drivers/scsi/sr.c~scsi-save-disk-in-scsi_device
+++ a/drivers/scsi/sr.c
@@ -606,6 +606,7 @@ static int sr_probe(struct device *dev)
 	if (sdev->media_change_notify)
 		disk->flags |= GENHD_FL_MEDIA_CHANGE_NOTIFY;
 	add_disk(disk);
+	sdev->disk = disk;
 
 	sdev_printk(KERN_DEBUG, sdev,
 		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
diff -puN include/scsi/scsi_device.h~scsi-save-disk-in-scsi_device include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h~scsi-save-disk-in-scsi_device
+++ a/include/scsi/scsi_device.h
@@ -140,7 +140,7 @@ struct scsi_device {
 
 	struct device		sdev_gendev;
 	struct class_device	sdev_classdev;
-
+	struct gendisk 		*disk;
 	struct execute_work	ew; /* used to get process context on put */
 
 	enum scsi_device_state sdev_state;
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

git-acpi.patch
libata-check-for-an-support.patch
scsi-expose-an-to-user-space.patch
libata-expose-an-to-user-space.patch
scsi-save-disk-in-scsi_device.patch
libata-send-event-when-an-received.patch
cpci_hotplug-convert-to-use-the-kthread-api.patch
