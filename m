Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAB53F8DE1
	for <mm-commits@vger.kernel.org>; Wed, 18 Mar 2026 20:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773864826; cv=none; b=G60Ghrr9xuhod39OwHTy2DCsXSgoy/IQ3B1ZZJapr+9Qxlz6fdlXIMNBTOVuNAWsxVkPmrw1ukmtX4Fb6NcBi/l37tmKho+KNQplq5v1diMry/S/la13/Tp79SCSg8rbxDPO5lcJoITbSYWbj2dIMNFqIYr7VSJRlFh5jT27Hdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773864826; c=relaxed/simple;
	bh=xObn2v5WaVl8JdIeF+CLpoyaBfMFtqgO7e8ohsWFvcQ=;
	h=Date:To:From:Subject:Message-Id; b=JWALBY0p2Qo3mpuhd6icNi6QbGvwnSKh76AwZKauT6AOx2LwwgOcE7IqoX7MOqoRpDHw3TaOA/Tpeptc3eobXubsG0SJZNxLsCpFrP3ojVfP8Jxq3Fs9TiZA/wthhRbIt1GhhpqGuKXED7atqA1XtEHNYAXUYwNQ/P8IWj7YKPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yr5vUGNk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yr5vUGNk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BF5C2BC9E;
	Wed, 18 Mar 2026 20:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773864825;
	bh=xObn2v5WaVl8JdIeF+CLpoyaBfMFtqgO7e8ohsWFvcQ=;
	h=Date:To:From:Subject:From;
	b=yr5vUGNkGmT2/49Ibx3LQ8iesxIZXgiripCP205f0Rwy9q77pOSOOXSOIyYPiXavX
	 X0HoD7oUb4LtZCsPLSACca1W97zJC5A8ZmPbKfuK+bHnHbNj1tw0KBn1rg3mr8EFuh
	 3vn0v355jeHChw86JDUwzveiyKDF0/lQ4d8N1zkQ=
Date: Wed, 18 Mar 2026 13:13:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,roman.gushchin@linux.dev,npache@redhat.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,david@fromorbit.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-introduce-folio_memcg_list_lru_alloc.patch added to mm-new branch
Message-Id: <20260318201345.B0BF5C2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: list_lru: introduce folio_memcg_list_lru_alloc()
has been added to the -mm mm-new branch.  Its filename is
     mm-list_lru-introduce-folio_memcg_list_lru_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-list_lru-introduce-folio_memcg_list_lru_alloc.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
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

mm-vmalloc-streamline-vmalloc-memory-accounting.patch
mm-memcontrol-switch-to-native-nr_vmalloc-vmstat-counter.patch
mm-memcontrol-split-out-__obj_cgroup_charge.patch
mm-memcontrol-use-__account_obj_stock-in-the-locked-path.patch
mm-memcg-separate-slab-stat-accounting-from-objcg-charge-cache.patch
mm-list_lru-lock_list_lru_of_memcg-cannot-return-null-if-skip_empty.patch
mm-list_lru-deduplicate-unlock_list_lru.patch
mm-list_lru-move-list-dead-check-to-lock_list_lru_of_memcg.patch
mm-list_lru-deduplicate-lock_list_lru.patch
mm-list_lru-introduce-caller-locking-for-additions-and-deletions.patch
mm-list_lru-introduce-folio_memcg_list_lru_alloc.patch
mm-switch-deferred-split-shrinker-to-list_lru.patch

