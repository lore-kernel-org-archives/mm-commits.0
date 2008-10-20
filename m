From: akpm@linux-foundation.org
Subject: - mips-use-bcd2bin-bin2bcd.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:37:51 -0700
Message-ID: <200810202037.m9KKbpaj011729@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754603AbYJTUqz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips: use bcd2bin/bin2bcd
has been removed from the -mm tree.  Its filename was
     mips-use-bcd2bin-bin2bcd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mips: use bcd2bin/bin2bcd
From: Adrian Bunk <bunk@kernel.org>

Changes mips to use the new bcd2bin/bin2bcd functions instead of the
obsolete BCD_TO_BIN/BIN_TO_BCD/BCD2BIN/BIN2BCD macros.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/dec/time.c                   |   18 ++++++-------
 arch/mips/include/asm/mc146818-time.h  |   18 ++++++-------
 arch/mips/pmc-sierra/yosemite/setup.c  |   30 +++++++++++------------
 arch/mips/sibyte/swarm/rtc_m41t81.c    |   26 +++++++++----------
 arch/mips/sibyte/swarm/rtc_xicor1241.c |   26 +++++++++----------
 5 files changed, 59 insertions(+), 59 deletions(-)

diff -puN arch/mips/dec/time.c~mips-use-bcd2bin-bin2bcd arch/mips/dec/time.c
--- a/arch/mips/dec/time.c~mips-use-bcd2bin-bin2bcd
+++ a/arch/mips/dec/time.c
@@ -45,12 +45,12 @@ unsigned long read_persistent_clock(void
 	spin_unlock_irqrestore(&rtc_lock, flags);
 
 	if (!(CMOS_READ(RTC_CONTROL) & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		sec = BCD2BIN(sec);
-		min = BCD2BIN(min);
-		hour = BCD2BIN(hour);
-		day = BCD2BIN(day);
-		mon = BCD2BIN(mon);
-		year = BCD2BIN(year);
+		sec = bcd2bin(sec);
+		min = bcd2bin(min);
+		hour = bcd2bin(hour);
+		day = bcd2bin(day);
+		mon = bcd2bin(mon);
+		year = bcd2bin(year);
 	}
 
 	year += real_year - 72 + 2000;
@@ -83,7 +83,7 @@ int rtc_mips_set_mmss(unsigned long nowt
 
 	cmos_minutes = CMOS_READ(RTC_MINUTES);
 	if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
-		cmos_minutes = BCD2BIN(cmos_minutes);
+		cmos_minutes = bcd2bin(cmos_minutes);
 
 	/*
 	 * since we're only adjusting minutes and seconds,
@@ -99,8 +99,8 @@ int rtc_mips_set_mmss(unsigned long nowt
 
 	if (abs(real_minutes - cmos_minutes) < 30) {
 		if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-			real_seconds = BIN2BCD(real_seconds);
-			real_minutes = BIN2BCD(real_minutes);
+			real_seconds = bin2bcd(real_seconds);
+			real_minutes = bin2bcd(real_minutes);
 		}
 		CMOS_WRITE(real_seconds, RTC_SECONDS);
 		CMOS_WRITE(real_minutes, RTC_MINUTES);
diff -puN arch/mips/include/asm/mc146818-time.h~mips-use-bcd2bin-bin2bcd arch/mips/include/asm/mc146818-time.h
--- a/arch/mips/include/asm/mc146818-time.h~mips-use-bcd2bin-bin2bcd
+++ a/arch/mips/include/asm/mc146818-time.h
@@ -44,7 +44,7 @@ static inline int mc146818_set_rtc_mmss(
 
 	cmos_minutes = CMOS_READ(RTC_MINUTES);
 	if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
-		BCD_TO_BIN(cmos_minutes);
+		cmos_minutes = bcd2bin(cmos_minutes);
 
 	/*
 	 * since we're only adjusting minutes and seconds,
@@ -60,8 +60,8 @@ static inline int mc146818_set_rtc_mmss(
 
 	if (abs(real_minutes - cmos_minutes) < 30) {
 		if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-			BIN_TO_BCD(real_seconds);
-			BIN_TO_BCD(real_minutes);
+			real_seconds = bin2bcd(real_seconds);
+			real_minutes = bin2bcd(real_minutes);
 		}
 		CMOS_WRITE(real_seconds, RTC_SECONDS);
 		CMOS_WRITE(real_minutes, RTC_MINUTES);
@@ -103,12 +103,12 @@ static inline unsigned long mc146818_get
 	} while (sec != CMOS_READ(RTC_SECONDS));
 
 	if (!(CMOS_READ(RTC_CONTROL) & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		BCD_TO_BIN(sec);
-		BCD_TO_BIN(min);
-		BCD_TO_BIN(hour);
-		BCD_TO_BIN(day);
-		BCD_TO_BIN(mon);
-		BCD_TO_BIN(year);
+		sec = bcd2bin(sec);
+		min = bcd2bin(min);
+		hour = bcd2bin(hour);
+		day = bcd2bin(day);
+		mon = bcd2bin(mon);
+		year = bcd2bin(year);
 	}
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	year = mc146818_decode_year(year);
diff -puN arch/mips/pmc-sierra/yosemite/setup.c~mips-use-bcd2bin-bin2bcd arch/mips/pmc-sierra/yosemite/setup.c
--- a/arch/mips/pmc-sierra/yosemite/setup.c~mips-use-bcd2bin-bin2bcd
+++ a/arch/mips/pmc-sierra/yosemite/setup.c
@@ -79,14 +79,14 @@ unsigned long read_persistent_clock(void
 	/* Stop the update to the time */
 	m48t37_base->control = 0x40;
 
-	year = BCD2BIN(m48t37_base->year);
-	year += BCD2BIN(m48t37_base->century) * 100;
+	year = bcd2bin(m48t37_base->year);
+	year += bcd2bin(m48t37_base->century) * 100;
 
-	month = BCD2BIN(m48t37_base->month);
-	day = BCD2BIN(m48t37_base->date);
-	hour = BCD2BIN(m48t37_base->hour);
-	min = BCD2BIN(m48t37_base->min);
-	sec = BCD2BIN(m48t37_base->sec);
+	month = bcd2bin(m48t37_base->month);
+	day = bcd2bin(m48t37_base->date);
+	hour = bcd2bin(m48t37_base->hour);
+	min = bcd2bin(m48t37_base->min);
+	sec = bcd2bin(m48t37_base->sec);
 
 	/* Start the update to the time again */
 	m48t37_base->control = 0x00;
@@ -113,22 +113,22 @@ int rtc_mips_set_time(unsigned long tim)
 	m48t37_base->control = 0x80;
 
 	/* year */
-	m48t37_base->year = BIN2BCD(tm.tm_year % 100);
-	m48t37_base->century = BIN2BCD(tm.tm_year / 100);
+	m48t37_base->year = bin2bcd(tm.tm_year % 100);
+	m48t37_base->century = bin2bcd(tm.tm_year / 100);
 
 	/* month */
-	m48t37_base->month = BIN2BCD(tm.tm_mon);
+	m48t37_base->month = bin2bcd(tm.tm_mon);
 
 	/* day */
-	m48t37_base->date = BIN2BCD(tm.tm_mday);
+	m48t37_base->date = bin2bcd(tm.tm_mday);
 
 	/* hour/min/sec */
-	m48t37_base->hour = BIN2BCD(tm.tm_hour);
-	m48t37_base->min = BIN2BCD(tm.tm_min);
-	m48t37_base->sec = BIN2BCD(tm.tm_sec);
+	m48t37_base->hour = bin2bcd(tm.tm_hour);
+	m48t37_base->min = bin2bcd(tm.tm_min);
+	m48t37_base->sec = bin2bcd(tm.tm_sec);
 
 	/* day of week -- not really used, but let's keep it up-to-date */
-	m48t37_base->day = BIN2BCD(tm.tm_wday + 1);
+	m48t37_base->day = bin2bcd(tm.tm_wday + 1);
 
 	/* disable writing */
 	m48t37_base->control = 0x00;
diff -puN arch/mips/sibyte/swarm/rtc_m41t81.c~mips-use-bcd2bin-bin2bcd arch/mips/sibyte/swarm/rtc_m41t81.c
--- a/arch/mips/sibyte/swarm/rtc_m41t81.c~mips-use-bcd2bin-bin2bcd
+++ a/arch/mips/sibyte/swarm/rtc_m41t81.c
@@ -156,32 +156,32 @@ int m41t81_set_time(unsigned long t)
 	 */
 
 	spin_lock_irqsave(&rtc_lock, flags);
-	tm.tm_sec = BIN2BCD(tm.tm_sec);
+	tm.tm_sec = bin2bcd(tm.tm_sec);
 	m41t81_write(M41T81REG_SC, tm.tm_sec);
 
-	tm.tm_min = BIN2BCD(tm.tm_min);
+	tm.tm_min = bin2bcd(tm.tm_min);
 	m41t81_write(M41T81REG_MN, tm.tm_min);
 
-	tm.tm_hour = BIN2BCD(tm.tm_hour);
+	tm.tm_hour = bin2bcd(tm.tm_hour);
 	tm.tm_hour = (tm.tm_hour & 0x3f) | (m41t81_read(M41T81REG_HR) & 0xc0);
 	m41t81_write(M41T81REG_HR, tm.tm_hour);
 
 	/* tm_wday starts from 0 to 6 */
 	if (tm.tm_wday == 0) tm.tm_wday = 7;
-	tm.tm_wday = BIN2BCD(tm.tm_wday);
+	tm.tm_wday = bin2bcd(tm.tm_wday);
 	m41t81_write(M41T81REG_DY, tm.tm_wday);
 
-	tm.tm_mday = BIN2BCD(tm.tm_mday);
+	tm.tm_mday = bin2bcd(tm.tm_mday);
 	m41t81_write(M41T81REG_DT, tm.tm_mday);
 
 	/* tm_mon starts from 0, *ick* */
 	tm.tm_mon ++;
-	tm.tm_mon = BIN2BCD(tm.tm_mon);
+	tm.tm_mon = bin2bcd(tm.tm_mon);
 	m41t81_write(M41T81REG_MO, tm.tm_mon);
 
 	/* we don't do century, everything is beyond 2000 */
 	tm.tm_year %= 100;
-	tm.tm_year = BIN2BCD(tm.tm_year);
+	tm.tm_year = bin2bcd(tm.tm_year);
 	m41t81_write(M41T81REG_YR, tm.tm_year);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 
@@ -209,12 +209,12 @@ unsigned long m41t81_get_time(void)
 	year = m41t81_read(M41T81REG_YR);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 
-	sec = BCD2BIN(sec);
-	min = BCD2BIN(min);
-	hour = BCD2BIN(hour);
-	day = BCD2BIN(day);
-	mon = BCD2BIN(mon);
-	year = BCD2BIN(year);
+	sec = bcd2bin(sec);
+	min = bcd2bin(min);
+	hour = bcd2bin(hour);
+	day = bcd2bin(day);
+	mon = bcd2bin(mon);
+	year = bcd2bin(year);
 
 	year += 2000;
 
diff -puN arch/mips/sibyte/swarm/rtc_xicor1241.c~mips-use-bcd2bin-bin2bcd arch/mips/sibyte/swarm/rtc_xicor1241.c
--- a/arch/mips/sibyte/swarm/rtc_xicor1241.c~mips-use-bcd2bin-bin2bcd
+++ a/arch/mips/sibyte/swarm/rtc_xicor1241.c
@@ -124,18 +124,18 @@ int xicor_set_time(unsigned long t)
 	xicor_write(X1241REG_SR, X1241REG_SR_WEL | X1241REG_SR_RWEL);
 
 	/* trivial ones */
-	tm.tm_sec = BIN2BCD(tm.tm_sec);
+	tm.tm_sec = bin2bcd(tm.tm_sec);
 	xicor_write(X1241REG_SC, tm.tm_sec);
 
-	tm.tm_min = BIN2BCD(tm.tm_min);
+	tm.tm_min = bin2bcd(tm.tm_min);
 	xicor_write(X1241REG_MN, tm.tm_min);
 
-	tm.tm_mday = BIN2BCD(tm.tm_mday);
+	tm.tm_mday = bin2bcd(tm.tm_mday);
 	xicor_write(X1241REG_DT, tm.tm_mday);
 
 	/* tm_mon starts from 0, *ick* */
 	tm.tm_mon ++;
-	tm.tm_mon = BIN2BCD(tm.tm_mon);
+	tm.tm_mon = bin2bcd(tm.tm_mon);
 	xicor_write(X1241REG_MO, tm.tm_mon);
 
 	/* year is split */
@@ -148,7 +148,7 @@ int xicor_set_time(unsigned long t)
 	tmp = xicor_read(X1241REG_HR);
 	if (tmp & X1241REG_HR_MIL) {
 		/* 24 hour format */
-		tm.tm_hour = BIN2BCD(tm.tm_hour);
+		tm.tm_hour = bin2bcd(tm.tm_hour);
 		tmp = (tmp & ~0x3f) | (tm.tm_hour & 0x3f);
 	} else {
 		/* 12 hour format, with 0x2 for pm */
@@ -157,7 +157,7 @@ int xicor_set_time(unsigned long t)
 			tmp |= 0x20;
 			tm.tm_hour -= 12;
 		}
-		tm.tm_hour = BIN2BCD(tm.tm_hour);
+		tm.tm_hour = bin2bcd(tm.tm_hour);
 		tmp |= tm.tm_hour;
 	}
 	xicor_write(X1241REG_HR, tmp);
@@ -191,13 +191,13 @@ unsigned long xicor_get_time(void)
 	y2k = xicor_read(X1241REG_Y2K);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 
-	sec = BCD2BIN(sec);
-	min = BCD2BIN(min);
-	hour = BCD2BIN(hour);
-	day = BCD2BIN(day);
-	mon = BCD2BIN(mon);
-	year = BCD2BIN(year);
-	y2k = BCD2BIN(y2k);
+	sec = bcd2bin(sec);
+	min = bcd2bin(min);
+	hour = bcd2bin(hour);
+	day = bcd2bin(day);
+	mon = bcd2bin(mon);
+	year = bcd2bin(year);
+	y2k = bcd2bin(y2k);
 
 	year += (y2k * 100);
 
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

