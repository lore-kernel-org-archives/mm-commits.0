From: akpm@osdl.org
Subject: - pata_it8213-add-new-driver-for-the-it8213-card.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:56:40 -0800
Message-ID: <200612130656.kBD6ueNI030747@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58010 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965062AbWLMG45 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:56:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     pata_it8213: Add new driver for the IT8213 card
has been removed from the -mm tree.  Its filename was
     pata_it8213-add-new-driver-for-the-it8213-card.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_it8213: Add new driver for the IT8213 card
From: Alan <alan@lxorguk.ukuu.org.uk>

Add a driver for the IT8213 which is a single channel ICH-ish PATA
controller.  As it is very different to the IT8211/2 it gets its own
driver.  There is a legacy drivers/ide driver also available and I'll post
that once I get time to test it all out (probably early January).  If
anyone else needs the drivers/ide driver and wants to do the merge for
drivers/ide (Bart ??) then I'll forward it.

[akpm@osdl.org: add PCI ID, constify needed_pio[]]
Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/Kconfig       |   11 +
 drivers/ata/Makefile      |    1 
 drivers/ata/pata_it8213.c |  354 ++++++++++++++++++++++++++++++++++++
 include/linux/pci_ids.h   |    1 
 4 files changed, 366 insertions(+), 1 deletion(-)

diff -puN drivers/ata/Kconfig~pata_it8213-add-new-driver-for-the-it8213-card drivers/ata/Kconfig
--- a/drivers/ata/Kconfig~pata_it8213-add-new-driver-for-the-it8213-card
+++ a/drivers/ata/Kconfig
@@ -305,7 +305,7 @@ config PATA_ISAPNP
 	  If unsure, say N.
 
 config PATA_IT821X
-	tristate "IT821x PATA support (Experimental)"
+	tristate "IT8211/2 PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the ITE 8211 and 8212
@@ -314,6 +314,15 @@ config PATA_IT821X
 
 	  If unsure, say N.
 
+config PATA_IT8213
+	tristate "IT8213 PATA support (Experimental)"
+	depends on PCI && EXPERIMENTAL
+	help
+	  This option enables support for the ITE 821 PATA
+          controllers via the new ATA layer.
+
+	  If unsure, say N.
+
 config PATA_JMICRON
 	tristate "JMicron PATA support"
 	depends on PCI
diff -puN drivers/ata/Makefile~pata_it8213-add-new-driver-for-the-it8213-card drivers/ata/Makefile
--- a/drivers/ata/Makefile~pata_it8213-add-new-driver-for-the-it8213-card
+++ a/drivers/ata/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_PATA_HPT3X2N)	+= pata_hpt3x
 obj-$(CONFIG_PATA_HPT3X3)	+= pata_hpt3x3.o
 obj-$(CONFIG_PATA_ISAPNP)	+= pata_isapnp.o
 obj-$(CONFIG_PATA_IT821X)	+= pata_it821x.o
+obj-$(CONFIG_PATA_IT8213)	+= pata_it8213.o
 obj-$(CONFIG_PATA_JMICRON)	+= pata_jmicron.o
 obj-$(CONFIG_PATA_NETCELL)	+= pata_netcell.o
 obj-$(CONFIG_PATA_NS87410)	+= pata_ns87410.o
diff -puN /dev/null drivers/ata/pata_it8213.c
--- /dev/null
+++ a/drivers/ata/pata_it8213.c
@@ -0,0 +1,354 @@
+/*
+ *    pata_it8213.c - iTE Tech. Inc.  IT8213 PATA driver
+ *
+ *    The IT8213 is a very Intel ICH like device for timing purposes, having
+ *    a similar register layout and the same split clock arrangement. Cable
+ *    detection is different, and it does not have slave channels or all the
+ *    clutter of later ICH/SATA setups.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/blkdev.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <scsi/scsi_host.h>
+#include <linux/libata.h>
+#include <linux/ata.h>
+
+#define DRV_NAME	"pata_it8213"
+#define DRV_VERSION	"0.0.2"
+
+/**
+ *	it8213_pre_reset	-	check for 40/80 pin
+ *	@ap: Port
+ *
+ *	Perform cable detection for the 8213 ATA interface. This is
+ *	different to the PIIX arrangement
+ */
+
+static int it8213_pre_reset(struct ata_port *ap)
+{
+	static const struct pci_bits it8213_enable_bits[] = {
+		{ 0x41U, 1U, 0x80UL, 0x80UL },	/* port 0 */
+	};
+
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u8 tmp;
+
+	if (!pci_test_config_bits(pdev, &it8213_enable_bits[ap->port_no]))
+		return -ENOENT;
+
+	pci_read_config_byte(pdev, 0x42, &tmp);
+	if (tmp & 2)	/* The initial docs are incorrect */
+		ap->cbl = ATA_CBL_PATA40;
+	else
+		ap->cbl = ATA_CBL_PATA80;
+	return ata_std_prereset(ap);
+}
+
+/**
+ *	it8213_probe_reset - Probe specified port on PATA host controller
+ *	@ap: Port to probe
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void it8213_error_handler(struct ata_port *ap)
+{
+	ata_bmdma_drive_eh(ap, it8213_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
+}
+
+/**
+ *	it8213_set_piomode - Initialize host controller PATA PIO timings
+ *	@ap: Port whose timings we are configuring
+ *	@adev: um
+ *
+ *	Set PIO mode for device, in host controller PCI config space.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void it8213_set_piomode (struct ata_port *ap, struct ata_device *adev)
+{
+	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
+	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
+	unsigned int idetm_port= ap->port_no ? 0x42 : 0x40;
+	u16 idetm_data;
+	int control = 0;
+
+	/*
+	 *	See Intel Document 298600-004 for the timing programing rules
+	 *	for PIIX/ICH. The 8213 is a clone so very similar
+	 */
+
+	static const	 /* ISP  RTC */
+	u8 timings[][2]	= { { 0, 0 },
+			    { 0, 0 },
+			    { 1, 0 },
+			    { 2, 1 },
+			    { 2, 3 }, };
+
+	if (pio > 2)
+		control |= 1;	/* TIME1 enable */
+	if (ata_pio_need_iordy(adev))	/* PIO 3/4 require IORDY */
+		control |= 2;	/* IORDY enable */
+	/* Bit 2 is set for ATAPI on the IT8213 - reverse of ICH/PIIX */
+	if (adev->class != ATA_DEV_ATA)
+		control |= 4;
+
+	pci_read_config_word(dev, idetm_port, &idetm_data);
+
+	/* Enable PPE, IE and TIME as appropriate */
+
+	if (adev->devno == 0) {
+		idetm_data &= 0xCCF0;
+		idetm_data |= control;
+		idetm_data |= (timings[pio][0] << 12) |
+			(timings[pio][1] << 8);
+	} else {
+		u8 slave_data;
+
+		idetm_data &= 0xCC0F;
+		idetm_data |= (control << 4);
+
+		/* Slave timing in seperate register */
+		pci_read_config_byte(dev, 0x44, &slave_data);
+		slave_data &= 0xF0;
+		slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << 4;
+		pci_write_config_byte(dev, 0x44, slave_data);
+	}
+
+	idetm_data |= 0x4000;	/* Ensure SITRE is enabled */
+	pci_write_config_word(dev, idetm_port, idetm_data);
+}
+
+/**
+ *	it8213_set_dmamode - Initialize host controller PATA DMA timings
+ *	@ap: Port whose timings we are configuring
+ *	@adev: Device to program
+ *
+ *	Set UDMA/MWDMA mode for device, in host controller PCI config space.
+ *	This device is basically an ICH alike.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void it8213_set_dmamode (struct ata_port *ap, struct ata_device *adev)
+{
+	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
+	u16 master_data;
+	u8 speed		= adev->dma_mode;
+	int devid		= adev->devno;
+	u8 udma_enable;
+
+	static const	 /* ISP  RTC */
+	u8 timings[][2]	= { { 0, 0 },
+			    { 0, 0 },
+			    { 1, 0 },
+			    { 2, 1 },
+			    { 2, 3 }, };
+
+	pci_read_config_word(dev, 0x40, &master_data);
+	pci_read_config_byte(dev, 0x48, &udma_enable);
+
+	if (speed >= XFER_UDMA_0) {
+		unsigned int udma = adev->dma_mode - XFER_UDMA_0;
+		u16 udma_timing;
+		u16 ideconf;
+		int u_clock, u_speed;
+
+		/* Clocks follow the PIIX style */
+		u_speed = min(2 - (udma & 1), udma);
+		if (udma == 5)
+			u_clock = 0x1000;	/* 100Mhz */
+		else if (udma > 2)
+			u_clock = 1;		/* 66Mhz */
+		else
+			u_clock = 0;		/* 33Mhz */
+
+		udma_enable |= (1 << devid);
+
+		/* Load the UDMA mode number */
+		pci_read_config_word(dev, 0x4A, &udma_timing);
+		udma_timing &= ~(3 << (4 * devid));
+		udma_timing |= (udma & 3) << (4 * devid);
+		pci_write_config_word(dev, 0x4A, udma_timing);
+
+		/* Load the clock selection */
+		pci_read_config_word(dev, 0x54, &ideconf);
+		ideconf &= ~(0x1001 << devid);
+		ideconf |= u_clock << devid;
+		pci_write_config_word(dev, 0x54, ideconf);
+	} else {
+		/*
+		 * MWDMA is driven by the PIO timings. We must also enable
+		 * IORDY unconditionally along with TIME1. PPE has already
+		 * been set when the PIO timing was set.
+		 */
+		unsigned int mwdma	= adev->dma_mode - XFER_MW_DMA_0;
+		unsigned int control;
+		u8 slave_data;
+		static const unsigned int needed_pio[3] = {
+			XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
+		};
+		int pio = needed_pio[mwdma] - XFER_PIO_0;
+
+		control = 3;	/* IORDY|TIME1 */
+
+		/* If the drive MWDMA is faster than it can do PIO then
+		   we must force PIO into PIO0 */
+
+		if (adev->pio_mode < needed_pio[mwdma])
+			/* Enable DMA timing only */
+			control |= 8;	/* PIO cycles in PIO0 */
+
+		if (devid) {	/* Slave */
+			master_data &= 0xFF4F;  /* Mask out IORDY|TIME1|DMAONLY */
+			master_data |= control << 4;
+			pci_read_config_byte(dev, 0x44, &slave_data);
+			slave_data &= (0x0F + 0xE1 * ap->port_no);
+			/* Load the matching timing */
+			slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << (ap->port_no ? 4 : 0);
+			pci_write_config_byte(dev, 0x44, slave_data);
+		} else { 	/* Master */
+			master_data &= 0xCCF4;	/* Mask out IORDY|TIME1|DMAONLY
+						   and master timing bits */
+			master_data |= control;
+			master_data |=
+				(timings[pio][0] << 12) |
+				(timings[pio][1] << 8);
+		}
+		udma_enable &= ~(1 << devid);
+		pci_write_config_word(dev, 0x40, master_data);
+	}
+	pci_write_config_byte(dev, 0x48, udma_enable);
+}
+
+static struct scsi_host_template it8213_sht = {
+	.module			= THIS_MODULE,
+	.name			= DRV_NAME,
+	.ioctl			= ata_scsi_ioctl,
+	.queuecommand		= ata_scsi_queuecmd,
+	.can_queue		= ATA_DEF_QUEUE,
+	.this_id		= ATA_SHT_THIS_ID,
+	.sg_tablesize		= LIBATA_MAX_PRD,
+	.max_sectors		= ATA_MAX_SECTORS,
+	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
+	.emulated		= ATA_SHT_EMULATED,
+	.use_clustering		= ATA_SHT_USE_CLUSTERING,
+	.proc_name		= DRV_NAME,
+	.dma_boundary		= ATA_DMA_BOUNDARY,
+	.slave_configure	= ata_scsi_slave_config,
+	.bios_param		= ata_std_bios_param,
+	.resume			= ata_scsi_device_resume,
+	.suspend		= ata_scsi_device_suspend,
+};
+
+static const struct ata_port_operations it8213_ops = {
+	.port_disable		= ata_port_disable,
+	.set_piomode		= it8213_set_piomode,
+	.set_dmamode		= it8213_set_dmamode,
+	.mode_filter		= ata_pci_default_filter,
+
+	.tf_load		= ata_tf_load,
+	.tf_read		= ata_tf_read,
+	.check_status		= ata_check_status,
+	.exec_command		= ata_exec_command,
+	.dev_select		= ata_std_dev_select,
+
+	.freeze			= ata_bmdma_freeze,
+	.thaw			= ata_bmdma_thaw,
+	.error_handler		= it8213_error_handler,
+	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+
+	.bmdma_setup		= ata_bmdma_setup,
+	.bmdma_start		= ata_bmdma_start,
+	.bmdma_stop		= ata_bmdma_stop,
+	.bmdma_status		= ata_bmdma_status,
+	.qc_prep		= ata_qc_prep,
+	.qc_issue		= ata_qc_issue_prot,
+	.data_xfer		= ata_pio_data_xfer,
+
+	.irq_handler		= ata_interrupt,
+	.irq_clear		= ata_bmdma_irq_clear,
+
+	.port_start		= ata_port_start,
+	.port_stop		= ata_port_stop,
+	.host_stop		= ata_host_stop,
+};
+
+
+/**
+ *	it8213_init_one - Register 8213 ATA PCI device with kernel services
+ *	@pdev: PCI device to register
+ *	@ent: Entry in it8213_pci_tbl matching with @pdev
+ *
+ *	Called from kernel PCI layer.
+ *
+ *	LOCKING:
+ *	Inherited from PCI layer (may sleep).
+ *
+ *	RETURNS:
+ *	Zero on success, or -ERRNO value.
+ */
+
+static int it8213_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	static int printed_version;
+	static struct ata_port_info info = {
+		.sht		= &it8213_sht,
+		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.pio_mask	= 0x1f,	/* pio0-4 */
+		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.udma_mask 	= 0x1f, /* UDMA 100 */
+		.port_ops	= &it8213_ops,
+	};
+	static struct ata_port_info *port_info[2] = { &info, &info };
+
+	if (!printed_version++)
+		dev_printk(KERN_DEBUG, &pdev->dev,
+			   "version " DRV_VERSION "\n");
+
+	/* Current IT8213 stuff is single port */
+	return ata_pci_init_one(pdev, port_info, 1);
+}
+
+static const struct pci_device_id it8213_pci_tbl[] = {
+	{ PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8213), },
+
+	{ }	/* terminate list */
+};
+
+static struct pci_driver it8213_pci_driver = {
+	.name			= DRV_NAME,
+	.id_table		= it8213_pci_tbl,
+	.probe			= it8213_init_one,
+	.remove			= ata_pci_remove_one,
+	.suspend		= ata_pci_device_suspend,
+	.resume			= ata_pci_device_resume,
+};
+
+static int __init it8213_init(void)
+{
+	return pci_register_driver(&it8213_pci_driver);
+}
+
+static void __exit it8213_exit(void)
+{
+	pci_unregister_driver(&it8213_pci_driver);
+}
+
+module_init(it8213_init);
+module_exit(it8213_exit);
+
+MODULE_AUTHOR("Alan Cox");
+MODULE_DESCRIPTION("SCSI low-level driver for the ITE 8213");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(pci, it8213_pci_tbl);
+MODULE_VERSION(DRV_VERSION);
diff -puN include/linux/pci_ids.h~pata_it8213-add-new-driver-for-the-it8213-card include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~pata_it8213-add-new-driver-for-the-it8213-card
+++ a/include/linux/pci_ids.h
@@ -1621,6 +1621,7 @@
 #define PCI_VENDOR_ID_ITE		0x1283
 #define PCI_DEVICE_ID_ITE_8211		0x8211
 #define PCI_DEVICE_ID_ITE_8212		0x8212
+#define PCI_DEVICE_ID_ITE_8213		0x8213
 #define PCI_DEVICE_ID_ITE_8872		0x8872
 #define PCI_DEVICE_ID_ITE_IT8330G_0	0xe886
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
tty-switch-to-ktermios-nozomi-fix.patch
git-libata-all.patch
ata-fix-platform_device_register_simple-error-check.patch
initializer-entry-defined-twice-in-pata_rz1000.patch
git-mtd.patch
resend-iphase-64bit-cleanup.patch
make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch
perle-multimodem-card-pci-ras-detection.patch
pnx8550-uart-driver.patch
pci-quirks-fix-the-festering-mess-that-claims-to-handle-ide-quirks-ide-fix.patch
via-sb600-sata-quirk.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
xtensa-add-ktermios-and-minor-filename-fix.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
fix-numerous-kcalloc-calls-convert-to-kzalloc.patch
tty-remove-useless-memory-barrier.patch
ide-hpt3xxn-clocking-fixes.patch
ide-fix-hpt37x-timing-tables.patch
ide-optimize-hpt37x-timing-tables.patch
ide-fix-hpt3xx-hotswap-support.patch
ide-fix-the-case-of-multiple-hpt3xx-chips-present.patch
ide-hpt3xx-fix-pci-clock-detection.patch
ide-hpt3xx-fix-pci-clock-detection-fix-2.patch
hpt3xx-rework-rate-filtering.patch
hpt3xx-rework-rate-filtering-tidy.patch
hpt3xx-print-the-real-chip-name-at-startup.patch
hpt3xx-switch-to-using-pci_get_slot.patch
hpt3xx-cache-channels-mcr-address.patch
hpt3x7-merge-speedproc-handlers.patch
hpt370-clean-up-dma-timeout-handling.patch
hpt3xx-init-code-rewrite.patch
piix-fix-82371mx-enablebits.patch
piix-remove-check-for-broken-mw-dma-mode-0.patch
piix-slc90e66-pio-mode-fallback-fix.patch
pdc202xx_new-remove-useless-code.patch
pdc202xx_-remove-check_in_drive_lists-abomination.patch
getting-rid-of-all-casts-of-kalloc-calls.patch

