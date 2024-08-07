Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616E75D8F0
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 20:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723063573; cv=none; b=NImjPEhZDdgC3/RlTrVTqbm+089SWA2UTPcB7JGqnCjYUMtEyG7T0bzoR/Nx85H/ZKFRP1U6dlveSDm0xUjfeTmYFvuun90SXsMt3Pm5GbFdrYjJMRziPYUM+zeKYz15ZPIvD9+1PsA+5EQfgKSdPeWpHImhjYaM/RCikZvzcEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723063573; c=relaxed/simple;
	bh=1mHH9ZS/2jl9M82PTXBQTHLWUxdKdqTISA5t3DtfMVs=;
	h=Date:To:From:Subject:Message-Id; b=HSrbCN0T5jWyhDtUW9nFAF9e7GNUOVfyQTVOA45wGnO7hbOLlHyEFamh1qJWOkp2BXHndv3tNO9gVRrxmHBA3dULY2T6HwFiYChfukz8QTEVs6EodIMkVcD1NkRxw7V9PfJPcQLutm79i8F5rjzBV+rShp5bPAOIElbKXujKpwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gbBuTH/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gbBuTH/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1CB4C32781;
	Wed,  7 Aug 2024 20:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723063572;
	bh=1mHH9ZS/2jl9M82PTXBQTHLWUxdKdqTISA5t3DtfMVs=;
	h=Date:To:From:Subject:From;
	b=gbBuTH/n7Rz/FuArLKzYiHvTmAA9wAmjxBP7cwUIDhZPNyYHrhMxS1uazN6Stikmo
	 9H6ObuIEN1S/xKpHUqg0U/pbD5Z0YNThwcreb2o1QCGUfDGVSctzFVSWFW58AjqTyP
	 X5rMgOu83rzZsTx4Rt8WP8qQFUk1a4+hmoMAk+BM=
Date: Wed, 07 Aug 2024 13:46:12 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,chrisl@kernel.org,baohua@kernel.org,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large.patch added to mm-unstable branch
Message-Id: <20240807204612.D1CB4C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: split large entry if the swapin folio is not large
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large.patch

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
Subject: mm: shmem: split large entry if the swapin folio is not large
Date: Wed, 7 Aug 2024 15:31:14 +0800

Now the swap device can only swap-in order 0 folio, even though a large
folio is swapped out.  This requires us to split the large entry
previously saved in the shmem pagecache to support the swap in of small
folios.

Link: https://lkml.kernel.org/r/7eef2117208a6146ea31e8c87238f1b25519c07c.1723012159.git.baolin.wang@linux.alibaba.com
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

 mm/shmem.c |  100 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)

--- a/mm/shmem.c~mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large
+++ a/mm/shmem.c
@@ -1990,6 +1990,81 @@ static void shmem_set_folio_swapin_error
 	swap_free_nr(swap, nr_pages);
 }
 
+static int shmem_split_large_entry(struct inode *inode, pgoff_t index,
+				   swp_entry_t swap, int new_order, gfp_t gfp)
+{
+	struct address_space *mapping = inode->i_mapping;
+	XA_STATE_ORDER(xas, &mapping->i_pages, index, new_order);
+	void *alloced_shadow = NULL;
+	int alloced_order = 0, i;
+
+	for (;;) {
+		int order = -1, split_order = 0;
+		void *old = NULL;
+
+		xas_lock_irq(&xas);
+		old = xas_load(&xas);
+		if (!xa_is_value(old) || swp_to_radix_entry(swap) != old) {
+			xas_set_err(&xas, -EEXIST);
+			goto unlock;
+		}
+
+		order = xas_get_order(&xas);
+
+		/* Swap entry may have changed before we re-acquire the lock */
+		if (alloced_order &&
+		    (old != alloced_shadow || order != alloced_order)) {
+			xas_destroy(&xas);
+			alloced_order = 0;
+		}
+
+		/* Try to split large swap entry in pagecache */
+		if (order > 0 && order > new_order) {
+			if (!alloced_order) {
+				split_order = order;
+				goto unlock;
+			}
+			xas_split(&xas, old, order);
+
+			/*
+			 * Re-set the swap entry after splitting, and the swap
+			 * offset of the original large entry must be continuous.
+			 */
+			for (i = 0; i < 1 << order; i += (1 << new_order)) {
+				pgoff_t aligned_index = round_down(index, 1 << order);
+				swp_entry_t tmp;
+
+				tmp = swp_entry(swp_type(swap), swp_offset(swap) + i);
+				__xa_store(&mapping->i_pages, aligned_index + i,
+					   swp_to_radix_entry(tmp), 0);
+			}
+		}
+
+unlock:
+		xas_unlock_irq(&xas);
+
+		/* split needed, alloc here and retry. */
+		if (split_order) {
+			xas_split_alloc(&xas, old, split_order, gfp);
+			if (xas_error(&xas))
+				goto error;
+			alloced_shadow = old;
+			alloced_order = split_order;
+			xas_reset(&xas);
+			continue;
+		}
+
+		if (!xas_nomem(&xas, gfp))
+			break;
+	}
+
+error:
+	if (xas_error(&xas))
+		return xas_error(&xas);
+
+	return alloced_order;
+}
+
 /*
  * Swap in the folio pointed to by *foliop.
  * Caller has to make sure that *foliop contains a valid swapped folio.
@@ -2026,12 +2101,37 @@ static int shmem_swapin_folio(struct ino
 	/* Look it up and read it in.. */
 	folio = swap_cache_get_folio(swap, NULL, 0);
 	if (!folio) {
+		int split_order;
+
 		/* Or update major stats only when swapin succeeds?? */
 		if (fault_type) {
 			*fault_type |= VM_FAULT_MAJOR;
 			count_vm_event(PGMAJFAULT);
 			count_memcg_event_mm(fault_mm, PGMAJFAULT);
 		}
+
+		/*
+		 * Now swap device can only swap in order 0 folio, then we
+		 * should split the large swap entry stored in the pagecache
+		 * if necessary.
+		 */
+		split_order = shmem_split_large_entry(inode, index, swap, 0, gfp);
+		if (split_order < 0) {
+			error = split_order;
+			goto failed;
+		}
+
+		/*
+		 * If the large swap entry has already been split, it is
+		 * necessary to recalculate the new swap entry based on
+		 * the old order alignment.
+		 */
+		if (split_order > 0) {
+			pgoff_t offset = index - round_down(index, 1 << split_order);
+
+			swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
+		}
+
 		/* Here we actually start the io */
 		folio = shmem_swapin_cluster(swap, gfp, info, index);
 		if (!folio) {
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

