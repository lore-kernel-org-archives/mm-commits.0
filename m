Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14473134B7
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ly47G+Az"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D113EC433C9;
	Fri, 29 Dec 2023 20:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880012;
	bh=lXaIBjzS3vyjDumvzge4skKYhLtTzwIkv7iMXF3uTok=;
	h=Date:To:From:Subject:From;
	b=ly47G+Az6mVdkrpv272cQH8MiFxSlzk7HjiCKIxrDskPo8X22GvLLiUIDS9ZdfVPb
	 tfnajMofzq91EN9dPU59qnu9Xudd+4IZKth/CRtqLi94czRSuT2rn/1PjpSzPmTww4
	 vuA6zEIK/hLdYGI94y79KJrQz7IfWbGkcnXfhKbA=
Date: Fri, 29 Dec 2023 12:00:12 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-swap_page_sector-to-swap_folio_sector.patch removed from -mm tree
Message-Id: <20231229200012.D113EC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert swap_page_sector() to swap_folio_sector()
has been removed from the -mm tree.  Its filename was
     mm-convert-swap_page_sector-to-swap_folio_sector.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -334,7 +334,7 @@ static void swap_writepage_bdev_sync(str
 
 	bio_init(&bio, sis->bdev, &bv, 1,
 		 REQ_OP_WRITE | REQ_SWAP | wbc_to_write_flags(wbc));
-	bio.bi_iter.bi_sector = swap_page_sector(&folio->page);
+	bio.bi_iter.bi_sector = swap_folio_sector(folio);
 	bio_add_folio_nofail(&bio, folio, folio_size(folio), 0);
 
 	bio_associate_blkg_from_page(&bio, folio);
@@ -355,7 +355,7 @@ static void swap_writepage_bdev_async(st
 	bio = bio_alloc(sis->bdev, 1,
 			REQ_OP_WRITE | REQ_SWAP | wbc_to_write_flags(wbc),
 			GFP_NOIO);
-	bio->bi_iter.bi_sector = swap_page_sector(&folio->page);
+	bio->bi_iter.bi_sector = swap_folio_sector(folio);
 	bio->bi_end_io = end_swap_bio_write;
 	bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
 
@@ -461,7 +461,7 @@ static void swap_readpage_bdev_sync(stru
 	struct bio bio;
 
 	bio_init(&bio, sis->bdev, &bv, 1, REQ_OP_READ);
-	bio.bi_iter.bi_sector = swap_page_sector(&folio->page);
+	bio.bi_iter.bi_sector = swap_folio_sector(folio);
 	bio_add_folio_nofail(&bio, folio, folio_size(folio), 0);
 	/*
 	 * Keep this task valid during swap readpage because the oom killer may
@@ -480,7 +480,7 @@ static void swap_readpage_bdev_async(str
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

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

