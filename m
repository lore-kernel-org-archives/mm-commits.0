From: akpm@linux-foundation.org
Subject: + rtc-update-vr41xx-alarm-handling.patch added to -mm tree
Date: Wed, 25 Apr 2007 17:10:42 -0700
Message-ID: <200704260010.l3Q0Ag3r016494@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751951AbXDZALh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 20:11:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yoichi_yuasa@tripeaks.co.jp, a.zummo@towertech.it, dbrownell@users.sourceforge.net


The patch titled
     rtc: update vr41xx alarm handling
has been added to the -mm tree.  Its filename is
     rtc-update-vr41xx-alarm-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc: update vr41xx alarm handling
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

- vr41xx_rtc_read_alarm() reports alarm enabled.
- vr41xx_rtc_set_alarm() sets alarm disable/enable by rtc_wkalrm.enabled.

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-vr41xx.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-vr41xx.c~rtc-update-vr41xx-alarm-handling drivers/rtc/rtc-vr41xx.c
--- a/drivers/rtc/rtc-vr41xx.c~rtc-update-vr41xx-alarm-handling
+++ a/drivers/rtc/rtc-vr41xx.c
@@ -97,6 +97,7 @@ static DEFINE_SPINLOCK(rtc_lock);
 static char rtc_name[] = "RTC";
 static unsigned long periodic_frequency;
 static unsigned long periodic_count;
+static unsigned int alarm_enabled;
 
 struct resource rtc_resource[2] = {
 	{	.name	= rtc_name,
@@ -188,6 +189,7 @@ static int vr41xx_rtc_read_alarm(struct 
 	low = rtc1_read(ECMPLREG);
 	mid = rtc1_read(ECMPMREG);
 	high = rtc1_read(ECMPHREG);
+	wkalrm->enabled = alarm_enabled;
 
 	spin_unlock_irq(&rtc_lock);
 
@@ -206,10 +208,18 @@ static int vr41xx_rtc_set_alarm(struct d
 
 	spin_lock_irq(&rtc_lock);
 
+	if (alarm_enabled)
+		disable_irq(ELAPSEDTIME_IRQ);
+
 	rtc1_write(ECMPLREG, (uint16_t)(alarm_sec << 15));
 	rtc1_write(ECMPMREG, (uint16_t)(alarm_sec >> 1));
 	rtc1_write(ECMPHREG, (uint16_t)(alarm_sec >> 17));
 
+	if (wkalrm->enabled)
+		enable_irq(ELAPSEDTIME_IRQ);
+
+	alarm_enabled = wkalrm->enabled;
+
 	spin_unlock_irq(&rtc_lock);
 
 	return 0;
@@ -221,10 +231,24 @@ static int vr41xx_rtc_ioctl(struct devic
 
 	switch (cmd) {
 	case RTC_AIE_ON:
-		enable_irq(ELAPSEDTIME_IRQ);
+		spin_lock_irq(&rtc_lock);
+
+		if (!alarm_enabled) {
+			enable_irq(ELAPSEDTIME_IRQ);
+			alarm_enabled = 1;
+		}
+
+		spin_unlock_irq(&rtc_lock);
 		break;
 	case RTC_AIE_OFF:
-		disable_irq(ELAPSEDTIME_IRQ);
+		spin_lock_irq(&rtc_lock);
+
+		if (alarm_enabled) {
+			disable_irq(ELAPSEDTIME_IRQ);
+			alarm_enabled = 0;
+		}
+
+		spin_unlock_irq(&rtc_lock);
 		break;
 	case RTC_PIE_ON:
 		enable_irq(RTCLONG1_IRQ);
_

Patches currently in -mm which might be from yoichi_yuasa@tripeaks.co.jp are

git-input.patch
git-mips.patch
rtc-update-vr41xx-alarm-handling.patch
