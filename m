From: akpm@linux-foundation.org
Subject: - scsi-sr-remove-gendisk-from-private-data-struct.patch removed from -mm tree
Date: Fri, 06 Jul 2007 13:42:16 -0700
Message-ID: <200707062042.l66KgGi7018952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50939 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761125AbXGFUmb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 16:42:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristen.c.accardi@intel.com, James.Bottomley@steeleye.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     SCSI: sr: remove gendisk from private data struct
has been removed from the -mm tree.  Its filename was
     scsi-sr-remove-gendisk-from-private-data-struct.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: SCSI: sr: remove gendisk from private data struct
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Since gendisk is now part of scsi_device, don't store this struct in private
data struct

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sr.c |   14 ++++++--------
 drivers/scsi/sr.h |    3 +--
 2 files changed, 7 insertions(+), 10 deletions(-)

diff -puN drivers/scsi/sr.c~scsi-sr-remove-gendisk-from-private-data-struct drivers/scsi/sr.c
--- a/drivers/scsi/sr.c~scsi-sr-remove-gendisk-from-private-data-struct
+++ a/drivers/scsi/sr.c
@@ -265,9 +265,9 @@ static void rw_intr(struct scsi_cmnd * S
 			 * last 75 2K sectors, we decrease the saved size
 			 * value.
 			 */
-			if (error_sector < get_capacity(cd->disk) &&
+			if (error_sector < get_capacity(cd->device->disk) &&
 			    cd->capacity - error_sector < 4 * 75)
-				set_capacity(cd->disk, error_sector);
+				set_capacity(cd->device->disk, error_sector);
 			break;
 
 		case RECOVERED_ERROR:
@@ -302,7 +302,7 @@ static int sr_init_command(struct scsi_c
 	struct scsi_cd *cd = scsi_cd(SCpnt->request->rq_disk);
 
 	SCSI_LOG_HLQUEUE(1, printk("Doing sr request, dev = %s, block = %d\n",
-				cd->disk->disk_name, block));
+				cd->device->disk->disk_name, block));
 
 	if (!cd->device || !scsi_device_online(cd->device)) {
 		SCSI_LOG_HLQUEUE(2, printk("Finishing %ld sectors\n",
@@ -571,9 +571,7 @@ static int sr_probe(struct device *dev)
 	disk->flags = GENHD_FL_CD;
 
 	cd->device = sdev;
-	cd->disk = disk;
 	cd->driver = &sr_template;
-	cd->disk = disk;
 	cd->capacity = 0x1fffff;
 	cd->device->changed = 1;	/* force recheck CD type */
 	cd->use = 1;
@@ -691,7 +689,7 @@ static void get_sectorsize(struct scsi_c
 		 * Add this so that we have the ability to correctly gauge
 		 * what the device is capable of.
 		 */
-		set_capacity(cd->disk, cd->capacity);
+		set_capacity(cd->device->disk, cd->capacity);
 	}
 
 	queue = cd->device->request_queue;
@@ -853,7 +851,7 @@ static int sr_packet(struct cdrom_device
 static void sr_kref_release(struct kref *kref)
 {
 	struct scsi_cd *cd = container_of(kref, struct scsi_cd, kref);
-	struct gendisk *disk = cd->disk;
+	struct gendisk *disk = cd->device->disk;
 
 	spin_lock(&sr_index_lock);
 	clear_bit(disk->first_minor, sr_index_bits);
@@ -872,7 +870,7 @@ static int sr_remove(struct device *dev)
 {
 	struct scsi_cd *cd = dev_get_drvdata(dev);
 
-	del_gendisk(cd->disk);
+	del_gendisk(cd->device->disk);
 
 	mutex_lock(&sr_ref_mutex);
 	kref_put(&cd->kref, sr_kref_release);
diff -puN drivers/scsi/sr.h~scsi-sr-remove-gendisk-from-private-data-struct drivers/scsi/sr.h
--- a/drivers/scsi/sr.h~scsi-sr-remove-gendisk-from-private-data-struct
+++ a/drivers/scsi/sr.h
@@ -38,10 +38,9 @@ typedef struct scsi_cd {
 	unsigned readcd_known:1;	/* drive supports READ_CD (0xbe) */
 	unsigned readcd_cdda:1;	/* reading audio data using READ_CD */
 	struct cdrom_device_info cdi;
-	/* We hold gendisk and scsi_device references on probe and use
+	/* We hold scsi_device references on probe and use
 	 * the refs on this kref to decide when to release them */
 	struct kref kref;
-	struct gendisk *disk;
 } Scsi_CD;
 
 int sr_do_ioctl(Scsi_CD *, struct packet_command *);
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
scsi-sr-remove-gendisk-from-private-data-struct.patch
scsi-st-remove-gendisk-from-private-data-struct.patch
