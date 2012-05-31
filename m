From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-pl031c-remove-rtc-timer-interrupt-handling.patch removed from -mm tree
Date: Thu, 31 May 2012 12:20:40 -0700
Message-ID: <20120531192040.898E0A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:46086 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933104Ab2EaTUm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:20:42 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so76227wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:20:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rajkumar.kasirajan@stericsson.com, a.zummo@towertech.it, linus.walleij@linaro.org, mattias.wallin@stericsson.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pl031.c: remove RTC timer interrupt handling
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-pl031c-remove-rtc-timer-interrupt-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>
Subject: drivers/rtc/rtc-pl031.c: remove RTC timer interrupt handling

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

diff -puN drivers/rtc/rtc-pl031.c~drivers-rtc-rtc-pl031c-remove-rtc-timer-interrupt-handling drivers/rtc/rtc-pl031.c
--- a/drivers/rtc/rtc-pl031.c~drivers-rtc-rtc-pl031c-remove-rtc-timer-interrupt-handling
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
