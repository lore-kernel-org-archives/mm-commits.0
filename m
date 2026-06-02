Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFBD3BC69D
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439077; cv=none; b=NVNtPaEeR3FmBqXKqIZj2P8hDS5q3FKsWWlBhKDVe2WZ0125LUDDxiq+7J+ZDbp3cerbmysi/Wt+wEb9ttkHTRGXVSuAF4CT97MeIx4WxMIrdnTgqNRRqZLNcTAVPC/VdXR0MYCtZhXTsfDro0YGPN5OvT0NcDEft0+opY2ZiNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439077; c=relaxed/simple;
	bh=YfSuwG2sy8+lhv/29HxK6OOEXccA9OeqoLfpTXrh15I=;
	h=Date:To:From:Subject:Message-Id; b=OGdQtbNY4kDD82rtxWsSE8l8gTzWel3D9SggS5mQOujdI5eI9JWyZcIbH244NRhR3LZSiK1mG67+04i1x49YTrSlP5VG0XnCktG6iD7tj00gFTlOfzpcX+EN0hWE7ZDrpzVr2d/Qh8Uo+NZvpuA1NKCzDZBuCECJa9lv2PbtnpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N2aPU08p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N2aPU08p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FB41F0089A;
	Tue,  2 Jun 2026 22:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439075;
	bh=r14tGMcueIrJnPciwMoQAp6iy7f9J6xsSKVh21Le+PY=;
	h=Date:To:From:Subject;
	b=N2aPU08p97vDInqgGwf+WQhtMvJI64QT0GKeTKUaDSRtQomdOm8S4LunpppGcdm9A
	 zjmQNKTAxlhatXRE1hVtJ2ltetCnAMjCjAa2TWOxEXKg2u6FPx27FqX0FpQFfnLm0a
	 5Dkk0xW0mzWkHclumaYa7i5EZCKu/EXSe1ChrWHc=
Date: Tue, 02 Jun 2026 15:24:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,youngjun.park@lge.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,ljs@kernel.org,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-consolidate-cluster-allocation-helpers.patch removed from -mm tree
Message-Id: <20260602222435.12FB41F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: consolidate cluster allocation helpers
has been removed from the -mm tree.  Its filename was
     mm-swap-consolidate-cluster-allocation-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: consolidate cluster allocation helpers
Date: Sun, 17 May 2026 23:39:48 +0800

Swap cluster table management is spread across several narrow helpers.  As
a result, the allocation and fallback sequences are open-coded in multiple
places.

A few more per-cluster tables will be added soon, so avoid duplicating
these sequences per table type.  Fold the existing pairs into
cluster-oriented helpers, and rename for consistency.

No functional change, only a few sanity checks are slightly adjusted.

Link: https://lore.kernel.org/20260517-swap-table-p4-v5-9-88ae43e064c7@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |  110 +++++++++++++++++++++---------------------------
 1 file changed, 49 insertions(+), 61 deletions(-)

--- a/mm/swapfile.c~mm-swap-consolidate-cluster-allocation-helpers
+++ a/mm/swapfile.c
@@ -411,20 +411,7 @@ static inline unsigned int cluster_offse
 	return cluster_index(si, ci) * SWAPFILE_CLUSTER;
 }
 
-static struct swap_table *swap_table_alloc(gfp_t gfp)
-{
-	struct folio *folio;
-
-	if (!SWP_TABLE_USE_PAGE)
-		return kmem_cache_zalloc(swap_table_cachep, gfp);
-
-	folio = folio_alloc(gfp | __GFP_ZERO, 0);
-	if (folio)
-		return folio_address(folio);
-	return NULL;
-}
-
-static void swap_table_free_folio_rcu_cb(struct rcu_head *head)
+static void swap_cluster_free_table_folio_rcu_cb(struct rcu_head *head)
 {
 	struct folio *folio;
 
@@ -432,15 +419,46 @@ static void swap_table_free_folio_rcu_cb
 	folio_put(folio);
 }
 
-static void swap_table_free(struct swap_table *table)
+static void swap_cluster_free_table(struct swap_cluster_info *ci)
 {
+	struct swap_table *table;
+
+	table = (struct swap_table *)rcu_dereference_protected(ci->table, true);
+	if (!table)
+		return;
+
+	rcu_assign_pointer(ci->table, NULL);
 	if (!SWP_TABLE_USE_PAGE) {
 		kmem_cache_free(swap_table_cachep, table);
 		return;
 	}
 
 	call_rcu(&(folio_page(virt_to_folio(table), 0)->rcu_head),
-		 swap_table_free_folio_rcu_cb);
+		 swap_cluster_free_table_folio_rcu_cb);
+}
+
+static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
+{
+	struct swap_table *table = NULL;
+	struct folio *folio;
+
+	/* The cluster must be empty and not on any list during allocation. */
+	VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
+	if (rcu_access_pointer(ci->table))
+		return 0;
+
+	if (SWP_TABLE_USE_PAGE) {
+		folio = folio_alloc(gfp | __GFP_ZERO, 0);
+		if (folio)
+			table = folio_address(folio);
+	} else {
+		table = kmem_cache_zalloc(swap_table_cachep, gfp);
+	}
+	if (!table)
+		return -ENOMEM;
+
+	rcu_assign_pointer(ci->table, table);
+	return 0;
 }
 
 /*
@@ -471,27 +489,15 @@ static void swap_cluster_assert_empty(st
 	WARN_ON_ONCE(nr == SWAPFILE_CLUSTER && ci->extend_table);
 }
 
-static void swap_cluster_free_table(struct swap_cluster_info *ci)
-{
-	struct swap_table *table;
-
-	/* Only empty cluster's table is allow to be freed  */
-	lockdep_assert_held(&ci->lock);
-	table = (void *)rcu_dereference_protected(ci->table, true);
-	rcu_assign_pointer(ci->table, NULL);
-
-	swap_table_free(table);
-}
-
 /*
  * Allocate swap table for one cluster. Attempt an atomic allocation first,
  * then fallback to sleeping allocation.
  */
 static struct swap_cluster_info *
-swap_cluster_alloc_table(struct swap_info_struct *si,
+swap_cluster_populate(struct swap_info_struct *si,
 			 struct swap_cluster_info *ci)
 {
-	struct swap_table *table;
+	int ret;
 
 	/*
 	 * Only cluster isolation from the allocator does table allocation.
@@ -502,14 +508,9 @@ swap_cluster_alloc_table(struct swap_inf
 		lockdep_assert_held(&si->global_cluster_lock);
 	lockdep_assert_held(&ci->lock);
 
-	/* The cluster must be free and was just isolated from the free list. */
-	VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
-
-	table = swap_table_alloc(__GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
-	if (table) {
-		rcu_assign_pointer(ci->table, table);
+	if (!swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
+					  __GFP_NOWARN))
 		return ci;
-	}
 
 	/*
 	 * Try a sleep allocation. Each isolated free cluster may cause
@@ -521,7 +522,8 @@ swap_cluster_alloc_table(struct swap_inf
 		spin_unlock(&si->global_cluster_lock);
 	local_unlock(&percpu_swap_cluster.lock);
 
-	table = swap_table_alloc(__GFP_HIGH | __GFP_NOMEMALLOC | GFP_KERNEL);
+	ret = swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
+					   GFP_KERNEL);
 
 	/*
 	 * Back to atomic context. We might have migrated to a new CPU with a
@@ -536,20 +538,11 @@ swap_cluster_alloc_table(struct swap_inf
 		spin_lock(&si->global_cluster_lock);
 	spin_lock(&ci->lock);
 
-	/* Nothing except this helper should touch a dangling empty cluster. */
-	if (WARN_ON_ONCE(cluster_table_is_alloced(ci))) {
-		if (table)
-			swap_table_free(table);
-		return ci;
-	}
-
-	if (!table) {
+	if (ret) {
 		move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 		spin_unlock(&ci->lock);
 		return NULL;
 	}
-
-	rcu_assign_pointer(ci->table, table);
 	return ci;
 }
 
@@ -621,12 +614,11 @@ static struct swap_cluster_info *isolate
 	}
 	spin_unlock(&si->lock);
 
-	if (found && !cluster_table_is_alloced(found)) {
-		/* Only an empty free cluster's swap table can be freed. */
-		VM_WARN_ON_ONCE(flags != CLUSTER_FLAG_FREE);
+	/* Cluster's table is freed when and only when it's on the free list. */
+	if (found && flags == CLUSTER_FLAG_FREE) {
 		VM_WARN_ON_ONCE(list != &si->free_clusters);
-		VM_WARN_ON_ONCE(!cluster_is_empty(found));
-		return swap_cluster_alloc_table(si, found);
+		VM_WARN_ON_ONCE(cluster_table_is_alloced(found));
+		return swap_cluster_populate(si, found);
 	}
 
 	return found;
@@ -769,7 +761,6 @@ static int swap_cluster_setup_bad_slot(s
 	unsigned int ci_off = offset % SWAPFILE_CLUSTER;
 	unsigned long idx = offset / SWAPFILE_CLUSTER;
 	struct swap_cluster_info *ci;
-	struct swap_table *table;
 	int ret = 0;
 
 	/* si->max may got shrunk by swap swap_activate() */
@@ -790,12 +781,9 @@ static int swap_cluster_setup_bad_slot(s
 	}
 
 	ci = cluster_info + idx;
-	if (!ci->table) {
-		table = swap_table_alloc(GFP_KERNEL);
-		if (!table)
-			return -ENOMEM;
-		rcu_assign_pointer(ci->table, table);
-	}
+	/* Need to allocate swap table first for initial bad slot marking. */
+	if (!ci->count && swap_cluster_alloc_table(ci, GFP_KERNEL))
+		return -ENOMEM;
 	spin_lock(&ci->lock);
 	/* Check for duplicated bad swap slots. */
 	if (__swap_table_xchg(ci, ci_off, SWP_TB_BAD) != SWP_TB_NULL) {
@@ -2920,7 +2908,7 @@ static void free_swap_cluster_info(struc
 		ci = cluster_info + i;
 		/* Cluster with bad marks count will have a remaining table */
 		spin_lock(&ci->lock);
-		if (rcu_dereference_protected(ci->table, true)) {
+		if (cluster_table_is_alloced(ci)) {
 			swap_cluster_assert_empty(ci, 0, SWAPFILE_CLUSTER, true);
 			swap_cluster_free_table(ci);
 		}
_

Patches currently in -mm which might be from kasong@tencent.com are


