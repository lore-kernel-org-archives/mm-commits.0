From: akpm@linux-foundation.org
Subject: + rtc-pxa-remove-unnecessary-private-ops-ioctl.patch added to -mm tree
Date: Thu, 10 Jun 2010 13:45:16 -0700
Message-ID: <201006102045.o5AKjGIr022781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752315Ab0FJUps (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jun 2010 16:45:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcuos.com@gmail.com, a.zummo@towertech.it, eric.y.miao@gmail.com, p_gortmaker@yahoo.com, robert.jarzmik@free.fr


The patch titled
     rtc/pxa: remove unnecessary private ops->ioctl()
has been added to the -mm tree.  Its filename is
     rtc-pxa-remove-unnecessary-private-ops-ioctl.patch

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
Subject: rtc/pxa: remove unnecessary private ops->ioctl()
From: Wan ZongShun <mcuos.com@gmail.com>

We shouldn't implement private ops->ioctl() unless absolutely necessary. 
pxa series RTC driver's ioctl() is unnecessary, since RTC subsystem has
implement the ioctl() very well,so we can only use the API of
'.alarm_irq_enable' and '.update_irq_enable' to do enable irq action.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>
Acked-by: Eric Miao <eric.y.miao@gmail.com>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pxa.c |   41 +++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff -puN drivers/rtc/rtc-pxa.c~rtc-pxa-remove-unnecessary-private-ops-ioctl drivers/rtc/rtc-pxa.c
--- a/drivers/rtc/rtc-pxa.c~rtc-pxa-remove-unnecessary-private-ops-ioctl
+++ a/drivers/rtc/rtc-pxa.c
@@ -235,32 +235,34 @@ static int pxa_periodic_irq_set_state(st
 	return 0;
 }
 
-static int pxa_rtc_ioctl(struct device *dev, unsigned int cmd,
-		unsigned long arg)
+static int pxa_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct pxa_rtc *pxa_rtc = dev_get_drvdata(dev);
-	int ret = 0;
 
 	spin_lock_irq(&pxa_rtc->lock);
-	switch (cmd) {
-	case RTC_AIE_OFF:
-		rtsr_clear_bits(pxa_rtc, RTSR_RDALE1);
-		break;
-	case RTC_AIE_ON:
+
+	if (enabled)
 		rtsr_set_bits(pxa_rtc, RTSR_RDALE1);
-		break;
-	case RTC_UIE_OFF:
-		rtsr_clear_bits(pxa_rtc, RTSR_HZE);
-		break;
-	case RTC_UIE_ON:
+	else
+		rtsr_clear_bits(pxa_rtc, RTSR_RDALE1);
+
+	spin_unlock_irq(&pxa_rtc->lock);
+	return 0;
+}
+
+static int pxa_update_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct pxa_rtc *pxa_rtc = dev_get_drvdata(dev);
+
+	spin_lock_irq(&pxa_rtc->lock);
+
+	if (enabled)
 		rtsr_set_bits(pxa_rtc, RTSR_HZE);
-		break;
-	default:
-		ret = -ENOIOCTLCMD;
-	}
+	else
+		rtsr_clear_bits(pxa_rtc, RTSR_HZE);
 
 	spin_unlock_irq(&pxa_rtc->lock);
-	return ret;
+	return 0;
 }
 
 static int pxa_rtc_read_time(struct device *dev, struct rtc_time *tm)
@@ -339,11 +341,12 @@ static int pxa_rtc_proc(struct device *d
 static const struct rtc_class_ops pxa_rtc_ops = {
 	.open = pxa_rtc_open,
 	.release = pxa_rtc_release,
-	.ioctl = pxa_rtc_ioctl,
 	.read_time = pxa_rtc_read_time,
 	.set_time = pxa_rtc_set_time,
 	.read_alarm = pxa_rtc_read_alarm,
 	.set_alarm = pxa_rtc_set_alarm,
+	.alarm_irq_enable = pxa_alarm_irq_enable,
+	.update_irq_enable = pxa_update_irq_enable,
 	.proc = pxa_rtc_proc,
 	.irq_set_state = pxa_periodic_irq_set_state,
 	.irq_set_freq = pxa_periodic_irq_set_freq,
_

Patches currently in -mm which might be from mcuos.com@gmail.com are

origin.patch
linux-next.patch
nuc900-rtc-change-the-waiting-for-device-ready-implement.patch
drivers-rtc-rtc-pcf8563c-remove-unused-struct.patch
rtc-pxa-remove-unused-field.patch
rtc-m48t59-kfreenull-is-ok.patch
rtc-rtc-mxc-remove-six-unused-fields.patch
rtc-fixes-and-new-functionality-for-fm3130.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
rtc-pxa-remove-unnecessary-private-ops-ioctl.patch

