Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752E9145A1D
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 20:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723063574; cv=none; b=BsucNNC+SsLWyeVfeQ+ZhvMCT2BOkYXIGbPLp8LDiIJH2pCmhz4rNdMP/P+0rci6ZIWoYRQ+vFxsAWlxy6Mni8QFrS4z6Hh+0p59q0+AG0kw106Rt8yD1hQyLrEocYEG1fJtIwiKX8fn7y1umkT8grpjIY5Gh+7dowvVZyPvd/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723063574; c=relaxed/simple;
	bh=mIRx2vgVKQA+V2f0JYFLAQJpEADR4WEkpossRV2NXRw=;
	h=Date:To:From:Subject:Message-Id; b=hV5ClVnAGRnVjkIKxbMLlXWaERIGlTwOVCgZ/icA+Nj/Ybnr8pmL1BMSFrkIK4qeZLKA1/EtbZK6ItN2hzWTgJ5wvJTxAjNoLHhRbP3JZQyq/h0Om1Btx2xraeMwWEEmzoxcLWcY5n/vwdn7pgd2YBteUYEKsOj5KxjSLKNkDT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YY5qS+bS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YY5qS+bS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44048C32781;
	Wed,  7 Aug 2024 20:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723063574;
	bh=mIRx2vgVKQA+V2f0JYFLAQJpEADR4WEkpossRV2NXRw=;
	h=Date:To:From:Subject:From;
	b=YY5qS+bSDhhQ5i7ueeIaPzDrnL9sz6yZ1GONh2tTdwt1r7LjFcrM+QjrSKZRt3Ap8
	 STJVYRLnMg9kcXhF7YYfCraDlJZgQ827Trd9T6L7R1Qk+wHiUhEFpxyveiu1PDJQkt
	 a7Q4sn7wWTac9pBtg08B+E7MouW3vZaN3M1FCF7I=
Date: Wed, 07 Aug 2024 13:46:13 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,chrisl@kernel.org,baohua@kernel.org,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-support-large-folio-swap-out.patch added to mm-unstable branch
Message-Id: <20240807204614.44048C32781@smtp.kernel.org>
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
Date: Wed, 7 Aug 2024 15:31:15 +0800

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
Link: https://lkml.kernel.org/r/a7f632e1d8976e6de37e3e60358e1406048b4e7e.1723012159.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
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

 drivers/gpu/drm/i915/gem/i915_gem_shmem.c |    1 +
 include/linux/writeback.h                 |    1 +
 mm/shmem.c                                |    3 +--
 mm/vmscan.c                               |   14 ++++++++++++--
 4 files changed, 15 insertions(+), 4 deletions(-)

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
--- a/mm/shmem.c~mm-shmem-support-large-folio-swap-out
+++ a/mm/shmem.c
@@ -795,7 +795,6 @@ static int shmem_add_to_page_cache(struc
 	VM_BUG_ON_FOLIO(index != round_down(index, nr), folio);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_swapbacked(folio), folio);
-	VM_BUG_ON(expected && folio_test_large(folio));
 
 	folio_ref_add(folio, nr);
 	folio->mapping = mapping;
@@ -1482,7 +1481,7 @@ static int shmem_writepage(struct page *
 	 * "force", drivers/gpu/drm/i915/gem/i915_gem_shmem.c gets huge pages,
 	 * and its shmem_writeback() needs them to be split when swapping.
 	 */
-	if (folio_test_large(folio)) {
+	if (wbc->split_large_folio && folio_test_large(folio)) {
 		/* Ensure the subpages are still dirty */
 		folio_test_set_dirty(folio);
 		if (split_huge_page(page) < 0)
--- a/mm/vmscan.c~mm-shmem-support-large-folio-swap-out
+++ a/mm/vmscan.c
@@ -1268,8 +1268,12 @@ retry:
 			if (!total_swap_pages)
 				goto activate_locked;
 
-			/* Split shmem folio */
-			if (split_folio_to_list(folio, folio_list))
+			/*
+			 * Only split shmem folio when CONFIG_THP_SWAP
+			 * is not enabled.
+			 */
+			if (!IS_ENABLED(CONFIG_THP_SWAP) &&
+			    split_folio_to_list(folio, folio_list))
 				goto keep_locked;
 		}
 
@@ -1371,10 +1375,16 @@ retry:
 			 * starts and then write it out here.
 			 */
 			try_to_unmap_flush_dirty();
+try_pageout:
 			switch (pageout(folio, mapping, &plug)) {
 			case PAGE_KEEP:
 				goto keep_locked;
 			case PAGE_ACTIVATE:
+				if (shmem_mapping(mapping) && folio_test_large(folio) &&
+				    !split_folio_to_list(folio, folio_list)) {
+					nr_pages = 1;
+					goto try_pageout;
+				}
 				goto activate_locked;
 			case PAGE_SUCCESS:
 				stat->nr_pageout += nr_pages;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem.patch
mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix.patch
mm-shmem-fix-incorrect-aligned-index-when-checking-conflicts.patch
mm-shmem-simplify-the-suitable-huge-orders-validation-for-tmpfs.patch
mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled.patch
mm-shmem-move-shmem_huge_global_enabled-into-shmem_allowable_huge_orders.patch
mm-vmscan-add-validation-before-spliting-shmem-large-folio.patch
mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting.patch
mm-shmem-extend-shmem_partial_swap_usage-to-support-large-folio-swap.patch
mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch
mm-shmem-use-swap_free_nr-to-free-shmem-swap-entries.patch
mm-shmem-support-large-folio-allocation-for-shmem_replace_folio.patch
mm-shmem-drop-folio-reference-count-using-nr_pages-in-shmem_delete_from_page_cache.patch
mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large.patch
mm-shmem-support-large-folio-swap-out.patch

