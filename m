Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2BD134D3
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xZwTAmsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15895C433C9;
	Fri, 29 Dec 2023 20:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880023;
	bh=57ketwV8O3p189PTsjDTZjyfr1o5MENVn89POurcNBY=;
	h=Date:To:From:Subject:From;
	b=xZwTAmsAHuDHxA29+07RWbXcPEYvMq/tsx6y7RRccr/wwMjhKfVkJhZHHkglWPVhV
	 M11855iZ/UpNUxL4Twbig/u7JIn9HJLILGC5rlcEaGEwj6Yh/wY2QuiAUVNhkcU1s+
	 hab8AkXXRBQIjpVgAZE6OE7BwfsbltZu6ZEmloWA=
Date: Fri, 29 Dec 2023 12:00:22 -0800
To: mm-commits@vger.kernel.org,hch@lst.de,axboe@kernel.dk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-reduce-stack-usage-in-do_mpage_readpage.patch removed from -mm tree
Message-Id: <20231229200023.15895C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: reduce stack usage in do_mpage_readpage
has been removed from the -mm tree.  Its filename was
     fs-reduce-stack-usage-in-do_mpage_readpage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

