From: akpm@linux-foundation.org
Subject: + thermal-exynos-use-devm_-functions.patch added to -mm tree
Date: Thu, 16 Aug 2012 11:40:02 -0700
Message-ID: <20120816184003.5590A20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:50508 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2HPSkF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Aug 2012 14:40:05 -0400
Received: by eaac1 with SMTP id c1so147684eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Aug 2012 11:40:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, guenter.roeck@ericsson.com, len.brown@intel.com, lenb@kernel.org, sachin.kamat@samsung.com


The patch titled
     Subject: drivers/thermal/exynos_thermal.c: use devm_* functions
has been added to the -mm tree.  Its filename is
     thermal-exynos-use-devm_-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/thermal/exynos_thermal.c: use devm_* functions

devm_* functions are used to replace kzalloc, request_mem_region, ioremap
and request_irq functions in probe call.  With the usage of devm_*
functions explicit freeing and unmapping is not required.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/exynos_thermal.c |   51 +++++------------------------
 1 file changed, 10 insertions(+), 41 deletions(-)

diff -puN drivers/thermal/exynos_thermal.c~thermal-exynos-use-devm_-functions drivers/thermal/exynos_thermal.c
--- a/drivers/thermal/exynos_thermal.c~thermal-exynos-use-devm_-functions
+++ a/drivers/thermal/exynos_thermal.c
@@ -780,7 +780,9 @@ static int __devinit exynos_tmu_probe(st
 		dev_err(&pdev->dev, "No platform init data supplied.\n");
 		return -ENODEV;
 	}
-	data = kzalloc(sizeof(struct exynos_tmu_data), GFP_KERNEL);
+
+	data = devm_kzalloc(&pdev->dev, sizeof(struct exynos_tmu_data),
+								GFP_KERNEL);
 	if (!data) {
 		dev_err(&pdev->dev, "Failed to allocate driver structure\n");
 		return -ENOMEM;
@@ -788,47 +790,29 @@ static int __devinit exynos_tmu_probe(st
 
 	data->irq = platform_get_irq(pdev, 0);
 	if (data->irq < 0) {
-		ret = data->irq;
 		dev_err(&pdev->dev, "Failed to get platform irq\n");
-		goto err_free;
+		return data->irq;
 	}
 
 	INIT_WORK(&data->irq_work, exynos_tmu_work);
 
 	data->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!data->mem) {
-		ret = -ENOENT;
-		dev_err(&pdev->dev, "Failed to get platform resource\n");
-		goto err_free;
-	}
 
-	data->mem = request_mem_region(data->mem->start,
-			resource_size(data->mem), pdev->name);
-	if (!data->mem) {
-		ret = -ENODEV;
-		dev_err(&pdev->dev, "Failed to request memory region\n");
-		goto err_free;
-	}
-
-	data->base = ioremap(data->mem->start, resource_size(data->mem));
-	if (!data->base) {
-		ret = -ENODEV;
-		dev_err(&pdev->dev, "Failed to ioremap memory\n");
-		goto err_mem_region;
-	}
+	data->base = devm_request_and_ioremap(&pdev->dev, data->mem);
+	if (!data->base)
+		return -ENODEV;
 
-	ret = request_irq(data->irq, exynos_tmu_irq,
+	ret = devm_request_irq(&pdev->dev, data->irq, exynos_tmu_irq,
 		IRQF_TRIGGER_RISING, "exynos-tmu", data);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to request irq: %d\n", data->irq);
-		goto err_io_remap;
+		return ret;
 	}
 
 	data->clk = clk_get(NULL, "tmu_apbif");
 	if (IS_ERR(data->clk)) {
-		ret = PTR_ERR(data->clk);
 		dev_err(&pdev->dev, "Failed to get clock\n");
-		goto err_irq;
+		return PTR_ERR(data->clk);
 	}
 
 	if (pdata->type == SOC_ARCH_EXYNOS5 ||
@@ -880,14 +864,6 @@ static int __devinit exynos_tmu_probe(st
 err_clk:
 	platform_set_drvdata(pdev, NULL);
 	clk_put(data->clk);
-err_irq:
-	free_irq(data->irq, data);
-err_io_remap:
-	iounmap(data->base);
-err_mem_region:
-	release_mem_region(data->mem->start, resource_size(data->mem));
-err_free:
-	kfree(data);
 
 	return ret;
 }
@@ -902,15 +878,8 @@ static int __devexit exynos_tmu_remove(s
 
 	clk_put(data->clk);
 
-	free_irq(data->irq, data);
-
-	iounmap(data->base);
-	release_mem_region(data->mem->start, resource_size(data->mem));
-
 	platform_set_drvdata(pdev, NULL);
 
-	kfree(data);
