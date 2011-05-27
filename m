From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-pcf50633c-dont-request-update-irq.patch removed from -mm tree
Date: Fri, 27 May 2011 12:57:16 -0700
Message-ID: <201105271955.p4RJtLgx017444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756976Ab1E0T4A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:56:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lars@metafoo.de, a.zummo@towertech.it, john.stultz@linaro.org, mroberto@cpti.cetuc.puc-rio.br, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc/rtc-pcf50633.c: don't request update IRQ
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-pcf50633c-dont-request-update-irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-pcf50633.c: don't request update IRQ
From: Lars-Peter Clausen <lars@metafoo.de>

Commit 51ba60c5 ("RTC: Cleanup rtc_class_ops->update_irq_enable()")
removed the only user of the update IRQ, so there is no need to manage it
any more.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf50633.c |   23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff -puN drivers/rtc/rtc-pcf50633.c~drivers-rtc-rtc-pcf50633c-dont-request-update-irq drivers/rtc/rtc-pcf50633.c
--- a/drivers/rtc/rtc-pcf50633.c~drivers-rtc-rtc-pcf50633c-dont-request-update-irq
+++ a/drivers/rtc/rtc-pcf50633.c
@@ -58,7 +58,6 @@ struct pcf50633_time {
 
 struct pcf50633_rtc {
 	int alarm_enabled;
-	int second_enabled;
 	int alarm_pending;
 
 	struct pcf50633 *pcf;
@@ -143,7 +142,7 @@ static int pcf50633_rtc_set_time(struct 
 {
 	struct pcf50633_rtc *rtc;
 	struct pcf50633_time pcf_tm;
-	int second_masked, alarm_masked, ret = 0;
+	int alarm_masked, ret = 0;
 
 	rtc = dev_get_drvdata(dev);
 
@@ -162,11 +161,8 @@ static int pcf50633_rtc_set_time(struct 
 		pcf_tm.time[PCF50633_TI_SEC]);
 
 
-	second_masked = pcf50633_irq_mask_get(rtc->pcf, PCF50633_IRQ_SECOND);
 	alarm_masked = pcf50633_irq_mask_get(rtc->pcf, PCF50633_IRQ_ALARM);
 
-	if (!second_masked)
-		pcf50633_irq_mask(rtc->pcf, PCF50633_IRQ_SECOND);
 	if (!alarm_masked)
 		pcf50633_irq_mask(rtc->pcf, PCF50633_IRQ_ALARM);
 
@@ -175,8 +171,6 @@ static int pcf50633_rtc_set_time(struct 
 					     PCF50633_TI_EXTENT,
 					     &pcf_tm.time[0]);
 
-	if (!second_masked)
-		pcf50633_irq_unmask(rtc->pcf, PCF50633_IRQ_SECOND);
 	if (!alarm_masked)
 		pcf50633_irq_unmask(rtc->pcf, PCF50633_IRQ_ALARM);
 
@@ -250,15 +244,8 @@ static void pcf50633_rtc_irq(int irq, vo
 {
 	struct pcf50633_rtc *rtc = data;
 
-	switch (irq) {
-	case PCF50633_IRQ_ALARM:
-		rtc_update_irq(rtc->rtc_dev, 1, RTC_AF | RTC_IRQF);
-		rtc->alarm_pending = 1;
-		break;
-	case PCF50633_IRQ_SECOND:
-		rtc_update_irq(rtc->rtc_dev, 1, RTC_UF | RTC_IRQF);
-		break;
-	}
+	rtc_update_irq(rtc->rtc_dev, 1, RTC_AF | RTC_IRQF);
+	rtc->alarm_pending = 1;
 }
 
 static int __devinit pcf50633_rtc_probe(struct platform_device *pdev)
@@ -282,9 +269,6 @@ static int __devinit pcf50633_rtc_probe(
 
 	pcf50633_register_irq(rtc->pcf, PCF50633_IRQ_ALARM,
 					pcf50633_rtc_irq, rtc);
-	pcf50633_register_irq(rtc->pcf, PCF50633_IRQ_SECOND,
-					pcf50633_rtc_irq, rtc);
