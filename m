From: akpm@osdl.org
Subject: + scsi-sd-udev-accessing-an-uninitialized-scsi_disk-results-in-a-crash.patch added to -mm tree
Date: Fri, 02 Feb 2007 17:18:46 -0800
Message-ID: <200702030118.l131IkxN023548@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48344 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933404AbXBCBWD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 20:22:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nagendra_tomar@adaptec.com, James.Bottomley@steeleye.com, greg@kroah.com, stable@kernel.org


The patch titled
     SCSI sd: udev accessing an uninitialized scsi_disk results in a crash
has been added to the -mm tree.  Its filename is
     scsi-sd-udev-accessing-an-uninitialized-scsi_disk-results-in-a-crash.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SCSI sd: udev accessing an uninitialized scsi_disk results in a crash
From: Nagendra Singh Tomar <nagendra_tomar@adaptec.com>

sd_probe() calls class_device_add() even before initializing the
sdkp->device variable.  class_device_add() eventually results in the user
mode udev program to be called.  udev program can read the the
allow_restart attribute of the newly created scsi device.  This is
resulting in a crash as the show function for allow_restart (i.e
sd_show_allow_restart) returns the attribute value by reading the
sdkp->device->allow_restart variable.  As the sdkp->device is not
initialized before calling the user mode hotplug helper, this results in a
crash.

The patch solves it by calling class_device_add() only after the necessary
fields in the scsi_disk structure are initialized properly.

Signed-off-by: Nagendra Singh Tomar <nagendra_tomar@adaptec.com>
Cc: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/sd.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/scsi/sd.c~scsi-sd-udev-accessing-an-uninitialized-scsi_disk-results-in-a-crash drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~scsi-sd-udev-accessing-an-uninitialized-scsi_disk-results-in-a-crash
+++ a/drivers/scsi/sd.c
@@ -1647,16 +1647,6 @@ static int sd_probe(struct device *dev)
 	if (error)
 		goto out_put;
 
-	class_device_initialize(&sdkp->cdev);
-	sdkp->cdev.dev = &sdp->sdev_gendev;
-	sdkp->cdev.class = &sd_disk_class;
-	strncpy(sdkp->cdev.class_id, sdp->sdev_gendev.bus_id, BUS_ID_SIZE);
-
-	if (class_device_add(&sdkp->cdev))
-		goto out_put;
-
-	get_device(&sdp->sdev_gendev);
-
 	sdkp->device = sdp;
 	sdkp->driver = &sd_template;
 	sdkp->disk = gd;
@@ -1670,6 +1660,16 @@ static int sd_probe(struct device *dev)
 			sdp->timeout = SD_MOD_TIMEOUT;
 	}
 
+	class_device_initialize(&sdkp->cdev);
+	sdkp->cdev.dev = &sdp->sdev_gendev;
+	sdkp->cdev.class = &sd_disk_class;
+	strncpy(sdkp->cdev.class_id, sdp->sdev_gendev.bus_id, BUS_ID_SIZE);
+
+	if (class_device_add(&sdkp->cdev))
+		goto out_put;
+
+	get_device(&sdp->sdev_gendev);
+
 	gd->major = sd_major((index & 0xf0) >> 4);
 	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
 	gd->minors = 16;
_

Patches currently in -mm which might be from nagendra_tomar@adaptec.com are

scsi-sd-udev-accessing-an-uninitialized-scsi_disk-results-in-a-crash.patch
