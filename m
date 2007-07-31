From: akpm@linux-foundation.org
Subject: - testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch removed from -mm tree
Date: Tue, 31 Jul 2007 03:10:29 -0700
Message-ID: <200707311010.l6VAATK9028031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45464 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754200AbXGaKKr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 06:10:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     Testing patch for ALi PATA - fixes hopefully for the problems with ATAPI DMA
has been removed from the -mm tree.  Its filename was
     testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: Testing patch for ALi PATA - fixes hopefully for the problems with ATAPI DMA
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This implements two things at driver level which are implemented
implicitly by the old IDE layer

- Only doing sector sized ATAPI I/O via DMA
- Alway writing the size values

Hopefully this will make CD devices behave better for those with the
problems. If you can test both the detection and mounting/reading of a CD
works nicely that would be great, and then if you can see whether it is
the size check or the use of ali_tf_load v ata_tf_load that fixes it this
would be ideal.

Currently I don't have an ALi device with the problem so its a bit hard
to debug.

[bunk@stusta.de: make drivers/ata/pata_ali.c:ali_tf_load() static]

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_ali.c |   87 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 81 insertions(+), 6 deletions(-)

diff -puN drivers/ata/pata_ali.c~testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma drivers/ata/pata_ali.c
--- a/drivers/ata/pata_ali.c~testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma
+++ a/drivers/ata/pata_ali.c
@@ -233,8 +233,8 @@ static void ali_set_dmamode(struct ata_p
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
 
-	if (adev->class == ATA_DEV_ATA)
-		ali_fifo_control(ap, adev, 0x08);
+/*	if (adev->class == ATA_DEV_ATA)
+		ali_fifo_control(ap, adev, 0x08); */
 
 	if (adev->dma_mode >= XFER_UDMA_0) {
 		ali_program_modes(ap, adev, NULL, udma_timing[adev->dma_mode - XFER_UDMA_0]);
@@ -275,6 +275,77 @@ static void ali_lock_sectors(struct ata_
 	adev->max_sectors = 255;
 }
 
+/**
+ *	ali_tf_load - send taskfile registers to host controller
+ *	@ap: Port to which output is sent
+ *	@tf: ATA taskfile register set
+ *
+ *	Outputs ATA taskfile to standard ATA host controller. We can't
+ *	use the default one as the onboard FIFO logic requires that we
+ *	write all the registers (see 1535 BIOS programming guide)
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+
+static void ali_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
+{
+	struct ata_ioports *ioaddr = &ap->ioaddr;
+	unsigned int is_addr = tf->flags & ATA_TFLAG_ISADDR;
+
+	iowrite8(tf->ctl, ioaddr->ctl_addr);
+	ap->last_ctl = tf->ctl;
+	ata_wait_idle(ap);
+
+	if (is_addr && (tf->flags & ATA_TFLAG_LBA48)) {
+		iowrite8(tf->hob_feature, ioaddr->feature_addr);
+		iowrite8(tf->hob_nsect, ioaddr->nsect_addr);
+		iowrite8(tf->hob_lbal, ioaddr->lbal_addr);
+		iowrite8(tf->hob_lbam, ioaddr->lbam_addr);
+		iowrite8(tf->hob_lbah, ioaddr->lbah_addr);
+		VPRINTK("hob: feat 0x%X nsect 0x%X, lba 0x%X 0x%X 0x%X\n",
+			tf->hob_feature,
+			tf->hob_nsect,
+			tf->hob_lbal,
+			tf->hob_lbam,
+			tf->hob_lbah);
+	}
+	if (is_addr) {
+		iowrite8(tf->feature, ioaddr->feature_addr);
+		iowrite8(tf->nsect, ioaddr->nsect_addr);
+		iowrite8(tf->lbal, ioaddr->lbal_addr);
+		iowrite8(tf->lbam, ioaddr->lbam_addr);
+		iowrite8(tf->lbah, ioaddr->lbah_addr);
+		VPRINTK("feat 0x%X nsect 0x%X lba 0x%X 0x%X 0x%X\n",
+			tf->feature,
+			tf->nsect,
+			tf->lbal,
+			tf->lbam,
+			tf->lbah);
+	} else {
+		iowrite8(0, ioaddr->feature_addr);
+		iowrite8(0, ioaddr->nsect_addr);
+		iowrite8(0, ioaddr->lbal_addr);
+		iowrite8(0, ioaddr->lbam_addr);
+		iowrite8(0, ioaddr->lbah_addr);
+	}
+
+	if (tf->flags & ATA_TFLAG_DEVICE) {
+		iowrite8(tf->device, ioaddr->device_addr);
+		VPRINTK("device 0x%X\n", tf->device);
+	}
+
+	ata_wait_idle(ap);
+}
+
+static int ali_check_atapi_dma(struct ata_queued_cmd *qc)
+{
+	/* Don't do DMA except for whole blocks */
+	if (qc->nbytes & 511)
+		return -1;
+	return 0;
+}
+
 static struct scsi_host_template ali_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -300,7 +371,7 @@ static struct scsi_host_template ali_sht
 static struct ata_port_operations ali_early_port_ops = {
 	.port_disable	= ata_port_disable,
 	.set_piomode	= ali_set_piomode,
-	.tf_load	= ata_tf_load,
+	.tf_load	= ali_tf_load,
 	.tf_read	= ata_tf_read,
 	.check_status 	= ata_check_status,
 	.exec_command	= ata_exec_command,
@@ -314,6 +385,7 @@ static struct ata_port_operations ali_ea
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
+	.check_atapi_dma= ali_check_atapi_dma,
 
 	.data_xfer	= ata_data_xfer,
 
@@ -336,7 +408,7 @@ static struct ata_port_operations ali_20
 	.set_dmamode	= ali_set_dmamode,
 	.mode_filter	= ali_20_filter,
 
-	.tf_load	= ata_tf_load,
+	.tf_load	= ali_tf_load,
 	.tf_read	= ata_tf_read,
 	.check_status 	= ata_check_status,
 	.exec_command	= ata_exec_command,
@@ -356,6 +428,7 @@ static struct ata_port_operations ali_20
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
+	.check_atapi_dma= ali_check_atapi_dma,
 
 	.data_xfer	= ata_data_xfer,
 
@@ -375,7 +448,7 @@ static struct ata_port_operations ali_c2
 	.set_piomode	= ali_set_piomode,
 	.set_dmamode	= ali_set_dmamode,
 	.mode_filter	= ata_pci_default_filter,
-	.tf_load	= ata_tf_load,
+	.tf_load	= ali_tf_load,
 	.tf_read	= ata_tf_read,
 	.check_status 	= ata_check_status,
 	.exec_command	= ata_exec_command,
@@ -395,6 +468,7 @@ static struct ata_port_operations ali_c2
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
+	.check_atapi_dma= ali_check_atapi_dma,
 
 	.data_xfer	= ata_data_xfer,
 
@@ -414,7 +488,7 @@ static struct ata_port_operations ali_c5
 	.set_piomode	= ali_set_piomode,
 	.set_dmamode	= ali_set_dmamode,
 	.mode_filter	= ata_pci_default_filter,
-	.tf_load	= ata_tf_load,
+	.tf_load	= ali_tf_load,
 	.tf_read	= ata_tf_read,
 	.check_status 	= ata_check_status,
 	.exec_command	= ata_exec_command,
@@ -433,6 +507,7 @@ static struct ata_port_operations ali_c5
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
+	.check_atapi_dma= ali_check_atapi_dma,
 
 	.data_xfer	= ata_data_xfer,
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
nozomi-shoot-defunct-label.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742.patch
libata-acpi-checks-for-80wire-cable-headers.patch
libata-acpi-checks-for-80wire-cable-implementation.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_amd.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_via.patch
libata-sff-unbreak-non-dma-capable-controllers-again.patch
pata_cmd64x-correct-the-speed-ranges.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
dtc-clean-up-indent-damage-and-add-printk-levels.patch
kl5kusb105-switch-to-new-speed-api.patch
mct_u232-convert-to-proper-speed-handling-api-fix.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
blackfin-enable-arbitary-speed-serial-setting.patch
char-cyclades-remove-bottom-half-processing.patch
