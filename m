From: akpm@linux-foundation.org
Subject: + rtc-use-genirq-directly-in-rtc-wm831x.patch added to -mm tree
Date: Fri, 21 May 2010 13:51:15 -0700
Message-ID: <201005212051.o4LKpFSH000886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751069Ab0EUUv1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 May 2010 16:51:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, a.zummo@towertech.it


The patch titled
     rtc: use genirq directly in rtc-wm831x
has been added to the -mm tree.  Its filename is
     rtc-use-genirq-directly-in-rtc-wm831x.patch

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
Subject: rtc: use genirq directly in rtc-wm831x
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Now that the WM831x core uses genirq for the IRQ controller there is no
need to use the WM831x-specific wrappers to request interrupts so convert
to use genirq directly.

Also use more meaningful strings to make /proc/interrupts more readily
legible.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-wm831x.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-wm831x.c~rtc-use-genirq-directly-in-rtc-wm831x drivers/rtc/rtc-wm831x.c
--- a/drivers/rtc/rtc-wm831x.c~rtc-use-genirq-directly-in-rtc-wm831x
+++ a/drivers/rtc/rtc-wm831x.c
@@ -449,17 +449,17 @@ static int wm831x_rtc_probe(struct platf
 		goto err;
 	}
 
-	ret = wm831x_request_irq(wm831x, per_irq, wm831x_per_irq,
-				 IRQF_TRIGGER_RISING, "wm831x_rtc_per",
-				 wm831x_rtc);
+	ret = request_threaded_irq(per_irq, NULL, wm831x_per_irq,
+				   IRQF_TRIGGER_RISING, "RTC period",
+				   wm831x_rtc);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request periodic IRQ %d: %d\n",
 			per_irq, ret);
 	}
 
-	ret = wm831x_request_irq(wm831x, alm_irq, wm831x_alm_irq,
-				 IRQF_TRIGGER_RISING, "wm831x_rtc_alm",
-				 wm831x_rtc);
+	ret = request_threaded_irq(alm_irq, NULL, wm831x_alm_irq,
+				   IRQF_TRIGGER_RISING, "RTC alarm",
+				   wm831x_rtc);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request alarm IRQ %d: %d\n",
 			alm_irq, ret);
@@ -478,8 +478,8 @@ static int __devexit wm831x_rtc_remove(s
 	int per_irq = platform_get_irq_byname(pdev, "PER");
 	int alm_irq = platform_get_irq_byname(pdev, "ALM");
 
-	wm831x_free_irq(wm831x_rtc->wm831x, alm_irq, wm831x_rtc);
-	wm831x_free_irq(wm831x_rtc->wm831x, per_irq, wm831x_rtc);
+	free_irq(alm_irq, wm831x_rtc);
+	free_irq(per_irq, wm831x_rtc);
 	rtc_device_unregister(wm831x_rtc->rtc);
 	kfree(wm831x_rtc);
 
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch
rtc-use-genirq-directly-in-rtc-wm831x.patch
gpiolib-introduce-set_debounce-method.patch
arm-omap-gpio-implement-set_debounce-method.patch
arm-omap-switch-over-to-gpio_set_debounce.patch
arm-omap-remove-the-unused-omap_gpio_set_debounce-methods.patch

