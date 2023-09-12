Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C54EECA0EF2
	for <mm-commits@archiver.kernel.org>; Tue, 12 Sep 2023 16:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbjILQPI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Sep 2023 12:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236539AbjILQPH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Sep 2023 12:15:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7350510E5
        for <mm-commits@vger.kernel.org>; Tue, 12 Sep 2023 09:15:03 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D2AC433C8;
        Tue, 12 Sep 2023 16:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694535303;
        bh=u6YOnVEOdRWM+kOhfjZKTDjvv6bOmho0mVNgMS1pXQc=;
        h=Date:To:From:Subject:From;
        b=RmbpP5hJOsDDB+Uk0W52qMNaH6ATv+fsxoBks11N6mw5UdzVWpJzgqAUNbiBpyr20
         0mZpFtfD3KnQTkI06TDfkBA77Vw8cCEpgK8Rg88MIcoGD3Dd3mjvkVaUZTaGycxf4Y
         +5KYP0r5PkRUL3bfwAQ1px2WkZyO6d61vRmtTw/c=
Date:   Tue, 12 Sep 2023 09:15:02 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mkoutny@suse.com,
        mhocko@suse.com, longman@redhat.com, ivan@cloudflare.com,
        hannes@cmpxchg.org, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memcg-add-a-helper-for-non-unified-stats-flushing.patch removed from -mm tree
Message-Id: <20230912161503.07D2AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memcg: add a helper for non-unified stats flushing
has been removed from the -mm tree.  Its filename was
     mm-memcg-add-a-helper-for-non-unified-stats-flushing.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: memcg: add a helper for non-unified stats flushing
Date: Thu, 31 Aug 2023 16:56:09 +0000

Some contexts flush memcg stats outside of unified flushing, directly
using cgroup_rstat_flush().  Add a helper for non-unified flushing, a
counterpart for do_unified_stats_flush(), and use it in those contexts, as
well as in do_unified_stats_flush() itself.

This abstracts the rstat API and makes it easy to introduce modifications
to either unified or non-unified flushing functions without changing
callers.

No functional change intended.

Link: https://lkml.kernel.org/r/20230831165611.2610118-3-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Waiman Long <longman@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Ivan Babrou <ivan@cloudflare.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-add-a-helper-for-non-unified-stats-flushing
+++ a/mm/memcontrol.c
@@ -640,6 +640,17 @@ static inline void memcg_rstat_updated(s
 }
 
 /*
+ * do_stats_flush - do a flush of the memory cgroup statistics
+ * @memcg: memory cgroup to flush
+ *
+ * Only flushes the subtree of @memcg, does not skip under any conditions.
+ */
+static void do_stats_flush(struct mem_cgroup *memcg)
+{
+	cgroup_rstat_flush(memcg->css.cgroup);
+}
+
+/*
  * do_unified_stats_flush - do a unified flush of memory cgroup statistics
  *
  * A unified flush tries to flush the entire hierarchy, but skips if there is
@@ -656,7 +667,7 @@ static void do_unified_stats_flush(void)
 
 	WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);
 
-	cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
+	do_stats_flush(root_mem_cgroup);
 
 	atomic_set(&stats_flush_threshold, 0);
 	atomic_set(&stats_unified_flush_ongoing, 0);
@@ -7794,7 +7805,7 @@ bool obj_cgroup_may_zswap(struct obj_cgr
 			break;
 		}
 
-		cgroup_rstat_flush(memcg->css.cgroup);
+		do_stats_flush(memcg);
 		pages = memcg_page_state(memcg, MEMCG_ZSWAP_B) / PAGE_SIZE;
 		if (pages < max)
 			continue;
@@ -7859,8 +7870,10 @@ void obj_cgroup_uncharge_zswap(struct ob
 static u64 zswap_current_read(struct cgroup_subsys_state *css,
 			      struct cftype *cft)
 {
-	cgroup_rstat_flush(css->cgroup);
-	return memcg_page_state(mem_cgroup_from_css(css), MEMCG_ZSWAP_B);
+	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+
+	do_stats_flush(memcg);
+	return memcg_page_state(memcg, MEMCG_ZSWAP_B);
 }
 
 static int zswap_max_show(struct seq_file *m, void *v)
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-memcg-let-non-unified-root-stats-flushes-help-unified-flushes.patch
mm-memcg-use-non-unified-stats-flushing-for-userspace-reads.patch

