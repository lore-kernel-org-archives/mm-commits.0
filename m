Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA6430E834
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 00:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750380043; cv=none; b=Dy0tST2Yob7JAbmdQaXTv0h/EfXH2NgBV+RewnXTQ/HTdQVDwiuOxq84PVduKa1bHiB6lt1FmdarhO2+NPH3weI5Skb4JudNRIWURtSnq1zezMkz6dcnHMDG0HGA5S2OqDcr5MJNbbFLa1OEBq7o21iD+cuJO4HFdN6LzxnI7YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750380043; c=relaxed/simple;
	bh=wEIUERreK5D4zjKDNRiKGeC28FmZJ5QrYstUyUe4Ye8=;
	h=Date:To:From:Subject:Message-Id; b=t6+C/P/lHKZT5Q5K+SKH08LTW88fGok7nOjznZil/ucvuY8xJZHgOvIPMf8S/QhcBwnYMXs/86X/Gu2tLCCZLac1liYgdx/BYiEtS34eJG7RpoPA4FJJDODbsjcQEZ5PI1BZ/YohGrdjJ/jzDXVr4WNxwMsrVlRm0hu5bFAgxhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yWg7iHe0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yWg7iHe0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AB3C4CEEA;
	Fri, 20 Jun 2025 00:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750380042;
	bh=wEIUERreK5D4zjKDNRiKGeC28FmZJ5QrYstUyUe4Ye8=;
	h=Date:To:From:Subject:From;
	b=yWg7iHe098gIggDV3c9ZuUvMB9R45L1Wkke9OZ9U5bPf7h08VPCd+ZTtvM50USbuF
	 HE2XLfu/hnQ85WiU8vSKvvIYWoKNFbASaM3Nyhz7KJpeGWAbgO0yqV2uAT+X577TDL
	 EUsn/tBJoTr+do8cBsh5whiL3+CRuXZwxDSWOl6g=
Date: Thu, 19 Jun 2025 17:40:42 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-avoid-false-positive-swap-cache-lookup.patch added to mm-new branch
Message-Id: <20250620004042.D0AB3C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem, swap: avoid false positive swap cache lookup
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-swap-avoid-false-positive-swap-cache-lookup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-swap-avoid-false-positive-swap-cache-lookup.patch

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
Subject: mm/shmem, swap: avoid false positive swap cache lookup
Date: Fri, 20 Jun 2025 01:55:38 +0800

If the shmem read request's index points to the middle of a large swap
entry, shmem swap in does the swap cache lookup use the large swap entry's
starting value (the first sub swap entry of this large entry).  This will
lead to false positive lookup result if only the first few swap entries
are cached, but the requested swap entry pointed by index is uncached.

Currently shmem will do a large entry split then retry the swapin from
beginning, which is a waste of CPU and fragile.  Handle this correctly.

Also add some sanity checks to help understand the code and ensure things
won't go wrong.

Link: https://lkml.kernel.org/r/20250619175538.15799-5-ryncsn@gmail.com
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

 mm/shmem.c |   61 ++++++++++++++++++++++++---------------------------
 1 file changed, 29 insertions(+), 32 deletions(-)

--- a/mm/shmem.c~mm-shmem-swap-avoid-false-positive-swap-cache-lookup
+++ a/mm/shmem.c
@@ -1977,12 +1977,12 @@ unlock:
 
 static struct folio *shmem_swapin_direct(struct inode *inode,
 		struct vm_area_struct *vma, pgoff_t index,
-		swp_entry_t entry, int *order, gfp_t gfp)
+		swp_entry_t index_entry, swp_entry_t swap,
+		int *order, gfp_t gfp)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	int nr_pages = 1 << *order;
 	struct folio *new;
-	pgoff_t offset;
 	void *shadow;
 
 	/*
@@ -2003,13 +2003,11 @@ static struct folio *shmem_swapin_direct
 		 */
 		if ((vma && userfaultfd_armed(vma)) ||
 		    !zswap_never_enabled() ||
-		    non_swapcache_batch(entry, nr_pages) != nr_pages) {
-			offset = index - round_down(index, nr_pages);
-			entry = swp_entry(swp_type(entry),
-					  swp_offset(entry) + offset);
+		    non_swapcache_batch(index_entry, nr_pages) != nr_pages) {
 			*order = 0;
 			nr_pages = 1;
 		} else {
+			swap.val = index_entry.val;
 			gfp_t huge_gfp = vma_thp_gfp_mask(vma);
 
 			gfp = limit_gfp_mask(huge_gfp, gfp);
@@ -2021,7 +2019,7 @@ static struct folio *shmem_swapin_direct
 		return ERR_PTR(-ENOMEM);
 
 	if (mem_cgroup_swapin_charge_folio(new, vma ? vma->vm_mm : NULL,
-					   gfp, entry)) {
+					   gfp, swap)) {
 		folio_put(new);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -2036,17 +2034,17 @@ static struct folio *shmem_swapin_direct
 	 * In this case, shmem_add_to_page_cache() will help identify the
 	 * concurrent swapin and return -EEXIST.
 	 */
-	if (swapcache_prepare(entry, nr_pages)) {
+	if (swapcache_prepare(swap, nr_pages)) {
 		folio_put(new);
 		return ERR_PTR(-EEXIST);
 	}
 
 	__folio_set_locked(new);
 	__folio_set_swapbacked(new);
-	new->swap = entry;
+	new->swap = swap;
 
-	memcg1_swapin(entry, nr_pages);
-	shadow = get_shadow_from_swap_cache(entry);
+	memcg1_swapin(swap, nr_pages);
+	shadow = get_shadow_from_swap_cache(swap);
 	if (shadow)
 		workingset_refault(new, shadow);
 	folio_add_lru(new);
@@ -2278,20 +2276,21 @@ static int shmem_swapin_folio(struct ino
 	struct mm_struct *fault_mm = vma ? vma->vm_mm : NULL;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	int error, nr_pages, order, swap_order;
+	swp_entry_t swap, index_entry;
 	struct swap_info_struct *si;
 	struct folio *folio = NULL;
 	bool skip_swapcache = false;
-	swp_entry_t swap;
+	pgoff_t offset;
 
 	VM_BUG_ON(!*foliop || !xa_is_value(*foliop));
-	swap = radix_to_swp_entry(*foliop);
+	index_entry = radix_to_swp_entry(*foliop);
 	*foliop = NULL;
 
-	if (is_poisoned_swp_entry(swap))
+	if (is_poisoned_swp_entry(index_entry))
 		return -EIO;
 
-	si = get_swap_device(swap);
-	order = shmem_confirm_swap(mapping, index, swap);
+	si = get_swap_device(index_entry);
+	order = shmem_confirm_swap(mapping, index, index_entry);
 	if (unlikely(!si)) {
 		if (order < 0)
 			return -EEXIST;
@@ -2303,7 +2302,9 @@ static int shmem_swapin_folio(struct ino
 		return -EEXIST;
 	}
 
-	/* Look it up and read it in.. */
+	/* @index may points to the middle of a large entry, get the real swap value first */
+	offset = index - round_down(index, 1 << order);
+	swap.val = index_entry.val + offset;
 	folio = swap_cache_get_folio(swap, NULL, 0);
 	if (!folio) {
 		/* Or update major stats only when swapin succeeds?? */
@@ -2315,7 +2316,7 @@ static int shmem_swapin_folio(struct ino
 		/* Try direct mTHP swapin bypassing swap cache and readahead */
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
 			swap_order = order;
-			folio = shmem_swapin_direct(inode, vma, index,
+			folio = shmem_swapin_direct(inode, vma, index, index_entry,
 						    swap, &swap_order, gfp);
 			if (!IS_ERR(folio)) {
 				skip_swapcache = true;
@@ -2338,28 +2339,25 @@ static int shmem_swapin_folio(struct ino
 		}
 	}
 alloced:
+	swap_order = folio_order(folio);
+	nr_pages = folio_nr_pages(folio);
+
+	/* The swap-in should cover both @swap and @index */
+	swap.val = round_down(swap.val, nr_pages);
+	VM_WARN_ON_ONCE(swap.val > index_entry.val + offset);
+	VM_WARN_ON_ONCE(swap.val + nr_pages <= index_entry.val + offset);
+
 	/*
 	 * We need to split an existing large entry if swapin brought in a
 	 * smaller folio due to various of reasons.
-	 *
-	 * And worth noting there is a special case: if there is a smaller
-	 * cached folio that covers @swap, but not @index (it only covers
-	 * first few sub entries of the large entry, but @index points to
-	 * later parts), the swap cache lookup will still see this folio,
-	 * And we need to split the large entry here. Later checks will fail,
-	 * as it can't satisfy the swap requirement, and we will retry
-	 * the swapin from beginning.
 	 */
-	swap_order = folio_order(folio);
+	index = round_down(index, nr_pages);
 	if (order > swap_order) {
-		error = shmem_split_swap_entry(inode, index, swap, gfp);
+		error = shmem_split_swap_entry(inode, index, index_entry, gfp);
 		if (error)
 			goto failed_nolock;
 	}
 
-	index = round_down(index, 1 << swap_order);
-	swap.val = round_down(swap.val, 1 << swap_order);
-
 	/* We have to do this with folio locked to prevent races */
 	folio_lock(folio);
 	if ((!skip_swapcache && !folio_test_swapcache(folio)) ||
@@ -2372,7 +2370,6 @@ alloced:
 		goto failed;
 	}
 	folio_wait_writeback(folio);
-	nr_pages = folio_nr_pages(folio);
 
 	/*
 	 * Some architectures may have to restore extra metadata to the
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

