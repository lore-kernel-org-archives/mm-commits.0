Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E457B2FE566
	for <mm-commits@vger.kernel.org>; Sat, 20 Dec 2025 22:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766268299; cv=none; b=L6wsDnRX0nSupBQceJQrv44epTkqahnr1rfroulYtu1EyahdS1a/r29m6FVp814JFoynhtXvkd9JfYGf3255mrHSbiGZza3Rfa/7vzykkPs5FdhWZRRaUQLws71cm9WzCAEIW14PMLJvpcuS0JClh5EmnfIs+r3m+U5X2yWJpEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766268299; c=relaxed/simple;
	bh=1NFVRWhlxK1IEZDjqn5k6YN/p13SnoR5tIZmNjgblNk=;
	h=Date:To:From:Subject:Message-Id; b=DH1ZOyrMOeyUaaVoA1hsxvkTiY4wv8k/WpVVXWYm3p0Faz1GgTrCIvpx6l4mt6VOLkEEbmXxf1L6SjbCDYznNHZGmRZQrC5aIS2ve1zniGqcxBuBnwjF23x1iXRQNoKfLd5uuznikd/16DW3dy7rq1bx6xp0f0P83dEc1zFrLJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uQQ1q3bY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uQQ1q3bY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6322EC4CEF5;
	Sat, 20 Dec 2025 22:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766268298;
	bh=1NFVRWhlxK1IEZDjqn5k6YN/p13SnoR5tIZmNjgblNk=;
	h=Date:To:From:Subject:From;
	b=uQQ1q3bYHg/51kfl0r2M7AYKVC5zQJFvP4hNCBctGGUTJcPLjGyMtFDT0ebT/Dgfm
	 ZDSao96o3ResTDHKeIk/ZYnFqqx+SkQB21LivbxuTFj4eyA1Vd75GOyQ39L0/WgCoK
	 ETnzjw64cWW0wfXUV5ZdpjHbGYIW83QdsAcEsqU8=
Date: Sat, 20 Dec 2025 14:04:57 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,rafael@kernel.org,nphamcs@gmail.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-never-bypass-the-swap-cache-for-swp_synchronous_io.patch added to mm-new branch
Message-Id: <20251220220458.6322EC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem: never bypass the swap cache for SWP_SYNCHRONOUS_IO
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-never-bypass-the-swap-cache-for-swp_synchronous_io.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-never-bypass-the-swap-cache-for-swp_synchronous_io.patch

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
Subject: mm/shmem: never bypass the swap cache for SWP_SYNCHRONOUS_IO
Date: Sat, 20 Dec 2025 03:57:51 +0800

Now the overhead of the swap cache is trivial to none, bypassing the swap
cache is no longer a good optimization.

We have removed the cache bypass swapin for anon memory, now do the same
for shmem.  Many helpers and functions can be dropped now.

The performance may slightly drop because of the co-existence and double
update of swap_map and swap table, and this problem will be improved very
soon in later commits by dropping the swap_map update partially:

Swapin of 24 GB file with tmpfs with
transparent_hugepage_tmpfs=within_size and ZRAM, 3 test runs on my
machine:

Before:  After this commit:  After this series:
5.99s    6.29s               6.08s

And later swap table phases will drop the swap_map completely to avoid
overhead and reduce memory usage.

Link: https://lkml.kernel.org/r/20251219195751.61328-1-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c    |   65 +++++++++++++-----------------------------------
 mm/swap.h     |    4 --
 mm/swapfile.c |   35 ++++++-------------------
 3 files changed, 27 insertions(+), 77 deletions(-)

--- a/mm/shmem.c~mm-shmem-never-bypass-the-swap-cache-for-swp_synchronous_io
+++ a/mm/shmem.c
@@ -2014,10 +2014,9 @@ static struct folio *shmem_swap_alloc_fo
 		swp_entry_t entry, int order, gfp_t gfp)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	struct folio *new, *swapcache;
 	int nr_pages = 1 << order;
-	struct folio *new;
 	gfp_t alloc_gfp;
-	void *shadow;
 
 	/*
 	 * We have arrived here because our zones are constrained, so don't
@@ -2057,34 +2056,19 @@ retry:
 		goto fallback;
 	}
 
-	/*
-	 * Prevent parallel swapin from proceeding with the swap cache flag.
-	 *
-	 * Of course there is another possible concurrent scenario as well,
-	 * that is to say, the swap cache flag of a large folio has already
-	 * been set by swapcache_prepare(), while another thread may have
-	 * already split the large swap entry stored in the shmem mapping.
-	 * In this case, shmem_add_to_page_cache() will help identify the
-	 * concurrent swapin and return -EEXIST.
-	 */
-	if (swapcache_prepare(entry, nr_pages)) {
+	swapcache = swapin_folio(entry, new);
+	if (swapcache != new) {
 		folio_put(new);
-		new = ERR_PTR(-EEXIST);
-		/* Try smaller folio to avoid cache conflict */
-		goto fallback;
+		if (!swapcache) {
+			/*
+			 * The new folio is charged already, swapin can
+			 * only fail due to another raced swapin.
+			 */
+			new = ERR_PTR(-EEXIST);
+			goto fallback;
+		}
 	}
-
-	__folio_set_locked(new);
-	__folio_set_swapbacked(new);
-	new->swap = entry;
-
-	memcg1_swapin(entry, nr_pages);
-	shadow = swap_cache_get_shadow(entry);
-	if (shadow)
-		workingset_refault(new, shadow);
-	folio_add_lru(new);
-	swap_read_folio(new, NULL);
-	return new;
+	return swapcache;
 fallback:
 	/* Order 0 swapin failed, nothing to fallback to, abort */
 	if (!order)
@@ -2174,8 +2158,7 @@ static int shmem_replace_folio(struct fo
 }
 
 static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
-					 struct folio *folio, swp_entry_t swap,
-					 bool skip_swapcache)
+					 struct folio *folio, swp_entry_t swap)
 {
 	struct address_space *mapping = inode->i_mapping;
 	swp_entry_t swapin_error;
@@ -2191,8 +2174,7 @@ static void shmem_set_folio_swapin_error
 
 	nr_pages = folio_nr_pages(folio);
 	folio_wait_writeback(folio);
-	if (!skip_swapcache)
-		swap_cache_del_folio(folio);
+	swap_cache_del_folio(folio);
 	/*
 	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks
 	 * won't be 0 when inode is released and thus trigger WARN_ON(i_blocks)
@@ -2292,7 +2274,6 @@ static int shmem_swapin_folio(struct ino
 	softleaf_t index_entry;
 	struct swap_info_struct *si;
 	struct folio *folio = NULL;
-	bool skip_swapcache = false;
 	int error, nr_pages, order;
 	pgoff_t offset;
 
@@ -2335,7 +2316,6 @@ static int shmem_swapin_folio(struct ino
 				folio = NULL;
 				goto failed;
 			}
-			skip_swapcache = true;
 		} else {
 			/* Cached swapin only supports order 0 folio */
 			folio = shmem_swapin_cluster(swap, gfp, info, index);
@@ -2391,9 +2371,8 @@ static int shmem_swapin_folio(struct ino
 	 * and swap cache folios are never partially freed.
 	 */
 	folio_lock(folio);
-	if ((!skip_swapcache && !folio_test_swapcache(folio)) ||
-	    shmem_confirm_swap(mapping, index, swap) < 0 ||
-	    folio->swap.val != swap.val) {
+	if (!folio_matches_swap_entry(folio, swap) ||
+	    shmem_confirm_swap(mapping, index, swap) < 0) {
 		error = -EEXIST;
 		goto unlock;
 	}
@@ -2425,12 +2404,7 @@ static int shmem_swapin_folio(struct ino
 	if (sgp == SGP_WRITE)
 		folio_mark_accessed(folio);
 
-	if (skip_swapcache) {
-		folio->swap.val = 0;
-		swapcache_clear(si, swap, nr_pages);
-	} else {
-		swap_cache_del_folio(folio);
-	}
+	swap_cache_del_folio(folio);
 	folio_mark_dirty(folio);
 	swap_free_nr(swap, nr_pages);
 	put_swap_device(si);
@@ -2441,14 +2415,11 @@ failed:
 	if (shmem_confirm_swap(mapping, index, swap) < 0)
 		error = -EEXIST;
 	if (error == -EIO)
-		shmem_set_folio_swapin_error(inode, index, folio, swap,
-					     skip_swapcache);
+		shmem_set_folio_swapin_error(inode, index, folio, swap);
 unlock:
 	if (folio)
 		folio_unlock(folio);
 failed_nolock:
-	if (skip_swapcache)
-		swapcache_clear(si, folio->swap, folio_nr_pages(folio));
 	if (folio)
 		folio_put(folio);
 	put_swap_device(si);
--- a/mm/swapfile.c~mm-shmem-never-bypass-the-swap-cache-for-swp_synchronous_io
+++ a/mm/swapfile.c
@@ -1614,22 +1614,6 @@ put_out:
 	return NULL;
 }
 
-static void swap_entries_put_cache(struct swap_info_struct *si,
-				   swp_entry_t entry, int nr)
-{
-	unsigned long offset = swp_offset(entry);
-	struct swap_cluster_info *ci;
-
-	ci = swap_cluster_lock(si, offset);
-	if (swap_only_has_cache(si, offset, nr)) {
-		swap_entries_free(si, ci, entry, nr);
-	} else {
-		for (int i = 0; i < nr; i++, entry.val++)
-			swap_entry_put_locked(si, ci, entry, SWAP_HAS_CACHE);
-	}
-	swap_cluster_unlock(ci);
-}
-
 static bool swap_entries_put_map(struct swap_info_struct *si,
 				 swp_entry_t entry, int nr)
 {
@@ -1765,13 +1749,21 @@ void swap_free_nr(swp_entry_t entry, int
 void put_swap_folio(struct folio *folio, swp_entry_t entry)
 {
 	struct swap_info_struct *si;
+	struct swap_cluster_info *ci;
+	unsigned long offset = swp_offset(entry);
 	int size = 1 << swap_entry_order(folio_order(folio));
 
 	si = _swap_info_get(entry);
 	if (!si)
 		return;
 
-	swap_entries_put_cache(si, entry, size);
+	ci = swap_cluster_lock(si, offset);
+	if (swap_only_has_cache(si, offset, size))
+		swap_entries_free(si, ci, entry, size);
+	else
+		for (int i = 0; i < size; i++, entry.val++)
+			swap_entry_put_locked(si, ci, entry, SWAP_HAS_CACHE);
+	swap_cluster_unlock(ci);
 }
 
 int __swap_count(swp_entry_t entry)
@@ -3785,15 +3777,6 @@ int swapcache_prepare(swp_entry_t entry,
 }
 
 /*
- * Caller should ensure entries belong to the same folio so
- * the entries won't span cross cluster boundary.
- */
-void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr)
-{
-	swap_entries_put_cache(si, entry, nr);
-}
-
-/*
  * add_swap_count_continuation - called when a swap count is duplicated
  * beyond SWAP_MAP_MAX, it allocates a new page and links that to the entry's
  * page of the original vmalloc'ed swap_map, to hold the continuation count
--- a/mm/swap.h~mm-shmem-never-bypass-the-swap-cache-for-swp_synchronous_io
+++ a/mm/swap.h
@@ -403,10 +403,6 @@ static inline int swap_writeout(struct f
 	return 0;
 }
 
-static inline void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr)
-{
-}
-
 static inline struct folio *swap_cache_get_folio(swp_entry_t entry)
 {
 	return NULL;
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

