From: akpm@linux-foundation.org
Subject: + rtc-sa1100-move-clock-enable-disable-to-probe-remove.patch added to -mm tree
Date: Thu, 14 Feb 2013 16:11:59 -0800
Message-ID: <20130215001159.A6B535A41F0@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:53435 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935101Ab3BOAMA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Feb 2013 19:12:00 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so56987qaj.1
        for <mm-commits@vger.kernel.org>; Thu, 14 Feb 2013 16:12:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chao.xie@marvell.com, haojian.zhuang@gmail.com, liangs@marvell.com


The patch titled
     Subject: drivers/rtc/rtc-sa1100.c: move clock enable/disable to probe/remove
has been added to the -mm tree.  Its filename is
     rtc-sa1100-move-clock-enable-disable-to-probe-remove.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chao Xie <chao.xie@marvell.com>
Subject: drivers/rtc/rtc-sa1100.c: move clock enable/disable to probe/remove

The original sa1100_rtc_open/sa1100_rtc_release will be called when the
/dev/rtc0 is opened or closed.  In fact, these two functions will
enable/disable the clock.  Disabling clock will make rtc not work.  So
only enable/disable clock when probe/remove the device.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Leo Song <liangs@marvell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-sa1100.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-sa1100.c~rtc-sa1100-move-clock-enable-disable-to-probe-remove drivers/rtc/rtc-sa1100.c
--- a/drivers/rtc/rtc-sa1100.c~rtc-sa1100-move-clock-enable-disable-to-probe-remove
+++ a/drivers/rtc/rtc-sa1100.c
@@ -108,9 +108,6 @@ static int sa1100_rtc_open(struct device
 	struct rtc_device *rtc = info->rtc;
 	int ret;
 
-	ret = clk_prepare_enable(info->clk);
-	if (ret)
-		goto fail_clk;
 	ret = request_irq(info->irq_1hz, sa1100_rtc_interrupt, 0, "rtc 1Hz", dev);
 	if (ret) {
 		dev_err(dev, "IRQ %d already in use.\n", info->irq_1hz);
@@ -130,7 +127,6 @@ static int sa1100_rtc_open(struct device
 	free_irq(info->irq_1hz, dev);
  fail_ui:
 	clk_disable_unprepare(info->clk);
- fail_clk:
 	return ret;
 }
 
@@ -144,7 +140,6 @@ static void sa1100_rtc_release(struct de
 
 	free_irq(info->irq_alarm, dev);
 	free_irq(info->irq_1hz, dev);
-	clk_disable_unprepare(info->clk);
 }
 
 static int sa1100_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
@@ -253,6 +248,9 @@ static int sa1100_rtc_probe(struct platf
 	spin_lock_init(&info->lock);
 	platform_set_drvdata(pdev, info);
 
+	ret = clk_prepare_enable(info->clk);
+	if (ret)
+		goto err_enable_clk;
 	/*
 	 * According to the manual we should be able to let RTTR be zero
 	 * and then a default diviser for a 32.768KHz clock is used.
@@ -305,6 +303,8 @@ static int sa1100_rtc_probe(struct platf
 
 	return 0;
 err_dev:
+	clk_disable_unprepare(info->clk);
+err_enable_clk:
 	platform_set_drvdata(pdev, NULL);
 	clk_put(info->clk);
 err_clk:
@@ -318,6 +318,7 @@ static int sa1100_rtc_remove(struct plat
 
 	if (info) {
 		rtc_device_unregister(info->rtc);
+		clk_disable_unprepare(info->clk);
 		clk_put(info->clk);
 		platform_set_drvdata(pdev, NULL);
 		kfree(info);
_

Patches currently in -mm which might be from chao.xie@marvell.com are

linux-next.patch
rtc-sa1100-move-clock-enable-disable-to-probe-remove.patch

