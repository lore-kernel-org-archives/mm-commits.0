From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-sirfsocc-replace-local_irq_disable-by-spin_lock_irq-for-smp-safety.patch removed from -mm tree
Date: Thu, 11 Dec 2014 11:07:25 -0800
Message-ID: <5489eb6d.apbYhc7vZ9lnniBs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889AbaLKTH0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:07:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Baohua.Song@csr.com, a.zummo@towertech.it, hao.liu@csr.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-sirfsoc.c: replace local_irq_disable by spin_lock_irq for SMP safety
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-sirfsocc-replace-local_irq_disable-by-spin_lock_irq-for-smp-safety.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Barry Song <Baohua.Song@csr.com>
Subject: drivers/rtc/rtc-sirfsoc.c: replace local_irq_disable by spin_lock_irq for SMP safety

Signed-off-by: Barry Song <Baohua.Song@csr.com>
Cc: hao liu <hao.liu@csr.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-sirfsoc.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-sirfsoc.c~drivers-rtc-rtc-sirfsocc-replace-local_irq_disable-by-spin_lock_irq-for-smp-safety drivers/rtc/rtc-sirfsoc.c
--- a/drivers/rtc/rtc-sirfsoc.c~drivers-rtc-rtc-sirfsocc-replace-local_irq_disable-by-spin_lock_irq-for-smp-safety
+++ a/drivers/rtc/rtc-sirfsoc.c
@@ -47,6 +47,7 @@ struct sirfsoc_rtc_drv {
 	unsigned		irq_wake;
 	/* Overflow for every 8 years extra time */
 	u32			overflow_rtc;
+	spinlock_t		lock;
 #ifdef CONFIG_PM
 	u32		saved_counter;
 	u32		saved_overflow_rtc;
@@ -61,7 +62,7 @@ static int sirfsoc_rtc_read_alarm(struct
 
 	rtcdrv = dev_get_drvdata(dev);
 
-	local_irq_disable();
+	spin_lock_irq(&rtcdrv->lock);
 
 	rtc_count = sirfsoc_rtc_iobrg_readl(rtcdrv->rtc_base + RTC_CN);
 
@@ -84,7 +85,8 @@ static int sirfsoc_rtc_read_alarm(struct
 	if (sirfsoc_rtc_iobrg_readl(
 			rtcdrv->rtc_base + RTC_STATUS) & SIRFSOC_RTC_AL0E)
 		alrm->enabled = 1;
-	local_irq_enable();
+
+	spin_unlock_irq(&rtcdrv->lock);
 
 	return 0;
 }
@@ -99,7 +101,7 @@ static int sirfsoc_rtc_set_alarm(struct
 	if (alrm->enabled) {
 		rtc_tm_to_time(&(alrm->time), &rtc_alarm);
 
-		local_irq_disable();
+		spin_lock_irq(&rtcdrv->lock);
 
 		rtc_status_reg = sirfsoc_rtc_iobrg_readl(
 				rtcdrv->rtc_base + RTC_STATUS);
@@ -123,14 +125,15 @@ static int sirfsoc_rtc_set_alarm(struct
 		rtc_status_reg |= SIRFSOC_RTC_AL0E;
 		sirfsoc_rtc_iobrg_writel(
 			rtc_status_reg, rtcdrv->rtc_base + RTC_STATUS);
-		local_irq_enable();
+
+		spin_unlock_irq(&rtcdrv->lock);
 	} else {
 		/*
 		 * if this function was called with enabled=0
 		 * then it could mean that the application is
 		 * trying to cancel an ongoing alarm
 		 */
-		local_irq_disable();
+		spin_lock_irq(&rtcdrv->lock);
 
 		rtc_status_reg = sirfsoc_rtc_iobrg_readl(
 				rtcdrv->rtc_base + RTC_STATUS);
@@ -146,7 +149,7 @@ static int sirfsoc_rtc_set_alarm(struct
 					rtcdrv->rtc_base + RTC_STATUS);
 		}
 
-		local_irq_enable();
+		spin_unlock_irq(&rtcdrv->lock);
 	}
 
 	return 0;
@@ -217,7 +220,7 @@ static int sirfsoc_rtc_alarm_irq_enable(
 
 	rtcdrv = dev_get_drvdata(dev);
 
-	local_irq_disable();
+	spin_lock_irq(&rtcdrv->lock);
 
 	rtc_status_reg = sirfsoc_rtc_iobrg_readl(
 				rtcdrv->rtc_base + RTC_STATUS);
@@ -227,7 +230,8 @@ static int sirfsoc_rtc_alarm_irq_enable(
 		rtc_status_reg &= ~SIRFSOC_RTC_AL0E;
 
 	sirfsoc_rtc_iobrg_writel(rtc_status_reg, rtcdrv->rtc_base + RTC_STATUS);
-	local_irq_enable();
+
+	spin_unlock_irq(&rtcdrv->lock);
 
 	return 0;
 
@@ -248,6 +252,8 @@ static irqreturn_t sirfsoc_rtc_irq_handl
 	unsigned long rtc_status_reg = 0x0;
 	unsigned long events = 0x0;
 
+	spin_lock(&rtcdrv->lock);
+
 	rtc_status_reg = sirfsoc_rtc_iobrg_readl(rtcdrv->rtc_base + RTC_STATUS);
 	/* this bit will be set ONLY if an alarm was active
 	 * and it expired NOW
@@ -265,6 +271,9 @@ static irqreturn_t sirfsoc_rtc_irq_handl
 		rtc_status_reg &= ~(SIRFSOC_RTC_AL0E);
 	}
 	sirfsoc_rtc_iobrg_writel(rtc_status_reg, rtcdrv->rtc_base + RTC_STATUS);
+
+	spin_unlock(&rtcdrv->lock);
+
 	/* this should wake up any apps polling/waiting on the read
 	 * after setting the alarm
 	 */
@@ -292,6 +301,8 @@ static int sirfsoc_rtc_probe(struct plat
 	if (rtcdrv == NULL)
 		return -ENOMEM;
 
+	spin_lock_init(&rtcdrv->lock);
+
 	err = of_property_read_u32(np, "reg", &rtcdrv->rtc_base);
 	if (err) {
 		dev_err(&pdev->dev, "unable to find base address of rtc node in dtb\n");
_

Patches currently in -mm which might be from Baohua.Song@csr.com are

origin.patch
linux-next.patch

