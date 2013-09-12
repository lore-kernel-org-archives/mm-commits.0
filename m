From: akpm@linux-foundation.org
Subject: [merged] rtc-simplify-devm_request_mem_region-devm_ioremap.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:48:17 -0700
Message-ID: <52321a81.LFPmoncq2Z3uIKmg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58748 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590Ab3ILTsc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:48:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, Julia.Lawall@lip6.fr

Subject: [merged] rtc-simplify-devm_request_mem_region-devm_ioremap.patch removed from -mm tree
To: Julia.Lawall@lip6.fr,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:48:17 -0700


The patch titled
     Subject: rtc: simplify devm_request_mem_region/devm_ioremap
has been removed from the -mm tree.  Its filename was
     rtc-simplify-devm_request_mem_region-devm_ioremap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: rtc: simplify devm_request_mem_region/devm_ioremap

Convert the composition of devm_request_mem_region and devm_ioremap to a
single call to devm_ioremap_resource.  The associated call to
platform_get_resource is also simplified and moved next to the new call to
devm_ioremap_resource.

This was done using a combination of the semantic patches
devm_ioremap_resource.cocci and devm_request_and_ioremap.cocci, found in
the scripts/coccinelle/api directory.

In rtc-lpc32xx.c and rtc-mv.c, the local variable size is no longer needed.

In rtc-ds1511.c the size field of the local structure is not useful any
more, and is deleted.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1511.c   |   17 +++++------------
 drivers/rtc/rtc-ds1553.c   |   13 ++++---------
 drivers/rtc/rtc-ep93xx.c   |   14 +++-----------
 drivers/rtc/rtc-imxdi.c    |   16 ++++------------
 drivers/rtc/rtc-lpc32xx.c  |   24 ++++--------------------
 drivers/rtc/rtc-mv.c       |   17 ++++-------------
 drivers/rtc/rtc-mxc.c      |   14 ++++----------
 drivers/rtc/rtc-stk17ta8.c |   15 +++++----------
 drivers/rtc/rtc-tx4939.c   |   14 ++++----------
 9 files changed, 37 insertions(+), 107 deletions(-)

diff -puN drivers/rtc/rtc-ds1511.c~rtc-simplify-devm_request_mem_region-devm_ioremap drivers/rtc/rtc-ds1511.c
--- a/drivers/rtc/rtc-ds1511.c~rtc-simplify-devm_request_mem_region-devm_ioremap
+++ a/drivers/rtc/rtc-ds1511.c
@@ -89,7 +89,6 @@ enum ds1511reg {
 struct rtc_plat_data {
 	struct rtc_device *rtc;
 	void __iomem *ioaddr;		/* virtual base address */
-	int size;				/* amount of memory mapped */
 	int irq;
 	unsigned int irqen;
 	int alrm_sec;
@@ -479,20 +478,14 @@ static int ds1511_rtc_probe(struct platf
 	struct rtc_plat_data *pdata;
 	int ret = 0;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
-
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
-	pdata->size = resource_size(res);
-	if (!devm_request_mem_region(&pdev->dev, res->start, pdata->size,
-			pdev->name))
-		return -EBUSY;
-	ds1511_base = devm_ioremap(&pdev->dev, res->start, pdata->size);
-	if (!ds1511_base)
-		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	ds1511_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ds1511_base))
+		return PTR_ERR(ds1511_base);
 	pdata->ioaddr = ds1511_base;
 	pdata->irq = platform_get_irq(pdev, 0);
 
diff -puN drivers/rtc/rtc-ds1553.c~rtc-simplify-devm_request_mem_region-devm_ioremap drivers/rtc/rtc-ds1553.c
--- a/drivers/rtc/rtc-ds1553.c~rtc-simplify-devm_request_mem_region-devm_ioremap
+++ a/drivers/rtc/rtc-ds1553.c
@@ -285,19 +285,14 @@ static int ds1553_rtc_probe(struct platf
 	void __iomem *ioaddr;
 	int ret = 0;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
-	if (!devm_request_mem_region(&pdev->dev, res->start, RTC_REG_SIZE,
-			pdev->name))
-		return -EBUSY;
 
-	ioaddr = devm_ioremap(&pdev->dev, res->start, RTC_REG_SIZE);
-	if (!ioaddr)
-		return -ENOMEM;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	ioaddr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ioaddr))
+		return PTR_ERR(ioaddr);
 	pdata->ioaddr = ioaddr;
 	pdata->irq = platform_get_irq(pdev, 0);
 
diff -puN drivers/rtc/rtc-ep93xx.c~rtc-simplify-devm_request_mem_region-devm_ioremap drivers/rtc/rtc-ep93xx.c
--- a/drivers/rtc/rtc-ep93xx.c~rtc-simplify-devm_request_mem_region-devm_ioremap
+++ a/drivers/rtc/rtc-ep93xx.c
@@ -138,17 +138,9 @@ static int ep93xx_rtc_probe(struct platf
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENXIO;
-
-	if (!devm_request_mem_region(&pdev->dev, res->start,
-				     resource_size(res), pdev->name))
-		return -EBUSY;
-
-	ep93xx_rtc->mmio_base = devm_ioremap(&pdev->dev, res->start,
-					     resource_size(res));
-	if (!ep93xx_rtc->mmio_base)
-		return -ENXIO;
+	ep93xx_rtc->mmio_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ep93xx_rtc->mmio_base))
+		return PTR_ERR(ep93xx_rtc->mmio_base);
 
 	pdev->dev.platform_data = ep93xx_rtc;
 	platform_set_drvdata(pdev, ep93xx_rtc);
diff -puN drivers/rtc/rtc-imxdi.c~rtc-simplify-devm_request_mem_region-devm_ioremap drivers/rtc/rtc-imxdi.c
--- a/drivers/rtc/rtc-imxdi.c~rtc-simplify-devm_request_mem_region-devm_ioremap
+++ a/drivers/rtc/rtc-imxdi.c
@@ -375,24 +375,16 @@ static int __init dryice_rtc_probe(struc
 	struct imxdi_dev *imxdi;
 	int rc;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
-
 	imxdi = devm_kzalloc(&pdev->dev, sizeof(*imxdi), GFP_KERNEL);
 	if (!imxdi)
 		return -ENOMEM;
 
 	imxdi->pdev = pdev;
 
-	if (!devm_request_mem_region(&pdev->dev, res->start, resource_size(res),
-				pdev->name))
-		return -EBUSY;
-
-	imxdi->ioaddr = devm_ioremap(&pdev->dev, res->start,
-			resource_size(res));
-	if (imxdi->ioaddr == NULL)
-		return -ENOMEM;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	imxdi->ioaddr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(imxdi->ioaddr))
+		return PTR_ERR(imxdi->ioaddr);
 
 	spin_lock_init(&imxdi->irq_lock);
 
diff -puN drivers/rtc/rtc-lpc32xx.c~rtc-simplify-devm_request_mem_region-devm_ioremap drivers/rtc/rtc-lpc32xx.c
--- a/drivers/rtc/rtc-lpc32xx.c~rtc-simplify-devm_request_mem_region-devm_ioremap
+++ a/drivers/rtc/rtc-lpc32xx.c
@@ -201,16 +201,9 @@ static int lpc32xx_rtc_probe(struct plat
 {
 	struct resource *res;
 	struct lpc32xx_rtc *rtc;
-	resource_size_t size;
 	int rtcirq;
 	u32 tmp;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "Can't get memory resource\n");
-		return -ENOENT;
-	}
-
 	rtcirq = platform_get_irq(pdev, 0);
 	if (rtcirq < 0 || rtcirq >= NR_IRQS) {
 		dev_warn(&pdev->dev, "Can't get interrupt resource\n");
@@ -224,19 +217,10 @@ static int lpc32xx_rtc_probe(struct plat
 	}
 	rtc->irq = rtcirq;
 
-	size = resource_size(res);
-
-	if (!devm_request_mem_region(&pdev->dev, res->start, size,
-				     pdev->name)) {
-		dev_err(&pdev->dev, "RTC registers are not free\n");
-		return -EBUSY;
-	}
-
-	rtc->rtc_base = devm_ioremap(&pdev->dev, res->start, size);
-	if (!rtc->rtc_base) {
-		dev_err(&pdev->dev, "Can't map memory\n");
-		return -ENOMEM;
-	}
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	rtc->rtc_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(rtc->rtc_base))
+		return PTR_ERR(rtc->rtc_base);
 
 	spin_lock_init(&rtc->lock);
 
diff -puN drivers/rtc/rtc-mv.c~rtc-simplify-devm_request_mem_region-devm_ioremap drivers/rtc/rtc-mv.c
--- a/drivers/rtc/rtc-mv.c~rtc-simplify-devm_request_mem_region-devm_ioremap
+++ a/drivers/rtc/rtc-mv.c
@@ -221,26 +221,17 @@ static int __init mv_rtc_probe(struct pl
 {
 	struct resource *res;
 	struct rtc_plat_data *pdata;
-	resource_size_t size;
 	u32 rtc_time;
 	int ret = 0;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
-
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
 
-	size = resource_size(res);
-	if (!devm_request_mem_region(&pdev->dev, res->start, size,
-				     pdev->name))
-		return -EBUSY;
-
-	pdata->ioaddr = devm_ioremap(&pdev->dev, res->start, size);
-	if (!pdata->ioaddr)
-		return -ENOMEM;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	pdata->ioaddr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(pdata->ioaddr))
+		return PTR_ERR(pdata->ioaddr);
 
 	pdata->clk = devm_clk_get(&pdev->dev, NULL);
 	/* Not all SoCs require a clock.*/
diff -puN drivers/rtc/rtc-mxc.c~rtc-simplify-devm_request_mem_region-devm_ioremap drivers/rtc/rtc-mxc.c
--- a/drivers/rtc/rtc-mxc.c~rtc-simplify-devm_request_mem_region-devm_ioremap
+++ a/drivers/rtc/rtc-mxc.c
@@ -377,22 +377,16 @@ static int mxc_rtc_probe(struct platform
 	unsigned long rate;
 	int ret;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
-
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
 
 	pdata->devtype = pdev->id_entry->driver_data;
 
-	if (!devm_request_mem_region(&pdev->dev, res->start,
-				     resource_size(res), pdev->name))
-		return -EBUSY;
-
-	pdata->ioaddr = devm_ioremap(&pdev->dev, res->start,
-				     resource_size(res));
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	pdata->ioaddr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(pdata->ioaddr))
+		return PTR_ERR(pdata->ioaddr);
 
 	pdata->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(pdata->clk)) {
diff -puN drivers/rtc/rtc-stk17ta8.c~rtc-simplify-devm_request_mem_region-devm_ioremap drivers/rtc/rtc-stk17ta8.c
--- a/drivers/rtc/rtc-stk17ta8.c~rtc-simplify-devm_request_mem_region-devm_ioremap
+++ a/drivers/rtc/rtc-stk17ta8.c
@@ -294,19 +294,14 @@ static int stk17ta8_rtc_probe(struct pla
 	void __iomem *ioaddr;
 	int ret = 0;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
-
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
-	if (!devm_request_mem_region(&pdev->dev, res->start, RTC_REG_SIZE,
-			pdev->name))
-		return -EBUSY;
-	ioaddr = devm_ioremap(&pdev->dev, res->start, RTC_REG_SIZE);
-	if (!ioaddr)
-		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	ioaddr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ioaddr))
+		return PTR_ERR(ioaddr);
 	pdata->ioaddr = ioaddr;
 	pdata->irq = platform_get_irq(pdev, 0);
 
diff -puN drivers/rtc/rtc-tx4939.c~rtc-simplify-devm_request_mem_region-devm_ioremap drivers/rtc/rtc-tx4939.c
--- a/drivers/rtc/rtc-tx4939.c~rtc-simplify-devm_request_mem_region-devm_ioremap
+++ a/drivers/rtc/rtc-tx4939.c
@@ -244,9 +244,6 @@ static int __init tx4939_rtc_probe(struc
 	struct resource *res;
 	int irq, ret;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
 		return -ENODEV;
@@ -255,13 +252,10 @@ static int __init tx4939_rtc_probe(struc
 		return -ENOMEM;
 	platform_set_drvdata(pdev, pdata);
 
-	if (!devm_request_mem_region(&pdev->dev, res->start,
-				     resource_size(res), pdev->name))
-		return -EBUSY;
-	pdata->rtcreg = devm_ioremap(&pdev->dev, res->start,
-				     resource_size(res));
-	if (!pdata->rtcreg)
-		return -EBUSY;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	pdata->rtcreg = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(pdata->rtcreg))
+		return PTR_ERR(pdata->rtcreg);
 
 	spin_lock_init(&pdata->lock);
 	tx4939_rtc_cmd(pdata->rtcreg, TX4939_RTCCTL_COMMAND_NOP);
_

Patches currently in -mm which might be from Julia.Lawall@lip6.fr are

origin.patch

