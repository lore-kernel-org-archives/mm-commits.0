From: akpm@linux-foundation.org
Subject: +
 genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create.patch added
 to -mm tree
Date: Thu, 09 Jul 2015 12:14:18 -0700
Message-ID: <559ec80a.HLrlE2cs0uITd4/G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbbGITOU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 15:14:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladimir_zapolskiy@mentor.com, alexandre.belloni@free-electrons.com, arnd@arndb.de, gregkh@linuxfoundation.org, kernel@pengutronix.de, linux@arm.linux.org.uk, mchehab@osg.samsung.com, nicolas.ferre@atmel.com, p.zabel@pengutronix.de, plagnioj@jcrosoft.com, shawnguo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: genalloc: add name arg to gen_pool_get() and devm_gen_pool_create()
has been added to the -mm tree.  Its filename is
     genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Subject: genalloc: add name arg to gen_pool_get() and devm_gen_pool_create()

This change modifies gen_pool_get() and devm_gen_pool_create() client
interfaces adding one more argument "name" of a gen_pool object.

Due to implementation gen_pool_get() is capable to retrieve only one
gen_pool associated with a device even if multiple gen_pools are created,
fortunately right at the moment it is sufficient for the clients, hence
provide NULL as a valid argument on both producer devm_gen_pool_create()
and consumer gen_pool_get() sides.

Because only one created gen_pool per device is addressable, explicitly
add a restriction to devm_gen_pool_create() to create only one gen_pool
per device, this implies two possible error codes returned by the
function, account it on client side (only misc/sram).  This completes
client side changes related to genalloc updates.

Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-at91/pm.c                   |    2 
 arch/arm/mach-imx/pm-imx5.c               |    2 
 arch/arm/mach-imx/pm-imx6.c               |    2 
 drivers/media/platform/coda/coda-common.c |    2 
 drivers/misc/sram.c                       |    8 +--
 include/linux/genalloc.h                  |    4 -
 lib/genalloc.c                            |   49 +++++++++++---------
 7 files changed, 38 insertions(+), 31 deletions(-)

diff -puN arch/arm/mach-at91/pm.c~genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create arch/arm/mach-at91/pm.c
--- a/arch/arm/mach-at91/pm.c~genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create
+++ a/arch/arm/mach-at91/pm.c
@@ -369,7 +369,7 @@ static void __init at91_pm_sram_init(voi
 		return;
 	}
 
-	sram_pool = gen_pool_get(&pdev->dev);
+	sram_pool = gen_pool_get(&pdev->dev, NULL);
 	if (!sram_pool) {
 		pr_warn("%s: sram pool unavailable!\n", __func__);
 		return;
diff -puN arch/arm/mach-imx/pm-imx5.c~genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create arch/arm/mach-imx/pm-imx5.c
--- a/arch/arm/mach-imx/pm-imx5.c~genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create
+++ a/arch/arm/mach-imx/pm-imx5.c
@@ -297,7 +297,7 @@ static int __init imx_suspend_alloc_ocra
 		goto put_node;
 	}
 
-	ocram_pool = gen_pool_get(&pdev->dev);
+	ocram_pool = gen_pool_get(&pdev->dev, NULL);
 	if (!ocram_pool) {
 		pr_warn("%s: ocram pool unavailable!\n", __func__);
 		ret = -ENODEV;
diff -puN arch/arm/mach-imx/pm-imx6.c~genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create arch/arm/mach-imx/pm-imx6.c
--- a/arch/arm/mach-imx/pm-imx6.c~genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create
+++ a/arch/arm/mach-imx/pm-imx6.c
@@ -451,7 +451,7 @@ static int __init imx6q_suspend_init(con
 		goto put_node;
 	}
 
-	ocram_pool = gen_pool_get(&pdev->dev);
+	ocram_pool = gen_pool_get(&pdev->dev, NULL);
 	if (!ocram_pool) {
 		pr_warn("%s: ocram pool unavailable!\n", __func__);
 		ret = -ENODEV;
diff -puN drivers/media/platform/coda/coda-common.c~genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create drivers/media/platform/coda/coda-common.c
--- a/drivers/media/platform/coda/coda-common.c~genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create
+++ a/drivers/media/platform/coda/coda-common.c
@@ -2157,7 +2157,7 @@ static int coda_probe(struct platform_de
 	/* Get IRAM pool from device tree or platform data */
 	pool = of_gen_pool_get(np, "iram", 0);
 	if (!pool && pdata)
-		pool = gen_pool_get(pdata->iram_dev);
+		pool = gen_pool_get(pdata->iram_dev, NULL);
 	if (!pool) {
 		dev_err(&pdev->dev, "iram pool not available\n");
 		return -ENOMEM;
diff -puN drivers/misc/sram.c~genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create drivers/misc/sram.c
--- a/drivers/misc/sram.c~genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create
+++ a/drivers/misc/sram.c
@@ -186,10 +186,10 @@ static int sram_probe(struct platform_de
 	if (IS_ERR(sram->virt_base))
 		return PTR_ERR(sram->virt_base);
 
-	sram->pool = devm_gen_pool_create(sram->dev,
-					  ilog2(SRAM_GRANULARITY), -1);
-	if (!sram->pool)
-		return -ENOMEM;
+	sram->pool = devm_gen_pool_create(sram->dev, ilog2(SRAM_GRANULARITY),
+					  NUMA_NO_NODE, NULL);
+	if (IS_ERR(sram->pool))
+		return PTR_ERR(sram->pool);
 
 	ret = sram_reserve_regions(sram, res);
 	if (ret)
diff -puN include/linux/genalloc.h~genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create include/linux/genalloc.h
--- a/include/linux/genalloc.h~genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create
+++ a/include/linux/genalloc.h
@@ -118,8 +118,8 @@ extern unsigned long gen_pool_best_fit(u
 		unsigned long start, unsigned int nr, void *data);
 
 extern struct gen_pool *devm_gen_pool_create(struct device *dev,
-		int min_alloc_order, int nid);
-extern struct gen_pool *gen_pool_get(struct device *dev);
+		int min_alloc_order, int nid, const char *name);
+extern struct gen_pool *gen_pool_get(struct device *dev, const char *name);
 
 bool addr_in_gen_pool(struct gen_pool *pool, unsigned long start,
 			size_t size);
diff -puN lib/genalloc.c~genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create lib/genalloc.c
--- a/lib/genalloc.c~genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create
+++ a/lib/genalloc.c
@@ -571,23 +571,46 @@ static void devm_gen_pool_release(struct
 }
 
 /**
+ * gen_pool_get - Obtain the gen_pool (if any) for a device
+ * @dev: device to retrieve the gen_pool from
+ * @name: name of a gen_pool or NULL, identifies a particular gen_pool on device
+ *
+ * Returns the gen_pool for the device if one is present, or NULL.
+ */
+struct gen_pool *gen_pool_get(struct device *dev, const char *name)
+{
+	struct gen_pool **p = devres_find(dev, devm_gen_pool_release,
+					  NULL, NULL);
+
+	if (!p)
+		return NULL;
+	return *p;
+}
+EXPORT_SYMBOL_GPL(gen_pool_get);
+
+/**
  * devm_gen_pool_create - managed gen_pool_create
  * @dev: device that provides the gen_pool
  * @min_alloc_order: log base 2 of number of bytes each bitmap bit represents
- * @nid: node id of the node the pool structure should be allocated on, or -1
+ * @nid: node selector for allocated gen_pool, %NUMA_NO_NODE for all nodes
+ * @name: name of a gen_pool or NULL, identifies a particular gen_pool on device
  *
  * Create a new special memory pool that can be used to manage special purpose
  * memory not managed by the regular kmalloc/kfree interface. The pool will be
  * automatically destroyed by the device management code.
  */
 struct gen_pool *devm_gen_pool_create(struct device *dev, int min_alloc_order,
-		int nid)
+				      int nid, const char *name)
 {
 	struct gen_pool **ptr, *pool;
 
+	/* Check that genpool to be created is uniquely addressed on device */
+	if (gen_pool_get(dev, name))
+		return ERR_PTR(-EINVAL);
+
 	ptr = devres_alloc(devm_gen_pool_release, sizeof(*ptr), GFP_KERNEL);
 	if (!ptr)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	pool = gen_pool_create(min_alloc_order, nid);
 	if (pool) {
@@ -595,29 +618,13 @@ struct gen_pool *devm_gen_pool_create(st
 		devres_add(dev, ptr);
 	} else {
 		devres_free(ptr);
+		return ERR_PTR(-ENOMEM);
 	}
 
 	return pool;
 }
 EXPORT_SYMBOL(devm_gen_pool_create);
 
-/**
- * gen_pool_get - Obtain the gen_pool (if any) for a device
- * @dev: device to retrieve the gen_pool from
- *
- * Returns the gen_pool for the device if one is present, or NULL.
- */
-struct gen_pool *gen_pool_get(struct device *dev)
-{
-	struct gen_pool **p = devres_find(dev, devm_gen_pool_release, NULL,
-					NULL);
-
-	if (!p)
-		return NULL;
-	return *p;
-}
-EXPORT_SYMBOL_GPL(gen_pool_get);
