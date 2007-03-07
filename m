From: akpm@linux-foundation.org
Subject: - pata_via-use-cable_detect-method.patch removed from -mm tree
Date: Wed, 07 Mar 2007 15:46:53 -0800
Message-ID: <200703072346.l27NkrW8013369@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39187 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945928AbXCGXrP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 18:47:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     pata_via: use cable_detect method
has been removed from the -mm tree.  Its filename was
     pata_via-use-cable_detect-method.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: pata_via: use cable_detect method
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

We end up shifting a few bits of logic around in this driver but the basic
change is the same.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_via.c |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff -puN drivers/ata/pata_via.c~pata_via-use-cable_detect-method drivers/ata/pata_via.c
--- a/drivers/ata/pata_via.c~pata_via-use-cable_detect-method
+++ a/drivers/ata/pata_via.c
@@ -62,7 +62,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_via"
-#define DRV_VERSION "0.2.1"
+#define DRV_VERSION "0.3.1"
 
 /*
  *	The following comes directly from Vojtech Pavlik's ide/pci/via82cxxx
@@ -135,16 +135,23 @@ static const struct via_isa_bridge {
  */
 
 static int via_cable_detect(struct ata_port *ap) {
+	const struct via_isa_bridge *config = ap->host->private_data;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u32 ata66;
 
+	/* Early chips are 40 wire */
+	if ((config->flags & VIA_UDMA) < VIA_UDMA_66)
+		return ATA_CBL_PATA40;
+	/* UDMA 66 chips have only drive side logic */
+	else if((config->flags & VIA_UDMA) < VIA_UDMA_100)
+		return ATA_CBL_PATA_UNK;
+	/* UDMA 100 or later */
 	pci_read_config_dword(pdev, 0x50, &ata66);
 	/* Check both the drive cable reporting bits, we might not have
 	   two drives */
 	if (ata66 & (0x10100000 >> (16 * ap->port_no)))
 		return ATA_CBL_PATA80;
-	else
-		return ATA_CBL_PATA40;
+	return ATA_CBL_PATA40;
 }
 
 static int via_pre_reset(struct ata_port *ap)
@@ -156,22 +163,10 @@ static int via_pre_reset(struct ata_port
 			{ 0x40, 1, 0x02, 0x02 },
 			{ 0x40, 1, 0x01, 0x01 }
 		};
-
 		struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-
 		if (!pci_test_config_bits(pdev, &via_enable_bits[ap->port_no]))
 			return -ENOENT;
 	}
-
-	if ((config->flags & VIA_UDMA) >= VIA_UDMA_100)
-		ap->cbl = via_cable_detect(ap);
-	/* The UDMA66 series has no cable detect so do drive side detect */
-	else if ((config->flags & VIA_UDMA) < VIA_UDMA_66)
-		ap->cbl = ATA_CBL_PATA40;
-	else
-		ap->cbl = ATA_CBL_PATA_UNK;
-
-
 	return ata_std_prereset(ap);
 }
 
@@ -327,6 +322,7 @@ static struct ata_port_operations via_po
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= via_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= via_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -362,6 +358,7 @@ static struct ata_port_operations via_po
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= via_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= via_cable_detect,
 
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
pata_via-use-cable_detect-method.patch
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
