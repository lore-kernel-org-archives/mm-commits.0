From: akpm@linux-foundation.org
Subject: [merged] mm-sched-numa-fix-numa-balancing-when-sched_debug.patch
 removed from -mm tree
Date: Mon, 05 Aug 2013 12:05:47 -0700
Message-ID: <51fff78b.aVwXdVe7FLTvf/OS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab3HETFw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 15:05:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de, dave.kleikamp@oracle.com

Subject: [merged] mm-sched-numa-fix-numa-balancing-when-sched_debug.patch removed from -mm tree
To: dave.kleikamp@oracle.com,mgorman@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 12:05:47 -0700


The patch titled
     Subject: mm: sched: numa: fix NUMA balancing when !SCHED_DEBUG
has been removed from the -mm tree.  Its filename was
     mm-sched-numa-fix-numa-balancing-when-sched_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: mm: sched: numa: fix NUMA balancing when !SCHED_DEBUG

3105b86a ("mm: sched: numa: Control enabling and disabling of NUMA
balancing if !SCHED_DEBUG") defined numabalancing_enabled to control the
enabling and disabling of automatic NUMA balancing, but it is never used.

I believe the intention was to use this in place of sched_feat_numa(NUMA).

Currently, if SCHED_DEBUG is not defined, sched_feat_numa(NUMA) will never
be changed from the initial "false".

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/fair.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/sched/fair.c~mm-sched-numa-fix-numa-balancing-when-sched_debug kernel/sched/fair.c
--- a/kernel/sched/fair.c~mm-sched-numa-fix-numa-balancing-when-sched_debug
+++ a/kernel/sched/fair.c
@@ -851,7 +851,7 @@ void task_numa_fault(int node, int pages
 {
 	struct task_struct *p = current;
 
-	if (!sched_feat_numa(NUMA))
+	if (!numabalancing_enabled)
 		return;
 
 	/* FIXME: Allocate task-specific structure for placement policy here */
@@ -5786,7 +5786,7 @@ static void task_tick_fair(struct rq *rq
 		entity_tick(cfs_rq, se, queued);
 	}
 
-	if (sched_feat_numa(NUMA))
+	if (numabalancing_enabled)
 		task_tick_numa(rq, curr);
 
 	update_rq_runnable_avg(rq, 1);
_

Patches currently in -mm which might be from dave.kleikamp@oracle.com are


