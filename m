From: akpm@linux-foundation.org
Subject: + w1-add-1-wire-master-driver-for-imx27-imx31-update.patch added to -mm tree
Date: Fri, 21 Nov 2008 15:50:47 -0800
Message-ID: <200811212350.mALNolDW003928@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753568AbYKUXvv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 18:51:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: s.hauer@pengutronix.de, l.fu@pengutronix.de, rmk@arm.linux.org.uk, zbr@ioremap.net


The patch titled
     Add 1-wire master driver for i.MX27 / i.MX31 (update)
has been added to the -mm tree.  Its filename is
     w1-add-1-wire-master-driver-for-imx27-imx31-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add 1-wire master driver for i.MX27 / i.MX31 (update)
From: Sascha Hauer <s.hauer@pengutronix.de>

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/w1/masters/00-INDEX |    2 +
 Documentation/w1/masters/mxc-w1   |   11 +++++++
 drivers/w1/masters/mxc_w1.c       |   40 ++++++++++++----------------
 3 files changed, 31 insertions(+), 22 deletions(-)

diff -puN Documentation/w1/masters/00-INDEX~w1-add-1-wire-master-driver-for-imx27-imx31-update Documentation/w1/masters/00-INDEX
--- a/Documentation/w1/masters/00-INDEX~w1-add-1-wire-master-driver-for-imx27-imx31-update
+++ a/Documentation/w1/masters/00-INDEX
@@ -4,5 +4,7 @@ ds2482
 	- The Maxim/Dallas Semiconductor DS2482 provides 1-wire busses.
 ds2490
 	- The Maxim/Dallas Semiconductor DS2490 builds USB <-> W1 bridges.
+mxc_w1
+	- W1 master controller driver found on Freescale MX2/MX3 SoCs
 w1-gpio
 	- GPIO 1-wire bus master driver.
diff -puN /dev/null Documentation/w1/masters/mxc-w1
--- /dev/null
+++ a/Documentation/w1/masters/mxc-w1
@@ -0,0 +1,11 @@
+Kernel driver mxc_w1
+====================
+
+Supported chips:
+  * Freescale MX27, MX31 and probably other i.MX SoCs
+    Datasheets:
+        http://www.freescale.com/files/32bit/doc/data_sheet/MCIMX31.pdf?fpsp=1
+	http://www.freescale.com/files/dsp/MCIMX27.pdf?fpsp=1
+
+Author: Originally based on Freescale code, prepared for mainline by
+	Sascha Hauer <s.hauer@pengutronix.de>
diff -puN drivers/w1/masters/mxc_w1.c~w1-add-1-wire-master-driver-for-imx27-imx31-update drivers/w1/masters/mxc_w1.c
--- a/drivers/w1/masters/mxc_w1.c~w1-add-1-wire-master-driver-for-imx27-imx31-update
+++ a/drivers/w1/masters/mxc_w1.c
@@ -47,7 +47,7 @@ struct mxc_w1_device {
 	void __iomem *regs;
 	unsigned int clkdiv;
 	struct clk *clk;
-	struct w1_bus_master *bus_master;
+	struct w1_bus_master bus_master;
 };
 
 /*
@@ -57,10 +57,9 @@ struct mxc_w1_device {
  */
 static u8 mxc_w1_ds2_reset_bus(void *data)
 {
-	u8 reg_val, rc = 1;
+	u8 reg_val;
 	unsigned int timeout_cnt = 0;
-
-	struct mxc_w1_device *dev = (struct mxc_w1_device *)data;
+	struct mxc_w1_device *dev = data;
 
 	__raw_writeb(0x80, (dev->regs + MXC_W1_CONTROL));
 
@@ -68,10 +67,9 @@ static u8 mxc_w1_ds2_reset_bus(void *dat
 		reg_val = __raw_readb(dev->regs + MXC_W1_CONTROL);
 
 		if (((reg_val >> 7) & 0x1) == 0 ||
-		    timeout_cnt > MXC_W1_RESET_TIMEOUT) {
-			rc = 0;
+		    timeout_cnt > MXC_W1_RESET_TIMEOUT)
 			break;
-		} else
+		else
 			timeout_cnt++;
 
 		udelay(100);
@@ -86,10 +84,11 @@ static u8 mxc_w1_ds2_reset_bus(void *dat
  */
 static u8 mxc_w1_ds2_touch_bit(void *data, u8 bit)
 {
-	unsigned int timeout_cnt = 400;
-
-	struct mxc_w1_device *mdev = (struct mxc_w1_device *)data;
+	struct mxc_w1_device *mdev = data;
 	void __iomem *ctrl_addr = mdev->regs + MXC_W1_CONTROL;
+	unsigned int timeout_cnt = 400; /* Takes max. 120us according to
+					 * datasheet.
+					 */
 
 	__raw_writeb((1 << (5 - bit)), ctrl_addr);
 
@@ -103,7 +102,7 @@ static u8 mxc_w1_ds2_touch_bit(void *dat
 	return ((__raw_readb(ctrl_addr)) >> 3) & 0x1;
 }
 
-static int __devinit mxc_w1_probe(struct platform_device *pdev)
+static int __init mxc_w1_probe(struct platform_device *pdev)
 {
 	struct mxc_w1_device *mdev;
 	struct resource *res;
@@ -113,9 +112,7 @@ static int __devinit mxc_w1_probe(struct
 	if (!res)
 		return -ENODEV;
 
-	mdev = kzalloc(sizeof(struct mxc_w1_device) +
-		      sizeof(struct w1_bus_master), GFP_KERNEL);
-
+	mdev = kzalloc(sizeof(struct mxc_w1_device), GFP_KERNEL);
 	if (!mdev)
 		return -ENOMEM;
 
@@ -125,7 +122,6 @@ static int __devinit mxc_w1_probe(struct
 		goto failed_clk;
 	}
 
-	mdev->bus_master = (struct w1_bus_master *)(mdev + 1);
 	mdev->clkdiv = (clk_get_rate(mdev->clk) / 1000000) - 1;
 
 	res = request_mem_region(res->start, resource_size(res),
@@ -137,18 +133,18 @@ static int __devinit mxc_w1_probe(struct
 
 	mdev->regs = ioremap(res->start, resource_size(res));
 	if (!mdev->regs) {
-		printk(KERN_ERR"Cannot map frame buffer registers\n");
+		printk(KERN_ERR "Cannot map frame buffer registers\n");
 		goto failed_ioremap;
 	}
 
 	clk_enable(mdev->clk);
 	__raw_writeb(mdev->clkdiv, mdev->regs + MXC_W1_TIME_DIVIDER);
 
-	mdev->bus_master->data = mdev;
-	mdev->bus_master->reset_bus = &mxc_w1_ds2_reset_bus;
-	mdev->bus_master->touch_bit = &mxc_w1_ds2_touch_bit;
+	mdev->bus_master.data = mdev;
+	mdev->bus_master.reset_bus = mxc_w1_ds2_reset_bus;
+	mdev->bus_master.touch_bit = mxc_w1_ds2_touch_bit;
 
-	err = w1_add_master_device(mdev->bus_master);
+	err = w1_add_master_device(&mdev->bus_master);
 
 	if (err)
 		goto failed_add;
@@ -177,7 +173,7 @@ static int mxc_w1_remove(struct platform
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	w1_remove_master_device(mdev->bus_master);
+	w1_remove_master_device(&mdev->bus_master);
 
 	iounmap(mdev->regs);
 	release_mem_region(res->start, resource_size(res));
@@ -192,7 +188,7 @@ static int mxc_w1_remove(struct platform
 static struct platform_driver mxc_w1_driver = {
 	.driver = {
 		   .name = "mxc_w1",
-		   },
+	},
 	.probe = mxc_w1_probe,
 	.remove = mxc_w1_remove,
 };
_

Patches currently in -mm which might be from s.hauer@pengutronix.de are

mx2-add-w1-device-resources.patch
mx31-add-w1-platform_device-and-resources.patch
mx2-pcm038-add-1-wire-master-support.patch
pcm037-add-1wire-support.patch
w1-add-1-wire-master-driver-for-imx27-imx31.patch
w1-add-1-wire-master-driver-for-imx27-imx31-update.patch
w1-add-1-wire-master-driver-for-imx27-imx31-fix.patch

