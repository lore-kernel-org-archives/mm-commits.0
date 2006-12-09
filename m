From: akpm@osdl.org
Subject: + fix-numerous-kcalloc-calls-convert-to-kzalloc.patch added to -mm tree
Date: Sat, 09 Dec 2006 14:44:10 -0800
Message-ID: <200612092244.kB9MiADq006351@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56361 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758890AbWLIWo6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 9 Dec 2006 17:44:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, James.Bottomley@steeleye.com, alan@lxorguk.ukuu.org.uk, ambx1@neo.rr.com, greg@kroah.com, jeff@garzik.org, linux@dominikbrodowski.net, mark.fasheh@oracle.com, neilb@suse.de, trond.myklebust@fys.uio.no


The patch titled
     Fix numerous kcalloc() calls, convert to kzalloc()
has been added to the -mm tree.  Its filename is
     fix-numerous-kcalloc-calls-convert-to-kzalloc.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix numerous kcalloc() calls, convert to kzalloc()
From: "Robert P. J. Day" <rpjday@mindspring.com>

All kcalloc() calls of the form "kcalloc(1,...)" are converted to the
equivalent kzalloc() calls, and a few kcalloc() calls with the incorrect
ordering of the first two arguments are fixed.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Greg KH <greg@kroah.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/pdc_adma.c              |    4 ++--
 drivers/macintosh/smu.c             |    2 +-
 drivers/mtd/rfd_ftl.c               |    2 +-
 drivers/net/phy/phy_device.c        |    2 +-
 drivers/net/skge.c                  |    2 +-
 drivers/pcmcia/at91_cf.c            |    2 +-
 drivers/pcmcia/omap_cf.c            |    2 +-
 drivers/pnp/isapnp/core.c           |   22 +++++++++++-----------
 drivers/pnp/pnpacpi/core.c          |    6 +++---
 drivers/pnp/pnpacpi/rsparser.c      |   22 +++++++++++-----------
 drivers/pnp/pnpbios/core.c          |   14 +++++++-------
 drivers/pnp/pnpbios/proc.c          |    8 ++++----
 drivers/pnp/pnpbios/rsparser.c      |   16 ++++++++--------
 drivers/scsi/sym53c8xx_2/sym_hipd.c |    2 +-
 drivers/usb/gadget/at91_udc.c       |    2 +-
 drivers/usb/misc/uss720.c           |    2 +-
 drivers/usb/net/rndis_host.c        |    2 +-
 fs/ocfs2/alloc.c                    |    2 +-
 fs/ocfs2/cluster/heartbeat.c        |    4 ++--
 fs/ocfs2/cluster/nodemanager.c      |    6 +++---
 fs/ocfs2/cluster/tcp.c              |   10 +++++-----
 fs/ocfs2/dlm/dlmdomain.c            |    4 ++--
 fs/ocfs2/dlm/dlmlock.c              |    4 ++--
 fs/ocfs2/dlm/dlmmaster.c            |    2 +-
 fs/ocfs2/dlm/dlmrecovery.c          |    6 +++---
 fs/ocfs2/localalloc.c               |    2 +-
 fs/ocfs2/slot_map.c                 |    2 +-
 fs/ocfs2/suballoc.c                 |    6 +++---
 fs/ocfs2/super.c                    |    6 +++---
 fs/ocfs2/vote.c                     |    4 ++--
 include/linux/gameport.h            |    2 +-
 kernel/relay.c                      |    4 ++--
 net/sunrpc/svc.c                    |    2 +-
 sound/pci/hda/patch_realtek.c       |    4 ++--
 34 files changed, 91 insertions(+), 91 deletions(-)

diff -puN drivers/ata/pdc_adma.c~fix-numerous-kcalloc-calls-convert-to-kzalloc drivers/ata/pdc_adma.c
--- a/drivers/ata/pdc_adma.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/drivers/ata/pdc_adma.c
@@ -551,7 +551,7 @@ static int adma_port_start(struct ata_po
 		return rc;
 	adma_enter_reg_mode(ap);
 	rc = -ENOMEM;
-	pp = kcalloc(1, sizeof(*pp), GFP_KERNEL);
+	pp = kzalloc(sizeof(*pp), GFP_KERNEL);
 	if (!pp)
 		goto err_out;
 	pp->pkt = dma_alloc_coherent(dev, ADMA_PKT_BYTES, &pp->pkt_dma,
@@ -672,7 +672,7 @@ static int adma_ata_init_one(struct pci_
 	if (rc)
 		goto err_out_iounmap;
 
-	probe_ent = kcalloc(1, sizeof(*probe_ent), GFP_KERNEL);
+	probe_ent = kzalloc(sizeof(*probe_ent), GFP_KERNEL);
 	if (probe_ent == NULL) {
 		rc = -ENOMEM;
 		goto err_out_iounmap;
diff -puN drivers/macintosh/smu.c~fix-numerous-kcalloc-calls-convert-to-kzalloc drivers/macintosh/smu.c
--- a/drivers/macintosh/smu.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/drivers/macintosh/smu.c
@@ -945,7 +945,7 @@ static struct smu_sdbp_header *smu_creat
 	 */
 	tlen = sizeof(struct property) + len + 18;
 
-	prop = kcalloc(tlen, 1, GFP_KERNEL);
+	prop = kzalloc(tlen, GFP_KERNEL);
 	if (prop == NULL)
 		return NULL;
 	hdr = (struct smu_sdbp_header *)(prop + 1);
diff -puN drivers/mtd/rfd_ftl.c~fix-numerous-kcalloc-calls-convert-to-kzalloc drivers/mtd/rfd_ftl.c
--- a/drivers/mtd/rfd_ftl.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/drivers/mtd/rfd_ftl.c
@@ -768,7 +768,7 @@ static void rfd_ftl_add_mtd(struct mtd_b
 	if (mtd->type != MTD_NORFLASH)
 		return;
 
-	part = kcalloc(1, sizeof(struct partition), GFP_KERNEL);
+	part = kzalloc(sizeof(struct partition), GFP_KERNEL);
 	if (!part)
 		return;
 
diff -puN drivers/net/phy/phy_device.c~fix-numerous-kcalloc-calls-convert-to-kzalloc drivers/net/phy/phy_device.c
--- a/drivers/net/phy/phy_device.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/drivers/net/phy/phy_device.c
@@ -50,7 +50,7 @@ struct phy_device* phy_device_create(str
 	struct phy_device *dev;
 	/* We allocate the device, and initialize the
 	 * default values */
-	dev = kcalloc(1, sizeof(*dev), GFP_KERNEL);
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 
 	if (NULL == dev)
 		return (struct phy_device*) PTR_ERR((void*)-ENOMEM);
diff -puN drivers/net/skge.c~fix-numerous-kcalloc-calls-convert-to-kzalloc drivers/net/skge.c
--- a/drivers/net/skge.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/drivers/net/skge.c
@@ -749,7 +749,7 @@ static int skge_ring_alloc(struct skge_r
 	struct skge_element *e;
 	int i;
 
-	ring->start = kcalloc(sizeof(*e), ring->count, GFP_KERNEL);
+	ring->start = kcalloc(ring->count, sizeof(*e), GFP_KERNEL);
 	if (!ring->start)
 		return -ENOMEM;
 
diff -puN drivers/pcmcia/at91_cf.c~fix-numerous-kcalloc-calls-convert-to-kzalloc drivers/pcmcia/at91_cf.c
--- a/drivers/pcmcia/at91_cf.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/drivers/pcmcia/at91_cf.c
@@ -230,7 +230,7 @@ static int __init at91_cf_probe(struct p
 	if (!io)
 		return -ENODEV;
 
-	cf = kcalloc(1, sizeof *cf, GFP_KERNEL);
+	cf = kzalloc(sizeof *cf, GFP_KERNEL);
 	if (!cf)
 		return -ENOMEM;
 
diff -puN drivers/pcmcia/omap_cf.c~fix-numerous-kcalloc-calls-convert-to-kzalloc drivers/pcmcia/omap_cf.c
--- a/drivers/pcmcia/omap_cf.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/drivers/pcmcia/omap_cf.c
@@ -220,7 +220,7 @@ static int __devinit omap_cf_probe(struc
 	if (irq < 0)
 		return -EINVAL;
 
-	cf = kcalloc(1, sizeof *cf, GFP_KERNEL);
+	cf = kzalloc(sizeof *cf, GFP_KERNEL);
 	if (!cf)
 		return -ENOMEM;
 	init_timer(&cf->timer);
diff -puN drivers/pnp/isapnp/core.c~fix-numerous-kcalloc-calls-convert-to-kzalloc drivers/pnp/isapnp/core.c
--- a/drivers/pnp/isapnp/core.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/drivers/pnp/isapnp/core.c
@@ -395,7 +395,7 @@ static void isapnp_parse_id(struct pnp_d
 	struct pnp_id * id;
 	if (!dev)
 		return;
-	id = kcalloc(1, sizeof(struct pnp_id), GFP_KERNEL);
+	id = kzalloc(sizeof(struct pnp_id), GFP_KERNEL);
 	if (!id)
 		return;
 	sprintf(id->id, "%c%c%c%x%x%x%x",
@@ -419,7 +419,7 @@ static struct pnp_dev * __init isapnp_pa
 	struct pnp_dev *dev;
 
 	isapnp_peek(tmp, size);
-	dev = kcalloc(1, sizeof(struct pnp_dev), GFP_KERNEL);
+	dev = kzalloc(sizeof(struct pnp_dev), GFP_KERNEL);
 	if (!dev)
 		return NULL;
 	dev->number = number;
@@ -450,7 +450,7 @@ static void __init isapnp_parse_irq_reso
 	unsigned long bits;
 
 	isapnp_peek(tmp, size);
-	irq = kcalloc(1, sizeof(struct pnp_irq), GFP_KERNEL);
+	irq = kzalloc(sizeof(struct pnp_irq), GFP_KERNEL);
 	if (!irq)
 		return;
 	bits = (tmp[1] << 8) | tmp[0];
@@ -474,7 +474,7 @@ static void __init isapnp_parse_dma_reso
 	struct pnp_dma *dma;
 
 	isapnp_peek(tmp, size);
-	dma = kcalloc(1, sizeof(struct pnp_dma), GFP_KERNEL);
+	dma = kzalloc(sizeof(struct pnp_dma), GFP_KERNEL);
 	if (!dma)
 		return;
 	dma->map = tmp[0];
@@ -494,7 +494,7 @@ static void __init isapnp_parse_port_res
 	struct pnp_port *port;
 
 	isapnp_peek(tmp, size);
-	port = kcalloc(1, sizeof(struct pnp_port), GFP_KERNEL);
+	port = kzalloc(sizeof(struct pnp_port), GFP_KERNEL);
 	if (!port)
 		return;
 	port->min = (tmp[2] << 8) | tmp[1];
@@ -517,7 +517,7 @@ static void __init isapnp_parse_fixed_po
 	struct pnp_port *port;
 
 	isapnp_peek(tmp, size);
-	port = kcalloc(1, sizeof(struct pnp_port), GFP_KERNEL);
+	port = kzalloc(sizeof(struct pnp_port), GFP_KERNEL);
 	if (!port)
 		return;
 	port->min = port->max = (tmp[1] << 8) | tmp[0];
@@ -539,7 +539,7 @@ static void __init isapnp_parse_mem_reso
 	struct pnp_mem *mem;
 
 	isapnp_peek(tmp, size);
-	mem = kcalloc(1, sizeof(struct pnp_mem), GFP_KERNEL);
+	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
 	if (!mem)
 		return;
 	mem->min = ((tmp[2] << 8) | tmp[1]) << 8;
@@ -562,7 +562,7 @@ static void __init isapnp_parse_mem32_re
 	struct pnp_mem *mem;
 
 	isapnp_peek(tmp, size);
-	mem = kcalloc(1, sizeof(struct pnp_mem), GFP_KERNEL);
+	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
 	if (!mem)
 		return;
 	mem->min = (tmp[4] << 24) | (tmp[3] << 16) | (tmp[2] << 8) | tmp[1];
@@ -584,7 +584,7 @@ static void __init isapnp_parse_fixed_me
 	struct pnp_mem *mem;
 
 	isapnp_peek(tmp, size);
-	mem = kcalloc(1, sizeof(struct pnp_mem), GFP_KERNEL);
+	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
 	if (!mem)
 		return;
 	mem->min = mem->max = (tmp[4] << 24) | (tmp[3] << 16) | (tmp[2] << 8) | tmp[1];
@@ -829,7 +829,7 @@ static unsigned char __init isapnp_check
 
 static void isapnp_parse_card_id(struct pnp_card * card, unsigned short vendor, unsigned short device)
 {
-	struct pnp_id * id = kcalloc(1, sizeof(struct pnp_id), GFP_KERNEL);
+	struct pnp_id * id = kzalloc(sizeof(struct pnp_id), GFP_KERNEL);
 	if (!id)
 		return;
 	sprintf(id->id, "%c%c%c%x%x%x%x",
@@ -865,7 +865,7 @@ static int __init isapnp_build_device_li
 			header[4], header[5], header[6], header[7], header[8]);
 		printk(KERN_DEBUG "checksum = 0x%x\n", checksum);
 #endif
-		if ((card = kcalloc(1, sizeof(struct pnp_card), GFP_KERNEL)) == NULL)
+		if ((card = kzalloc(sizeof(struct pnp_card), GFP_KERNEL)) == NULL)
 			continue;
 
 		card->number = csn;
diff -puN drivers/pnp/pnpacpi/core.c~fix-numerous-kcalloc-calls-convert-to-kzalloc drivers/pnp/pnpacpi/core.c
--- a/drivers/pnp/pnpacpi/core.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/drivers/pnp/pnpacpi/core.c
@@ -139,7 +139,7 @@ static int __init pnpacpi_add_device(str
 		return 0;
 
 	pnp_dbg("ACPI device : hid %s", acpi_device_hid(device));
-	dev =  kcalloc(1, sizeof(struct pnp_dev), GFP_KERNEL);
+	dev =  kzalloc(sizeof(struct pnp_dev), GFP_KERNEL);
 	if (!dev) {
 		pnp_err("Out of memory");
 		return -ENOMEM;
@@ -169,7 +169,7 @@ static int __init pnpacpi_add_device(str
 	dev->number = num;
 	
 	/* set the initial values for the PnP device */
-	dev_id = kcalloc(1, sizeof(struct pnp_id), GFP_KERNEL);
+	dev_id = kzalloc(sizeof(struct pnp_id), GFP_KERNEL);
 	if (!dev_id)
 		goto err;
 	pnpidacpi_to_pnpid(acpi_device_hid(device), dev_id->id);
@@ -201,7 +201,7 @@ static int __init pnpacpi_add_device(str
 		for (i = 0; i < cid_list->count; i++) {
 			if (!ispnpidacpi(cid_list->id[i].value))
 				continue;
-			dev_id = kcalloc(1, sizeof(struct pnp_id), GFP_KERNEL);
+			dev_id = kzalloc(sizeof(struct pnp_id), GFP_KERNEL);
 			if (!dev_id)
 				continue;
 
diff -puN drivers/pnp/pnpacpi/rsparser.c~fix-numerous-kcalloc-calls-convert-to-kzalloc drivers/pnp/pnpacpi/rsparser.c
--- a/drivers/pnp/pnpacpi/rsparser.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/drivers/pnp/pnpacpi/rsparser.c
@@ -298,7 +298,7 @@ static void pnpacpi_parse_dma_option(str
 
 	if (p->channel_count == 0)
 		return;
-	dma = kcalloc(1, sizeof(struct pnp_dma), GFP_KERNEL);
+	dma = kzalloc(sizeof(struct pnp_dma), GFP_KERNEL);
 	if (!dma)
 		return;
 
@@ -354,7 +354,7 @@ static void pnpacpi_parse_irq_option(str
 
 	if (p->interrupt_count == 0)
 		return;
-	irq = kcalloc(1, sizeof(struct pnp_irq), GFP_KERNEL);
+	irq = kzalloc(sizeof(struct pnp_irq), GFP_KERNEL);
 	if (!irq)
 		return;
 
@@ -375,7 +375,7 @@ static void pnpacpi_parse_ext_irq_option
 
 	if (p->interrupt_count == 0)
 		return;
-	irq = kcalloc(1, sizeof(struct pnp_irq), GFP_KERNEL);
+	irq = kzalloc(sizeof(struct pnp_irq), GFP_KERNEL);
 	if (!irq)
 		return;
 
@@ -396,7 +396,7 @@ pnpacpi_parse_port_option(struct pnp_opt
 
 	if (io->address_length == 0)
 		return;
-	port = kcalloc(1, sizeof(struct pnp_port), GFP_KERNEL);
+	port = kzalloc(sizeof(struct pnp_port), GFP_KERNEL);
 	if (!port)
 		return;
 	port->min = io->minimum;
@@ -417,7 +417,7 @@ pnpacpi_parse_fixed_port_option(struct p
 
 	if (io->address_length == 0)
 		return;
-	port = kcalloc(1, sizeof(struct pnp_port), GFP_KERNEL);
+	port = kzalloc(sizeof(struct pnp_port), GFP_KERNEL);
 	if (!port)
 		return;
 	port->min = port->max = io->address;
@@ -436,7 +436,7 @@ pnpacpi_parse_mem24_option(struct pnp_op
 
 	if (p->address_length == 0)
 		return;
-	mem = kcalloc(1, sizeof(struct pnp_mem), GFP_KERNEL);
+	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
 	if (!mem)
 		return;
 	mem->min = p->minimum;
@@ -459,7 +459,7 @@ pnpacpi_parse_mem32_option(struct pnp_op
 
 	if (p->address_length == 0)
 		return;
-	mem = kcalloc(1, sizeof(struct pnp_mem), GFP_KERNEL);
+	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
 	if (!mem)
 		return;
 	mem->min = p->minimum;
@@ -482,7 +482,7 @@ pnpacpi_parse_fixed_mem32_option(struct 
 
 	if (p->address_length == 0)
 		return;
-	mem = kcalloc(1, sizeof(struct pnp_mem), GFP_KERNEL);
+	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
 	if (!mem)
 		return;
 	mem->min = mem->max = p->address;
@@ -514,7 +514,7 @@ pnpacpi_parse_address_option(struct pnp_
 		return;
 
 	if (p->resource_type == ACPI_MEMORY_RANGE) {
-		mem = kcalloc(1, sizeof(struct pnp_mem), GFP_KERNEL);
+		mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
 		if (!mem)
 			return;
 		mem->min = mem->max = p->minimum;
@@ -524,7 +524,7 @@ pnpacpi_parse_address_option(struct pnp_
 		    ACPI_READ_WRITE_MEMORY) ? IORESOURCE_MEM_WRITEABLE : 0;
 		pnp_register_mem_resource(option, mem);
 	} else if (p->resource_type == ACPI_IO_RANGE) {
-		port = kcalloc(1, sizeof(struct pnp_port), GFP_KERNEL);
+		port = kzalloc(sizeof(struct pnp_port), GFP_KERNEL);
 		if (!port)
 			return;
 		port->min = port->max = p->minimum;
@@ -721,7 +721,7 @@ int pnpacpi_build_resource_template(acpi
 	if (!res_cnt)
 		return -EINVAL;
 	buffer->length = sizeof(struct acpi_resource) * (res_cnt + 1) + 1;
-	buffer->pointer = kcalloc(1, buffer->length - 1, GFP_KERNEL);
+	buffer->pointer = kzalloc(buffer->length - 1, GFP_KERNEL);
 	if (!buffer->pointer)
 		return -ENOMEM;
 	pnp_dbg("Res cnt %d", res_cnt);
diff -puN drivers/pnp/pnpbios/core.c~fix-numerous-kcalloc-calls-convert-to-kzalloc drivers/pnp/pnpbios/core.c
--- a/drivers/pnp/pnpbios/core.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/drivers/pnp/pnpbios/core.c
@@ -112,7 +112,7 @@ static int pnp_dock_event(int dock, stru
 	if (!(envp = (char **) kcalloc (20, sizeof (char *), GFP_KERNEL))) {
 		return -ENOMEM;
 	}
-	if (!(buf = kcalloc (1, 256, GFP_KERNEL))) {
+	if (!(buf = kzalloc(256, GFP_KERNEL))) {
 		kfree (envp);
 		return -ENOMEM;
 	}
@@ -220,7 +220,7 @@ static int pnpbios_get_resources(struct 
 	if(!pnpbios_is_dynamic(dev))
 		return -EPERM;
 
-	node = kcalloc(1, node_info.max_node_size, GFP_KERNEL);
+	node = kzalloc(node_info.max_node_size, GFP_KERNEL);
 	if (!node)
 		return -1;
 	if (pnp_bios_get_dev_node(&nodenum, (char )PNPMODE_DYNAMIC, node)) {
@@ -243,7 +243,7 @@ static int pnpbios_set_resources(struct 
 	if (!pnpbios_is_dynamic(dev))
 		return -EPERM;
 
-	node = kcalloc(1, node_info.max_node_size, GFP_KERNEL);
+	node = kzalloc(node_info.max_node_size, GFP_KERNEL);
 	if (!node)
 		return -1;
 	if (pnp_bios_get_dev_node(&nodenum, (char )PNPMODE_DYNAMIC, node)) {
@@ -294,7 +294,7 @@ static int pnpbios_disable_resources(str
 	if(dev->flags & PNPBIOS_NO_DISABLE || !pnpbios_is_dynamic(dev))
 		return -EPERM;
 
-	node = kcalloc(1, node_info.max_node_size, GFP_KERNEL);
+	node = kzalloc(node_info.max_node_size, GFP_KERNEL);
 	if (!node)
 		return -ENOMEM;
 
@@ -336,7 +336,7 @@ static int insert_device(struct pnp_dev 
 	}
 
 	/* set the initial values for the PnP device */
-	dev_id = kcalloc(1, sizeof(struct pnp_id), GFP_KERNEL);
+	dev_id = kzalloc(sizeof(struct pnp_id), GFP_KERNEL);
 	if (!dev_id)
 		return -1;
 	pnpid32_to_pnpid(node->eisa_id,id);
@@ -374,7 +374,7 @@ static void __init build_devlist(void)
 	struct pnp_bios_node *node;
 	struct pnp_dev *dev;
 
-	node = kcalloc(1, node_info.max_node_size, GFP_KERNEL);
+	node = kzalloc(node_info.max_node_size, GFP_KERNEL);
 	if (!node)
 		return;
 
@@ -391,7 +391,7 @@ static void __init build_devlist(void)
 				break;
 		}
 		nodes_got++;
-		dev =  kcalloc(1, sizeof (struct pnp_dev), GFP_KERNEL);
+		dev =  kzalloc(sizeof (struct pnp_dev), GFP_KERNEL);
 		if (!dev)
 			break;
 		if(insert_device(dev,node)<0)
diff -puN drivers/pnp/pnpbios/proc.c~fix-numerous-kcalloc-calls-convert-to-kzalloc drivers/pnp/pnpbios/proc.c
--- a/drivers/pnp/pnpbios/proc.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/drivers/pnp/pnpbios/proc.c
@@ -87,7 +87,7 @@ static int proc_read_escd(char *buf, cha
 		return -EFBIG;
 	}
 
-	tmpbuf = kcalloc(1, escd.escd_size, GFP_KERNEL);
+	tmpbuf = kzalloc(escd.escd_size, GFP_KERNEL);
 	if (!tmpbuf) return -ENOMEM;
 
 	if (pnp_bios_read_escd(tmpbuf, escd.nv_storage_base)) {
@@ -133,7 +133,7 @@ static int proc_read_devices(char *buf, 
 	if (pos >= 0xff)
 		return 0;
 
-	node = kcalloc(1, node_info.max_node_size, GFP_KERNEL);
+	node = kzalloc(node_info.max_node_size, GFP_KERNEL);
 	if (!node) return -ENOMEM;
 
 	for (nodenum=pos; nodenum<0xff; ) {
@@ -168,7 +168,7 @@ static int proc_read_node(char *buf, cha
 	u8 nodenum = (long)data;
 	int len;
 
-	node = kcalloc(1, node_info.max_node_size, GFP_KERNEL);
+	node = kzalloc(node_info.max_node_size, GFP_KERNEL);
 	if (!node) return -ENOMEM;
 	if (pnp_bios_get_dev_node(&nodenum, boot, node)) {
 		kfree(node);
@@ -188,7 +188,7 @@ static int proc_write_node(struct file *
 	u8 nodenum = (long)data;
 	int ret = count;
 
-	node = kcalloc(1, node_info.max_node_size, GFP_KERNEL);
+	node = kzalloc(node_info.max_node_size, GFP_KERNEL);
 	if (!node)
 		return -ENOMEM;
 	if (pnp_bios_get_dev_node(&nodenum, boot, node)) {
diff -puN drivers/pnp/pnpbios/rsparser.c~fix-numerous-kcalloc-calls-convert-to-kzalloc drivers/pnp/pnpbios/rsparser.c
--- a/drivers/pnp/pnpbios/rsparser.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/drivers/pnp/pnpbios/rsparser.c
@@ -248,7 +248,7 @@ static void
 pnpbios_parse_mem_option(unsigned char *p, int size, struct pnp_option *option)
 {
 	struct pnp_mem * mem;
-	mem = kcalloc(1, sizeof(struct pnp_mem), GFP_KERNEL);
+	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
 	if (!mem)
 		return;
 	mem->min = ((p[5] << 8) | p[4]) << 8;
@@ -264,7 +264,7 @@ static void
 pnpbios_parse_mem32_option(unsigned char *p, int size, struct pnp_option *option)
 {
 	struct pnp_mem * mem;
-	mem = kcalloc(1, sizeof(struct pnp_mem), GFP_KERNEL);
+	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
 	if (!mem)
 		return;
 	mem->min = (p[7] << 24) | (p[6] << 16) | (p[5] << 8) | p[4];
@@ -280,7 +280,7 @@ static void
 pnpbios_parse_fixed_mem32_option(unsigned char *p, int size, struct pnp_option *option)
 {
 	struct pnp_mem * mem;
-	mem = kcalloc(1, sizeof(struct pnp_mem), GFP_KERNEL);
+	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
 	if (!mem)
 		return;
 	mem->min = mem->max = (p[7] << 24) | (p[6] << 16) | (p[5] << 8) | p[4];
@@ -297,7 +297,7 @@ pnpbios_parse_irq_option(unsigned char *
 	struct pnp_irq * irq;
 	unsigned long bits;
 
-	irq = kcalloc(1, sizeof(struct pnp_irq), GFP_KERNEL);
+	irq = kzalloc(sizeof(struct pnp_irq), GFP_KERNEL);
 	if (!irq)
 		return;
 	bits = (p[2] << 8) | p[1];
@@ -314,7 +314,7 @@ static void
 pnpbios_parse_dma_option(unsigned char *p, int size, struct pnp_option *option)
 {
 	struct pnp_dma * dma;
-	dma = kcalloc(1, sizeof(struct pnp_dma), GFP_KERNEL);
+	dma = kzalloc(sizeof(struct pnp_dma), GFP_KERNEL);
 	if (!dma)
 		return;
 	dma->map = p[1];
@@ -327,7 +327,7 @@ static void
 pnpbios_parse_port_option(unsigned char *p, int size, struct pnp_option *option)
 {
 	struct pnp_port * port;
-	port = kcalloc(1, sizeof(struct pnp_port), GFP_KERNEL);
+	port = kzalloc(sizeof(struct pnp_port), GFP_KERNEL);
 	if (!port)
 		return;
 	port->min = (p[3] << 8) | p[2];
@@ -343,7 +343,7 @@ static void
 pnpbios_parse_fixed_port_option(unsigned char *p, int size, struct pnp_option *option)
 {
 	struct pnp_port * port;
-	port = kcalloc(1, sizeof(struct pnp_port), GFP_KERNEL);
+	port = kzalloc(sizeof(struct pnp_port), GFP_KERNEL);
 	if (!port)
 		return;
 	port->min = port->max = (p[2] << 8) | p[1];
@@ -527,7 +527,7 @@ pnpbios_parse_compatible_ids(unsigned ch
 		case SMALL_TAG_COMPATDEVID: /* compatible ID */
 			if (len != 4)
 				goto len_err;
-			dev_id =  kcalloc(1, sizeof (struct pnp_id), GFP_KERNEL);
+			dev_id =  kzalloc(sizeof (struct pnp_id), GFP_KERNEL);
 			if (!dev_id)
 				return NULL;
 			memset(dev_id, 0, sizeof(struct pnp_id));
diff -puN drivers/scsi/sym53c8xx_2/sym_hipd.c~fix-numerous-kcalloc-calls-convert-to-kzalloc drivers/scsi/sym53c8xx_2/sym_hipd.c
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -5545,7 +5545,7 @@ int sym_hcb_attach(struct Scsi_Host *sho
 	/*
 	 *  Allocate the array of lists of CCBs hashed by DSA.
 	 */
-	np->ccbh = kcalloc(sizeof(struct sym_ccb **), CCB_HASH_SIZE, GFP_KERNEL);
+	np->ccbh = kcalloc(CCB_HASH_SIZE, sizeof(struct sym_ccb **), GFP_KERNEL);
 	if (!np->ccbh)
 		goto attach_failed;
 
diff -puN drivers/usb/gadget/at91_udc.c~fix-numerous-kcalloc-calls-convert-to-kzalloc drivers/usb/gadget/at91_udc.c
--- a/drivers/usb/gadget/at91_udc.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/drivers/usb/gadget/at91_udc.c
@@ -598,7 +598,7 @@ at91_ep_alloc_request(struct usb_ep *_ep
 {
 	struct at91_request *req;
 
-	req = kcalloc(1, sizeof (struct at91_request), gfp_flags);
+	req = kzalloc(sizeof (struct at91_request), gfp_flags);
 	if (!req)
 		return NULL;
 
diff -puN drivers/usb/misc/uss720.c~fix-numerous-kcalloc-calls-convert-to-kzalloc drivers/usb/misc/uss720.c
--- a/drivers/usb/misc/uss720.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/drivers/usb/misc/uss720.c
@@ -705,7 +705,7 @@ static int uss720_probe(struct usb_inter
 	/*
 	 * Allocate parport interface 
 	 */
-	if (!(priv = kcalloc(sizeof(struct parport_uss720_private), 1, GFP_KERNEL))) {
+	if (!(priv = kzalloc(sizeof(struct parport_uss720_private), GFP_KERNEL))) {
 		usb_put_dev(usbdev);
 		return -ENOMEM;
 	}
diff -puN drivers/usb/net/rndis_host.c~fix-numerous-kcalloc-calls-convert-to-kzalloc drivers/usb/net/rndis_host.c
--- a/drivers/usb/net/rndis_host.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/drivers/usb/net/rndis_host.c
@@ -469,7 +469,7 @@ static void rndis_unbind(struct usbnet *
 	struct rndis_halt	*halt;
 
 	/* try to clear any rndis state/activity (no i/o from stack!) */
-	halt = kcalloc(1, sizeof *halt, GFP_KERNEL);
+	halt = kzalloc(sizeof *halt, GFP_KERNEL);
 	if (halt) {
 		halt->msg_type = RNDIS_MSG_HALT;
 		halt->msg_len = ccpu2(sizeof *halt);
diff -puN fs/ocfs2/alloc.c~fix-numerous-kcalloc-calls-convert-to-kzalloc fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/fs/ocfs2/alloc.c
@@ -1959,7 +1959,7 @@ int ocfs2_prepare_truncate(struct ocfs2_
 		goto bail;
 	}
 
-	*tc = kcalloc(1, sizeof(struct ocfs2_truncate_context), GFP_KERNEL);
+	*tc = kzalloc(sizeof(struct ocfs2_truncate_context), GFP_KERNEL);
 	if (!(*tc)) {
 		status = -ENOMEM;
 		mlog_errno(status);
diff -puN fs/ocfs2/cluster/heartbeat.c~fix-numerous-kcalloc-calls-convert-to-kzalloc fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -1553,7 +1553,7 @@ static struct config_item *o2hb_heartbea
 	struct o2hb_region *reg = NULL;
 	struct config_item *ret = NULL;
 
-	reg = kcalloc(1, sizeof(struct o2hb_region), GFP_KERNEL);
+	reg = kzalloc(sizeof(struct o2hb_region), GFP_KERNEL);
 	if (reg == NULL)
 		goto out; /* ENOMEM */
 
@@ -1679,7 +1679,7 @@ struct config_group *o2hb_alloc_hb_set(v
 	struct o2hb_heartbeat_group *hs = NULL;
 	struct config_group *ret = NULL;
 
-	hs = kcalloc(1, sizeof(struct o2hb_heartbeat_group), GFP_KERNEL);
+	hs = kzalloc(sizeof(struct o2hb_heartbeat_group), GFP_KERNEL);
 	if (hs == NULL)
 		goto out;
 
diff -puN fs/ocfs2/cluster/nodemanager.c~fix-numerous-kcalloc-calls-convert-to-kzalloc fs/ocfs2/cluster/nodemanager.c
--- a/fs/ocfs2/cluster/nodemanager.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/fs/ocfs2/cluster/nodemanager.c
@@ -714,7 +714,7 @@ static struct config_item *o2nm_node_gro
 	if (strlen(name) > O2NM_MAX_NAME_LEN)
 		goto out; /* ENAMETOOLONG */
 
-	node = kcalloc(1, sizeof(struct o2nm_node), GFP_KERNEL);
+	node = kzalloc(sizeof(struct o2nm_node), GFP_KERNEL);
 	if (node == NULL)
 		goto out; /* ENOMEM */
 
@@ -825,8 +825,8 @@ static struct config_group *o2nm_cluster
 	if (o2nm_single_cluster)
 		goto out; /* ENOSPC */
 
-	cluster = kcalloc(1, sizeof(struct o2nm_cluster), GFP_KERNEL);
-	ns = kcalloc(1, sizeof(struct o2nm_node_group), GFP_KERNEL);
+	cluster = kzalloc(sizeof(struct o2nm_cluster), GFP_KERNEL);
+	ns = kzalloc(sizeof(struct o2nm_node_group), GFP_KERNEL);
 	defs = kcalloc(3, sizeof(struct config_group *), GFP_KERNEL);
 	o2hb_group = o2hb_alloc_hb_set();
 	if (cluster == NULL || ns == NULL || o2hb_group == NULL || defs == NULL)
diff -puN fs/ocfs2/cluster/tcp.c~fix-numerous-kcalloc-calls-convert-to-kzalloc fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/fs/ocfs2/cluster/tcp.c
@@ -324,7 +324,7 @@ static struct o2net_sock_container *sc_a
 	struct page *page = NULL;
 
 	page = alloc_page(GFP_NOFS);
-	sc = kcalloc(1, sizeof(*sc), GFP_NOFS);
+	sc = kzalloc(sizeof(*sc), GFP_NOFS);
 	if (sc == NULL || page == NULL)
 		goto out;
 
@@ -714,7 +714,7 @@ int o2net_register_handler(u32 msg_type,
 		goto out;
 	}
 
-       	nmh = kcalloc(1, sizeof(struct o2net_msg_handler), GFP_NOFS);
+       	nmh = kzalloc(sizeof(struct o2net_msg_handler), GFP_NOFS);
 	if (nmh == NULL) {
 		ret = -ENOMEM;
 		goto out;
@@ -1918,9 +1918,9 @@ int o2net_init(void)
 
 	o2quo_init();
 
-	o2net_hand = kcalloc(1, sizeof(struct o2net_handshake), GFP_KERNEL);
-	o2net_keep_req = kcalloc(1, sizeof(struct o2net_msg), GFP_KERNEL);
-	o2net_keep_resp = kcalloc(1, sizeof(struct o2net_msg), GFP_KERNEL);
+	o2net_hand = kzalloc(sizeof(struct o2net_handshake), GFP_KERNEL);
+	o2net_keep_req = kzalloc(sizeof(struct o2net_msg), GFP_KERNEL);
+	o2net_keep_resp = kzalloc(sizeof(struct o2net_msg), GFP_KERNEL);
 	if (!o2net_hand || !o2net_keep_req || !o2net_keep_resp) {
 		kfree(o2net_hand);
 		kfree(o2net_keep_req);
diff -puN fs/ocfs2/dlm/dlmdomain.c~fix-numerous-kcalloc-calls-convert-to-kzalloc fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -970,7 +970,7 @@ static int dlm_try_to_join_domain(struct
 
 	mlog_entry("%p", dlm);
 
-	ctxt = kcalloc(1, sizeof(*ctxt), GFP_KERNEL);
+	ctxt = kzalloc(sizeof(*ctxt), GFP_KERNEL);
 	if (!ctxt) {
 		status = -ENOMEM;
 		mlog_errno(status);
@@ -1280,7 +1280,7 @@ static struct dlm_ctxt *dlm_alloc_ctxt(c
 	int i;
 	struct dlm_ctxt *dlm = NULL;
 
-	dlm = kcalloc(1, sizeof(*dlm), GFP_KERNEL);
+	dlm = kzalloc(sizeof(*dlm), GFP_KERNEL);
 	if (!dlm) {
 		mlog_errno(-ENOMEM);
 		goto leave;
diff -puN fs/ocfs2/dlm/dlmlock.c~fix-numerous-kcalloc-calls-convert-to-kzalloc fs/ocfs2/dlm/dlmlock.c
--- a/fs/ocfs2/dlm/dlmlock.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/fs/ocfs2/dlm/dlmlock.c
@@ -412,13 +412,13 @@ struct dlm_lock * dlm_new_lock(int type,
 	struct dlm_lock *lock;
 	int kernel_allocated = 0;
 
-	lock = kcalloc(1, sizeof(*lock), GFP_NOFS);
+	lock = kzalloc(sizeof(*lock), GFP_NOFS);
 	if (!lock)
 		return NULL;
 
 	if (!lksb) {
 		/* zero memory only if kernel-allocated */
-		lksb = kcalloc(1, sizeof(*lksb), GFP_NOFS);
+		lksb = kzalloc(sizeof(*lksb), GFP_NOFS);
 		if (!lksb) {
 			kfree(lock);
 			return NULL;
diff -puN fs/ocfs2/dlm/dlmmaster.c~fix-numerous-kcalloc-calls-convert-to-kzalloc fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -2067,7 +2067,7 @@ int dlm_dispatch_assert_master(struct dl
 			       int ignore_higher, u8 request_from, u32 flags)
 {
 	struct dlm_work_item *item;
-	item = kcalloc(1, sizeof(*item), GFP_NOFS);
+	item = kzalloc(sizeof(*item), GFP_NOFS);
 	if (!item)
 		return -ENOMEM;
 
diff -puN fs/ocfs2/dlm/dlmrecovery.c~fix-numerous-kcalloc-calls-convert-to-kzalloc fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -757,7 +757,7 @@ static int dlm_init_recovery_area(struct
 		}
 		BUG_ON(num == dead_node);
 
-		ndata = kcalloc(1, sizeof(*ndata), GFP_NOFS);
+		ndata = kzalloc(sizeof(*ndata), GFP_NOFS);
 		if (!ndata) {
 			dlm_destroy_recovery_area(dlm, dead_node);
 			return -ENOMEM;
@@ -842,7 +842,7 @@ int dlm_request_all_locks_handler(struct
 	}
 	BUG_ON(lr->dead_node != dlm->reco.dead_node);
 
-	item = kcalloc(1, sizeof(*item), GFP_NOFS);
+	item = kzalloc(sizeof(*item), GFP_NOFS);
 	if (!item) {
 		dlm_put(dlm);
 		return -ENOMEM;
@@ -1364,7 +1364,7 @@ int dlm_mig_lockres_handler(struct o2net
 
 	ret = -ENOMEM;
 	buf = kmalloc(be16_to_cpu(msg->data_len), GFP_NOFS);
-	item = kcalloc(1, sizeof(*item), GFP_NOFS);
+	item = kzalloc(sizeof(*item), GFP_NOFS);
 	if (!buf || !item)
 		goto leave;
 
diff -puN fs/ocfs2/localalloc.c~fix-numerous-kcalloc-calls-convert-to-kzalloc fs/ocfs2/localalloc.c
--- a/fs/ocfs2/localalloc.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/fs/ocfs2/localalloc.c
@@ -776,7 +776,7 @@ static int ocfs2_local_alloc_reserve_for
 {
 	int status;
 
-	*ac = kcalloc(1, sizeof(struct ocfs2_alloc_context), GFP_KERNEL);
+	*ac = kzalloc(sizeof(struct ocfs2_alloc_context), GFP_KERNEL);
 	if (!(*ac)) {
 		status = -ENOMEM;
 		mlog_errno(status);
diff -puN fs/ocfs2/slot_map.c~fix-numerous-kcalloc-calls-convert-to-kzalloc fs/ocfs2/slot_map.c
--- a/fs/ocfs2/slot_map.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/fs/ocfs2/slot_map.c
@@ -175,7 +175,7 @@ int ocfs2_init_slot_info(struct ocfs2_su
 	struct buffer_head *bh = NULL;
 	struct ocfs2_slot_info *si;
 
-	si = kcalloc(1, sizeof(struct ocfs2_slot_info), GFP_KERNEL);
+	si = kzalloc(sizeof(struct ocfs2_slot_info), GFP_KERNEL);
 	if (!si) {
 		status = -ENOMEM;
 		mlog_errno(status);
diff -puN fs/ocfs2/suballoc.c~fix-numerous-kcalloc-calls-convert-to-kzalloc fs/ocfs2/suballoc.c
--- a/fs/ocfs2/suballoc.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/fs/ocfs2/suballoc.c
@@ -488,7 +488,7 @@ int ocfs2_reserve_new_metadata(struct oc
 	int status;
 	u32 slot;
 
-	*ac = kcalloc(1, sizeof(struct ocfs2_alloc_context), GFP_KERNEL);
+	*ac = kzalloc(sizeof(struct ocfs2_alloc_context), GFP_KERNEL);
 	if (!(*ac)) {
 		status = -ENOMEM;
 		mlog_errno(status);
@@ -530,7 +530,7 @@ int ocfs2_reserve_new_inode(struct ocfs2
 {
 	int status;
 
-	*ac = kcalloc(1, sizeof(struct ocfs2_alloc_context), GFP_KERNEL);
+	*ac = kzalloc(sizeof(struct ocfs2_alloc_context), GFP_KERNEL);
 	if (!(*ac)) {
 		status = -ENOMEM;
 		mlog_errno(status);
@@ -595,7 +595,7 @@ int ocfs2_reserve_clusters(struct ocfs2_
 
 	mlog_entry_void();
 
-	*ac = kcalloc(1, sizeof(struct ocfs2_alloc_context), GFP_KERNEL);
+	*ac = kzalloc(sizeof(struct ocfs2_alloc_context), GFP_KERNEL);
 	if (!(*ac)) {
 		status = -ENOMEM;
 		mlog_errno(status);
diff -puN fs/ocfs2/super.c~fix-numerous-kcalloc-calls-convert-to-kzalloc fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/fs/ocfs2/super.c
@@ -1231,7 +1231,7 @@ static int ocfs2_setup_osb_uuid(struct o
 
 	BUG_ON(uuid_bytes != OCFS2_VOL_UUID_LEN);
 
-	osb->uuid_str = kcalloc(1, OCFS2_VOL_UUID_LEN * 2 + 1, GFP_KERNEL);
+	osb->uuid_str = kzalloc(OCFS2_VOL_UUID_LEN * 2 + 1, GFP_KERNEL);
 	if (osb->uuid_str == NULL)
 		return -ENOMEM;
 
@@ -1262,7 +1262,7 @@ static int ocfs2_initialize_super(struct
 
 	mlog_entry_void();
 
-	osb = kcalloc(1, sizeof(struct ocfs2_super), GFP_KERNEL);
+	osb = kzalloc(sizeof(struct ocfs2_super), GFP_KERNEL);
 	if (!osb) {
 		status = -ENOMEM;
 		mlog_errno(status);
@@ -1387,7 +1387,7 @@ static int ocfs2_initialize_super(struct
 	 */
 	/* initialize our journal structure */
 
-	journal = kcalloc(1, sizeof(struct ocfs2_journal), GFP_KERNEL);
+	journal = kzalloc(sizeof(struct ocfs2_journal), GFP_KERNEL);
 	if (!journal) {
 		mlog(ML_ERROR, "unable to alloc journal\n");
 		status = -ENOMEM;
diff -puN fs/ocfs2/vote.c~fix-numerous-kcalloc-calls-convert-to-kzalloc fs/ocfs2/vote.c
--- a/fs/ocfs2/vote.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/fs/ocfs2/vote.c
@@ -479,7 +479,7 @@ static struct ocfs2_net_wait_ctxt *ocfs2
 {
 	struct ocfs2_net_wait_ctxt *w;
 
-	w = kcalloc(1, sizeof(*w), GFP_NOFS);
+	w = kzalloc(sizeof(*w), GFP_NOFS);
 	if (!w) {
 		mlog_errno(-ENOMEM);
 		goto bail;
@@ -642,7 +642,7 @@ static struct ocfs2_vote_msg * ocfs2_new
 
 	BUG_ON(!ocfs2_is_valid_vote_request(type));
 
-	request = kcalloc(1, sizeof(*request), GFP_NOFS);
+	request = kzalloc(sizeof(*request), GFP_NOFS);
 	if (!request) {
 		mlog_errno(-ENOMEM);
 	} else {
diff -puN include/linux/gameport.h~fix-numerous-kcalloc-calls-convert-to-kzalloc include/linux/gameport.h
--- a/include/linux/gameport.h~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/include/linux/gameport.h
@@ -105,7 +105,7 @@ static inline void gameport_set_phys(str
 
 static inline struct gameport *gameport_allocate_port(void)
 {
-	struct gameport *gameport = kcalloc(1, sizeof(struct gameport), GFP_KERNEL);
+	struct gameport *gameport = kzalloc(sizeof(struct gameport), GFP_KERNEL);
 
 	return gameport;
 }
diff -puN kernel/relay.c~fix-numerous-kcalloc-calls-convert-to-kzalloc kernel/relay.c
--- a/kernel/relay.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/kernel/relay.c
@@ -138,7 +138,7 @@ depopulate:
  */
 struct rchan_buf *relay_create_buf(struct rchan *chan)
 {
-	struct rchan_buf *buf = kcalloc(1, sizeof(struct rchan_buf), GFP_KERNEL);
+	struct rchan_buf *buf = kzalloc(sizeof(struct rchan_buf), GFP_KERNEL);
 	if (!buf)
 		return NULL;
 
@@ -479,7 +479,7 @@ struct rchan *relay_open(const char *bas
 	if (!(subbuf_size && n_subbufs))
 		return NULL;
 
-	chan = kcalloc(1, sizeof(struct rchan), GFP_KERNEL);
+	chan = kzalloc(sizeof(struct rchan), GFP_KERNEL);
 	if (!chan)
 		return NULL;
 
diff -puN net/sunrpc/svc.c~fix-numerous-kcalloc-calls-convert-to-kzalloc net/sunrpc/svc.c
--- a/net/sunrpc/svc.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/net/sunrpc/svc.c
@@ -308,7 +308,7 @@ __svc_create(struct svc_program *prog, u
 
 	serv->sv_nrpools = npools;
 	serv->sv_pools =
-		kcalloc(sizeof(struct svc_pool), serv->sv_nrpools,
+		kcalloc(serv->sv_nrpools, sizeof(struct svc_pool),
 			GFP_KERNEL);
 	if (!serv->sv_pools) {
 		kfree(serv);
diff -puN sound/pci/hda/patch_realtek.c~fix-numerous-kcalloc-calls-convert-to-kzalloc sound/pci/hda/patch_realtek.c
--- a/sound/pci/hda/patch_realtek.c~fix-numerous-kcalloc-calls-convert-to-kzalloc
+++ a/sound/pci/hda/patch_realtek.c
@@ -6477,7 +6477,7 @@ static int patch_alc262(struct hda_codec
 	int board_config;
 	int err;
 
-	spec = kcalloc(1, sizeof(*spec), GFP_KERNEL);
+	spec = kzalloc(sizeof(*spec), GFP_KERNEL);
 	if (spec == NULL)
 		return -ENOMEM;
 
@@ -7597,7 +7597,7 @@ static int patch_alc861(struct hda_codec
 	int board_config;
 	int err;
 
-	spec = kcalloc(1, sizeof(*spec), GFP_KERNEL);
+	spec = kzalloc(sizeof(*spec), GFP_KERNEL);
 	if (spec == NULL)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
fix-numerous-kcalloc-calls-convert-to-kzalloc.patch
kcalloc-re-order-out-of-order-args-in-kcalloc-calls.patch
schedc-correct-comment-for-this_rq_lock-routine.patch

