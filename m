From: akpm@linux-foundation.org
Subject: + blackfin-convert-to-use-arch_gettimeoffset.patch added to -mm tree
Date: Thu, 23 Jul 2009 13:16:48 -0700
Message-ID: <200907232016.n6NKGmxZ012175@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43630 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751756AbZGWUQw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 16:16:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, vapier.adi@gmail.com


The patch titled
     blackfin: convert to use arch_gettimeoffset()
has been added to the -mm tree.  Its filename is
     blackfin-convert-to-use-arch_gettimeoffset.patch

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
Subject: blackfin: convert to use arch_gettimeoffset()
From: john stultz <johnstul@us.ibm.com>

Convert blackfin to use GENERIC_TIME via the arch_getoffset()
infrastructure, reducing the amount of arch specific code we need to
maintain.

I've taken my best swing at converting this, but I'm not 100% confident
I got it right. My cross-compiler is now out of date (gcc4.2) so I
wasn't able to  check if it compiled. Any assistance from arch
maintainers or testers to get this merged would be great.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/Kconfig       |   10 +++--
 arch/blackfin/kernel/time.c |   63 +---------------------------------
 2 files changed, 8 insertions(+), 65 deletions(-)

diff -puN arch/blackfin/Kconfig~blackfin-convert-to-use-arch_gettimeoffset arch/blackfin/Kconfig
--- a/arch/blackfin/Kconfig~blackfin-convert-to-use-arch_gettimeoffset
+++ a/arch/blackfin/Kconfig
@@ -229,7 +229,7 @@ endchoice
 
 config SMP
 	depends on BF561
-	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
 	bool "Symmetric multi-processing support"
 	---help---
 	  This enables support for systems with more than one CPU,
@@ -612,12 +612,10 @@ comment "Kernel Timer/Scheduler"
 source kernel/Kconfig.hz
 
 config GENERIC_TIME
-	bool "Generic time"
-	default y
+	def_bool y
 
 config GENERIC_CLOCKEVENTS
 	bool "Generic clock events"
-	depends on GENERIC_TIME
 	default y
 
 choice
@@ -652,6 +650,10 @@ config GPTMR0_CLOCKSOURCE
 	depends on GENERIC_CLOCKEVENTS
 	depends on !TICKSOURCE_GPTMR0
 
+config ARCH_USES_GETTIMEOFFSET
+	depends on !GENERIC_CLOCKEVENTS
+	def_bool y
+
 source kernel/time/Kconfig
 
 comment "Misc"
diff -puN arch/blackfin/kernel/time.c~blackfin-convert-to-use-arch_gettimeoffset arch/blackfin/kernel/time.c
--- a/arch/blackfin/kernel/time.c~blackfin-convert-to-use-arch_gettimeoffset
+++ a/arch/blackfin/kernel/time.c
@@ -81,11 +81,11 @@ time_sched_init(irqreturn_t(*timer_routi
 #endif
 }
 
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 /*
  * Should return useconds since last timer tick
  */
-#ifndef CONFIG_GENERIC_TIME
-static unsigned long gettimeoffset(void)
+u32 arch_gettimeoffset(void)
 {
 	unsigned long offset;
 	unsigned long clocks_per_jiffy;
@@ -184,65 +184,6 @@ void __init time_init(void)
 	time_sched_init(timer_interrupt);
 }
 
-#ifndef CONFIG_GENERIC_TIME
-void do_gettimeofday(struct timeval *tv)
-{
-	unsigned long flags;
-	unsigned long seq;
-	unsigned long usec, sec;
-
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-		usec = gettimeoffset();
-		sec = xtime.tv_sec;
-		usec += (xtime.tv_nsec / NSEC_PER_USEC);
-	}
-	while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
-
-	while (usec >= USEC_PER_SEC) {
-		usec -= USEC_PER_SEC;
-		sec++;
-	}
-
-	tv->tv_sec = sec;
-	tv->tv_usec = usec;
-}
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
-	/*
-	 * This is revolting. We need to set the xtime.tv_usec
-	 * correctly. However, the value in this location is
-	 * is value at the last tick.
-	 * Discover what correction gettimeofday
-	 * would have done, and then undo it!
-	 */
-	nsec -= (gettimeoffset() * NSEC_PER_USEC);
-
-	wtm_sec = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
-
-	ntp_clear();
-
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
-
-	return 0;
-}
-EXPORT_SYMBOL(do_settimeofday);
-#endif /* !CONFIG_GENERIC_TIME */
