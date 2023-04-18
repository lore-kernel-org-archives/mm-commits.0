Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FE79C77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbjDRXel (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbjDRXeK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:34:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791157AA1
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55554639F4
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFF5C433EF;
        Tue, 18 Apr 2023 23:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860842;
        bh=I3RVaaUhih98ArReZNKVatQNbOdtQtaClVVvQg9fB0E=;
        h=Date:To:From:Subject:From;
        b=hKUoBEvtSn8UJ/dMhUZvwQvkl9cdY1gQ+cd5q3PKEvdL1IZ7/JDhjm+O730JjF+eo
         9LZVNM+OJhIpFJoisZn5tgaL71O86xeBmk+Cw6/Dz4Bo7ag2pwp3OmBOgFI6OGizR7
         kkK7mntPzr+FttbHF8PmndoqLDX9GT/iOpDmVrQA=
Date:   Tue, 18 Apr 2023 16:34:02 -0700
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tj@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mkoutny@suse.com, mhocko@suse.com,
        mhocko@kernel.org, lizefan.x@bytedance.com, josef@toxicpanda.com,
        hannes@cmpxchg.org, axboe@kernel.dk, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-rename-mem_cgroup_flush_stats_delayed-to-ratelimited.patch removed from -mm tree
Message-Id: <20230418233402.ACFF5C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg: rename mem_cgroup_flush_stats_"delayed" to "ratelimited"
has been removed from the -mm tree.  Its filename was
     memcg-rename-mem_cgroup_flush_stats_delayed-to-ratelimited.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: memcg: rename mem_cgroup_flush_stats_"delayed" to "ratelimited"
Date: Thu, 30 Mar 2023 19:17:55 +0000

mem_cgroup_flush_stats_delayed() suggests his is using a delayed_work, but
this is actually sometimes flushing directly from the callsite.

What it's doing is ratelimited calls.  A better name would be
mem_cgroup_flush_stats_ratelimited().

Link: https://lkml.kernel.org/r/20230330191801.1967435-3-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
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
 mm/memcontrol.c            |    2 +-
 mm/workingset.c            |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/memcontrol.h~memcg-rename-mem_cgroup_flush_stats_delayed-to-ratelimited
+++ a/include/linux/memcontrol.h
@@ -1038,7 +1038,7 @@ static inline unsigned long lruvec_page_
 }
 
 void mem_cgroup_flush_stats(void);
-void mem_cgroup_flush_stats_delayed(void);
+void mem_cgroup_flush_stats_ratelimited(void);
 
 void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			      int val);
@@ -1536,7 +1536,7 @@ static inline void mem_cgroup_flush_stat
 {
 }
 
-static inline void mem_cgroup_flush_stats_delayed(void)
+static inline void mem_cgroup_flush_stats_ratelimited(void)
 {
 }
 
--- a/mm/memcontrol.c~memcg-rename-mem_cgroup_flush_stats_delayed-to-ratelimited
+++ a/mm/memcontrol.c
@@ -654,7 +654,7 @@ void mem_cgroup_flush_stats(void)
 		__mem_cgroup_flush_stats();
 }
 
-void mem_cgroup_flush_stats_delayed(void)
+void mem_cgroup_flush_stats_ratelimited(void)
 {
 	if (time_after64(jiffies_64, flush_next_time))
 		mem_cgroup_flush_stats();
--- a/mm/workingset.c~memcg-rename-mem_cgroup_flush_stats_delayed-to-ratelimited
+++ a/mm/workingset.c
@@ -462,7 +462,7 @@ void workingset_refault(struct folio *fo
 
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
 
-	mem_cgroup_flush_stats_delayed();
+	mem_cgroup_flush_stats_ratelimited();
 	/*
 	 * Compare the distance to the existing workingset size. We
 	 * don't activate pages that couldn't stay resident even if
_

Patches currently in -mm which might be from yosryahmed@google.com are

memcg-do-not-flush-stats-in-irq-context.patch
memcg-replace-stats_flush_lock-with-an-atomic.patch
memcg-sleep-during-flushing-stats-in-safe-contexts.patch
workingset-memcg-sleep-when-flushing-stats-in-workingset_refault.patch
vmscan-memcg-sleep-when-flushing-stats-during-reclaim.patch
memcg-do-not-modify-rstat-tree-for-zero-updates.patch
memcg-page_cgroup_ino-get-memcg-from-the-pages-folio.patch
mm-vmscan-ignore-non-lru-based-reclaim-in-memcg-reclaim.patch
mm-vmscan-move-set_task_reclaim_state-near-flush_reclaim_state.patch
mm-vmscan-refactor-updating-current-reclaim_state.patch

