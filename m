Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96AD480C07
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104113; cv=none; b=VbZxhe840j3vVlYPMwLOA+8IjSRwShAEkUl6br3yUPNEaSuxm+vsed5U6O+ksrLSd0mLSOXOxql0TwUOFBwaqthEu2of0VvwyZxKxgEv+qVITX7Vk7z9nA9dz4njk79v9oJ7eXmgkzCm06vIyx2aTPbtlNenF8VCvbWxj+BEvgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104113; c=relaxed/simple;
	bh=FyeidqZbf7XlsXenc8/RXUUCNF3eMMUXyafR9ML2z1E=;
	h=Date:To:From:Subject:Message-Id; b=nyh+EJ9DyBZfgc9/i4LepNXWt8pKii5JBaypYa0UTvvFL6qqeSzFR0WFLjnjbAdtLU2IJko9W0zFqg98O7/cW3ODxKlFq6i2UfZzW9UbgzazQYb0K/HR1ChHytNepcgFKbHCtI0Mgd35zZacX0h54ZxxrZLqEpDTSJ7eHNJElrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BueKhFbU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BueKhFbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCA6C116B1;
	Fri, 26 Apr 2024 04:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104113;
	bh=FyeidqZbf7XlsXenc8/RXUUCNF3eMMUXyafR9ML2z1E=;
	h=Date:To:From:Subject:From;
	b=BueKhFbUqgsFQCyRYyPFihVEBzeoX1FosUy504SyJaoXqWwRWNmuEpkCyF1mWcw4Q
	 /WBXUnR7zuzaYxhL/PbycuHkeP/JWe5aTU8EY2sufL8IJnZJ0CGtkYlKrs8MaDxVBQ
	 uWT2+6FX0M+pB9laOvzkXDR4EHU9FcVJ5tJ7wLcQ=
Date: Thu, 25 Apr 2024 21:01:52 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rename-vma_pgoff_address-back-to-vma_address.patch removed from -mm tree
Message-Id: <20240426040153.6CCA6C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rename vma_pgoff_address back to vma_address
has been removed from the -mm tree.  Its filename was
     mm-rename-vma_pgoff_address-back-to-vma_address.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: rename vma_pgoff_address back to vma_address
Date: Thu, 28 Mar 2024 22:58:29 +0000

With all callers converted, we can use the nice shorter name.  Take this
opportunity to reorder the arguments to the logical order (larger object
first).

Link: https://lkml.kernel.org/r/20240328225831.1765286-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h        |    9 ++++-----
 mm/memory-failure.c  |    2 +-
 mm/page_vma_mapped.c |    2 +-
 mm/rmap.c            |   12 ++++++------
 4 files changed, 12 insertions(+), 13 deletions(-)

--- a/mm/internal.h~mm-rename-vma_pgoff_address-back-to-vma_address
+++ a/mm/internal.h
@@ -805,17 +805,16 @@ void mlock_drain_remote(int cpu);
 extern pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
 
 /**
- * vma_pgoff_address - Find the virtual address a page range is mapped at
+ * vma_address - Find the virtual address a page range is mapped at
+ * @vma: The vma which maps this object.
  * @pgoff: The page offset within its object.
  * @nr_pages: The number of pages to consider.
- * @vma: The vma which maps this object.
  *
  * If any page in this range is mapped by this VMA, return the first address
  * where any of these pages appear.  Otherwise, return -EFAULT.
  */
-static inline unsigned long
-vma_pgoff_address(pgoff_t pgoff, unsigned long nr_pages,
-		  struct vm_area_struct *vma)
+static inline unsigned long vma_address(struct vm_area_struct *vma,
+		pgoff_t pgoff, unsigned long nr_pages)
 {
 	unsigned long address;
 
--- a/mm/memory-failure.c~mm-rename-vma_pgoff_address-back-to-vma_address
+++ a/mm/memory-failure.c
@@ -455,7 +455,7 @@ static void __add_to_kill(struct task_st
 	tk->addr = ksm_addr ? ksm_addr : page_address_in_vma(p, vma);
 	if (is_zone_device_page(p)) {
 		if (fsdax_pgoff != FSDAX_INVALID_PGOFF)
-			tk->addr = vma_pgoff_address(fsdax_pgoff, 1, vma);
+			tk->addr = vma_address(vma, fsdax_pgoff, 1);
 		tk->size_shift = dev_pagemap_mapping_shift(vma, tk->addr);
 	} else
 		tk->size_shift = page_shift(compound_head(p));
--- a/mm/page_vma_mapped.c~mm-rename-vma_pgoff_address-back-to-vma_address
+++ a/mm/page_vma_mapped.c
@@ -334,7 +334,7 @@ int page_mapped_in_vma(struct page *page
 		.flags = PVMW_SYNC,
 	};
 
-	pvmw.address = vma_pgoff_address(pgoff, 1, vma);
+	pvmw.address = vma_address(vma, pgoff, 1);
 	if (pvmw.address == -EFAULT)
 		return 0;
 	if (!page_vma_mapped_walk(&pvmw))
--- a/mm/rmap.c~mm-rename-vma_pgoff_address-back-to-vma_address
+++ a/mm/rmap.c
@@ -794,7 +794,7 @@ unsigned long page_address_in_vma(struct
 
 	/* The !page__anon_vma above handles KSM folios */
 	pgoff = folio->index + folio_page_idx(folio, page);
-	return vma_pgoff_address(pgoff, 1, vma);
+	return vma_address(vma, pgoff, 1);
 }
 
 /*
@@ -1132,7 +1132,7 @@ int pfn_mkclean_range(unsigned long pfn,
 	if (invalid_mkclean_vma(vma, NULL))
 		return 0;
 
-	pvmw.address = vma_pgoff_address(pgoff, nr_pages, vma);
+	pvmw.address = vma_address(vma, pgoff, nr_pages);
 	VM_BUG_ON_VMA(pvmw.address == -EFAULT, vma);
 
 	return page_vma_mkclean_one(&pvmw);
@@ -2592,8 +2592,8 @@ static void rmap_walk_anon(struct folio
 	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root,
 			pgoff_start, pgoff_end) {
 		struct vm_area_struct *vma = avc->vma;
-		unsigned long address = vma_pgoff_address(pgoff_start,
-				folio_nr_pages(folio), vma);
+		unsigned long address = vma_address(vma, pgoff_start,
+				folio_nr_pages(folio));
 
 		VM_BUG_ON_VMA(address == -EFAULT, vma);
 		cond_resched();
@@ -2654,8 +2654,8 @@ static void rmap_walk_file(struct folio
 lookup:
 	vma_interval_tree_foreach(vma, &mapping->i_mmap,
 			pgoff_start, pgoff_end) {
-		unsigned long address = vma_pgoff_address(pgoff_start,
-			       folio_nr_pages(folio), vma);
+		unsigned long address = vma_address(vma, pgoff_start,
+			       folio_nr_pages(folio));
 
 		VM_BUG_ON_VMA(address == -EFAULT, vma);
 		cond_resched();
_

Patches currently in -mm which might be from willy@infradead.org are

doc-improve-the-description-of-__folio_mark_dirty.patch
buffer-add-kernel-doc-for-block_dirty_folio.patch
buffer-add-kernel-doc-for-try_to_free_buffers.patch
buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch
buffer-add-kernel-doc-for-brelse-and-__brelse.patch
buffer-add-kernel-doc-for-bforget-and-__bforget.patch
buffer-improve-bdev_getblk-documentation.patch
doc-split-bufferrst-out-of-api-summaryrst.patch
doc-split-bufferrst-out-of-api-summaryrst-fix.patch
mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill.patch
mm-memory-failure-pass-addr-to-__add_to_kill.patch
mm-return-the-address-from-page_mapped_in_vma.patch
mm-make-page_mapped_in_vma-conditional-on-config_memory_failure.patch
mm-memory-failure-convert-shake_page-to-shake_folio.patch
mm-convert-hugetlb_page_mapping_lock_write-to-folio.patch
mm-memory-failure-convert-memory_failure-to-use-a-folio.patch
mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio.patch
mm-memory-failure-add-some-folio-conversions-to-unpoison_memory.patch
mm-memory-failure-use-folio-functions-throughout-collect_procs.patch
mm-memory-failure-pass-the-folio-to-collect_procs_ksm.patch
fscrypt-convert-bh_get_inode_and_lblk_num-to-use-a-folio.patch
f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio.patch
memory-failure-remove-calls-to-page_mapping.patch
migrate-expand-the-use-of-folio-in-__migrate_device_pages.patch
userfault-expand-folio-use-in-mfill_atomic_install_pte.patch
mm-remove-page_mapping.patch
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch
mm-simplify-thp_vma_allowable_order.patch

