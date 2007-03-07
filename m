From: akpm@linux-foundation.org
Subject: + tpm_infineon-add-support-for-devices-in-mmio-space.patch added to -mm tree
Date: Wed, 07 Mar 2007 14:36:12 -0800
Message-ID: <200703072236.l27MaC5f011408@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35126 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965703AbXCGWg0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 17:36:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alex.williamson@hp.com, kjhall@us.ibm.com, tpm@selhorst.net


The patch titled
     tpm_infineon: add support for devices in mmio space
has been added to the -mm tree.  Its filename is
     tpm_infineon-add-support-for-devices-in-mmio-space.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tpm_infineon: add support for devices in mmio space
From: Alex Williamson <alex.williamson@hp.com>

tAdd adds support for devices living in MMIO space to the Infineon TPM
driver.  These can be found on some of the newer HP ia64 systems.

Signed-off-by: Alex Williamson <alex.williamson@hp.com>
Cc: Kylene Jo Hall <kjhall@us.ibm.com>
Cc: Marcel Selhorst <tpm@selhorst.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm_infineon.c |  231 +++++++++++++++++++++---------
 1 files changed, 165 insertions(+), 66 deletions(-)

diff -puN drivers/char/tpm/tpm_infineon.c~tpm_infineon-add-support-for-devices-in-mmio-space drivers/char/tpm/tpm_infineon.c
--- a/drivers/char/tpm/tpm_infineon.c~tpm_infineon-add-support-for-devices-in-mmio-space
+++ a/drivers/char/tpm/tpm_infineon.c
@@ -30,12 +30,60 @@
 #define	TPM_MAX_TRIES		5000
 #define	TPM_INFINEON_DEV_VEN_VALUE	0x15D1
 
-/* These values will be filled after PnP-call */
-static int TPM_INF_DATA;
-static int TPM_INF_ADDR;
-static int TPM_INF_BASE;
-static int TPM_INF_ADDR_LEN;
-static int TPM_INF_PORT_LEN;
+#define TPM_INF_IO_PORT		0x0
+#define TPM_INF_IO_MEM		0x1
+
+#define TPM_INF_ADDR		0x0
+#define TPM_INF_DATA		0x1
+
+struct tpm_inf_dev {
+	int iotype;
+
+	void __iomem *mem_base;		/* MMIO ioremap'd addr */
+	unsigned long map_base;		/* phys MMIO base */
+	unsigned long map_size;		/* MMIO region size */
+	unsigned int index_off;		/* index register offset */
+
+	unsigned int data_regs;		/* Data registers */
+	unsigned int data_size;
+
+	unsigned int config_port;	/* IO Port config index reg */
+	unsigned int config_size;
+};
+
+static struct tpm_inf_dev tpm_dev;
+
+static inline void tpm_data_out(unsigned char data, unsigned char offset)
+{
+	if (tpm_dev.iotype == TPM_INF_IO_PORT)
+		outb(data, tpm_dev.data_regs + offset);
+	else
+		writeb(data, tpm_dev.mem_base + tpm_dev.data_regs + offset);
+}
+
+static inline unsigned char tpm_data_in(unsigned char offset)
+{
+	if (tpm_dev.iotype == TPM_INF_IO_PORT)
+		return inb(tpm_dev.data_regs + offset);
+	else
+		return readb(tpm_dev.mem_base + tpm_dev.data_regs + offset);
+}
+
+static inline void tpm_config_out(unsigned char data, unsigned char offset)
+{
+	if (tpm_dev.iotype == TPM_INF_IO_PORT)
+		outb(data, tpm_dev.config_port + offset);
+	else
+		writeb(data, tpm_dev.mem_base + tpm_dev.index_off + offset);
+}
+
+static inline unsigned char tpm_config_in(unsigned char offset)
+{
+	if (tpm_dev.iotype == TPM_INF_IO_PORT)
+		return inb(tpm_dev.config_port + offset);
+	else
+		return readb(tpm_dev.mem_base + tpm_dev.index_off + offset);
+}
 
 /* TPM header definitions */
 enum infineon_tpm_header {
@@ -105,7 +153,7 @@ static int empty_fifo(struct tpm_chip *c
 
 	if (clear_wrfifo) {
 		for (i = 0; i < 4096; i++) {
-			status = inb(chip->vendor.base + WRFIFO);
+			status = tpm_data_in(WRFIFO);
 			if (status == 0xff) {
 				if (check == 5)
 					break;
@@ -125,8 +173,8 @@ static int empty_fifo(struct tpm_chip *c
 	 */
 	i = 0;
 	do {
-		status = inb(chip->vendor.base + RDFIFO);
-		status = inb(chip->vendor.base + STAT);
+		status = tpm_data_in(RDFIFO);
+		status = tpm_data_in(STAT);
 		i++;
 		if (i == TPM_MAX_TRIES)
 			return -EIO;
@@ -139,7 +187,7 @@ static int wait(struct tpm_chip *chip, i
 	int status;
 	int i;
 	for (i = 0; i < TPM_MAX_TRIES; i++) {
-		status = inb(chip->vendor.base + STAT);
+		status = tpm_data_in(STAT);
 		/* check the status-register if wait_for_bit is set */
 		if (status & 1 << wait_for_bit)
 			break;
@@ -158,7 +206,7 @@ static int wait(struct tpm_chip *chip, i
 static void wait_and_send(struct tpm_chip *chip, u8 sendbyte)
 {
 	wait(chip, STAT_XFE);
-	outb(sendbyte, chip->vendor.base + WRFIFO);
+	tpm_data_out(sendbyte, WRFIFO);
 }
 
     /* Note: WTX means Waiting-Time-Extension. Whenever the TPM needs more
@@ -205,7 +253,7 @@ recv_begin:
 		ret = wait(chip, STAT_RDA);
 		if (ret)
 			return -EIO;
-		buf[i] = inb(chip->vendor.base + RDFIFO);
+		buf[i] = tpm_data_in(RDFIFO);
 	}
 
 	if (buf[0] != TPM_VL_VER) {
@@ -220,7 +268,7 @@ recv_begin:
 
 		for (i = 0; i < size; i++) {
 			wait(chip, STAT_RDA);
-			buf[i] = inb(chip->vendor.base + RDFIFO);
+			buf[i] = tpm_data_in(RDFIFO);
 		}
 
 		if ((size == 0x6D00) && (buf[1] == 0x80)) {
@@ -269,7 +317,7 @@ static int tpm_inf_send(struct tpm_chip 
 	u8 count_high, count_low, count_4, count_3, count_2, count_1;
 
 	/* Disabling Reset, LP and IRQC */
-	outb(RESET_LP_IRQC_DISABLE, chip->vendor.base + CMD);
+	tpm_data_out(RESET_LP_IRQC_DISABLE, CMD);
 
 	ret = empty_fifo(chip, 1);
 	if (ret) {
@@ -320,7 +368,7 @@ static void tpm_inf_cancel(struct tpm_ch
 
 static u8 tpm_inf_status(struct tpm_chip *chip)
 {
-	return inb(chip->vendor.base + STAT);
+	return tpm_data_in(STAT);
 }
 
 static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
@@ -381,51 +429,88 @@ static int __devinit tpm_inf_pnp_probe(s
 	/* read IO-ports through PnP */
 	if (pnp_port_valid(dev, 0) && pnp_port_valid(dev, 1) &&
 	    !(pnp_port_flags(dev, 0) & IORESOURCE_DISABLED)) {
-		TPM_INF_ADDR = pnp_port_start(dev, 0);
-		TPM_INF_ADDR_LEN = pnp_port_len(dev, 0);
-		TPM_INF_DATA = (TPM_INF_ADDR + 1);
-		TPM_INF_BASE = pnp_port_start(dev, 1);
-		TPM_INF_PORT_LEN = pnp_port_len(dev, 1);
-		if ((TPM_INF_PORT_LEN < 4) || (TPM_INF_ADDR_LEN < 2)) {
+
+	    	tpm_dev.iotype = TPM_INF_IO_PORT;
+
+		tpm_dev.config_port = pnp_port_start(dev, 0);
+		tpm_dev.config_size = pnp_port_len(dev, 0);
+		tpm_dev.data_regs = pnp_port_start(dev, 1);
+		tpm_dev.data_size = pnp_port_len(dev, 1);
+		if ((tpm_dev.data_size < 4) || (tpm_dev.config_size < 2)) {
 			rc = -EINVAL;
 			goto err_last;
 		}
 		dev_info(&dev->dev, "Found %s with ID %s\n",
 			 dev->name, dev_id->id);
-		if (!((TPM_INF_BASE >> 8) & 0xff)) {
+		if (!((tpm_dev.data_regs >> 8) & 0xff)) {
 			rc = -EINVAL;
 			goto err_last;
 		}
 		/* publish my base address and request region */
-		if (request_region
-		    (TPM_INF_BASE, TPM_INF_PORT_LEN, "tpm_infineon0") == NULL) {
+		if (request_region(tpm_dev.data_regs, tpm_dev.data_size,
+				   "tpm_infineon0") == NULL) {
 			rc = -EINVAL;
 			goto err_last;
 		}
-		if (request_region
-		    (TPM_INF_ADDR, TPM_INF_ADDR_LEN, "tpm_infineon0") == NULL) {
+		if (request_region(tpm_dev.config_port, tpm_dev.config_size,
+				   "tpm_infineon0") == NULL) {
+			release_region(tpm_dev.data_regs, tpm_dev.data_size);
 			rc = -EINVAL;
 			goto err_last;
 		}
+	} else if (pnp_mem_valid(dev, 0) &&
+	           !(pnp_mem_flags(dev, 0) & IORESOURCE_DISABLED)) {
+
+	    	tpm_dev.iotype = TPM_INF_IO_MEM;
+
+		tpm_dev.map_base = pnp_mem_start(dev, 0);
+		tpm_dev.map_size = pnp_mem_len(dev, 0);
+
+		dev_info(&dev->dev, "Found %s with ID %s\n",
+			 dev->name, dev_id->id);
+
+		/* publish my base address and request region */
+		if (request_mem_region(tpm_dev.map_base, tpm_dev.map_size,
+				       "tpm_infineon0") == NULL) {
+			rc = -EINVAL;
+			goto err_last;
+		}
+
+		tpm_dev.mem_base = ioremap(tpm_dev.map_base, tpm_dev.map_size);
+		if (tpm_dev.mem_base == NULL) {
+			release_mem_region(tpm_dev.map_base, tpm_dev.map_size);
+			rc = -EINVAL;
+			goto err_last;
+		}
+
+		/*
+		 * The only known MMIO based Infineon TPM system provides
+		 * a single large mem region with the device config
+		 * registers at the default TPM_ADDR.  The data registers
+		 * seem like they could be placed anywhere within the MMIO
+		 * region, but lets just put them at zero offset.
+		 */
+		tpm_dev.index_off = TPM_ADDR;
+		tpm_dev.data_regs = 0x0;
 	} else {
 		rc = -EINVAL;
 		goto err_last;
 	}
 
 	/* query chip for its vendor, its version number a.s.o. */
-	outb(ENABLE_REGISTER_PAIR, TPM_INF_ADDR);
-	outb(IDVENL, TPM_INF_ADDR);
-	vendorid[1] = inb(TPM_INF_DATA);
-	outb(IDVENH, TPM_INF_ADDR);
-	vendorid[0] = inb(TPM_INF_DATA);
-	outb(IDPDL, TPM_INF_ADDR);
-	productid[1] = inb(TPM_INF_DATA);
-	outb(IDPDH, TPM_INF_ADDR);
-	productid[0] = inb(TPM_INF_DATA);
-	outb(CHIP_ID1, TPM_INF_ADDR);
-	version[1] = inb(TPM_INF_DATA);
-	outb(CHIP_ID2, TPM_INF_ADDR);
-	version[0] = inb(TPM_INF_DATA);
+	tpm_config_out(ENABLE_REGISTER_PAIR, TPM_INF_ADDR);
+	tpm_config_out(IDVENL, TPM_INF_ADDR);
+	vendorid[1] = tpm_config_in(TPM_INF_DATA);
+	tpm_config_out(IDVENH, TPM_INF_ADDR);
+	vendorid[0] = tpm_config_in(TPM_INF_DATA);
+	tpm_config_out(IDPDL, TPM_INF_ADDR);
+	productid[1] = tpm_config_in(TPM_INF_DATA);
+	tpm_config_out(IDPDH, TPM_INF_ADDR);
+	productid[0] = tpm_config_in(TPM_INF_DATA);
+	tpm_config_out(CHIP_ID1, TPM_INF_ADDR);
+	version[1] = tpm_config_in(TPM_INF_DATA);
+	tpm_config_out(CHIP_ID2, TPM_INF_ADDR);
+	version[0] = tpm_config_in(TPM_INF_DATA);
 
 	switch ((productid[0] << 8) | productid[1]) {
 	case 6:
@@ -442,51 +527,54 @@ static int __devinit tpm_inf_pnp_probe(s
 	if ((vendorid[0] << 8 | vendorid[1]) == (TPM_INFINEON_DEV_VEN_VALUE)) {
 
 		/* configure TPM with IO-ports */
-		outb(IOLIMH, TPM_INF_ADDR);
-		outb(((TPM_INF_BASE >> 8) & 0xff), TPM_INF_DATA);
-		outb(IOLIML, TPM_INF_ADDR);
-		outb((TPM_INF_BASE & 0xff), TPM_INF_DATA);
+		tpm_config_out(IOLIMH, TPM_INF_ADDR);
+		tpm_config_out((tpm_dev.data_regs >> 8) & 0xff, TPM_INF_DATA);
+		tpm_config_out(IOLIML, TPM_INF_ADDR);
+		tpm_config_out((tpm_dev.data_regs & 0xff), TPM_INF_DATA);
 
 		/* control if IO-ports are set correctly */
-		outb(IOLIMH, TPM_INF_ADDR);
-		ioh = inb(TPM_INF_DATA);
-		outb(IOLIML, TPM_INF_ADDR);
-		iol = inb(TPM_INF_DATA);
+		tpm_config_out(IOLIMH, TPM_INF_ADDR);
+		ioh = tpm_config_in(TPM_INF_DATA);
+		tpm_config_out(IOLIML, TPM_INF_ADDR);
+		iol = tpm_config_in(TPM_INF_DATA);
 
-		if ((ioh << 8 | iol) != TPM_INF_BASE) {
+		if ((ioh << 8 | iol) != tpm_dev.data_regs) {
 			dev_err(&dev->dev,
-				"Could not set IO-ports to 0x%x\n",
-				TPM_INF_BASE);
+				"Could not set IO-data registers to 0x%x\n",
+				tpm_dev.data_regs);
 			rc = -EIO;
 			goto err_release_region;
 		}
 
 		/* activate register */
-		outb(TPM_DAR, TPM_INF_ADDR);
-		outb(0x01, TPM_INF_DATA);
-		outb(DISABLE_REGISTER_PAIR, TPM_INF_ADDR);
+		tpm_config_out(TPM_DAR, TPM_INF_ADDR);
+		tpm_config_out(0x01, TPM_INF_DATA);
+		tpm_config_out(DISABLE_REGISTER_PAIR, TPM_INF_ADDR);
 
 		/* disable RESET, LP and IRQC */
-		outb(RESET_LP_IRQC_DISABLE, TPM_INF_BASE + CMD);
+		tpm_data_out(RESET_LP_IRQC_DISABLE, CMD);
 
 		/* Finally, we're done, print some infos */
 		dev_info(&dev->dev, "TPM found: "
-			 "config base 0x%x, "
-			 "io base 0x%x, "
+			 "config base 0x%lx, "
+			 "data base 0x%lx, "
 			 "chip version 0x%02x%02x, "
 			 "vendor id 0x%x%x (Infineon), "
 			 "product id 0x%02x%02x"
 			 "%s\n",
-			 TPM_INF_ADDR,
-			 TPM_INF_BASE,
+			 tpm_dev.iotype == TPM_INF_IO_PORT ?
+				tpm_dev.config_port :
+				tpm_dev.map_base + tpm_dev.index_off,
+			 tpm_dev.iotype == TPM_INF_IO_PORT ?
+				tpm_dev.data_regs :
+				tpm_dev.map_base + tpm_dev.data_regs,
 			 version[0], version[1],
 			 vendorid[0], vendorid[1],
 			 productid[0], productid[1], chipname);
 
-		if (!(chip = tpm_register_hardware(&dev->dev, &tpm_inf))) {
+		if (!(chip = tpm_register_hardware(&dev->dev, &tpm_inf)))
 			goto err_release_region;
-		}
-		chip->vendor.base = TPM_INF_BASE;
+
 		return 0;
 	} else {
 		rc = -ENODEV;
@@ -494,8 +582,13 @@ static int __devinit tpm_inf_pnp_probe(s
 	}
 
 err_release_region:
-	release_region(TPM_INF_BASE, TPM_INF_PORT_LEN);
-	release_region(TPM_INF_ADDR, TPM_INF_ADDR_LEN);
+	if (tpm_dev.iotype == TPM_INF_IO_PORT) {
+		release_region(tpm_dev.data_regs, tpm_dev.data_size);
+		release_region(tpm_dev.config_port, tpm_dev.config_size);
+	} else {
+		iounmap(tpm_dev.mem_base);
+		release_mem_region(tpm_dev.map_base, tpm_dev.map_size);
+	}
 
 err_last:
 	return rc;
@@ -506,8 +599,14 @@ static __devexit void tpm_inf_pnp_remove
 	struct tpm_chip *chip = pnp_get_drvdata(dev);
 
 	if (chip) {
-		release_region(TPM_INF_BASE, TPM_INF_PORT_LEN);
-		release_region(TPM_INF_ADDR, TPM_INF_ADDR_LEN);
+		if (tpm_dev.iotype == TPM_INF_IO_PORT) {
+			release_region(tpm_dev.data_regs, tpm_dev.data_size);
+			release_region(tpm_dev.config_port,
+				       tpm_dev.config_size);
+		} else {
+			iounmap(tpm_dev.mem_base);
+			release_mem_region(tpm_dev.map_base, tpm_dev.map_size);
+		}
 		tpm_remove_hardware(chip->dev);
 	}
 }
@@ -539,5 +638,5 @@ module_exit(cleanup_inf);
 
 MODULE_AUTHOR("Marcel Selhorst <selhorst@crypto.rub.de>");
 MODULE_DESCRIPTION("Driver for Infineon TPM SLD 9630 TT 1.1 / SLB 9635 TT 1.2");
-MODULE_VERSION("1.8");
+MODULE_VERSION("1.9");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from alex.williamson@hp.com are

tpm_infineon-add-support-for-devices-in-mmio-space.patch
