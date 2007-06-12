From: akpm@linux-foundation.org
Subject: + pata_it821x-partially-fix-dma-in-raid-mode.patch added to -mm tree
Date: Tue, 12 Jun 2007 12:14:40 -0700
Message-ID: <200706121914.l5CJEfu2018985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53244 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751406AbXFLTPA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:15:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bzolnier@gmail.com, alan@redhat.com, htejun@gmail.com


The patch titled
     pata_it821x: (partially) fix DMA in RAID mode
has been added to the -mm tree.  Its filename is
     pata_it821x-partially-fix-dma-in-raid-mode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_it821x: (partially) fix DMA in RAID mode
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Code intended to check DMA status was checking DMA command register.

Moreover firmware seems to "forget" to set DMA capable bit for the slave
device (at least in RAID mode but without ITE RAID volumes) so check device
ID for DMA capable bit when deciding whether to use DMA and remove DMA
status check completely.

Thanks to Pavol Simo for the bugreport and testing the initial fix.

This change unfortunately still doesn't fix DMA in RAID mode (which works
fine with IDE it821x) but Alan is working on the missing pieces
(pata_it821x vs libata EH issues).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_it821x.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/ata/pata_it821x.c~pata_it821x-partially-fix-dma-in-raid-mode drivers/ata/pata_it821x.c
--- a/drivers/ata/pata_it821x.c~pata_it821x-partially-fix-dma-in-raid-mode
+++ a/drivers/ata/pata_it821x.c
@@ -2,6 +2,7 @@
  * pata_it821x.c 	- IT821x PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
  *			  Alan Cox <alan@redhat.com>
+ *			  (C) 2007 Bartlomiej Zolnierkiewicz
  *
  * based upon
  *
@@ -79,7 +80,7 @@
 
 
 #define DRV_NAME "pata_it821x"
-#define DRV_VERSION "0.3.6"
+#define DRV_VERSION "0.3.7"
 
 struct it821x_dev
 {
@@ -460,14 +461,8 @@ static unsigned int it821x_passthru_qc_i
 
 static int it821x_smart_set_mode(struct ata_port *ap, struct ata_device **unused)
 {
-	int dma_enabled = 0;
 	int i;
 
-	/* Bits 5 and 6 indicate if DMA is active on master/slave */
-	/* It is possible that BMDMA isn't allocated */
-	if (ap->ioaddr.bmdma_addr)
-		dma_enabled = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-
 	for (i = 0; i < ATA_MAX_DEVICES; i++) {
 		struct ata_device *dev = &ap->device[i];
 		if (ata_dev_enabled(dev)) {
@@ -476,7 +471,7 @@ static int it821x_smart_set_mode(struct 
 			dev->dma_mode = XFER_MW_DMA_0;
 			/* We do need the right mode information for DMA or PIO
 			   and this comes from the current configuration flags */
-			if (dma_enabled & (1 << (5 + i))) {
+			if (ata_id_has_dma(dev->id)) {
 				ata_dev_printk(dev, KERN_INFO, "configured for DMA\n");
 				dev->xfer_mode = XFER_MW_DMA_0;
 				dev->xfer_shift = ATA_SHIFT_MWDMA;
_

Patches currently in -mm which might be from bzolnier@gmail.com are

origin.patch
pata_it821x-partially-fix-dma-in-raid-mode.patch
fix-ide-ide-hpa-detect-from-resume.patch
ide_scan_pcibus-cehck-__pci_register_driver-return-value.patch
fix-jvc-cdrom-drive-lockup.patch
use-no_pci_devices-in-pci-searchc.patch
