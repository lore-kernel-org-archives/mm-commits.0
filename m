From: akpm@linux-foundation.org
Subject: - pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch removed from -mm tree
Date: Tue, 02 Oct 2007 13:47:12 -0700
Message-ID: <200710022047.l92KlCjS021491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55564 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752709AbXJBUrb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2007 16:47:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pata_acpi: rework the ACPI drivers based upon experience of what the BIOS can do
has been removed from the -mm tree.  Its filename was
     pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch

This patch was dropped because it was folded into pata_acpi-restore-driver.patch

------------------------------------------------------
Subject: pata_acpi: rework the ACPI drivers based upon experience of what the BIOS can do
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Don't assume the BIOS can validate modes or has any sense at all.  Instead use
the BIOS timings to deduce the modes.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_acpi.c |   74 +++++++++++++-------------------------
 1 files changed, 27 insertions(+), 47 deletions(-)

diff -puN drivers/ata/pata_acpi.c~pata_acpi-rework-the-acpi-drivers-based-upon-experience drivers/ata/pata_acpi.c
--- a/drivers/ata/pata_acpi.c~pata_acpi-rework-the-acpi-drivers-based-upon-experience
+++ a/drivers/ata/pata_acpi.c
@@ -2,8 +2,6 @@
  *	ACPI PATA driver
  *
  *	(c) 2007 Red Hat  <alan@redhat.com>
- *
- *	TODO - restore modes after mode_filter chews them up
  */
 
 #include <linux/kernel.h>
@@ -28,7 +26,7 @@
 #include "libata-acpi.h"
 
 #define DRV_NAME	"pata_acpi"
-#define DRV_VERSION	"0.1.1"
+#define DRV_VERSION	"0.2.1"
 
 struct pata_acpi {
 	void *handle;
@@ -122,59 +120,41 @@ static unsigned long pacpi_discover_mode
 	if (!(probe.flags & 0x10))
 		unit = 0;
 
-
-	/* In order to generate a valid mode mask as we need cycle through
-	   trying each proposed speed in turn */
+	ata_acpi_gtm(ap. acpi->handle, &probe);
 
 	/* Start by scanning for PIO modes */
 	for (i = 0; i < 7; i++) {
-		probe.drive[unit].pio = pio_cycle[i];
-		ata_acpi_stm(ap, acpi->handle, &probe);
-		ata_acpi_gtm(ap, acpi->handle, &probe);
 		t = probe.drive[unit].pio;
-		if (t == 0xFFFFFFFF || (i &&  t >= pio_cycle[i-1]))
-			mask &= ~(1 << (i + ATA_SHIFT_PIO));
-	}
-
-	/* Select MWDMA */
-	probe.flags &= ~(1 << (2 * unit));
-
-	/* Scan for MWDMA modes */
-	for (i = 0; i < 5; i++) {
-		u32 t;
-		probe.drive[unit].dma = mwdma_cycle[i];
-		ata_acpi_stm(ap, acpi->handle, &probe);
-		ata_acpi_gtm(ap, acpi->handle, &probe);
-
-		t = probe.drive[unit].dma;
-
-		if (t == 0xFFFFFFFF || (i && t >= mwdma_cycle[i-1]))
-			mask &= ~ (1 << (i + ATA_SHIFT_MWDMA));
+		if (t <= pio_cycle[i]) {
+			mask |= (2 << (ATA_SHIFT_PIO + i)) - 1;
+			break;
+		}
 	}
 
-	/* Select UDMA */
-	probe.flags |= (1 << (2 * unit));
-
-	/* Scan for UDMA modes */
-	for (i = 0; i < 7; i++) {
-		u32 t;
-		probe.drive[unit].dma = udma_cycle[i];
-		ata_acpi_stm(ap, acpi->handle, &probe);
-		ata_acpi_gtm(ap, acpi->handle, &probe);
-
-		t = probe.drive[unit].dma;
-
-		if (t == 0xFFFFFFFF || (i && t >= udma_cycle[i-1]))
-			mask &= ~ (1 << (i + ATA_SHIFT_UDMA));
+	/* See if we have MWDMA or UDMA data. We don't bother with MWDMA
+	   if UDMA is availabe as this means the BIOS set UDMA and our
+	   error changedown if it works is UDMA to PIO anyway */
+	if (probe.flags & (1 << (2 * unit))) {
+		/* MWDMA */
+		for (i = 0; i < 5; i++) {
+			t = probe.drive[unit].dma;
+			if (t <= mwdma_cycle[i]) {
+				mask |= (2 << (ATA_SHIFT_MWDMA + i)) - 1;
+				break;
+			}
+		}
+	} else {
+		/* UDMA */
+		for (i = 0; i < 7; i++) {
+			t = probe.drive[unit].dma;
+			if (t <= udma_cycle[i]) {
+				mask |= (2 << (ATA_SHIFT_UDMA + i)) - 1;
+				break;
+			}
+		}
 	}
-
 	if (mask & (0xF8 << ATA_SHIFT_UDMA))
 		ap->cbl = ATA_CBL_PATA80;
-
-	/* Restore the programmed timings */
-	ata_acpi_stm(ap, acpi->handle, &acpi->gtm);
-	/* And finally we can hand back the list of speeds that actually are
-	   supported by the BIOS */
 	return mask;
 }
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
pata_acpi-restore-driver.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
pata_acpi-use-ata_sff_port_start.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-add-a-drivers-ide-style-dma-disable.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check.patch
libata-add-a-horkage-entry-for-drq-mishandling-atapi.patch
libata_scsi-fix-transfer-lengths.patch
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
fs-correct-sus-compliance-for-open-of-large-file-without.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
usb_serial-stop-passing-null-to-functions-that-expect-data.patch
ark3116-update-termios-handling.patch
usb-serial-kill-another-case-we-pass-null-and-shouldnt.patch
ch341-fix-termios-handling.patch
digi_acceleport-fix-termios-and-also-readability-a-bit.patch
empeg-clean-up-and-handle-speeds.patch
funsoft-fix-termios.patch
ir_usb-termios-handling.patch
keyspan-termios-tidy.patch
kobil_sct-termios-encoding-fixups.patch
option-termios-handling.patch
sierra-termios.patch
usb-serial-handle-null-termios-methods-as-no-hardware-changing-support.patch
visor-termios-bits.patch
