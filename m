From: akpm@osdl.org
Subject: - sata_via-pata-support-resubmit.patch removed from -mm tree
Date: Tue, 09 Jan 2007 12:29:07 -0800
Message-ID: <200701092029.l09KT76H014351@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41162 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932393AbXAIUaN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 15:30:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jgarzik@pobox.com, mm-commits@vger.kernel.org


The patch titled
     sata_via: PATA support
has been removed from the -mm tree.  Its filename was
     sata_via-pata-support-resubmit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sata_via: PATA support
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This is a clean version of the PATA support for the sata_via hardware.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/sata_via.c |  108 ++++++++++++++++++++++++++++++++++++---
 1 files changed, 102 insertions(+), 6 deletions(-)

diff -puN drivers/ata/sata_via.c~sata_via-pata-support-resubmit drivers/ata/sata_via.c
--- a/drivers/ata/sata_via.c~sata_via-pata-support-resubmit
+++ a/drivers/ata/sata_via.c
@@ -59,11 +59,14 @@ enum {
 	SATA_INT_GATE		= 0x41, /* SATA interrupt gating */
 	SATA_NATIVE_MODE	= 0x42, /* Native mode enable */
 	SATA_PATA_SHARING	= 0x49, /* PATA/SATA sharing func ctrl */
-
+	PATA_UDMA_TIMING	= 0xB3, /* PATA timing for DMA/ cable detect */
+	PATA_PIO_TIMING		= 0xAB, /* PATA timing register */
+
 	PORT0			= (1 << 1),
 	PORT1			= (1 << 0),
 	ALL_PORTS		= PORT0 | PORT1,
-	N_PORTS			= 2,
+	PATA_PORT		= 2,	/* PATA is port 2 */
+	N_PORTS			= 3,
 
 	NATIVE_MODE_ALL		= (1 << 7) | (1 << 6) | (1 << 5) | (1 << 4),
 
@@ -75,6 +78,11 @@ static int svia_init_one (struct pci_dev
 static u32 svia_scr_read (struct ata_port *ap, unsigned int sc_reg);
 static void svia_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
 static void vt6420_error_handler(struct ata_port *ap);
+static void vt6421_sata_error_handler(struct ata_port *ap);
+static void vt6421_pata_error_handler(struct ata_port *ap);
+static void vt6421_set_pio_mode(struct ata_port *ap, struct ata_device *adev);
+static void vt6421_set_dma_mode(struct ata_port *ap, struct ata_device *adev);
+static int vt6421_port_start(struct ata_port *ap);
 
 static const struct pci_device_id svia_pci_tbl[] = {
 	{ PCI_VDEVICE(VIA, 0x0591), vt6420 },
@@ -140,9 +148,43 @@ static const struct ata_port_operations 
 	.host_stop		= ata_host_stop,
 };
 
-static const struct ata_port_operations vt6421_sata_ops = {
+static const struct ata_port_operations vt6421_pata_ops = {
 	.port_disable		= ata_port_disable,
+
+	.set_piomode		= vt6421_set_pio_mode,
+	.set_dmamode		= vt6421_set_dma_mode,
+
+	.tf_load		= ata_tf_load,
+	.tf_read		= ata_tf_read,
+	.check_status		= ata_check_status,
+	.exec_command		= ata_exec_command,
+	.dev_select		= ata_std_dev_select,
+
+	.bmdma_setup            = ata_bmdma_setup,
+	.bmdma_start            = ata_bmdma_start,
+	.bmdma_stop		= ata_bmdma_stop,
+	.bmdma_status		= ata_bmdma_status,
+
+	.qc_prep		= ata_qc_prep,
+	.qc_issue		= ata_qc_issue_prot,
+	.data_xfer		= ata_pio_data_xfer,
+
+	.freeze			= ata_bmdma_freeze,
+	.thaw			= ata_bmdma_thaw,
+	.error_handler		= vt6421_pata_error_handler,
+	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
 
+	.irq_handler		= ata_interrupt,
+	.irq_clear		= ata_bmdma_irq_clear,
+
+	.port_start		= vt6421_port_start,
+	.port_stop		= ata_port_stop,
+	.host_stop		= ata_host_stop,
+};
+
+static const struct ata_port_operations vt6421_sata_ops = {
+	.port_disable		= ata_port_disable,
+
 	.tf_load		= ata_tf_load,
 	.tf_read		= ata_tf_read,
 	.check_status		= ata_check_status,
@@ -160,7 +202,7 @@ static const struct ata_port_operations 
 
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
-	.error_handler		= ata_bmdma_error_handler,
+	.error_handler		= vt6421_sata_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
 
 	.irq_handler		= ata_interrupt,
@@ -169,7 +211,7 @@ static const struct ata_port_operations 
 	.scr_read		= svia_scr_read,
 	.scr_write		= svia_scr_write,
 
-	.port_start		= ata_port_start,
+	.port_start		= vt6421_port_start,
 	.port_stop		= ata_port_stop,
 	.host_stop		= ata_host_stop,
 };
@@ -278,6 +320,61 @@ static void vt6420_error_handler(struct 
 				  NULL, ata_std_postreset);
 }
 
+static int vt6421_pata_prereset(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u8 tmp;
+
+	pci_read_config_byte(pdev, PATA_UDMA_TIMING, &tmp);
+	if (tmp & 0x10)
+		ap->cbl = ATA_CBL_PATA40;
+	else
+		ap->cbl = ATA_CBL_PATA80;
+	return 0;
+}
+
+static void vt6421_pata_error_handler(struct ata_port *ap)
+{
+	return ata_bmdma_drive_eh(ap, vt6421_pata_prereset, ata_std_softreset,
+				  NULL, ata_std_postreset);
+}
+
+static int vt6421_sata_prereset(struct ata_port *ap)
+{
+	ap->cbl = ATA_CBL_SATA;
+	return 0;
+}
+
+static void vt6421_sata_error_handler(struct ata_port *ap)
+{
+	return ata_bmdma_drive_eh(ap, vt6421_sata_prereset, ata_std_softreset,
+				  NULL, ata_std_postreset);
+}
+
+static void vt6421_set_pio_mode(struct ata_port *ap, struct ata_device *adev)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	static const u8 pio_bits[] = { 0xA8, 0x65, 0x65, 0x31, 0x20 };
+	pci_write_config_byte(pdev, PATA_PIO_TIMING, pio_bits[adev->pio_mode - XFER_PIO_0]);
+}
+
+static void vt6421_set_dma_mode(struct ata_port *ap, struct ata_device *adev)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	static const u8 udma_bits[] = { 0xEE, 0xE8, 0xE6, 0xE4, 0xE2, 0xE1, 0xE0, 0xE0 };
+	pci_write_config_byte(pdev, PATA_UDMA_TIMING, udma_bits[adev->pio_mode - XFER_UDMA_0]);
+}
+
+static int vt6421_port_start(struct ata_port *ap)
+{
+	if (ap->port_no == PATA_PORT) {
+		ap->ops = &vt6421_pata_ops;
+		ap->mwdma_mask = 0;
+		ap->flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_NO_LEGACY | ATA_FLAG_SRST;
+	}
+	return ata_port_start(ap);
+}
+
 static const unsigned int svia_bar_sizes[] = {
 	8, 4, 8, 4, 16, 256
 };
@@ -500,4 +597,3 @@ static void __exit svia_exit(void)
 
 module_init(svia_init);
 module_exit(svia_exit);
-
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
add-suport-for-marvell-88se6121-in-pata_marvell.patch
git-mtd.patch
z85230-spinlock-logic.patch
resend-iphase-64bit-cleanup.patch
make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch
perle-multimodem-card-pci-ras-detection.patch
pnx8550-uart-driver.patch
pnx8550-uart-driver-fixes.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-tty_wakeup-cleanup.patch
proc-remove-useless-and-buggy-nlink-settings.patch
tty-improve-encode_baud_rate-logic.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
edac-e752x-bit-mask-fix.patch
edac-e752x-byte-access-fix.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
hpt3xx-rework-rate-filtering.patch
hpt3xx-rework-rate-filtering-tidy.patch
hpt3xx-print-the-real-chip-name-at-startup.patch
hpt3xx-switch-to-using-pci_get_slot.patch
hpt3xx-cache-channels-mcr-address.patch
hpt3x7-merge-speedproc-handlers.patch
hpt370-clean-up-dma-timeout-handling.patch
hpt3xx-init-code-rewrite.patch
piix-fix-82371mx-enablebits.patch
pdc202xx_new-remove-useless-code.patch
pdc202xx_-remove-check_in_drive_lists-abomination.patch
piix-tuneproc-fixes-cleanups.patch
slc90e66-carry-over-fixes-from-piix-driver.patch
hpt36x-pci-clock-detection-fix.patch
atiixpc-remove-unused-code.patch
atiixpc-sb600-ide-only-has-one-channel.patch
atiixpc-add-cable-detection-support-for-ati-ide.patch
jmicron-warning-fix.patch
