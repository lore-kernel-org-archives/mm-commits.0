Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD2139B498
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779141122; cv=none; b=P5GQnvSbPntxb6tkH+zX2A8nFcsU6WItQaKOCN4DFbyqe8uoW4WIku86TrJKGz4i71E3EDBxCW/DWhmnhYkfAwRT5RDxslZzo2xn9FJEx+M/hNUa29VNp3rPPmWPAq1EeqGqMR5TeVkxl16Sww07K7nAuu56M3mAHVpt0N2J7X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779141122; c=relaxed/simple;
	bh=sQIiqxKHP8rwLmX9oCtjLn/lrgvtiN/CoG9JHCsvUMo=;
	h=Date:To:From:Subject:Message-Id; b=CWmHEqZ6E7Sf5fXjGfRCpu695SM6bf9Ja4xmvbFkxrT4fGKGEYAJu230WYD/+ROiHm7OOBinjavpeaAKwbXattltKfgKVX7o0zn141f18noVFprkWBHLM1tel6ls3qbC3+zNlt28a2mLo6ZqDoANPyJaz6iyHT9BKK5bGvspEv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LSJ8V/wc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LSJ8V/wc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A87EC2BCB7;
	Mon, 18 May 2026 21:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779141122;
	bh=sQIiqxKHP8rwLmX9oCtjLn/lrgvtiN/CoG9JHCsvUMo=;
	h=Date:To:From:Subject:From;
	b=LSJ8V/wcbs93HsdXwLLko0s+KToXW3BAUQTgKUyR8Q6MAfRZhusGtaK2R4yiG1SC2
	 9OdSEdudMnc5n5iNPJJWGcUSyMKJzV5XQakXaGWdiyEnxfjnG9usrHRgr7cvXpDPvb
	 /vs/fP8AA6Xjnliu0mm42USF2HJsxwUmFbL44rug=
Date: Mon, 18 May 2026 14:52:01 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-simplify-swap-cache-allocation-helper.patch added to mm-new branch
Message-Id: <20260518215202.1A87EC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: simplify swap cache allocation helper
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-simplify-swap-cache-allocation-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-simplify-swap-cache-allocation-helper.patch

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
Subject: mm, swap: simplify swap cache allocation helper
Date: Sun, 17 May 2026 23:39:40 +0800

This series unifies the allocation and charging of anon and shmem swap in
folios, provides better synchronization, consolidates the metadata
management, hence dropping the static array and map, and improves the
performance.  The static metadata overhead is now close to zero, and
workload performance is slightly improved.

For example, mounting a 1TB swap device saves about 512MB of memory:

Before:
free -m
          total   used      free   shared   buff/cache   available
Mem:       1464    805       346        1          382         658
Swap:   1048575      0   1048575

After:
free -m
          total   used      free   shared   buff/cache   available
Mem:       1464    277       899         1         356        1187
Swap:   1048575      0   1048575

Memory usage is ~512M lower, and we now have a close to 0 static overhead.
It was about 2 bytes per slot before, now roughly 0.09375 bytes per slot
(48 bytes ci info per cluster, which is 512 slots).

Performance test is also looking good, testing Redis in a 2G VM using 6G
ZRAM as swap:

valkey-server --maxmemory 2560M
redis-benchmark -r 3000000 -n 3000000 -d 1024 -c 12 -P 32 -t get

Before: 3385017.283654 RPS
After:  3433309.307292 RPS (1.42% better)

Testing with build kernel under global pressure on a 48c96t system,
limiting the total memory to 8G, using 12G ZRAM, 24 test runs, enabling
THP:

make -j96, using defconfig

Before: user time 2904.59s system time 4773.99s
After:  user time 2909.38s system time 4641.55s (2.77% better)

Testing with usemem on a 32c machine using 48G brd ramdisk and 16G RAM, 12
test run:

usemem --init-time -O -y -x -n 48 1G

Before: Throughput (Sum): 6482.58 MB/s Free Latency: 371371.67us
After:  Throughput (Sum): 6539.28 MB/s Free Latency: 363059.88us

Seems similar, or slightly better.

This series also reduces memory thrashing, I no longer see any: "Huh
VM_FAULT_OOM leaked out to the #PF handler.  Retrying PF", it was shown
several times during stress testing before this series when under great
pressure:

Before: grep -Ri VM_FAULT_OOM <test logs> | wc -l => 18
After:  grep -Ri VM_FAULT_OOM <test logs> | wc -l => 0


This patch (of 12):

Instead of trying to return the existing folio if the entry is already
cached in swap_cache_alloc_folio, simply return an error pointer if the
allocation failed, and drop the output argument that indicates what kind
of folio is actually returned.

And a proper wrapper swap_cache_read_folio that decouples and handles the
actual requirement - read in the folio, or return the already read folio
in cache.  This is what async swapin and readahead actually required.

As for zswap swap out, the caller just needs to abort if the allocation
fails because the entry is gone or already cached, so removing simplifies
the return argument, making it cleaner.

No feature change.

Link: https://lore.kernel.org/20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com
Link: https://lore.kernel.org/20260517-swap-table-p4-v5-1-88ae43e064c7@tencent.com
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
Cc: Zi Yan <ziy@nvidia.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h       |    3 
 mm/swap_state.c |  180 +++++++++++++++++++++++-----------------------
 mm/zswap.c      |   23 ++---
 3 files changed, 103 insertions(+), 103 deletions(-)

--- a/mm/swap.h~mm-swap-simplify-swap-cache-allocation-helper
+++ a/mm/swap.h
@@ -281,8 +281,7 @@ struct folio *swap_cache_get_folio(swp_e
 void *swap_cache_get_shadow(swp_entry_t entry);
 void swap_cache_del_folio(struct folio *folio);
 struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_flags,
-				     struct mempolicy *mpol, pgoff_t ilx,
-				     bool *alloced);
+				     struct mempolicy *mpol, pgoff_t ilx);
 /* Below helpers require the caller to lock and pass in the swap cluster. */
 void __swap_cache_add_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry);
--- a/mm/swap_state.c~mm-swap-simplify-swap-cache-allocation-helper
+++ a/mm/swap_state.c
@@ -459,54 +459,38 @@ void swap_update_readahead(struct folio
  * All swap slots covered by the folio must have a non-zero swap count.
  *
  * Context: Caller must protect the swap device with reference count or locks.
- * Return: Returns the folio being added on success. Returns the existing folio
- * if @entry is already cached. Returns NULL if raced with swapin or swapoff.
+ * Return: 0 if success, error code if failed.
  */
-static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
-						  struct folio *folio,
-						  gfp_t gfp, bool charged)
+static int __swap_cache_prepare_and_add(swp_entry_t entry,
+					struct folio *folio,
+					gfp_t gfp, bool charged)
 {
-	struct folio *swapcache = NULL;
 	void *shadow;
 	int ret;
 
 	__folio_set_locked(folio);
 	__folio_set_swapbacked(folio);
 
-	if (!charged && mem_cgroup_swapin_charge_folio(folio, NULL, gfp, entry))
+	if (!charged && mem_cgroup_swapin_charge_folio(folio, NULL, gfp, entry)) {
+		ret = -ENOMEM;
 		goto failed;
-
-	for (;;) {
-		ret = swap_cache_add_folio(folio, entry, &shadow);
-		if (!ret)
-			break;
-
-		/*
-		 * Large order allocation needs special handling on
-		 * race: if a smaller folio exists in cache, swapin needs
-		 * to fallback to order 0, and doing a swap cache lookup
-		 * might return a folio that is irrelevant to the faulting
-		 * entry because @entry is aligned down. Just return NULL.
-		 */
-		if (ret != -EEXIST || folio_test_large(folio))
-			goto failed;
-
-		swapcache = swap_cache_get_folio(entry);
-		if (swapcache)
-			goto failed;
 	}
 
+	ret = swap_cache_add_folio(folio, entry, &shadow);
+	if (ret)
+		goto failed;
+
 	memcg1_swapin(entry, folio_nr_pages(folio));
 	if (shadow)
 		workingset_refault(folio, shadow);
 
 	/* Caller will initiate read into locked folio */
 	folio_add_lru(folio);
-	return folio;
+	return 0;
 
 failed:
 	folio_unlock(folio);
-	return swapcache;
+	return ret;
 }
 
 /**
@@ -515,7 +499,6 @@ failed:
  * @gfp_mask: memory allocation flags
  * @mpol: NUMA memory allocation policy to be applied
  * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
- * @new_page_allocated: sets true if allocation happened, false otherwise
  *
  * Allocate a folio in the swap cache for one swap slot, typically before
  * doing IO (e.g. swap in or zswap writeback). The swap slot indicated by
@@ -523,18 +506,40 @@ failed:
  * Currently only supports order 0.
  *
  * Context: Caller must protect the swap device with reference count or locks.
- * Return: Returns the existing folio if @entry is cached already. Returns
- * NULL if failed due to -ENOMEM or @entry have a swap count < 1.
+ * Return: Returns the folio if allocation succeeded and folio is added to
+ * swap cache. Returns error code if allocation failed due to race or OOM.
  */
 struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
-				     struct mempolicy *mpol, pgoff_t ilx,
-				     bool *new_page_allocated)
+				     struct mempolicy *mpol, pgoff_t ilx)
+{
+	int err;
+	struct folio *folio;
+
+	/* Allocate a new folio to be added into the swap cache. */
+	folio = folio_alloc_mpol(gfp_mask, 0, mpol, ilx, numa_node_id());
+	if (!folio)
+		return ERR_PTR(-ENOMEM);
+
+	/*
+	 * Try to add the new folio to the swap cache. It returns
+	 * -EEXIST if the entry is already cached.
+	 */
+	err = __swap_cache_prepare_and_add(entry, folio, gfp_mask, false);
+	if (err) {
+		folio_put(folio);
+		return ERR_PTR(err);
+	}
+
+	return folio;
+}
+
+static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
+					   struct mempolicy *mpol, pgoff_t ilx,
+					   struct swap_iocb **plug, bool readahead)
 {
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct folio *folio;
-	struct folio *result = NULL;
 
-	*new_page_allocated = false;
 	/* Check the swap cache again for readahead path. */
 	folio = swap_cache_get_folio(entry);
 	if (folio)
@@ -544,17 +549,24 @@ struct folio *swap_cache_alloc_folio(swp
 	if (!swap_entry_swapped(si, entry))
 		return NULL;
 
-	/* Allocate a new folio to be added into the swap cache. */
-	folio = folio_alloc_mpol(gfp_mask, 0, mpol, ilx, numa_node_id());
-	if (!folio)
+	do {
+		folio = swap_cache_get_folio(entry);
+		if (folio)
+			return folio;
+
+		folio = swap_cache_alloc_folio(entry, gfp, mpol, ilx);
+	} while (PTR_ERR(folio) == -EEXIST);
+
+	if (IS_ERR_OR_NULL(folio))
 		return NULL;
-	/* Try add the new folio, returns existing folio or NULL on failure. */
-	result = __swap_cache_prepare_and_add(entry, folio, gfp_mask, false);
-	if (result == folio)
-		*new_page_allocated = true;
-	else
-		folio_put(folio);
-	return result;
+
+	swap_read_folio(folio, plug);
+	if (readahead) {
+		folio_set_readahead(folio);
+		count_vm_event(SWAP_RA);
+	}
+
+	return folio;
 }
 
 /**
@@ -573,15 +585,35 @@ struct folio *swap_cache_alloc_folio(swp
  */
 struct folio *swapin_folio(swp_entry_t entry, struct folio *folio)
 {
+	int ret;
 	struct folio *swapcache;
 	pgoff_t offset = swp_offset(entry);
 	unsigned long nr_pages = folio_nr_pages(folio);
 
 	entry = swp_entry(swp_type(entry), round_down(offset, nr_pages));
-	swapcache = __swap_cache_prepare_and_add(entry, folio, 0, true);
-	if (swapcache == folio)
-		swap_read_folio(folio, NULL);
-	return swapcache;
+	for (;;) {
+		ret = __swap_cache_prepare_and_add(entry, folio, 0, true);
+		if (!ret) {
+			swap_read_folio(folio, NULL);
+			break;
+		}
+
+		/*
+		 * Large order allocation needs special handling on
+		 * race: if a smaller folio exists in cache, swapin needs
+		 * to fall back to order 0, and doing a swap cache lookup
+		 * might return a folio that is irrelevant to the faulting
+		 * entry because @entry is aligned down. Just return NULL.
+		 */
+		if (ret != -EEXIST || nr_pages > 1)
+			return NULL;
+
+		swapcache = swap_cache_get_folio(entry);
+		if (swapcache)
+			return swapcache;
+	}
+
+	return folio;
 }
 
 /*
@@ -595,7 +627,6 @@ struct folio *read_swap_cache_async(swp_
 		struct swap_iocb **plug)
 {
 	struct swap_info_struct *si;
-	bool page_allocated;
 	struct mempolicy *mpol;
 	pgoff_t ilx;
 	struct folio *folio;
@@ -605,13 +636,9 @@ struct folio *read_swap_cache_async(swp_
 		return NULL;
 
 	mpol = get_vma_policy(vma, addr, 0, &ilx);
-	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
-				       &page_allocated);
+	folio = swap_cache_read_folio(entry, gfp_mask, mpol, ilx, plug, false);
 	mpol_cond_put(mpol);
 
-	if (page_allocated)
-		swap_read_folio(folio, plug);
-
 	put_swap_device(si);
 	return folio;
 }
@@ -696,7 +723,7 @@ static unsigned long swapin_nr_pages(uns
  * are fairly likely to have been swapped out from the same node.
  */
 struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
-				    struct mempolicy *mpol, pgoff_t ilx)
+				     struct mempolicy *mpol, pgoff_t ilx)
 {
 	struct folio *folio;
 	unsigned long entry_offset = swp_offset(entry);
@@ -706,7 +733,7 @@ struct folio *swap_cluster_readahead(swp
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct blk_plug plug;
 	struct swap_iocb *splug = NULL;
-	bool page_allocated;
+	swp_entry_t ra_entry;
 
 	mask = swapin_nr_pages(offset) - 1;
 	if (!mask)
@@ -723,18 +750,11 @@ struct folio *swap_cluster_readahead(swp
 	blk_start_plug(&plug);
 	for (offset = start_offset; offset <= end_offset ; offset++) {
 		/* Ok, do the async read-ahead now */
-		folio = swap_cache_alloc_folio(
-			swp_entry(swp_type(entry), offset), gfp_mask, mpol, ilx,
-			&page_allocated);
+		ra_entry = swp_entry(swp_type(entry), offset);
+		folio = swap_cache_read_folio(ra_entry, gfp_mask, mpol, ilx,
+					      &splug, offset != entry_offset);
 		if (!folio)
 			continue;
-		if (page_allocated) {
-			swap_read_folio(folio, &splug);
-			if (offset != entry_offset) {
-				folio_set_readahead(folio);
-				count_vm_event(SWAP_RA);
-			}
-		}
 		folio_put(folio);
 	}
 	blk_finish_plug(&plug);
@@ -742,11 +762,7 @@ struct folio *swap_cluster_readahead(swp
 	lru_add_drain();	/* Push any new pages onto the LRU now */
 skip:
 	/* The page was likely read above, so no need for plugging here */
-	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
-				       &page_allocated);
-	if (unlikely(page_allocated))
-		swap_read_folio(folio, NULL);
-	return folio;
+	return swap_cache_read_folio(entry, gfp_mask, mpol, ilx, NULL, false);
 }
 
 static int swap_vma_ra_win(struct vm_fault *vmf, unsigned long *start,
@@ -812,8 +828,7 @@ static struct folio *swap_vma_readahead(
 	pte_t *pte = NULL, pentry;
 	int win;
 	unsigned long start, end, addr;
-	pgoff_t ilx;
-	bool page_allocated;
+	pgoff_t ilx = targ_ilx;
 
 	win = swap_vma_ra_win(vmf, &start, &end);
 	if (win == 1)
@@ -847,19 +862,12 @@ static struct folio *swap_vma_readahead(
 			if (!si)
 				continue;
 		}
-		folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
-					       &page_allocated);
+		folio = swap_cache_read_folio(entry, gfp_mask, mpol, ilx,
+					      &splug, addr != vmf->address);
 		if (si)
 			put_swap_device(si);
 		if (!folio)
 			continue;
-		if (page_allocated) {
-			swap_read_folio(folio, &splug);
-			if (addr != vmf->address) {
-				folio_set_readahead(folio);
-				count_vm_event(SWAP_RA);
-			}
-		}
 		folio_put(folio);
 	}
 	if (pte)
@@ -869,10 +877,8 @@ static struct folio *swap_vma_readahead(
 	lru_add_drain();
 skip:
 	/* The folio was likely read above, so no need for plugging here */
-	folio = swap_cache_alloc_folio(targ_entry, gfp_mask, mpol, targ_ilx,
-				       &page_allocated);
-	if (unlikely(page_allocated))
-		swap_read_folio(folio, NULL);
+	folio = swap_cache_read_folio(targ_entry, gfp_mask, mpol, targ_ilx,
+				      NULL, false);
 	return folio;
 }
 
--- a/mm/zswap.c~mm-swap-simplify-swap-cache-allocation-helper
+++ a/mm/zswap.c
@@ -991,7 +991,6 @@ static int zswap_writeback_entry(struct
 	pgoff_t offset = swp_offset(swpentry);
 	struct folio *folio;
 	struct mempolicy *mpol;
-	bool folio_was_allocated;
 	struct swap_info_struct *si;
 	int ret = 0;
 
@@ -1002,22 +1001,18 @@ static int zswap_writeback_entry(struct
 
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, mpol,
-				       NO_INTERLEAVE_INDEX, &folio_was_allocated);
+				       NO_INTERLEAVE_INDEX);
 	put_swap_device(si);
-	if (!folio)
-		return -ENOMEM;
 
 	/*
-	 * Found an existing folio, we raced with swapin or concurrent
-	 * shrinker. We generally writeback cold folios from zswap, and
-	 * swapin means the folio just became hot, so skip this folio.
-	 * For unlikely concurrent shrinker case, it will be unlinked
-	 * and freed when invalidated by the concurrent shrinker anyway.
+	 * Swap cache allocation might fail due to OOM, or the entry
+	 * may already be cached due to concurrent swapin or have been
+	 * freed. If already cached, a concurrent swapin made the folio
+	 * hot, so skip it. For the unlikely concurrent shrinker case,
+	 * it will be unlinked and freed when invalidated anyway.
 	 */
-	if (!folio_was_allocated) {
-		ret = -EEXIST;
-		goto out;
-	}
+	if (IS_ERR(folio))
+		return PTR_ERR(folio);
 
 	/*
 	 * folio is locked, and the swapcache is now secured against
@@ -1057,7 +1052,7 @@ static int zswap_writeback_entry(struct
 	__swap_writepage(folio, NULL);
 
 out:
-	if (ret && ret != -EEXIST) {
+	if (ret) {
 		swap_cache_del_folio(folio);
 		folio_unlock(folio);
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

