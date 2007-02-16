From: akpm@linux-foundation.org
Subject: + rtc-sa1100-rtc_wklarmenabled-bugfixes.patch added to -mm tree
Date: Thu, 15 Feb 2007 19:11:17 -0800
Message-ID: <200702160311.l1G3BHGd017745@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47813 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932566AbXBPDLj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 22:11:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net


The patch titled
     rtc-sa1100 rtc_wklarm.enabled bugfixes
has been added to the -mm tree.  Its filename is
     rtc-sa1100-rtc_wklarmenabled-bugfixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc-sa1100 rtc_wklarm.enabled bugfixes
From: David Brownell <david-b@pacbell.net>

Some rtc-sa1100 bugfixes:

 - The read_alarm() method reports the rtc_wkalrm.enabled field properly.
   This patch is already in the handhelds.org tree.

 - And the set_alarm() method now handles that flag correctly, rather than
   making mismatched {en,dis}able_irq_wake() calls, which trigger runtime
   warning messages.  (Those calls are best made in suspend/resume methods.)

Note that while this SA1100/PXA RTC is fully capable of waking those ARM
processors from sleep states, that mechanism isn't properly supported on
either processor family, or in this driver.  Some boards have board-specific
PM glue providing partial workarounds for the weak generic PM support.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-sa1100.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-sa1100.c~rtc-sa1100-rtc_wklarmenabled-bugfixes drivers/rtc/rtc-sa1100.c
--- a/drivers/rtc/rtc-sa1100.c~rtc-sa1100-rtc_wklarmenabled-bugfixes
+++ a/drivers/rtc/rtc-sa1100.c
@@ -263,8 +263,12 @@ static int sa1100_rtc_set_time(struct de
 
 static int sa1100_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
+	u32	rtsr;
+
 	memcpy(&alrm->time, &rtc_alarm, sizeof(struct rtc_time));
-	alrm->pending = RTSR & RTSR_AL ? 1 : 0;
+	rtsr = RTSR;
+	alrm->enabled = (rtsr & RTSR_ALE) ? 1 : 0;
+	alrm->pending = (rtsr & RTSR_AL) ? 1 : 0;
 	return 0;
 }
 
@@ -275,12 +279,10 @@ static int sa1100_rtc_set_alarm(struct d
 	spin_lock_irq(&sa1100_rtc_lock);
 	ret = rtc_update_alarm(&alrm->time);
 	if (ret == 0) {
-		memcpy(&rtc_alarm, &alrm->time, sizeof(struct rtc_time));
-
 		if (alrm->enabled)
-			enable_irq_wake(IRQ_RTCAlrm);
+			RTSR |= RTSR_ALE;
 		else
-			disable_irq_wake(IRQ_RTCAlrm);
+			RTSR &= ~RTSR_ALE;
 	}
 	spin_unlock_irq(&sa1100_rtc_lock);
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
gpio-core-documentation.patch
git-acpi.patch
git-avr32.patch
git-md-accel.patch
8250-make-probing-for-txen-bug-a-config-option.patch
loosen-dependancy-on-rtc-cmos.patch
rtc-sa1100-rtc_wklarmenabled-bugfixes.patch
