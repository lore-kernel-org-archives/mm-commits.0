Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA001FE455
	for <mm-commits@vger.kernel.org>; Fri, 27 Jun 2025 20:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751055413; cv=none; b=YFu12ZHaR9YeHRFXhjo3dYx7RDWMnyC5215EuLe47Y69ZNqos3+/LWveMp8ImmBpsFh+W5Xb+o9WUSTlhiS4pzSWXx+hiw4mn6G4+bSOFcqKgCHBRwg8MKtP1Mj6/Nuok1oPf3ZGF/rnEIjjJzuHWzX0tIF12dl3Veqajy7MEAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751055413; c=relaxed/simple;
	bh=x+i6iCpz4m25QWtLUTObl59hedkjCTMahs5vESFofRE=;
	h=Date:To:From:Subject:Message-Id; b=UIDweEmAVmC6CK1LukFfQx4NBB3ptME99SFLEzOPJzThqTGIG5KvRbesSVIkAcEMxE95rs7vkR08cNzendzbyzNe80FL1K2k0mh4W7K/bH4Y4plAVqWkjLeW8rYNGknFIxeGKavyFJ3vYzQE3M2aBUiBYPLqGnqD70YFPm+Hn8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WBVYCWGB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WBVYCWGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A034AC4CEE3;
	Fri, 27 Jun 2025 20:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751055413;
	bh=x+i6iCpz4m25QWtLUTObl59hedkjCTMahs5vESFofRE=;
	h=Date:To:From:Subject:From;
	b=WBVYCWGBIXZ2FBCV8GFrv8Dd3c/ayamCnH2qAm9pANUa+l6luLkHVUzj/ELTcfxQh
	 AbvZ+KKq+PSBP3d0iupnx4trBptlj/GdBavGfSEI7TBsleI1bAxLSsyLFPCfoHlL2B
	 MORGB8n7MXIJ5MDha20eI+5OK7K2E4qVoqXySt5s=
Date: Fri, 27 Jun 2025 13:16:53 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,dev.jain@arm.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-avoid-false-positive-swap-cache-lookup.patch added to mm-new branch
Message-Id: <20250627201653.A034AC4CEE3@smtp.kernel.org>
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
Date: Fri, 27 Jun 2025 14:20:20 +0800

If the shmem read request's index points to the middle of a large swap
entry, shmem swap in does the swap cache lookup use the large swap entry's
starting value (the first sub swap entry of this large entry).  This will
lead to false positive lookup result if only the first few swap entries
are cached, but the requested swap entry pointed by index is uncached.

Currently shmem will do a large entry split then retry the swapin from
beginning, which is a waste of CPU and fragile.  Handle this correctly.

Also add some sanity checks to help understand the code and ensure things
won't go wrong.

Link: https://lkml.kernel.org/r/20250627062020.534-8-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   60 +++++++++++++++++++++++++++------------------------
 1 file changed, 32 insertions(+), 28 deletions(-)

--- a/mm/shmem.c~mm-shmem-swap-avoid-false-positive-swap-cache-lookup
+++ a/mm/shmem.c
@@ -1977,14 +1977,19 @@ unlock:
 
 static struct folio *shmem_swapin_direct(struct inode *inode,
 		struct vm_area_struct *vma, pgoff_t index,
-		swp_entry_t entry, int order, gfp_t gfp)
+		swp_entry_t index_entry, swp_entry_t swap,
+		int order, gfp_t gfp)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
-	int nr_pages = 1 << order;
 	struct folio *new;
-	pgoff_t offset;
+	swp_entry_t entry;
 	gfp_t swap_gfp;
 	void *shadow;
+	int nr_pages;
+
+	/* Prefer aligned THP swapin */
+	entry.val = index_entry.val;
+	nr_pages = 1 << order;
 
 	/*
 	 * We have arrived here because our zones are constrained, so don't
@@ -2011,6 +2016,7 @@ static struct folio *shmem_swapin_direct
 			swap_gfp = limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
 		}
 	}
+
 retry:
 	new = shmem_alloc_folio(swap_gfp, order, info, index);
 	if (!new) {
@@ -2056,11 +2062,10 @@ fallback:
 	if (!order)
 		return new;
 	/* High order swapin failed, fallback to order 0 and retry */
-	order = 0;
-	nr_pages = 1;
+	entry.val = swap.val;
 	swap_gfp = gfp;
-	offset = index - round_down(index, nr_pages);
-	entry = swp_entry(swp_type(entry), swp_offset(entry) + offset);
+	nr_pages = 1;
+	order = 0;
 	goto retry;
 }
 
@@ -2288,20 +2293,21 @@ static int shmem_swapin_folio(struct ino
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
@@ -2313,13 +2319,15 @@ static int shmem_swapin_folio(struct ino
 		return -EEXIST;
 	}
 
-	/* Look it up and read it in.. */
+	/* @index may points to the middle of a large entry, get the real swap value first */
+	offset = index - round_down(index, 1 << order);
+	swap.val = index_entry.val + offset;
 	folio = swap_cache_get_folio(swap, NULL, 0);
 	if (!folio) {
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
 			/* Direct mTHP swapin without swap cache or readahead */
 			folio = shmem_swapin_direct(inode, vma, index,
-						    swap, order, gfp);
+						    index_entry, swap, order, gfp);
 			if (IS_ERR(folio)) {
 				error = PTR_ERR(folio);
 				folio = NULL;
@@ -2341,28 +2349,25 @@ static int shmem_swapin_folio(struct ino
 			count_memcg_event_mm(fault_mm, PGMAJFAULT);
 		}
 	}
+
+	swap_order = folio_order(folio);
+	nr_pages = folio_nr_pages(folio);
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
@@ -2375,7 +2380,6 @@ static int shmem_swapin_folio(struct ino
 		goto failed;
 	}
 	folio_wait_writeback(folio);
-	nr_pages = folio_nr_pages(folio);
 
 	/*
 	 * Some architectures may have to restore extra metadata to the
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-list_lru-refactor-the-locking-code.patch
mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hung.patch
mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch
mm-shmem-swap-tidy-up-thp-swapin-checks.patch
mm-shmem-swap-clean-up-swap-entry-splitting.patch
mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch
mm-shmem-swap-fix-major-fault-counting.patch
mm-shmem-swap-avoid-false-positive-swap-cache-lookup.patch

