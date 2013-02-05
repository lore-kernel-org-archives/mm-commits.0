From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-pl031c-fix-the-missing-operation-on-enable.patch removed from -mm tree
Date: Tue, 05 Feb 2013 12:20:42 -0800
Message-ID: <20130205202042.B723431C107@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:53126 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613Ab3BEUUn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2013 15:20:43 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so65797ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Feb 2013 12:20:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haojian.zhuang@linaro.org, a.zummo@towertech.it, linus.walleij@linaro.org, srinidhi.kasagar@stericsson.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pl031.c: fix the missing operation on enable
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-pl031c-fix-the-missing-operation-on-enable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Haojian Zhuang <haojian.zhuang@linaro.org>
Subject: drivers/rtc/rtc-pl031.c: fix the missing operation on enable

The RTC control register should be enabled in the process of initializing.

Without this patch, I failed to enable RTC in Hisilicon Hi3620 SoC.  The
register mapping section in RTC is always read as zero.  So I doubt that
ST guys may already enable this register in bootloader.  So they won't
meet this issue.

Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pl031.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-pl031.c~drivers-rtc-rtc-pl031c-fix-the-missing-operation-on-enable drivers/rtc/rtc-pl031.c
--- a/drivers/rtc/rtc-pl031.c~drivers-rtc-rtc-pl031c-fix-the-missing-operation-on-enable
+++ a/drivers/rtc/rtc-pl031.c
@@ -44,6 +44,7 @@
 #define RTC_YMR		0x34	/* Year match register */
 #define RTC_YLR		0x38	/* Year data load register */
 
+#define RTC_CR_EN	(1 << 0)	/* counter enable bit */
 #define RTC_CR_CWEN	(1 << 26)	/* Clockwatch enable bit */
 
 #define RTC_TCR_EN	(1 << 1) /* Periodic timer enable bit */
@@ -320,7 +321,7 @@ static int pl031_probe(struct amba_devic
 	struct pl031_local *ldata;
 	struct pl031_vendor_data *vendor = id->data;
 	struct rtc_class_ops *ops = &vendor->ops;
-	unsigned long time;
+	unsigned long time, data;
 
 	ret = amba_request_regions(adev, NULL);
 	if (ret)
@@ -345,10 +346,11 @@ static int pl031_probe(struct amba_devic
 	dev_dbg(&adev->dev, "designer ID = 0x%02x\n", amba_manf(adev));
 	dev_dbg(&adev->dev, "revision = 0x%01x\n", amba_rev(adev));
 
+	data = readl(ldata->base + RTC_CR);
 	/* Enable the clockwatch on ST Variants */
 	if (vendor->clockwatch)
-		writel(readl(ldata->base + RTC_CR) | RTC_CR_CWEN,
-		       ldata->base + RTC_CR);
+		data |= RTC_CR_CWEN;
+	writel(data | RTC_CR_EN, ldata->base + RTC_CR);
 
 	/*
 	 * On ST PL031 variants, the RTC reset value does not provide correct
_

Patches currently in -mm which might be from haojian.zhuang@linaro.org are

origin.patch
linux-next.patch

