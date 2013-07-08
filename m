From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-sh-use-devm_-functions.patch removed from -mm
 tree
Date: Mon, 08 Jul 2013 12:33:36 -0700
Message-ID: <51db1410.Pt4odObUMdZ7l16X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab3GHTdg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:33:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] rtc-rtc-sh-use-devm_-functions.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:33:36 -0700


The patch titled
     Subject: rtc: rtc-sh: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-sh-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-sh: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-sh.c |   74 ++++++++++++-----------------------------
 1 file changed, 22 insertions(+), 52 deletions(-)

diff -puN drivers/rtc/rtc-sh.c~rtc-rtc-sh-use-devm_-functions drivers/rtc/rtc-sh.c
--- a/drivers/rtc/rtc-sh.c~rtc-rtc-sh-use-devm_-functions
+++ a/drivers/rtc/rtc-sh.c
@@ -593,7 +593,7 @@ static int __init sh_rtc_probe(struct pl
 	char clk_name[6];
 	int clk_id, ret;
 
-	rtc = kzalloc(sizeof(struct sh_rtc), GFP_KERNEL);
+	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
 	if (unlikely(!rtc))
 		return -ENOMEM;
 
@@ -602,9 +602,8 @@ static int __init sh_rtc_probe(struct pl
 	/* get periodic/carry/alarm irqs */
 	ret = platform_get_irq(pdev, 0);
 	if (unlikely(ret <= 0)) {
-		ret = -ENOENT;
 		dev_err(&pdev->dev, "No IRQ resource\n");
-		goto err_badres;
+		return -ENOENT;
 	}
 
 	rtc->periodic_irq = ret;
@@ -613,24 +612,21 @@ static int __init sh_rtc_probe(struct pl
 
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
 	if (unlikely(res == NULL)) {
-		ret = -ENOENT;
 		dev_err(&pdev->dev, "No IO resource\n");
-		goto err_badres;
+		return -ENOENT;
 	}
 
 	rtc->regsize = resource_size(res);
 
-	rtc->res = request_mem_region(res->start, rtc->regsize, pdev->name);
-	if (unlikely(!rtc->res)) {
-		ret = -EBUSY;
-		goto err_badres;
-	}
-
-	rtc->regbase = ioremap_nocache(rtc->res->start, rtc->regsize);
-	if (unlikely(!rtc->regbase)) {
-		ret = -EINVAL;
-		goto err_badmap;
-	}
+	rtc->res = devm_request_mem_region(&pdev->dev, res->start,
+					rtc->regsize, pdev->name);
+	if (unlikely(!rtc->res))
+		return -EBUSY;
+
+	rtc->regbase = devm_ioremap_nocache(&pdev->dev, rtc->res->start,
+					rtc->regsize);
+	if (unlikely(!rtc->regbase))
+		return -EINVAL;
 
 	clk_id = pdev->id;
 	/* With a single device, the clock id is still "rtc0" */
@@ -639,7 +635,7 @@ static int __init sh_rtc_probe(struct pl
 
 	snprintf(clk_name, sizeof(clk_name), "rtc%d", clk_id);
 
-	rtc->clk = clk_get(&pdev->dev, clk_name);
+	rtc->clk = devm_clk_get(&pdev->dev, clk_name);
 	if (IS_ERR(rtc->clk)) {
 		/*
 		 * No error handling for rtc->clk intentionally, not all
@@ -665,8 +661,8 @@ static int __init sh_rtc_probe(struct pl
 
 	if (rtc->carry_irq <= 0) {
 		/* register shared periodic/carry/alarm irq */
-		ret = request_irq(rtc->periodic_irq, sh_rtc_shared,
-				  0, "sh-rtc", rtc);
+		ret = devm_request_irq(&pdev->dev, rtc->periodic_irq,
+				sh_rtc_shared, 0, "sh-rtc", rtc);
 		if (unlikely(ret)) {
 			dev_err(&pdev->dev,
 				"request IRQ failed with %d, IRQ %d\n", ret,
@@ -675,8 +671,8 @@ static int __init sh_rtc_probe(struct pl
 		}
 	} else {
 		/* register periodic/carry/alarm irqs */
-		ret = request_irq(rtc->periodic_irq, sh_rtc_periodic,
-				  0, "sh-rtc period", rtc);
+		ret = devm_request_irq(&pdev->dev, rtc->periodic_irq,
+				sh_rtc_periodic, 0, "sh-rtc period", rtc);
 		if (unlikely(ret)) {
 			dev_err(&pdev->dev,
 				"request period IRQ failed with %d, IRQ %d\n",
@@ -684,24 +680,21 @@ static int __init sh_rtc_probe(struct pl
 			goto err_unmap;
 		}
 
-		ret = request_irq(rtc->carry_irq, sh_rtc_interrupt,
-				  0, "sh-rtc carry", rtc);
+		ret = devm_request_irq(&pdev->dev, rtc->carry_irq,
+				sh_rtc_interrupt, 0, "sh-rtc carry", rtc);
 		if (unlikely(ret)) {
 			dev_err(&pdev->dev,
 				"request carry IRQ failed with %d, IRQ %d\n",
 				ret, rtc->carry_irq);
-			free_irq(rtc->periodic_irq, rtc);
 			goto err_unmap;
 		}
 
-		ret = request_irq(rtc->alarm_irq, sh_rtc_alarm,
-				  0, "sh-rtc alarm", rtc);
+		ret = devm_request_irq(&pdev->dev, rtc->alarm_irq,
+				sh_rtc_alarm, 0, "sh-rtc alarm", rtc);
 		if (unlikely(ret)) {
 			dev_err(&pdev->dev,
 				"request alarm IRQ failed with %d, IRQ %d\n",
 				ret, rtc->alarm_irq);
-			free_irq(rtc->carry_irq, rtc);
-			free_irq(rtc->periodic_irq, rtc);
 			goto err_unmap;
 		}
 	}
@@ -714,13 +707,10 @@ static int __init sh_rtc_probe(struct pl
 	sh_rtc_setaie(&pdev->dev, 0);
 	sh_rtc_setcie(&pdev->dev, 0);
 
-	rtc->rtc_dev = rtc_device_register("sh", &pdev->dev,
+	rtc->rtc_dev = devm_rtc_device_register(&pdev->dev, "sh",
 					   &sh_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc_dev)) {
 		ret = PTR_ERR(rtc->rtc_dev);
-		free_irq(rtc->periodic_irq, rtc);
-		free_irq(rtc->carry_irq, rtc);
-		free_irq(rtc->alarm_irq, rtc);
 		goto err_unmap;
 	}
 
@@ -737,12 +727,6 @@ static int __init sh_rtc_probe(struct pl
 
 err_unmap:
 	clk_disable(rtc->clk);
-	clk_put(rtc->clk);
-	iounmap(rtc->regbase);
-err_badmap:
-	release_mem_region(rtc->res->start, rtc->regsize);
-err_badres:
-	kfree(rtc);
 
 	return ret;
 }
@@ -751,26 +735,12 @@ static int __exit sh_rtc_remove(struct p
 {
 	struct sh_rtc *rtc = platform_get_drvdata(pdev);
 
-	rtc_device_unregister(rtc->rtc_dev);
 	sh_rtc_irq_set_state(&pdev->dev, 0);
 
 	sh_rtc_setaie(&pdev->dev, 0);
 	sh_rtc_setcie(&pdev->dev, 0);
 
-	free_irq(rtc->periodic_irq, rtc);
-
-	if (rtc->carry_irq > 0) {
-		free_irq(rtc->carry_irq, rtc);
-		free_irq(rtc->alarm_irq, rtc);
-	}
-
-	iounmap(rtc->regbase);
-	release_mem_region(rtc->res->start, rtc->regsize);
-
 	clk_disable(rtc->clk);
-	clk_put(rtc->clk);
