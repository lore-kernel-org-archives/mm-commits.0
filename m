From: akpm@linux-foundation.org
Subject: - libata-use-new-id_to_dma_mode-function-to-tidy-reporting.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:52:00 -0800
Message-ID: <200702282352.l1SNq0TV030958@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48211 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932619AbXB1XwQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:52:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     libata: Use new id_to_dma_mode function to tidy reporting  in more drivers (minimally tested)
has been removed from the -mm tree.  Its filename was
     libata-use-new-id_to_dma_mode-function-to-tidy-reporting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

libata-warn-if-speed-limited-due-to-40-wire-cable-v2.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
acpi-driver-support-for-pata.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
resend-iphase-64bit-cleanup.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
driver_bfin_serial_core.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
tty-clarify-documentation-of-write.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
