From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-coh901331c-use-devm-allocation.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:52:05 -0700
Message-ID: <20120731185205.A9108100082@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:42024 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756337Ab2GaSwG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:52:06 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4679387obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:52:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linus.walleij@linaro.org, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-coh901331.c: use devm allocation
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-coh901331c-use-devm-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Linus Walleij <linus.walleij@linaro.org>
Subject: drivers/rtc/rtc-coh901331.c: use devm allocation

Allocate memory, region, remap and irq for device state using devm_*
helpers to simplify memory accounting.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-coh901331.c |   50 ++++++++++------------------------
 1 file changed, 15 insertions(+), 35 deletions(-)

diff -puN drivers/rtc/rtc-coh901331.c~drivers-rtc-rtc-coh901331c-use-devm-allocation drivers/rtc/rtc-coh901331.c
--- a/drivers/rtc/rtc-coh901331.c~drivers-rtc-rtc-coh901331c-use-devm-allocation
+++ a/drivers/rtc/rtc-coh901331.c
@@ -155,14 +155,10 @@ static int __exit coh901331_remove(struc
 	struct coh901331_port *rtap = dev_get_drvdata(&pdev->dev);
 
 	if (rtap) {
-		free_irq(rtap->irq, rtap);
 		rtc_device_unregister(rtap->rtc);
 		clk_unprepare(rtap->clk);
 		clk_put(rtap->clk);
-		iounmap(rtap->virtbase);
-		release_mem_region(rtap->phybase, rtap->physize);
 		platform_set_drvdata(pdev, NULL);
-		kfree(rtap);
 	}
 
 	return 0;
@@ -175,42 +171,36 @@ static int __init coh901331_probe(struct
 	struct coh901331_port *rtap;
 	struct resource *res;
 
-	rtap = kzalloc(sizeof(struct coh901331_port), GFP_KERNEL);
+	rtap = devm_kzalloc(&pdev->dev,
+			    sizeof(struct coh901331_port), GFP_KERNEL);
 	if (!rtap)
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		ret = -ENOENT;
-		goto out_no_resource;
-	}
+	if (!res)
+		return -ENOENT;
+
 	rtap->phybase = res->start;
 	rtap->physize = resource_size(res);
 
-	if (request_mem_region(rtap->phybase, rtap->physize,
-			       "rtc-coh901331") == NULL) {
-		ret = -EBUSY;
-		goto out_no_memregion;
-	}
+	if (devm_request_mem_region(&pdev->dev, rtap->phybase, rtap->physize,
+				    "rtc-coh901331") == NULL)
+		return -EBUSY;
 
-	rtap->virtbase = ioremap(rtap->phybase, rtap->physize);
-	if (!rtap->virtbase) {
-		ret = -ENOMEM;
-		goto out_no_remap;
-	}
+	rtap->virtbase = devm_ioremap(&pdev->dev, rtap->phybase, rtap->physize);
+	if (!rtap->virtbase)
+		return -ENOMEM;
 
 	rtap->irq = platform_get_irq(pdev, 0);
-	if (request_irq(rtap->irq, coh901331_interrupt, 0,
-			"RTC COH 901 331 Alarm", rtap)) {
-		ret = -EIO;
-		goto out_no_irq;
-	}
+	if (devm_request_irq(&pdev->dev, rtap->irq, coh901331_interrupt, 0,
+			     "RTC COH 901 331 Alarm", rtap))
+		return -EIO;
 
 	rtap->clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(rtap->clk)) {
 		ret = PTR_ERR(rtap->clk);
 		dev_err(&pdev->dev, "could not get clock\n");
-		goto out_no_clk;
+		return ret;
 	}
 
 	/* We enable/disable the clock only to assure it works */
@@ -236,16 +226,6 @@ static int __init coh901331_probe(struct
 	clk_unprepare(rtap->clk);
  out_no_clk_prepenable:
 	clk_put(rtap->clk);
- out_no_clk:
-	free_irq(rtap->irq, rtap);
- out_no_irq:
-	iounmap(rtap->virtbase);
- out_no_remap:
-	platform_set_drvdata(pdev, NULL);
- out_no_memregion:
-	release_mem_region(rtap->phybase, SZ_4K);
- out_no_resource:
-	kfree(rtap);
 	return ret;
 }
 
_

Patches currently in -mm which might be from linus.walleij@linaro.org are

origin.patch
linux-next.patch

