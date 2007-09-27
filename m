From: akpm@linux-foundation.org
Subject: + fix-proc-acpi-alarm-to-work-with-bcd-alarm-encodings-award.patch added to -mm tree
Date: Wed, 26 Sep 2007 21:04:53 -0700
Message-ID: <200709270404.l8R44rcO018532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52316 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145AbXI0EFR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Sep 2007 00:05:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lkml@rtr.ca, akpm@linux-foundation.org, david-b@pacbell.net, lenb@kernel.org, mlord@pobox.com


The patch titled
     Fix /proc/acpi/alarm to work with BCD alarm encodings (AWARD BIOS)
has been added to the -mm tree.  Its filename is
     fix-proc-acpi-alarm-to-work-with-bcd-alarm-encodings-award.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix /proc/acpi/alarm to work with BCD alarm encodings (AWARD BIOS)
From: Mark Lord <lkml@rtr.ca>

My Foxconn motherboard has ICH8 + AWARD BIOS.  The BIOS seems to prefer to
maintain the RTC alarm in BCD format rather than binary.

The existing code in linux/drivers/acpi/sleep/proc.c has a nasty bug that
prevents BCD mode from working: the code converts binary to BCD three times
in a row, each time taking the previous result.  This thoroughly mangles
the alarm timestamp, and never worked.

The patch below fixes it, by removing the first two (bogus) conversions,
and leaving only the final conversion in place.  Tested & working on my
system here.

Note for future enhancement: fix the code to either handle 12-hour mode (as
opposed to the more sensible 24-hour mode) timekeeping, or at least have it
complain loudly when 12-hour mode is detected.

Signed-off-by: Mark Lord <mlord@pobox.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Len Brown <lenb@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/proc.c |   17 -----------------
 1 file changed, 17 deletions(-)

diff -puN drivers/acpi/sleep/proc.c~fix-proc-acpi-alarm-to-work-with-bcd-alarm-encodings-award drivers/acpi/sleep/proc.c
--- a/drivers/acpi/sleep/proc.c~fix-proc-acpi-alarm-to-work-with-bcd-alarm-encodings-award
+++ a/drivers/acpi/sleep/proc.c
@@ -258,14 +258,6 @@ acpi_system_write_alarm(struct file *fil
 	spin_lock_irq(&rtc_lock);
 
 	rtc_control = CMOS_READ(RTC_CONTROL);
-	if (!(rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		BIN_TO_BCD(yr);
-		BIN_TO_BCD(mo);
-		BIN_TO_BCD(day);
-		BIN_TO_BCD(hr);
-		BIN_TO_BCD(min);
-		BIN_TO_BCD(sec);
-	}
 
 	if (adjust) {
 		yr += CMOS_READ(RTC_YEAR);
@@ -278,15 +270,6 @@ acpi_system_write_alarm(struct file *fil
 
 	spin_unlock_irq(&rtc_lock);
 
-	if (!(rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		BCD_TO_BIN(yr);
-		BCD_TO_BIN(mo);
-		BCD_TO_BIN(day);
-		BCD_TO_BIN(hr);
-		BCD_TO_BIN(min);
-		BCD_TO_BIN(sec);
-	}
-
 	if (sec > 59) {
 		min++;
 		sec -= 60;
_

Patches currently in -mm which might be from lkml@rtr.ca are

fix-proc-acpi-alarm-to-work-with-bcd-alarm-encodings-award.patch
