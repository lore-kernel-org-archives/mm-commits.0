From: akpm@linux-foundation.org
Subject: + time-clean-up-direct-xtime-usage-in-xen.patch added to -mm tree
Date: Thu, 04 Mar 2010 13:52:25 -0800
Message-ID: <201003042152.o24LqPYh032068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751561Ab0CDVwt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Mar 2010 16:52:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, jeremy@xensource.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     time: clean up direct xtime usage in xen
has been added to the -mm tree.  Its filename is
     time-clean-up-direct-xtime-usage-in-xen.patch

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
Subject: time: clean up direct xtime usage in xen
From: John Stultz <johnstul@us.ibm.com>

Cleanup xen's direct use of internal timekeeping values.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/time.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/xen/time.c~time-clean-up-direct-xtime-usage-in-xen arch/x86/xen/time.c
--- a/arch/x86/xen/time.c~time-clean-up-direct-xtime-usage-in-xen
+++ a/arch/x86/xen/time.c
@@ -475,6 +475,7 @@ void xen_timer_resume(void)
 __init void xen_time_init(void)
 {
 	int cpu = smp_processor_id();
+	struct timespec tp;
 
 	clocksource_register(&xen_clocksource);
 
@@ -486,9 +487,8 @@ __init void xen_time_init(void)
 	}
 
 	/* Set initial system time with full resolution */
-	xen_read_wallclock(&xtime);
-	set_normalized_timespec(&wall_to_monotonic,
-				-xtime.tv_sec, -xtime.tv_nsec);
+	xen_read_wallclock(&tp);
+	do_settimeofday(&tp);
 
 	setup_force_cpu_cap(X86_FEATURE_TSC);
 
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

origin.patch
linux-next.patch
arm-convert-arm-to-arch_gettimeoffset.patch
cs5535-clockevt-free-timer-in-irq-setup-error-path.patch
time-clean-up-warp_clock.patch
time-clean-up-direct-xtime-usage-in-xen.patch
genirq-warn-about-irqf_sharedirqf_disabled-at-the-right-place.patch
cris-convert-to-use-arch_gettimeoffset.patch
posix-cpu-timers-cleanup-rlimits-usage.patch
kernel-core-use-helpers-for-rlimits.patch
time-kill-off-config_generic_time.patch
xtensa-fix-unnecessary-setting-of-xtime.patch

