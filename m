From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-sirfsocc-use-devm_rtc_device_register.patch
 added to -mm tree
Date: Thu, 19 Sep 2013 15:10:15 -0700
Message-ID: <523b7647.3aEPfOtxo1nGxh51%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab3ISWKQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 18:10:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, Xianglong.Du@csr.com, sachin.kamat@linaro.org

Subject: + drivers-rtc-rtc-sirfsocc-use-devm_rtc_device_register.patch added to -mm tree
To: sachin.kamat@linaro.org,Xianglong.Du@csr.com,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 15:10:15 -0700


The patch titled
     Subject: drivers/rtc/rtc-sirfsoc.c: use devm_rtc_device_register
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-sirfsocc-use-devm_rtc_device_register.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-sirfsocc-use-devm_rtc_device_register.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-sirfsocc-use-devm_rtc_device_register.patch

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
Subject: drivers/rtc/rtc-sirfsoc.c: use devm_rtc_device_register

devm_rtc_device_register simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Xianglong Du <Xianglong.Du@csr.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-sirfsoc.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-sirfsoc.c~drivers-rtc-rtc-sirfsocc-use-devm_rtc_device_register drivers/rtc/rtc-sirfsoc.c
--- a/drivers/rtc/rtc-sirfsoc.c~drivers-rtc-rtc-sirfsocc-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-sirfsoc.c
@@ -274,7 +274,7 @@ static int sirfsoc_rtc_probe(struct plat
 	err = of_property_read_u32(np, "reg", &rtcdrv->rtc_base);
 	if (err) {
 		dev_err(&pdev->dev, "unable to find base address of rtc node in dtb\n");
-		goto error;
+		return err;
 	}
 
 	platform_set_drvdata(pdev, rtcdrv);
@@ -290,7 +290,7 @@ static int sirfsoc_rtc_probe(struct plat
 	rtc_div = ((32768 / RTC_HZ) / 2) - 1;
 	sirfsoc_rtc_iobrg_writel(rtc_div, rtcdrv->rtc_base + RTC_DIV);
 
-	rtcdrv->rtc = rtc_device_register(pdev->name, &(pdev->dev),
+	rtcdrv->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 			&sirfsoc_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtcdrv->rtc)) {
 		err = PTR_ERR(rtcdrv->rtc);
@@ -322,24 +322,15 @@ static int sirfsoc_rtc_probe(struct plat
 			rtcdrv);
 	if (err) {
 		dev_err(&pdev->dev, "Unable to register for the SiRF SOC RTC IRQ\n");
-		goto error;
+		return err;
 	}
 
 	return 0;
-
-error:
-	if (rtcdrv->rtc)
-		rtc_device_unregister(rtcdrv->rtc);
-
-	return err;
 }
 
 static int sirfsoc_rtc_remove(struct platform_device *pdev)
 {
-	struct sirfsoc_rtc_drv *rtcdrv = platform_get_drvdata(pdev);
