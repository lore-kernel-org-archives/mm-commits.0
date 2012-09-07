From: akpm@linux-foundation.org
Subject: + rtc-rtc-mxc-adapt-to-the-new-imx-clock-framework.patch added to -mm tree
Date: Fri, 07 Sep 2012 14:58:06 -0700
Message-ID: <20120907215807.A23CE2001BB@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:46675 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757435Ab2IGV6K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Sep 2012 17:58:10 -0400
Received: by lagw12 with SMTP id w12so2395lag.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Sep 2012 14:58:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fabio.estevam@freescale.com, a.zummo@towertech.it, s.hauer@pengutronix.de


The patch titled
     Subject: rtc: rtc-mxc: adapt to the new i.mx clock framework
has been added to the -mm tree.  Its filename is
     rtc-rtc-mxc-adapt-to-the-new-imx-clock-framework.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
dma-dmaengine-lower-the-priority-of-failed-to-get-dma-channel-message.patch
rtc-rtc-mxc-adapt-to-the-new-imx-clock-framework.patch
rtc-rtc-mxc-convert-to-module_platform_driver.patch

