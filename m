From: akpm@linux-foundation.org
Subject: - pata_atiixp-switch-to-cable_detect-method-with-correct.patch removed from -mm tree
Date: Wed, 07 Mar 2007 15:47:01 -0800
Message-ID: <200703072347.l27Nl1p8013375@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39194 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945924AbXCGXrX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 18:47:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     pata_atiixp: switch to cable_detect method (with correct patch)
has been removed from the -mm tree.  Its filename was
     pata_atiixp-switch-to-cable_detect-method-with-correct.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: pata_atiixp: switch to cable_detect method (with correct patch)
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Lets try attaching the right patch file this time

Not clear we should keep this ugly BIOS mode hack, but for now it can stay. 
Possibly an ACPI based solution will work, or just doing drive side detection
now that is hopefully fixed.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_atiixp.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff -puN drivers/ata/pata_atiixp.c~pata_atiixp-switch-to-cable_detect-method-with-correct drivers/ata/pata_atiixp.c
--- a/drivers/ata/pata_atiixp.c~pata_atiixp-switch-to-cable_detect-method-with-correct
+++ a/drivers/ata/pata_atiixp.c
@@ -22,7 +22,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_atiixp"
-#define DRV_VERSION "0.4.4"
+#define DRV_VERSION "0.4.5"
 
 enum {
 	ATIIXP_IDE_PIO_TIMING	= 0x40,
@@ -35,23 +35,13 @@ enum {
 
 static int atiixp_pre_reset(struct ata_port *ap)
 {
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	static const struct pci_bits atiixp_enable_bits[] = {
 		{ 0x48, 1, 0x01, 0x00 },
 		{ 0x48, 1, 0x08, 0x00 }
 	};
-	u8 udma;
-
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	if (!pci_test_config_bits(pdev, &atiixp_enable_bits[ap->port_no]))
 		return -ENOENT;
-
-	/* Hack from drivers/ide/pci. Really we want to know how to do the
-	   raw detection not play follow the bios mode guess */
-	pci_read_config_byte(pdev, ATIIXP_IDE_UDMA_MODE + ap->port_no, &udma);
-	if ((udma & 0x07) >= 0x04 || (udma & 0x70) >= 0x40)
-		ap->cbl = ATA_CBL_PATA80;
-	else
-		ap->cbl = ATA_CBL_PATA40;
 	return ata_std_prereset(ap);
 }
 
@@ -60,6 +50,19 @@ static void atiixp_error_handler(struct 
 	ata_bmdma_drive_eh(ap, atiixp_pre_reset, ata_std_softreset, NULL,   ata_std_postreset);
 }
 
+static int atiixp_cable_detect(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u8 udma;
+
+	/* Hack from drivers/ide/pci. Really we want to know how to do the
+	   raw detection not play follow the bios mode guess */
+	pci_read_config_byte(pdev, ATIIXP_IDE_UDMA_MODE + ap->port_no, &udma);
+	if ((udma & 0x07) >= 0x04 || (udma & 0x70) >= 0x40)
+		return  ATA_CBL_PATA80;
+	return ATA_CBL_PATA40;
+}
+
 /**
  *	atiixp_set_pio_timing	-	set initial PIO mode data
  *	@ap: ATA interface
@@ -245,6 +248,7 @@ static struct ata_port_operations atiixp
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= atiixp_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= atiixp_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= atiixp_bmdma_start,
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
pata_platform-set-a-cable-type-which-to-set.patch
pata_qdi-set-cable-type.patch
pata_sl82c105-missing-methods-cable.patch
pata_isapnp-set-cable-type.patch
pata_legacy-fix-missing-methods-and-add-cable-types.patch
pata_sc1200-set-cable-type-add-freeze-thaw-methods.patch
pata_winbond-set-cable-type.patch
ata_piix-remove-ugly-layering-violation.patch
pata_mpc52xx-cable-detect.patch
pata_mpiix-cable-detect-method.patch
pata_ns87410-cable-detect-method.patch
pata_oldpiix-cable-detect.patch
pata_opti-cable-detect.patch
pata_pcmcia-cable-detect.patch
pata_triflex-cable-detect.patch
pata_cmd640-multiple-updates.patch
pata_atiixp-switch-to-cable_detect-method-with-correct.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
dilnetpc-fix-warning.patch
resend-iphase-64bit-cleanup.patch
serial-suppress-rts-assertion-with-disabled-crtscts.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
z85230-fix-fifo-handling.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
tty-clarify-documentation-of-write.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
