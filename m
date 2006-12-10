From: akpm@osdl.org
Subject: - sched-improve-migration-accuracy-fix.patch removed from -mm tree
Date: Sun, 10 Dec 2006 00:23:38 -0800
Message-ID: <200612100823.kBA8Ncn6018776@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33063 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760398AbWLJIXr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 03:23:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: efault@gmx.de, dwm@meer.net, mm-commits@vger.kernel.org


The patch titled
     sched-improve-migration-accuracy fix
has been removed from the -mm tree.  Its filename was
     sched-improve-migration-accuracy-fix.patch

This patch was dropped because it was folded into sched-improve-migration-accuracy.patch

------------------------------------------------------
Subject: sched-improve-migration-accuracy fix
From: Mike Galbraith <efault@gmx.de>

Fix sleep_avg breakage induced by sched-improve-migration-accuracy.path
Use p->last_ran to fix sched_time buglet instead of p->timestamp.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Don Mullis <dwm@meer.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sched.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN kernel/sched.c~sched-improve-migration-accuracy-fix kernel/sched.c
--- a/kernel/sched.c~sched-improve-migration-accuracy-fix
+++ a/kernel/sched.c
@@ -2972,8 +2972,8 @@ EXPORT_PER_CPU_SYMBOL(kstat);
 static inline void
 update_cpu_clock(struct task_struct *p, struct rq *rq, unsigned long long now)
 {
-	p->sched_time += now - p->timestamp;
-	p->timestamp = rq->most_recent_timestamp = now;
+	p->sched_time += now - p->last_ran;
+	p->last_ran = rq->most_recent_timestamp = now;
 }
 
 /*
@@ -2986,7 +2986,7 @@ unsigned long long current_sched_time(co
 	unsigned long flags;
 
 	local_irq_save(flags);
-	ns = p->sched_time + sched_clock() - p->timestamp;
+	ns = p->sched_time + sched_clock() - p->last_ran;
 	local_irq_restore(flags);
 
 	return ns;
@@ -3499,10 +3499,11 @@ switch_tasks:
 	prev->sleep_avg -= run_time;
 	if ((long)prev->sleep_avg <= 0)
 		prev->sleep_avg = 0;
+	prev->timestamp = prev->last_ran = now;
 
 	sched_info_switch(prev, next);
 	if (likely(prev != next)) {
-		next->timestamp = prev->last_ran = now;
+		next->timestamp = now;
 		rq->nr_switches++;
 		rq->curr = next;
 		++*switch_count;
_

Patches currently in -mm which might be from efault@gmx.de are

origin.patch
sched-improve-migration-accuracy.patch
sched-improve-migration-accuracy-fix.patch
readahead-call-scheme.patch

