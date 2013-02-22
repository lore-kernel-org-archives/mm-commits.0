From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-at91rm9200-use-dev_dbg-dev_err-instead-of-printk-pr_debug.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:44:26 -0800
Message-ID: <20130222204426.A66E331C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:63560 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758348Ab3BVUo1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:44:27 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so119574qaj.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:44:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-at91rm9200: use dev_dbg()/dev_err() instead of printk()/pr_debug()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-at91rm9200-use-dev_dbg-dev_err-instead-of-printk-pr_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-at91rm9200: use dev_dbg()/dev_err() instead of printk()/pr_debug()

Fix the checkpatch warning as below:

  WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91rm9200.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/rtc-at91rm9200.c~rtc-rtc-at91rm9200-use-dev_dbg-dev_err-instead-of-printk-pr_debug drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~rtc-rtc-at91rm9200-use-dev_dbg-dev_err-instead-of-printk-pr_debug
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -86,7 +86,7 @@ static int at91_rtc_readtime(struct devi
 	tm->tm_yday = rtc_year_days(tm->tm_mday, tm->tm_mon, tm->tm_year);
 	tm->tm_year = tm->tm_year - 1900;
 
-	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
+	dev_dbg(dev, "%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
 		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec);
 
@@ -100,7 +100,7 @@ static int at91_rtc_settime(struct devic
 {
 	unsigned long cr;
 
-	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
+	dev_dbg(dev, "%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
 		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec);
 
@@ -145,7 +145,7 @@ static int at91_rtc_readalarm(struct dev
 	alrm->enabled = (at91_rtc_read(AT91_RTC_IMR) & AT91_RTC_ALARM)
 			? 1 : 0;
 
-	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
+	dev_dbg(dev, "%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
 		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec);
 
@@ -183,7 +183,7 @@ static int at91_rtc_setalarm(struct devi
 		at91_rtc_write(AT91_RTC_IER, AT91_RTC_ALARM);
 	}
 
-	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
+	dev_dbg(dev, "%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
 		at91_alarm_year, tm.tm_mon, tm.tm_mday, tm.tm_hour,
 		tm.tm_min, tm.tm_sec);
 
@@ -192,7 +192,7 @@ static int at91_rtc_setalarm(struct devi
 
 static int at91_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
-	pr_debug("%s(): cmd=%08x\n", __func__, enabled);
+	dev_dbg(dev, "%s(): cmd=%08x\n", __func__, enabled);
 
 	if (enabled) {
 		at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
@@ -240,7 +240,7 @@ static irqreturn_t at91_rtc_interrupt(in
 
 		rtc_update_irq(rtc, 1, events);
 
-		pr_debug("%s(): num=%ld, events=0x%02lx\n", __func__,
+		dev_dbg(&pdev->dev, "%s(): num=%ld, events=0x%02lx\n", __func__,
 			events >> 8, events & 0x000000FF);
 
 		return IRQ_HANDLED;
@@ -296,8 +296,7 @@ static int __init at91_rtc_probe(struct 
 				IRQF_SHARED,
 				"at91_rtc", pdev);
 	if (ret) {
-		printk(KERN_ERR "at91_rtc: IRQ %d already in use.\n",
-				irq);
+		dev_err(&pdev->dev, "IRQ %d already in use.\n", irq);
 		return ret;
 	}
 
@@ -315,7 +314,7 @@ static int __init at91_rtc_probe(struct 
 	}
 	platform_set_drvdata(pdev, rtc);
 
-	printk(KERN_INFO "AT91 Real Time Clock driver.\n");
+	dev_info(&pdev->dev, "AT91 Real Time Clock driver.\n");
 	return 0;
 }
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

