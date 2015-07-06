From: akpm@linux-foundation.org
Subject: [merged] genalloc-rename-dev_get_gen_pool-to-gen_pool_get.patch
 removed from -mm tree
Date: Mon, 06 Jul 2015 12:48:20 -0700
Message-ID: <559adb84.vpxY2WBXcg30t7M4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877AbbGFTsV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:48:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladimir_zapolskiy@mentor.com, alexandre.belloni@free-electrons.com, atull@opensource.altera.com, broonie@kernel.org, dinguyen@opensource.altera.com, kernel@pengutronix.de, khilman@linaro.org, linux@arm.linux.org.uk, mchehab@osg.samsung.com, nicolas.ferre@atmel.com, p.zabel@pengutronix.de, perex@perex.cz, sfr@canb.auug.org.au, shawn.guo@linaro.org, tiwai@suse.de, vinod.koul@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: genalloc: rename dev_get_gen_pool() to gen_pool_get()
has been removed from the -mm tree.  Its filename was
     genalloc-rename-dev_get_gen_pool-to-gen_pool_get.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Subject: genalloc: rename dev_get_gen_pool() to gen_pool_get()

To be consistent with other genalloc interface namings, rename
dev_get_gen_pool() to gen_pool_get().  The original omitted "dev_" prefix
is removed, since it points to argument type of the function, and so it
does not bring any useful information.

[akpm@linux-foundation.org: update arch/arm/mach-socfpga/pm.c]
Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Mark Brown <broonie@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Alan Tull <atull@opensource.altera.com>
Cc: Dinh Nguyen <dinguyen@opensource.altera.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-at91/pm.c                   |    2 +-
 arch/arm/mach-imx/pm-imx5.c               |    2 +-
 arch/arm/mach-imx/pm-imx6.c               |    2 +-
 arch/arm/mach-socfpga/pm.c                |    2 +-
 drivers/media/platform/coda/coda-common.c |    2 +-
 include/linux/genalloc.h                  |    2 +-
 lib/genalloc.c                            |    8 ++++----
 7 files changed, 10 insertions(+), 10 deletions(-)

diff -puN arch/arm/mach-at91/pm.c~genalloc-rename-dev_get_gen_pool-to-gen_pool_get arch/arm/mach-at91/pm.c
--- a/arch/arm/mach-at91/pm.c~genalloc-rename-dev_get_gen_pool-to-gen_pool_get
+++ a/arch/arm/mach-at91/pm.c
@@ -369,7 +369,7 @@ static void __init at91_pm_sram_init(voi
 		return;
 	}
 
-	sram_pool = dev_get_gen_pool(&pdev->dev);
+	sram_pool = gen_pool_get(&pdev->dev);
 	if (!sram_pool) {
 		pr_warn("%s: sram pool unavailable!\n", __func__);
 		return;
diff -puN arch/arm/mach-imx/pm-imx5.c~genalloc-rename-dev_get_gen_pool-to-gen_pool_get arch/arm/mach-imx/pm-imx5.c
--- a/arch/arm/mach-imx/pm-imx5.c~genalloc-rename-dev_get_gen_pool-to-gen_pool_get
+++ a/arch/arm/mach-imx/pm-imx5.c
@@ -297,7 +297,7 @@ static int __init imx_suspend_alloc_ocra
 		goto put_node;
 	}
 
-	ocram_pool = dev_get_gen_pool(&pdev->dev);
+	ocram_pool = gen_pool_get(&pdev->dev);
 	if (!ocram_pool) {
 		pr_warn("%s: ocram pool unavailable!\n", __func__);
 		ret = -ENODEV;
diff -puN arch/arm/mach-imx/pm-imx6.c~genalloc-rename-dev_get_gen_pool-to-gen_pool_get arch/arm/mach-imx/pm-imx6.c
--- a/arch/arm/mach-imx/pm-imx6.c~genalloc-rename-dev_get_gen_pool-to-gen_pool_get
+++ a/arch/arm/mach-imx/pm-imx6.c
@@ -451,7 +451,7 @@ static int __init imx6q_suspend_init(con
 		goto put_node;
 	}
 
-	ocram_pool = dev_get_gen_pool(&pdev->dev);
+	ocram_pool = gen_pool_get(&pdev->dev);
 	if (!ocram_pool) {
 		pr_warn("%s: ocram pool unavailable!\n", __func__);
 		ret = -ENODEV;
diff -puN arch/arm/mach-socfpga/pm.c~genalloc-rename-dev_get_gen_pool-to-gen_pool_get arch/arm/mach-socfpga/pm.c
--- a/arch/arm/mach-socfpga/pm.c~genalloc-rename-dev_get_gen_pool-to-gen_pool_get
+++ a/arch/arm/mach-socfpga/pm.c
@@ -56,7 +56,7 @@ static int socfpga_setup_ocram_self_refr
 		goto put_node;
 	}
 
-	ocram_pool = dev_get_gen_pool(&pdev->dev);
+	ocram_pool = get_gen_pool(&pdev->dev);
 	if (!ocram_pool) {
 		pr_warn("%s: ocram pool unavailable!\n", __func__);
 		ret = -ENODEV;
diff -puN drivers/media/platform/coda/coda-common.c~genalloc-rename-dev_get_gen_pool-to-gen_pool_get drivers/media/platform/coda/coda-common.c
--- a/drivers/media/platform/coda/coda-common.c~genalloc-rename-dev_get_gen_pool-to-gen_pool_get
+++ a/drivers/media/platform/coda/coda-common.c
@@ -2157,7 +2157,7 @@ static int coda_probe(struct platform_de
 	/* Get IRAM pool from device tree or platform data */
 	pool = of_get_named_gen_pool(np, "iram", 0);
 	if (!pool && pdata)
-		pool = dev_get_gen_pool(pdata->iram_dev);
+		pool = gen_pool_get(pdata->iram_dev);
 	if (!pool) {
 		dev_err(&pdev->dev, "iram pool not available\n");
 		return -ENOMEM;
diff -puN include/linux/genalloc.h~genalloc-rename-dev_get_gen_pool-to-gen_pool_get include/linux/genalloc.h
--- a/include/linux/genalloc.h~genalloc-rename-dev_get_gen_pool-to-gen_pool_get
+++ a/include/linux/genalloc.h
@@ -119,7 +119,7 @@ extern unsigned long gen_pool_best_fit(u
 
 extern struct gen_pool *devm_gen_pool_create(struct device *dev,
 		int min_alloc_order, int nid);
-extern struct gen_pool *dev_get_gen_pool(struct device *dev);
+extern struct gen_pool *gen_pool_get(struct device *dev);
 
 bool addr_in_gen_pool(struct gen_pool *pool, unsigned long start,
 			size_t size);
diff -puN lib/genalloc.c~genalloc-rename-dev_get_gen_pool-to-gen_pool_get lib/genalloc.c
--- a/lib/genalloc.c~genalloc-rename-dev_get_gen_pool-to-gen_pool_get
+++ a/lib/genalloc.c
@@ -602,12 +602,12 @@ struct gen_pool *devm_gen_pool_create(st
 EXPORT_SYMBOL(devm_gen_pool_create);
 
 /**
- * dev_get_gen_pool - Obtain the gen_pool (if any) for a device
+ * gen_pool_get - Obtain the gen_pool (if any) for a device
  * @dev: device to retrieve the gen_pool from
  *
  * Returns the gen_pool for the device if one is present, or NULL.
  */
-struct gen_pool *dev_get_gen_pool(struct device *dev)
+struct gen_pool *gen_pool_get(struct device *dev)
 {
 	struct gen_pool **p = devres_find(dev, devm_gen_pool_release, NULL,
 					NULL);
@@ -616,7 +616,7 @@ struct gen_pool *dev_get_gen_pool(struct
 		return NULL;
 	return *p;
 }
-EXPORT_SYMBOL_GPL(dev_get_gen_pool);
+EXPORT_SYMBOL_GPL(gen_pool_get);
 
 #ifdef CONFIG_OF
 /**
@@ -642,7 +642,7 @@ struct gen_pool *of_get_named_gen_pool(s
 	of_node_put(np_pool);
 	if (!pdev)
 		return NULL;
-	return dev_get_gen_pool(&pdev->dev);
+	return gen_pool_get(&pdev->dev);
 }
 EXPORT_SYMBOL_GPL(of_get_named_gen_pool);
 #endif /* CONFIG_OF */
_

Patches currently in -mm which might be from vladimir_zapolskiy@mentor.com are

linux-next.patch

