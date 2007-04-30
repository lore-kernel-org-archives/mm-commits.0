From: akpm@linux-foundation.org
Subject: - sched-fix-idle-load-balancing-in-softirqd-context-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 13:20:26 -0700
Message-ID: <200704302020.l3UKKRjX014052@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946757AbXD3UVY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 16:21:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kernel@kolivas.org, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     sched: fix idle at tick
has been removed from the -mm tree.  Its filename was
     sched-fix-idle-load-balancing-in-softirqd-context-fix.patch

This patch was dropped because it was folded into sched-fix-idle-load-balancing-in-softirqd-context.patch

------------------------------------------------------
Subject: sched: fix idle at tick
From: Con Kolivas <kernel@kolivas.org>

Fix reverse idle at tick logic.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~sched-fix-idle-load-balancing-in-softirqd-context-fix kernel/sched.c
--- a/kernel/sched.c~sched-fix-idle-load-balancing-in-softirqd-context-fix
+++ a/kernel/sched.c
@@ -3220,7 +3220,7 @@ void scheduler_tick(void)
 
 	update_cpu_clock(p, rq, now);
 
-	if (idle_at_tick)
+	if (!idle_at_tick)
 		task_running_tick(rq, p);
 #ifdef CONFIG_SMP
 	update_load(rq);
_

Patches currently in -mm which might be from kernel@kolivas.org are

sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
swap-prefetch-avoid-repeating-entry.patch
