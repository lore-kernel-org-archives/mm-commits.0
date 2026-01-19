Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1025129BDB4;
	Mon, 19 Jan 2026 17:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768845354; cv=none; b=FC7dhZo0WzOrdkU78aTB/r8Xj3dE12Hrc2T/YSbO533no9E+SmVYi2pc4gxlCBw6JO8dmTZ/O6KDBF4fzZ2AlBf26VPCLfYSdSttqeUkxe8BpSbVF2uX8n7YE3lHN+09H72/mbEk2SNHg528tFcp//UjoEnSlH0fhMQVWL0e3dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768845354; c=relaxed/simple;
	bh=8Cvh2KaSfQf8lSAJTgG2RJCMySIRjoZIzHP4R/SzfNY=;
	h=Date:To:From:Subject:Message-Id; b=mAjQUJblXX8Sxyfi386+NwTMyuU8QiubhBvwza48b47zdXxRkbsNfBEdlzCZq6kRi4u5mSPAdNhp5lo/9ZmEj0U80+0VRxBSdSsfrSjdC1UxWWGsXoftvyOtqyUOoL9YgvD91GxpSdyylQQmgkHmbudwGL7OXjOaAbJ+0sjSJJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KRbOJGkG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KRbOJGkG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E68FC116C6;
	Mon, 19 Jan 2026 17:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768845353;
	bh=8Cvh2KaSfQf8lSAJTgG2RJCMySIRjoZIzHP4R/SzfNY=;
	h=Date:To:From:Subject:From;
	b=KRbOJGkGUpzuk0vNkOxmbl3uBhuT3eure7CdBMdCkg+6+13fnk1yLZqV22pdTtAgt
	 jwBbto0p3II/RBMQp7dOin6e1mVkDqrUbHsrKZeg0N+OE/WG1ubVvkpvqefTX7cFeg
	 5yGlELkggPYavHor6pKTiUpsFThph1O0HFvrxgJo=
Date: Mon, 19 Jan 2026 09:55:52 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-fix-race-of-truncate-and-swap-entry-split.patch added to mm-hotfixes-unstable branch
Message-Id: <20260119175553.7E68FC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem, swap: fix race of truncate and swap entry split
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-swap-fix-race-of-truncate-and-swap-entry-split.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-swap-fix-race-of-truncate-and-swap-entry-split.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/shmem, swap: fix race of truncate and swap entry split
Date: Tue, 20 Jan 2026 00:11:21 +0800

The helper for shmem swap freeing is not handling the order of swap
entries correctly.  It uses xa_cmpxchg_irq to erase the swap entry, but it
gets the entry order before that using xa_get_order without lock
protection, and it may get an outdated order value if the entry is split
or changed in other ways after the xa_get_order and before the
xa_cmpxchg_irq.

And besides, the order could grow and be larger than expected, and cause
truncation to erase data beyond the end border.  For example, if the
target entry and following entries are swapped in or freed, then a large
folio was added in place and swapped out, using the same entry, the
xa_cmpxchg_irq will still succeed, it's very unlikely to happen though.

To fix that, open code the Xarray cmpxchg and put the order retrieval and
value checking in the same critical section.  Also, ensure the order won't
exceed the end border, skip it if the entry goes across the border.

Skipping large swap entries crosses the end border is safe here.  Shmem
truncate iterates the range twice, in the first iteration,
find_lock_entries already filtered such entries, and shmem will swapin the
entries that cross the end border and partially truncate the folio (split
the folio or at least zero part of it).  So in the second loop here, if we
see a swap entry that crosses the end order, it must at least have its
content erased already.

I observed random swapoff hangs and kernel panics when stress testing
ZSWAP with shmem.  After applying this patch, all problems are gone.

Link: https://lkml.kernel.org/r/20260120-shmem-swap-fix-v3-1-3d33ebfbc057@tencent.com
Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   45 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 34 insertions(+), 11 deletions(-)

--- a/mm/shmem.c~mm-shmem-swap-fix-race-of-truncate-and-swap-entry-split
+++ a/mm/shmem.c
@@ -962,17 +962,29 @@ static void shmem_delete_from_page_cache
  * being freed).
  */
 static long shmem_free_swap(struct address_space *mapping,
-			    pgoff_t index, void *radswap)
+			    pgoff_t index, pgoff_t end, void *radswap)
 {
-	int order = xa_get_order(&mapping->i_pages, index);
-	void *old;
+	XA_STATE(xas, &mapping->i_pages, index);
+	unsigned int nr_pages = 0;
+	pgoff_t base;
+	void *entry;
+
+	xas_lock_irq(&xas);
+	entry = xas_load(&xas);
+	if (entry == radswap) {
+		nr_pages = 1 << xas_get_order(&xas);
+		base = round_down(xas.xa_index, nr_pages);
+		if (base < index || base + nr_pages - 1 > end)
+			nr_pages = 0;
+		else
+			xas_store(&xas, NULL);
+	}
+	xas_unlock_irq(&xas);
 
-	old = xa_cmpxchg_irq(&mapping->i_pages, index, radswap, NULL, 0);
-	if (old != radswap)
-		return 0;
-	free_swap_and_cache_nr(radix_to_swp_entry(radswap), 1 << order);
+	if (nr_pages)
+		free_swap_and_cache_nr(radix_to_swp_entry(radswap), nr_pages);
 
-	return 1 << order;
+	return nr_pages;
 }
 
 /*
@@ -1124,8 +1136,8 @@ static void shmem_undo_range(struct inod
 			if (xa_is_value(folio)) {
 				if (unfalloc)
 					continue;
-				nr_swaps_freed += shmem_free_swap(mapping,
-							indices[i], folio);
+				nr_swaps_freed += shmem_free_swap(mapping, indices[i],
+								  end - 1, folio);
 				continue;
 			}
 
@@ -1191,12 +1203,23 @@ whole_folios:
 			folio = fbatch.folios[i];
 
 			if (xa_is_value(folio)) {
+				int order;
 				long swaps_freed;
 
 				if (unfalloc)
 					continue;
-				swaps_freed = shmem_free_swap(mapping, indices[i], folio);
+				swaps_freed = shmem_free_swap(mapping, indices[i],
+							      end - 1, folio);
 				if (!swaps_freed) {
+					/*
+					 * If found a large swap entry cross the end border,
+					 * skip it as the truncate_inode_partial_folio above
+					 * should have at least zerod its content once.
+					 */
+					order = shmem_confirm_swap(mapping, indices[i],
+								   radix_to_swp_entry(folio));
+					if (order > 0 && indices[i] + (1 << order) > end)
+						continue;
 					/* Swap was replaced by page: retry */
 					index = indices[i];
 					break;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-shmem-swap-fix-race-of-truncate-and-swap-entry-split.patch
mm-gup-remove-no-longer-used-gup_fast_undo_dev_pagemap.patch
mm-swap-rename-__read_swap_cache_async-to-swap_cache_alloc_folio.patch
mm-swap-split-swap-cache-preparation-loop-into-a-standalone-helper.patch
mm-swap-never-bypass-the-swap-cache-even-for-swp_synchronous_io.patch
mm-swap-always-try-to-free-swap-cache-for-swp_synchronous_io-devices.patch
mm-swap-simplify-the-code-and-reduce-indention.patch
mm-swap-free-the-swap-cache-after-folio-is-mapped.patch
mm-shmem-never-bypass-the-swap-cache-for-swp_synchronous_io.patch
mm-swap-swap-entry-of-a-bad-slot-should-not-be-considered-as-swapped-out.patch
mm-swap-consolidate-cluster-reclaim-and-usability-check.patch
mm-swap-split-locked-entry-duplicating-into-a-standalone-helper.patch
mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer.patch
mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer-fix.patch
mm-swap-remove-workaround-for-unsynchronized-swap-map-cache-state.patch
mm-swap-cleanup-swap-entry-management-workflow.patch
mm-swap-cleanup-swap-entry-management-workflow-fix.patch
mm-swap-add-folio-to-swap-cache-directly-on-allocation.patch
mm-swap-check-swap-table-directly-for-checking-cache.patch
mm-swap-clean-up-and-improve-swap-entries-freeing.patch
mm-swap-drop-the-swap_has_cache-flag.patch
mm-swap-remove-no-longer-needed-_swap_info_get.patch

