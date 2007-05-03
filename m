From: akpm@linux-foundation.org
Subject: - rename-get_property-to-of_get_property-drivers.patch removed from -mm tree
Date: Thu, 03 May 2007 12:13:59 -0700
Message-ID: <200705031914.l43JE01F017706@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767739AbXECTRW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 15:17:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, James.Bottomley@steeleye.com, adaplas@pol.net, bzolnier@gmail.com, dwmw2@infradead.org, jeff@garzik.org, khali@linux-fr.org, kristen.c.accardi@intel.com, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     Rename get_property to of_get_property: drivers
has been removed from the -mm tree.  Its filename was
     rename-get_property-to-of_get_property-drivers.patch

This patch was dropped because Paul merged it

------------------------------------------------------
Subject: Rename get_property to of_get_property: drivers
From: Stephen Rothwell <sfr@canb.auug.org.au>

These are all the remaining instances of get_property.  Simple rename of
get_property to of_get_property.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jeff Garzik <jeff@garzik.org>, Jean Delvare <khali@linux-fr.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_svw.c                 |    2 -
 drivers/char/agp/uninorth-agp.c        |    2 -
 drivers/char/briq_panel.c              |    2 -
 drivers/char/tpm/tpm_atmel.h           |    2 -
 drivers/hwmon/ams/ams-core.c           |    2 -
 drivers/hwmon/ams/ams-i2c.c            |    2 -
 drivers/hwmon/ams/ams-pmu.c            |    2 -
 drivers/ide/ppc/pmac.c                 |    4 +--
 drivers/infiniband/hw/ehca/ehca_main.c |    2 -
 drivers/mtd/maps/physmap_of.c          |    8 +++---
 drivers/net/bmac.c                     |    5 ++--
 drivers/net/ehea/ehea_main.c           |    6 ++--
 drivers/net/mace.c                     |    4 +--
 drivers/net/pasemi_mac.c               |    2 -
 drivers/net/spider_net.c               |    4 +--
 drivers/net/sungem.c                   |    2 -
 drivers/net/sungem_phy.c               |    2 -
 drivers/net/ucc_geth.c                 |   18 +++++++-------
 drivers/net/ucc_geth_mii.c             |    4 +--
 drivers/pci/hotplug/rpaphp_core.c      |   10 ++++----
 drivers/scsi/ibmvscsi/ibmvstgt.c       |    8 +++---
 drivers/scsi/ibmvscsi/rpa_vscsi.c      |    4 +--
 drivers/scsi/mac53c94.c                |    2 -
 drivers/scsi/mesh.c                    |    2 -
 drivers/serial/mpc52xx_uart.c          |    2 -
 drivers/serial/of_serial.c             |    4 +--
 drivers/serial/pmac_zilog.c            |    6 ++--
 drivers/video/aty/radeon_base.c        |    6 ++--
 drivers/video/aty/radeon_monitor.c     |   11 ++++-----
 drivers/video/aty/radeon_pm.c          |    2 -
 drivers/video/nvidia/nv_of.c           |    8 +++---
 drivers/video/offb.c                   |   28 +++++++++++------------
 drivers/video/riva/fbdev.c             |    4 +--
 33 files changed, 87 insertions(+), 85 deletions(-)

diff -puN drivers/ata/sata_svw.c~rename-get_property-to-of_get_property-drivers drivers/ata/sata_svw.c
--- a/drivers/ata/sata_svw.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/ata/sata_svw.c
@@ -288,7 +288,7 @@ static int k2_sata_proc_info(struct Scsi
 	/* Match it to a port node */
 	index = (ap == ap->host->ports[0]) ? 0 : 1;
 	for (np = np->child; np != NULL; np = np->sibling) {
-		const u32 *reg = get_property(np, "reg", NULL);
+		const u32 *reg = of_get_property(np, "reg", NULL);
 		if (!reg)
 			continue;
 		if (index == *reg)
diff -puN drivers/char/agp/uninorth-agp.c~rename-get_property-to-of_get_property-drivers drivers/char/agp/uninorth-agp.c
--- a/drivers/char/agp/uninorth-agp.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/char/agp/uninorth-agp.c
@@ -613,7 +613,7 @@ static int __devinit agp_uninorth_probe(
 		uninorth_node = of_find_node_by_name(NULL, "u3");
 	}
 	if (uninorth_node) {
-		const int *revprop = get_property(uninorth_node,
+		const int *revprop = of_get_property(uninorth_node,
 				"device-rev", NULL);
 		if (revprop != NULL)
 			uninorth_rev = *revprop & 0x3f;
diff -puN drivers/char/briq_panel.c~rename-get_property-to-of_get_property-drivers drivers/char/briq_panel.c
--- a/drivers/char/briq_panel.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/char/briq_panel.c
@@ -206,7 +206,7 @@ static int __init briq_panel_init(void)
 	const char *machine;
 	int i;
 
-	machine = get_property(root, "model", NULL);
+	machine = of_get_property(root, "model", NULL);
 	if (!machine || strncmp(machine, "TotalImpact,BRIQ-1", 18) != 0) {
 		of_node_put(root);
 		return -ENODEV;
diff -puN drivers/char/tpm/tpm_atmel.h~rename-get_property-to-of_get_property-drivers drivers/char/tpm/tpm_atmel.h
--- a/drivers/char/tpm/tpm_atmel.h~rename-get_property-to-of_get_property-drivers
+++ a/drivers/char/tpm/tpm_atmel.h
@@ -52,7 +52,7 @@ static void __iomem * atmel_get_base_add
 		return NULL;
 	}
 
-	reg = get_property(dn, "reg", &reglen);
+	reg = of_get_property(dn, "reg", &reglen);
 	naddrc = of_n_addr_cells(dn);
 	nsizec = of_n_size_cells(dn);
 
diff -puN drivers/hwmon/ams/ams-core.c~rename-get_property-to-of_get_property-drivers drivers/hwmon/ams/ams-core.c
--- a/drivers/hwmon/ams/ams-core.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/hwmon/ams/ams-core.c
@@ -144,7 +144,7 @@ int ams_sensor_attach(void)
 	const u32 *prop;
 
 	/* Get orientation */
-	prop = get_property(ams_info.of_node, "orientation", NULL);
+	prop = of_get_property(ams_info.of_node, "orientation", NULL);
 	if (!prop)
 		return -ENODEV;
 	ams_info.orient1 = *prop;
diff -puN drivers/hwmon/ams/ams-i2c.c~rename-get_property-to-of_get_property-drivers drivers/hwmon/ams/ams-i2c.c
--- a/drivers/hwmon/ams/ams-i2c.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/hwmon/ams/ams-i2c.c
@@ -276,7 +276,7 @@ int __init ams_i2c_init(struct device_no
 	ams_info.bustype = BUS_I2C;
 
 	/* look for bus either using "reg" or by path */
-	prop = get_property(ams_info.of_node, "reg", NULL);
+	prop = of_get_property(ams_info.of_node, "reg", NULL);
 	if (!prop) {
 		result = -ENODEV;
 
diff -puN drivers/hwmon/ams/ams-pmu.c~rename-get_property-to-of_get_property-drivers drivers/hwmon/ams/ams-pmu.c
--- a/drivers/hwmon/ams/ams-pmu.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/hwmon/ams/ams-pmu.c
@@ -160,7 +160,7 @@ int __init ams_pmu_init(struct device_no
 	ams_info.bustype = BUS_HOST;
 
 	/* Get PMU command, should be 0x4e, but we can never know */
-	prop = get_property(ams_info.of_node, "reg", NULL);
+	prop = of_get_property(ams_info.of_node, "reg", NULL);
 	if (!prop) {
 		result = -ENODEV;
 		goto exit;
diff -puN drivers/ide/ppc/pmac.c~rename-get_property-to-of_get_property-drivers drivers/ide/ppc/pmac.c
--- a/drivers/ide/ppc/pmac.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/ide/ppc/pmac.c
@@ -1175,14 +1175,14 @@ pmac_ide_setup_device(pmac_ide_hwif_t *p
 		pmif->broken_dma = 1;
 	}
 
-	bidp = get_property(np, "AAPL,bus-id", NULL);
+	bidp = of_get_property(np, "AAPL,bus-id", NULL);
 	pmif->aapl_bus_id =  bidp ? *bidp : 0;
 
 	/* Get cable type from device-tree */
 	if (pmif->kind == controller_kl_ata4 || pmif->kind == controller_un_ata6
 	    || pmif->kind == controller_k2_ata6
 	    || pmif->kind == controller_sh_ata6) {
-		const char* cable = get_property(np, "cable-type", NULL);
+		const char* cable = of_get_property(np, "cable-type", NULL);
 		if (cable && !strncmp(cable, "80-", 3))
 			pmif->cable_80 = 1;
 	}
diff -puN drivers/infiniband/hw/ehca/ehca_main.c~rename-get_property-to-of_get_property-drivers drivers/infiniband/hw/ehca/ehca_main.c
--- a/drivers/infiniband/hw/ehca/ehca_main.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/infiniband/hw/ehca/ehca_main.c
@@ -569,7 +569,7 @@ static int __devinit ehca_probe(struct i
 	struct ib_pd *ibpd;
 	int ret;
 
-	handle = get_property(dev->ofdev.node, "ibm,hca-handle", NULL);
+	handle = of_get_property(dev->ofdev.node, "ibm,hca-handle", NULL);
 	if (!handle) {
 		ehca_gen_err("Cannot get eHCA handle for adapter: %s.",
 			     dev->ofdev.node->full_name);
diff -puN drivers/mtd/maps/physmap_of.c~rename-get_property-to-of_get_property-drivers drivers/mtd/maps/physmap_of.c
--- a/drivers/mtd/maps/physmap_of.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/mtd/maps/physmap_of.c
@@ -48,7 +48,7 @@ static int parse_flash_partitions(struct
 	const  u32  *part;
 	const  char *name;
 
-	part = get_property(node, "partitions", &plen);
+	part = of_get_property(node, "partitions", &plen);
 	if (part == NULL)
 		goto err;
 
@@ -59,7 +59,7 @@ static int parse_flash_partitions(struct
 		goto err;
 	}
 
-	name = get_property(node, "partition-names", &plen);
+	name = of_get_property(node, "partition-names", &plen);
 
 	for (i = 0; i < retval; i++) {
 		(*parts)[i].offset = *part++;
@@ -153,7 +153,7 @@ static int __devinit of_physmap_probe(st
 		goto err_out;
 	}
 
-	width = get_property(dp, "bank-width", NULL);
+	width = of_get_property(dp, "bank-width", NULL);
 	if (width == NULL) {
 		dev_err(&dev->dev, "Can't get the flash bank width!\n");
 		err = -EINVAL;
@@ -174,7 +174,7 @@ static int __devinit of_physmap_probe(st
 
 	simple_map_init(&info->map);
 
-	of_probe = get_property(dp, "probe-type", NULL);
+	of_probe = of_get_property(dp, "probe-type", NULL);
 	if (of_probe == NULL) {
 		probe_type = rom_probe_types;
 		for (; info->mtd == NULL && *probe_type != NULL; probe_type++)
diff -puN drivers/net/bmac.c~rename-get_property-to-of_get_property-drivers drivers/net/bmac.c
--- a/drivers/net/bmac.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/net/bmac.c
@@ -1260,9 +1260,10 @@ static int __devinit bmac_probe(struct m
 		printk(KERN_ERR "BMAC: can't use, need 3 addrs and 3 intrs\n");
 		return -ENODEV;
 	}
-	prop_addr = get_property(macio_get_of_node(mdev), "mac-address", NULL);
+	prop_addr = of_get_property(macio_get_of_node(mdev),
+			"mac-address", NULL);
 	if (prop_addr == NULL) {
-		prop_addr = get_property(macio_get_of_node(mdev),
+		prop_addr = of_get_property(macio_get_of_node(mdev),
 				"local-mac-address", NULL);
 		if (prop_addr == NULL) {
 			printk(KERN_ERR "BMAC: Can't get mac-address\n");
diff -puN drivers/net/ehea/ehea_main.c~rename-get_property-to-of_get_property-drivers drivers/net/ehea/ehea_main.c
--- a/drivers/net/ehea/ehea_main.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/net/ehea/ehea_main.c
@@ -2609,7 +2609,7 @@ static int ehea_setup_ports(struct ehea_
 	lhea_dn = adapter->ebus_dev->ofdev.node;
 	while ((eth_dn = of_get_next_child(lhea_dn, eth_dn))) {
 
-		dn_log_port_id = get_property(eth_dn, "ibm,hea-port-no",
+		dn_log_port_id = of_get_property(eth_dn, "ibm,hea-port-no",
 						    NULL);
 		if (!dn_log_port_id) {
 			ehea_error("bad device node: eth_dn name=%s",
@@ -2649,7 +2649,7 @@ static struct device_node *ehea_get_eth_
 	lhea_dn = adapter->ebus_dev->ofdev.node;
 	while ((eth_dn = of_get_next_child(lhea_dn, eth_dn))) {
 
-		dn_log_port_id = get_property(eth_dn, "ibm,hea-port-no",
+		dn_log_port_id = of_get_property(eth_dn, "ibm,hea-port-no",
 						    NULL);
 		if (dn_log_port_id)
 			if (*dn_log_port_id == logical_port_id)
@@ -2790,7 +2790,7 @@ static int __devinit ehea_probe_adapter(
 
 	adapter->ebus_dev = dev;
 
-	adapter_handle = get_property(dev->ofdev.node, "ibm,hea-handle",
+	adapter_handle = of_get_property(dev->ofdev.node, "ibm,hea-handle",
 					    NULL);
 	if (adapter_handle)
 		adapter->handle = *adapter_handle;
diff -puN drivers/net/mace.c~rename-get_property-to-of_get_property-drivers drivers/net/mace.c
--- a/drivers/net/mace.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/net/mace.c
@@ -110,9 +110,9 @@ static int __devinit mace_probe(struct m
 		return -ENODEV;
 	}
 
-	addr = get_property(mace, "mac-address", NULL);
+	addr = of_get_property(mace, "mac-address", NULL);
 	if (addr == NULL) {
-		addr = get_property(mace, "local-mac-address", NULL);
+		addr = of_get_property(mace, "local-mac-address", NULL);
 		if (addr == NULL) {
 			printk(KERN_ERR "Can't get mac-address for MACE %s\n",
 			       mace->full_name);
diff -puN drivers/net/pasemi_mac.c~rename-get_property-to-of_get_property-drivers drivers/net/pasemi_mac.c
--- a/drivers/net/pasemi_mac.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/net/pasemi_mac.c
@@ -80,7 +80,7 @@ static int pasemi_get_mac_addr(struct pa
 		return -ENOENT;
 	}
 
-	maddr = get_property(dn, "mac-address", NULL);
+	maddr = of_get_property(dn, "mac-address", NULL);
 	if (maddr == NULL) {
 		dev_warn(&pdev->dev,
 			 "no mac address in device tree, not configuring\n");
diff -puN drivers/net/spider_net.c~rename-get_property-to-of_get_property-drivers drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/net/spider_net.c
@@ -1830,7 +1830,7 @@ try_host_fw:
 	if (!dn)
 		goto out_err;
 
-	fw_prop = get_property(dn, "firmware", &fw_size);
+	fw_prop = of_get_property(dn, "firmware", &fw_size);
 	if (!fw_prop)
 		goto out_err;
 
@@ -2236,7 +2236,7 @@ spider_net_setup_netdev(struct spider_ne
 	if (!dn)
 		return -EIO;
 
-	mac = get_property(dn, "local-mac-address", NULL);
+	mac = of_get_property(dn, "local-mac-address", NULL);
 	if (!mac)
 		return -EIO;
 	memcpy(addr.sa_data, mac, ETH_ALEN);
diff -puN drivers/net/sungem.c~rename-get_property-to-of_get_property-drivers drivers/net/sungem.c
--- a/drivers/net/sungem.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/net/sungem.c
@@ -2903,7 +2903,7 @@ static int __devinit gem_get_device_addr
 	struct net_device *dev = gp->dev;
 	const unsigned char *addr;
 
-	addr = get_property(gp->of_node, "local-mac-address", NULL);
+	addr = of_get_property(gp->of_node, "local-mac-address", NULL);
 	if (addr == NULL) {
 #ifdef CONFIG_SPARC
 		addr = idprom->id_ethaddr;
diff -puN drivers/net/sungem_phy.c~rename-get_property-to-of_get_property-drivers drivers/net/sungem_phy.c
--- a/drivers/net/sungem_phy.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/net/sungem_phy.c
@@ -451,7 +451,7 @@ static int bcm5421_init(struct mii_phy* 
 	if (phy->platform_data) {
 		struct device_node *np = of_get_parent(phy->platform_data);
 		int can_low_power = 1;
-		if (np == NULL || get_property(np, "no-autolowpower", NULL))
+		if (np == NULL || of_get_property(np, "no-autolowpower", NULL))
 			can_low_power = 0;
 		if (can_low_power) {
 			/* Enable automatic low-power */
diff -puN drivers/net/ucc_geth.c~rename-get_property-to-of_get_property-drivers drivers/net/ucc_geth.c
--- a/drivers/net/ucc_geth.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/net/ucc_geth.c
@@ -3787,7 +3787,7 @@ static int ucc_geth_probe(struct of_devi
 
 	ugeth_vdbg("%s: IN", __FUNCTION__);
 
-	prop = get_property(np, "device-id", NULL);
+	prop = of_get_property(np, "device-id", NULL);
 	ucc_num = *prop - 1;
 	if ((ucc_num < 0) || (ucc_num > 7))
 		return -ENODEV;
@@ -3795,9 +3795,9 @@ static int ucc_geth_probe(struct of_devi
 	ug_info = &ugeth_info[ucc_num];
 	ug_info->uf_info.ucc_num = ucc_num;
 
-	prop = get_property(np, "rx-clock", NULL);
+	prop = of_get_property(np, "rx-clock", NULL);
 	ug_info->uf_info.rx_clock = *prop;
-	prop = get_property(np, "tx-clock", NULL);
+	prop = of_get_property(np, "tx-clock", NULL);
 	ug_info->uf_info.tx_clock = *prop;
 	err = of_address_to_resource(np, 0, &res);
 	if (err)
@@ -3806,23 +3806,23 @@ static int ucc_geth_probe(struct of_devi
 	ug_info->uf_info.regs = res.start;
 	ug_info->uf_info.irq = irq_of_parse_and_map(np, 0);
 
-	ph = get_property(np, "phy-handle", NULL);
+	ph = of_get_property(np, "phy-handle", NULL);
 	phy = of_find_node_by_phandle(*ph);
 
 	if (phy == NULL)
 		return -ENODEV;
 
 	/* set the PHY address */
-	prop = get_property(phy, "reg", NULL);
+	prop = of_get_property(phy, "reg", NULL);
 	if (prop == NULL)
 		return -1;
 	ug_info->phy_address = *prop;
 
 	/* get the phy interface type, or default to MII */
-	prop = get_property(np, "interface-type", NULL);
+	prop = of_get_property(np, "interface-type", NULL);
 	if (!prop) {
 		/* handle interface property present in old trees */
-		prop = get_property(phy, "interface", NULL);
+		prop = of_get_property(phy, "interface", NULL);
 		if (prop != NULL)
 			phy_interface = enet_to_phy_interface[*prop];
 		else
@@ -3832,10 +3832,10 @@ static int ucc_geth_probe(struct of_devi
 	}
 
 	/* get speed, or derive from interface */
-	prop = get_property(np, "max-speed", NULL);
+	prop = of_get_property(np, "max-speed", NULL);
 	if (!prop) {
 		/* handle interface property present in old trees */
-		prop = get_property(phy, "interface", NULL);
+		prop = of_get_property(phy, "interface", NULL);
 		if (prop != NULL)
 			max_speed = enet_to_speed[*prop];
 	} else {
diff -puN drivers/net/ucc_geth_mii.c~rename-get_property-to-of_get_property-drivers drivers/net/ucc_geth_mii.c
--- a/drivers/net/ucc_geth_mii.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/net/ucc_geth_mii.c
@@ -172,7 +172,7 @@ static int uec_mdio_probe(struct of_devi
 	while ((child = of_get_next_child(np, child)) != NULL) {
 		int irq = irq_of_parse_and_map(child, 0);
 		if (irq != NO_IRQ) {
-			const u32 *id = get_property(child, "reg", NULL);
+			const u32 *id = of_get_property(child, "reg", NULL);
 			new_bus->irq[*id] = irq;
 		}
 	}
@@ -203,7 +203,7 @@ static int uec_mdio_probe(struct of_devi
 		if ((res.start >= tempres.start) &&
 		    (res.end <= tempres.end)) {
 			/* set this UCC to be the MII master */
-			const u32 *id = get_property(tempnp, "device-id", NULL);
+			const u32 *id = of_get_property(tempnp, "device-id", NULL);
 			if (id == NULL)
 				goto bus_register_fail;
 
diff -puN drivers/pci/hotplug/rpaphp_core.c~rename-get_property-to-of_get_property-drivers drivers/pci/hotplug/rpaphp_core.c
--- a/drivers/pci/hotplug/rpaphp_core.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/pci/hotplug/rpaphp_core.c
@@ -169,10 +169,10 @@ static int get_children_props(struct dev
 {
 	const int *indexes, *names, *types, *domains;
 
-	indexes = get_property(dn, "ibm,drc-indexes", NULL);
-	names = get_property(dn, "ibm,drc-names", NULL);
-	types = get_property(dn, "ibm,drc-types", NULL);
-	domains = get_property(dn, "ibm,drc-power-domains", NULL);
+	indexes = of_get_property(dn, "ibm,drc-indexes", NULL);
+	names = of_get_property(dn, "ibm,drc-names", NULL);
+	types = of_get_property(dn, "ibm,drc-types", NULL);
+	domains = of_get_property(dn, "ibm,drc-power-domains", NULL);
 
 	if (!indexes || !names || !types || !domains) {
 		/* Slot does not have dynamically-removable children */
@@ -205,7 +205,7 @@ int rpaphp_get_drc_props(struct device_n
 	char *name_tmp, *type_tmp;
 	int i, rc;
 
-	my_index = get_property(dn, "ibm,my-drc-index", NULL);
+	my_index = of_get_property(dn, "ibm,my-drc-index", NULL);
 	if (!my_index) {
 		/* Node isn't DLPAR/hotplug capable */
 		return -EINVAL;
diff -puN drivers/scsi/ibmvscsi/ibmvstgt.c~rename-get_property-to-of_get_property-drivers drivers/scsi/ibmvscsi/ibmvstgt.c
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -892,16 +892,16 @@ static int get_system_info(void)
 	if (!rootdn)
 		return -ENOENT;
 
-	model = get_property(rootdn, "model", NULL);
-	id = get_property(rootdn, "system-id", NULL);
+	model = of_get_property(rootdn, "model", NULL);
+	id = of_get_property(rootdn, "system-id", NULL);
 	if (model && id)
 		snprintf(system_id, sizeof(system_id), "%s-%s", model, id);
 
-	name = get_property(rootdn, "ibm,partition-name", NULL);
+	name = of_get_property(rootdn, "ibm,partition-name", NULL);
 	if (name)
 		strncpy(partition_name, name, sizeof(partition_name));
 
-	num = get_property(rootdn, "ibm,partition-no", NULL);
+	num = of_get_property(rootdn, "ibm,partition-no", NULL);
 	if (num)
 		partition_number = *num;
 
diff -puN drivers/scsi/ibmvscsi/rpa_vscsi.c~rename-get_property-to-of_get_property-drivers drivers/scsi/ibmvscsi/rpa_vscsi.c
--- a/drivers/scsi/ibmvscsi/rpa_vscsi.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/scsi/ibmvscsi/rpa_vscsi.c
@@ -162,11 +162,11 @@ static void gather_partition_info(void)
 		return;
 	}
 
-	ppartition_name = get_property(rootdn, "ibm,partition-name", NULL);
+	ppartition_name = of_get_property(rootdn, "ibm,partition-name", NULL);
 	if (ppartition_name)
 		strncpy(partition_name, ppartition_name,
 				sizeof(partition_name));
-	p_number_ptr = get_property(rootdn, "ibm,partition-no", NULL);
+	p_number_ptr = of_get_property(rootdn, "ibm,partition-no", NULL);
 	if (p_number_ptr)
 		partition_number = *p_number_ptr;
 	of_node_put(rootdn);
diff -puN drivers/scsi/mac53c94.c~rename-get_property-to-of_get_property-drivers drivers/scsi/mac53c94.c
--- a/drivers/scsi/mac53c94.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/scsi/mac53c94.c
@@ -471,7 +471,7 @@ static int mac53c94_probe(struct macio_d
 		goto out_free;
 	}
 
-       	clkprop = get_property(node, "clock-frequency", &proplen);
+	clkprop = of_get_property(node, "clock-frequency", &proplen);
        	if (clkprop == NULL || proplen != sizeof(int)) {
        		printk(KERN_ERR "%s: can't get clock frequency, "
        		       "assuming 25MHz\n", node->full_name);
diff -puN drivers/scsi/mesh.c~rename-get_property-to-of_get_property-drivers drivers/scsi/mesh.c
--- a/drivers/scsi/mesh.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/scsi/mesh.c
@@ -1947,7 +1947,7 @@ static int mesh_probe(struct macio_dev *
 	       	ms->tgts[tgt].current_req = NULL;
        	}
 
-	if ((cfp = get_property(mesh, "clock-frequency", NULL)))
+	if ((cfp = of_get_property(mesh, "clock-frequency", NULL)))
        		ms->clk_freq = *cfp;
 	else {
        		printk(KERN_INFO "mesh: assuming 50MHz clock frequency\n");
diff -puN drivers/serial/mpc52xx_uart.c~rename-get_property-to-of_get_property-drivers drivers/serial/mpc52xx_uart.c
--- a/drivers/serial/mpc52xx_uart.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/serial/mpc52xx_uart.c
@@ -1069,7 +1069,7 @@ mpc52xx_uart_of_enumerate(void)
 			continue;
 
 		/* Is a particular device number requested? */
-		devno = get_property(np, "port-number", NULL);
+		devno = of_get_property(np, "port-number", NULL);
 		mpc52xx_uart_of_assign(of_node_get(np), devno ? *devno : -1);
 	}
 
diff -puN drivers/serial/of_serial.c~rename-get_property-to-of_get_property-drivers drivers/serial/of_serial.c
--- a/drivers/serial/of_serial.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/serial/of_serial.c
@@ -29,8 +29,8 @@ static int __devinit of_platform_serial_
 	int ret;
 
 	memset(port, 0, sizeof *port);
-	spd = get_property(np, "current-speed", NULL);
-	clk = get_property(np, "clock-frequency", NULL);
+	spd = of_get_property(np, "current-speed", NULL);
+	clk = of_get_property(np, "clock-frequency", NULL);
 	if (!clk) {
 		dev_warn(&ofdev->dev, "no clock-frequency property set\n");
 		return -ENODEV;
diff -puN drivers/serial/pmac_zilog.c~rename-get_property-to-of_get_property-drivers drivers/serial/pmac_zilog.c
--- a/drivers/serial/pmac_zilog.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/serial/pmac_zilog.c
@@ -1452,12 +1452,12 @@ no_dma:
 	 */
 	if (device_is_compatible(np, "cobalt"))
 		uap->flags |= PMACZILOG_FLAG_IS_INTMODEM;
-	conn = get_property(np, "AAPL,connector", &len);
+	conn = of_get_property(np, "AAPL,connector", &len);
 	if (conn && (strcmp(conn, "infrared") == 0))
 		uap->flags |= PMACZILOG_FLAG_IS_IRDA;
 	uap->port_type = PMAC_SCC_ASYNC;
 	/* 1999 Powerbook G3 has slot-names property instead */
-	slots = get_property(np, "slot-names", &len);
+	slots = of_get_property(np, "slot-names", &len);
 	if (slots && slots->count > 0) {
 		if (strcmp(slots->name, "IrDA") == 0)
 			uap->flags |= PMACZILOG_FLAG_IS_IRDA;
@@ -1471,7 +1471,7 @@ no_dma:
 			of_find_node_by_name(NULL, "i2c-modem");
 		if (i2c_modem) {
 			const char* mid =
-				get_property(i2c_modem, "modem-id", NULL);
+				of_get_property(i2c_modem, "modem-id", NULL);
 			if (mid) switch(*mid) {
 			case 0x04 :
 			case 0x05 :
diff -puN drivers/video/aty/radeon_base.c~rename-get_property-to-of_get_property-drivers drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/video/aty/radeon_base.c
@@ -424,7 +424,7 @@ static int __devinit radeon_read_xtal_OF
 
 	if (dp == NULL)
 		return -ENODEV;
-	val = get_property(dp, "ATY,RefCLK", NULL);
+	val = of_get_property(dp, "ATY,RefCLK", NULL);
 	if (!val || !*val) {
 		printk(KERN_WARNING "radeonfb: No ATY,RefCLK property !\n");
 		return -EINVAL;
@@ -432,11 +432,11 @@ static int __devinit radeon_read_xtal_OF
 
 	rinfo->pll.ref_clk = (*val) / 10;
 
-	val = get_property(dp, "ATY,SCLK", NULL);
+	val = of_get_property(dp, "ATY,SCLK", NULL);
 	if (val && *val)
 		rinfo->pll.sclk = (*val) / 10;
 
-	val = get_property(dp, "ATY,MCLK", NULL);
+	val = of_get_property(dp, "ATY,MCLK", NULL);
 	if (val && *val)
 		rinfo->pll.mclk = (*val) / 10;
 
diff -puN drivers/video/aty/radeon_monitor.c~rename-get_property-to-of_get_property-drivers drivers/video/aty/radeon_monitor.c
--- a/drivers/video/aty/radeon_monitor.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/video/aty/radeon_monitor.c
@@ -70,7 +70,7 @@ static int __devinit radeon_parse_montyp
         int i, mt = MT_NONE;  
 	
 	RTRACE("analyzing OF properties...\n");
-	pmt = get_property(dp, "display-type", NULL);
+	pmt = of_get_property(dp, "display-type", NULL);
 	if (!pmt)
 		return MT_NONE;
 	RTRACE("display-type: %s\n", pmt);
@@ -89,7 +89,7 @@ static int __devinit radeon_parse_montyp
 	}
 
 	for (i = 0; propnames[i] != NULL; ++i) {
-		pedid = get_property(dp, propnames[i], NULL);
+		pedid = of_get_property(dp, propnames[i], NULL);
 		if (pedid != NULL)
 			break;
 	}
@@ -98,9 +98,10 @@ static int __devinit radeon_parse_montyp
 	 * single-head cards have hdno == -1 and skip this step
 	 */
 	if (pedid == NULL && dp->parent && (hdno != -1))
-		pedid = get_property(dp->parent, (hdno == 0) ? "EDID1" : "EDID2", NULL);
+		pedid = of_get_property(dp->parent,
+				(hdno == 0) ? "EDID1" : "EDID2", NULL);
 	if (pedid == NULL && dp->parent && (hdno == 0))
-		pedid = get_property(dp->parent, "EDID", NULL);
+		pedid = of_get_property(dp->parent, "EDID", NULL);
 	if (pedid == NULL)
 		return mt;
 
@@ -130,7 +131,7 @@ static int __devinit radeon_probe_OF_hea
 		do {
 			if (!dp)
 				return MT_NONE;
-			pname = get_property(dp, "name", NULL);
+			pname = of_get_property(dp, "name", NULL);
 			if (!pname)
 				return MT_NONE;
 			len = strlen(pname);
diff -puN drivers/video/aty/radeon_pm.c~rename-get_property-to-of_get_property-drivers drivers/video/aty/radeon_pm.c
--- a/drivers/video/aty/radeon_pm.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/video/aty/radeon_pm.c
@@ -1290,7 +1290,7 @@ static void radeon_pm_full_reset_sdram(s
 		if (rinfo->of_node != NULL) {
 			int size;
 
-			mrtable = get_property(rinfo->of_node, "ATY,MRT", &size);
+			mrtable = of_get_property(rinfo->of_node, "ATY,MRT", &size);
 			if (mrtable)
 				mrtable_size = size >> 2;
 			else
diff -puN drivers/video/nvidia/nv_of.c~rename-get_property-to-of_get_property-drivers drivers/video/nvidia/nv_of.c
--- a/drivers/video/nvidia/nv_of.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/video/nvidia/nv_of.c
@@ -46,15 +46,15 @@ int nvidia_probe_of_connector(struct fb_
 
 		for (dp = NULL;
 		     (dp = of_get_next_child(parent, dp)) != NULL;) {
-			pname = get_property(dp, "name", NULL);
+			pname = of_get_property(dp, "name", NULL);
 			if (!pname)
 				continue;
 			len = strlen(pname);
 			if ((pname[len-1] == 'A' && conn == 1) ||
 			    (pname[len-1] == 'B' && conn == 2)) {
 				for (i = 0; propnames[i] != NULL; ++i) {
-					pedid = get_property(dp, propnames[i],
-							     NULL);
+					pedid = of_get_property(dp,
+							propnames[i], NULL);
 					if (pedid != NULL)
 						break;
 				}
@@ -65,7 +65,7 @@ int nvidia_probe_of_connector(struct fb_
 	}
 	if (pedid == NULL) {
 		for (i = 0; propnames[i] != NULL; ++i) {
-			pedid = get_property(parent, propnames[i], NULL);
+			pedid = of_get_property(parent, propnames[i], NULL);
 			if (pedid != NULL)
 				break;
 		}
diff -puN drivers/video/offb.c~rename-get_property-to-of_get_property-drivers drivers/video/offb.c
--- a/drivers/video/offb.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/video/offb.c
@@ -425,27 +425,27 @@ static void __init offb_init_nodriver(st
 	const u32 *pp, *addrp, *up;
 	u64 asize;
 
-	pp = get_property(dp, "linux,bootx-depth", &len);
+	pp = of_get_property(dp, "linux,bootx-depth", &len);
 	if (pp == NULL)
-		pp = get_property(dp, "depth", &len);
+		pp = of_get_property(dp, "depth", &len);
 	if (pp && len == sizeof(u32))
 		depth = *pp;
 
-	pp = get_property(dp, "linux,bootx-width", &len);
+	pp = of_get_property(dp, "linux,bootx-width", &len);
 	if (pp == NULL)
-		pp = get_property(dp, "width", &len);
+		pp = of_get_property(dp, "width", &len);
 	if (pp && len == sizeof(u32))
 		width = *pp;
 
-	pp = get_property(dp, "linux,bootx-height", &len);
+	pp = of_get_property(dp, "linux,bootx-height", &len);
 	if (pp == NULL)
-		pp = get_property(dp, "height", &len);
+		pp = of_get_property(dp, "height", &len);
 	if (pp && len == sizeof(u32))
 		height = *pp;
 
-	pp = get_property(dp, "linux,bootx-linebytes", &len);
+	pp = of_get_property(dp, "linux,bootx-linebytes", &len);
 	if (pp == NULL)
-		pp = get_property(dp, "linebytes", &len);
+		pp = of_get_property(dp, "linebytes", &len);
 	if (pp && len == sizeof(u32) && (*pp != 0xffffffffu))
 		pitch = *pp;
 	else
@@ -463,9 +463,9 @@ static void __init offb_init_nodriver(st
 	 * ranges and pick one that is both big enough and if possible encloses
 	 * the "address" property. If none match, we pick the biggest
 	 */
-	up = get_property(dp, "linux,bootx-addr", &len);
+	up = of_get_property(dp, "linux,bootx-addr", &len);
 	if (up == NULL)
-		up = get_property(dp, "address", &len);
+		up = of_get_property(dp, "address", &len);
 	if (up && len == sizeof(u32))
 		addr_prop = *up;
 
@@ -521,7 +521,7 @@ static int __init offb_init(void)
 		return -ENODEV;
 
 	/* Check if we have a MacOS display without a node spec */
-	if (get_property(of_chosen, "linux,bootx-noscreen", NULL) != NULL) {
+	if (of_get_property(of_chosen, "linux,bootx-noscreen", NULL) != NULL) {
 		/* The old code tried to work out which node was the MacOS
 		 * display based on the address. I'm dropping that since the
 		 * lack of a node spec only happens with old BootX versions
@@ -532,14 +532,14 @@ static int __init offb_init(void)
 	}
 
 	for (dp = NULL; (dp = of_find_node_by_type(dp, "display"));) {
-		if (get_property(dp, "linux,opened", NULL) &&
-		    get_property(dp, "linux,boot-display", NULL)) {
+		if (of_get_property(dp, "linux,opened", NULL) &&
+		    of_get_property(dp, "linux,boot-display", NULL)) {
 			boot_disp = dp;
 			offb_init_nodriver(dp, 0);
 		}
 	}
 	for (dp = NULL; (dp = of_find_node_by_type(dp, "display"));) {
-		if (get_property(dp, "linux,opened", NULL) &&
+		if (of_get_property(dp, "linux,opened", NULL) &&
 		    dp != boot_disp)
 			offb_init_nodriver(dp, 0);
 	}
diff -puN drivers/video/riva/fbdev.c~rename-get_property-to-of_get_property-drivers drivers/video/riva/fbdev.c
--- a/drivers/video/riva/fbdev.c~rename-get_property-to-of_get_property-drivers
+++ a/drivers/video/riva/fbdev.c
@@ -1760,13 +1760,13 @@ static int __devinit riva_get_EDID_OF(st
 	NVTRACE_ENTER();
 	dp = pci_device_to_OF_node(pd);
 	for (; dp != NULL; dp = dp->child) {
-		disptype = get_property(dp, "display-type", NULL);
+		disptype = of_get_property(dp, "display-type", NULL);
 		if (disptype == NULL)
 			continue;
 		if (strncmp(disptype, "LCD", 3) != 0)
 			continue;
 		for (i = 0; propnames[i] != NULL; ++i) {
-			pedid = get_property(dp, propnames[i], NULL);
+			pedid = of_get_property(dp, propnames[i], NULL);
 			if (pedid != NULL) {
 				par->EDID = (unsigned char *)pedid;
 				NVTRACE("LCD found.\n");
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
git-powerpc.patch
drivers-char-hvc_consolec-cleanups.patch
rename-get_property-to-of_get_property-drivers.patch
rename-device_is_compatible-to-of_device_is_compatible.patch
