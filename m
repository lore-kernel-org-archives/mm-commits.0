From: akpm@linux-foundation.org
Subject: + rtc-add-periodic-irq-support-to-rtc-cmos.patch added to -mm tree
Date: Wed, 18 Jul 2007 13:16:03 -0700
Message-ID: <200707182016.l6IKG3VD026875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51486 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752936AbXGRUQt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 16:16:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alessandro.zummo@towertech.it, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     RTC: add periodic irq support to rtc-cmos
has been added to the -mm tree.  Its filename is
     rtc-add-periodic-irq-support-to-rtc-cmos.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: RTC: add periodic irq support to rtc-cmos
From: Alessandro Zummo <alessandro.zummo@towertech.it>

Adds support for periodic irq enabling in rtc-cmos.  This could be used by
the ALSA driver and is already being tested with the zaptel ztdummy module.

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |   33 +++++++++++++++++++++++++++++++--
 1 files changed, 31 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-add-periodic-irq-support-to-rtc-cmos drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-add-periodic-irq-support-to-rtc-cmos
+++ a/drivers/rtc/rtc-cmos.c
@@ -235,7 +235,7 @@ static int cmos_set_alarm(struct device 
 	return 0;
 }
 
-static int cmos_set_freq(struct device *dev, int freq)
+static int cmos_irq_set_freq(struct device *dev, int freq)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
 	int		f;
@@ -259,6 +259,34 @@ static int cmos_set_freq(struct device *
 	return 0;
 }
 
+static int cmos_irq_set_state(struct device *dev, int enabled)
+{
+	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
+	unsigned char	rtc_control, rtc_intr;
+	unsigned long	flags;
+
+	if (!is_valid_irq(cmos->irq))
+		return -ENXIO;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	rtc_control = CMOS_READ(RTC_CONTROL);
+
+	if (enabled)
+		rtc_control |= RTC_PIE;
+	else
+		rtc_control &= ~RTC_PIE;
+
+	CMOS_WRITE(rtc_control, RTC_CONTROL);
+
+	rtc_intr = CMOS_READ(RTC_INTR_FLAGS);
+	rtc_intr &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
+	if (is_intr(rtc_intr))
+		rtc_update_irq(cmos->rtc, 1, rtc_intr);
+
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	return 0;
+}
+
 #if defined(CONFIG_RTC_INTF_DEV) || defined(CONFIG_RTC_INTF_DEV_MODULE)
 
 static int
@@ -360,7 +388,8 @@ static const struct rtc_class_ops cmos_r
 	.read_alarm	= cmos_read_alarm,
 	.set_alarm	= cmos_set_alarm,
 	.proc		= cmos_procfs,
-	.irq_set_freq	= cmos_set_freq,
+	.irq_set_freq	= cmos_irq_set_freq,
+	.irq_set_state	= cmos_irq_set_state,
 };
 
 /*----------------------------------------------------------------*/
_

Patches currently in -mm which might be from alessandro.zummo@towertech.it are

origin.patch
rtc-add-periodic-irq-support-to-rtc-cmos.patch
