Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271A68183A
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 23:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DYAawHMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B47C433C7;
	Wed, 13 Dec 2023 23:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702509132;
	bh=gcpAoNG0lZ4D6mbc3cMhqUrIycuRSC1RmZS5/T03IeY=;
	h=Date:To:From:Subject:From;
	b=DYAawHMWZYghUf1+VQ96PvD8Pu4JP/Mw/oBdeFKE8i2rd4NDPFhJM6r1RA5+Atkmw
	 MmpigMxEfCg1sk6Z11rag7lN9bnQwUx0m3rDpYn5Kz2t/ad/ijakP5VeYafOVGS5px
	 Rinrx2CsBcoHWR+J37hpu6W6x0W9+7nS0sydt59c=
Date: Wed, 13 Dec 2023 15:12:11 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-swap_readpage-to-swap_read_folio.patch added to mm-unstable branch
Message-Id: <20231213231211.E4B47C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert swap_readpage() to swap_read_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-swap_readpage-to-swap_read_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-swap_readpage-to-swap_read_folio.patch

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
Subject: mm: convert swap_readpage() to swap_read_folio()
Date: Wed, 13 Dec 2023 21:58:39 +0000

All callers have a folio, so pass it in, saving two calls to
compound_head().

Link: https://lkml.kernel.org/r/20231213215842.671461-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c     |    4 ++--
 mm/page_io.c    |   18 +++++++++---------
 mm/swap.h       |    5 +++--
 mm/swap_state.c |   12 ++++++------
 mm/swapfile.c   |    2 +-
 5 files changed, 21 insertions(+), 20 deletions(-)

--- a/mm/memory.c~mm-convert-swap_readpage-to-swap_read_folio
+++ a/mm/memory.c
@@ -3882,9 +3882,9 @@ vm_fault_t do_swap_page(struct vm_fault
 
 				folio_add_lru(folio);
 
-				/* To provide entry to swap_readpage() */
+				/* To provide entry to swap_read_folio() */
 				folio->swap = entry;
-				swap_readpage(page, true, NULL);
+				swap_read_folio(folio, true, NULL);
 				folio->private = NULL;
 			}
 		} else {
--- a/mm/page_io.c~mm-convert-swap_readpage-to-swap_read_folio
+++ a/mm/page_io.c
@@ -426,7 +426,7 @@ static void sio_read_complete(struct kio
 	mempool_free(sio, sio_pool);
 }
 
-static void swap_readpage_fs(struct folio *folio, struct swap_iocb **plug)
+static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
 {
 	struct swap_info_struct *sis = swp_swap_info(folio->swap);
 	struct swap_iocb *sio = NULL;
@@ -460,7 +460,7 @@ static void swap_readpage_fs(struct foli
 		*plug = sio;
 }
 
-static void swap_readpage_bdev_sync(struct folio *folio,
+static void swap_read_folio_bdev_sync(struct folio *folio,
 		struct swap_info_struct *sis)
 {
 	struct bio_vec bv;
@@ -480,7 +480,7 @@ static void swap_readpage_bdev_sync(stru
 	put_task_struct(current);
 }
 
-static void swap_readpage_bdev_async(struct folio *folio,
+static void swap_read_folio_bdev_async(struct folio *folio,
 		struct swap_info_struct *sis)
 {
 	struct bio *bio;
@@ -493,10 +493,10 @@ static void swap_readpage_bdev_async(str
 	submit_bio(bio);
 }
 
-void swap_readpage(struct page *page, bool synchronous, struct swap_iocb **plug)
+void swap_read_folio(struct folio *folio, bool synchronous,
+		struct swap_iocb **plug)
 {
-	struct folio *folio = page_folio(page);
-	struct swap_info_struct *sis = page_swap_info(page);
+	struct swap_info_struct *sis = swp_swap_info(folio->swap);
 	bool workingset = folio_test_workingset(folio);
 	unsigned long pflags;
 	bool in_thrashing;
@@ -520,11 +520,11 @@ void swap_readpage(struct page *page, bo
 		folio_mark_uptodate(folio);
 		folio_unlock(folio);
 	} else if (data_race(sis->flags & SWP_FS_OPS)) {
-		swap_readpage_fs(folio, plug);
+		swap_read_folio_fs(folio, plug);
 	} else if (synchronous || (sis->flags & SWP_SYNCHRONOUS_IO)) {
-		swap_readpage_bdev_sync(folio, sis);
+		swap_read_folio_bdev_sync(folio, sis);
 	} else {
-		swap_readpage_bdev_async(folio, sis);
+		swap_read_folio_bdev_async(folio, sis);
 	}
 
 	if (workingset) {
--- a/mm/swapfile.c~mm-convert-swap_readpage-to-swap_read_folio
+++ a/mm/swapfile.c
@@ -2225,7 +2225,7 @@ EXPORT_SYMBOL_GPL(add_swap_extent);
 /*
  * A `swap extent' is a simple thing which maps a contiguous range of pages
  * onto a contiguous range of disk blocks.  A rbtree of swap extents is
- * built at swapon time and is then used at swap_writepage/swap_readpage
+ * built at swapon time and is then used at swap_writepage/swap_read_folio
  * time for locating where on disk a page belongs.
  *
  * If the swapfile is an S_ISBLK block device, a single extent is installed.
--- a/mm/swap.h~mm-convert-swap_readpage-to-swap_read_folio
+++ a/mm/swap.h
@@ -10,7 +10,8 @@ struct mempolicy;
 /* linux/mm/page_io.c */
 int sio_pool_init(void);
 struct swap_iocb;
-void swap_readpage(struct page *page, bool do_poll, struct swap_iocb **plug);
+void swap_read_folio(struct folio *folio, bool do_poll,
+		struct swap_iocb **plug);
 void __swap_read_unplug(struct swap_iocb *plug);
 static inline void swap_read_unplug(struct swap_iocb *plug)
 {
@@ -63,7 +64,7 @@ static inline unsigned int folio_swap_fl
 }
 #else /* CONFIG_SWAP */
 struct swap_iocb;
-static inline void swap_readpage(struct page *page, bool do_poll,
+static inline void swap_read_folio(struct folio *folio, bool do_poll,
 		struct swap_iocb **plug)
 {
 }
--- a/mm/swap_state.c~mm-convert-swap_readpage-to-swap_read_folio
+++ a/mm/swap_state.c
@@ -530,7 +530,7 @@ fail_put_swap:
  * the swap entry is no longer in use.
  *
  * get/put_swap_device() aren't needed to call this function, because
- * __read_swap_cache_async() call them and swap_readpage() holds the
+ * __read_swap_cache_async() call them and swap_read_folio() holds the
  * swap cache folio lock.
  */
 struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
@@ -548,7 +548,7 @@ struct page *read_swap_cache_async(swp_e
 	mpol_cond_put(mpol);
 
 	if (page_allocated)
-		swap_readpage(&folio->page, false, plug);
+		swap_read_folio(folio, false, plug);
 	return folio_file_page(folio, swp_offset(entry));
 }
 
@@ -665,7 +665,7 @@ struct page *swap_cluster_readahead(swp_
 		if (!folio)
 			continue;
 		if (page_allocated) {
-			swap_readpage(&folio->page, false, &splug);
+			swap_read_folio(folio, false, &splug);
 			if (offset != entry_offset) {
 				folio_set_readahead(folio);
 				count_vm_event(SWAP_RA);
@@ -681,7 +681,7 @@ skip:
 	folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
 					&page_allocated, false);
 	if (unlikely(page_allocated))
-		swap_readpage(&folio->page, false, NULL);
+		swap_read_folio(folio, false, NULL);
 	zswap_folio_swapin(folio);
 	return folio_file_page(folio, swp_offset(entry));
 }
@@ -839,7 +839,7 @@ static struct page *swap_vma_readahead(s
 		if (!folio)
 			continue;
 		if (page_allocated) {
-			swap_readpage(&folio->page, false, &splug);
+			swap_read_folio(folio, false, &splug);
 			if (i != ra_info.offset) {
 				folio_set_readahead(folio);
 				count_vm_event(SWAP_RA);
@@ -857,7 +857,7 @@ skip:
 	folio = __read_swap_cache_async(targ_entry, gfp_mask, mpol, targ_ilx,
 					&page_allocated, false);
 	if (unlikely(page_allocated))
-		swap_readpage(&folio->page, false, NULL);
+		swap_read_folio(folio, false, NULL);
 	zswap_folio_swapin(folio);
 	return folio_file_page(folio, swp_offset(entry));
 }
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

