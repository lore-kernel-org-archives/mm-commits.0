From: akpm@linux-foundation.org
Subject: - pata_optidma-rework-for-cable-detect-and-to-remove.patch removed from -mm tree
Date: Wed, 04 Apr 2007 19:00:18 -0700
Message-ID: <200704050200.l3520IY9004807@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38021 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbXDECA0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 22:00:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_optidma: rework for cable detect and to remove post_set_mode()
has been removed from the -mm tree.  Its filename was
     pata_optidma-rework-for-cable-detect-and-to-remove.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_optidma: rework for cable detect and to remove post_set_mode()
From: Alan Cox <alan@redhat.com>

A lot of noise because I had to rename the optidma_set_mode() method to
avoid confusion with the new ->set_mode() method that was added. Cable
detect side is pretty trivial.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_optidma.c |   55 ++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff -puN drivers/ata/pata_optidma.c~pata_optidma-rework-for-cable-detect-and-to-remove drivers/ata/pata_optidma.c
--- a/drivers/ata/pata_optidma.c~pata_optidma-rework-for-cable-detect-and-to-remove
+++ a/drivers/ata/pata_optidma.c
@@ -33,7 +33,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_optidma"
-#define DRV_VERSION "0.2.4"
+#define DRV_VERSION "0.3.2"
 
 enum {
 	READ_REG	= 0,	/* index of Read cycle timing register */
@@ -61,8 +61,6 @@ static int optidma_pre_reset(struct ata_
 
 	if (ap->port_no && !pci_test_config_bits(pdev, &optidma_enable_bits))
 		return -ENOENT;
-
-	ap->cbl = ATA_CBL_PATA40;
 	return ata_std_prereset(ap);
 }
 
@@ -115,7 +113,7 @@ static void optidma_lock(struct ata_port
 }
 
 /**
- *	optidma_set_mode	-	set mode data
+ *	optidma_mode_setup	-	set mode data
  *	@ap: ATA interface
  *	@adev: ATA device
  *	@mode: Mode to set
@@ -128,7 +126,7 @@ static void optidma_lock(struct ata_port
  *	IRQ here we depend on the host set locking to avoid catastrophe.
  */
 
-static void optidma_set_mode(struct ata_port *ap, struct ata_device *adev, u8 mode)
+static void optidma_mode_setup(struct ata_port *ap, struct ata_device *adev, u8 mode)
 {
 	struct ata_device *pair = ata_dev_pair(adev);
 	int pio = adev->pio_mode - XFER_PIO_0;
@@ -202,7 +200,7 @@ static void optidma_set_mode(struct ata_
 }
 
 /**
- *	optiplus_set_mode	-	DMA setup for Firestar Plus
+ *	optiplus_mode_setup	-	DMA setup for Firestar Plus
  *	@ap: ATA port
  *	@adev: device
  *	@mode: desired mode
@@ -213,7 +211,7 @@ static void optidma_set_mode(struct ata_
  *	one
  */
 
-static void optiplus_set_mode(struct ata_port *ap, struct ata_device *adev, u8 mode)
+static void optiplus_mode_setup(struct ata_port *ap, struct ata_device *adev, u8 mode)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u8 udcfg;
@@ -225,7 +223,7 @@ static void optiplus_set_mode(struct ata
 	pci_read_config_byte(pdev, 0x44, &udcfg);
 	if (mode <= XFER_UDMA_0) {
 		udcfg &= ~(1 << unit);
-		optidma_set_mode(ap, adev, adev->dma_mode);
+		optidma_mode_setup(ap, adev, adev->dma_mode);
 	} else {
 		udcfg |=  (1 << unit);
 		if (ap->port_no) {
@@ -253,7 +251,7 @@ static void optiplus_set_mode(struct ata
 
 static void optidma_set_pio_mode(struct ata_port *ap, struct ata_device *adev)
 {
-	optidma_set_mode(ap, adev, adev->pio_mode);
+	optidma_mode_setup(ap, adev, adev->pio_mode);
 }
 
 /**
@@ -268,7 +266,7 @@ static void optidma_set_pio_mode(struct 
 
 static void optidma_set_dma_mode(struct ata_port *ap, struct ata_device *adev)
 {
-	optidma_set_mode(ap, adev, adev->dma_mode);
+	optidma_mode_setup(ap, adev, adev->dma_mode);
 }
 
 /**
@@ -283,7 +281,7 @@ static void optidma_set_dma_mode(struct 
 
 static void optiplus_set_pio_mode(struct ata_port *ap, struct ata_device *adev)
 {
-	optiplus_set_mode(ap, adev, adev->pio_mode);
+	optiplus_mode_setup(ap, adev, adev->pio_mode);
 }
 
 /**
@@ -298,7 +296,7 @@ static void optiplus_set_pio_mode(struct
 
 static void optiplus_set_dma_mode(struct ata_port *ap, struct ata_device *adev)
 {
-	optiplus_set_mode(ap, adev, adev->dma_mode);
+	optiplus_mode_setup(ap, adev, adev->dma_mode);
 }
 
 /**
@@ -322,26 +320,29 @@ static u8 optidma_make_bits43(struct ata
 }
 
 /**
- *	optidma_post_set_mode	-	finalize PCI setup
+ *	optidma_set_mode	-	mode setup
  *	@ap: port to set up
  *
- *	Finalise the configuration by writing the nibble of extra bits
- *	of data into the chip.
+ *	Use the standard setup to tune the chipset and then finalise the
+ *	configuration by writing the nibble of extra bits of data into
+ *	the chip.
  */
 
-static void optidma_post_set_mode(struct ata_port *ap)
+static int optidma_set_mode(struct ata_port *ap, struct ata_device **r_failed)
 {
 	u8 r;
 	int nybble = 4 * ap->port_no;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-
-	pci_read_config_byte(pdev, 0x43, &r);
-
-	r &= (0x0F << nybble);
-	r |= (optidma_make_bits43(&ap->device[0]) +
-	     (optidma_make_bits43(&ap->device[0]) << 2)) << nybble;
-
-	pci_write_config_byte(pdev, 0x43, r);
+	int rc  = ata_do_set_mode(ap, r_failed);
+	if (rc == 0) {
+		pci_read_config_byte(pdev, 0x43, &r);
+
+		r &= (0x0F << nybble);
+		r |= (optidma_make_bits43(&ap->device[0]) +
+		     (optidma_make_bits43(&ap->device[0]) << 2)) << nybble;
+		pci_write_config_byte(pdev, 0x43, r);
+	}
+	return rc;
 }
 
 static struct scsi_host_template optidma_sht = {
@@ -381,7 +382,8 @@ static struct ata_port_operations optidm
 	.thaw		= ata_bmdma_thaw,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
 	.error_handler	= optidma_error_handler,
-	.post_set_mode	= optidma_post_set_mode,
+	.set_mode	= optidma_set_mode,
+	.cable_detect	= ata_cable_40wire,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -416,7 +418,8 @@ static struct ata_port_operations optipl
 	.thaw		= ata_bmdma_thaw,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
 	.error_handler	= optidma_error_handler,
-	.post_set_mode	= optidma_post_set_mode,
+	.set_mode	= optidma_set_mode,
+	.cable_detect	= ata_cable_40wire,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
_

Patches currently in -mm which might be from alan@redhat.com are

origin.patch
git-libata-all.patch
ata_generic-remove-all-the-crud-again-and-use-cable.patch
pata_cypress-re-remove-all-the-crap-and-switch-back-to.patch
libata-acpi-add-infrastructure-for-drivers-to-use.patch
libata-acpi-add-infrastructure-for-drivers-to-use-fix.patch
pata_acpi-restore-driver.patch
pata_acpi-restore-driver-fix.patch
libata-misc-minor-merge-fixups.patch
pata_hpt37x-further-small-fixes.patch
pata_hpt3x2n-add-hpt371n-support-and-other-bits.patch
pata_pdc2027x-bring-into-line-with-changes-add-the-mode.patch
pci_module_init-convertion-in-tmscsimc.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
revoke-special-mmap-handling.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
