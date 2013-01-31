From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-pl031c-fix-the-missing-operation-on-enable.patch added to -mm tree
Date: Thu, 31 Jan 2013 14:45:20 -0800
Message-ID: <20130131224520.9FBFB31C1BB@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:64964 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757169Ab3AaWpW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Jan 2013 17:45:22 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so378436qaj.5
        for <mm-commits@vger.kernel.org>; Thu, 31 Jan 2013 14:45:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haojian.zhuang@linaro.org, a.zummo@towertech.it, linus.walleij@linaro.org, srinidhi.kasagar@stericsson.com


The patch titled
     Subject: drivers/rtc/rtc-pl031.c: fix the missing operation on enable
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-pl031c-fix-the-missing-operation-on-enable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Haojian Zhuang <haojian.zhuang@linaro.org>
Subject: drivers/rtc/rtc-pl031.c: fix the missing operation on enable

The RTC control register should be enabled in the process of initializing.

Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
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
drivers-rtc-rtc-pl031c-fix-the-missing-operation-on-enable.patch

