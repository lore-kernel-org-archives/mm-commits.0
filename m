Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AAE35AC11
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 19:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790019951; cv=none; b=o4T2bYy9reOT1EyF02YbFbknM+TXc6dz6pu/dwyJNKLuLUbfy6KwUtPQ3ufvOX3pZQ4gtEmDGN5QrTVbo1STQS2xvsaM2xqNB5oknzu1LFHZ3Btg8KRAexCioo4akVru9tIaJZgPCu4zM2G6A8vj7m1zUdaLcUFjH3JW6yMQPjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790019951; c=relaxed/simple;
	bh=bI2wYNXXTcQ19IVbh14u52izc0VMDs6+b+F06FYY71k=;
	h=Date:To:From:Subject:Message-Id; b=hzgzLRbm7CKzXbNb6HEc1pg2AOwZuPXOIadxA/pOVXpk/UG6YIOr+lI/jqovfV+3oIJFj94JPtOZApRWek3talFARfMfVAe0qbSnogFUX3UftTvTNUF3rzLylhW2q5aJ/D9oTOHDCauFe8SZz7iCadvpmcCiMRbgvFswP2Ys5CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OLlagfvi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OLlagfvi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9281F000FF;
	Mon, 21 Sep 2026 19:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790019948;
	bh=CmhwetdMo2mkl5kvTG9xjpB4aG3hglzUCwxEiuWifCI=;
	h=Date:To:From:Subject;
	b=OLlagfviTbR6sjKVUNc8NozJu5Hnt9O+NTsYqVqXQttepR2M8Jpcl1+rbR/AFY6Rg
	 wXgQsAnpmxQeV5buiEG8Tbd75TMwQklU549ygnsrRBdwS7pJH4UgAUvtjiZIn9nzou
	 OQsNcvzw8L5BtMXyMKfceZTqej3EikFYVfrOJlZ0=
Date: Mon, 21 Sep 2026 12:45:47 -0700
To: mm-commits@vger.kernel.org,alex@ghiti.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-move-lru-insertion-out-of-the-swap-cache-allocator.patch added to mm-new branch
Message-Id: <20260921194548.2D9281F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: move LRU insertion out of the swap cache allocator
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-move-lru-insertion-out-of-the-swap-cache-allocator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-move-lru-insertion-out-of-the-swap-cache-allocator.patch

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
From: Alexandre Ghiti <alex@ghiti.fr>
Subject: mm: swap: move LRU insertion out of the swap cache allocator
Date: Mon, 21 Sep 2026 17:13:02 +0200

Patch series "mm: zswap: free cold writeback folios promptly", v6.

When zswap writes an entry back, it allocates an order-0 swap cache folio,
decompresses into it, and issues the write. The folio is cold by
construction, yet today it is left on the LRU for page reclaim to find and
free later. That wastes a reclaim scan and keeps cold memory resident
longer than necessary.

Rather than implement this in zswap, extend the existing dropbehind
mechanism to swap cache folios and have zswap opt into it (Yosry). A
PG_dropbehind folio is already dropped from its cache once writeback
completes instead of being left for reclaim; for a swap cache folio that
"drop" is removing it from the swap cache.

  Patch 1 - move LRU insertion out of the swap cache allocator into its
            callers, so zswap writeback can allocate off the LRU.

  Patch 2 - drop dropbehind swap cache folios on writeback completion.

  Patch 3 - zswap allocates its writeback folio off the LRU and marks it
            dropbehind, opting into the mechanism above.


This patch (of 3):

This is a preparatory patch.

swap_cache_alloc_folio() adds the new folio to the LRU itself, which
leaves its callers no way to act on the folio before it becomes visible
to reclaim.  Two users need exactly that:

 - moving the refault evaluation out of the swap cache folio allocation
   requires it to happen before folio_add_lru(): that consumes PG_active
   to file the folio on the inactive or the active list, and under MGLRU
   it also reads PG_workingset to pick the generation.  Setting either
   flag afterwards does not move the folio;

 - zswap writeback dropbehind needs the buffer folio to stay off the LRU
   entirely, as the per-CPU LRU batch would hold a reference on it and
   keep remove_mapping() from freeing it once writeback completes.

Defer the LRU insertion to the callers and rename the helper to
__swap_cache_alloc_folio(): each caller adds the folio right after the
allocation, so there is no functional change intended.

Link: https://lore.kernel.org/20260921151306.625134-1-alex@ghiti.fr
Link: https://lore.kernel.org/20260921151306.625134-2-alex@ghiti.fr
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chis Li <chrisl@kernel.org> (Google)
Cc: Christian Brauner (Amutable) <brauner@kernel.org>
Cc: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tal Zussman <tz2294@columbia.edu>
Cc: Wei Xu <weixugc@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Yuanchu Xie <yuanchu@google.com>
---

 mm/swap.h       |    6 +++---
 mm/swap_state.c |   20 ++++++++++++--------
 mm/swapfile.c   |    2 +-
 mm/zswap.c      |    5 +++--
 4 files changed, 19 insertions(+), 14 deletions(-)

--- a/mm/swapfile.c~mm-swap-move-lru-insertion-out-of-the-swap-cache-allocator
+++ a/mm/swapfile.c
@@ -1887,7 +1887,7 @@ void folio_put_swap(struct folio *folio,
  *   CPU1				CPU2
  *   do_swap_page()
  *     ...				swapoff+swapon
- *     swap_cache_alloc_folio()
+ *     __swap_cache_alloc_folio()
  *       // check swap_map
  *     // verify PTE not changed
  *
--- a/mm/swap.h~mm-swap-move-lru-insertion-out-of-the-swap-cache-allocator
+++ a/mm/swap.h
@@ -312,9 +312,9 @@ bool swap_cache_has_folio(swp_entry_t en
 struct folio *swap_cache_get_folio(swp_entry_t entry);
 void *swap_cache_get_shadow(swp_entry_t entry);
 void swap_cache_del_folio(struct folio *folio);
-struct folio *swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
-				     unsigned long orders, struct vm_fault *vmf,
-				     struct mempolicy *mpol, pgoff_t ilx);
+struct folio *__swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
+				       unsigned long orders, struct vm_fault *vmf,
+				       struct mempolicy *mpol, pgoff_t ilx);
 /* Below helpers require the caller to lock and pass in the swap cluster. */
 void __swap_cache_add_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry);
--- a/mm/swap_state.c~mm-swap-move-lru-insertion-out-of-the-swap-cache-allocator
+++ a/mm/swap_state.c
@@ -497,13 +497,11 @@ static struct folio *__swap_cache_alloc(
 	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
 
-	/* Caller will initiate read into locked new_folio */
-	folio_add_lru(folio);
 	return folio;
 }
 
 /**
- * swap_cache_alloc_folio - Allocate folio for swapped out slot in swap cache.
+ * __swap_cache_alloc_folio - Allocate folio for swapped out slot in swap cache.
  * @targ_entry: swap entry indicating the target slot
  * @gfp: memory allocation flags
  * @orders: allocation orders, must be non zero
@@ -515,13 +513,17 @@ static struct folio *__swap_cache_alloc(
  * doing IO (e.g. swap in or zswap writeback). The swap slot indicated by
  * @targ_entry must have a non-zero swap count (swapped out).
  *
+ * The returned folio is locked and is NOT on the LRU. The caller must either
+ * add it to the LRU with folio_add_lru() so page reclaim can find it, or free
+ * it directly once done; a folio left off the LRU is unreclaimable and leaks.
+ *
  * Context: Caller must protect the swap device with reference count or locks.
  * Return: Returns the folio if allocation succeeded and folio is in the swap
  * cache. Returns error code if failed due to race, OOM or invalid arguments.
  */
-struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
-				     unsigned long orders, struct vm_fault *vmf,
-				     struct mempolicy *mpol, pgoff_t ilx)
+struct folio *__swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
+				       unsigned long orders, struct vm_fault *vmf,
+				       struct mempolicy *mpol, pgoff_t ilx)
 {
 	int order, err;
 	struct folio *ret;
@@ -657,12 +659,13 @@ static struct folio *swap_cache_read_fol
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
-		folio = swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx);
+		folio = __swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR_OR_NULL(folio))
 		return NULL;
 
+	folio_add_lru(folio);
 	swap_read_folio(ctx, folio);
 	if (readahead) {
 		folio_set_readahead(folio);
@@ -698,12 +701,13 @@ struct folio *swapin_sync(swp_entry_t en
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
-		folio = swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx);
+		folio = __swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR(folio))
 		return folio;
 
+	folio_add_lru(folio);
 	swap_read_folio(&ctx, folio);
 	swap_read_submit(&ctx);
 	return folio;
--- a/mm/zswap.c~mm-swap-move-lru-insertion-out-of-the-swap-cache-allocator
+++ a/mm/zswap.c
@@ -1019,8 +1019,8 @@ static int zswap_writeback_entry(struct
 		return -ENOENT;
 
 	mpol = get_task_policy(current);
-	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
-				       NO_INTERLEAVE_INDEX);
+	folio = __swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
+					 NO_INTERLEAVE_INDEX);
 	put_swap_device(si);
 
 	/*
@@ -1032,6 +1032,7 @@ static int zswap_writeback_entry(struct
 	 */
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
+	folio_add_lru(folio);
 
 	/*
 	 * folio is locked, and the swapcache is now secured against
_

Patches currently in -mm which might be from alex@ghiti.fr are

mm-swap-move-lru-insertion-out-of-the-swap-cache-allocator.patch
mm-swap-drop-dropbehind-swap-cache-folios-on-writeback-completion.patch
mm-zswap-drop-cold-writeback-folios-via-swap-dropbehind.patch

