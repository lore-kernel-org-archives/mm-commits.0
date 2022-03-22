Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85502C43219
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236063AbiCVVnM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234569AbiCVVnJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:43:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782435EDC1
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:41:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35798B81DB5
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09F2C340F3;
        Tue, 22 Mar 2022 21:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985298;
        bh=rb2yf8BdDL/eNtOb+t+e3KEJEoeZ3+IyJOBGGQFF94s=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=xFpbAOQ6am1bFejycXmVpX6HbTgZ7UsoLU1GSwzh7yf0PWctrGkXVAuKTHqTg4lzT
         UZmBBs85sZohcdp42cmAcrs93tNGd4840A9nDbRe3ofWWP4o9ei95NOOekgwE5cOys
         avJwJJR24G9ePEcM7/5fGW+SeCrK5k7okHRZU/hw=
Date:   Tue, 22 Mar 2022 14:41:38 -0700
To:     zhengqi.arch@bytedance.com, willy@infradead.org,
        vdavydov.dev@gmail.com, vbabka@suse.cz, tytso@mit.edu,
        trond.myklebust@hammerspace.com, shy828301@gmail.com,
        shakeelb@google.com, roman.gushchin@linux.dev,
        richard.weiyang@gmail.com, mhocko@kernel.org,
        kari.argillander@gmail.com, jaegeuk@kernel.org, hannes@cmpxchg.org,
        fam.zheng@bytedance.com, duanxiongchun@bytedance.com,
        david@fromorbit.com, chao@kernel.org, Anna.Schumaker@Netapp.com,
        alexs@kernel.org, songmuchun@bytedance.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 061/227] mm: memcontrol: rename memcg_cache_id to memcg_kmem_id
Message-Id: <20220322214138.C09F2C340F3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: rename memcg_cache_id to memcg_kmem_id

The memcg_cache_id() introduced by commit 2633d7a02823 ("slab/slub:
consider a memcg parameter in kmem_create_cache") is used to index in the
kmem_cache->memcg_params->memcg_caches array.  Since
kmem_cache->memcg_params.memcg_caches has been removed by commit
9855609bde03 ("mm: memcg/slab: use a single set of kmem_caches for all
accounted allocations").  So the name does not need to reflect cache
related.  Just rename it to memcg_kmem_id.  And it can reflect kmem
related.

Link: https://lkml.kernel.org/r/20220228122126.37293-17-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kari Argillander <kari.argillander@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 mm/list_lru.c              |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-rename-memcg_cache_id-to-memcg_kmem_id
+++ a/include/linux/memcontrol.h
@@ -1708,7 +1708,7 @@ static inline void memcg_kmem_uncharge_p
  * A helper for accessing memcg's kmem_id, used for getting
  * corresponding LRU lists.
  */
-static inline int memcg_cache_id(struct mem_cgroup *memcg)
+static inline int memcg_kmem_id(struct mem_cgroup *memcg)
 {
 	return memcg ? memcg->kmemcg_id : -1;
 }
@@ -1746,7 +1746,7 @@ static inline bool memcg_kmem_enabled(vo
 	return false;
 }
 
-static inline int memcg_cache_id(struct mem_cgroup *memcg)
+static inline int memcg_kmem_id(struct mem_cgroup *memcg)
 {
 	return -1;
 }
--- a/mm/list_lru.c~mm-memcontrol-rename-memcg_cache_id-to-memcg_kmem_id
+++ a/mm/list_lru.c
@@ -75,7 +75,7 @@ list_lru_from_kmem(struct list_lru *lru,
 	if (!memcg)
 		goto out;
 
-	l = list_lru_from_memcg_idx(lru, nid, memcg_cache_id(memcg));
+	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
 out:
 	if (memcg_ptr)
 		*memcg_ptr = memcg;
@@ -182,7 +182,7 @@ unsigned long list_lru_count_one(struct
 	long count;
 
 	rcu_read_lock();
-	l = list_lru_from_memcg_idx(lru, nid, memcg_cache_id(memcg));
+	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
 	count = l ? READ_ONCE(l->nr_items) : 0;
 	rcu_read_unlock();
 
@@ -273,7 +273,7 @@ list_lru_walk_one(struct list_lru *lru,
 	unsigned long ret;
 
 	spin_lock(&nlru->lock);
-	ret = __list_lru_walk_one(lru, nid, memcg_cache_id(memcg), isolate,
+	ret = __list_lru_walk_one(lru, nid, memcg_kmem_id(memcg), isolate,
 				  cb_arg, nr_to_walk);
 	spin_unlock(&nlru->lock);
 	return ret;
@@ -289,7 +289,7 @@ list_lru_walk_one_irq(struct list_lru *l
 	unsigned long ret;
 
 	spin_lock_irq(&nlru->lock);
-	ret = __list_lru_walk_one(lru, nid, memcg_cache_id(memcg), isolate,
+	ret = __list_lru_walk_one(lru, nid, memcg_kmem_id(memcg), isolate,
 				  cb_arg, nr_to_walk);
 	spin_unlock_irq(&nlru->lock);
 	return ret;
_
