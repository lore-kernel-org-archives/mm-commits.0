From: akpm@linux-foundation.org
Subject: - pata_marvell-cable-and-reset-fixes.patch removed from -mm tree
Date: Wed, 07 Mar 2007 15:46:40 -0800
Message-ID: <200703072346.l27NkevG013356@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39167 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945916AbXCGXrC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 18:47:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     pata_marvell: cable and reset fixes
has been removed from the -mm tree.  Its filename was
     pata_marvell-cable-and-reset-fixes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: pata_marvell: cable and reset fixes
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

There are two changes here.  Firstly we switch to a cable detect method,
secondly the old code forgot to call ata_std_prereset() but somehow managed to
work anyway.  Fix the missing call.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_marvell.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff -puN drivers/ata/pata_marvell.c~pata_marvell-cable-and-reset-fixes drivers/ata/pata_marvell.c
--- a/drivers/ata/pata_marvell.c~pata_marvell-cable-and-reset-fixes
+++ a/drivers/ata/pata_marvell.c
@@ -20,7 +20,7 @@
 #include <linux/ata.h>
 
 #define DRV_NAME	"pata_marvell"
-#define DRV_VERSION	"0.1.1"
+#define DRV_VERSION	"0.1.4"
 
 /**
  *	marvell_pre_reset	-	check for 40/80 pin
@@ -52,22 +52,23 @@ static int marvell_pre_reset(struct ata_
 	if ((pdev->device == 0x6145) && (ap->port_no == 0) &&
 	    (!(devices & 0x10)))	/* PATA enable ? */
 		return -ENOENT;
+	return ata_std_prereset(ap);
+}
 
+static int marvell_cable_detect(struct ata_port *ap)
+{
 	/* Cable type */
 	switch(ap->port_no)
 	{
 	case 0:
 		if (ioread8(ap->ioaddr.bmdma_addr + 1) & 1)
-			ap->cbl = ATA_CBL_PATA40;
-		else
-			ap->cbl = ATA_CBL_PATA80;
-		break;
-
+			return ATA_CBL_PATA40;
+		return ATA_CBL_PATA80;
 	case 1: /* Legacy SATA port */
-		ap->cbl = ATA_CBL_SATA;
-		break;
+		return ATA_CBL_SATA;
 	}
-	return ata_std_prereset(ap);
+	BUG();
+	return 0;	/* Our BUG macro needs the right markup */
 }
 
 /**
@@ -123,6 +124,7 @@ static const struct ata_port_operations 
 	.thaw			= ata_bmdma_thaw,
 	.error_handler		= marvell_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.cable_detect		= marvell_cable_detect,
 
 	/* BMDMA handling is PCI ATA format, use helpers */
 	.bmdma_setup		= ata_bmdma_setup,
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
