Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA08EC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 22:41:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92861225AC
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 22:41:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgLWWlg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Dec 2020 17:41:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:59500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgLWWlg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Dec 2020 17:41:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C09CA22571;
        Wed, 23 Dec 2020 22:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608763255;
        bh=iYqsbC3mAY10OzNQAk4FVZjqLuIbSlwpi9KK4juearY=;
        h=Date:From:To:Subject:From;
        b=hYBHPIrZgTU4c2/i+jkrskh1XL1vOWAmoWWWkkd+t6HrBJRUcrAV/h7DtQgPz6MUn
         zbiWZPsq6yCrQfr255qYLrrM9PXjDnPdnd4BgjztEE0BbeUSXS7h7GO3gCnWh3am99
         bbm+akrEKl+JdPBCwJRNHPrOMtQ52LmW8qx/Rebc=
Date:   Wed, 23 Dec 2020 14:40:54 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        shakeelb@google.com, sfr@canb.auug.org.au,
        richard.weiyang@gmail.com, mhocko@kernel.org, laoar.shao@gmail.com,
        hannes@cmpxchg.org, guro@fb.com, chris@chrisdown.name,
        songmuchun@bytedance.com
Subject:  +
 mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage.patch added to
 -mm tree
Message-ID: <20201223224054.G7Png%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: optimize per-lruvec stats counter memory usage
has been added to the -mm tree.  Its filename is
     mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
+	 * cannot be optimized to struct batched_lruvec_stat. Becasue
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
@@ -5199,7 +5199,7 @@ static int alloc_mem_cgroup_per_node_inf
 		return 1;
 	}
 
-	pn->lruvec_stat_cpu = alloc_percpu_gfp(struct lruvec_stat,
+	pn->lruvec_stat_cpu = alloc_percpu_gfp(struct batched_lruvec_stat,
 					       GFP_KERNEL_ACCOUNT);
 	if (!pn->lruvec_stat_cpu) {
 		free_percpu(pn->lruvec_stat_local);
@@ -7090,6 +7090,14 @@ static int __init mem_cgroup_init(void)
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

mm-memcontrol-fix-nr_anon_thps-accounting-in-charge-moving.patch
mm-memcontrol-convert-nr_anon_thps-account-to-pages.patch
mm-memcontrol-convert-nr_file_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_pmdmapped-account-to-pages.patch
mm-memcontrol-convert-nr_file_pmdmapped-account-to-pages.patch
mm-memcontrol-make-the-slab-calculation-consistent.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage.patch

