From: akpm@linux-foundation.org
Subject: - i386-prevent-early-access-to-tsc-to-avoid-crash-on.patch removed from -mm tree
Date: Sun, 25 Mar 2007 17:05:52 -0800
Message-ID: <200703260105.l2Q15qlD008738@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38576 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933409AbXCZBGG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 21:06:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     i386: prevent early access to TSC to avoid crash on TSCless systems
has been removed from the -mm tree.  Its filename was
     i386-prevent-early-access-to-tsc-to-avoid-crash-on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: prevent early access to TSC to avoid crash on TSCless systems
From: Thomas Gleixner <tglx@linutronix.de>

commit f9690982b8c2f9a2c65acdc113e758ec356676a3 removed the check for
cpu_khz from sched_clock(), which prevented early access to the TSC by non
obvious magic.

This is harmless as long as the CPU has a TSC.  On TSCless systems this
results in an illegal instruction trap.

Replace tsc_disabled and tsc_unstable by tsc_enabled, which is only set
when the tsc is available and not unstable.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/tsc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/tsc.c~i386-prevent-early-access-to-tsc-to-avoid-crash-on arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~i386-prevent-early-access-to-tsc-to-avoid-crash-on
+++ a/arch/i386/kernel/tsc.c
@@ -18,6 +18,8 @@
 
 #include "mach_timer.h"
 
+static int tsc_enabled;
+
 /*
  * On some systems the TSC frequency does not
  * change with the cpu frequency. So we need
@@ -105,7 +107,7 @@ unsigned long long sched_clock(void)
 	/*
 	 * Fall back to jiffies if there's no TSC available:
 	 */
-	if (tsc_unstable || unlikely(tsc_disable))
+	if (unlikely(!tsc_enabled))
 		/* No locking but a rare wrong value is not a big deal: */
 		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
 
@@ -283,6 +285,7 @@ void mark_tsc_unstable(void)
 {
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
+		tsc_enabled = 0;
 		/* Can be called before registration */
 		if (clocksource_tsc.mult)
 			clocksource_change_rating(&clocksource_tsc, 0);
@@ -383,7 +386,9 @@ void __init tsc_init(void)
 	if (check_tsc_unstable()) {
 		clocksource_tsc.rating = 0;
 		clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
-	}
+	} else
+		tsc_enabled = 1;
+
 	clocksource_register(&clocksource_tsc);
 
 	return;
_

Patches currently in -mm which might be from tglx@linutronix.de are

correct-slow-acpi_pm-rating.patch
ntp-avoid-time_offset-overflows.patch
ntp-avoid-time_offset-overflows-fix.patch
git-ieee1394.patch
log-reason-why-tsc-was-marked-unstable.patch
optimize-timespec_trunc.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
mm-only-hrtimers-debug-patch.patch
