From: akpm@linux-foundation.org
Subject: [merged] sched-fix-compiler-warning-about-declared-inline-after-use.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:32:56 -0700
Message-ID: <20120326193256.817D4A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:45421 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab2CZTc6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:32:58 -0400
Received: by mail-fa0-f74.google.com with SMTP id a19so298511faa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:32:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, akpm@linux-foundation.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: sched: fix compiler warning about declared inline after use
has been removed from the -mm tree.  Its filename was
     sched-fix-compiler-warning-about-declared-inline-after-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: sched: fix compiler warning about declared inline after use

kernel/sched/fair.c:420: warning: 'account_cfs_rq_runtime' declared inline =
after being called
kernel/sched/fair.c:420: warning: previous declaration of 'account_cfs_rq_r=
untime' was here
kernel/sched/fair.c:1165: warning: 'return_cfs_rq_runtime' declared inline =
after being called
kernel/sched/fair.c:1165: warning: previous declaration of 'return_cfs_rq_r=
untime' was here

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/fair.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN kernel/sched/fair.c~sched-fix-compiler-warning-about-declared-inline-after-use kernel/sched/fair.c
--- a/kernel/sched/fair.c~sched-fix-compiler-warning-about-declared-inline-after-use
+++ a/kernel/sched/fair.c
@@ -416,8 +416,8 @@ find_matching_se(struct sched_entity **s
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
-static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
-				   unsigned long delta_exec);
+static __always_inline
+void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, unsigned long delta_exec);
 
 /**************************************************************
  * Scheduling class tree data structure manipulation methods:
@@ -1162,7 +1162,7 @@ static void clear_buddies(struct cfs_rq 
 		__clear_buddies_skip(se);
 }
 
-static void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
+static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
 
 static void
 dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
@@ -1546,8 +1546,8 @@ static void __account_cfs_rq_runtime(str
 		resched_task(rq_of(cfs_rq)->curr);
 }
 
-static __always_inline void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
-						   unsigned long delta_exec)
+static __always_inline
+void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, unsigned long delta_exec)
 {
 	if (!cfs_bandwidth_used() || !cfs_rq->runtime_enabled)
 		return;
@@ -2073,11 +2073,11 @@ void unthrottle_offline_cfs_rqs(struct r
 }
 
 #else /* CONFIG_CFS_BANDWIDTH */
-static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
-				     unsigned long delta_exec) {}
+static __always_inline
+void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, unsigned long delta_exec) {}
 static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq) {}
-static void return_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
+static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 
 static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
 {
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
linux-next.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
smp-introduce-a-generic-on_each_cpu_mask-function.patch
arm-move-arm-over-to-generic-on_each_cpu_mask.patch
tile-move-tile-to-use-generic-on_each_cpu_mask.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch
fs-only-send-ipi-to-invalidate-lru-bh-when-needed.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch
ipc-semc-alternatives-to-preempt_disable.patch

