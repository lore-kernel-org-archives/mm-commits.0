From: akpm@linux-foundation.org
Subject: + alpha-convert-to-use-arch_gettimeoffset.patch added to -mm tree
Date: Thu, 23 Jul 2009 13:13:33 -0700
Message-ID: <200907232013.n6NKDXfL007140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751756AbZGWUOO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 16:14:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     alpha: convert to use arch_gettimeoffset()
has been added to the -mm tree.  Its filename is
     alpha-convert-to-use-arch_gettimeoffset.patch

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
Subject: alpha: convert to use arch_gettimeoffset()
From: john stultz <johnstul@us.ibm.com>

Converts alpha to use GENERIC_TIME via the arch_getoffset()
infrastructure, reducing the amount of arch specific code we need to
maintain.

I suspect the alpha arch could even be further improved to provide and
rpcc() based clocksource, but not having the hardware, I don't feel
comfortable attempting the more complicated conversion (but I'd be glad to
help if anyone else is interested).

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig       |    8 ++++
 arch/alpha/kernel/time.c |   72 ++-----------------------------------
 2 files changed, 12 insertions(+), 68 deletions(-)

diff -puN arch/alpha/Kconfig~alpha-convert-to-use-arch_gettimeoffset arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~alpha-convert-to-use-arch_gettimeoffset
+++ a/arch/alpha/Kconfig
@@ -45,6 +45,14 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
+config GENERIC_TIME
+	bool
+	default y
+
+config ARCH_USES_GETTIMEOFFSET
+	bool
+	default y
+
 config ZONE_DMA
 	bool
 	default y
diff -puN arch/alpha/kernel/time.c~alpha-convert-to-use-arch_gettimeoffset arch/alpha/kernel/time.c
--- a/arch/alpha/kernel/time.c~alpha-convert-to-use-arch_gettimeoffset
+++ a/arch/alpha/kernel/time.c
@@ -408,28 +408,17 @@ time_init(void)
  * part.  So we can't do the "find absolute time in terms of cycles" thing
  * that the other ports do.
  */
-void
-do_gettimeofday(struct timeval *tv)
+u32 arch_gettimeoffset(void)
 {
-	unsigned long flags;
-	unsigned long sec, usec, seq;
 	unsigned long delta_cycles, delta_usec, partial_tick;
 
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-
-		delta_cycles = rpcc() - state.last_time;
-		sec = xtime.tv_sec;
-		usec = (xtime.tv_nsec / 1000);
-		partial_tick = state.partial_tick;
-
-	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
-
 #ifdef CONFIG_SMP
 	/* Until and unless we figure out how to get cpu cycle counters
 	   in sync and keep them there, we can't use the rpcc tricks.  */
 	delta_usec = 0;
 #else
+	delta_cycles = rpcc() - state.last_time;
+	partial_tick = state.partial_tick;
 	/*
 	 * usec = cycles * ticks_per_cycle * 2**48 * 1e6 / (2**48 * ticks)
 	 *	= cycles * (s_t_p_c) * 1e6 / (2**48 * ticks)
@@ -448,62 +437,9 @@ do_gettimeofday(struct timeval *tv)
 	delta_usec = ((delta_usec / ((1UL << (FIX_SHIFT-6-1)) * HZ)) + 1) / 2;
 #endif
 
-	usec += delta_usec;
-	if (usec >= 1000000) {
-		sec += 1;
-		usec -= 1000000;
-	}
-
-	tv->tv_sec = sec;
-	tv->tv_usec = usec;
-}
-
-EXPORT_SYMBOL(do_gettimeofday);
-
-int
-do_settimeofday(struct timespec *tv)
-{
-	time_t wtm_sec, sec = tv->tv_sec;
-	long wtm_nsec, nsec = tv->tv_nsec;
-	unsigned long delta_nsec;
-
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	write_seqlock_irq(&xtime_lock);
-
-	/* The offset that is added into time in do_gettimeofday above
-	   must be subtracted out here to keep a coherent view of the
-	   time.  Without this, a full-tick error is possible.  */
-
-#ifdef CONFIG_SMP
-	delta_nsec = 0;
-#else
-	delta_nsec = rpcc() - state.last_time;
-	delta_nsec = (delta_nsec * state.scaled_ticks_per_cycle 
-		      + state.partial_tick) * 15625;
-	delta_nsec = ((delta_nsec / ((1UL << (FIX_SHIFT-6-1)) * HZ)) + 1) / 2;
-	delta_nsec *= 1000;
-#endif
-
-	nsec -= delta_nsec;
-
-	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
-
-	ntp_clear();
-
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
-	return 0;
+	return delta_usec * 1000;
 }
 
-EXPORT_SYMBOL(do_settimeofday);
-
