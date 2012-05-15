From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-pl031c-remove-rtc-timer-interrupt-handling.patch added to -mm tree
Date: Tue, 15 May 2012 15:22:09 -0700
Message-ID: <20120515222209.A555EA0397@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:39509 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965655Ab2EOWWK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 May 2012 18:22:10 -0400
Received: by yhgm50 with SMTP id m50so20383yhg.1
        for <mm-commits@vger.kernel.org>; Tue, 15 May 2012 15:22:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rajkumar.kasirajan@stericsson.com, a.zummo@towertech.it, linus.walleij@linaro.org, mattias.wallin@stericsson.com


The patch titled
     Subject: drivers/rtc/rtc-pl031.c: remove RTC timer interrupt handling
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-pl031c-remove-rtc-timer-interrupt-handling.patch

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
Subject: drivers/rtc/rtc-pl031.c: remove RTC timer interrupt handling.

Remove RTT interrupt handling, since PIE mode interrupts are now better
emulated in generic code via an hrtimer we have no need for this, and
there is no codepath in the driver that enables these periodic interrupts
anyway.

Signed-off-by: Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pl031.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-pl031.c~rtc-pl031-removed-rtc-timer-interrupt-handling drivers/rtc/rtc-pl031.c
--- a/drivers/rtc/rtc-pl031.c~rtc-pl031-removed-rtc-timer-interrupt-handling
+++ a/drivers/rtc/rtc-pl031.c
@@ -220,17 +220,9 @@ static irqreturn_t pl031_interrupt(int i
 	unsigned long events = 0;
 
 	rtcmis = readl(ldata->base + RTC_MIS);
-	if (rtcmis) {
-		writel(rtcmis, ldata->base + RTC_ICR);
-
-		if (rtcmis & RTC_BIT_AI)
-			events |= (RTC_AF | RTC_IRQF);
-
-		/* Timer interrupt is only available in ST variants */
-		if ((rtcmis & RTC_BIT_PI) &&
-			(ldata->hw_designer == AMBA_VENDOR_ST))
-			events |= (RTC_PF | RTC_IRQF);
