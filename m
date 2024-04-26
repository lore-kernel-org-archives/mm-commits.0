Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DC4762C1
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103078; cv=none; b=aqZAlqFskUSJNfmbN5X960f95/10YPS/YBCBIGYO9a8qwUiPryiY5QHndGfTqwJPCC4AzGtNHYxPDO3h+14XeuxfC9Lm1auv6HlqRa50qpNAVVpKTu++Lw10LbrvrkOS1XPiRYlgEaSSF1hWRmDUtJuugWzdYiSLFx0mp18uhOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103078; c=relaxed/simple;
	bh=XdITy9X9O3YFkZq58kxtzWtHf5qSbztaSgbdQrNDQ1s=;
	h=Date:To:From:Subject:Message-Id; b=agTppKoU3laFME/qLKjV6N5P53eSqh0HY87ib87aoEbNBb41nyDKkc6CnoH5oGOZ8nvjaPCuEOzaxgEhREPkhY156kdKALXw4v30BtY6K1toPMhgilgjg4pXEviofsKw6TOu9F6FQk6/FS6N2mrymIiKAA6dfF/zbie45/i6NKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iFrZhDgQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iFrZhDgQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8788DC113CD;
	Fri, 26 Apr 2024 03:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103077;
	bh=XdITy9X9O3YFkZq58kxtzWtHf5qSbztaSgbdQrNDQ1s=;
	h=Date:To:From:Subject:From;
	b=iFrZhDgQmnBY3MvxQT7+ou/R2NAc7yrqCRLd9/8ThZMbGAQA5XO+djTY+a42DXdru
	 JEict739SRjTdmcpHRqbnF/skHF7RgCoaVNtT+kPX3hyyDscZnI5fwwldVMvUE8VXc
	 5B/gQuNnw5v+IrTXfXw1WZV6nhg9ZT/27VnHmNI4=
Date: Thu, 25 Apr 2024 20:44:36 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] khugepaged-use-a-folio-throughout-collapse_file-fix.patch removed from -mm tree
Message-Id: <20240426034437.8788DC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: khugepaged-use-a-folio-throughout-collapse_file-fix
has been removed from the -mm tree.  Its filename was
     khugepaged-use-a-folio-throughout-collapse_file-fix.patch

This patch was dropped because it was folded into khugepaged-use-a-folio-throughout-collapse_file.patch

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: khugepaged-use-a-folio-throughout-collapse_file-fix
Date: Sun, 7 Apr 2024 04:43:27 +0100

the unlikely() is embedded in IS_ERR() so no need to keep it here

Link: https://lkml.kernel.org/r/ZhIWX8K0E2tSyMSr@casper.infradead.org
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Reported-by: Vishal Moola <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~khugepaged-use-a-folio-throughout-collapse_file-fix
+++ a/mm/khugepaged.c
@@ -1865,7 +1865,7 @@ static int collapse_file(struct mm_struc
 				/* drain lru cache to help isolate_lru_page() */
 				lru_add_drain();
 				folio = filemap_lock_folio(mapping, index);
-				if (unlikely(folio == NULL)) {
+				if (IS_ERR(folio)) {
 					result = SCAN_FAIL;
 					goto xa_unlocked;
 				}
_

Patches currently in -mm which might be from willy@infradead.org are

mm-always-initialise-folio-_deferred_list.patch
mm-remove-folio_prep_large_rmappable.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch
sh-remove-use-of-pg_arch_1-on-individual-pages.patch
xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch
mm-make-page_ext_get-take-a-const-argument.patch
mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch
mm-make-is_free_buddy_page-take-a-const-argument.patch
mm-make-page_mapped-take-a-const-argument.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch
slub-remove-use-of-page-flags.patch
remove-references-to-page-flags-in-documentation.patch
proc-rewrite-stable_page_flags.patch
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
mm-remove-page_mapping.patch
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch
mm-simplify-thp_vma_allowable_order.patch

