From: akpm@linux-foundation.org
Subject: - sched-align-rq-to-cacheline-boundary.patch removed from -mm tree
Date: Tue, 08 May 2007 19:53:46 -0700
Message-ID: <200705090253.l492rktY009732@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032238AbXEICxz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:53:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suresh.b.siddha@intel.com, kiran@scalex86.org, mingo@elte.hu, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     sched: align rq to cacheline boundary
has been removed from the -mm tree.  Its filename was
     sched-align-rq-to-cacheline-boundary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: align rq to cacheline boundary
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

Align the per cpu runqueue to the cacheline boundary.  This will minimize
the number of cachelines touched during remote wakeup.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~sched-align-rq-to-cacheline-boundary kernel/sched.c
--- a/kernel/sched.c~sched-align-rq-to-cacheline-boundary
+++ a/kernel/sched.c
@@ -304,7 +304,7 @@ struct rq {
 	struct lock_class_key rq_lock_key;
 };
 
-static DEFINE_PER_CPU(struct rq, runqueues);
+static DEFINE_PER_CPU(struct rq, runqueues) ____cacheline_aligned_in_smp;
 
 static inline int cpu_of(struct rq *rq)
 {
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

origin.patch
git-ia64.patch
