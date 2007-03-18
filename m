From: akpm@linux-foundation.org
Subject: - hrtimer-fixup-unlocked-access-to-wall_to_monotonic.patch removed from -mm tree
Date: Sun, 18 Mar 2007 01:09:35 -0800
Message-ID: <200703180909.l2I99ZG5020018@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60521 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183AbXCRJKj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:10:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     hrtimer: fix up unlocked access to wall_to_monotonic
has been removed from the -mm tree.  Its filename was
     hrtimer-fixup-unlocked-access-to-wall_to_monotonic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hrtimer: fix up unlocked access to wall_to_monotonic
From: Thomas Gleixner <tglx@linutronix.de>

commit f4304ab21513b834c8fe3403927c60c2b81a72d7 (HZ free NTP) moved the
access to wall_to_monotonic in hrtimer_get_softirq_time() out of the
xtime_lock protection.

Move it back into the seq_lock section.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hrtimer.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/hrtimer.c~hrtimer-fixup-unlocked-access-to-wall_to_monotonic kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimer-fixup-unlocked-access-to-wall_to_monotonic
+++ a/kernel/hrtimer.c
@@ -135,7 +135,7 @@ EXPORT_SYMBOL_GPL(ktime_get_ts);
 static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
 {
 	ktime_t xtim, tomono;
-	struct timespec xts;
+	struct timespec xts, tom;
 	unsigned long seq;
 
 	do {
@@ -145,10 +145,11 @@ static void hrtimer_get_softirq_time(str
 #else
 		xts = xtime;
 #endif
+		tom = wall_to_monotonic;
 	} while (read_seqretry(&xtime_lock, seq));
 
 	xtim = timespec_to_ktime(xts);
-	tomono = timespec_to_ktime(wall_to_monotonic);
+	tomono = timespec_to_ktime(tom);
 	base->clock_base[CLOCK_REALTIME].softirq_time = xtim;
 	base->clock_base[CLOCK_MONOTONIC].softirq_time =
 		ktime_add(xtim, tomono);
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
i386-trust-the-pm-timer-calibration-of-the-local-apic.patch
git-ieee1394.patch
log-reason-why-tsc-was-marked-unstable.patch
optimize-timespec_trunc.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
