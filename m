From: akpm@linux-foundation.org
Subject: + mmc-add-support-for-the-marvell-platform-sdhci-controller.patch added to -mm tree
Date: Wed, 25 Aug 2010 16:16:25 -0700
Message-ID: <201008252316.o7PNGPhl021552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753066Ab0HYXQ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Aug 2010 19:16:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: saeed@marvell.com, linux-mmc@vger.kernel.org, matt@console-pimps.org


The patch titled
     mmx: add support for the Marvell platform SDHCI controller
has been added to the -mm tree.  Its filename is
     mmc-add-support-for-the-marvell-platform-sdhci-controller.patch

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
Subject: mmx: add support for the Marvell platform SDHCI controller
From: Saeed Bishara <saeed@marvell.com>

Implement a driver for the platfrom SDHCI controllers that is found on
some of Marvell's SoC's.

Signed-off-by: Saeed Bishara <saeed@marvell.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/Kconfig    |   12 +
 drivers/mmc/host/Makefile   |    1 
 drivers/mmc/host/sdhci-mv.c |  243 ++++++++++++++++++++++++++++++++++
 3 files changed, 256 insertions(+)

diff -puN drivers/mmc/host/Kconfig~mmc-add-support-for-the-marvell-platform-sdhci-controller drivers/mmc/host/Kconfig
--- a/drivers/mmc/host/Kconfig~mmc-add-support-for-the-marvell-platform-sdhci-controller
+++ a/drivers/mmc/host/Kconfig
@@ -130,6 +130,18 @@ config MMC_SDHCI_CNS3XXX
 
 	  If unsure, say N.
 
+config MMC_SDHCI_MV
+	tristate "SDHCI support on Marvell's soc"
+	depends on MMC_SDHCI
+	select MMC_SDHCI_IO_ACCESSORS
+	help
+	  This selects the Secure Digital Host Controller Interface in
+	  Marvell's SoC controllers.
+
+	  If you have a controller with this interface, say Y or M here.
+
+	  If unsure, say N.
+
 config MMC_SDHCI_S3C
 	tristate "SDHCI support on Samsung S3C SoC"
 	depends on MMC_SDHCI && PLAT_SAMSUNG
diff -puN drivers/mmc/host/Makefile~mmc-add-support-for-the-marvell-platform-sdhci-controller drivers/mmc/host/Makefile
--- a/drivers/mmc/host/Makefile~mmc-add-support-for-the-marvell-platform-sdhci-controller
+++ a/drivers/mmc/host/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_MMC_PXA)		+= pxamci.o
 obj-$(CONFIG_MMC_IMX)		+= imxmmc.o
 obj-$(CONFIG_MMC_MXC)		+= mxcmmc.o
 obj-$(CONFIG_MMC_SDHCI)		+= sdhci.o
+obj-$(CONFIG_MMC_SDHCI_MV)	+= sdhci-mv.o
 obj-$(CONFIG_MMC_SDHCI_PCI)	+= sdhci-pci.o
 obj-$(CONFIG_MMC_SDHCI_S3C)	+= sdhci-s3c.o
 obj-$(CONFIG_MMC_SDHCI_SPEAR)	+= sdhci-spear.o
diff -puN /dev/null drivers/mmc/host/sdhci-mv.c
--- /dev/null
+++ a/drivers/mmc/host/sdhci-mv.c
@@ -0,0 +1,243 @@
+/*
+ * sdhci-mv.c Support for SDHCI platform devices
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+/* Supports:
+ * SDHCI platform devices found on Marvell SoC's
+ *
+ * Based on  sdhci-pltfm.c
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/mmc/host.h>
+#include "sdhci.h"
+
+struct sdhci_mv_host {
+#if defined(CONFIG_HAVE_CLK)
+	struct clk		*clk;
+#endif
+};
+
+/*****************************************************************************\
+ *                                                                           *
+ * SDHCI core callbacks                                                      *
+ *                                                                           *
+\*****************************************************************************/
+static u16 mv_readw(struct sdhci_host *host, int reg)
+{
+	u16 ret;
+
+	switch (reg) {
+	case SDHCI_HOST_VERSION:
+	case SDHCI_SLOT_INT_STATUS:
+		/* those registers don't exist */
+		return 0;
+	default:
+		ret = readw(host->ioaddr + reg);
+	}
+	return ret;
+}
+
+static u32 mv_readl(struct sdhci_host *host, int reg)
+{
+	u32 ret;
+
+	switch (reg) {
+	case SDHCI_CAPABILITIES:
+		ret = readl(host->ioaddr + reg);
+		/* Mask the support for 3.0V */
+		ret &= ~SDHCI_CAN_VDD_300;
+		break;
+	default:
+		ret = readl(host->ioaddr + reg);
+	}
+	return ret;
+}
+
+static struct sdhci_ops sdhci_mv_ops = {
+	.read_w	= mv_readw,
+	.read_l	= mv_readl,
+};
+
+/*****************************************************************************\
+ *                                                                           *
+ * Device probing/removal                                                    *
+ *                                                                           *
+\*****************************************************************************/
+
+static int __devinit sdhci_mv_probe(struct platform_device *pdev)
+{
+	struct sdhci_host *host;
+	struct sdhci_mv_host *mv_host;
+	struct resource *iomem;
+	int ret;
+
+	BUG_ON(pdev == NULL);
+
+	iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!iomem) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	if (resource_size(iomem) != 0x100)
+		dev_err(&pdev->dev, "Invalid iomem size. You may "
+			"experience problems.\n");
+
+	if (pdev->dev.parent)
+		host = sdhci_alloc_host(pdev->dev.parent, sizeof(*mv_host));
+	else
+		host = sdhci_alloc_host(&pdev->dev, sizeof(*mv_host));
+
+	if (IS_ERR(host)) {
+		ret = PTR_ERR(host);
+		goto err;
+	}
+
+	mv_host = sdhci_priv(host);
+	host->hw_name = "marvell-sdhci";
+	host->ops = &sdhci_mv_ops;
+	host->irq = platform_get_irq(pdev, 0);
+	host->quirks =  SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER |
+			SDHCI_QUIRK_NO_BUSY_IRQ |
+			SDHCI_QUIRK_BROKEN_TIMEOUT_VAL |
+			SDHCI_QUIRK_FORCE_DMA;
+
+	if (!devm_request_mem_region(&pdev->dev, iomem->start,
+				     resource_size(iomem),
+				     mmc_hostname(host->mmc))) {
+		dev_err(&pdev->dev, "cannot request region\n");
+		ret = -EBUSY;
+		goto err_request;
+	}
+
+	host->ioaddr = devm_ioremap(&pdev->dev, iomem->start,
+				    resource_size(iomem));
+	if (!host->ioaddr) {
+		dev_err(&pdev->dev, "failed to remap registers\n");
+		ret = -ENOMEM;
+		goto err_request;
+	}
+
+#if defined(CONFIG_HAVE_CLK)
+	mv_host->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(mv_host->clk))
+		dev_notice(&pdev->dev, "cannot get clkdev\n");
+	else
+		clk_enable(mv_host->clk);
+#endif
+
+	ret = sdhci_add_host(host);
+	if (ret)
+		goto err_request;
+
+	platform_set_drvdata(pdev, host);
+
+	return 0;
+
+err_request:
+	sdhci_free_host(host);
+err:
+	printk(KERN_ERR"Probing of sdhci-mv failed: %d\n", ret);
+	return ret;
+}
+
+static int __devexit sdhci_mv_remove(struct platform_device *pdev)
+{
+	struct sdhci_host *host = platform_get_drvdata(pdev);
+#if defined(CONFIG_HAVE_CLK)
+	struct sdhci_mv_host *mv_host = sdhci_priv(host);
+	struct clk *clk = mv_host->clk;
+#endif
+	int dead;
+	u32 scratch;
+
+	dead = 0;
+	scratch = readl(host->ioaddr + SDHCI_INT_STATUS);
+	if (scratch == (u32)-1)
+		dead = 1;
+
+	sdhci_remove_host(host, dead);
+	sdhci_free_host(host);
+	platform_set_drvdata(pdev, NULL);
+#if defined(CONFIG_HAVE_CLK)
+	if (!IS_ERR(clk)) {
+		clk_disable(clk);
+		clk_put(clk);
+	}
+#endif
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int sdhci_mv_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct sdhci_host *host = dev_get_drvdata(&pdev->dev);
+
+	return sdhci_suspend_host(host, state);
+}
+
+static int sdhci_mv_resume(struct platform_device *pdev)
+{
+	struct sdhci_host *host = dev_get_drvdata(&pdev->dev);
+
+	return sdhci_resume_host(host);
+}
+#else
+#define sdhci_mv_suspend NULL
+#define sdhci_mv_resume NULL
+#endif
+
+static struct platform_driver sdhci_mv_driver = {
+	.driver = {
+		.name	= "sdhci-mv",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= sdhci_mv_probe,
+	.remove		= __devexit_p(sdhci_mv_remove),
+	.suspend	= sdhci_mv_suspend,
+	.resume		= sdhci_mv_resume,
+};
+
+/*****************************************************************************\
+ *                                                                           *
+ * Driver init/exit                                                          *
+ *                                                                           *
+\*****************************************************************************/
+
+static int __init sdhci_mv_init(void)
+{
+	return platform_driver_register(&sdhci_mv_driver);
+}
+
+static void __exit sdhci_mv_exit(void)
+{
+	platform_driver_unregister(&sdhci_mv_driver);
+}
+
+module_init(sdhci_mv_init);
+module_exit(sdhci_mv_exit);
+
+MODULE_DESCRIPTION("Marvell SDHCI platform driver");
+MODULE_AUTHOR("Saeed Bishara <saeed@marvell.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:sdhci-mv");
+
_

Patches currently in -mm which might be from saeed@marvell.com are

linux-next.patch
mmc-add-support-for-the-marvell-platform-sdhci-controller.patch

