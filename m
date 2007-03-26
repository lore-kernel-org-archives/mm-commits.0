From: akpm@linux-foundation.org
Subject: - clocksource-fix-thinko-in-watchdog-selection.patch removed from -mm tree
Date: Sun, 25 Mar 2007 17:05:58 -0800
Message-ID: <200703260105.l2Q15w6q008746@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38649 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933426AbXCZBHs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 21:07:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, bunk@stusta.de, johnstul@us.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     clocksource: fix thinko in watchdog selection
has been removed from the -mm tree.  Its filename was
     clocksource-fix-thinko-in-watchdog-selection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: clocksource: fix thinko in watchdog selection
From: Thomas Gleixner <tglx@linutronix.de>

The watchdog implementation excludes low res / non continuous clocksources
from being selected as a watchdog reference unintentionally.

Allow using jiffies/PIT as a watchdog reference as long as no better
clocksource is available.  This is necessary to detect TSC breakage on
systems, which have no pmtimer/hpet.

The main goal of the initial patch (preventing to switch to highres/nohz
when no reliable fallback clocksource is available) is still guaranteed by
the checks in clocksource_watchdog().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/clocksource.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/time/clocksource.c~clocksource-fix-thinko-in-watchdog-selection kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~clocksource-fix-thinko-in-watchdog-selection
+++ a/kernel/time/clocksource.c
@@ -151,7 +151,8 @@ static void clocksource_check_watchdog(s
 			watchdog_timer.expires = jiffies + WATCHDOG_INTERVAL;
 			add_timer(&watchdog_timer);
 		}
-	} else if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS) {
+	} else {
+		if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS)
 			cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
 
 		if (!watchdog || cs->rating > watchdog->rating) {
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
