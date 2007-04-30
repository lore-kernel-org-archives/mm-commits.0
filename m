From: akpm@linux-foundation.org
Subject: - mpc52xx-psc-spi-master-driver-update.patch removed from -mm tree
Date: Mon, 30 Apr 2007 13:15:21 -0700
Message-ID: <200704302015.l3UKFMrq013949@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030285AbXD3UQZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 16:16:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dragos.carp@toptica.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     mpc52xx-psc-spi-master-driver update
has been removed from the -mm tree.  Its filename was
     mpc52xx-psc-spi-master-driver-update.patch

This patch was dropped because it was folded into mpc52xx-psc-spi-master-driver.patch

------------------------------------------------------
Subject: mpc52xx-psc-spi-master-driver update
From: Dragos Carp <dragos.carp@toptica.com>

Related to your comments: I used the constants that were already defined
in the mpc52xx.h or mpc52xx_psc.h. I could define them there, but this
will be probably a different patch.
I chose the bus number starting with 0, because I wanted to use the same
rule as the mpc52xx_psc_uart driver, anyway using the OpenFirmware the
bus number will be dynamic allocated based on the order in the
configuration file.
I also changed the name of the driver according to
Documentation/powerpc/mpc52xx-device-tree-bindings.txt.

The newlines were inserted and the inline-s removed.

Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/mpc52xx_psc_spi.c |  235 ++++++++++++++++++++++++++++----
 1 file changed, 206 insertions(+), 29 deletions(-)

diff -puN drivers/spi/mpc52xx_psc_spi.c~mpc52xx-psc-spi-master-driver-update drivers/spi/mpc52xx_psc_spi.c
--- a/drivers/spi/mpc52xx_psc_spi.c~mpc52xx-psc-spi-master-driver-update
+++ a/drivers/spi/mpc52xx_psc_spi.c
@@ -15,7 +15,13 @@
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
+
+#if defined(CONFIG_PPC_MERGE)
+#include <asm/of_platform.h>
+#else
 #include <linux/platform_device.h>
+#endif
+
 #include <linux/workqueue.h>
 #include <linux/completion.h>
 #include <linux/io.h>
@@ -36,6 +42,7 @@ struct mpc52xx_psc_spi {
 
 	/* driver internal data */
 	struct mpc52xx_psc __iomem *psc;
+	unsigned int irq;
 	u8 bits_per_word;
 	u8 busy;
 
@@ -70,7 +77,7 @@ static int mpc52xx_psc_spi_transfer_setu
 	return 0;
 }
 
-static inline void mpc52xx_psc_spi_activate_cs(struct spi_device *spi)
+static void mpc52xx_psc_spi_activate_cs(struct spi_device *spi)
 {
 	struct mpc52xx_psc_spi_cs *cs = spi->controller_state;
 	struct mpc52xx_psc_spi *mps = spi_master_get_devdata(spi->master);
@@ -114,7 +121,7 @@ static inline void mpc52xx_psc_spi_activ
 				(spi->mode & SPI_CS_HIGH) ? 1 : 0);
 }
 
-static inline void mpc52xx_psc_spi_deactivate_cs(struct spi_device *spi)
+static void mpc52xx_psc_spi_deactivate_cs(struct spi_device *spi)
 {
 	struct mpc52xx_psc_spi *mps = spi_master_get_devdata(spi->master);
 
@@ -127,7 +134,7 @@ static inline void mpc52xx_psc_spi_deact
 /* wake up when 80% fifo full */
 #define MPC52xx_PSC_RFALARM (MPC52xx_PSC_BUFSIZE * 20 / 100)
 
-static inline int mpc52xx_psc_spi_transfer_rxtx(struct spi_device *spi,
+static int mpc52xx_psc_spi_transfer_rxtx(struct spi_device *spi,
 						struct spi_transfer *t)
 {
 	struct mpc52xx_psc_spi *mps = spi_master_get_devdata(spi->master);
@@ -309,21 +316,25 @@ static int mpc52xx_psc_spi_transfer(stru
 
 static void mpc52xx_psc_spi_cleanup(struct spi_device *spi)
 {
-	if (spi->controller_state)
-		kfree(spi->controller_state);
+	kfree(spi->controller_state);
 }
 
 static int mpc52xx_psc_spi_port_config(int psc_id, struct mpc52xx_psc_spi *mps)
 {
 	struct mpc52xx_cdm __iomem *cdm;
 	struct mpc52xx_gpio __iomem *gpio;
-	struct mpc52xx_psc __iomem *psc;
+	struct mpc52xx_psc __iomem *psc = mps->psc;
 	u32 ul;
 	u32 mclken_div;
 	int ret = 0;
 
+#if defined(CONFIG_PPC_MERGE)
+	cdm = mpc52xx_find_and_map("mpc52xx-cdm");
+	gpio = mpc52xx_find_and_map("mpc52xx-gpio");
+#else
 	cdm = ioremap(MPC52xx_PA(MPC52xx_CDM_OFFSET), MPC52xx_CDM_SIZE);
 	gpio = ioremap(MPC52xx_PA(MPC52xx_GPIO_OFFSET), MPC52xx_GPIO_SIZE);
+#endif
 	if (!cdm || !gpio) {
 		printk(KERN_ERR "Error mapping CDM/GPIO\n");
 		ret = -EFAULT;
@@ -379,14 +390,6 @@ static int mpc52xx_psc_spi_port_config(i
 		ret = -EINVAL;
 		goto unmap_regs;
 	}
-	psc = ioremap(MPC52xx_PA(MPC52xx_PSCx_OFFSET(psc_id)),
-			MPC52xx_PSC_SIZE);
-	if (!psc) {
-		printk(KERN_ERR "Error mapping PSC%d\n", psc_id);
-		ret = -EFAULT;
-		goto unmap_regs;
-	}
-	mps->psc = psc;
 
 	/* Reset the PSC into a known state */
 	out_8(&psc->command, MPC52xx_PSC_RST_RX);
@@ -399,7 +402,7 @@ static int mpc52xx_psc_spi_port_config(i
 	out_8(&psc->rfcntl, 0);
 	out_8(&psc->mode, MPC52xx_PSC_MODE_FFULL);
 
-	/* Configure 8bit codec mode as an SPI master and use EOF flags */
+	/* Configure 8bit codec mode as a SPI master and use EOF flags */
 	/* SICR_SIM_CODEC8|SICR_GENCLK|SICR_SPI|SICR_MSTR|SICR_USEEOF */
 	out_be32(&psc->sicr, 0x0180C800);
 	out_be16(&psc->ccr, 0x070F); /* by default SPI Clk 1MHz */
@@ -411,8 +414,10 @@ static int mpc52xx_psc_spi_port_config(i
 	mps->bits_per_word = 8;
 
 unmap_regs:
-	if (cdm)  iounmap(cdm);
-	if (gpio) iounmap(gpio);
+	if (cdm)
+		iounmap(cdm);
+	if (gpio)
+		iounmap(gpio);
 
 	return ret;
 }
@@ -431,12 +436,13 @@ static irqreturn_t mpc52xx_psc_spi_isr(i
 	return IRQ_NONE;
 }
 
+#if !defined(CONFIG_PPC_MERGE)
 static int __init mpc52xx_psc_spi_probe(struct platform_device *dev)
 {
 	struct fsl_spi_platform_data *pdata = dev->dev.platform_data;
 	struct mpc52xx_psc_spi *mps;
 	struct spi_master *master;
-	unsigned int irq = platform_get_irq(dev, 0);
+	struct mpc52xx_psc __iomem *psc;
 	int ret;
 
 	if (pdata == NULL)
@@ -459,14 +465,32 @@ static int __init mpc52xx_psc_spi_probe(
 	master->transfer = mpc52xx_psc_spi_transfer;
 	master->cleanup = mpc52xx_psc_spi_cleanup;
 
-	ret = mpc52xx_psc_spi_port_config(dev->id, mps);
-	if (ret < 0)
+	switch(dev->id) {
+	case 1: case 2: case 3: case 6:
+		break;
+	default:
+		ret = -EINVAL;
 		goto free_master;
+	}
+	psc = ioremap(MPC52xx_PA(MPC52xx_PSCx_OFFSET(dev->id)),
+			MPC52xx_PSC_SIZE);
+	if (!psc) {
+		printk(KERN_ERR "Error mapping PSC%d\n", dev->id);
+		ret = -EFAULT;
+		goto free_master;
+	}
+	mps->psc = psc;
 
-	ret = request_irq(irq, mpc52xx_psc_spi_isr, 0, "mpc52xx_psc_spi", mps);
+	mps->irq = platform_get_irq(dev, 0);
+	ret = request_irq(mps->irq, mpc52xx_psc_spi_isr, 0,
+				"mpc52xx-psc-spi", mps);
 	if (ret)
 		goto free_master;
 
+	ret = mpc52xx_psc_spi_port_config(dev->id, mps);
+	if (ret < 0)
+		goto free_irq;
+
 	spin_lock_init(&mps->lock);
 	init_completion(&mps->done);
 	INIT_WORK(&mps->work, mpc52xx_psc_spi_work);
@@ -476,7 +500,7 @@ static int __init mpc52xx_psc_spi_probe(
 		master->cdev.dev->bus_id);
 	if (mps->workqueue == NULL) {
 		ret = -EBUSY;
-		goto err_workq;
+		goto free_irq;
 	}
 
 	ret = spi_register_master(master);
@@ -487,10 +511,11 @@ static int __init mpc52xx_psc_spi_probe(
 
 unreg_master:
 	destroy_workqueue(mps->workqueue);
-err_workq:
-	free_irq(irq, mps);
+free_irq:
+	free_irq(mps->irq, mps);
 free_master:
-	if (mps->psc)  iounmap(mps->psc);
+	if (mps->psc)
+		iounmap(mps->psc);
 	spi_master_put(master);
 
 	return ret;
@@ -500,13 +525,13 @@ static int __exit mpc52xx_psc_spi_remove
 {
 	struct spi_master *master = platform_get_drvdata(dev);
 	struct mpc52xx_psc_spi *mps = spi_master_get_devdata(master);
-	unsigned int irq = platform_get_irq(dev, 0);
 
 	flush_workqueue(mps->workqueue);
 	destroy_workqueue(mps->workqueue);
 	spi_unregister_master(master);
-	free_irq(irq, mps);
-	if (mps->psc)  iounmap(mps->psc);
+	free_irq(mps->irq, mps);
+	if (mps->psc)
+		iounmap(mps->psc);
 
 	return 0;
 }
@@ -514,26 +539,178 @@ static int __exit mpc52xx_psc_spi_remove
 static struct platform_driver mpc52xx_psc_spi_platform_driver = {
 	.remove = __exit_p(mpc52xx_psc_spi_remove),
 	.driver = {
-		.name = "mpc52xx_psc_spi",
+		.name = "mpc52xx-psc-spi",
 		.owner = THIS_MODULE,
 	},
 };
+#endif	/* !defined(CONFIG_PPC_MERGE) */
 
 
+#if defined(CONFIG_PPC_MERGE)
+static int __init mpc52xx_psc_spi_of_probe(struct of_device *op,
+	const struct of_device_id *match)
+{
+	struct device *dev = &op->dev;
+	struct fsl_spi_platform_data *pdata = dev->platform_data;
+	struct mpc52xx_psc_spi *mps;
+	struct spi_master *master;
+	int ret;
+	const u32 *regaddr_p;
+	u64 regaddr64, size64;
+	struct mpc52xx_psc __iomem *psc;
+
+	if (dev == NULL)
+		return -ENODEV;
+
+	master = spi_alloc_master(dev, sizeof *mps);
+	if (master == NULL)
+		return -ENOMEM;
+	dev_set_drvdata(dev, master);
+	mps = spi_master_get_devdata(master);
+
+	regaddr_p = of_get_address(op->node, 0, &size64, NULL);
+	if (!regaddr_p) {
+		printk(KERN_ERR "Invalid PSC address\n");
+		ret = -EINVAL;
+		goto free_master;
+	}
+	regaddr64 = of_translate_address(op->node, regaddr_p);
+	psc = ioremap((u32)regaddr64, (u32)size64);
+	if (!psc) {
+		printk(KERN_ERR "Error mapping memory at %x (%x bytes)\n",
+			(u32)regaddr64, (u32)size64);
+		ret = -EFAULT;
+		goto free_master;
+	}
+	mps->psc = psc;
+
+	mps->irq = irq_of_parse_and_map(op->node, 0);
+	ret = request_irq(mps->irq, mpc52xx_psc_spi_isr, 0,
+				"mpc52xx-psc-spi", mps);
+	if (ret)
+		goto free_master;
+
+	if (pdata == NULL) {
+		struct device_node *np;
+		int i = 0;
+
+		dev_warn(dev, "probe called without platform data, no "
+				"(de)activate_cs function will be called\n");
+
+		mps->activate_cs = NULL;
+		mps->deactivate_cs = NULL;
+		mps->sysclk = 0;
+		master->bus_num = -1;
+		for_each_node_by_type(np, "spi") {
+			if (of_find_device_by_node(np) == op) {
+				master->bus_num = i;
+				break;
+			}
+			i++;
+		}
+		master->num_chipselect = 255;
+	} else {
+		mps->activate_cs = pdata->activate_cs;
+		mps->deactivate_cs = pdata->deactivate_cs;
+		mps->sysclk = pdata->sysclk;
+		master->bus_num = pdata->bus_num;
+		master->num_chipselect = pdata->max_chipselect;
+	}
+	master->setup = mpc52xx_psc_spi_setup;
+	master->transfer = mpc52xx_psc_spi_transfer;
+	master->cleanup = mpc52xx_psc_spi_cleanup;
+
+	ret = mpc52xx_psc_spi_port_config(master->bus_num, mps);
+	if (ret < 0)
+		goto free_irq;
+
+	spin_lock_init(&mps->lock);
+	init_completion(&mps->done);
+	INIT_WORK(&mps->work, mpc52xx_psc_spi_work);
+	INIT_LIST_HEAD(&mps->queue);
+
+	mps->workqueue = create_singlethread_workqueue(
+		master->cdev.dev->bus_id);
+	if (mps->workqueue == NULL) {
+		ret = -EBUSY;
+		goto free_irq;
+	}
+
+	ret = spi_register_master(master);
+	if (ret < 0)
+		goto unreg_master;
+
+	return ret;
+
+unreg_master:
+	destroy_workqueue(mps->workqueue);
+free_irq:
+	free_irq(mps->irq, mps);
+free_master:
+	if (mps->psc)
+		iounmap(mps->psc);
+	spi_master_put(master);
+
+	return ret;
+}
+
+static int __exit mpc52xx_psc_spi_of_remove(struct of_device *op)
+{
+	struct spi_master *master = dev_get_drvdata(&op->dev);
+	struct mpc52xx_psc_spi *mps = spi_master_get_devdata(master);
+
+	flush_workqueue(mps->workqueue);
+	destroy_workqueue(mps->workqueue);
+	spi_unregister_master(master);
+	free_irq(mps->irq, mps);
+	if (mps->psc)
+		iounmap(mps->psc);
+
+	return 0;
+}
+
+static struct of_device_id mpc52xx_psc_spi_of_match[] = {
+	{ .type = "spi", .compatible = "mpc52xx-psc-spi", },
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, mpc52xx_psc_spi_of_match);
+
+static struct of_platform_driver mpc52xx_psc_spi_of_driver = {
+	.owner = THIS_MODULE,
+	.name = "mpc52xx-psc-spi",
+	.match_table = mpc52xx_psc_spi_of_match,
+	.probe = mpc52xx_psc_spi_of_probe,
+	.remove = __exit_p(mpc52xx_psc_spi_of_remove),
+	.driver = {
+		.name = "mpc52xx-psc-spi",
+		.owner = THIS_MODULE,
+	},
+};
+#endif	/* defined(CONFIG_PPC_MERGE) */
+
 /* ======================================================================== */
 /* Module                                                                   */
 /* ======================================================================== */
 
 static int __init mpc52xx_psc_spi_init(void)
 {
+#if defined(CONFIG_PPC_MERGE)
+	return of_register_platform_driver(&mpc52xx_psc_spi_of_driver);
+#else
 	return platform_driver_probe(&mpc52xx_psc_spi_platform_driver,
 			mpc52xx_psc_spi_probe);
+#endif
 }
 module_init(mpc52xx_psc_spi_init);
 
 static void __exit mpc52xx_psc_spi_exit(void)
 {
+#if defined(CONFIG_PPC_MERGE)
+	of_unregister_platform_driver(&mpc52xx_psc_spi_of_driver);
+#else
 	platform_driver_unregister(&mpc52xx_psc_spi_platform_driver);
+#endif
 }
 module_exit(mpc52xx_psc_spi_exit);
 
_

Patches currently in -mm which might be from dragos.carp@toptica.com are

mpc52xx-psc-spi-master-driver.patch
mpc52xx-psc-spi-master-driver-update.patch
