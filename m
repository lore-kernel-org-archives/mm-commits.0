From: akpm@linux-foundation.org
Subject: - cris-use-bcd2bin-bin2bcd.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:37:41 -0700
Message-ID: <200810202037.m9KKbfwO011689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754044AbYJTUil (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:38:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, zankel@tensilica.com, mm-commits@vger.kernel.org


The patch titled
     cris: use bcd2bin/bin2bcd
has been removed from the -mm tree.  Its filename was
     cris-use-bcd2bin-bin2bcd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cris: use bcd2bin/bin2bcd
From: Adrian Bunk <bunk@kernel.org>

Change cris to use the new bcd2bin/bin2bcd functions instead of the
obsolete BCD_TO_BIN/BIN_TO_BCD macros.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Chris Zankel <zankel@tensilica.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/drivers/ds1302.c  |   24 ++++++++++++------------
 arch/cris/arch-v10/drivers/pcf8563.c |   24 ++++++++++++------------
 arch/cris/arch-v32/drivers/pcf8563.c |   24 ++++++++++++------------
 arch/cris/kernel/time.c              |   18 +++++++++---------
 4 files changed, 45 insertions(+), 45 deletions(-)

diff -puN arch/cris/arch-v10/drivers/ds1302.c~cris-use-bcd2bin-bin2bcd arch/cris/arch-v10/drivers/ds1302.c
--- a/arch/cris/arch-v10/drivers/ds1302.c~cris-use-bcd2bin-bin2bcd
+++ a/arch/cris/arch-v10/drivers/ds1302.c
@@ -215,12 +215,12 @@ get_rtc_time(struct rtc_time *rtc_tm) 
 
 	local_irq_restore(flags);
 	
-	BCD_TO_BIN(rtc_tm->tm_sec);
-	BCD_TO_BIN(rtc_tm->tm_min);
-	BCD_TO_BIN(rtc_tm->tm_hour);
-	BCD_TO_BIN(rtc_tm->tm_mday);
-	BCD_TO_BIN(rtc_tm->tm_mon);
-	BCD_TO_BIN(rtc_tm->tm_year);
+	rtc_tm->tm_sec = bcd2bin(rtc_tm->tm_sec);
+	rtc_tm->tm_min = bcd2bin(rtc_tm->tm_min);
+	rtc_tm->tm_hour = bcd2bin(rtc_tm->tm_hour);
+	rtc_tm->tm_mday = bcd2bin(rtc_tm->tm_mday);
+	rtc_tm->tm_mon = bcd2bin(rtc_tm->tm_mon);
+	rtc_tm->tm_year = bcd2bin(rtc_tm->tm_year);
 
 	/*
 	 * Account for differences between how the RTC uses the values
@@ -295,12 +295,12 @@ rtc_ioctl(struct inode *inode, struct fi
 			else
 				yrs -= 1900;	/* RTC (70, 71, ... 99) */
 
-			BIN_TO_BCD(sec);
-			BIN_TO_BCD(min);
-			BIN_TO_BCD(hrs);
-			BIN_TO_BCD(day);
-			BIN_TO_BCD(mon);
-			BIN_TO_BCD(yrs);
+			sec = bin2bcd(sec);
+			min = bin2bcd(min);
+			hrs = bin2bcd(hrs);
+			day = bin2bcd(day);
+			mon = bin2bcd(mon);
+			yrs = bin2bcd(yrs);
 
 			local_irq_save(flags);
 			CMOS_WRITE(yrs, RTC_YEAR);
diff -puN arch/cris/arch-v10/drivers/pcf8563.c~cris-use-bcd2bin-bin2bcd arch/cris/arch-v10/drivers/pcf8563.c
--- a/arch/cris/arch-v10/drivers/pcf8563.c~cris-use-bcd2bin-bin2bcd
+++ a/arch/cris/arch-v10/drivers/pcf8563.c
@@ -122,7 +122,7 @@ get_rtc_time(struct rtc_time *tm)
 		       "information is no longer guaranteed!\n", PCF8563_NAME);
 	}
 
-	tm->tm_year  = BCD_TO_BIN(tm->tm_year) +
+	tm->tm_year  = bcd2bin(tm->tm_year) +
 		       ((tm->tm_mon & 0x80) ? 100 : 0);
 	tm->tm_sec  &= 0x7F;
 	tm->tm_min  &= 0x7F;
@@ -131,11 +131,11 @@ get_rtc_time(struct rtc_time *tm)
 	tm->tm_wday &= 0x07; /* Not coded in BCD. */
 	tm->tm_mon  &= 0x1F;
 
-	BCD_TO_BIN(tm->tm_sec);
-	BCD_TO_BIN(tm->tm_min);
-	BCD_TO_BIN(tm->tm_hour);
-	BCD_TO_BIN(tm->tm_mday);
-	BCD_TO_BIN(tm->tm_mon);
+	tm->tm_sec = bcd2bin(tm->tm_sec);
+	tm->tm_min = bcd2bin(tm->tm_min);
+	tm->tm_hour = bcd2bin(tm->tm_hour);
+	tm->tm_mday = bcd2bin(tm->tm_mday);
+	tm->tm_mon = bcd2bin(tm->tm_mon);
 	tm->tm_mon--; /* Month is 1..12 in RTC but 0..11 in linux */
 }
 
@@ -282,12 +282,12 @@ int pcf8563_ioctl(struct inode *inode, s
 		century = (tm.tm_year >= 2000) ? 0x80 : 0;
 		tm.tm_year = tm.tm_year % 100;
 
-		BIN_TO_BCD(tm.tm_year);
-		BIN_TO_BCD(tm.tm_mon);
-		BIN_TO_BCD(tm.tm_mday);
-		BIN_TO_BCD(tm.tm_hour);
-		BIN_TO_BCD(tm.tm_min);
-		BIN_TO_BCD(tm.tm_sec);
+		tm.tm_year = bin2bcd(tm.tm_year);
+		tm.tm_mon = bin2bcd(tm.tm_mon);
+		tm.tm_mday = bin2bcd(tm.tm_mday);
+		tm.tm_hour = bin2bcd(tm.tm_hour);
+		tm.tm_min = bin2bcd(tm.tm_min);
+		tm.tm_sec = bin2bcd(tm.tm_sec);
 		tm.tm_mon |= century;
 
 		mutex_lock(&rtc_lock);
diff -puN arch/cris/arch-v32/drivers/pcf8563.c~cris-use-bcd2bin-bin2bcd arch/cris/arch-v32/drivers/pcf8563.c
--- a/arch/cris/arch-v32/drivers/pcf8563.c~cris-use-bcd2bin-bin2bcd
+++ a/arch/cris/arch-v32/drivers/pcf8563.c
@@ -118,7 +118,7 @@ get_rtc_time(struct rtc_time *tm)
 		       "information is no longer guaranteed!\n", PCF8563_NAME);
 	}
 
-	tm->tm_year  = BCD_TO_BIN(tm->tm_year) +
+	tm->tm_year  = bcd2bin(tm->tm_year) +
 		       ((tm->tm_mon & 0x80) ? 100 : 0);
 	tm->tm_sec  &= 0x7F;
 	tm->tm_min  &= 0x7F;
@@ -127,11 +127,11 @@ get_rtc_time(struct rtc_time *tm)
 	tm->tm_wday &= 0x07; /* Not coded in BCD. */
 	tm->tm_mon  &= 0x1F;
 
-	BCD_TO_BIN(tm->tm_sec);
-	BCD_TO_BIN(tm->tm_min);
-	BCD_TO_BIN(tm->tm_hour);
-	BCD_TO_BIN(tm->tm_mday);
-	BCD_TO_BIN(tm->tm_mon);
+	tm->tm_sec = bcd2bin(tm->tm_sec);
+	tm->tm_min = bcd2bin(tm->tm_min);
+	tm->tm_hour = bcd2bin(tm->tm_hour);
+	tm->tm_mday = bcd2bin(tm->tm_mday);
+	tm->tm_mon = bcd2bin(tm->tm_mon);
 	tm->tm_mon--; /* Month is 1..12 in RTC but 0..11 in linux */
 }
 
@@ -279,12 +279,12 @@ int pcf8563_ioctl(struct inode *inode, s
 		century = (tm.tm_year >= 2000) ? 0x80 : 0;
 		tm.tm_year = tm.tm_year % 100;
 
-		BIN_TO_BCD(tm.tm_year);
-		BIN_TO_BCD(tm.tm_mon);
-		BIN_TO_BCD(tm.tm_mday);
-		BIN_TO_BCD(tm.tm_hour);
-		BIN_TO_BCD(tm.tm_min);
-		BIN_TO_BCD(tm.tm_sec);
+		tm.tm_year = bin2bcd(tm.tm_year);
+		tm.tm_mon = bin2bcd(tm.tm_mon);
+		tm.tm_mday = bin2bcd(tm.tm_mday);
+		tm.tm_hour = bin2bcd(tm.tm_hour);
+		tm.tm_min = bin2bcd(tm.tm_min);
+		tm.tm_sec = bin2bcd(tm.tm_sec);
 		tm.tm_mon |= century;
 
 		mutex_lock(&rtc_lock);
diff -puN arch/cris/kernel/time.c~cris-use-bcd2bin-bin2bcd arch/cris/kernel/time.c
--- a/arch/cris/kernel/time.c~cris-use-bcd2bin-bin2bcd
+++ a/arch/cris/kernel/time.c
@@ -127,7 +127,7 @@ int set_rtc_mmss(unsigned long nowtime)
 		return 0;
 
 	cmos_minutes = CMOS_READ(RTC_MINUTES);
-	BCD_TO_BIN(cmos_minutes);
+	cmos_minutes = bcd2bin(cmos_minutes);
 
 	/*
 	 * since we're only adjusting minutes and seconds,
@@ -142,8 +142,8 @@ int set_rtc_mmss(unsigned long nowtime)
 	real_minutes %= 60;
 
 	if (abs(real_minutes - cmos_minutes) < 30) {
-		BIN_TO_BCD(real_seconds);
-		BIN_TO_BCD(real_minutes);
+		real_seconds = bin2bcd(real_seconds);
+		real_minutes = bin2bcd(real_minutes);
 		CMOS_WRITE(real_seconds,RTC_SECONDS);
 		CMOS_WRITE(real_minutes,RTC_MINUTES);
 	} else {
@@ -170,12 +170,12 @@ get_cmos_time(void)
 	mon = CMOS_READ(RTC_MONTH);
 	year = CMOS_READ(RTC_YEAR);
 
-	BCD_TO_BIN(sec);
-	BCD_TO_BIN(min);
-	BCD_TO_BIN(hour);
-	BCD_TO_BIN(day);
-	BCD_TO_BIN(mon);
-	BCD_TO_BIN(year);
+	sec = bcd2bin(sec);
+	min = bcd2bin(min);
+	hour = bcd2bin(hour);
+	day = bcd2bin(day);
+	mon = bcd2bin(mon);
+	year = bcd2bin(year);
 
 	if ((year += 1900) < 1970)
 		year += 100;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-kernel-smpbootc-must-include-linux-cpuh.patch
the-overdue-eepro100-removal.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
reiser4.patch

