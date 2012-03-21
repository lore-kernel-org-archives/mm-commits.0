From: akpm@linux-foundation.org
Subject: + sched-fix-compiler-warning-about-declared-inline-after-use.patch added to -mm tree
Date: Wed, 21 Mar 2012 13:07:16 -0700
Message-ID: <20120321200717.49BB4A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:36191 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab2CUUHS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Mar 2012 16:07:18 -0400
Received: by ghbz15 with SMTP id z15so236528ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Mar 2012 13:07:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, akpm@linux-foundation.org, mingo@elte.hu


The patch titled
     Subject: sched: fix compiler warning about declared inline after use
has been added to the -mm tree.  Its filename is
     sched-fix-compiler-warning-about-declared-inline-after-use.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: sched: fix compiler warning about declared inline after use

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
sched-fix-compiler-warning-about-declared-inline-after-use.patch
linux-next.patch
hugetlbfs-lockdep-annotate-root-inode-properly.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
rmap-anon_vma_prepare-reduce-code-duplication-by-calling-anon_vma_chain_link.patch
mm-update-stale-lock-ordering-comment-for-memory-failurec.patch
cpuset-mm-reduce-large-amounts-of-memory-barrier-related-damage-v3.patch
watchdog-make-sure-the-watchdog-thread-gets-cpu-on-loaded-system.patch
kernel-watchdogc-convert-to-pr_foo.patch
kernel-watchdogc-add-comment-to-watchdog-exit-path.patch
smp-start-up-non-boot-cpus-asynchronously.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
checkpatch-warn-on-use-of-yield.patch
epoll-comment-the-funky-ifdef.patch
proc-speedup-proc-stat-handling.patch
procfs-add-num_to_str-to-speed-up-proc-stat.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
smp-introduce-a-generic-on_each_cpu_mask-function.patch
arm-move-arm-over-to-generic-on_each_cpu_mask.patch
tile-move-tile-to-use-generic-on_each_cpu_mask.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch
fs-only-send-ipi-to-invalidate-lru-bh-when-needed.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch
ipc-semc-alternatives-to-preempt_disable.patch

