From: akpm@linux-foundation.org
Subject: + ata_piix-remove-ugly-layering-violation.patch added to -mm tree
Date: Wed, 07 Mar 2007 13:08:14 -0800
Message-ID: <200703072108.l27L8Eai009023@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57500 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423009AbXCGVIm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 16:08:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jeff@garzik.org


The patch titled
     ata_piix: remove ugly layering violation
has been added to the -mm tree.  Its filename is
     ata_piix-remove-ugly-layering-violation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ata_piix: remove ugly layering violation
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

A while ago I modified the libata code so that drivers can return -ENOENT for
unknown ports not fiddle with the EH flags and print stuff directly. 
Somewhere along the line ata_piix didn't get fully converted.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ata_piix.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/ata/ata_piix.c~ata_piix-remove-ugly-layering-violation drivers/ata/ata_piix.c
--- a/drivers/ata/ata_piix.c~ata_piix-remove-ugly-layering-violation
+++ a/drivers/ata/ata_piix.c
@@ -93,7 +93,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"ata_piix"
-#define DRV_VERSION	"2.10"
+#define DRV_VERSION	"2.10ac1"
 
 enum {
 	PIIX_IOCFG		= 0x54, /* IDE I/O configuration register */
@@ -667,14 +667,9 @@ static int ich_pata_prereset(struct ata_
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
-	if (!pci_test_config_bits(pdev, &piix_enable_bits[ap->port_no])) {
-		ata_port_printk(ap, KERN_INFO, "port disabled. ignoring.\n");
-		ap->eh_context.i.action &= ~ATA_EH_RESET_MASK;
-		return 0;
-	}
-
+	if (!pci_test_config_bits(pdev, &piix_enable_bits[ap->port_no]))
+		return -ENOENT;
 	ich_pata_cbl_detect(ap);
-
 	return ata_std_prereset(ap);
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
