From: akpm@linux-foundation.org
Subject: + rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch added to -mm tree
Date: Mon, 20 Aug 2012 14:36:44 -0700
Message-ID: <20120820213645.259725C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:60078 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784Ab2HTVgr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 17:36:47 -0400
Received: by lbbge1 with SMTP id ge1so316400lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 14:36:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shawn.guo@linaro.org, a.zummo@towertech.it, kim.phillips@freescale.com, s.hauer@pengutronix.de, sboyd@codeaurora.org


The patch titled
     Subject: rtc: snvs: change timeout to use a fixed number of loop
has been added to the -mm tree.  Its filename is
     rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
