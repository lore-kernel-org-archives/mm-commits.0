From: akpm@linux-foundation.org
Subject: [merged] spi_mpc83xx-add-of-platform-driver-bindings.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:41:27 -0700
Message-ID: <200904011841.n31IfRTu009350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934139AbZDATsJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:48:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, benh@kernel.crashing.org, david-b@pacbell.net, galak@gate.crashing.org, grant.likely@secretlab.ca, mm-commits@vger.kernel.org


The patch titled
     spi_mpc83xx: add OF platform driver bindings
has been removed from the -mm tree.  Its filename was
     spi_mpc83xx-add-of-platform-driver-bindings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_mpc83xx: add OF platform driver bindings
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Implement full support for OF SPI bindings.  Now the driver can manage its
own chip selects without any help from the board files and/or fsl_soc
constructors.

The "legacy" code is well isolated and could be removed as time goes by.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_mpc83xx.c   |  330 ++++++++++++++++++++++++++++++----
 include/linux/fsl_devices.h |    2 
 2 files changed, 295 insertions(+), 37 deletions(-)

diff -puN drivers/spi/spi_mpc83xx.c~spi_mpc83xx-add-of-platform-driver-bindings drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi_mpc83xx-add-of-platform-driver-bindings
+++ a/drivers/spi/spi_mpc83xx.c
@@ -14,6 +14,8 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/err.h>
 #include <linux/completion.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
@@ -23,7 +25,13 @@
 #include <linux/spi/spi_bitbang.h>
 #include <linux/platform_device.h>
 #include <linux/fsl_devices.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/gpio.h>
+#include <linux/of_gpio.h>
+#include <linux/of_spi.h>
 
+#include <sysdev/fsl_soc.h>
 #include <asm/irq.h>
 #include <asm/io.h>
 
@@ -79,7 +87,7 @@ struct mpc83xx_spi {
 	u32(*get_tx) (struct mpc83xx_spi *);
 
 	unsigned int count;
-	int irq;
+	unsigned int irq;
 
 	unsigned nsecs;		/* (clock cycle time)/2 */
 
@@ -543,36 +551,23 @@ static void mpc83xx_spi_cleanup(struct s
 	kfree(spi->controller_state);
 }
 
-static int __init mpc83xx_spi_probe(struct platform_device *dev)
+static struct spi_master * __devinit
+mpc83xx_spi_probe(struct device *dev, struct resource *mem, unsigned int irq)
 {
+	struct fsl_spi_platform_data *pdata = dev->platform_data;
 	struct spi_master *master;
 	struct mpc83xx_spi *mpc83xx_spi;
-	struct fsl_spi_platform_data *pdata;
-	struct resource *r;
 	u32 regval;
 	int ret = 0;
 
-	/* Get resources(memory, IRQ) associated with the device */
-	master = spi_alloc_master(&dev->dev, sizeof(struct mpc83xx_spi));
-
+	master = spi_alloc_master(dev, sizeof(struct mpc83xx_spi));
 	if (master == NULL) {
 		ret = -ENOMEM;
 		goto err;
 	}
 
-	platform_set_drvdata(dev, master);
-	pdata = dev->dev.platform_data;
-
-	if (pdata == NULL) {
-		ret = -ENODEV;
-		goto free_master;
-	}
+	dev_set_drvdata(dev, master);
 
-	r = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	if (r == NULL) {
-		ret = -ENODEV;
-		goto free_master;
-	}
 	master->setup = mpc83xx_spi_setup;
 	master->transfer = mpc83xx_spi_transfer;
 	master->cleanup = mpc83xx_spi_cleanup;
@@ -592,18 +587,13 @@ static int __init mpc83xx_spi_probe(stru
 
 	init_completion(&mpc83xx_spi->done);
 
-	mpc83xx_spi->base = ioremap(r->start, r->end - r->start + 1);
+	mpc83xx_spi->base = ioremap(mem->start, mem->end - mem->start + 1);
 	if (mpc83xx_spi->base == NULL) {
 		ret = -ENOMEM;
 		goto put_master;
 	}
 
-	mpc83xx_spi->irq = platform_get_irq(dev, 0);
-
-	if (mpc83xx_spi->irq < 0) {
-		ret = -ENXIO;
-		goto unmap_io;
-	}
+	mpc83xx_spi->irq = irq;
 
 	/* Register for SPI Interrupt */
 	ret = request_irq(mpc83xx_spi->irq, mpc83xx_spi_irq,
@@ -645,9 +635,9 @@ static int __init mpc83xx_spi_probe(stru
 
 	printk(KERN_INFO
 	       "%s: MPC83xx SPI Controller driver at 0x%p (irq = %d)\n",
-	       dev_name(&dev->dev), mpc83xx_spi->base, mpc83xx_spi->irq);
+	       dev_name(dev), mpc83xx_spi->base, mpc83xx_spi->irq);
 
-	return ret;
+	return master;
 
 unreg_master:
 	destroy_workqueue(mpc83xx_spi->workqueue);
@@ -657,18 +647,16 @@ unmap_io:
 	iounmap(mpc83xx_spi->base);
 put_master:
 	spi_master_put(master);
-free_master:
-	kfree(master);
 err:
-	return ret;
+	return ERR_PTR(ret);
 }
 
-static int __exit mpc83xx_spi_remove(struct platform_device *dev)
+static int __devexit mpc83xx_spi_remove(struct device *dev)
 {
 	struct mpc83xx_spi *mpc83xx_spi;
 	struct spi_master *master;
 
-	master = platform_get_drvdata(dev);
+	master = dev_get_drvdata(dev);
 	mpc83xx_spi = spi_master_get_devdata(master);
 
 	flush_workqueue(mpc83xx_spi->workqueue);
@@ -681,23 +669,293 @@ static int __exit mpc83xx_spi_remove(str
 	return 0;
 }
 
+struct mpc83xx_spi_probe_info {
+	struct fsl_spi_platform_data pdata;
+	int *gpios;
+	bool *alow_flags;
+};
+
+static struct mpc83xx_spi_probe_info *
+to_of_pinfo(struct fsl_spi_platform_data *pdata)
+{
+	return container_of(pdata, struct mpc83xx_spi_probe_info, pdata);
+}
+
+static void mpc83xx_spi_cs_control(struct spi_device *spi, bool on)
+{
+	struct device *dev = spi->dev.parent;
+	struct mpc83xx_spi_probe_info *pinfo = to_of_pinfo(dev->platform_data);
+	u16 cs = spi->chip_select;
+	int gpio = pinfo->gpios[cs];
+	bool alow = pinfo->alow_flags[cs];
+
+	gpio_set_value(gpio, on ^ alow);
+}
+
+static int of_mpc83xx_spi_get_chipselects(struct device *dev)
+{
+	struct device_node *np = dev_archdata_get_node(&dev->archdata);
+	struct fsl_spi_platform_data *pdata = dev->platform_data;
+	struct mpc83xx_spi_probe_info *pinfo = to_of_pinfo(pdata);
+	unsigned int ngpios;
+	int i = 0;
+	int ret;
+
+	ngpios = of_gpio_count(np);
+	if (!ngpios) {
+		/*
+		 * SPI w/o chip-select line. One SPI device is still permitted
+		 * though.
+		 */
+		pdata->max_chipselect = 1;
+		return 0;
+	}
+
+	pinfo->gpios = kmalloc(ngpios * sizeof(pinfo->gpios), GFP_KERNEL);
+	if (!pinfo->gpios)
+		return -ENOMEM;
+	memset(pinfo->gpios, -1, ngpios * sizeof(pinfo->gpios));
+
+	pinfo->alow_flags = kzalloc(ngpios * sizeof(pinfo->alow_flags),
+				    GFP_KERNEL);
+	if (!pinfo->alow_flags) {
+		ret = -ENOMEM;
+		goto err_alloc_flags;
+	}
+
+	for (; i < ngpios; i++) {
+		int gpio;
+		enum of_gpio_flags flags;
+
+		gpio = of_get_gpio_flags(np, i, &flags);
+		if (!gpio_is_valid(gpio)) {
+			dev_err(dev, "invalid gpio #%d: %d\n", i, gpio);
+			goto err_loop;
+		}
+
+		ret = gpio_request(gpio, dev_name(dev));
+		if (ret) {
+			dev_err(dev, "can't request gpio #%d: %d\n", i, ret);
+			goto err_loop;
+		}
+
+		pinfo->gpios[i] = gpio;
+		pinfo->alow_flags[i] = flags & OF_GPIO_ACTIVE_LOW;
+
+		ret = gpio_direction_output(pinfo->gpios[i],
+					    pinfo->alow_flags[i]);
+		if (ret) {
+			dev_err(dev, "can't set output direction for gpio "
+				"#%d: %d\n", i, ret);
+			goto err_loop;
+		}
+	}
+
+	pdata->max_chipselect = ngpios;
+	pdata->cs_control = mpc83xx_spi_cs_control;
+
+	return 0;
+
+err_loop:
+	while (i >= 0) {
+		if (gpio_is_valid(pinfo->gpios[i]))
+			gpio_free(pinfo->gpios[i]);
+		i--;
+	}
+
+	kfree(pinfo->alow_flags);
+	pinfo->alow_flags = NULL;
+err_alloc_flags:
+	kfree(pinfo->gpios);
+	pinfo->gpios = NULL;
+	return ret;
+}
+
+static int of_mpc83xx_spi_free_chipselects(struct device *dev)
+{
+	struct fsl_spi_platform_data *pdata = dev->platform_data;
+	struct mpc83xx_spi_probe_info *pinfo = to_of_pinfo(pdata);
+	int i;
+
+	if (!pinfo->gpios)
+		return 0;
+
+	for (i = 0; i < pdata->max_chipselect; i++) {
+		if (gpio_is_valid(pinfo->gpios[i]))
+			gpio_free(pinfo->gpios[i]);
+	}
+
+	kfree(pinfo->gpios);
+	kfree(pinfo->alow_flags);
+	return 0;
+}
+
+static int __devinit of_mpc83xx_spi_probe(struct of_device *ofdev,
+					  const struct of_device_id *ofid)
+{
+	struct device *dev = &ofdev->dev;
+	struct device_node *np = ofdev->node;
+	struct mpc83xx_spi_probe_info *pinfo;
+	struct fsl_spi_platform_data *pdata;
+	struct spi_master *master;
+	struct resource mem;
+	struct resource irq;
+	const void *prop;
+	int ret = -ENOMEM;
+
+	pinfo = kzalloc(sizeof(*pinfo), GFP_KERNEL);
+	if (!pinfo)
+		return -ENOMEM;
+
+	pdata = &pinfo->pdata;
+	dev->platform_data = pdata;
+
+	/* Allocate bus num dynamically. */
+	pdata->bus_num = -1;
+
+	/* SPI controller is either clocked from QE or SoC clock. */
+	pdata->sysclk = get_brgfreq();
+	if (pdata->sysclk == -1) {
+		pdata->sysclk = fsl_get_sys_freq();
+		if (pdata->sysclk == -1) {
+			ret = -ENODEV;
+			goto err_clk;
+		}
+	}
+
+	prop = of_get_property(np, "mode", NULL);
+	if (prop && !strcmp(prop, "cpu-qe"))
+		pdata->qe_mode = 1;
+
+	ret = of_mpc83xx_spi_get_chipselects(dev);
+	if (ret)
+		goto err;
+
+	ret = of_address_to_resource(np, 0, &mem);
+	if (ret)
+		goto err;
+
+	ret = of_irq_to_resource(np, 0, &irq);
+	if (!ret) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	master = mpc83xx_spi_probe(dev, &mem, irq.start);
+	if (IS_ERR(master)) {
+		ret = PTR_ERR(master);
+		goto err;
+	}
+
+	of_register_spi_devices(master, np);
+
+	return 0;
+
+err:
+	of_mpc83xx_spi_free_chipselects(dev);
+err_clk:
+	kfree(pinfo);
+	return ret;
+}
+
+static int __devexit of_mpc83xx_spi_remove(struct of_device *ofdev)
+{
+	int ret;
+
+	ret = mpc83xx_spi_remove(&ofdev->dev);
+	if (ret)
+		return ret;
+	of_mpc83xx_spi_free_chipselects(&ofdev->dev);
+	return 0;
+}
+
+static const struct of_device_id of_mpc83xx_spi_match[] = {
+	{ .compatible = "fsl,spi" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, of_mpc83xx_spi_match);
+
+static struct of_platform_driver of_mpc83xx_spi_driver = {
+	.name		= "mpc83xx_spi",
+	.match_table	= of_mpc83xx_spi_match,
+	.probe		= of_mpc83xx_spi_probe,
+	.remove		= __devexit_p(of_mpc83xx_spi_remove),
+};
+
+#ifdef CONFIG_MPC832x_RDB
+/*
+ * 				XXX XXX XXX
+ * This is "legacy" platform driver, was used by the MPC8323E-RDB boards
+ * only. The driver should go away soon, since newer MPC8323E-RDB's device
+ * tree can work with OpenFirmware driver. But for now we support old trees
+ * as well.
+ */
+static int __devinit plat_mpc83xx_spi_probe(struct platform_device *pdev)
+{
+	struct resource *mem;
+	unsigned int irq;
+	struct spi_master *master;
+
+	if (!pdev->dev.platform_data)
+		return -EINVAL;
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem)
+		return -EINVAL;
+
+	irq = platform_get_irq(pdev, 0);
+	if (!irq)
+		return -EINVAL;
+
+	master = mpc83xx_spi_probe(&pdev->dev, mem, irq);
+	if (IS_ERR(master))
+		return PTR_ERR(master);
+	return 0;
+}
+
+static int __devexit plat_mpc83xx_spi_remove(struct platform_device *pdev)
+{
+	return mpc83xx_spi_remove(&pdev->dev);
+}
+
 MODULE_ALIAS("platform:mpc83xx_spi");
 static struct platform_driver mpc83xx_spi_driver = {
-	.remove = __exit_p(mpc83xx_spi_remove),
+	.probe = plat_mpc83xx_spi_probe,
+	.remove = __exit_p(plat_mpc83xx_spi_remove),
 	.driver = {
 		.name = "mpc83xx_spi",
 		.owner = THIS_MODULE,
 	},
 };
 
+static bool legacy_driver_failed;
+
+static void __init legacy_driver_register(void)
+{
+	legacy_driver_failed = platform_driver_register(&mpc83xx_spi_driver);
+}
+
+static void __exit legacy_driver_unregister(void)
+{
+	if (legacy_driver_failed)
+		return;
+	platform_driver_unregister(&mpc83xx_spi_driver);
+}
+#else
+static void __init legacy_driver_register(void) {}
+static void __exit legacy_driver_unregister(void) {}
+#endif /* CONFIG_MPC832x_RDB */
+
 static int __init mpc83xx_spi_init(void)
 {
-	return platform_driver_probe(&mpc83xx_spi_driver, mpc83xx_spi_probe);
+	legacy_driver_register();
+	return of_register_platform_driver(&of_mpc83xx_spi_driver);
 }
 
 static void __exit mpc83xx_spi_exit(void)
 {
-	platform_driver_unregister(&mpc83xx_spi_driver);
+	of_unregister_platform_driver(&of_mpc83xx_spi_driver);
+	legacy_driver_unregister();
 }
 
 module_init(mpc83xx_spi_init);
diff -puN include/linux/fsl_devices.h~spi_mpc83xx-add-of-platform-driver-bindings include/linux/fsl_devices.h
--- a/include/linux/fsl_devices.h~spi_mpc83xx-add-of-platform-driver-bindings
+++ a/include/linux/fsl_devices.h
@@ -99,7 +99,7 @@ struct spi_device;
 
 struct fsl_spi_platform_data {
 	u32 	initial_spmode;	/* initial SPMODE value */
-	u16	bus_num;
+	s16	bus_num;
 	bool	qe_mode;
 	/* board specific information */
 	u16	max_chipselect;
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch

