From: akpm@linux-foundation.org
Subject: - pata_it8213-cable-detect.patch removed from -mm tree
Date: Wed, 07 Mar 2007 15:46:35 -0800
Message-ID: <200703072346.l27NkZIe013345@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39145 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945913AbXCGXqw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 18:46:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     pata_it8213: cable detect
has been removed from the -mm tree.  Its filename was
     pata_it8213-cable-detect.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: pata_it8213: cable detect
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Another not-quite PIIX, another cable type conversion

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_it8213.c |   36 +++++++++++++++++++++++-------------
 1 files changed, 23 insertions(+), 13 deletions(-)

diff -puN drivers/ata/pata_it8213.c~pata_it8213-cable-detect drivers/ata/pata_it8213.c
--- a/drivers/ata/pata_it8213.c~pata_it8213-cable-detect
+++ a/drivers/ata/pata_it8213.c
@@ -25,8 +25,8 @@
  *	it8213_pre_reset	-	check for 40/80 pin
  *	@ap: Port
  *
- *	Perform cable detection for the 8213 ATA interface. This is
- *	different to the PIIX arrangement
+ *	Filter out ports by the enable bits before doing the normal reset
+ *	and probe.
  */
 
 static int it8213_pre_reset(struct ata_port *ap)
@@ -34,23 +34,14 @@ static int it8213_pre_reset(struct ata_p
 	static const struct pci_bits it8213_enable_bits[] = {
 		{ 0x41U, 1U, 0x80UL, 0x80UL },	/* port 0 */
 	};
-
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u8 tmp;
-
 	if (!pci_test_config_bits(pdev, &it8213_enable_bits[ap->port_no]))
 		return -ENOENT;
-
-	pci_read_config_byte(pdev, 0x42, &tmp);
-	if (tmp & 2)	/* The initial docs are incorrect */
-		ap->cbl = ATA_CBL_PATA40;
-	else
-		ap->cbl = ATA_CBL_PATA80;
 	return ata_std_prereset(ap);
 }
 
 /**
- *	it8213_probe_reset - Probe specified port on PATA host controller
+ *	it8213_error_handler - Probe specified port on PATA host controller
  *	@ap: Port to probe
  *
  *	LOCKING:
@@ -63,9 +54,27 @@ static void it8213_error_handler(struct 
 }
 
 /**
+ *	it8213_cable_detect	-	check for 40/80 pin
+ *	@ap: Port
+ *
+ *	Perform cable detection for the 8213 ATA interface. This is
+ *	different to the PIIX arrangement
+ */
+
+static int it8213_cable_detect(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u8 tmp;
+	pci_read_config_byte(pdev, 0x42, &tmp);
+	if (tmp & 2)	/* The initial docs are incorrect */
+		return ATA_CBL_PATA40;
+	return ATA_CBL_PATA80;
+}
+
+/**
  *	it8213_set_piomode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
- *	@adev: um
+ *	@adev: Device whose timings we are configuring
  *
  *	Set PIO mode for device, in host controller PCI config space.
  *
@@ -268,6 +277,7 @@ static const struct ata_port_operations 
 	.thaw			= ata_bmdma_thaw,
 	.error_handler		= it8213_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.cable_detect		= it8213_cable_detect,
 
 	.bmdma_setup		= ata_bmdma_setup,
 	.bmdma_start		= ata_bmdma_start,
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
pata_it8213-cable-detect.patch
pata_marvell-cable-and-reset-fixes.patch
pata_serverworks-cable-detect-and-comment-fix.patch
pata_sis-clean-up-using-cable_detect-methods.patch
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
