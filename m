From: akpm@linux-foundation.org
Subject: + pata_pdc202xx_old-fix-timings.patch added to -mm tree
Date: Wed, 26 Sep 2007 15:45:47 -0700
Message-ID: <200709262245.l8QMjlI1007772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45377 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753012AbXIZWqA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 18:46:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     pata_pdc202xx_old: fix timings
has been added to the -mm tree.  Its filename is
     pata_pdc202xx_old-fix-timings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_pdc202xx_old: fix timings
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

I've been doing an audit of this driver to try and find out why we have
problems with some Clevo boxes that use it.  Didn't get anywhere other than
to discover all the bug reporters I have use vmware, which may or may not
be chance.

In the process however I did find out our MWDMA2 performance was a bit low
and code review showed the MWDMA0/2 timings are reversed due to a thinko in
the table ordering

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/ata/pata_pdc202xx_old.c~pata_pdc202xx_old-fix-timings drivers/ata/pata_pdc202xx_old.c
--- a/drivers/ata/pata_pdc202xx_old.c~pata_pdc202xx_old-fix-timings
+++ a/drivers/ata/pata_pdc202xx_old.c
@@ -9,7 +9,7 @@
  * First cut with LBA48/ATAPI
  *
  * TODO:
- *	Channel interlock/reset on both required
+ *	Channel interlock/reset on both required ?
  */
 
 #include <linux/kernel.h>
@@ -22,7 +22,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_pdc202xx_old"
-#define DRV_VERSION "0.4.2"
+#define DRV_VERSION "0.4.3"
 
 static int pdc2026x_cable_detect(struct ata_port *ap)
 {
@@ -106,9 +106,9 @@ static void pdc202xx_set_dmamode(struct 
 		{ 0x20, 0x01 }
 	};
 	static u8 mdma_timing[3][2] = {
-		{ 0x60, 0x03 },
-		{ 0x60, 0x04 },
 		{ 0xe0, 0x0f },
+		{ 0x60, 0x04 },
+		{ 0x60, 0x03 },
 	};
 	u8 r_bp, r_cp;
 
@@ -139,6 +139,9 @@ static void pdc202xx_set_dmamode(struct 
  *
  *	In UDMA3 or higher we have to clock switch for the duration of the
  *	DMA transfer sequence.
+ *
+ *	Note: The host lock held by the libata layer protects
+ *	us from two channels both trying to set DMA bits at once
  */
 
 static void pdc2026x_bmdma_start(struct ata_queued_cmd *qc)
@@ -187,6 +190,9 @@ static void pdc2026x_bmdma_start(struct 
  *
  *	After a DMA completes we need to put the clock back to 33MHz for
  *	PIO timings.
+ *
+ *	Note: The host lock held by the libata layer protects
+ *	us from two channels both trying to set DMA bits at once
  */
 
 static void pdc2026x_bmdma_stop(struct ata_queued_cmd *qc)
@@ -206,7 +212,6 @@ static void pdc2026x_bmdma_stop(struct a
 		iowrite32(0, atapi_reg);
 		iowrite8(ioread8(clock) & ~sel66, clock);
 	}
-	/* Check we keep host level locking here */
 	/* Flip back to 33Mhz for PIO */
 	if (adev->dma_mode >= XFER_UDMA_2)
 		iowrite8(ioread8(clock) & ~sel66, clock);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
pata_acpi-use-ata_sff_port_start.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-add-a-drivers-ide-style-dma-disable.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check.patch
libata-add-a-horkage-entry-for-drq-mishandling-atapi.patch
pata_pdc202xx_old-fix-timings.patch
pata_ns87415-initial-cut-at-87415-87560-ide-support.patch
fix-hpa-handling-regression.patch
libata_scsi-fix-transfer-lengths.patch
pata_atiixp-audit-notes-on-locking.patch
pata_hpt3x2n-clean-up-dpll-stuff.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
introduce-dma_mask_none-as-a-signal-for-unable-to-do.patch
pcmcia-use-dma_mask_none-for-the-default-for-all.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
8250_pci-autodetect-mainpine-cards-fix.patch
wake-up-from-a-serial-port.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
git-scsi-misc.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
tty-bring-the-old-cris-driver-back-somewhere-into-the.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
add-config_vt_unicode.patch
keys-missing-word-in-documentation.patch
ide-cd-is-unmaintained.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-fix.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
