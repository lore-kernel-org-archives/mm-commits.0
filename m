From: akpm@linux-foundation.org
Subject: + mm-sched-numa-fix-numa-balancing-when-sched_debug.patch added
 to -mm tree
Date: Thu, 11 Jul 2013 15:05:44 -0700
Message-ID: <51df2c38.hhTC7ycqlNRfovKH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747Ab3GKWFp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Jul 2013 18:05:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de, dave.kleikamp@oracle.com

Subject: + mm-sched-numa-fix-numa-balancing-when-sched_debug.patch added to -mm tree
To: dave.kleikamp@oracle.com,mgorman@suse.de
From: akpm@linux-foundation.org
Date: Thu, 11 Jul 2013 15:05:44 -0700


The patch titled
     Subject: mm: sched: numa: fix NUMA balancing when !SCHED_DEBUG
has been added to the -mm tree.  Its filename is
     mm-sched-numa-fix-numa-balancing-when-sched_debug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sched-numa-fix-numa-balancing-when-sched_debug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sched-numa-fix-numa-balancing-when-sched_debug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
linux-next.patch
mm-sched-numa-fix-numa-balancing-when-sched_debug.patch

