Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B880D33D5
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 03:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725422035; cv=none; b=qvdE7UoG5IVtacoQ0wZTIlUEn0FAPwQI6U3ImECDfQUO8kTPGdXolvncIvDgkZP1BfOXYg3jAZRko1Z4/PLFiUwob+3YPflqRkYlHuHuSyI6n+WXtK53faAN5/a1JaV94qwR3OJvN30sE+D7EjZ6GLGo6bmZDjyjn8zWjOVOuk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725422035; c=relaxed/simple;
	bh=Qn1sUKvaoE65RdSmIURJddfejUeoG6DiLnc2g0sKVY4=;
	h=Date:To:From:Subject:Message-Id; b=nC8y2keWa2o3OVCngqpOpNE77wI4ENstZhipQckaD0kXeoVux87QTiyZDZ+Q0CPpc9gX1By6GejQP/SypcOpBjT35iwP10wr2lQcP2Q34x0HF1lvHBpg9QbyzKz54iJ1NaAMtbbrLzWQsaIjX6BbO5aSHexRpk5wPwrBTeNLBmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nkCE3CGD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nkCE3CGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C41AC4CEC2;
	Wed,  4 Sep 2024 03:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725422035;
	bh=Qn1sUKvaoE65RdSmIURJddfejUeoG6DiLnc2g0sKVY4=;
	h=Date:To:From:Subject:From;
	b=nkCE3CGDoaIA+Vbuiwkd0fBuHilhzJT68t0cZOO0KShbuuj2AoTK+RCGt2txiF/Go
	 NzYShfr2SKrFSbKujhUKEnMOGfRZBZbVvKzL6lzoSv1Lo5UaZV4hv5Xav9lBhyq+Sm
	 gExwGJJ2qkJA4XHkEBtNi3j6lZyh9FPp0PAv2L+E=
Date: Tue, 03 Sep 2024 20:53:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,chrisl@kernel.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shmem-support-large-folio-swap-out-fix-2.patch removed from -mm tree
Message-Id: <20240904035355.8C41AC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: support large folio swap out fix 2
has been removed from the -mm tree.  Its filename was
     mm-shmem-support-large-folio-swap-out-fix-2.patch

This patch was dropped because it was folded into mm-shmem-support-large-folio-swap-out.patch

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: support large folio swap out fix 2
Date: Wed, 28 Aug 2024 16:28:38 +0800

As Hugh said:
"
The i915 THP splitting inshmem_writepage() was to avoid mm VM_BUG_ONs and
crashes when shmem.c did not support huge page swapout: but now you are
enabling that support, and such VM_BUG_ONs and crashes are gone (so far
as I can see: and this is written on a laptop using the i915 driver).

I cannot think of why i915 itself would care how mm implements swapout
(beyond enjoying faster): I think all the wbc->split_large_folio you
introduce here should be reverted.
"

So this fixup patch will remove the wbc->split_large_folio as suggested
by Hugh.

Link: https://lkml.kernel.org/r/1236a002daa301b3b9ba73d6c0fab348427cf295.1724833399.git.baolin.wang@linux.alibaba.com
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

 drivers/gpu/drm/i915/gem/i915_gem_shmem.c |    1 -
 include/linux/writeback.h                 |    1 -
 mm/shmem.c                                |    9 ++++-----
 mm/vmscan.c                               |    4 +---
 4 files changed, 5 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c~mm-shmem-support-large-folio-swap-out-fix-2
+++ a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -308,7 +308,6 @@ void __shmem_writeback(size_t size, stru
 		.range_start = 0,
 		.range_end = LLONG_MAX,
 		.for_reclaim = 1,
-		.split_large_folio = 1,
 	};
 	unsigned long i;
 
--- a/include/linux/writeback.h~mm-shmem-support-large-folio-swap-out-fix-2
+++ a/include/linux/writeback.h
@@ -63,7 +63,6 @@ struct writeback_control {
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned for_sync:1;		/* sync(2) WB_SYNC_ALL writeback */
 	unsigned unpinned_netfs_wb:1;	/* Cleared I_PINNING_NETFS_WB */
-	unsigned split_large_folio:1;	/* Split large folio for shmem writeback */
 
 	/*
 	 * When writeback IOs are bounced through async layers, only the
--- a/mm/shmem.c~mm-shmem-support-large-folio-swap-out-fix-2
+++ a/mm/shmem.c
@@ -1478,19 +1478,18 @@ static int shmem_writepage(struct page *
 		goto redirty;
 
 	/*
-	 * If /sys/kernel/mm/transparent_hugepage/shmem_enabled is "always" or
-	 * "force", drivers/gpu/drm/i915/gem/i915_gem_shmem.c gets huge pages,
-	 * and its shmem_writeback() needs them to be split when swapping.
+	 * If CONFIG_THP_SWAP is not enabled, the large folio should be
+	 * split when swapping.
 	 *
 	 * And shrinkage of pages beyond i_size does not split swap, so
 	 * swapout of a large folio crossing i_size needs to split too
 	 * (unless fallocate has been used to preallocate beyond EOF).
 	 */
 	if (folio_test_large(folio)) {
-		split = wbc->split_large_folio;
 		index = shmem_fallocend(inode,
 			DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE));
-		if (index > folio->index && index < folio_next_index(folio))
+		if ((index > folio->index && index < folio_next_index(folio)) ||
+		    !IS_ENABLED(CONFIG_THP_SWAP))
 			split = true;
 	}
 
--- a/mm/vmscan.c~mm-shmem-support-large-folio-swap-out-fix-2
+++ a/mm/vmscan.c
@@ -681,10 +681,8 @@ static pageout_t pageout(struct folio *f
 		 * not enabled or contiguous swap entries are failed to
 		 * allocate.
 		 */
-		if (shmem_mapping(mapping) && folio_test_large(folio)) {
+		if (shmem_mapping(mapping) && folio_test_large(folio))
 			wbc.list = folio_list;
-			wbc.split_large_folio = !IS_ENABLED(CONFIG_THP_SWAP);
-		}
 
 		folio_set_reclaim(folio);
 		res = mapping->a_ops->writepage(&folio->page, &wbc);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting.patch
mm-shmem-extend-shmem_partial_swap_usage-to-support-large-folio-swap.patch
mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch
mm-shmem-use-swap_free_nr-to-free-shmem-swap-entries.patch
mm-shmem-support-large-folio-allocation-for-shmem_replace_folio.patch
mm-shmem-drop-folio-reference-count-using-nr_pages-in-shmem_delete_from_page_cache.patch
mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large.patch
mm-shmem-support-large-folio-swap-out.patch
mm-khugepaged-expand-the-is_refcount_suitable-to-support-file-folios.patch
mm-khugepaged-use-the-number-of-pages-in-the-folio-to-check-the-reference-count.patch
mm-khugepaged-support-shmem-mthp-copy.patch
mm-khugepaged-support-shmem-mthp-collapse.patch
selftests-mm-support-shmem-mthp-collapse-testing.patch

