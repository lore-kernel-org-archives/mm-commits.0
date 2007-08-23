From: akpm@linux-foundation.org
Subject: + libata-add-a-drivers-ide-style-dma-disable.patch added to -mm tree
Date: Thu, 23 Aug 2007 15:26:16 -0700
Message-ID: <200708232226.l7NMQH0S029888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38245 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763875AbXHWW06 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 18:26:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     From: Alan Cox <alan@lxorguk.ukuu.org.uk>
has been added to the -mm tree.  Its filename is
     libata-add-a-drivers-ide-style-dma-disable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |   17 +++++++++++++++++
 include/linux/libata.h    |    6 ++++++
 2 files changed, 23 insertions(+)

diff -puN drivers/ata/libata-core.c~libata-add-a-drivers-ide-style-dma-disable drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-add-a-drivers-ide-style-dma-disable
+++ a/drivers/ata/libata-core.c
@@ -99,6 +99,10 @@ static int ata_ignore_hpa = 0;
 module_param_named(ignore_hpa, ata_ignore_hpa, int, 0644);
 MODULE_PARM_DESC(ignore_hpa, "Ignore HPA limit (0=keep BIOS limits, 1=ignore limits, using full disk)");
 
+static int ata_pata_dma = ATA_DMA_MASK_ATA|ATA_DMA_MASK_ATAPI|ATA_DMA_MASK_CFA;
+module_param_named(pata_dma, ata_pata_dma, int, 0644);
+MODULE_PARM_DESC(pata_dma, "Use DMA on PATA devices");
+
 static int ata_probe_timeout = ATA_TMOUT_INTERNAL / HZ;
 module_param(ata_probe_timeout, int, 0444);
 MODULE_PARM_DESC(ata_probe_timeout, "Set ATA probing timeout (seconds)");
@@ -2846,14 +2850,27 @@ int ata_do_set_mode(struct ata_link *lin
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
@@ -314,6 +314,12 @@ enum {
 	ATA_HORKAGE_NODMA	= (1 << 1),	/* DMA problems */
 	ATA_HORKAGE_NONCQ	= (1 << 2),	/* Don't use NCQ */
 	ATA_HORKAGE_MAX_SEC_128	= (1 << 3),	/* Limit max sects to 128 */
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

origin.patch
serial-add-support-for-ite-887x-chips.patch
serial_txx9-fix-modem-control-line-handling.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
fix-null-pointer-dereference-in-__vm_enough_memory.patch
m68k-enable-arbitary-speed-tty-support.patch
introduce-config_check_signature-was-re-uninline.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-switch-most-of-the-remaining-sff-drivers-to.patch
pata_sis-add-the-fsc-amilo-and-friends.patch
pata_via-add-armia-w730-k8-and-other-rebadgings.patch
pata_marvell-add-more-identifiers.patch
libata-portmap-remove-unused-definitions.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-spot-bridge-chips.patch
libata-allow-for-original-ide-drives-that-dont-support-geometry-setting.patch
libata-strict-checking-for-identify-reporting.patch
libata-add-a-drivers-ide-style-dma-disable.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
git-scsi-misc.patch
fix-gregkh-usb-usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
kobil_sct-rework-driver.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
pata_it821x-fix-regression-corruptor.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
