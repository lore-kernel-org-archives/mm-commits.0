From: akpm@linux-foundation.org
Subject: - libata-store-bus-addresses-versus-mm-for-testing.patch removed from -mm tree
Date: Mon, 30 Jul 2007 11:59:13 -0700
Message-ID: <200707301859.l6UIxDuT025203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39260 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966383AbXG3TAM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 15:00:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     libata: Store bus addresses (versus -mm for testing)
has been removed from the -mm tree.  Its filename was
     libata-store-bus-addresses-versus-mm-for-testing.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: libata: Store bus addresses (versus -mm for testing)
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

As we cannot reverse iomap results portably as we tried before the libata
layer needs to keep bus addresses around for reporting.  This first big
patch adds a structure for it and teaches the drivers to keep the
information.  Thankfully most drivers go via libata-sff and it can do the
work for them.

For the others we replace ata_std_ports with ata_std_io_ports /
std_mmio_ports and pass both the mapped and some bus address info.

We don't keep all the mappings in both forms.  We only need cmd, ctrl and
status (for wait_status() reporting).  We also keep a "base" for devices
where the taskfile (cmd/ctl) mapping makes no sense.

This patch stores all the data but doesn't yet change the display side. 
I've got a couple of variants I'm playing with on the display side and want
to get that right.  In the mean time this should store all the data and
have no side effects for anyone, so is a good first chunk for testing
alone.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c           |   10 ++++-
 drivers/ata/libata-core.c    |   60 +++++++++++++++++++++++++++++++--
 drivers/ata/libata-sff.c     |    6 ++-
 drivers/ata/pata_cs5520.c    |   17 ++++++++-
 drivers/ata/pata_hpt3x3.c    |   11 +++++-
 drivers/ata/pata_isapnp.c    |    4 +-
 drivers/ata/pata_ixp4xx_cf.c |   10 +++--
 drivers/ata/pata_legacy.c    |    4 +-
 drivers/ata/pata_pcmcia.c    |    7 +++
 drivers/ata/pata_qdi.c       |    5 ++
 drivers/ata/pata_sil680.c    |   18 ++++++++-
 drivers/ata/pata_winbond.c   |    5 ++
 drivers/ata/sata_inic162x.c  |    5 ++
 drivers/ata/sata_mv.c        |    5 ++
 drivers/ata/sata_nv.c        |   15 ++++++++
 drivers/ata/sata_promise.c   |    2 +
 drivers/ata/sata_qstor.c     |    8 ++++
 drivers/ata/sata_sil.c       |   10 ++++-
 drivers/ata/sata_sil24.c     |    5 ++
 drivers/ata/sata_svw.c       |   19 ++++++++--
 drivers/ata/sata_sx4.c       |   24 ++++++++++---
 drivers/ata/sata_uli.c       |   17 ++++++++-
 drivers/ata/sata_via.c       |   11 ++++--
 drivers/ata/sata_vsc.c       |   20 ++++++++---
 include/linux/libata.h       |   28 ++++++++++++++-
 25 files changed, 287 insertions(+), 39 deletions(-)

diff -puN drivers/ata/ahci.c~libata-store-bus-addresses-versus-mm-for-testing drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~libata-store-bus-addresses-versus-mm-for-testing
+++ a/drivers/ata/ahci.c
@@ -518,12 +518,17 @@ static inline int ahci_nr_ports(u32 cap)
 	return (cap & 0x1f) + 1;
 }
 
+static inline unsigned int __ahci_port_offset(unsigned int port_no)
+{
+	return 0x100 + (port_no * 0x80);
+}
+
 static inline void __iomem *__ahci_port_base(struct ata_host *host,
 					     unsigned int port_no)
 {
 	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
 
-	return mmio + 0x100 + (port_no * 0x80);
+	return mmio + __ahci_port_offset(port_no);
 }
 
 static inline void __iomem *ahci_port_base(struct ata_port *ap)
@@ -2042,6 +2047,9 @@ static int ahci_init_one(struct pci_dev 
 
 		/* standard SATA port setup */
 		if (hpriv->port_map & (1 << i)) {
+			ap->busaddr.base_addr = pci_resource_start(pdev, AHCI_PCI_BAR)
+						+ __ahci_port_offset(i);
+			ap->busaddr.base_type = ATA_ADDR_MMIO;
 			ap->ioaddr.cmd_addr = port_mmio;
 			ap->pm_policy = SHOST_NOT_AVAILABLE;
 		}
diff -puN drivers/ata/libata-core.c~libata-store-bus-addresses-versus-mm-for-testing drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-store-bus-addresses-versus-mm-for-testing
+++ a/drivers/ata/libata-core.c
@@ -6738,7 +6738,7 @@ void ata_host_detach(struct ata_host *ho
  *	Does not set ctl_addr, altstatus_addr, bmdma_addr, or scr_addr.
  */
 
-void ata_std_ports(struct ata_ioports *ioaddr)
+static void ata_std_ports(struct ata_ioports *ioaddr)
 {
 	ioaddr->data_addr = ioaddr->cmd_addr + ATA_REG_DATA;
 	ioaddr->error_addr = ioaddr->cmd_addr + ATA_REG_ERR;
@@ -6752,6 +6752,61 @@ void ata_std_ports(struct ata_ioports *i
 	ioaddr->command_addr = ioaddr->cmd_addr + ATA_REG_CMD;
 }
 
+/**
+ *	ata_std_io_ports - initialize ioaddr with standard port offsets.
+ *	@ioaddr: IO address structure to be initialized
+ *	@busaddr: Bus addresses to report
+ *
+ *	Utility function which initializes data_addr, error_addr,
+ *	feature_addr, nsect_addr, lbal_addr, lbam_addr, lbah_addr,
+ *	device_addr, status_addr, and command_addr to standard offsets
+ *	relative to cmd_addr.
+ *
+ *	Does not set ctl_addr, altstatus_addr, bmdma_addr, or scr_addr.
+ *
+ *	Sets up the types of the prepared physical bus registers as I/O
+ */
+
+void ata_std_io_ports(struct ata_ioports *ioaddr, struct ata_busports *busaddr)
+{
+	ata_std_ports(ioaddr);
+	busaddr->cmd_type = ATA_ADDR_PIO;
+	if (busaddr->status_addr == 0)
+		busaddr->status_addr = busaddr->cmd_addr + ATA_REG_STATUS;
+	busaddr->status_type = ATA_ADDR_PIO;
+	if (busaddr->bmdma_addr)
+		busaddr->bmdma_type = ATA_ADDR_PIO;
+	if (busaddr->ctl_addr)
+		busaddr->ctl_type = ATA_ADDR_PIO;
+}
+
+/**
+ *	ata_std_mmio_ports - initialize ioaddr with standard port offsets.
+ *	@ioaddr: IO address structure to be initialized
+ *	@busaddr: Bus addresses to report
+ *
+ *	Utility function which initializes data_addr, error_addr,
+ *	feature_addr, nsect_addr, lbal_addr, lbam_addr, lbah_addr,
+ *	device_addr, status_addr, and command_addr to standard offsets
+ *	relative to cmd_addr.
+ *
+ *	Does not set ctl_addr, altstatus_addr, bmdma_addr, or scr_addr.
+ *
+ *	Sets up the types of the prepared physical bus registers as MMIO
+ */
+
+void ata_std_mmio_ports(struct ata_ioports *ioaddr, struct ata_busports *busaddr)
+{
+	ata_std_ports(ioaddr);
+	busaddr->cmd_type = ATA_ADDR_MMIO;
+	if (busaddr->status_addr == 0)
+		busaddr->status_addr = busaddr->cmd_addr + ATA_REG_STATUS;
+	busaddr->status_type = ATA_ADDR_MMIO;
+	if (busaddr->bmdma_addr)
+		busaddr->bmdma_type = ATA_ADDR_MMIO;
+	if (busaddr->ctl_addr)
+		busaddr->ctl_type = ATA_ADDR_MMIO;
+}
 
 #ifdef CONFIG_PCI
 
@@ -7008,7 +7063,8 @@ EXPORT_SYMBOL_GPL(sata_deb_timing_long);
 EXPORT_SYMBOL_GPL(ata_dummy_port_ops);
 EXPORT_SYMBOL_GPL(ata_dummy_port_info);
 EXPORT_SYMBOL_GPL(ata_std_bios_param);
-EXPORT_SYMBOL_GPL(ata_std_ports);
+EXPORT_SYMBOL_GPL(ata_std_io_ports);
+EXPORT_SYMBOL_GPL(ata_std_mmio_ports);
 EXPORT_SYMBOL_GPL(ata_host_init);
 EXPORT_SYMBOL_GPL(ata_host_alloc);
 EXPORT_SYMBOL_GPL(ata_host_alloc_pinfo);
diff -puN drivers/ata/libata-sff.c~libata-store-bus-addresses-versus-mm-for-testing drivers/ata/libata-sff.c
--- a/drivers/ata/libata-sff.c~libata-store-bus-addresses-versus-mm-for-testing
+++ a/drivers/ata/libata-sff.c
@@ -601,6 +601,8 @@ int ata_pci_init_bmdma(struct ata_host *
 			continue;
 
 		ap->ioaddr.bmdma_addr = bmdma;
+		ap->busaddr.bmdma_addr = pci_resource_start(pdev, 4) + 8 * i;
+		ap->busaddr.bmdma_type = ATA_ADDR_PIO;
 		if ((!(ap->flags & ATA_FLAG_IGN_SIMPLEX)) &&
 		    (ioread8(bmdma + 2) & 0x80))
 			host->flags |= ATA_HOST_SIMPLEX;
@@ -669,7 +671,9 @@ int ata_pci_init_sff_host(struct ata_hos
 		ap->ioaddr.altstatus_addr =
 		ap->ioaddr.ctl_addr = (void __iomem *)
 			((unsigned long)iomap[base + 1] | ATA_PCI_CTL_OFS);
-		ata_std_ports(&ap->ioaddr);
+		ap->busaddr.cmd_addr = pci_resource_start(pdev, base);
+		ap->busaddr.ctl_addr = pci_resource_start(pdev, base + 1) | ATA_PCI_CTL_OFS;
+		ata_std_io_ports(&ap->ioaddr, &ap->busaddr);
 
 		mask |= 1 << i;
 	}
diff -puN drivers/ata/pata_cs5520.c~libata-store-bus-addresses-versus-mm-for-testing drivers/ata/pata_cs5520.c
--- a/drivers/ata/pata_cs5520.c~libata-store-bus-addresses-versus-mm-for-testing
+++ a/drivers/ata/pata_cs5520.c
@@ -201,6 +201,7 @@ static int __devinit cs5520_init_one(str
 	void *iomap[5];
 	struct ata_host *host;
 	struct ata_ioports *ioaddr;
+	struct ata_busports *busaddr;
 	int i, rc;
 
 	/* IDE port enable bits */
@@ -258,14 +259,26 @@ static int __devinit cs5520_init_one(str
 	ioaddr->ctl_addr = iomap[1];
 	ioaddr->altstatus_addr = iomap[1];
 	ioaddr->bmdma_addr = iomap[4];
-	ata_std_ports(ioaddr);
+
+	busaddr = &host->ports[0]->busaddr;
+	busaddr->cmd_addr = 0x1F0;
+	busaddr->ctl_addr = 0x3F6;
+	busaddr->bmdma_addr = pci_resource_start(pdev, 2);
+
+	ata_std_io_ports(ioaddr, busaddr);
 
 	ioaddr = &host->ports[1]->ioaddr;
 	ioaddr->cmd_addr = iomap[2];
 	ioaddr->ctl_addr = iomap[3];
 	ioaddr->altstatus_addr = iomap[3];
 	ioaddr->bmdma_addr = iomap[4] + 8;
-	ata_std_ports(ioaddr);
+
+	busaddr = &host->ports[1]->busaddr;
+	busaddr->cmd_addr = 0x170;
+	busaddr->ctl_addr = 0x376;
+	busaddr->bmdma_addr = pci_resource_start(pdev, 2) + 8;
+
+	ata_std_io_ports(ioaddr, busaddr);
 
 	/* activate the host */
 	pci_set_master(pdev);
diff -puN drivers/ata/pata_hpt3x3.c~libata-store-bus-addresses-versus-mm-for-testing drivers/ata/pata_hpt3x3.c
--- a/drivers/ata/pata_hpt3x3.c~libata-store-bus-addresses-versus-mm-for-testing
+++ a/drivers/ata/pata_hpt3x3.c
@@ -208,6 +208,7 @@ static int hpt3x3_init_one(struct pci_de
 	struct ata_host *host;
 	int i, rc;
 	void __iomem *base;
+	unsigned long busbase;
 
 	hpt3x3_init_chipset(pdev);
 
@@ -237,16 +238,24 @@ static int hpt3x3_init_one(struct pci_de
 		return rc;
 
 	base = host->iomap[4];	/* Bus mastering base */
+	busbase = pci_resource_start(pdev, 4);
 
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_ioports *ioaddr = &host->ports[i]->ioaddr;
+		struct ata_busports *busaddr = &host->ports[i]->busaddr;
 
 		ioaddr->cmd_addr = base + offset_cmd[i];
 		ioaddr->altstatus_addr =
 		ioaddr->ctl_addr = base + offset_ctl[i];
 		ioaddr->scr_addr = NULL;
-		ata_std_ports(ioaddr);
 		ioaddr->bmdma_addr = base + 8 * i;
+
+		busaddr->bmdma_addr = busbase + 8 * i;
+		busaddr->cmd_addr = busbase + offset_cmd[i];
+		busaddr->ctl_addr = busbase + offset_ctl[i];
+
+		ata_std_io_ports(ioaddr, busaddr);
+
 	}
 	pci_set_master(pdev);
 	return ata_host_activate(host, pdev->irq, ata_interrupt, IRQF_SHARED,
diff -puN drivers/ata/pata_isapnp.c~libata-store-bus-addresses-versus-mm-for-testing drivers/ata/pata_isapnp.c
--- a/drivers/ata/pata_isapnp.c~libata-store-bus-addresses-versus-mm-for-testing
+++ a/drivers/ata/pata_isapnp.c
@@ -102,15 +102,17 @@ static int isapnp_init_one(struct pnp_de
 	ap->flags |= ATA_FLAG_SLAVE_POSS;
 
 	ap->ioaddr.cmd_addr = cmd_addr;
+	ap->busaddr.cmd_addr = pnp_port_start(idev, 0);
 
 	if (pnp_port_valid(idev, 1) == 0) {
 		ctl_addr = devm_ioport_map(&idev->dev,
 					   pnp_port_start(idev, 1), 1);
 		ap->ioaddr.altstatus_addr = ctl_addr;
 		ap->ioaddr.ctl_addr = ctl_addr;
+		ap->busaddr.ctl_addr = pnp_port_start(idev, 1);
 	}
 
-	ata_std_ports(&ap->ioaddr);
+	ata_std_io_ports(&ap->ioaddr);
 
 	/* activate */
 	return ata_host_activate(host, pnp_irq(idev, 0), ata_interrupt, 0,
diff -puN drivers/ata/pata_ixp4xx_cf.c~libata-store-bus-addresses-versus-mm-for-testing drivers/ata/pata_ixp4xx_cf.c
--- a/drivers/ata/pata_ixp4xx_cf.c~libata-store-bus-addresses-versus-mm-for-testing
+++ a/drivers/ata/pata_ixp4xx_cf.c
@@ -134,13 +134,17 @@ static struct ata_port_operations ixp4xx
 };
 
 static void ixp4xx_setup_port(struct ata_ioports *ioaddr,
-				struct ixp4xx_pata_data *data)
+				struct ata_busports *busaddr,
+				struct ixp4xx_pata_data *data,
+				unsigned long s0, s1)
 {
 	ioaddr->cmd_addr	= data->cs0;
 	ioaddr->altstatus_addr	= data->cs1 + 0x06;
 	ioaddr->ctl_addr	= data->cs1 + 0x06;
 
-	ata_std_ports(ioaddr);
+	busaddr->cmd_addr = s1;
+	busaddr->ctl_addr = s1 + 0x06;
+	ata_std_mmio_ports(ioaddr, busaddr);
 
 #ifndef __ARMEB__
 
@@ -203,7 +207,7 @@ static __devinit int ixp4xx_pata_probe(s
 	ap->pio_mask = 0x1f; /* PIO4 */
 	ap->flags |= ATA_FLAG_MMIO | ATA_FLAG_NO_LEGACY | ATA_FLAG_NO_ATAPI;
 
-	ixp4xx_setup_port(&ap->ioaddr, data);
+	ixp4xx_setup_port(&ap->ioaddr, &ap->busaddr, data, cs0->start, cs1->start);
 
 	dev_printk(KERN_INFO, &pdev->dev, "version " DRV_VERSION "\n");
 
diff -puN drivers/ata/pata_legacy.c~libata-store-bus-addresses-versus-mm-for-testing drivers/ata/pata_legacy.c
--- a/drivers/ata/pata_legacy.c~libata-store-bus-addresses-versus-mm-for-testing
+++ a/drivers/ata/pata_legacy.c
@@ -811,7 +811,9 @@ static __init int legacy_init_one(int po
 	ap->ioaddr.cmd_addr = io_addr;
 	ap->ioaddr.altstatus_addr = ctrl_addr;
 	ap->ioaddr.ctl_addr = ctrl_addr;
-	ata_std_ports(&ap->ioaddr);
+	ap->busaddr.cmd_addr = io;
+	ap->busaddr.ctl_addr = ctrl;
+	ata_std_io_ports(&ap->ioaddr, &ap->busaddr);
 	ap->private_data = ld;
 
 	ret = ata_host_activate(host, irq, ata_interrupt, 0, &legacy_sht);
diff -puN drivers/ata/pata_pcmcia.c~libata-store-bus-addresses-versus-mm-for-testing drivers/ata/pata_pcmcia.c
--- a/drivers/ata/pata_pcmcia.c~libata-store-bus-addresses-versus-mm-for-testing
+++ a/drivers/ata/pata_pcmcia.c
@@ -299,10 +299,15 @@ next_entry:
 	ap->ops = &pcmcia_port_ops;
 	ap->pio_mask = 1;		/* ISA so PIO 0 cycles */
 	ap->flags |= ATA_FLAG_SLAVE_POSS;
+
 	ap->ioaddr.cmd_addr = io_addr;
 	ap->ioaddr.altstatus_addr = ctl_addr;
 	ap->ioaddr.ctl_addr = ctl_addr;
-	ata_std_ports(&ap->ioaddr);
+
+	ap->busaddr.cmd_addr = io_base;
+	ap->busaddr.ctl_addr = ctl_base;
+
+	ata_std_io_ports(&ap->ioaddr, &ap->busaddr);
 
 	/* activate */
 	ret = ata_host_activate(host, pdev->irq.AssignedIRQ, ata_interrupt,
diff -puN drivers/ata/pata_qdi.c~libata-store-bus-addresses-versus-mm-for-testing drivers/ata/pata_qdi.c
--- a/drivers/ata/pata_qdi.c~libata-store-bus-addresses-versus-mm-for-testing
+++ a/drivers/ata/pata_qdi.c
@@ -277,7 +277,10 @@ static __init int qdi_init_one(unsigned 
 	ap->ioaddr.cmd_addr = io_addr;
 	ap->ioaddr.altstatus_addr = ctl_addr;
 	ap->ioaddr.ctl_addr = ctl_addr;
-	ata_std_ports(&ap->ioaddr);
+
+	ap->busaddr.cmd_addr = io;
+	ap->busaddr.ctl_addr = io + 0x0206;
+	ata_std_io_ports(&ap->ioaddr, &ap->busaddr);
 
 	/*
 	 *	Hook in a private data structure per channel
diff -puN drivers/ata/pata_sil680.c~libata-store-bus-addresses-versus-mm-for-testing drivers/ata/pata_sil680.c
--- a/drivers/ata/pata_sil680.c~libata-store-bus-addresses-versus-mm-for-testing
+++ a/drivers/ata/pata_sil680.c
@@ -366,6 +366,7 @@ static int __devinit sil680_init_one(str
 	static int printed_version;
 	struct ata_host *host;
 	void __iomem *mmio_base;
+	unsigned long mmio_bus;
 	int rc, try_mmio;
 
 	if (!printed_version++)
@@ -409,16 +410,29 @@ static int __devinit sil680_init_one(str
 
 	/* Get MMIO base and initialize port addresses */
 	mmio_base = host->iomap[SIL680_MMIO_BAR];
+	mmio_bus = pci_resource_start(pdev, SIL680_MMIO_BAR);
+
 	host->ports[0]->ioaddr.bmdma_addr = mmio_base + 0x00;
 	host->ports[0]->ioaddr.cmd_addr = mmio_base + 0x80;
 	host->ports[0]->ioaddr.ctl_addr = mmio_base + 0x8a;
 	host->ports[0]->ioaddr.altstatus_addr = mmio_base + 0x8a;
-	ata_std_ports(&host->ports[0]->ioaddr);
+
+	host->ports[0]->busaddr.bmdma_addr = mmio_bus + 0x00;
+	host->ports[0]->busaddr.cmd_addr = mmio_bus + 0x80;
+	host->ports[0]->busaddr.ctl_addr = mmio_bus + 0x8a;
+
+	ata_std_mmio_ports(&host->ports[0]->ioaddr, &host->ports[0]->busaddr);
+
 	host->ports[1]->ioaddr.bmdma_addr = mmio_base + 0x08;
 	host->ports[1]->ioaddr.cmd_addr = mmio_base + 0xc0;
 	host->ports[1]->ioaddr.ctl_addr = mmio_base + 0xca;
 	host->ports[1]->ioaddr.altstatus_addr = mmio_base + 0xca;
-	ata_std_ports(&host->ports[1]->ioaddr);
+
+	host->ports[1]->busaddr.bmdma_addr = mmio_bus + 0x08;
+	host->ports[1]->busaddr.cmd_addr = mmio_bus + 0xc0;
+	host->ports[1]->busaddr.ctl_addr = mmio_bus + 0xca;
+
+	ata_std_mmio_ports(&host->ports[1]->ioaddr, &host->ports[1]->busaddr);
 
 	/* Register & activate */
 	return ata_host_activate(host, pdev->irq, ata_interrupt, IRQF_SHARED,
diff -puN drivers/ata/pata_winbond.c~libata-store-bus-addresses-versus-mm-for-testing drivers/ata/pata_winbond.c
--- a/drivers/ata/pata_winbond.c~libata-store-bus-addresses-versus-mm-for-testing
+++ a/drivers/ata/pata_winbond.c
@@ -228,7 +228,10 @@ static __init int winbond_init_one(unsig
 		ap->ioaddr.cmd_addr = cmd_addr;
 		ap->ioaddr.altstatus_addr = ctl_addr;
 		ap->ioaddr.ctl_addr = ctl_addr;
-		ata_std_ports(&ap->ioaddr);
+
+		ap->busaddr.cmd_addr = cmd_port;
+		ap->busaddr.ctl_addr = cmd_port + 0x0206;
+		ata_std_io_ports(&ap->ioaddr, &ap->busaddr);
 
 		/* hook in a private data structure per channel */
 		host->private_data = &winbond_data[nr_winbond_host];
diff -puN drivers/ata/sata_inic162x.c~libata-store-bus-addresses-versus-mm-for-testing drivers/ata/sata_inic162x.c
--- a/drivers/ata/sata_inic162x.c~libata-store-bus-addresses-versus-mm-for-testing
+++ a/drivers/ata/sata_inic162x.c
@@ -694,6 +694,7 @@ static int inic_init_one(struct pci_dev 
 
 	for (i = 0; i < NR_PORTS; i++) {
 		struct ata_ioports *port = &host->ports[i]->ioaddr;
+		struct ata_busports *busaddr = &host->ports[i]->busaddr;
 		void __iomem *port_base = iomap[MMIO_BAR] + i * PORT_SIZE;
 
 		port->cmd_addr = iomap[2 * i];
@@ -702,7 +703,9 @@ static int inic_init_one(struct pci_dev 
 			((unsigned long)iomap[2 * i + 1] | ATA_PCI_CTL_OFS);
 		port->scr_addr = port_base + PORT_SCR;
 
-		ata_std_ports(port);
+		busaddr->cmd_addr = pci_resource_start(pdev, 2 * i);
+		busaddr->ctl_addr = pci_resource_start(pdev, 2 * i + 1) | ATA_PCI_CTL_OFS;
+		ata_std_io_ports(port, busaddr);
 	}
 
 	hpriv->cached_hctl = readw(iomap[MMIO_BAR] + HOST_CTL);
diff -puN drivers/ata/sata_mv.c~libata-store-bus-addresses-versus-mm-for-testing drivers/ata/sata_mv.c
--- a/drivers/ata/sata_mv.c~libata-store-bus-addresses-versus-mm-for-testing
+++ a/drivers/ata/sata_mv.c
@@ -2530,6 +2530,7 @@ static int mv_init_host(struct ata_host 
 	int rc = 0, n_hc, port, hc;
 	struct pci_dev *pdev = to_pci_dev(host->dev);
 	void __iomem *mmio = host->iomap[MV_PRIMARY_BAR];
+	unsigned long busio = pci_resource_start(pdev, MV_PRIMARY_BAR);
 	struct mv_host_priv *hpriv = host->private_data;
 
 	/* global interrupt mask */
@@ -2555,7 +2556,6 @@ static int mv_init_host(struct ata_host 
 	for (port = 0; port < host->n_ports; port++) {
 		if (IS_GEN_II(hpriv)) {
 			void __iomem *port_mmio = mv_port_base(mmio, port);
-
 			u32 ifctl = readl(port_mmio + SATA_INTERFACE_CTL);
 			ifctl |= (1 << 7);		/* enable gen2i speed */
 			ifctl = (ifctl & 0xfff) | 0x9b1000; /* from chip spec */
@@ -2567,7 +2567,10 @@ static int mv_init_host(struct ata_host 
 
 	for (port = 0; port < host->n_ports; port++) {
 		void __iomem *port_mmio = mv_port_base(mmio, port);
+		struct ata_busports *busaddr = &host->ports[port]->busaddr;
 		mv_port_init(&host->ports[port]->ioaddr, port_mmio);
+		busaddr->base_addr = (unsigned long)mv_port_base((void __iomem *)busio, port);
+		busaddr->base_type = ATA_ADDR_MMIO;
 	}
 
 	for (hc = 0; hc < n_hc; hc++) {
diff -puN drivers/ata/sata_nv.c~libata-store-bus-addresses-versus-mm-for-testing drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~libata-store-bus-addresses-versus-mm-for-testing
+++ a/drivers/ata/sata_nv.c
@@ -1270,8 +1270,11 @@ static int nv_adma_port_resume(struct at
 
 static void nv_adma_setup_port(struct ata_port *ap)
 {
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	void __iomem *mmio = ap->host->iomap[NV_MMIO_BAR];
+	unsigned long busio = pci_resource_start(pdev, NV_MMIO_BAR);
 	struct ata_ioports *ioport = &ap->ioaddr;
+	struct ata_busports *busaddr = &ap->busaddr;
 
 	VPRINTK("ENTER\n");
 
@@ -1290,6 +1293,13 @@ static void nv_adma_setup_port(struct at
 	ioport->command_addr	= mmio + (ATA_REG_STATUS * 4);
 	ioport->altstatus_addr	=
 	ioport->ctl_addr	= mmio + 0x20;
+
+	busaddr->cmd_addr	= busio;
+	busaddr->cmd_type	= ATA_ADDR_MMIO;
+	busaddr->ctl_addr	= busio + 0x20;
+	busaddr->ctl_type	= ATA_ADDR_MMIO;
+	busaddr->status_addr	= busio + ATA_REG_STATUS * 4;
+	busaddr->status_type	= ATA_ADDR_MMIO;
 }
 
 static int nv_adma_host_init(struct ata_host *host)
@@ -2427,6 +2437,11 @@ static int nv_init_one (struct pci_dev *
 	host->ports[0]->ioaddr.scr_addr = base + NV_PORT0_SCR_REG_OFFSET;
 	host->ports[1]->ioaddr.scr_addr = base + NV_PORT1_SCR_REG_OFFSET;
 
+	host->ports[0]->busaddr.base_addr = pci_resource_start(pdev, NV_MMIO_BAR);
+	host->ports[1]->busaddr.base_type = ATA_ADDR_MMIO;
+	host->ports[1]->busaddr.base_addr = pci_resource_start(pdev, NV_MMIO_BAR);
+	host->ports[1]->busaddr.base_type = ATA_ADDR_MMIO;
+
 	/* enable SATA space for CK804 */
 	if (type >= CK804) {
 		u8 regval;
diff -puN drivers/ata/sata_promise.c~libata-store-bus-addresses-versus-mm-for-testing drivers/ata/sata_promise.c
--- a/drivers/ata/sata_promise.c~libata-store-bus-addresses-versus-mm-for-testing
+++ a/drivers/ata/sata_promise.c
@@ -1013,6 +1013,8 @@ static int pdc_ata_init_one (struct pci_
 		pdc_ata_setup_port(host->ports[i],
 				   base + 0x200 + ata_no * 0x80,
 				   base + 0x400 + ata_no * 0x100);
+		host->ports[i]->busaddr.base_type = ATA_ADDR_MMIO;
+		host->ports[i]->busaddr.base_addr = pci_resource_start(pdev, PDC_MMIO_BAR) + 0x200 + 0x80 * ata_no;
 	}
 
 	/* initialize adapter */
diff -puN drivers/ata/sata_qstor.c~libata-store-bus-addresses-versus-mm-for-testing drivers/ata/sata_qstor.c
--- a/drivers/ata/sata_qstor.c~libata-store-bus-addresses-versus-mm-for-testing
+++ a/drivers/ata/sata_qstor.c
@@ -637,9 +637,17 @@ static int qs_ata_init_one(struct pci_de
 		return rc;
 
 	for (port_no = 0; port_no < host->n_ports; ++port_no) {
+		struct ata_busports *busaddr = &host->ports[port_no]->busaddr;
 		void __iomem *chan =
 			host->iomap[QS_MMIO_BAR] + (port_no * 0x4000);
+
 		qs_ata_setup_port(&host->ports[port_no]->ioaddr, chan);
+
+		busaddr->base_type = ATA_ADDR_MMIO;
+		busaddr->base_addr = pci_resource_start(pdev, QS_MMIO_BAR)
+								+ 0x4000 * port_no;
+		busaddr->status_type = ATA_ADDR_MMIO;
+		busaddr->status_addr = busaddr->base_addr + 0x438;
 	}
 
 	/* initialize adapter */
diff -puN drivers/ata/sata_sil.c~libata-store-bus-addresses-versus-mm-for-testing drivers/ata/sata_sil.c
--- a/drivers/ata/sata_sil.c~libata-store-bus-addresses-versus-mm-for-testing
+++ a/drivers/ata/sata_sil.c
@@ -649,6 +649,7 @@ static int sil_init_one (struct pci_dev 
 	const struct ata_port_info *ppi[] = { &sil_port_info[board_id], NULL };
 	struct ata_host *host;
 	void __iomem *mmio_base;
+	unsigned long mmio_bus;
 	int n_ports, rc;
 	unsigned int i;
 
@@ -684,16 +685,23 @@ static int sil_init_one (struct pci_dev 
 		return rc;
 
 	mmio_base = host->iomap[SIL_MMIO_BAR];
+	mmio_bus = pci_resource_start(pdev, SIL_MMIO_BAR);
 
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_ioports *ioaddr = &host->ports[i]->ioaddr;
+		struct ata_busports *busaddr = &host->ports[i]->busaddr;
 
 		ioaddr->cmd_addr = mmio_base + sil_port[i].tf;
 		ioaddr->altstatus_addr =
 		ioaddr->ctl_addr = mmio_base + sil_port[i].ctl;
 		ioaddr->bmdma_addr = mmio_base + sil_port[i].bmdma;
 		ioaddr->scr_addr = mmio_base + sil_port[i].scr;
-		ata_std_ports(ioaddr);
+
+		busaddr->cmd_addr = mmio_bus + sil_port[i].tf;
+		busaddr->ctl_addr = mmio_bus + sil_port[i].ctl;
+		busaddr->bmdma_addr = mmio_bus + sil_port[i].bmdma;
+
+		ata_std_mmio_ports(ioaddr, busaddr);
 	}
 
 	/* initialize and activate */
diff -puN drivers/ata/sata_sil24.c~libata-store-bus-addresses-versus-mm-for-testing drivers/ata/sata_sil24.c
--- a/drivers/ata/sata_sil24.c~libata-store-bus-addresses-versus-mm-for-testing
+++ a/drivers/ata/sata_sil24.c
@@ -1115,7 +1115,10 @@ static int sil24_init_one(struct pci_dev
 		host->ports[i]->ioaddr.cmd_addr = port;
 		host->ports[i]->ioaddr.scr_addr = port + PORT_SCONTROL;
 
-		ata_std_ports(&host->ports[i]->ioaddr);
+		host->ports[i]->busaddr.cmd_addr = pci_resource_start(pdev, SIL24_PORT_BAR)
+								+ i * PORT_REGS_SIZE;
+
+		ata_std_mmio_ports(&host->ports[i]->ioaddr, &host->ports[i]->busaddr);
 	}
 
 	/* configure and activate the device */
diff -puN drivers/ata/sata_svw.c~libata-store-bus-addresses-versus-mm-for-testing drivers/ata/sata_svw.c
--- a/drivers/ata/sata_svw.c~libata-store-bus-addresses-versus-mm-for-testing
+++ a/drivers/ata/sata_svw.c
@@ -377,7 +377,8 @@ static const struct ata_port_info k2_por
 	},
 };
 
-static void k2_sata_setup_port(struct ata_ioports *port, void __iomem *base)
+static void k2_sata_setup_port(struct ata_ioports *port, void __iomem *base,
+			       struct ata_busports *busaddr, unsigned long busbase)
 {
 	port->cmd_addr		= base + K2_SATA_TF_CMD_OFFSET;
 	port->data_addr		= base + K2_SATA_TF_DATA_OFFSET;
@@ -394,6 +395,15 @@ static void k2_sata_setup_port(struct at
 	port->ctl_addr		= base + K2_SATA_TF_CTL_OFFSET;
 	port->bmdma_addr	= base + K2_SATA_DMA_CMD_OFFSET;
 	port->scr_addr		= base + K2_SATA_SCR_STATUS_OFFSET;
+
+	busaddr->cmd_addr	= busbase + K2_SATA_TF_CMD_OFFSET;
+	busaddr->cmd_type	= ATA_ADDR_MMIO;
+	busaddr->status_addr	= busbase + K2_SATA_TF_CMDSTAT_OFFSET;
+	busaddr->status_type	= ATA_ADDR_MMIO;
+	busaddr->ctl_addr	= busbase + K2_SATA_TF_CTL_OFFSET;
+	busaddr->ctl_type	= ATA_ADDR_MMIO;
+	busaddr->bmdma_addr	= busbase + K2_SATA_DMA_CMD_OFFSET;
+	busaddr->bmdma_type	= ATA_ADDR_MMIO;
 }
 
 
@@ -445,9 +455,12 @@ static int k2_sata_init_one (struct pci_
 	/* different controllers have different number of ports - currently 4 or 8 */
 	/* All ports are on the same function. Multi-function device is no
 	 * longer available. This should not be seen in any system. */
-	for (i = 0; i < host->n_ports; i++)
+	for (i = 0; i < host->n_ports; i++) {
 		k2_sata_setup_port(&host->ports[i]->ioaddr,
-				   mmio_base + i * K2_SATA_PORT_OFFSET);
+				   mmio_base + i * K2_SATA_PORT_OFFSET,
+				   &host->ports[i]->busaddr,
+				   pci_resource_start(pdev, 5) + i * K2_SATA_PORT_OFFSET);
+	}
 
 	rc = pci_set_dma_mask(pdev, ATA_DMA_MASK);
 	if (rc)
diff -puN drivers/ata/sata_sx4.c~libata-store-bus-addresses-versus-mm-for-testing drivers/ata/sata_sx4.c
--- a/drivers/ata/sata_sx4.c~libata-store-bus-addresses-versus-mm-for-testing
+++ a/drivers/ata/sata_sx4.c
@@ -922,7 +922,8 @@ static void pdc_exec_command_mmio(struct
 }
 
 
-static void pdc_sata_setup_port(struct ata_ioports *port, void __iomem *base)
+static void pdc_sata_setup_port(struct ata_ioports *port, void __iomem *base,
+				struct ata_busports *busaddr, unsigned long busbase)
 {
 	port->cmd_addr		= base;
 	port->data_addr		= base;
@@ -937,6 +938,13 @@ static void pdc_sata_setup_port(struct a
 	port->status_addr	= base + 0x1c;
 	port->altstatus_addr	=
 	port->ctl_addr		= base + 0x38;
+
+	busaddr->cmd_addr	= busbase;
+	busaddr->cmd_type	= ATA_ADDR_MMIO;
+	busaddr->ctl_addr	= busbase + 0x38;
+	busaddr->ctl_type	= ATA_ADDR_MMIO;
+	busaddr->status_addr	= busbase + 0x1c;
+	busaddr->status_type	= ATA_ADDR_MMIO;
 }
 
 
@@ -1384,6 +1392,7 @@ static int pdc_sata_init_one (struct pci
 		{ &pdc_port_info[ent->driver_data], NULL };
 	struct ata_host *host;
 	void __iomem *base;
+	unsigned long busbase;
 	struct pdc_host_priv *hpriv;
 	int rc;
 
@@ -1412,10 +1421,15 @@ static int pdc_sata_init_one (struct pci
 	host->iomap = pcim_iomap_table(pdev);
 
 	base = host->iomap[PDC_MMIO_BAR] + PDC_CHIP0_OFS;
-	pdc_sata_setup_port(&host->ports[0]->ioaddr, base + 0x200);
-	pdc_sata_setup_port(&host->ports[1]->ioaddr, base + 0x280);
-	pdc_sata_setup_port(&host->ports[2]->ioaddr, base + 0x300);
-	pdc_sata_setup_port(&host->ports[3]->ioaddr, base + 0x380);
+	busbase = pci_resource_start(pdev, PDC_MMIO_BAR);
+	pdc_sata_setup_port(&host->ports[0]->ioaddr, base + 0x200,
+			    &host->ports[0]->busaddr, busbase + 0x200);
+	pdc_sata_setup_port(&host->ports[1]->ioaddr, base + 0x280,
+			    &host->ports[1]->busaddr, busbase + 0x280);
+	pdc_sata_setup_port(&host->ports[2]->ioaddr, base + 0x300,
+			    &host->ports[2]->busaddr, busbase + 0x300);
+	pdc_sata_setup_port(&host->ports[3]->ioaddr, base + 0x380,
+			    &host->ports[3]->busaddr, busbase + 0x380);
 
 	/* configure and activate */
 	rc = pci_set_dma_mask(pdev, ATA_DMA_MASK);
diff -puN drivers/ata/sata_uli.c~libata-store-bus-addresses-versus-mm-for-testing drivers/ata/sata_uli.c
--- a/drivers/ata/sata_uli.c~libata-store-bus-addresses-versus-mm-for-testing
+++ a/drivers/ata/sata_uli.c
@@ -191,6 +191,7 @@ static int uli_init_one (struct pci_dev 
 	struct uli_priv *hpriv;
 	void __iomem * const *iomap;
 	struct ata_ioports *ioaddr;
+	struct ata_busports *busaddr;
 	int n_ports, rc;
 
 	if (!printed_version++)
@@ -234,13 +235,20 @@ static int uli_init_one (struct pci_dev 
 		hpriv->scr_cfg_addr[1] = ULI5287_BASE + ULI5287_OFFS;
 
 		ioaddr = &host->ports[2]->ioaddr;
+		busaddr = &host->ports[2]->busaddr;
+
 		ioaddr->cmd_addr = iomap[0] + 8;
 		ioaddr->altstatus_addr =
 		ioaddr->ctl_addr = (void __iomem *)
 			((unsigned long)iomap[1] | ATA_PCI_CTL_OFS) + 4;
 		ioaddr->bmdma_addr = iomap[4] + 16;
 		hpriv->scr_cfg_addr[2] = ULI5287_BASE + ULI5287_OFFS*4;
-		ata_std_ports(ioaddr);
+
+		busaddr->cmd_addr = pci_resource_start(pdev, 0) + 8;
+		busaddr->ctl_addr = (pci_resource_start(pdev, 1) + 4) | ATA_PCI_CTL_OFS;
+		busaddr->bmdma_addr = pci_resource_start(pdev, 4) + 16;
+
+		ata_std_io_ports(ioaddr, busaddr);
 
 		ioaddr = &host->ports[3]->ioaddr;
 		ioaddr->cmd_addr = iomap[2] + 8;
@@ -249,7 +257,12 @@ static int uli_init_one (struct pci_dev 
 			((unsigned long)iomap[3] | ATA_PCI_CTL_OFS) + 4;
 		ioaddr->bmdma_addr = iomap[4] + 24;
 		hpriv->scr_cfg_addr[3] = ULI5287_BASE + ULI5287_OFFS*5;
-		ata_std_ports(ioaddr);
+
+		busaddr->cmd_addr = pci_resource_start(pdev, 2) + 8;
+		busaddr->ctl_addr = (pci_resource_start(pdev, 3) + 4) | ATA_PCI_CTL_OFS;
+		busaddr->bmdma_addr = pci_resource_start(pdev, 4) + 24;
+
+		ata_std_io_ports(ioaddr, busaddr);
 		break;
 
 	case uli_5289:
diff -puN drivers/ata/sata_via.c~libata-store-bus-addresses-versus-mm-for-testing drivers/ata/sata_via.c
--- a/drivers/ata/sata_via.c~libata-store-bus-addresses-versus-mm-for-testing
+++ a/drivers/ata/sata_via.c
@@ -392,12 +392,13 @@ static void __iomem * vt6421_scr_addr(vo
 	return addr + (port * 64);
 }
 
-static void vt6421_init_addrs(struct ata_port *ap)
+static void vt6421_init_addrs(struct pci_dev *pdev, struct ata_port *ap)
 {
 	void __iomem * const * iomap = ap->host->iomap;
 	void __iomem *reg_addr = iomap[ap->port_no];
 	void __iomem *bmdma_addr = iomap[4] + (ap->port_no * 8);
 	struct ata_ioports *ioaddr = &ap->ioaddr;
+	struct ata_busports *busaddr = &ap->busaddr;
 
 	ioaddr->cmd_addr = reg_addr;
 	ioaddr->altstatus_addr =
@@ -406,7 +407,11 @@ static void vt6421_init_addrs(struct ata
 	ioaddr->bmdma_addr = bmdma_addr;
 	ioaddr->scr_addr = vt6421_scr_addr(iomap[5], ap->port_no);
 
-	ata_std_ports(ioaddr);
+	busaddr->bmdma_addr = pci_resource_start(pdev, 4) + 8 * ap->port_no;
+	busaddr->cmd_addr = pci_resource_start(pdev, ap->port_no);
+	busaddr->ctl_addr = (busaddr->cmd_addr + 8) | ATA_PCI_CTL_OFS;
+
+	ata_std_mmio_ports(ioaddr, busaddr);
 }
 
 static int vt6420_prepare_host(struct pci_dev *pdev, struct ata_host **r_host)
@@ -454,7 +459,7 @@ static int vt6421_prepare_host(struct pc
 	host->iomap = pcim_iomap_table(pdev);
 
 	for (i = 0; i < host->n_ports; i++)
-		vt6421_init_addrs(host->ports[i]);
+		vt6421_init_addrs(pdev, host->ports[i]);
 
 	rc = pci_set_dma_mask(pdev, ATA_DMA_MASK);
 	if (rc)
diff -puN drivers/ata/sata_vsc.c~libata-store-bus-addresses-versus-mm-for-testing drivers/ata/sata_vsc.c
--- a/drivers/ata/sata_vsc.c~libata-store-bus-addresses-versus-mm-for-testing
+++ a/drivers/ata/sata_vsc.c
@@ -343,7 +343,9 @@ static const struct ata_port_operations 
 };
 
 static void __devinit vsc_sata_setup_port(struct ata_ioports *port,
-					  void __iomem *base)
+					  void __iomem *base,
+					  struct ata_busports *busaddr,
+					  unsigned long busbase)
 {
 	port->cmd_addr		= base + VSC_SATA_TF_CMD_OFFSET;
 	port->data_addr		= base + VSC_SATA_TF_DATA_OFFSET;
@@ -360,6 +362,14 @@ static void __devinit vsc_sata_setup_por
 	port->ctl_addr		= base + VSC_SATA_TF_CTL_OFFSET;
 	port->bmdma_addr	= base + VSC_SATA_DMA_CMD_OFFSET;
 	port->scr_addr		= base + VSC_SATA_SCR_STATUS_OFFSET;
+
+	busaddr->cmd_addr	= busbase + VSC_SATA_TF_CMD_OFFSET;
+	busaddr->cmd_type	= ATA_ADDR_MMIO;
+	busaddr->ctl_addr	= busbase + VSC_SATA_TF_CTL_OFFSET;
+	busaddr->ctl_type	= ATA_ADDR_MMIO;
+	busaddr->status_addr	= busbase + VSC_SATA_TF_STATUS_OFFSET;
+	busaddr->status_type	= ATA_ADDR_MMIO;
+
 	writel(0, base + VSC_SATA_UP_DESCRIPTOR_OFFSET);
 	writel(0, base + VSC_SATA_UP_DATA_BUFFER_OFFSET);
 }
@@ -408,10 +418,12 @@ static int __devinit vsc_sata_init_one (
 
 	mmio_base = host->iomap[VSC_MMIO_BAR];
 
-	for (i = 0; i < host->n_ports; i++)
+	for (i = 0; i < host->n_ports; i++) {
 		vsc_sata_setup_port(&host->ports[i]->ioaddr,
-				    mmio_base + (i + 1) * VSC_SATA_PORT_OFFSET);
-
+				    mmio_base + (i + 1) * VSC_SATA_PORT_OFFSET,
+				    &host->ports[i]->busaddr,
+				    pci_resource_start(pdev, VSC_MMIO_BAR) + (i + 1) * VSC_SATA_PORT_OFFSET);
+	}
 	/*
 	 * Use 32 bit DMA mask, because 64 bit address support is poor.
 	 */
diff -puN include/linux/libata.h~libata-store-bus-addresses-versus-mm-for-testing include/linux/libata.h
--- a/include/linux/libata.h~libata-store-bus-addresses-versus-mm-for-testing
+++ a/include/linux/libata.h
@@ -370,6 +370,30 @@ struct ata_ioports {
 	void __iomem		*scr_addr;
 };
 
+typedef enum {
+	ATA_ADDR_UNSET = 0,
+	ATA_ADDR_PIO = 1,
+	ATA_ADDR_MMIO = 2
+} ata_addr_type;
+
+struct ata_busports {
+	/* If this is set it is used to indicate the resource block for
+	   a device (eg AHCI) which may not fit the usual arrangement */
+	unsigned long base_addr;
+	ata_addr_type base_type;
+	/* Optionally we can provide the SFF type task file and BMDMA
+	   locations. Status must be provided if the ata_status functions
+	   are being used */
+	unsigned long cmd_addr;
+	ata_addr_type cmd_type;
+	unsigned long ctl_addr;
+	ata_addr_type ctl_type;
+	unsigned long bmdma_addr;
+	ata_addr_type bmdma_type;
+	unsigned long status_addr;
+	ata_addr_type status_type;
+};
+
 struct ata_host {
 	spinlock_t		lock;
 	struct device 		*dev;
@@ -536,6 +560,7 @@ struct ata_port {
 	dma_addr_t		pad_dma;
 
 	struct ata_ioports	ioaddr;	/* ATA cmd/ctl/dma register blocks */
+	struct ata_busports	busaddr; /* Bus addresses for reporting */
 
 	u8			ctl;	/* cache of ATA control register */
 	u8			last_ctl;	/* Cache last written value */
@@ -720,7 +745,8 @@ extern int sata_std_hardreset(struct ata
 			      unsigned long deadline);
 extern void ata_std_postreset(struct ata_port *ap, unsigned int *classes);
 extern void ata_port_disable(struct ata_port *);
-extern void ata_std_ports(struct ata_ioports *ioaddr);
+extern void ata_std_io_ports(struct ata_ioports *ioaddr, struct ata_busports *busaddr);
+extern void ata_std_mmio_ports(struct ata_ioports *ioaddr, struct ata_busports *busaddr);
 #ifdef CONFIG_PCI
 extern int ata_pci_init_one (struct pci_dev *pdev,
 			     const struct ata_port_info * const * ppi);
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
libata-store-bus-addresses-versus-mm-for-testing.patch
libata-store-bus-addresses-versus-mm-for-testing-fix.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
lib8390-comment-on-locking-by-alan-cox.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
dtc-clean-up-indent-damage-and-add-printk-levels.patch
digi_acceleport-drag-the-driver-kicking-and-screaming-into.patch
kl5kusb105-switch-to-new-speed-api.patch
mct_u232-convert-to-proper-speed-handling-api.patch
mct_u232-convert-to-proper-speed-handling-api-fix.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
geode-setup-correct-chipset-access-functions-fix.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
blackfin-enable-arbitary-speed-serial-setting.patch
