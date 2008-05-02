From: akpm@linux-foundation.org
Subject: - ntp-handle-leap-second-via-timer.patch removed from -mm tree
Date: Fri, 02 May 2008 12:42:14 -0700
Message-ID: <200805021942.m42JgECQ011176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932515AbYEBTrq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:47:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zippel@linux-m68k.org, johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     ntp: handle leap second via timer
has been removed from the -mm tree.  Its filename was
     ntp-handle-leap-second-via-timer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ntp: handle leap second via timer
From: Roman Zippel <zippel@linux-m68k.org>

Remove the leap second handling from second_overflow(), which doesn't has to
check for it every second anymore.  With CONFIG_NO_HZ this also makes sure the
leap second is handled close to the full second.  Additionally this makes it
possible to abort a leap second properly by resetting the STA_INS/STA_DEL
status bits.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/clocksource.h |    2 
 include/linux/timex.h       |    1 
 kernel/time/ntp.c           |  133 +++++++++++++++++++++++-----------
 kernel/time/timekeeping.c   |    4 -
 4 files changed, 95 insertions(+), 45 deletions(-)

diff -puN include/linux/clocksource.h~ntp-handle-leap-second-via-timer include/linux/clocksource.h
--- a/include/linux/clocksource.h~ntp-handle-leap-second-via-timer
+++ a/include/linux/clocksource.h
@@ -93,6 +93,8 @@ struct clocksource {
 #endif
 };
 
+extern struct clocksource *clock;	/* current clocksource */
+
 /*
  * Clock source flags bits::
  */
diff -puN include/linux/timex.h~ntp-handle-leap-second-via-timer include/linux/timex.h
--- a/include/linux/timex.h~ntp-handle-leap-second-via-timer
+++ a/include/linux/timex.h
@@ -212,6 +212,7 @@ extern long time_esterror;	/* estimated 
 
 extern long time_adjust;	/* The amount of adjtime left */
 
+extern void ntp_init(void);
 extern void ntp_clear(void);
 
 /**
diff -puN kernel/time/ntp.c~ntp-handle-leap-second-via-timer kernel/time/ntp.c
--- a/kernel/time/ntp.c~ntp-handle-leap-second-via-timer
+++ a/kernel/time/ntp.c
@@ -16,6 +16,7 @@
 #include <linux/hrtimer.h>
 #include <linux/capability.h>
 #include <linux/math64.h>
+#include <linux/clocksource.h>
 #include <asm/timex.h>
 
 /*
@@ -26,6 +27,8 @@ unsigned long tick_nsec;			/* ACTHZ peri
 u64 tick_length;
 static u64 tick_length_base;
 
+static struct hrtimer leap_timer;
+
 #define MAX_TICKADJ		500		/* microsecs */
 #define MAX_TICKADJ_SCALED	(((u64)(MAX_TICKADJ * NSEC_PER_USEC) << \
 				  NTP_SCALE_SHIFT) / NTP_INTERVAL_FREQ)
@@ -120,64 +123,70 @@ void ntp_clear(void)
 }
 
 /*
- * this routine handles the overflow of the microsecond field
- *
- * The tricky bits of code to handle the accurate clock support
- * were provided by Dave Mills (Mills@UDEL.EDU) of NTP fame.
- * They were originally developed for SUN and DEC kernels.
- * All the kudos should go to Dave for this stuff.
+ * Leap second processing. If in leap-insert state at the end of the
+ * day, the system clock is set back one second; if in leap-delete
+ * state, the system clock is set ahead one second.
  */
-void second_overflow(void)
+static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 {
-	s64 time_adj;
+	enum hrtimer_restart res = HRTIMER_NORESTART;
 
-	/* Bump the maxerror field */
-	time_maxerror += MAXFREQ / NSEC_PER_USEC;
-	if (time_maxerror > NTP_PHASE_LIMIT) {
-		time_maxerror = NTP_PHASE_LIMIT;
-		time_status |= STA_UNSYNC;
-	}
+	write_seqlock_irq(&xtime_lock);
 
-	/*
-	 * Leap second processing. If in leap-insert state at the end of the
-	 * day, the system clock is set back one second; if in leap-delete
-	 * state, the system clock is set ahead one second. The microtime()
-	 * routine or external clock driver will insure that reported time is
-	 * always monotonic. The ugly divides should be replaced.
-	 */
 	switch (time_state) {
 	case TIME_OK:
-		if (time_status & STA_INS)
-			time_state = TIME_INS;
-		else if (time_status & STA_DEL)
-			time_state = TIME_DEL;
 		break;
 	case TIME_INS:
-		if (xtime.tv_sec % 86400 == 0) {
-			xtime.tv_sec--;
-			wall_to_monotonic.tv_sec++;
-			time_state = TIME_OOP;
-			printk(KERN_NOTICE "Clock: inserting leap second "
-					"23:59:60 UTC\n");
-		}
+		xtime.tv_sec--;
+		wall_to_monotonic.tv_sec++;
+		time_state = TIME_OOP;
+		printk(KERN_NOTICE "Clock: "
+		       "inserting leap second 23:59:60 UTC\n");
+		leap_timer.expires = ktime_add_ns(leap_timer.expires,
+						  NSEC_PER_SEC);
+		res = HRTIMER_RESTART;
 		break;
 	case TIME_DEL:
-		if ((xtime.tv_sec + 1) % 86400 == 0) {
-			xtime.tv_sec++;
-			time_tai--;
-			wall_to_monotonic.tv_sec--;
-			time_state = TIME_WAIT;
-			printk(KERN_NOTICE "Clock: deleting leap second "
-					"23:59:59 UTC\n");
-		}
+		xtime.tv_sec++;
+		time_tai--;
+		wall_to_monotonic.tv_sec--;
+		time_state = TIME_WAIT;
+		printk(KERN_NOTICE "Clock: "
+		       "deleting leap second 23:59:59 UTC\n");
 		break;
 	case TIME_OOP:
 		time_tai++;
 		time_state = TIME_WAIT;
-		break;
+		/* fall through */
 	case TIME_WAIT:
 		if (!(time_status & (STA_INS | STA_DEL)))
 			time_state = TIME_OK;
+		break;
+	}
+	update_vsyscall(&xtime, clock);
+
+	write_sequnlock_irq(&xtime_lock);
+
+	return res;
+}
+
+/*
+ * this routine handles the overflow of the microsecond field
+ *
+ * The tricky bits of code to handle the accurate clock support
+ * were provided by Dave Mills (Mills@UDEL.EDU) of NTP fame.
+ * They were originally developed for SUN and DEC kernels.
+ * All the kudos should go to Dave for this stuff.
+ */
+void second_overflow(void)
+{
+	s64 time_adj;
+
+	/* Bump the maxerror field */
+	time_maxerror += MAXFREQ / NSEC_PER_USEC;
+	if (time_maxerror > NTP_PHASE_LIMIT) {
+		time_maxerror = NTP_PHASE_LIMIT;
+		time_status |= STA_UNSYNC;
 	}
 
 	/*
@@ -268,7 +277,7 @@ static inline void notify_cmos_timer(voi
 int do_adjtimex(struct timex *txc)
 {
 	struct timespec ts;
-	long save_adjust;
+	long save_adjust, sec;
 	int result;
 
 	/* In order to modify anything, you gotta be super-user! */
@@ -289,6 +298,10 @@ int do_adjtimex(struct timex *txc)
 		    txc->tick > 1100000/USER_HZ)
 			return -EINVAL;
 
+	if (time_state != TIME_OK && txc->modes & ADJ_STATUS)
+		hrtimer_cancel(&leap_timer);
+	getnstimeofday(&ts);
+
 	write_seqlock_irq(&xtime_lock);
 
 	/* Save for later - semantics of adjtime is to return old value */
@@ -305,6 +318,34 @@ int do_adjtimex(struct timex *txc)
 			/* only set allowed bits */
 			time_status &= STA_RONLY;
 			time_status |= txc->status & ~STA_RONLY;
+
+			switch (time_state) {
+			case TIME_OK:
+			start_timer:
+				sec = ts.tv_sec;
+				if (time_status & STA_INS) {
+					time_state = TIME_INS;
+					sec += 86400 - sec % 86400;
+					hrtimer_start(&leap_timer, ktime_set(sec, 0), HRTIMER_MODE_ABS);
+				} else if (time_status & STA_DEL) {
+					time_state = TIME_DEL;
+					sec += 86400 - (sec + 1) % 86400;
+					hrtimer_start(&leap_timer, ktime_set(sec, 0), HRTIMER_MODE_ABS);
+				}
+				break;
+			case TIME_INS:
+			case TIME_DEL:
+				time_state = TIME_OK;
+				goto start_timer;
+				break;
+			case TIME_WAIT:
+				if (!(time_status & (STA_INS | STA_DEL)))
+					time_state = TIME_OK;
+				break;
+			case TIME_OOP:
+				hrtimer_restart(&leap_timer);
+				break;
+			}
 		}
 
 		if (txc->modes & ADJ_NANO)
@@ -384,7 +425,6 @@ int do_adjtimex(struct timex *txc)
 	txc->stbcnt	   = 0;
 	write_sequnlock_irq(&xtime_lock);
 
-	getnstimeofday(&ts);
 	txc->time.tv_sec = ts.tv_sec;
 	txc->time.tv_usec = ts.tv_nsec;
 	if (!(time_status & STA_NANO))
@@ -402,3 +442,10 @@ static int __init ntp_tick_adj_setup(cha
 }
 
 __setup("ntp_tick_adj=", ntp_tick_adj_setup);
+
+void __init ntp_init(void)
+{
+	ntp_clear();
+	hrtimer_init(&leap_timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
+	leap_timer.function = ntp_leap_second;
+}
diff -puN kernel/time/timekeeping.c~ntp-handle-leap-second-via-timer kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~ntp-handle-leap-second-via-timer
+++ a/kernel/time/timekeeping.c
@@ -53,7 +53,7 @@ void update_xtime_cache(u64 nsec)
 	timespec_add_ns(&xtime_cache, nsec);
 }
 
-static struct clocksource *clock; /* pointer to current clocksource */
+struct clocksource *clock;
 
 
 #ifdef CONFIG_GENERIC_TIME
@@ -246,7 +246,7 @@ void __init timekeeping_init(void)
 
 	write_seqlock_irqsave(&xtime_lock, flags);
 
-	ntp_clear();
+	ntp_init();
 
 	clock = clocksource_get_next();
 	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

origin.patch
affs-fix-reservation-discarding.patch
vfs-kill-put_inode.patch
git-dvb.patch
git-watchdog.patch

