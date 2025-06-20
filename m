Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBD130E834
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 00:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750380040; cv=none; b=doocGN89L09I7X7ZDGynR6f4be5jbmPbyMu678H762KZyyRI7rdJwbs40Jb30IZ+LGZpJzSv2sFzRz9l1dj04cCVWFwFlh+pmWuJZdJ1N7HZcymDmmTGH+cQ/4wWckwtnFjTJeQAueNHM5Bw8TsAu0QNH/9+GgziSqlDQViYqKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750380040; c=relaxed/simple;
	bh=hdyHeSkyOp+FryV165wTDgDNOxbb72uFDJuUIh6AB24=;
	h=Date:To:From:Subject:Message-Id; b=cFx0Er1OIoGzVslO4hh4jCkfWJ0W2frJyJa+ZIGkgjW9T4dIpfU2nRoI03TgHLPwTxrHNsuMzrgXZY17/T/O5b+xHHH8gbe7gwAGW6oBxT8z3alJ5ZswdsGdbUDUTkC+X/c57PKqF8/JVYEH5571FWg2ps0OenjJ8fvZ83T1bV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hydKw9u4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hydKw9u4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C293C4CEEA;
	Fri, 20 Jun 2025 00:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750380040;
	bh=hdyHeSkyOp+FryV165wTDgDNOxbb72uFDJuUIh6AB24=;
	h=Date:To:From:Subject:From;
	b=hydKw9u4GD1C0ojbpjXJyiyMQXOK4/UzDYMgWT+8jdfIXVUL6CGGTJMArOHzHy7cK
	 1rT0XIey5AjYhrSZwagxmkwzMWucCNKpCAe8zJ7oaRn9mdUv5k39xYBaLWLnt3diQx
	 HwiDFvnJOZxEP8IExhOo8/r9wZuYL2HHqdD3SbWw=
Date: Thu, 19 Jun 2025 17:40:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-improve-mthp-swapin-process.patch added to mm-new branch
Message-Id: <20250620004040.9C293C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem, swap: improve mthp swapin process
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-swap-improve-mthp-swapin-process.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-swap-improve-mthp-swapin-process.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/shmem, swap: improve mthp swapin process
Date: Fri, 20 Jun 2025 01:55:37 +0800

Tidy up the mTHP swapin code, reduce duplicated codes and slightly tweak
the workflow.

For SWP_SYNCHRONOUS_IO devices, we should skip the readahead and swap
cache even if the swapin falls back to order 0.  Readahead is not helpful
for such devices.

Also consolidates the mTHP related check to one place so they are now all
wrapped by CONFIG_TRANSPARENT_HUGEPAGE, and will be trimmed off by
compiler if not needed.

Link: https://lkml.kernel.org/r/20250619175538.15799-4-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |  175 ++++++++++++++++++++++-----------------------------
 1 file changed, 78 insertions(+), 97 deletions(-)

--- a/mm/shmem.c~mm-shmem-swap-improve-mthp-swapin-process
+++ a/mm/shmem.c
@@ -1975,31 +1975,51 @@ unlock:
 	return ERR_PTR(error);
 }
 
-static struct folio *shmem_swap_alloc_folio(struct inode *inode,
+static struct folio *shmem_swapin_direct(struct inode *inode,
 		struct vm_area_struct *vma, pgoff_t index,
-		swp_entry_t entry, int order, gfp_t gfp)
+		swp_entry_t entry, int *order, gfp_t gfp)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	int nr_pages = 1 << *order;
 	struct folio *new;
+	pgoff_t offset;
 	void *shadow;
-	int nr_pages;
 
 	/*
 	 * We have arrived here because our zones are constrained, so don't
 	 * limit chance of success with further cpuset and node constraints.
 	 */
 	gfp &= ~GFP_CONSTRAINT_MASK;
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && order > 0) {
-		gfp_t huge_gfp = vma_thp_gfp_mask(vma);
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+		if (WARN_ON_ONCE(*order))
+			return ERR_PTR(-EINVAL);
+	} else if (*order) {
+		/*
+		 * If uffd is active for the vma, we need per-page fault
+		 * fidelity to maintain the uffd semantics, then fallback
+		 * to swapin order-0 folio, as well as for zswap case.
+		 * Any existing sub folio in the swap cache also blocks
+		 * mTHP swapin.
+		 */
+		if ((vma && userfaultfd_armed(vma)) ||
+		    !zswap_never_enabled() ||
+		    non_swapcache_batch(entry, nr_pages) != nr_pages) {
+			offset = index - round_down(index, nr_pages);
+			entry = swp_entry(swp_type(entry),
+					  swp_offset(entry) + offset);
+			*order = 0;
+			nr_pages = 1;
+		} else {
+			gfp_t huge_gfp = vma_thp_gfp_mask(vma);
 
-		gfp = limit_gfp_mask(huge_gfp, gfp);
+			gfp = limit_gfp_mask(huge_gfp, gfp);
+		}
 	}
 
-	new = shmem_alloc_folio(gfp, order, info, index);
+	new = shmem_alloc_folio(gfp, *order, info, index);
 	if (!new)
 		return ERR_PTR(-ENOMEM);
 
-	nr_pages = folio_nr_pages(new);
 	if (mem_cgroup_swapin_charge_folio(new, vma ? vma->vm_mm : NULL,
 					   gfp, entry)) {
 		folio_put(new);
@@ -2165,8 +2185,12 @@ static void shmem_set_folio_swapin_error
 	swap_free_nr(swap, nr_pages);
 }
 
-static int shmem_split_large_entry(struct inode *inode, pgoff_t index,
-				   swp_entry_t swap, gfp_t gfp)
+/*
+ * Split an existing large swap entry. @index should point to one sub mapping
+ * slot within the entry @swap, this sub slot will be split into order 0.
+ */
+static int shmem_split_swap_entry(struct inode *inode, pgoff_t index,
+				  swp_entry_t swap, gfp_t gfp)
 {
 	struct address_space *mapping = inode->i_mapping;
 	XA_STATE_ORDER(xas, &mapping->i_pages, index, 0);
@@ -2226,7 +2250,6 @@ static int shmem_split_large_entry(struc
 			cur_order = split_order;
 			split_order = xas_try_split_min_order(split_order);
 		}
-
 unlock:
 		xas_unlock_irq(&xas);
 
@@ -2237,7 +2260,7 @@ unlock:
 	if (xas_error(&xas))
 		return xas_error(&xas);
 
-	return entry_order;
+	return 0;
 }
 
 /*
@@ -2254,11 +2277,11 @@ static int shmem_swapin_folio(struct ino
 	struct address_space *mapping = inode->i_mapping;
 	struct mm_struct *fault_mm = vma ? vma->vm_mm : NULL;
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	int error, nr_pages, order, swap_order;
 	struct swap_info_struct *si;
 	struct folio *folio = NULL;
 	bool skip_swapcache = false;
 	swp_entry_t swap;
-	int error, nr_pages, order, split_order;
 
 	VM_BUG_ON(!*foliop || !xa_is_value(*foliop));
 	swap = radix_to_swp_entry(*foliop);
@@ -2283,110 +2306,66 @@ static int shmem_swapin_folio(struct ino
 	/* Look it up and read it in.. */
 	folio = swap_cache_get_folio(swap, NULL, 0);
 	if (!folio) {
-		int nr_pages = 1 << order;
-		bool fallback_order0 = false;
-
 		/* Or update major stats only when swapin succeeds?? */
 		if (fault_type) {
 			*fault_type |= VM_FAULT_MAJOR;
 			count_vm_event(PGMAJFAULT);
 			count_memcg_event_mm(fault_mm, PGMAJFAULT);
 		}
-
-		/*
-		 * If uffd is active for the vma, we need per-page fault
-		 * fidelity to maintain the uffd semantics, then fallback
-		 * to swapin order-0 folio, as well as for zswap case.
-		 * Any existing sub folio in the swap cache also blocks
-		 * mTHP swapin.
-		 */
-		if (order > 0 && ((vma && unlikely(userfaultfd_armed(vma))) ||
-				  !zswap_never_enabled() ||
-				  non_swapcache_batch(swap, nr_pages) != nr_pages))
-			fallback_order0 = true;
-
-		/* Skip swapcache for synchronous device. */
-		if (!fallback_order0 && data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
-			folio = shmem_swap_alloc_folio(inode, vma, index, swap, order, gfp);
+		/* Try direct mTHP swapin bypassing swap cache and readahead */
+		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
+			swap_order = order;
+			folio = shmem_swapin_direct(inode, vma, index,
+						    swap, &swap_order, gfp);
 			if (!IS_ERR(folio)) {
 				skip_swapcache = true;
 				goto alloced;
 			}
-
-			/*
-			 * Fallback to swapin order-0 folio unless the swap entry
-			 * already exists.
-			 */
+			/* Fallback if order > 0 swapin failed with -ENOMEM */
 			error = PTR_ERR(folio);
 			folio = NULL;
-			if (error == -EEXIST)
+			if (error != -ENOMEM || !swap_order)
 				goto failed;
 		}
-
 		/*
-		 * Now swap device can only swap in order 0 folio, then we
-		 * should split the large swap entry stored in the pagecache
-		 * if necessary.
+		 * Try order 0 swapin using swap cache and readahead, it still
+		 * may return order > 0 folio due to raced swap cache.
 		 */
-		split_order = shmem_split_large_entry(inode, index, swap, gfp);
-		if (split_order < 0) {
-			error = split_order;
-			goto failed;
-		}
-
-		/*
-		 * If the large swap entry has already been split, it is
-		 * necessary to recalculate the new swap entry based on
-		 * the old order alignment.
-		 */
-		if (split_order > 0) {
-			pgoff_t offset = index - round_down(index, 1 << split_order);
-
-			swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
-		}
-
-		/* Here we actually start the io */
 		folio = shmem_swapin_cluster(swap, gfp, info, index);
 		if (!folio) {
 			error = -ENOMEM;
 			goto failed;
 		}
-	} else if (order > folio_order(folio)) {
-		/*
-		 * Swap readahead may swap in order 0 folios into swapcache
-		 * asynchronously, while the shmem mapping can still stores
-		 * large swap entries. In such cases, we should split the
-		 * large swap entry to prevent possible data corruption.
-		 */
-		split_order = shmem_split_large_entry(inode, index, swap, gfp);
-		if (split_order < 0) {
-			folio_put(folio);
-			folio = NULL;
-			error = split_order;
-			goto failed;
-		}
-
-		/*
-		 * If the large swap entry has already been split, it is
-		 * necessary to recalculate the new swap entry based on
-		 * the old order alignment.
-		 */
-		if (split_order > 0) {
-			pgoff_t offset = index - round_down(index, 1 << split_order);
-
-			swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
-		}
-	} else if (order < folio_order(folio)) {
-		swap.val = round_down(swp_type(swap), folio_order(folio));
 	}
-
 alloced:
+	/*
+	 * We need to split an existing large entry if swapin brought in a
+	 * smaller folio due to various of reasons.
+	 *
+	 * And worth noting there is a special case: if there is a smaller
+	 * cached folio that covers @swap, but not @index (it only covers
+	 * first few sub entries of the large entry, but @index points to
+	 * later parts), the swap cache lookup will still see this folio,
+	 * And we need to split the large entry here. Later checks will fail,
+	 * as it can't satisfy the swap requirement, and we will retry
+	 * the swapin from beginning.
+	 */
+	swap_order = folio_order(folio);
+	if (order > swap_order) {
+		error = shmem_split_swap_entry(inode, index, swap, gfp);
+		if (error)
+			goto failed_nolock;
+	}
+
+	index = round_down(index, 1 << swap_order);
+	swap.val = round_down(swap.val, 1 << swap_order);
+
 	/* We have to do this with folio locked to prevent races */
 	folio_lock(folio);
 	if ((!skip_swapcache && !folio_test_swapcache(folio)) ||
 	    folio->swap.val != swap.val) {
 		error = -EEXIST;
-		goto unlock;
+		goto failed_unlock;
 	}
 	if (!folio_test_uptodate(folio)) {
 		error = -EIO;
@@ -2407,8 +2386,7 @@ alloced:
 			goto failed;
 	}
 
-	error = shmem_add_to_page_cache(folio, mapping,
-					round_down(index, nr_pages),
+	error = shmem_add_to_page_cache(folio, mapping, index,
 					swp_to_radix_entry(swap), gfp);
 	if (error)
 		goto failed;
@@ -2419,8 +2397,8 @@ alloced:
 		folio_mark_accessed(folio);
 
 	if (skip_swapcache) {
+		swapcache_clear(si, folio->swap, folio_nr_pages(folio));
 		folio->swap.val = 0;
-		swapcache_clear(si, swap, nr_pages);
 	} else {
 		delete_from_swap_cache(folio);
 	}
@@ -2436,13 +2414,16 @@ failed:
 	if (error == -EIO)
 		shmem_set_folio_swapin_error(inode, index, folio, swap,
 					     skip_swapcache);
-unlock:
-	if (skip_swapcache)
-		swapcache_clear(si, swap, folio_nr_pages(folio));
-	if (folio) {
+failed_unlock:
+	if (folio)
 		folio_unlock(folio);
-		folio_put(folio);
+failed_nolock:
+	if (skip_swapcache) {
+		swapcache_clear(si, folio->swap, folio_nr_pages(folio));
+		folio->swap.val = 0;
 	}
+	if (folio)
+		folio_put(folio);
 	put_swap_device(si);
 	return error;
 }
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-shmem-swap-fix-softlockup-with-mthp-swapin.patch
mm-shmem-swap-fix-softlockup-with-mthp-swapin-v3.patch
mm-userfaultfd-fix-race-of-userfaultfd_move-and-swap-cache.patch
mm-list_lru-refactor-the-locking-code.patch
mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hung.patch
mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch
mm-shmem-swap-improve-mthp-swapin-process.patch
mm-shmem-swap-avoid-false-positive-swap-cache-lookup.patch

