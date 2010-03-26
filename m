From: akpm@linux-foundation.org
Subject: + rtc-mxc-remove-unnecessary-clock-source-for-rtc-subsystem.patch added to -mm tree
Date: Fri, 26 Mar 2010 14:50:11 -0700
Message-ID: <201003262150.o2QLoBEh022588@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752276Ab0CZVut (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 17:50:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vzapolskiy@gmail.com, a.zummo@towertech.it, akpm@linux-foundation.org, daniel@caiaq.de, p_gortmaker@yahoo.com


The patch titled
     rtc-mxc: remove unnecessary clock source for rtc subsystem
has been added to the -mm tree.  Its filename is
     rtc-mxc-remove-unnecessary-clock-source-for-rtc-subsystem.patch

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
Subject: rtc-mxc: remove unnecessary clock source for rtc subsystem
From: Vladimir Zapolskiy <vzapolskiy@gmail.com>

On imx SoCs rtc clock parent is CKIL, but clock rate shall be determined
using rtc clock itself, that eliminates CKIL clock usage in the driver.

Signed-off-by: Vladimir Zapolskiy <vzapolskiy@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Daniel Mack <daniel@caiaq.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mxc.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff -puN drivers/rtc/rtc-mxc.c~rtc-mxc-remove-unnecessary-clock-source-for-rtc-subsystem drivers/rtc/rtc-mxc.c
--- a/drivers/rtc/rtc-mxc.c~rtc-mxc-remove-unnecessary-clock-source-for-rtc-subsystem
+++ a/drivers/rtc/rtc-mxc.c
@@ -378,7 +378,6 @@ static struct rtc_class_ops mxc_rtc_ops 
 
 static int __init mxc_rtc_probe(struct platform_device *pdev)
 {
-	struct clk *clk;
 	struct resource *res;
 	struct rtc_device *rtc;
 	struct rtc_plat_data *pdata = NULL;
@@ -401,14 +400,15 @@ static int __init mxc_rtc_probe(struct p
 	pdata->ioaddr = devm_ioremap(&pdev->dev, res->start,
 				     resource_size(res));
 
-	clk = clk_get(&pdev->dev, "ckil");
-	if (IS_ERR(clk)) {
-		ret = PTR_ERR(clk);
+	pdata->clk = clk_get(&pdev->dev, "rtc");
+	if (IS_ERR(pdata->clk)) {
+		dev_err(&pdev->dev, "unable to get clock!\n");
+		ret = PTR_ERR(pdata->clk);
 		goto exit_free_pdata;
 	}
 
-	rate = clk_get_rate(clk);
-	clk_put(clk);
+	clk_enable(pdata->clk);
+	rate = clk_get_rate(pdata->clk);
 
 	if (rate == 32768)
 		reg = RTC_INPUT_CLK_32768HZ;
@@ -419,7 +419,7 @@ static int __init mxc_rtc_probe(struct p
 	else {
 		dev_err(&pdev->dev, "rtc clock is not valid (%lu)\n", rate);
 		ret = -EINVAL;
-		goto exit_free_pdata;
+		goto exit_put_clk;
 	}
 
 	reg |= RTC_ENABLE_BIT;
@@ -427,18 +427,9 @@ static int __init mxc_rtc_probe(struct p
 	if (((readw(pdata->ioaddr + RTC_RTCCTL)) & RTC_ENABLE_BIT) == 0) {
 		dev_err(&pdev->dev, "hardware module can't be enabled!\n");
 		ret = -EIO;
-		goto exit_free_pdata;
-	}
-
-	pdata->clk = clk_get(&pdev->dev, "rtc");
-	if (IS_ERR(pdata->clk)) {
-		dev_err(&pdev->dev, "unable to get clock!\n");
-		ret = PTR_ERR(pdata->clk);
-		goto exit_free_pdata;
+		goto exit_put_clk;
 	}
 
-	clk_enable(pdata->clk);
