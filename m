From: akpm@osdl.org
Subject: - rtc-sh-act-on-rtc_wkalrmenabled-when-setting-an-alarm.patch removed from -mm tree
Date: Thu, 25 Jan 2007 23:51:32 -0800
Message-ID: <200701260751.l0Q7pWsH010734@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50486 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030815AbXAZHvr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 02:51:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lenehan@twibble.org, alessandro.zummo@towertech.it, david-b@pacbell.net, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     rtc-sh: act on rtc_wkalrm.enabled when setting an alarm
has been removed from the -mm tree.  Its filename was
     rtc-sh-act-on-rtc_wkalrmenabled-when-setting-an-alarm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc-sh: act on rtc_wkalrm.enabled when setting an alarm
From: Jamie Lenehan <lenehan@twibble.org>

This fixes the SH rtc driver correctly act on the "enabled" flag when
setting an alarm.

Signed-off-by: Jamie Lenehan <lenehan@twibble.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/rtc/rtc-sh.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-sh.c~rtc-sh-act-on-rtc_wkalrmenabled-when-setting-an-alarm drivers/rtc/rtc-sh.c
--- a/drivers/rtc/rtc-sh.c~rtc-sh-act-on-rtc_wkalrmenabled-when-setting-an-alarm
+++ a/drivers/rtc/rtc-sh.c
@@ -492,10 +492,10 @@ static int sh_rtc_set_alarm(struct devic
 
 	spin_lock_irq(&rtc->lock);
 
-	/* disable alarm interrupt and clear flag */
+	/* disable alarm interrupt and clear the alarm flag */
 	rcr1 = readb(rtc->regbase + RCR1);
-	rcr1 &= ~RCR1_AF;
-	writeb(rcr1 & ~RCR1_AIE, rtc->regbase + RCR1);
+	rcr1 &= ~(RCR1_AF|RCR1_AIE);
+	writeb(rcr1, rtc->regbase + RCR1);
 
 	rtc->rearm_aie = 0;
 
@@ -510,8 +510,10 @@ static int sh_rtc_set_alarm(struct devic
 		mon += 1;
 	sh_rtc_write_alarm_value(rtc, mon, RMONAR);
 
-	/* Restore interrupt activation status */
-	writeb(rcr1, rtc->regbase + RCR1);
+	if (wkalrm->enabled) {
+		rcr1 |= RCR1_AIE;
+		writeb(rcr1, rtc->regbase + RCR1);
+	}
 
 	spin_unlock_irq(&rtc->lock);
 
_

Patches currently in -mm which might be from lenehan@twibble.org are

git-sh.patch
