Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1094AC76196
	for <mm-commits@archiver.kernel.org>; Mon,  3 Apr 2023 21:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbjDCVY6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Apr 2023 17:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233763AbjDCVY1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Apr 2023 17:24:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C27525B
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 14:23:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 646C361E06
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 21:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C00C433D2;
        Mon,  3 Apr 2023 21:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680557003;
        bh=QOnTBvpP0FXlHbX3Aa/A/jkL1zFQ6PLnSMlSweZfFtc=;
        h=Date:To:From:Subject:From;
        b=vK0tZgKFy530ef7weP/pKIpFB/Z0Xk1CZf0bBwFYnlmGd2XiVggXeSVJT2uE4lS8Q
         cfXfcsq3x5j8WzU1yYtBnRKiufLnS3uYU31CFXmuNHGKeyRlbcC2K75NoEApu8xrmK
         2QyvVIN5d1mUr2FHUdyVP+UrUmbSsL62hJJ+VsTA=
Date:   Mon, 03 Apr 2023 14:23:22 -0700
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tj@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mkoutny@suse.com, mhocko@suse.com,
        mhocko@kernel.org, lizefan.x@bytedance.com, josef@toxicpanda.com,
        hannes@cmpxchg.org, axboe@kernel.dk, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + workingset-memcg-sleep-when-flushing-stats-in-workingset_refault.patch added to mm-unstable branch
Message-Id: <20230403212323.B7C00C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: workingset: memcg: sleep when flushing stats in workingset_refault()
has been added to the -mm mm-unstable branch.  Its filename is
     workingset-memcg-sleep-when-flushing-stats-in-workingset_refault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/workingset-memcg-sleep-when-flushing-stats-in-workingset_refault.patch

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

cgroup-rename-cgroup_rstat_flush_irqsafe-to-atomic.patch
memcg-rename-mem_cgroup_flush_stats_delayed-to-ratelimited.patch
memcg-do-not-flush-stats-in-irq-context.patch
memcg-replace-stats_flush_lock-with-an-atomic.patch
memcg-sleep-during-flushing-stats-in-safe-contexts.patch
workingset-memcg-sleep-when-flushing-stats-in-workingset_refault.patch
vmscan-memcg-sleep-when-flushing-stats-during-reclaim.patch
memcg-do-not-modify-rstat-tree-for-zero-updates.patch

