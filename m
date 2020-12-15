Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF09C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8C88224DE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbgLODHV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:07:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:35012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbgLODHG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:07:06 -0500
Date:   Mon, 14 Dec 2020 19:06:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001586;
        bh=MTQjT8m52wpqIsyI58yrY2zjAbywVeAs7/kQ5YN8ooA=;
        h=From:To:Subject:In-Reply-To:From;
        b=BVFI2WvYZUWdE6NxrEMHYgq/Fn60KNWuhsdGm2nUoEmqZGG+q534ZURnv3y/Z9OfN
         gYTc/ru1OUNl9IGYz0tkjD4fHIv3/adxLz2/AHTTLAe0rHNePIg1AUqU2azIqpi25E
         nHkEG+cnIDphWflKL6Pk5qU7hcBr2nhezrqIn+y8=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name, cl@linux.com,
        guro@fb.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com,
        laoar.shao@gmail.com, linux-mm@kvack.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, shakeelb@google.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        vdavydov.dev@gmail.com
Subject:  [patch 056/200] mm: memcontrol: remove unused
 mod_memcg_obj_state()
Message-ID: <20201215030624.ogxUWmR1Q%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: remove unused mod_memcg_obj_state()

Since commit:

  991e7673859e ("mm: memcontrol: account kernel stack per node")

There is no user of the mod_memcg_obj_state().  This patch just remove it.
Also rework type of the idx parameter of the mod_objcg_state() from int
to enum node_stat_item.

Link: https://lkml.kernel.org/r/20201013153504.92602-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Chris Down <chris@chrisdown.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ------
 mm/memcontrol.c            |   11 -----------
 mm/slab.h                  |    4 ++--
 3 files changed, 2 insertions(+), 19 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-remove-unused-mod_memcg_obj_state
+++ a/include/linux/memcontrol.h
@@ -798,8 +798,6 @@ void __mod_lruvec_state(struct lruvec *l
 			int val);
 void __mod_lruvec_slab_state(void *p, enum node_stat_item idx, int val);
 
-void mod_memcg_obj_state(void *p, int idx, int val);
-
 static inline void mod_lruvec_slab_state(void *p, enum node_stat_item idx,
 					 int val)
 {
@@ -1255,10 +1253,6 @@ static inline void mod_lruvec_slab_state
 	mod_node_page_state(page_pgdat(page), idx, val);
 }
 
-static inline void mod_memcg_obj_state(void *p, int idx, int val)
-{
-}
-
 static inline
 unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 					    gfp_t gfp_mask,
--- a/mm/memcontrol.c~mm-memcontrol-remove-unused-mod_memcg_obj_state
+++ a/mm/memcontrol.c
@@ -882,17 +882,6 @@ void __mod_lruvec_slab_state(void *p, en
 	rcu_read_unlock();
 }
 
-void mod_memcg_obj_state(void *p, int idx, int val)
-{
-	struct mem_cgroup *memcg;
-
-	rcu_read_lock();
-	memcg = mem_cgroup_from_obj(p);
-	if (memcg)
-		mod_memcg_state(memcg, idx, val);
-	rcu_read_unlock();
-}
-
 /**
  * __count_memcg_events - account VM events in a cgroup
  * @memcg: the memory cgroup
--- a/mm/slab.h~mm-memcontrol-remove-unused-mod_memcg_obj_state
+++ a/mm/slab.h
@@ -204,7 +204,7 @@ ssize_t slabinfo_write(struct file *file
 void __kmem_cache_free_bulk(struct kmem_cache *, size_t, void **);
 int __kmem_cache_alloc_bulk(struct kmem_cache *, gfp_t, size_t, void **);
 
-static inline int cache_vmstat_idx(struct kmem_cache *s)
+static inline enum node_stat_item cache_vmstat_idx(struct kmem_cache *s)
 {
 	return (s->flags & SLAB_RECLAIM_ACCOUNT) ?
 		NR_SLAB_RECLAIMABLE_B : NR_SLAB_UNRECLAIMABLE_B;
@@ -304,7 +304,7 @@ static inline bool memcg_slab_pre_alloc_
 
 static inline void mod_objcg_state(struct obj_cgroup *objcg,
 				   struct pglist_data *pgdat,
-				   int idx, int nr)
+				   enum node_stat_item idx, int nr)
 {
 	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
_
