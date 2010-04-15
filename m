From: akpm@linux-foundation.org
Subject: [merged] time-clean-up-direct-xtime-usage-in-xen.patch removed from -mm tree
Date: Thu, 15 Apr 2010 11:38:40 -0400
Message-ID: <201004151840.o3FIeIiO024409@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754848Ab0DOSqW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Apr 2010 14:46:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, jeremy@xensource.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     time: clean up direct xtime usage in xen
has been removed from the -mm tree.  Its filename was
     time-clean-up-direct-xtime-usage-in-xen.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -476,6 +476,7 @@ void xen_timer_resume(void)
 __init void xen_time_init(void)
 {
 	int cpu = smp_processor_id();
+	struct timespec tp;
 
 	clocksource_register(&xen_clocksource);
 
@@ -487,9 +488,8 @@ __init void xen_time_init(void)
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

linux-next.patch
arch-x86-kernel-hpetc-make-the-hpet-compare-register-read-back-failed-warning-conditional-on-the-hpet=verbose-boot-option.patch
time-remove-xtime_cache-take-2.patch
hangcheck-timer-fix-x86_32-bugs.patch
time-kill-off-config_generic_time.patch

