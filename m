From: akpm@linux-foundation.org
Subject: - libata-add-a-drivers-ide-style-dma-disable.patch removed from -mm tree
Date: Tue, 02 Oct 2007 15:55:11 -0700
Message-ID: <200710022255.l92MtBP1026766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52610 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753295AbXJBWzd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2007 18:55:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     From: Alan Cox <alan@lxorguk.ukuu.org.uk>
has been removed from the -mm tree.  Its filename was
     libata-add-a-drivers-ide-style-dma-disable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: From: Alan Cox <alan@lxorguk.ukuu.org.uk>


This is useful when debugging, handling problem systems, or for
distributions just to get the system installed so it can be sorted
out later.

This is a bit smarter than the old IDE one and lets you do

libata.pata_dma=0		Disable all PATA DMA like old IDE
libata.pata_dma=1		Disk DMA only
libata.pata_dma=2		ATAPI DMA only
libata.pata_dma=4		CF DMA only

(or combinations thereof - 0,1,3 being the useful ones I suspect)

(I've split CF as it seems to be a seperate case of pain and suffering

SATA is not affected - for one its not clear it makes sense to disable
DMA for SATA if even always possible, for two we've seen no failure
evidence to justify needing to support this kind of hammer on SATA.

Signed-off-by: Alan Cox <alan@redhat.com>
Acked-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |   17 +++++++++++++++++
 include/linux/libata.h    |    6 ++++++
 2 files changed, 23 insertions(+)

diff -puN drivers/ata/libata-core.c~libata-add-a-drivers-ide-style-dma-disable drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-add-a-drivers-ide-style-dma-disable
+++ a/drivers/ata/libata-core.c
@@ -97,6 +97,10 @@ static int ata_ignore_hpa = 0;
 module_param_named(ignore_hpa, ata_ignore_hpa, int, 0644);
 MODULE_PARM_DESC(ignore_hpa, "Ignore HPA limit (0=keep BIOS limits, 1=ignore limits, using full disk)");
 
+static int ata_pata_dma = ATA_DMA_MASK_ATA|ATA_DMA_MASK_ATAPI|ATA_DMA_MASK_CFA;
+module_param_named(pata_dma, ata_pata_dma, int, 0644);
+MODULE_PARM_DESC(pata_dma, "Use DMA on PATA devices");
+
 static int ata_probe_timeout = ATA_TMOUT_INTERNAL / HZ;
 module_param(ata_probe_timeout, int, 0444);
 MODULE_PARM_DESC(ata_probe_timeout, "Set ATA probing timeout (seconds)");
@@ -2897,14 +2901,27 @@ int ata_do_set_mode(struct ata_link *lin
 	/* step 1: calculate xfer_mask */
 	ata_link_for_each_dev(dev, link) {
 		unsigned int pio_mask, dma_mask;
+		unsigned int mode_mask;
 
 		if (!ata_dev_enabled(dev))
 			continue;
 
+		mode_mask = ATA_DMA_MASK_ATA;
+		if (dev->class == ATA_DEV_ATAPI)
+			mode_mask = ATA_DMA_MASK_ATAPI;
+		else if (ata_id_is_cfa(dev->id))
+			mode_mask = ATA_DMA_MASK_CFA;
+
 		ata_dev_xfermask(dev);
 
 		pio_mask = ata_pack_xfermask(dev->pio_mask, 0, 0);
 		dma_mask = ata_pack_xfermask(0, dev->mwdma_mask, dev->udma_mask);
+
+		if ((ata_pata_dma & mode_mask) || ap->cbl == ATA_CBL_SATA)
+			dma_mask = ata_pack_xfermask(0, dev->mwdma_mask, dev->udma_mask);
+		else
+			dma_mask = 0;
+
 		dev->pio_mode = ata_xfer_mask2mode(pio_mask);
 		dev->dma_mode = ata_xfer_mask2mode(dma_mask);
 
diff -puN include/linux/libata.h~libata-add-a-drivers-ide-style-dma-disable include/linux/libata.h
--- a/include/linux/libata.h~libata-add-a-drivers-ide-style-dma-disable
+++ a/include/linux/libata.h
@@ -338,6 +338,12 @@ enum {
 	ATA_HORKAGE_BROKEN_HPA	= (1 << 4),	/* Broken HPA */
 	ATA_HORKAGE_SKIP_PM	= (1 << 5),	/* Skip PM operations */
 	ATA_HORKAGE_HPA_SIZE	= (1 << 6),	/* native size off by one */
+
+	/* DMA mask for user DMA control: User visible values do not
+	   renumber */
+	ATA_DMA_MASK_ATA	= (1 << 0),	/* DMA on ATA Disk */
+	ATA_DMA_MASK_ATAPI	= (1 << 1),	/* DMA on ATAPI */
+	ATA_DMA_MASK_CFA	= (1 << 2),	/* DMA on CF Card */
 };
 
 enum hsm_task_states {
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
libata-correct-handling-of-srst-reset-sequences.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check.patch
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
