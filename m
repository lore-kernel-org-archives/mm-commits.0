From: akpm@linux-foundation.org
Subject: + fatfs-use-common-localtime-gmtime-in-fat_time_unix2fat.patch added to -mm tree
Date: Wed, 15 Jul 2009 14:11:52 -0700
Message-ID: <200907152111.n6FLBqSN012306@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985AbZGOVMU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jul 2009 17:12:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhaolei@cn.fujitsu.com, hirofumi@mail.parknet.co.jp, mingo@elte.hu, tglx@linutronix.de


The patch titled
     fatfs: use common localtime/gmtime in fat_time_unix2fat()
has been added to the -mm tree.  Its filename is
     fatfs-use-common-localtime-gmtime-in-fat_time_unix2fat.patch

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
Subject: fatfs: use common localtime/gmtime in fat_time_unix2fat()
From: Zhaolei <zhaolei@cn.fujitsu.com>

It is not necessary to write custom code for convert calendar time to
broken-down time.  localtime()/gmtime() is more generic to do that.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/misc.c |   62 +++++++++++++++---------------------------------
 1 file changed, 20 insertions(+), 42 deletions(-)

diff -puN fs/fat/misc.c~fatfs-use-common-localtime-gmtime-in-fat_time_unix2fat fs/fat/misc.c
--- a/fs/fat/misc.c~fatfs-use-common-localtime-gmtime-in-fat_time_unix2fat
+++ a/fs/fat/misc.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
+#include <linux/time.h>
 #include "fat.h"
 
 /*
@@ -155,10 +156,6 @@ extern struct timezone sys_tz;
 #define SECS_PER_MIN	60
 #define SECS_PER_HOUR	(60 * 60)
 #define SECS_PER_DAY	(SECS_PER_HOUR * 24)
-#define UNIX_SECS_1980	315532800L
-#if BITS_PER_LONG == 64
-#define UNIX_SECS_2108	4354819200L
-#endif
 /* days between 1.1.70 and 1.1.80 (2 leap days) */
 #define DAYS_DELTA	(365 * 10 + 2)
 /* 120 (2100 - 1980) isn't leap year */
@@ -211,58 +208,40 @@ void fat_time_fat2unix(struct msdos_sb_i
 void fat_time_unix2fat(struct msdos_sb_info *sbi, struct timespec *ts,
 		       __le16 *time, __le16 *date, u8 *time_cs)
 {
-	time_t second = ts->tv_sec;
-	time_t day, leap_day, month, year;
-
-	if (!sbi->options.tz_utc)
-		second -= sys_tz.tz_minuteswest * SECS_PER_MIN;
+	unsigned int year, mon, mday, hour, min, sec;
+	if (sbi->options.tz_utc) {
+		gmtime(ts->tv_sec,
+		       &year, &mon, &mday, &hour, &min, &sec, NULL, NULL);
+	} else {
+		localtime(ts->tv_sec,
+		       &year, &mon, &mday, &hour, &min, &sec, NULL, NULL);
+	}
 
-	/* Jan 1 GMT 00:00:00 1980. But what about another time zone? */
-	if (second < UNIX_SECS_1980) {
+	/*  FAT can only support year between 1980 to 2107 */
+	if (year < 1980 - 1900) {
 		*time = 0;
 		*date = cpu_to_le16((0 << 9) | (1 << 5) | 1);
 		if (time_cs)
 			*time_cs = 0;
 		return;
 	}
-#if BITS_PER_LONG == 64
-	if (second >= UNIX_SECS_2108) {
+	if (year > 2107 - 1900) {
 		*time = cpu_to_le16((23 << 11) | (59 << 5) | 29);
 		*date = cpu_to_le16((127 << 9) | (12 << 5) | 31);
 		if (time_cs)
 			*time_cs = 199;
 		return;
 	}
-#endif
 
-	day = second / SECS_PER_DAY - DAYS_DELTA;
-	year = day / 365;
-	leap_day = (year + 3) / 4;
-	if (year > YEAR_2100)		/* 2100 isn't leap year */
-		leap_day--;
-	if (year * 365 + leap_day > day)
-		year--;
-	leap_day = (year + 3) / 4;
-	if (year > YEAR_2100)		/* 2100 isn't leap year */
-		leap_day--;
-	day -= year * 365 + leap_day;
+	/* from 1900 -> from 1980 */
+	year -= 80;
+	/* 0~11 -> 1~12 */
+	mon++;
+	/* 0~59 -> 0~29(2sec counts) */
+	sec >>= 1;
 
-	if (IS_LEAP_YEAR(year) && day == days_in_year[3]) {
-		month = 2;
-	} else {
-		if (IS_LEAP_YEAR(year) && day > days_in_year[3])
-			day--;
-		for (month = 1; month < 12; month++) {
-			if (days_in_year[month + 1] > day)
-				break;
-		}
-	}
-	day -= days_in_year[month];
-
-	*time = cpu_to_le16(((second / SECS_PER_HOUR) % 24) << 11
-			    | ((second / SECS_PER_MIN) % 60) << 5
-			    | (second % SECS_PER_MIN) >> 1);
-	*date = cpu_to_le16((year << 9) | (month << 5) | (day + 1));
+	*time = cpu_to_le16(hour << 11 | min << 5 | sec);
+	*date = cpu_to_le16(year << 9 | mon << 5 | mday);
 	if (time_cs)
 		*time_cs = (ts->tv_sec & 1) * 100 + ts->tv_nsec / 10000000;
 }
@@ -283,4 +262,3 @@ int fat_sync_bhs(struct buffer_head **bh
 	}
 	return err;
 }
