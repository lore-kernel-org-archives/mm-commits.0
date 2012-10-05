From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-mxc-adapt-to-the-new-imx-clock-framework.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:17:14 -0700
Message-ID: <20121005201714.B2158100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:50910 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752Ab2JEURP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:17:15 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so236805vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:17:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabio.estevam@freescale.com, a.zummo@towertech.it, s.hauer@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-mxc: adapt to the new i.mx clock framework
has been removed from the -mm tree.  Its filename was
     rtc-rtc-mxc-adapt-to-the-new-imx-clock-framework.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabio Estevam <fabio.estevam@freescale.com>
Subject: rtc: rtc-mxc: adapt to the new i.mx clock framework

i.mx drivers should use clk_prepare_enable/clk_disable_unprepare() in
order to avoid clk warnings.

While at it, convert to devm_clk_get() since other devm_ functions are
used in this driver and it can also save some clk_put() calls.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mxc.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-mxc.c~rtc-rtc-mxc-adapt-to-the-new-imx-clock-framework drivers/rtc/rtc-mxc.c
--- a/drivers/rtc/rtc-mxc.c~rtc-rtc-mxc-adapt-to-the-new-imx-clock-framework
+++ a/drivers/rtc/rtc-mxc.c
@@ -367,14 +367,14 @@ static int __init mxc_rtc_probe(struct p
 	pdata->ioaddr = devm_ioremap(&pdev->dev, res->start,
 				     resource_size(res));
 
-	pdata->clk = clk_get(&pdev->dev, "rtc");
+	pdata->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(pdata->clk)) {
 		dev_err(&pdev->dev, "unable to get clock!\n");
 		ret = PTR_ERR(pdata->clk);
 		goto exit_free_pdata;
 	}
 
-	clk_enable(pdata->clk);
+	clk_prepare_enable(pdata->clk);
 	rate = clk_get_rate(pdata->clk);
 
 	if (rate == 32768)
@@ -426,8 +426,7 @@ static int __init mxc_rtc_probe(struct p
 exit_clr_drvdata:
 	platform_set_drvdata(pdev, NULL);
 exit_put_clk:
-	clk_disable(pdata->clk);
-	clk_put(pdata->clk);
+	clk_disable_unprepare(pdata->clk);
 
 exit_free_pdata:
 
@@ -440,8 +439,7 @@ static int __exit mxc_rtc_remove(struct 
 
 	rtc_device_unregister(pdata->rtc);
 
-	clk_disable(pdata->clk);
-	clk_put(pdata->clk);
+	clk_disable_unprepare(pdata->clk);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
_

Patches currently in -mm which might be from fabio.estevam@freescale.com are

origin.patch
linux-next.patch

