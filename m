From: akpm@linux-foundation.org
Subject: [merged] rtc-pl031-configured-correct-wday-for-2000-01-01.patch removed from -mm tree
Date: Wed, 23 May 2012 12:51:04 -0700
Message-ID: <20120523195104.378FFA0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:35344 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760680Ab2EWTvG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 May 2012 15:51:06 -0400
Received: by eeit10 with SMTP id t10so448398eei.1
        for <mm-commits@vger.kernel.org>; Wed, 23 May 2012 12:51:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rajkumar.kasirajan@stericsson.com, a.zummo@towertech.it, linus.walleij@linaro.org, mattias.wallin@stericsson.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pl031.c: configure correct wday for 2000-01-01
has been removed from the -mm tree.  Its filename was
     rtc-pl031-configured-correct-wday-for-2000-01-01.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>
Subject: drivers/rtc/rtc-pl031.c: configure correct wday for 2000-01-01

The reset date of the ST Micro version of PL031 is 2000-01-01.  The
correct weekday for 2000-01-01 is saturday, but pl031 is initialized to
sunday.  This may lead to alarm malfunction, so configure the correct wday
if RTC_DR indicates reset.

Signed-off-by: Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pl031.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN drivers/rtc/rtc-pl031.c~rtc-pl031-configured-correct-wday-for-2000-01-01 drivers/rtc/rtc-pl031.c
--- a/drivers/rtc/rtc-pl031.c~rtc-pl031-configured-correct-wday-for-2000-01-01
+++ a/drivers/rtc/rtc-pl031.c
@@ -312,6 +312,7 @@ static int pl031_probe(struct amba_devic
 	int ret;
 	struct pl031_local *ldata;
 	struct rtc_class_ops *ops = id->data;
+	unsigned long time;
 
 	ret = amba_request_regions(adev, NULL);
 	if (ret)
@@ -343,6 +344,23 @@ static int pl031_probe(struct amba_devic
 		writel(readl(ldata->base + RTC_CR) | RTC_CR_CWEN,
 		       ldata->base + RTC_CR);
 
+	/*
+	 * On ST PL031 variants, the RTC reset value does not provide correct
+	 * weekday for 2000-01-01. Correct the erroneous sunday to saturday.
+	 */
+	if (ldata->hw_designer == AMBA_VENDOR_ST) {
+		if (readl(ldata->base + RTC_YDR) == 0x2000) {
+			time = readl(ldata->base + RTC_DR);
+			if ((time &
+			     (RTC_MON_MASK | RTC_MDAY_MASK | RTC_WDAY_MASK))
+			    == 0x02120000) {
+				time = time | (0x7 << RTC_WDAY_SHIFT);
+				writel(0x2000, ldata->base + RTC_YLR);
+				writel(time, ldata->base + RTC_LR);
+			}
+		}
+	}
+
 	ldata->rtc = rtc_device_register("pl031", &adev->dev, ops,
 					THIS_MODULE);
 	if (IS_ERR(ldata->rtc)) {
_

Patches currently in -mm which might be from rajkumar.kasirajan@stericsson.com are

drivers-rtc-rtc-pl031c-remove-rtc-timer-interrupt-handling.patch

