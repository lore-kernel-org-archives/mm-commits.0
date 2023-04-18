Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4259C77B76
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjDRXex (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbjDRXeS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:34:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C32A275
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B19F0639E7
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1788EC4339B;
        Tue, 18 Apr 2023 23:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860847;
        bh=enAHx1z0eEaGkUEzfCh51qUN0mnqnHzjOCAuYbxzJ3A=;
        h=Date:To:From:Subject:From;
        b=PJtvZrhiCihjnf3EAa19lul4nu14QE+//5qFTQkQgz+FsOI8QYwJoFR/diVHPKVVQ
         577GM77b6fmZSMD6GKVX4uALSZROrCAhZ09ZJnAzV5kr1C3jVZVdGQ8XHW0E3OEBhF
         rqUmm26UTimFLt2eXbRLv1T+jfItg6TxhvngSibo=
Date:   Tue, 18 Apr 2023 16:34:06 -0700
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tj@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mkoutny@suse.com, mhocko@suse.com,
        mhocko@kernel.org, lizefan.x@bytedance.com, josef@toxicpanda.com,
        hannes@cmpxchg.org, axboe@kernel.dk, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] workingset-memcg-sleep-when-flushing-stats-in-workingset_refault.patch removed from -mm tree
Message-Id: <20230418233407.1788EC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: workingset: memcg: sleep when flushing stats in workingset_refault()
has been removed from the -mm tree.  Its filename was
     workingset-memcg-sleep-when-flushing-stats-in-workingset_refault.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: workingset: memcg: sleep when flushing stats in workingset_refault()
Date: Thu, 30 Mar 2023 19:17:59 +0000

In workingset_refault(), we call
mem_cgroup_flush_stats_atomic_ratelimited() to read accurate stats within
an RCU read section and with sleeping disallowed.  Move the call above the
RCU read section to make it non-atomic.

Flushing is an expensive operation that scales with the number of cpus and
the number of cgroups in the system, so avoid doing it atomically where
possible.

Since workingset_refault() is the only caller of
mem_cgroup_flush_stats_atomic_ratelimited(), just make it non-atomic, and
rename it to mem_cgroup_flush_stats_ratelimited().

Link: https://lkml.kernel.org/r/20230330191801.1967435-7-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
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

 include/linux/memcontrol.h |    4 ++--
 mm/memcontrol.c            |    4 ++--
 mm/workingset.c            |    5 +++--
 3 files changed, 7 insertions(+), 6 deletions(-)

--- a/include/linux/memcontrol.h~workingset-memcg-sleep-when-flushing-stats-in-workingset_refault
+++ a/include/linux/memcontrol.h
@@ -1039,7 +1039,7 @@ static inline unsigned long lruvec_page_
 
 void mem_cgroup_flush_stats(void);
 void mem_cgroup_flush_stats_atomic(void);
-void mem_cgroup_flush_stats_atomic_ratelimited(void);
+void mem_cgroup_flush_stats_ratelimited(void);
 
 void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			      int val);
@@ -1541,7 +1541,7 @@ static inline void mem_cgroup_flush_stat
 {
 }
 
-static inline void mem_cgroup_flush_stats_atomic_ratelimited(void)
+static inline void mem_cgroup_flush_stats_ratelimited(void)
 {
 }
 
--- a/mm/memcontrol.c~workingset-memcg-sleep-when-flushing-stats-in-workingset_refault
+++ a/mm/memcontrol.c
@@ -674,10 +674,10 @@ void mem_cgroup_flush_stats_atomic(void)
 		do_flush_stats(true);
 }
 
-void mem_cgroup_flush_stats_atomic_ratelimited(void)
+void mem_cgroup_flush_stats_ratelimited(void)
 {
 	if (time_after64(jiffies_64, READ_ONCE(flush_next_time)))
-		mem_cgroup_flush_stats_atomic();
+		mem_cgroup_flush_stats();
 }
 
 static void flush_memcg_stats_dwork(struct work_struct *w)
--- a/mm/workingset.c~workingset-memcg-sleep-when-flushing-stats-in-workingset_refault
+++ a/mm/workingset.c
@@ -406,6 +406,9 @@ void workingset_refault(struct folio *fo
 	unpack_shadow(shadow, &memcgid, &pgdat, &eviction, &workingset);
 	eviction <<= bucket_order;
 
+	/* Flush stats (and potentially sleep) before holding RCU read lock */
+	mem_cgroup_flush_stats_ratelimited();
+
 	rcu_read_lock();
 	/*
 	 * Look up the memcg associated with the stored ID. It might
@@ -461,8 +464,6 @@ void workingset_refault(struct folio *fo
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
-
-	mem_cgroup_flush_stats_atomic_ratelimited();
 	/*
 	 * Compare the distance to the existing workingset size. We
 	 * don't activate pages that couldn't stay resident even if
_

Patches currently in -mm which might be from yosryahmed@google.com are

vmscan-memcg-sleep-when-flushing-stats-during-reclaim.patch
memcg-do-not-modify-rstat-tree-for-zero-updates.patch
memcg-page_cgroup_ino-get-memcg-from-the-pages-folio.patch
mm-vmscan-ignore-non-lru-based-reclaim-in-memcg-reclaim.patch
mm-vmscan-move-set_task_reclaim_state-near-flush_reclaim_state.patch
mm-vmscan-refactor-updating-current-reclaim_state.patch

