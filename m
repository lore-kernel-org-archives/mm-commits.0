From: akpm@linux-foundation.org
Subject: + rtc-fix-the-error-in-the-function-of-cmos_set_alarm.patch added to -mm tree
Date: Thu, 10 Apr 2008 22:16:20 -0700
Message-ID: <200804110516.m3B5GKpr002051@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423AbYDKFQb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Apr 2008 01:16:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yakui.zhao@intel.com, dbrownell@users.sourceforge.net, rui.zhang@intel.com


The patch titled
     rtc: fix the error in the function of cmos_set_alarm
has been added to the -mm tree.  Its filename is
     rtc-fix-the-error-in-the-function-of-cmos_set_alarm.patch

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
rtc-fix-the-error-in-the-function-of-cmos_set_alarm.patch
acpi-unneccessary-to-scan-the-pci-bus-already-scanned.patch

