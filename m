From: akpm@linux-foundation.org
Subject: + time-create-arch_gettimeoffset-infrastructure-for-use-in-the-generic-timekeeping-core.patch added to -mm tree
Date: Thu, 16 Apr 2009 16:04:43 -0700
Message-ID: <200904162304.n3GN4iSk009957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754161AbZDPXPJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Apr 2009 19:15:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, cooloney@kernel.org, geert@linux-m68k.org, ink@jurassic.park.msu.ru, lethal@linux-sh.org, magnus.damm@gmail.com, rmk@arm.linux.org.uk, rth@twiddle.net, starvik@axis.com, takata@linux-m32r.org, zippel@linux-m68k.org


The patch titled
     time: create arch_gettimeoffset infrastructure for use in the generic timekeeping core.
has been added to the -mm tree.  Its filename is
     time-create-arch_gettimeoffset-infrastructure-for-use-in-the-generic-timekeeping-core.patch

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
Subject: time: create arch_gettimeoffset infrastructure for use in the generic timekeeping core.
From: john stultz <johnstul@us.ibm.com>

Some arches don't supply their own clocksource.  This is mainly the case
in architectures that get their inter-tick times by reading the counter on
their interval timer.  Since these timers wrap every tick, they're not
really useful as clocksources.  Wrapping them to act like one is possible
but not very efficient.  So we provide a callout these arches can
implement for use with the jiffies clocksource to provide finer then tick
granular time.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Bryan Wu <cooloney@kernel.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Magnus Damm <magnus.damm@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/time.h      |   15 +++++++++++++++
 kernel/time/timekeeping.c |    7 +++++++
 2 files changed, 22 insertions(+)

diff -puN include/linux/time.h~time-create-arch_gettimeoffset-infrastructure-for-use-in-the-generic-timekeeping-core include/linux/time.h
--- a/include/linux/time.h~time-create-arch_gettimeoffset-infrastructure-for-use-in-the-generic-timekeeping-core
+++ a/include/linux/time.h
@@ -113,6 +113,21 @@ struct timespec current_kernel_time(void
 #define CURRENT_TIME		(current_kernel_time())
 #define CURRENT_TIME_SEC	((struct timespec) { get_seconds(), 0 })
 
+/* Some architectures do not supply their own clocksource.
+ * This is mainly the case in architectures that get their
+ * inter-tick times by reading the counter on their interval
+ * timer. Since these timers wrap every tick, they're not really
+ * useful as clocksources. Wrapping them to act like one is possible
+ * but not very efficient. So we provide a callout these arches
+ * can implement for use with the jiffies clocksource to provide
+ * finer then tick granular time.
+ */
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
+extern u32 arch_gettimeoffset(void);
+#else
+#define arch_gettimeoffset() (0)
+#endif
+
 extern void do_gettimeofday(struct timeval *tv);
 extern int do_settimeofday(struct timespec *tv);
 extern int do_sys_settimeofday(struct timespec *tv, struct timezone *tz);
diff -puN kernel/time/timekeeping.c~time-create-arch_gettimeoffset-infrastructure-for-use-in-the-generic-timekeeping-core kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~time-create-arch_gettimeoffset-infrastructure-for-use-in-the-generic-timekeeping-core
+++ a/kernel/time/timekeeping.c
@@ -77,6 +77,10 @@ static void clocksource_forward_now(void
 	clock->cycle_last = cycle_now;
 
 	nsec = cyc2ns(clock, cycle_delta);
+
+	/* If arch requires, add in gettimeoffset() */
+	nsec += arch_gettimeoffset();
+
 	timespec_add_ns(&xtime, nsec);
 
 	nsec = ((s64)cycle_delta * clock->mult_orig) >> clock->shift;
@@ -111,6 +115,9 @@ void getnstimeofday(struct timespec *ts)
 		/* convert to nanoseconds: */
 		nsecs = cyc2ns(clock, cycle_delta);
 
+		/* If arch requires, add in gettimeoffset() */
+		nsecs += arch_gettimeoffset();
+
 	} while (read_seqretry(&xtime_lock, seq));
 
 	timespec_add_ns(ts, nsecs);
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

clocksource-pass-clocksource-to-read-callback.patch
clocksource-add-enable-and-disable-callbacks.patch
clocksource-sanity-check-sysfs-clocksource-changes.patch
time-move-calc_load-call-out-from-xtime_lock-protection.patch
time-avoid-possible-endless-loop-when-using-jiffies-clocksource-and-oneshot-mode-clockevent.patch
time-create-arch_gettimeoffset-infrastructure-for-use-in-the-generic-timekeeping-core.patch
time-sh-convert-to-use-arch_getoffset-infrastructure.patch

