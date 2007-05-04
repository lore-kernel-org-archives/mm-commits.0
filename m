From: akpm@linux-foundation.org
Subject: + libata-clean-up-sff-init-mess.patch added to -mm tree
Date: Fri, 04 May 2007 13:05:10 -0700
Message-ID: <200705042005.l44K5FXU012948@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161569AbXEDUFb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 16:05:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com


The patch titled
     libata: clean up SFF init mess
has been added to the -mm tree.  Its filename is
     libata-clean-up-sff-init-mess.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: clean up SFF init mess
From: Tejun Heo <htejun@gmail.com>

The intention of using port_mask in SFF init helpers was to eventually
support exoctic configurations such as combination of legacy and native
port on the same controller.  This never became actually necessary and the
related code always has been subtly broken one way or the other.  Now that
new init model is in place, there is no reason to make common helpers
capable of handling all corner cases.  Exotic cases can simply dealt within
LLDs as necessary.

This patch removes port_mask handling in SFF init helpers.  SFF init
helpers don't take n_ports argument and interpret it into port_mask
anymore.  All information is carried via port_info.  n_ports argument is
dropped and always two ports are allocated.  LLD can tell SFF to skip
certain port by marking it dummy.  Note that SFF code has been treating
unuvailable ports this way for a long time until recent breakage fix from
Linus and is consistent with how other drivers handle with unavailable
ports.

This fixes 1-port legacy host handling still broken after the recent native
mode fix and simplifies SFF init logic.  The following changes are made...

* ata_pci_init_native_host() and ata_init_legacy_host() both now try
  to initialized whatever they can and mark failed ports dummy.  They
  return 0 if any port is successfully initialized.

* ata_pci_prepare_native_host() and ata_pci_init_one() now doesn't
  take n_ports argument.  All info should be specified via port_info
  array.  Always two ports are allocated.

* ata_pci_init_bmdma() exported to be used by LLDs in exotic cases.

* port_info handling in all LLDs are standardized - all port_info
  arrays are const stack variable named ppi.  Unless the second port
  is different from the first, its port_info is specified as NULL
  (tells libata that it's identical to the last non-NULL port_info).

* pata_hpt37x/hpt3x2n: don't modify static variable directly.  Make an
  on-stack copy instead as ata_piix does.

* pata_uli: It has 4 ports instead of 2.  Don't use
  ata_pci_prepare_native_host().  Allocate the host explicitly and use
  init helpers.  It's simple enough.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ata_generic.c       |    6 -
 drivers/ata/ata_piix.c          |    4 
 drivers/ata/libata-core.c       |    1 
 drivers/ata/libata-sff.c        |  162 +++++++++++++++---------------
 drivers/ata/pata_ali.c          |   32 ++---
 drivers/ata/pata_amd.c          |    9 -
 drivers/ata/pata_artop.c        |   25 ++--
 drivers/ata/pata_atiixp.c       |    6 -
 drivers/ata/pata_cmd640.c       |    7 -
 drivers/ata/pata_cmd64x.c       |   13 --
 drivers/ata/pata_cs5530.c       |   10 -
 drivers/ata/pata_cs5535.c       |    6 -
 drivers/ata/pata_cypress.c      |    6 -
 drivers/ata/pata_efar.c         |    6 -
 drivers/ata/pata_hpt366.c       |   13 +-
 drivers/ata/pata_hpt37x.c       |   33 +++---
 drivers/ata/pata_hpt3x2n.c      |   13 +-
 drivers/ata/pata_hpt3x3.c       |    6 -
 drivers/ata/pata_it8213.c       |    8 -
 drivers/ata/pata_it821x.c       |   12 +-
 drivers/ata/pata_jmicron.c      |    6 -
 drivers/ata/pata_marvell.c      |   11 --
 drivers/ata/pata_netcell.c      |    6 -
 drivers/ata/pata_ns87410.c      |    6 -
 drivers/ata/pata_oldpiix.c      |    6 -
 drivers/ata/pata_opti.c         |    6 -
 drivers/ata/pata_optidma.c      |   12 --
 drivers/ata/pata_pdc202xx_old.c |    8 -
 drivers/ata/pata_radisys.c      |    6 -
 drivers/ata/pata_rz1000.c       |   12 --
 drivers/ata/pata_sc1200.c       |    8 -
 drivers/ata/pata_serverworks.c  |   15 +-
 drivers/ata/pata_sil680.c       |   10 -
 drivers/ata/pata_sis.c          |   29 ++---
 drivers/ata/pata_sl82c105.c     |   17 +--
 drivers/ata/pata_triflex.c      |    6 -
 drivers/ata/pata_via.c          |   32 ++---
 drivers/ata/sata_nv.c           |    8 -
 drivers/ata/sata_sis.c          |    6 -
 drivers/ata/sata_uli.c          |   22 +++-
 drivers/ata/sata_via.c          |    2 
 drivers/ata/sis.h               |    2 
 include/linux/libata.h          |   14 --
 43 files changed, 313 insertions(+), 315 deletions(-)

diff -puN drivers/ata/ata_generic.c~libata-clean-up-sff-init-mess drivers/ata/ata_generic.c
--- a/drivers/ata/ata_generic.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/ata_generic.c
@@ -145,7 +145,7 @@ static int all_generic_ide;		/* Set to c
 static int ata_generic_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	u16 command;
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &generic_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -153,7 +153,7 @@ static int ata_generic_init_one(struct p
 		.udma_mask = 0x3f,
 		.port_ops = &generic_port_ops
 	};
-	static struct ata_port_info *port_info[2] = { &info, &info };
+	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	/* Don't use the generic entry unless instructed to do so */
 	if (id->driver_data == 1 && all_generic_ide == 0)
@@ -179,7 +179,7 @@ static int ata_generic_init_one(struct p
 	if (dev->vendor == PCI_VENDOR_ID_AL)
 	    	ata_pci_clear_simplex(dev);
 
-	return ata_pci_init_one(dev, port_info, 2);
+	return ata_pci_init_one(dev, ppi);
 }
 
 static struct pci_device_id ata_generic[] = {
diff -puN drivers/ata/ata_piix.c~libata-clean-up-sff-init-mess drivers/ata/ata_piix.c
--- a/drivers/ata/ata_piix.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/ata_piix.c
@@ -1034,7 +1034,7 @@ static int piix_init_one (struct pci_dev
 	static int printed_version;
 	struct device *dev = &pdev->dev;
 	struct ata_port_info port_info[2];
-	struct ata_port_info *ppinfo[2] = { &port_info[0], &port_info[1] };
+	const struct ata_port_info *ppi[] = { &port_info[0], &port_info[1] };
 	struct piix_host_priv *hpriv;
 	unsigned long port_flags;
 
@@ -1093,7 +1093,7 @@ static int piix_init_one (struct pci_dev
 		port_info[1].mwdma_mask = 0;
 		port_info[1].udma_mask = 0;
 	}
-	return ata_pci_init_one(pdev, ppinfo, 2);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 static int __init piix_init(void)
diff -puN drivers/ata/libata-core.c~libata-clean-up-sff-init-mess drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/libata-core.c
@@ -6880,6 +6880,7 @@ EXPORT_SYMBOL_GPL(ata_timing_merge);
 #ifdef CONFIG_PCI
 EXPORT_SYMBOL_GPL(pci_test_config_bits);
 EXPORT_SYMBOL_GPL(ata_pci_init_native_host);
+EXPORT_SYMBOL_GPL(ata_pci_init_bmdma);
 EXPORT_SYMBOL_GPL(ata_pci_prepare_native_host);
 EXPORT_SYMBOL_GPL(ata_pci_init_one);
 EXPORT_SYMBOL_GPL(ata_pci_remove_one);
diff -puN drivers/ata/libata-sff.c~libata-clean-up-sff-init-mess drivers/ata/libata-sff.c
--- a/drivers/ata/libata-sff.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/libata-sff.c
@@ -544,7 +544,7 @@ static int ata_resources_present(struct 
  *	RETURNS:
  *	0 on success, -errno otherwise.
  */
-static int ata_pci_init_bmdma(struct ata_host *host)
+int ata_pci_init_bmdma(struct ata_host *host)
 {
 	struct device *gdev = host->dev;
 	struct pci_dev *pdev = to_pci_dev(gdev);
@@ -566,7 +566,7 @@ static int ata_pci_init_bmdma(struct ata
 	}
 	host->iomap = pcim_iomap_table(pdev);
 
-	for (i = 0; i < host->n_ports; i++) {
+	for (i = 0; i < 2; i++) {
 		struct ata_port *ap = host->ports[i];
 		void __iomem *bmdma = host->iomap[4] + 8 * i;
 
@@ -585,54 +585,52 @@ static int ata_pci_init_bmdma(struct ata
 /**
  *	ata_pci_init_native_host - acquire native ATA resources and init host
  *	@host: target ATA host
- *	@port_mask: ports to consider
  *
- *	Acquire native PCI ATA resources for @host and initialize
- *	@host accordoingly.
+ *	Acquire native PCI ATA resources for @host and initialize the
+ *	first two ports of @host accordingly.  Ports marked dummy are
+ *	skipped and allocation failure makes the port dummy.
  *
  *	LOCKING:
  *	Inherited from calling layer (may sleep).
  *
  *	RETURNS:
- *	0 on success, -errno otherwise.
+ *	0 if at least one port is initialized, -ENODEV if no port is
+ *	available.
  */
-int ata_pci_init_native_host(struct ata_host *host, unsigned int port_mask)
+int ata_pci_init_native_host(struct ata_host *host)
 {
 	struct device *gdev = host->dev;
 	struct pci_dev *pdev = to_pci_dev(gdev);
+	unsigned int mask = 0;
 	int i, rc;
 
-	/* Discard disabled ports.  Some controllers show their unused
-	 * channels this way.  Disabled ports are made dummy.
-	 */
-	for (i = 0; i < 2; i++) {
-		if ((port_mask & (1 << i)) && !ata_resources_present(pdev, i)) {
-			host->ports[i]->ops = &ata_dummy_port_ops;
-			port_mask &= ~(1 << i);
-		}
-	}
-
-	if (!port_mask) {
-		dev_printk(KERN_ERR, gdev, "no available port\n");
-		return -ENODEV;
-	}
-
 	/* request, iomap BARs and init port addresses accordingly */
 	for (i = 0; i < 2; i++) {
 		struct ata_port *ap = host->ports[i];
 		int base = i * 2;
 		void __iomem * const *iomap;
 
-		if (!(port_mask & (1 << i)))
+		if (ata_port_is_dummy(ap))
 			continue;
 
+		/* Discard disabled ports.  Some controllers show
+		 * their unused channels this way.  Disabled ports are
+		 * made dummy.
+		 */
+		if (!ata_resources_present(pdev, i)) {
+			ap->ops = &ata_dummy_port_ops;
+			continue;
+		}
+
 		rc = pcim_iomap_regions(pdev, 0x3 << base, DRV_NAME);
 		if (rc) {
-			dev_printk(KERN_ERR, gdev, "failed to request/iomap "
-				   "BARs for port %d (errno=%d)\n", i, rc);
+			dev_printk(KERN_WARNING, gdev,
+				   "failed to request/iomap BARs for port %d "
+				   "(errno=%d)\n", i, rc);
 			if (rc == -EBUSY)
 				pcim_pin_device(pdev);
-			return rc;
+			ap->ops = &ata_dummy_port_ops;
+			continue;
 		}
 		host->iomap = iomap = pcim_iomap_table(pdev);
 
@@ -641,6 +639,13 @@ int ata_pci_init_native_host(struct ata_
 		ap->ioaddr.ctl_addr = (void __iomem *)
 			((unsigned long)iomap[base + 1] | ATA_PCI_CTL_OFS);
 		ata_std_ports(&ap->ioaddr);
+
+		mask |= 1 << i;
+	}
+
+	if (!mask) {
+		dev_printk(KERN_ERR, gdev, "no available native port\n");
+		return -ENODEV;
 	}
 
 	return 0;
@@ -649,8 +654,7 @@ int ata_pci_init_native_host(struct ata_
 /**
  *	ata_pci_prepare_native_host - helper to prepare native PCI ATA host
  *	@pdev: target PCI device
- *	@ppi: array of port_info
- *	@n_ports: number of ports to allocate
+ *	@ppi: array of port_info, must be enough for two ports
  *	@r_host: out argument for the initialized ATA host
  *
  *	Helper to allocate ATA host for @pdev, acquire all native PCI
@@ -664,10 +668,9 @@ int ata_pci_init_native_host(struct ata_
  */
 int ata_pci_prepare_native_host(struct pci_dev *pdev,
 				const struct ata_port_info * const * ppi,
-				int n_ports, struct ata_host **r_host)
+				struct ata_host **r_host)
 {
 	struct ata_host *host;
-	unsigned int port_mask;
 	int rc;
 
 	if (!devres_open_group(&pdev->dev, NULL, GFP_KERNEL))
@@ -681,11 +684,7 @@ int ata_pci_prepare_native_host(struct p
 		goto err_out;
 	}
 
-	port_mask = ATA_PORT_PRIMARY;
-	if (n_ports > 1)
-		port_mask |= ATA_PORT_SECONDARY;
-
-	rc = ata_pci_init_native_host(host, port_mask);
+	rc = ata_pci_init_native_host(host);
 	if (rc)
 		goto err_out;
 
@@ -777,8 +776,11 @@ static int ata_init_legacy_port(struct a
 	/* iomap cmd and ctl ports */
 	legacy_dr->cmd_addr[port_no] = ioport_map(cmd_port, 8);
 	legacy_dr->ctl_addr[port_no] = ioport_map(ctl_port, 1);
-	if (!legacy_dr->cmd_addr[port_no] || !legacy_dr->ctl_addr[port_no])
+	if (!legacy_dr->cmd_addr[port_no] || !legacy_dr->ctl_addr[port_no]) {
+		dev_printk(KERN_WARNING, host->dev,
+			   "failed to map cmd/ctl ports\n");
 		return -ENOMEM;
+	}
 
 	/* init IO addresses */
 	ap->ioaddr.cmd_addr = legacy_dr->cmd_addr[port_no];
@@ -792,19 +794,20 @@ static int ata_init_legacy_port(struct a
 /**
  *	ata_init_legacy_host - acquire legacy ATA resources and init ATA host
  *	@host: target ATA host
- *	@legacy_mask: out parameter, mask indicating ports is in legacy mode
  *	@was_busy: out parameter, indicates whether any port was busy
  *
- *	Acquire legacy ATA resources for ports.
+ *	Acquire legacy ATA resources for the first two ports of @host
+ *	and initialize it accordingly.  Ports marked dummy are skipped
+ *	and resource acquistion failure makes the port dummy.
  *
  *	LOCKING:
  *	Inherited from calling layer (may sleep).
  *
  *	RETURNS:
- *	0 on success, -errno otherwise.
+ *	0 if at least one port is initialized, -ENODEV if no port is
+ *	available.
  */
-static int ata_init_legacy_host(struct ata_host *host,
-				unsigned int *legacy_mask, int *was_busy)
+static int ata_init_legacy_host(struct ata_host *host, int *was_busy)
 {
 	struct device *gdev = host->dev;
 	struct ata_legacy_devres *legacy_dr;
@@ -821,22 +824,23 @@ static int ata_init_legacy_host(struct a
 	devres_add(gdev, legacy_dr);
 
 	for (i = 0; i < 2; i++) {
-		*legacy_mask &= ~(1 << i);
+		if (ata_port_is_dummy(host->ports[i]))
+			continue;
+
 		rc = ata_init_legacy_port(host->ports[i], legacy_dr);
 		if (rc == 0)
 			legacy_dr->mask |= 1 << i;
-		else if (rc == -EBUSY)
-			(*was_busy)++;
-	}
-
-	if (!legacy_dr->mask)
-		return -EBUSY;
-
-	for (i = 0; i < 2; i++)
-		if (!(legacy_dr->mask & (1 << i)))
+		else {
+			if (rc == -EBUSY)
+				(*was_busy)++;
 			host->ports[i]->ops = &ata_dummy_port_ops;
+		}
+	}
 
-	*legacy_mask |= legacy_dr->mask;
+	if (!legacy_dr->mask) {
+		dev_printk(KERN_ERR, gdev, "no available legacy port\n");
+		return -ENODEV;
+	}
 
 	devres_remove_group(gdev, NULL);
 	return 0;
@@ -875,7 +879,7 @@ static int ata_request_legacy_irqs(struc
 	legacy_dr = devres_find(host->dev, ata_legacy_release, NULL, NULL);
 	BUG_ON(!legacy_dr);
 
-	for (i = 0; i < host->n_ports; i++) {
+	for (i = 0; i < 2; i++) {
 		unsigned int irq;
 
 		/* FIXME: ATA_*_IRQ() should take generic device not pci_dev */
@@ -923,8 +927,7 @@ static int ata_request_legacy_irqs(struc
 /**
  *	ata_pci_init_one - Initialize/register PCI IDE host controller
  *	@pdev: Controller to be initialized
- *	@port_info: Information from low-level host driver
- *	@n_ports: Number of ports attached to host controller
+ *	@ppi: array of port_info, must be enough for two ports
  *
  *	This is a helper function which can be called from a driver's
  *	xxx_init_one() probe function if the hardware uses traditional
@@ -944,26 +947,34 @@ static int ata_request_legacy_irqs(struc
  *	RETURNS:
  *	Zero on success, negative on errno-based value on error.
  */
-
-int ata_pci_init_one (struct pci_dev *pdev, struct ata_port_info **port_info,
-		      unsigned int n_ports)
+int ata_pci_init_one(struct pci_dev *pdev,
+		     const struct ata_port_info * const * ppi)
 {
 	struct device *dev = &pdev->dev;
+	const struct ata_port_info *pi = NULL;
 	struct ata_host *host = NULL;
-	const struct ata_port_info *port[2];
 	u8 mask;
-	unsigned int legacy_mode = 0;
-	int rc;
+	int legacy_mode = 0;
+	int i, rc;
 
 	DPRINTK("ENTER\n");
 
-	if (!devres_open_group(dev, NULL, GFP_KERNEL))
-		return -ENOMEM;
+	/* look up the first valid port_info */
+	for (i = 0; i < 2 && ppi[i]; i++) {
+		if (ppi[i]->port_ops != &ata_dummy_port_ops) {
+			pi = ppi[i];
+			break;
+		}
+	}
 
-	BUG_ON(n_ports < 1 || n_ports > 2);
+	if (!pi) {
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "no valid port_info specified\n");
+		return -EINVAL;
+	}
 
-	port[0] = port_info[0];
-	port[1] = (n_ports > 1) ? port_info[1] : NULL;
+	if (!devres_open_group(dev, NULL, GFP_KERNEL))
+		return -ENOMEM;
 
 	/* FIXME: Really for ATA it isn't safe because the device may be
 	   multi-purpose and we want to leave it alone if it was already
@@ -984,7 +995,7 @@ int ata_pci_init_one (struct pci_dev *pd
 		pci_read_config_byte(pdev, PCI_CLASS_PROG, &tmp8);
 		mask = (1 << 2) | (1 << 0);
 		if ((tmp8 & mask) != mask)
-			legacy_mode = (1 << 3);
+			legacy_mode = 1;
 #if defined(CONFIG_NO_ATA_LEGACY)
 		/* Some platforms with PCI limits cannot address compat
 		   port space. In that case we punt if their firmware has
@@ -998,7 +1009,7 @@ int ata_pci_init_one (struct pci_dev *pd
 	}
 
 	/* alloc and init host */
-	host = ata_host_alloc_pinfo(dev, port, n_ports);
+	host = ata_host_alloc_pinfo(dev, ppi, 2);
 	if (!host) {
 		dev_printk(KERN_ERR, &pdev->dev,
 			   "failed to allocate ATA host\n");
@@ -1007,19 +1018,13 @@ int ata_pci_init_one (struct pci_dev *pd
 	}
 
 	if (!legacy_mode) {
-		unsigned int port_mask;
-
-		port_mask = ATA_PORT_PRIMARY;
-		if (n_ports > 1)
-			port_mask |= ATA_PORT_SECONDARY;
-
-		rc = ata_pci_init_native_host(host, port_mask);
+		rc = ata_pci_init_native_host(host);
 		if (rc)
 			goto err_out;
 	} else {
 		int was_busy = 0;
 
-		rc = ata_init_legacy_host(host, &legacy_mode, &was_busy);
+		rc = ata_init_legacy_host(host, &was_busy);
 		if (was_busy)
 			pcim_pin_device(pdev);
 		if (rc)
@@ -1040,8 +1045,7 @@ int ata_pci_init_one (struct pci_dev *pd
 		goto err_out;
 
 	if (!legacy_mode)
-		rc = devm_request_irq(dev, pdev->irq,
-				      port_info[0]->port_ops->irq_handler,
+		rc = devm_request_irq(dev, pdev->irq, pi->port_ops->irq_handler,
 				      IRQF_SHARED, DRV_NAME, host);
 	else {
 		irq_handler_t handler[2] = { host->ops->irq_handler,
@@ -1055,7 +1059,7 @@ int ata_pci_init_one (struct pci_dev *pd
 		goto err_out;
 
 	/* register */
-	rc = ata_host_register(host, port_info[0]->sht);
+	rc = ata_host_register(host, pi->sht);
 	if (rc)
 		goto err_out;
 
diff -puN drivers/ata/pata_ali.c~libata-clean-up-sff-init-mess drivers/ata/pata_ali.c
--- a/drivers/ata/pata_ali.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_ali.c
@@ -522,14 +522,14 @@ static void ali_init_chipset(struct pci_
 
 static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info_early = {
+	static const struct ata_port_info info_early = {
 		.sht = &ali_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
 		.port_ops = &ali_early_port_ops
 	};
 	/* Revision 0x20 added DMA */
-	static struct ata_port_info info_20 = {
+	static const struct ata_port_info info_20 = {
 		.sht = &ali_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST | ATA_FLAG_PIO_LBA48,
 		.pio_mask = 0x1f,
@@ -537,7 +537,7 @@ static int ali_init_one(struct pci_dev *
 		.port_ops = &ali_20_port_ops
 	};
 	/* Revision 0x20 with support logic added UDMA */
-	static struct ata_port_info info_20_udma = {
+	static const struct ata_port_info info_20_udma = {
 		.sht = &ali_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST | ATA_FLAG_PIO_LBA48,
 		.pio_mask = 0x1f,
@@ -546,7 +546,7 @@ static int ali_init_one(struct pci_dev *
 		.port_ops = &ali_20_port_ops
 	};
 	/* Revision 0xC2 adds UDMA66 */
-	static struct ata_port_info info_c2 = {
+	static const struct ata_port_info info_c2 = {
 		.sht = &ali_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST | ATA_FLAG_PIO_LBA48,
 		.pio_mask = 0x1f,
@@ -555,7 +555,7 @@ static int ali_init_one(struct pci_dev *
 		.port_ops = &ali_c2_port_ops
 	};
 	/* Revision 0xC3 is UDMA100 */
-	static struct ata_port_info info_c3 = {
+	static const struct ata_port_info info_c3 = {
 		.sht = &ali_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST | ATA_FLAG_PIO_LBA48,
 		.pio_mask = 0x1f,
@@ -564,7 +564,7 @@ static int ali_init_one(struct pci_dev *
 		.port_ops = &ali_c2_port_ops
 	};
 	/* Revision 0xC4 is UDMA133 */
-	static struct ata_port_info info_c4 = {
+	static const struct ata_port_info info_c4 = {
 		.sht = &ali_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST | ATA_FLAG_PIO_LBA48,
 		.pio_mask = 0x1f,
@@ -573,7 +573,7 @@ static int ali_init_one(struct pci_dev *
 		.port_ops = &ali_c2_port_ops
 	};
 	/* Revision 0xC5 is UDMA133 with LBA48 DMA */
-	static struct ata_port_info info_c5 = {
+	static const struct ata_port_info info_c5 = {
 		.sht = &ali_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -582,7 +582,7 @@ static int ali_init_one(struct pci_dev *
 		.port_ops = &ali_c5_port_ops
 	};
 
-	static struct ata_port_info *port_info[2];
+	const struct ata_port_info *ppi[] = { NULL, NULL };
 	u8 rev, tmp;
 	struct pci_dev *isa_bridge;
 
@@ -594,17 +594,17 @@ static int ali_init_one(struct pci_dev *
 	 */
 
 	if (rev < 0x20) {
-		port_info[0] = port_info[1] = &info_early;
+		ppi[0] = &info_early;
 	} else if (rev < 0xC2) {
-        	port_info[0] = port_info[1] = &info_20;
+        	ppi[0] = &info_20;
 	} else if (rev == 0xC2) {
-        	port_info[0] = port_info[1] = &info_c2;
+        	ppi[0] = &info_c2;
 	} else if (rev == 0xC3) {
-        	port_info[0] = port_info[1] = &info_c3;
+        	ppi[0] = &info_c3;
 	} else if (rev == 0xC4) {
-        	port_info[0] = port_info[1] = &info_c4;
+        	ppi[0] = &info_c4;
 	} else
-        	port_info[0] = port_info[1] = &info_c5;
+        	ppi[0] = &info_c5;
 
 	ali_init_chipset(pdev);
 
@@ -613,10 +613,10 @@ static int ali_init_one(struct pci_dev *
 		/* Are we paired with a UDMA capable chip */
 		pci_read_config_byte(isa_bridge, 0x5E, &tmp);
 		if ((tmp & 0x1E) == 0x12)
-	        	port_info[0] = port_info[1] = &info_20_udma;
+	        	ppi[0] = &info_20_udma;
 		pci_dev_put(isa_bridge);
 	}
-	return ata_pci_init_one(pdev, port_info, 2);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 #ifdef CONFIG_PM
diff -puN drivers/ata/pata_amd.c~libata-clean-up-sff-init-mess drivers/ata/pata_amd.c
--- a/drivers/ata/pata_amd.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_amd.c
@@ -542,7 +542,7 @@ static struct ata_port_operations nv133_
 
 static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info[10] = {
+	static const struct ata_port_info info[10] = {
 		{	/* 0: AMD 7401 */
 			.sht = &amd_sht,
 			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
@@ -624,7 +624,7 @@ static int amd_init_one(struct pci_dev *
 			.port_ops = &amd100_port_ops
 		}
 	};
-	static struct ata_port_info *port_info[2];
+	const struct ata_port_info *ppi[] = { NULL, NULL };
 	static int printed_version;
 	int type = id->driver_data;
 	u8 rev;
@@ -656,9 +656,8 @@ static int amd_init_one(struct pci_dev *
 		ata_pci_clear_simplex(pdev);
 
 	/* And fire it up */
-
-	port_info[0] = port_info[1] = &info[type];
-	return ata_pci_init_one(pdev, port_info, 2);
+	ppi[0] = &info[type];
+	return ata_pci_init_one(pdev, ppi);
 }
 
 #ifdef CONFIG_PM
diff -puN drivers/ata/pata_artop.c~libata-clean-up-sff-init-mess drivers/ata/pata_artop.c
--- a/drivers/ata/pata_artop.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_artop.c
@@ -414,7 +414,7 @@ static const struct ata_port_operations 
 static int artop_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	static int printed_version;
-	static struct ata_port_info info_6210 = {
+	static const struct ata_port_info info_6210 = {
 		.sht		= &artop_sht,
 		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask	= 0x1f,	/* pio0-4 */
@@ -422,7 +422,7 @@ static int artop_init_one (struct pci_de
 		.udma_mask 	= ATA_UDMA2,
 		.port_ops	= &artop6210_ops,
 	};
-	static struct ata_port_info info_626x = {
+	static const struct ata_port_info info_626x = {
 		.sht		= &artop_sht,
 		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask	= 0x1f,	/* pio0-4 */
@@ -430,7 +430,7 @@ static int artop_init_one (struct pci_de
 		.udma_mask 	= ATA_UDMA4,
 		.port_ops	= &artop6260_ops,
 	};
-	static struct ata_port_info info_626x_fast = {
+	static const struct ata_port_info info_626x_fast = {
 		.sht		= &artop_sht,
 		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask	= 0x1f,	/* pio0-4 */
@@ -438,32 +438,30 @@ static int artop_init_one (struct pci_de
 		.udma_mask 	= ATA_UDMA5,
 		.port_ops	= &artop6260_ops,
 	};
-	struct ata_port_info *port_info[2];
-	struct ata_port_info *info = NULL;
-	int ports = 2;
+	const struct ata_port_info *ppi[] = { NULL, NULL };
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
 	if (id->driver_data == 0) {	/* 6210 variant */
-		info = &info_6210;
+		ppi[0] = &info_6210;
+		ppi[1] = &ata_dummy_port_info;
 		/* BIOS may have left us in UDMA, clear it before libata probe */
 		pci_write_config_byte(pdev, 0x54, 0);
 		/* For the moment (also lacks dsc) */
 		printk(KERN_WARNING "ARTOP 6210 requires serialize functionality not yet supported by libata.\n");
 		printk(KERN_WARNING "Secondary ATA ports will not be activated.\n");
-		ports = 1;
 	}
 	else if (id->driver_data == 1)	/* 6260 */
-		info = &info_626x;
+		ppi[0] = &info_626x;
 	else if (id->driver_data == 2)	{ /* 6260 or 6260 + fast */
 		unsigned long io = pci_resource_start(pdev, 4);
 		u8 reg;
 
-		info = &info_626x;
+		ppi[0] = &info_626x;
 		if (inb(io) & 0x10)
-			info = &info_626x_fast;
+			ppi[0] = &info_626x_fast;
 		/* Mac systems come up with some registers not set as we
 		   will need them */
 
@@ -484,10 +482,9 @@ static int artop_init_one (struct pci_de
 
 	}
 
-	BUG_ON(info == NULL);
+	BUG_ON(ppi[0] == NULL);
 
-	port_info[0] = port_info[1] = info;
-	return ata_pci_init_one(pdev, port_info, ports);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 static const struct pci_device_id artop_pci_tbl[] = {
diff -puN drivers/ata/pata_atiixp.c~libata-clean-up-sff-init-mess drivers/ata/pata_atiixp.c
--- a/drivers/ata/pata_atiixp.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_atiixp.c
@@ -272,7 +272,7 @@ static struct ata_port_operations atiixp
 
 static int atiixp_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &atiixp_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -280,8 +280,8 @@ static int atiixp_init_one(struct pci_de
 		.udma_mask = 0x3F,
 		.port_ops = &atiixp_port_ops
 	};
-	static struct ata_port_info *port_info[2] = { &info, &info };
-	return ata_pci_init_one(dev, port_info, 2);
+	const struct ata_port_info *ppi[] = { &info, NULL };
+	return ata_pci_init_one(dev, ppi);
 }
 
 static const struct pci_device_id atiixp[] = {
diff -puN drivers/ata/pata_cmd640.c~libata-clean-up-sff-init-mess drivers/ata/pata_cmd640.c
--- a/drivers/ata/pata_cmd640.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_cmd640.c
@@ -253,17 +253,16 @@ static void cmd640_hardware_init(struct 
 
 static int cmd640_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &cmd640_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
 		.port_ops = &cmd640_port_ops
 	};
-
-	static struct ata_port_info *port_info[2] = { &info, &info };
+	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	cmd640_hardware_init(pdev);
-	return ata_pci_init_one(pdev, port_info, 2);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 static int cmd640_reinit_one(struct pci_dev *pdev)
diff -puN drivers/ata/pata_cmd64x.c~libata-clean-up-sff-init-mess drivers/ata/pata_cmd64x.c
--- a/drivers/ata/pata_cmd64x.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_cmd64x.c
@@ -381,7 +381,7 @@ static int cmd64x_init_one(struct pci_de
 {
 	u32 class_rev;
 
-	static struct ata_port_info cmd_info[6] = {
+	static const struct ata_port_info cmd_info[6] = {
 		{	/* CMD 643 - no UDMA */
 			.sht = &cmd64x_sht,
 			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
@@ -428,11 +428,9 @@ static int cmd64x_init_one(struct pci_de
 			.port_ops = &cmd648_port_ops
 		}
 	};
-	static struct ata_port_info *port_info[2], *info;
+	const struct ata_port_info *ppi[] = { &cmd_info[id->driver_data], NULL };
 	u8 mrdmode;
 
-	info = &cmd_info[id->driver_data];
-
 	pci_read_config_dword(pdev, PCI_CLASS_REVISION, &class_rev);
 	class_rev &= 0xFF;
 
@@ -442,10 +440,10 @@ static int cmd64x_init_one(struct pci_de
 	if (pdev->device == PCI_DEVICE_ID_CMD_646) {
 		/* Does UDMA work ? */
 		if (class_rev > 4)
-			info = &cmd_info[2];
+			ppi[0] = &cmd_info[2];
 		/* Early rev with other problems ? */
 		else if (class_rev == 1)
-			info = &cmd_info[3];
+			ppi[0] = &cmd_info[3];
 	}
 
 	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 64);
@@ -461,8 +459,7 @@ static int cmd64x_init_one(struct pci_de
 	pci_write_config_byte(pdev, UDIDETCR0, 0xF0);
 #endif
 
-	port_info[0] = port_info[1] = info;
-	return ata_pci_init_one(pdev, port_info, 2);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 #ifdef CONFIG_PM
diff -puN drivers/ata/pata_cs5530.c~libata-clean-up-sff-init-mess drivers/ata/pata_cs5530.c
--- a/drivers/ata/pata_cs5530.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_cs5530.c
@@ -339,7 +339,7 @@ fail_put:
 
 static int cs5530_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &cs5530_sht,
 		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -348,23 +348,23 @@ static int cs5530_init_one(struct pci_de
 		.port_ops = &cs5530_port_ops
 	};
 	/* The docking connector doesn't do UDMA, and it seems not MWDMA */
-	static struct ata_port_info info_palmax_secondary = {
+	static const struct ata_port_info info_palmax_secondary = {
 		.sht = &cs5530_sht,
 		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
 		.port_ops = &cs5530_port_ops
 	};
-	static struct ata_port_info *port_info[2] = { &info, &info };
+	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	/* Chip initialisation */
 	if (cs5530_init_chip())
 		return -ENODEV;
 
 	if (cs5530_is_palmax())
-		port_info[1] = &info_palmax_secondary;
+		ppi[1] = &info_palmax_secondary;
 
 	/* Now kick off ATA set up */
-	return ata_pci_init_one(pdev, port_info, 2);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 #ifdef CONFIG_PM
diff -puN drivers/ata/pata_cs5535.c~libata-clean-up-sff-init-mess drivers/ata/pata_cs5535.c
--- a/drivers/ata/pata_cs5535.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_cs5535.c
@@ -227,7 +227,7 @@ static struct ata_port_operations cs5535
 
 static int cs5535_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &cs5535_sht,
 		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -235,7 +235,7 @@ static int cs5535_init_one(struct pci_de
 		.udma_mask = 0x1f,
 		.port_ops = &cs5535_port_ops
 	};
-	struct ata_port_info *ports[1] = { &info };
+	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
 
 	u32 timings, dummy;
 
@@ -247,7 +247,7 @@ static int cs5535_init_one(struct pci_de
 	rdmsr(ATAC_CH0D1_PIO, timings, dummy);
 	if (CS5535_BAD_PIO(timings))
 		wrmsr(ATAC_CH0D1_PIO, 0xF7F4F7F4UL, 0);
-	return ata_pci_init_one(dev, ports, 1);
+	return ata_pci_init_one(dev, ppi);
 }
 
 static const struct pci_device_id cs5535[] = {
diff -puN drivers/ata/pata_cypress.c~libata-clean-up-sff-init-mess drivers/ata/pata_cypress.c
--- a/drivers/ata/pata_cypress.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_cypress.c
@@ -169,14 +169,14 @@ static struct ata_port_operations cy82c6
 
 static int cy82c693_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &cy82c693_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.port_ops = &cy82c693_port_ops
 	};
-	static struct ata_port_info *port_info[1] = { &info };
+	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
 
 	/* Devfn 1 is the ATA primary. The secondary is magic and on devfn2.
 	   For the moment we don't handle the secondary. FIXME */
@@ -184,7 +184,7 @@ static int cy82c693_init_one(struct pci_
 	if (PCI_FUNC(pdev->devfn) != 1)
 		return -ENODEV;
 
-	return ata_pci_init_one(pdev, port_info, 1);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 static const struct pci_device_id cy82c693[] = {
diff -puN drivers/ata/pata_efar.c~libata-clean-up-sff-init-mess drivers/ata/pata_efar.c
--- a/drivers/ata/pata_efar.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_efar.c
@@ -305,7 +305,7 @@ static const struct ata_port_operations 
 static int efar_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht		= &efar_sht,
 		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask	= 0x1f,	/* pio0-4 */
@@ -313,13 +313,13 @@ static int efar_init_one (struct pci_dev
 		.udma_mask 	= 0x0f, /* UDMA 66 */
 		.port_ops	= &efar_ops,
 	};
-	static struct ata_port_info *port_info[2] = { &info, &info };
+	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_init_one(pdev, port_info, 2);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 static const struct pci_device_id efar_pci_tbl[] = {
diff -puN drivers/ata/pata_hpt366.c~libata-clean-up-sff-init-mess drivers/ata/pata_hpt366.c
--- a/drivers/ata/pata_hpt366.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_hpt366.c
@@ -421,7 +421,7 @@ static void hpt36x_init_chipset(struct p
 
 static int hpt36x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info_hpt366 = {
+	static const struct ata_port_info info_hpt366 = {
 		.sht = &hpt36x_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -429,7 +429,8 @@ static int hpt36x_init_one(struct pci_de
 		.udma_mask = 0x1f,
 		.port_ops = &hpt366_port_ops
 	};
-	struct ata_port_info *port_info[2] = {&info_hpt366, &info_hpt366};
+	struct ata_port_info info = info_hpt366;
+	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	u32 class_rev;
 	u32 reg1;
@@ -450,17 +451,17 @@ static int hpt36x_init_one(struct pci_de
 	/* info_hpt366 is safe against re-entry so we can scribble on it */
 	switch((reg1 & 0x700) >> 8) {
 		case 5:
-			info_hpt366.private_data = &hpt366_40;
+			info.private_data = &hpt366_40;
 			break;
 		case 9:
-			info_hpt366.private_data = &hpt366_25;
+			info.private_data = &hpt366_25;
 			break;
 		default:
-			info_hpt366.private_data = &hpt366_33;
+			info.private_data = &hpt366_33;
 			break;
 	}
 	/* Now kick off ATA set up */
-	return ata_pci_init_one(dev, port_info, 2);
+	return ata_pci_init_one(dev, ppi);
 }
 
 #ifdef CONFIG_PM
diff -puN drivers/ata/pata_hpt37x.c~libata-clean-up-sff-init-mess drivers/ata/pata_hpt37x.c
--- a/drivers/ata/pata_hpt37x.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_hpt37x.c
@@ -887,7 +887,7 @@ static int hpt37x_calibrate_dpll(struct 
 static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	/* HPT370 - UDMA100 */
-	static struct ata_port_info info_hpt370 = {
+	static const struct ata_port_info info_hpt370 = {
 		.sht = &hpt37x_sht,
 		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -896,7 +896,7 @@ static int hpt37x_init_one(struct pci_de
 		.port_ops = &hpt370_port_ops
 	};
 	/* HPT370A - UDMA100 */
-	static struct ata_port_info info_hpt370a = {
+	static const struct ata_port_info info_hpt370a = {
 		.sht = &hpt37x_sht,
 		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -905,7 +905,7 @@ static int hpt37x_init_one(struct pci_de
 		.port_ops = &hpt370a_port_ops
 	};
 	/* HPT370 - UDMA100 */
-	static struct ata_port_info info_hpt370_33 = {
+	static const struct ata_port_info info_hpt370_33 = {
 		.sht = &hpt37x_sht,
 		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -914,7 +914,7 @@ static int hpt37x_init_one(struct pci_de
 		.port_ops = &hpt370_port_ops
 	};
 	/* HPT370A - UDMA100 */
-	static struct ata_port_info info_hpt370a_33 = {
+	static const struct ata_port_info info_hpt370a_33 = {
 		.sht = &hpt37x_sht,
 		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -923,7 +923,7 @@ static int hpt37x_init_one(struct pci_de
 		.port_ops = &hpt370a_port_ops
 	};
 	/* HPT371, 372 and friends - UDMA133 */
-	static struct ata_port_info info_hpt372 = {
+	static const struct ata_port_info info_hpt372 = {
 		.sht = &hpt37x_sht,
 		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -932,7 +932,7 @@ static int hpt37x_init_one(struct pci_de
 		.port_ops = &hpt372_port_ops
 	};
 	/* HPT371, 372 and friends - UDMA100 at 50MHz clock */
-	static struct ata_port_info info_hpt372_50 = {
+	static const struct ata_port_info info_hpt372_50 = {
 		.sht = &hpt37x_sht,
 		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -941,7 +941,7 @@ static int hpt37x_init_one(struct pci_de
 		.port_ops = &hpt372_port_ops
 	};
 	/* HPT374 - UDMA133 */
-	static struct ata_port_info info_hpt374 = {
+	static const struct ata_port_info info_hpt374 = {
 		.sht = &hpt37x_sht,
 		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -951,9 +951,10 @@ static int hpt37x_init_one(struct pci_de
 	};
 
 	static const int MHz[4] = { 33, 40, 50, 66 };
-
-	struct ata_port_info *port_info[2];
-	struct ata_port_info *port;
+	const struct ata_port_info *port;
+	void *private_data = NULL;
+	struct ata_port_info port_info;
+	const struct ata_port_info *ppi[] = { &port_info, NULL };
 
 	u8 irqmask;
 	u32 class_rev;
@@ -1124,13 +1125,13 @@ static int hpt37x_init_one(struct pci_de
 			return -ENODEV;
 		}
 		if (clock_slot == 3)
-			port->private_data = (void *)hpt37x_timings_66;
+			private_data = (void *)hpt37x_timings_66;
 		else
-			port->private_data = (void *)hpt37x_timings_50;
+			private_data = (void *)hpt37x_timings_50;
 
 		printk(KERN_INFO "hpt37x: Bus clock %dMHz, using DPLL.\n", MHz[clock_slot]);
 	} else {
-		port->private_data = (void *)chip_table->clocks[clock_slot];
+		private_data = (void *)chip_table->clocks[clock_slot];
 		/*
 		 *	Perform a final fixup. Note that we will have used the
 		 *	DPLL on the HPT372 which means we don't have to worry
@@ -1144,9 +1145,11 @@ static int hpt37x_init_one(struct pci_de
 		printk(KERN_INFO "hpt37x: %s: Bus clock %dMHz.\n", chip_table->name, MHz[clock_slot]);
 	}
 
-	port_info[0] = port_info[1] = port;
 	/* Now kick off ATA set up */
-	return ata_pci_init_one(dev, port_info, 2);
+	port_info = *port;
+	port_info.private_data = private_data;
+
+	return ata_pci_init_one(dev, ppi);
 }
 
 static const struct pci_device_id hpt37x[] = {
diff -puN drivers/ata/pata_hpt3x2n.c~libata-clean-up-sff-init-mess drivers/ata/pata_hpt3x2n.c
--- a/drivers/ata/pata_hpt3x2n.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_hpt3x2n.c
@@ -488,7 +488,7 @@ static int hpt3x2n_pci_clock(struct pci_
 static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	/* HPT372N and friends - UDMA133 */
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &hpt3x2n_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -496,8 +496,8 @@ static int hpt3x2n_init_one(struct pci_d
 		.udma_mask = 0x7f,
 		.port_ops = &hpt3x2n_port_ops
 	};
-	struct ata_port_info *port_info[2];
-	struct ata_port_info *port = &info;
+	struct ata_port_info port = info;
+	const struct ata_port_info *ppi[] = { &port, NULL };
 
 	u8 irqmask;
 	u32 class_rev;
@@ -585,9 +585,9 @@ static int hpt3x2n_init_one(struct pci_d
 
 	/* Set our private data up. We only need a few flags so we use
 	   it directly */
-	port->private_data = NULL;
+	port.private_data = NULL;
 	if (pci_mhz > 60) {
-		port->private_data = (void *)PCI66;
+		port.private_data = (void *)PCI66;
 		/*
 		 * On  HPT371N, if ATA clock is 66 MHz we must set bit 2 in
 		 * the MISC. register to stretch the UltraDMA Tss timing.
@@ -598,8 +598,7 @@ static int hpt3x2n_init_one(struct pci_d
 	}
 
 	/* Now kick off ATA set up */
-	port_info[0] = port_info[1] = port;
-	return ata_pci_init_one(dev, port_info, 2);
+	return ata_pci_init_one(dev, ppi);
 }
 
 static const struct pci_device_id hpt3x2n[] = {
diff -puN drivers/ata/pata_hpt3x3.c~libata-clean-up-sff-init-mess drivers/ata/pata_hpt3x3.c
--- a/drivers/ata/pata_hpt3x3.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_hpt3x3.c
@@ -175,7 +175,7 @@ static void hpt3x3_init_chipset(struct p
 
 static int hpt3x3_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &hpt3x3_sht,
 		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -183,11 +183,11 @@ static int hpt3x3_init_one(struct pci_de
 		.udma_mask = 0x07,
 		.port_ops = &hpt3x3_port_ops
 	};
-	static struct ata_port_info *port_info[2] = { &info, &info };
+	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	hpt3x3_init_chipset(dev);
 	/* Now kick off ATA set up */
-	return ata_pci_init_one(dev, port_info, 2);
+	return ata_pci_init_one(dev, ppi);
 }
 
 #ifdef CONFIG_PM
diff -puN drivers/ata/pata_it8213.c~libata-clean-up-sff-init-mess drivers/ata/pata_it8213.c
--- a/drivers/ata/pata_it8213.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_it8213.c
@@ -315,7 +315,7 @@ static const struct ata_port_operations 
 static int it8213_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht		= &it8213_sht,
 		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask	= 0x1f,	/* pio0-4 */
@@ -323,14 +323,14 @@ static int it8213_init_one (struct pci_d
 		.udma_mask 	= 0x1f, /* UDMA 100 */
 		.port_ops	= &it8213_ops,
 	};
-	static struct ata_port_info *port_info[2] = { &info, &info };
+	/* Current IT8213 stuff is single port */
+	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	/* Current IT8213 stuff is single port */
-	return ata_pci_init_one(pdev, port_info, 1);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 static const struct pci_device_id it8213_pci_tbl[] = {
diff -puN drivers/ata/pata_it821x.c~libata-clean-up-sff-init-mess drivers/ata/pata_it821x.c
--- a/drivers/ata/pata_it821x.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_it821x.c
@@ -722,14 +722,14 @@ static int it821x_init_one(struct pci_de
 {
 	u8 conf;
 
-	static struct ata_port_info info_smart = {
+	static const struct ata_port_info info_smart = {
 		.sht = &it821x_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.port_ops = &it821x_smart_port_ops
 	};
-	static struct ata_port_info info_passthru = {
+	static const struct ata_port_info info_passthru = {
 		.sht = &it821x_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -737,8 +737,8 @@ static int it821x_init_one(struct pci_de
 		.udma_mask = 0x7f,
 		.port_ops = &it821x_passthru_port_ops
 	};
-	static struct ata_port_info *port_info[2];
 
+	const struct ata_port_info *ppi[] = { NULL, NULL };
 	static char *mode[2] = { "pass through", "smart" };
 
 	/* Force the card into bypass mode if so requested */
@@ -751,11 +751,11 @@ static int it821x_init_one(struct pci_de
 
 	printk(KERN_INFO DRV_NAME ": controller in %s mode.\n", mode[conf]);
 	if (conf == 0)
-		port_info[0] = port_info[1] = &info_passthru;
+		ppi[0] = &info_passthru;
 	else
-		port_info[0] = port_info[1] = &info_smart;
+		ppi[0] = &info_smart;
 
-	return ata_pci_init_one(pdev, port_info, 2);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 #ifdef CONFIG_PM
diff -puN drivers/ata/pata_jmicron.c~libata-clean-up-sff-init-mess drivers/ata/pata_jmicron.c
--- a/drivers/ata/pata_jmicron.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_jmicron.c
@@ -195,7 +195,7 @@ static const struct ata_port_operations 
 
 static int jmicron_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht		= &jmicron_sht,
 		.flags	= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 
@@ -205,9 +205,9 @@ static int jmicron_init_one (struct pci_
 
 		.port_ops	= &jmicron_ops,
 	};
-	struct ata_port_info *port_info[2] = { &info, &info };
+	const struct ata_port_info *ppi[] = { &info, NULL };
 
-	return ata_pci_init_one(pdev, port_info, 2);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 static const struct pci_device_id jmicron_pci_tbl[] = {
diff -puN drivers/ata/pata_marvell.c~libata-clean-up-sff-init-mess drivers/ata/pata_marvell.c
--- a/drivers/ata/pata_marvell.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_marvell.c
@@ -165,7 +165,7 @@ static const struct ata_port_operations 
 
 static int marvell_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht		= &marvell_sht,
 		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 
@@ -175,7 +175,7 @@ static int marvell_init_one (struct pci_
 
 		.port_ops	= &marvell_ops,
 	};
-	static struct ata_port_info info_sata = {
+	static const struct ata_port_info info_sata = {
 		.sht		= &marvell_sht,
 		/* Slave possible as its magically mapped not real */
 		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
@@ -186,13 +186,12 @@ static int marvell_init_one (struct pci_
 
 		.port_ops	= &marvell_ops,
 	};
-	struct ata_port_info *port_info[2] = { &info, &info_sata };
-	int n_port = 2;
+	const struct ata_port_info *ppi[] = { &info, &info_sata };
 
 	if (pdev->device == 0x6101)
-		n_port = 1;
+		ppi[1] = &ata_dummy_port_info;
 
-	return ata_pci_init_one(pdev, port_info, n_port);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 static const struct pci_device_id marvell_pci_tbl[] = {
diff -puN drivers/ata/pata_netcell.c~libata-clean-up-sff-init-mess drivers/ata/pata_netcell.c
--- a/drivers/ata/pata_netcell.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_netcell.c
@@ -96,7 +96,7 @@ static const struct ata_port_operations 
 static int netcell_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht		= &netcell_sht,
 		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		/* Actually we don't really care about these as the
@@ -106,7 +106,7 @@ static int netcell_init_one (struct pci_
 		.udma_mask 	= 0x3f, /* UDMA 133 */
 		.port_ops	= &netcell_ops,
 	};
-	static struct ata_port_info *port_info[2] = { &info, &info };
+	const struct ata_port_info *port_info[] = { &info, NULL };
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev,
@@ -116,7 +116,7 @@ static int netcell_init_one (struct pci_
 	ata_pci_clear_simplex(pdev);
 
 	/* And let the library code do the work */
-	return ata_pci_init_one(pdev, port_info, 2);
+	return ata_pci_init_one(pdev, port_info);
 }
 
 static const struct pci_device_id netcell_pci_tbl[] = {
diff -puN drivers/ata/pata_ns87410.c~libata-clean-up-sff-init-mess drivers/ata/pata_ns87410.c
--- a/drivers/ata/pata_ns87410.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_ns87410.c
@@ -195,14 +195,14 @@ static struct ata_port_operations ns8741
 
 static int ns87410_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &ns87410_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x0F,
 		.port_ops = &ns87410_port_ops
 	};
-	static struct ata_port_info *port_info[2] = {&info, &info};
-	return ata_pci_init_one(dev, port_info, 2);
+	const struct ata_port_info *ppi[] = { &info, NULL };
+	return ata_pci_init_one(dev, ppi);
 }
 
 static const struct pci_device_id ns87410[] = {
diff -puN drivers/ata/pata_oldpiix.c~libata-clean-up-sff-init-mess drivers/ata/pata_oldpiix.c
--- a/drivers/ata/pata_oldpiix.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_oldpiix.c
@@ -293,20 +293,20 @@ static const struct ata_port_operations 
 static int oldpiix_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht		= &oldpiix_sht,
 		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma1-2 */
 		.port_ops	= &oldpiix_pata_ops,
 	};
-	static struct ata_port_info *port_info[2] = { &info, &info };
+	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_init_one(pdev, port_info, 2);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 static const struct pci_device_id oldpiix_pci_tbl[] = {
diff -puN drivers/ata/pata_opti.c~libata-clean-up-sff-init-mess drivers/ata/pata_opti.c
--- a/drivers/ata/pata_opti.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_opti.c
@@ -220,19 +220,19 @@ static struct ata_port_operations opti_p
 
 static int opti_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &opti_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
 		.port_ops = &opti_port_ops
 	};
-	static struct ata_port_info *port_info[2] = { &info, &info };
+	const struct ata_port_info *ppi[] = { &info, NULL };
 	static int printed_version;
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &dev->dev, "version " DRV_VERSION "\n");
 
-	return ata_pci_init_one(dev, port_info, 2);
+	return ata_pci_init_one(dev, ppi);
 }
 
 static const struct pci_device_id opti[] = {
diff -puN drivers/ata/pata_optidma.c~libata-clean-up-sff-init-mess drivers/ata/pata_optidma.c
--- a/drivers/ata/pata_optidma.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_optidma.c
@@ -486,14 +486,14 @@ done_nomsg:		/* Wrong chip revision */
 
 static int optidma_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info_82c700 = {
+	static const struct ata_port_info info_82c700 = {
 		.sht = &optidma_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.port_ops = &optidma_port_ops
 	};
-	static struct ata_port_info info_82c700_udma = {
+	static const struct ata_port_info info_82c700_udma = {
 		.sht = &optidma_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -501,8 +501,7 @@ static int optidma_init_one(struct pci_d
 		.udma_mask = 0x07,
 		.port_ops = &optiplus_port_ops
 	};
-	static struct ata_port_info *port_info[2];
-	struct ata_port_info *info = &info_82c700;
+	const struct ata_port_info *ppi[] = { &info_82c700, NULL };
 	static int printed_version;
 
 	if (!printed_version++)
@@ -514,10 +513,9 @@ static int optidma_init_one(struct pci_d
 	pci_clock = inb(0x1F5) & 1;		/* 0 = 33Mhz, 1 = 25Mhz */
 
 	if (optiplus_with_udma(dev))
-		info = &info_82c700_udma;
+		ppi[0] = &info_82c700_udma;
 
-	port_info[0] = port_info[1] = info;
-	return ata_pci_init_one(dev, port_info, 2);
+	return ata_pci_init_one(dev, ppi);
 }
 
 static const struct pci_device_id optidma[] = {
diff -puN drivers/ata/pata_pdc202xx_old.c~libata-clean-up-sff-init-mess drivers/ata/pata_pdc202xx_old.c
--- a/drivers/ata/pata_pdc202xx_old.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_pdc202xx_old.c
@@ -321,7 +321,7 @@ static struct ata_port_operations pdc202
 
 static int pdc202xx_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info[3] = {
+	static const struct ata_port_info info[3] = {
 		{
 			.sht = &pdc202xx_sht,
 			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
@@ -348,9 +348,7 @@ static int pdc202xx_init_one(struct pci_
 		}
 
 	};
-	static struct ata_port_info *port_info[2];
-
-	port_info[0] = port_info[1] = &info[id->driver_data];
+	const struct ata_port_info *ppi[] = { &info[id->driver_data], NULL };
 
 	if (dev->device == PCI_DEVICE_ID_PROMISE_20265) {
 		struct pci_dev *bridge = dev->bus->self;
@@ -362,7 +360,7 @@ static int pdc202xx_init_one(struct pci_
 				return -ENODEV;
 		}
 	}
-	return ata_pci_init_one(dev, port_info, 2);
+	return ata_pci_init_one(dev, ppi);
 }
 
 static const struct pci_device_id pdc202xx[] = {
diff -puN drivers/ata/pata_radisys.c~libata-clean-up-sff-init-mess drivers/ata/pata_radisys.c
--- a/drivers/ata/pata_radisys.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_radisys.c
@@ -259,7 +259,7 @@ static const struct ata_port_operations 
 static int radisys_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht		= &radisys_sht,
 		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask	= 0x1f,	/* pio0-4 */
@@ -267,13 +267,13 @@ static int radisys_init_one (struct pci_
 		.udma_mask	= 0x14, /* UDMA33/66 only */
 		.port_ops	= &radisys_pata_ops,
 	};
-	static struct ata_port_info *port_info[2] = { &info, &info };
+	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_init_one(pdev, port_info, 2);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 static const struct pci_device_id radisys_pci_tbl[] = {
diff -puN drivers/ata/pata_rz1000.c~libata-clean-up-sff-init-mess drivers/ata/pata_rz1000.c
--- a/drivers/ata/pata_rz1000.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_rz1000.c
@@ -135,22 +135,20 @@ static int rz1000_fifo_disable(struct pc
 static int rz1000_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
-	struct ata_port_info *port_info[2];
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &rz1000_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
 		.port_ops = &rz1000_port_ops
 	};
+	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	if (!printed_version++)
 		printk(KERN_DEBUG DRV_NAME " version " DRV_VERSION "\n");
 
-	if (rz1000_fifo_disable(pdev) == 0) {
-		port_info[0] = &info;
-		port_info[1] = &info;
-		return ata_pci_init_one(pdev, port_info, 2);
-	}
+	if (rz1000_fifo_disable(pdev) == 0)
+		return ata_pci_init_one(pdev, ppi);
+
 	printk(KERN_ERR DRV_NAME ": failed to disable read-ahead on chipset..\n");
 	/* Not safe to use so skip */
 	return -ENODEV;
diff -puN drivers/ata/pata_sc1200.c~libata-clean-up-sff-init-mess drivers/ata/pata_sc1200.c
--- a/drivers/ata/pata_sc1200.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_sc1200.c
@@ -247,7 +247,7 @@ static struct ata_port_operations sc1200
 
 static int sc1200_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &sc1200_sht,
 		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -255,10 +255,10 @@ static int sc1200_init_one(struct pci_de
 		.udma_mask = 0x07,
 		.port_ops = &sc1200_port_ops
 	};
-	static struct ata_port_info *port_info[2] = { &info, &info };
-
 	/* Can't enable port 2 yet, see top comments */
-	return ata_pci_init_one(dev, port_info, 1);
+	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
+
+	return ata_pci_init_one(dev, ppi);
 }
 
 static const struct pci_device_id sc1200[] = {
diff -puN drivers/ata/pata_serverworks.c~libata-clean-up-sff-init-mess drivers/ata/pata_serverworks.c
--- a/drivers/ata/pata_serverworks.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_serverworks.c
@@ -479,8 +479,7 @@ static void serverworks_fixup_ht1000(str
 
 static int serverworks_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	int ports = 2;
-	static struct ata_port_info info[4] = {
+	static const struct ata_port_info info[4] = {
 		{ /* OSB4 */
 			.sht = &serverworks_sht,
 			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
@@ -511,8 +510,7 @@ static int serverworks_init_one(struct p
 			.port_ops = &serverworks_csb_port_ops
 		}
 	};
-	static struct ata_port_info *port_info[2];
-	struct ata_port_info *devinfo = &info[id->driver_data];
+	const struct ata_port_info *ppi[] = { &info[id->driver_data], NULL };
 
 	/* Force master latency timer to 64 PCI clocks */
 	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x40);
@@ -521,7 +519,7 @@ static int serverworks_init_one(struct p
 	if (pdev->device == PCI_DEVICE_ID_SERVERWORKS_OSB4IDE) {
 		/* Select non UDMA capable OSB4 if we can't do fixups */
 		if ( serverworks_fixup_osb4(pdev) < 0)
-			devinfo = &info[1];
+			ppi[0] = &info[1];
 	}
 	/* setup CSB5/CSB6 : South Bridge and IDE option RAID */
 	else if ((pdev->device == PCI_DEVICE_ID_SERVERWORKS_CSB5IDE) ||
@@ -531,11 +529,11 @@ static int serverworks_init_one(struct p
 		 /* If the returned btr is the newer revision then
 		    select the right info block */
 		 if (serverworks_fixup_csb(pdev) == 3)
-		 	devinfo = &info[3];
+		 	ppi[0] = &info[3];
 
 		/* Is this the 3rd channel CSB6 IDE ? */
 		if (pdev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2)
-			ports = 1;
+			ppi[1] = &ata_dummy_port_info;
 	}
 	/* setup HT1000E */
 	else if (pdev->device == PCI_DEVICE_ID_SERVERWORKS_HT1000IDE)
@@ -544,8 +542,7 @@ static int serverworks_init_one(struct p
 	if (pdev->device == PCI_DEVICE_ID_SERVERWORKS_CSB5IDE)
 		ata_pci_clear_simplex(pdev);
 
-	port_info[0] = port_info[1] = devinfo;
-	return ata_pci_init_one(pdev, port_info, ports);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 #ifdef CONFIG_PM
diff -puN drivers/ata/pata_sil680.c~libata-clean-up-sff-init-mess drivers/ata/pata_sil680.c
--- a/drivers/ata/pata_sil680.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_sil680.c
@@ -345,7 +345,7 @@ static u8 sil680_init_chip(struct pci_de
 
 static int sil680_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &sil680_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -353,7 +353,7 @@ static int sil680_init_one(struct pci_de
 		.udma_mask = 0x7f,
 		.port_ops = &sil680_port_ops
 	};
-	static struct ata_port_info info_slow = {
+	static const struct ata_port_info info_slow = {
 		.sht = &sil680_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -361,7 +361,7 @@ static int sil680_init_one(struct pci_de
 		.udma_mask = 0x3f,
 		.port_ops = &sil680_port_ops
 	};
-	static struct ata_port_info *port_info[2] = {&info, &info};
+	const struct ata_port_info *ppi[] = { &info, NULL };
 	static int printed_version;
 
 	if (!printed_version++)
@@ -370,12 +370,12 @@ static int sil680_init_one(struct pci_de
 	switch(sil680_init_chip(pdev))
 	{
 		case 0:
-			port_info[0] = port_info[1] = &info_slow;
+			ppi[0] = &info_slow;
 			break;
 		case 0x30:
 			return -ENODEV;
 	}
-	return ata_pci_init_one(pdev, port_info, 2);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 #ifdef CONFIG_PM
diff -puN drivers/ata/pata_sis.c~libata-clean-up-sff-init-mess drivers/ata/pata_sis.c
--- a/drivers/ata/pata_sis.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_sis.c
@@ -38,8 +38,8 @@
 #define DRV_VERSION	"0.5.1"
 
 struct sis_chipset {
-	u16 device;			/* PCI host ID */
-	struct ata_port_info *info;	/* Info block */
+	u16 device;				/* PCI host ID */
+	const struct ata_port_info *info;	/* Info block */
 	/* Probably add family, cable detect type etc here to clean
 	   up code later */
 };
@@ -700,7 +700,7 @@ static const struct ata_port_operations 
 	.port_start		= ata_port_start,
 };
 
-static struct ata_port_info sis_info = {
+static const struct ata_port_info sis_info = {
 	.sht		= &sis_sht,
 	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 	.pio_mask	= 0x1f,	/* pio0-4 */
@@ -708,7 +708,7 @@ static struct ata_port_info sis_info = {
 	.udma_mask	= 0,
 	.port_ops	= &sis_old_ops,
 };
-static struct ata_port_info sis_info33 = {
+static const struct ata_port_info sis_info33 = {
 	.sht		= &sis_sht,
 	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 	.pio_mask	= 0x1f,	/* pio0-4 */
@@ -716,35 +716,35 @@ static struct ata_port_info sis_info33 =
 	.udma_mask	= ATA_UDMA2,	/* UDMA 33 */
 	.port_ops	= &sis_old_ops,
 };
-static struct ata_port_info sis_info66 = {
+static const struct ata_port_info sis_info66 = {
 	.sht		= &sis_sht,
 	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 	.pio_mask	= 0x1f,	/* pio0-4 */
 	.udma_mask	= ATA_UDMA4,	/* UDMA 66 */
 	.port_ops	= &sis_66_ops,
 };
-static struct ata_port_info sis_info100 = {
+static const struct ata_port_info sis_info100 = {
 	.sht		= &sis_sht,
 	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 	.pio_mask	= 0x1f,	/* pio0-4 */
 	.udma_mask	= ATA_UDMA5,
 	.port_ops	= &sis_100_ops,
 };
-static struct ata_port_info sis_info100_early = {
+static const struct ata_port_info sis_info100_early = {
 	.sht		= &sis_sht,
 	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 	.udma_mask	= ATA_UDMA5,
 	.pio_mask	= 0x1f,	/* pio0-4 */
 	.port_ops	= &sis_66_ops,
 };
-struct ata_port_info sis_info133 = {
+const struct ata_port_info sis_info133 = {
 	.sht		= &sis_sht,
 	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 	.pio_mask	= 0x1f,	/* pio0-4 */
 	.udma_mask	= ATA_UDMA6,
 	.port_ops	= &sis_133_ops,
 };
-static struct ata_port_info sis_info133_early = {
+static const struct ata_port_info sis_info133_early = {
 	.sht		= &sis_sht,
 	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 	.pio_mask	= 0x1f,	/* pio0-4 */
@@ -827,8 +827,8 @@ static void sis_fixup(struct pci_dev *pd
 static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
-	static struct ata_port_info *port_info[2];
-	struct ata_port_info *port;
+	struct ata_port_info port;
+	const struct ata_port_info *ppi[] = { &port, NULL };
 	struct pci_dev *host = NULL;
 	struct sis_chipset *chipset = NULL;
 	struct sis_chipset *sets;
@@ -968,13 +968,12 @@ static int sis_init_one (struct pci_dev 
 	if (chipset == NULL)
 		return -ENODEV;
 
-	port = chipset->info;
-	port->private_data = chipset;
+	port = *chipset->info;
+	port.private_data = chipset;
 
 	sis_fixup(pdev, chipset);
 
-	port_info[0] = port_info[1] = port;
-	return ata_pci_init_one(pdev, port_info, 2);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 static const struct pci_device_id sis_pci_tbl[] = {
diff -puN drivers/ata/pata_sl82c105.c~libata-clean-up-sff-init-mess drivers/ata/pata_sl82c105.c
--- a/drivers/ata/pata_sl82c105.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_sl82c105.c
@@ -301,20 +301,22 @@ static int sl82c105_bridge_revision(stru
 
 static int sl82c105_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info_dma = {
+	static const struct ata_port_info info_dma = {
 		.sht = &sl82c105_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.port_ops = &sl82c105_port_ops
 	};
-	static struct ata_port_info info_early = {
+	static const struct ata_port_info info_early = {
 		.sht = &sl82c105_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
 		.port_ops = &sl82c105_port_ops
 	};
-	static struct ata_port_info *port_info[2] = { &info_early, &info_early };
+	/* for now use only the first port */
+	const struct ata_port_info *ppi[] = { &info_early,
+					       &ata_dummy_port_info };
 	u32 val;
 	int rev;
 
@@ -324,17 +326,14 @@ static int sl82c105_init_one(struct pci_
 		dev_printk(KERN_WARNING, &dev->dev, "pata_sl82c105: Unable to find bridge, disabling DMA.\n");
 	else if (rev <= 5)
 		dev_printk(KERN_WARNING, &dev->dev, "pata_sl82c105: Early bridge revision, no DMA available.\n");
-	else {
-		port_info[0] = &info_dma;
-		port_info[1] = &info_dma;
-	}
+	else
+		ppi[0] = &info_dma;
 
 	pci_read_config_dword(dev, 0x40, &val);
 	val |= CTRL_P0EN | CTRL_P0F16 | CTRL_P1F16;
 	pci_write_config_dword(dev, 0x40, val);
 
-
-	return ata_pci_init_one(dev, port_info, 1); /* For now */
+	return ata_pci_init_one(dev, ppi);
 }
 
 static const struct pci_device_id sl82c105[] = {
diff -puN drivers/ata/pata_triflex.c~libata-clean-up-sff-init-mess drivers/ata/pata_triflex.c
--- a/drivers/ata/pata_triflex.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_triflex.c
@@ -237,20 +237,20 @@ static struct ata_port_operations trifle
 
 static int triflex_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &triflex_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.port_ops = &triflex_port_ops
 	};
-	static struct ata_port_info *port_info[2] = { &info, &info };
+	const struct ata_port_info *ppi[] = { &info, NULL };
 	static int printed_version;
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &dev->dev, "version " DRV_VERSION "\n");
 
-	return ata_pci_init_one(dev, port_info, 2);
+	return ata_pci_init_one(dev, ppi);
 }
 
 static const struct pci_device_id triflex[] = {
diff -puN drivers/ata/pata_via.c~libata-clean-up-sff-init-mess drivers/ata/pata_via.c
--- a/drivers/ata/pata_via.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/pata_via.c
@@ -425,7 +425,7 @@ static void via_config_fifo(struct pci_d
 static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	/* Early VIA without UDMA support */
-	static struct ata_port_info via_mwdma_info = {
+	static const struct ata_port_info via_mwdma_info = {
 		.sht = &via_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SETXFER_POLLING,
 		.pio_mask = 0x1f,
@@ -433,7 +433,7 @@ static int via_init_one(struct pci_dev *
 		.port_ops = &via_port_ops
 	};
 	/* Ditto with IRQ masking required */
-	static struct ata_port_info via_mwdma_info_borked = {
+	static const struct ata_port_info via_mwdma_info_borked = {
 		.sht = &via_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SETXFER_POLLING,
 		.pio_mask = 0x1f,
@@ -441,7 +441,7 @@ static int via_init_one(struct pci_dev *
 		.port_ops = &via_port_ops_noirq,
 	};
 	/* VIA UDMA 33 devices (and borked 66) */
-	static struct ata_port_info via_udma33_info = {
+	static const struct ata_port_info via_udma33_info = {
 		.sht = &via_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SETXFER_POLLING,
 		.pio_mask = 0x1f,
@@ -450,7 +450,7 @@ static int via_init_one(struct pci_dev *
 		.port_ops = &via_port_ops
 	};
 	/* VIA UDMA 66 devices */
-	static struct ata_port_info via_udma66_info = {
+	static const struct ata_port_info via_udma66_info = {
 		.sht = &via_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SETXFER_POLLING,
 		.pio_mask = 0x1f,
@@ -459,7 +459,7 @@ static int via_init_one(struct pci_dev *
 		.port_ops = &via_port_ops
 	};
 	/* VIA UDMA 100 devices */
-	static struct ata_port_info via_udma100_info = {
+	static const struct ata_port_info via_udma100_info = {
 		.sht = &via_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SETXFER_POLLING,
 		.pio_mask = 0x1f,
@@ -468,7 +468,7 @@ static int via_init_one(struct pci_dev *
 		.port_ops = &via_port_ops
 	};
 	/* UDMA133 with bad AST (All current 133) */
-	static struct ata_port_info via_udma133_info = {
+	static const struct ata_port_info via_udma133_info = {
 		.sht = &via_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SETXFER_POLLING,
 		.pio_mask = 0x1f,
@@ -476,7 +476,8 @@ static int via_init_one(struct pci_dev *
 		.udma_mask = 0x7f,	/* FIXME: should check north bridge */
 		.port_ops = &via_port_ops
 	};
-	struct ata_port_info *port_info[2], *type;
+	struct ata_port_info type;
+	const struct ata_port_info *ppi[] = { &type, NULL };
 	struct pci_dev *isa = NULL;
 	const struct via_isa_bridge *config;
 	static int printed_version;
@@ -521,25 +522,25 @@ static int via_init_one(struct pci_dev *
 	switch(config->flags & VIA_UDMA) {
 		case VIA_UDMA_NONE:
 			if (config->flags & VIA_NO_UNMASK)
-				type = &via_mwdma_info_borked;
+				type = via_mwdma_info_borked;
 			else
-				type = &via_mwdma_info;
+				type = via_mwdma_info;
 			break;
 		case VIA_UDMA_33:
-			type = &via_udma33_info;
+			type = via_udma33_info;
 			break;
 		case VIA_UDMA_66:
-			type = &via_udma66_info;
+			type = via_udma66_info;
 			/* The 66 MHz devices require we enable the clock */
 			pci_read_config_dword(pdev, 0x50, &timing);
 			timing |= 0x80008;
 			pci_write_config_dword(pdev, 0x50, timing);
 			break;
 		case VIA_UDMA_100:
-			type = &via_udma100_info;
+			type = via_udma100_info;
 			break;
 		case VIA_UDMA_133:
-			type = &via_udma133_info;
+			type = via_udma133_info;
 			break;
 		default:
 			WARN_ON(1);
@@ -554,10 +555,9 @@ static int via_init_one(struct pci_dev *
 	}
 
 	/* We have established the device type, now fire it up */
-	type->private_data = (void *)config;
+	type.private_data = (void *)config;
 
-	port_info[0] = port_info[1] = type;
-	return ata_pci_init_one(pdev, port_info, 2);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 #ifdef CONFIG_PM
diff -puN drivers/ata/sata_nv.c~libata-clean-up-sff-init-mess drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/sata_nv.c
@@ -463,7 +463,7 @@ static const struct ata_port_operations 
 	.host_stop		= nv_adma_host_stop,
 };
 
-static struct ata_port_info nv_port_info[] = {
+static const struct ata_port_info nv_port_info[] = {
 	/* generic */
 	{
 		.sht		= &nv_sht,
@@ -1481,7 +1481,7 @@ static void nv_adma_error_handler(struct
 static int nv_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version = 0;
-	const struct ata_port_info *ppi[2];
+	const struct ata_port_info *ppi[] = { NULL, NULL };
 	struct ata_host *host;
 	struct nv_host_priv *hpriv;
 	int rc;
@@ -1509,8 +1509,8 @@ static int nv_init_one (struct pci_dev *
 		type = ADMA;
 	}
 
-	ppi[0] = ppi[1] = &nv_port_info[type];
-	rc = ata_pci_prepare_native_host(pdev, ppi, 2, &host);
+	ppi[0] = &nv_port_info[type];
+	rc = ata_pci_prepare_native_host(pdev, ppi, &host);
 	if (rc)
 		return rc;
 
diff -puN drivers/ata/sata_sis.c~libata-clean-up-sff-init-mess drivers/ata/sata_sis.c
--- a/drivers/ata/sata_sis.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/sata_sis.c
@@ -129,7 +129,7 @@ static const struct ata_port_operations 
 	.port_start		= ata_port_start,
 };
 
-static struct ata_port_info sis_port_info = {
+static const struct ata_port_info sis_port_info = {
 	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
 	.pio_mask	= 0x1f,
 	.mwdma_mask	= 0x7,
@@ -255,7 +255,7 @@ static int sis_init_one (struct pci_dev 
 {
 	static int printed_version;
 	struct ata_port_info pi = sis_port_info;
-	const struct ata_port_info *ppi[2] = { &pi, &pi };
+	const struct ata_port_info *ppi[] = { &pi, NULL };
 	struct ata_host *host;
 	u32 genctl, val;
 	u8 pmr;
@@ -335,7 +335,7 @@ static int sis_init_one (struct pci_dev 
 		break;
 	}
 
-	rc = ata_pci_prepare_native_host(pdev, ppi, 2, &host);
+	rc = ata_pci_prepare_native_host(pdev, ppi, &host);
 	if (rc)
 		return rc;
 
diff -puN drivers/ata/sata_uli.c~libata-clean-up-sff-init-mess drivers/ata/sata_uli.c
--- a/drivers/ata/sata_uli.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/sata_uli.c
@@ -125,7 +125,7 @@ static const struct ata_port_operations 
 	.port_start		= ata_port_start,
 };
 
-static struct ata_port_info uli_port_info = {
+static const struct ata_port_info uli_port_info = {
 	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 			  ATA_FLAG_IGN_SIMPLEX,
 	.pio_mask       = 0x1f,		/* pio0-4 */
@@ -201,19 +201,33 @@ static int uli_init_one (struct pci_dev 
 	n_ports = 2;
 	if (board_idx == uli_5287)
 		n_ports = 4;
-	rc = ata_pci_prepare_native_host(pdev, ppi, n_ports, &host);
-	if (rc)
-		return rc;
+
+	/* allocate the host */
+	host = ata_host_alloc_pinfo(&pdev->dev, ppi, n_ports);
+	if (!host)
+		return -ENOMEM;
 
 	hpriv = devm_kzalloc(&pdev->dev, sizeof(*hpriv), GFP_KERNEL);
 	if (!hpriv)
 		return -ENOMEM;
 	host->private_data = hpriv;
 
+	/* the first two ports are standard SFF */
+	rc = ata_pci_init_native_host(host);
+	if (rc)
+		return rc;
+
+	rc = ata_pci_init_bmdma(host);
+	if (rc)
+		return rc;
+
 	iomap = host->iomap;
 
 	switch (board_idx) {
 	case uli_5287:
+		/* If there are four, the last two live right after
+		 * the standard SFF ports.
+		 */
 		hpriv->scr_cfg_addr[0] = ULI5287_BASE;
 		hpriv->scr_cfg_addr[1] = ULI5287_BASE + ULI5287_OFFS;
 
diff -puN drivers/ata/sata_via.c~libata-clean-up-sff-init-mess drivers/ata/sata_via.c
--- a/drivers/ata/sata_via.c~libata-clean-up-sff-init-mess
+++ a/drivers/ata/sata_via.c
@@ -407,7 +407,7 @@ static int vt6420_prepare_host(struct pc
 	struct ata_host *host;
 	int rc;
 
-	rc = ata_pci_prepare_native_host(pdev, ppi, 2, &host);
+	rc = ata_pci_prepare_native_host(pdev, ppi, &host);
 	if (rc)
 		return rc;
 	*r_host = host;
diff -puN drivers/ata/sis.h~libata-clean-up-sff-init-mess drivers/ata/sis.h
--- a/drivers/ata/sis.h~libata-clean-up-sff-init-mess
+++ a/drivers/ata/sis.h
@@ -2,4 +2,4 @@
 struct ata_port_info;
 
 /* pata_sis.c */
-extern struct ata_port_info sis_info133;
+extern const struct ata_port_info sis_info133;
diff -puN include/linux/libata.h~libata-clean-up-sff-init-mess include/linux/libata.h
--- a/include/linux/libata.h~libata-clean-up-sff-init-mess
+++ a/include/linux/libata.h
@@ -254,10 +254,6 @@ enum {
 	ATA_DMA_PAD_SZ		= 4,
 	ATA_DMA_PAD_BUF_SZ	= ATA_DMA_PAD_SZ * ATA_MAX_QUEUE,
 
-	/* masks for port functions */
-	ATA_PORT_PRIMARY	= (1 << 0),
-	ATA_PORT_SECONDARY	= (1 << 1),
-
 	/* ering size */
 	ATA_ERING_SIZE		= 32,
 
@@ -693,8 +689,8 @@ extern void ata_std_postreset(struct ata
 extern void ata_port_disable(struct ata_port *);
 extern void ata_std_ports(struct ata_ioports *ioaddr);
 #ifdef CONFIG_PCI
-extern int ata_pci_init_one (struct pci_dev *pdev, struct ata_port_info **port_info,
-			     unsigned int n_ports);
+extern int ata_pci_init_one (struct pci_dev *pdev,
+			     const struct ata_port_info * const * ppi);
 extern void ata_pci_remove_one (struct pci_dev *pdev);
 #ifdef CONFIG_PM
 extern void ata_pci_device_do_suspend(struct pci_dev *pdev, pm_message_t mesg);
@@ -861,11 +857,11 @@ struct pci_bits {
 	unsigned long		val;
 };
 
-extern int ata_pci_init_native_host(struct ata_host *host,
-				    unsigned int port_mask);
+extern int ata_pci_init_native_host(struct ata_host *host);
+extern int ata_pci_init_bmdma(struct ata_host *host);
 extern int ata_pci_prepare_native_host(struct pci_dev *pdev,
 				const struct ata_port_info * const * ppi,
-				int n_ports, struct ata_host **r_host);
+				struct ata_host **r_host);
 extern int pci_test_config_bits(struct pci_dev *pdev, const struct pci_bits *bits);
 extern unsigned long ata_pci_default_filter(struct ata_device *, unsigned long);
 #endif /* CONFIG_PCI */
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
introduce-config_has_dma.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
git-dvb.patch
git-libata-all.patch
libata-clean-up-sff-init-mess.patch
ahci-crash-fix.patch
optional-led-trigger-for-libata.patch
drivers-ata-remove-the-wildcard-from-sata_nv-driver.patch
add-the-combined-mode-for-ati-sb700.patch
add-the-ati-sb700-sata-controller-device-id-to-ahci-pci-table.patch
libata-add-support-for-ata_16-on-atapi.patch
pata_scc-fix-compilation.patch
git-scsi-misc.patch
