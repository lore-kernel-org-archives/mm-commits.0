From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-s3cc-convert-to-use-devm_-api.patch added to -mm tree
Date: Tue, 27 Nov 2012 14:28:51 -0800
Message-ID: <20121127222852.C5685200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:36030 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab2K0W26 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Nov 2012 17:28:58 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so432434wey.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Nov 2012 14:28:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tushar.behera@linaro.org, a.zummo@towertech.it, grant.likely@secretlab.ca, rob.herring@calxeda.com


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: convert to use devm_* API
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-s3cc-convert-to-use-devm_-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tushar Behera <tushar.behera@linaro.org>
Subject: drivers/rtc/rtc-s3c.c: convert to use devm_* API

rtc-s3c driver is modified to use devm_request_and_ioremap() (combining
request_mem_region and ioremap), devm_clk_get() and devm_request_irq()
APIs.  Since this removes the necessity of freeing the related resources
the return path is also simplified.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |   45 +++++++---------------------------------
 1 file changed, 8 insertions(+), 37 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-convert-to-use-devm_-api drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-convert-to-use-devm_-api
+++ a/drivers/rtc/rtc-s3c.c
@@ -47,8 +47,6 @@ struct s3c_rtc_drv_data {
 /* I have yet to find an S3C implementation with more than one
  * of these rtc blocks in */
 
-static struct resource *s3c_rtc_mem;
-
 static struct clk *rtc_clk;
 static void __iomem *s3c_rtc_base;
 static int s3c_rtc_alarmno = NO_IRQ;
@@ -427,21 +425,13 @@ static int __devexit s3c_rtc_remove(stru
 {
 	struct rtc_device *rtc = platform_get_drvdata(dev);
 
-	free_irq(s3c_rtc_alarmno, rtc);
-	free_irq(s3c_rtc_tickno, rtc);
-
 	platform_set_drvdata(dev, NULL);
 	rtc_device_unregister(rtc);
 
 	s3c_rtc_setaie(&dev->dev, 0);
 
-	clk_put(rtc_clk);
 	rtc_clk = NULL;
 
-	iounmap(s3c_rtc_base);
-	release_resource(s3c_rtc_mem);
-	kfree(s3c_rtc_mem);
-
 	return 0;
 }
 
@@ -496,27 +486,18 @@ static int __devinit s3c_rtc_probe(struc
 		return -ENOENT;
 	}
 
-	s3c_rtc_mem = request_mem_region(res->start, resource_size(res),
-					 pdev->name);
-
-	if (s3c_rtc_mem == NULL) {
-		dev_err(&pdev->dev, "failed to reserve memory region\n");
-		return -ENOENT;
-	}
-
-	s3c_rtc_base = ioremap(res->start, resource_size(res));
+	s3c_rtc_base = devm_request_and_ioremap(&pdev->dev, res);
 	if (s3c_rtc_base == NULL) {
-		dev_err(&pdev->dev, "failed ioremap()\n");
-		ret = -EINVAL;
-		goto err_nomap;
+		dev_err(&pdev->dev, "failed to ioremap memory region\n");
+		return -EINVAL;
 	}
 
-	rtc_clk = clk_get(&pdev->dev, "rtc");
+	rtc_clk = devm_clk_get(&pdev->dev, "rtc");
 	if (IS_ERR(rtc_clk)) {
 		dev_err(&pdev->dev, "failed to find rtc clock source\n");
 		ret = PTR_ERR(rtc_clk);
 		rtc_clk = NULL;
-		goto err_clk;
+		return ret;
 	}
 
 	clk_enable(rtc_clk);
@@ -575,28 +556,24 @@ static int __devinit s3c_rtc_probe(struc
 
 	s3c_rtc_setfreq(&pdev->dev, 1);
 
-	ret = request_irq(s3c_rtc_alarmno, s3c_rtc_alarmirq,
+	ret = devm_request_irq(&pdev->dev, s3c_rtc_alarmno, s3c_rtc_alarmirq,
 			  0,  "s3c2410-rtc alarm", rtc);
 	if (ret) {
 		dev_err(&pdev->dev, "IRQ%d error %d\n", s3c_rtc_alarmno, ret);
 		goto err_alarm_irq;
 	}
 
-	ret = request_irq(s3c_rtc_tickno, s3c_rtc_tickirq,
+	ret = devm_request_irq(&pdev->dev, s3c_rtc_tickno, s3c_rtc_tickirq,
 			  0,  "s3c2410-rtc tick", rtc);
 	if (ret) {
 		dev_err(&pdev->dev, "IRQ%d error %d\n", s3c_rtc_tickno, ret);
-		free_irq(s3c_rtc_alarmno, rtc);
-		goto err_tick_irq;
+		goto err_alarm_irq;
 	}
 
 	clk_disable(rtc_clk);
 
 	return 0;
 
- err_tick_irq:
-	free_irq(s3c_rtc_alarmno, rtc);
-
  err_alarm_irq:
 	platform_set_drvdata(pdev, NULL);
 	rtc_device_unregister(rtc);
@@ -604,13 +581,7 @@ static int __devinit s3c_rtc_probe(struc
  err_nortc:
 	s3c_rtc_enable(pdev, 0);
 	clk_disable(rtc_clk);
-	clk_put(rtc_clk);
