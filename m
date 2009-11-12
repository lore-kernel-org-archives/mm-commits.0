From: akpm@linux-foundation.org
Subject: + hpsa-make-fill_cmd-return-void.patch added to -mm tree
Date: Thu, 12 Nov 2009 14:53:54 -0800
Message-ID: <200911122253.nACMrsoG006897@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754565AbZKLW6P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 17:58:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com


The patch titled
     hpsa:  Make fill_cmd() return void
has been added to the -mm tree.  Its filename is
     hpsa-make-fill_cmd-return-void.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpsa:  Make fill_cmd() return void
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

hpsa:  Make fill_cmd() return void, and BUG() if it is asked to
fill out an unknown command or command type, as that should simply
not happen as all the commands and command types are fixed, and
known ahead of time.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |   73 ++++++++++++++----------------------------
 1 file changed, 25 insertions(+), 48 deletions(-)

diff -puN drivers/scsi/hpsa.c~hpsa-make-fill_cmd-return-void drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-make-fill_cmd-return-void
+++ a/drivers/scsi/hpsa.c
@@ -126,7 +126,7 @@ static void cmd_free(struct ctlr_info *h
 static void cmd_special_free(struct ctlr_info *h, struct CommandList *c);
 static struct CommandList *cmd_alloc(struct ctlr_info *h);
 static struct CommandList *cmd_special_alloc(struct ctlr_info *h);
-static int fill_cmd(struct CommandList *c, __u8 cmd, struct ctlr_info *h,
+static void fill_cmd(struct CommandList *c, __u8 cmd, struct ctlr_info *h,
 	void *buff, size_t size, __u8 page_code, unsigned char *scsi3addr,
 	int cmd_type);
 
@@ -1258,7 +1258,7 @@ static int hpsa_scsi_do_inquiry(struct c
 			unsigned char page, unsigned char *buf,
 			unsigned char bufsize)
 {
-	int rc;
+	int rc = IO_OK;
 	struct CommandList *c;
 	struct ErrorInfo *ei;
 
@@ -1269,16 +1269,12 @@ static int hpsa_scsi_do_inquiry(struct c
 		return -1;
 	}
 
-	rc = fill_cmd(c, HPSA_INQUIRY, h, buf, bufsize, page, scsi3addr,
-		TYPE_CMD);
-	if (rc == 0) {
-		hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE);
-		ei = c->err_info;
-		if (ei->CommandStatus != 0 &&
-		    ei->CommandStatus != CMD_DATA_UNDERRUN) {
-			hpsa_scsi_interpret_error(c);
-			rc = -1;
-		}
+	fill_cmd(c, HPSA_INQUIRY, h, buf, bufsize, page, scsi3addr, TYPE_CMD);
+	hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE);
+	ei = c->err_info;
+	if (ei->CommandStatus != 0 && ei->CommandStatus != CMD_DATA_UNDERRUN) {
+		hpsa_scsi_interpret_error(c);
+		rc = -1;
 	}
 	cmd_special_free(h, c);
 	return rc;
@@ -1286,7 +1282,7 @@ static int hpsa_scsi_do_inquiry(struct c
 
 static int hpsa_send_reset(struct ctlr_info *h, unsigned char *scsi3addr)
 {
-	int rc;
+	int rc = IO_OK;
 	struct CommandList *c;
 	struct ErrorInfo *ei;
 
@@ -1297,11 +1293,7 @@ static int hpsa_send_reset(struct ctlr_i
 		return -1;
 	}
 
-	rc = fill_cmd(c, HPSA_DEVICE_RESET_MSG, h, NULL, 0, 0, scsi3addr,
-		TYPE_MSG);
-	if (rc != 0)
-		goto out;
-
+	fill_cmd(c, HPSA_DEVICE_RESET_MSG, h, NULL, 0, 0, scsi3addr, TYPE_MSG);
 	hpsa_scsi_do_simple_cmd_core(h, c);
 	/* no unmap needed here because no data xfer. */
 
@@ -1310,7 +1302,6 @@ static int hpsa_send_reset(struct ctlr_i
 		hpsa_scsi_interpret_error(c);
 		rc = -1;
 	}
-out:
 	cmd_special_free(h, c);
 	return rc;
 }
@@ -1357,7 +1348,7 @@ static int hpsa_scsi_do_report_luns(stru
 		struct ReportLUNdata *buf, int bufsize,
 		int extended_response)
 {
-	int rc;
+	int rc = IO_OK;
 	struct CommandList *c;
 	unsigned char scsi3addr[8];
 	struct ErrorInfo *ei;
@@ -1370,11 +1361,8 @@ static int hpsa_scsi_do_report_luns(stru
 
 	memset(&scsi3addr[0], 0, 8); /* address the controller */
 
-	rc = fill_cmd(c, logical ? HPSA_REPORT_LOG : HPSA_REPORT_PHYS, h,
+	fill_cmd(c, logical ? HPSA_REPORT_LOG : HPSA_REPORT_PHYS, h,
 		buf, bufsize, 0, scsi3addr, TYPE_CMD);
-	if (rc != 0)
-		goto out;
-
 	if (extended_response)
 		c->Request.CDB[1] = extended_response;
 	hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE);
@@ -1384,7 +1372,6 @@ static int hpsa_scsi_do_report_luns(stru
 		hpsa_scsi_interpret_error(c);
 		rc = -1;
 	}
-out:
 	cmd_special_free(h, c);
 	return rc;
 }
@@ -1944,7 +1931,7 @@ static int hpsa_register_scsi(struct ctl
 static int wait_for_device_to_become_ready(struct ctlr_info *h,
 	unsigned char lunaddr[])
 {
-	int rc;
+	int rc = 0;
 	int count = 0;
 	int waittime = HZ;
 	struct CommandList *c;
@@ -1971,15 +1958,7 @@ static int wait_for_device_to_become_rea
 			waittime = waittime * 2;
 
 		/* Send the Test Unit Ready */
-		rc = fill_cmd(c, TEST_UNIT_READY, h, NULL, 0, 0,
-			lunaddr, TYPE_CMD);
-		if (rc != 0) {
-			/* We don't expect to get in here */
-			dev_warn(&h->pdev->dev, "fill_cmd failed at %s:%d\n",
-				__FILE__, __LINE__);
-			break;
-		}
-
+		fill_cmd(c, TEST_UNIT_READY, h, NULL, 0, 0, lunaddr, TYPE_CMD);
 		hpsa_scsi_do_simple_cmd_core(h, c);
 		/* no unmap needed here because no data xfer. */
 
@@ -2558,7 +2537,7 @@ static int hpsa_ioctl(struct scsi_device
 	}
 }
 
-static int fill_cmd(struct CommandList *c, __u8 cmd, struct ctlr_info *h,
+static void fill_cmd(struct CommandList *c, __u8 cmd, struct ctlr_info *h,
 	void *buff, size_t size, __u8 page_code, unsigned char *scsi3addr,
 	int cmd_type)
 {
@@ -2631,7 +2610,8 @@ static int fill_cmd(struct CommandList *
 			break;
 		default:
 			dev_warn(&h->pdev->dev, "unknown command 0x%c\n", cmd);
-			return IO_ERROR;
+			BUG();
+			return;
 		}
 	} else if (cmd_type == TYPE_MSG) {
 		switch (cmd) {
@@ -2655,11 +2635,11 @@ static int fill_cmd(struct CommandList *
 		default:
 			dev_warn(&h->pdev->dev, "unknown message type %d\n",
 				cmd);
-			return IO_ERROR;
+			BUG();
 		}
 	} else {
 		dev_warn(&h->pdev->dev, "unknown command type %d\n", cmd_type);
-		return IO_ERROR;
+		BUG();
 	}
 
 	switch (c->Request.Type.Direction) {
@@ -2678,7 +2658,7 @@ static int fill_cmd(struct CommandList *
 
 	hpsa_map_one(h->pdev, c, buff, size, pci_dir);
 
-	return IO_OK;
+	return;
 }
 
 /*
@@ -3429,7 +3409,6 @@ static void hpsa_flush_cache(struct ctlr
 {
 	char *flush_buf;
 	struct CommandList *c;
-	int rc;
 
 	flush_buf = kzalloc(4, GFP_KERNEL);
 	if (!flush_buf)
@@ -3440,14 +3419,12 @@ static void hpsa_flush_cache(struct ctlr
 		dev_warn(&h->pdev->dev, "cmd_special_alloc returned NULL!\n");
 		goto out_of_memory;
 	}
-	rc = fill_cmd(c, HPSA_CACHE_FLUSH, h, flush_buf, 4, 0,
+	fill_cmd(c, HPSA_CACHE_FLUSH, h, flush_buf, 4, 0,
 		RAID_CTLR_LUNID, TYPE_CMD);
-	if (rc == 0) {
-		hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_TODEVICE);
-		if (c->err_info->CommandStatus != 0)
-			dev_warn(&h->pdev->dev,
-				"error flushing cache on controller\n");
-	}
+	hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_TODEVICE);
+	if (c->err_info->CommandStatus != 0)
+		dev_warn(&h->pdev->dev,
+			"error flushing cache on controller\n");
 	cmd_special_free(h, c);
 out_of_memory:
 	kfree(flush_buf);
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix-hpsa_allow_any-test-for-vendor-id.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
hpsa-fix-use-of-unallocated-memory-for-msa2xxx-enclosure-device-data.patch
hpsa-allocate-the-correct-amount-of-extra-space-for-the-scsi-host.patch
hpsa-use-shost_priv-instead-of-accessing-host-hostdata-directly.patch
hpsa-factor-out-command-submission-sequence.patch
hpsa-factor-out-some-pci_unmap-code.patch
add-thread-to-allow-controllers-to-register-for-rescan-for-new-devices.patch
hpsa-allow-device-rescan-to-be-triggered-via-sysfs.patch
hpsa-make-hpsa_sdev_attrs-static.patch
hpsa-decode-unit-attention-condition-and-retry-commands.patch
hpsa-retry-driver-initiated-commands-on-unit-attention.patch
hpsa-flush-cache-with-interrupts-still-enabled.patch
hpsa-remove-sendcmd-in-no-case-are-we-required-to-poll-for-completions.patch
hpsa-make-fill_cmd-return-void.patch
hpsa-fix-typo-that-causes-scsi-status-to-be-lost.patch

