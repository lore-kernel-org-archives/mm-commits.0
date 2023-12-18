Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302EC1DDF8
	for <mm-commits@vger.kernel.org>; Mon, 18 Dec 2023 18:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xtg1IvU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77AFC433C8;
	Mon, 18 Dec 2023 18:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702925053;
	bh=qgHMQeR3/3ZAdb7pTRg1KmLJBUvTI7Jfhpmg7UO9jqE=;
	h=Date:To:From:Subject:From;
	b=xtg1IvU4ZZJ9uQCsoy64wnbIW2DcfDj7ukJpvG8e5723lKJiSEi65xcxAgI+XaO5m
	 NwxY7/f2mWUL+MOzGAyTBpNP29an0sQIP3RcEAyjLcSOYKr2vpzROcb3lGe3K+UzNI
	 AGtDMrPYv2nQO7zu6IvxEWvHZqm/Utvfx3WDIvMY=
Date: Mon, 18 Dec 2023 10:44:13 -0800
To: mm-commits@vger.kernel.org,hch@lst.de,axboe@kernel.dk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-reduce-stack-usage-in-do_mpage_readpage.patch added to mm-unstable branch
Message-Id: <20231218184413.A77AFC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: reduce stack usage in do_mpage_readpage
has been added to the -mm mm-unstable branch.  Its filename is
     fs-reduce-stack-usage-in-do_mpage_readpage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-reduce-stack-usage-in-do_mpage_readpage.patch

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
Subject: fs: reduce stack usage in do_mpage_readpage
Date: Fri, 15 Dec 2023 20:02:35 +0000

Some architectures support a very large PAGE_SIZE, so instead of the 8
pointers we see with a 4kB PAGE_SIZE, we can see 128 pointers with 64kB or
so many on Hexagon that it trips compiler warnings about exceeding stack
frame size.

All we're doing with this array is checking for block contiguity, which we
can as well do by remembering the address of the first block in the page
and checking this block is at the appropriate offset from that address.

Link: https://lkml.kernel.org/r/20231215200245.748418-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/mpage.c~fs-reduce-stack-usage-in-do_mpage_readpage
+++ a/fs/mpage.c
@@ -166,7 +166,7 @@ static struct bio *do_mpage_readpage(str
 	sector_t block_in_file;
 	sector_t last_block;
 	sector_t last_block_in_file;
-	sector_t blocks[MAX_BUF_PER_PAGE];
+	sector_t first_block;
 	unsigned page_block;
 	unsigned first_hole = blocks_per_page;
 	struct block_device *bdev = NULL;
@@ -205,6 +205,7 @@ static struct bio *do_mpage_readpage(str
 		unsigned map_offset = block_in_file - args->first_logical_block;
 		unsigned last = nblocks - map_offset;
 
+		first_block = map_bh->b_blocknr + map_offset;
 		for (relative_block = 0; ; relative_block++) {
 			if (relative_block == last) {
 				clear_buffer_mapped(map_bh);
@@ -212,8 +213,6 @@ static struct bio *do_mpage_readpage(str
 			}
 			if (page_block == blocks_per_page)
 				break;
-			blocks[page_block] = map_bh->b_blocknr + map_offset +
-						relative_block;
 			page_block++;
 			block_in_file++;
 		}
@@ -259,7 +258,9 @@ static struct bio *do_mpage_readpage(str
 			goto confused;		/* hole -> non-hole */
 
 		/* Contiguous blocks? */
-		if (page_block && blocks[page_block-1] != map_bh->b_blocknr-1)
+		if (!page_block)
+			first_block = map_bh->b_blocknr;
+		else if (first_block + page_block != map_bh->b_blocknr)
 			goto confused;
 		nblocks = map_bh->b_size >> blkbits;
 		for (relative_block = 0; ; relative_block++) {
@@ -268,7 +269,6 @@ static struct bio *do_mpage_readpage(str
 				break;
 			} else if (page_block == blocks_per_page)
 				break;
-			blocks[page_block] = map_bh->b_blocknr+relative_block;
 			page_block++;
 			block_in_file++;
 		}
@@ -289,7 +289,7 @@ static struct bio *do_mpage_readpage(str
 	/*
 	 * This folio will go to BIO.  Do we need to send this BIO off first?
 	 */
-	if (args->bio && (args->last_block_in_bio != blocks[0] - 1))
+	if (args->bio && (args->last_block_in_bio != first_block - 1))
 		args->bio = mpage_bio_submit_read(args->bio);
 
 alloc_new:
@@ -298,7 +298,7 @@ alloc_new:
 				      gfp);
 		if (args->bio == NULL)
 			goto confused;
-		args->bio->bi_iter.bi_sector = blocks[0] << (blkbits - 9);
+		args->bio->bi_iter.bi_sector = first_block << (blkbits - 9);
 	}
 
 	length = first_hole << blkbits;
@@ -313,7 +313,7 @@ alloc_new:
 	    (first_hole != blocks_per_page))
 		args->bio = mpage_bio_submit_read(args->bio);
 	else
-		args->last_block_in_bio = blocks[blocks_per_page - 1];
+		args->last_block_in_bio = first_block + blocks_per_page - 1;
 out:
 	return args->bio;
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-memory-failure-pass-the-folio-and-the-page-to-collect_procs.patch
mm-memory-failure-check-the-mapcount-of-the-precise-page.patch
mm-memory-failure-cast-index-to-loff_t-before-shifting-it.patch
mailmap-add-an-old-address-for-naoya-horiguchi.patch
buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch
mm-convert-ksm_might_need_to_copy-to-work-on-folios.patch
mm-convert-ksm_might_need_to_copy-to-work-on-folios-fix.patch
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
fs-remove-clean_page_buffers.patch
fs-convert-clean_buffers-to-take-a-folio.patch
fs-reduce-stack-usage-in-__mpage_writepage.patch
fs-reduce-stack-usage-in-do_mpage_readpage.patch
adfs-remove-writepage-implementation.patch
bfs-remove-writepage-implementation.patch
hfs-really-remove-hfs_writepage.patch
hfsplus-really-remove-hfsplus_writepage.patch
minix-remove-writepage-implementation.patch
ocfs2-remove-writepage-implementation.patch
sysv-remove-writepage-implementation.patch
ufs-remove-writepage-implementation.patch
fs-convert-block_write_full_page-to-block_write_full_folio.patch
fs-remove-the-bh_end_io-argument-from-__block_write_full_folio.patch

