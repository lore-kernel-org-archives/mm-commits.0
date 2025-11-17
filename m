Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3280C21D3CC
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343237; cv=none; b=Pq6IxKUCrTgT4PXS9RErg7I1qoTtq2YHv9rwBovqopsXTtYWshgO3gZ7BhvVxviYQqlQt2EiUWC+zTEqTiBfQAsCgDoQihV0WiKsgBkwootVMEEdODFufHxr2IeNwqGHwMlMbdFQqAJ285VUWqEU3hql2R8Cpb0MbaoR+OCwmrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343237; c=relaxed/simple;
	bh=8WUmhuiFgSJclESY5PYnj19S4VDeaSSIjMwHzrQQb24=;
	h=Date:To:From:Subject:Message-Id; b=KVCGOkWxCo0iXN9wLgdWWZrnfKt4HmsywQpNgmjnVCvzKc+lXlR2qQ8dk2TowHzZTh81eShiFjNvxUczzBPC+K0j3gG1kzCtfjzIsHfXWxH2Rjj0LdtuXxk0IJuA+XuvwN2v5rvEsSIDHgRZseQ0/SWosYwpJIW/ccu0pOitK4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hlIye24o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hlIye24o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD08C4CEF5;
	Mon, 17 Nov 2025 01:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343237;
	bh=8WUmhuiFgSJclESY5PYnj19S4VDeaSSIjMwHzrQQb24=;
	h=Date:To:From:Subject:From;
	b=hlIye24o/Vi5Nn3F4h4/1I6gf6iMFbdOJ4Krv54pNLQF46IKqvyyoRmOJSAQSxsOg
	 SlyHpQ/6AAxYJ5S5JvI0BemDHYClj0O1ZgFgE0MN2evVknVHznDtQlWMyf//QVR2Qv
	 TKSG5b1yKw8Ei3KoktdR3i2QflLgavgdymwWB0A0=
Date: Sun, 16 Nov 2025 17:33:56 -0800
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-cleanup-swap-entry-allocation-parameter.patch removed from -mm tree
Message-Id: <20251117013357.0AD08C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: cleanup swap entry allocation parameter
has been removed from the -mm tree.  Its filename was
     mm-swap-cleanup-swap-entry-allocation-parameter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: cleanup swap entry allocation parameter
Date: Fri, 24 Oct 2025 02:00:41 +0800

We no longer need this GFP parameter after commit 8578e0c00dcf ("mm, swap:
use the swap table for the swap cache and switch API").  Before that
commit the GFP parameter is already almost identical for all callers, so
nothing changed by that commit.  Swap table just moved the GFP to lower
layer and make it more defined and changes depend on atomic or sleep
allocation.

Now this parameter is no longer used, just remove it.  No behavior change.

Link: https://lkml.kernel.org/r/20251024-swap-clean-after-swap-table-p1-v2-3-a709469052e7@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    4 ++--
 mm/shmem.c           |    2 +-
 mm/swapfile.c        |    3 +--
 mm/vmscan.c          |    4 ++--
 4 files changed, 6 insertions(+), 7 deletions(-)

--- a/include/linux/swap.h~mm-swap-cleanup-swap-entry-allocation-parameter
+++ a/include/linux/swap.h
@@ -462,7 +462,7 @@ static inline long get_nr_swap_pages(voi
 }
 
 extern void si_swapinfo(struct sysinfo *);
-int folio_alloc_swap(struct folio *folio, gfp_t gfp_mask);
+int folio_alloc_swap(struct folio *folio);
 bool folio_free_swap(struct folio *folio);
 void put_swap_folio(struct folio *folio, swp_entry_t entry);
 extern swp_entry_t get_swap_page_of_type(int);
@@ -560,7 +560,7 @@ static inline int swp_swapcount(swp_entr
 	return 0;
 }
 
-static inline int folio_alloc_swap(struct folio *folio, gfp_t gfp_mask)
+static inline int folio_alloc_swap(struct folio *folio)
 {
 	return -EINVAL;
 }
--- a/mm/shmem.c~mm-swap-cleanup-swap-entry-allocation-parameter
+++ a/mm/shmem.c
@@ -1617,7 +1617,7 @@ try_split:
 		folio_mark_uptodate(folio);
 	}
 
-	if (!folio_alloc_swap(folio, __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
+	if (!folio_alloc_swap(folio)) {
 		bool first_swapped = shmem_recalc_inode(inode, 0, nr_pages);
 		int error;
 
--- a/mm/swapfile.c~mm-swap-cleanup-swap-entry-allocation-parameter
+++ a/mm/swapfile.c
@@ -1417,7 +1417,6 @@ static bool swap_sync_discard(void)
 /**
  * folio_alloc_swap - allocate swap space for a folio
  * @folio: folio we want to move to swap
- * @gfp: gfp mask for shadow nodes
  *
  * Allocate swap space for the folio and add the folio to the
  * swap cache.
@@ -1425,7 +1424,7 @@ static bool swap_sync_discard(void)
  * Context: Caller needs to hold the folio lock.
  * Return: Whether the folio was added to the swap cache.
  */
-int folio_alloc_swap(struct folio *folio, gfp_t gfp)
+int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
 	unsigned int size = 1 << order;
--- a/mm/vmscan.c~mm-swap-cleanup-swap-entry-allocation-parameter
+++ a/mm/vmscan.c
@@ -1318,7 +1318,7 @@ retry:
 					    split_folio_to_list(folio, folio_list))
 						goto activate_locked;
 				}
-				if (folio_alloc_swap(folio, __GFP_HIGH | __GFP_NOWARN)) {
+				if (folio_alloc_swap(folio)) {
 					int __maybe_unused order = folio_order(folio);
 
 					if (!folio_test_large(folio))
@@ -1334,7 +1334,7 @@ retry:
 					}
 #endif
 					count_mthp_stat(order, MTHP_STAT_SWPOUT_FALLBACK);
-					if (folio_alloc_swap(folio, __GFP_HIGH | __GFP_NOWARN))
+					if (folio_alloc_swap(folio))
 						goto activate_locked_split;
 				}
 				/*
_

Patches currently in -mm which might be from kasong@tencent.com are


