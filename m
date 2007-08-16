From: akpm@linux-foundation.org
Subject: + scsi-send-media-state-change-modification-events.patch added to -mm tree
Date: Thu, 16 Aug 2007 12:40:08 -0700
Message-ID: <200708161940.l7GJe86H003532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39826 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933193AbXHPTkT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 15:40:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kay.sievers@vrfy.org, James.Bottomley@steeleye.com, greg@kroah.com, kristen.c.accardi@intel.com


The patch titled
     scsi: send media state change modification events
has been added to the -mm tree.  Its filename is
     scsi-send-media-state-change-modification-events.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: scsi: send media state change modification events
From: Kay Sievers <kay.sievers@vrfy.org>

This will send for a card reader slot (remove/add media):
  UEVENT[1187091572.155884] change   /devices/pci0000:00/0000:00:1d.7/usb5/5-2/5-2:1.0/host7/target7:0:0/7:0:0:0 (scsi)
  UEVENT[1187091572.162314] remove   /block/sdb/sdb1 (block)
  UEVENT[1187091572.172464] add      /block/sdb/sdb1 (block)
  UEVENT[1187091572.175408] change   /devices/pci0000:00/0000:00:1d.7/usb5/5-2/5-2:1.0/host7/target7:0:0/7:0:0:0 (scsi)

and for a DVD drive (add/eject media):
  UEVENT[1187091590.189159] change   /devices/pci0000:00/0000:00:1f.1/host4/target4:0:0/4:0:0:0 (scsi)
  UEVENT[1187091590.957124] add      /module/isofs (module)
  UEVENT[1187091604.468207] change   /devices/pci0000:00/0000:00:1f.1/host4/target4:0:0/4:0:0:0 (scsi)

Userspace gets events, even for unpartitioned media. This unifies
the event handling for asynchronoous events (AN) and events caused by
perodical polling the device from userspace.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sd.c |   24 +++++++++++++++---------
 drivers/scsi/sr.c |   13 ++++++++++---
 drivers/scsi/sr.h |    1 +
 include/scsi/sd.h |    1 +
 4 files changed, 27 insertions(+), 12 deletions(-)

diff -puN drivers/scsi/sd.c~scsi-send-media-state-change-modification-events drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~scsi-send-media-state-change-modification-events
+++ a/drivers/scsi/sd.c
@@ -722,8 +722,11 @@ static int sd_media_changed(struct gendi
 	 * can deal with it then.  It is only because of unrecoverable errors
 	 * that we would ever take a device offline in the first place.
 	 */
-	if (!scsi_device_online(sdp))
-		goto not_present;
+	if (!scsi_device_online(sdp)) {
+		set_media_not_present(sdkp);
+		retval = 1;
+		goto out;
+	}
 
 	/*
 	 * Using TEST_UNIT_READY enables differentiation between drive with
@@ -735,6 +738,7 @@ static int sd_media_changed(struct gendi
 	 * sd_revalidate() is called.
 	 */
 	retval = -ENODEV;
+
 	if (scsi_block_when_processing_errors(sdp))
 		retval = scsi_test_unit_ready(sdp, SD_TIMEOUT, SD_MAX_RETRIES);
 
@@ -744,8 +748,11 @@ static int sd_media_changed(struct gendi
 	 * and we will figure it out later once the drive is
 	 * available again.
 	 */
-	if (retval)
-		 goto not_present;
+	if (retval) {
+		set_media_not_present(sdkp);
+		retval = 1;
+		goto out;
+	}
 
 	/*
 	 * For removable scsi disk we have to recognise the presence
@@ -756,12 +763,11 @@ static int sd_media_changed(struct gendi
 
 	retval = sdp->changed;
 	sdp->changed = 0;
-
+out:
+	if (retval != sdkp->previous_state)
+		scsi_device_event_notify(sdp, SDEV_MEDIA_CHANGE);
+	sdkp->previous_state = retval;
 	return retval;
-
-not_present:
-	set_media_not_present(sdkp);
-	return 1;
 }
 
 static int sd_sync_cache(struct scsi_disk *sdkp)
diff -puN drivers/scsi/sr.c~scsi-send-media-state-change-modification-events drivers/scsi/sr.c
--- a/drivers/scsi/sr.c~scsi-send-media-state-change-modification-events
+++ a/drivers/scsi/sr.c
@@ -192,8 +192,9 @@ static int sr_media_change(struct cdrom_
 		 * and we will figure it out later once the drive is
 		 * available again.  */
 		cd->device->changed = 1;
-		return 1;	/* This will force a flush, if called from
-				 * check_disk_change */
+		/* This will force a flush, if called from check_disk_change */
+		retval = 1;
+		goto out;
 	};
 
 	retval = cd->device->changed;
@@ -203,9 +204,15 @@ static int sr_media_change(struct cdrom_
 	if (retval) {
 		/* check multisession offset etc */
 		sr_cd_check(cdi);
-
 		get_sectorsize(cd);
 	}
+
+out:
+	/* Notify userspace, that media has changed. */
+	if (retval != cd->previous_state)
+		scsi_device_event_notify(cd->device, SDEV_MEDIA_CHANGE);
+	cd->previous_state = retval;
+
 	return retval;
 }
  
diff -puN drivers/scsi/sr.h~scsi-send-media-state-change-modification-events drivers/scsi/sr.h
--- a/drivers/scsi/sr.h~scsi-send-media-state-change-modification-events
+++ a/drivers/scsi/sr.h
@@ -37,6 +37,7 @@ typedef struct scsi_cd {
 	unsigned xa_flag:1;	/* CD has XA sectors ? */
 	unsigned readcd_known:1;	/* drive supports READ_CD (0xbe) */
 	unsigned readcd_cdda:1;	/* reading audio data using READ_CD */
+	unsigned previous_state:1;	/* media has changed */
 	struct cdrom_device_info cdi;
 	/* We hold gendisk and scsi_device references on probe and use
 	 * the refs on this kref to decide when to release them */
diff -puN include/scsi/sd.h~scsi-send-media-state-change-modification-events include/scsi/sd.h
--- a/include/scsi/sd.h~scsi-send-media-state-change-modification-events
+++ a/include/scsi/sd.h
@@ -41,6 +41,7 @@ struct scsi_disk {
 	u32		index;
 	u8		media_present;
 	u8		write_prot;
+	unsigned	previous_state : 1;
 	unsigned	WCE : 1;	/* state of disk WCE bit */
 	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
 	unsigned	DPOFUA : 1;	/* state of disk DPOFUA bit */
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

scsi-send-media-state-change-modification-events.patch
