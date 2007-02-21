From: akpm@linux-foundation.org
Subject: + libata-warn-if-speed-limited-due-to-40-wire-cable-v2.patch added to -mm tree
Date: Wed, 21 Feb 2007 14:27:32 -0800
Message-ID: <200702212227.l1LMRWVm028382@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52964 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423203AbXBUW1m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 17:27:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hancockr@shaw.ca, alan@lxorguk.ukuu.org.uk, jeff@garzik.org


The patch titled
     libata: warn if speed limited due to 40-wire cable
has been added to the -mm tree.  Its filename is
     libata-warn-if-speed-limited-due-to-40-wire-cable-v2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 20 insertions(+), 13 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-warn-if-speed-limited-due-to-40-wire-cable-v2 drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-warn-if-speed-limited-due-to-40-wire-cable-v2
+++ a/drivers/ata/libata-core.c
@@ -3366,19 +3366,7 @@ static void ata_dev_xfermask(struct ata_
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
@@ -3409,6 +3397,25 @@ static void ata_dev_xfermask(struct ata_
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
libata-warn-if-speed-limited-due-to-40-wire-cable-v2.patch
