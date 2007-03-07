From: akpm@linux-foundation.org
Subject: + pata_hpt3x2n-cable-detect-handling-needs-work.patch added to -mm tree
Date: Wed, 07 Mar 2007 13:08:20 -0800
Message-ID: <200703072108.l27L8KGE009041@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57518 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423015AbXCGVIo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 16:08:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jeff@garzik.org


The patch titled
     pata_hpt3x2n: cable detect handling (needs work)
has been added to the -mm tree.  Its filename is
     pata_hpt3x2n-cable-detect-handling-needs-work.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_hpt3x2n: cable detect handling (needs work)
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_hpt3x2n.c |   29 ++++++++++++++++++++---------
 1 files changed, 20 insertions(+), 9 deletions(-)

diff -puN drivers/ata/pata_hpt3x2n.c~pata_hpt3x2n-cable-detect-handling-needs-work drivers/ata/pata_hpt3x2n.c
--- a/drivers/ata/pata_hpt3x2n.c~pata_hpt3x2n-cable-detect-handling-needs-work
+++ a/drivers/ata/pata_hpt3x2n.c
@@ -25,7 +25,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt3x2n"
-#define DRV_VERSION	"0.3.2"
+#define DRV_VERSION	"0.3.3"
 
 enum {
 	HPT_PCI_FAST	=	(1 << 31),
@@ -115,14 +115,13 @@ static u32 hpt3x2n_find_mode(struct ata_
 }
 
 /**
- *	hpt3x2n_pre_reset	-	reset the hpt3x2n bus
- *	@ap: ATA port to reset
+ *	hpt3x2n_cable_detect	-	Detect the cable type
+ *	@ap: ATA port to detect on
  *
- *	Perform the initial reset handling for the 3x2n series controllers.
- *	Reset the hardware and state machine, obtain the cable type.
+ *	Return the cable type attached to this port
  */
 
-static int hpt3xn_pre_reset(struct ata_port *ap)
+static int hpt3x2n_cable_detect(struct ata_port *ap)
 {
 	u8 scr2, ata66;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
@@ -135,15 +134,26 @@ static int hpt3xn_pre_reset(struct ata_p
 	pci_write_config_byte(pdev, 0x5B, scr2);
 
 	if (ata66 & (1 << ap->port_no))
-		ap->cbl = ATA_CBL_PATA40;
+		return ATA_CBL_PATA40;
 	else
-		ap->cbl = ATA_CBL_PATA80;
+		return ATA_CBL_PATA80;
+}
+
+/**
+ *	hpt3x2n_pre_reset	-	reset the hpt3x2n bus
+ *	@ap: ATA port to reset
+ *
+ *	Perform the initial reset handling for the 3x2n series controllers.
+ *	Reset the hardware and state machine,
+ */
 
+static int hpt3xn_pre_reset(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	/* Reset the state machine */
 	pci_write_config_byte(pdev, 0x50, 0x37);
 	pci_write_config_byte(pdev, 0x54, 0x37);
 	udelay(100);
-
 	return ata_std_prereset(ap);
 }
 
@@ -364,6 +374,7 @@ static struct ata_port_operations hpt3x2
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= hpt3x2n_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= hpt3x2n_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
acpi-driver-support-for-pata.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
pata_platform-set-a-cable-type-which-to-set.patch
pata_qdi-set-cable-type.patch
pata_sl82c105-missing-methods-cable.patch
ata_generic-remove-lots-of-code-using-the-new-cable_detect.patch
pata_ali-remove-lots-of-code-by-using-the-cable_detect.patch
pata_cs55x0-clean-up-by-using-the-cable_detect-method.patch
pata_cypress-clean-up-by-using-cable_detect-method.patch
pata_isapnp-set-cable-type.patch
pata_ixp4xx_cf-set-cable-type.patch
pata_legacy-fix-missing-methods-and-add-cable-types.patch
pata_netcell-remove-lots-of-crud-by-using-the-cable-method.patch
pata_radisys-switch-to-cable-method-to-cleanup-code.patch
pata_sc1200-set-cable-type-add-freeze-thaw-methods.patch
pata_rz1000-remove-lots-of-crap-by-using-cable-method.patch
pata_winbond-set-cable-type.patch
pata_cmd64x-various-fixes.patch
pata_hpt3x3-clean-up-by-using-cable-method.patch
ata_piix-remove-ugly-layering-violation.patch
pata_artop-cable-detect-methods.patch
pata_cs5535-cable-detect.patch
pata_hpt3x2n-cable-detect-handling-needs-work.patch
pata_it821x-clean-up-by-using-cable-methods.patch
pata_mpc52xx-cable-detect.patch
pata_mpiix-cable-detect-method.patch
pata_ns87410-cable-detect-method.patch
pata_oldpiix-cable-detect.patch
pata_opti-cable-detect.patch
pata_pcmcia-cable-detect.patch
pata_pdc202xx_old-cable-detect-clean-up.patch
pata_sil680-cable-detect.patch
pata_triflex-cable-detect.patch
sata_via-cable-detection.patch
pata_cmd640-multiple-updates.patch
pata_efar-switch-to-cable_detect-method.patch
pata_it8213-cable-detect.patch
pata_marvell-cable-and-reset-fixes.patch
pata_serverworks-cable-detect-and-comment-fix.patch
pata_sis-clean-up-using-cable_detect-methods.patch
pata_via-use-cable_detect-method.patch
pata_hpt366-cable-detect-methods.patch
pata_atiixp-switch-to-cable_detect-method-with-correct.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
resend-iphase-64bit-cleanup.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
tty-clarify-documentation-of-write.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
