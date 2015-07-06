From: akpm@linux-foundation.org
Subject: [merged]
 genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get.patch removed from -mm tree
Date: Mon, 06 Jul 2015 12:48:23 -0700
Message-ID: <559adb87.oXURCexN4EefCA01%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856AbbGFTsY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:48:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladimir_zapolskiy@mentor.com, alexandre.belloni@free-electrons.com, boris.brezillon@free-electrons.com, herbert@gondor.apana.org.au, kernel@pengutronix.de, linux@arm.linux.org.uk, mchehab@osg.samsung.com, nicolas.ferre@atmel.com, p.zabel@pengutronix.de, perex@perex.cz, sfr@canb.auug.org.au, shawn.guo@linaro.org, tiwai@suse.de, vinod.koul@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: genalloc: rename of_get_named_gen_pool() to of_gen_pool_get()
has been removed from the -mm tree.  Its filename was
     genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Subject: genalloc: rename of_get_named_gen_pool() to of_gen_pool_get()

To be consistent with other kernel interface namings, rename
of_get_named_gen_pool() to of_gen_pool_get().  In the original function
name "_named" suffix references to a device tree property, which contains
a phandle to a device and the corresponding device driver is assumed to
register a gen_pool object.

Due to a weak relation and to avoid any confusion (e.g.  in future
possible scenario if gen_pool objects are named) the suffix is removed.

[sfr@canb.auug.org.au: crypto/marvell/cesa - fix up for of_get_named_gen_pool() rename]
Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/crypto/marvell/cesa.c             |    5 ++---
 drivers/dma/mmp_tdma.c                    |    2 +-
 drivers/media/platform/coda/coda-common.c |    2 +-
 include/linux/genalloc.h                  |    4 ++--
 lib/genalloc.c                            |    6 +++---
 sound/core/memalloc.c                     |    2 +-
 6 files changed, 10 insertions(+), 11 deletions(-)

diff -puN drivers/crypto/marvell/cesa.c~genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get drivers/crypto/marvell/cesa.c
--- a/drivers/crypto/marvell/cesa.c~genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get
+++ a/drivers/crypto/marvell/cesa.c
@@ -321,9 +321,8 @@ static int mv_cesa_get_sram(struct platf
 	const char *res_name = "sram";
 	struct resource *res;
 
-	engine->pool = of_get_named_gen_pool(cesa->dev->of_node,
-					     "marvell,crypto-srams",
-					     idx);
+	engine->pool = of_gen_pool_get(cesa->dev->of_node,
+				       "marvell,crypto-srams", idx);
 	if (engine->pool) {
 		engine->sram = gen_pool_dma_alloc(engine->pool,
 						  cesa->sram_size,
diff -puN drivers/dma/mmp_tdma.c~genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get drivers/dma/mmp_tdma.c
--- a/drivers/dma/mmp_tdma.c~genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get
+++ a/drivers/dma/mmp_tdma.c
@@ -657,7 +657,7 @@ static int mmp_tdma_probe(struct platfor
 	INIT_LIST_HEAD(&tdev->device.channels);
 
 	if (pdev->dev.of_node)
-		pool = of_get_named_gen_pool(pdev->dev.of_node, "asram", 0);
+		pool = of_gen_pool_get(pdev->dev.of_node, "asram", 0);
 	else
 		pool = sram_get_gpool("asram");
 	if (!pool) {
diff -puN drivers/media/platform/coda/coda-common.c~genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get drivers/media/platform/coda/coda-common.c
--- a/drivers/media/platform/coda/coda-common.c~genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get
+++ a/drivers/media/platform/coda/coda-common.c
@@ -2155,7 +2155,7 @@ static int coda_probe(struct platform_de
 	}
 
 	/* Get IRAM pool from device tree or platform data */
-	pool = of_get_named_gen_pool(np, "iram", 0);
+	pool = of_gen_pool_get(np, "iram", 0);
 	if (!pool && pdata)
 		pool = gen_pool_get(pdata->iram_dev);
 	if (!pool) {
diff -puN include/linux/genalloc.h~genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get include/linux/genalloc.h
--- a/include/linux/genalloc.h~genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get
+++ a/include/linux/genalloc.h
@@ -125,10 +125,10 @@ bool addr_in_gen_pool(struct gen_pool *p
 			size_t size);
 
 #ifdef CONFIG_OF
-extern struct gen_pool *of_get_named_gen_pool(struct device_node *np,
+extern struct gen_pool *of_gen_pool_get(struct device_node *np,
 	const char *propname, int index);
 #else
-static inline struct gen_pool *of_get_named_gen_pool(struct device_node *np,
+static inline struct gen_pool *of_gen_pool_get(struct device_node *np,
 	const char *propname, int index)
 {
 	return NULL;
diff -puN lib/genalloc.c~genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get lib/genalloc.c
--- a/lib/genalloc.c~genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get
+++ a/lib/genalloc.c
@@ -620,7 +620,7 @@ EXPORT_SYMBOL_GPL(gen_pool_get);
 
 #ifdef CONFIG_OF
 /**
- * of_get_named_gen_pool - find a pool by phandle property
+ * of_gen_pool_get - find a pool by phandle property
  * @np: device node
  * @propname: property name containing phandle(s)
  * @index: index into the phandle array
@@ -629,7 +629,7 @@ EXPORT_SYMBOL_GPL(gen_pool_get);
  * address of the device tree node pointed at by the phandle property,
  * or NULL if not found.
  */
-struct gen_pool *of_get_named_gen_pool(struct device_node *np,
+struct gen_pool *of_gen_pool_get(struct device_node *np,
 	const char *propname, int index)
 {
 	struct platform_device *pdev;
@@ -644,5 +644,5 @@ struct gen_pool *of_get_named_gen_pool(s
 		return NULL;
 	return gen_pool_get(&pdev->dev);
 }
-EXPORT_SYMBOL_GPL(of_get_named_gen_pool);
+EXPORT_SYMBOL_GPL(of_gen_pool_get);
 #endif /* CONFIG_OF */
diff -puN sound/core/memalloc.c~genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get sound/core/memalloc.c
--- a/sound/core/memalloc.c~genalloc-rename-of_get_named_gen_pool-to-of_gen_pool_get
+++ a/sound/core/memalloc.c
@@ -124,7 +124,7 @@ static void snd_malloc_dev_iram(struct s
 	dmab->addr = 0;
 
 	if (dev->of_node)
-		pool = of_get_named_gen_pool(dev->of_node, "iram", 0);
+		pool = of_gen_pool_get(dev->of_node, "iram", 0);
 
 	if (!pool)
 		return;
_

Patches currently in -mm which might be from vladimir_zapolskiy@mentor.com are

linux-next.patch

