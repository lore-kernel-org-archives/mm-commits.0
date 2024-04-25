Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F073185E
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 00:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714006200; cv=none; b=VVivQiNPNdA86qS53hrY7EAGn1fLhCVitA07Tje9jdEYVz2x5vjy4A+En1Q6qBcwJwKQsrCvizgYGJ59mG2adrW3MgEpQBxl6PvYXDsffFAO04n56rAShoa0oRzvUPsqy+KgsO5dq21aCInWtWmXXL1oNdQb/jh3LlXOrDQkj+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714006200; c=relaxed/simple;
	bh=A2taTXtAjEXZDY4MH7TYXSwWyXeF7o0Q5q97FEAKPsU=;
	h=Date:To:From:Subject:Message-Id; b=m093t2bfNHmRtTKhoIKtzUuPzKPp9tMEZnvOf74qe/KvSv8ZwIXq2Uzn2W4tA1Z+W63Pcwg0HmFMmbv0KqNXo0qCYOsnXbV7rBWYUDGl19S2Vs0SrqBEgHcH0bo1f/ACau+Ffyr8RceArn3lzyJyQz9rvqeG/WwNzQVxR7yshMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZONUclOM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZONUclOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A90C113CD;
	Thu, 25 Apr 2024 00:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714006200;
	bh=A2taTXtAjEXZDY4MH7TYXSwWyXeF7o0Q5q97FEAKPsU=;
	h=Date:To:From:Subject:From;
	b=ZONUclOMWDl7xpwK0/QibXGQD9jIVl3VlNITJzT6/kI5PxmbiDahdZA/Em5C3knou
	 uPwy8HryVYLrvBnDdZ3+RkLGcUn07lPm+WwasJslYZas8lhNkMwXMVCC2aYWLntac9
	 WIQDsVd+HE7/Aqqt+H74V27+ipj4Z8qOHZoxDFMc=
Date: Wed, 24 Apr 2024 17:49:59 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,linmiaohe@huawei.com,jane.chu@oracle.com,dan.j.williams@intel.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-hugetlb_page_mapping_lock_write-to-folio.patch added to mm-unstable branch
Message-Id: <20240425005000.51A90C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert hugetlb_page_mapping_lock_write to folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-hugetlb_page_mapping_lock_write-to-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-hugetlb_page_mapping_lock_write-to-folio.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert hugetlb_page_mapping_lock_write to folio
Date: Fri, 12 Apr 2024 20:35:03 +0100

The page is only used to get the mapping, so the folio will do just as
well.  Both callers already have a folio available, so this saves a call
to compound_head().

Link: https://lkml.kernel.org/r/20240412193510.2356957-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jane Chu  <jane.chu@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 +++---
 mm/hugetlb.c            |    6 +++---
 mm/memory-failure.c     |    2 +-
 mm/migrate.c            |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/hugetlb.h~mm-convert-hugetlb_page_mapping_lock_write-to-folio
+++ a/include/linux/hugetlb.h
@@ -178,7 +178,7 @@ bool hugetlbfs_pagecache_present(struct
 				 struct vm_area_struct *vma,
 				 unsigned long address);
 
-struct address_space *hugetlb_page_mapping_lock_write(struct page *hpage);
+struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio);
 
 extern int sysctl_hugetlb_shm_group;
 extern struct list_head huge_boot_pages[MAX_NUMNODES];
@@ -297,8 +297,8 @@ static inline unsigned long hugetlb_tota
 	return 0;
 }
 
-static inline struct address_space *hugetlb_page_mapping_lock_write(
-							struct page *hpage)
+static inline struct address_space *hugetlb_folio_mapping_lock_write(
+							struct folio *folio)
 {
 	return NULL;
 }
--- a/mm/hugetlb.c~mm-convert-hugetlb_page_mapping_lock_write-to-folio
+++ a/mm/hugetlb.c
@@ -2155,13 +2155,13 @@ static bool prep_compound_gigantic_folio
 /*
  * Find and lock address space (mapping) in write mode.
  *
- * Upon entry, the page is locked which means that page_mapping() is
+ * Upon entry, the folio is locked which means that folio_mapping() is
  * stable.  Due to locking order, we can only trylock_write.  If we can
  * not get the lock, simply return NULL to caller.
  */
-struct address_space *hugetlb_page_mapping_lock_write(struct page *hpage)
+struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio)
 {
-	struct address_space *mapping = page_mapping(hpage);
+	struct address_space *mapping = folio_mapping(folio);
 
 	if (!mapping)
 		return mapping;
--- a/mm/memory-failure.c~mm-convert-hugetlb_page_mapping_lock_write-to-folio
+++ a/mm/memory-failure.c
@@ -1624,7 +1624,7 @@ static bool hwpoison_user_mappings(struc
 		 * TTU_RMAP_LOCKED to indicate we have taken the lock
 		 * at this higher level.
 		 */
-		mapping = hugetlb_page_mapping_lock_write(hpage);
+		mapping = hugetlb_folio_mapping_lock_write(folio);
 		if (mapping) {
 			try_to_unmap(folio, ttu|TTU_RMAP_LOCKED);
 			i_mmap_unlock_write(mapping);
--- a/mm/migrate.c~mm-convert-hugetlb_page_mapping_lock_write-to-folio
+++ a/mm/migrate.c
@@ -1425,7 +1425,7 @@ static int unmap_and_move_huge_page(new_
 			 * semaphore in write mode here and set TTU_RMAP_LOCKED
 			 * to let lower levels know we have taken the lock.
 			 */
-			mapping = hugetlb_page_mapping_lock_write(&src->page);
+			mapping = hugetlb_folio_mapping_lock_write(src);
 			if (unlikely(!mapping))
 				goto unlock_put_anon;
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch
mm-always-initialise-folio-_deferred_list.patch
mm-remove-folio_prep_large_rmappable.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-free-up-pg_slab-fix.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch
sh-remove-use-of-pg_arch_1-on-individual-pages.patch
xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch
mm-make-page_ext_get-take-a-const-argument.patch
mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch
mm-make-is_free_buddy_page-take-a-const-argument.patch
mm-make-page_mapped-take-a-const-argument.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio-fix.patch
slub-remove-use-of-page-flags.patch
remove-references-to-page-flags-in-documentation.patch
proc-rewrite-stable_page_flags.patch
proc-rewrite-stable_page_flags-fix.patch
proc-rewrite-stable_page_flags-fix-2.patch
sparc-use-is_huge_zero_pmd.patch
mm-add-is_huge_zero_folio.patch
mm-add-pmd_folio.patch
mm-convert-migrate_vma_collect_pmd-to-use-a-folio.patch
mm-convert-huge_zero_page-to-huge_zero_folio.patch
mm-convert-do_huge_pmd_anonymous_page-to-huge_zero_folio.patch
dax-use-huge_zero_folio.patch
mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio.patch
mm-use-rwsem-assertion-macros-for-mmap_lock.patch
filemap-remove-__set_page_dirty.patch
mm-correct-page_mapped_in_vma-for-large-folios.patch
mm-remove-vma_address.patch
mm-rename-vma_pgoff_address-back-to-vma_address.patch
khugepaged-inline-hpage_collapse_alloc_folio.patch
khugepaged-convert-alloc_charge_hpage-to-alloc_charge_folio.patch
khugepaged-remove-hpage-from-collapse_huge_page.patch
khugepaged-pass-a-folio-to-__collapse_huge_page_copy.patch
khugepaged-remove-hpage-from-collapse_file.patch
khugepaged-use-a-folio-throughout-collapse_file.patch
khugepaged-use-a-folio-throughout-collapse_file-fix.patch
khugepaged-use-a-folio-throughout-hpage_collapse_scan_file.patch
proc-convert-clear_refs_pte_range-to-use-a-folio.patch
proc-convert-smaps_account-to-use-a-folio.patch
mm-remove-page_idle-and-page_young-wrappers.patch
mm-generate-page_idle_flag-definitions.patch
proc-convert-gather_stats-to-use-a-folio.patch
proc-convert-smaps_page_accumulate-to-use-a-folio.patch
proc-pass-a-folio-to-smaps_page_accumulate.patch
proc-convert-smaps_pmd_entry-to-use-a-folio.patch
mm-remove-struct-page-from-get_shadow_from_swap_cache.patch
hugetlb-convert-alloc_buddy_hugetlb_folio-to-use-a-folio.patch
mm-convert-pagecache_isize_extended-to-use-a-folio.patch
mm-free-non-hugetlb-large-folios-in-a-batch.patch
mm-combine-free_the_page-and-free_unref_page.patch
mm-inline-destroy_large_folio-into-__folio_put_large.patch
mm-combine-__folio_put_small-__folio_put_large-and-__folio_put.patch
mm-convert-free_zone_device_page-to-free_zone_device_folio.patch
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
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch

