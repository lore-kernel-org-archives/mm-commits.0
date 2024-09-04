Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F3773478
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423477; cv=none; b=G25CKKAaBiaYdGvL7GN5dWdFGJSvt0SXyzUPUrJTkGkZ+nbUnsIzlgV8E0Elm/GImRYOZEMLdokvLWWPNQQUeUole2TLwcQKW/AuF3869/rA8AKyZB/3m6f5IapRB2fjC2zq7LWpa3UhQ0qakgaZUPFwmuXgYKfvH2RcZMKQR7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423477; c=relaxed/simple;
	bh=B0OlRi07IMnfATNvJKtv89TqHixghH7NN3zBEU+fsYs=;
	h=Date:To:From:Subject:Message-Id; b=f1VC/3PPPrBsXcmGC60WZMurhSZVzlj4ri/48oADxc8QVEKr1nKeIWnMUjvoat2KPdwzTfhtmCxL06a/7GgU2V2Om7ebmlDu98j+Isvuxalf/QuIds61XvaFymhuXp6TVv2qEbXH9NPQk9UE2tidgPtinwyeSl/fWV4dxuaT9mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SI5eaeIY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SI5eaeIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56662C4CEC2;
	Wed,  4 Sep 2024 04:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423477;
	bh=B0OlRi07IMnfATNvJKtv89TqHixghH7NN3zBEU+fsYs=;
	h=Date:To:From:Subject:From;
	b=SI5eaeIYbFu3vlp/d6KuJEDvDWNPiNiFGRjTCc6U/pc/mpSZstDx5nEiYDpeIHgts
	 L3dzXsJTSvrxAaiBy8wVNBeqEZTol/OQ+oLecJr7zxJ1iM8cwLS/fTZgN6TwKoW20m
	 ehyB+az+s9aQlU7D46IYc89uaCCLcmXJIeR9m+oE=
Date: Tue, 03 Sep 2024 21:17:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,chrisl@kernel.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-support-large-folio-swap-out.patch removed from -mm tree
Message-Id: <20240904041757.56662C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: support large folio swap out
has been removed from the -mm tree.  Its filename was
     mm-shmem-support-large-folio-swap-out.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[hughd@google.com: shmem_writepage() split folio at EOF before swapout]
  Link: https://lkml.kernel.org/r/aef55f8d-6040-692d-65e3-16150cce4440@google.com
[baolin.wang@linux.alibaba.com: remove the wbc->split_large_folio per Hugh]
  Link: https://lkml.kernel.org/r/1236a002daa301b3b9ba73d6c0fab348427cf295.1724833399.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/d80c21abd20e1b0f5ca66b330f074060fb2f082d.1723434324.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    3 +++
 mm/shmem.c                |   28 ++++++++++++++++++++++------
 mm/vmscan.c               |   30 +++++++++++++++++++++++-------
 3 files changed, 48 insertions(+), 13 deletions(-)

--- a/include/linux/writeback.h~mm-shmem-support-large-folio-swap-out
+++ a/include/linux/writeback.h
@@ -79,6 +79,9 @@ struct writeback_control {
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
@@ -1460,6 +1459,7 @@ static int shmem_writepage(struct page *
 	swp_entry_t swap;
 	pgoff_t index;
 	int nr_pages;
+	bool split = false;
 
 	/*
 	 * Our capabilities prevent regular writeback or sync from ever calling
@@ -1478,14 +1478,26 @@ static int shmem_writepage(struct page *
 		goto redirty;
 
 	/*
-	 * If /sys/kernel/mm/transparent_hugepage/shmem_enabled is "always" or
-	 * "force", drivers/gpu/drm/i915/gem/i915_gem_shmem.c gets huge pages,
-	 * and its shmem_writeback() needs them to be split when swapping.
+	 * If CONFIG_THP_SWAP is not enabled, the large folio should be
+	 * split when swapping.
+	 *
+	 * And shrinkage of pages beyond i_size does not split swap, so
+	 * swapout of a large folio crossing i_size needs to split too
+	 * (unless fallocate has been used to preallocate beyond EOF).
 	 */
 	if (folio_test_large(folio)) {
+		index = shmem_fallocend(inode,
+			DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE));
+		if ((index > folio->index && index < folio_next_index(folio)) ||
+		    !IS_ENABLED(CONFIG_THP_SWAP))
+			split = true;
+	}
+
+	if (split) {
+try_split:
 		/* Ensure the subpages are still dirty */
 		folio_test_set_dirty(folio);
-		if (split_huge_page(page) < 0)
+		if (split_huge_page_to_list_to_order(page, wbc->list, 0))
 			goto redirty;
 		folio = page_folio(page);
 		folio_clear_dirty(folio);
@@ -1527,8 +1539,12 @@ static int shmem_writepage(struct page *
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
@@ -676,6 +676,14 @@ static pageout_t pageout(struct folio *f
 			.swap_plug = plug,
 		};
 
+		/*
+		 * The large shmem folio can be split if CONFIG_THP_SWAP is
+		 * not enabled or contiguous swap entries are failed to
+		 * allocate.
+		 */
+		if (shmem_mapping(mapping) && folio_test_large(folio))
+			wbc.list = folio_list;
+
 		folio_set_reclaim(folio);
 		res = mapping->a_ops->writepage(&folio->page, &wbc);
 		if (res < 0)
@@ -1257,11 +1265,6 @@ retry:
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
@@ -1362,12 +1365,25 @@ retry:
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


