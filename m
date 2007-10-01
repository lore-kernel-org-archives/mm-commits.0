From: akpm@linux-foundation.org
Subject: - fix-hpa-handling-regression.patch removed from -mm tree
Date: Mon, 01 Oct 2007 00:14:04 -0700
Message-ID: <200710010714.l917E4JY004503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56149 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751758AbXJAHOS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2007 03:14:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ata: fix HPA handling regression
has been removed from the -mm tree.  Its filename was
     fix-hpa-handling-regression.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ata: fix HPA handling regression
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Restore the support for handling drives that report one sector too many (ie
SCSI not ATA style).  This worked before the HPA update but was removed in
that process

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    7 ++++++-
 include/linux/libata.h    |    1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/ata/libata-core.c~fix-hpa-handling-regression drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~fix-hpa-handling-regression
+++ a/drivers/ata/libata-core.c
@@ -919,7 +919,8 @@ static int ata_read_native_max_address(s
 		*max_sectors = ata_tf_to_lba48(&tf);
 	else
 		*max_sectors = ata_tf_to_lba(&tf);
-
+        if (dev->horkage & ATA_HORKAGE_HPA_SIZE)
+		(*max_sectors)--;
 	return 0;
 }
 
@@ -3980,6 +3981,10 @@ static const struct ata_blacklist_entry 
 	{ "WDC WD2500JD-00HBB0", "WD-WMAL71490727", ATA_HORKAGE_BROKEN_HPA },
 	{ "MAXTOR 6L080L4",	"A93.0500",	ATA_HORKAGE_BROKEN_HPA },
 
+	/* Devices which report 1 sector over size HPA */
+	{ "ST340823A",		NULL,		ATA_HORKAGE_HPA_SIZE, },
+	{ "ST320413A",		NULL,		ATA_HORKAGE_HPA_SIZE, },
+
 	/* End Marker */
 	{ }
 };
diff -puN include/linux/libata.h~fix-hpa-handling-regression include/linux/libata.h
--- a/include/linux/libata.h~fix-hpa-handling-regression
+++ a/include/linux/libata.h
@@ -338,6 +338,7 @@ enum {
 	ATA_HORKAGE_BROKEN_HPA	= (1 << 4),	/* Broken HPA */
 	ATA_HORKAGE_SKIP_PM	= (1 << 5),	/* Skip PM operations */
 	ATA_HORKAGE_DRQ		= (1 << 6),	/* Device forgets to clear DRQ on error */
+	ATA_HORKAGE_HPA_SIZE	= (1 << 7), 	/* Reports native size off by one */
 
 	/* DMA mask for user DMA control: User visible values do not
 	   renumber */
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
