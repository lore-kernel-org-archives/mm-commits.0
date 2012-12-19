From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue.patch added to -mm tree
Date: Tue, 18 Dec 2012 16:11:55 -0800
Message-ID: <20121219001156.08567200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:41719 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab2LSAL6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 19:11:58 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so71065eei.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 16:11:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liangs@marvell.com


The patch titled
     Subject: drivers/rtc/rtc-pxa.c: fix set time sync time issue
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Leo Song <liangs@marvell.com>
Subject: drivers/rtc/rtc-pxa.c: fix set time sync time issue

Fix set time and sync time issue, add some delay when set pxa rtc timer
according to spec

Signed-off-by: Leo Song <liangs@marvell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pxa.c   |   63 +++++++++++++++++++++++++++++++++-----
 include/linux/rtc-pxa.h |   18 ++++++++++
 2 files changed, 74 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-pxa.c~drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue drivers/rtc/rtc-pxa.c
--- a/drivers/rtc/rtc-pxa.c~drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue
+++ a/drivers/rtc/rtc-pxa.c
@@ -80,22 +80,29 @@
 #define RYAR1		0x1c
 #define RTCPICR		0x34
 #define PIAR		0x38
+#define PSBR_RTC	0x00
 
 #define rtc_readl(pxa_rtc, reg)	\
 	__raw_readl((pxa_rtc)->base + (reg))
 #define rtc_writel(pxa_rtc, reg, value)	\
 	__raw_writel((value), (pxa_rtc)->base + (reg))
+#define rtc_readl_psbr(pxa_rtc, reg)	\
+	__raw_readl((pxa_rtc)->base_psbr + (reg))
+#define rtc_writel_psbr(pxa_rtc, reg, value)	\
+	__raw_writel((value), (pxa_rtc)->base_psbr + (reg))
 
 struct pxa_rtc {
 	struct resource	*ress;
+	struct resource	*ress_psbr;
 	void __iomem		*base;
+	void __iomem		*base_psbr;
 	int			irq_1Hz;
 	int			irq_Alrm;
 	struct rtc_device	*rtc;
 	spinlock_t		lock;		/* Protects this structure */
 };
 
-
+static struct pxa_rtc *rtc_info;
 static u32 ryxr_calc(struct rtc_time *tm)
 {
 	return ((tm->tm_year + 1900) << RYxR_YEAR_S)
@@ -117,7 +124,7 @@ static void tm_calc(u32 rycr, u32 rdcr, 
 	tm->tm_year = ((rycr & RYxR_YEAR_MASK) >> RYxR_YEAR_S) - 1900;
 	tm->tm_mon = (((rycr & RYxR_MONTH_MASK) >> RYxR_MONTH_S)) - 1;
 	tm->tm_mday = (rycr & RYxR_DAY_MASK);
-	tm->tm_wday = ((rycr & RDxR_DOW_MASK) >> RDxR_DOW_S) - 1;
+	tm->tm_wday = ((rdcr & RDxR_DOW_MASK) >> RDxR_DOW_S) - 1;
 	tm->tm_hour = (rdcr & RDxR_HOUR_MASK) >> RDxR_HOUR_S;
 	tm->tm_min = (rdcr & RDxR_MIN_MASK) >> RDxR_MIN_S;
 	tm->tm_sec = rdcr & RDxR_SEC_MASK;
@@ -175,7 +182,6 @@ static irqreturn_t pxa_rtc_irq(int irq, 
 
 	/* enable back rtc interrupts */
 	rtc_writel(pxa_rtc, RTSR, rtsr & ~RTSR_TRIG_MASK);
-
 	spin_unlock(&pxa_rtc->lock);
 	return IRQ_HANDLED;
 }
@@ -250,12 +256,45 @@ static int pxa_rtc_read_time(struct devi
 static int pxa_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	struct pxa_rtc *pxa_rtc = dev_get_drvdata(dev);
-
+	/* sequence to wirte pxa rtc register RCNR RDCR RYCR is
+	*1. set PSBR[RWE] bit, take 2x32-khz to complete
+	*2. write to RTC register,take 2x32-khz to complete
+	*3. clear PSBR[RWE] bit,take 2x32-khz to complete
+	*/
+	if ((tm->tm_year < 70) || (tm->tm_year > 138))
+		return -EINVAL;
+	rtc_writel_psbr(rtc_info, PSBR_RTC, 0x01);
+	udelay(100);
 	rtc_writel(pxa_rtc, RYCR, ryxr_calc(tm));
 	rtc_writel(pxa_rtc, RDCR, rdxr_calc(tm));
+	udelay(100);
+	rtc_writel_psbr(rtc_info, PSBR_RTC, 0x00);
+	udelay(100);
+	pxa_rtc_read_time(dev, tm);
+	dev_info(dev, "tm.year = %d, tm.month = %d, tm.day = %d\n",
+			tm->tm_year + 1900, tm->tm_mon, tm->tm_mday);
+	return 0;
+}
 
+int pxa_rtc_sync_time(unsigned int ticks)
+{
+	/* sequence to wirte pxa rtc register RCNR RDCR RYCR is
+	*1. set PSBR[RWE] bit, take 2x32-khz to complete
+	*2. write to RTC register,take 2x32-khz to complete
+	*3. clear PSBR[RWE] bit,take 2x32-khz to complete
+	*/
+	struct rtc_time tm;
+	rtc_time_to_tm(ticks, &tm);
+	rtc_writel_psbr(rtc_info, PSBR_RTC, 0x01);
+	udelay(100);
+	rtc_writel(rtc_info, RYCR, ryxr_calc(&tm));
+	rtc_writel(rtc_info, RDCR, rdxr_calc(&tm));
+	udelay(100);
+	rtc_writel_psbr(rtc_info, PSBR_RTC, 0x00);
+	udelay(100);
 	return 0;
 }
+EXPORT_SYMBOL(pxa_rtc_sync_time);
 
 static int pxa_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
@@ -327,7 +366,7 @@ static int __init pxa_rtc_probe(struct p
 	pxa_rtc = kzalloc(sizeof(struct pxa_rtc), GFP_KERNEL);
 	if (!pxa_rtc)
 		return -ENOMEM;
-
+	rtc_info = pxa_rtc;
 	spin_lock_init(&pxa_rtc->lock);
 	platform_set_drvdata(pdev, pxa_rtc);
 
@@ -337,6 +376,11 @@ static int __init pxa_rtc_probe(struct p
 		dev_err(dev, "No I/O memory resource defined\n");
 		goto err_ress;
 	}
+	pxa_rtc->ress_psbr = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (!pxa_rtc->ress_psbr) {
+		dev_err(dev, "No I/O memory resource defined\n");
+		goto err_ress;
+	}
 
 	pxa_rtc->irq_1Hz = platform_get_irq(pdev, 0);
 	if (pxa_rtc->irq_1Hz < 0) {
@@ -348,7 +392,6 @@ static int __init pxa_rtc_probe(struct p
 		dev_err(dev, "No alarm IRQ resource defined\n");
 		goto err_ress;
 	}
-	pxa_rtc_open(dev);
 	ret = -ENOMEM;
 	pxa_rtc->base = ioremap(pxa_rtc->ress->start,
 				resource_size(pxa_rtc->ress));
@@ -357,6 +400,12 @@ static int __init pxa_rtc_probe(struct p
 		goto err_map;
 	}
 
+	pxa_rtc->base_psbr = ioremap(pxa_rtc->ress_psbr->start,
+				resource_size(pxa_rtc->ress_psbr));
+	if (!pxa_rtc->base_psbr) {
+		dev_err(&pdev->dev, "Unable to map pxa RTC PSBR I/O memory\n");
+		goto err_map;
+	}
 	/*
 	 * If the clock divider is uninitialized then reset it to the
 	 * default value to get the 1Hz clock.
@@ -379,7 +428,7 @@ static int __init pxa_rtc_probe(struct p
 	}
 
 	device_init_wakeup(dev, 1);
-
+	pxa_rtc_open(dev);
 	return 0;
 
 err_rtc_reg:
diff -puN /dev/null include/linux/rtc-pxa.h
--- /dev/null
+++ a/include/linux/rtc-pxa.h
@@ -0,0 +1,18 @@
+/*
+ * include/linux/rtc-pxa.h
+ *
+ * RTC PXA Header file
+ *
+ * Copyright (C) 2010 Marvell International Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __LINUX_RTC_PXA_H
+#define __LINUX_RTC_PXA_H
+
+extern int pxa_rtc_sync_time(unsigned int ticks);
+
+#endif /* __LINUX_RTC_PXA_H */
_

Patches currently in -mm which might be from liangs@marvell.com are

drivers-rtc-rtc-pxac-fix-alarm-not-match-issue.patch
drivers-rtc-rtc-pxac-fix-alarm-cant-wake-up-system-issue.patch
drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue.patch

