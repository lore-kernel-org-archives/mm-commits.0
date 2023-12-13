Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382378183A
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 23:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GXAA31qz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F185FC433C8;
	Wed, 13 Dec 2023 23:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702509123;
	bh=GcwUufmJHgF8CPMq/VPO2c+xA6RtocjTAlldjOcaiNI=;
	h=Date:To:From:Subject:From;
	b=GXAA31qzSE4GFRQjYqrBgdRSvoCHygzbhnjR4JselFC+Y9nBpLv/kPnzsvwHD5USx
	 ERUAQcffFnjxyPggt8+j0PQsQB1V6DQVKorvp/qlbeHwWBcOiU0wco2v/FeJGLYrJR
	 H9HGpwGMOhVf3i04peSjEvMtggnQRocSWNEc8nHA=
Date: Wed, 13 Dec 2023 15:12:02 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pass-a-folio-to-swap_writepage_bdev_async.patch added to mm-unstable branch
Message-Id: <20231213231202.F185FC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: pass a folio to swap_writepage_bdev_async()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pass-a-folio-to-swap_writepage_bdev_async.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pass-a-folio-to-swap_writepage_bdev_async.patch

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
Subject: mm: pass a folio to swap_writepage_bdev_async()
Date: Wed, 13 Dec 2023 21:58:34 +0000

Saves a call to compound_head().

Link: https://lkml.kernel.org/r/20231213215842.671461-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/page_io.c~mm-pass-a-folio-to-swap_writepage_bdev_async
+++ a/mm/page_io.c
@@ -353,18 +353,17 @@ static void swap_writepage_bdev_sync(str
 	__end_swap_bio_write(&bio);
 }
 
-static void swap_writepage_bdev_async(struct page *page,
+static void swap_writepage_bdev_async(struct folio *folio,
 		struct writeback_control *wbc, struct swap_info_struct *sis)
 {
 	struct bio *bio;
-	struct folio *folio = page_folio(page);
 
 	bio = bio_alloc(sis->bdev, 1,
 			REQ_OP_WRITE | REQ_SWAP | wbc_to_write_flags(wbc),
 			GFP_NOIO);
-	bio->bi_iter.bi_sector = swap_page_sector(page);
+	bio->bi_iter.bi_sector = swap_page_sector(&folio->page);
 	bio->bi_end_io = end_swap_bio_write;
-	__bio_add_page(bio, page, thp_size(page), 0);
+	bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
 
 	bio_associate_blkg_from_page(bio, folio);
 	count_swpout_vm_event(folio);
@@ -388,7 +387,7 @@ void __swap_writepage(struct folio *foli
 	else if (sis->flags & SWP_SYNCHRONOUS_IO)
 		swap_writepage_bdev_sync(folio, wbc, sis);
 	else
-		swap_writepage_bdev_async(&folio->page, wbc, sis);
+		swap_writepage_bdev_async(folio, wbc, sis);
 }
 
 void swap_write_unplug(struct swap_iocb *sio)
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

