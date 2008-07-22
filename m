From: akpm@linux-foundation.org
Subject: + rtc-vr41xx-add-irq_set_freq-and-irq_set_state.patch added to -mm tree
Date: Tue, 22 Jul 2008 01:09:06 -0700
Message-ID: <200807220809.m6M896aj017790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089AbYGVIJd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 04:09:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yoichi_yuasa@tripeaks.co.jp, a.zummo@towertech.it, david-b@pacbell.net, ralf@linux-mips.org


The patch titled
     rtc-vr41xx: add irq_set_freq() and irq_set_state()
has been added to the -mm tree.  Its filename is
     rtc-vr41xx-add-irq_set_freq-and-irq_set_state.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-vr41xx: add irq_set_freq() and irq_set_state()
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

Implement the ioctls RTC_PIE_ON, RTC_PIE_OFF, RTC_IRQP_SET and
RTC_IRQP_READ in the standard RTC way.

Thanks Dave for noticing it.

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: David Brownell <david-b@pacbell.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-vr41xx.c |   65 +++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 31 deletions(-)

diff -puN drivers/rtc/rtc-vr41xx.c~rtc-vr41xx-add-irq_set_freq-and-irq_set_state drivers/rtc/rtc-vr41xx.c
--- a/drivers/rtc/rtc-vr41xx.c~rtc-vr41xx-add-irq_set_freq-and-irq_set_state
+++ a/drivers/rtc/rtc-vr41xx.c
@@ -1,7 +1,7 @@
 /*
  *  Driver for NEC VR4100 series Real Time Clock unit.
  *
- *  Copyright (C) 2003-2006  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *  Copyright (C) 2003-2008  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -34,7 +34,7 @@
 
 MODULE_AUTHOR("Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>");
 MODULE_DESCRIPTION("NEC VR4100 series RTC driver");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 
 /* RTC 1 registers */
 #define ETIMELREG		0x00
@@ -82,7 +82,6 @@ static unsigned long epoch = 1970;	/* Ja
 
 static DEFINE_SPINLOCK(rtc_lock);
 static char rtc_name[] = "RTC";
-static unsigned long periodic_frequency;
 static unsigned long periodic_count;
 static unsigned int alarm_enabled;
 static int aie_irq = -1;
@@ -207,10 +206,37 @@ static int vr41xx_rtc_set_alarm(struct d
 	return 0;
 }
 
-static int vr41xx_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
+static int vr41xx_rtc_irq_set_freq(struct device *dev, int freq)
 {
 	unsigned long count;
 
+	count = RTC_FREQUENCY;
+	do_div(count, freq);
+
+	periodic_count = count;
+
+	spin_lock_irq(&rtc_lock);
+
+	rtc1_write(RTCL1LREG, count);
+	rtc1_write(RTCL1HREG, count >> 16);
+
+	spin_unlock_irq(&rtc_lock);
+
+	return 0;
+}
+
+static int vr41xx_rtc_irq_set_state(struct device *dev, int enabled)
+{
+	if (enabled)
+		enable_irq(pie_irq);
+	else
+		disable_irq(pie_irq);
+
+	return 0;
+}
+
+static int vr41xx_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
+{
 	switch (cmd) {
 	case RTC_AIE_ON:
 		spin_lock_irq(&rtc_lock);
@@ -232,33 +258,6 @@ static int vr41xx_rtc_ioctl(struct devic
 
 		spin_unlock_irq(&rtc_lock);
 		break;
-	case RTC_PIE_ON:
-		enable_irq(pie_irq);
-		break;
-	case RTC_PIE_OFF:
-		disable_irq(pie_irq);
-		break;
-	case RTC_IRQP_READ:
-		return put_user(periodic_frequency, (unsigned long __user *)arg);
-		break;
-	case RTC_IRQP_SET:
-		if (arg > MAX_PERIODIC_RATE)
-			return -EINVAL;
-
-		periodic_frequency = arg;
-
-		count = RTC_FREQUENCY;
-		do_div(count, arg);
-
-		periodic_count = count;
-
-		spin_lock_irq(&rtc_lock);
-
-		rtc1_write(RTCL1LREG, count);
-		rtc1_write(RTCL1HREG, count >> 16);
-
-		spin_unlock_irq(&rtc_lock);
-		break;
 	case RTC_EPOCH_READ:
 		return put_user(epoch, (unsigned long __user *)arg);
 	case RTC_EPOCH_SET:
@@ -309,6 +308,8 @@ static const struct rtc_class_ops vr41xx
 	.set_time	= vr41xx_rtc_set_time,
 	.read_alarm	= vr41xx_rtc_read_alarm,
 	.set_alarm	= vr41xx_rtc_set_alarm,
+	.irq_set_freq	= vr41xx_rtc_irq_set_freq,
+	.irq_set_state	= vr41xx_rtc_irq_set_state,
 };
 
 static int __devinit rtc_probe(struct platform_device *pdev)
@@ -346,6 +347,8 @@ static int __devinit rtc_probe(struct pl
 		goto err_iounmap_all;
 	}
 
+	rtc->max_user_freq = MAX_PERIODIC_RATE;
+
 	spin_lock_irq(&rtc_lock);
 
 	rtc1_write(ECMPLREG, 0);
_

Patches currently in -mm which might be from yoichi_yuasa@tripeaks.co.jp are

origin.patch
rtc-vr41xx-add-irq_set_freq-and-irq_set_state.patch
fbdev-add-new-cobalt-lcd-framebuffer-driver.patch
fbdev-add-new-cobalt-lcd-framebuffer-driver-v3.patch
drivers-char-remove-old-broken-cobalt-lcd-driver.patch

