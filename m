Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32485C7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbjFIX1R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbjFIX1C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:27:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6D13589
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D2F663BDB
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1E4C433EF;
        Fri,  9 Jun 2023 23:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353220;
        bh=GAnGXIHChJED+w/TMnZTscbcZFY5Eyub6oTv9qhgQaI=;
        h=Date:To:From:Subject:From;
        b=c+gI8R1KasGExrR1brhhLrxz10s1RrhyulXyrUbM/M6Gam3dx09HaZchpTLbvY3gj
         OIcS7vzfPonKZ3r0vgFm17s8u4WO6wpgq1QiAvLhwXI9h2Fu5AsHQMa5X4L2jbQ3qS
         Gqie/+6bB/JJsB4eudhGhZbqyeGgPr+v7G89tiqY=
Date:   Fri, 09 Jun 2023 16:26:59 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tj@kernel.org,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        jack@suse.cz, hannes@cmpxchg.org, brauner@kernel.org,
        axboe@kernel.dk, yosryahmed@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-remove-mem_cgroup_flush_stats_atomic.patch removed from -mm tree
Message-Id: <20230609232659.DD1E4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg: remove mem_cgroup_flush_stats_atomic()
has been removed from the -mm tree.  Its filename was
     memcg-remove-mem_cgroup_flush_stats_atomic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: memcg: remove mem_cgroup_flush_stats_atomic()
Date: Fri, 21 Apr 2023 17:40:19 +0000

Previous patches removed all callers of mem_cgroup_flush_stats_atomic(). 
Remove the function and simplify the code.

Link: https://lkml.kernel.org/r/20230421174020.2994750-5-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 -----
 mm/memcontrol.c            |   24 +++++-------------------
 2 files changed, 5 insertions(+), 24 deletions(-)

--- a/include/linux/memcontrol.h~memcg-remove-mem_cgroup_flush_stats_atomic
+++ a/include/linux/memcontrol.h
@@ -1038,7 +1038,6 @@ static inline unsigned long lruvec_page_
 }
 
 void mem_cgroup_flush_stats(void);
-void mem_cgroup_flush_stats_atomic(void);
 void mem_cgroup_flush_stats_ratelimited(void);
 
 void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
@@ -1537,10 +1536,6 @@ static inline void mem_cgroup_flush_stat
 {
 }
 
-static inline void mem_cgroup_flush_stats_atomic(void)
-{
-}
-
 static inline void mem_cgroup_flush_stats_ratelimited(void)
 {
 }
--- a/mm/memcontrol.c~memcg-remove-mem_cgroup_flush_stats_atomic
+++ a/mm/memcontrol.c
@@ -639,7 +639,7 @@ static inline void memcg_rstat_updated(s
 	}
 }
 
-static void do_flush_stats(bool atomic)
+static void do_flush_stats(void)
 {
 	/*
 	 * We always flush the entire tree, so concurrent flushers can just
@@ -652,30 +652,16 @@ static void do_flush_stats(bool atomic)
 
 	WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);
 
-	if (atomic)
-		cgroup_rstat_flush_atomic(root_mem_cgroup->css.cgroup);
-	else
-		cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
+	cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
 
 	atomic_set(&stats_flush_threshold, 0);
 	atomic_set(&stats_flush_ongoing, 0);
 }
 
-static bool should_flush_stats(void)
-{
-	return atomic_read(&stats_flush_threshold) > num_online_cpus();
-}
-
 void mem_cgroup_flush_stats(void)
 {
-	if (should_flush_stats())
-		do_flush_stats(false);
-}
-
-void mem_cgroup_flush_stats_atomic(void)
-{
-	if (should_flush_stats())
-		do_flush_stats(true);
+	if (atomic_read(&stats_flush_threshold) > num_online_cpus())
+		do_flush_stats();
 }
 
 void mem_cgroup_flush_stats_ratelimited(void)
@@ -690,7 +676,7 @@ static void flush_memcg_stats_dwork(stru
 	 * Always flush here so that flushing in latency-sensitive paths is
 	 * as cheap as possible.
 	 */
-	do_flush_stats(false);
+	do_flush_stats();
 	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, FLUSH_TIME);
 }
 
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-zswap-support-exclusive-loads.patch

