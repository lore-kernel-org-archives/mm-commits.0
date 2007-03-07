From: akpm@linux-foundation.org
Subject: - libata-warn-if-speed-limited-due-to-40-wire-cable-v2.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:22:30 -0800
Message-ID: <200703070422.l274MUtA018994@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47142 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbXCGEWh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:22:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hancockr@shaw.ca, alan@lxorguk.ukuu.org.uk, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     libata: warn if speed limited due to 40-wire cable
has been removed from the -mm tree.  Its filename was
     libata-warn-if-speed-limited-due-to-40-wire-cable-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: warn if speed limited due to 40-wire cable
From: Robert Hancock <hancockr@shaw.ca>

Warn the user if a drive's transfer rate is limited because of a 40-wire
cable detection.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-warn-if-speed-limited-due-to-40-wire-cable-v2 drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-warn-if-speed-limited-due-to-40-wire-cable-v2
+++ a/drivers/ata/libata-core.c
@@ -3405,19 +3405,7 @@ static void ata_dev_xfermask(struct ata_
 	xfer_mask = ata_pack_xfermask(ap->pio_mask,
 				      ap->mwdma_mask, ap->udma_mask);
 
-	/* Apply cable rule here.  Don't apply it early because when
-	 * we handle hot plug the cable type can itself change.
-	 */
-	if (ap->cbl == ATA_CBL_PATA40)
-		xfer_mask &= ~(0xF8 << ATA_SHIFT_UDMA);
-	/* Apply drive side cable rule. Unknown or 80 pin cables reported
-	 * host side are checked drive side as well. Cases where we know a
-	 * 40wire cable is used safely for 80 are not checked here.
-	 */
-        if (ata_drive_40wire(dev->id) && (ap->cbl == ATA_CBL_PATA_UNK || ap->cbl == ATA_CBL_PATA80))
-		xfer_mask &= ~(0xF8 << ATA_SHIFT_UDMA);
-
-
+	/* drive modes available */
 	xfer_mask &= ata_pack_xfermask(dev->pio_mask,
 				       dev->mwdma_mask, dev->udma_mask);
 	xfer_mask &= ata_id_xfermask(dev->id);
@@ -3448,6 +3436,25 @@ static void ata_dev_xfermask(struct ata_
 	if (ap->ops->mode_filter)
 		xfer_mask = ap->ops->mode_filter(ap, dev, xfer_mask);
 
+	/* Apply cable rule here.  Don't apply it early because when
+	 * we handle hot plug the cable type can itself change.
+	 * Check this last so that we know if the transfer rate was
+	 * solely limited by the cable.
+	 * Unknown or 80 wire cables reported host side are checked
+	 * drive side as well. Cases where we know a 40wire cable
+	 * is used safely for 80 are not checked here.
+	 */
+	if (xfer_mask & (0xF8 << ATA_SHIFT_UDMA))
+		/* UDMA/44 or higher would be available */
+		if((ap->cbl == ATA_CBL_PATA40) ||
+   		    (ata_drive_40wire(dev->id) &&
+		     (ap->cbl == ATA_CBL_PATA_UNK ||
+                     ap->cbl == ATA_CBL_PATA80))) {
+		      	ata_dev_printk(dev, KERN_WARNING,
+				 "limited to UDMA/33 due to 40-wire cable\n");
+			xfer_mask &= ~(0xF8 << ATA_SHIFT_UDMA);
+		}
+
 	ata_unpack_xfermask(xfer_mask, &dev->pio_mask,
 			    &dev->mwdma_mask, &dev->udma_mask);
 }
_

Patches currently in -mm which might be from hancockr@shaw.ca are

git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
sata_nv-dont-read-shadow-registers-when-in-adma-mode.patch
