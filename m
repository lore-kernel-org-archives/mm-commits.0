From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-jz4740c-add-alarm-function.patch added to -mm tree
Date: Thu, 21 Oct 2010 16:56:57 -0700
Message-ID: <201010212356.o9LNuvfF012272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751783Ab0JUX5e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 19:57:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paul@crapouillou.net, a.zummo@towertech.it, lars@metafoo.de, mcuos.com@gmail.com, p_gortmaker@yahoo.com, ralf@linux-mips.org


The patch titled
     drivers/rtc/rtc-jz4740.c: add alarm function
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-jz4740c-add-alarm-function.patch

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
Subject: drivers/rtc/rtc-jz4740.c: add alarm function
From: Paul Cercueil <paul@crapouillou.net>

Add the "alarm" function to the jz4740 RTC.  Interrupts will now be raised
when the "alarm" time is reached.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-jz4740.c |   45 ++++++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-jz4740.c~drivers-rtc-rtc-jz4740c-add-alarm-function drivers/rtc/rtc-jz4740.c
--- a/drivers/rtc/rtc-jz4740.c~drivers-rtc-rtc-jz4740c-add-alarm-function
+++ a/drivers/rtc/rtc-jz4740.c
@@ -1,5 +1,6 @@
 /*
  *  Copyright (C) 2009-2010, Lars-Peter Clausen <lars@metafoo.de>
+ *  Copyright (C) 2010, Paul Cercueil <paul@crapouillou.net>
  *	 JZ4740 SoC RTC driver
  *
  *  This program is free software; you can redistribute it and/or modify it
@@ -161,7 +162,8 @@ static int jz4740_rtc_set_alarm(struct d
 
 	ret = jz4740_rtc_reg_write(rtc, JZ_REG_RTC_SEC_ALARM, secs);
 	if (!ret)
-		ret = jz4740_rtc_ctrl_set_bits(rtc, JZ_RTC_CTRL_AE, alrm->enabled);
+		ret = jz4740_rtc_ctrl_set_bits(rtc,
+			JZ_RTC_CTRL_AE | JZ_RTC_CTRL_AF_IRQ, alrm->enabled);
 
 	return ret;
 }
@@ -258,6 +260,8 @@ static int __devinit jz4740_rtc_probe(st
 
 	platform_set_drvdata(pdev, rtc);
 
+	device_init_wakeup(&pdev->dev, 1);
+
 	rtc->rtc = rtc_device_register(pdev->name, &pdev->dev, &jz4740_rtc_ops,
 					THIS_MODULE);
 	if (IS_ERR(rtc->rtc)) {
@@ -318,12 +322,43 @@ static int __devexit jz4740_rtc_remove(s
 	return 0;
 }
 
+
+#ifdef CONFIG_PM
+static int jz4740_rtc_suspend(struct device *dev)
+{
+	struct jz4740_rtc *rtc = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		enable_irq_wake(rtc->irq);
+	return 0;
+}
+
+static int jz4740_rtc_resume(struct device *dev)
+{
+	struct jz4740_rtc *rtc = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		disable_irq_wake(rtc->irq);
+	return 0;
+}
+
+static const struct dev_pm_ops jz4740_pm_ops = {
+    .suspend = jz4740_rtc_suspend,
+    .resume  = jz4740_rtc_resume,
+};
+#define JZ4740_RTC_PM_OPS (&jz4740_pm_ops)
+
+#else
+#define JZ4740_RTC_PM_OPS NULL
+#endif  /* CONFIG_PM */
+
 struct platform_driver jz4740_rtc_driver = {
-	.probe = jz4740_rtc_probe,
-	.remove = __devexit_p(jz4740_rtc_remove),
-	.driver = {
-		.name = "jz4740-rtc",
+	.probe	 = jz4740_rtc_probe,
+	.remove	 = __devexit_p(jz4740_rtc_remove),
+	.driver	 = {
+		.name  = "jz4740-rtc",
 		.owner = THIS_MODULE,
+		.pm    = JZ4740_RTC_PM_OPS,
 	},
 };
 
_

Patches currently in -mm which might be from paul@crapouillou.net are

drivers-rtc-rtc-jz4740c-add-alarm-function.patch

