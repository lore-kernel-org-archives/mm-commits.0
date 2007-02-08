From: akpm@linux-foundation.org
Subject: - pata_acpi-take-two.patch removed from -mm tree
Date: Wed, 07 Feb 2007 16:29:30 -0800
Message-ID: <200702080030.l180UavU032712@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47802 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422896AbXBHAcQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 19:32:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     pata_acpi: take two
has been removed from the -mm tree.  Its filename was
     pata_acpi-take-two.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: pata_acpi: take two
From: Alan <alan@lxorguk.ukuu.org.uk>

This is a driver for motherboard SFF style PATA ports that have ACPI
control methods.  In theory it provides support for just about any
motherboard PATA controller with ACPI methods.  I've tested it on a few
controllers and it seems to work fine after a couple of bug fixes from the
original.

It also turns out the correct way to handle the Nvidia PATA (and the only
vendor sane way to get cable detect bits) is to use ACPI for Nvidia PATA. 
The patch therefore also punts the Nvidia hardware to the ACPI driver but
IFF the ACPI driver is compiled in, the Nvidia device has ACPI methods and
ACPI is currently in use.  If not it falls back to the AMD driver which
handles it as a sort of bad AMD clone.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/Kconfig       |    9 
 drivers/ata/Makefile      |    2 
 drivers/ata/libata-acpi.c |   90 +++++++-
 drivers/ata/libata-acpi.h |   47 ++++
 drivers/ata/pata_acpi.c   |  405 ++++++++++++++++++++++++++++++++++++
 drivers/ata/pata_amd.c    |    5 
 6 files changed, 557 insertions(+), 1 deletion(-)

diff -puN drivers/ata/Kconfig~pata_acpi-take-two drivers/ata/Kconfig
--- a/drivers/ata/Kconfig~pata_acpi-take-two
+++ a/drivers/ata/Kconfig
@@ -174,6 +174,15 @@ config SATA_ACPI
 	  You can disable this at kernel boot time by using the
 	  option libata.noacpi=1
 
+config PATA_ACPI
+	tristate "ACPI firmware driver for PATA"
+	depends on ACPI && PCI && SATA_ACPI
+	help
+	  This option enables an ACPI method driver which drives
+	  motherboard PATA controller interfaces through the ACPI
+	  firmware in the BIOS. This driver can sometimes handle
+	  otherwise unsupported hardware.
+
 config PATA_ALI
 	tristate "ALi PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
diff -puN drivers/ata/Makefile~pata_acpi-take-two drivers/ata/Makefile
--- a/drivers/ata/Makefile~pata_acpi-take-two
+++ a/drivers/ata/Makefile
@@ -60,6 +60,8 @@ obj-$(CONFIG_PATA_SIS)		+= pata_sis.o
 obj-$(CONFIG_PATA_TRIFLEX)	+= pata_triflex.o
 obj-$(CONFIG_PATA_IXP4XX_CF)	+= pata_ixp4xx_cf.o
 obj-$(CONFIG_PATA_PLATFORM)	+= pata_platform.o
+# Should be last but two libata driver
+obj-$(CONFIG_PATA_ACPI)		+= pata_acpi.o
 # Should be last but one libata driver
 obj-$(CONFIG_ATA_GENERIC)	+= ata_generic.o
 # Should be last libata driver
diff -puN drivers/ata/libata-acpi.c~pata_acpi-take-two drivers/ata/libata-acpi.c
--- a/drivers/ata/libata-acpi.c~pata_acpi-take-two
+++ a/drivers/ata/libata-acpi.c
@@ -15,7 +15,7 @@
 #include <linux/libata.h>
 #include <linux/pci.h>
 #include "libata.h"
-
+#include "libata-acpi.h"
 #include <acpi/acpi_bus.h>
 #include <acpi/acnames.h>
 #include <acpi/acnamesp.h>
@@ -696,3 +696,91 @@ out:
 }
 
 
+int ata_acpi_gtm(const struct ata_port *ap, void *handle, struct acpi_gtm *gtm)
+{
+	acpi_status status;
+	struct acpi_buffer output;
+
+	output.length = ACPI_ALLOCATE_BUFFER;
+	output.pointer = NULL;
+
+	status = acpi_evaluate_object(handle, "_GTM", NULL, &output);
+
+	if (ACPI_FAILURE(status)) {
+		ata_port_printk(ap, KERN_ERR, "ACPI get timing mode failed.\n");
+		return -EINVAL;
+	}
+	if (output.length < sizeof(struct acpi_gtm) || output.pointer == NULL) {
+		ata_port_printk(ap, KERN_ERR, "ACPI get timing provided invalid data.\n");
+		return -EINVAL;
+	}
+	memcpy(gtm, output.pointer, sizeof(struct acpi_gtm));
+	kfree(output.pointer);
+	return 0;
+}
+
+int ata_acpi_stm(const struct ata_port *ap, void *handle, struct acpi_gtm *stm)
+{
+	acpi_status status;
+	struct acpi_object_list         input;
+	union acpi_object               in_params[3];
+
+	in_params[0].type = ACPI_TYPE_BUFFER;
+	in_params[0].buffer.length = sizeof(struct acpi_gtm);
+	in_params[0].buffer.pointer = (u8 *)stm;
+	/* Buffers for id may need byteswapping ? */
+	in_params[1].type = ACPI_TYPE_BUFFER;
+	in_params[1].buffer.length = 512;
+	in_params[1].buffer.pointer = (u8 *)ap->device[0].id;
+	in_params[2].type = ACPI_TYPE_BUFFER;
+	in_params[2].buffer.length = 512;
+	in_params[2].buffer.pointer = (u8 *)ap->device[1].id;
+
+	input.count = 3;
+	input.pointer = in_params;
+
+	status = acpi_evaluate_object(handle, "_STM", &input, NULL);
+
+	if (ACPI_FAILURE(status)) {
+		ata_port_printk(ap, KERN_ERR, "ACPI set timing mode failed.\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static void *ata_pata_find_handle(struct device *dev, int port)
+{
+	acpi_handle handle, *chan_handle;
+	acpi_integer devfn;
+
+	if (noacpi)
+		return NULL;
+	if (pata_get_dev_handle(dev, &handle, &devfn) < 0)
+		return NULL;
+	chan_handle = acpi_get_child(handle, port);
+	if (chan_handle == NULL)
+		return NULL;
+	return chan_handle;
+}
+
+void *ata_pata_acpi_handle(const struct ata_port *ap)
+{
+	return ata_pata_find_handle(ap->host->dev, ap->port_no);
+}
+
+int ata_pata_acpi_present(struct pci_dev *pdev)
+{
+	int present = 0;
+
+	if(ata_pata_find_handle(&pdev->dev, 0))
+		present |= 1;
+	if(ata_pata_find_handle(&pdev->dev, 1))
+		present |= 2;
+	return present;
+}
+
+
+EXPORT_SYMBOL_GPL(ata_acpi_gtm);
+EXPORT_SYMBOL_GPL(ata_acpi_stm);
+EXPORT_SYMBOL_GPL(ata_pata_acpi_handle);
+EXPORT_SYMBOL_GPL(ata_pata_acpi_present);
diff -puN /dev/null drivers/ata/libata-acpi.h
--- /dev/null
+++ a/drivers/ata/libata-acpi.h
@@ -0,0 +1,47 @@
+/*
+ *  libata-acpi.h - helper library for ATA ACPI drivers
+ *
+ *  Copyright 2007 Red Hat, Inc.  All rights reserved.
+ *  Copyright 2007 Alan Cox
+ *
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2, or (at your option)
+ *  any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ *
+ *  libata documentation is available via 'make {ps|pdf}docs',
+ *  as Documentation/DocBook/libata.*
+ *
+ */
+
+#ifndef __LIBATA_ACPI_H__
+#define __LIBATA_ACPI_H__
+
+struct acpi_drive
+{
+	u32 pio;
+	u32 dma;
+};
+
+struct acpi_gtm {
+	struct acpi_drive drive[2];
+	u32 flags;
+};
+
+extern int ata_acpi_gtm(const struct ata_port *p, void *handle, struct acpi_gtm *gtm);
+extern int ata_acpi_stm(const struct ata_port *ap, void *handle, struct acpi_gtm *stm);
+extern void *ata_pata_acpi_handle(const struct ata_port *ap);
+extern int ata_pata_acpi_present(struct pci_dev *pdev);
+
+#endif
diff -puN /dev/null drivers/ata/pata_acpi.c
--- /dev/null
+++ a/drivers/ata/pata_acpi.c
@@ -0,0 +1,405 @@
+/*
+ *	ACPI PATA driver
+ *
+ *	(c) 2007 Red Hat  <alan@redhat.com>
+ *
+ *	TODO - restore modes after mode_filter chews them up
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
+#include <acpi/acpi_bus.h>
+#include <acpi/acnames.h>
+#include <acpi/acnamesp.h>
+#include <acpi/acparser.h>
+#include <acpi/acexcep.h>
+#include <acpi/acmacros.h>
+#include <acpi/actypes.h>
+
+#include <linux/libata.h>
+#include <linux/ata.h>
+
+#include "libata-acpi.h"
+
+#define DRV_NAME	"pata_acpi"
+#define DRV_VERSION	"0.0.3"
+
+struct pata_acpi {
+	void *handle;
+	struct acpi_gtm gtm;
+	void *last;
+};
+
+/**
+ *	pacpi_pre_reset	-	check for 40/80 pin
+ *	@ap: Port
+ *
+ *	Perform the PATA port setup we need.
+ */
+
+static int pacpi_pre_reset(struct ata_port *ap)
+{
+	struct pata_acpi *acpi = ap->private_data;
+	int i;
+
+	if (acpi->handle == NULL || ata_acpi_gtm(ap, acpi->handle, &acpi->gtm) < 0)
+		return -ENODEV;
+	ap->cbl = ATA_CBL_PATA40;
+
+	/* If the firmware proposed mode is UDMA3 or better then we know
+	   it is 80wire, or 40wire short */
+	for (i = 0; i < 2; i++) {
+		if (acpi->gtm.flags & (1 << 2 * i))	/* UDMA in use ? */
+			if (acpi->gtm.drive[i].dma < 55)	/* 60nS is UDMA2 */
+				ap->cbl = ATA_CBL_PATA80;
+	}
+	return ata_std_prereset(ap);
+}
+
+/**
+ *	pacpi_error_handler - Setup and error handler
+ *	@ap: Port to handle
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void pacpi_error_handler(struct ata_port *ap)
+{
+	return ata_bmdma_drive_eh(ap, pacpi_pre_reset, ata_std_softreset,
+				  NULL, ata_std_postreset);
+}
+
+/* Welcome to ACPI, bring a bucket */
+static const unsigned int pio_cycle[7] = {
+	600, 383, 240, 180, 120, 100, 80
+};
+static const unsigned int mwdma_cycle[5] = {
+	480, 150, 120, 100, 80
+};
+static const unsigned int udma_cycle[7] = {
+	120, 80, 60, 45, 30, 20, 15
+};
+
+/**
+ *	pacpi_mode_filter	-	filter non ACPI modes
+ *	@adev: ATA device
+ *	@mask: proposed modes
+ *
+ *	Try the modes available and see which ones the ACPI method will
+ *	set up sensibly. From this we get a mask of ACPI modes we can use
+ */
+
+static unsigned long pacpi_mode_filter(const struct ata_port *ap, struct ata_device *adev, unsigned long mask)
+{
+	int unit = adev->devno;
+	struct pata_acpi *acpi = ap->private_data;
+	int i;
+	u32 t;
+
+	struct acpi_gtm probe;
+
+	probe = acpi->gtm;
+
+	/* We always use the 0 slot for crap hardware */
+	if (!(probe.flags & 0x10))
+		unit = 0;
+
+
+	/* In order to generate a valid mode mask as we need cycle through
+	   trying each proposed speed in turn */
+
+	/* Start by scanning for PIO modes */
+	for (i = 0; i < 7; i++) {
+		probe.drive[unit].pio = pio_cycle[i];
+		ata_acpi_stm(ap, acpi->handle, &probe);
+		ata_acpi_gtm(ap, acpi->handle, &probe);
+		t = probe.drive[unit].pio;
+		if (t == 0xFFFFFFFF || (i &&  t >= pio_cycle[i-1]))
+			mask &= ~(1 << (i + ATA_SHIFT_PIO));
+	}
+
+	/* Select MWDMA */
+	probe.flags &= ~(1 << (2 * unit));
+
+	/* Scan for MWDMA modes */
+	for (i = 0; i < 5; i++) {
+		u32 t;
+		probe.drive[unit].dma = mwdma_cycle[i];
+		ata_acpi_stm(ap, acpi->handle, &probe);
+		ata_acpi_gtm(ap, acpi->handle, &probe);
+
+		t = probe.drive[unit].dma;
+
+		if (t == 0xFFFFFFFF || (i && t >= mwdma_cycle[i-1]))
+			mask &= ~ (1 << (i + ATA_SHIFT_MWDMA));
+	}
+
+	/* Select UDMA */
+	probe.flags |= (1 << (2 * unit));
+
+	/* Scan for UDMA modes */
+	for (i = 0; i < 7; i++) {
+		u32 t;
+		probe.drive[unit].dma = udma_cycle[i];
+		ata_acpi_stm(ap, acpi->handle, &probe);
+		ata_acpi_gtm(ap, acpi->handle, &probe);
+
+		t = probe.drive[unit].dma;
+
+		if (t == 0xFFFFFFFF || (i && t >= udma_cycle[i-1]))
+			mask &= ~ (1 << (i + ATA_SHIFT_UDMA));
+	}
+
+	/* Restore the programmed timings */
+	ata_acpi_stm(ap, acpi->handle, &acpi->gtm);
+	/* And finally we can hand back the list of speeds that actually are
+	   supported by the BIOS */
+	return ata_pci_default_filter(ap, adev, mask);
+}
+
+/**
+ *	pacpi_set_piomode	-	set initial PIO mode data
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ */
+
+static void pacpi_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	int unit = adev->devno;
+	struct pata_acpi *acpi = ap->private_data;
+
+	if(!(acpi->gtm.flags & 0x10))
+		unit = 0;
+
+	/* Now stuff the nS values into the structure */
+	acpi->gtm.drive[unit].pio = pio_cycle[adev->pio_mode - XFER_PIO_0];
+	ata_acpi_stm(ap, acpi->handle, &acpi->gtm);
+	/* See what mode we actually got */
+	ata_acpi_gtm(ap, acpi->handle, &acpi->gtm);
+}
+
+/**
+ *	pacpi_set_dmamode	-	set initial DMA mode data
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ */
+
+static void pacpi_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	int unit = adev->devno;
+	struct pata_acpi *acpi = ap->private_data;
+
+	if(!(acpi->gtm.flags & 0x10))
+		unit = 0;
+
+	/* Now stuff the nS values into the structure */
+	if (adev->dma_mode >= XFER_UDMA_0) {
+		acpi->gtm.drive[unit].dma = udma_cycle[adev->dma_mode - XFER_UDMA_0];
+		acpi->gtm.flags |= (1 << (2 * unit));
+	} else {
+		acpi->gtm.drive[unit].dma = mwdma_cycle[adev->dma_mode - XFER_MW_DMA_0];
+		acpi->gtm.flags &= ~(1 << (2 * unit));
+	}
+	ata_acpi_stm(ap, acpi->handle, &acpi->gtm);
+	/* See what mode we actually got */
+	ata_acpi_gtm(ap, acpi->handle, &acpi->gtm);
+}
+
+/**
+ *	pacpi_qc_issue_prot	-	command issue
+ *	@qc: command pending
+ *
+ *	Called when the libata layer is about to issue a command. We wrap
+ *	this interface so that we can load the correct ATA timings if
+ *	neccessary.
+ */
+
+static unsigned int pacpi_qc_issue_prot(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct ata_device *adev = qc->dev;
+	struct pata_acpi *acpi = ap->private_data;
+
+	if (acpi->gtm.flags & 0x10)
+		return ata_qc_issue_prot(qc);
+
+	if (adev != acpi->last) {
+		pacpi_set_piomode(ap, adev);
+		if (adev->dma_mode)
+			pacpi_set_dmamode(ap, adev);
+		acpi->last = adev;
+	}
+	return ata_qc_issue_prot(qc);
+}
+
+/**
+ *	pacpi_port_start	-	port setup
+ *	@ap: ATA port being set up
+ *
+ *	Use the port_start hook to maintain private control structures
+ */
+
+static int pacpi_port_start(struct ata_port *ap)
+{
+	struct pata_acpi *acpi;
+
+	int ret = ata_port_start(ap);
+	if (ret < 0)
+		return ret;
+
+	acpi = ap->private_data = kzalloc(sizeof(struct pata_acpi), GFP_KERNEL);
+	if (ap->private_data == NULL) {
+		ata_port_stop(ap);
+		return -ENOMEM;
+	}
+	acpi->handle = ata_pata_acpi_handle(ap);
+	return ret;
+}
+
+/**
+ *	pacpi_port_stop	-	port shutdown
+ *	@ap: ATA port being removed
+ *
+ *	Release the private objects we added in pacpi_port_start
+ */
+
+static void pacpi_port_stop(struct ata_port *ap)
+{
+	kfree(ap->private_data);
+	ap->private_data = NULL;	/* We want an OOPS if we reuse this
+					   too late! */
+	ata_port_stop(ap);
+}
+
+static struct scsi_host_template pacpi_sht = {
+	.module			= THIS_MODULE,
+	.name			= DRV_NAME,
+	.ioctl			= ata_scsi_ioctl,
+	.queuecommand		= ata_scsi_queuecmd,
+	.can_queue		= ATA_DEF_QUEUE,
+	.this_id		= ATA_SHT_THIS_ID,
+	.sg_tablesize		= LIBATA_MAX_PRD,
+	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
+	.emulated		= ATA_SHT_EMULATED,
+	.use_clustering		= ATA_SHT_USE_CLUSTERING,
+	.proc_name		= DRV_NAME,
+	.dma_boundary		= ATA_DMA_BOUNDARY,
+	.slave_configure	= ata_scsi_slave_config,
+	.slave_destroy		= ata_scsi_slave_destroy,
+	/* Use standard CHS mapping rules */
+	.bios_param		= ata_std_bios_param,
+	.resume			= ata_scsi_device_resume,
+	.suspend		= ata_scsi_device_suspend,
+};
+
+static const struct ata_port_operations pacpi_ops = {
+	.port_disable		= ata_port_disable,
+	.set_piomode		= pacpi_set_piomode,
+	.set_dmamode		= pacpi_set_dmamode,
+	.mode_filter		= pacpi_mode_filter,
+
+	/* Task file is PCI ATA format, use helpers */
+	.tf_load		= ata_tf_load,
+	.tf_read		= ata_tf_read,
+	.check_status		= ata_check_status,
+	.exec_command		= ata_exec_command,
+	.dev_select		= ata_std_dev_select,
+
+	.freeze			= ata_bmdma_freeze,
+	.thaw			= ata_bmdma_thaw,
+	.error_handler		= pacpi_error_handler,
+	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+
+	/* BMDMA handling is PCI ATA format, use helpers */
+	.bmdma_setup		= ata_bmdma_setup,
+	.bmdma_start		= ata_bmdma_start,
+	.bmdma_stop		= ata_bmdma_stop,
+	.bmdma_status		= ata_bmdma_status,
+	.qc_prep		= ata_qc_prep,
+	.qc_issue		= pacpi_qc_issue_prot,
+	.data_xfer		= ata_pio_data_xfer,
+
+	/* Timeout handling */
+	.irq_handler		= ata_interrupt,
+	.irq_clear		= ata_bmdma_irq_clear,
+
+	/* Generic PATA PCI ATA helpers */
+	.port_start		= pacpi_port_start,
+	.port_stop		= pacpi_port_stop,
+	.host_stop		= ata_host_stop,
+};
+
+
+/**
+ *	pacpi_init_one - Register ACPI ATA PCI device with kernel services
+ *	@pdev: PCI device to register
+ *	@ent: Entry in pacpi_pci_tbl matching with @pdev
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
+static int pacpi_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	static struct ata_port_info info = {
+		.sht		= &pacpi_sht,
+		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+
+		.pio_mask	= 0x1f,
+		.mwdma_mask	= 0x07,
+		.udma_mask 	= 0x3f,
+
+		.port_ops	= &pacpi_ops,
+	};
+	struct ata_port_info *port_info[1] = { &info };
+
+	if (!ata_pata_acpi_present(pdev))
+		return -ENODEV;
+	return ata_pci_init_one(pdev, port_info, 1);
+}
+
+static const struct pci_device_id pacpi_pci_tbl[] = {
+	{ PCI_ANY_ID,		PCI_ANY_ID,			   PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_STORAGE_IDE << 8, 0xFFFFFF00UL, 1},
+	{ }	/* terminate list */
+};
+
+static struct pci_driver pacpi_pci_driver = {
+	.name			= DRV_NAME,
+	.id_table		= pacpi_pci_tbl,
+	.probe			= pacpi_init_one,
+	.remove			= ata_pci_remove_one,
+	.suspend		= ata_pci_device_suspend,
+	.resume			= ata_pci_device_resume,
+};
+
+static int __init pacpi_init(void)
+{
+	return pci_register_driver(&pacpi_pci_driver);
+}
+
+static void __exit pacpi_exit(void)
+{
+	pci_unregister_driver(&pacpi_pci_driver);
+}
+
+module_init(pacpi_init);
+module_exit(pacpi_exit);
+
+MODULE_AUTHOR("Alan Cox");
+MODULE_DESCRIPTION("SCSI low-level driver for ATA in ACPI mode");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(pci, pacpi_pci_tbl);
+MODULE_VERSION(DRV_VERSION);
+
diff -puN drivers/ata/pata_amd.c~pata_acpi-take-two drivers/ata/pata_amd.c
--- a/drivers/ata/pata_amd.c~pata_acpi-take-two
+++ a/drivers/ata/pata_amd.c
@@ -642,6 +642,11 @@ static int amd_init_one(struct pci_dev *
 	if (type == 1 && rev > 0x7)
 		type = 2;
 
+#if defined(CONFIG_ATA_ACPI)
+	/* Prefer the ACPI driver for Nvidia hardware */
+	if (pdev->vendor == PCI_VENDOR_ID_NVIDIA && ata_pata_acpi_present(pdev))
+		return -ENODEV;
+#endif
 	/* Check for AMD7411 */
 	if (type == 3)
 		/* FIFO is broken */
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
sis-warning-fixes.patch
libata-add-a-host-flag-to-indicate-lack-of-iordy.patch
pata_acpi-take-two.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
git-mtd.patch
git-netdev-all.patch
resend-iphase-64bit-cleanup.patch
make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch
perle-multimodem-card-pci-ras-detection.patch
pnx8550-uart-driver.patch
pnx8550-uart-driver-fixes.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
geode-support-classic-mediagxm.patch
cyrix-fails-to-detect-mediagx.patch
geode-configuration-fixes.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-tty_wakeup-cleanup.patch
proc-remove-useless-and-buggy-nlink-settings.patch
tty-improve-encode_baud_rate-logic.patch
kernel-shut-up-the-irq-mismatch-messages.patch
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
sched-avoid-div-in-rebalance_tick.patch
pm3fb-kill-pci_find_device-usage.patch
