From: akpm@linux-foundation.org
Subject: - st340823a-hpa-and-libata.patch removed from -mm tree
Date: Fri, 21 Sep 2007 13:40:17 -0700
Message-ID: <200709212040.l8LKeHt0021515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55275 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757503AbXIUUlC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 16:41:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ST340823A, HPA and libata
has been removed from the -mm tree.  Its filename was
     st340823a-hpa-and-libata.patch

This patch was dropped because Jeff deleted the code with it patches

------------------------------------------------------
Subject: ST340823A, HPA and libata
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Ok this is a different approach to handling it - knowing it is an off by one
so we can handle the drive if clipped

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    7 +++++++
 include/linux/libata.h    |    1 +
 2 files changed, 8 insertions(+)

diff -puN drivers/ata/libata-core.c~st340823a-hpa-and-libata drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~st340823a-hpa-and-libata
+++ a/drivers/ata/libata-core.c
@@ -996,6 +996,10 @@ static u64 ata_hpa_resize(struct ata_dev
 	else
 		hpa_sectors = ata_read_native_max_address(dev);
 
+	/* Reports one sector too many */
+	if (hpa_sectors && (dev->horkage & ATA_HORKAGE_HPA_SIZE))
+		hpa_sectors--;
+
 	if (hpa_sectors > sectors) {
 		ata_dev_printk(dev, KERN_INFO,
 			"Host Protected Area detected:\n"
@@ -3919,6 +3923,9 @@ static const struct ata_blacklist_entry 
 	{ "WDC WD2500JD-00HBB0", "WD-WMAL71490727", ATA_HORKAGE_BROKEN_HPA },
 	{ "MAXTOR 6L080L4",	"A93.0500",	ATA_HORKAGE_BROKEN_HPA },
 
+	/* Devices which report 1 sector over size HPA */
+	{ "ST340823A",		NULL,		ATA_HORKAGE_HPA_SIZE, },
+
 	/* End Marker */
 	{ }
 };
diff -puN include/linux/libata.h~st340823a-hpa-and-libata include/linux/libata.h
--- a/include/linux/libata.h~st340823a-hpa-and-libata
+++ a/include/linux/libata.h
@@ -315,6 +315,7 @@ enum {
 	ATA_HORKAGE_NONCQ	= (1 << 2),	/* Don't use NCQ */
 	ATA_HORKAGE_MAX_SEC_128	= (1 << 3),	/* Limit max sects to 128 */
 	ATA_HORKAGE_BROKEN_HPA	= (1 << 4),	/* Broken HPA */
+	ATA_HORKAGE_HPA_SIZE	= (1 << 5), 	/* Reports native size off by one */
 
 	/* DMA mask for user DMA control: User visible values do not
 	   renumber */
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
pata_acpi-use-ata_sff_port_start.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-add-a-drivers-ide-style-dma-disable.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check.patch
st340823a-hpa-and-libata.patch
libata-update-the-blacklist-with-a-few-more-devices.patch
libata-add-a-horkage-entry-for-drq-mishandling-atapi.patch
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
dtc-fix-typo.patch
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
