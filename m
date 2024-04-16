Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160ED1CF8A
	for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2024 20:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713297624; cv=none; b=T30eBrjys1F0NeSapVshvW9egXpvXvPVsyTKA60MYH3T3NJ+7x4m6RaokpYDh818m+VYRy/yDfCiJ5X0EODQ47naJKv8uc4/4j7ELkDFSuEhZWHV8imPIjeqZ4T/eoV1GAOVLTENc3CAsOhZ5k4HzBIWM97gZiA/Jk0rfIuzfTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713297624; c=relaxed/simple;
	bh=U386HPPU4Fv6gpKBn1x0bWGug+4PFWW4+1+7U/h9Q4w=;
	h=Date:To:From:Subject:Message-Id; b=GbMPi5/fbibrP6AJsQJgWDazajpzvadCtiJgoGYZwq5iZ4wSkLvlBCSYIyvxcmw3Uudi218T3WaAkna97NmdZ7p/18pIDjAIpNglNy9ECRDtJQwvnWmLTLZ6NpIEUt6uOCPH0YIrKWF04C8MMVcdGYttVZvnEOg6YjVckyBAFnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FkcPWJrs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FkcPWJrs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB991C113CE;
	Tue, 16 Apr 2024 20:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713297623;
	bh=U386HPPU4Fv6gpKBn1x0bWGug+4PFWW4+1+7U/h9Q4w=;
	h=Date:To:From:Subject:From;
	b=FkcPWJrs/XhYgrsTyOU1E+6526/VGSvpRRJFpkrLpDbYRSAuYiCkzboJ3rWwoXg1K
	 RwK04d+9B9C/fslJPKAEP/GQySZk/ouFTu9aqgNit5sO+SUSYGol1PdlRtcAQVJGWm
	 jL7AplW6VHQRvsXVbKqfbLV0lIJsy8x4QTH2XZKQ=
Date: Tue, 16 Apr 2024 13:00:23 -0700
To: mm-commits@vger.kernel.org,p.raghav@samsung.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch added to mm-unstable branch
Message-Id: <20240416200023.DB991C113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: buffer: fix __bread and __bread_gfp kernel-doc
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch

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
Subject: buffer: fix __bread and __bread_gfp kernel-doc
Date: Tue, 16 Apr 2024 04:17:48 +0100

The extra indentation confused the kernel-doc parser, so remove it.  Fix
some other wording while I'm here, and advise the user they need to call
brelse() on this buffer.

__bread_gfp() isn't used directly by filesystems, but the other wrappers
for it don't have documentation, so document it accordingly.

Link: https://lkml.kernel.org/r/20240416031754.4076917-5-willy@infradead.org
Co-developed-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   33 +++++++++++++++++++++------------
 include/linux/buffer_head.h |   22 +++++++++++++---------
 2 files changed, 34 insertions(+), 21 deletions(-)

--- a/fs/buffer.c~buffer-fix-__bread-and-__bread_gfp-kernel-doc
+++ a/fs/buffer.c
@@ -1453,20 +1453,29 @@ void __breadahead(struct block_device *b
 EXPORT_SYMBOL(__breadahead);
 
 /**
- *  __bread_gfp() - reads a specified block and returns the bh
- *  @bdev: the block_device to read from
- *  @block: number of block
- *  @size: size (in bytes) to read
- *  @gfp: page allocation flag
+ * __bread_gfp() - Read a block.
+ * @bdev: The block device to read from.
+ * @block: Block number in units of block size.
+ * @size: The block size of this device in bytes.
+ * @gfp: Not page allocation flags; see below.
  *
- *  Reads a specified block, and returns buffer head that contains it.
- *  The page cache can be allocated from non-movable area
- *  not to prevent page migration if you set gfp to zero.
- *  It returns NULL if the block was unreadable.
+ * You are not expected to call this function.  You should use one of
+ * sb_bread(), sb_bread_unmovable() or __bread().
+ *
+ * Read a specified block, and return the buffer head that refers to it.
+ * If @gfp is 0, the memory will be allocated using the block device's
+ * default GFP flags.  If @gfp is __GFP_MOVABLE, the memory may be
+ * allocated from a movable area.  Do not pass in a complete set of
+ * GFP flags.
+ *
+ * The returned buffer head has its refcount increased.  The caller should
+ * call brelse() when it has finished with the buffer.
+ *
+ * Context: May sleep waiting for I/O.
+ * Return: NULL if the block was unreadable.
  */
-struct buffer_head *
-__bread_gfp(struct block_device *bdev, sector_t block,
-		   unsigned size, gfp_t gfp)
+struct buffer_head *__bread_gfp(struct block_device *bdev, sector_t block,
+		unsigned size, gfp_t gfp)
 {
 	struct buffer_head *bh;
 
--- a/include/linux/buffer_head.h~buffer-fix-__bread-and-__bread_gfp-kernel-doc
+++ a/include/linux/buffer_head.h
@@ -437,17 +437,21 @@ static inline void bh_readahead_batch(in
 }
 
 /**
- *  __bread() - reads a specified block and returns the bh
- *  @bdev: the block_device to read from
- *  @block: number of block
- *  @size: size (in bytes) to read
+ * __bread() - Read a block.
+ * @bdev: The block device to read from.
+ * @block: Block number in units of block size.
+ * @size: The block size of this device in bytes.
  *
- *  Reads a specified block, and returns buffer head that contains it.
- *  The page cache is allocated from movable area so that it can be migrated.
- *  It returns NULL if the block was unreadable.
+ * Read a specified block, and return the buffer head that refers
+ * to it.  The memory is allocated from the movable area so that it can
+ * be migrated.  The returned buffer head has its refcount increased.
+ * The caller should call brelse() when it has finished with the buffer.
+ *
+ * Context: May sleep waiting for I/O.
+ * Return: NULL if the block was unreadable.
  */
-static inline struct buffer_head *
-__bread(struct block_device *bdev, sector_t block, unsigned size)
+static inline struct buffer_head *__bread(struct block_device *bdev,
+		sector_t block, unsigned size)
 {
 	return __bread_gfp(bdev, block, size, __GFP_MOVABLE);
 }
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

