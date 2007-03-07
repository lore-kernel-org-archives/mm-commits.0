From: akpm@linux-foundation.org
Subject: - pata_hpt366-cable-detect-methods.patch removed from -mm tree
Date: Wed, 07 Mar 2007 15:46:57 -0800
Message-ID: <200703072346.l27NkvAf013372@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39186 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945922AbXCGXrN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 18:47:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     pata_hpt366: cable detect methods
has been removed from the -mm tree.  Its filename was
     pata_hpt366-cable-detect-methods.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: pata_hpt366: cable detect methods
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_hpt366.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff -puN drivers/ata/pata_hpt366.c~pata_hpt366-cable-detect-methods drivers/ata/pata_hpt366.c
--- a/drivers/ata/pata_hpt366.c~pata_hpt366-cable-detect-methods
+++ a/drivers/ata/pata_hpt366.c
@@ -27,7 +27,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt366"
-#define DRV_VERSION	"0.6.0"
+#define DRV_VERSION	"0.6.1"
 
 struct hpt_clock {
 	u8	xfer_speed;
@@ -210,24 +210,26 @@ static u32 hpt36x_find_mode(struct ata_p
 	return 0xffffffffU;	/* silence compiler warning */
 }
 
+static int hpt36x_cable_detect(struct ata_port *ap)
+{
+	u8 ata66;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+
+	pci_read_config_byte(pdev, 0x5A, &ata66);
+	if (ata66 & (1 << ap->port_no))
+		return ATA_CBL_PATA40;
+	return ATA_CBL_PATA80;
+}
+
 static int hpt36x_pre_reset(struct ata_port *ap)
 {
 	static const struct pci_bits hpt36x_enable_bits[] = {
 		{ 0x50, 1, 0x04, 0x04 },
 		{ 0x54, 1, 0x04, 0x04 }
 	};
-
-	u8 ata66;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-
 	if (!pci_test_config_bits(pdev, &hpt36x_enable_bits[ap->port_no]))
 		return -ENOENT;
-
-	pci_read_config_byte(pdev, 0x5A, &ata66);
-	if (ata66 & (1 << ap->port_no))
-		ap->cbl = ATA_CBL_PATA40;
-	else
-		ap->cbl = ATA_CBL_PATA80;
 	return ata_std_prereset(ap);
 }
 
@@ -354,6 +356,7 @@ static struct ata_port_operations hpt366
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= hpt36x_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= hpt36x_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
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
pata_hpt366-cable-detect-methods.patch
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
