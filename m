Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6987D182B4
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247663; cv=none; b=dgLqPwFO4PY+q9JfqVEeht8KFzHG2SVLLd6rOv4AC0CklQpoDk3PXmxDFuF8R64mKH9Y+81zIUoE0P5cZF+EGs6PeWi/HUJZpx2z7NqezBYmGk4F6QiL5TxsYEU8cnQDUZcAg4QCDVm+aARlOtaAhF+7S+7GmeQgG9ZNoqtLWsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247663; c=relaxed/simple;
	bh=k/FTN4IV5KnC32BdWL8Jap8zMESz2xBtMgogeDN5KX0=;
	h=Date:To:From:Subject:Message-Id; b=F6QRsK51IoWFKP9c6V9dYZSLgui4lXLDugKHmYuAxcfvsDzQlms0slaEntbT0R6tcdulAulYsHHy/vCXNezy4h3r317ACZkDkWjomlUZnB7Qj/ttm+JezA1wKwG/9kNwsWFQnn7wqs0Fh3KFitYQf9RVeVkT9avs4dq2HJw8RR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DGRsrUQ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DGRsrUQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3442DC4CEC2;
	Mon,  2 Sep 2024 03:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247663;
	bh=k/FTN4IV5KnC32BdWL8Jap8zMESz2xBtMgogeDN5KX0=;
	h=Date:To:From:Subject:From;
	b=DGRsrUQ0zwFsztMqsSkPiaWPAU7u3aaJJfIP+gHDYKFPSFi3N8zEU5RvAcgNgb15R
	 FbR/2wdVH/cWMavnIWJqV5lFyXy6pnyQfxGt4/SDWifr+wryOU9U/0nEZjlAAx+0rx
	 8wziKYCGKzDJX+oouXDsKGZ9DSt4y7kSx6O5OZ7c=
Date: Sun, 01 Sep 2024 20:27:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-move-shmem_huge_global_enabled-into-shmem_allowable_huge_orders.patch removed from -mm tree
Message-Id: <20240902032743.3442DC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: move shmem_huge_global_enabled() into shmem_allowable_huge_orders()
has been removed from the -mm tree.  Its filename was
     mm-shmem-move-shmem_huge_global_enabled-into-shmem_allowable_huge_orders.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: move shmem_huge_global_enabled() into shmem_allowable_huge_orders()
Date: Mon, 22 Jul 2024 13:43:19 +0800

Move shmem_huge_global_enabled() into shmem_allowable_huge_orders(), so
that shmem_allowable_huge_orders() can also help to find the allowable
huge orders for tmpfs.  Moreover the shmem_huge_global_enabled() can
become static.  While we are at it, passing the vma instead of mm for
shmem_huge_global_enabled() makes code cleaner.

No functional changes.

Link: https://lkml.kernel.org/r/8e825146bb29ee1a1c7bd64d2968ff3e19be7815.1721626645.git.baolin.wang@linux.alibaba.com
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

 include/linux/shmem_fs.h |   12 +--------
 mm/huge_memory.c         |   12 ++-------
 mm/shmem.c               |   47 +++++++++++++++++++++++--------------
 3 files changed, 35 insertions(+), 36 deletions(-)

--- a/include/linux/shmem_fs.h~mm-shmem-move-shmem_huge_global_enabled-into-shmem_allowable_huge_orders
+++ a/include/linux/shmem_fs.h
@@ -111,21 +111,13 @@ extern void shmem_truncate_range(struct
 int shmem_unuse(unsigned int type);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-extern bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index, bool shmem_huge_force,
-				      struct mm_struct *mm, unsigned long vm_flags);
 unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
-				bool global_huge);
+				bool shmem_huge_force);
 #else
-static __always_inline bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
-						      bool shmem_huge_force, struct mm_struct *mm,
-						      unsigned long vm_flags)
-{
-	return false;
-}
 static inline unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
-				bool global_huge)
+				bool shmem_huge_force)
 {
 	return 0;
 }
--- a/mm/huge_memory.c~mm-shmem-move-shmem_huge_global_enabled-into-shmem_allowable_huge_orders
+++ a/mm/huge_memory.c
@@ -159,16 +159,10 @@ unsigned long __thp_vma_allowable_orders
 	 * Must be done before hugepage flags check since shmem has its
 	 * own flags.
 	 */
-	if (!in_pf && shmem_file(vma->vm_file)) {
-		bool global_huge = shmem_huge_global_enabled(file_inode(vma->vm_file),
-							     vma->vm_pgoff, !enforce_sysfs,
-							     vma->vm_mm, vm_flags);
-
-		if (!vma_is_anon_shmem(vma))
-			return global_huge ? orders : 0;
+	if (!in_pf && shmem_file(vma->vm_file))
 		return shmem_allowable_huge_orders(file_inode(vma->vm_file),
-							vma, vma->vm_pgoff, global_huge);
-	}
+						   vma, vma->vm_pgoff,
+						   !enforce_sysfs);
 
 	if (!vma_is_anonymous(vma)) {
 		/*
--- a/mm/shmem.c~mm-shmem-move-shmem_huge_global_enabled-into-shmem_allowable_huge_orders
+++ a/mm/shmem.c
@@ -549,9 +549,10 @@ static bool shmem_confirm_swap(struct ad
 static int shmem_huge __read_mostly = SHMEM_HUGE_NEVER;
 
 static bool __shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
-					bool shmem_huge_force, struct mm_struct *mm,
+					bool shmem_huge_force, struct vm_area_struct *vma,
 					unsigned long vm_flags)
 {
+	struct mm_struct *mm = vma ? vma->vm_mm : NULL;
 	loff_t i_size;
 
 	if (!S_ISREG(inode->i_mode))
@@ -581,15 +582,15 @@ static bool __shmem_huge_global_enabled(
 	}
 }
 
-bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
-		   bool shmem_huge_force, struct mm_struct *mm,
+static bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
+		   bool shmem_huge_force, struct vm_area_struct *vma,
 		   unsigned long vm_flags)
 {
 	if (HPAGE_PMD_ORDER > MAX_PAGECACHE_ORDER)
 		return false;
 
 	return __shmem_huge_global_enabled(inode, index, shmem_huge_force,
-					   mm, vm_flags);
+					   vma, vm_flags);
 }
 
 #if defined(CONFIG_SYSFS)
@@ -772,6 +773,13 @@ static unsigned long shmem_unused_huge_s
 {
 	return 0;
 }
+
+static bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
+		bool shmem_huge_force, struct vm_area_struct *vma,
+		unsigned long vm_flags)
+{
+	return false;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 /*
@@ -1625,22 +1633,33 @@ static gfp_t limit_gfp_mask(gfp_t huge_g
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
-				bool global_huge)
+				bool shmem_huge_force)
 {
 	unsigned long mask = READ_ONCE(huge_shmem_orders_always);
 	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
-	unsigned long vm_flags = vma->vm_flags;
+	unsigned long vm_flags = vma ? vma->vm_flags : 0;
+	bool global_huge;
 	loff_t i_size;
 	int order;
 
-	if ((vm_flags & VM_NOHUGEPAGE) ||
-	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
+	if (vma && ((vm_flags & VM_NOHUGEPAGE) ||
+	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags)))
 		return 0;
 
 	/* If the hardware/firmware marked hugepage support disabled. */
 	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED))
 		return 0;
 
+	global_huge = shmem_huge_global_enabled(inode, index, shmem_huge_force,
+						vma, vm_flags);
+	if (!vma || !vma_is_anon_shmem(vma)) {
+		/*
+		 * For tmpfs, we now only support PMD sized THP if huge page
+		 * is enabled, otherwise fallback to order 0.
+		 */
+		return global_huge ? BIT(HPAGE_PMD_ORDER) : 0;
+	}
+
 	/*
 	 * Following the 'deny' semantics of the top level, force the huge
 	 * option off from all mounts.
@@ -2077,7 +2096,7 @@ static int shmem_get_folio_gfp(struct in
 	struct mm_struct *fault_mm;
 	struct folio *folio;
 	int error;
-	bool alloced, huge;
+	bool alloced;
 	unsigned long orders = 0;
 
 	if (WARN_ON_ONCE(!shmem_mapping(inode->i_mapping)))
@@ -2150,14 +2169,8 @@ repeat:
 		return 0;
 	}
 
-	huge = shmem_huge_global_enabled(inode, index, false, fault_mm,
-			     vma ? vma->vm_flags : 0);
-	/* Find hugepage orders that are allowed for anonymous shmem. */
-	if (vma && vma_is_anon_shmem(vma))
-		orders = shmem_allowable_huge_orders(inode, vma, index, huge);
-	else if (huge)
-		orders = BIT(HPAGE_PMD_ORDER);
-
+	/* Find hugepage orders that are allowed for anonymous shmem and tmpfs. */
+	orders = shmem_allowable_huge_orders(inode, vma, index, false);
 	if (orders > 0) {
 		gfp_t huge_gfp;
 
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

