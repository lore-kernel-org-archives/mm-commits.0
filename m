From: akpm@linux-foundation.org
Subject: + scsi-st-remove-gendisk-from-private-data-struct.patch added to -mm tree
Date: Thu, 05 Jul 2007 15:58:02 -0700
Message-ID: <200707052258.l65Mw26K022671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60059 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759416AbXGEW6R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 18:58:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristen.c.accardi@intel.com, James.Bottomley@steeleye.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     SCSI: st: remove gendisk from private data struct
has been added to the -mm tree.  Its filename is
     scsi-st-remove-gendisk-from-private-data-struct.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SCSI: st: remove gendisk from private data struct
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Since gendisk is now part of scsi_device, don't store this struct in private
data struct

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/st.c |   12 +++++++-----
 drivers/scsi/st.h |    1 -
 2 files changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/st.c~scsi-st-remove-gendisk-from-private-data-struct drivers/scsi/st.c
--- a/drivers/scsi/st.c~scsi-st-remove-gendisk-from-private-data-struct
+++ a/drivers/scsi/st.c
@@ -306,7 +306,7 @@ static char * st_incompatible(struct scs
 
 static inline char *tape_name(struct scsi_tape *tape)
 {
-	return tape->disk->disk_name;
+	return tape->device->disk->disk_name;
 }
 
 
@@ -3549,7 +3549,8 @@ static int st_ioctl(struct inode *inode,
 			    !capable(CAP_SYS_RAWIO))
 				i = -EPERM;
 			else
-				i = scsi_cmd_ioctl(file, STp->disk, cmd_in, p);
+				i = scsi_cmd_ioctl(file, STp->device->disk,
+						cmd_in, p);
 			if (i != -ENOTTY)
 				return i;
 			break;
@@ -3961,7 +3962,6 @@ static int st_probe(struct device *dev)
 		goto out_put_disk;
 	}
 	kref_init(&tpnt->kref);
-	tpnt->disk = disk;
 	sprintf(disk->disk_name, "st%d", i);
 	disk->private_data = &tpnt->driver;
 	disk->queue = SDp->request_queue;
@@ -4063,6 +4063,8 @@ static int st_probe(struct device *dev)
 			goto out_free_tape;
 	}
 
+	SDp->disk = disk;
+
 	sdev_printk(KERN_NOTICE, SDp,
 		    "Attached scsi tape %s\n", tape_name(tpnt));
 	sdev_printk(KERN_INFO, SDp, "%s: try direct i/o: %s (alignment %d B)\n",
@@ -4151,7 +4153,7 @@ static int st_remove(struct device *dev)
 static void scsi_tape_release(struct kref *kref)
 {
 	struct scsi_tape *tpnt = to_scsi_tape(kref);
-	struct gendisk *disk = tpnt->disk;
+	struct gendisk *disk = tpnt->device->disk;
 
 	tpnt->device = NULL;
 
@@ -4348,7 +4350,7 @@ static int do_create_class_files(struct 
 		   first modes always get the same names */
 		i = mode << (4 - ST_NBR_MODE_BITS);
 		snprintf(name, 10, "%s%s%s", rew ? "n" : "",
-			 STp->disk->disk_name, st_formats[i]);
+			 STp->device->disk->disk_name, st_formats[i]);
 		st_class_member =
 			class_device_create(st_sysfs_class, NULL,
 					    MKDEV(SCSI_TAPE_MAJOR,
diff -puN drivers/scsi/st.h~scsi-st-remove-gendisk-from-private-data-struct drivers/scsi/st.h
--- a/drivers/scsi/st.h~scsi-st-remove-gendisk-from-private-data-struct
+++ a/drivers/scsi/st.h
@@ -167,7 +167,6 @@ struct scsi_tape {
 	unsigned char last_cmnd[6];
 	unsigned char last_sense[16];
 #endif
-	struct gendisk *disk;
 	struct kref     kref;
 };
 
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

git-acpi.patch
libata-check-for-an-support.patch
scsi-expose-an-to-user-space.patch
libata-expose-an-to-user-space.patch
scsi-save-disk-in-scsi_device.patch
libata-send-event-when-an-received.patch
ata-ahci-alpm-store-interrupt-value.patch
ata-ahci-alpm-expose-power-management-policy-option-to-users.patch
ata-ahci-alpm-enable-link-power-management-for-ata-drivers.patch
ata-ahci-alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch
cpci_hotplug-convert-to-use-the-kthread-api.patch
scsi-osst-remove-gendisk-from-private-data-struct.patch
scsi-sr-remove-gendisk-from-private-data-struct.patch
scsi-st-remove-gendisk-from-private-data-struct.patch
