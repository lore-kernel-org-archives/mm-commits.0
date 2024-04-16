Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05211CF8A
	for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2024 20:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713297621; cv=none; b=LtnSPRdf3vWEolVYLp2fHc5YhYUbGAy+sgiOtZMNYS14+ZdYN84iruHXWy8Ogt/1x18o3TJ9DZ9ihjcqdwqUU9y9AgWCpGLNX/iPfyjAY7GuQPDVwgtRSnnIifKcNl0Bo1/LcJDQugHWyKepo1qhUWumlEwEYFhVbC4nivqldeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713297621; c=relaxed/simple;
	bh=lsbKSRdHNrOcsC6+XFUZVS90NniwVgoMOVBtMNRIwaA=;
	h=Date:To:From:Subject:Message-Id; b=QM0GoM1RtRG9W1KnJC7QDD1qKvOnsAHRryoQGY2pzJhkrvy+0j0YBspGK/nsjsj2IqlWFxb9evigxCHf8fBeywx6Fv00IFDnCfN2cTtVuh9rxP+wlvtB9Pd7iY4j3g04wYTUrkaInEkpo/eb2/+dt8jgxTclk/3y7cgmnEV1Gsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ip6oPunC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ip6oPunC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36159C113CE;
	Tue, 16 Apr 2024 20:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713297620;
	bh=lsbKSRdHNrOcsC6+XFUZVS90NniwVgoMOVBtMNRIwaA=;
	h=Date:To:From:Subject:From;
	b=ip6oPunCv/n4+X+0pBGgBLCpoXQpwsc71gabJbM6UzEV6ATl0sPw78CYfPo+Z7SWx
	 qYzKcopB1nH9nF29j4IFEcbWbkoLYfm4NR5k4145ALbizb87GTKSXBj61rR2FewwiL
	 vtLz39J8Og7G+SiL+3CUxoUXLjwAwItLBEONWEAI=
Date: Tue, 16 Apr 2024 13:00:19 -0700
To: mm-commits@vger.kernel.org,p.raghav@samsung.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-add-kernel-doc-for-block_dirty_folio.patch added to mm-unstable branch
Message-Id: <20240416200020.36159C113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: buffer: add kernel-doc for block_dirty_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-add-kernel-doc-for-block_dirty_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-add-kernel-doc-for-block_dirty_folio.patch

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
Subject: buffer: add kernel-doc for block_dirty_folio()
Date: Tue, 16 Apr 2024 04:17:46 +0100

Turn the excellent documentation for this function into kernel-doc. 
Replace 'page' with 'folio' and make a few other minor updates.

Link: https://lkml.kernel.org/r/20240416031754.4076917-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   49 ++++++++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

--- a/fs/buffer.c~buffer-add-kernel-doc-for-block_dirty_folio
+++ a/fs/buffer.c
@@ -687,30 +687,37 @@ void mark_buffer_dirty_inode(struct buff
 }
 EXPORT_SYMBOL(mark_buffer_dirty_inode);
 
-/*
- * Add a page to the dirty page list.
+/**
+ * block_dirty_folio - Mark a folio as dirty.
+ * @mapping: The address space containing this folio.
+ * @folio: The folio to mark dirty.
  *
- * It is a sad fact of life that this function is called from several places
- * deeply under spinlocking.  It may not sleep.
+ * Filesystems which use buffer_heads can use this function as their
+ * ->dirty_folio implementation.  Some filesystems need to do a little
+ * work before calling this function.  Filesystems which do not use
+ * buffer_heads should call filemap_dirty_folio() instead.
  *
- * If the page has buffers, the uptodate buffers are set dirty, to preserve
- * dirty-state coherency between the page and the buffers.  It the page does
- * not have buffers then when they are later attached they will all be set
- * dirty.
- *
- * The buffers are dirtied before the page is dirtied.  There's a small race
- * window in which a writepage caller may see the page cleanness but not the
- * buffer dirtiness.  That's fine.  If this code were to set the page dirty
- * before the buffers, a concurrent writepage caller could clear the page dirty
- * bit, see a bunch of clean buffers and we'd end up with dirty buffers/clean
- * page on the dirty page list.
- *
- * We use i_private_lock to lock against try_to_free_buffers while using the
- * page's buffer list.  Also use this to protect against clean buffers being
- * added to the page after it was set dirty.
+ * If the folio has buffers, the uptodate buffers are set dirty, to
+ * preserve dirty-state coherency between the folio and the buffers.
+ * Buffers added to a dirty folio are created dirty.
  *
- * FIXME: may need to call ->reservepage here as well.  That's rather up to the
- * address_space though.
+ * The buffers are dirtied before the folio is dirtied.  There's a small
+ * race window in which writeback may see the folio cleanness but not the
+ * buffer dirtiness.  That's fine.  If this code were to set the folio
+ * dirty before the buffers, writeback could clear the folio dirty flag,
+ * see a bunch of clean buffers and we'd end up with dirty buffers/clean
+ * folio on the dirty folio list.
+ *
+ * We use i_private_lock to lock against try_to_free_buffers() while
+ * using the folio's buffer list.  This also prevents clean buffers
+ * being added to the folio after it was set dirty.
+ *
+ * Context: May only be called from process context.  Does not sleep.
+ * Caller must ensure that @folio cannot be truncated during this call,
+ * typically by holding the folio lock or having a page in the folio
+ * mapped and holding the page table lock.
+ *
+ * Return: True if the folio was dirtied; false if it was already dirtied.
  */
 bool block_dirty_folio(struct address_space *mapping, struct folio *folio)
 {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch
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

