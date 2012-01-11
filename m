From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-interfacec-fix-alarm-rollover-when-day-or-month-is-out-of-range.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:32:46 -0800
Message-ID: <20120111213247.3DF1C5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:43465 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758163Ab2AKVcu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:32:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@decadent.org.uk, a.zummo@towertech.it, broonie@opensource.wolfsonmicro.com, john.stultz@linaro.org, jrnieder@gmail.com, leoweppelman@googlemail.com, mailme667@yahoo.co.uk, mroberto@cpti.cetuc.puc-rio.br, stable@vger.kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/interface.c: fix alarm rollover when day or month is out-of-range
has been removed from the -mm tree.  Its filename was
     drivers-rtc-interfacec-fix-alarm-rollover-when-day-or-month-is-out-of-range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Ben Hutchings <ben@decadent.org.uk>
Subject: drivers/rtc/interface.c: fix alarm rollover when day or month is out-of-range

Commit f44f7f96a20a ("RTC: Initialize kernel state from RTC") introduced a
potential infinite loop.  If an alarm time contains a wildcard month and
an invalid day (> 31), or a wildcard year and an invalid month (>= 12),
the loop searching for the next matching date will never terminate.  Treat
the invalid values as wildcards.

Fixes <http://bugs.debian.org/646429>, <http://bugs.debian.org/653331>

Reported-by: leo weppelman <leoweppelman@googlemail.com>
Reported-by: "P. van Gaans" <mailme667@yahoo.co.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/interface.c~drivers-rtc-interfacec-fix-alarm-rollover-when-day-or-month-is-out-of-range drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~drivers-rtc-interfacec-fix-alarm-rollover-when-day-or-month-is-out-of-range
+++ a/drivers/rtc/interface.c
@@ -228,11 +228,11 @@ int __rtc_read_alarm(struct rtc_device *
 		alarm->time.tm_hour = now.tm_hour;
 
 	/* For simplicity, only support date rollover for now */
-	if (alarm->time.tm_mday == -1) {
+	if (alarm->time.tm_mday < 1 || alarm->time.tm_mday > 31) {
 		alarm->time.tm_mday = now.tm_mday;
 		missing = day;
 	}
-	if (alarm->time.tm_mon == -1) {
+	if ((unsigned)alarm->time.tm_mon >= 12) {
 		alarm->time.tm_mon = now.tm_mon;
 		if (missing == none)
 			missing = month;
_

Patches currently in -mm which might be from ben@decadent.org.uk are

origin.patch
linux-next.patch

