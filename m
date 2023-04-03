Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76FFAC77B62
	for <mm-commits@archiver.kernel.org>; Mon,  3 Apr 2023 21:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbjDCVYg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Apr 2023 17:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbjDCVYM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Apr 2023 17:24:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379214ED1
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 14:23:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D05262C2D
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 21:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45AAC433EF;
        Mon,  3 Apr 2023 21:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680557000;
        bh=GonpkAgR+e9xWwBs5YPKbjN5id+MLP5VwViDqAZHTnY=;
        h=Date:To:From:Subject:From;
        b=VG52Eldp1kydilsxn/FBOIwaqOnso822RhzPIJqqVsWsTxpPYoFG8vAAmXEifAOkW
         kY6g9K+HN4q3B0wmoQgSftSDcGmKIlDiPnOnY5SzFn3c5UaGf0GKRx+BUlB3nXEtxY
         8nYvyUzee5Woo+XbF7C+6MRJRxDzpCPVu6sv96NY=
Date:   Mon, 03 Apr 2023 14:23:20 -0700
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tj@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mkoutny@suse.com, mhocko@suse.com,
        mhocko@kernel.org, lizefan.x@bytedance.com, josef@toxicpanda.com,
        hannes@cmpxchg.org, axboe@kernel.dk, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-sleep-during-flushing-stats-in-safe-contexts.patch added to mm-unstable branch
Message-Id: <20230403212320.C45AAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: sleep during flushing stats in safe contexts
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-sleep-during-flushing-stats-in-safe-contexts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-sleep-during-flushing-stats-in-safe-contexts.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: memcg: sleep during flushing stats in safe contexts
Date: Thu, 30 Mar 2023 19:17:58 +0000

Currently, all contexts that flush memcg stats do so with sleeping not
allowed.  Some of these contexts are perfectly safe to sleep in, such as
reading cgroup files from userspace or the background periodic flusher. 
Flushing is an expensive operation that scales with the number of cpus and
the number of cgroups in the system, so avoid doing it atomically where
possible.

Refactor the code to make mem_cgroup_flush_stats() non-atomic (aka
sleepable), and provide a separate atomic version.  The atomic version is
used in reclaim, refault, writeback, and in mem_cgroup_usage().  All other
code paths are left to use the non-atomic version.  This includes
callbacks for userspace reads and the periodic flusher.

Since refault is the only caller of mem_cgroup_flush_stats_ratelimited(),
change it to mem_cgroup_flush_stats_atomic_ratelimited().  Reclaim and
refault code paths are modified to do non-atomic flushing in separate
later patches -- so it will eventually be changed back to
mem_cgroup_flush_stats_ratelimited().

Link: https://lkml.kernel.org/r/20230330191801.1967435-6-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vasily Averin <vasily.averin@linux.dev>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    9 +++++--
 mm/memcontrol.c            |   45 ++++++++++++++++++++++++++++-------
 mm/vmscan.c                |    2 -
 mm/workingset.c            |    2 -
 4 files changed, 45 insertions(+), 13 deletions(-)

--- a/include/linux/memcontrol.h~memcg-sleep-during-flushing-stats-in-safe-contexts
+++ a/include/linux/memcontrol.h
@@ -1038,7 +1038,8 @@ static inline unsigned long lruvec_page_
 }
 
 void mem_cgroup_flush_stats(void);
-void mem_cgroup_flush_stats_ratelimited(void);
+void mem_cgroup_flush_stats_atomic(void);
+void mem_cgroup_flush_stats_atomic_ratelimited(void);
 
 void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			      int val);
@@ -1536,7 +1537,11 @@ static inline void mem_cgroup_flush_stat
 {
 }
 
-static inline void mem_cgroup_flush_stats_ratelimited(void)
+static inline void mem_cgroup_flush_stats_atomic(void)
+{
+}
+
+static inline void mem_cgroup_flush_stats_atomic_ratelimited(void)
 {
 }
 
--- a/mm/memcontrol.c~memcg-sleep-during-flushing-stats-in-safe-contexts
+++ a/mm/memcontrol.c
@@ -635,7 +635,7 @@ static inline void memcg_rstat_updated(s
 	}
 }
 
-static void __mem_cgroup_flush_stats(void)
+static void do_flush_stats(bool atomic)
 {
 	/*
 	 * We always flush the entire tree, so concurrent flushers can just
@@ -647,26 +647,46 @@ static void __mem_cgroup_flush_stats(voi
 		return;
 
 	WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);
-	cgroup_rstat_flush_atomic(root_mem_cgroup->css.cgroup);
+
+	if (atomic)
+		cgroup_rstat_flush_atomic(root_mem_cgroup->css.cgroup);
+	else
+		cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
+
 	atomic_set(&stats_flush_threshold, 0);
 	atomic_set(&stats_flush_ongoing, 0);
 }
 
+static bool should_flush_stats(void)
+{
+	return atomic_read(&stats_flush_threshold) > num_online_cpus();
+}
+
 void mem_cgroup_flush_stats(void)
 {
-	if (atomic_read(&stats_flush_threshold) > num_online_cpus())
-		__mem_cgroup_flush_stats();
+	if (should_flush_stats())
+		do_flush_stats(false);
 }
 
-void mem_cgroup_flush_stats_ratelimited(void)
+void mem_cgroup_flush_stats_atomic(void)
+{
+	if (should_flush_stats())
+		do_flush_stats(true);
+}
+
+void mem_cgroup_flush_stats_atomic_ratelimited(void)
 {
 	if (time_after64(jiffies_64, READ_ONCE(flush_next_time)))
-		mem_cgroup_flush_stats();
+		mem_cgroup_flush_stats_atomic();
 }
 
 static void flush_memcg_stats_dwork(struct work_struct *w)
 {
-	__mem_cgroup_flush_stats();
+	/*
+	 * Always flush here so that flushing in latency-sensitive paths is
+	 * as cheap as possible.
+	 */
+	do_flush_stats(false);
 	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, FLUSH_TIME);
 }
 
@@ -3686,9 +3706,12 @@ static unsigned long mem_cgroup_usage(st
 		 * done from irq context; use stale stats in this case.
 		 * Arguably, usage threshold events are not reliable on the root
 		 * memcg anyway since its usage is ill-defined.
+		 *
+		 * Additionally, other call paths through memcg_check_events()
+		 * disable irqs, so make sure we are flushing stats atomically.
 		 */
 		if (in_task())
-			mem_cgroup_flush_stats();
+			mem_cgroup_flush_stats_atomic();
 		val = memcg_page_state(memcg, NR_FILE_PAGES) +
 			memcg_page_state(memcg, NR_ANON_MAPPED);
 		if (swap)
@@ -4611,7 +4634,11 @@ void mem_cgroup_wb_stats(struct bdi_writ
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 	struct mem_cgroup *parent;
 
-	mem_cgroup_flush_stats();
+	/*
+	 * wb_writeback() takes a spinlock and calls
+	 * wb_over_bg_thresh()->mem_cgroup_wb_stats(). Do not sleep.
+	 */
+	mem_cgroup_flush_stats_atomic();
 
 	*pdirty = memcg_page_state(memcg, NR_FILE_DIRTY);
 	*pwriteback = memcg_page_state(memcg, NR_WRITEBACK);
--- a/mm/vmscan.c~memcg-sleep-during-flushing-stats-in-safe-contexts
+++ a/mm/vmscan.c
@@ -2861,7 +2861,7 @@ static void prepare_scan_count(pg_data_t
 	 * Flush the memory cgroup stats, so that we read accurate per-memcg
 	 * lruvec stats for heuristics.
 	 */
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats_atomic();
 
 	/*
 	 * Determine the scan balance between anon and file LRUs.
--- a/mm/workingset.c~memcg-sleep-during-flushing-stats-in-safe-contexts
+++ a/mm/workingset.c
@@ -462,7 +462,7 @@ void workingset_refault(struct folio *fo
 
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
 
-	mem_cgroup_flush_stats_ratelimited();
+	mem_cgroup_flush_stats_atomic_ratelimited();
 	/*
 	 * Compare the distance to the existing workingset size. We
 	 * don't activate pages that couldn't stay resident even if
_

Patches currently in -mm which might be from yosryahmed@google.com are

cgroup-rename-cgroup_rstat_flush_irqsafe-to-atomic.patch
memcg-rename-mem_cgroup_flush_stats_delayed-to-ratelimited.patch
memcg-do-not-flush-stats-in-irq-context.patch
memcg-replace-stats_flush_lock-with-an-atomic.patch
memcg-sleep-during-flushing-stats-in-safe-contexts.patch
workingset-memcg-sleep-when-flushing-stats-in-workingset_refault.patch
vmscan-memcg-sleep-when-flushing-stats-during-reclaim.patch
memcg-do-not-modify-rstat-tree-for-zero-updates.patch

