From: akpm@linux-foundation.org
Subject: + rtc-at32ap700x-fix-bug-in-at32_rtc_readalarm.patch added to -mm tree
Date: Wed, 11 Jun 2008 12:10:06 -0700
Message-ID: <200806111910.m5BJA6wK013166@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505AbYFKTKr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 15:10:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haavard.skinnemoen@atmel.com, a.zummo@towertech.it, david-b@pacbell.net, hans-christian.egtvedt@atmel.com


The patch titled
     rtc-at32ap700x: fix bug in at32_rtc_readalarm()
has been added to the -mm tree.  Its filename is
     rtc-at32ap700x-fix-bug-in-at32_rtc_readalarm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-at32ap700x: fix bug in at32_rtc_readalarm()
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

alarm->pending indicates whether there's an alarm that has actually been
triggered, not whether we're waiting for it.  alarm->enabled indicates
that.

Also add missing locking around reading the RTC registers.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at32ap700x.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-at32ap700x.c~rtc-at32ap700x-fix-bug-in-at32_rtc_readalarm drivers/rtc/rtc-at32ap700x.c
--- a/drivers/rtc/rtc-at32ap700x.c~rtc-at32ap700x-fix-bug-in-at32_rtc_readalarm
+++ a/drivers/rtc/rtc-at32ap700x.c
@@ -94,8 +94,11 @@ static int at32_rtc_readalarm(struct dev
 {
 	struct rtc_at32ap700x *rtc = dev_get_drvdata(dev);
 
+	spin_lock_irq(&rtc->lock);
 	rtc_time_to_tm(rtc->alarm_time, &alrm->time);
-	alrm->pending = rtc_readl(rtc, IMR) & RTC_BIT(IMR_TOPI) ? 1 : 0;
+	alrm->enabled = rtc_readl(rtc, IMR) & RTC_BIT(IMR_TOPI) ? 1 : 0;
+	alrm->pending = rtc_readl(rtc, ISR) & RTC_BIT(ISR_TOPI) ? 1 : 0;
+	spin_unlock_irq(&rtc->lock);
 
 	return 0;
 }
@@ -119,7 +122,7 @@ static int at32_rtc_setalarm(struct devi
 	spin_lock_irq(&rtc->lock);
 	rtc->alarm_time = alarm_unix_time;
 	rtc_writel(rtc, TOP, rtc->alarm_time);
-	if (alrm->pending)
+	if (alrm->enabled)
 		rtc_writel(rtc, CTRL, rtc_readl(rtc, CTRL)
 				| RTC_BIT(CTRL_TOPEN));
 	else
_

Patches currently in -mm which might be from haavard.skinnemoen@atmel.com are

origin.patch
rtc-at32ap700x-fix-bug-in-at32_rtc_readalarm.patch
linux-next.patch

