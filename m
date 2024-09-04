Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176AE6F2EB
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423471; cv=none; b=IJoVh1vwVYBlGty10+v49rDtWzRLA6h0kGy/61HeZe99GeZAP1tFjrD9U0JzbtWymHzU4UhUzXQLfJtpidiEoH5GMe2HmTnpjF2hoVmqNPYus7iG1vmbFZR5lj3wmYSutPwiUZZC0LsKuttDsZQ+q/MwGl4nZZpUI8jEtfgkx0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423471; c=relaxed/simple;
	bh=N3n61D+YJbEZWJZ2dASmsinzWb6khVJFa3b3n8eR7M8=;
	h=Date:To:From:Subject:Message-Id; b=MG/IyjOwsnuE85Y7U6pKxZPZW2UmqyYy9TZRNVWYs65xkR0uMRXyu56oZSZ9EHldjKxr91v9jIl/xUCb9ap+bj8W2gbYuSbd+wK/y/zs1g+qzusG5pFANgGlb8WS5WJ7wdHdbreKk8i5tnXpoUyTbGFoaGc+E6lwsCdy7RNtOHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DuKVOGNY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DuKVOGNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1EF4C4CEC2;
	Wed,  4 Sep 2024 04:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423471;
	bh=N3n61D+YJbEZWJZ2dASmsinzWb6khVJFa3b3n8eR7M8=;
	h=Date:To:From:Subject:From;
	b=DuKVOGNYA+emG1dnQhxCx3PhBbFrtuUNL5AeixMSWv+3jmm760iNqMFLoLAB2+I2G
	 eCWUihS4HW9Pv/Yg7eO/sXKAIxMQAncVmx/5//gtoFScKtg5iqepZMJNO0Wjgdk/Do
	 JBxngXG1CuPYRpeSz6SxO+PFugfPyflaNqZ0LIvU=
Date: Tue, 03 Sep 2024 21:17:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,chrisl@kernel.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-support-large-folio-allocation-for-shmem_replace_folio.patch removed from -mm tree
Message-Id: <20240904041750.E1EF4C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: support large folio allocation for shmem_replace_folio()
has been removed from the -mm tree.  Its filename was
     mm-shmem-support-large-folio-allocation-for-shmem_replace_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: support large folio allocation for shmem_replace_folio()
Date: Mon, 12 Aug 2024 15:42:07 +0800

To support large folio swapin for shmem in the following patches, add
large folio allocation for the new replacement folio in
shmem_replace_folio().  Moreover large folios occupy N consecutive entries
in the swap cache instead of using multi-index entries like the page
cache, therefore we should replace each consecutive entries in the swap
cache instead of using the shmem_replace_entry().

As well as updating statistics and folio reference count using the number
of pages in the folio.

[baolin.wang@linux.alibaba.com: fix the gfp flag for large folio allocation]
  Link: https://lkml.kernel.org/r/5b1e9c5a-7f61-4d97-a8d7-41767ca04c77@linux.alibaba.com
[baolin.wang@linux.alibaba.com: fix build without CONFIG_TRANSPARENT_HUGEPAGE]
  Link: https://lkml.kernel.org/r/8c03467c-63b2-43b4-9851-222d4188725c@linux.alibaba.com
Link: https://lkml.kernel.org/r/a41138ecc857ef13e7c5ffa0174321e9e2c9970a.1723434324.git.baolin.wang@linux.alibaba.com
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

 mm/shmem.c |   74 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 28 deletions(-)

--- a/mm/shmem.c~mm-shmem-support-large-folio-allocation-for-shmem_replace_folio
+++ a/mm/shmem.c
@@ -155,7 +155,7 @@ static unsigned long shmem_default_max_i
 
 static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 			struct folio **foliop, enum sgp_type sgp, gfp_t gfp,
-			struct mm_struct *fault_mm, vm_fault_t *fault_type);
+			struct vm_area_struct *vma, vm_fault_t *fault_type);
 
 static inline struct shmem_sb_info *SHMEM_SB(struct super_block *sb)
 {
@@ -1887,30 +1887,35 @@ static bool shmem_should_replace_folio(s
 }
 
 static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
-				struct shmem_inode_info *info, pgoff_t index)
+				struct shmem_inode_info *info, pgoff_t index,
+				struct vm_area_struct *vma)
 {
-	struct folio *old, *new;
-	struct address_space *swap_mapping;
-	swp_entry_t entry;
-	pgoff_t swap_index;
-	int error;
-
-	old = *foliop;
-	entry = old->swap;
-	swap_index = swap_cache_index(entry);
-	swap_mapping = swap_address_space(entry);
+	struct folio *new, *old = *foliop;
+	swp_entry_t entry = old->swap;
+	struct address_space *swap_mapping = swap_address_space(entry);
+	pgoff_t swap_index = swap_cache_index(entry);
+	XA_STATE(xas, &swap_mapping->i_pages, swap_index);
+	int nr_pages = folio_nr_pages(old);
+	int error = 0, i;
 
 	/*
 	 * We have arrived here because our zones are constrained, so don't
 	 * limit chance of success by further cpuset and node constraints.
 	 */
 	gfp &= ~GFP_CONSTRAINT_MASK;
-	VM_BUG_ON_FOLIO(folio_test_large(old), old);
-	new = shmem_alloc_folio(gfp, 0, info, index);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (nr_pages > 1) {
+		gfp_t huge_gfp = vma_thp_gfp_mask(vma);
+
+		gfp = limit_gfp_mask(huge_gfp, gfp);
+	}
+#endif
+
+	new = shmem_alloc_folio(gfp, folio_order(old), info, index);
 	if (!new)
 		return -ENOMEM;
 
-	folio_get(new);
+	folio_ref_add(new, nr_pages);
 	folio_copy(new, old);
 	flush_dcache_folio(new);
 
@@ -1920,18 +1925,25 @@ static int shmem_replace_folio(struct fo
 	new->swap = entry;
 	folio_set_swapcache(new);
 
-	/*
-	 * Our caller will very soon move newpage out of swapcache, but it's
-	 * a nice clean interface for us to replace oldpage by newpage there.
-	 */
+	/* Swap cache still stores N entries instead of a high-order entry */
 	xa_lock_irq(&swap_mapping->i_pages);
-	error = shmem_replace_entry(swap_mapping, swap_index, old, new);
+	for (i = 0; i < nr_pages; i++) {
+		void *item = xas_load(&xas);
+
+		if (item != old) {
+			error = -ENOENT;
+			break;
+		}
+
+		xas_store(&xas, new);
+		xas_next(&xas);
+	}
 	if (!error) {
 		mem_cgroup_replace_folio(old, new);
-		__lruvec_stat_mod_folio(new, NR_FILE_PAGES, 1);
-		__lruvec_stat_mod_folio(new, NR_SHMEM, 1);
-		__lruvec_stat_mod_folio(old, NR_FILE_PAGES, -1);
-		__lruvec_stat_mod_folio(old, NR_SHMEM, -1);
+		__lruvec_stat_mod_folio(new, NR_FILE_PAGES, nr_pages);
+		__lruvec_stat_mod_folio(new, NR_SHMEM, nr_pages);
+		__lruvec_stat_mod_folio(old, NR_FILE_PAGES, -nr_pages);
+		__lruvec_stat_mod_folio(old, NR_SHMEM, -nr_pages);
 	}
 	xa_unlock_irq(&swap_mapping->i_pages);
 
@@ -1951,7 +1963,12 @@ static int shmem_replace_folio(struct fo
 	old->private = NULL;
 
 	folio_unlock(old);
-	folio_put_refs(old, 2);
+	/*
+	 * The old folio are removed from swap cache, drop the 'nr_pages'
+	 * reference, as well as one temporary reference getting from swap
+	 * cache.
+	 */
+	folio_put_refs(old, nr_pages + 1);
 	return error;
 }
 
@@ -1990,10 +2007,11 @@ static void shmem_set_folio_swapin_error
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
@@ -2054,7 +2072,7 @@ static int shmem_swapin_folio(struct ino
 	arch_swap_restore(folio_swap(swap, folio), folio);
 
 	if (shmem_should_replace_folio(folio, gfp)) {
-		error = shmem_replace_folio(&folio, gfp, info, index);
+		error = shmem_replace_folio(&folio, gfp, info, index, vma);
 		if (error)
 			goto failed;
 	}
@@ -2135,7 +2153,7 @@ repeat:
 
 	if (xa_is_value(folio)) {
 		error = shmem_swapin_folio(inode, index, &folio,
-					   sgp, gfp, fault_mm, fault_type);
+					   sgp, gfp, vma, fault_type);
 		if (error == -EEXIST)
 			goto repeat;
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


