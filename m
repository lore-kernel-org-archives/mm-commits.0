From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-davinci-use-devm_kzalloc.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:08:10 -0800
Message-ID: <20121218200810.AF134100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:54259 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab2LRUIL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:08:11 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so125831ggn.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:08:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: devendra.aaru@gmail.com, a.zummo@towertech.it, miguel.aguilar@ridgerun.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-davinci: use devm_kzalloc()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-davinci-use-devm_kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Devendra Naga <devendra.aaru@gmail.com>
Subject: rtc: rtc-davinci: use devm_kzalloc()

Use devm_kzalloc() and remove the error path free and the unload free as
devm functions take care of freeing resources.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Miguel Aguilar <miguel.aguilar@ridgerun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-davinci.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-davinci.c~rtc-rtc-davinci-use-devm_kzalloc drivers/rtc/rtc-davinci.c
--- a/drivers/rtc/rtc-davinci.c~rtc-rtc-davinci-use-devm_kzalloc
+++ a/drivers/rtc/rtc-davinci.c
@@ -485,7 +485,7 @@ static int __init davinci_rtc_probe(stru
 	struct resource *res, *mem;
 	int ret = 0;
 
-	davinci_rtc = kzalloc(sizeof(struct davinci_rtc), GFP_KERNEL);
+	davinci_rtc = devm_kzalloc(&pdev->dev, sizeof(struct davinci_rtc), GFP_KERNEL);
 	if (!davinci_rtc) {
 		dev_dbg(dev, "could not allocate memory for private data\n");
 		return -ENOMEM;
@@ -494,15 +494,13 @@ static int __init davinci_rtc_probe(stru
 	davinci_rtc->irq = platform_get_irq(pdev, 0);
 	if (davinci_rtc->irq < 0) {
 		dev_err(dev, "no RTC irq\n");
-		ret = davinci_rtc->irq;
-		goto fail1;
+		return davinci_rtc->irq;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(dev, "no mem resource\n");
-		ret = -EINVAL;
-		goto fail1;
+		return -EINVAL;
 	}
 
 	davinci_rtc->pbase = res->start;
@@ -513,8 +511,7 @@ static int __init davinci_rtc_probe(stru
 	if (!mem) {
 		dev_err(dev, "RTC registers at %08x are not free\n",
 			davinci_rtc->pbase);
-		ret = -EBUSY;
-		goto fail1;
+		return -EBUSY;
 	}
 
 	davinci_rtc->base = ioremap(davinci_rtc->pbase, davinci_rtc->base_size);
@@ -567,9 +564,6 @@ fail3:
 	iounmap(davinci_rtc->base);
 fail2:
 	release_mem_region(davinci_rtc->pbase, davinci_rtc->base_size);
-fail1:
-	kfree(davinci_rtc);
-
 	return ret;
 }
 
@@ -590,8 +584,6 @@ static int __devexit davinci_rtc_remove(
 
 	platform_set_drvdata(pdev, NULL);
 
-	kfree(davinci_rtc);
