From: akpm@linux-foundation.org
Subject: + scsi-osst-remove-gendisk-from-private-data-struct.patch added to -mm tree
Date: Thu, 05 Jul 2007 15:57:58 -0700
Message-ID: <200707052257.l65Mvwq4022665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34981 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751729AbXGEW6N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 18:58:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristen.c.accardi@intel.com, James.Bottomley@steeleye.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     SCSI: osst: remove gendisk from private data struct
has been added to the -mm tree.  Its filename is
     scsi-osst-remove-gendisk-from-private-data-struct.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SCSI: osst: remove gendisk from private data struct
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Since gendisk is now part of scsi_device, don't store this struct in private
data struct

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/osst.c |    9 +++++----
 drivers/scsi/osst.h |    1 -
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/osst.c~scsi-osst-remove-gendisk-from-private-data-struct drivers/scsi/osst.c
--- a/drivers/scsi/osst.c~scsi-osst-remove-gendisk-from-private-data-struct
+++ a/drivers/scsi/osst.c
@@ -191,7 +191,7 @@ static int osst_write_error_recovery(str
 
 static inline char *tape_name(struct osst_tape *tape)
 {
-	return tape->drive->disk_name;
+	return tape->device->disk->disk_name;
 }
 
 /* Routines that handle the interaction with mid-layer SCSI routines */
@@ -5803,7 +5803,6 @@ static int osst_probe(struct device *dev
 	drive->private_data = &tpnt->driver;
 	sprintf(drive->disk_name, "osst%d", dev_num);
 	tpnt->driver = &osst_template;
-	tpnt->drive = drive;
 	tpnt->in_use = 0;
 	tpnt->capacity = 0xfffff;
 	tpnt->dirty = 0;
@@ -5885,6 +5884,8 @@ static int osst_probe(struct device *dev
 			goto out_free_sysfs1;
 	}
 
+	SDp->disk = drive;
+
 	sdev_printk(KERN_INFO, SDp,
 		"osst :I: Attached OnStream %.5s tape as %s\n",
 		SDp->model, tape_name(tpnt));
@@ -5915,7 +5916,7 @@ static int osst_remove(struct device *de
 			osst_sysfs_destroy(MKDEV(OSST_MAJOR, i));
 			osst_sysfs_destroy(MKDEV(OSST_MAJOR, i+128));
 			tpnt->device = NULL;
-			put_disk(tpnt->drive);
+			put_disk(tpnt->device->disk);
 			os_scsi_tapes[i] = NULL;
 			osst_nr_dev--;
 			write_unlock(&os_scsi_tapes_lock);
@@ -5988,7 +5989,7 @@ static void __exit exit_osst (void)
 				normalize_buffer(STp->buffer);
 				kfree(STp->buffer);
 			}
-			put_disk(STp->drive);
+			put_disk(STp->device->disk);
 			kfree(STp);
 		}
 		kfree(os_scsi_tapes);
diff -puN drivers/scsi/osst.h~scsi-osst-remove-gendisk-from-private-data-struct drivers/scsi/osst.h
--- a/drivers/scsi/osst.h~scsi-osst-remove-gendisk-from-private-data-struct
+++ a/drivers/scsi/osst.h
@@ -623,7 +623,6 @@ struct osst_tape {
   unsigned char last_cmnd[6];
   unsigned char last_sense[16];
 #endif
-  struct gendisk *drive;
 } ;
 
 /* scsi tape command */
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
