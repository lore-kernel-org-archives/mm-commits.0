Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63752D9EE7
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968138; cv=none; b=VXI0rwrb4oQFsJWKo6VOZXtdeUNZbIKAQpue01lNuMsMi5f7Ye4zz4pC/u9sd8l9lsINfW/1C8RUl23UG9l9Fzti6ygZVOqL/f4Wrzb+x+2iRoZUDsIuKPbtPLUxbAUgijlKv3tj5vFtkyP6+ESFWyeUvSFI4tZPp5E1WSXxcAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968138; c=relaxed/simple;
	bh=t3tULVnnRPaR5i/3jjvh4wlq92KGiq/b0xOqZsomvB8=;
	h=Date:To:From:Subject:Message-Id; b=K36vLIgBQQWrRN5xjM5BZjI7mPShBrhLhs32n1ZN81itHKHzeDI4Pt8CvptBJFLxd4zUOy04VYJX2yvgtdb5fhjLiRfwRIeSAs6Fq/2tbX0HDDKxEhQa6ov8wvjDfA66iY8kxwFdnOc+vneTmVEEkRLfPBfADN00qKTSzV5bMFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SAsP/8Xs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SAsP/8Xs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE991F00893;
	Tue,  9 Jun 2026 01:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968136;
	bh=Q7JFcdKgBDUefEpYqKbencyIjJUWUmJvAaNv7zPjlGU=;
	h=Date:To:From:Subject;
	b=SAsP/8XszJ17TIOnv5ldmemfZwxP35YN2KwpqRlDVLF21sEMOyKeUfkCn78xweYBu
	 BMDUYQ9x+9TlkvcW23/JmvCgp2VNEZGQt1IkjpF40E9qHXENMgDtOchfikqj46YLJO
	 IaKPGv0FB3npcYMvGb1wiYLVjSfOd5fIOg9PGwgA=
Date: Mon, 08 Jun 2026 18:22:16 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zaslonko@linux.ibm.com,vbabka@kernel.org,usama.arif@linux.dev,shakeel.butt@linux.dev,ryncsn@gmail.com,ryan.roberts@arm.com,roman.gushchin@linux.dev,npache@redhat.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,gor@linux.ibm.com,dev.jain@arm.com,david@kernel.org,david@fromorbit.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-list_lru-introduce-folio_memcg_list_lru_alloc.patch removed from -mm tree
Message-Id: <20260609012216.BDE991F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: list_lru: introduce folio_memcg_list_lru_alloc()
has been removed from the -mm tree.  Its filename was
     mm-list_lru-introduce-folio_memcg_list_lru_alloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: list_lru: introduce folio_memcg_list_lru_alloc()
Date: Wed, 27 May 2026 16:45:14 -0400

memcg_list_lru_alloc() is called every time an object that may end up on
the list_lru is created.  It needs to quickly check if the list_lru heads
for the memcg already exist, and allocate them when they don't.

Doing this with folio objects is tricky: folio_memcg() is not stable and
requires either RCU protection or pinning the cgroup.  But it's desirable
to make the existence check lightweight under RCU, and only pin the memcg
when we need to allocate list_lru heads and may block.

In preparation for switching the THP shrinker to list_lru, add a helper
function for allocating list_lru heads coming from a folio.

Link: https://lore.kernel.org/20260527204757.2544958-8-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h |   27 +++++++++++++++++++++++++
 mm/list_lru.c            |   39 ++++++++++++++++++++++++++++++++-----
 2 files changed, 61 insertions(+), 5 deletions(-)

--- a/include/linux/list_lru.h~mm-list_lru-introduce-folio_memcg_list_lru_alloc
+++ a/include/linux/list_lru.h
@@ -81,6 +81,33 @@ static inline int list_lru_init_memcg_ke
 
 int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
 			 gfp_t gfp);
+
+#ifdef CONFIG_MEMCG
+/**
+ * folio_memcg_list_lru_alloc - allocate list_lru heads for shrinkable folio
+ * @folio: the newly allocated & charged folio
+ * @lru: the list_lru this might be queued on
+ * @gfp: gfp mask
+ *
+ * Allocate list_lru heads (per-memcg, per-node) needed to queue this
+ * particular folio down the line.
+ *
+ * This does memcg_list_lru_alloc(), but on the memcg that @folio is
+ * associated with. Handles folio_memcg() access rules in the fast
+ * path (list_lru heads allocated) and the allocation slowpath.
+ *
+ * Returns 0 on success, a negative error value otherwise.
+ */
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
@@ -568,17 +568,14 @@ static inline bool memcg_list_lru_alloca
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
@@ -619,6 +616,38 @@ int memcg_list_lru_alloc(struct mem_cgro
 
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


