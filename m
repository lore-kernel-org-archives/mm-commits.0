From: akpm@linux-foundation.org
Subject: + pata_pdc202xx_old-lba48-bug.patch added to -mm tree
Date: Sun, 25 Mar 2007 00:53:31 -0800
Message-ID: <200703250853.l2P8rVrV024141@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36736 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499AbXCYIxl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 04:53:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     pata_pdc202xx_old: LBA48 bug
has been added to the -mm tree.  Its filename is
     pata_pdc202xx_old-lba48-bug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_pdc202xx_old: LBA48 bug
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

In LBA48 mode we have to help the controller to get anything to work.  The
chip provides a register giving word counts meant for ATAPI use which we can
use.  However we need to load the count in words not bytes..

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_pdc202xx_old.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/ata/pata_pdc202xx_old.c~pata_pdc202xx_old-lba48-bug drivers/ata/pata_pdc202xx_old.c
--- a/drivers/ata/pata_pdc202xx_old.c~pata_pdc202xx_old-lba48-bug
+++ a/drivers/ata/pata_pdc202xx_old.c
@@ -22,7 +22,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_pdc202xx_old"
-#define DRV_VERSION "0.4.2"
+#define DRV_VERSION "0.4.3"
 
 static int pdc2026x_cable_detect(struct ata_port *ap)
 {
@@ -167,7 +167,7 @@ static void pdc2026x_bmdma_start(struct 
 	/* Cases the state machine will not complete correctly without help */
 	if ((tf->flags & ATA_TFLAG_LBA48) ||  tf->protocol == ATA_PROT_ATAPI_DMA)
 	{
-		len = qc->nbytes;
+		len = qc->nbytes / 2;
 
 		if (tf->flags & ATA_TFLAG_WRITE)
 			len |= 0x06000000;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

generic_serial-fix-decoding-of-baud-rate.patch
git-libata-all.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
libata-misc-minor-merge-fixups.patch
tty-minor-merge-correction.patch
pata_pdc202xx_old-lba48-bug.patch
pata_hpt37x-further-small-fixes.patch
pata_hpt3x2n-add-hpt371n-support-and-other-bits.patch
pata_pdc2027x-bring-into-line-with-changes-add-the-mode.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
baycom_ser_fdx-also-allow-i-o-ports-=-0x1000-and-enhanced.patch
resend-iphase-64bit-cleanup.patch
serial-suppress-rts-assertion-with-disabled-crtscts.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
tty-remove-unnecessary-export-of-proc_clear_tty.patch
tty-simplify-calling-of-put_pid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
protect-tty-drivers-list-with-tty_mutex.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
