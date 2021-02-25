Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DDDEC433E6
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAAE364ECE
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:25:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbhBYTZK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:25:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:34002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233153AbhBYTW5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:22:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8A5E64F62;
        Thu, 25 Feb 2021 19:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280433;
        bh=XA0lSZEL6zQ6eT/9WMNEnJIV/QIcmyn9mfnItSxq3ac=;
        h=Date:From:To:Subject:From;
        b=FSzeyUfvnxquSVfRGfpJv/PexTi6U5wJ4Zc3OKqD1JemOyO/H54iNF3cYSlghh/ne
         k/pttQV+dhM5dlaT1if7wgLxp9vC4NIFpQb/EswcpXwhDfPv16Q6xFwbcE+/KPXKEb
         ztirBhfDEqsPpZB+KMjsNVDKnpX+ZEFcR9GKp9M8=
Date:   Thu, 25 Feb 2021 11:13:52 -0800
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org,
        laoar.shao@gmail.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        sfr@canb.auug.org.au, shakeelb@google.com,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage.patch removed
 from -mm tree
Message-ID: <20210225191352.TGC2oZ2K-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: optimize per-lruvec stats counter memory usage
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: optimize per-lruvec stats counter memory usage

The vmstat threshold is 32 (MEMCG_CHARGE_BATCH), Actually the threshold
can be as big as MEMCG_CHARGE_BATCH * PAGE_SIZE.  It still fits into s32. 
So introduce struct batched_lruvec_stat to optimize memory usage.

The size of struct lruvec_stat is 304 bytes on 64 bit systems.  As it is a
per-cpu structure.  So with this patch, we can save 304 / 2 * ncpu bytes
per-memcg per-node where ncpu is the number of the possible CPU.  If there
are c memory cgroup (include dying cgroup) and n NUMA node in the system. 
Finally, we can save (152 * ncpu * c * n) bytes.

[akpm@linux-foundation.org: fix typo in comment]
Link: https://lkml.kernel.org/r/20201210042121.39665-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Chris Down <chris@chrisdown.name>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   14 ++++++++++++--
 mm/memcontrol.c            |   10 +++++++++-
 2 files changed, 21 insertions(+), 3 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage
+++ a/include/linux/memcontrol.h
@@ -92,6 +92,10 @@ struct lruvec_stat {
 	long count[NR_VM_NODE_STAT_ITEMS];
 };
 
+struct batched_lruvec_stat {
+	s32 count[NR_VM_NODE_STAT_ITEMS];
+};
+
 /*
  * Bitmap of shrinker::id corresponding to memcg-aware shrinkers,
  * which have elements charged to this memcg.
@@ -107,11 +111,17 @@ struct memcg_shrinker_map {
 struct mem_cgroup_per_node {
 	struct lruvec		lruvec;
 
-	/* Legacy local VM stats */
+	/*
+	 * Legacy local VM stats. This should be struct lruvec_stat and
+	 * cannot be optimized to struct batched_lruvec_stat. Because
+	 * the threshold of the lruvec_stat_cpu can be as big as
+	 * MEMCG_CHARGE_BATCH * PAGE_SIZE. It can fit into s32. But this
+	 * filed has no upper limit.
+	 */
 	struct lruvec_stat __percpu *lruvec_stat_local;
 
 	/* Subtree VM stats (batched updates) */
-	struct lruvec_stat __percpu *lruvec_stat_cpu;
+	struct batched_lruvec_stat __percpu *lruvec_stat_cpu;
 	atomic_long_t		lruvec_stat[NR_VM_NODE_STAT_ITEMS];
 
 	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
--- a/mm/memcontrol.c~mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage
+++ a/mm/memcontrol.c
@@ -5208,7 +5208,7 @@ static int alloc_mem_cgroup_per_node_inf
 		return 1;
 	}
 
-	pn->lruvec_stat_cpu = alloc_percpu_gfp(struct lruvec_stat,
+	pn->lruvec_stat_cpu = alloc_percpu_gfp(struct batched_lruvec_stat,
 					       GFP_KERNEL_ACCOUNT);
 	if (!pn->lruvec_stat_cpu) {
 		free_percpu(pn->lruvec_stat_local);
@@ -7093,6 +7093,14 @@ static int __init mem_cgroup_init(void)
 {
 	int cpu, node;
 
+	/*
+	 * Currently s32 type (can refer to struct batched_lruvec_stat) is
+	 * used for per-memcg-per-cpu caching of per-node statistics. In order
+	 * to work fine, we should make sure that the overfill threshold can't
+	 * exceed S32_MAX / PAGE_SIZE.
+	 */
+	BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S32_MAX / PAGE_SIZE);
+
 	cpuhp_setup_state_nocalls(CPUHP_MM_MEMCQ_DEAD, "mm/memctrl:dead", NULL,
 				  memcg_hotplug_cpu_dead);
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


