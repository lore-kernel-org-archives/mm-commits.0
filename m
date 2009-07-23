From: akpm@linux-foundation.org
Subject: + cris-convert-to-use-arch_gettimeoffset.patch added to -mm tree
Date: Thu, 23 Jul 2009 13:14:36 -0700
Message-ID: <200907232014.n6NKEa1V008796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751756AbZGWUOr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 16:14:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, jesper.nilsson@axis.com, starvik@axis.com


The patch titled
     cris: convert to use arch_gettimeoffset()
has been added to the -mm tree.  Its filename is
     cris-convert-to-use-arch_gettimeoffset.patch

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
Subject: cris: convert to use arch_gettimeoffset()
From: john stultz <johnstul@us.ibm.com>

Convert cris to use GENERIC_TIME via the arch_getoffset() infrastructure,
reducing the amount of arch specific code we need to maintain.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/Kconfig       |    6 +++
 arch/cris/kernel/time.c |   68 +-------------------------------------
 2 files changed, 8 insertions(+), 66 deletions(-)

diff -puN arch/cris/Kconfig~cris-convert-to-use-arch_gettimeoffset arch/cris/Kconfig
--- a/arch/cris/Kconfig~cris-convert-to-use-arch_gettimeoffset
+++ a/arch/cris/Kconfig
@@ -20,6 +20,12 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 
+config GENERIC_TIME
+	def_bool y
+
+config ARCH_USES_GETTIMEOFFSET
+	def_bool y
+
 config GENERIC_IOMAP
        bool
        default y
diff -puN arch/cris/kernel/time.c~cris-convert-to-use-arch_gettimeoffset arch/cris/kernel/time.c
--- a/arch/cris/kernel/time.c~cris-convert-to-use-arch_gettimeoffset
+++ a/arch/cris/kernel/time.c
@@ -42,75 +42,11 @@ unsigned long loops_per_usec;
 extern unsigned long do_slow_gettimeoffset(void);
 static unsigned long (*do_gettimeoffset)(void) = do_slow_gettimeoffset;
 
-/*
- * This version of gettimeofday has near microsecond resolution.
- *
- * Note: Division is quite slow on CRIS and do_gettimeofday is called
- *       rather often. Maybe we should do some kind of approximation here
- *       (a naive approximation would be to divide by 1024).
- */
-void do_gettimeofday(struct timeval *tv)
-{
-	unsigned long flags;
-	signed long usec, sec;
-	local_irq_save(flags);
-	usec = do_gettimeoffset();
-
-        /*
-	 * If time_adjust is negative then NTP is slowing the clock
-	 * so make sure not to go into next possible interval.
-	 * Better to lose some accuracy than have time go backwards..
-	 */
-	if (unlikely(time_adjust < 0) && usec > tickadj)
-		usec = tickadj;
-
-	sec = xtime.tv_sec;
-	usec += xtime.tv_nsec / 1000;
-	local_irq_restore(flags);
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
+u32 arch_gettimeoffset(void)
 {
-	time_t wtm_sec, sec = tv->tv_sec;
-	long wtm_nsec, nsec = tv->tv_nsec;
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
-	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
-
-	ntp_clear();
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
-	return 0;
+	return do_gettimeoffset() * 1000;
 }
 
-EXPORT_SYMBOL(do_settimeofday);
-
