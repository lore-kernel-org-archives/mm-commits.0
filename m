From: akpm@linux-foundation.org
Subject: + sched-align-rq-to-cacheline-boundary.patch added to -mm tree
Date: Mon, 09 Apr 2007 13:41:15 -0700
Message-ID: <200704092041.l39KfFlb022918@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59497 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965570AbXDIUlV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 9 Apr 2007 16:41:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: suresh.b.siddha@intel.com, kiran@scalex86.org, mingo@elte.hu, nickpiggin@yahoo.com.au


The patch titled
     sched: align rq to cacheline boundary
has been added to the -mm tree.  Its filename is
     sched-align-rq-to-cacheline-boundary.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched: align rq to cacheline boundary
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

Align the per cpu runqueue to the cacheline boundary.  This will minimize
the number of cachelines touched during remote wakeup.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~sched-align-rq-to-cacheline-boundary kernel/sched.c
--- a/kernel/sched.c~sched-align-rq-to-cacheline-boundary
+++ a/kernel/sched.c
@@ -304,7 +304,7 @@ struct rq {
 	struct lock_class_key rq_lock_key;
 };
 
-static DEFINE_PER_CPU(struct rq, runqueues);
+static DEFINE_PER_CPU(struct rq, runqueues) ____cacheline_aligned_in_smp;
 static DEFINE_MUTEX(sched_hotcpu_mutex);
 
 static inline int cpu_of(struct rq *rq)
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

x86_64-set-node_possible_map-at-runtime.patch
slab-x86_64-skip-cache_free_alien-on-non-numa.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
sched-dynticks-idle-load-balancing-v3.patch
sched-optimize-siblings-status-check-logic-in-wake_idle.patch
sched-align-rq-to-cacheline-boundary.patch
sched-dont-renice-kernel-threads.patch
sched-remove-sleepavg-from-proc.patch
sched-implement-staircase-deadline-cpu-scheduler.patch
sched-implement-staircase-deadline-cpu-scheduler-misc-fixes.patch
sched-remove-noninteractive-flag.patch
sched-document-sd-cpu-scheduler.patch
