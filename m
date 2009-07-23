From: akpm@linux-foundation.org
Subject: + m68k-convert-to-use-arch_gettimeoffset.patch added to -mm tree
Date: Thu, 23 Jul 2009 13:15:40 -0700
Message-ID: <200907232015.n6NKFetu010479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751756AbZGWUQA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 16:16:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, geert@linux-m68k.org, zippel@linux-m68k.org


The patch titled
     m68k: convert to use arch_gettimeoffset()
has been added to the -mm tree.  Its filename is
     m68k-convert-to-use-arch_gettimeoffset.patch

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
Subject: m68k: convert to use arch_gettimeoffset()
From: john stultz <johnstul@us.ibm.com>

Convert m68k to use GENERIC_TIME via the arch_getoffset() infrastructure,
reducing the amount of arch specific code we need to maintain.

I've taken my best swing at converting this, but I'm not 100% confident
I got it right. My cross-compiler is now out of date (gcc4.2) so I
wasn't able to  check if it compiled. Any assistance from arch
maintainers or testers to get this merged would be great.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/Kconfig       |    6 +++
 arch/m68k/kernel/time.c |   70 +-------------------------------------
 2 files changed, 8 insertions(+), 68 deletions(-)

diff -puN arch/m68k/Kconfig~m68k-convert-to-use-arch_gettimeoffset arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~m68k-convert-to-use-arch_gettimeoffset
+++ a/arch/m68k/Kconfig
@@ -58,6 +58,12 @@ config HZ
 	int
 	default 100
 
+config GENERIC_TIME
+	def_bool y
+
+config ARCH_USES_GETTIMEOFFSET
+	def_bool y
+
 mainmenu "Linux/68k Kernel Configuration"
 
 source "init/Kconfig"
diff -puN arch/m68k/kernel/time.c~m68k-convert-to-use-arch_gettimeoffset arch/m68k/kernel/time.c
--- a/arch/m68k/kernel/time.c~m68k-convert-to-use-arch_gettimeoffset
+++ a/arch/m68k/kernel/time.c
@@ -91,77 +91,11 @@ void __init time_init(void)
 	mach_sched_init(timer_interrupt);
 }
 
-/*
- * This version of gettimeofday has near microsecond resolution.
- */
-void do_gettimeofday(struct timeval *tv)
+u32 arch_gettimeoffset(void)
 {
-	unsigned long flags;
-	unsigned long seq;
-	unsigned long usec, sec;
-	unsigned long max_ntp_tick = tick_usec - tickadj;
-
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-
-		usec = mach_gettimeoffset();
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
-		usec += xtime.tv_nsec/1000;
-	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
-
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
-	long wtm_nsec, nsec = tv->tv_nsec;
-
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	write_seqlock_irq(&xtime_lock);
-	/* This is revolting. We need to set the xtime.tv_nsec
-	 * correctly. However, the value in this location is
-	 * is value at the last tick.
-	 * Discover what correction gettimeofday
-	 * would have done, and then undo it!
-	 */
-	nsec -= 1000 * mach_gettimeoffset();
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
+	return mach_gettimeoffset() * 1000;
 }
 
-EXPORT_SYMBOL(do_settimeofday);
-
