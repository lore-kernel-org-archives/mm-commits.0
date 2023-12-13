Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7128183A
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 23:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="odAQF9jK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E4CC433C8;
	Wed, 13 Dec 2023 23:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702509129;
	bh=BQl54S0QK5PnnPgo1+8TbZOSmG4hPyc/IPSdYmFTZOc=;
	h=Date:To:From:Subject:From;
	b=odAQF9jK4RbB0z7inFC6QA1aN4ulfh9KAj0KssNvf1g8MbqsopjUseIfLgl2F6mVP
	 6WX8Fw5HoBGPeJQqWJyz13RKp+hqH/DW+dPt+sKirxiYxMP5yyHyQ50MY7xWm/5UPC
	 gHTA61WgM2o77s4hM3hyMcHGMMlpxqcWoihG/Z1U=
Date: Wed, 13 Dec 2023 15:12:09 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-swap_page_sector-to-swap_folio_sector.patch added to mm-unstable branch
Message-Id: <20231213231209.A8E4CC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert swap_page_sector() to swap_folio_sector()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-swap_page_sector-to-swap_folio_sector.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-swap_page_sector-to-swap_folio_sector.patch

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
Subject: mm: convert swap_page_sector() to swap_folio_sector()
Date: Wed, 13 Dec 2023 21:58:38 +0000

All callers have a folio, so pass it in.  Saves a couple of calls to
compound_head().

Link: https://lkml.kernel.org/r/20231213215842.671461-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 mm/page_io.c         |    8 ++++----
 mm/swapfile.c        |    6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/swap.h~mm-convert-swap_page_sector-to-swap_folio_sector
+++ a/include/linux/swap.h
@@ -493,7 +493,7 @@ struct backing_dev_info;
 extern int init_swap_address_space(unsigned int type, unsigned long nr_pages);
 extern void exit_swap_address_space(unsigned int type);
 extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
-sector_t swap_page_sector(struct page *page);
+sector_t swap_folio_sector(struct folio *folio);
 
 static inline void put_swap_device(struct swap_info_struct *si)
 {
--- a/mm/page_io.c~mm-convert-swap_page_sector-to-swap_folio_sector
+++ a/mm/page_io.c
@@ -340,7 +340,7 @@ static void swap_writepage_bdev_sync(str
 
 	bio_init(&bio, sis->bdev, &bv, 1,
 		 REQ_OP_WRITE | REQ_SWAP | wbc_to_write_flags(wbc));
-	bio.bi_iter.bi_sector = swap_page_sector(&folio->page);
+	bio.bi_iter.bi_sector = swap_folio_sector(folio);
 	bio_add_folio_nofail(&bio, folio, folio_size(folio), 0);
 
 	bio_associate_blkg_from_page(&bio, folio);
@@ -361,7 +361,7 @@ static void swap_writepage_bdev_async(st
 	bio = bio_alloc(sis->bdev, 1,
 			REQ_OP_WRITE | REQ_SWAP | wbc_to_write_flags(wbc),
 			GFP_NOIO);
-	bio->bi_iter.bi_sector = swap_page_sector(&folio->page);
+	bio->bi_iter.bi_sector = swap_folio_sector(folio);
 	bio->bi_end_io = end_swap_bio_write;
 	bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
 
@@ -467,7 +467,7 @@ static void swap_readpage_bdev_sync(stru
 	struct bio bio;
 
 	bio_init(&bio, sis->bdev, &bv, 1, REQ_OP_READ);
-	bio.bi_iter.bi_sector = swap_page_sector(&folio->page);
+	bio.bi_iter.bi_sector = swap_folio_sector(folio);
 	bio_add_folio_nofail(&bio, folio, folio_size(folio), 0);
 	/*
 	 * Keep this task valid during swap readpage because the oom killer may
@@ -486,7 +486,7 @@ static void swap_readpage_bdev_async(str
 	struct bio *bio;
 
 	bio = bio_alloc(sis->bdev, 1, REQ_OP_READ, GFP_KERNEL);
-	bio->bi_iter.bi_sector = swap_page_sector(&folio->page);
+	bio->bi_iter.bi_sector = swap_folio_sector(folio);
 	bio->bi_end_io = end_swap_bio_read;
 	bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
 	count_vm_event(PSWPIN);
--- a/mm/swapfile.c~mm-convert-swap_page_sector-to-swap_folio_sector
+++ a/mm/swapfile.c
@@ -227,14 +227,14 @@ offset_to_swap_extent(struct swap_info_s
 	BUG();
 }
 
-sector_t swap_page_sector(struct page *page)
+sector_t swap_folio_sector(struct folio *folio)
 {
-	struct swap_info_struct *sis = page_swap_info(page);
+	struct swap_info_struct *sis = swp_swap_info(folio->swap);
 	struct swap_extent *se;
 	sector_t sector;
 	pgoff_t offset;
 
-	offset = __page_file_index(page);
+	offset = swp_offset(folio->swap);
 	se = offset_to_swap_extent(sis, offset);
 	sector = se->start_block + (offset - se->start_page);
 	return sector << (PAGE_SHIFT - 9);
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch
mm-convert-ksm_might_need_to_copy-to-work-on-folios.patch
mm-remove-pageanonexclusive-assertions-in-unuse_pte.patch
mm-convert-unuse_pte-to-use-a-folio-throughout.patch
mm-remove-some-calls-to-page_add_new_anon_rmap.patch
mm-remove-stale-example-from-comment.patch
mm-remove-references-to-page_add_new_anon_rmap-in-comments.patch
mm-convert-migrate_vma_insert_page-to-use-a-folio.patch
mm-convert-collapse_huge_page-to-use-a-folio.patch
mm-remove-page_add_new_anon_rmap-and-lru_cache_add_inactive_or_unevictable.patch
mm-return-the-folio-from-__read_swap_cache_async.patch
mm-pass-a-folio-to-__swap_writepage.patch
mm-pass-a-folio-to-swap_writepage_fs.patch
mm-pass-a-folio-to-swap_writepage_bdev_sync.patch
mm-pass-a-folio-to-swap_writepage_bdev_async.patch
mm-pass-a-folio-to-swap_readpage_fs.patch
mm-pass-a-folio-to-swap_readpage_bdev_sync.patch
mm-pass-a-folio-to-swap_readpage_bdev_async.patch
mm-convert-swap_page_sector-to-swap_folio_sector.patch
mm-convert-swap_readpage-to-swap_read_folio.patch
mm-remove-page_swap_info.patch
mm-return-a-folio-from-read_swap_cache_async.patch
mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio.patch

