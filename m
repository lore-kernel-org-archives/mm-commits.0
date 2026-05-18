Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB80139A7E1
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779141130; cv=none; b=aqOBwBEoh48V2MvWxIAFTrpNcB2LYpReiKWWmGYoM0tOw8dmbPAIUS0YaFVEPUmf/v6gBYfysNQQN39sYu39i+yoH0BYkzKV36MSYMRSxsNAFR1oJBFHI8iaBLPnELkxR+2+bRiQUX4KgKDnflyfZCMvUeVnwEejJO8NMUPyLAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779141130; c=relaxed/simple;
	bh=S+kcbLGb1IPtqcRSMZXTlSr3upDeDNX1ANT1s5GQfFA=;
	h=Date:To:From:Subject:Message-Id; b=TExcCUVA9lCo/0odB1DvbMp0eNFwevLxIwHZSOOysOoJHzyfjO3U4KrjMYkBs7XwldmdWzOeNqFli4u/QQFeZx8DpaEznZ8ZVxJeJ9dFAnZGeK8QRh4RShjbYCrMjS3fuslc02Wb/ho3Y2fjMGLX9QQePKCJskju6v1gpP9ENtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1bD6ij/f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1bD6ij/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99477C2BCB7;
	Mon, 18 May 2026 21:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779141130;
	bh=S+kcbLGb1IPtqcRSMZXTlSr3upDeDNX1ANT1s5GQfFA=;
	h=Date:To:From:Subject:From;
	b=1bD6ij/fRe1KXwYXVr+MrSf9sfeyca6sPk1iPhTJ+Mov1CD/1nCnsaxVdjGHthq3g
	 oSTIj+46T2YiuzupNGhV59CYSbGV51h8x8Haw/1xq4xK0pS/HKSJZjti6zDZi5zQT/
	 uQjRzK/RPUrm93If/rCb52zMOUyiUFptWUYT0a38=
Date: Mon, 18 May 2026 14:52:10 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-add-support-for-stable-large-allocation-in-swap-cache-directly.patch added to mm-new branch
Message-Id: <20260518215210.99477C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: add support for stable large allocation in swap cache directly
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-add-support-for-stable-large-allocation-in-swap-cache-directly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-add-support-for-stable-large-allocation-in-swap-cache-directly.patch

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
Subject: mm, swap: add support for stable large allocation in swap cache directly
Date: Sun, 17 May 2026 23:39:43 +0800

To make it possible to allocate large folios directly in swap cache,
provide a new infrastructure helper to handle the swap cache status check,
allocation, and order fallback in the swap cache layer

The new helper replaces the existing swap_cache_alloc_folio.  Based on
this, all the separate swap folio allocation that is being done by anon /
shmem before is converted to use this helper directly, unifying folio
allocation for anon, shmem, and readahead.

This slightly consolidates how allocation is synchronized, making it more
stable and less prone to errors.  The slot-count and cache-conflict check
is now always performed with the cluster lock held before allocation, and
repeated under the same lock right before cache insertion.  This double
check produces a stable result compared to the previous anon and shmem
mTHP allocation implementation, avoids the false-negative conflict checks
that the lockless path can return — large allocations no longer have to
be unwound because the range turned out to be occupied — and aborts
early for already-freed slots, which helps ordinary swapin and especially
readahead, with only a marginal increase in cluster-lock contention (the
lock is very lightly contended and stays local in the first place). 
Hence, callers of swap_cache_alloc_folio() no longer need to check the
swap slot count or swap cache status themselves.

And now whoever first successfully allocates a folio in the swap cache
will be the one who charges it and performs the swap-in.  The race window
of swapping is also reduced since the loop is much more compact.

Link: https://lore.kernel.org/20260517-swap-table-p4-v5-4-88ae43e064c7@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
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

 mm/swap.h       |    3 
 mm/swap_state.c |  236 ++++++++++++++++++++++++++++++++--------------
 mm/zswap.c      |    2 
 3 files changed, 170 insertions(+), 71 deletions(-)

--- a/mm/swap.h~mm-swap-add-support-for-stable-large-allocation-in-swap-cache-directly
+++ a/mm/swap.h
@@ -280,7 +280,8 @@ bool swap_cache_has_folio(swp_entry_t en
 struct folio *swap_cache_get_folio(swp_entry_t entry);
 void *swap_cache_get_shadow(swp_entry_t entry);
 void swap_cache_del_folio(struct folio *folio);
-struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_flags,
+struct folio *swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
+				     unsigned long orders, struct vm_fault *vmf,
 				     struct mempolicy *mpol, pgoff_t ilx);
 /* Below helpers require the caller to lock and pass in the swap cluster. */
 void __swap_cache_add_folio(struct swap_cluster_info *ci,
--- a/mm/swap_state.c~mm-swap-add-support-for-stable-large-allocation-in-swap-cache-directly
+++ a/mm/swap_state.c
@@ -139,10 +139,10 @@ void *swap_cache_get_shadow(swp_entry_t
 
 /**
  * __swap_cache_add_check - Check if a range is suitable for adding a folio.
- * @ci: The locked swap cluster.
- * @ci_off: Range start offset.
- * @nr: Number of slots to check.
- * @shadow: Returns the shadow value if one exists in the range.
+ * @ci: The locked swap cluster
+ * @targ_entry: The target swap entry to check, will be rounded down by @nr
+ * @nr: Number of slots to check, must be a power of 2
+ * @shadowp: Returns the shadow value if one exists in the range.
  *
  * Check if all slots covered by given range have a swap count >= 1.
  * Retrieves the shadow if there is one.
@@ -151,26 +151,40 @@ void *swap_cache_get_shadow(swp_entry_t
  * Return: 0 if success, error code if failed.
  */
 static int __swap_cache_add_check(struct swap_cluster_info *ci,
-				  unsigned int ci_off, unsigned int nr,
-				  void **shadow)
+				  swp_entry_t targ_entry,
+				  unsigned long nr, void **shadowp)
 {
-	unsigned int ci_end = ci_off + nr;
+	unsigned int ci_off, ci_end;
 	unsigned long old_tb;
 
 	lockdep_assert_held(&ci->lock);
-	if (WARN_ON_ONCE(ci_off >= SWAPFILE_CLUSTER))
-		return -EINVAL;
 
+	/*
+	 * If the target slot is not swapped out or already cached, return
+	 * -ENOENT or -EEXIST. If the batch is not suitable, could be a
+	 * race with concurrent free or cache add, return -EBUSY.
+	 */
 	if (unlikely(!ci->table))
 		return -ENOENT;
+	ci_off = swp_cluster_offset(targ_entry);
+	old_tb = __swap_table_get(ci, ci_off);
+	if (swp_tb_is_folio(old_tb))
+		return -EEXIST;
+	if (!__swp_tb_get_count(old_tb))
+		return -ENOENT;
+	if (swp_tb_is_shadow(old_tb) && shadowp)
+		*shadowp = swp_tb_to_shadow(old_tb);
+
+	if (nr == 1)
+		return 0;
+
+	ci_off = round_down(ci_off, nr);
+	ci_end = ci_off + nr;
 	do {
 		old_tb = __swap_table_get(ci, ci_off);
-		if (unlikely(swp_tb_is_folio(old_tb)))
-			return -EEXIST;
-		if (unlikely(!__swp_tb_get_count(old_tb)))
-			return -ENOENT;
-		if (swp_tb_is_shadow(old_tb))
-			*shadow = swp_tb_to_shadow(old_tb);
+		if (unlikely(swp_tb_is_folio(old_tb) ||
+			     !__swp_tb_get_count(old_tb)))
+			return -EBUSY;
 	} while (++ci_off < ci_end);
 
 	return 0;
@@ -241,15 +255,13 @@ static int swap_cache_add_folio(struct f
 {
 	int err;
 	void *shadow = NULL;
-	unsigned int ci_off;
 	struct swap_info_struct *si;
 	struct swap_cluster_info *ci;
 	unsigned long nr_pages = folio_nr_pages(folio);
 
 	si = __swap_entry_to_info(entry);
 	ci = swap_cluster_lock(si, swp_offset(entry));
-	ci_off = swp_cluster_offset(entry);
-	err = __swap_cache_add_check(ci, ci_off, nr_pages, &shadow);
+	err = __swap_cache_add_check(ci, entry, nr_pages, &shadow);
 	if (err) {
 		swap_cluster_unlock(ci);
 		return err;
@@ -405,6 +417,142 @@ void __swap_cache_replace_folio(struct s
 }
 
 /*
+ * Try to allocate a folio of given order in the swap cache.
+ *
+ * This helper resolves the potential races of swap allocation
+ * and prepares a folio to be used for swap IO. May return following
+ * value:
+ *
+ * -ENOMEM / -EBUSY: Order is too large or in conflict with sub slot,
+ *                   caller should shrink the order and retry
+ * -ENOENT / -EEXIST: Target swap entry is unavailable or cached, the caller
+ *                    should abort or try to use the cached folio instead
+ */
+static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
+					swp_entry_t targ_entry, gfp_t gfp,
+					unsigned int order, struct vm_fault *vmf,
+					struct mempolicy *mpol, pgoff_t ilx)
+{
+	int err;
+	swp_entry_t entry;
+	struct folio *folio;
+	void *shadow = NULL;
+	unsigned long address, nr_pages = 1UL << order;
+	struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
+
+	VM_WARN_ON_ONCE(nr_pages > SWAPFILE_CLUSTER);
+	entry.val = round_down(targ_entry.val, nr_pages);
+
+	/* Check if the slot and range are available, skip allocation if not */
+	spin_lock(&ci->lock);
+	err = __swap_cache_add_check(ci, targ_entry, nr_pages, NULL);
+	spin_unlock(&ci->lock);
+	if (unlikely(err))
+		return ERR_PTR(err);
+
+	/*
+	 * Limit THP gfp. The limitation is a no-op for typical
+	 * GFP_HIGHUSER_MOVABLE but matters for shmem.
+	 */
+	if (order)
+		gfp = thp_shmem_limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
+
+	if (mpol || !vmf) {
+		folio = folio_alloc_mpol(gfp, order, mpol, ilx, numa_node_id());
+	} else {
+		address = round_down(vmf->address, PAGE_SIZE << order);
+		folio = vma_alloc_folio(gfp, order, vmf->vma, address);
+	}
+	if (unlikely(!folio))
+		return ERR_PTR(-ENOMEM);
+
+	/* Double check the range is still not in conflict */
+	spin_lock(&ci->lock);
+	err = __swap_cache_add_check(ci, targ_entry, nr_pages, &shadow);
+	if (unlikely(err)) {
+		spin_unlock(&ci->lock);
+		folio_put(folio);
+		return ERR_PTR(err);
+	}
+
+	__folio_set_locked(folio);
+	__folio_set_swapbacked(folio);
+	__swap_cache_do_add_folio(ci, folio, entry);
+	spin_unlock(&ci->lock);
+
+	if (mem_cgroup_swapin_charge_folio(folio, vmf ? vmf->vma->vm_mm : NULL,
+					   gfp, entry)) {
+		spin_lock(&ci->lock);
+		__swap_cache_do_del_folio(ci, folio, entry, shadow);
+		spin_unlock(&ci->lock);
+		folio_unlock(folio);
+		/* nr_pages refs from swap cache, 1 from allocation */
+		folio_put_refs(folio, nr_pages + 1);
+		count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK_CHARGE);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/* For memsw accounting, swap is uncharged when folio is added to swap cache */
+	memcg1_swapin(entry, 1 << order);
+	if (shadow)
+		workingset_refault(folio, shadow);
+
+	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
+	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
+
+	/* Caller will initiate read into locked new_folio */
+	folio_add_lru(folio);
+	return folio;
+}
+
+/**
+ * swap_cache_alloc_folio - Allocate folio for swapped out slot in swap cache.
+ * @targ_entry: swap entry indicating the target slot
+ * @gfp: memory allocation flags
+ * @orders: allocation orders, must be non zero
+ * @vmf: fault information
+ * @mpol: NUMA memory allocation policy to be applied
+ * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
+ *
+ * Allocate a folio in the swap cache for one swap slot, typically before
+ * doing IO (e.g. swap in or zswap writeback). The swap slot indicated by
+ * @targ_entry must have a non-zero swap count (swapped out).
+ *
+ * Context: Caller must protect the swap device with reference count or locks.
+ * Return: Returns the folio if allocation succeeded and folio is in the swap
+ * cache. Returns error code if failed due to race, OOM or invalid arguments.
+ */
+struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
+				     unsigned long orders, struct vm_fault *vmf,
+				     struct mempolicy *mpol, pgoff_t ilx)
+{
+	int order, err;
+	struct folio *ret;
+	struct swap_cluster_info *ci;
+
+	ci = __swap_entry_to_cluster(targ_entry);
+	order = highest_order(orders);
+
+	/* orders must be non-zero, and must not exceed cluster size. */
+	if (WARN_ON_ONCE(!orders || (1UL << order) > SWAPFILE_CLUSTER))
+		return ERR_PTR(-EINVAL);
+
+	do {
+		ret = __swap_cache_alloc(ci, targ_entry, gfp, order,
+					 vmf, mpol, ilx);
+		if (!IS_ERR(ret))
+			break;
+		err = PTR_ERR(ret);
+		if (!order || (err && err != -EBUSY && err != -ENOMEM))
+			break;
+		count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK);
+		order = next_order(&orders, order);
+	} while (orders);
+
+	return ret;
+}
+
+/*
  * If we are the only user, then try to free up the swap cache.
  *
  * Its ok to check the swapcache flag without the folio lock
@@ -547,68 +695,18 @@ failed:
 	return ret;
 }
 
-/**
- * swap_cache_alloc_folio - Allocate folio for swapped out slot in swap cache.
- * @entry: the swapped out swap entry to be binded to the folio.
- * @gfp_mask: memory allocation flags
- * @mpol: NUMA memory allocation policy to be applied
- * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
- *
- * Allocate a folio in the swap cache for one swap slot, typically before
- * doing IO (e.g. swap in or zswap writeback). The swap slot indicated by
- * @entry must have a non-zero swap count (swapped out).
- * Currently only supports order 0.
- *
- * Context: Caller must protect the swap device with reference count or locks.
- * Return: Returns the folio if allocation succeeded and folio is added to
- * swap cache. Returns error code if allocation failed due to race or OOM.
- */
-struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
-				     struct mempolicy *mpol, pgoff_t ilx)
-{
-	int err;
-	struct folio *folio;
-
-	/* Allocate a new folio to be added into the swap cache. */
-	folio = folio_alloc_mpol(gfp_mask, 0, mpol, ilx, numa_node_id());
-	if (!folio)
-		return ERR_PTR(-ENOMEM);
-
-	/*
-	 * Try to add the new folio to the swap cache. It returns
-	 * -EEXIST if the entry is already cached.
-	 */
-	err = __swap_cache_prepare_and_add(entry, folio, gfp_mask, false);
-	if (err) {
-		folio_put(folio);
-		return ERR_PTR(err);
-	}
-
-	return folio;
-}
-
 static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
 					   struct mempolicy *mpol, pgoff_t ilx,
 					   struct swap_iocb **plug, bool readahead)
 {
-	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct folio *folio;
 
-	/* Check the swap cache again for readahead path. */
-	folio = swap_cache_get_folio(entry);
-	if (folio)
-		return folio;
-
-	/* Skip allocation for unused and bad swap slot for readahead. */
-	if (!swap_entry_swapped(si, entry))
-		return NULL;
-
 	do {
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
 
-		folio = swap_cache_alloc_folio(entry, gfp, mpol, ilx);
+		folio = swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR_OR_NULL(folio))
--- a/mm/zswap.c~mm-swap-add-support-for-stable-large-allocation-in-swap-cache-directly
+++ a/mm/zswap.c
@@ -1000,7 +1000,7 @@ static int zswap_writeback_entry(struct
 		return -EEXIST;
 
 	mpol = get_task_policy(current);
-	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, mpol,
+	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
 				       NO_INTERLEAVE_INDEX);
 	put_swap_device(si);
 
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

