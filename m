Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23F9134D3
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PTnH1Epb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E196C433C8;
	Fri, 29 Dec 2023 20:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880022;
	bh=6Aa1mDZmRIEPbLxPJ4EEQMoeqmQE+oJGCVjw2daazrU=;
	h=Date:To:From:Subject:From;
	b=PTnH1EpbyPcSXlAVlCFfOGJDUJClcGx08iKgtqOVeRv76lYbSYIUTVCmz32XRIs8F
	 g3LuIm6du6wbBdq62p1jN2boAiw605V8ZyyTns+tRNHuIGViEk5H5Wmb/7IV1DPVmP
	 a1uJSRv3EQESGMd3GNs1OYYPaz7oXobafgAxJITE=
Date: Fri, 29 Dec 2023 12:00:21 -0800
To: mm-commits@vger.kernel.org,hch@lst.de,axboe@kernel.dk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-reduce-stack-usage-in-__mpage_writepage.patch removed from -mm tree
Message-Id: <20231229200022.2E196C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: reduce stack usage in __mpage_writepage
has been removed from the -mm tree.  Its filename was
     fs-reduce-stack-usage-in-__mpage_writepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: fs: reduce stack usage in __mpage_writepage
Date: Fri, 15 Dec 2023 20:02:34 +0000

Some architectures support a very large PAGE_SIZE, so instead of the 8
pointers we see with a 4kB PAGE_SIZE, we can see 128 pointers with 64kB or
so many on Hexagon that it trips compiler warnings about exceeding stack
frame size.

All we're doing with this array is checking for block contiguity, which we
can as well do by remembering the address of the first block in the page
and checking this block is at the appropriate offset from that address.

Link: https://lkml.kernel.org/r/20231215200245.748418-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/fs/mpage.c~fs-reduce-stack-usage-in-__mpage_writepage
+++ a/fs/mpage.c
@@ -466,7 +466,7 @@ static int __mpage_writepage(struct foli
 	const unsigned blocks_per_page = PAGE_SIZE >> blkbits;
 	sector_t last_block;
 	sector_t block_in_file;
-	sector_t blocks[MAX_BUF_PER_PAGE];
+	sector_t first_block;
 	unsigned page_block;
 	unsigned first_unmapped = blocks_per_page;
 	struct block_device *bdev = NULL;
@@ -504,10 +504,12 @@ static int __mpage_writepage(struct foli
 			if (!buffer_dirty(bh) || !buffer_uptodate(bh))
 				goto confused;
 			if (page_block) {
-				if (bh->b_blocknr != blocks[page_block-1] + 1)
+				if (bh->b_blocknr != first_block + page_block)
 					goto confused;
+			} else {
+				first_block = bh->b_blocknr;
 			}
-			blocks[page_block++] = bh->b_blocknr;
+			page_block++;
 			boundary = buffer_boundary(bh);
 			if (boundary) {
 				boundary_block = bh->b_blocknr;
@@ -556,10 +558,12 @@ static int __mpage_writepage(struct foli
 			boundary_bdev = map_bh.b_bdev;
 		}
 		if (page_block) {
-			if (map_bh.b_blocknr != blocks[page_block-1] + 1)
+			if (map_bh.b_blocknr != first_block + page_block)
 				goto confused;
+		} else {
+			first_block = map_bh.b_blocknr;
 		}
-		blocks[page_block++] = map_bh.b_blocknr;
+		page_block++;
 		boundary = buffer_boundary(&map_bh);
 		bdev = map_bh.b_bdev;
 		if (block_in_file == last_block)
@@ -591,7 +595,7 @@ page_is_mapped:
 	/*
 	 * This page will go to BIO.  Do we need to send this BIO off first?
 	 */
-	if (bio && mpd->last_block_in_bio != blocks[0] - 1)
+	if (bio && mpd->last_block_in_bio != first_block - 1)
 		bio = mpage_bio_submit_write(bio);
 
 alloc_new:
@@ -599,7 +603,7 @@ alloc_new:
 		bio = bio_alloc(bdev, BIO_MAX_VECS,
 				REQ_OP_WRITE | wbc_to_write_flags(wbc),
 				GFP_NOFS);
-		bio->bi_iter.bi_sector = blocks[0] << (blkbits - 9);
+		bio->bi_iter.bi_sector = first_block << (blkbits - 9);
 		wbc_init_bio(wbc, bio);
 	}
 
@@ -627,7 +631,7 @@ alloc_new:
 					boundary_block, 1 << blkbits);
 		}
 	} else {
-		mpd->last_block_in_bio = blocks[blocks_per_page - 1];
+		mpd->last_block_in_bio = first_block + blocks_per_page - 1;
 	}
 	goto out;
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

