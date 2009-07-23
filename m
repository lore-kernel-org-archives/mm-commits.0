From: akpm@linux-foundation.org
Subject: + m32r-convert-to-use-arch_gettimeoffset.patch added to -mm tree
Date: Thu, 23 Jul 2009 13:12:11 -0700
Message-ID: <200907232012.n6NKCB5N005024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751756AbZGWUMy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 16:12:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, takata@linux-m32r.org


The patch titled
     m32r: convert to use arch_gettimeoffset()
has been added to the -mm tree.  Its filename is
     m32r-convert-to-use-arch_gettimeoffset.patch

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
Subject: m32r: convert to use arch_gettimeoffset()
From: john stultz <johnstul@us.ibm.com>

Convert m32r to use GENERIC_TIME via the arch_getoffset() infrastructure,
reducing the amount of arch specific code we need to maintain.

I also noted that m32r doesn't seem to be taking the xtime write lock
before calling do_timer()!  That looks like a pretty bad bug to me.  If
folks agree, let me know and I can move the lock grab to the correct spot.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/Kconfig       |    6 +++
 arch/m32r/kernel/time.c |   74 +-------------------------------------
 2 files changed, 9 insertions(+), 71 deletions(-)

diff -puN arch/m32r/Kconfig~m32r-convert-to-use-arch_gettimeoffset arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~m32r-convert-to-use-arch_gettimeoffset
+++ a/arch/m32r/Kconfig
@@ -41,6 +41,12 @@ config HZ
 	int
 	default 100
 
+config GENERIC_TIME
+	def_bool y
+
+config ARCH_USES_GETTIMEOFFSET
+	def_bool y
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff -puN arch/m32r/kernel/time.c~m32r-convert-to-use-arch_gettimeoffset arch/m32r/kernel/time.c
--- a/arch/m32r/kernel/time.c~m32r-convert-to-use-arch_gettimeoffset
+++ a/arch/m32r/kernel/time.c
@@ -48,7 +48,7 @@ extern void smp_local_timer_interrupt(vo
 
 static unsigned long latch;
 
-static unsigned long do_gettimeoffset(void)
+u32 arch_gettimeoffset(void)
 {
 	unsigned long  elapsed_time = 0;  /* [us] */
 
@@ -93,79 +93,10 @@ static unsigned long do_gettimeoffset(vo
 #error no chip configuration
 #endif
 
-	return elapsed_time;
+	return elapsed_time * 1000;
 }
 
 /*
- * This version of gettimeofday has near microsecond resolution.
- */
-void do_gettimeofday(struct timeval *tv)
-{
-	unsigned long seq;
-	unsigned long usec, sec;
-	unsigned long max_ntp_tick = tick_usec - tickadj;
-
-	do {
-		seq = read_seqbegin(&xtime_lock);
-
-		usec = do_gettimeoffset();
-
-		/*
-		 * If time_adjust is negative then NTP is slowing the clock
-		 * so make sure not to go into next possible interval.
-		 * Better to lose some accuracy than have time go backwards..
-		 */
-		if (unlikely(time_adjust < 0))
-			usec = min(usec, max_ntp_tick);
-
-		sec = xtime.tv_sec;
-		usec += (xtime.tv_nsec / 1000);
-	} while (read_seqretry(&xtime_lock, seq));
-
-	while (usec >= 1000000) {
-		usec -= 1000000;
-		sec++;
-	}
-
-	tv->tv_sec = sec;
-	tv->tv_usec = usec;
-}
-
-EXPORT_SYMBOL(do_gettimeofday);
-
-int do_settimeofday(struct timespec *tv)
-{
-	time_t wtm_sec, sec = tv->tv_sec;
- 	long wtm_nsec, nsec = tv->tv_nsec;
-
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	write_seqlock_irq(&xtime_lock);
-	/*
-	 * This is revolting. We need to set "xtime" correctly. However, the
-	 * value in this location is the value at the most recent update of
-	 * wall time.  Discover what correction gettimeofday() would have
-	 * made, and then undo it!
-	 */
-	nsec -= do_gettimeoffset() * NSEC_PER_USEC;
-
-	wtm_sec = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
-
-	ntp_clear();
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
-
-	return 0;
-}
-
-EXPORT_SYMBOL(do_settimeofday);
