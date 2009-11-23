From: akpm@linux-foundation.org
Subject: + rtc-remove-__raw_-accessors-from-pl031-rtc.patch added to -mm tree
Date: Mon, 23 Nov 2009 13:31:52 -0800
Message-ID: <200911232131.nANLVq9M003095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756913AbZKWVb4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 16:31:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linus.walleij@stericsson.com, a.zummo@towertech.it


The patch titled
     rtc: remove __raw_* accessors from PL031 RTC
has been added to the -mm tree.  Its filename is
     rtc-remove-__raw_-accessors-from-pl031-rtc.patch

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
Subject: rtc: remove __raw_* accessors from PL031 RTC
From: Linus Walleij <linus.walleij@stericsson.com>

This switches __raw_[read|write]l() for plain [read|write]l in the PL031
RTC driver.  The sister driver for PL030 use the simple accessors as most
PrimeCell drivers.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pl031.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-pl031.c~rtc-remove-__raw_-accessors-from-pl031-rtc drivers/rtc/rtc-pl031.c
--- a/drivers/rtc/rtc-pl031.c~rtc-remove-__raw_-accessors-from-pl031-rtc
+++ a/drivers/rtc/rtc-pl031.c
@@ -51,10 +51,10 @@ static int pl031_ioctl(struct device *de
 
 	switch (cmd) {
 	case RTC_AIE_OFF:
-		__raw_writel(1, ldata->base + RTC_MIS);
+		writel(1, ldata->base + RTC_MIS);
 		return 0;
 	case RTC_AIE_ON:
-		__raw_writel(0, ldata->base + RTC_MIS);
+		writel(0, ldata->base + RTC_MIS);
 		return 0;
 	}
 
@@ -65,7 +65,7 @@ static int pl031_read_time(struct device
 {
 	struct pl031_local *ldata = dev_get_drvdata(dev);
 
-	rtc_time_to_tm(__raw_readl(ldata->base + RTC_DR), tm);
+	rtc_time_to_tm(readl(ldata->base + RTC_DR), tm);
 
 	return 0;
 }
@@ -76,7 +76,7 @@ static int pl031_set_time(struct device 
 	struct pl031_local *ldata = dev_get_drvdata(dev);
 
 	rtc_tm_to_time(tm, &time);
-	__raw_writel(time, ldata->base + RTC_LR);
+	writel(time, ldata->base + RTC_LR);
 
 	return 0;
 }
@@ -85,9 +85,9 @@ static int pl031_read_alarm(struct devic
 {
 	struct pl031_local *ldata = dev_get_drvdata(dev);
 
-	rtc_time_to_tm(__raw_readl(ldata->base + RTC_MR), &alarm->time);
-	alarm->pending = __raw_readl(ldata->base + RTC_RIS);
-	alarm->enabled = __raw_readl(ldata->base + RTC_IMSC);
+	rtc_time_to_tm(readl(ldata->base + RTC_MR), &alarm->time);
+	alarm->pending = readl(ldata->base + RTC_RIS);
+	alarm->enabled = readl(ldata->base + RTC_IMSC);
 
 	return 0;
 }
@@ -99,8 +99,8 @@ static int pl031_set_alarm(struct device
 
 	rtc_tm_to_time(&alarm->time, &time);
 
-	__raw_writel(time, ldata->base + RTC_MR);
-	__raw_writel(!alarm->enabled, ldata->base + RTC_MIS);
+	writel(time, ldata->base + RTC_MR);
+	writel(!alarm->enabled, ldata->base + RTC_MIS);
 
 	return 0;
 }
@@ -180,8 +180,9 @@ err_req:
 
 static struct amba_id pl031_ids[] __initdata = {
 	{
-		 .id = 0x00041031,
-	 	.mask = 0x000fffff, },
+		.id = 0x00041031,
+		.mask = 0x000fffff,
+	},
 	{0, 0},
 };
 
_

Patches currently in -mm which might be from linus.walleij@stericsson.com are

linux-next.patch
rtc-remove-__raw_-accessors-from-pl031-rtc.patch

