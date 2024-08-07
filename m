Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33E85D8F0
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 20:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723063567; cv=none; b=OIjO5MXqhSQkYgn2qnA6xQ9PyFcyFQkYilgvZP0sN7UrVfptAln08Mf/TWbiIBQPX5eVszSBDjqsEyhmJ30MOHKdYVKCQxsCB/JDxgbDwArwgt+FiLDSd6+sUnv3WGwhG3IZ3spLvan0nLgfIYek6qe+TriAhKyjTk/jf2cNmwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723063567; c=relaxed/simple;
	bh=j5cpsUSjjqO7k92WKJzxMKG/A6ot9mK1YfjPpXjQVBw=;
	h=Date:To:From:Subject:Message-Id; b=dSU8q0lDdKzTIrwjwxPdKsoj/YCJUuniPaN+NEt587O5UqMYLLvNPlOZBU9siSccfM68XssSzvtPW2Dv9KynAWjf5KFgdIpDVsSMCUEunWPHnxlY0qy0ZEaO0JNADERbqgw5BBzqfDR2fYAOIP/nQhlWESILfVYVWHvczCcIW1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dCnyOowL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dCnyOowL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5536EC32781;
	Wed,  7 Aug 2024 20:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723063567;
	bh=j5cpsUSjjqO7k92WKJzxMKG/A6ot9mK1YfjPpXjQVBw=;
	h=Date:To:From:Subject:From;
	b=dCnyOowLhLkAG3Zt8PTXaCFbjT7DRTRXKcTSr9rI64hjzIsCWQ45lvnCrUcoDSIe0
	 0rdb8LkZrc34QwrO7J8e1y6a00XS7ICALqNEL0p40HL2SEhHNHKH/6bbiM0JBHwKHG
	 /pu0JLHRhfi1QIFlqSk2Q7ZK3PMvRSmrr3dERgCo=
Date: Wed, 07 Aug 2024 13:46:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,chrisl@kernel.org,baohua@kernel.org,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-use-swap_free_nr-to-free-shmem-swap-entries.patch added to mm-unstable branch
Message-Id: <20240807204607.5536EC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: use swap_free_nr() to free shmem swap entries
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-use-swap_free_nr-to-free-shmem-swap-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-use-swap_free_nr-to-free-shmem-swap-entries.patch

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
Subject: mm: shmem: use swap_free_nr() to free shmem swap entries
Date: Wed, 7 Aug 2024 15:31:11 +0800

As a preparation for supporting shmem large folio swapout, use
swap_free_nr() to free some continuous swap entries of the shmem large
folio when the large folio was swapped in from the swap cache.  In
addition, the index should also be round down to the number of pages when
adding the swapin folio into the pagecache.

Link: https://lkml.kernel.org/r/15eea8558d8980e6cf64ce8cd826cd0267742eed.1723012159.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Barry Song <baohua@kernel.org>
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

 mm/shmem.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/mm/shmem.c~mm-shmem-use-swap_free_nr-to-free-shmem-swap-entries
+++ a/mm/shmem.c
@@ -1961,6 +1961,7 @@ static void shmem_set_folio_swapin_error
 	struct address_space *mapping = inode->i_mapping;
 	swp_entry_t swapin_error;
 	void *old;
+	int nr_pages;
 
 	swapin_error = make_poisoned_swp_entry();
 	old = xa_cmpxchg_irq(&mapping->i_pages, index,
@@ -1969,6 +1970,7 @@ static void shmem_set_folio_swapin_error
 	if (old != swp_to_radix_entry(swap))
 		return;
 
+	nr_pages = folio_nr_pages(folio);
 	folio_wait_writeback(folio);
 	delete_from_swap_cache(folio);
 	/*
@@ -1976,8 +1978,8 @@ static void shmem_set_folio_swapin_error
 	 * won't be 0 when inode is released and thus trigger WARN_ON(i_blocks)
 	 * in shmem_evict_inode().
 	 */
-	shmem_recalc_inode(inode, -1, -1);
-	swap_free(swap);
+	shmem_recalc_inode(inode, -nr_pages, -nr_pages);
+	swap_free_nr(swap, nr_pages);
 }
 
 /*
@@ -1996,7 +1998,7 @@ static int shmem_swapin_folio(struct ino
 	struct swap_info_struct *si;
 	struct folio *folio = NULL;
 	swp_entry_t swap;
-	int error;
+	int error, nr_pages;
 
 	VM_BUG_ON(!*foliop || !xa_is_value(*foliop));
 	swap = radix_to_swp_entry(*foliop);
@@ -2043,6 +2045,7 @@ static int shmem_swapin_folio(struct ino
 		goto failed;
 	}
 	folio_wait_writeback(folio);
+	nr_pages = folio_nr_pages(folio);
 
 	/*
 	 * Some architectures may have to restore extra metadata to the
@@ -2056,19 +2059,20 @@ static int shmem_swapin_folio(struct ino
 			goto failed;
 	}
 
-	error = shmem_add_to_page_cache(folio, mapping, index,
+	error = shmem_add_to_page_cache(folio, mapping,
+					round_down(index, nr_pages),
 					swp_to_radix_entry(swap), gfp);
 	if (error)
 		goto failed;
 
-	shmem_recalc_inode(inode, 0, -1);
+	shmem_recalc_inode(inode, 0, -nr_pages);
 
 	if (sgp == SGP_WRITE)
 		folio_mark_accessed(folio);
 
 	delete_from_swap_cache(folio);
 	folio_mark_dirty(folio);
-	swap_free(swap);
+	swap_free_nr(swap, nr_pages);
 	put_swap_device(si);
 
 	*foliop = folio;
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

