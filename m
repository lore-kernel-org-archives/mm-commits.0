From: akpm@linux-foundation.org
Subject: + sched-optimize-siblings-status-check-logic-in-wake_idle.patch added to -mm tree
Date: Mon, 05 Mar 2007 19:15:44 -0800
Message-ID: <200703060315.l263FiVA010415@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48626 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933896AbXCFDPx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 22:15:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: suresh.b.siddha@intel.com, mingo@elte.hu, nickpiggin@yahoo.com.au


The patch titled
     sched: optimize siblings status check logic in wake_idle()
has been added to the -mm tree.  Its filename is
     sched-optimize-siblings-status-check-logic-in-wake_idle.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN kernel/sched.c~sched-optimize-siblings-status-check-logic-in-wake_idle kernel/sched.c
--- a/kernel/sched.c~sched-optimize-siblings-status-check-logic-in-wake_idle
+++ a/kernel/sched.c
@@ -1407,7 +1407,16 @@ static int wake_idle(int cpu, struct tas
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

sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
sched-optimize-siblings-status-check-logic-in-wake_idle.patch
