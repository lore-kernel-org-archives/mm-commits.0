From: akpm@linux-foundation.org
Subject: + clocksource-fix-thinko-in-watchdog-selection.patch added to -mm tree
Date: Sun, 25 Mar 2007 13:45:20 -0800
Message-ID: <200703252145.l2PLjKHY003581@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59186 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbXCYVv7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 17:51:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, bunk@stusta.de, johnstul@us.ibm.com, mingo@elte.hu


The patch titled
     clocksource: fix thinko in watchdog selection
has been added to the -mm tree.  Its filename is
     clocksource-fix-thinko-in-watchdog-selection.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
time-fix-formatting-in-proc-timer_list.patch
correct-slow-acpi_pm-rating.patch
i386-prevent-early-access-to-tsc-to-avoid-crash-on.patch
dynticks-fix-hrtimer-rounding-error-in.patch
clocksource-fix-thinko-in-watchdog-selection.patch
git-ieee1394.patch
log-reason-why-tsc-was-marked-unstable.patch
optimize-timespec_trunc.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
mm-only-hrtimers-debug-patch.patch
