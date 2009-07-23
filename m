From: akpm@linux-foundation.org
Subject: + time-add-function-to-convert-between-calendar-time-and-broken-down-time-for-universal-use.patch added to -mm tree
Date: Thu, 23 Jul 2009 15:32:31 -0700
Message-ID: <200907232232.n6NMWVZ6031662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753927AbZGWWdZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 18:33:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhaolei@cn.fujitsu.com, hirofumi@mail.parknet.co.jp, mingo@elte.hu, pavel@ucw.cz, tglx@linutronix.de


The patch titled
     time: add function to convert between calendar time and broken-down time for universal use
has been added to the -mm tree.  Its filename is
     time-add-function-to-convert-between-calendar-time-and-broken-down-time-for-universal-use.patch

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
Subject: time: add function to convert between calendar time and broken-down time for universal use
From: Zhaolei <zhaolei@cn.fujitsu.com>

There are many similar code in kernel for one object: convert time between
calendar time and broken-down time.

Here is some source I found:
fs/ncpfs/dir.c
fs/smbfs/proc.c
fs/fat/misc.c
fs/udf/udftime.c
fs/cifs/netmisc.c
net/netfilter/xt_time.c
drivers/scsi/ips.c
drivers/input/misc/hp_sdc_rtc.c
drivers/rtc/rtc-lib.c
arch/ia64/hp/sim/boot/fw-emu.c
arch/m68k/mac/misc.c
arch/powerpc/kernel/time.c
arch/parisc/include/asm/rtc.h
...

We can make a common function for this type of convert,
At least we can get following benefit:
1: Make kernel simple and unify
2: Easy to fix bug in converting code
3: Reduce clone of code in future
   For example, I'm trying to make ftrace display walltime,
   this patch will make me easy.

This code is based on code from glibc-2.6

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/time.h   |   66 ++++++++++++++++++
 kernel/time/Makefile   |    2 
 kernel/time/timeconv.c |  138 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 205 insertions(+), 1 deletion(-)

diff -puN include/linux/time.h~time-add-function-to-convert-between-calendar-time-and-broken-down-time-for-universal-use include/linux/time.h
--- a/include/linux/time.h~time-add-function-to-convert-between-calendar-time-and-broken-down-time-for-universal-use
+++ a/include/linux/time.h
@@ -151,6 +151,72 @@ extern void update_xtime_cache(u64 nsec)
 struct tms;
 extern void do_sys_times(struct tms *);
 
+/*
+ * Similar to the struct tm in userspace <time.h>, but it needs to be here so
+ * that the kernel source is self contained.
+ */
+struct tm {
+	/*
+	 * the number of seconds after the minute, normally in the range
+	 * 0 to 59, but can be up to 60 to allow for leap seconds
+	 */
+	int tm_sec;
+	/* the number of minutes after the hour, in the range 0 to 59*/
+	int tm_min;
+	/* the number of hours past midnight, in the range 0 to 23 */
+	int tm_hour;
+	/* the day of the month, in the range 1 to 31 */
+	int tm_mday;
+	/* the number of months since January, in the range 0 to 11 */
+	int tm_mon;
+	/* the number of years since 1900 */
+	int tm_year;
+	/* the number of days since Sunday, in the range 0 to 6 */
+	int tm_wday;
+	/* the number of days since January 1, in the range 0 to 365 */
+	int tm_yday;
+};
+
+extern struct tm *__offtime(__kernel_time_t totalsecs, int offset,
+			    struct tm *result);
+
+/**
+ * gmtime_r - converts the calendar time to UTC broken-down time
+ *
+ * @totalsecs	the number of seconds elapsed since 00:00:00 on January 1, 1970,
+ *		Coordinated Universal Time (UTC).
+ * @result	pointer to struct tm variable to receive broken-down time
+ *
+ * Return a pointer to the broken-down time result on success,
+ * and NULL on when the year does not fit into an integer.
+ *
+ * Similar to the gmtime_r() in glibc, broken-down time is expressed in
+ * Coordinated Universal Time (UTC).
+ */
+static inline struct tm *gmtime_r(__kernel_time_t totalsecs, struct tm *result)
+{
+	return __offtime(totalsecs, 0, result);
+}
+
+/**
+ * localtime_r - converts the calendar time to local broken-down time
+ *
+ * @totalsecs	the number of seconds elapsed since 00:00:00 on January 1, 1970,
+ *		Coordinated Universal Time (UTC).
+ * @result	pointer to struct tm variable to receive broken-down time
+ *
+ * Return a pointer to the broken-down time result on success,
+ * and NULL on when the year does not fit into an integer.
+ *
+ * Similar to the localtime_r() in glibc, broken-down time is expressed
+ * relative to sys_tz.
+ */
+static inline struct tm *localtime_r(__kernel_time_t totalsecs,
+				     struct tm *result)
+{
+	return __offtime(totalsecs, -sys_tz.tz_minuteswest * 60, result);
+}
+
 /**
  * timespec_to_ns - Convert timespec to nanoseconds
  * @ts:		pointer to the timespec variable to be converted
diff -puN kernel/time/Makefile~time-add-function-to-convert-between-calendar-time-and-broken-down-time-for-universal-use kernel/time/Makefile
--- a/kernel/time/Makefile~time-add-function-to-convert-between-calendar-time-and-broken-down-time-for-universal-use
+++ a/kernel/time/Makefile
@@ -1,4 +1,4 @@
-obj-y += timekeeping.o ntp.o clocksource.o jiffies.o timer_list.o timecompare.o
+obj-y += timekeeping.o ntp.o clocksource.o jiffies.o timer_list.o timecompare.o timeconv.o
 
 obj-$(CONFIG_GENERIC_CLOCKEVENTS_BUILD)		+= clockevents.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS)		+= tick-common.o
diff -puN /dev/null kernel/time/timeconv.c
--- /dev/null
+++ a/kernel/time/timeconv.c
@@ -0,0 +1,138 @@
+/*
+ * Copyright (C) 1993, 1994, 1995, 1996, 1997 Free Software Foundation, Inc.
+ * This file is part of the GNU C Library.
+ * Contributed by Paul Eggert (eggert@twinsun.com).
+ *
+ * The GNU C Library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Library General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ *
+ * The GNU C Library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Library General Public License for more details.
+ *
+ * You should have received a copy of the GNU Library General Public
+ * License along with the GNU C Library; see the file COPYING.LIB.  If not,
+ * write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 02111-1307, USA.
+ */
+
+/*
+ * Converts the calendar time to broken-down time representation
+ * Based on code from glibc-2.6
+ *
+ * 2009-7-14:
+ *   Moved from glibc-2.6 to kernel by Zhaolei<zhaolei@cn.fujitsu.com>
+ */
+
+#include <linux/time.h>
+#include <linux/module.h>
+
+/*
+ * Nonzero if YEAR is a leap year (every 4 years,
+ * except every 100th isn't, and every 400th is).
+ */
+static int __isleap(unsigned int year)
+{
+	return (year) % 4 == 0 && ((year) % 100 != 0 || (year) % 400 == 0);
+}
+
+/* do a mathdiv for long type */
+static long math_div(long a, long b)
+{
+	return a / b - (a % b < 0);
+}
+
+/* How many leap years between y1 and y2, y1 must less or equal to y2 */
+static long leaps_between(long y1, long y2)
+{
+	long leaps1 = math_div(y1 - 1, 4) - math_div(y1 - 1, 100)
+		+ math_div(y1 - 1, 400);
+	long leaps2 = math_div(y2 - 1, 4) - math_div(y2 - 1, 100)
+		+ math_div(y2 - 1, 400);
+	return leaps2 - leaps1;
+}
+
+/* How many days come before each month (0-12). */
+static const unsigned short __mon_yday[2][13] = {
+	/* Normal years. */
+	{0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365},
+	/* Leap years. */
+	{0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366}
+};
+
+#define SECS_PER_HOUR	(60 * 60)
+#define SECS_PER_DAY	(SECS_PER_HOUR * 24)
+
+/**
+ * __offtime - converts the calendar time to local broken-down time
+ *
+ * @totalsecs	the number of seconds elapsed since 00:00:00 on January 1, 1970,
+ *		Coordinated Universal Time (UTC).
+ * @offset	offset seconds adding to totalsecs.
+ * @result	pointer to struct tm variable to receive broken-down time
+ *
+ * Return a pointer to the broken-down time result on success,
+ * and NULL on when the year does not fit into an integer.
+ *
+ * This function is for internal use, call gmtime_r() and localtime_r() instead.
+ */
+struct tm *__offtime(__kernel_time_t totalsecs, int offset, struct tm *result)
+{
+	long days, rem, y;
+	const unsigned short *ip;
+
+	days = totalsecs / SECS_PER_DAY;
+	rem = totalsecs % SECS_PER_DAY;
+	rem += offset;
+	while (rem < 0) {
+		rem += SECS_PER_DAY;
+		--days;
+	}
+	while (rem >= SECS_PER_DAY) {
+		rem -= SECS_PER_DAY;
+		++days;
+	}
+
+	result->tm_hour = rem / SECS_PER_HOUR;
+	rem %= SECS_PER_HOUR;
+	result->tm_min = rem / 60;
+	result->tm_sec = rem % 60;
+
+	/* January 1, 1970 was a Thursday. */
+	result->tm_wday = (4 + days) % 7;
+	if (result->tm_wday < 0)
+		result->tm_wday += 7;
+
+	y = 1970;
+
+	while (days < 0 || days >= (__isleap(y) ? 366 : 365)) {
+		/* Guess a corrected year, assuming 365 days per year. */
+		long yg = y + math_div(days, 365);
+
+		/* Adjust DAYS and Y to match the guessed year. */
+		days -= (yg - y) * 365 + leaps_between(y, yg);
+		y = yg;
+	}
+
+	result->tm_year = y - 1900;
+	if (result->tm_year != y - 1900) {
+		/* The year cannot be represented due to overflow. */
+		return NULL;
+	}
+
+	result->tm_yday = days;
+
+	ip = __mon_yday[__isleap(y)];
+	for (y = 11; days < ip[y]; y--)
+		continue;
+	days -= ip[y];
+
+	result->tm_mon = y;
+	result->tm_mday = days + 1;
+
+	return result;
+}
+EXPORT_SYMBOL(__offtime);
_

Patches currently in -mm which might be from zhaolei@cn.fujitsu.com are

time-add-function-to-convert-between-calendar-time-and-broken-down-time-for-universal-use.patch
time-add-function-to-convert-between-calendar-time-and-broken-down-time-for-universal-use-checkpatch-fixes.patch
fatfs-use-common-localtime-gmtime-in-fat_time_unix2fat.patch
fatfs-use-common-localtime-gmtime-in-fat_time_unix2fat-checkpatch-fixes.patch

