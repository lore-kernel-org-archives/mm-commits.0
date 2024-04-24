Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB8E13C9DE
	for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2024 21:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713994164; cv=none; b=lYzXnqjub2Mf7I1ZLy0MTH89HysRIkR3ZDyzizf0UowlmsP9yxJLRuPwU8IPxmz1lwGy383Wl62pU/Apk9MFvGgw9hKf2B+iUmTGkxbzgFdGkjzDI0KtT2foaIvJcZVIZrmo/Rw79MAae7Dl8N1m0SK6QPJ7q7BQRi0YmqpGtbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713994164; c=relaxed/simple;
	bh=nTNWK7kRbzlpfD/2q8EHXFU8dAOHrO4sLek0c0/man0=;
	h=Date:To:From:Subject:Message-Id; b=aQQgCPdv6EI0YuctZGsvmGFQ3DoEUIMNYMos4Liq91q/bedJWLN8DQYkN9j9szwCk03iXQaVHeCNOKyzErAFkkogCzG5PsFatoqD0iY9aTANuW5Kk4UwxVfGXcP+QZ4nldFAe6h3qtj7peNAouRt1VKWHhZTP32DzNWYgnv+PeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LvACNHi4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LvACNHi4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB6FC113CD;
	Wed, 24 Apr 2024 21:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713994164;
	bh=nTNWK7kRbzlpfD/2q8EHXFU8dAOHrO4sLek0c0/man0=;
	h=Date:To:From:Subject:From;
	b=LvACNHi4KhE+iPVfUPVmgqXuNjqgxNh0R/y5cx9Zvt79beatQddmn382+rWoNV1kW
	 ue83M2xS6A7inF1bcIeFp0pGuBrje4aLgOyNsqLNB61YNjYWVeDaDwVJm0WCh5FX1c
	 AxCGIVWKOrBG73+qvAuWBb1lgXnVUz6mGDTU53lA=
Date: Wed, 24 Apr 2024 14:29:23 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,ebiggers@google.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20240424212924.4EB6FC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: f2fs: convert f2fs_clear_page_cache_dirty_tag to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio.patch

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
Subject: f2fs: convert f2fs_clear_page_cache_dirty_tag to use a folio
Date: Tue, 23 Apr 2024 23:55:33 +0100

Removes uses of page_mapping() and page_index().

Link: https://lkml.kernel.org/r/20240423225552.4113447-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/f2fs/data.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/f2fs/data.c~f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio
+++ a/fs/f2fs/data.c
@@ -4082,11 +4082,12 @@ const struct address_space_operations f2
 
 void f2fs_clear_page_cache_dirty_tag(struct page *page)
 {
-	struct address_space *mapping = page_mapping(page);
+	struct folio *folio = page_folio(page);
+	struct address_space *mapping = folio->mapping;
 	unsigned long flags;
 
 	xa_lock_irqsave(&mapping->i_pages, flags);
-	__xa_clear_mark(&mapping->i_pages, page_index(page),
+	__xa_clear_mark(&mapping->i_pages, folio->index,
 						PAGECACHE_TAG_DIRTY);
 	xa_unlock_irqrestore(&mapping->i_pages, flags);
 }
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

