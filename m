From: akpm@linux-foundation.org
Subject: + rtc-pl031-configured-correct-wday-for-2000-01-01.patch added to -mm tree
Date: Tue, 15 May 2012 15:20:05 -0700
Message-ID: <20120515222005.5E953A0397@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:33816 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965655Ab2EOWUH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 May 2012 18:20:07 -0400
Received: by eaao13 with SMTP id o13so3173eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 15 May 2012 15:20:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rajkumar.kasirajan@stericsson.com, a.zummo@towertech.it, linus.walleij@linaro.org, mattias.wallin@stericsson.com


The patch titled
     Subject: drivers/rtc/rtc-pl031.c: configure correct wday for 2000-01-01
has been added to the -mm tree.  Its filename is
     rtc-pl031-configured-correct-wday-for-2000-01-01.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: drivers/rtc/rtc-pl031.c: configure correct wday for 2000-01-01

Patches currently in -mm which might be from rajkumar.kasirajan@stericsson.com are

rtc-pl031-configured-correct-wday-for-2000-01-01.patch

