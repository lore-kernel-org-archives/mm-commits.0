From: akpm@linux-foundation.org
Subject: + rtc-convert-wm8350-use-new-alarm-and-update-operations.patch added to -mm tree
Date: Mon, 12 Jan 2009 16:51:12 -0800
Message-ID: <200901130051.n0D0pC9s021121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751003AbZAMAv2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 19:51:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc: convert wm8350 use new alarm and update operations
has been added to the -mm tree.  Its filename is
     rtc-convert-wm8350-use-new-alarm-and-update-operations.patch

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
Subject: rtc: convert wm8350 use new alarm and update operations
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

These are the only two ioctls so the ioctl() function is also removed.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-wm8350.c |   39 +++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff -puN drivers/rtc/rtc-wm8350.c~rtc-convert-wm8350-use-new-alarm-and-update-operations drivers/rtc/rtc-wm8350.c
--- a/drivers/rtc/rtc-wm8350.c~rtc-convert-wm8350-use-new-alarm-and-update-operations
+++ a/drivers/rtc/rtc-wm8350.c
@@ -236,6 +236,17 @@ static int wm8350_rtc_start_alarm(struct
 	return 0;
 }
 
+static int wm8350_rtc_alarm_irq_enable(struct device *dev,
+				       unsigned int enabled)
+{
+	struct wm8350 *wm8350 = dev_get_drvdata(dev);
+
+	if (enabled)
+		return wm8350_rtc_start_alarm(wm8350);
+	else
+		return wm8350_rtc_stop_alarm(wm8350);
+}
+
 static int wm8350_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct wm8350 *wm8350 = dev_get_drvdata(dev);
@@ -291,30 +302,15 @@ static int wm8350_rtc_setalarm(struct de
 	return ret;
 }
 
-/*
- * Handle commands from user-space
- */
-static int wm8350_rtc_ioctl(struct device *dev, unsigned int cmd,
-			    unsigned long arg)
+static int wm8350_rtc_update_irq_enable(struct device *dev,
+					unsigned int enabled)
 {
 	struct wm8350 *wm8350 = dev_get_drvdata(dev);
 
-	switch (cmd) {
-	case RTC_AIE_OFF:
-		return wm8350_rtc_stop_alarm(wm8350);
-	case RTC_AIE_ON:
-		return wm8350_rtc_start_alarm(wm8350);
-
-	case RTC_UIE_OFF:
-		wm8350_mask_irq(wm8350, WM8350_IRQ_RTC_SEC);
-		break;
-	case RTC_UIE_ON:
+	if (enabled)
 		wm8350_unmask_irq(wm8350, WM8350_IRQ_RTC_SEC);
-		break;
-
-	default:
-		return -ENOIOCTLCMD;
-	}
+	else
+		wm8350_mask_irq(wm8350, WM8350_IRQ_RTC_SEC);
 
 	return 0;
 }
@@ -345,11 +341,12 @@ static void wm8350_rtc_update_handler(st
 }
 
 static const struct rtc_class_ops wm8350_rtc_ops = {
-	.ioctl = wm8350_rtc_ioctl,
 	.read_time = wm8350_rtc_readtime,
 	.set_time = wm8350_rtc_settime,
 	.read_alarm = wm8350_rtc_readalarm,
 	.set_alarm = wm8350_rtc_setalarm,
+	.alarm_irq_enable = wm8350_rtc_alarm_irq_enable,
+	.update_irq_enable = wm8350_rtc_update_irq_enable,
 };
 
 #ifdef CONFIG_PM
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

linux-next.patch
regulator-pcf50633-pmic-driver.patch
rtc-convert-wm8350-use-new-alarm-and-update-operations.patch

