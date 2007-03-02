From: akpm@linux-foundation.org
Subject: - fix-posix-cpu-timer-breakage-caused-by-stale-p-last_ran.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:06:22 -0800
Message-ID: <200703020506.l2256Mwd000790@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42429 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422782AbXCBFHx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:07:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mingo@elte.hu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Fix posix-cpu-timer breakage caused by stale p->last_ran value
has been removed from the -mm tree.  Its filename was
     fix-posix-cpu-timer-breakage-caused-by-stale-p-last_ran.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix posix-cpu-timer breakage caused by stale p->last_ran value
From: Thomas Gleixner <tglx@linutronix.de>

Problem description at:
http://bugzilla.kernel.org/show_bug.cgi?id=8048

Commit b18ec80396834497933d77b81ec0918519f4e2a7
    [PATCH] sched: improve migration accuracy
optimized the scheduler time calculations, but broke posix-cpu-timers.

The problem is that the p->last_ran value is not updated after a context
switch.  So a subsequent call to current_sched_time() calculates with a
stale p->last_ran value, i.e.  accounts the full time, which the task was
scheduled away.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~fix-posix-cpu-timer-breakage-caused-by-stale-p-last_ran kernel/sched.c
--- a/kernel/sched.c~fix-posix-cpu-timer-breakage-caused-by-stale-p-last_ran
+++ a/kernel/sched.c
@@ -3566,7 +3566,7 @@ switch_tasks:
 
 	sched_info_switch(prev, next);
 	if (likely(prev != next)) {
-		next->timestamp = now;
+		next->timestamp = next->last_ran = now;
 		rq->nr_switches++;
 		rq->curr = next;
 		++*switch_count;
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-block.patch
log-reason-why-tsc-was-marked-unstable.patch
clocksource-init-adjustments-fix-bug-7426.patch
timer-run-calc_load-halfway-through-each-round_jiffies.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
