Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D516E16BE34
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 22:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723588888; cv=none; b=MNfrEajwepCuuS/xB5uKt8A4nr9pwk7qkHZdVDU65zEpBB6ZM5mU7MhOR2f8ojZoHuzuWR6xm/LAIGFqfQz247IVFZC8fxRKUn96MPQUH6lfOjpqr3TmO4fkO8bdEd9MX6x+SBycAx7lR1R2/+H3O8vt5vvjvENy5/vXa6e3o/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723588888; c=relaxed/simple;
	bh=qyGVvU3kMtxLa+L8qyBIE23XeWRppQBpQxv6bc5FjFI=;
	h=Date:To:From:Subject:Message-Id; b=lOZo4p4p/33q2E/XqZALFG93AQ30Ky3EuBfFeayS8bkKJ/cU9T3BXkiKxhxK3+QBx7kTom8cVZne506wXK+RFMQ5Ya7kQjbjIULgMREClQqGyO3ebVViA176T0PI8N5zyo+wVfkgmiWXRapkLRkFOfEg/NhYlDOh231kavTuWHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MJW03JIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MJW03JIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786B8C32782;
	Tue, 13 Aug 2024 22:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723588887;
	bh=qyGVvU3kMtxLa+L8qyBIE23XeWRppQBpQxv6bc5FjFI=;
	h=Date:To:From:Subject:From;
	b=MJW03JIRhVhCSxbQYI0fQNn6sGcz+gno5hyE12AAKSBZaFOZ0018vwi+sunpRn6bp
	 dluf5FLA1GLOvZfViSHzvlTuu3Aw5AISTGSBds3g3R2RXbl399Tf33j6az39mxJAnK
	 4xDxxtAdkzvLBFpU2C+aJ6ychgqVtmpwUNr5WlDY=
Date: Tue, 13 Aug 2024 15:41:26 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,chrisl@kernel.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting.patch added to mm-unstable branch
Message-Id: <20240813224127.786B8C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: extend swap_shmem_alloc() to support batch SWAP_MAP_SHMEM flag setting
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting.patch

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
Subject: mm: swap: extend swap_shmem_alloc() to support batch SWAP_MAP_SHMEM flag setting
Date: Mon, 12 Aug 2024 15:42:02 +0800

Patch series "support large folio swap-out and swap-in for shmem", v5.

Shmem will support large folio allocation [1] [2] to get a better
performance, however, the memory reclaim still splits the precious large
folios when trying to swap-out shmem, which may lead to the memory
fragmentation issue and can not take advantage of the large folio for
shmeme.

Moreover, the swap code already supports for swapping out large folio
without split, and large folio swap-in[3] series is queued into
mm-unstable branch.  Hence this patch set also supports the large folio
swap-out and swap-in for shmem.


This patch (of 9):

To support shmem large folio swap operations, add a new parameter to
swap_shmem_alloc() that allows batch SWAP_MAP_SHMEM flag setting for shmem
swap entries.

While we are at it, using folio_nr_pages() to get the number of pages of
the folio as a preparation.

Link: https://lkml.kernel.org/r/cover.1723434324.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/99f64115d04b285e009580eb177352c57119ffd0.1723434324.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
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

 include/linux/swap.h |    4 ++--
 mm/shmem.c           |    6 ++++--
 mm/swapfile.c        |    4 ++--
 3 files changed, 8 insertions(+), 6 deletions(-)

--- a/include/linux/swap.h~mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting
+++ a/include/linux/swap.h
@@ -481,7 +481,7 @@ void put_swap_folio(struct folio *folio,
 extern swp_entry_t get_swap_page_of_type(int);
 extern int get_swap_pages(int n, swp_entry_t swp_entries[], int order);
 extern int add_swap_count_continuation(swp_entry_t, gfp_t);
-extern void swap_shmem_alloc(swp_entry_t);
+extern void swap_shmem_alloc(swp_entry_t, int);
 extern int swap_duplicate(swp_entry_t);
 extern int swapcache_prepare(swp_entry_t entry, int nr);
 extern void swap_free_nr(swp_entry_t entry, int nr_pages);
@@ -548,7 +548,7 @@ static inline int add_swap_count_continu
 	return 0;
 }
 
-static inline void swap_shmem_alloc(swp_entry_t swp)
+static inline void swap_shmem_alloc(swp_entry_t swp, int nr)
 {
 }
 
--- a/mm/shmem.c~mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting
+++ a/mm/shmem.c
@@ -1452,6 +1452,7 @@ static int shmem_writepage(struct page *
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	swp_entry_t swap;
 	pgoff_t index;
+	int nr_pages;
 
 	/*
 	 * Our capabilities prevent regular writeback or sync from ever calling
@@ -1484,6 +1485,7 @@ static int shmem_writepage(struct page *
 	}
 
 	index = folio->index;
+	nr_pages = folio_nr_pages(folio);
 
 	/*
 	 * This is somewhat ridiculous, but without plumbing a SWAP_MAP_FALLOC
@@ -1536,8 +1538,8 @@ static int shmem_writepage(struct page *
 	if (add_to_swap_cache(folio, swap,
 			__GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN,
 			NULL) == 0) {
-		shmem_recalc_inode(inode, 0, 1);
-		swap_shmem_alloc(swap);
+		shmem_recalc_inode(inode, 0, nr_pages);
+		swap_shmem_alloc(swap, nr_pages);
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(swap));
 
 		mutex_unlock(&shmem_swaplist_mutex);
--- a/mm/swapfile.c~mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting
+++ a/mm/swapfile.c
@@ -3655,9 +3655,9 @@ unlock_out:
  * Help swapoff by noting that swap entry belongs to shmem/tmpfs
  * (in which case its reference count is never incremented).
  */
-void swap_shmem_alloc(swp_entry_t entry)
+void swap_shmem_alloc(swp_entry_t entry, int nr)
 {
-	__swap_duplicate(entry, SWAP_MAP_SHMEM, 1);
+	__swap_duplicate(entry, SWAP_MAP_SHMEM, nr);
 }
 
 /*
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

