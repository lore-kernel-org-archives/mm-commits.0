Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4425D273FC
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247662; cv=none; b=ofTdvJHEVh5G2pU89hKmsYLkp6knrfpl8Oc2Vqqocf9cZPPlXYQXZn408wjO2mabswzVjt2/2zP0F9M5h+LL6XA0rIX2lwI4zg8N6m1Qdn5J2XC9L/RoBgJgkb+9au8+MoMQ9VvNH6fHw1R+UTxVVPFr+4B11Y+QIm1F92fA2bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247662; c=relaxed/simple;
	bh=2aqZhGIMSjiK1W2fcx1heyL93vsVStqA7h8vMmmUpsA=;
	h=Date:To:From:Subject:Message-Id; b=T78BALn87Q5yrf7T15D2P8q6koBwjhoLeCK8Ed90m0O1yjk5TFQCSOl0YlJmySYJyKLbP04ZkZO8GZt+gtdv2/9ezMK1uvCgp83LondOOec6jzozd+VsgzeUgAdMYWuAeWL1mE27rZSWU8ippmJz7toNvDfZxTfXkqx1xgmHVVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XI26K8bj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XI26K8bj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A61C4CEC2;
	Mon,  2 Sep 2024 03:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247662;
	bh=2aqZhGIMSjiK1W2fcx1heyL93vsVStqA7h8vMmmUpsA=;
	h=Date:To:From:Subject:From;
	b=XI26K8bj9qu4srJYXidGushDcmzoDR3dMhXv1LMUApB2BodTvKQUdyfTM2QMW8ymC
	 FoZDEGQFxWjRJ1CbMFPIJiQ4M8opl5RpzlNSNg0tgsfPHoa2UYVAzntCKVaFfhCUri
	 hIv092plyNh3VBJ3KebDaq3hEuf/oPy/RbzdaYw0=
Date: Sun, 01 Sep 2024 20:27:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled.patch removed from -mm tree
Message-Id: <20240902032742.16A61C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: rename shmem_is_huge() to shmem_huge_global_enabled()
has been removed from the -mm tree.  Its filename was
     mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: rename shmem_is_huge() to shmem_huge_global_enabled()
Date: Mon, 22 Jul 2024 13:43:18 +0800

shmem_is_huge() is now used to check if the top-level huge page is
enabled, thus rename it to reflect its usage.

Link: https://lkml.kernel.org/r/da53296e0ab6359aa083561d9dc01e4223d60fbe.1721626645.git.baolin.wang@linux.alibaba.com
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

 include/linux/shmem_fs.h |    9 +++++----
 mm/huge_memory.c         |    5 +++--
 mm/shmem.c               |   15 ++++++++-------
 3 files changed, 16 insertions(+), 13 deletions(-)

--- a/include/linux/shmem_fs.h~mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled
+++ a/include/linux/shmem_fs.h
@@ -111,14 +111,15 @@ extern void shmem_truncate_range(struct
 int shmem_unuse(unsigned int type);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-extern bool shmem_is_huge(struct inode *inode, pgoff_t index, bool shmem_huge_force,
-			  struct mm_struct *mm, unsigned long vm_flags);
+extern bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index, bool shmem_huge_force,
+				      struct mm_struct *mm, unsigned long vm_flags);
 unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
 				bool global_huge);
 #else
-static __always_inline bool shmem_is_huge(struct inode *inode, pgoff_t index, bool shmem_huge_force,
-					  struct mm_struct *mm, unsigned long vm_flags)
+static __always_inline bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
+						      bool shmem_huge_force, struct mm_struct *mm,
+						      unsigned long vm_flags)
 {
 	return false;
 }
--- a/mm/huge_memory.c~mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled
+++ a/mm/huge_memory.c
@@ -160,8 +160,9 @@ unsigned long __thp_vma_allowable_orders
 	 * own flags.
 	 */
 	if (!in_pf && shmem_file(vma->vm_file)) {
-		bool global_huge = shmem_is_huge(file_inode(vma->vm_file), vma->vm_pgoff,
-							!enforce_sysfs, vma->vm_mm, vm_flags);
+		bool global_huge = shmem_huge_global_enabled(file_inode(vma->vm_file),
+							     vma->vm_pgoff, !enforce_sysfs,
+							     vma->vm_mm, vm_flags);
 
 		if (!vma_is_anon_shmem(vma))
 			return global_huge ? orders : 0;
--- a/mm/shmem.c~mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled
+++ a/mm/shmem.c
@@ -548,9 +548,9 @@ static bool shmem_confirm_swap(struct ad
 
 static int shmem_huge __read_mostly = SHMEM_HUGE_NEVER;
 
-static bool __shmem_is_huge(struct inode *inode, pgoff_t index,
-			    bool shmem_huge_force, struct mm_struct *mm,
-			    unsigned long vm_flags)
+static bool __shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
+					bool shmem_huge_force, struct mm_struct *mm,
+					unsigned long vm_flags)
 {
 	loff_t i_size;
 
@@ -581,14 +581,15 @@ static bool __shmem_is_huge(struct inode
 	}
 }
 
-bool shmem_is_huge(struct inode *inode, pgoff_t index,
+bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
 		   bool shmem_huge_force, struct mm_struct *mm,
 		   unsigned long vm_flags)
 {
 	if (HPAGE_PMD_ORDER > MAX_PAGECACHE_ORDER)
 		return false;
 
-	return __shmem_is_huge(inode, index, shmem_huge_force, mm, vm_flags);
+	return __shmem_huge_global_enabled(inode, index, shmem_huge_force,
+					   mm, vm_flags);
 }
 
 #if defined(CONFIG_SYSFS)
@@ -1156,7 +1157,7 @@ static int shmem_getattr(struct mnt_idma
 			STATX_ATTR_NODUMP);
 	generic_fillattr(idmap, request_mask, inode, stat);
 
-	if (shmem_is_huge(inode, 0, false, NULL, 0))
+	if (shmem_huge_global_enabled(inode, 0, false, NULL, 0))
 		stat->blksize = HPAGE_PMD_SIZE;
 
 	if (request_mask & STATX_BTIME) {
@@ -2149,7 +2150,7 @@ repeat:
 		return 0;
 	}
 
-	huge = shmem_is_huge(inode, index, false, fault_mm,
+	huge = shmem_huge_global_enabled(inode, index, false, fault_mm,
 			     vma ? vma->vm_flags : 0);
 	/* Find hugepage orders that are allowed for anonymous shmem. */
 	if (vma && vma_is_anon_shmem(vma))
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

