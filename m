From: akpm@linux-foundation.org
Subject: + cciss-fix-cciss-scsi-rescan-code-to-better-notice-device-changes.patch added to -mm tree
Date: Fri, 19 Sep 2008 17:19:39 -0700
Message-ID: <200809200019.m8K0JdwR014597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752455AbYITAUD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Sep 2008 20:20:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cca.cpqcorp.net, jens.axboe@oracle.com, mike.miller@hp.com


The patch titled
     cciss: fix cciss SCSI rescan code to better notice device changes.
has been added to the -mm tree.  Its filename is
     cciss-fix-cciss-scsi-rescan-code-to-better-notice-device-changes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: fix cciss SCSI rescan code to better notice device changes.
From: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>

Fix cciss SCSI rescan code to better notice device changes.  If you
hot-unplug a tape drive, then hot-plug a different tape drive into the
same slot in a storage enclosure, the cciss driver wouldn't notice
anything had changed, as it was only looking at the LUN address and device
type.  Now it looks at the inquiry page 0x83 device identifier, and vendor
and model strings as well.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
Cc: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss_scsi.c |  149 ++++++++++++++++++++++-------------
 drivers/block/cciss_scsi.h |    4 
 2 files changed, 101 insertions(+), 52 deletions(-)

diff -puN drivers/block/cciss_scsi.c~cciss-fix-cciss-scsi-rescan-code-to-better-notice-device-changes drivers/block/cciss_scsi.c
--- a/drivers/block/cciss_scsi.c~cciss-fix-cciss-scsi-rescan-code-to-better-notice-device-changes
+++ a/drivers/block/cciss_scsi.c
@@ -365,7 +365,7 @@ struct scsi2map {
 
 static int 
 cciss_scsi_add_entry(int ctlr, int hostno, 
-		unsigned char *scsi3addr, int devtype,
+		struct cciss_scsi_dev_t *device,
 		struct scsi2map *added, int *nadded)
 {
 	/* assumes hba[ctlr]->scsi_ctlr->lock is held */ 
@@ -384,12 +384,12 @@ cciss_scsi_add_entry(int ctlr, int hostn
 	lun = 0;
 	/* Is this device a non-zero lun of a multi-lun device */
 	/* byte 4 of the 8-byte LUN addr will contain the logical unit no. */
-	if (scsi3addr[4] != 0) {
+	if (device->scsi3addr[4] != 0) {
 		/* Search through our list and find the device which */
 		/* has the same 8 byte LUN address, excepting byte 4. */
 		/* Assign the same bus and target for this new LUN. */
 		/* Use the logical unit number from the firmware. */
-		memcpy(addr1, scsi3addr, 8);
+		memcpy(addr1, device->scsi3addr, 8);
 		addr1[4] = 0;
 		for (i = 0; i < n; i++) {
 			sd = &ccissscsi[ctlr].dev[i];
@@ -399,7 +399,7 @@ cciss_scsi_add_entry(int ctlr, int hostn
 			if (memcmp(addr1, addr2, 8) == 0) {
 				bus = sd->bus;
 				target = sd->target;
-				lun = scsi3addr[4];
+				lun = device->scsi3addr[4];
 				break;
 			}
 		}
@@ -420,8 +420,12 @@ cciss_scsi_add_entry(int ctlr, int hostn
 	added[*nadded].lun = sd->lun;
 	(*nadded)++;
 
-	memcpy(&sd->scsi3addr[0], scsi3addr, 8);
-	sd->devtype = devtype;
+	memcpy(sd->scsi3addr, device->scsi3addr, 8);
+	memcpy(sd->vendor, device->vendor, sizeof(sd->vendor));
+	memcpy(sd->revision, device->revision, sizeof(sd->revision));
+	memcpy(sd->device_id, device->device_id, sizeof(sd->device_id));
+	sd->devtype = device->devtype;
+
 	ccissscsi[ctlr].ndevices++;
 
 	/* initially, (before registering with scsi layer) we don't 
@@ -487,6 +491,22 @@ static void fixup_botched_add(int ctlr, 
 	CPQ_TAPE_UNLOCK(ctlr, flags);
 }
 
+static int device_is_the_same(struct cciss_scsi_dev_t *dev1,
+	struct cciss_scsi_dev_t *dev2)
+{
+	return dev1->devtype == dev2->devtype &&
+		memcmp(dev1->scsi3addr, dev2->scsi3addr,
+			sizeof(dev1->scsi3addr)) == 0 &&
+		memcmp(dev1->device_id, dev2->device_id,
+			sizeof(dev1->device_id)) == 0 &&
+		memcmp(dev1->vendor, dev2->vendor,
+			sizeof(dev1->vendor)) == 0 &&
+		memcmp(dev1->model, dev2->model,
+			sizeof(dev1->model)) == 0 &&
+		memcmp(dev1->revision, dev2->revision,
+			sizeof(dev1->revision)) == 0;
+}
+
 static int
 adjust_cciss_scsi_table(int ctlr, int hostno,
 	struct cciss_scsi_dev_t sd[], int nsds)
@@ -532,7 +552,7 @@ adjust_cciss_scsi_table(int ctlr, int ho
 		for (j=0;j<nsds;j++) {
 			if (SCSI3ADDR_EQ(sd[j].scsi3addr,
 				csd->scsi3addr)) {
-				if (sd[j].devtype == csd->devtype)
+				if (device_is_the_same(&sd[j], csd))
 					found=2;
 				else
 					found=1;
@@ -548,22 +568,26 @@ adjust_cciss_scsi_table(int ctlr, int ho
 			cciss_scsi_remove_entry(ctlr, hostno, i,
 				removed, &nremoved);
 			/* remove ^^^, hence i not incremented */
-		} 
-		else if (found == 1) { /* device is different kind */
+		} else if (found == 1) { /* device is different in some way */
 			changes++;
-			printk("cciss%d: device c%db%dt%dl%d type changed "
-				"(device type now %s).\n",
-				ctlr, hostno, csd->bus, csd->target, csd->lun,
-					scsi_device_type(csd->devtype));
+			printk("cciss%d: device c%db%dt%dl%d has changed.\n",
+				ctlr, hostno, csd->bus, csd->target, csd->lun);
 			cciss_scsi_remove_entry(ctlr, hostno, i,
 				removed, &nremoved);
 			/* remove ^^^, hence i not incremented */
-			if (cciss_scsi_add_entry(ctlr, hostno,
-				&sd[j].scsi3addr[0], sd[j].devtype,
+			if (cciss_scsi_add_entry(ctlr, hostno, &sd[j],
 				added, &nadded) != 0)
 				/* we just removed one, so add can't fail. */
 					BUG();
 			csd->devtype = sd[j].devtype;
+			memcpy(csd->device_id, sd[j].device_id,
+				sizeof(csd->device_id));
+			memcpy(csd->vendor, sd[j].vendor,
+				sizeof(csd->vendor));
+			memcpy(csd->model, sd[j].model,
+				sizeof(csd->model));
+			memcpy(csd->revision, sd[j].revision,
+				sizeof(csd->revision));
 		} else 		/* device is same as it ever was, */
 			i++;	/* so just move along. */
 	}
@@ -577,7 +601,7 @@ adjust_cciss_scsi_table(int ctlr, int ho
 			csd = &ccissscsi[ctlr].dev[j];
 			if (SCSI3ADDR_EQ(sd[i].scsi3addr,
 				csd->scsi3addr)) {
-				if (sd[i].devtype == csd->devtype)
+				if (device_is_the_same(&sd[i], csd))
 					found=2;	/* found device */
 				else
 					found=1; 	/* found a bug. */
@@ -586,16 +610,14 @@ adjust_cciss_scsi_table(int ctlr, int ho
 		}
 		if (!found) {
 			changes++;
-			if (cciss_scsi_add_entry(ctlr, hostno, 
-
-				&sd[i].scsi3addr[0], sd[i].devtype,
+			if (cciss_scsi_add_entry(ctlr, hostno, &sd[i],
 				added, &nadded) != 0)
 				break;
 		} else if (found == 1) {
 			/* should never happen... */
 			changes++;
-			printk("cciss%d: device unexpectedly changed type\n",
-				ctlr);
+			printk(KERN_WARNING "cciss%d: device "
+				"unexpectedly changed\n", ctlr);
 			/* but if it does happen, we just ignore that device */
 		}
 	}
@@ -1012,7 +1034,8 @@ cciss_scsi_interpret_error(CommandList_s
 
 static int
 cciss_scsi_do_inquiry(ctlr_info_t *c, unsigned char *scsi3addr, 
-		 unsigned char *buf, unsigned char bufsize)
+	unsigned char page, unsigned char *buf,
+	unsigned char bufsize)
 {
 	int rc;
 	CommandList_struct *cp;
@@ -1032,8 +1055,8 @@ cciss_scsi_do_inquiry(ctlr_info_t *c, un
 	ei = cp->err_info; 
 
 	cdb[0] = CISS_INQUIRY;
-	cdb[1] = 0;
-	cdb[2] = 0;
+	cdb[1] = (page != 0);
+	cdb[2] = page;
 	cdb[3] = 0;
 	cdb[4] = bufsize;
 	cdb[5] = 0;
@@ -1053,6 +1076,25 @@ cciss_scsi_do_inquiry(ctlr_info_t *c, un
 	return rc;	
 }
 
+/* Get the device id from inquiry page 0x83 */
+static int cciss_scsi_get_device_id(ctlr_info_t *c, unsigned char *scsi3addr,
+	unsigned char *device_id, int buflen)
+{
+	int rc;
+	unsigned char *buf;
+
+	if (buflen > 16)
+		buflen = 16;
+	buf = kzalloc(64, GFP_KERNEL);
+	if (!buf)
+		return -1;
+	rc = cciss_scsi_do_inquiry(c, scsi3addr, 0x83, buf, 64);
+	if (rc == 0)
+		memcpy(device_id, &buf[8], buflen);
+	kfree(buf);
+	return rc != 0;
+}
+
 static int
 cciss_scsi_do_report_phys_luns(ctlr_info_t *c, 
 		ReportLunData_struct *buf, int bufsize)
@@ -1142,25 +1184,21 @@ cciss_update_non_disk_devices(int cntl_n
 	ctlr_info_t *c;
 	__u32 num_luns=0;
 	unsigned char *ch;
-	/* unsigned char found[CCISS_MAX_SCSI_DEVS_PER_HBA]; */
-	struct cciss_scsi_dev_t currentsd[CCISS_MAX_SCSI_DEVS_PER_HBA];
+	struct cciss_scsi_dev_t *currentsd, *this_device;
 	int ncurrent=0;
 	int reportlunsize = sizeof(*ld_buff) + CISS_MAX_PHYS_LUN * 8;
 	int i;
 
 	c = (ctlr_info_t *) hba[cntl_num];	
 	ld_buff = kzalloc(reportlunsize, GFP_KERNEL);
-	if (ld_buff == NULL) {
-		printk(KERN_ERR "cciss: out of memory\n");
-		return;
-	}
 	inq_buff = kmalloc(OBDR_TAPE_INQ_SIZE, GFP_KERNEL);
-        if (inq_buff == NULL) {
-                printk(KERN_ERR "cciss: out of memory\n");
-                kfree(ld_buff);
-                return;
+	currentsd = kzalloc(sizeof(*currentsd) *
+			(CCISS_MAX_SCSI_DEVS_PER_HBA+1), GFP_KERNEL);
+	if (ld_buff == NULL || inq_buff == NULL || currentsd == NULL) {
+		printk(KERN_ERR "cciss: out of memory\n");
+		goto out;
 	}
-
+	this_device = &currentsd[CCISS_MAX_SCSI_DEVS_PER_HBA];
 	if (cciss_scsi_do_report_phys_luns(c, ld_buff, reportlunsize) == 0) {
 		ch = &ld_buff->LUNListLength[0];
 		num_luns = ((ch[0]<<24) | (ch[1]<<16) | (ch[2]<<8) | ch[3]) / 8;
@@ -1179,23 +1217,34 @@ cciss_update_non_disk_devices(int cntl_n
 
 
 	/* adjust our table of devices */	
-	for(i=0; i<num_luns; i++)
-	{
-		int devtype;
-
+	for (i = 0; i < num_luns; i++) {
 		/* for each physical lun, do an inquiry */
 		if (ld_buff->LUN[i][3] & 0xC0) continue;
 		memset(inq_buff, 0, OBDR_TAPE_INQ_SIZE);
 		memcpy(&scsi3addr[0], &ld_buff->LUN[i][0], 8);
 
-		if (cciss_scsi_do_inquiry(hba[cntl_num], scsi3addr, inq_buff,
-			(unsigned char) OBDR_TAPE_INQ_SIZE) != 0) {
+		if (cciss_scsi_do_inquiry(hba[cntl_num], scsi3addr, 0, inq_buff,
+			(unsigned char) OBDR_TAPE_INQ_SIZE) != 0)
 			/* Inquiry failed (msg printed already) */
-			devtype = 0; /* so we will skip this device. */
-		} else /* what kind of device is this? */
-			devtype = (inq_buff[0] & 0x1f);
+			continue; /* so we will skip this device. */
+
+		this_device->devtype = (inq_buff[0] & 0x1f);
+		this_device->bus = -1;
+		this_device->target = -1;
+		this_device->lun = -1;
+		memcpy(this_device->scsi3addr, scsi3addr, 8);
+		memcpy(this_device->vendor, &inq_buff[8],
+			sizeof(this_device->vendor));
+		memcpy(this_device->model, &inq_buff[16],
+			sizeof(this_device->model));
+		memcpy(this_device->revision, &inq_buff[32],
+			sizeof(this_device->revision));
+		memset(this_device->device_id, 0,
+			sizeof(this_device->device_id));
+		cciss_scsi_get_device_id(hba[cntl_num], scsi3addr,
+			this_device->device_id, sizeof(this_device->device_id));
 
-		switch (devtype)
+		switch (this_device->devtype)
 		{
 		  case 0x05: /* CD-ROM */ {
 
@@ -1220,15 +1269,10 @@ cciss_update_non_disk_devices(int cntl_n
 			if (ncurrent >= CCISS_MAX_SCSI_DEVS_PER_HBA) {
 				printk(KERN_INFO "cciss%d: %s ignored, "
 					"too many devices.\n", cntl_num,
-					scsi_device_type(devtype));
+					scsi_device_type(this_device->devtype));
 				break;
 			}
-			memcpy(&currentsd[ncurrent].scsi3addr[0], 
-				&scsi3addr[0], 8);
-			currentsd[ncurrent].devtype = devtype;
-			currentsd[ncurrent].bus = -1;
-			currentsd[ncurrent].target = -1;
-			currentsd[ncurrent].lun = -1;
+			currentsd[ncurrent] = *this_device;
 			ncurrent++;
 			break;
 		  default: 
@@ -1240,6 +1284,7 @@ cciss_update_non_disk_devices(int cntl_n
 out:
 	kfree(inq_buff);
 	kfree(ld_buff);
+	kfree(currentsd);
 	return;
 }
 
diff -puN drivers/block/cciss_scsi.h~cciss-fix-cciss-scsi-rescan-code-to-better-notice-device-changes drivers/block/cciss_scsi.h
--- a/drivers/block/cciss_scsi.h~cciss-fix-cciss-scsi-rescan-code-to-better-notice-device-changes
+++ a/drivers/block/cciss_scsi.h
@@ -66,6 +66,10 @@ struct cciss_scsi_dev_t {
 	int devtype;
 	int bus, target, lun;		/* as presented to the OS */
 	unsigned char scsi3addr[8];	/* as presented to the HW */
+	unsigned char device_id[16];	/* from inquiry pg. 0x83 */
+	unsigned char vendor[8];	/* bytes 8-15 of inquiry data */
+	unsigned char model[16];	/* bytes 16-31 of inquiry data */
+	unsigned char revision[4];	/* bytes 32-35 of inquiry data */
 };
 
 struct cciss_scsi_hba_t {
_

Patches currently in -mm which might be from scameron@beardog.cca.cpqcorp.net are

cciss-fix-cciss-scsi-rescan-code-to-better-notice-device-changes.patch

