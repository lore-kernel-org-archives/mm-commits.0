From: akpm@linux-foundation.org
Subject: + mpc52xx-psc-spi-master-driver-update.patch added to -mm tree
Date: Wed, 09 May 2007 03:25:46 -0700
Message-ID: <200705091025.l49APkOM021278@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757512AbXEIK0Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 06:26:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dragos.carp@toptica.com, david-b@pacbell.net


The patch titled
     MPC52xx PSC SPI master driver (update)
has been added to the -mm tree.  Its filename is
     mpc52xx-psc-spi-master-driver-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MPC52xx PSC SPI master driver (update)
From: Dragos Carp <dragos.carp@toptica.com>

Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/mpc52xx_psc_spi.c |  210 ++++++++++----------------------
 1 file changed, 71 insertions(+), 139 deletions(-)

diff -puN drivers/spi/mpc52xx_psc_spi.c~mpc52xx-psc-spi-master-driver-update drivers/spi/mpc52xx_psc_spi.c
--- a/drivers/spi/mpc52xx_psc_spi.c~mpc52xx-psc-spi-master-driver-update
+++ a/drivers/spi/mpc52xx_psc_spi.c
@@ -436,58 +436,58 @@ static irqreturn_t mpc52xx_psc_spi_isr(i
 	return IRQ_NONE;
 }
 
-#if !defined(CONFIG_PPC_MERGE)
-static int __init mpc52xx_psc_spi_probe(struct platform_device *dev)
+/* bus_num is used only for the case dev->platform_data == NULL */
+static int __init mpc52xx_psc_spi_do_probe(struct device *dev, u32 regaddr,
+				u32 size, unsigned int irq, s16 bus_num)
 {
-	struct fsl_spi_platform_data *pdata = dev->dev.platform_data;
+	struct fsl_spi_platform_data *pdata = dev->platform_data;
 	struct mpc52xx_psc_spi *mps;
 	struct spi_master *master;
-	struct mpc52xx_psc __iomem *psc;
 	int ret;
 
 	if (pdata == NULL)
 		return -ENODEV;
 
-	master = spi_alloc_master(&dev->dev, sizeof *mps);
+	master = spi_alloc_master(dev, sizeof *mps);
 	if (master == NULL)
 		return -ENOMEM;
 
-	platform_set_drvdata(dev, master);
-
+	dev_set_drvdata(dev, master);
 	mps = spi_master_get_devdata(master);
-	mps->activate_cs = pdata->activate_cs;
-	mps->deactivate_cs = pdata->deactivate_cs;
-	mps->sysclk = pdata->sysclk;
 
-	master->bus_num = dev->id = pdata->bus_num;
-	master->num_chipselect = pdata->max_chipselect;
+	mps->irq = irq;
+	if (pdata == NULL) {
+		dev_warn(dev, "probe called without platform data, no "
+				"(de)activate_cs function will be called\n");
+		mps->activate_cs = NULL;
+		mps->deactivate_cs = NULL;
+		mps->sysclk = 0;
+		master->bus_num = bus_num;
+		master->num_chipselect = 255;
+	} else {
+		mps->activate_cs = pdata->activate_cs;
+		mps->deactivate_cs = pdata->deactivate_cs;
+		mps->sysclk = pdata->sysclk;
+		master->bus_num = pdata->bus_num;
+		master->num_chipselect = pdata->max_chipselect;
+	}
 	master->setup = mpc52xx_psc_spi_setup;
 	master->transfer = mpc52xx_psc_spi_transfer;
 	master->cleanup = mpc52xx_psc_spi_cleanup;
 
-	switch(dev->id) {
-	case 1: case 2: case 3: case 6:
-		break;
-	default:
-		ret = -EINVAL;
-		goto free_master;
-	}
-	psc = ioremap(MPC52xx_PA(MPC52xx_PSCx_OFFSET(dev->id)),
-			MPC52xx_PSC_SIZE);
-	if (!psc) {
-		printk(KERN_ERR "Error mapping PSC%d\n", dev->id);
+	mps->psc = ioremap(regaddr, size);
+	if (!mps->psc) {
+		dev_err(dev, "could not ioremap I/O port range\n");
 		ret = -EFAULT;
 		goto free_master;
 	}
-	mps->psc = psc;
 
-	mps->irq = platform_get_irq(dev, 0);
-	ret = request_irq(mps->irq, mpc52xx_psc_spi_isr, 0,
-				"mpc52xx-psc-spi", mps);
+	ret = request_irq(mps->irq, mpc52xx_psc_spi_isr, 0, "mpc52xx-psc-spi",
+				mps);
 	if (ret)
 		goto free_master;
 
-	ret = mpc52xx_psc_spi_port_config(dev->id, mps);
+	ret = mpc52xx_psc_spi_port_config(master->bus_num, mps);
 	if (ret < 0)
 		goto free_irq;
 
@@ -521,9 +521,9 @@ free_master:
 	return ret;
 }
 
-static int __exit mpc52xx_psc_spi_remove(struct platform_device *dev)
+static int __exit mpc52xx_psc_spi_do_remove(struct device *dev)
 {
-	struct spi_master *master = platform_get_drvdata(dev);
+	struct spi_master *master = dev_get_drvdata(dev);
 	struct mpc52xx_psc_spi *mps = spi_master_get_devdata(master);
 
 	flush_workqueue(mps->workqueue);
@@ -536,6 +536,24 @@ static int __exit mpc52xx_psc_spi_remove
 	return 0;
 }
 
+#if !defined(CONFIG_PPC_MERGE)
+static int __init mpc52xx_psc_spi_probe(struct platform_device *dev)
+{
+	switch(dev->id) {
+	case 1: case 2: case 3: case 6:
+		return mpc52xx_psc_spi_do_probe(&dev->dev,
+			MPC52xx_PA(MPC52xx_PSCx_OFFSET(dev->id)),
+			MPC52xx_PSC_SIZE, platform_get_irq(dev, 0), dev->id);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int __exit mpc52xx_psc_spi_remove(struct platform_device *dev)
+{
+	return mpc52xx_psc_spi_do_remove(&dev->dev);
+}
+
 static struct platform_driver mpc52xx_psc_spi_platform_driver = {
 	.remove = __exit_p(mpc52xx_psc_spi_remove),
 	.driver = {
@@ -543,130 +561,56 @@ static struct platform_driver mpc52xx_ps
 		.owner = THIS_MODULE,
 	},
 };
-#endif	/* !defined(CONFIG_PPC_MERGE) */
 
+static int __init mpc52xx_psc_spi_init(void)
+{
+	return platform_driver_probe(&mpc52xx_psc_spi_platform_driver,
+			mpc52xx_psc_spi_probe);
+}
+module_init(mpc52xx_psc_spi_init);
+
+static void __exit mpc52xx_psc_spi_exit(void)
+{
+	platform_driver_unregister(&mpc52xx_psc_spi_platform_driver);
+}
+module_exit(mpc52xx_psc_spi_exit);
+
+#else	/* defined(CONFIG_PPC_MERGE) */
 
-#if defined(CONFIG_PPC_MERGE)
 static int __init mpc52xx_psc_spi_of_probe(struct of_device *op,
 	const struct of_device_id *match)
 {
-	struct device *dev = &op->dev;
-	struct fsl_spi_platform_data *pdata = dev->platform_data;
-	struct mpc52xx_psc_spi *mps;
-	struct spi_master *master;
-	int ret;
 	const u32 *regaddr_p;
 	u64 regaddr64, size64;
-	struct mpc52xx_psc __iomem *psc;
-
-	if (dev == NULL)
-		return -ENODEV;
-
-	master = spi_alloc_master(dev, sizeof *mps);
-	if (master == NULL)
-		return -ENOMEM;
-	dev_set_drvdata(dev, master);
-	mps = spi_master_get_devdata(master);
+	s16 id = -1;
 
 	regaddr_p = of_get_address(op->node, 0, &size64, NULL);
 	if (!regaddr_p) {
 		printk(KERN_ERR "Invalid PSC address\n");
-		ret = -EINVAL;
-		goto free_master;
+		return -EINVAL;
 	}
 	regaddr64 = of_translate_address(op->node, regaddr_p);
-	psc = ioremap((u32)regaddr64, (u32)size64);
-	if (!psc) {
-		printk(KERN_ERR "Error mapping memory at %x (%x bytes)\n",
-			(u32)regaddr64, (u32)size64);
-		ret = -EFAULT;
-		goto free_master;
-	}
-	mps->psc = psc;
 
-	mps->irq = irq_of_parse_and_map(op->node, 0);
-	ret = request_irq(mps->irq, mpc52xx_psc_spi_isr, 0,
-				"mpc52xx-psc-spi", mps);
-	if (ret)
-		goto free_master;
-
-	if (pdata == NULL) {
+	if (op->dev.platform_data == NULL) {
 		struct device_node *np;
 		int i = 0;
 
-		dev_warn(dev, "probe called without platform data, no "
-				"(de)activate_cs function will be called\n");
-
-		mps->activate_cs = NULL;
-		mps->deactivate_cs = NULL;
-		mps->sysclk = 0;
-		master->bus_num = -1;
 		for_each_node_by_type(np, "spi") {
 			if (of_find_device_by_node(np) == op) {
-				master->bus_num = i;
+				id = i;
 				break;
 			}
 			i++;
 		}
-		master->num_chipselect = 255;
-	} else {
-		mps->activate_cs = pdata->activate_cs;
-		mps->deactivate_cs = pdata->deactivate_cs;
-		mps->sysclk = pdata->sysclk;
-		master->bus_num = pdata->bus_num;
-		master->num_chipselect = pdata->max_chipselect;
 	}
-	master->setup = mpc52xx_psc_spi_setup;
-	master->transfer = mpc52xx_psc_spi_transfer;
-	master->cleanup = mpc52xx_psc_spi_cleanup;
 
-	ret = mpc52xx_psc_spi_port_config(master->bus_num, mps);
-	if (ret < 0)
-		goto free_irq;
-
-	spin_lock_init(&mps->lock);
-	init_completion(&mps->done);
-	INIT_WORK(&mps->work, mpc52xx_psc_spi_work);
-	INIT_LIST_HEAD(&mps->queue);
-
-	mps->workqueue = create_singlethread_workqueue(
-		master->cdev.dev->bus_id);
-	if (mps->workqueue == NULL) {
-		ret = -EBUSY;
-		goto free_irq;
-	}
-
-	ret = spi_register_master(master);
-	if (ret < 0)
-		goto unreg_master;
-
-	return ret;
-
-unreg_master:
-	destroy_workqueue(mps->workqueue);
-free_irq:
-	free_irq(mps->irq, mps);
-free_master:
-	if (mps->psc)
-		iounmap(mps->psc);
-	spi_master_put(master);
-
-	return ret;
+	return mpc52xx_psc_spi_do_probe(&op->dev, (u32)regaddr64, (u32)size64,
+					irq_of_parse_and_map(op->node, 0), id);
 }
 
 static int __exit mpc52xx_psc_spi_of_remove(struct of_device *op)
 {
-	struct spi_master *master = dev_get_drvdata(&op->dev);
-	struct mpc52xx_psc_spi *mps = spi_master_get_devdata(master);
-
-	flush_workqueue(mps->workqueue);
-	destroy_workqueue(mps->workqueue);
-	spi_unregister_master(master);
-	free_irq(mps->irq, mps);
-	if (mps->psc)
-		iounmap(mps->psc);
-
-	return 0;
+	return mpc52xx_psc_spi_do_remove(&op->dev);
 }
 
 static struct of_device_id mpc52xx_psc_spi_of_match[] = {
@@ -687,33 +631,21 @@ static struct of_platform_driver mpc52xx
 		.owner = THIS_MODULE,
 	},
 };
-#endif	/* defined(CONFIG_PPC_MERGE) */
-
-/* ======================================================================== */
-/* Module                                                                   */
-/* ======================================================================== */
 
 static int __init mpc52xx_psc_spi_init(void)
 {
-#if defined(CONFIG_PPC_MERGE)
 	return of_register_platform_driver(&mpc52xx_psc_spi_of_driver);
-#else
-	return platform_driver_probe(&mpc52xx_psc_spi_platform_driver,
-			mpc52xx_psc_spi_probe);
-#endif
 }
 module_init(mpc52xx_psc_spi_init);
 
 static void __exit mpc52xx_psc_spi_exit(void)
 {
-#if defined(CONFIG_PPC_MERGE)
 	of_unregister_platform_driver(&mpc52xx_psc_spi_of_driver);
-#else
-	platform_driver_unregister(&mpc52xx_psc_spi_platform_driver);
-#endif
 }
 module_exit(mpc52xx_psc_spi_exit);
 
+#endif	/* defined(CONFIG_PPC_MERGE) */
+
 MODULE_AUTHOR("Dragos Carp");
 MODULE_DESCRIPTION("MPC52xx PSC SPI Driver");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from dragos.carp@toptica.com are

mpc52xx-psc-spi-master-driver.patch
mpc52xx-psc-spi-master-driver-update.patch
mpc52xx-psc-spi-master-driver-update-tidy.patch
