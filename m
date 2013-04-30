From: akpm@linux-foundation.org
Subject: [merged] media-coda-use-genalloc-api.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:50:45 -0700
Message-ID: <20130430185045.98BCF5A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:60671 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669Ab3D3Sur (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:50:47 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so86247qen.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:50:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: p.zabel@pengutronix.de, dong.aisheng@linaro.org, fabio.estevam@freescale.com, grant.likely@secretlab.ca, gregkh@linuxfoundation.org, javier.martin@vista-silicon.com, monstr@monstr.eu, mporter@ti.com, paul.gortmaker@windriver.com, rob.herring@calxeda.com, shawn.guo@linaro.org, shijie8@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: media: coda: use genalloc API
has been removed from the -mm tree.  Its filename was
     media-coda-use-genalloc-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Philipp Zabel <p.zabel@pengutronix.de>
Subject: media: coda: use genalloc API

This patch depends on "genalloc: add devres support, allow to find a
managed pool by device", which provides the of_get_named_gen_pool and
dev_get_gen_pool functions.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Javier Martin <javier.martin@vista-silicon.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Dong Aisheng <dong.aisheng@linaro.org>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Huang Shijie <shijie8@gmail.com>
Cc: Matt Porter <mporter@ti.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/media/coda.txt |   30 ++++++++
 drivers/media/platform/Kconfig                   |    1 
 drivers/media/platform/coda.c                    |   45 ++++++++-----
 include/linux/platform_data/coda.h               |   18 +++++
 4 files changed, 79 insertions(+), 15 deletions(-)

diff -puN /dev/null Documentation/devicetree/bindings/media/coda.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/media/coda.txt
@@ -0,0 +1,30 @@
+Chips&Media Coda multi-standard codec IP
+========================================
+
+Coda codec IPs are present in i.MX SoCs in various versions,
+called VPU (Video Processing Unit).
+
+Required properties:
+- compatible : should be "fsl,<chip>-src" for i.MX SoCs:
+  (a) "fsl,imx27-vpu" for CodaDx6 present in i.MX27
+  (b) "fsl,imx53-vpu" for CODA7541 present in i.MX53
+  (c) "fsl,imx6q-vpu" for CODA960 present in i.MX6q
+- reg: should be register base and length as documented in the
+  SoC reference manual
+- interrupts : Should contain the VPU interrupt. For CODA960,
+  a second interrupt is needed for the MJPEG unit.
+- clocks : Should contain the ahb and per clocks, in the order
+  determined by the clock-names property.
+- clock-names : Should be "ahb", "per"
+- iram : phandle pointing to the SRAM device node
+
+Example:
+
+vpu: vpu@63ff4000 {
+	compatible = "fsl,imx53-vpu";
+	reg = <0x63ff4000 0x1000>;
+	interrupts = <9>;
+	clocks = <&clks 63>, <&clks 63>;
+	clock-names = "ahb", "per";
+	iram = <&ocram>;
+};
diff -puN drivers/media/platform/Kconfig~media-coda-use-genalloc-api drivers/media/platform/Kconfig
--- a/drivers/media/platform/Kconfig~media-coda-use-genalloc-api
+++ a/drivers/media/platform/Kconfig
@@ -145,7 +145,6 @@ config VIDEO_CODA
 	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_MXC
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
-	select IRAM_ALLOC if SOC_IMX53
 	---help---
 	   Coda is a range of video codec IPs that supports
 	   H.264, MPEG-4, and other video formats.
diff -puN drivers/media/platform/coda.c~media-coda-use-genalloc-api drivers/media/platform/coda.c
--- a/drivers/media/platform/coda.c~media-coda-use-genalloc-api
+++ a/drivers/media/platform/coda.c
@@ -14,6 +14,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/firmware.h>
+#include <linux/genalloc.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/irq.h>
@@ -23,7 +24,7 @@
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <linux/of.h>
-#include <linux/platform_data/imx-iram.h>
+#include <linux/platform_data/coda.h>
 
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
@@ -43,6 +44,7 @@
 #define CODA7_WORK_BUF_SIZE	(512 * 1024 + CODA_FMO_BUF_SIZE * 8 * 1024)
 #define CODA_PARA_BUF_SIZE	(10 * 1024)
 #define CODA_ISRAM_SIZE	(2048 * 2)
+#define CODADX6_IRAM_SIZE	0xb000
 #define CODA7_IRAM_SIZE		0x14000 /* 81920 bytes */
 
 #define CODA_MAX_FRAMEBUFFERS	2
@@ -128,7 +130,10 @@ struct coda_dev {
 
 	struct coda_aux_buf	codebuf;
 	struct coda_aux_buf	workbuf;
+	struct gen_pool		*iram_pool;
+	long unsigned int	iram_vaddr;
 	long unsigned int	iram_paddr;
+	unsigned long		iram_size;
 
 	spinlock_t		irqlock;
 	struct mutex		dev_mutex;
@@ -1926,6 +1931,9 @@ static int coda_probe(struct platform_de
 	const struct of_device_id *of_id =
 			of_match_device(of_match_ptr(coda_dt_ids), &pdev->dev);
 	const struct platform_device_id *pdev_id;
+	struct coda_platform_data *pdata = pdev->dev.platform_data;
+	struct device_node *np = pdev->dev.of_node;
+	struct gen_pool *pool;
 	struct coda_dev *dev;
 	struct resource *res;
 	int ret, irq;
@@ -1988,6 +1996,16 @@ static int coda_probe(struct platform_de
 		return -ENOENT;
 	}
 
+	/* Get IRAM pool from device tree or platform data */
+	pool = of_get_named_gen_pool(np, "iram", 0);
+	if (!pool && pdata)
+		pool = dev_get_gen_pool(pdata->iram_dev);
+	if (!pool) {
+		dev_err(&pdev->dev, "iram pool not available\n");
+		return -ENOMEM;
+	}
+	dev->iram_pool = pool;
+
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
 	if (ret)
 		return ret;
@@ -2022,18 +2040,17 @@ static int coda_probe(struct platform_de
 		return -ENOMEM;
 	}
 
-	if (dev->devtype->product == CODA_DX6) {
-		dev->iram_paddr = 0xffff4c00;
-	} else {
-		void __iomem *iram_vaddr;
-
-		iram_vaddr = iram_alloc(CODA7_IRAM_SIZE,
-					&dev->iram_paddr);
-		if (!iram_vaddr) {
-			dev_err(&pdev->dev, "unable to alloc iram\n");
-			return -ENOMEM;
-		}
+	if (dev->devtype->product == CODA_DX6)
+		dev->iram_size = CODADX6_IRAM_SIZE;
+	else
+		dev->iram_size = CODA7_IRAM_SIZE;
+	dev->iram_vaddr = gen_pool_alloc(dev->iram_pool, dev->iram_size);
+	if (!dev->iram_vaddr) {
+		dev_err(&pdev->dev, "unable to alloc iram\n");
+		return -ENOMEM;
 	}
+	dev->iram_paddr = gen_pool_virt_to_phys(dev->iram_pool,
+						dev->iram_vaddr);
 
 	platform_set_drvdata(pdev, dev);
 
@@ -2050,8 +2067,8 @@ static int coda_remove(struct platform_d
 	if (dev->alloc_ctx)
 		vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
 	v4l2_device_unregister(&dev->v4l2_dev);
-	if (dev->iram_paddr)
-		iram_free(dev->iram_paddr, CODA7_IRAM_SIZE);
+	if (dev->iram_vaddr)
+		gen_pool_free(dev->iram_pool, dev->iram_vaddr, dev->iram_size);
 	if (dev->codebuf.vaddr)
 		dma_free_coherent(&pdev->dev, dev->codebuf.size,
 				  &dev->codebuf.vaddr, dev->codebuf.paddr);
diff -puN /dev/null include/linux/platform_data/coda.h
--- /dev/null
+++ a/include/linux/platform_data/coda.h
@@ -0,0 +1,18 @@
+/*
+ * Copyright (C) 2013 Philipp Zabel, Pengutronix
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef PLATFORM_CODA_H
+#define PLATFORM_CODA_H
+
+struct device;
+
+struct coda_platform_data {
+	struct device *iram_dev;
+};
+
+#endif
_

Patches currently in -mm which might be from p.zabel@pengutronix.de are

origin.patch
linux-next.patch

