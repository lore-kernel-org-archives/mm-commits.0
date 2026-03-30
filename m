Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF8E3803DD
	for <mm-commits@vger.kernel.org>; Mon, 30 Mar 2026 19:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774897433; cv=none; b=Gt5+dkmv58iY/tIFNNtPahox38ULdRHKgAHyUOSKvufiwnooOta0jOGZHhR3vr2VjDwjVKKM5gONQROhYB1GIdbq7s5at/KV5jLnQxH5Cd2whnoarX7MqDRhBDndKPbu90KDMDn1HdzdVfdaJxbQiMReqyjT/RWC90YsBhfn7K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774897433; c=relaxed/simple;
	bh=PzLagunLortDVdqTK4vWNJUIbcUDyCZiKS3h7KnAiZA=;
	h=Date:To:From:Subject:Message-Id; b=cH5nb6sFFZ+O7ShFMZcfBBQ0SEnA0xDdvdrwKtKrjPwW/nE1978UUMb8afmQZwonnda4eBXnhwjp8IwbZ50P2Gh9fH68iPU81WWBBxkMtULCnF7Jno8Bpm1eBPYBZvLWih7otvNcquRlOQQrpH+MdUVonqzWF994efUuHR2GI0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m4h7nLjR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m4h7nLjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D06C2BCB1;
	Mon, 30 Mar 2026 19:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774897433;
	bh=PzLagunLortDVdqTK4vWNJUIbcUDyCZiKS3h7KnAiZA=;
	h=Date:To:From:Subject:From;
	b=m4h7nLjRTnN0N8UQ1cG75Hf7d8RBmtNI45zA/GxdAGJ7D/wnEjCH8CtVQnQfsF7Ax
	 aKNppuKH4HB+xtwSplUZtPqGZ6azoVoqcs8hmfKyZ0W+DDTCyU/ZzGPVw9D+u/+TGk
	 Rm4Frfidlp+AGrM/6bckk7tqT6QFMvANx2X5zGPU=
Date: Mon, 30 Mar 2026 12:03:53 -0700
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-list_lru-introduce-folio_memcg_list_lru_alloc.patch removed from -mm tree
Message-Id: <20260330190353.A2D06C2BCB1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: list_lru: introduce folio_memcg_list_lru_alloc()
has been removed from the -mm tree.  Its filename was
     mm-list_lru-introduce-folio_memcg_list_lru_alloc.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: list_lru: introduce folio_memcg_list_lru_alloc()
Date: Wed, 18 Mar 2026 15:53:24 -0400

memcg_list_lru_alloc() is called every time an object that may end up on
the list_lru is created.  It needs to quickly check if the list_lru heads
for the memcg already exist, and allocate them when they don't.

Doing this with folio objects is tricky: folio_memcg() is not stable and
requires either RCU protection or pinning the cgroup.  But it's desirable
to make the existence check lightweight under RCU, and only pin the memcg
when we need to allocate list_lru heads and may block.

In preparation for switching the THP shrinker to list_lru, add a helper
function for allocating list_lru heads coming from a folio.

Link: https://lkml.kernel.org/r/20260318200352.1039011-7-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h |   12 +++++++++++
 mm/list_lru.c            |   39 ++++++++++++++++++++++++++++++++-----
 2 files changed, 46 insertions(+), 5 deletions(-)

--- a/include/linux/list_lru.h~mm-list_lru-introduce-folio_memcg_list_lru_alloc
+++ a/include/linux/list_lru.h
@@ -81,6 +81,18 @@ static inline int list_lru_init_memcg_ke
 
 int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
 			 gfp_t gfp);
+
+#ifdef CONFIG_MEMCG
+int folio_memcg_list_lru_alloc(struct folio *folio, struct list_lru *lru,
+			       gfp_t gfp);
+#else
+static inline int folio_memcg_list_lru_alloc(struct folio *folio,
+					     struct list_lru *lru, gfp_t gfp)
+{
+	return 0;
+}
+#endif
+
 void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *parent);
 
 /**
--- a/mm/list_lru.c~mm-list_lru-introduce-folio_memcg_list_lru_alloc
+++ a/mm/list_lru.c
@@ -537,17 +537,14 @@ static inline bool memcg_list_lru_alloca
 	return idx < 0 || xa_load(&lru->xa, idx);
 }
 
-int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
-			 gfp_t gfp)
+static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
+				  struct list_lru *lru, gfp_t gfp)
 {
 	unsigned long flags;
 	struct list_lru_memcg *mlru = NULL;
 	struct mem_cgroup *pos, *parent;
 	XA_STATE(xas, &lru->xa, 0);
 
-	if (!list_lru_memcg_aware(lru) || memcg_list_lru_allocated(memcg, lru))
-		return 0;
-
 	gfp &= GFP_RECLAIM_MASK;
 	/*
 	 * Because the list_lru can be reparented to the parent cgroup's
@@ -588,6 +585,38 @@ int memcg_list_lru_alloc(struct mem_cgro
 
 	return xas_error(&xas);
 }
+
+int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
+			 gfp_t gfp)
+{
+	if (!list_lru_memcg_aware(lru) || memcg_list_lru_allocated(memcg, lru))
+		return 0;
+	return __memcg_list_lru_alloc(memcg, lru, gfp);
+}
+
+int folio_memcg_list_lru_alloc(struct folio *folio, struct list_lru *lru,
+			       gfp_t gfp)
+{
+	struct mem_cgroup *memcg;
+	int res;
+
+	if (!list_lru_memcg_aware(lru))
+		return 0;
+
+	/* Fast path when list_lru heads already exist */
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	res = memcg_list_lru_allocated(memcg, lru);
+	rcu_read_unlock();
+	if (likely(res))
+		return 0;
+
+	/* Allocation may block, pin the memcg */
+	memcg = get_mem_cgroup_from_folio(folio);
+	res = __memcg_list_lru_alloc(memcg, lru, gfp);
+	mem_cgroup_put(memcg);
+	return res;
+}
 #else
 static inline void memcg_init_list_lru(struct list_lru *lru, bool memcg_aware)
 {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-switch-deferred-split-shrinker-to-list_lru.patch

