From: akpm@linux-foundation.org
Subject: + pata_cmd640-multiple-updates.patch added to -mm tree
Date: Wed, 07 Mar 2007 13:08:44 -0800
Message-ID: <200703072108.l27L8imF009084@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57602 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992585AbXCGVJE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 16:09:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jeff@garzik.org


The patch titled
     pata_cmd640: multiple updates
has been added to the -mm tree.  Its filename is
     pata_cmd640-multiple-updates.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_cmd640: multiple updates
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Add suspend/resume support
Write 0x5B to 0 not 0x5C

The former is important as we must kill the FIFO on a resume

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_cmd640.c |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)

diff -puN drivers/ata/pata_cmd640.c~pata_cmd640-multiple-updates drivers/ata/pata_cmd640.c
--- a/drivers/ata/pata_cmd640.c~pata_cmd640-multiple-updates
+++ a/drivers/ata/pata_cmd640.c
@@ -23,7 +23,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_cmd640"
-#define DRV_VERSION "0.0.3"
+#define DRV_VERSION "0.0.5"
 
 struct cmd640_reg {
 	int last;
@@ -43,6 +43,7 @@ enum {
 
 /**
  *	cmd640_set_piomode	-	set initial PIO mode data
+ *	@ap: ATA port
  *	@adev: ATA device
  *
  *	Called to do the PIO mode setup.
@@ -219,22 +220,13 @@ static struct ata_port_operations cmd640
 	.port_start	= cmd640_port_start,
 };
 
-static int cmd640_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
+static void cmd640_hardware_init(struct pci_dev *pdev)
 {
 	u8 r;
 	u8 ctrl;
 
-	static struct ata_port_info info = {
-		.sht = &cmd640_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
-		.pio_mask = 0x1f,
-		.port_ops = &cmd640_port_ops
-	};
-
-	static struct ata_port_info *port_info[2] = { &info, &info };
-
 	/* CMD640 detected, commiserations */
-	pci_write_config_byte(pdev, 0x5C, 0x00);
+	pci_write_config_byte(pdev, 0x5B, 0x00);
 	/* Get version info */
 	pci_read_config_byte(pdev, CFR, &r);
 	/* PIO0 command cycles */
@@ -255,12 +247,26 @@ static int cmd640_init_one(struct pci_de
 	pci_read_config_byte(pdev, ARTIM23, &ctrl);
 	ctrl |= 0x0C;
 	pci_write_config_byte(pdev, ARTIM23, ctrl);
+}
+
+static int cmd640_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	static struct ata_port_info info = {
+		.sht = &cmd640_sht,
+		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.pio_mask = 0x1f,
+		.port_ops = &cmd640_port_ops
+	};
+
+	static struct ata_port_info *port_info[2] = { &info, &info };
 
+	cmd640_hardware_init(pdev);
 	return ata_pci_init_one(pdev, port_info, 2);
 }
 
 static int cmd640_reinit_one(struct pci_dev *pdev)
 {
+	cmd640_hardware_init(pdev);
 	return ata_pci_device_resume(pdev);
 }
 
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
dilnetpc-fix-warning.patch
