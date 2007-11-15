From: akpm@linux-foundation.org
Subject: + time-fold-__get_realtime_clock_ts-into-getnstimeofday.patch added to -mm tree
Date: Thu, 15 Nov 2007 14:29:31 -0800
Message-ID: <200711152229.lAFMTV3E019189@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52344 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753542AbXKOWaT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 17:30:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, johnstul@us.ibm.com, tglx@linutronix.de


The patch titled
     time: fold __get_realtime_clock_ts() into getnstimeofday()
has been added to the -mm tree.  Its filename is
     time-fold-__get_realtime_clock_ts-into-getnstimeofday.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: time: fold __get_realtime_clock_ts() into getnstimeofday()
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

  - getnstimeofday() was just a wrapper around __get_realtime_clock_ts()
  - Replace calls to __get_realtime_clock_ts() by calls to getnstimeofday()
  - Fix bogus reference to get_realtime_clock_ts(), which never existed

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timekeeping.c |   22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff -puN kernel/time/timekeeping.c~time-fold-__get_realtime_clock_ts-into-getnstimeofday kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~time-fold-__get_realtime_clock_ts-into-getnstimeofday
+++ a/kernel/time/timekeeping.c
@@ -82,13 +82,12 @@ static inline s64 __get_nsec_offset(void
 }
 
 /**
- * __get_realtime_clock_ts - Returns the time of day in a timespec
+ * getnstimeofday - Returns the time of day in a timespec
  * @ts:		pointer to the timespec to be set
  *
- * Returns the time of day in a timespec. Used by
- * do_gettimeofday() and get_realtime_clock_ts().
+ * Returns the time of day in a timespec.
  */
-static inline void __get_realtime_clock_ts(struct timespec *ts)
+void getnstimeofday(struct timespec *ts)
 {
 	unsigned long seq;
 	s64 nsecs;
@@ -104,30 +103,19 @@ static inline void __get_realtime_clock_
 	timespec_add_ns(ts, nsecs);
 }
 
-/**
- * getnstimeofday - Returns the time of day in a timespec
- * @ts:		pointer to the timespec to be set
- *
- * Returns the time of day in a timespec.
- */
-void getnstimeofday(struct timespec *ts)
-{
-	__get_realtime_clock_ts(ts);
-}
-
 EXPORT_SYMBOL(getnstimeofday);
 
 /**
  * do_gettimeofday - Returns the time of day in a timeval
  * @tv:		pointer to the timeval to be set
  *
- * NOTE: Users should be converted to using get_realtime_clock_ts()
+ * NOTE: Users should be converted to using getnstimeofday()
  */
 void do_gettimeofday(struct timeval *tv)
 {
 	struct timespec now;
 
-	__get_realtime_clock_ts(&now);
+	getnstimeofday(&now);
 	tv->tv_sec = now.tv_sec;
 	tv->tv_usec = now.tv_nsec/1000;
 }
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
time-fold-__get_realtime_clock_ts-into-getnstimeofday.patch
git-kbuild.patch
