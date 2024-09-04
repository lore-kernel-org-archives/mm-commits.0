Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDC21E515
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 03:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725421917; cv=none; b=LwUe82ru41dWjOkuYdmDRQxSopjy6Ni5A4sam8R651oaOP3jAT9SXo/RvXT7PklLszIUclU6vuuC0VsMck57g3tl1LPqmm+yM2yMuzFusRk/pxYxcKh8b90TMOo7ub+eqVtlfVuYzxYdNVITCQMG0vV97dCS99CRQKzE3pV63VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725421917; c=relaxed/simple;
	bh=cJN/WaUVjmvjGHfIrKnQ5QPRQBKY8tkp6yhSRnnP2ko=;
	h=Date:To:From:Subject:Message-Id; b=bJVeQ0DhuHnXz0erZThGJTacaeWAVMxFvJk9K6DZRYSaron9YISDoEP/EacOYpdurfYVBlIshN3jA96yRZFNjS8NjTxfqARXaR+OQbBRoZ7QCHHJVHFoTHt3B6W9JLPMBREiunneyifrKVKaB0g56MWVTQb/EHMWoHZ64PvBYSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qy2XcOQe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qy2XcOQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87A6C4CEC2;
	Wed,  4 Sep 2024 03:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725421916;
	bh=cJN/WaUVjmvjGHfIrKnQ5QPRQBKY8tkp6yhSRnnP2ko=;
	h=Date:To:From:Subject:From;
	b=Qy2XcOQe3QcvVW5RXIW/q7ocVx0nqPKcFx46/7WfZVR1f05EQIGYMHUiiIxCElnyA
	 dqDHJXfCPGWAulVwUgTBTMUIG7XeITdNIhULsAxVW5JYvMD38tIeq3nimpRY3GdKi7
	 O0QwfywIbhpCLNSOFSbx5BfznYN9nd22hLSmq40Y=
Date: Tue, 03 Sep 2024 20:51:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,chrisl@kernel.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix.patch removed from -mm tree
Message-Id: <20240904035156.A87A6C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: fix the gfp flag for large folio allocation
has been removed from the -mm tree.  Its filename was
     mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix.patch

This patch was dropped because it was folded into mm-shmem-support-large-folio-allocation-for-shmem_replace_folio.patch

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: fix the gfp flag for large folio allocation
Date: Tue, 27 Aug 2024 11:06:34 +0800

In shmem_replace_folio(), it may be necessary to allocate a large folio,
so we should update the gfp flags to ensure it is suitable for allocating
the large folio.

Link: https://lkml.kernel.org/r/5b1e9c5a-7f61-4d97-a8d7-41767ca04c77@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
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

 mm/shmem.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/mm/shmem.c~mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix
+++ a/mm/shmem.c
@@ -155,7 +155,7 @@ static unsigned long shmem_default_max_i
 
 static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 			struct folio **foliop, enum sgp_type sgp, gfp_t gfp,
-			struct mm_struct *fault_mm, vm_fault_t *fault_type);
+			struct vm_area_struct *vma, vm_fault_t *fault_type);
 
 static inline struct shmem_sb_info *SHMEM_SB(struct super_block *sb)
 {
@@ -1883,7 +1883,8 @@ static bool shmem_should_replace_folio(s
 }
 
 static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
-				struct shmem_inode_info *info, pgoff_t index)
+				struct shmem_inode_info *info, pgoff_t index,
+				struct vm_area_struct *vma)
 {
 	struct folio *new, *old = *foliop;
 	swp_entry_t entry = old->swap;
@@ -1898,6 +1899,12 @@ static int shmem_replace_folio(struct fo
 	 * limit chance of success by further cpuset and node constraints.
 	 */
 	gfp &= ~GFP_CONSTRAINT_MASK;
+	if (nr_pages > 1) {
+		gfp_t huge_gfp = vma_thp_gfp_mask(vma);
+
+		gfp = limit_gfp_mask(huge_gfp, gfp);
+	}
+
 	new = shmem_alloc_folio(gfp, folio_order(old), info, index);
 	if (!new)
 		return -ENOMEM;
@@ -1994,10 +2001,11 @@ static void shmem_set_folio_swapin_error
  */
 static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 			     struct folio **foliop, enum sgp_type sgp,
-			     gfp_t gfp, struct mm_struct *fault_mm,
+			     gfp_t gfp, struct vm_area_struct *vma,
 			     vm_fault_t *fault_type)
 {
 	struct address_space *mapping = inode->i_mapping;
+	struct mm_struct *fault_mm = vma ? vma->vm_mm : NULL;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct swap_info_struct *si;
 	struct folio *folio = NULL;
@@ -2058,7 +2066,7 @@ static int shmem_swapin_folio(struct ino
 	arch_swap_restore(folio_swap(swap, folio), folio);
 
 	if (shmem_should_replace_folio(folio, gfp)) {
-		error = shmem_replace_folio(&folio, gfp, info, index);
+		error = shmem_replace_folio(&folio, gfp, info, index, vma);
 		if (error)
 			goto failed;
 	}
@@ -2139,7 +2147,7 @@ repeat:
 
 	if (xa_is_value(folio)) {
 		error = shmem_swapin_folio(inode, index, &folio,
-					   sgp, gfp, fault_mm, fault_type);
+					   sgp, gfp, vma, fault_type);
 		if (error == -EEXIST)
 			goto repeat;
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting.patch
mm-shmem-extend-shmem_partial_swap_usage-to-support-large-folio-swap.patch
mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch
mm-shmem-use-swap_free_nr-to-free-shmem-swap-entries.patch
mm-shmem-support-large-folio-allocation-for-shmem_replace_folio.patch
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

