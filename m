From: akpm@linux-foundation.org
Subject: + proc-acpi-alarm-handle-day-of-month-wraparound-on-readback.patch added to -mm tree
Date: Tue, 09 Dec 2008 11:54:32 -0800
Message-ID: <200812091954.mB9JsWUr007103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754081AbYLITys (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Dec 2008 14:54:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lkml@rtr.ca, lenb@kernel.org, mlord@pobox.com


The patch titled
     /proc/acpi/alarm: handle day-of-month wraparound on readback
has been added to the -mm tree.  Its filename is
     proc-acpi-alarm-handle-day-of-month-wraparound-on-readback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: /proc/acpi/alarm: handle day-of-month wraparound on readback
From: Mark Lord <lkml@rtr.ca>

Fix month wrap issue with readback from /proc/acpi/alarm This bug has been
around *forever*.

  $ echo '2008-12-01 10:36:20' > /proc/acpi/alarm
  $ cat /proc/acpi/alarm
  2008-11-01 10:36:20

Note how the readback above shows the month incorrectly when the alarm is
set in the *next* calendar month.  But with this patch applied, it shows
the correct month (12).

This patch applies/works on 2.6.28-rc6.
Probably best to queue it up for the next major cycle.

Signed-off-by: Mark Lord <mlord@pobox.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/proc.c |   53 +++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 21 deletions(-)

diff -puN drivers/acpi/sleep/proc.c~proc-acpi-alarm-handle-day-of-month-wraparound-on-readback drivers/acpi/sleep/proc.c
--- a/drivers/acpi/sleep/proc.c~proc-acpi-alarm-handle-day-of-month-wraparound-on-readback
+++ a/drivers/acpi/sleep/proc.c
@@ -84,12 +84,15 @@ acpi_system_write_sleep(struct file *fil
 #define	HAVE_ACPI_LEGACY_ALARM
 #endif
 
+static u32 cmos_bcd_read(int offset, int rtc_control);
+
 #ifdef	HAVE_ACPI_LEGACY_ALARM
 
 static int acpi_system_alarm_seq_show(struct seq_file *seq, void *offset)
 {
 	u32 sec, min, hr;
 	u32 day, mo, yr, cent = 0;
+	u32 today = 0;
 	unsigned char rtc_control = 0;
 	unsigned long flags;
 
@@ -97,38 +100,32 @@ static int acpi_system_alarm_seq_show(st
 
 	spin_lock_irqsave(&rtc_lock, flags);
 
-	sec = CMOS_READ(RTC_SECONDS_ALARM);
-	min = CMOS_READ(RTC_MINUTES_ALARM);
-	hr = CMOS_READ(RTC_HOURS_ALARM);
 	rtc_control = CMOS_READ(RTC_CONTROL);
+	sec = cmos_bcd_read(RTC_SECONDS_ALARM, rtc_control);
+	min = cmos_bcd_read(RTC_MINUTES_ALARM, rtc_control);
+	hr = cmos_bcd_read(RTC_HOURS_ALARM, rtc_control);
 
 	/* If we ever get an FACP with proper values... */
-	if (acpi_gbl_FADT.day_alarm)
+	if (acpi_gbl_FADT.day_alarm) {
 		/* ACPI spec: only low 6 its should be cared */
 		day = CMOS_READ(acpi_gbl_FADT.day_alarm) & 0x3F;
-	else
-		day = CMOS_READ(RTC_DAY_OF_MONTH);
+		if (!(rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
+			day = bcd2bin(day);
+	} else
+		day = cmos_bcd_read(RTC_DAY_OF_MONTH, rtc_control);
 	if (acpi_gbl_FADT.month_alarm)
-		mo = CMOS_READ(acpi_gbl_FADT.month_alarm);
-	else
-		mo = CMOS_READ(RTC_MONTH);
+		mo = cmos_bcd_read(acpi_gbl_FADT.month_alarm, rtc_control);
+	else {
+		mo = cmos_bcd_read(RTC_MONTH, rtc_control);
+		today = cmos_bcd_read(RTC_DAY_OF_MONTH, rtc_control);
+	}
 	if (acpi_gbl_FADT.century)
-		cent = CMOS_READ(acpi_gbl_FADT.century);
+		cent = cmos_bcd_read(acpi_gbl_FADT.century, rtc_control);
 
-	yr = CMOS_READ(RTC_YEAR);
+	yr = cmos_bcd_read(RTC_YEAR, rtc_control);
 
 	spin_unlock_irqrestore(&rtc_lock, flags);
 
-	if (!(rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		sec = bcd2bin(sec);
-		min = bcd2bin(min);
-		hr = bcd2bin(hr);
-		day = bcd2bin(day);
-		mo = bcd2bin(mo);
-		yr = bcd2bin(yr);
-		cent = bcd2bin(cent);
-	}
-
 	/* we're trusting the FADT (see above) */
 	if (!acpi_gbl_FADT.century)
 		/* If we're not trusting the FADT, we should at least make it
@@ -153,6 +150,20 @@ static int acpi_system_alarm_seq_show(st
 	else
 		yr += cent * 100;
 
+	/*
+	 * Show correct dates for alarms up to a month into the future.
+	 * This solves issues for nearly all situations with the common
+	 * 30-day alarm clocks in PC hardware.
+	 */
+	if (day < today) {
+		if (mo < 12) {
+			mo += 1;
+		} else {
+			mo = 1;
+			yr += 1;
+		}
+	}
+
 	seq_printf(seq, "%4.4u-", yr);
 	(mo > 12) ? seq_puts(seq, "**-") : seq_printf(seq, "%2.2u-", mo);
 	(day > 31) ? seq_puts(seq, "** ") : seq_printf(seq, "%2.2u ", day);
_

Patches currently in -mm which might be from lkml@rtr.ca are

proc-acpi-alarm-handle-day-of-month-wraparound-on-readback.patch
radio-si470x-add-usb-id-for-dealextreme-usb-radio.patch

