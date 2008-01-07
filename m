From: akpm@linux-foundation.org
Subject: - rtc-dont-write-rtc-century-when-setting-a-wake-alarm.patch removed from -mm tree
Date: Mon, 07 Jan 2008 12:02:58 -0800
Message-ID: <200801072002.m07K2cLn009856@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41893 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751817AbYAGUEC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 15:04:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkml@rtr.ca, david-b@pacbell.net, lenb@kernel.org, mlord@pobox.com, mm-commits@vger.kernel.org


The patch titled
     rtc: don't write RTC century when setting a wake alarm
has been removed from the -mm tree.  Its filename was
     rtc-dont-write-rtc-century-when-setting-a-wake-alarm.patch

This patch was dropped because git-acpi changes destroyed it

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: don't write RTC century when setting a wake alarm
From: Mark Lord <lkml@rtr.ca>

Fix /proc/acpi/alarm to not overwrite the RTC century field when setting a
wake alarm.  The alarm hardware doesn't have a century field, and we really
should not be fiddling with the RTC century field here.

Signed-off-by: Mark Lord <mlord@pobox.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/proc.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/acpi/sleep/proc.c~rtc-dont-write-rtc-century-when-setting-a-wake-alarm drivers/acpi/sleep/proc.c
--- a/drivers/acpi/sleep/proc.c~rtc-dont-write-rtc-century-when-setting-a-wake-alarm
+++ a/drivers/acpi/sleep/proc.c
@@ -268,7 +268,6 @@ acpi_system_write_alarm(struct file *fil
 		day -= 31;
 	}
 	if (mo > 12) {
-		yr += 1;
 		mo -= 12;
 	}
 
@@ -277,7 +276,6 @@ acpi_system_write_alarm(struct file *fil
 	rtc_control = CMOS_READ(RTC_CONTROL);
 
 	if (adjust) {
-		yr += cmos_bcd_read(RTC_YEAR, rtc_control);
 		mo += cmos_bcd_read(RTC_MONTH, rtc_control);
 		day += cmos_bcd_read(RTC_DAY_OF_MONTH, rtc_control);
 		hr += cmos_bcd_read(RTC_HOURS, rtc_control);
@@ -304,7 +302,6 @@ acpi_system_write_alarm(struct file *fil
 		day -= 31;
 	}
 	if (mo > 12) {
-		yr++;
 		mo -= 12;
 	}
 
@@ -331,8 +328,6 @@ acpi_system_write_alarm(struct file *fil
 		cmos_bcd_write(day, acpi_gbl_FADT.day_alarm, rtc_control);
 	if (acpi_gbl_FADT.month_alarm)
 		cmos_bcd_write(mo, acpi_gbl_FADT.month_alarm, rtc_control);
-	if (acpi_gbl_FADT.century)
-		cmos_bcd_write(yr / 100, acpi_gbl_FADT.century, rtc_control);
 	/* enable the rtc alarm interrupt */
 	rtc_control |= RTC_AIE;
 	CMOS_WRITE(rtc_control, RTC_CONTROL);
_

Patches currently in -mm which might be from lkml@rtr.ca are

rtc-dont-write-rtc-century-when-setting-a-wake-alarm.patch
