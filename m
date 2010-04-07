From: akpm@linux-foundation.org
Subject: [merged] rtc-mxc-multiple-fixes-in-rtc-mxc-probe-method.patch removed from -mm tree
Date: Wed, 07 Apr 2010 11:50:36 -0400
Message-ID: <201004071852.o37Iq3vb001345@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757529Ab0DGSwS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 14:52:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vzapolskiy@gmail.com, a.zummo@towertech.it, daniel@caiaq.de, mm-commits@vger.kernel.org


The patch titled
     rtc-mxc: multiple fixes in rtc-mxc probe method
has been removed from the -mm tree.  Its filename was
     rtc-mxc-multiple-fixes-in-rtc-mxc-probe-method.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: coding-style fixes]
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
@@ -384,21 +384,26 @@ static int __init mxc_rtc_probe(struct p
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
+				     resource_size(res), pdev->name))
+		return -EBUSY;
+
+	pdata->ioaddr = devm_ioremap(&pdev->dev, res->start,
+				     resource_size(res));
 
 	clk = clk_get(&pdev->dev, "ckil");
 	if (IS_ERR(clk)) {
-		iounmap(pdata->ioaddr);
 		ret = PTR_ERR(clk);
 		goto exit_free_pdata;
 	}
@@ -413,8 +418,7 @@ static int __init mxc_rtc_probe(struct p
 	else if (rate == 38400)
 		reg = RTC_INPUT_CLK_38400HZ;
 	else {
-		dev_err(&pdev->dev, "rtc clock is not valid (%lu)\n",
-			clk_get_rate(clk));
+		dev_err(&pdev->dev, "rtc clock is not valid (%lu)\n", rate);
 		ret = -EINVAL;
 		goto exit_free_pdata;
 	}
@@ -450,8 +454,8 @@ static int __init mxc_rtc_probe(struct p
 	pdata->irq = platform_get_irq(pdev, 0);
 
 	if (pdata->irq >= 0 &&
-	    request_irq(pdata->irq, mxc_rtc_interrupt, IRQF_SHARED,
-			pdev->name, pdev) < 0) {
+	    devm_request_irq(&pdev->dev, pdata->irq, mxc_rtc_interrupt,
+			     IRQF_SHARED, pdev->name, pdev) < 0) {
 		dev_warn(&pdev->dev, "interrupt not available.\n");
 		pdata->irq = -1;
 	}
@@ -459,10 +463,10 @@ static int __init mxc_rtc_probe(struct p
 	return 0;
 
 exit_put_clk:
+	clk_disable(pdata->clk);
 	clk_put(pdata->clk);
 
 exit_free_pdata:
-	kfree(pdata);
 
 	return ret;
 }
@@ -473,12 +477,8 @@ static int __exit mxc_rtc_remove(struct 
 
 	rtc_device_unregister(pdata->rtc);
 
-	if (pdata->irq >= 0)
-		free_irq(pdata->irq, pdev);
