From: akpm@linux-foundation.org
Subject: + pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch added to -mm tree
Date: Fri, 20 Jul 2007 13:54:12 -0700
Message-ID: <200707202054.l6KKsCPo015894@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50477 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764621AbXGTUy2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 16:54:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com


The patch titled
     pata_acpi: rework the ACPI drivers based upon experience of what the BIOS can do
has been added to the -mm tree.  Its filename is
     pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
pata_ali-correct-hp-detect.patch
pata_cs5520-fix-probe-bug-introduced-by-2622.patch
sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
geode-setup-correct-chipset-access-functions.patch
geode-setup-correct-chipset-access-functions-fix.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
blackfin-enable-arbitary-speed-serial-setting.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
update-coredump-path-in-kernel-to-not-check-coredump-rlim-if-core_pattern-is-a-pipe.patch
iomap-allow-space-for-64bit-i-o-ports.patch
iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer.patch
ata-use-iomap_name.patch
