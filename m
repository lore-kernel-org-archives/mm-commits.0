Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B76D134A8
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vL8N5ULi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8641DC433C7;
	Fri, 29 Dec 2023 19:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879971;
	bh=rkrd4chUl+IgGgWs4cvPtANXXFBL/xtJvHsWlynq8B4=;
	h=Date:To:From:Subject:From;
	b=vL8N5ULiR42eiibWx5TrZ7ZXGy6Mlg7jk+3+dh/t53S5B80xepEueHR8/dN5vLQd7
	 9Uc7LQPcWVSQ0jpt2xAJJ2zXPKMubzUb8h0I5pRauEmO8+N/PsypGa7uu52DniTCVc
	 JeysPt1hVW9W5W2Y2E1LYBxu+ZtKpt0yrE3Z2ROE=
Date: Fri, 29 Dec 2023 11:59:31 -0800
To: mm-commits@vger.kernel.org,p.raghav@samsung.com,mcgrof@kernel.org,konishi.ryusuke@gmail.com,hare@suse.de,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-fix-more-functions-for-block-size-page_size.patch removed from -mm tree
Message-Id: <20231229195931.8641DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: buffer: fix more functions for block size > PAGE_SIZE
has been removed from the -mm tree.  Its filename was
     buffer-fix-more-functions-for-block-size-page_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: fix more functions for block size > PAGE_SIZE
Date: Thu, 9 Nov 2023 21:06:08 +0000

Both __block_write_full_folio() and block_read_full_folio() assumed that
block size <= PAGE_SIZE.  Replace the shift with a divide, which is
probably cheaper than first calculating the shift.  That lets us remove
block_size_bits() as these were the last callers.

Link: https://lkml.kernel.org/r/20231109210608.2252323-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

--- a/fs/buffer.c~buffer-fix-more-functions-for-block-size-page_size
+++ a/fs/buffer.c
@@ -1742,19 +1742,6 @@ unlock_page:
 }
 EXPORT_SYMBOL(clean_bdev_aliases);
 
-/*
- * Size is a power-of-two in the range 512..PAGE_SIZE,
- * and the case we care about most is PAGE_SIZE.
- *
- * So this *could* possibly be written with those
- * constraints in mind (relevant mostly if some
- * architecture has a slow bit-scan instruction)
- */
-static inline int block_size_bits(unsigned int blocksize)
-{
-	return ilog2(blocksize);
-}
-
 static struct buffer_head *folio_create_buffers(struct folio *folio,
 						struct inode *inode,
 						unsigned int b_state)
@@ -1807,7 +1794,7 @@ int __block_write_full_folio(struct inod
 	sector_t block;
 	sector_t last_block;
 	struct buffer_head *bh, *head;
-	unsigned int blocksize, bbits;
+	size_t blocksize;
 	int nr_underway = 0;
 	blk_opf_t write_flags = wbc_to_write_flags(wbc);
 
@@ -1826,10 +1813,9 @@ int __block_write_full_folio(struct inod
 
 	bh = head;
 	blocksize = bh->b_size;
-	bbits = block_size_bits(blocksize);
 
-	block = (sector_t)folio->index << (PAGE_SHIFT - bbits);
-	last_block = (i_size_read(inode) - 1) >> bbits;
+	block = div_u64(folio_pos(folio), blocksize);
+	last_block = div_u64(i_size_read(inode) - 1, blocksize);
 
 	/*
 	 * Get all the dirty buffers mapped to disk addresses and
@@ -2355,7 +2341,7 @@ int block_read_full_folio(struct folio *
 	struct inode *inode = folio->mapping->host;
 	sector_t iblock, lblock;
 	struct buffer_head *bh, *head, *arr[MAX_BUF_PER_PAGE];
-	unsigned int blocksize, bbits;
+	size_t blocksize;
 	int nr, i;
 	int fully_mapped = 1;
 	bool page_error = false;
@@ -2369,10 +2355,9 @@ int block_read_full_folio(struct folio *
 
 	head = folio_create_buffers(folio, inode, 0);
 	blocksize = head->b_size;
-	bbits = block_size_bits(blocksize);
 
-	iblock = (sector_t)folio->index << (PAGE_SHIFT - bbits);
-	lblock = (limit+blocksize-1) >> bbits;
+	iblock = div_u64(folio_pos(folio), blocksize);
+	lblock = div_u64(limit + blocksize - 1, blocksize);
 	bh = head;
 	nr = 0;
 	i = 0;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

