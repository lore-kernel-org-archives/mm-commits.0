Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5811B2D061C;
	Tue, 27 Jan 2026 02:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769482653; cv=none; b=E/nghvkKGyudpAE5WzSENzpydQ6+EKvSd9DUG0W6vq4ZYX/9CPMn9Xth6GjLy0yqP5f3zhZlGdsG3X3ANB+dfOKTHwch4rwNi4CuNpY2a2AvlZrtn9p6lxntYE+O5n5oBAVhL+HHq5t8O4m2yhsm2YECjvOKb+elqMRT6Q1QJCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769482653; c=relaxed/simple;
	bh=bp8EhhDl2LQSzBNM23pqjJLxrBerJl7VRHPlIWMkS4k=;
	h=Date:To:From:Subject:Message-Id; b=o+ILKEie2ZzIFlTCOVMc5k6uIyTm4G6xlDgo2vECQOczGR+3PufYLpl9Hems47/u4lpuVUbtLJSkCg9RGFbO6deq2EKB47n8tqiupfwIPxJ4JeJISma6k+t0YX4ga3qidrRSoDe+nF4QRC1CIyTJMErcWpKrM8iQt4An9FeXjPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ePuPhgj2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ePuPhgj2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C00C116C6;
	Tue, 27 Jan 2026 02:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769482653;
	bh=bp8EhhDl2LQSzBNM23pqjJLxrBerJl7VRHPlIWMkS4k=;
	h=Date:To:From:Subject:From;
	b=ePuPhgj2eSW5TJUfkS+Ow7L3ryedBpzc6gbNno9OQokoBNIG6w9q9T8dUUsKBQ5yK
	 uCdcPlvMuLQMR71dYXLX7r4EsXl1DP90ChsS+ishw5pEH2YCL2pwtyff8EWw1UBDR+
	 d4mm4UkA3h7Vbp7JIdgHEBJyUFDaGF/Hw29udj1c=
Date: Mon, 26 Jan 2026 18:57:32 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-shmem-swap-fix-race-of-truncate-and-swap-entry-split.patch removed from -mm tree
Message-Id: <20260127025732.E6C00C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem, swap: fix race of truncate and swap entry split
has been removed from the -mm tree.  Its filename was
     mm-shmem-swap-fix-race-of-truncate-and-swap-entry-split.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
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

