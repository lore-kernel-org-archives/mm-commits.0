From: akpm@linux-foundation.org
Subject: - pata_sis-fix-and-clean-up-some-timing-setups.patch removed from -mm tree
Date: Tue, 29 May 2007 11:54:24 -0700
Message-ID: <200705291854.l4TIsNk2008520@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753616AbXE2Sy4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:54:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     pata_sis: Fix and clean up some timing setups
has been removed from the -mm tree.  Its filename was
     pata_sis-fix-and-clean-up-some-timing-setups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_sis: Fix and clean up some timing setups
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

- Rename sis_port_base to sis_old_port_base() so nobody uses it for new
  generation controllers in error.

- Use byte size operations where it is cleaner for mode setup

- Fix a couple of masking errors on certai chip revs when setting speeds

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_sis.c |   46 +++++++++++++++++++--------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff -puN drivers/ata/pata_sis.c~pata_sis-fix-and-clean-up-some-timing-setups drivers/ata/pata_sis.c
--- a/drivers/ata/pata_sis.c~pata_sis-fix-and-clean-up-some-timing-setups
+++ a/drivers/ata/pata_sis.c
@@ -73,14 +73,14 @@ static int sis_short_ata40(struct pci_de
 }
 
 /**
- *	sis_port_base		-	return PCI configuration base for dev
+ *	sis_old_port_base		-	return PCI configuration base for dev
  *	@adev: device
  *
  *	Returns the base of the PCI configuration registers for this port
  *	number.
  */
 
-static int sis_port_base(struct ata_device *adev)
+static int sis_old_port_base(struct ata_device *adev)
 {
 	return  0x40 + (4 * adev->ap->port_no) +  (2 * adev->devno);
 }
@@ -211,7 +211,7 @@ static void sis_set_fifo(struct ata_port
 static void sis_old_set_piomode (struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
-	int port = sis_port_base(adev);
+	int port = sis_old_port_base(adev);
 	u8 t1, t2;
 	int speed = adev->pio_mode - XFER_PIO_0;
 
@@ -248,7 +248,7 @@ static void sis_old_set_piomode (struct 
 static void sis_100_set_piomode (struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
-	int port = sis_port_base(adev);
+	int port = sis_old_port_base(adev);
 	int speed = adev->pio_mode - XFER_PIO_0;
 
 	const u8 actrec[] = { 0x00, 0x67, 0x44, 0x33, 0x31 };
@@ -328,7 +328,7 @@ static void sis_old_set_dmamode (struct 
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	int speed = adev->dma_mode - XFER_MW_DMA_0;
-	int drive_pci = sis_port_base(adev);
+	int drive_pci = sis_old_port_base(adev);
 	u16 timing;
 
 	const u16 mwdma_bits[] = { 0x707, 0x202, 0x202 };
@@ -367,7 +367,7 @@ static void sis_66_set_dmamode (struct a
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	int speed = adev->dma_mode - XFER_MW_DMA_0;
-	int drive_pci = sis_port_base(adev);
+	int drive_pci = sis_old_port_base(adev);
 	u16 timing;
 
 	const u16 mwdma_bits[] = { 0x707, 0x202, 0x202 };
@@ -378,12 +378,12 @@ static void sis_66_set_dmamode (struct a
 	if (adev->dma_mode < XFER_UDMA_0) {
 		/* bits 3-0 hold recovery timing bits 8-10 active timing and
 		   the higer bits are dependant on the device, bit 15 udma */
-		timing &= ~ 0x870F;
+		timing &= ~0x870F;
 		timing |= mwdma_bits[speed];
 	} else {
 		/* Bit 15 is UDMA on/off, bit 12-14 are cycle time */
 		speed = adev->dma_mode - XFER_UDMA_0;
-		timing &= ~0x6000;
+		timing &= ~0xF000;
 		timing |= udma_bits[speed];
 	}
 	pci_write_config_word(pdev, drive_pci, timing);
@@ -405,22 +405,22 @@ static void sis_100_set_dmamode (struct 
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	int speed = adev->dma_mode - XFER_MW_DMA_0;
-	int drive_pci = sis_port_base(adev);
-	u16 timing;
+	int drive_pci = sis_old_port_base(adev);
+	u8 timing;
 
-	const u16 udma_bits[]  = { 0x8B00, 0x8700, 0x8500, 0x8300, 0x8200, 0x8100};
+	const u8 udma_bits[]  = { 0x8B, 0x87, 0x85, 0x83, 0x82, 0x81};
 
-	pci_read_config_word(pdev, drive_pci, &timing);
+	pci_read_config_byte(pdev, drive_pci + 1, &timing);
 
 	if (adev->dma_mode < XFER_UDMA_0) {
 		/* NOT SUPPORTED YET: NEED DATA SHEET. DITTO IN OLD DRIVER */
 	} else {
-		/* Bit 15 is UDMA on/off, bit 12-14 are cycle time */
+		/* Bit 7 is UDMA on/off, bit 0-3 are cycle time */
 		speed = adev->dma_mode - XFER_UDMA_0;
-		timing &= ~0x0F00;
+		timing &= ~0x8F;
 		timing |= udma_bits[speed];
 	}
-	pci_write_config_word(pdev, drive_pci, timing);
+	pci_write_config_byte(pdev, drive_pci + 1, timing);
 }
 
 /**
@@ -440,22 +440,22 @@ static void sis_133_early_set_dmamode (s
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	int speed = adev->dma_mode - XFER_MW_DMA_0;
-	int drive_pci = sis_port_base(adev);
-	u16 timing;
-
-	static const u16 udma_bits[]  = { 0x8F00, 0x8A00, 0x8700, 0x8500, 0x8300, 0x8200, 0x8100};
+	int drive_pci = sis_old_port_base(adev);
+	u8 timing;
+	/* Low 4 bits are timing */
+	static const u8 udma_bits[]  = { 0x8F, 0x8A, 0x87, 0x85, 0x83, 0x82, 0x81};
 
-	pci_read_config_word(pdev, drive_pci, &timing);
+	pci_read_config_byte(pdev, drive_pci + 1, &timing);
 
 	if (adev->dma_mode < XFER_UDMA_0) {
 		/* NOT SUPPORTED YET: NEED DATA SHEET. DITTO IN OLD DRIVER */
 	} else {
-		/* Bit 15 is UDMA on/off, bit 12-14 are cycle time */
+		/* Bit 7 is UDMA on/off, bit 0-3 are cycle time */
 		speed = adev->dma_mode - XFER_UDMA_0;
-		timing &= ~0x0F00;
+		timing &= ~0x8F;
 		timing |= udma_bits[speed];
 	}
-	pci_write_config_word(pdev, drive_pci, timing);
+	pci_write_config_byte(pdev, drive_pci + 1, timing);
 }
 
 /**
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

lots-of-architectures-enable-arbitary-speed-tty-support.patch
git-arm-master.patch
arm26-enable-arbitary-speed-tty-ioctls-and-split.patch
ia64-arbitary-speed-tty-ioctl-support.patch
git-libata-all.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
serial-use-resource_size_t-for-port-io-addresses.patch
add-pci_try_set_mwi.patch
fix-pci_find_present.patch
git-scsi-misc.patch
git-watchdog.patch
add-pci_try_set_mwi-prism54pci.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
blackfin-enable-arbitary-speed-serial-setting.patch
h8300-enable-arbitary-speed-tty-port-setup.patch
m32r-enable-arbitary-speed-tty-rate-setting.patch
etrax-enable-arbitary-speed-setting-on-tty-ports.patch
v850-enable-arbitary-speed-tty-ioctls.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
update-zilog-timeout.patch
edd-switch-to-pci_get-based-api.patch
mpu401-warning-fixes.patch
i2o_cfg_passthru-cleanup.patch
i2o_cfg_passthru-cleanup-fix.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
