From: akpm@linux-foundation.org
Subject: [patch 03/15] y2038: hide
 timeval/timespec/itimerval/itimerspec types
Date: Thu, 20 Feb 2020 20:03:57 -0800
Message-ID: <20200221040357.Ez6Py%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729371AbgBUED6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 Feb 2020 23:03:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, deepa.kernel@gmail.com, arnd@arndb.de, akpm@linux-foundation.org, mm-commits@vger.kernel.org, linux-mm@kvack.org, torvalds@linux-foundation.org

From: Arnd Bergmann <arnd@arndb.de>
Subject: y2038: hide timeval/timespec/itimerval/itimerspec types

There are no in-kernel users remaining, but there may still be users that
include linux/time.h instead of sys/time.h from user space, so leave the
types available to user space while hiding them from kernel space.

Only the __kernel_old_* versions of these types remain now.

Link: http://lkml.kernel.org/r/20200110154232.4104492-4-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Deepa Dinamani <deepa.kernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/asm-generic/posix_types.h |    2 ++
 include/uapi/linux/time.h              |   22 ++++++++++++----------
 2 files changed, 14 insertions(+), 10 deletions(-)

--- a/include/uapi/asm-generic/posix_types.h~y2038-hide-timeval-timespec-itimerval-itimerspec-types
+++ a/include/uapi/asm-generic/posix_types.h
@@ -87,7 +87,9 @@ typedef struct {
 typedef __kernel_long_t	__kernel_off_t;
 typedef long long	__kernel_loff_t;
 typedef __kernel_long_t	__kernel_old_time_t;
+#ifndef __KERNEL__
 typedef __kernel_long_t	__kernel_time_t;
+#endif
 typedef long long __kernel_time64_t;
 typedef __kernel_long_t	__kernel_clock_t;
 typedef int		__kernel_timer_t;
--- a/include/uapi/linux/time.h~y2038-hide-timeval-timespec-itimerval-itimerspec-types
+++ a/include/uapi/linux/time.h
@@ -5,6 +5,7 @@
 #include <linux/types.h>
 #include <linux/time_types.h>
 
+#ifndef __KERNEL__
 #ifndef _STRUCT_TIMESPEC
 #define _STRUCT_TIMESPEC
 struct timespec {
@@ -18,6 +19,17 @@ struct timeval {
 	__kernel_suseconds_t	tv_usec;	/* microseconds */
 };
 
+struct itimerspec {
+	struct timespec it_interval;/* timer period */
+	struct timespec it_value;	/* timer expiration */
+};
+
+struct itimerval {
+	struct timeval it_interval;/* timer interval */
+	struct timeval it_value;	/* current value */
+};
+#endif
+
 struct timezone {
 	int	tz_minuteswest;	/* minutes west of Greenwich */
 	int	tz_dsttime;	/* type of dst correction */
@@ -31,16 +43,6 @@ struct timezone {
 #define	ITIMER_VIRTUAL		1
 #define	ITIMER_PROF		2
 
-struct itimerspec {
-	struct timespec it_interval;	/* timer period */
-	struct timespec it_value;	/* timer expiration */
-};
-
-struct itimerval {
-	struct timeval it_interval;	/* timer interval */
-	struct timeval it_value;	/* current value */
-};
