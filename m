From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-spear-use-devm_-routines.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:07:52 -0800
Message-ID: <20121218200752.AF7C582004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:40074 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab2LRUHx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:07:53 -0500
Received: by mail-ye0-f202.google.com with SMTP id l7so125943yen.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:07:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viresh.kumar@linaro.org, a.zummo@towertech.it, deepak.sikri@st.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-spear: use devm_*() routines
has been removed from the -mm tree.  Its filename was
     rtc-rtc-spear-use-devm_-routines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Viresh Kumar <viresh.kumar@linaro.org>
Subject: rtc: rtc-spear: use devm_*() routines

Free the rtc-spear driver from tension of freeing resources :) devm_*
derivatives of multiple routines are used while allocating resources,
which would be freed automatically by kernel.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Deepak Sikri <deepak.sikri@st.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-spear.c |   89 ++++++++++++--------------------------
 1 file changed, 29 insertions(+), 60 deletions(-)

diff -puN drivers/rtc/rtc-spear.c~rtc-rtc-spear-use-devm_-routines drivers/rtc/rtc-spear.c
--- a/drivers/rtc/rtc-spear.c~rtc-rtc-spear-use-devm_-routines
+++ a/drivers/rtc/rtc-spear.c
@@ -363,35 +363,42 @@ static int __devinit spear_rtc_probe(str
 		dev_err(&pdev->dev, "no resource defined\n");
 		return -EBUSY;
 	}
-	if (!request_mem_region(res->start, resource_size(res), pdev->name)) {
-		dev_err(&pdev->dev, "rtc region already claimed\n");
-		return -EBUSY;
-	}
 
-	config = kzalloc(sizeof(*config), GFP_KERNEL);
+	config = devm_kzalloc(&pdev->dev, sizeof(*config), GFP_KERNEL);
 	if (!config) {
 		dev_err(&pdev->dev, "out of memory\n");
-		status = -ENOMEM;
-		goto err_release_region;
+		return -ENOMEM;
 	}
 
-	config->clk = clk_get(&pdev->dev, NULL);
-	if (IS_ERR(config->clk)) {
-		status = PTR_ERR(config->clk);
-		goto err_kfree;
+	/* alarm irqs */
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "no update irq?\n");
+		return irq;
 	}
 
-	status = clk_enable(config->clk);
-	if (status < 0)
-		goto err_clk_put;
+	status = devm_request_irq(&pdev->dev, irq, spear_rtc_irq, 0, pdev->name,
+			config);
+	if (status) {
+		dev_err(&pdev->dev, "Alarm interrupt IRQ%d already claimed\n",
+				irq);
+		return status;
+	}
 
-	config->ioaddr = ioremap(res->start, resource_size(res));
+	config->ioaddr = devm_request_and_ioremap(&pdev->dev, res);
 	if (!config->ioaddr) {
-		dev_err(&pdev->dev, "ioremap fail\n");
-		status = -ENOMEM;
-		goto err_disable_clock;
+		dev_err(&pdev->dev, "request-ioremap fail\n");
+		return -ENOMEM;
 	}
 
+	config->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(config->clk))
+		return PTR_ERR(config->clk);
+
+	status = clk_enable(config->clk);
+	if (status < 0)
+		return status;
+
 	spin_lock_init(&config->lock);
 	platform_set_drvdata(pdev, config);
 
@@ -401,22 +408,7 @@ static int __devinit spear_rtc_probe(str
 		dev_err(&pdev->dev, "can't register RTC device, err %ld\n",
 				PTR_ERR(config->rtc));
 		status = PTR_ERR(config->rtc);
-		goto err_iounmap;
-	}
-
-	/* alarm irqs */
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
-		dev_err(&pdev->dev, "no update irq?\n");
-		status = irq;
-		goto err_clear_platdata;
-	}
-
-	status = request_irq(irq, spear_rtc_irq, 0, pdev->name, config);
-	if (status) {
-		dev_err(&pdev->dev, "Alarm interrupt IRQ%d already \
-				claimed\n", irq);
-		goto err_clear_platdata;
+		goto err_disable_clock;
 	}
 
 	if (!device_can_wakeup(&pdev->dev))
@@ -424,19 +416,9 @@ static int __devinit spear_rtc_probe(str
 
 	return 0;
 
-err_clear_platdata:
-	platform_set_drvdata(pdev, NULL);
-	rtc_device_unregister(config->rtc);
-err_iounmap:
-	iounmap(config->ioaddr);
 err_disable_clock:
+	platform_set_drvdata(pdev, NULL);
 	clk_disable(config->clk);
-err_clk_put:
-	clk_put(config->clk);
-err_kfree:
-	kfree(config);
-err_release_region:
-	release_mem_region(res->start, resource_size(res));
 
 	return status;
 }
@@ -444,24 +426,11 @@ err_release_region:
 static int __devexit spear_rtc_remove(struct platform_device *pdev)
 {
 	struct spear_rtc_config *config = platform_get_drvdata(pdev);
-	int irq;
-	struct resource *res;
 
-	/* leave rtc running, but disable irqs */
+	rtc_device_unregister(config->rtc);
 	spear_rtc_disable_interrupt(config);
-	device_init_wakeup(&pdev->dev, 0);
-	irq = platform_get_irq(pdev, 0);
-	if (irq)
-		free_irq(irq, pdev);
 	clk_disable(config->clk);
-	clk_put(config->clk);
-	iounmap(config->ioaddr);
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res)
-		release_mem_region(res->start, resource_size(res));
-	platform_set_drvdata(pdev, NULL);
-	rtc_device_unregister(config->rtc);
-	kfree(config);
+	device_init_wakeup(&pdev->dev, 0);
 
 	return 0;
 }
_

Patches currently in -mm which might be from viresh.kumar@linaro.org are

origin.patch
linux-next.patch

