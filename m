Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEF216BE34
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 22:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723588904; cv=none; b=bYTonI/NRWKEWWI0fEKsMp5aa/h1l8fo9Csxe5oMTLmOtWgYzG/0AorUV5zbfJi3Cm4TFCibtfdh/UcseR05mE+rslkE4tWIplpXQzqWULfn2Wtphg37siyJQU/38arDyrMQ0DNRB8otboDUFYRD1yYvmrDrZrfkdMulPrSPeDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723588904; c=relaxed/simple;
	bh=aSmMs2xP2tGosWKhI1gueBBia3zbAz8adnrA79YGhz8=;
	h=Date:To:From:Subject:Message-Id; b=sqmVBGBCf/V/m5LR7xqMGm1V5Plkrjk7pl+qvLi2ezkmsKwqgkBeiV0DC4Ipz7w3Ih6+yKXi+Cp9nXI12VQZNBtenc/q0tBxocvC/xgQOz4TO1FqlHd5nLTa8hyrCa+/qWtAYsmPB1T4CygLdC2mx97TMsgmV2ZM0izdhhymt1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l/tzHr4Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l/tzHr4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DFAC32782;
	Tue, 13 Aug 2024 22:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723588904;
	bh=aSmMs2xP2tGosWKhI1gueBBia3zbAz8adnrA79YGhz8=;
	h=Date:To:From:Subject:From;
	b=l/tzHr4ZWxbQE0GihG0S1stjZwm2/K9BJtFo1qY1Q7SCe+DDvvm134XFh8zHD0J/K
	 PKPjn/C2Vl/cWCZRVTkx4LFw+FnBZ+SLP0ca8EPYWysPI6XPew4RaG+/r8mHwZDZtu
	 cSS3BfzHeDau4hr2ad35XDwa0LDmjOaHZ1zWMhh8=
Date: Tue, 13 Aug 2024 15:41:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,chrisl@kernel.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-support-large-folio-swap-out.patch added to mm-unstable branch
Message-Id: <20240813224144.81DFAC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: support large folio swap out
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-support-large-folio-swap-out.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-support-large-folio-swap-out.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: support large folio swap out
Date: Mon, 12 Aug 2024 15:42:10 +0800

Shmem will support large folio allocation [1] [2] to get a better
performance, however, the memory reclaim still splits the precious large
folios when trying to swap out shmem, which may lead to the memory
fragmentation issue and can not take advantage of the large folio for
shmeme.

Moreover, the swap code already supports for swapping out large folio
without split, hence this patch set supports the large folio swap out for
shmem.

Note the i915_gem_shmem driver still need to be split when swapping, thus
add a new flag 'split_large_folio' for writeback_control to indicate
spliting the large folio.

[1] https://lore.kernel.org/all/cover.1717495894.git.baolin.wang@linux.alibaba.com/
[2] https://lore.kernel.org/all/20240515055719.32577-1-da.gomez@samsung.com/
Link: https://lkml.kernel.org/r/d80c21abd20e1b0f5ca66b330f074060fb2f082d.1723434324.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gem/i915_gem_shmem.c |    1 
 include/linux/writeback.h                 |    4 ++
 mm/shmem.c                                |   12 +++++--
 mm/vmscan.c                               |   32 +++++++++++++++-----
 4 files changed, 38 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c~mm-shmem-support-large-folio-swap-out
+++ a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -308,6 +308,7 @@ void __shmem_writeback(size_t size, stru
 		.range_start = 0,
 		.range_end = LLONG_MAX,
 		.for_reclaim = 1,
+		.split_large_folio = 1,
 	};
 	unsigned long i;
 
--- a/include/linux/writeback.h~mm-shmem-support-large-folio-swap-out
+++ a/include/linux/writeback.h
@@ -63,6 +63,7 @@ struct writeback_control {
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned for_sync:1;		/* sync(2) WB_SYNC_ALL writeback */
 	unsigned unpinned_netfs_wb:1;	/* Cleared I_PINNING_NETFS_WB */
+	unsigned split_large_folio:1;	/* Split large folio for shmem writeback */
 
 	/*
 	 * When writeback IOs are bounced through async layers, only the
@@ -79,6 +80,9 @@ struct writeback_control {
 	 */
 	struct swap_iocb **swap_plug;
 
+	/* Target list for splitting a large folio */
+	struct list_head *list;
+
 	/* internal fields used by the ->writepages implementation: */
 	struct folio_batch fbatch;
 	pgoff_t index;
--- a/mm/shmem.c~mm-shmem-support-large-folio-swap-out
+++ a/mm/shmem.c
@@ -795,7 +795,6 @@ static int shmem_add_to_page_cache(struc
 	VM_BUG_ON_FOLIO(index != round_down(index, nr), folio);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_swapbacked(folio), folio);
-	VM_BUG_ON(expected && folio_test_large(folio));
 
 	folio_ref_add(folio, nr);
 	folio->mapping = mapping;
@@ -1482,10 +1481,11 @@ static int shmem_writepage(struct page *
 	 * "force", drivers/gpu/drm/i915/gem/i915_gem_shmem.c gets huge pages,
 	 * and its shmem_writeback() needs them to be split when swapping.
 	 */
-	if (folio_test_large(folio)) {
+	if (wbc->split_large_folio && folio_test_large(folio)) {
+try_split:
 		/* Ensure the subpages are still dirty */
 		folio_test_set_dirty(folio);
-		if (split_huge_page(page) < 0)
+		if (split_huge_page_to_list_to_order(page, wbc->list, 0))
 			goto redirty;
 		folio = page_folio(page);
 		folio_clear_dirty(folio);
@@ -1527,8 +1527,12 @@ static int shmem_writepage(struct page *
 	}
 
 	swap = folio_alloc_swap(folio);
-	if (!swap.val)
+	if (!swap.val) {
+		if (nr_pages > 1)
+			goto try_split;
+
 		goto redirty;
+	}
 
 	/*
 	 * Add inode to shmem_unuse()'s list of swapped-out inodes,
--- a/mm/vmscan.c~mm-shmem-support-large-folio-swap-out
+++ a/mm/vmscan.c
@@ -628,7 +628,7 @@ typedef enum {
  * Calls ->writepage().
  */
 static pageout_t pageout(struct folio *folio, struct address_space *mapping,
-			 struct swap_iocb **plug)
+			 struct swap_iocb **plug, struct list_head *folio_list)
 {
 	/*
 	 * If the folio is dirty, only perform writeback if that write
@@ -676,6 +676,16 @@ static pageout_t pageout(struct folio *f
 			.swap_plug = plug,
 		};
 
+		/*
+		 * The large shmem folio can be split if CONFIG_THP_SWAP is
+		 * not enabled or contiguous swap entries are failed to
+		 * allocate.
+		 */
+		if (shmem_mapping(mapping) && folio_test_large(folio)) {
+			wbc.list = folio_list;
+			wbc.split_large_folio = !IS_ENABLED(CONFIG_THP_SWAP);
+		}
+
 		folio_set_reclaim(folio);
 		res = mapping->a_ops->writepage(&folio->page, &wbc);
 		if (res < 0)
@@ -1258,11 +1268,6 @@ retry:
 						goto activate_locked_split;
 				}
 			}
-		} else if (folio_test_swapbacked(folio) &&
-			   folio_test_large(folio)) {
-			/* Split shmem folio */
-			if (split_folio_to_list(folio, folio_list))
-				goto keep_locked;
 		}
 
 		/*
@@ -1363,12 +1368,25 @@ retry:
 			 * starts and then write it out here.
 			 */
 			try_to_unmap_flush_dirty();
-			switch (pageout(folio, mapping, &plug)) {
+			switch (pageout(folio, mapping, &plug, folio_list)) {
 			case PAGE_KEEP:
 				goto keep_locked;
 			case PAGE_ACTIVATE:
+				/*
+				 * If shmem folio is split when writeback to swap,
+				 * the tail pages will make their own pass through
+				 * this function and be accounted then.
+				 */
+				if (nr_pages > 1 && !folio_test_large(folio)) {
+					sc->nr_scanned -= (nr_pages - 1);
+					nr_pages = 1;
+				}
 				goto activate_locked;
 			case PAGE_SUCCESS:
+				if (nr_pages > 1 && !folio_test_large(folio)) {
+					sc->nr_scanned -= (nr_pages - 1);
+					nr_pages = 1;
+				}
 				stat->nr_pageout += nr_pages;
 
 				if (folio_test_writeback(folio))
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-simplify-the-suitable-huge-orders-validation-for-tmpfs.patch
mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled.patch
mm-shmem-move-shmem_huge_global_enabled-into-shmem_allowable_huge_orders.patch
mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting.patch
mm-shmem-extend-shmem_partial_swap_usage-to-support-large-folio-swap.patch
mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch
mm-shmem-use-swap_free_nr-to-free-shmem-swap-entries.patch
mm-shmem-support-large-folio-allocation-for-shmem_replace_folio.patch
mm-shmem-drop-folio-reference-count-using-nr_pages-in-shmem_delete_from_page_cache.patch
mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large.patch
mm-shmem-support-large-folio-swap-out.patch

