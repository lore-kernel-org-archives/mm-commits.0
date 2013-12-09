From: akpm@linux-foundation.org
Subject: + rtc-rtc-twl-use-devm_-functions.patch added to -mm tree
Date: Mon, 09 Dec 2013 15:17:46 -0800
Message-ID: <52a64f9a.+xSTa0m0AcmZnrAG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54914 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab3LIXRr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Dec 2013 18:17:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yuasa@linux-mips.org, grygorii.strashko@ti.com, jg1.han@samsung.com

Subject: + rtc-rtc-twl-use-devm_-functions.patch added to -mm tree
To: jg1.han@samsung.com,grygorii.strashko@ti.com,yuasa@linux-mips.org
From: akpm@linux-foundation.org
Date: Mon, 09 Dec 2013 15:17:46 -0800


The patch titled
     Subject: drivers/rtc/rtc-twl.c: use devm_*() functions
has been added to the -mm tree.  Its filename is
     rtc-rtc-twl-use-devm_-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-twl-use-devm_-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rtc-twl-use-devm_-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/rtc/rtc-twl.c: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler, and remove
unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Yoichi Yuasa <yuasa@linux-mips.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-twl.c |   38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

diff -puN drivers/rtc/rtc-twl.c~rtc-rtc-twl-use-devm_-functions drivers/rtc/rtc-twl.c
--- a/drivers/rtc/rtc-twl.c~rtc-rtc-twl-use-devm_-functions
+++ a/drivers/rtc/rtc-twl.c
@@ -479,7 +479,7 @@ static int twl_rtc_probe(struct platform
 	u8 rd_reg;
 
 	if (irq <= 0)
-		goto out1;
+		return ret;
 
 	/* Initialize the register map */
 	if (twl_class_is_4030())
@@ -489,7 +489,7 @@ static int twl_rtc_probe(struct platform
 
 	ret = twl_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
 	if (ret < 0)
-		goto out1;
+		return ret;
 
 	if (rd_reg & BIT_RTC_STATUS_REG_POWER_UP_M)
 		dev_warn(&pdev->dev, "Power up reset detected.\n");
@@ -500,7 +500,7 @@ static int twl_rtc_probe(struct platform
 	/* Clear RTC Power up reset and pending alarm interrupts */
 	ret = twl_rtc_write_u8(rd_reg, REG_RTC_STATUS_REG);
 	if (ret < 0)
-		goto out1;
+		return ret;
 
 	if (twl_class_is_6030()) {
 		twl6030_interrupt_unmask(TWL6030_RTC_INT_MASK,
@@ -512,7 +512,7 @@ static int twl_rtc_probe(struct platform
 	dev_info(&pdev->dev, "Enabling TWL-RTC\n");
 	ret = twl_rtc_write_u8(BIT_RTC_CTRL_REG_STOP_RTC_M, REG_RTC_CTRL_REG);
 	if (ret < 0)
-		goto out1;
+		return ret;
 
 	/* ensure interrupts are disabled, bootloaders can be strange */
 	ret = twl_rtc_write_u8(0, REG_RTC_INTERRUPTS_REG);
@@ -522,34 +522,29 @@ static int twl_rtc_probe(struct platform
 	/* init cached IRQ enable bits */
 	ret = twl_rtc_read_u8(&rtc_irq_bits, REG_RTC_INTERRUPTS_REG);
 	if (ret < 0)
-		goto out1;
+		return ret;
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	rtc = rtc_device_register(pdev->name,
-				  &pdev->dev, &twl_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
+					&twl_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
-		ret = PTR_ERR(rtc);
 		dev_err(&pdev->dev, "can't register RTC device, err %ld\n",
 			PTR_ERR(rtc));
-		goto out1;
+		return PTR_ERR(rtc);
 	}
 
-	ret = request_threaded_irq(irq, NULL, twl_rtc_interrupt,
-				   IRQF_TRIGGER_RISING | IRQF_ONESHOT,
-				   dev_name(&rtc->dev), rtc);
+	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+					twl_rtc_interrupt,
+					IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+					dev_name(&rtc->dev), rtc);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "IRQ is not free.\n");
-		goto out2;
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, rtc);
 	return 0;
-
-out2:
-	rtc_device_unregister(rtc);
-out1:
-	return ret;
 }
 
 /*
@@ -559,9 +554,6 @@ out1:
 static int twl_rtc_remove(struct platform_device *pdev)
 {
 	/* leave rtc running, but disable irqs */
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
-	int irq = platform_get_irq(pdev, 0);
-
 	mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
 	mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_TIMER_M);
 	if (twl_class_is_6030()) {
@@ -571,10 +563,6 @@ static int twl_rtc_remove(struct platfor
 			REG_INT_MSK_STS_A);
 	}
 
-
-	free_irq(irq, rtc);
