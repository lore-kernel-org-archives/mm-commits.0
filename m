From: akpm@osdl.org
Subject: - sata_promise-atapi-cleanup.patch removed from -mm tree
Date: Mon, 22 Jan 2007 12:29:07 -0800
Message-ID: <200701222029.l0MKT8N6001008@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48970 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbXAVU3T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 15:29:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikpe@it.uu.se, mm-commits@vger.kernel.org


The patch titled
     sata_promise: ATAPI cleanup
has been removed from the -mm tree.  Its filename was
     sata_promise-atapi-cleanup.patch

This patch was dropped because of rejects

------------------------------------------------------
Subject: sata_promise: ATAPI cleanup
From: Mikael Pettersson <mikpe@it.uu.se>

Here's a cleanup for yesterday's sata_promise ATAPI patch:
- add and use a symbolic constant for the altstatus register
- check return status from ata_busy_wait()
- add missing newline in a warning printk()
- update comment in pdc_issue_atapi_pkt_cmd() to clarify
  that the maybe-wait-for-INT issue cannot occur in the
  current driver, but may occur if the driver starts issuing
  ATAPI non-DMA commands as PDC packets

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/sata_promise.c |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff -puN drivers/ata/sata_promise.c~sata_promise-atapi-cleanup drivers/ata/sata_promise.c
--- a/drivers/ata/sata_promise.c~sata_promise-atapi-cleanup
+++ a/drivers/ata/sata_promise.c
@@ -59,6 +59,7 @@ enum {
 	PDC_CYLINDER_HIGH	= 0x14, /* Cylinder high reg (per port) */
 	PDC_DEVICE		= 0x18, /* Device/Head reg (per port) */
 	PDC_COMMAND		= 0x1C, /* Command/status reg (per port) */
+	PDC_ALTSTATUS		= 0x38, /* Alternate-status/device-control reg (per port) */
 	PDC_PKT_SUBMIT		= 0x40, /* Command packet pointer addr */
 	PDC_INT_SEQMASK		= 0x40,	/* Mask of asserted SEQ INTs */
 	PDC_FLASH_CTL		= 0x44, /* Flash control register */
@@ -728,7 +729,7 @@ static unsigned int pdc_wait_for_drq(str
 	 * know when to time out the outer loop.
 	 */
 	for(i = 0; i < 1000; ++i) {
-		status = readb(port_mmio + 0x38); /* altstatus */
+		status = readb(port_mmio + PDC_ALTSTATUS);
 		if (status == 0xFF)
 			break;
 		if (status & ATA_BUSY)
@@ -738,7 +739,15 @@ static unsigned int pdc_wait_for_drq(str
 		mdelay(1);
 	}
 	if (i >= 1000)
-		ata_port_printk(ap, KERN_WARNING, "%s timed out", __FUNCTION__);
+		ata_port_printk(ap, KERN_WARNING, "%s timed out\n", __FUNCTION__);
+	return status;
+}
+
+static unsigned int pdc_wait_on_busy(struct ata_port *ap)
+{
+	unsigned int status = ata_busy_wait(ap, ATA_BUSY, 1000);
+	if (status != 0xff && (status & ATA_BUSY))
+		ata_port_printk(ap, KERN_WARNING, "%s timed out\n", __FUNCTION__);
 	return status;
 }
 
@@ -762,7 +771,7 @@ static void pdc_issue_atapi_pkt_cmd(stru
 			tmp |= ATA_DEV1;
 	}
 	writeb(tmp, port_mmio + PDC_DEVICE);
-	ata_busy_wait(ap, ATA_BUSY, 1000);
+	pdc_wait_on_busy(ap);
 
 	writeb(0x00, port_mmio + PDC_SECTOR_COUNT);
 	writeb(0x00, port_mmio + PDC_SECTOR_NUMBER);
@@ -788,14 +797,10 @@ static void pdc_issue_atapi_pkt_cmd(stru
 	/* send ATAPI packet command 0xA0 */
 	writeb(ATA_CMD_PACKET, port_mmio + PDC_COMMAND);
 
-	/*
-	 * At this point in the issuing of a packet command, the Promise
-	 * driver busy-waits for INT (CTLSTAT bit 27) if it detected
-	 * (at port init time) that the device interrupts with assertion
-	 * of DRQ after receiving a packet command.
-	 *
-	 * XXX: Do we need to handle this case as well? Does libata detect
-	 * this case for us, or do we have to do our own per-port init?
+	/* pdc_qc_issue_prot() currently sends ATAPI PIO packets back
+	 * to libata. If we start handling those packets ourselves,
+	 * then we must busy-wait for INT (CTLSTAT bit 27) at this point
+	 * if the device has ATA_DFLAG_CDB_INTR set.
 	 */
 
 	pdc_wait_for_drq(ap);
_

Patches currently in -mm which might be from mikpe@it.uu.se are

git-libata-all.patch
sata_promise-atapi-cleanup.patch
git-net.patch
