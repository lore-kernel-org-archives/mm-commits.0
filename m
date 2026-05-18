Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B6A39B944
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779141150; cv=none; b=PR+p12Spudwsu7p7EipMJBzSxlKFPmwV5JIYSKjJAeiwu8QtVSovIVCzgwBAZo28PjmemhlOQ0R6+gKLuhzCMVHLegS+xcslxetUJQ3aKzBZaKBeHwNJ5mmj3fWfIAv2wBdMJHH2jNnoSp9JNt5lgjukIRfuGrycK2uT6GKcDMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779141150; c=relaxed/simple;
	bh=sdQkAIhOSFWXtk+nHi+Y/yjKU3Ax7beS+NGdy/g4Fak=;
	h=Date:To:From:Subject:Message-Id; b=iLMVLWWneats3LGj69rGQ9Z6eJsgBCTcclwL0p96OIjdZiCo3qM9tPNXFri4m14lNixcXuTLuRFnSQ45a/jErAxWMWHoT9/CqJ/EbOgyPSON9AIUPXgxnzL+O8nFnCxrrj4p2YEnowRWnbaTgAk67huqiZXJ4BLL6pMyWjmomyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zlX8UzHV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zlX8UzHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C13C2BCB7;
	Mon, 18 May 2026 21:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779141149;
	bh=sdQkAIhOSFWXtk+nHi+Y/yjKU3Ax7beS+NGdy/g4Fak=;
	h=Date:To:From:Subject:From;
	b=zlX8UzHVC4LmHoUI4B8JNBtd7lqj1NoeeXRVlZ7Xz6xtn16QWKqPDKWrsJTuqKK8/
	 j/EkDpKuhoiMYnmCWC4V2bcaRc1DXBepLL0gc//M/N5xtRkPmCFuOfDQL3/mACn+6I
	 n5KV5kAmvhPWLb0R3hg2o5P5MLiocsaeCwAfHWeo=
Date: Mon, 18 May 2026 14:52:28 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-consolidate-cluster-allocation-helpers.patch added to mm-new branch
Message-Id: <20260518215229.75C13C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: consolidate cluster allocation helpers
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-consolidate-cluster-allocation-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-consolidate-cluster-allocation-helpers.patch

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
@@ -3072,7 +3060,7 @@ static void free_swap_cluster_info(struc
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

mm-mglru-consolidate-common-code-for-retrieving-evictable-size.patch
mm-mglru-rename-variables-related-to-aging-and-rotation.patch
mm-mglru-relocate-the-lru-scan-batch-limit-to-callers.patch
mm-mglru-restructure-the-reclaim-loop.patch
mm-mglru-scan-and-count-the-exact-number-of-folios.patch
mm-mglru-use-a-smaller-batch-for-reclaim.patch
mm-mglru-dont-abort-scan-immediately-right-after-aging.patch
mm-mglru-remove-redundant-swap-constrained-check-upon-isolation.patch
mm-mglru-use-the-common-routine-for-dirty-writeback-reactivation.patch
mm-mglru-simplify-and-improve-dirty-writeback-handling.patch
mm-mglru-remove-no-longer-used-reclaim-argument-for-folio-protection.patch
mm-vmscan-remove-sc-file_taken.patch
mm-vmscan-remove-sc-unqueued_dirty.patch
mm-vmscan-unify-writeback-reclaim-statistic-and-throttling.patch
mm-swap-avoid-leaving-unused-extend-table-after-alloc-race.patch
mm-swap-simplify-swap-cache-allocation-helper.patch
mm-swap-move-common-swap-cache-operations-into-standalone-helpers.patch
mm-huge_memory-move-thp-gfp-limit-helper-into-header.patch
mm-swap-add-support-for-stable-large-allocation-in-swap-cache-directly.patch
mm-swap-unify-large-folio-allocation.patch
mm-memcg-swap-tidy-up-cgroup-v1-memsw-swap-helpers.patch
mm-swap-support-flexible-batch-freeing-of-slots-in-different-memcgs.patch
mm-swap-delay-and-unify-memcg-lookup-and-charging-for-swapin.patch
mm-swap-consolidate-cluster-allocation-helpers.patch
mm-memcg-swap-store-cgroup-id-in-cluster-table-directly.patch
mm-memcg-remove-no-longer-used-swap-cgroup-array.patch
mm-swap-merge-zeromap-into-swap-table.patch

