Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB59273FC
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247661; cv=none; b=hD5mBL+ecNw88b+krnz9x32XdxoP8RfHdmuXQHxze/IUgeSgs7CM97eBumZy09G42QKCCww8uQT3SHNrpTgGQGNbZmjm3U6I2Y0z/us6svcOXxMaKo3yc1ebp8De0YvbhC9RhLxDkU2sZSsosIKicAcaIEK2YZQsn2V78m7Fe8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247661; c=relaxed/simple;
	bh=4r3Bac92NOUlhi7+n556bEjxxlrWFw5aBUFWc2HYtqc=;
	h=Date:To:From:Subject:Message-Id; b=lI1pW0JLPlABwbeuMh0Mn44+JU+HxInSDJ2ypZH6s7c4IMVYR+eZaYM3fuHypBGZjiENAxu9f5Qtrmw1eTvtXcq2DXchmMwl4GdkwbDGFvvLCor6648K1JuiN5Rz3xAZx9AuD7dqPjxztOlIbODpjG0a/qkGeXOx2Xt99ObJWZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NNIj5CIh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NNIj5CIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0130C4CEC2;
	Mon,  2 Sep 2024 03:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247661;
	bh=4r3Bac92NOUlhi7+n556bEjxxlrWFw5aBUFWc2HYtqc=;
	h=Date:To:From:Subject:From;
	b=NNIj5CIh7tuRzbvSkptv2N4ivsD15svR0OHsrQtJlFiwN95qIFZjEYMKXjXs50R3u
	 0qclAnQbOzoKZGrYK28yUy7adbT7vL9/0ziIdTc/Rq2WGX1yb/5h9J65EEFQ3hrD3M
	 R0qlKoPT8MX0jyrR93TDRBQtkHc0b3eZ5mUmLDKw=
Date: Sun, 01 Sep 2024 20:27:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-simplify-the-suitable-huge-orders-validation-for-tmpfs.patch removed from -mm tree
Message-Id: <20240902032740.F0130C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: simplify the suitable huge orders validation for tmpfs
has been removed from the -mm tree.  Its filename was
     mm-shmem-simplify-the-suitable-huge-orders-validation-for-tmpfs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: simplify the suitable huge orders validation for tmpfs
Date: Mon, 22 Jul 2024 13:43:17 +0800

Patch series "Some cleanups for shmem", v3.

This series does some cleanups to reuse code, rename functions and
simplify logic to make code more clear.  No functional changes are
expected.


This patch (of 3):

Move the suitable huge orders validation into shmem_suitable_orders() for
tmpfs, which can reuse some code to simplify the logic.

In addition, we don't have special handling for the error code -E2BIG when
checking for conflicts with PMD sized THP in the pagecache for tmpfs,
instead, it will just fallback to order-0 allocations like this patch
does, so this simplification will not add functional changes.

Link: https://lkml.kernel.org/r/cover.1721626645.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/965985dd6d322929d78a0beee0dafa1c2a1b81e2.1721626645.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   39 +++++++++++++++------------------------
 1 file changed, 15 insertions(+), 24 deletions(-)

--- a/mm/shmem.c~mm-shmem-simplify-the-suitable-huge-orders-validation-for-tmpfs
+++ a/mm/shmem.c
@@ -1680,20 +1680,30 @@ static unsigned long shmem_suitable_orde
 					   struct address_space *mapping, pgoff_t index,
 					   unsigned long orders)
 {
-	struct vm_area_struct *vma = vmf->vma;
+	struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
 	pgoff_t aligned_index;
 	unsigned long pages;
 	int order;
 
-	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
-	if (!orders)
-		return 0;
+	if (vma) {
+		orders = thp_vma_suitable_orders(vma, vmf->address, orders);
+		if (!orders)
+			return 0;
+	}
 
 	/* Find the highest order that can add into the page cache */
 	order = highest_order(orders);
 	while (orders) {
 		pages = 1UL << order;
 		aligned_index = round_down(index, pages);
+		/*
+		 * Check for conflict before waiting on a huge allocation.
+		 * Conflict might be that a huge page has just been allocated
+		 * and added to page cache by a racing thread, or that there
+		 * is already at least one small page in the huge extent.
+		 * Be careful to retry when appropriate, but not forever!
+		 * Elsewhere -EEXIST would be the right code, but not here.
+		 */
 		if (!xa_find(&mapping->i_pages, &aligned_index,
 			     aligned_index + pages - 1, XA_PRESENT))
 			break;
@@ -1731,7 +1741,6 @@ static struct folio *shmem_alloc_and_add
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
-	struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
 	unsigned long suitable_orders = 0;
 	struct folio *folio = NULL;
 	long pages;
@@ -1741,26 +1750,8 @@ static struct folio *shmem_alloc_and_add
 		orders = 0;
 
 	if (orders > 0) {
-		if (vma && vma_is_anon_shmem(vma)) {
-			suitable_orders = shmem_suitable_orders(inode, vmf,
+		suitable_orders = shmem_suitable_orders(inode, vmf,
 							mapping, index, orders);
-		} else if (orders & BIT(HPAGE_PMD_ORDER)) {
-			pages = HPAGE_PMD_NR;
-			suitable_orders = BIT(HPAGE_PMD_ORDER);
-			index = round_down(index, HPAGE_PMD_NR);
-
-			/*
-			 * Check for conflict before waiting on a huge allocation.
-			 * Conflict might be that a huge page has just been allocated
-			 * and added to page cache by a racing thread, or that there
-			 * is already at least one small page in the huge extent.
-			 * Be careful to retry when appropriate, but not forever!
-			 * Elsewhere -EEXIST would be the right code, but not here.
-			 */
-			if (xa_find(&mapping->i_pages, &index,
-				    index + HPAGE_PMD_NR - 1, XA_PRESENT))
-				return ERR_PTR(-E2BIG);
-		}
 
 		order = highest_order(suitable_orders);
 		while (suitable_orders) {
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting.patch
mm-shmem-extend-shmem_partial_swap_usage-to-support-large-folio-swap.patch
mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch
mm-shmem-use-swap_free_nr-to-free-shmem-swap-entries.patch
mm-shmem-support-large-folio-allocation-for-shmem_replace_folio.patch
mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix.patch
mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix-fix.patch
mm-shmem-drop-folio-reference-count-using-nr_pages-in-shmem_delete_from_page_cache.patch
mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large.patch
mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix-2.patch
mm-shmem-support-large-folio-swap-out.patch
mm-shmem-support-large-folio-swap-out-fix-2.patch
mm-khugepaged-expand-the-is_refcount_suitable-to-support-file-folios.patch
mm-khugepaged-use-the-number-of-pages-in-the-folio-to-check-the-reference-count.patch
mm-khugepaged-support-shmem-mthp-copy.patch
mm-khugepaged-support-shmem-mthp-collapse.patch
selftests-mm-support-shmem-mthp-collapse-testing.patch

