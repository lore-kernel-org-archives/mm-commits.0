Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D0EBE4D
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 20:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712175409; cv=none; b=q/6TyxvYF1vFt/imEL9pPYjTltz3bn3hSj5qQe6W3HTmhGy2pziSnMqWVOGCy1x3szKUkqIDy1T80s5HadHClm90gmyTYIsBOlTF235ViGHVy0spfQVfigKKz0YFAqYL6k97RaDMw5+LuE8K2AAgluPGHxY9W3NrU7+5vqDu0qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712175409; c=relaxed/simple;
	bh=wKncAqNBVVjs0PdXPN4SxiiuYJt82AaDGernKkghHdM=;
	h=Date:To:From:Subject:Message-Id; b=KkyJerFpRCJCE7FoQk8vSR9agBBmtE9zv36bguj4xxWw4jqabet0tgTL658beg16eXbYVm7meji7LBkQJjoetMzDXZxDH/6b0yuWxE8xE1Dcy09KQaMbNYu+PAEtnRBgDmxldZguomaXn1/aPxdaFjGRNOfnOfgLuaL6wpGTRCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ab5ADcIq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ab5ADcIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBA5C433F1;
	Wed,  3 Apr 2024 20:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712175408;
	bh=wKncAqNBVVjs0PdXPN4SxiiuYJt82AaDGernKkghHdM=;
	h=Date:To:From:Subject:From;
	b=Ab5ADcIqu5Aue8e62lnW6o2KNcn8JmXmYdkdBi1ICEXcXRrzy2BjMux1o+5McppCT
	 VDsrLGfQR7U5jOsKbPrKuWRKqeXnUzipdSxnoKVBtfL6dw7Xz+TItCBvIo8lc1HsuB
	 fkdpKKKiQZtV7Oy5Ys4EK/4j5BbPs56jmR5hlbVo=
Date: Wed, 03 Apr 2024 13:16:47 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,shy828301@gmail.com,mhocko@suse.com,ioworker0@gmail.com,david@redhat.com,chrisl@kernel.org,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remove-cluster_flag_huge-from-swap_cluster_info-flags.patch added to mm-unstable branch
Message-Id: <20240403201648.6BBA5C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: remove CLUSTER_FLAG_HUGE from swap_cluster_info:flags
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-remove-cluster_flag_huge-from-swap_cluster_info-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-remove-cluster_flag_huge-from-swap_cluster_info-flags.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: swap: remove CLUSTER_FLAG_HUGE from swap_cluster_info:flags
Date: Wed, 3 Apr 2024 12:40:27 +0100

This series adds support for swapping out multi-size THP (mTHP) without
needing to first split the large folio via
split_huge_page_to_list_to_order().  It closely follows the approach
already used to swap-out PMD-sized THP.

There are a couple of reasons for swapping out mTHP without splitting:

  - Performance: It is expensive to split a large folio and under extreme memory
    pressure some workloads regressed performance when using 64K mTHP vs 4K
    small folios because of this extra cost in the swap-out path. This series
    not only eliminates the regression but makes it faster to swap out 64K mTHP
    vs 4K small folios.

  - Memory fragmentation avoidance: If we can avoid splitting a large folio
    memory is less likely to become fragmented, making it easier to re-allocate
    a large folio in future.

  - Performance: Enables a separate series [6] to swap-in whole mTHPs, which
    means we won't lose the TLB-efficiency benefits of mTHP once the memory has
    been through a swap cycle.

I've done what I thought was the smallest change possible, and as a
result, this approach is only employed when the swap is backed by a
non-rotating block device (just as PMD-sized THP is supported today). 
Discussion against the RFC concluded that this is sufficient.


Performance Testing
===================

I've run some swap performance tests on Ampere Altra VM (arm64) with 8
CPUs.  The VM is set up with a 35G block ram device as the swap device and
the test is run from inside a memcg limited to 40G memory.  I've then run
`usemem` from vm-scalability with 70 processes, each allocating and
writing 1G of memory.  I've repeated everything 6 times and taken the mean
performance improvement relative to 4K page baseline:

| alloc size |                baseline |           + this series |
|            | mm-unstable (~v6.9-rc1) |                         |
|:-----------|------------------------:|------------------------:|
| 4K Page    |                    0.0% |                    1.3% |
| 64K THP    |                  -13.6% |                   46.3% |
| 2M THP     |                   91.4% |                   89.6% |

So with this change, the 64K swap performance goes from a 14% regression
to a 46% improvement.  While 2M shows a small regression I'm confident
that this is just noise.


This patch (of 6):

As preparation for supporting small-sized THP in the swap-out path,
without first needing to split to order-0, Remove the CLUSTER_FLAG_HUGE,
which, when present, always implies PMD-sized THP, which is the same as
the cluster size.

The only use of the flag was to determine whether a swap entry refers to a
single page or a PMD-sized THP in swap_page_trans_huge_swapped().  Instead
of relying on the flag, we now pass in nr_pages, which originates from the
folio's number of pages.  This allows the logic to work for folios of any
order.

The one snag is that one of the swap_page_trans_huge_swapped() call sites
does not have the folio.  But it was only being called there to shortcut a
call __try_to_reclaim_swap() in some cases.  __try_to_reclaim_swap() gets
the folio and (via some other functions) calls
swap_page_trans_huge_swapped().  So I've removed the problematic call site
and believe the new logic should be functionally equivalent.

That said, removing the fast path means that we will take a reference and
trylock a large folio much more often, which we would like to avoid.  The
next patch will solve this.

Removing CLUSTER_FLAG_HUGE also means we can remove split_swap_cluster()
which used to be called during folio splitting, since
split_swap_cluster()'s only job was to remove the flag.

Link: https://lkml.kernel.org/r/20240403114032.1162100-1-ryan.roberts@arm.com
Link: https://lkml.kernel.org/r/20240403114032.1162100-2-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   10 --------
 mm/huge_memory.c     |    3 --
 mm/swapfile.c        |   47 ++++++-----------------------------------
 3 files changed, 8 insertions(+), 52 deletions(-)

--- a/include/linux/swap.h~mm-swap-remove-cluster_flag_huge-from-swap_cluster_info-flags
+++ a/include/linux/swap.h
@@ -259,7 +259,6 @@ struct swap_cluster_info {
 };
 #define CLUSTER_FLAG_FREE 1 /* This cluster is free */
 #define CLUSTER_FLAG_NEXT_NULL 2 /* This cluster has no next cluster */
-#define CLUSTER_FLAG_HUGE 4 /* This cluster is backing a transparent huge page */
 
 /*
  * We assign a cluster to each CPU, so each CPU can allocate swap entry from
@@ -587,15 +586,6 @@ static inline int add_swap_extent(struct
 }
 #endif /* CONFIG_SWAP */
 
-#ifdef CONFIG_THP_SWAP
-extern int split_swap_cluster(swp_entry_t entry);
-#else
-static inline int split_swap_cluster(swp_entry_t entry)
-{
-	return 0;
-}
-#endif
-
 #ifdef CONFIG_MEMCG
 static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 {
--- a/mm/huge_memory.c~mm-swap-remove-cluster_flag_huge-from-swap_cluster_info-flags
+++ a/mm/huge_memory.c
@@ -2844,9 +2844,6 @@ static void __split_huge_page(struct pag
 		shmem_uncharge(folio->mapping->host, nr_dropped);
 	remap_page(folio, nr);
 
-	if (folio_test_swapcache(folio))
-		split_swap_cluster(folio->swap);
-
 	/*
 	 * set page to its compound_head when split to non order-0 pages, so
 	 * we can skip unlocking it below, since PG_locked is transferred to
--- a/mm/swapfile.c~mm-swap-remove-cluster_flag_huge-from-swap_cluster_info-flags
+++ a/mm/swapfile.c
@@ -343,18 +343,6 @@ static inline void cluster_set_null(stru
 	info->data = 0;
 }
 
-static inline bool cluster_is_huge(struct swap_cluster_info *info)
-{
-	if (IS_ENABLED(CONFIG_THP_SWAP))
-		return info->flags & CLUSTER_FLAG_HUGE;
-	return false;
-}
-
-static inline void cluster_clear_huge(struct swap_cluster_info *info)
-{
-	info->flags &= ~CLUSTER_FLAG_HUGE;
-}
-
 static inline struct swap_cluster_info *lock_cluster(struct swap_info_struct *si,
 						     unsigned long offset)
 {
@@ -1027,7 +1015,7 @@ static int swap_alloc_cluster(struct swa
 	offset = idx * SWAPFILE_CLUSTER;
 	ci = lock_cluster(si, offset);
 	alloc_cluster(si, idx);
-	cluster_set_count_flag(ci, SWAPFILE_CLUSTER, CLUSTER_FLAG_HUGE);
+	cluster_set_count(ci, SWAPFILE_CLUSTER);
 
 	memset(si->swap_map + offset, SWAP_HAS_CACHE, SWAPFILE_CLUSTER);
 	unlock_cluster(ci);
@@ -1365,7 +1353,6 @@ void put_swap_folio(struct folio *folio,
 
 	ci = lock_cluster_or_swap_info(si, offset);
 	if (size == SWAPFILE_CLUSTER) {
-		VM_BUG_ON(!cluster_is_huge(ci));
 		map = si->swap_map + offset;
 		for (i = 0; i < SWAPFILE_CLUSTER; i++) {
 			val = map[i];
@@ -1373,7 +1360,6 @@ void put_swap_folio(struct folio *folio,
 			if (val == SWAP_HAS_CACHE)
 				free_entries++;
 		}
-		cluster_clear_huge(ci);
 		if (free_entries == SWAPFILE_CLUSTER) {
 			unlock_cluster_or_swap_info(si, ci);
 			spin_lock(&si->lock);
@@ -1395,23 +1381,6 @@ void put_swap_folio(struct folio *folio,
 	unlock_cluster_or_swap_info(si, ci);
 }
 
-#ifdef CONFIG_THP_SWAP
-int split_swap_cluster(swp_entry_t entry)
-{
-	struct swap_info_struct *si;
-	struct swap_cluster_info *ci;
-	unsigned long offset = swp_offset(entry);
-
-	si = _swap_info_get(entry);
-	if (!si)
-		return -EBUSY;
-	ci = lock_cluster(si, offset);
-	cluster_clear_huge(ci);
-	unlock_cluster(ci);
-	return 0;
-}
-#endif
-
 static int swp_entry_cmp(const void *ent1, const void *ent2)
 {
 	const swp_entry_t *e1 = ent1, *e2 = ent2;
@@ -1519,22 +1488,23 @@ out:
 }
 
 static bool swap_page_trans_huge_swapped(struct swap_info_struct *si,
-					 swp_entry_t entry)
+					 swp_entry_t entry,
+					 unsigned int nr_pages)
 {
 	struct swap_cluster_info *ci;
 	unsigned char *map = si->swap_map;
 	unsigned long roffset = swp_offset(entry);
-	unsigned long offset = round_down(roffset, SWAPFILE_CLUSTER);
+	unsigned long offset = round_down(roffset, nr_pages);
 	int i;
 	bool ret = false;
 
 	ci = lock_cluster_or_swap_info(si, offset);
-	if (!ci || !cluster_is_huge(ci)) {
+	if (!ci || nr_pages == 1) {
 		if (swap_count(map[roffset]))
 			ret = true;
 		goto unlock_out;
 	}
-	for (i = 0; i < SWAPFILE_CLUSTER; i++) {
+	for (i = 0; i < nr_pages; i++) {
 		if (swap_count(map[offset + i])) {
 			ret = true;
 			break;
@@ -1556,7 +1526,7 @@ static bool folio_swapped(struct folio *
 	if (!IS_ENABLED(CONFIG_THP_SWAP) || likely(!folio_test_large(folio)))
 		return swap_swapcount(si, entry) != 0;
 
-	return swap_page_trans_huge_swapped(si, entry);
+	return swap_page_trans_huge_swapped(si, entry, folio_nr_pages(folio));
 }
 
 /**
@@ -1622,8 +1592,7 @@ int free_swap_and_cache(swp_entry_t entr
 		}
 
 		count = __swap_entry_free(p, entry);
-		if (count == SWAP_HAS_CACHE &&
-		    !swap_page_trans_huge_swapped(p, entry))
+		if (count == SWAP_HAS_CACHE)
 			__try_to_reclaim_swap(p, swp_offset(entry),
 					      TTRS_UNMAPPED | TTRS_FULL);
 		put_swap_device(p);
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-swap-remove-cluster_flag_huge-from-swap_cluster_info-flags.patch
mm-swap-free_swap_and_cache_nr-as-batched-free_swap_and_cache.patch
mm-swap-simplify-struct-percpu_cluster.patch
mm-swap-allow-storage-of-all-mthp-orders.patch
mm-vmscan-avoid-split-during-shrink_folio_list.patch
mm-madvise-avoid-split-during-madv_pageout-and-madv_cold.patch
mm-madvise-avoid-split-during-madv_pageout-and-madv_cold-fix.patch

