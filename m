From: akpm@linux-foundation.org
Subject: + pata_it8213-switch-to-cable-method-again.patch added to -mm tree
Date: Sun, 11 Mar 2007 01:29:06 -0800
Message-ID: <200703110929.l2B9T65q008778@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41197 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbXCKJ3Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 05:29:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     pata_it8213: switch to cable method again
has been added to the -mm tree.  Its filename is
     pata_it8213-switch-to-cable-method-again.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_it8213: switch to cable method again
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_it8213.c |   36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff -puN drivers/ata/pata_it8213.c~pata_it8213-switch-to-cable-method-again drivers/ata/pata_it8213.c
--- a/drivers/ata/pata_it8213.c~pata_it8213-switch-to-cable-method-again
+++ a/drivers/ata/pata_it8213.c
@@ -26,8 +26,8 @@
  *	@ap: Port
  *	@deadline: deadline jiffies for the operation
  *
- *	Perform cable detection for the 8213 ATA interface. This is
- *	different to the PIIX arrangement
+ *	Filter out ports by the enable bits before doing the normal reset
+ *	and probe.
  */
 
 static int it8213_pre_reset(struct ata_port *ap, unsigned long deadline)
@@ -35,23 +35,14 @@ static int it8213_pre_reset(struct ata_p
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
 	return ata_std_prereset(ap, deadline);
 }
 
 /**
- *	it8213_probe_reset - Probe specified port on PATA host controller
+ *	it8213_error_handler - Probe specified port on PATA host controller
  *	@ap: Port to probe
  *
  *	LOCKING:
@@ -64,9 +55,27 @@ static void it8213_error_handler(struct 
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
@@ -269,6 +278,7 @@ static const struct ata_port_operations 
 	.thaw			= ata_bmdma_thaw,
 	.error_handler		= it8213_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.cable_detect		= it8213_cable_detect,
 
 	.bmdma_setup		= ata_bmdma_setup,
 	.bmdma_start		= ata_bmdma_start,
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
