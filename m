From: akpm@linux-foundation.org
Subject: - pata_hpt3x3-major-reworking-and-testing.patch removed from -mm tree
Date: Fri, 13 Jul 2007 15:32:51 -0700
Message-ID: <200707132232.l6DMWpoG025028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59356 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757151AbXGMWdi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 18:33:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, bzolnier@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pata_hpt3x3: major reworking and testing
has been removed from the -mm tree.  Its filename was
     pata_hpt3x3-major-reworking-and-testing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_hpt3x3: major reworking and testing
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The HPT343/345 (aka 363) is a bit of a warped device.  For many setups you
need to access the other registers via BAR4 offsets.  PIO is now rock
solid, DMA isn't.  Unfortunately the drivers/ide hpt34x driver is
completely broken so doesn't help further debug.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/Kconfig       |   10 +++-
 drivers/ata/pata_hpt3x3.c |   90 ++++++++++++++++++++++++++++++------
 2 files changed, 85 insertions(+), 15 deletions(-)

diff -puN drivers/ata/Kconfig~pata_hpt3x3-major-reworking-and-testing drivers/ata/Kconfig
--- a/drivers/ata/Kconfig~pata_hpt3x3-major-reworking-and-testing
+++ a/drivers/ata/Kconfig
@@ -318,7 +318,7 @@ config PATA_HPT3X2N
 	  If unsure, say N.
 
 config PATA_HPT3X3
-	tristate "HPT 343/363 PATA support (Experimental)"
+	tristate "HPT 343/363 PATA support"
 	depends on PCI
 	help
 	  This option enables support for the HPT 343/363
@@ -326,6 +326,14 @@ config PATA_HPT3X3
 
 	  If unsure, say N.
 
+config PATA_HPT3X3_DMA
+	bool "HPT 343/363 DMA support (Experimental)"
+	depends on PATA_HPT3X3
+	help
+	  This option enables DMA support for the HPT343/363
+	  controllers. Enable with care as there are still some
+	  problems with DMA on this chipset.
+
 config PATA_ISAPNP
 	tristate "ISA Plug and Play PATA support (Experimental)"
 	depends on EXPERIMENTAL && ISAPNP
diff -puN drivers/ata/pata_hpt3x3.c~pata_hpt3x3-major-reworking-and-testing drivers/ata/pata_hpt3x3.c
--- a/drivers/ata/pata_hpt3x3.c~pata_hpt3x3-major-reworking-and-testing
+++ a/drivers/ata/pata_hpt3x3.c
@@ -23,7 +23,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt3x3"
-#define DRV_VERSION	"0.4.3"
+#define DRV_VERSION	"0.5.3"
 
 /**
  *	hpt3x3_set_piomode		-	PIO setup
@@ -59,6 +59,9 @@ static void hpt3x3_set_piomode(struct at
  *
  *	Set up the channel for MWDMA or UDMA modes. Much the same as with
  *	PIO, load the mode number and then set MWDMA or UDMA flag.
+ *
+ *	0x44 : bit 0-2 master mode, 3-5 slave mode, etc
+ *	0x48 : bit 4/0 DMA/UDMA bit 5/1 for slave etc
  */
 
 static void hpt3x3_set_dmamode(struct ata_port *ap, struct ata_device *adev)
@@ -76,14 +79,26 @@ static void hpt3x3_set_dmamode(struct at
 	r2 &= ~(0x11 << dn);	/* Clear MWDMA and UDMA bits */
 
 	if (adev->dma_mode >= XFER_UDMA_0)
-		r2 |= 0x01 << dn;	/* Ultra mode */
+		r2 |= (0x10 << dn);	/* Ultra mode */
 	else
-		r2 |= 0x10 << dn;	/* MWDMA */
+		r2 |= (0x01 << dn);	/* MWDMA */
 
 	pci_write_config_dword(pdev, 0x44, r1);
 	pci_write_config_dword(pdev, 0x48, r2);
 }
 
+/**
+ *	hpt3x3_atapi_dma	-	ATAPI DMA check
+ *	@qc: Queued command
+ *
+ *	Just say no - we don't do ATAPI DMA
+ */
+
+static int hpt3x3_atapi_dma(struct ata_queued_cmd *qc)
+{
+	return 1;
+}
+
 static struct scsi_host_template hpt3x3_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -105,7 +120,6 @@ static struct scsi_host_template hpt3x3_
 static struct ata_port_operations hpt3x3_port_ops = {
 	.port_disable	= ata_port_disable,
 	.set_piomode	= hpt3x3_set_piomode,
-	.set_dmamode	= hpt3x3_set_dmamode,
 	.mode_filter	= ata_pci_default_filter,
 
 	.tf_load	= ata_tf_load,
@@ -124,6 +138,7 @@ static struct ata_port_operations hpt3x3
 	.bmdma_start 	= ata_bmdma_start,
 	.bmdma_stop	= ata_bmdma_stop,
 	.bmdma_status 	= ata_bmdma_status,
+	.check_atapi_dma= hpt3x3_atapi_dma,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
@@ -158,32 +173,79 @@ static void hpt3x3_init_chipset(struct p
 		pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x20);
 }
 
-
 /**
  *	hpt3x3_init_one		-	Initialise an HPT343/363
- *	@dev: PCI device
+ *	@pdev: PCI device
  *	@id: Entry in match table
  *
- *	Perform basic initialisation. The chip has a quirk that it won't
- *	function unless it is at XX00. The old ATA driver touched this up
- *	but we leave it for pci quirks to do properly.
+ *	Perform basic initialisation. We set the device up so we access all
+ *	ports via BAR4. This is neccessary to work around errata.
  */
 
-static int hpt3x3_init_one(struct pci_dev *dev, const struct pci_device_id *id)
+static int hpt3x3_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
+	static int printed_version;
 	static const struct ata_port_info info = {
 		.sht = &hpt3x3_sht,
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
+#if defined(CONFIG_PATA_HPT3X3_DMA)
+		/* Further debug needed */
 		.mwdma_mask = 0x07,
 		.udma_mask = 0x07,
+#endif
 		.port_ops = &hpt3x3_port_ops
 	};
+	/* Register offsets of taskfiles in BAR4 area */
+	static const u8 offset_cmd[2] = { 0x20, 0x28 };
+	static const u8 offset_ctl[2] = { 0x36, 0x3E };
 	const struct ata_port_info *ppi[] = { &info, NULL };
-
-	hpt3x3_init_chipset(dev);
-	/* Now kick off ATA set up */
-	return ata_pci_init_one(dev, ppi);
+	struct ata_host *host;
+	int i, rc;
+	void __iomem *base;
+
+	hpt3x3_init_chipset(pdev);
+
+	if (!printed_version++)
+		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+
+	host = ata_host_alloc_pinfo(&pdev->dev, ppi, 2);
+	if (!host)
+		return -ENOMEM;
+	/* acquire resources and fill host */
+	rc = pcim_enable_device(pdev);
+	if (rc)
+		return rc;
+
+	/* Everything is relative to BAR4 if we set up this way */
+	rc = pcim_iomap_regions(pdev, 1 << 4, DRV_NAME);
+	if (rc == -EBUSY)
+		pcim_pin_device(pdev);
+	if (rc)
+		return rc;
+	host->iomap = pcim_iomap_table(pdev);
+	rc = pci_set_dma_mask(pdev, ATA_DMA_MASK);
+	if (rc)
+		return rc;
+	rc = pci_set_consistent_dma_mask(pdev, ATA_DMA_MASK);
+	if (rc)
+		return rc;
+
+	base = host->iomap[4];	/* Bus mastering base */
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_ioports *ioaddr = &host->ports[i]->ioaddr;
+
+		ioaddr->cmd_addr = base + offset_cmd[i];
+		ioaddr->altstatus_addr =
+		ioaddr->ctl_addr = base + offset_ctl[i];
+		ioaddr->scr_addr = NULL;
+		ata_std_ports(ioaddr);
+		ioaddr->bmdma_addr = base + 8 * i;
+	}
+	pci_set_master(pdev);
+	return ata_host_activate(host, pdev->irq, ata_interrupt, IRQF_SHARED,
+				 &hpt3x3_sht);
 }
 
 #ifdef CONFIG_PM
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-powerpc.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer.patch
ata-use-iomap_name.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
git-scsi-misc.patch
ppa-coding-police-and-printk-levels.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
geode-basic-infrastructure-support-for-amd-geode-class.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
blackfin-enable-arbitary-speed-serial-setting.patch
h8300-enable-arbitary-speed-tty-port-setup.patch
arm26-enable-arbitary-speed-tty-ioctls-and-split.patch
m32r-enable-arbitary-speed-tty-rate-setting.patch
etrax-enable-arbitary-speed-setting-on-tty-ports.patch
v850-enable-arbitary-speed-tty-ioctls.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
update-zilog-timeout.patch
edd-switch-to-pci_get-based-api.patch
mpu401-warning-fixes.patch
char-tty_ioctl-use-wait_event_interruptible_timeout.patch
char-tty_ioctl-little-whitespace-cleanup.patch
intel-rng-undo-mess-made-by-an-80-column-extremist.patch
improve-behaviour-of-spurious-irq-detect.patch
audit-add-tty-input-auditing.patch
revert-vanishing-ioctl-handler-debugging.patch
amiserial-remove-incorrect-no-termios-change-check.patch
genericserial-remove-bogus-optimisation-check-and-dead-code-paths.patch
synclink-remove-bogus-no-change-termios-optimisation.patch
68360serial-remove-broken-optimisation.patch
serial-remove-termios-checks-from-various-old-char-serial.patch
ia64-arbitary-speed-tty-ioctl-support.patch
sb1250-duartc-sb1250-duart-serial-support.patch
i2o_cfg_passthru-cleanup.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
stallion-remove-unneeded-lock_kernel.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
driver-edac-add-mips-and-ppc-visibility.patch
driver-edac-mod-race-fix-i82875p.patch
driver-edac-fix-ignored-return-i82875p.patch
include-linux-pci_id-h-add-amd-northbridge-defines.patch
drivers-edac-fix-edac_device-semaphore-to-mutex.patch
drivers-edac-fix-e752x-reversed-csrows.patch
drivers-edac-fix-e752x-reversed-csrows-fix.patch
drivers-edac-new-pasemi-driver.patch
drivers-edac-new-pasemi-driver-fix.patch
drivers-edac-fix-leaf-sysfs-attribute.patch
drivers-edac-fix-edac_mc-init-apis.patch
drivers-edac-fix-edac_device-init-apis.patch
drivers-edac-fix-edac_mc-sysfs-completion-code.patch
drivers-edac-fix-edac_device-sysfs-completion-code.patch
