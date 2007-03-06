From: akpm@linux-foundation.org
Subject: - tick-management-dyntick--highres-functionality-fix-2.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:01:25 -0800
Message-ID: <200703060101.l2611PDv007060@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43873 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbXCFBBe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:01:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     dynticks: Fix one off jiffy update
has been removed from the -mm tree.  Its filename was
     tick-management-dyntick--highres-functionality-fix-2.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: dynticks: Fix one off jiffy update
From: Thomas Gleixner <tglx@linutronix.de>

The rework of the jiffy update code introduced a one off error, which
led to a one off accounting error for last_jiffy_update. This made
jiffies lag behind.

Noticed by Karsten Wiese (cpufreq_ondemand weirdness).

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/time/tick-sched.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/time/tick-sched.c~tick-management-dyntick--highres-functionality-fix-2 kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~tick-management-dyntick--highres-functionality-fix-2
+++ a/kernel/time/tick-sched.c
@@ -38,7 +38,7 @@ static ktime_t last_jiffies_update;
  */
 static void tick_do_update_jiffies64(ktime_t now)
 {
-	unsigned long ticks = 1;
+	unsigned long ticks = 0;
 	ktime_t delta;
 
 	/* Reevalute with xtime_lock held */
@@ -55,12 +55,12 @@ static void tick_do_update_jiffies64(kti
 		if (unlikely(delta.tv64 >= tick_period.tv64)) {
 			s64 incr = ktime_to_ns(tick_period);
 
-			ticks += ktime_divns(delta, incr);
+			ticks = ktime_divns(delta, incr);
 
 			last_jiffies_update = ktime_add_ns(last_jiffies_update,
 							   incr * ticks);
 		}
-		do_timer(ticks);
+		do_timer(++ticks);
 	}
 	write_sequnlock(&xtime_lock);
 }
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
bugfix-dont-use-the-tsc-in-sched_clock-if-unstable.patch
cleanup-unify-tsc_unstable-and-tsc_disable.patch
possible-bugfix-make-dmi_mark_tsc_unstable-call-mark_tsc_unstable.patch
log-reason-why-tsc-was-marked-unstable.patch
optimize-timespec_trunc.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
