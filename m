From: akpm@linux-foundation.org
Subject: + pata_optidma-rework-for-cable-detect-and-to-remove.patch added to -mm tree
Date: Sun, 11 Mar 2007 01:31:04 -0800
Message-ID: <200703110931.l2B9V4RV008908@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41294 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbXCKJbN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 05:31:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     pata_optidma: rework for cable detect and to remove post_set_mode()
has been added to the -mm tree.  Its filename is
     pata_optidma-rework-for-cable-detect-and-to-remove.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -62,8 +62,6 @@ static int optidma_pre_reset(struct ata_
 
 	if (ap->port_no && !pci_test_config_bits(pdev, &optidma_enable_bits))
 		return -ENOENT;
-
-	ap->cbl = ATA_CBL_PATA40;
 	return ata_std_prereset(ap, deadline);
 }
 
@@ -116,7 +114,7 @@ static void optidma_lock(struct ata_port
 }
 
 /**
- *	optidma_set_mode	-	set mode data
+ *	optidma_mode_setup	-	set mode data
  *	@ap: ATA interface
  *	@adev: ATA device
  *	@mode: Mode to set
@@ -129,7 +127,7 @@ static void optidma_lock(struct ata_port
  *	IRQ here we depend on the host set locking to avoid catastrophe.
  */
 
-static void optidma_set_mode(struct ata_port *ap, struct ata_device *adev, u8 mode)
+static void optidma_mode_setup(struct ata_port *ap, struct ata_device *adev, u8 mode)
 {
 	struct ata_device *pair = ata_dev_pair(adev);
 	int pio = adev->pio_mode - XFER_PIO_0;
@@ -203,7 +201,7 @@ static void optidma_set_mode(struct ata_
 }
 
 /**
- *	optiplus_set_mode	-	DMA setup for Firestar Plus
+ *	optiplus_mode_setup	-	DMA setup for Firestar Plus
  *	@ap: ATA port
  *	@adev: device
  *	@mode: desired mode
@@ -214,7 +212,7 @@ static void optidma_set_mode(struct ata_
  *	one
  */
 
-static void optiplus_set_mode(struct ata_port *ap, struct ata_device *adev, u8 mode)
+static void optiplus_mode_setup(struct ata_port *ap, struct ata_device *adev, u8 mode)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u8 udcfg;
@@ -226,7 +224,7 @@ static void optiplus_set_mode(struct ata
 	pci_read_config_byte(pdev, 0x44, &udcfg);
 	if (mode <= XFER_UDMA_0) {
 		udcfg &= ~(1 << unit);
-		optidma_set_mode(ap, adev, adev->dma_mode);
+		optidma_mode_setup(ap, adev, adev->dma_mode);
 	} else {
 		udcfg |=  (1 << unit);
 		if (ap->port_no) {
@@ -254,7 +252,7 @@ static void optiplus_set_mode(struct ata
 
 static void optidma_set_pio_mode(struct ata_port *ap, struct ata_device *adev)
 {
-	optidma_set_mode(ap, adev, adev->pio_mode);
+	optidma_mode_setup(ap, adev, adev->pio_mode);
 }
 
 /**
@@ -269,7 +267,7 @@ static void optidma_set_pio_mode(struct 
 
 static void optidma_set_dma_mode(struct ata_port *ap, struct ata_device *adev)
 {
-	optidma_set_mode(ap, adev, adev->dma_mode);
+	optidma_mode_setup(ap, adev, adev->dma_mode);
 }
 
 /**
@@ -284,7 +282,7 @@ static void optidma_set_dma_mode(struct 
 
 static void optiplus_set_pio_mode(struct ata_port *ap, struct ata_device *adev)
 {
-	optiplus_set_mode(ap, adev, adev->pio_mode);
+	optiplus_mode_setup(ap, adev, adev->pio_mode);
 }
 
 /**
@@ -299,7 +297,7 @@ static void optiplus_set_pio_mode(struct
 
 static void optiplus_set_dma_mode(struct ata_port *ap, struct ata_device *adev)
 {
-	optiplus_set_mode(ap, adev, adev->dma_mode);
+	optiplus_mode_setup(ap, adev, adev->dma_mode);
 }
 
 /**
@@ -323,26 +321,29 @@ static u8 optidma_make_bits43(struct ata
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
@@ -382,7 +383,8 @@ static struct ata_port_operations optidm
 	.thaw		= ata_bmdma_thaw,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
 	.error_handler	= optidma_error_handler,
-	.post_set_mode	= optidma_post_set_mode,
+	.set_mode	= optidma_set_mode,
+	.cable_detect	= ata_cable_40wire,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -417,7 +419,8 @@ static struct ata_port_operations optipl
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

git-libata-all.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
ata_generic-remove-all-the-crud-again-and-use-cable.patch
pata_ali-remove-all-the-crap-again-and-switch-to.patch
pata_amd-remove-all-the-crud-and-restore-the-cable-detect.patch
pata_artop-remove-all-the-crud-again-and-restore-the-cable.patch
pata_atiixp-restore-the-cable-method.patch
pata_cmd64x-restore-cable-method.patch
pata_cs5520-re-remove-crap-and-switch-to-cable-detect.patch
pata_cs5530-re-remove-all-the-crap-and-switch-back-to-the.patch
pata_cs5535-re-remove-all-the-crap-and-switch-to-the-cable.patch
pata_cypress-re-remove-all-the-crap-and-switch-back-to.patch
pata_efar-switch-back-to-cable-methods.patch
pata_hpt366-switch-back-to-cable-method-again.patch
pata_hpt3x3-switch-back-to-cable-method-and-re-remove-all.patch
pata_isapnp-put-cable-type-back.patch
pata_it8213-switch-to-cable-method-again.patch
pata_it821x-switch-back-to-cable-detect-and-re-remove-all.patch
pata_ixp4xx_cf-restore-cable-type-method.patch
pata_legacy-restore-cable-methods.patch
pata_marvell-restore-cable-methods-and-reapply-lost-bug.patch
pata_mpc52xx-restore-cable-method.patch
pata_mpiix-restore-cable-type-method.patch
pata_netcell-re-remove-all-the-crud.patch
pata_ns87410-restore-cable-detect-method.patch
pata_oldpiix-restore-cable-method-re-correct-comments.patch
pata_opti-restore-cable-method.patch
pata_pcmcia-restore-cable-reporting.patch
pata_pdc202xx_old-re-remove-crap-restore-cable-methods.patch
pata_qdi-restore-cable-detect.patch
pata_serverworks-re-remove-crap-restore-cable-detect.patch
pata_sil680-restore-cable-detect-methods.patch
pata_sis-restore-cable-method-re-perform-crapectory.patch
pata_sl82c105-restore-cable-detect-method.patch
pata_via-restore-cable-detect.patch
pata_winbond-restore-cable-method.patch
sata_via-use-cable-detect-methods.patch
libata-acpi-try-and-stop-all-the-non-pci-devices-crashing.patch
libata-acpi-add-infrastructure-for-drivers-to-use.patch
pata_optidma-rework-for-cable-detect-and-to-remove.patch
pata_pdc2027x-restore-various-updates-done-on-the-driver.patch
pata_acpi-restore-driver.patch
ata_piix-remove-ugly-layering-violation.patch
pata_cmd640-multiple-updates.patch
dilnetpc-fix-warning.patch
resend-iphase-64bit-cleanup.patch
pci_module_init-convertion-in-tmscsimc.patch
z85230-fix-fifo-handling.patch
tty-clarify-documentation-of-write.patch
