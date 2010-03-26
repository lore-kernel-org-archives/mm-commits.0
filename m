From: akpm@linux-foundation.org
Subject: + rtc-mxc-multiple-fixes-in-rtc-mxc-probe-method.patch added to -mm tree
Date: Fri, 26 Mar 2010 14:48:06 -0700
Message-ID: <201003262148.o2QLm6CE022457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754064Ab0CZVsv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 17:48:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vzapolskiy@gmail.com, a.zummo@towertech.it, daniel@caiaq.de


The patch titled
     rtc-mxc: multiple fixes in rtc-mxc probe method
has been added to the -mm tree.  Its filename is
     rtc-mxc-multiple-fixes-in-rtc-mxc-probe-method.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-mxc: multiple fixes in rtc-mxc probe method
From: Vladimir Zapolskiy <vzapolskiy@gmail.com>

On exit paths in mxc_rtc_probe() method some resources are not freed
correctly.

This patch fixes:
* unrequested memory region containing imx RTC registers
* iounmap() isn't called on exit_free_pdata branch
* clock get rate is called for freed clock source
* clock isn't disabled on exit_put_clk branch

To simplify the fix managed device resources are used.

Signed-off-by: Vladimir Zapolskiy <vzapolskiy@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Daniel Mack <daniel@caiaq.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mxc.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN drivers/rtc/rtc-mxc.c~rtc-mxc-multiple-fixes-in-rtc-mxc-probe-method drivers/rtc/rtc-mxc.c
--- a/drivers/rtc/rtc-mxc.c~rtc-mxc-multiple-fixes-in-rtc-mxc-probe-method
+++ a/drivers/rtc/rtc-mxc.c
@@ -383,21 +383,26 @@ static int __init mxc_rtc_probe(struct p
 	struct rtc_device *rtc;
 	struct rtc_plat_data *pdata = NULL;
 	u32 reg;
-	int ret, rate;
+	unsigned long rate;
+	int ret;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENODEV;
 
-	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
 
-	pdata->ioaddr = ioremap(res->start, resource_size(res));
+	if (!devm_request_mem_region(&pdev->dev, res->start,
+	                             resource_size(res), pdev->name))
+		return -EBUSY;
+
+	pdata->ioaddr = devm_ioremap(&pdev->dev, res->start,
+	                             resource_size(res));
 
 	clk = clk_get(&pdev->dev, "ckil");
 	if (IS_ERR(clk)) {
-		iounmap(pdata->ioaddr);
 		ret = PTR_ERR(clk);
 		goto exit_free_pdata;
 	}
@@ -412,8 +417,7 @@ static int __init mxc_rtc_probe(struct p
 	else if (rate == 38400)
 		reg = RTC_INPUT_CLK_38400HZ;
 	else {
-		dev_err(&pdev->dev, "rtc clock is not valid (%lu)\n",
-			clk_get_rate(clk));
+		dev_err(&pdev->dev, "rtc clock is not valid (%lu)\n", rate);
 		ret = -EINVAL;
 		goto exit_free_pdata;
 	}
@@ -449,8 +453,8 @@ static int __init mxc_rtc_probe(struct p
 	pdata->irq = platform_get_irq(pdev, 0);
 
 	if (pdata->irq >= 0 &&
-	    request_irq(pdata->irq, mxc_rtc_interrupt, IRQF_SHARED,
-			pdev->name, pdev) < 0) {
+	    devm_request_irq(&pdev->dev, pdata->irq, mxc_rtc_interrupt,
+	                     IRQF_SHARED, pdev->name, pdev) < 0) {
 		dev_warn(&pdev->dev, "interrupt not available.\n");
 		pdata->irq = -1;
 	}
@@ -458,10 +462,10 @@ static int __init mxc_rtc_probe(struct p
 	return 0;
 
 exit_put_clk:
+	clk_disable(pdata->clk);
 	clk_put(pdata->clk);
 
 exit_free_pdata:
-	kfree(pdata);
 
 	return ret;
 }
@@ -472,12 +476,8 @@ static int __exit mxc_rtc_remove(struct 
 
 	rtc_device_unregister(pdata->rtc);
 
-	if (pdata->irq >= 0)
-		free_irq(pdata->irq, pdev);
