From: akpm@linux-foundation.org
Subject: - rtc-fix-the-error-in-the-function-of-cmos_set_alarm.patch removed from -mm tree
Date: Wed, 16 Apr 2008 15:54:43 -0700
Message-ID: <200804162254.m3GMshEP011048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756451AbYDPWzc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 18:55:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yakui.zhao@intel.com, a.zummo@towertech.it, dbrownell@users.sourceforge.net, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     rtc: fix the error in the function of cmos_set_alarm
has been removed from the -mm tree.  Its filename was
     rtc-fix-the-error-in-the-function-of-cmos_set_alarm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: fix the error in the function of cmos_set_alarm
From: Zhao Yakui <yakui.zhao@intel.com>

There is a bug in the function of cmos_set_alarm.  RTC alarm time for October
can't be set correctly.

For October: 0x0A will be written into the RTC region (MONTH_ALARM) in current
kernel.  But in fact 0x10 should be written.  Wildcards are also not handled
correctly.

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-fix-the-error-in-the-function-of-cmos_set_alarm drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-fix-the-error-in-the-function-of-cmos_set_alarm
+++ a/drivers/rtc/rtc-cmos.c
@@ -198,9 +198,8 @@ static int cmos_set_alarm(struct device 
 
 	/* Writing 0xff means "don't care" or "match all".  */
 
-	mon = t->time.tm_mon;
-	mon = (mon < 12) ? BIN2BCD(mon) : 0xff;
-	mon++;
+	mon = t->time.tm_mon + 1;
+	mon = (mon <= 12) ? BIN2BCD(mon) : 0xff;
 
 	mday = t->time.tm_mday;
 	mday = (mday >= 1 && mday <= 31) ? BIN2BCD(mday) : 0xff;
_

Patches currently in -mm which might be from yakui.zhao@intel.com are

origin.patch
git-acpi.patch
acpi-check-a-return-value-correctly-in-acpi_power_get_context.patch
rtc-add-the-support-for-alarm-time-relative-to-current-time-in-sysfs.patch

