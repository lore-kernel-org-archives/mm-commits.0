Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B8432ABE1
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898414; cv=none; b=I0C+e9SS+N2z47PEV9Ilp8RzchH399/DfpeZgENADxaFzR1RmIudq7GQ8wY8n4+s+E+Tw0hXsBni5rs2+3DzxtgQr9N7ebfDrnnnpGGXzSSMBEjKQvPLTpY8lVYZNAHAnoNTxHYjD3SadoF5gbTjjlbtBWlZupVo+sHMy8z6LFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898414; c=relaxed/simple;
	bh=PMIvRk81rK4xtYdElX6N47arzxlc5j3LU+d/OxOEYr0=;
	h=Date:To:From:Subject:Message-Id; b=qcKYJEUk2kqTrBEMBF/r+WQ970PfeO7vIlY8IjgcwCs4DW7Bh4qvFMWWPfEsD+KZZaaFApMA6l2NpMPrYek3aF4NTKujql1c88XnZXALm2qeuo6BpCjznRTlEAgO7t0J3EWty9ZtspcqPEi6+xbGoYiAOGBuk9OTtBzyXPgrUsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ooq1MPWq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ooq1MPWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A302C4CEF1;
	Sat, 31 Jan 2026 22:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898414;
	bh=PMIvRk81rK4xtYdElX6N47arzxlc5j3LU+d/OxOEYr0=;
	h=Date:To:From:Subject:From;
	b=ooq1MPWqWoU+hvxTXX84+I3myeVLlR8C74bBGvsnYwxufJBb+DnXtMWc8Rtxea638
	 AJ7aGhtVv3j6gLkgE21+toG8m/Vo15/lRCy1WGJnjvZE+Ct4NicWX246odz9svuMu2
	 PalXrT9PmSxUMcTcnacjY7XrshI+eKMTRbP4g8XI=
Date: Sat, 31 Jan 2026 14:26:53 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,rafael@kernel.org,nphamcs@gmail.com,kartikey406@gmail.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-remove-workaround-for-unsynchronized-swap-map-cache-state.patch removed from -mm tree
Message-Id: <20260131222654.5A302C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: remove workaround for unsynchronized swap map cache state
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-workaround-for-unsynchronized-swap-map-cache-state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: remove workaround for unsynchronized swap map cache state
Date: Sat, 20 Dec 2025 03:43:42 +0800

Remove the "skip if exists" check from commit a65b0e7607ccb ("zswap: make
shrinking memcg-aware").  It was needed because there is a tiny time
window between setting the SWAP_HAS_CACHE bit and actually adding the
folio to the swap cache.  If a user is trying to add the folio into the
swap cache but another user was interrupted after setting SWAP_HAS_CACHE
but hasn't added the folio to the swap cache yet, it might lead to a
deadlock.

We have moved the bit setting to the same critical section as adding the
folio, so this is no longer needed.  Remove it and clean it up.

Link: https://lkml.kernel.org/r/20251220-swap-table-p2-v5-13-8862a265a033@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h       |    2 +-
 mm/swap_state.c |   27 ++++++++++-----------------
 mm/zswap.c      |    2 +-
 3 files changed, 12 insertions(+), 19 deletions(-)

--- a/mm/swap.h~mm-swap-remove-workaround-for-unsynchronized-swap-map-cache-state
+++ a/mm/swap.h
@@ -260,7 +260,7 @@ int swap_cache_add_folio(struct folio *f
 void swap_cache_del_folio(struct folio *folio);
 struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_flags,
 				     struct mempolicy *mpol, pgoff_t ilx,
-				     bool *alloced, bool skip_if_exists);
+				     bool *alloced);
 /* Below helpers require the caller to lock and pass in the swap cluster. */
 void __swap_cache_del_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry, void *shadow);
--- a/mm/swap_state.c~mm-swap-remove-workaround-for-unsynchronized-swap-map-cache-state
+++ a/mm/swap_state.c
@@ -444,8 +444,6 @@ void swap_update_readahead(struct folio
  * @folio: folio to be added.
  * @gfp: memory allocation flags for charge, can be 0 if @charged if true.
  * @charged: if the folio is already charged.
- * @skip_if_exists: if the slot is in a cached state, return NULL.
- *                  This is an old workaround that will be removed shortly.
  *
  * Update the swap_map and add folio as swap cache, typically before swapin.
  * All swap slots covered by the folio must have a non-zero swap count.
@@ -456,8 +454,7 @@ void swap_update_readahead(struct folio
  */
 static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
 						  struct folio *folio,
-						  gfp_t gfp, bool charged,
-						  bool skip_if_exists)
+						  gfp_t gfp, bool charged)
 {
 	struct folio *swapcache = NULL;
 	void *shadow;
@@ -477,7 +474,7 @@ static struct folio *__swap_cache_prepar
 		 * might return a folio that is irrelevant to the faulting
 		 * entry because @entry is aligned down. Just return NULL.
 		 */
-		if (ret != -EEXIST || skip_if_exists || folio_test_large(folio))
+		if (ret != -EEXIST || folio_test_large(folio))
 			goto failed;
 
 		swapcache = swap_cache_get_folio(entry);
@@ -510,8 +507,6 @@ failed:
  * @mpol: NUMA memory allocation policy to be applied
  * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
  * @new_page_allocated: sets true if allocation happened, false otherwise
- * @skip_if_exists: if the slot is a partially cached state, return NULL.
- *                  This is a workaround that would be removed shortly.
  *
  * Allocate a folio in the swap cache for one swap slot, typically before
  * doing IO (e.g. swap in or zswap writeback). The swap slot indicated by
@@ -524,8 +519,7 @@ failed:
  */
 struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
 				     struct mempolicy *mpol, pgoff_t ilx,
-				     bool *new_page_allocated,
-				     bool skip_if_exists)
+				     bool *new_page_allocated)
 {
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct folio *folio;
@@ -546,8 +540,7 @@ struct folio *swap_cache_alloc_folio(swp
 	if (!folio)
 		return NULL;
 	/* Try add the new folio, returns existing folio or NULL on failure. */
-	result = __swap_cache_prepare_and_add(entry, folio, gfp_mask,
-					      false, skip_if_exists);
+	result = __swap_cache_prepare_and_add(entry, folio, gfp_mask, false);
 	if (result == folio)
 		*new_page_allocated = true;
 	else
@@ -576,7 +569,7 @@ struct folio *swapin_folio(swp_entry_t e
 	unsigned long nr_pages = folio_nr_pages(folio);
 
 	entry = swp_entry(swp_type(entry), round_down(offset, nr_pages));
-	swapcache = __swap_cache_prepare_and_add(entry, folio, 0, true, false);
+	swapcache = __swap_cache_prepare_and_add(entry, folio, 0, true);
 	if (swapcache == folio)
 		swap_read_folio(folio, NULL);
 	return swapcache;
@@ -604,7 +597,7 @@ struct folio *read_swap_cache_async(swp_
 
 	mpol = get_vma_policy(vma, addr, 0, &ilx);
 	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
-					&page_allocated, false);
+				       &page_allocated);
 	mpol_cond_put(mpol);
 
 	if (page_allocated)
@@ -723,7 +716,7 @@ struct folio *swap_cluster_readahead(swp
 		/* Ok, do the async read-ahead now */
 		folio = swap_cache_alloc_folio(
 			swp_entry(swp_type(entry), offset), gfp_mask, mpol, ilx,
-			&page_allocated, false);
+			&page_allocated);
 		if (!folio)
 			continue;
 		if (page_allocated) {
@@ -741,7 +734,7 @@ struct folio *swap_cluster_readahead(swp
 skip:
 	/* The page was likely read above, so no need for plugging here */
 	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
-					&page_allocated, false);
+				       &page_allocated);
 	if (unlikely(page_allocated))
 		swap_read_folio(folio, NULL);
 	return folio;
@@ -846,7 +839,7 @@ static struct folio *swap_vma_readahead(
 				continue;
 		}
 		folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
-						&page_allocated, false);
+					       &page_allocated);
 		if (si)
 			put_swap_device(si);
 		if (!folio)
@@ -868,7 +861,7 @@ static struct folio *swap_vma_readahead(
 skip:
 	/* The folio was likely read above, so no need for plugging here */
 	folio = swap_cache_alloc_folio(targ_entry, gfp_mask, mpol, targ_ilx,
-					&page_allocated, false);
+				       &page_allocated);
 	if (unlikely(page_allocated))
 		swap_read_folio(folio, NULL);
 	return folio;
--- a/mm/zswap.c~mm-swap-remove-workaround-for-unsynchronized-swap-map-cache-state
+++ a/mm/zswap.c
@@ -1014,7 +1014,7 @@ static int zswap_writeback_entry(struct
 
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, mpol,
-				       NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
+				       NO_INTERLEAVE_INDEX, &folio_was_allocated);
 	put_swap_device(si);
 	if (!folio)
 		return -ENOMEM;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-shmem-swap-fix-race-of-truncate-and-swap-entry-split.patch

