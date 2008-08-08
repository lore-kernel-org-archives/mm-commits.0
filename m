From: akpm@linux-foundation.org
Subject: + drivers-rtc-use-bcd2bin-bin2bcd.patch added to -mm tree
Date: Fri, 08 Aug 2008 14:39:51 -0700
Message-ID: <200808082139.m78LdqZG029804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758725AbYHHVkd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 17:40:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     drivers/rtc/: use bcd2bin/bin2bcd
has been added to the -mm tree.  Its filename is
     drivers-rtc-use-bcd2bin-bin2bcd.patch

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
Subject: drivers/rtc/: use bcd2bin/bin2bcd
From: Adrian Bunk <bunk@kernel.org>

Change drivers/rtc/ to use the new bcd2bin/bin2bcd functions instead of
the obsolete BCD_TO_BIN/BIN_TO_BCD/BCD2BIN/BIN2BCD macros.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91rm9200.c |   42 ++++++++++++------------
 drivers/rtc/rtc-cmos.c       |   20 +++++------
 drivers/rtc/rtc-ds1216.c     |   26 +++++++--------
 drivers/rtc/rtc-ds1302.c     |   28 ++++++++--------
 drivers/rtc/rtc-ds1305.c     |   38 +++++++++++-----------
 drivers/rtc/rtc-ds1307.c     |   40 +++++++++++------------
 drivers/rtc/rtc-ds1511.c     |   42 ++++++++++++------------
 drivers/rtc/rtc-ds1553.c     |   38 +++++++++++-----------
 drivers/rtc/rtc-ds1742.c     |   30 ++++++++---------
 drivers/rtc/rtc-fm3130.c     |   56 ++++++++++++++++-----------------
 drivers/rtc/rtc-isl1208.c    |   44 ++++++++++++-------------
 drivers/rtc/rtc-m41t80.c     |   44 ++++++++++++-------------
 drivers/rtc/rtc-m41t94.c     |   28 ++++++++--------
 drivers/rtc/rtc-m48t59.c     |   48 ++++++++++++++--------------
 drivers/rtc/rtc-m48t86.c     |   28 ++++++++--------
 drivers/rtc/rtc-max6900.c    |   32 +++++++++---------
 drivers/rtc/rtc-max6902.c    |   34 ++++++++++----------
 drivers/rtc/rtc-omap.c       |   24 +++++++-------
 drivers/rtc/rtc-pcf8563.c    |   24 +++++++-------
 drivers/rtc/rtc-pcf8583.c    |   20 +++++------
 drivers/rtc/rtc-r9701.c      |   26 +++++++--------
 drivers/rtc/rtc-rs5c313.c    |   28 ++++++++--------
 drivers/rtc/rtc-rs5c348.c    |   30 ++++++++---------
 drivers/rtc/rtc-rs5c372.c    |   42 ++++++++++++------------
 drivers/rtc/rtc-s35390a.c    |   34 ++++++++++----------
 drivers/rtc/rtc-s3c.c        |   42 ++++++++++++------------
 drivers/rtc/rtc-sh.c         |   40 +++++++++++------------
 drivers/rtc/rtc-stk17ta8.c   |   38 +++++++++++-----------
 drivers/rtc/rtc-v3020.c      |   28 ++++++++--------
 drivers/rtc/rtc-x1205.c      |   30 ++++++++---------
 30 files changed, 512 insertions(+), 512 deletions(-)

diff -puN drivers/rtc/rtc-at91rm9200.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -53,21 +53,21 @@ static void at91_rtc_decodetime(unsigned
 	} while ((time != at91_sys_read(timereg)) ||
 			(date != at91_sys_read(calreg)));
 
-	tm->tm_sec  = BCD2BIN((time & AT91_RTC_SEC) >> 0);
-	tm->tm_min  = BCD2BIN((time & AT91_RTC_MIN) >> 8);
-	tm->tm_hour = BCD2BIN((time & AT91_RTC_HOUR) >> 16);
+	tm->tm_sec  = bcd2bin((time & AT91_RTC_SEC) >> 0);
+	tm->tm_min  = bcd2bin((time & AT91_RTC_MIN) >> 8);
+	tm->tm_hour = bcd2bin((time & AT91_RTC_HOUR) >> 16);
 
 	/*
 	 * The Calendar Alarm register does not have a field for
 	 * the year - so these will return an invalid value.  When an
 	 * alarm is set, at91_alarm_year wille store the current year.
 	 */
-	tm->tm_year  = BCD2BIN(date & AT91_RTC_CENT) * 100;	/* century */
-	tm->tm_year += BCD2BIN((date & AT91_RTC_YEAR) >> 8);	/* year */
+	tm->tm_year  = bcd2bin(date & AT91_RTC_CENT) * 100;	/* century */
+	tm->tm_year += bcd2bin((date & AT91_RTC_YEAR) >> 8);	/* year */
 
-	tm->tm_wday = BCD2BIN((date & AT91_RTC_DAY) >> 21) - 1;	/* day of the week [0-6], Sunday=0 */
-	tm->tm_mon  = BCD2BIN((date & AT91_RTC_MONTH) >> 16) - 1;
-	tm->tm_mday = BCD2BIN((date & AT91_RTC_DATE) >> 24);
+	tm->tm_wday = bcd2bin((date & AT91_RTC_DAY) >> 21) - 1;	/* day of the week [0-6], Sunday=0 */
+	tm->tm_mon  = bcd2bin((date & AT91_RTC_MONTH) >> 16) - 1;
+	tm->tm_mday = bcd2bin((date & AT91_RTC_DATE) >> 24);
 }
 
 /*
@@ -106,16 +106,16 @@ static int at91_rtc_settime(struct devic
 	at91_sys_write(AT91_RTC_IDR, AT91_RTC_ACKUPD);
 
 	at91_sys_write(AT91_RTC_TIMR,
-			  BIN2BCD(tm->tm_sec) << 0
-			| BIN2BCD(tm->tm_min) << 8
-			| BIN2BCD(tm->tm_hour) << 16);
+			  bin2bcd(tm->tm_sec) << 0
+			| bin2bcd(tm->tm_min) << 8
+			| bin2bcd(tm->tm_hour) << 16);
 
 	at91_sys_write(AT91_RTC_CALR,
-			  BIN2BCD((tm->tm_year + 1900) / 100)	/* century */
-			| BIN2BCD(tm->tm_year % 100) << 8	/* year */
-			| BIN2BCD(tm->tm_mon + 1) << 16		/* tm_mon starts at zero */
-			| BIN2BCD(tm->tm_wday + 1) << 21	/* day of the week [0-6], Sunday=0 */
-			| BIN2BCD(tm->tm_mday) << 24);
+			  bin2bcd((tm->tm_year + 1900) / 100)	/* century */
+			| bin2bcd(tm->tm_year % 100) << 8	/* year */
+			| bin2bcd(tm->tm_mon + 1) << 16		/* tm_mon starts at zero */
+			| bin2bcd(tm->tm_wday + 1) << 21	/* day of the week [0-6], Sunday=0 */
+			| bin2bcd(tm->tm_mday) << 24);
 
 	/* Restart Time/Calendar */
 	cr = at91_sys_read(AT91_RTC_CR);
@@ -162,13 +162,13 @@ static int at91_rtc_setalarm(struct devi
 
 	at91_sys_write(AT91_RTC_IDR, AT91_RTC_ALARM);
 	at91_sys_write(AT91_RTC_TIMALR,
-		  BIN2BCD(tm.tm_sec) << 0
-		| BIN2BCD(tm.tm_min) << 8
-		| BIN2BCD(tm.tm_hour) << 16
+		  bin2bcd(tm.tm_sec) << 0
+		| bin2bcd(tm.tm_min) << 8
+		| bin2bcd(tm.tm_hour) << 16
 		| AT91_RTC_HOUREN | AT91_RTC_MINEN | AT91_RTC_SECEN);
 	at91_sys_write(AT91_RTC_CALALR,
-		  BIN2BCD(tm.tm_mon + 1) << 16		/* tm_mon starts at zero */
-		| BIN2BCD(tm.tm_mday) << 24
+		  bin2bcd(tm.tm_mon + 1) << 16		/* tm_mon starts at zero */
+		| bin2bcd(tm.tm_mday) << 24
 		| AT91_RTC_DATEEN | AT91_RTC_MTHEN);
 
 	if (alrm->enabled) {
diff -puN drivers/rtc/rtc-cmos.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-cmos.c
@@ -203,26 +203,26 @@ static int cmos_read_alarm(struct device
 	/* REVISIT this assumes PC style usage:  always BCD */
 
 	if (((unsigned)t->time.tm_sec) < 0x60)
-		t->time.tm_sec = BCD2BIN(t->time.tm_sec);
+		t->time.tm_sec = bcd2bin(t->time.tm_sec);
 	else
 		t->time.tm_sec = -1;
 	if (((unsigned)t->time.tm_min) < 0x60)
-		t->time.tm_min = BCD2BIN(t->time.tm_min);
+		t->time.tm_min = bcd2bin(t->time.tm_min);
 	else
 		t->time.tm_min = -1;
 	if (((unsigned)t->time.tm_hour) < 0x24)
-		t->time.tm_hour = BCD2BIN(t->time.tm_hour);
+		t->time.tm_hour = bcd2bin(t->time.tm_hour);
 	else
 		t->time.tm_hour = -1;
 
 	if (cmos->day_alrm) {
 		if (((unsigned)t->time.tm_mday) <= 0x31)
-			t->time.tm_mday = BCD2BIN(t->time.tm_mday);
+			t->time.tm_mday = bcd2bin(t->time.tm_mday);
 		else
 			t->time.tm_mday = -1;
 		if (cmos->mon_alrm) {
 			if (((unsigned)t->time.tm_mon) <= 0x12)
-				t->time.tm_mon = BCD2BIN(t->time.tm_mon) - 1;
+				t->time.tm_mon = bcd2bin(t->time.tm_mon) - 1;
 			else
 				t->time.tm_mon = -1;
 		}
@@ -294,19 +294,19 @@ static int cmos_set_alarm(struct device 
 	/* Writing 0xff means "don't care" or "match all".  */
 
 	mon = t->time.tm_mon + 1;
-	mon = (mon <= 12) ? BIN2BCD(mon) : 0xff;
+	mon = (mon <= 12) ? bin2bcd(mon) : 0xff;
 
 	mday = t->time.tm_mday;
-	mday = (mday >= 1 && mday <= 31) ? BIN2BCD(mday) : 0xff;
+	mday = (mday >= 1 && mday <= 31) ? bin2bcd(mday) : 0xff;
 
 	hrs = t->time.tm_hour;
-	hrs = (hrs < 24) ? BIN2BCD(hrs) : 0xff;
+	hrs = (hrs < 24) ? bin2bcd(hrs) : 0xff;
 
 	min = t->time.tm_min;
-	min = (min < 60) ? BIN2BCD(min) : 0xff;
+	min = (min < 60) ? bin2bcd(min) : 0xff;
 
 	sec = t->time.tm_sec;
-	sec = (sec < 60) ? BIN2BCD(sec) : 0xff;
+	sec = (sec < 60) ? bin2bcd(sec) : 0xff;
 
 	spin_lock_irq(&rtc_lock);
 
diff -puN drivers/rtc/rtc-ds1216.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-ds1216.c
--- a/drivers/rtc/rtc-ds1216.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-ds1216.c
@@ -86,19 +86,19 @@ static int ds1216_rtc_read_time(struct d
 	ds1216_switch_ds_to_clock(priv->ioaddr);
 	ds1216_read(priv->ioaddr, (u8 *)&regs);
 
-	tm->tm_sec = BCD2BIN(regs.sec);
-	tm->tm_min = BCD2BIN(regs.min);
+	tm->tm_sec = bcd2bin(regs.sec);
+	tm->tm_min = bcd2bin(regs.min);
 	if (regs.hour & DS1216_HOUR_1224) {
 		/* AM/PM mode */
-		tm->tm_hour = BCD2BIN(regs.hour & 0x1f);
+		tm->tm_hour = bcd2bin(regs.hour & 0x1f);
 		if (regs.hour & DS1216_HOUR_AMPM)
 			tm->tm_hour += 12;
 	} else
-		tm->tm_hour = BCD2BIN(regs.hour & 0x3f);
+		tm->tm_hour = bcd2bin(regs.hour & 0x3f);
 	tm->tm_wday = (regs.wday & 7) - 1;
-	tm->tm_mday = BCD2BIN(regs.mday & 0x3f);
-	tm->tm_mon = BCD2BIN(regs.month & 0x1f);
-	tm->tm_year = BCD2BIN(regs.year);
+	tm->tm_mday = bcd2bin(regs.mday & 0x3f);
+	tm->tm_mon = bcd2bin(regs.month & 0x1f);
+	tm->tm_year = bcd2bin(regs.year);
 	if (tm->tm_year < 70)
 		tm->tm_year += 100;
 	return 0;
@@ -114,19 +114,19 @@ static int ds1216_rtc_set_time(struct de
 	ds1216_read(priv->ioaddr, (u8 *)&regs);
 
 	regs.tsec = 0; /* clear 0.1 and 0.01 seconds */
-	regs.sec = BIN2BCD(tm->tm_sec);
-	regs.min = BIN2BCD(tm->tm_min);
+	regs.sec = bin2bcd(tm->tm_sec);
+	regs.min = bin2bcd(tm->tm_min);
 	regs.hour &= DS1216_HOUR_1224;
 	if (regs.hour && tm->tm_hour > 12) {
 		regs.hour |= DS1216_HOUR_AMPM;
 		tm->tm_hour -= 12;
 	}
-	regs.hour |= BIN2BCD(tm->tm_hour);
+	regs.hour |= bin2bcd(tm->tm_hour);
 	regs.wday &= ~7;
 	regs.wday |= tm->tm_wday;
-	regs.mday = BIN2BCD(tm->tm_mday);
-	regs.month = BIN2BCD(tm->tm_mon);
-	regs.year = BIN2BCD(tm->tm_year % 100);
+	regs.mday = bin2bcd(tm->tm_mday);
+	regs.month = bin2bcd(tm->tm_mon);
+	regs.year = bin2bcd(tm->tm_year % 100);
 
 	ds1216_switch_ds_to_clock(priv->ioaddr);
 	ds1216_write(priv->ioaddr, (u8 *)&regs);
diff -puN drivers/rtc/rtc-ds1302.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-ds1302.c
--- a/drivers/rtc/rtc-ds1302.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-ds1302.c
@@ -107,13 +107,13 @@ static int ds1302_rtc_read_time(struct d
 
 	spin_lock_irq(&rtc->lock);
 
-	tm->tm_sec	= BCD2BIN(ds1302_readbyte(RTC_ADDR_SEC));
-	tm->tm_min	= BCD2BIN(ds1302_readbyte(RTC_ADDR_MIN));
-	tm->tm_hour	= BCD2BIN(ds1302_readbyte(RTC_ADDR_HOUR));
-	tm->tm_wday	= BCD2BIN(ds1302_readbyte(RTC_ADDR_DAY));
-	tm->tm_mday	= BCD2BIN(ds1302_readbyte(RTC_ADDR_DATE));
-	tm->tm_mon	= BCD2BIN(ds1302_readbyte(RTC_ADDR_MON)) - 1;
-	tm->tm_year	= BCD2BIN(ds1302_readbyte(RTC_ADDR_YEAR));
+	tm->tm_sec	= bcd2bin(ds1302_readbyte(RTC_ADDR_SEC));
+	tm->tm_min	= bcd2bin(ds1302_readbyte(RTC_ADDR_MIN));
+	tm->tm_hour	= bcd2bin(ds1302_readbyte(RTC_ADDR_HOUR));
+	tm->tm_wday	= bcd2bin(ds1302_readbyte(RTC_ADDR_DAY));
+	tm->tm_mday	= bcd2bin(ds1302_readbyte(RTC_ADDR_DATE));
+	tm->tm_mon	= bcd2bin(ds1302_readbyte(RTC_ADDR_MON)) - 1;
+	tm->tm_year	= bcd2bin(ds1302_readbyte(RTC_ADDR_YEAR));
 
 	if (tm->tm_year < 70)
 		tm->tm_year += 100;
@@ -141,13 +141,13 @@ static int ds1302_rtc_set_time(struct de
 	/* Stop RTC */
 	ds1302_writebyte(RTC_ADDR_SEC, ds1302_readbyte(RTC_ADDR_SEC) | 0x80);
 
-	ds1302_writebyte(RTC_ADDR_SEC, BIN2BCD(tm->tm_sec));
-	ds1302_writebyte(RTC_ADDR_MIN, BIN2BCD(tm->tm_min));
-	ds1302_writebyte(RTC_ADDR_HOUR, BIN2BCD(tm->tm_hour));
-	ds1302_writebyte(RTC_ADDR_DAY, BIN2BCD(tm->tm_wday));
-	ds1302_writebyte(RTC_ADDR_DATE, BIN2BCD(tm->tm_mday));
-	ds1302_writebyte(RTC_ADDR_MON, BIN2BCD(tm->tm_mon + 1));
-	ds1302_writebyte(RTC_ADDR_YEAR, BIN2BCD(tm->tm_year % 100));
+	ds1302_writebyte(RTC_ADDR_SEC, bin2bcd(tm->tm_sec));
+	ds1302_writebyte(RTC_ADDR_MIN, bin2bcd(tm->tm_min));
+	ds1302_writebyte(RTC_ADDR_HOUR, bin2bcd(tm->tm_hour));
+	ds1302_writebyte(RTC_ADDR_DAY, bin2bcd(tm->tm_wday));
+	ds1302_writebyte(RTC_ADDR_DATE, bin2bcd(tm->tm_mday));
+	ds1302_writebyte(RTC_ADDR_MON, bin2bcd(tm->tm_mon + 1));
+	ds1302_writebyte(RTC_ADDR_YEAR, bin2bcd(tm->tm_year % 100));
 
 	/* Start RTC */
 	ds1302_writebyte(RTC_ADDR_SEC, ds1302_readbyte(RTC_ADDR_SEC) & ~0x80);
diff -puN drivers/rtc/rtc-ds1305.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-ds1305.c
--- a/drivers/rtc/rtc-ds1305.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-ds1305.c
@@ -114,10 +114,10 @@ static unsigned bcd2hour(u8 bcd)
 			hour = 12;
 			bcd &= ~DS1305_HR_PM;
 		}
-		hour += BCD2BIN(bcd);
+		hour += bcd2bin(bcd);
 		return hour - 1;
 	}
-	return BCD2BIN(bcd);
+	return bcd2bin(bcd);
 }
 
 static u8 hour2bcd(bool hr12, int hour)
@@ -125,11 +125,11 @@ static u8 hour2bcd(bool hr12, int hour)
 	if (hr12) {
 		hour++;
 		if (hour <= 12)
-			return DS1305_HR_12 | BIN2BCD(hour);
+			return DS1305_HR_12 | bin2bcd(hour);
 		hour -= 12;
-		return DS1305_HR_12 | DS1305_HR_PM | BIN2BCD(hour);
+		return DS1305_HR_12 | DS1305_HR_PM | bin2bcd(hour);
 	}
-	return BIN2BCD(hour);
+	return bin2bcd(hour);
 }
 
 /*----------------------------------------------------------------------*/
@@ -206,13 +206,13 @@ static int ds1305_get_time(struct device
 		buf[4], buf[5], buf[6]);
 
 	/* Decode the registers */
-	time->tm_sec = BCD2BIN(buf[DS1305_SEC]);
-	time->tm_min = BCD2BIN(buf[DS1305_MIN]);
+	time->tm_sec = bcd2bin(buf[DS1305_SEC]);
+	time->tm_min = bcd2bin(buf[DS1305_MIN]);
 	time->tm_hour = bcd2hour(buf[DS1305_HOUR]);
 	time->tm_wday = buf[DS1305_WDAY] - 1;
-	time->tm_mday = BCD2BIN(buf[DS1305_MDAY]);
-	time->tm_mon = BCD2BIN(buf[DS1305_MON]) - 1;
-	time->tm_year = BCD2BIN(buf[DS1305_YEAR]) + 100;
+	time->tm_mday = bcd2bin(buf[DS1305_MDAY]);
+	time->tm_mon = bcd2bin(buf[DS1305_MON]) - 1;
+	time->tm_year = bcd2bin(buf[DS1305_YEAR]) + 100;
 
 	dev_vdbg(dev, "%s secs=%d, mins=%d, "
 		"hours=%d, mday=%d, mon=%d, year=%d, wday=%d\n",
@@ -239,13 +239,13 @@ static int ds1305_set_time(struct device
 	/* Write registers starting at the first time/date address. */
 	*bp++ = DS1305_WRITE | DS1305_SEC;
 
-	*bp++ = BIN2BCD(time->tm_sec);
-	*bp++ = BIN2BCD(time->tm_min);
+	*bp++ = bin2bcd(time->tm_sec);
+	*bp++ = bin2bcd(time->tm_min);
 	*bp++ = hour2bcd(ds1305->hr12, time->tm_hour);
 	*bp++ = (time->tm_wday < 7) ? (time->tm_wday + 1) : 1;
-	*bp++ = BIN2BCD(time->tm_mday);
-	*bp++ = BIN2BCD(time->tm_mon + 1);
-	*bp++ = BIN2BCD(time->tm_year - 100);
+	*bp++ = bin2bcd(time->tm_mday);
+	*bp++ = bin2bcd(time->tm_mon + 1);
+	*bp++ = bin2bcd(time->tm_year - 100);
 
 	dev_dbg(dev, "%s: %02x %02x %02x, %02x %02x %02x %02x\n",
 		"write", buf[1], buf[2], buf[3],
@@ -329,8 +329,8 @@ static int ds1305_get_alarm(struct devic
 	 * fill in the rest ... and also handle rollover to tomorrow when
 	 * that's needed.
 	 */
-	alm->time.tm_sec = BCD2BIN(buf[DS1305_SEC]);
-	alm->time.tm_min = BCD2BIN(buf[DS1305_MIN]);
+	alm->time.tm_sec = bcd2bin(buf[DS1305_SEC]);
+	alm->time.tm_min = bcd2bin(buf[DS1305_MIN]);
 	alm->time.tm_hour = bcd2hour(buf[DS1305_HOUR]);
 	alm->time.tm_mday = -1;
 	alm->time.tm_mon = -1;
@@ -387,8 +387,8 @@ static int ds1305_set_alarm(struct devic
 
 	/* write alarm */
 	buf[0] = DS1305_WRITE | DS1305_ALM0(DS1305_SEC);
-	buf[1 + DS1305_SEC] = BIN2BCD(alm->time.tm_sec);
-	buf[1 + DS1305_MIN] = BIN2BCD(alm->time.tm_min);
+	buf[1 + DS1305_SEC] = bin2bcd(alm->time.tm_sec);
+	buf[1 + DS1305_MIN] = bin2bcd(alm->time.tm_min);
 	buf[1 + DS1305_HOUR] = hour2bcd(ds1305->hr12, alm->time.tm_hour);
 	buf[1 + DS1305_WDAY] = DS1305_ALM_DISABLE;
 
diff -puN drivers/rtc/rtc-ds1307.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-ds1307.c
@@ -222,17 +222,17 @@ static int ds1307_get_time(struct device
 			ds1307->regs[4], ds1307->regs[5],
 			ds1307->regs[6]);
 
-	t->tm_sec = BCD2BIN(ds1307->regs[DS1307_REG_SECS] & 0x7f);
-	t->tm_min = BCD2BIN(ds1307->regs[DS1307_REG_MIN] & 0x7f);
+	t->tm_sec = bcd2bin(ds1307->regs[DS1307_REG_SECS] & 0x7f);
+	t->tm_min = bcd2bin(ds1307->regs[DS1307_REG_MIN] & 0x7f);
 	tmp = ds1307->regs[DS1307_REG_HOUR] & 0x3f;
-	t->tm_hour = BCD2BIN(tmp);
-	t->tm_wday = BCD2BIN(ds1307->regs[DS1307_REG_WDAY] & 0x07) - 1;
-	t->tm_mday = BCD2BIN(ds1307->regs[DS1307_REG_MDAY] & 0x3f);
+	t->tm_hour = bcd2bin(tmp);
+	t->tm_wday = bcd2bin(ds1307->regs[DS1307_REG_WDAY] & 0x07) - 1;
+	t->tm_mday = bcd2bin(ds1307->regs[DS1307_REG_MDAY] & 0x3f);
 	tmp = ds1307->regs[DS1307_REG_MONTH] & 0x1f;
-	t->tm_mon = BCD2BIN(tmp) - 1;
+	t->tm_mon = bcd2bin(tmp) - 1;
 
 	/* assume 20YY not 19YY, and ignore DS1337_BIT_CENTURY */
-	t->tm_year = BCD2BIN(ds1307->regs[DS1307_REG_YEAR]) + 100;
+	t->tm_year = bcd2bin(ds1307->regs[DS1307_REG_YEAR]) + 100;
 
 	dev_dbg(dev, "%s secs=%d, mins=%d, "
 		"hours=%d, mday=%d, mon=%d, year=%d, wday=%d\n",
@@ -258,16 +258,16 @@ static int ds1307_set_time(struct device
 		t->tm_mon, t->tm_year, t->tm_wday);
 
 	*buf++ = 0;		/* first register addr */
-	buf[DS1307_REG_SECS] = BIN2BCD(t->tm_sec);
-	buf[DS1307_REG_MIN] = BIN2BCD(t->tm_min);
-	buf[DS1307_REG_HOUR] = BIN2BCD(t->tm_hour);
-	buf[DS1307_REG_WDAY] = BIN2BCD(t->tm_wday + 1);
-	buf[DS1307_REG_MDAY] = BIN2BCD(t->tm_mday);
-	buf[DS1307_REG_MONTH] = BIN2BCD(t->tm_mon + 1);
+	buf[DS1307_REG_SECS] = bin2bcd(t->tm_sec);
+	buf[DS1307_REG_MIN] = bin2bcd(t->tm_min);
+	buf[DS1307_REG_HOUR] = bin2bcd(t->tm_hour);
+	buf[DS1307_REG_WDAY] = bin2bcd(t->tm_wday + 1);
+	buf[DS1307_REG_MDAY] = bin2bcd(t->tm_mday);
+	buf[DS1307_REG_MONTH] = bin2bcd(t->tm_mon + 1);
 
 	/* assume 20YY not 19YY */
 	tmp = t->tm_year - 100;
-	buf[DS1307_REG_YEAR] = BIN2BCD(tmp);
+	buf[DS1307_REG_YEAR] = bin2bcd(tmp);
 
 	switch (ds1307->type) {
 	case ds_1337:
@@ -709,18 +709,18 @@ read_rtc:
 	}
 
 	tmp = ds1307->regs[DS1307_REG_SECS];
-	tmp = BCD2BIN(tmp & 0x7f);
+	tmp = bcd2bin(tmp & 0x7f);
 	if (tmp > 60)
 		goto exit_bad;
-	tmp = BCD2BIN(ds1307->regs[DS1307_REG_MIN] & 0x7f);
+	tmp = bcd2bin(ds1307->regs[DS1307_REG_MIN] & 0x7f);
 	if (tmp > 60)
 		goto exit_bad;
 
-	tmp = BCD2BIN(ds1307->regs[DS1307_REG_MDAY] & 0x3f);
+	tmp = bcd2bin(ds1307->regs[DS1307_REG_MDAY] & 0x3f);
 	if (tmp == 0 || tmp > 31)
 		goto exit_bad;
 
-	tmp = BCD2BIN(ds1307->regs[DS1307_REG_MONTH] & 0x1f);
+	tmp = bcd2bin(ds1307->regs[DS1307_REG_MONTH] & 0x1f);
 	if (tmp == 0 || tmp > 12)
 		goto exit_bad;
 
@@ -739,14 +739,14 @@ read_rtc:
 		/* Be sure we're in 24 hour mode.  Multi-master systems
 		 * take note...
 		 */
-		tmp = BCD2BIN(tmp & 0x1f);
+		tmp = bcd2bin(tmp & 0x1f);
 		if (tmp == 12)
 			tmp = 0;
 		if (ds1307->regs[DS1307_REG_HOUR] & DS1307_BIT_PM)
 			tmp += 12;
 		i2c_smbus_write_byte_data(client,
 				DS1307_REG_HOUR,
-				BIN2BCD(tmp));
+				bin2bcd(tmp));
 	}
 
 	ds1307->rtc = rtc_device_register(client->name, &client->dev,
diff -puN drivers/rtc/rtc-ds1511.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-ds1511.c
--- a/drivers/rtc/rtc-ds1511.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-ds1511.c
@@ -153,8 +153,8 @@ ds1511_wdog_set(unsigned long decisecond
 	/*
 	 * set the wdog values in the wdog registers
 	 */
-	rtc_write(BIN2BCD(deciseconds % 100), DS1511_WD_MSEC);
-	rtc_write(BIN2BCD(deciseconds / 100), DS1511_WD_SEC);
+	rtc_write(bin2bcd(deciseconds % 100), DS1511_WD_MSEC);
+	rtc_write(bin2bcd(deciseconds / 100), DS1511_WD_SEC);
 	/*
 	 * set wdog enable and wdog 'steering' bit to issue a reset
 	 */
@@ -220,13 +220,13 @@ static int ds1511_rtc_set_time(struct de
 	/*
 	 * each register is a different number of valid bits
 	 */
-	sec = BIN2BCD(sec) & 0x7f;
-	min = BIN2BCD(min) & 0x7f;
-	hrs = BIN2BCD(hrs) & 0x3f;
-	day = BIN2BCD(day) & 0x3f;
-	mon = BIN2BCD(mon) & 0x1f;
-	yrs = BIN2BCD(yrs) & 0xff;
-	cen = BIN2BCD(cen) & 0xff;
+	sec = bin2bcd(sec) & 0x7f;
+	min = bin2bcd(min) & 0x7f;
+	hrs = bin2bcd(hrs) & 0x3f;
+	day = bin2bcd(day) & 0x3f;
+	mon = bin2bcd(mon) & 0x1f;
+	yrs = bin2bcd(yrs) & 0xff;
+	cen = bin2bcd(cen) & 0xff;
 
 	spin_lock_irqsave(&ds1511_lock, flags);
 	rtc_disable_update();
@@ -264,14 +264,14 @@ static int ds1511_rtc_read_time(struct d
 	rtc_enable_update();
 	spin_unlock_irqrestore(&ds1511_lock, flags);
 
-	rtc_tm->tm_sec = BCD2BIN(rtc_tm->tm_sec);
-	rtc_tm->tm_min = BCD2BIN(rtc_tm->tm_min);
-	rtc_tm->tm_hour = BCD2BIN(rtc_tm->tm_hour);
-	rtc_tm->tm_mday = BCD2BIN(rtc_tm->tm_mday);
-	rtc_tm->tm_wday = BCD2BIN(rtc_tm->tm_wday);
-	rtc_tm->tm_mon = BCD2BIN(rtc_tm->tm_mon);
-	rtc_tm->tm_year = BCD2BIN(rtc_tm->tm_year);
-	century = BCD2BIN(century) * 100;
+	rtc_tm->tm_sec = bcd2bin(rtc_tm->tm_sec);
+	rtc_tm->tm_min = bcd2bin(rtc_tm->tm_min);
+	rtc_tm->tm_hour = bcd2bin(rtc_tm->tm_hour);
+	rtc_tm->tm_mday = bcd2bin(rtc_tm->tm_mday);
+	rtc_tm->tm_wday = bcd2bin(rtc_tm->tm_wday);
+	rtc_tm->tm_mon = bcd2bin(rtc_tm->tm_mon);
+	rtc_tm->tm_year = bcd2bin(rtc_tm->tm_year);
+	century = bcd2bin(century) * 100;
 
 	/*
 	 * Account for differences between how the RTC uses the values
@@ -304,16 +304,16 @@ ds1511_rtc_update_alarm(struct rtc_plat_
 
 	spin_lock_irqsave(&pdata->rtc->irq_lock, flags);
 	rtc_write(pdata->alrm_mday < 0 || (pdata->irqen & RTC_UF) ?
-	       0x80 : BIN2BCD(pdata->alrm_mday) & 0x3f,
+	       0x80 : bin2bcd(pdata->alrm_mday) & 0x3f,
 	       RTC_ALARM_DATE);
 	rtc_write(pdata->alrm_hour < 0 || (pdata->irqen & RTC_UF) ?
-	       0x80 : BIN2BCD(pdata->alrm_hour) & 0x3f,
+	       0x80 : bin2bcd(pdata->alrm_hour) & 0x3f,
 	       RTC_ALARM_HOUR);
 	rtc_write(pdata->alrm_min < 0 || (pdata->irqen & RTC_UF) ?
-	       0x80 : BIN2BCD(pdata->alrm_min) & 0x7f,
+	       0x80 : bin2bcd(pdata->alrm_min) & 0x7f,
 	       RTC_ALARM_MIN);
 	rtc_write(pdata->alrm_sec < 0 || (pdata->irqen & RTC_UF) ?
-	       0x80 : BIN2BCD(pdata->alrm_sec) & 0x7f,
+	       0x80 : bin2bcd(pdata->alrm_sec) & 0x7f,
 	       RTC_ALARM_SEC);
 	rtc_write(rtc_read(RTC_CMD) | (pdata->irqen ? RTC_TIE : 0), RTC_CMD);
 	rtc_read(RTC_CMD1);	/* clear interrupts */
diff -puN drivers/rtc/rtc-ds1553.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-ds1553.c
--- a/drivers/rtc/rtc-ds1553.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-ds1553.c
@@ -78,17 +78,17 @@ static int ds1553_rtc_set_time(struct de
 	void __iomem *ioaddr = pdata->ioaddr;
 	u8 century;
 
-	century = BIN2BCD((tm->tm_year + 1900) / 100);
+	century = bin2bcd((tm->tm_year + 1900) / 100);
 
 	writeb(RTC_WRITE, pdata->ioaddr + RTC_CONTROL);
 
-	writeb(BIN2BCD(tm->tm_year % 100), ioaddr + RTC_YEAR);
-	writeb(BIN2BCD(tm->tm_mon + 1), ioaddr + RTC_MONTH);
-	writeb(BIN2BCD(tm->tm_wday) & RTC_DAY_MASK, ioaddr + RTC_DAY);
-	writeb(BIN2BCD(tm->tm_mday), ioaddr + RTC_DATE);
-	writeb(BIN2BCD(tm->tm_hour), ioaddr + RTC_HOURS);
-	writeb(BIN2BCD(tm->tm_min), ioaddr + RTC_MINUTES);
-	writeb(BIN2BCD(tm->tm_sec) & RTC_SECONDS_MASK, ioaddr + RTC_SECONDS);
+	writeb(bin2bcd(tm->tm_year % 100), ioaddr + RTC_YEAR);
+	writeb(bin2bcd(tm->tm_mon + 1), ioaddr + RTC_MONTH);
+	writeb(bin2bcd(tm->tm_wday) & RTC_DAY_MASK, ioaddr + RTC_DAY);
+	writeb(bin2bcd(tm->tm_mday), ioaddr + RTC_DATE);
+	writeb(bin2bcd(tm->tm_hour), ioaddr + RTC_HOURS);
+	writeb(bin2bcd(tm->tm_min), ioaddr + RTC_MINUTES);
+	writeb(bin2bcd(tm->tm_sec) & RTC_SECONDS_MASK, ioaddr + RTC_SECONDS);
 
 	/* RTC_CENTURY and RTC_CONTROL share same register */
 	writeb(RTC_WRITE | (century & RTC_CENTURY_MASK), ioaddr + RTC_CENTURY);
@@ -118,14 +118,14 @@ static int ds1553_rtc_read_time(struct d
 	year = readb(ioaddr + RTC_YEAR);
 	century = readb(ioaddr + RTC_CENTURY) & RTC_CENTURY_MASK;
 	writeb(0, ioaddr + RTC_CONTROL);
-	tm->tm_sec = BCD2BIN(second);
-	tm->tm_min = BCD2BIN(minute);
-	tm->tm_hour = BCD2BIN(hour);
-	tm->tm_mday = BCD2BIN(day);
-	tm->tm_wday = BCD2BIN(week);
-	tm->tm_mon = BCD2BIN(month) - 1;
+	tm->tm_sec = bcd2bin(second);
+	tm->tm_min = bcd2bin(minute);
+	tm->tm_hour = bcd2bin(hour);
+	tm->tm_mday = bcd2bin(day);
+	tm->tm_wday = bcd2bin(week);
+	tm->tm_mon = bcd2bin(month) - 1;
 	/* year is 1900 + tm->tm_year */
-	tm->tm_year = BCD2BIN(year) + BCD2BIN(century) * 100 - 1900;
+	tm->tm_year = bcd2bin(year) + bcd2bin(century) * 100 - 1900;
 
 	if (rtc_valid_tm(tm) < 0) {
 		dev_err(dev, "retrieved date/time is not valid.\n");
@@ -141,16 +141,16 @@ static void ds1553_rtc_update_alarm(stru
 
 	spin_lock_irqsave(&pdata->rtc->irq_lock, flags);
 	writeb(pdata->alrm_mday < 0 || (pdata->irqen & RTC_UF) ?
-	       0x80 : BIN2BCD(pdata->alrm_mday),
+	       0x80 : bin2bcd(pdata->alrm_mday),
 	       ioaddr + RTC_DATE_ALARM);
 	writeb(pdata->alrm_hour < 0 || (pdata->irqen & RTC_UF) ?
-	       0x80 : BIN2BCD(pdata->alrm_hour),
+	       0x80 : bin2bcd(pdata->alrm_hour),
 	       ioaddr + RTC_HOURS_ALARM);
 	writeb(pdata->alrm_min < 0 || (pdata->irqen & RTC_UF) ?
-	       0x80 : BIN2BCD(pdata->alrm_min),
+	       0x80 : bin2bcd(pdata->alrm_min),
 	       ioaddr + RTC_MINUTES_ALARM);
 	writeb(pdata->alrm_sec < 0 || (pdata->irqen & RTC_UF) ?
-	       0x80 : BIN2BCD(pdata->alrm_sec),
+	       0x80 : bin2bcd(pdata->alrm_sec),
 	       ioaddr + RTC_SECONDS_ALARM);
 	writeb(pdata->irqen ? RTC_INTS_AE : 0, ioaddr + RTC_INTERRUPTS);
 	readb(ioaddr + RTC_FLAGS);	/* clear interrupts */
diff -puN drivers/rtc/rtc-ds1742.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-ds1742.c
--- a/drivers/rtc/rtc-ds1742.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-ds1742.c
@@ -66,17 +66,17 @@ static int ds1742_rtc_set_time(struct de
 	void __iomem *ioaddr = pdata->ioaddr_rtc;
 	u8 century;
 
-	century = BIN2BCD((tm->tm_year + 1900) / 100);
+	century = bin2bcd((tm->tm_year + 1900) / 100);
 
 	writeb(RTC_WRITE, ioaddr + RTC_CONTROL);
 
-	writeb(BIN2BCD(tm->tm_year % 100), ioaddr + RTC_YEAR);
-	writeb(BIN2BCD(tm->tm_mon + 1), ioaddr + RTC_MONTH);
-	writeb(BIN2BCD(tm->tm_wday) & RTC_DAY_MASK, ioaddr + RTC_DAY);
-	writeb(BIN2BCD(tm->tm_mday), ioaddr + RTC_DATE);
-	writeb(BIN2BCD(tm->tm_hour), ioaddr + RTC_HOURS);
-	writeb(BIN2BCD(tm->tm_min), ioaddr + RTC_MINUTES);
-	writeb(BIN2BCD(tm->tm_sec) & RTC_SECONDS_MASK, ioaddr + RTC_SECONDS);
+	writeb(bin2bcd(tm->tm_year % 100), ioaddr + RTC_YEAR);
+	writeb(bin2bcd(tm->tm_mon + 1), ioaddr + RTC_MONTH);
+	writeb(bin2bcd(tm->tm_wday) & RTC_DAY_MASK, ioaddr + RTC_DAY);
+	writeb(bin2bcd(tm->tm_mday), ioaddr + RTC_DATE);
+	writeb(bin2bcd(tm->tm_hour), ioaddr + RTC_HOURS);
+	writeb(bin2bcd(tm->tm_min), ioaddr + RTC_MINUTES);
+	writeb(bin2bcd(tm->tm_sec) & RTC_SECONDS_MASK, ioaddr + RTC_SECONDS);
 
 	/* RTC_CENTURY and RTC_CONTROL share same register */
 	writeb(RTC_WRITE | (century & RTC_CENTURY_MASK), ioaddr + RTC_CENTURY);
@@ -106,14 +106,14 @@ static int ds1742_rtc_read_time(struct d
 	year = readb(ioaddr + RTC_YEAR);
 	century = readb(ioaddr + RTC_CENTURY) & RTC_CENTURY_MASK;
 	writeb(0, ioaddr + RTC_CONTROL);
-	tm->tm_sec = BCD2BIN(second);
-	tm->tm_min = BCD2BIN(minute);
-	tm->tm_hour = BCD2BIN(hour);
-	tm->tm_mday = BCD2BIN(day);
-	tm->tm_wday = BCD2BIN(week);
-	tm->tm_mon = BCD2BIN(month) - 1;
+	tm->tm_sec = bcd2bin(second);
+	tm->tm_min = bcd2bin(minute);
+	tm->tm_hour = bcd2bin(hour);
+	tm->tm_mday = bcd2bin(day);
+	tm->tm_wday = bcd2bin(week);
+	tm->tm_mon = bcd2bin(month) - 1;
 	/* year is 1900 + tm->tm_year */
-	tm->tm_year = BCD2BIN(year) + BCD2BIN(century) * 100 - 1900;
+	tm->tm_year = bcd2bin(year) + bcd2bin(century) * 100 - 1900;
 
 	if (rtc_valid_tm(tm) < 0) {
 		dev_err(dev, "retrieved date/time is not valid.\n");
diff -puN drivers/rtc/rtc-fm3130.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-fm3130.c
--- a/drivers/rtc/rtc-fm3130.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-fm3130.c
@@ -131,17 +131,17 @@ static int fm3130_get_time(struct device
 			fm3130->regs[0xc], fm3130->regs[0xd],
 			fm3130->regs[0xe]);
 
-	t->tm_sec = BCD2BIN(fm3130->regs[FM3130_RTC_SECONDS] & 0x7f);
-	t->tm_min = BCD2BIN(fm3130->regs[FM3130_RTC_MINUTES] & 0x7f);
+	t->tm_sec = bcd2bin(fm3130->regs[FM3130_RTC_SECONDS] & 0x7f);
+	t->tm_min = bcd2bin(fm3130->regs[FM3130_RTC_MINUTES] & 0x7f);
 	tmp = fm3130->regs[FM3130_RTC_HOURS] & 0x3f;
-	t->tm_hour = BCD2BIN(tmp);
-	t->tm_wday = BCD2BIN(fm3130->regs[FM3130_RTC_DAY] & 0x07) - 1;
-	t->tm_mday = BCD2BIN(fm3130->regs[FM3130_RTC_DATE] & 0x3f);
+	t->tm_hour = bcd2bin(tmp);
+	t->tm_wday = bcd2bin(fm3130->regs[FM3130_RTC_DAY] & 0x07) - 1;
+	t->tm_mday = bcd2bin(fm3130->regs[FM3130_RTC_DATE] & 0x3f);
 	tmp = fm3130->regs[FM3130_RTC_MONTHS] & 0x1f;
-	t->tm_mon = BCD2BIN(tmp) - 1;
+	t->tm_mon = bcd2bin(tmp) - 1;
 
 	/* assume 20YY not 19YY, and ignore CF bit */
-	t->tm_year = BCD2BIN(fm3130->regs[FM3130_RTC_YEARS]) + 100;
+	t->tm_year = bcd2bin(fm3130->regs[FM3130_RTC_YEARS]) + 100;
 
 	dev_dbg(dev, "%s secs=%d, mins=%d, "
 		"hours=%d, mday=%d, mon=%d, year=%d, wday=%d\n",
@@ -167,16 +167,16 @@ static int fm3130_set_time(struct device
 		t->tm_mon, t->tm_year, t->tm_wday);
 
 	/* first register addr */
-	buf[FM3130_RTC_SECONDS] = BIN2BCD(t->tm_sec);
-	buf[FM3130_RTC_MINUTES] = BIN2BCD(t->tm_min);
-	buf[FM3130_RTC_HOURS] = BIN2BCD(t->tm_hour);
-	buf[FM3130_RTC_DAY] = BIN2BCD(t->tm_wday + 1);
-	buf[FM3130_RTC_DATE] = BIN2BCD(t->tm_mday);
-	buf[FM3130_RTC_MONTHS] = BIN2BCD(t->tm_mon + 1);
+	buf[FM3130_RTC_SECONDS] = bin2bcd(t->tm_sec);
+	buf[FM3130_RTC_MINUTES] = bin2bcd(t->tm_min);
+	buf[FM3130_RTC_HOURS] = bin2bcd(t->tm_hour);
+	buf[FM3130_RTC_DAY] = bin2bcd(t->tm_wday + 1);
+	buf[FM3130_RTC_DATE] = bin2bcd(t->tm_mday);
+	buf[FM3130_RTC_MONTHS] = bin2bcd(t->tm_mon + 1);
 
 	/* assume 20YY not 19YY */
 	tmp = t->tm_year - 100;
-	buf[FM3130_RTC_YEARS] = BIN2BCD(tmp);
+	buf[FM3130_RTC_YEARS] = bin2bcd(tmp);
 
 	dev_dbg(dev, "%s: %02x %02x %02x %02x %02x %02x %02x"
 		"%02x %02x %02x %02x %02x %02x %02x %02x\n",
@@ -222,11 +222,11 @@ static int fm3130_read_alarm(struct devi
 			fm3130->regs[FM3130_ALARM_MONTHS]);
 
 
-	tm->tm_sec	= BCD2BIN(fm3130->regs[FM3130_ALARM_SECONDS] & 0x7F);
-	tm->tm_min	= BCD2BIN(fm3130->regs[FM3130_ALARM_MINUTES] & 0x7F);
-	tm->tm_hour	= BCD2BIN(fm3130->regs[FM3130_ALARM_HOURS] & 0x3F);
-	tm->tm_mday	= BCD2BIN(fm3130->regs[FM3130_ALARM_DATE] & 0x3F);
-	tm->tm_mon	= BCD2BIN(fm3130->regs[FM3130_ALARM_MONTHS] & 0x1F);
+	tm->tm_sec	= bcd2bin(fm3130->regs[FM3130_ALARM_SECONDS] & 0x7F);
+	tm->tm_min	= bcd2bin(fm3130->regs[FM3130_ALARM_MINUTES] & 0x7F);
+	tm->tm_hour	= bcd2bin(fm3130->regs[FM3130_ALARM_HOURS] & 0x3F);
+	tm->tm_mday	= bcd2bin(fm3130->regs[FM3130_ALARM_DATE] & 0x3F);
+	tm->tm_mon	= bcd2bin(fm3130->regs[FM3130_ALARM_MONTHS] & 0x1F);
 	if (tm->tm_mon > 0)
 		tm->tm_mon -= 1; /* RTC is 1-12, tm_mon is 0-11 */
 	dev_dbg(dev, "%s secs=%d, mins=%d, "
@@ -252,23 +252,23 @@ static int fm3130_set_alarm(struct devic
 
 	if (tm->tm_sec != -1)
 		fm3130->regs[FM3130_ALARM_SECONDS] =
-			BIN2BCD(tm->tm_sec) | 0x80;
+			bin2bcd(tm->tm_sec) | 0x80;
 
 	if (tm->tm_min != -1)
 		fm3130->regs[FM3130_ALARM_MINUTES] =
-			BIN2BCD(tm->tm_min) | 0x80;
+			bin2bcd(tm->tm_min) | 0x80;
 
 	if (tm->tm_hour != -1)
 		fm3130->regs[FM3130_ALARM_HOURS] =
-			BIN2BCD(tm->tm_hour) | 0x80;
+			bin2bcd(tm->tm_hour) | 0x80;
 
 	if (tm->tm_mday != -1)
 		fm3130->regs[FM3130_ALARM_DATE] =
-			BIN2BCD(tm->tm_mday) | 0x80;
+			bin2bcd(tm->tm_mday) | 0x80;
 
 	if (tm->tm_mon != -1)
 		fm3130->regs[FM3130_ALARM_MONTHS] =
-			BIN2BCD(tm->tm_mon + 1) | 0x80;
+			bin2bcd(tm->tm_mon + 1) | 0x80;
 
 	dev_dbg(dev, "alarm write %02x %02x %02x %02x %02x\n",
 			fm3130->regs[FM3130_ALARM_SECONDS],
@@ -414,18 +414,18 @@ static int __devinit fm3130_probe(struct
 	/* TODO */
 	/* TODO need to sanity check alarm */
 	tmp = fm3130->regs[FM3130_RTC_SECONDS];
-	tmp = BCD2BIN(tmp & 0x7f);
+	tmp = bcd2bin(tmp & 0x7f);
 	if (tmp > 60)
 		goto exit_bad;
-	tmp = BCD2BIN(fm3130->regs[FM3130_RTC_MINUTES] & 0x7f);
+	tmp = bcd2bin(fm3130->regs[FM3130_RTC_MINUTES] & 0x7f);
 	if (tmp > 60)
 		goto exit_bad;
 
-	tmp = BCD2BIN(fm3130->regs[FM3130_RTC_DATE] & 0x3f);
+	tmp = bcd2bin(fm3130->regs[FM3130_RTC_DATE] & 0x3f);
 	if (tmp == 0 || tmp > 31)
 		goto exit_bad;
 
-	tmp = BCD2BIN(fm3130->regs[FM3130_RTC_MONTHS] & 0x1f);
+	tmp = bcd2bin(fm3130->regs[FM3130_RTC_MONTHS] & 0x1f);
 	if (tmp == 0 || tmp > 12)
 		goto exit_bad;
 
diff -puN drivers/rtc/rtc-isl1208.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-isl1208.c
--- a/drivers/rtc/rtc-isl1208.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-isl1208.c
@@ -259,26 +259,26 @@ isl1208_i2c_read_time(struct i2c_client 
 		return sr;
 	}
 
-	tm->tm_sec = BCD2BIN(regs[ISL1208_REG_SC]);
-	tm->tm_min = BCD2BIN(regs[ISL1208_REG_MN]);
+	tm->tm_sec = bcd2bin(regs[ISL1208_REG_SC]);
+	tm->tm_min = bcd2bin(regs[ISL1208_REG_MN]);
 
 	/* HR field has a more complex interpretation */
 	{
 		const u8 _hr = regs[ISL1208_REG_HR];
 		if (_hr & ISL1208_REG_HR_MIL)	/* 24h format */
-			tm->tm_hour = BCD2BIN(_hr & 0x3f);
+			tm->tm_hour = bcd2bin(_hr & 0x3f);
 		else {
 			/* 12h format */
-			tm->tm_hour = BCD2BIN(_hr & 0x1f);
+			tm->tm_hour = bcd2bin(_hr & 0x1f);
 			if (_hr & ISL1208_REG_HR_PM)	/* PM flag set */
 				tm->tm_hour += 12;
 		}
 	}
 
-	tm->tm_mday = BCD2BIN(regs[ISL1208_REG_DT]);
-	tm->tm_mon = BCD2BIN(regs[ISL1208_REG_MO]) - 1;	/* rtc starts at 1 */
-	tm->tm_year = BCD2BIN(regs[ISL1208_REG_YR]) + 100;
-	tm->tm_wday = BCD2BIN(regs[ISL1208_REG_DW]);
+	tm->tm_mday = bcd2bin(regs[ISL1208_REG_DT]);
+	tm->tm_mon = bcd2bin(regs[ISL1208_REG_MO]) - 1;	/* rtc starts at 1 */
+	tm->tm_year = bcd2bin(regs[ISL1208_REG_YR]) + 100;
+	tm->tm_wday = bcd2bin(regs[ISL1208_REG_DW]);
 
 	return 0;
 }
@@ -305,13 +305,13 @@ isl1208_i2c_read_alarm(struct i2c_client
 	}
 
 	/* MSB of each alarm register is an enable bit */
-	tm->tm_sec = BCD2BIN(regs[ISL1208_REG_SCA - ISL1208_REG_SCA] & 0x7f);
-	tm->tm_min = BCD2BIN(regs[ISL1208_REG_MNA - ISL1208_REG_SCA] & 0x7f);
-	tm->tm_hour = BCD2BIN(regs[ISL1208_REG_HRA - ISL1208_REG_SCA] & 0x3f);
-	tm->tm_mday = BCD2BIN(regs[ISL1208_REG_DTA - ISL1208_REG_SCA] & 0x3f);
+	tm->tm_sec = bcd2bin(regs[ISL1208_REG_SCA - ISL1208_REG_SCA] & 0x7f);
+	tm->tm_min = bcd2bin(regs[ISL1208_REG_MNA - ISL1208_REG_SCA] & 0x7f);
+	tm->tm_hour = bcd2bin(regs[ISL1208_REG_HRA - ISL1208_REG_SCA] & 0x3f);
+	tm->tm_mday = bcd2bin(regs[ISL1208_REG_DTA - ISL1208_REG_SCA] & 0x3f);
 	tm->tm_mon =
-		BCD2BIN(regs[ISL1208_REG_MOA - ISL1208_REG_SCA] & 0x1f) - 1;
-	tm->tm_wday = BCD2BIN(regs[ISL1208_REG_DWA - ISL1208_REG_SCA] & 0x03);
+		bcd2bin(regs[ISL1208_REG_MOA - ISL1208_REG_SCA] & 0x1f) - 1;
+	tm->tm_wday = bcd2bin(regs[ISL1208_REG_DWA - ISL1208_REG_SCA] & 0x03);
 
 	return 0;
 }
@@ -328,15 +328,15 @@ isl1208_i2c_set_time(struct i2c_client *
 	int sr;
 	u8 regs[ISL1208_RTC_SECTION_LEN] = { 0, };
 
-	regs[ISL1208_REG_SC] = BIN2BCD(tm->tm_sec);
-	regs[ISL1208_REG_MN] = BIN2BCD(tm->tm_min);
-	regs[ISL1208_REG_HR] = BIN2BCD(tm->tm_hour) | ISL1208_REG_HR_MIL;
-
-	regs[ISL1208_REG_DT] = BIN2BCD(tm->tm_mday);
-	regs[ISL1208_REG_MO] = BIN2BCD(tm->tm_mon + 1);
-	regs[ISL1208_REG_YR] = BIN2BCD(tm->tm_year - 100);
+	regs[ISL1208_REG_SC] = bin2bcd(tm->tm_sec);
+	regs[ISL1208_REG_MN] = bin2bcd(tm->tm_min);
+	regs[ISL1208_REG_HR] = bin2bcd(tm->tm_hour) | ISL1208_REG_HR_MIL;
+
+	regs[ISL1208_REG_DT] = bin2bcd(tm->tm_mday);
+	regs[ISL1208_REG_MO] = bin2bcd(tm->tm_mon + 1);
+	regs[ISL1208_REG_YR] = bin2bcd(tm->tm_year - 100);
 
-	regs[ISL1208_REG_DW] = BIN2BCD(tm->tm_wday & 7);
+	regs[ISL1208_REG_DW] = bin2bcd(tm->tm_wday & 7);
 
 	sr = isl1208_i2c_get_sr(client);
 	if (sr < 0) {
diff -puN drivers/rtc/rtc-m41t80.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-m41t80.c
--- a/drivers/rtc/rtc-m41t80.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-m41t80.c
@@ -104,15 +104,15 @@ static int m41t80_get_datetime(struct i2
 		return -EIO;
 	}
 
-	tm->tm_sec = BCD2BIN(buf[M41T80_REG_SEC] & 0x7f);
-	tm->tm_min = BCD2BIN(buf[M41T80_REG_MIN] & 0x7f);
-	tm->tm_hour = BCD2BIN(buf[M41T80_REG_HOUR] & 0x3f);
-	tm->tm_mday = BCD2BIN(buf[M41T80_REG_DAY] & 0x3f);
+	tm->tm_sec = bcd2bin(buf[M41T80_REG_SEC] & 0x7f);
+	tm->tm_min = bcd2bin(buf[M41T80_REG_MIN] & 0x7f);
+	tm->tm_hour = bcd2bin(buf[M41T80_REG_HOUR] & 0x3f);
+	tm->tm_mday = bcd2bin(buf[M41T80_REG_DAY] & 0x3f);
 	tm->tm_wday = buf[M41T80_REG_WDAY] & 0x07;
-	tm->tm_mon = BCD2BIN(buf[M41T80_REG_MON] & 0x1f) - 1;
+	tm->tm_mon = bcd2bin(buf[M41T80_REG_MON] & 0x1f) - 1;
 
 	/* assume 20YY not 19YY, and ignore the Century Bit */
-	tm->tm_year = BCD2BIN(buf[M41T80_REG_YEAR]) + 100;
+	tm->tm_year = bcd2bin(buf[M41T80_REG_YEAR]) + 100;
 	return 0;
 }
 
@@ -155,19 +155,19 @@ static int m41t80_set_datetime(struct i2
 	/* Merge time-data and register flags into buf[0..7] */
 	buf[M41T80_REG_SSEC] = 0;
 	buf[M41T80_REG_SEC] =
-		BIN2BCD(tm->tm_sec) | (buf[M41T80_REG_SEC] & ~0x7f);
+		bin2bcd(tm->tm_sec) | (buf[M41T80_REG_SEC] & ~0x7f);
 	buf[M41T80_REG_MIN] =
-		BIN2BCD(tm->tm_min) | (buf[M41T80_REG_MIN] & ~0x7f);
+		bin2bcd(tm->tm_min) | (buf[M41T80_REG_MIN] & ~0x7f);
 	buf[M41T80_REG_HOUR] =
-		BIN2BCD(tm->tm_hour) | (buf[M41T80_REG_HOUR] & ~0x3f) ;
+		bin2bcd(tm->tm_hour) | (buf[M41T80_REG_HOUR] & ~0x3f) ;
 	buf[M41T80_REG_WDAY] =
 		(tm->tm_wday & 0x07) | (buf[M41T80_REG_WDAY] & ~0x07);
 	buf[M41T80_REG_DAY] =
-		BIN2BCD(tm->tm_mday) | (buf[M41T80_REG_DAY] & ~0x3f);
+		bin2bcd(tm->tm_mday) | (buf[M41T80_REG_DAY] & ~0x3f);
 	buf[M41T80_REG_MON] =
-		BIN2BCD(tm->tm_mon + 1) | (buf[M41T80_REG_MON] & ~0x1f);
+		bin2bcd(tm->tm_mon + 1) | (buf[M41T80_REG_MON] & ~0x1f);
 	/* assume 20YY not 19YY */
-	buf[M41T80_REG_YEAR] = BIN2BCD(tm->tm_year % 100);
+	buf[M41T80_REG_YEAR] = bin2bcd(tm->tm_year % 100);
 
 	if (i2c_transfer(client->adapter, msgs, 1) != 1) {
 		dev_err(&client->dev, "write error\n");
@@ -282,15 +282,15 @@ static int m41t80_rtc_set_alarm(struct d
 
 	wbuf[0] = M41T80_REG_ALARM_MON; /* offset into rtc's regs */
 	reg[M41T80_REG_ALARM_SEC] |= t->time.tm_sec >= 0 ?
-		BIN2BCD(t->time.tm_sec) : 0x80;
+		bin2bcd(t->time.tm_sec) : 0x80;
 	reg[M41T80_REG_ALARM_MIN] |= t->time.tm_min >= 0 ?
-		BIN2BCD(t->time.tm_min) : 0x80;
+		bin2bcd(t->time.tm_min) : 0x80;
 	reg[M41T80_REG_ALARM_HOUR] |= t->time.tm_hour >= 0 ?
-		BIN2BCD(t->time.tm_hour) : 0x80;
+		bin2bcd(t->time.tm_hour) : 0x80;
 	reg[M41T80_REG_ALARM_DAY] |= t->time.tm_mday >= 0 ?
-		BIN2BCD(t->time.tm_mday) : 0x80;
+		bin2bcd(t->time.tm_mday) : 0x80;
 	if (t->time.tm_mon >= 0)
-		reg[M41T80_REG_ALARM_MON] |= BIN2BCD(t->time.tm_mon + 1);
+		reg[M41T80_REG_ALARM_MON] |= bin2bcd(t->time.tm_mon + 1);
 	else
 		reg[M41T80_REG_ALARM_DAY] |= 0x40;
 
@@ -341,15 +341,15 @@ static int m41t80_rtc_read_alarm(struct 
 	t->time.tm_mday = -1;
 	t->time.tm_mon = -1;
 	if (!(reg[M41T80_REG_ALARM_SEC] & 0x80))
-		t->time.tm_sec = BCD2BIN(reg[M41T80_REG_ALARM_SEC] & 0x7f);
+		t->time.tm_sec = bcd2bin(reg[M41T80_REG_ALARM_SEC] & 0x7f);
 	if (!(reg[M41T80_REG_ALARM_MIN] & 0x80))
-		t->time.tm_min = BCD2BIN(reg[M41T80_REG_ALARM_MIN] & 0x7f);
+		t->time.tm_min = bcd2bin(reg[M41T80_REG_ALARM_MIN] & 0x7f);
 	if (!(reg[M41T80_REG_ALARM_HOUR] & 0x80))
-		t->time.tm_hour = BCD2BIN(reg[M41T80_REG_ALARM_HOUR] & 0x3f);
+		t->time.tm_hour = bcd2bin(reg[M41T80_REG_ALARM_HOUR] & 0x3f);
 	if (!(reg[M41T80_REG_ALARM_DAY] & 0x80))
-		t->time.tm_mday = BCD2BIN(reg[M41T80_REG_ALARM_DAY] & 0x3f);
+		t->time.tm_mday = bcd2bin(reg[M41T80_REG_ALARM_DAY] & 0x3f);
 	if (!(reg[M41T80_REG_ALARM_DAY] & 0x40))
-		t->time.tm_mon = BCD2BIN(reg[M41T80_REG_ALARM_MON] & 0x1f) - 1;
+		t->time.tm_mon = bcd2bin(reg[M41T80_REG_ALARM_MON] & 0x1f) - 1;
 	t->time.tm_year = -1;
 	t->time.tm_wday = -1;
 	t->time.tm_yday = -1;
diff -puN drivers/rtc/rtc-m41t94.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-m41t94.c
--- a/drivers/rtc/rtc-m41t94.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-m41t94.c
@@ -41,17 +41,17 @@ static int m41t94_set_time(struct device
 		tm->tm_mon, tm->tm_year, tm->tm_wday);
 
 	buf[0] = 0x80 | M41T94_REG_SECONDS; /* write time + date */
-	buf[M41T94_REG_SECONDS] = BIN2BCD(tm->tm_sec);
-	buf[M41T94_REG_MINUTES] = BIN2BCD(tm->tm_min);
-	buf[M41T94_REG_HOURS]   = BIN2BCD(tm->tm_hour);
-	buf[M41T94_REG_WDAY]    = BIN2BCD(tm->tm_wday + 1);
-	buf[M41T94_REG_DAY]     = BIN2BCD(tm->tm_mday);
-	buf[M41T94_REG_MONTH]   = BIN2BCD(tm->tm_mon + 1);
+	buf[M41T94_REG_SECONDS] = bin2bcd(tm->tm_sec);
+	buf[M41T94_REG_MINUTES] = bin2bcd(tm->tm_min);
+	buf[M41T94_REG_HOURS]   = bin2bcd(tm->tm_hour);
+	buf[M41T94_REG_WDAY]    = bin2bcd(tm->tm_wday + 1);
+	buf[M41T94_REG_DAY]     = bin2bcd(tm->tm_mday);
+	buf[M41T94_REG_MONTH]   = bin2bcd(tm->tm_mon + 1);
 
 	buf[M41T94_REG_HOURS] |= M41T94_BIT_CEB;
 	if (tm->tm_year >= 100)
 		buf[M41T94_REG_HOURS] |= M41T94_BIT_CB;
-	buf[M41T94_REG_YEAR] = BIN2BCD(tm->tm_year % 100);
+	buf[M41T94_REG_YEAR] = bin2bcd(tm->tm_year % 100);
 
 	return spi_write(spi, buf, 8);
 }
@@ -82,14 +82,14 @@ static int m41t94_read_time(struct devic
 		spi_write(spi, buf, 2);
 	}
 
-	tm->tm_sec  = BCD2BIN(spi_w8r8(spi, M41T94_REG_SECONDS));
-	tm->tm_min  = BCD2BIN(spi_w8r8(spi, M41T94_REG_MINUTES));
+	tm->tm_sec  = bcd2bin(spi_w8r8(spi, M41T94_REG_SECONDS));
+	tm->tm_min  = bcd2bin(spi_w8r8(spi, M41T94_REG_MINUTES));
 	hour = spi_w8r8(spi, M41T94_REG_HOURS);
-	tm->tm_hour = BCD2BIN(hour & 0x3f);
-	tm->tm_wday = BCD2BIN(spi_w8r8(spi, M41T94_REG_WDAY)) - 1;
-	tm->tm_mday = BCD2BIN(spi_w8r8(spi, M41T94_REG_DAY));
-	tm->tm_mon  = BCD2BIN(spi_w8r8(spi, M41T94_REG_MONTH)) - 1;
-	tm->tm_year = BCD2BIN(spi_w8r8(spi, M41T94_REG_YEAR));
+	tm->tm_hour = bcd2bin(hour & 0x3f);
+	tm->tm_wday = bcd2bin(spi_w8r8(spi, M41T94_REG_WDAY)) - 1;
+	tm->tm_mday = bcd2bin(spi_w8r8(spi, M41T94_REG_DAY));
+	tm->tm_mon  = bcd2bin(spi_w8r8(spi, M41T94_REG_MONTH)) - 1;
+	tm->tm_year = bcd2bin(spi_w8r8(spi, M41T94_REG_YEAR));
 	if ((hour & M41T94_BIT_CB) || !(hour & M41T94_BIT_CEB))
 		tm->tm_year += 100;
 
diff -puN drivers/rtc/rtc-m48t59.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-m48t59.c
--- a/drivers/rtc/rtc-m48t59.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-m48t59.c
@@ -75,10 +75,10 @@ static int m48t59_rtc_read_time(struct d
 	/* Issue the READ command */
 	M48T59_SET_BITS(M48T59_CNTL_READ, M48T59_CNTL);
 
-	tm->tm_year	= BCD2BIN(M48T59_READ(M48T59_YEAR));
+	tm->tm_year	= bcd2bin(M48T59_READ(M48T59_YEAR));
 	/* tm_mon is 0-11 */
-	tm->tm_mon	= BCD2BIN(M48T59_READ(M48T59_MONTH)) - 1;
-	tm->tm_mday	= BCD2BIN(M48T59_READ(M48T59_MDAY));
+	tm->tm_mon	= bcd2bin(M48T59_READ(M48T59_MONTH)) - 1;
+	tm->tm_mday	= bcd2bin(M48T59_READ(M48T59_MDAY));
 
 	val = M48T59_READ(M48T59_WDAY);
 	if ((val & M48T59_WDAY_CEB) && (val & M48T59_WDAY_CB)) {
@@ -86,10 +86,10 @@ static int m48t59_rtc_read_time(struct d
 		tm->tm_year += 100;	/* one century */
 	}
 
-	tm->tm_wday	= BCD2BIN(val & 0x07);
-	tm->tm_hour	= BCD2BIN(M48T59_READ(M48T59_HOUR) & 0x3F);
-	tm->tm_min	= BCD2BIN(M48T59_READ(M48T59_MIN) & 0x7F);
-	tm->tm_sec	= BCD2BIN(M48T59_READ(M48T59_SEC) & 0x7F);
+	tm->tm_wday	= bcd2bin(val & 0x07);
+	tm->tm_hour	= bcd2bin(M48T59_READ(M48T59_HOUR) & 0x3F);
+	tm->tm_min	= bcd2bin(M48T59_READ(M48T59_MIN) & 0x7F);
+	tm->tm_sec	= bcd2bin(M48T59_READ(M48T59_SEC) & 0x7F);
 
 	/* Clear the READ bit */
 	M48T59_CLEAR_BITS(M48T59_CNTL_READ, M48T59_CNTL);
@@ -117,17 +117,17 @@ static int m48t59_rtc_set_time(struct de
 	/* Issue the WRITE command */
 	M48T59_SET_BITS(M48T59_CNTL_WRITE, M48T59_CNTL);
 
-	M48T59_WRITE((BIN2BCD(tm->tm_sec) & 0x7F), M48T59_SEC);
-	M48T59_WRITE((BIN2BCD(tm->tm_min) & 0x7F), M48T59_MIN);
-	M48T59_WRITE((BIN2BCD(tm->tm_hour) & 0x3F), M48T59_HOUR);
-	M48T59_WRITE((BIN2BCD(tm->tm_mday) & 0x3F), M48T59_MDAY);
+	M48T59_WRITE((bin2bcd(tm->tm_sec) & 0x7F), M48T59_SEC);
+	M48T59_WRITE((bin2bcd(tm->tm_min) & 0x7F), M48T59_MIN);
+	M48T59_WRITE((bin2bcd(tm->tm_hour) & 0x3F), M48T59_HOUR);
+	M48T59_WRITE((bin2bcd(tm->tm_mday) & 0x3F), M48T59_MDAY);
 	/* tm_mon is 0-11 */
-	M48T59_WRITE((BIN2BCD(tm->tm_mon + 1) & 0x1F), M48T59_MONTH);
-	M48T59_WRITE(BIN2BCD(tm->tm_year % 100), M48T59_YEAR);
+	M48T59_WRITE((bin2bcd(tm->tm_mon + 1) & 0x1F), M48T59_MONTH);
+	M48T59_WRITE(bin2bcd(tm->tm_year % 100), M48T59_YEAR);
 
 	if (tm->tm_year/100)
 		val = (M48T59_WDAY_CEB | M48T59_WDAY_CB);
-	val |= (BIN2BCD(tm->tm_wday) & 0x07);
+	val |= (bin2bcd(tm->tm_wday) & 0x07);
 	M48T59_WRITE(val, M48T59_WDAY);
 
 	/* Clear the WRITE bit */
@@ -156,18 +156,18 @@ static int m48t59_rtc_readalarm(struct d
 	/* Issue the READ command */
 	M48T59_SET_BITS(M48T59_CNTL_READ, M48T59_CNTL);
 
-	tm->tm_year = BCD2BIN(M48T59_READ(M48T59_YEAR));
+	tm->tm_year = bcd2bin(M48T59_READ(M48T59_YEAR));
 	/* tm_mon is 0-11 */
-	tm->tm_mon = BCD2BIN(M48T59_READ(M48T59_MONTH)) - 1;
+	tm->tm_mon = bcd2bin(M48T59_READ(M48T59_MONTH)) - 1;
 
 	val = M48T59_READ(M48T59_WDAY);
 	if ((val & M48T59_WDAY_CEB) && (val & M48T59_WDAY_CB))
 		tm->tm_year += 100;	/* one century */
 
-	tm->tm_mday = BCD2BIN(M48T59_READ(M48T59_ALARM_DATE));
-	tm->tm_hour = BCD2BIN(M48T59_READ(M48T59_ALARM_HOUR));
-	tm->tm_min = BCD2BIN(M48T59_READ(M48T59_ALARM_MIN));
-	tm->tm_sec = BCD2BIN(M48T59_READ(M48T59_ALARM_SEC));
+	tm->tm_mday = bcd2bin(M48T59_READ(M48T59_ALARM_DATE));
+	tm->tm_hour = bcd2bin(M48T59_READ(M48T59_ALARM_HOUR));
+	tm->tm_min = bcd2bin(M48T59_READ(M48T59_ALARM_MIN));
+	tm->tm_sec = bcd2bin(M48T59_READ(M48T59_ALARM_SEC));
 
 	/* Clear the READ bit */
 	M48T59_CLEAR_BITS(M48T59_CNTL_READ, M48T59_CNTL);
@@ -199,18 +199,18 @@ static int m48t59_rtc_setalarm(struct de
 	 * 0xff means "always match"
 	 */
 	mday = tm->tm_mday;
-	mday = (mday >= 1 && mday <= 31) ? BIN2BCD(mday) : 0xff;
+	mday = (mday >= 1 && mday <= 31) ? bin2bcd(mday) : 0xff;
 	if (mday == 0xff)
 		mday = M48T59_READ(M48T59_MDAY);
 
 	hour = tm->tm_hour;
-	hour = (hour < 24) ? BIN2BCD(hour) : 0x00;
+	hour = (hour < 24) ? bin2bcd(hour) : 0x00;
 
 	min = tm->tm_min;
-	min = (min < 60) ? BIN2BCD(min) : 0x00;
+	min = (min < 60) ? bin2bcd(min) : 0x00;
 
 	sec = tm->tm_sec;
-	sec = (sec < 60) ? BIN2BCD(sec) : 0x00;
+	sec = (sec < 60) ? bin2bcd(sec) : 0x00;
 
 	spin_lock_irqsave(&m48t59->lock, flags);
 	/* Issue the WRITE command */
diff -puN drivers/rtc/rtc-m48t86.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-m48t86.c
--- a/drivers/rtc/rtc-m48t86.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-m48t86.c
@@ -62,14 +62,14 @@ static int m48t86_rtc_read_time(struct d
 		tm->tm_wday	= ops->readbyte(M48T86_REG_DOW);
 	} else {
 		/* bcd mode */
-		tm->tm_sec	= BCD2BIN(ops->readbyte(M48T86_REG_SEC));
-		tm->tm_min	= BCD2BIN(ops->readbyte(M48T86_REG_MIN));
-		tm->tm_hour	= BCD2BIN(ops->readbyte(M48T86_REG_HOUR) & 0x3F);
-		tm->tm_mday	= BCD2BIN(ops->readbyte(M48T86_REG_DOM));
+		tm->tm_sec	= bcd2bin(ops->readbyte(M48T86_REG_SEC));
+		tm->tm_min	= bcd2bin(ops->readbyte(M48T86_REG_MIN));
+		tm->tm_hour	= bcd2bin(ops->readbyte(M48T86_REG_HOUR) & 0x3F);
+		tm->tm_mday	= bcd2bin(ops->readbyte(M48T86_REG_DOM));
 		/* tm_mon is 0-11 */
-		tm->tm_mon	= BCD2BIN(ops->readbyte(M48T86_REG_MONTH)) - 1;
-		tm->tm_year	= BCD2BIN(ops->readbyte(M48T86_REG_YEAR)) + 100;
-		tm->tm_wday	= BCD2BIN(ops->readbyte(M48T86_REG_DOW));
+		tm->tm_mon	= bcd2bin(ops->readbyte(M48T86_REG_MONTH)) - 1;
+		tm->tm_year	= bcd2bin(ops->readbyte(M48T86_REG_YEAR)) + 100;
+		tm->tm_wday	= bcd2bin(ops->readbyte(M48T86_REG_DOW));
 	}
 
 	/* correct the hour if the clock is in 12h mode */
@@ -103,13 +103,13 @@ static int m48t86_rtc_set_time(struct de
 		ops->writebyte(tm->tm_wday, M48T86_REG_DOW);
 	} else {
 		/* bcd mode */
-		ops->writebyte(BIN2BCD(tm->tm_sec), M48T86_REG_SEC);
-		ops->writebyte(BIN2BCD(tm->tm_min), M48T86_REG_MIN);
-		ops->writebyte(BIN2BCD(tm->tm_hour), M48T86_REG_HOUR);
-		ops->writebyte(BIN2BCD(tm->tm_mday), M48T86_REG_DOM);
-		ops->writebyte(BIN2BCD(tm->tm_mon + 1), M48T86_REG_MONTH);
-		ops->writebyte(BIN2BCD(tm->tm_year % 100), M48T86_REG_YEAR);
-		ops->writebyte(BIN2BCD(tm->tm_wday), M48T86_REG_DOW);
+		ops->writebyte(bin2bcd(tm->tm_sec), M48T86_REG_SEC);
+		ops->writebyte(bin2bcd(tm->tm_min), M48T86_REG_MIN);
+		ops->writebyte(bin2bcd(tm->tm_hour), M48T86_REG_HOUR);
+		ops->writebyte(bin2bcd(tm->tm_mday), M48T86_REG_DOM);
+		ops->writebyte(bin2bcd(tm->tm_mon + 1), M48T86_REG_MONTH);
+		ops->writebyte(bin2bcd(tm->tm_year % 100), M48T86_REG_YEAR);
+		ops->writebyte(bin2bcd(tm->tm_wday), M48T86_REG_DOW);
 	}
 
 	/* update ended */
diff -puN drivers/rtc/rtc-max6900.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-max6900.c
--- a/drivers/rtc/rtc-max6900.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-max6900.c
@@ -196,14 +196,14 @@ static int max6900_i2c_read_time(struct 
 	if (rc < 0)
 		return rc;
 
-	tm->tm_sec = BCD2BIN(regs[MAX6900_REG_SC]);
-	tm->tm_min = BCD2BIN(regs[MAX6900_REG_MN]);
-	tm->tm_hour = BCD2BIN(regs[MAX6900_REG_HR] & 0x3f);
-	tm->tm_mday = BCD2BIN(regs[MAX6900_REG_DT]);
-	tm->tm_mon = BCD2BIN(regs[MAX6900_REG_MO]) - 1;
-	tm->tm_year = BCD2BIN(regs[MAX6900_REG_YR]) +
-		      BCD2BIN(regs[MAX6900_REG_CENTURY]) * 100 - 1900;
-	tm->tm_wday = BCD2BIN(regs[MAX6900_REG_DW]);
+	tm->tm_sec = bcd2bin(regs[MAX6900_REG_SC]);
+	tm->tm_min = bcd2bin(regs[MAX6900_REG_MN]);
+	tm->tm_hour = bcd2bin(regs[MAX6900_REG_HR] & 0x3f);
+	tm->tm_mday = bcd2bin(regs[MAX6900_REG_DT]);
+	tm->tm_mon = bcd2bin(regs[MAX6900_REG_MO]) - 1;
+	tm->tm_year = bcd2bin(regs[MAX6900_REG_YR]) +
+		      bcd2bin(regs[MAX6900_REG_CENTURY]) * 100 - 1900;
+	tm->tm_wday = bcd2bin(regs[MAX6900_REG_DW]);
 
 	return 0;
 }
@@ -230,14 +230,14 @@ static int max6900_i2c_set_time(struct i
 	if (rc < 0)
 		return rc;
 
-	regs[MAX6900_REG_SC] = BIN2BCD(tm->tm_sec);
-	regs[MAX6900_REG_MN] = BIN2BCD(tm->tm_min);
-	regs[MAX6900_REG_HR] = BIN2BCD(tm->tm_hour);
-	regs[MAX6900_REG_DT] = BIN2BCD(tm->tm_mday);
-	regs[MAX6900_REG_MO] = BIN2BCD(tm->tm_mon + 1);
-	regs[MAX6900_REG_DW] = BIN2BCD(tm->tm_wday);
-	regs[MAX6900_REG_YR] = BIN2BCD(tm->tm_year % 100);
-	regs[MAX6900_REG_CENTURY] = BIN2BCD((tm->tm_year + 1900) / 100);
+	regs[MAX6900_REG_SC] = bin2bcd(tm->tm_sec);
+	regs[MAX6900_REG_MN] = bin2bcd(tm->tm_min);
+	regs[MAX6900_REG_HR] = bin2bcd(tm->tm_hour);
+	regs[MAX6900_REG_DT] = bin2bcd(tm->tm_mday);
+	regs[MAX6900_REG_MO] = bin2bcd(tm->tm_mon + 1);
+	regs[MAX6900_REG_DW] = bin2bcd(tm->tm_wday);
+	regs[MAX6900_REG_YR] = bin2bcd(tm->tm_year % 100);
+	regs[MAX6900_REG_CENTURY] = bin2bcd((tm->tm_year + 1900) / 100);
 	/* set write protect */
 	regs[MAX6900_REG_CT] = MAX6900_REG_CT_WP;
 
diff -puN drivers/rtc/rtc-max6902.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-max6902.c
--- a/drivers/rtc/rtc-max6902.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-max6902.c
@@ -126,15 +126,15 @@ static int max6902_get_datetime(struct d
 
 	/* The chip sends data in this order:
 	 * Seconds, Minutes, Hours, Date, Month, Day, Year */
-	dt->tm_sec	= BCD2BIN(chip->buf[1]);
-	dt->tm_min	= BCD2BIN(chip->buf[2]);
-	dt->tm_hour	= BCD2BIN(chip->buf[3]);
-	dt->tm_mday	= BCD2BIN(chip->buf[4]);
-	dt->tm_mon	= BCD2BIN(chip->buf[5]) - 1;
-	dt->tm_wday	= BCD2BIN(chip->buf[6]);
-	dt->tm_year = BCD2BIN(chip->buf[7]);
+	dt->tm_sec	= bcd2bin(chip->buf[1]);
+	dt->tm_min	= bcd2bin(chip->buf[2]);
+	dt->tm_hour	= bcd2bin(chip->buf[3]);
+	dt->tm_mday	= bcd2bin(chip->buf[4]);
+	dt->tm_mon	= bcd2bin(chip->buf[5]) - 1;
+	dt->tm_wday	= bcd2bin(chip->buf[6]);
+	dt->tm_year = bcd2bin(chip->buf[7]);
 
-	century = BCD2BIN(tmp) * 100;
+	century = bcd2bin(tmp) * 100;
 
 	dt->tm_year += century;
 	dt->tm_year -= 1900;
@@ -170,15 +170,15 @@ static int max6902_set_datetime(struct d
 	/* Remove write protection */
 	max6902_set_reg(dev, 0xF, 0);
 
-	max6902_set_reg(dev, 0x01, BIN2BCD(dt->tm_sec));
-	max6902_set_reg(dev, 0x03, BIN2BCD(dt->tm_min));
-	max6902_set_reg(dev, 0x05, BIN2BCD(dt->tm_hour));
-
-	max6902_set_reg(dev, 0x07, BIN2BCD(dt->tm_mday));
-	max6902_set_reg(dev, 0x09, BIN2BCD(dt->tm_mon+1));
-	max6902_set_reg(dev, 0x0B, BIN2BCD(dt->tm_wday));
-	max6902_set_reg(dev, 0x0D, BIN2BCD(dt->tm_year%100));
-	max6902_set_reg(dev, 0x13, BIN2BCD(dt->tm_year/100));
+	max6902_set_reg(dev, 0x01, bin2bcd(dt->tm_sec));
+	max6902_set_reg(dev, 0x03, bin2bcd(dt->tm_min));
+	max6902_set_reg(dev, 0x05, bin2bcd(dt->tm_hour));
+
+	max6902_set_reg(dev, 0x07, bin2bcd(dt->tm_mday));
+	max6902_set_reg(dev, 0x09, bin2bcd(dt->tm_mon+1));
+	max6902_set_reg(dev, 0x0B, bin2bcd(dt->tm_wday));
+	max6902_set_reg(dev, 0x0D, bin2bcd(dt->tm_year%100));
+	max6902_set_reg(dev, 0x13, bin2bcd(dt->tm_year/100));
 
 	/* Compulab used a delay here. However, the datasheet
 	 * does not mention a delay being required anywhere... */
diff -puN drivers/rtc/rtc-omap.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-omap.c
@@ -186,30 +186,30 @@ static int tm2bcd(struct rtc_time *tm)
 	if (rtc_valid_tm(tm) != 0)
 		return -EINVAL;
 
-	tm->tm_sec = BIN2BCD(tm->tm_sec);
-	tm->tm_min = BIN2BCD(tm->tm_min);
-	tm->tm_hour = BIN2BCD(tm->tm_hour);
-	tm->tm_mday = BIN2BCD(tm->tm_mday);
+	tm->tm_sec = bin2bcd(tm->tm_sec);
+	tm->tm_min = bin2bcd(tm->tm_min);
+	tm->tm_hour = bin2bcd(tm->tm_hour);
+	tm->tm_mday = bin2bcd(tm->tm_mday);
 
-	tm->tm_mon = BIN2BCD(tm->tm_mon + 1);
+	tm->tm_mon = bin2bcd(tm->tm_mon + 1);
 
 	/* epoch == 1900 */
 	if (tm->tm_year < 100 || tm->tm_year > 199)
 		return -EINVAL;
-	tm->tm_year = BIN2BCD(tm->tm_year - 100);
+	tm->tm_year = bin2bcd(tm->tm_year - 100);
 
 	return 0;
 }
 
 static void bcd2tm(struct rtc_time *tm)
 {
-	tm->tm_sec = BCD2BIN(tm->tm_sec);
-	tm->tm_min = BCD2BIN(tm->tm_min);
-	tm->tm_hour = BCD2BIN(tm->tm_hour);
-	tm->tm_mday = BCD2BIN(tm->tm_mday);
-	tm->tm_mon = BCD2BIN(tm->tm_mon) - 1;
+	tm->tm_sec = bcd2bin(tm->tm_sec);
+	tm->tm_min = bcd2bin(tm->tm_min);
+	tm->tm_hour = bcd2bin(tm->tm_hour);
+	tm->tm_mday = bcd2bin(tm->tm_mday);
+	tm->tm_mon = bcd2bin(tm->tm_mon) - 1;
 	/* epoch == 1900 */
-	tm->tm_year = BCD2BIN(tm->tm_year) + 100;
+	tm->tm_year = bcd2bin(tm->tm_year) + 100;
 }
 
 
diff -puN drivers/rtc/rtc-pcf8563.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -97,13 +97,13 @@ static int pcf8563_get_datetime(struct i
 		buf[8]);
 
 
-	tm->tm_sec = BCD2BIN(buf[PCF8563_REG_SC] & 0x7F);
-	tm->tm_min = BCD2BIN(buf[PCF8563_REG_MN] & 0x7F);
-	tm->tm_hour = BCD2BIN(buf[PCF8563_REG_HR] & 0x3F); /* rtc hr 0-23 */
-	tm->tm_mday = BCD2BIN(buf[PCF8563_REG_DM] & 0x3F);
+	tm->tm_sec = bcd2bin(buf[PCF8563_REG_SC] & 0x7F);
+	tm->tm_min = bcd2bin(buf[PCF8563_REG_MN] & 0x7F);
+	tm->tm_hour = bcd2bin(buf[PCF8563_REG_HR] & 0x3F); /* rtc hr 0-23 */
+	tm->tm_mday = bcd2bin(buf[PCF8563_REG_DM] & 0x3F);
 	tm->tm_wday = buf[PCF8563_REG_DW] & 0x07;
-	tm->tm_mon = BCD2BIN(buf[PCF8563_REG_MO] & 0x1F) - 1; /* rtc mn 1-12 */
-	tm->tm_year = BCD2BIN(buf[PCF8563_REG_YR]);
+	tm->tm_mon = bcd2bin(buf[PCF8563_REG_MO] & 0x1F) - 1; /* rtc mn 1-12 */
+	tm->tm_year = bcd2bin(buf[PCF8563_REG_YR]);
 	if (tm->tm_year < 70)
 		tm->tm_year += 100;	/* assume we are in 1970...2069 */
 	/* detect the polarity heuristically. see note above. */
@@ -138,17 +138,17 @@ static int pcf8563_set_datetime(struct i
 		tm->tm_mday, tm->tm_mon, tm->tm_year, tm->tm_wday);
 
 	/* hours, minutes and seconds */
-	buf[PCF8563_REG_SC] = BIN2BCD(tm->tm_sec);
-	buf[PCF8563_REG_MN] = BIN2BCD(tm->tm_min);
-	buf[PCF8563_REG_HR] = BIN2BCD(tm->tm_hour);
+	buf[PCF8563_REG_SC] = bin2bcd(tm->tm_sec);
+	buf[PCF8563_REG_MN] = bin2bcd(tm->tm_min);
+	buf[PCF8563_REG_HR] = bin2bcd(tm->tm_hour);
 
-	buf[PCF8563_REG_DM] = BIN2BCD(tm->tm_mday);
+	buf[PCF8563_REG_DM] = bin2bcd(tm->tm_mday);
 
 	/* month, 1 - 12 */
-	buf[PCF8563_REG_MO] = BIN2BCD(tm->tm_mon + 1);
+	buf[PCF8563_REG_MO] = bin2bcd(tm->tm_mon + 1);
 
 	/* year and century */
-	buf[PCF8563_REG_YR] = BIN2BCD(tm->tm_year % 100);
+	buf[PCF8563_REG_YR] = bin2bcd(tm->tm_year % 100);
 	if (pcf8563->c_polarity ? (tm->tm_year >= 100) : (tm->tm_year < 100))
 		buf[PCF8563_REG_MO] |= PCF8563_MO_C;
 
diff -puN drivers/rtc/rtc-pcf8583.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-pcf8583.c
--- a/drivers/rtc/rtc-pcf8583.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-pcf8583.c
@@ -76,11 +76,11 @@ static int pcf8583_get_datetime(struct i
 		buf[4] &= 0x3f;
 		buf[5] &= 0x1f;
 
-		dt->tm_sec = BCD2BIN(buf[1]);
-		dt->tm_min = BCD2BIN(buf[2]);
-		dt->tm_hour = BCD2BIN(buf[3]);
-		dt->tm_mday = BCD2BIN(buf[4]);
-		dt->tm_mon = BCD2BIN(buf[5]) - 1;
+		dt->tm_sec = bcd2bin(buf[1]);
+		dt->tm_min = bcd2bin(buf[2]);
+		dt->tm_hour = bcd2bin(buf[3]);
+		dt->tm_mday = bcd2bin(buf[4]);
+		dt->tm_mon = bcd2bin(buf[5]) - 1;
 	}
 
 	return ret == 2 ? 0 : -EIO;
@@ -94,14 +94,14 @@ static int pcf8583_set_datetime(struct i
 	buf[0] = 0;
 	buf[1] = get_ctrl(client) | 0x80;
 	buf[2] = 0;
-	buf[3] = BIN2BCD(dt->tm_sec);
-	buf[4] = BIN2BCD(dt->tm_min);
-	buf[5] = BIN2BCD(dt->tm_hour);
+	buf[3] = bin2bcd(dt->tm_sec);
+	buf[4] = bin2bcd(dt->tm_min);
+	buf[5] = bin2bcd(dt->tm_hour);
 
 	if (datetoo) {
 		len = 8;
-		buf[6] = BIN2BCD(dt->tm_mday) | (dt->tm_year << 6);
-		buf[7] = BIN2BCD(dt->tm_mon + 1)  | (dt->tm_wday << 5);
+		buf[6] = bin2bcd(dt->tm_mday) | (dt->tm_year << 6);
+		buf[7] = bin2bcd(dt->tm_mon + 1)  | (dt->tm_wday << 5);
 	}
 
 	ret = i2c_master_send(client, (char *)buf, len);
diff -puN drivers/rtc/rtc-r9701.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-r9701.c
--- a/drivers/rtc/rtc-r9701.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-r9701.c
@@ -81,13 +81,13 @@ static int r9701_get_datetime(struct dev
 
 	memset(dt, 0, sizeof(*dt));
 
-	dt->tm_sec = BCD2BIN(buf[0]); /* RSECCNT */
-	dt->tm_min = BCD2BIN(buf[1]); /* RMINCNT */
-	dt->tm_hour = BCD2BIN(buf[2]); /* RHRCNT */
-
-	dt->tm_mday = BCD2BIN(buf[3]); /* RDAYCNT */
-	dt->tm_mon = BCD2BIN(buf[4]) - 1; /* RMONCNT */
-	dt->tm_year = BCD2BIN(buf[5]) + 100; /* RYRCNT */
+	dt->tm_sec = bcd2bin(buf[0]); /* RSECCNT */
+	dt->tm_min = bcd2bin(buf[1]); /* RMINCNT */
+	dt->tm_hour = bcd2bin(buf[2]); /* RHRCNT */
+
+	dt->tm_mday = bcd2bin(buf[3]); /* RDAYCNT */
+	dt->tm_mon = bcd2bin(buf[4]) - 1; /* RMONCNT */
+	dt->tm_year = bcd2bin(buf[5]) + 100; /* RYRCNT */
 
 	/* the rtc device may contain illegal values on power up
 	 * according to the data sheet. make sure they are valid.
@@ -104,12 +104,12 @@ static int r9701_set_datetime(struct dev
 	if (year >= 2100 || year < 2000)
 		return -EINVAL;
 
-	ret = write_reg(dev, RHRCNT, BIN2BCD(dt->tm_hour));
-	ret = ret ? ret : write_reg(dev, RMINCNT, BIN2BCD(dt->tm_min));
-	ret = ret ? ret : write_reg(dev, RSECCNT, BIN2BCD(dt->tm_sec));
-	ret = ret ? ret : write_reg(dev, RDAYCNT, BIN2BCD(dt->tm_mday));
-	ret = ret ? ret : write_reg(dev, RMONCNT, BIN2BCD(dt->tm_mon + 1));
-	ret = ret ? ret : write_reg(dev, RYRCNT, BIN2BCD(dt->tm_year - 100));
+	ret = write_reg(dev, RHRCNT, bin2bcd(dt->tm_hour));
+	ret = ret ? ret : write_reg(dev, RMINCNT, bin2bcd(dt->tm_min));
+	ret = ret ? ret : write_reg(dev, RSECCNT, bin2bcd(dt->tm_sec));
+	ret = ret ? ret : write_reg(dev, RDAYCNT, bin2bcd(dt->tm_mday));
+	ret = ret ? ret : write_reg(dev, RMONCNT, bin2bcd(dt->tm_mon + 1));
+	ret = ret ? ret : write_reg(dev, RYRCNT, bin2bcd(dt->tm_year - 100));
 	ret = ret ? ret : write_reg(dev, RWKCNT, 1 << dt->tm_wday);
 
 	return ret;
diff -puN drivers/rtc/rtc-rs5c313.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-rs5c313.c
--- a/drivers/rtc/rtc-rs5c313.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-rs5c313.c
@@ -235,33 +235,33 @@ static int rs5c313_rtc_read_time(struct 
 
 	data = rs5c313_read_reg(RS5C313_ADDR_SEC);
 	data |= (rs5c313_read_reg(RS5C313_ADDR_SEC10) << 4);
-	tm->tm_sec = BCD2BIN(data);
+	tm->tm_sec = bcd2bin(data);
 
 	data = rs5c313_read_reg(RS5C313_ADDR_MIN);
 	data |= (rs5c313_read_reg(RS5C313_ADDR_MIN10) << 4);
-	tm->tm_min = BCD2BIN(data);
+	tm->tm_min = bcd2bin(data);
 
 	data = rs5c313_read_reg(RS5C313_ADDR_HOUR);
 	data |= (rs5c313_read_reg(RS5C313_ADDR_HOUR10) << 4);
-	tm->tm_hour = BCD2BIN(data);
+	tm->tm_hour = bcd2bin(data);
 
 	data = rs5c313_read_reg(RS5C313_ADDR_DAY);
 	data |= (rs5c313_read_reg(RS5C313_ADDR_DAY10) << 4);
-	tm->tm_mday = BCD2BIN(data);
+	tm->tm_mday = bcd2bin(data);
 
 	data = rs5c313_read_reg(RS5C313_ADDR_MON);
 	data |= (rs5c313_read_reg(RS5C313_ADDR_MON10) << 4);
-	tm->tm_mon = BCD2BIN(data) - 1;
+	tm->tm_mon = bcd2bin(data) - 1;
 
 	data = rs5c313_read_reg(RS5C313_ADDR_YEAR);
 	data |= (rs5c313_read_reg(RS5C313_ADDR_YEAR10) << 4);
-	tm->tm_year = BCD2BIN(data);
+	tm->tm_year = bcd2bin(data);
 
 	if (tm->tm_year < 70)
 		tm->tm_year += 100;
 
 	data = rs5c313_read_reg(RS5C313_ADDR_WEEK);
-	tm->tm_wday = BCD2BIN(data);
+	tm->tm_wday = bcd2bin(data);
 
 	RS5C313_CEDISABLE;
 	ndelay(700);		/* CE:L */
@@ -294,31 +294,31 @@ static int rs5c313_rtc_set_time(struct d
 		}
 	}
 
-	data = BIN2BCD(tm->tm_sec);
+	data = bin2bcd(tm->tm_sec);
 	rs5c313_write_reg(RS5C313_ADDR_SEC, data);
 	rs5c313_write_reg(RS5C313_ADDR_SEC10, (data >> 4));
 
-	data = BIN2BCD(tm->tm_min);
+	data = bin2bcd(tm->tm_min);
 	rs5c313_write_reg(RS5C313_ADDR_MIN, data );
 	rs5c313_write_reg(RS5C313_ADDR_MIN10, (data >> 4));
 
-	data = BIN2BCD(tm->tm_hour);
+	data = bin2bcd(tm->tm_hour);
 	rs5c313_write_reg(RS5C313_ADDR_HOUR, data);
 	rs5c313_write_reg(RS5C313_ADDR_HOUR10, (data >> 4));
 
-	data = BIN2BCD(tm->tm_mday);
+	data = bin2bcd(tm->tm_mday);
 	rs5c313_write_reg(RS5C313_ADDR_DAY, data);
 	rs5c313_write_reg(RS5C313_ADDR_DAY10, (data>> 4));
 
-	data = BIN2BCD(tm->tm_mon + 1);
+	data = bin2bcd(tm->tm_mon + 1);
 	rs5c313_write_reg(RS5C313_ADDR_MON, data);
 	rs5c313_write_reg(RS5C313_ADDR_MON10, (data >> 4));
 
-	data = BIN2BCD(tm->tm_year % 100);
+	data = bin2bcd(tm->tm_year % 100);
 	rs5c313_write_reg(RS5C313_ADDR_YEAR, data);
 	rs5c313_write_reg(RS5C313_ADDR_YEAR10, (data >> 4));
 
-	data = BIN2BCD(tm->tm_wday);
+	data = bin2bcd(tm->tm_wday);
 	rs5c313_write_reg(RS5C313_ADDR_WEEK, data);
 
 	RS5C313_CEDISABLE;	/* CE:H */
diff -puN drivers/rtc/rtc-rs5c348.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-rs5c348.c
--- a/drivers/rtc/rtc-rs5c348.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-rs5c348.c
@@ -74,20 +74,20 @@ rs5c348_rtc_set_time(struct device *dev,
 	txbuf[3] = 0;	/* dummy */
 	txbuf[4] = RS5C348_CMD_MW(RS5C348_REG_SECS); /* cmd, sec, ... */
 	txp = &txbuf[5];
-	txp[RS5C348_REG_SECS] = BIN2BCD(tm->tm_sec);
-	txp[RS5C348_REG_MINS] = BIN2BCD(tm->tm_min);
+	txp[RS5C348_REG_SECS] = bin2bcd(tm->tm_sec);
+	txp[RS5C348_REG_MINS] = bin2bcd(tm->tm_min);
 	if (pdata->rtc_24h) {
-		txp[RS5C348_REG_HOURS] = BIN2BCD(tm->tm_hour);
+		txp[RS5C348_REG_HOURS] = bin2bcd(tm->tm_hour);
 	} else {
 		/* hour 0 is AM12, noon is PM12 */
-		txp[RS5C348_REG_HOURS] = BIN2BCD((tm->tm_hour + 11) % 12 + 1) |
+		txp[RS5C348_REG_HOURS] = bin2bcd((tm->tm_hour + 11) % 12 + 1) |
 			(tm->tm_hour >= 12 ? RS5C348_BIT_PM : 0);
 	}
-	txp[RS5C348_REG_WDAY] = BIN2BCD(tm->tm_wday);
-	txp[RS5C348_REG_DAY] = BIN2BCD(tm->tm_mday);
-	txp[RS5C348_REG_MONTH] = BIN2BCD(tm->tm_mon + 1) |
+	txp[RS5C348_REG_WDAY] = bin2bcd(tm->tm_wday);
+	txp[RS5C348_REG_DAY] = bin2bcd(tm->tm_mday);
+	txp[RS5C348_REG_MONTH] = bin2bcd(tm->tm_mon + 1) |
 		(tm->tm_year >= 100 ? RS5C348_BIT_Y2K : 0);
-	txp[RS5C348_REG_YEAR] = BIN2BCD(tm->tm_year % 100);
+	txp[RS5C348_REG_YEAR] = bin2bcd(tm->tm_year % 100);
 	/* write in one transfer to avoid data inconsistency */
 	ret = spi_write_then_read(spi, txbuf, sizeof(txbuf), NULL, 0);
 	udelay(62);	/* Tcsr 62us */
@@ -116,20 +116,20 @@ rs5c348_rtc_read_time(struct device *dev
 	if (ret < 0)
 		return ret;
 
-	tm->tm_sec = BCD2BIN(rxbuf[RS5C348_REG_SECS] & RS5C348_SECS_MASK);
-	tm->tm_min = BCD2BIN(rxbuf[RS5C348_REG_MINS] & RS5C348_MINS_MASK);
-	tm->tm_hour = BCD2BIN(rxbuf[RS5C348_REG_HOURS] & RS5C348_HOURS_MASK);
+	tm->tm_sec = bcd2bin(rxbuf[RS5C348_REG_SECS] & RS5C348_SECS_MASK);
+	tm->tm_min = bcd2bin(rxbuf[RS5C348_REG_MINS] & RS5C348_MINS_MASK);
+	tm->tm_hour = bcd2bin(rxbuf[RS5C348_REG_HOURS] & RS5C348_HOURS_MASK);
 	if (!pdata->rtc_24h) {
 		tm->tm_hour %= 12;
 		if (rxbuf[RS5C348_REG_HOURS] & RS5C348_BIT_PM)
 			tm->tm_hour += 12;
 	}
-	tm->tm_wday = BCD2BIN(rxbuf[RS5C348_REG_WDAY] & RS5C348_WDAY_MASK);
-	tm->tm_mday = BCD2BIN(rxbuf[RS5C348_REG_DAY] & RS5C348_DAY_MASK);
+	tm->tm_wday = bcd2bin(rxbuf[RS5C348_REG_WDAY] & RS5C348_WDAY_MASK);
+	tm->tm_mday = bcd2bin(rxbuf[RS5C348_REG_DAY] & RS5C348_DAY_MASK);
 	tm->tm_mon =
-		BCD2BIN(rxbuf[RS5C348_REG_MONTH] & RS5C348_MONTH_MASK) - 1;
+		bcd2bin(rxbuf[RS5C348_REG_MONTH] & RS5C348_MONTH_MASK) - 1;
 	/* year is 1900 + tm->tm_year */
-	tm->tm_year = BCD2BIN(rxbuf[RS5C348_REG_YEAR]) +
+	tm->tm_year = bcd2bin(rxbuf[RS5C348_REG_YEAR]) +
 		((rxbuf[RS5C348_REG_MONTH] & RS5C348_BIT_Y2K) ? 100 : 0);
 
 	if (rtc_valid_tm(tm) < 0) {
diff -puN drivers/rtc/rtc-rs5c372.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-rs5c372.c
--- a/drivers/rtc/rtc-rs5c372.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-rs5c372.c
@@ -128,9 +128,9 @@ static unsigned rs5c_reg2hr(struct rs5c3
 	unsigned	hour;
 
 	if (rs5c->time24)
-		return BCD2BIN(reg & 0x3f);
+		return bcd2bin(reg & 0x3f);
 
-	hour = BCD2BIN(reg & 0x1f);
+	hour = bcd2bin(reg & 0x1f);
 	if (hour == 12)
 		hour = 0;
 	if (reg & 0x20)
@@ -141,15 +141,15 @@ static unsigned rs5c_reg2hr(struct rs5c3
 static unsigned rs5c_hr2reg(struct rs5c372 *rs5c, unsigned hour)
 {
 	if (rs5c->time24)
-		return BIN2BCD(hour);
+		return bin2bcd(hour);
 
 	if (hour > 12)
-		return 0x20 | BIN2BCD(hour - 12);
+		return 0x20 | bin2bcd(hour - 12);
 	if (hour == 12)
-		return 0x20 | BIN2BCD(12);
+		return 0x20 | bin2bcd(12);
 	if (hour == 0)
-		return BIN2BCD(12);
-	return BIN2BCD(hour);
+		return bin2bcd(12);
+	return bin2bcd(hour);
 }
 
 static int rs5c372_get_datetime(struct i2c_client *client, struct rtc_time *tm)
@@ -160,18 +160,18 @@ static int rs5c372_get_datetime(struct i
 	if (status < 0)
 		return status;
 
-	tm->tm_sec = BCD2BIN(rs5c->regs[RS5C372_REG_SECS] & 0x7f);
-	tm->tm_min = BCD2BIN(rs5c->regs[RS5C372_REG_MINS] & 0x7f);
+	tm->tm_sec = bcd2bin(rs5c->regs[RS5C372_REG_SECS] & 0x7f);
+	tm->tm_min = bcd2bin(rs5c->regs[RS5C372_REG_MINS] & 0x7f);
 	tm->tm_hour = rs5c_reg2hr(rs5c, rs5c->regs[RS5C372_REG_HOURS]);
 
-	tm->tm_wday = BCD2BIN(rs5c->regs[RS5C372_REG_WDAY] & 0x07);
-	tm->tm_mday = BCD2BIN(rs5c->regs[RS5C372_REG_DAY] & 0x3f);
+	tm->tm_wday = bcd2bin(rs5c->regs[RS5C372_REG_WDAY] & 0x07);
+	tm->tm_mday = bcd2bin(rs5c->regs[RS5C372_REG_DAY] & 0x3f);
 
 	/* tm->tm_mon is zero-based */
-	tm->tm_mon = BCD2BIN(rs5c->regs[RS5C372_REG_MONTH] & 0x1f) - 1;
+	tm->tm_mon = bcd2bin(rs5c->regs[RS5C372_REG_MONTH] & 0x1f) - 1;
 
 	/* year is 1900 + tm->tm_year */
-	tm->tm_year = BCD2BIN(rs5c->regs[RS5C372_REG_YEAR]) + 100;
+	tm->tm_year = bcd2bin(rs5c->regs[RS5C372_REG_YEAR]) + 100;
 
 	dev_dbg(&client->dev, "%s: tm is secs=%d, mins=%d, hours=%d, "
 		"mday=%d, mon=%d, year=%d, wday=%d\n",
@@ -195,13 +195,13 @@ static int rs5c372_set_datetime(struct i
 		tm->tm_mday, tm->tm_mon, tm->tm_year, tm->tm_wday);
 
 	buf[0] = RS5C_ADDR(RS5C372_REG_SECS);
-	buf[1] = BIN2BCD(tm->tm_sec);
-	buf[2] = BIN2BCD(tm->tm_min);
+	buf[1] = bin2bcd(tm->tm_sec);
+	buf[2] = bin2bcd(tm->tm_min);
 	buf[3] = rs5c_hr2reg(rs5c, tm->tm_hour);
-	buf[4] = BIN2BCD(tm->tm_wday);
-	buf[5] = BIN2BCD(tm->tm_mday);
-	buf[6] = BIN2BCD(tm->tm_mon + 1);
-	buf[7] = BIN2BCD(tm->tm_year - 100);
+	buf[4] = bin2bcd(tm->tm_wday);
+	buf[5] = bin2bcd(tm->tm_mday);
+	buf[6] = bin2bcd(tm->tm_mon + 1);
+	buf[7] = bin2bcd(tm->tm_year - 100);
 
 	if ((i2c_master_send(client, buf, 8)) != 8) {
 		dev_err(&client->dev, "%s: write error\n", __func__);
@@ -344,7 +344,7 @@ static int rs5c_read_alarm(struct device
 
 	/* report alarm time */
 	t->time.tm_sec = 0;
-	t->time.tm_min = BCD2BIN(rs5c->regs[RS5C_REG_ALARM_A_MIN] & 0x7f);
+	t->time.tm_min = bcd2bin(rs5c->regs[RS5C_REG_ALARM_A_MIN] & 0x7f);
 	t->time.tm_hour = rs5c_reg2hr(rs5c, rs5c->regs[RS5C_REG_ALARM_A_HOURS]);
 	t->time.tm_mday = -1;
 	t->time.tm_mon = -1;
@@ -391,7 +391,7 @@ static int rs5c_set_alarm(struct device 
 
 	/* set alarm */
 	buf[0] = RS5C_ADDR(RS5C_REG_ALARM_A_MIN);
-	buf[1] = BIN2BCD(t->time.tm_min);
+	buf[1] = bin2bcd(t->time.tm_min);
 	buf[2] = rs5c_hr2reg(rs5c, t->time.tm_hour);
 	buf[3] = 0x7f;	/* any/all days */
 	if ((i2c_master_send(client, buf, 4)) != 4) {
diff -puN drivers/rtc/rtc-s35390a.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-s35390a.c
--- a/drivers/rtc/rtc-s35390a.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-s35390a.c
@@ -104,12 +104,12 @@ static int s35390a_disable_test_mode(str
 static char s35390a_hr2reg(struct s35390a *s35390a, int hour)
 {
 	if (s35390a->twentyfourhour)
-		return BIN2BCD(hour);
+		return bin2bcd(hour);
 
 	if (hour < 12)
-		return BIN2BCD(hour);
+		return bin2bcd(hour);
 
-	return 0x40 | BIN2BCD(hour - 12);
+	return 0x40 | bin2bcd(hour - 12);
 }
 
 static int s35390a_reg2hr(struct s35390a *s35390a, char reg)
@@ -117,9 +117,9 @@ static int s35390a_reg2hr(struct s35390a
 	unsigned hour;
 
 	if (s35390a->twentyfourhour)
-		return BCD2BIN(reg & 0x3f);
+		return bcd2bin(reg & 0x3f);
 
-	hour = BCD2BIN(reg & 0x3f);
+	hour = bcd2bin(reg & 0x3f);
 	if (reg & 0x40)
 		hour += 12;
 
@@ -137,13 +137,13 @@ static int s35390a_set_datetime(struct i
 		tm->tm_min, tm->tm_hour, tm->tm_mday, tm->tm_mon, tm->tm_year,
 		tm->tm_wday);
 
-	buf[S35390A_BYTE_YEAR] = BIN2BCD(tm->tm_year - 100);
-	buf[S35390A_BYTE_MONTH] = BIN2BCD(tm->tm_mon + 1);
-	buf[S35390A_BYTE_DAY] = BIN2BCD(tm->tm_mday);
-	buf[S35390A_BYTE_WDAY] = BIN2BCD(tm->tm_wday);
+	buf[S35390A_BYTE_YEAR] = bin2bcd(tm->tm_year - 100);
+	buf[S35390A_BYTE_MONTH] = bin2bcd(tm->tm_mon + 1);
+	buf[S35390A_BYTE_DAY] = bin2bcd(tm->tm_mday);
+	buf[S35390A_BYTE_WDAY] = bin2bcd(tm->tm_wday);
 	buf[S35390A_BYTE_HOURS] = s35390a_hr2reg(s35390a, tm->tm_hour);
-	buf[S35390A_BYTE_MINS] = BIN2BCD(tm->tm_min);
-	buf[S35390A_BYTE_SECS] = BIN2BCD(tm->tm_sec);
+	buf[S35390A_BYTE_MINS] = bin2bcd(tm->tm_min);
+	buf[S35390A_BYTE_SECS] = bin2bcd(tm->tm_sec);
 
 	/* This chip expects the bits of each byte to be in reverse order */
 	for (i = 0; i < 7; ++i)
@@ -168,13 +168,13 @@ static int s35390a_get_datetime(struct i
 	for (i = 0; i < 7; ++i)
 		buf[i] = bitrev8(buf[i]);
 
-	tm->tm_sec = BCD2BIN(buf[S35390A_BYTE_SECS]);
-	tm->tm_min = BCD2BIN(buf[S35390A_BYTE_MINS]);
+	tm->tm_sec = bcd2bin(buf[S35390A_BYTE_SECS]);
+	tm->tm_min = bcd2bin(buf[S35390A_BYTE_MINS]);
 	tm->tm_hour = s35390a_reg2hr(s35390a, buf[S35390A_BYTE_HOURS]);
-	tm->tm_wday = BCD2BIN(buf[S35390A_BYTE_WDAY]);
-	tm->tm_mday = BCD2BIN(buf[S35390A_BYTE_DAY]);
-	tm->tm_mon = BCD2BIN(buf[S35390A_BYTE_MONTH]) - 1;
-	tm->tm_year = BCD2BIN(buf[S35390A_BYTE_YEAR]) + 100;
+	tm->tm_wday = bcd2bin(buf[S35390A_BYTE_WDAY]);
+	tm->tm_mday = bcd2bin(buf[S35390A_BYTE_DAY]);
+	tm->tm_mon = bcd2bin(buf[S35390A_BYTE_MONTH]) - 1;
+	tm->tm_year = bcd2bin(buf[S35390A_BYTE_YEAR]) + 100;
 
 	dev_dbg(&client->dev, "%s: tm is secs=%d, mins=%d, hours=%d, mday=%d, "
 		"mon=%d, year=%d, wday=%d\n", __func__, tm->tm_sec,
diff -puN drivers/rtc/rtc-s3c.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-s3c.c
@@ -134,12 +134,12 @@ static int s3c_rtc_gettime(struct device
 		 rtc_tm->tm_year, rtc_tm->tm_mon, rtc_tm->tm_mday,
 		 rtc_tm->tm_hour, rtc_tm->tm_min, rtc_tm->tm_sec);
 
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
 
 	rtc_tm->tm_year += 100;
 	rtc_tm->tm_mon -= 1;
@@ -163,12 +163,12 @@ static int s3c_rtc_settime(struct device
 		return -EINVAL;
 	}
 
-	writeb(BIN2BCD(tm->tm_sec),  base + S3C2410_RTCSEC);
-	writeb(BIN2BCD(tm->tm_min),  base + S3C2410_RTCMIN);
-	writeb(BIN2BCD(tm->tm_hour), base + S3C2410_RTCHOUR);
-	writeb(BIN2BCD(tm->tm_mday), base + S3C2410_RTCDATE);
-	writeb(BIN2BCD(tm->tm_mon + 1), base + S3C2410_RTCMON);
-	writeb(BIN2BCD(year), base + S3C2410_RTCYEAR);
+	writeb(bin2bcd(tm->tm_sec),  base + S3C2410_RTCSEC);
+	writeb(bin2bcd(tm->tm_min),  base + S3C2410_RTCMIN);
+	writeb(bin2bcd(tm->tm_hour), base + S3C2410_RTCHOUR);
+	writeb(bin2bcd(tm->tm_mday), base + S3C2410_RTCDATE);
+	writeb(bin2bcd(tm->tm_mon + 1), base + S3C2410_RTCMON);
+	writeb(bin2bcd(year), base + S3C2410_RTCYEAR);
 
 	return 0;
 }
@@ -199,34 +199,34 @@ static int s3c_rtc_getalarm(struct devic
 	/* decode the alarm enable field */
 
 	if (alm_en & S3C2410_RTCALM_SECEN)
-		BCD_TO_BIN(alm_tm->tm_sec);
+		alm_tm->tm_sec = bcd2bin(alm_tm->tm_sec);
 	else
 		alm_tm->tm_sec = 0xff;
 
 	if (alm_en & S3C2410_RTCALM_MINEN)
-		BCD_TO_BIN(alm_tm->tm_min);
+		alm_tm->tm_min = bcd2bin(alm_tm->tm_min);
 	else
 		alm_tm->tm_min = 0xff;
 
 	if (alm_en & S3C2410_RTCALM_HOUREN)
-		BCD_TO_BIN(alm_tm->tm_hour);
+		alm_tm->tm_hour = bcd2bin(alm_tm->tm_hour);
 	else
 		alm_tm->tm_hour = 0xff;
 
 	if (alm_en & S3C2410_RTCALM_DAYEN)
-		BCD_TO_BIN(alm_tm->tm_mday);
+		alm_tm->tm_mday = bcd2bin(alm_tm->tm_mday);
 	else
 		alm_tm->tm_mday = 0xff;
 
 	if (alm_en & S3C2410_RTCALM_MONEN) {
-		BCD_TO_BIN(alm_tm->tm_mon);
+		alm_tm->tm_mon = bcd2bin(alm_tm->tm_mon);
 		alm_tm->tm_mon -= 1;
 	} else {
 		alm_tm->tm_mon = 0xff;
 	}
 
 	if (alm_en & S3C2410_RTCALM_YEAREN)
-		BCD_TO_BIN(alm_tm->tm_year);
+		alm_tm->tm_year = bcd2bin(alm_tm->tm_year);
 	else
 		alm_tm->tm_year = 0xffff;
 
@@ -250,17 +250,17 @@ static int s3c_rtc_setalarm(struct devic
 
 	if (tm->tm_sec < 60 && tm->tm_sec >= 0) {
 		alrm_en |= S3C2410_RTCALM_SECEN;
-		writeb(BIN2BCD(tm->tm_sec), base + S3C2410_ALMSEC);
+		writeb(bin2bcd(tm->tm_sec), base + S3C2410_ALMSEC);
 	}
 
 	if (tm->tm_min < 60 && tm->tm_min >= 0) {
 		alrm_en |= S3C2410_RTCALM_MINEN;
-		writeb(BIN2BCD(tm->tm_min), base + S3C2410_ALMMIN);
+		writeb(bin2bcd(tm->tm_min), base + S3C2410_ALMMIN);
 	}
 
 	if (tm->tm_hour < 24 && tm->tm_hour >= 0) {
 		alrm_en |= S3C2410_RTCALM_HOUREN;
-		writeb(BIN2BCD(tm->tm_hour), base + S3C2410_ALMHOUR);
+		writeb(bin2bcd(tm->tm_hour), base + S3C2410_ALMHOUR);
 	}
 
 	pr_debug("setting S3C2410_RTCALM to %08x\n", alrm_en);
diff -puN drivers/rtc/rtc-sh.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-sh.c
--- a/drivers/rtc/rtc-sh.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-sh.c
@@ -330,23 +330,23 @@ static int sh_rtc_read_time(struct devic
 
 		sec128 = readb(rtc->regbase + R64CNT);
 
-		tm->tm_sec	= BCD2BIN(readb(rtc->regbase + RSECCNT));
-		tm->tm_min	= BCD2BIN(readb(rtc->regbase + RMINCNT));
-		tm->tm_hour	= BCD2BIN(readb(rtc->regbase + RHRCNT));
-		tm->tm_wday	= BCD2BIN(readb(rtc->regbase + RWKCNT));
-		tm->tm_mday	= BCD2BIN(readb(rtc->regbase + RDAYCNT));
-		tm->tm_mon	= BCD2BIN(readb(rtc->regbase + RMONCNT)) - 1;
+		tm->tm_sec	= bcd2bin(readb(rtc->regbase + RSECCNT));
+		tm->tm_min	= bcd2bin(readb(rtc->regbase + RMINCNT));
+		tm->tm_hour	= bcd2bin(readb(rtc->regbase + RHRCNT));
+		tm->tm_wday	= bcd2bin(readb(rtc->regbase + RWKCNT));
+		tm->tm_mday	= bcd2bin(readb(rtc->regbase + RDAYCNT));
+		tm->tm_mon	= bcd2bin(readb(rtc->regbase + RMONCNT)) - 1;
 
 		if (rtc->capabilities & RTC_CAP_4_DIGIT_YEAR) {
 			yr  = readw(rtc->regbase + RYRCNT);
-			yr100 = BCD2BIN(yr >> 8);
+			yr100 = bcd2bin(yr >> 8);
 			yr &= 0xff;
 		} else {
 			yr  = readb(rtc->regbase + RYRCNT);
-			yr100 = BCD2BIN((yr == 0x99) ? 0x19 : 0x20);
+			yr100 = bcd2bin((yr == 0x99) ? 0x19 : 0x20);
 		}
 
-		tm->tm_year = (yr100 * 100 + BCD2BIN(yr)) - 1900;
+		tm->tm_year = (yr100 * 100 + bcd2bin(yr)) - 1900;
 
 		sec2 = readb(rtc->regbase + R64CNT);
 		cf_bit = readb(rtc->regbase + RCR1) & RCR1_CF;
@@ -388,20 +388,20 @@ static int sh_rtc_set_time(struct device
 	tmp &= ~RCR2_START;
 	writeb(tmp, rtc->regbase + RCR2);
 
-	writeb(BIN2BCD(tm->tm_sec),  rtc->regbase + RSECCNT);
-	writeb(BIN2BCD(tm->tm_min),  rtc->regbase + RMINCNT);
-	writeb(BIN2BCD(tm->tm_hour), rtc->regbase + RHRCNT);
-	writeb(BIN2BCD(tm->tm_wday), rtc->regbase + RWKCNT);
-	writeb(BIN2BCD(tm->tm_mday), rtc->regbase + RDAYCNT);
-	writeb(BIN2BCD(tm->tm_mon + 1), rtc->regbase + RMONCNT);
+	writeb(bin2bcd(tm->tm_sec),  rtc->regbase + RSECCNT);
+	writeb(bin2bcd(tm->tm_min),  rtc->regbase + RMINCNT);
+	writeb(bin2bcd(tm->tm_hour), rtc->regbase + RHRCNT);
+	writeb(bin2bcd(tm->tm_wday), rtc->regbase + RWKCNT);
+	writeb(bin2bcd(tm->tm_mday), rtc->regbase + RDAYCNT);
+	writeb(bin2bcd(tm->tm_mon + 1), rtc->regbase + RMONCNT);
 
 	if (rtc->capabilities & RTC_CAP_4_DIGIT_YEAR) {
-		year = (BIN2BCD((tm->tm_year + 1900) / 100) << 8) |
-			BIN2BCD(tm->tm_year % 100);
+		year = (bin2bcd((tm->tm_year + 1900) / 100) << 8) |
+			bin2bcd(tm->tm_year % 100);
 		writew(year, rtc->regbase + RYRCNT);
 	} else {
 		year = tm->tm_year % 100;
-		writeb(BIN2BCD(year), rtc->regbase + RYRCNT);
+		writeb(bin2bcd(year), rtc->regbase + RYRCNT);
 	}
 
 	/* Start RTC */
@@ -423,7 +423,7 @@ static inline int sh_rtc_read_alarm_valu
 	byte = readb(rtc->regbase + reg_off);
 	if (byte & AR_ENB) {
 		byte &= ~AR_ENB;	/* strip the enable bit */
-		value = BCD2BIN(byte);
+		value = bcd2bin(byte);
 	}
 
 	return value;
@@ -461,7 +461,7 @@ static inline void sh_rtc_write_alarm_va
 	if (value < 0)
 		writeb(0, rtc->regbase + reg_off);
 	else
-		writeb(BIN2BCD(value) | AR_ENB,  rtc->regbase + reg_off);
+		writeb(bin2bcd(value) | AR_ENB,  rtc->regbase + reg_off);
 }
 
 static int sh_rtc_check_alarm(struct rtc_time *tm)
diff -puN drivers/rtc/rtc-stk17ta8.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-stk17ta8.c
--- a/drivers/rtc/rtc-stk17ta8.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-stk17ta8.c
@@ -82,14 +82,14 @@ static int stk17ta8_rtc_set_time(struct 
 	flags = readb(pdata->ioaddr + RTC_FLAGS);
 	writeb(flags | RTC_WRITE, pdata->ioaddr + RTC_FLAGS);
 
-	writeb(BIN2BCD(tm->tm_year % 100), ioaddr + RTC_YEAR);
-	writeb(BIN2BCD(tm->tm_mon + 1), ioaddr + RTC_MONTH);
-	writeb(BIN2BCD(tm->tm_wday) & RTC_DAY_MASK, ioaddr + RTC_DAY);
-	writeb(BIN2BCD(tm->tm_mday), ioaddr + RTC_DATE);
-	writeb(BIN2BCD(tm->tm_hour), ioaddr + RTC_HOURS);
-	writeb(BIN2BCD(tm->tm_min), ioaddr + RTC_MINUTES);
-	writeb(BIN2BCD(tm->tm_sec) & RTC_SECONDS_MASK, ioaddr + RTC_SECONDS);
-	writeb(BIN2BCD((tm->tm_year + 1900) / 100), ioaddr + RTC_CENTURY);
+	writeb(bin2bcd(tm->tm_year % 100), ioaddr + RTC_YEAR);
+	writeb(bin2bcd(tm->tm_mon + 1), ioaddr + RTC_MONTH);
+	writeb(bin2bcd(tm->tm_wday) & RTC_DAY_MASK, ioaddr + RTC_DAY);
+	writeb(bin2bcd(tm->tm_mday), ioaddr + RTC_DATE);
+	writeb(bin2bcd(tm->tm_hour), ioaddr + RTC_HOURS);
+	writeb(bin2bcd(tm->tm_min), ioaddr + RTC_MINUTES);
+	writeb(bin2bcd(tm->tm_sec) & RTC_SECONDS_MASK, ioaddr + RTC_SECONDS);
+	writeb(bin2bcd((tm->tm_year + 1900) / 100), ioaddr + RTC_CENTURY);
 
 	writeb(flags & ~RTC_WRITE, pdata->ioaddr + RTC_FLAGS);
 	return 0;
@@ -120,14 +120,14 @@ static int stk17ta8_rtc_read_time(struct
 	year = readb(ioaddr + RTC_YEAR);
 	century = readb(ioaddr + RTC_CENTURY);
 	writeb(flags & ~RTC_READ, ioaddr + RTC_FLAGS);
-	tm->tm_sec = BCD2BIN(second);
-	tm->tm_min = BCD2BIN(minute);
-	tm->tm_hour = BCD2BIN(hour);
-	tm->tm_mday = BCD2BIN(day);
-	tm->tm_wday = BCD2BIN(week);
-	tm->tm_mon = BCD2BIN(month) - 1;
+	tm->tm_sec = bcd2bin(second);
+	tm->tm_min = bcd2bin(minute);
+	tm->tm_hour = bcd2bin(hour);
+	tm->tm_mday = bcd2bin(day);
+	tm->tm_wday = bcd2bin(week);
+	tm->tm_mon = bcd2bin(month) - 1;
 	/* year is 1900 + tm->tm_year */
-	tm->tm_year = BCD2BIN(year) + BCD2BIN(century) * 100 - 1900;
+	tm->tm_year = bcd2bin(year) + bcd2bin(century) * 100 - 1900;
 
 	if (rtc_valid_tm(tm) < 0) {
 		dev_err(dev, "retrieved date/time is not valid.\n");
@@ -148,16 +148,16 @@ static void stk17ta8_rtc_update_alarm(st
 	writeb(flags | RTC_WRITE, ioaddr + RTC_FLAGS);
 
 	writeb(pdata->alrm_mday < 0 || (pdata->irqen & RTC_UF) ?
-	       0x80 : BIN2BCD(pdata->alrm_mday),
+	       0x80 : bin2bcd(pdata->alrm_mday),
 	       ioaddr + RTC_DATE_ALARM);
 	writeb(pdata->alrm_hour < 0 || (pdata->irqen & RTC_UF) ?
-	       0x80 : BIN2BCD(pdata->alrm_hour),
+	       0x80 : bin2bcd(pdata->alrm_hour),
 	       ioaddr + RTC_HOURS_ALARM);
 	writeb(pdata->alrm_min < 0 || (pdata->irqen & RTC_UF) ?
-	       0x80 : BIN2BCD(pdata->alrm_min),
+	       0x80 : bin2bcd(pdata->alrm_min),
 	       ioaddr + RTC_MINUTES_ALARM);
 	writeb(pdata->alrm_sec < 0 || (pdata->irqen & RTC_UF) ?
-	       0x80 : BIN2BCD(pdata->alrm_sec),
+	       0x80 : bin2bcd(pdata->alrm_sec),
 	       ioaddr + RTC_SECONDS_ALARM);
 	writeb(pdata->irqen ? RTC_INTS_AIE : 0, ioaddr + RTC_INTERRUPTS);
 	readb(ioaddr + RTC_FLAGS);	/* clear interrupts */
diff -puN drivers/rtc/rtc-v3020.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-v3020.c
--- a/drivers/rtc/rtc-v3020.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-v3020.c
@@ -92,19 +92,19 @@ static int v3020_read_time(struct device
 
 	/* ...and then read constant values. */
 	tmp = v3020_get_reg(chip, V3020_SECONDS);
-	dt->tm_sec	= BCD2BIN(tmp);
+	dt->tm_sec	= bcd2bin(tmp);
 	tmp = v3020_get_reg(chip, V3020_MINUTES);
-	dt->tm_min	= BCD2BIN(tmp);
+	dt->tm_min	= bcd2bin(tmp);
 	tmp = v3020_get_reg(chip, V3020_HOURS);
-	dt->tm_hour	= BCD2BIN(tmp);
+	dt->tm_hour	= bcd2bin(tmp);
 	tmp = v3020_get_reg(chip, V3020_MONTH_DAY);
-	dt->tm_mday	= BCD2BIN(tmp);
+	dt->tm_mday	= bcd2bin(tmp);
 	tmp = v3020_get_reg(chip, V3020_MONTH);
-	dt->tm_mon    = BCD2BIN(tmp) - 1;
+	dt->tm_mon    = bcd2bin(tmp) - 1;
 	tmp = v3020_get_reg(chip, V3020_WEEK_DAY);
-	dt->tm_wday	= BCD2BIN(tmp);
+	dt->tm_wday	= bcd2bin(tmp);
 	tmp = v3020_get_reg(chip, V3020_YEAR);
-	dt->tm_year = BCD2BIN(tmp)+100;
+	dt->tm_year = bcd2bin(tmp)+100;
 
 #ifdef DEBUG
 	printk("\n%s : Read RTC values\n",__func__);
@@ -136,13 +136,13 @@ static int v3020_set_time(struct device 
 #endif
 
 	/* Write all the values to ram... */
-	v3020_set_reg(chip, V3020_SECONDS, 	BIN2BCD(dt->tm_sec));
-	v3020_set_reg(chip, V3020_MINUTES, 	BIN2BCD(dt->tm_min));
-	v3020_set_reg(chip, V3020_HOURS, 	BIN2BCD(dt->tm_hour));
-	v3020_set_reg(chip, V3020_MONTH_DAY,	BIN2BCD(dt->tm_mday));
-	v3020_set_reg(chip, V3020_MONTH,     BIN2BCD(dt->tm_mon + 1));
-	v3020_set_reg(chip, V3020_WEEK_DAY, 	BIN2BCD(dt->tm_wday));
-	v3020_set_reg(chip, V3020_YEAR, 	BIN2BCD(dt->tm_year % 100));
+	v3020_set_reg(chip, V3020_SECONDS, 	bin2bcd(dt->tm_sec));
+	v3020_set_reg(chip, V3020_MINUTES, 	bin2bcd(dt->tm_min));
+	v3020_set_reg(chip, V3020_HOURS, 	bin2bcd(dt->tm_hour));
+	v3020_set_reg(chip, V3020_MONTH_DAY,	bin2bcd(dt->tm_mday));
+	v3020_set_reg(chip, V3020_MONTH,     bin2bcd(dt->tm_mon + 1));
+	v3020_set_reg(chip, V3020_WEEK_DAY, 	bin2bcd(dt->tm_wday));
+	v3020_set_reg(chip, V3020_YEAR, 	bin2bcd(dt->tm_year % 100));
 
 	/* ...and set the clock. */
 	v3020_set_reg(chip, V3020_CMD_RAM2CLOCK, 0);
diff -puN drivers/rtc/rtc-x1205.c~drivers-rtc-use-bcd2bin-bin2bcd drivers/rtc/rtc-x1205.c
--- a/drivers/rtc/rtc-x1205.c~drivers-rtc-use-bcd2bin-bin2bcd
+++ a/drivers/rtc/rtc-x1205.c
@@ -118,13 +118,13 @@ static int x1205_get_datetime(struct i2c
 		for (i = 0; i <= 4; i++)
 			buf[i] &= 0x7F;
 
-	tm->tm_sec = BCD2BIN(buf[CCR_SEC]);
-	tm->tm_min = BCD2BIN(buf[CCR_MIN]);
-	tm->tm_hour = BCD2BIN(buf[CCR_HOUR] & 0x3F); /* hr is 0-23 */
-	tm->tm_mday = BCD2BIN(buf[CCR_MDAY]);
-	tm->tm_mon = BCD2BIN(buf[CCR_MONTH]) - 1; /* mon is 0-11 */
-	tm->tm_year = BCD2BIN(buf[CCR_YEAR])
-			+ (BCD2BIN(buf[CCR_Y2K]) * 100) - 1900;
+	tm->tm_sec = bcd2bin(buf[CCR_SEC]);
+	tm->tm_min = bcd2bin(buf[CCR_MIN]);
+	tm->tm_hour = bcd2bin(buf[CCR_HOUR] & 0x3F); /* hr is 0-23 */
+	tm->tm_mday = bcd2bin(buf[CCR_MDAY]);
+	tm->tm_mon = bcd2bin(buf[CCR_MONTH]) - 1; /* mon is 0-11 */
+	tm->tm_year = bcd2bin(buf[CCR_YEAR])
+			+ (bcd2bin(buf[CCR_Y2K]) * 100) - 1900;
 	tm->tm_wday = buf[CCR_WDAY];
 
 	dev_dbg(&client->dev, "%s: tm is secs=%d, mins=%d, hours=%d, "
@@ -174,11 +174,11 @@ static int x1205_set_datetime(struct i2c
 		__func__,
 		tm->tm_sec, tm->tm_min, tm->tm_hour);
 
-	buf[CCR_SEC] = BIN2BCD(tm->tm_sec);
-	buf[CCR_MIN] = BIN2BCD(tm->tm_min);
+	buf[CCR_SEC] = bin2bcd(tm->tm_sec);
+	buf[CCR_MIN] = bin2bcd(tm->tm_min);
 
 	/* set hour and 24hr bit */
-	buf[CCR_HOUR] = BIN2BCD(tm->tm_hour) | X1205_HR_MIL;
+	buf[CCR_HOUR] = bin2bcd(tm->tm_hour) | X1205_HR_MIL;
 
 	/* should we also set the date? */
 	if (datetoo) {
@@ -187,15 +187,15 @@ static int x1205_set_datetime(struct i2c
 			__func__,
 			tm->tm_mday, tm->tm_mon, tm->tm_year, tm->tm_wday);
 
-		buf[CCR_MDAY] = BIN2BCD(tm->tm_mday);
+		buf[CCR_MDAY] = bin2bcd(tm->tm_mday);
 
 		/* month, 1 - 12 */
-		buf[CCR_MONTH] = BIN2BCD(tm->tm_mon + 1);
+		buf[CCR_MONTH] = bin2bcd(tm->tm_mon + 1);
 
 		/* year, since the rtc epoch*/
-		buf[CCR_YEAR] = BIN2BCD(tm->tm_year % 100);
+		buf[CCR_YEAR] = bin2bcd(tm->tm_year % 100);
 		buf[CCR_WDAY] = tm->tm_wday & 0x07;
-		buf[CCR_Y2K] = BIN2BCD(tm->tm_year / 100);
+		buf[CCR_Y2K] = bin2bcd(tm->tm_year / 100);
 	}
 
 	/* If writing alarm registers, set compare bits on registers 0-4 */
@@ -437,7 +437,7 @@ static int x1205_validate_client(struct 
 			return -EIO;
 		}
 
-		value = BCD2BIN(reg & probe_limits_pattern[i].mask);
+		value = bcd2bin(reg & probe_limits_pattern[i].mask);
 
 		if (value > probe_limits_pattern[i].max ||
 			value < probe_limits_pattern[i].min) {
_

Patches currently in -mm which might be from bunk@kernel.org are

feature-removal-scheduletxt-remove-the-ncr53c9x-entry.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
m32r-dont-offer-config_isa.patch
m32r-export-empty_zero_page.patch
m32r-export-__ndelay.patch
m32r-kernel-cleanups.patch
the-overdue-eepro100-removal.patch
ntfs-update-homepage.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
git-block.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
git-xtensa.patch
drivers-net-atl1e-atl1e_mainc-uninline-atl1e_setup_mac_ctrl.patch
asm-h8300-mdh-remove-cvs-keyword.patch
alpha-miata-remove-dead-url.patch
uml-remove-the-dead-tty_log-code.patch
include-linux-kernelh-userspace-header-cleanup.patch
maintainers-remove-zf-machz-watchdog-entry.patch
maintainers-remove-hga-framebuffer-driver-entry.patch
include-linux-mounth-remove-cvs-keyword.patch
kernel-dmac-remove-a-cvs-keyword.patch
binfmt_somc-add-module_license.patch
the-scheduled-serial_coldfire-removal.patch
make-probe_serial_gsc-static.patch
pnp-remove-printk-with-outdated-version.patch
telephony-remove-cvs-keywords.patch
reiserfs-procfsc-remove-cvs-keywords.patch
quota-remove-cvs-keywords.patch
make-ptrace_untrace-static.patch
fs-partitions-acornc-remove-dead-code.patch
parport-remove-cvs-keywords.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-firmware-iscsi_ibftc-make-3-functions-static.patch
acpi-use-bcd2bin-bin2bcd.patch
alpha-use-bcd2bin-bin2bcd.patch
arm-use-bcd2bin-bin2bcd.patch
cris-use-bcd2bin-bin2bcd.patch
drivers-rtc-use-bcd2bin-bin2bcd.patch
rtc-use-bcd2bin-bin2bcd.patch
ia64-use-bcd2bin-bin2bcd.patch
ide-cd-use-bcd2bin-bin2bcd.patch
m68k-use-bcd2bin-bin2bcd.patch
mips-use-bcd2bin-bin2bcd.patch
mn10300-use-bcd2bin-bin2bcd.patch
powerpc-use-bcd2bin-bin2bcd.patch
i2c-use-bcd2bin-bin2bcd.patch
drivers-scsi-sr_vendorc-use-bcd2bin.patch
sparc64-use-bcd2bin-bin2bcd.patch
remove-the-obsolete-bcdbin-binbcd-macros.patch
include-linux-bcdh-remove-comments.patch
reiser4.patch

