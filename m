From: akpm@osdl.org
Subject: - sched-optimize-activate_task-for-rt-task.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:54:43 -0800
Message-ID: <200612130654.kBD6shet030567@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57666 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965011AbWLMGyu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:54:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenneth.w.chen@intel.com, mingo@elte.hu, nickpiggin@yahoo.com.au, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     sched: optimize activate_task for RT task
has been removed from the -mm tree.  Its filename was
     sched-optimize-activate_task-for-rt-task.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: optimize activate_task for RT task
From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>

RT task does not participate in interactiveness priority and thus shouldn't
be bothered with timestamp and p->sleep_type manipulation when task is
being put on run queue.  Bypass all of the them with a single if (rt_task)
test.

Signed-off-by: Ken Chen <kenneth.w.chen@intel.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sched.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN kernel/sched.c~sched-optimize-activate_task-for-rt-task kernel/sched.c
--- a/kernel/sched.c~sched-optimize-activate_task-for-rt-task
+++ a/kernel/sched.c
@@ -940,6 +940,9 @@ static void activate_task(struct task_st
 {
 	unsigned long long now;
 
+	if (rt_task(p))
+		goto out;
+
 	now = sched_clock();
 #ifdef CONFIG_SMP
 	if (!local) {
@@ -961,8 +964,7 @@ static void activate_task(struct task_st
 				     (now - p->timestamp) >> 20);
 	}
 
-	if (!rt_task(p))
-		p->prio = recalc_task_prio(p, now);
+	p->prio = recalc_task_prio(p, now);
 
 	/*
 	 * This checks to make sure it's not an uninterruptible task
@@ -987,7 +989,7 @@ static void activate_task(struct task_st
 		}
 	}
 	p->timestamp = now;
-
+out:
 	__activate_task(p, rq);
 }
 
_

Patches currently in -mm which might be from kenneth.w.chen@intel.com are

origin.patch
optimize-o_direct-on-block-device-v3.patch
optimize-o_direct-on-block-device-v3-tweak.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch

