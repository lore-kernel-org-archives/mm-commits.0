From: akpm@linux-foundation.org
Subject: + testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch added to -mm tree
Date: Wed, 28 Mar 2007 15:34:57 -0700
Message-ID: <200703282234.l2SMYvXS021752@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34263 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933741AbXC1WfC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 18:35:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk


The patch titled
     Testing patch for ALi PATA - fixes hopefully for the problems with ATAPI DMA
has been added to the -mm tree.  Its filename is
     testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_ali.c |   87 ++++++++++++++++++++++++++++++++++++---
 1 files changed, 81 insertions(+), 6 deletions(-)

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
+void ali_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
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
@@ -304,7 +375,7 @@ static struct scsi_host_template ali_sht
 static struct ata_port_operations ali_early_port_ops = {
 	.port_disable	= ata_port_disable,
 	.set_piomode	= ali_set_piomode,
-	.tf_load	= ata_tf_load,
+	.tf_load	= ali_tf_load,
 	.tf_read	= ata_tf_read,
 	.check_status 	= ata_check_status,
 	.exec_command	= ata_exec_command,
@@ -318,6 +389,7 @@ static struct ata_port_operations ali_ea
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
+	.check_atapi_dma= ali_check_atapi_dma,
 
 	.data_xfer	= ata_data_xfer,
 
@@ -340,7 +412,7 @@ static struct ata_port_operations ali_20
 	.set_dmamode	= ali_set_dmamode,
 	.mode_filter	= ali_20_filter,
 
-	.tf_load	= ata_tf_load,
+	.tf_load	= ali_tf_load,
 	.tf_read	= ata_tf_read,
 	.check_status 	= ata_check_status,
 	.exec_command	= ata_exec_command,
@@ -360,6 +432,7 @@ static struct ata_port_operations ali_20
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
+	.check_atapi_dma= ali_check_atapi_dma,
 
 	.data_xfer	= ata_data_xfer,
 
@@ -379,7 +452,7 @@ static struct ata_port_operations ali_c2
 	.set_piomode	= ali_set_piomode,
 	.set_dmamode	= ali_set_dmamode,
 	.mode_filter	= ata_pci_default_filter,
-	.tf_load	= ata_tf_load,
+	.tf_load	= ali_tf_load,
 	.tf_read	= ata_tf_read,
 	.check_status 	= ata_check_status,
 	.exec_command	= ata_exec_command,
@@ -399,6 +472,7 @@ static struct ata_port_operations ali_c2
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
+	.check_atapi_dma= ali_check_atapi_dma,
 
 	.data_xfer	= ata_data_xfer,
 
@@ -418,7 +492,7 @@ static struct ata_port_operations ali_c5
 	.set_piomode	= ali_set_piomode,
 	.set_dmamode	= ali_set_dmamode,
 	.mode_filter	= ata_pci_default_filter,
-	.tf_load	= ata_tf_load,
+	.tf_load	= ali_tf_load,
 	.tf_read	= ata_tf_read,
 	.check_status 	= ata_check_status,
 	.exec_command	= ata_exec_command,
@@ -437,6 +511,7 @@ static struct ata_port_operations ali_c5
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
+	.check_atapi_dma= ali_check_atapi_dma,
 
 	.data_xfer	= ata_data_xfer,
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
generic_serial-fix-decoding-of-baud-rate.patch
tty-minor-merge-correction.patch
git-libata-all.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
libata-misc-minor-merge-fixups.patch
pata_pdc202xx_old-lba48-bug.patch
pata_hpt37x-further-small-fixes.patch
pata_hpt3x2n-add-hpt371n-support-and-other-bits.patch
pata_pdc2027x-bring-into-line-with-changes-add-the-mode.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
baycom_ser_fdx-also-allow-i-o-ports-=-0x1000-and-enhanced.patch
serial-suppress-rts-assertion-with-disabled-crtscts.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
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
revoke-core-code-revoke-no-revoke-for-nommu.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch
