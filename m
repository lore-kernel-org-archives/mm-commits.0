From: akpm@linux-foundation.org
Subject: + libata-use-new-id_to_dma_mode-function-to-tidy-reporting.patch added to -mm tree
Date: Wed, 21 Feb 2007 16:31:11 -0800
Message-ID: <200702220031.l1M0VBpI031329@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59519 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965114AbXBVAb3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 19:31:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     libata: Use new id_to_dma_mode function to tidy reporting  in more drivers (minimally tested)
has been added to the -mm tree.  Its filename is
     libata-use-new-id_to_dma_mode-function-to-tidy-reporting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: Use new id_to_dma_mode function to tidy reporting  in more drivers (minimally tested)
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ata_generic.c |    4 ++--
 drivers/ata/pata_it821x.c |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/ata/ata_generic.c~libata-use-new-id_to_dma_mode-function-to-tidy-reporting drivers/ata/ata_generic.c
--- a/drivers/ata/ata_generic.c~libata-use-new-id_to_dma_mode-function-to-tidy-reporting
+++ a/drivers/ata/ata_generic.c
@@ -90,10 +90,10 @@ static int generic_set_mode(struct ata_p
 			/* We do need the right mode information for DMA or PIO
 			   and this comes from the current configuration flags */
 			if (dma_enabled & (1 << (5 + i))) {
-				dev->xfer_mode = XFER_MW_DMA_0;
-				dev->xfer_shift = ATA_SHIFT_MWDMA;
+				ata_id_to_dma_mode(dev, XFER_MW_DMA_0);
 				dev->flags &= ~ATA_DFLAG_PIO;
 			} else {
+				ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
 				dev->xfer_mode = XFER_PIO_0;
 				dev->xfer_shift = ATA_SHIFT_PIO;
 				dev->flags |= ATA_DFLAG_PIO;
diff -puN drivers/ata/pata_it821x.c~libata-use-new-id_to_dma_mode-function-to-tidy-reporting drivers/ata/pata_it821x.c
--- a/drivers/ata/pata_it821x.c~libata-use-new-id_to_dma_mode-function-to-tidy-reporting
+++ a/drivers/ata/pata_it821x.c
@@ -503,10 +503,12 @@ static int it821x_smart_set_mode(struct 
 			/* We do need the right mode information for DMA or PIO
 			   and this comes from the current configuration flags */
 			if (dma_enabled & (1 << (5 + i))) {
+				ata_dev_printk(dev, KERN_INFO, "configured for DMA\n");
 				dev->xfer_mode = XFER_MW_DMA_0;
 				dev->xfer_shift = ATA_SHIFT_MWDMA;
 				dev->flags &= ~ATA_DFLAG_PIO;
 			} else {
+				ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
 				dev->xfer_mode = XFER_PIO_0;
 				dev->xfer_shift = ATA_SHIFT_PIO;
 				dev->flags |= ATA_DFLAG_PIO;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
libata-warn-if-speed-limited-due-to-40-wire-cable-v2.patch
add-id_to_dma_mode-function-for-printing-dma-modes.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
acpi-driver-support-for-pata.patch
libata-use-new-id_to_dma_mode-function-to-tidy-reporting.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
adjust-legacy-ide-resource-setting-v2.patch
resend-iphase-64bit-cleanup.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
driver_bfin_serial_core.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
