From: akpm@linux-foundation.org
Subject: [folded-dropped] rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch removed from -mm tree
Date: Thu, 04 Oct 2012 16:59:07 -0700
Message-ID: <20121004235908.60E4E1E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:41747 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab2JDX7J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 19:59:09 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so129482ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 16:59:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shawn.guo@linaro.org, a.zummo@towertech.it, kim.phillips@freescale.com, s.hauer@pengutronix.de, sboyd@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: snvs: change timeout to use a fixed number of loop
has been removed from the -mm tree.  Its filename was
     rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch

This patch was dropped because it was folded into rtc-snvs-add-freescale-rtc-snvs-driver.patch

------------------------------------------------------
From: Shawn Guo <shawn.guo@linaro.org>
Subject: rtc: snvs: change timeout to use a fixed number of loop

Andrew Morton <akpm@linux-foundation.org> wrote:

> The timeout code here is fragile.  If acquiring the spinlock takes more
> than a millisecond or if this thread gets interrupted or preempted then
> we could easily execute that loop just a single time, and fail.
>
> It would be better to retry a fixed number of times, say 1000?  That
> would take around 1 millisecond, but might be overkill.

Take Andrew's suggestion to change the timeout code to retry 1000
times.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Kim Phillips <kim.phillips@freescale.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-snvs.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-snvs.c~rtc-snvs-add-freescale-rtc-snvs-driver-fix drivers/rtc/rtc-snvs.c
--- a/drivers/rtc/rtc-snvs.c~rtc-snvs-add-freescale-rtc-snvs-driver-fix
+++ a/drivers/rtc/rtc-snvs.c
@@ -83,8 +83,8 @@ static void rtc_write_sync_lp(void __iom
 
 static int snvs_rtc_enable(struct snvs_rtc_data *data, bool enable)
 {
-	unsigned long timeout = jiffies + msecs_to_jiffies(1);
 	unsigned long flags;
+	int timeout = 1000;
 	u32 lpcr;
 
 	spin_lock_irqsave(&data->lock, flags);
@@ -98,7 +98,7 @@ static int snvs_rtc_enable(struct snvs_r
 
 	spin_unlock_irqrestore(&data->lock, flags);
 
-	while (1) {
+	while (--timeout) {
 		lpcr = readl(data->ioaddr + SNVS_LPCR);
 
 		if (enable) {
@@ -108,11 +108,11 @@ static int snvs_rtc_enable(struct snvs_r
 			if (!(lpcr & SNVS_LPCR_SRTC_ENV))
 				break;
 		}
