Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53362BAE2
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101940; cv=none; b=A5ymGorrXQdEKTsX5RMIaoFiZSUwIFOpQF8OMU+Kf66DA5OBpiMIYQILS+CNQwfU5GNP3lIqQ1XGSf+lRepZ9WUww/JRKhk+9H3tapYrubY1AVudPv80D+KphQDQPOlpKcCvA0CV6JEhV2ZN0u84xsJSV5DQFSkI7qfKSDezKJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101940; c=relaxed/simple;
	bh=mrcufhBcPemIxWT5hcMddzYIFjn1lR8ndNFo/75RRxk=;
	h=Date:To:From:Subject:Message-Id; b=Zj6nFx/iIqfa4eJuuCxM63Xca6HUOmb7RsO5ylXSSX+4Vo5MG2Bk3n+XonKmomUXcfQJJ+pD+cVM9+ycu9jdPCBMPyjkPgBZ3J0pa+hxhV9bteMx9tFLr6G4ALNNyFfyofvCt243j1R4jnQXfckgTO2kRGC9rTkZhlo2FyAHf3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T0/sC9vB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T0/sC9vB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EDEC113CD;
	Fri, 26 Apr 2024 03:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101940;
	bh=mrcufhBcPemIxWT5hcMddzYIFjn1lR8ndNFo/75RRxk=;
	h=Date:To:From:Subject:From;
	b=T0/sC9vBk0rZM4TgyfdXyuwHkgpO84ukgmAvqYxVrVMUMlHJgfa3CsJiW0jQWxNDO
	 wR4qTegoz+4Z4yw3nYI9TpKGqS/wmc575f7F0KnLZ48DsD/5T44mrM8m4ffaqoF8nf
	 6qDLx3sTmoaG+YZrYYddXqtbe9bVu/GSUf6PUFmc=
Date: Thu, 25 Apr 2024 20:25:39 -0700
To: mm-commits@vger.kernel.org,dan.carpenter@linaro.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] proc-rewrite-stable_page_flags-fix.patch removed from -mm tree
Message-Id: <20240426032540.47EDEC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc-rewrite-stable_page_flags-fix
has been removed from the -mm tree.  Its filename was
     proc-rewrite-stable_page_flags-fix.patch

This patch was dropped because it was folded into proc-rewrite-stable_page_flags.patch

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: proc-rewrite-stable_page_flags-fix
Date: Wed, 3 Apr 2024 18:31:11 +0100

Dan reported I'd messed up some bits vs masks here:
https://lore.kernel.org/linux-fsdevel/1a6dc6a5-b5b6-494c-b94b-f6655da51bb9@moroto.mountain/T/#u

Link: https://lkml.kernel.org/r/20240403173112.1450721-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/proc/page.c~proc-rewrite-stable_page_flags-fix
+++ a/fs/proc/page.c
@@ -153,7 +153,7 @@ u64 stable_page_flags(const struct page
 	 * to make sure a given page is a thp, not a non-huge compound page.
 	 */
 	else if (folio_test_large(folio)) {
-		if ((k & PG_lru) || is_anon)
+		if ((k & (1 << PG_lru)) || is_anon)
 			u |= 1 << KPF_THP;
 		else if (is_huge_zero_page(&folio->page)) {
 			u |= 1 << KPF_ZERO_PAGE;
@@ -204,7 +204,7 @@ u64 stable_page_flags(const struct page
 	u |= kpf_copy_bit(k, KPF_MLOCKED,	PG_mlocked);
 
 #ifdef CONFIG_MEMORY_FAILURE
-	if (u & KPF_HUGE)
+	if (u & (1 << KPF_HUGE))
 		u |= kpf_copy_bit(k, KPF_HWPOISON,	PG_hwpoison);
 	else
 		u |= kpf_copy_bit(page->flags, KPF_HWPOISON,	PG_hwpoison);
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
mm-remove-page_mapping.patch
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch
mm-simplify-thp_vma_allowable_order.patch

