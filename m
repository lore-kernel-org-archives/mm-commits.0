From: akpm@linux-foundation.org
Subject: [merged] rtc-cmos-convert-rtc_aie-rtc_uie-to-rtc-irq-api.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:34:18 -0800
Message-ID: <200912162034.nBGKYIxw013014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763203AbZLPUed (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:34:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: herton@mandriva.com.br, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc-cmos: convert RTC_AIE/RTC_UIE to rtc irq API
has been removed from the -mm tree.  Its filename was
     rtc-cmos-convert-rtc_aie-rtc_uie-to-rtc-irq-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-cmos: convert RTC_AIE/RTC_UIE to rtc irq API
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>

Drop ioctl function that handles RTC_AIE/RTC_UIE, and use instead the
rtc subsystem API (alarm_irq_enable/update_irq_enable callbacks).

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |   75 ++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 40 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-cmos-convert-rtc_aie-rtc_uie-to-rtc-irq-api drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-cmos-convert-rtc_aie-rtc_uie-to-rtc-irq-api
+++ a/drivers/rtc/rtc-cmos.c
@@ -420,49 +420,43 @@ static int cmos_irq_set_state(struct dev
 	return 0;
 }
 
-#if defined(CONFIG_RTC_INTF_DEV) || defined(CONFIG_RTC_INTF_DEV_MODULE)
-
-static int
-cmos_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
+static int cmos_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
 	unsigned long	flags;
 
-	switch (cmd) {
-	case RTC_AIE_OFF:
-	case RTC_AIE_ON:
-	case RTC_UIE_OFF:
-	case RTC_UIE_ON:
-		if (!is_valid_irq(cmos->irq))
-			return -EINVAL;
-		break;
-	/* PIE ON/OFF is handled by cmos_irq_set_state() */
-	default:
-		return -ENOIOCTLCMD;
-	}
+	if (!is_valid_irq(cmos->irq))
+		return -EINVAL;
 
 	spin_lock_irqsave(&rtc_lock, flags);
-	switch (cmd) {
-	case RTC_AIE_OFF:	/* alarm off */
-		cmos_irq_disable(cmos, RTC_AIE);
-		break;
-	case RTC_AIE_ON:	/* alarm on */
+
+	if (enabled)
 		cmos_irq_enable(cmos, RTC_AIE);
-		break;
-	case RTC_UIE_OFF:	/* update off */
-		cmos_irq_disable(cmos, RTC_UIE);
-		break;
-	case RTC_UIE_ON:	/* update on */
-		cmos_irq_enable(cmos, RTC_UIE);
-		break;
-	}
+	else
+		cmos_irq_disable(cmos, RTC_AIE);
+
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return 0;
 }
 
-#else
-#define	cmos_rtc_ioctl	NULL
-#endif
+static int cmos_update_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
+	unsigned long	flags;
+
+	if (!is_valid_irq(cmos->irq))
+		return -EINVAL;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+
+	if (enabled)
+		cmos_irq_enable(cmos, RTC_UIE);
+	else
+		cmos_irq_disable(cmos, RTC_UIE);
+
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	return 0;
+}
 
 #if defined(CONFIG_RTC_INTF_PROC) || defined(CONFIG_RTC_INTF_PROC_MODULE)
 
@@ -503,14 +497,15 @@ static int cmos_procfs(struct device *de
 #endif
 
 static const struct rtc_class_ops cmos_rtc_ops = {
-	.ioctl		= cmos_rtc_ioctl,
-	.read_time	= cmos_read_time,
-	.set_time	= cmos_set_time,
-	.read_alarm	= cmos_read_alarm,
-	.set_alarm	= cmos_set_alarm,
-	.proc		= cmos_procfs,
-	.irq_set_freq	= cmos_irq_set_freq,
-	.irq_set_state	= cmos_irq_set_state,
+	.read_time		= cmos_read_time,
+	.set_time		= cmos_set_time,
+	.read_alarm		= cmos_read_alarm,
+	.set_alarm		= cmos_set_alarm,
+	.proc			= cmos_procfs,
+	.irq_set_freq		= cmos_irq_set_freq,
+	.irq_set_state		= cmos_irq_set_state,
+	.alarm_irq_enable	= cmos_alarm_irq_enable,
+	.update_irq_enable	= cmos_update_irq_enable,
 };
 
 /*----------------------------------------------------------------*/
_

Patches currently in -mm which might be from herton@mandriva.com.br are

origin.patch

