From: akpm@linux-foundation.org
Subject: - ntp-remove-current_tick_length.patch removed from -mm tree
Date: Fri, 02 May 2008 12:42:12 -0700
Message-ID: <200805021942.m42JgC4K011172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932200AbYEBTmt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:42:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zippel@linux-m68k.org, johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     ntp: remove current_tick_length()
has been removed from the -mm tree.  Its filename was
     ntp-remove-current_tick_length.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ntp: remove current_tick_length()
From: Roman Zippel <zippel@linux-m68k.org>

current_tick_length used to do a little more, but now it just returns
tick_length, which we can also access directly at the few places, where it's
needed.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timex.h     |    4 ++--
 kernel/time/ntp.c         |   16 ++--------------
 kernel/time/timekeeping.c |    5 ++---
 3 files changed, 6 insertions(+), 19 deletions(-)

diff -puN include/linux/timex.h~ntp-remove-current_tick_length include/linux/timex.h
--- a/include/linux/timex.h~ntp-remove-current_tick_length
+++ a/include/linux/timex.h
@@ -239,8 +239,8 @@ static inline int ntp_synced(void)
 #endif
 #define NTP_INTERVAL_LENGTH (NSEC_PER_SEC/NTP_INTERVAL_FREQ)
 
-/* Returns how long ticks are at present, in ns / 2^(SHIFT_SCALE-10). */
-extern u64 current_tick_length(void);
+/* Returns how long ticks are at present, in ns / 2^NTP_SCALE_SHIFT. */
+extern u64 tick_length;
 
 extern void second_overflow(void);
 extern void update_ntp_one_tick(void);
diff -puN kernel/time/ntp.c~ntp-remove-current_tick_length kernel/time/ntp.c
--- a/kernel/time/ntp.c~ntp-remove-current_tick_length
+++ a/kernel/time/ntp.c
@@ -23,7 +23,8 @@
  */
 unsigned long tick_usec = TICK_USEC; 		/* USER_HZ period (usec) */
 unsigned long tick_nsec;			/* ACTHZ period (nsec) */
-static u64 tick_length, tick_length_base;
+u64 tick_length;
+static u64 tick_length_base;
 
 #define MAX_TICKADJ		500		/* microsecs */
 #define MAX_TICKADJ_SCALED	(((u64)(MAX_TICKADJ * NSEC_PER_USEC) << \
@@ -203,19 +204,6 @@ void second_overflow(void)
 	}
 }
 
-/*
- * Return how long ticks are at the moment, that is, how much time
- * update_wall_time_one_tick will add to xtime next time we call it
- * (assuming no calls to do_adjtimex in the meantime).
- * The return value is in fixed-point nanoseconds shifted by the
- * specified number of bits to the right of the binary point.
- * This function has no side-effects.
- */
-u64 current_tick_length(void)
-{
-	return tick_length;
-}
-
 #ifdef CONFIG_GENERIC_CMOS_UPDATE
 
 /* Disable the cmos update - used by virtualization and embedded */
diff -puN kernel/time/timekeeping.c~ntp-remove-current_tick_length kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~ntp-remove-current_tick_length
+++ a/kernel/time/timekeeping.c
@@ -380,8 +380,7 @@ static __always_inline int clocksource_b
 	 * Now calculate the error in (1 << look_ahead) ticks, but first
 	 * remove the single look ahead already included in the error.
 	 */
-	tick_error = current_tick_length() >>
-		(NTP_SCALE_SHIFT - clock->shift + 1);
+	tick_error = tick_length >> (NTP_SCALE_SHIFT - clock->shift + 1);
 	tick_error -= clock->xtime_interval >> 1;
 	error = ((error - tick_error) >> look_ahead) + tick_error;
 
@@ -473,7 +472,7 @@ void update_wall_time(void)
 		}
 
 		/* accumulate error between NTP and clock interval */
-		clock->error += current_tick_length();
+		clock->error += tick_length;
 		clock->error -= clock->xtime_interval << (NTP_SCALE_SHIFT - clock->shift);
 	}
 
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

origin.patch
affs-fix-reservation-discarding.patch
vfs-kill-put_inode.patch
git-dvb.patch
git-watchdog.patch

