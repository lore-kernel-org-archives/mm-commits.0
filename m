From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-m48t35c-use-devm_-apis.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:59:46 -0700
Message-ID: <20130430185946.7756B5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:57533 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933476Ab3D3S7r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:59:47 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so87205yen.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:59:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, jg1.han@samsung.com, tsbogend@alpha.franken.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-m48t35.c: use devm_* APIs
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-m48t35c-use-devm_-apis.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
