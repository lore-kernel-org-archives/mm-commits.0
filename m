From: akpm@linux-foundation.org
Subject: - libata-warn-if-speed-limited-due-to-40-wire-cable.patch removed from -mm tree
Date: Tue, 13 Feb 2007 09:26:52 -0800
Message-ID: <200702131726.l1DHQsnQ003988@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45136 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbXBMR1h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 12:27:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hancockr@shaw.ca, alan@lxorguk.ukuu.org.uk, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     libata: warn if speed limited due to 40-wire cable
has been removed from the -mm tree.  Its filename was
     libata-warn-if-speed-limited-due-to-40-wire-cable.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: libata: warn if speed limited due to 40-wire cable
From: Robert Hancock <hancockr@shaw.ca>

Print an explicit warning when a device's UDMA mode is limited due to a
40-wire cable being detected, so that users have some idea why their device
isn't running as fast as it should.

This moves the application of the drive's mode masks before the cable rule,
so that can tell whether the rate is being limited by the cable and not the
drive or controller.

I haven't tested whether the message actually shows up, as my system isn't
horked in this manner..

Signed-off-by: Robert Hancock <hancockr@shaw.ca>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-warn-if-speed-limited-due-to-40-wire-cable drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-warn-if-speed-limited-due-to-40-wire-cable
+++ a/drivers/ata/libata-core.c
@@ -3319,22 +3319,24 @@ static void ata_dev_xfermask(struct ata_
 	xfer_mask = ata_pack_xfermask(ap->pio_mask,
 				      ap->mwdma_mask, ap->udma_mask);
 
+	/* drive modes available */
+	xfer_mask &= ata_pack_xfermask(dev->pio_mask,
+				       dev->mwdma_mask, dev->udma_mask);
+	xfer_mask &= ata_id_xfermask(dev->id);
+
 	/* Apply cable rule here.  Don't apply it early because when
 	 * we handle hot plug the cable type can itself change.
+	 * Unknown or 80 wire cables reported host side are checked
+	 * drive side as well. Cases where we know a 40wire cable
+	 * is used safely for 80 are not checked here.
 	 */
-	if (ap->cbl == ATA_CBL_PATA40)
-		xfer_mask &= ~(0xF8 << ATA_SHIFT_UDMA);
-	/* Apply drive side cable rule. Unknown or 80 pin cables reported
-	 * host side are checked drive side as well. Cases where we know a
-	 * 40wire cable is used safely for 80 are not checked here.
-	 */
-        if (ata_drive_40wire(dev->id) && (ap->cbl == ATA_CBL_PATA_UNK || ap->cbl == ATA_CBL_PATA80))
+	if ((xfer_mask & (0xF8 << ATA_SHIFT_UDMA)) &&
+	    ((ap->cbl == ATA_CBL_PATA40) ||
+	     (ata_drive_40wire(dev->id) &&
+	      (ap->cbl == ATA_CBL_PATA_UNK || ap->cbl == ATA_CBL_PATA80)))) {
+	      	ata_dev_printk(dev, KERN_WARNING, "limited to UDMA2 due to 40-wire cable\n");
 		xfer_mask &= ~(0xF8 << ATA_SHIFT_UDMA);
-
-
-	xfer_mask &= ata_pack_xfermask(dev->pio_mask,
-				       dev->mwdma_mask, dev->udma_mask);
-	xfer_mask &= ata_id_xfermask(dev->id);
+	}
 
 	/*
 	 *	CFA Advanced TrueIDE timings are not allowed on a shared
_

Patches currently in -mm which might be from hancockr@shaw.ca are

origin.patch
libata-warn-if-speed-limited-due-to-40-wire-cable.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy.patch
sata_nv-handle-serror-status-indication.patch
