From: akpm@linux-foundation.org
Subject: - rtc-at32ap700x-fix-bug-in-at32_rtc_readalarm.patch removed from -mm tree
Date: Sun, 15 Jun 2008 23:03:30 -0700
Message-ID: <200806160603.m5G63UDd010600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43668 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751366AbYFPGDs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jun 2008 02:03:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haavard.skinnemoen@atmel.com, a.zummo@towertech.it, david-b@pacbell.net, hans-christian.egtvedt@atmel.com, mm-commits@vger.kernel.org


The patch titled
     rtc-at32ap700x: fix bug in at32_rtc_readalarm()
has been removed from the -mm tree.  Its filename was
     rtc-at32ap700x-fix-bug-in-at32_rtc_readalarm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch

