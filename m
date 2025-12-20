Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848662FE04E
	for <mm-commits@vger.kernel.org>; Sat, 20 Dec 2025 22:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766268315; cv=none; b=p8mc9UItOG+5Fu/Gw6cZJgpTaGFKeFhw8Pfa5xmUYcT8t8mV3Q9U+ZArcFatqbkXIrmGbwYJeF4zUyJF/DfYYz4yGOoZlJe2uqy/ZBPIauvUvQzitMDJzZa7B639Pj2p3AoT54i/tOjZ6KzZLq1F9/mYmIaUddX1Tt+Po7YDZ84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766268315; c=relaxed/simple;
	bh=gxvctDdECXhZh4bk+eGhqzh2FjuMxeoVVC1hbxOXPQw=;
	h=Date:To:From:Subject:Message-Id; b=tFoDAKs6dOjyU73mbo7lMNhfXmb9WCxLI3eQOiIUffLnd/OFbyf02ya5H/CfjXyDV3eCvKPBiENuOvccI31EItTsSlaEnMV6xBEiFQvhirn2wrUuEMTwqefYRa0w1+wnnxK1jUkAswaiLb3OWcDD8gQ1rBXkQnI43V+/aZkmgo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zkTNPdiO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zkTNPdiO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587F9C4CEF5;
	Sat, 20 Dec 2025 22:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766268315;
	bh=gxvctDdECXhZh4bk+eGhqzh2FjuMxeoVVC1hbxOXPQw=;
	h=Date:To:From:Subject:From;
	b=zkTNPdiOVeEex9zGf6XojUOr7790RFEf8G05EQhrcgn176A648mObW+XQegVRwFcg
	 JMa1SfNS8U6T+qjgHvGMR8iONqdsqCvFxSHPpVUtr1yJU2N2lFD4eSeZRA4k4XazV3
	 F/8PFYJoHtEgoaWYGPEY2Kq4zUnlGUz6rAN2eImk=
Date: Sat, 20 Dec 2025 14:05:14 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,rafael@kernel.org,nphamcs@gmail.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remove-workaround-for-unsynchronized-swap-map-cache-state.patch added to mm-new branch
Message-Id: <20251220220515.587F9C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: remove workaround for unsynchronized swap map cache state
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-remove-workaround-for-unsynchronized-swap-map-cache-state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-remove-workaround-for-unsynchronized-swap-map-cache-state.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
@@ -445,8 +445,6 @@ void swap_update_readahead(struct folio
  * @folio: folio to be added.
  * @gfp: memory allocation flags for charge, can be 0 if @charged if true.
  * @charged: if the folio is already charged.
- * @skip_if_exists: if the slot is in a cached state, return NULL.
- *                  This is an old workaround that will be removed shortly.
  *
  * Update the swap_map and add folio as swap cache, typically before swapin.
  * All swap slots covered by the folio must have a non-zero swap count.
@@ -457,8 +455,7 @@ void swap_update_readahead(struct folio
  */
 static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
 						  struct folio *folio,
-						  gfp_t gfp, bool charged,
-						  bool skip_if_exists)
+						  gfp_t gfp, bool charged)
 {
 	struct folio *swapcache = NULL;
 	void *shadow;
@@ -478,7 +475,7 @@ static struct folio *__swap_cache_prepar
 		 * might return a folio that is irrelevant to the faulting
 		 * entry because @entry is aligned down. Just return NULL.
 		 */
-		if (ret != -EEXIST || skip_if_exists || folio_test_large(folio))
+		if (ret != -EEXIST || folio_test_large(folio))
 			goto failed;
 
 		swapcache = swap_cache_get_folio(entry);
@@ -511,8 +508,6 @@ failed:
  * @mpol: NUMA memory allocation policy to be applied
  * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
  * @new_page_allocated: sets true if allocation happened, false otherwise
- * @skip_if_exists: if the slot is a partially cached state, return NULL.
- *                  This is a workaround that would be removed shortly.
  *
  * Allocate a folio in the swap cache for one swap slot, typically before
  * doing IO (e.g. swap in or zswap writeback). The swap slot indicated by
@@ -525,8 +520,7 @@ failed:
  */
 struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
 				     struct mempolicy *mpol, pgoff_t ilx,
-				     bool *new_page_allocated,
-				     bool skip_if_exists)
+				     bool *new_page_allocated)
 {
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct folio *folio;
@@ -547,8 +541,7 @@ struct folio *swap_cache_alloc_folio(swp
 	if (!folio)
 		return NULL;
 	/* Try add the new folio, returns existing folio or NULL on failure. */
-	result = __swap_cache_prepare_and_add(entry, folio, gfp_mask,
-					      false, skip_if_exists);
+	result = __swap_cache_prepare_and_add(entry, folio, gfp_mask, false);
 	if (result == folio)
 		*new_page_allocated = true;
 	else
@@ -577,7 +570,7 @@ struct folio *swapin_folio(swp_entry_t e
 	unsigned long nr_pages = folio_nr_pages(folio);
 
 	entry = swp_entry(swp_type(entry), round_down(offset, nr_pages));
-	swapcache = __swap_cache_prepare_and_add(entry, folio, 0, true, false);
+	swapcache = __swap_cache_prepare_and_add(entry, folio, 0, true);
 	if (swapcache == folio)
 		swap_read_folio(folio, NULL);
 	return swapcache;
@@ -605,7 +598,7 @@ struct folio *read_swap_cache_async(swp_
 
 	mpol = get_vma_policy(vma, addr, 0, &ilx);
 	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
-					&page_allocated, false);
+				       &page_allocated);
 	mpol_cond_put(mpol);
 
 	if (page_allocated)
@@ -724,7 +717,7 @@ struct folio *swap_cluster_readahead(swp
 		/* Ok, do the async read-ahead now */
 		folio = swap_cache_alloc_folio(
 			swp_entry(swp_type(entry), offset), gfp_mask, mpol, ilx,
-			&page_allocated, false);
+			&page_allocated);
 		if (!folio)
 			continue;
 		if (page_allocated) {
@@ -742,7 +735,7 @@ struct folio *swap_cluster_readahead(swp
 skip:
 	/* The page was likely read above, so no need for plugging here */
 	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
-					&page_allocated, false);
+				       &page_allocated);
 	if (unlikely(page_allocated))
 		swap_read_folio(folio, NULL);
 	return folio;
@@ -847,7 +840,7 @@ static struct folio *swap_vma_readahead(
 				continue;
 		}
 		folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
-						&page_allocated, false);
+					       &page_allocated);
 		if (si)
 			put_swap_device(si);
 		if (!folio)
@@ -869,7 +862,7 @@ static struct folio *swap_vma_readahead(
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
@@ -1013,7 +1013,7 @@ static int zswap_writeback_entry(struct
 
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, mpol,
-				       NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
+				       NO_INTERLEAVE_INDEX, &folio_was_allocated);
 	put_swap_device(si);
 	if (!folio)
 		return -ENOMEM;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-rename-__read_swap_cache_async-to-swap_cache_alloc_folio.patch
mm-swap-split-swap-cache-preparation-loop-into-a-standalone-helper.patch
mm-swap-never-bypass-the-swap-cache-even-for-swp_synchronous_io.patch
mm-swap-always-try-to-free-swap-cache-for-swp_synchronous_io-devices.patch
mm-swap-simplify-the-code-and-reduce-indention.patch
mm-swap-free-the-swap-cache-after-folio-is-mapped.patch
mm-shmem-never-bypass-the-swap-cache-for-swp_synchronous_io.patch
mm-swap-swap-entry-of-a-bad-slot-should-not-be-considered-as-swapped-out.patch
mm-swap-consolidate-cluster-reclaim-and-usability-check.patch
mm-swap-split-locked-entry-duplicating-into-a-standalone-helper.patch
mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer.patch
mm-swap-remove-workaround-for-unsynchronized-swap-map-cache-state.patch
mm-swap-cleanup-swap-entry-management-workflow.patch
mm-swap-add-folio-to-swap-cache-directly-on-allocation.patch
mm-swap-check-swap-table-directly-for-checking-cache.patch
mm-swap-clean-up-and-improve-swap-entries-freeing.patch
mm-swap-drop-the-swap_has_cache-flag.patch
mm-swap-remove-no-longer-needed-_swap_info_get.patch

