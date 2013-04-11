From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-m48t35c-use-devm_-apis.patch added to -mm tree
Date: Thu, 11 Apr 2013 16:01:49 -0700
Message-ID: <20130411230149.CC2FB5A4228@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:42818 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933289Ab3DKXBu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 19:01:50 -0400
Received: by mail-gh0-f201.google.com with SMTP id r13so196391ghr.2
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 16:01:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, jg1.han@samsung.com, tsbogend@alpha.franken.de


The patch titled
     Subject: drivers/rtc/rtc-m48t35.c: use devm_* APIs
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-m48t35c-use-devm_-apis.patch

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
Subject: drivers/rtc/rtc-m48t35.c: use devm_* APIs

devm_* functions are device managed and make cleanup code simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m48t35.c |   42 ++++++++-----------------------------
 1 file changed, 10 insertions(+), 32 deletions(-)

diff -puN drivers/rtc/rtc-m48t35.c~drivers-rtc-rtc-m48t35c-use-devm_-apis drivers/rtc/rtc-m48t35.c
--- a/drivers/rtc/rtc-m48t35.c~drivers-rtc-rtc-m48t35c-use-devm_-apis
+++ a/drivers/rtc/rtc-m48t35.c
@@ -145,12 +145,11 @@ static int m48t35_probe(struct platform_
 {
 	struct resource *res;
 	struct m48t35_priv *priv;
-	int ret = 0;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENODEV;
-	priv = kzalloc(sizeof(struct m48t35_priv), GFP_KERNEL);
+	priv = devm_kzalloc(&pdev->dev, sizeof(struct m48t35_priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
@@ -160,50 +159,29 @@ static int m48t35_probe(struct platform_
 	 * conflicts are resolved
 	 */
 #ifndef CONFIG_SGI_IP27
-	if (!request_mem_region(res->start, priv->size, pdev->name)) {
-		ret = -EBUSY;
-		goto out;
-	}
+	if (!devm_request_mem_region(&pdev->dev, res->start, priv->size,
+				     pdev->name))
+		return -EBUSY;
 #endif
 	priv->baseaddr = res->start;
-	priv->reg = ioremap(priv->baseaddr, priv->size);
-	if (!priv->reg) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	priv->reg = devm_ioremap(&pdev->dev, priv->baseaddr, priv->size);
+	if (!priv->reg)
+		return -ENOMEM;
 
 	spin_lock_init(&priv->lock);
 
 	platform_set_drvdata(pdev, priv);
 
-	priv->rtc = rtc_device_register("m48t35", &pdev->dev,
+	priv->rtc = devm_rtc_device_register(&pdev->dev, "m48t35",
 				  &m48t35_ops, THIS_MODULE);
-	if (IS_ERR(priv->rtc)) {
-		ret = PTR_ERR(priv->rtc);
-		goto out;
-	}
+	if (IS_ERR(priv->rtc))
+		return PTR_ERR(priv->rtc);
 
 	return 0;
-
-out:
-	if (priv->reg)
-		iounmap(priv->reg);
-	if (priv->baseaddr)
-		release_mem_region(priv->baseaddr, priv->size);
-	kfree(priv);
-	return ret;
 }
 
 static int m48t35_remove(struct platform_device *pdev)
 {
-	struct m48t35_priv *priv = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(priv->rtc);
-	iounmap(priv->reg);
-#ifndef CONFIG_SGI_IP27
-	release_mem_region(priv->baseaddr, priv->size);
-#endif
-	kfree(priv);
 	return 0;
 }
 
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

linux-next.patch
drivers-video-exynos-exynos_mipi_dsic-convert-to-devm_ioremap_resource.patch
drivers-rtc-rtc-tps6586xc-remove-incorrect-use-of-rtc_device_unregister.patch
drivers-rtc-rtc-tps65910c-fix-incorrect-return-value-on-error.patch
drivers-rtc-rtc-max8997c-fix-incorrect-return-value-on-error.patch
drivers-rtc-rtc-max77686c-fix-incorrect-return-value-on-error.patch
drivers-rtc-rtc-max8907c-remove-redundant-code.patch
drivers-rtc-rtc-max77686c-use-devm_regmap_init_i2c.patch
drivers-rtc-rtc-88pm860xc-use-devm_-apis.patch
drivers-rtc-rtc-at32ap700xc-use-devm_-apis.patch
drivers-rtc-rtc-ds1305c-use-devm_-apis.patch
drivers-rtc-rtc-ds1374c-use-devm_-apis.patch
drivers-rtc-rtc-ds3232c-use-devm_-apis.patch
drivers-rtc-rtc-m48t35c-use-devm_-apis.patch
drivers-rtc-rtc-max8925c-use-devm_-apis.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch

