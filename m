From: akpm@osdl.org
Subject: + sd-spin-down-disks-on-removal-or-power-down.patch added to -mm tree
Date: Mon, 29 Jan 2007 15:49:16 -0800
Message-ID: <200701292349.l0TNnKf3003028@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34172 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964783AbXA2XtW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 18:49:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hancockr@shaw.ca


The patch titled
     sd: spin down disks on removal or power-down
has been added to the -mm tree.  Its filename is
     sd-spin-down-disks-on-removal-or-power-down.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sd: spin down disks on removal or power-down
From: Robert Hancock <hancockr@shaw.ca>

Here's a patch for sd.c I've cooked up which issues a START STOP UNIT
command to stop the drive when the SCSI disk is removed or the machine is
powered down.  The rationale behind this is that apparently on many drives,
simply cutting power to the spinning disk forces it to do an emergency head
park/unload which creates more wear on the drive then a controlled
park/unload with power still applied.  This change ensures that the drive
will be spun down if the user shuts down the machine or if they are about
to hot-unplug the drive and have done "scsiadd -r" first.

The main potential concern I have about this implementation is that if the
drive is used in a multi-initiator, iSCSI, etc.  environment, stopping the
drive may be undesirable as another initiator may still be accessing it. 
I'm not familiar enough with these setups to know if this problem is likely
to come up or not.  For this and other reasons we may want to make this
behavior controllable - I'm open to suggestions on how to do this or
whether it's needed.

I've tested that this does work on SATA disks through libata (with my patch
"libata: fix translation for START STOP UNIT" applied).  I also tested with
some external USB-to-IDE drive enclosures.  The support for START STOP UNIT
on those seems rather poor though, on one enclosure with a Genesys bridge
chip it returned a check condition with "Invalid field in CDB", and on
another with a JMicron chip the request succeeded but it didn't actually
spin the drive down.


Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/sd.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+)

diff -puN drivers/scsi/sd.c~sd-spin-down-disks-on-removal-or-power-down drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~sd-spin-down-disks-on-removal-or-power-down
+++ a/drivers/scsi/sd.c
@@ -821,6 +821,39 @@ static int sd_sync_cache(struct scsi_dev
 	return res;
 }
 
+static int sd_stop_unit(struct scsi_device *sdp, struct scsi_disk* sdkp)
+{
+	int res;
+	struct scsi_sense_hdr sshdr;
+	unsigned char cmd[10] = { 0 };
+
+	if (!scsi_device_online(sdp))
+		return -ENODEV;
+
+	cmd[0] = START_STOP;
+	/*
+	 * Leave the rest of the command zero to indicate
+	 * transition to stopped power condition and return
+	 * on completion.
+	 */
+	printk(KERN_NOTICE "Stopping SCSI disk %s\n",
+		sdkp->disk->disk_name);
+	res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
+			       SD_TIMEOUT, SD_MAX_RETRIES);
+
+	if (res) {
+		printk(KERN_WARNING "sd stop failed: status = %x, message = %02x, "
+				    "host = %d, driver = %02x\n",
+				    status_byte(res), msg_byte(res),
+				    host_byte(res), driver_byte(res));
+		if (driver_byte(res) & DRIVER_SENSE)
+			scsi_print_sense_hdr("sd", &sshdr);
+	}
+
+	return res;
+}
+
+
 static int sd_issue_flush(struct device *dev, sector_t *error_sector)
 {
 	int ret = 0;
@@ -1727,11 +1760,13 @@ static int sd_probe(struct device *dev)
  **/
 static int sd_remove(struct device *dev)
 {
+	struct scsi_device *sdp = to_scsi_device(dev);
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
 	class_device_del(&sdkp->cdev);
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
+	sd_stop_unit(sdp,sdkp);
 
 	mutex_lock(&sd_ref_mutex);
 	dev_set_drvdata(dev, NULL);
@@ -1784,6 +1819,9 @@ static void sd_shutdown(struct device *d
 				sdkp->disk->disk_name);
 		sd_sync_cache(sdp);
 	}
+	if(system_state == SYSTEM_POWER_OFF)
+		sd_stop_unit(sdp,sdkp);
+
 	scsi_disk_put(sdkp);
 }
 
_

Patches currently in -mm which might be from hancockr@shaw.ca are

git-libata-all.patch
sata_nv-cleanup-adma-error-handling-v2.patch
sata_nv-cleanup-adma-error-handling-v2-cleanup.patch
sata_nv-use-adma-for-nodata-commands.patch
libata-fix-translation-for-start-stop-unit.patch
sd-spin-down-disks-on-removal-or-power-down.patch
