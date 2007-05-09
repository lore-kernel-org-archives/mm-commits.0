From: akpm@linux-foundation.org
Subject: - sched-optimize-siblings-status-check-logic-in-wake_idle.patch removed from -mm tree
Date: Tue, 08 May 2007 19:53:40 -0700
Message-ID: <200705090253.l492retK009724@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032097AbXEICxr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:53:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suresh.b.siddha@intel.com, mingo@elte.hu, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     sched: optimize siblings status check logic in wake_idle()
has been removed from the -mm tree.  Its filename was
     sched-optimize-siblings-status-check-logic-in-wake_idle.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: optimize siblings status check logic in wake_idle()
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

When a logical cpu 'x' already has more than one process running, then most
likely the siblings of that cpu 'x' must be busy.  Otherwise the idle
siblings would have likely(in most of the scenarios) picked up the extra
load making the load on 'x' atmost one.

Use this logic to eliminate the siblings status check and minimize the cache
misses encountered on a heavily loaded system.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN kernel/sched.c~sched-optimize-siblings-status-check-logic-in-wake_idle kernel/sched.c
--- a/kernel/sched.c~sched-optimize-siblings-status-check-logic-in-wake_idle
+++ a/kernel/sched.c
@@ -1406,7 +1406,16 @@ static int wake_idle(int cpu, struct tas
 	struct sched_domain *sd;
 	int i;
 
-	if (idle_cpu(cpu))
+	/*
+	 * If it is idle, then it is the best cpu to run this task.
+	 *
+	 * This cpu is also the best, if it has more than one task already.
+	 * Siblings must be also busy(in most cases) as they didn't already
+	 * pickup the extra load from this cpu and hence we need not check
+	 * sibling runqueue info. This will avoid the checks and cache miss
+	 * penalities associated with that.
+	 */
+	if (idle_cpu(cpu) || cpu_rq(cpu)->nr_running > 1)
 		return cpu;
 
 	for_each_domain(cpu, sd) {
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

origin.patch
git-ia64.patch
