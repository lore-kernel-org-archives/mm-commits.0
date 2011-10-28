From: akpm@linux-foundation.org
Subject: [merged] dio-separate-fields-only-used-in-the-submission-path-from-struct-dio.patch removed from -mm tree
Date: Fri, 28 Oct 2011 15:10:14 -0700
Message-ID: <201110282210.p9SMAEaA005338@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:32984 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab1J1WK1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2011 18:10:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, axboe@kernel.dk, hch@lst.de, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dio: separate fields only used in the submission path from struct dio
has been removed from the -mm tree.  Its filename was
     dio-separate-fields-only-used-in-the-submission-path-from-struct-dio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: dio: separate fields only used in the submission path from struct dio

This large, but largely mechanic, patch moves all fields in struct dio
that are only used in the submission path into a separate on stack data
structure.  This has the advantage that the memory is very likely cache
hot, which is not guaranteed for memory fresh out of kmalloc.

This also gives gcc more optimization potential because it can easier
determine that there are no external aliases for these variables.

The sdio initialization is a initialization now instead of memset.  This
allows gcc to break sdio into individual fields and optimize away
unnecessary zeroing (after all the functions are inlined)

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |  391 ++++++++++++++++++++++++-----------------------
 1 file changed, 201 insertions(+), 190 deletions(-)

diff -puN fs/direct-io.c~dio-separate-fields-only-used-in-the-submission-path-from-struct-dio fs/direct-io.c
--- a/fs/direct-io.c~dio-separate-fields-only-used-in-the-submission-path-from-struct-dio
+++ a/fs/direct-io.c
@@ -55,13 +55,10 @@
  * blocksize.
  */
 
-struct dio {
-	/* BIO submission state */
+/* dio_state only used in the submission path */
+
+struct dio_submit {
 	struct bio *bio;		/* bio under assembly */
-	struct inode *inode;
-	int rw;
-	loff_t i_size;			/* i_size when submitted */
-	int flags;			/* doesn't change */
 	unsigned blkbits;		/* doesn't change */
 	unsigned blkfactor;		/* When we're using an alignment which
 					   is finer than the filesystem's soft
@@ -71,7 +68,7 @@ struct dio {
 	unsigned start_zero_done;	/* flag: sub-blocksize zeroing has
 					   been performed at the start of a
 					   write */
-	int pages_in_io;		/* approximate total IO pages */
+	int pages_in_io;		/* approximate total IO pages */	
 	size_t	size;			/* total request size (doesn't change)*/
 	sector_t block_in_file;		/* Current offset into the underlying
 					   file in dio_block units. */
@@ -81,14 +78,13 @@ struct dio {
 	int boundary;			/* prev block is at a boundary */
 	int reap_counter;		/* rate limit reaping */
 	get_block_t *get_block;		/* block mapping function */
-	dio_iodone_t *end_io;		/* IO completion function */
-	dio_submit_t *submit_io;	/* IO submition function */
+	dio_submit_t *submit_io;	/* IO submition function */	
+
 	loff_t logical_offset_in_bio;	/* current first logical block in bio */
 	sector_t final_block_in_bio;	/* current final block in bio + 1 */
 	sector_t next_block_for_io;	/* next block to be put under IO,
 					   in dio_blocks units */
-	struct buffer_head map_bh;	/* last get_block() result */
-
+	
 	/*
 	 * Deferred addition of a page to the dio.  These variables are
 	 * private to dio_send_cur_page(), submit_page_section() and
@@ -100,18 +96,6 @@ struct dio {
 	sector_t cur_page_block;	/* Where it starts */
 	loff_t cur_page_fs_offset;	/* Offset in file */
 
-	/* BIO completion state */
-	spinlock_t bio_lock;		/* protects BIO fields below */
-	unsigned long refcount;		/* direct_io_worker() and bios */
-	struct bio *bio_list;		/* singly linked via bi_private */
-	struct task_struct *waiter;	/* waiting task (NULL if none) */
-
-	/* AIO related stuff */
-	struct kiocb *iocb;		/* kiocb */
-	int is_async;			/* is IO async ? */
-	int io_error;			/* IO error in completion path */
-	ssize_t result;                 /* IO result */
-
 	/*
 	 * Page fetching state. These variables belong to dio_refill_pages().
 	 */
@@ -125,6 +109,30 @@ struct dio {
 	 */
 	unsigned head;			/* next page to process */
 	unsigned tail;			/* last valid page + 1 */
+};
+
+/* dio_state communicated between submission path and end_io */
+struct dio {
+	int flags;			/* doesn't change */
+	struct inode *inode;
+	int rw;
+	loff_t i_size;			/* i_size when submitted */
+	dio_iodone_t *end_io;		/* IO completion function */
+	struct buffer_head map_bh;	/* last get_block() result */
+
+
+	/* BIO completion state */
+	spinlock_t bio_lock;		/* protects BIO fields below */
+	unsigned long refcount;		/* direct_io_worker() and bios */
+	struct bio *bio_list;		/* singly linked via bi_private */
+	struct task_struct *waiter;	/* waiting task (NULL if none) */
+
+	/* AIO related stuff */
+	struct kiocb *iocb;		/* kiocb */
+	int is_async;			/* is IO async ? */
+	int io_error;			/* IO error in completion path */
+	ssize_t result;                 /* IO result */
+
 	int page_errors;		/* errno from get_user_pages() */
 
 	/*
@@ -132,7 +140,7 @@ struct dio {
 	 * allocation time.  Don't add new fields after pages[] unless you
 	 * wish that they not be zeroed.
 	 */
-	struct page *pages[DIO_PAGES];	/* page buffer */
+	struct page *pages[DIO_PAGES];	/* page buffer */	
 };
 
 static void __inode_dio_wait(struct inode *inode)
@@ -182,27 +190,27 @@ EXPORT_SYMBOL_GPL(inode_dio_done);
 /*
  * How many pages are in the queue?
  */
-static inline unsigned dio_pages_present(struct dio *dio)
+static inline unsigned dio_pages_present(struct dio *dio, struct dio_submit *sdio)
 {
-	return dio->tail - dio->head;
+	return sdio->tail - sdio->head;
 }
 
 /*
  * Go grab and pin some userspace pages.   Typically we'll get 64 at a time.
  */
-static int dio_refill_pages(struct dio *dio)
+static int dio_refill_pages(struct dio *dio, struct dio_submit *sdio)
 {
 	int ret;
 	int nr_pages;
 
-	nr_pages = min(dio->total_pages - dio->curr_page, DIO_PAGES);
+	nr_pages = min(sdio->total_pages - sdio->curr_page, DIO_PAGES);
 	ret = get_user_pages_fast(
-		dio->curr_user_address,		/* Where from? */
+		sdio->curr_user_address,		/* Where from? */
 		nr_pages,			/* How many pages? */
 		dio->rw == READ,		/* Write to memory? */
 		&dio->pages[0]);		/* Put results here */
 
-	if (ret < 0 && dio->blocks_available && (dio->rw & WRITE)) {
+	if (ret < 0 && sdio->blocks_available && (dio->rw & WRITE)) {
 		struct page *page = ZERO_PAGE(0);
 		/*
 		 * A memory fault, but the filesystem has some outstanding
@@ -213,17 +221,17 @@ static int dio_refill_pages(struct dio *
 			dio->page_errors = ret;
 		page_cache_get(page);
 		dio->pages[0] = page;
-		dio->head = 0;
-		dio->tail = 1;
+		sdio->head = 0;
+		sdio->tail = 1;
 		ret = 0;
 		goto out;
 	}
 
 	if (ret >= 0) {
-		dio->curr_user_address += ret * PAGE_SIZE;
-		dio->curr_page += ret;
-		dio->head = 0;
-		dio->tail = ret;
+		sdio->curr_user_address += ret * PAGE_SIZE;
+		sdio->curr_page += ret;
+		sdio->head = 0;
+		sdio->tail = ret;
 		ret = 0;
 	}
 out:
@@ -236,17 +244,17 @@ out:
  * decent number of pages, less frequently.  To provide nicer use of the
  * L1 cache.
  */
-static struct page *dio_get_page(struct dio *dio)
+static struct page *dio_get_page(struct dio *dio, struct dio_submit *sdio)
 {
-	if (dio_pages_present(dio) == 0) {
+	if (dio_pages_present(dio, sdio) == 0) {
 		int ret;
 
-		ret = dio_refill_pages(dio);
+		ret = dio_refill_pages(dio, sdio);
 		if (ret)
 			return ERR_PTR(ret);
-		BUG_ON(dio_pages_present(dio) == 0);
+		BUG_ON(dio_pages_present(dio, sdio) == 0);
 	}
-	return dio->pages[dio->head++];
+	return dio->pages[sdio->head++];
 }
 
 /**
@@ -368,8 +376,9 @@ void dio_end_io(struct bio *bio, int err
 EXPORT_SYMBOL_GPL(dio_end_io);
 
 static void
-dio_bio_alloc(struct dio *dio, struct block_device *bdev,
-		sector_t first_sector, int nr_vecs)
+dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
+	      struct block_device *bdev,
+	      sector_t first_sector, int nr_vecs)
 {
 	struct bio *bio;
 
@@ -386,8 +395,8 @@ dio_bio_alloc(struct dio *dio, struct bl
 	else
 		bio->bi_end_io = dio_bio_end_io;
 
-	dio->bio = bio;
-	dio->logical_offset_in_bio = dio->cur_page_fs_offset;
+	sdio->bio = bio;
+	sdio->logical_offset_in_bio = sdio->cur_page_fs_offset;
 }
 
 /*
@@ -397,9 +406,9 @@ dio_bio_alloc(struct dio *dio, struct bl
  *
  * bios hold a dio reference between submit_bio and ->end_io.
  */
-static void dio_bio_submit(struct dio *dio)
+static void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
 {
-	struct bio *bio = dio->bio;
+	struct bio *bio = sdio->bio;
 	unsigned long flags;
 
 	bio->bi_private = dio;
@@ -411,24 +420,24 @@ static void dio_bio_submit(struct dio *d
 	if (dio->is_async && dio->rw == READ)
 		bio_set_pages_dirty(bio);
 
-	if (dio->submit_io)
-		dio->submit_io(dio->rw, bio, dio->inode,
-			       dio->logical_offset_in_bio);
+	if (sdio->submit_io)
+		sdio->submit_io(dio->rw, bio, dio->inode,
+			       sdio->logical_offset_in_bio);
 	else
 		submit_bio(dio->rw, bio);
 
-	dio->bio = NULL;
-	dio->boundary = 0;
-	dio->logical_offset_in_bio = 0;
+	sdio->bio = NULL;
+	sdio->boundary = 0;
+	sdio->logical_offset_in_bio = 0;
 }
 
 /*
  * Release any resources in case of a failure
  */
-static void dio_cleanup(struct dio *dio)
+static void dio_cleanup(struct dio *dio, struct dio_submit *sdio)
 {
-	while (dio_pages_present(dio))
-		page_cache_release(dio_get_page(dio));
+	while (dio_pages_present(dio, sdio))
+		page_cache_release(dio_get_page(dio, sdio));
 }
 
 /*
@@ -518,11 +527,11 @@ static void dio_await_completion(struct 
  *
  * This also helps to limit the peak amount of pinned userspace memory.
  */
-static int dio_bio_reap(struct dio *dio)
+static int dio_bio_reap(struct dio *dio, struct dio_submit *sdio)
 {
 	int ret = 0;
 
-	if (dio->reap_counter++ >= 64) {
+	if (sdio->reap_counter++ >= 64) {
 		while (dio->bio_list) {
 			unsigned long flags;
 			struct bio *bio;
@@ -536,14 +545,14 @@ static int dio_bio_reap(struct dio *dio)
 			if (ret == 0)
 				ret = ret2;
 		}
-		dio->reap_counter = 0;
+		sdio->reap_counter = 0;
 	}
 	return ret;
 }
 
 /*
  * Call into the fs to map some more disk blocks.  We record the current number
- * of available blocks at dio->blocks_available.  These are in units of the
+ * of available blocks at sdio->blocks_available.  These are in units of the
  * fs blocksize, (1 << inode->i_blkbits).
  *
  * The fs is allowed to map lots of blocks at once.  If it wants to do that,
@@ -564,7 +573,7 @@ static int dio_bio_reap(struct dio *dio)
  * buffer_mapped().  However the direct-io code will only process holes one
  * block at a time - it will repeatedly call get_block() as it walks the hole.
  */
-static int get_more_blocks(struct dio *dio)
+static int get_more_blocks(struct dio *dio, struct dio_submit *sdio)
 {
 	int ret;
 	struct buffer_head *map_bh = &dio->map_bh;
@@ -579,9 +588,9 @@ static int get_more_blocks(struct dio *d
 	 */
 	ret = dio->page_errors;
 	if (ret == 0) {
-		BUG_ON(dio->block_in_file >= dio->final_block_in_request);
-		fs_startblk = dio->block_in_file >> dio->blkfactor;
-		fs_endblk = (dio->final_block_in_request - 1) >> dio->blkfactor;
+		BUG_ON(sdio->block_in_file >= sdio->final_block_in_request);
+		fs_startblk = sdio->block_in_file >> sdio->blkfactor;
+		fs_endblk = (sdio->final_block_in_request-1) >> sdio->blkfactor;
 		fs_count = fs_endblk - fs_startblk + 1;
 
 		map_bh->b_state = 0;
@@ -600,12 +609,12 @@ static int get_more_blocks(struct dio *d
 		 */
 		create = dio->rw & WRITE;
 		if (dio->flags & DIO_SKIP_HOLES) {
-			if (dio->block_in_file < (i_size_read(dio->inode) >>
-							dio->blkbits))
+			if (sdio->block_in_file < (i_size_read(dio->inode) >>
+							sdio->blkbits))
 				create = 0;
 		}
 
-		ret = (*dio->get_block)(dio->inode, fs_startblk,
+		ret = (*sdio->get_block)(dio->inode, fs_startblk,
 						map_bh, create);
 	}
 	return ret;
@@ -614,20 +623,21 @@ static int get_more_blocks(struct dio *d
 /*
  * There is no bio.  Make one now.
  */
-static int dio_new_bio(struct dio *dio, sector_t start_sector)
+static int dio_new_bio(struct dio *dio, struct dio_submit *sdio, 
+		       sector_t start_sector)
 {
 	sector_t sector;
 	int ret, nr_pages;
 
-	ret = dio_bio_reap(dio);
+	ret = dio_bio_reap(dio, sdio);
 	if (ret)
 		goto out;
-	sector = start_sector << (dio->blkbits - 9);
-	nr_pages = min(dio->pages_in_io, bio_get_nr_vecs(dio->map_bh.b_bdev));
+	sector = start_sector << (sdio->blkbits - 9);
+	nr_pages = min(sdio->pages_in_io, bio_get_nr_vecs(dio->map_bh.b_bdev));
 	nr_pages = min(nr_pages, BIO_MAX_PAGES);
 	BUG_ON(nr_pages <= 0);
-	dio_bio_alloc(dio, dio->map_bh.b_bdev, sector, nr_pages);
-	dio->boundary = 0;
+	dio_bio_alloc(dio, sdio, dio->map_bh.b_bdev, sector, nr_pages);
+	sdio->boundary = 0;
 out:
 	return ret;
 }
@@ -639,21 +649,21 @@ out:
  *
  * Return zero on success.  Non-zero means the caller needs to start a new BIO.
  */
-static int dio_bio_add_page(struct dio *dio)
+static int dio_bio_add_page(struct dio *dio, struct dio_submit *sdio)
 {
 	int ret;
 
-	ret = bio_add_page(dio->bio, dio->cur_page,
-			dio->cur_page_len, dio->cur_page_offset);
-	if (ret == dio->cur_page_len) {
+	ret = bio_add_page(sdio->bio, sdio->cur_page,
+			sdio->cur_page_len, sdio->cur_page_offset);
+	if (ret == sdio->cur_page_len) {
 		/*
 		 * Decrement count only, if we are done with this page
 		 */
-		if ((dio->cur_page_len + dio->cur_page_offset) == PAGE_SIZE)
-			dio->pages_in_io--;
-		page_cache_get(dio->cur_page);
-		dio->final_block_in_bio = dio->cur_page_block +
-			(dio->cur_page_len >> dio->blkbits);
+		if ((sdio->cur_page_len + sdio->cur_page_offset) == PAGE_SIZE)
+			sdio->pages_in_io--;
+		page_cache_get(sdio->cur_page);
+		sdio->final_block_in_bio = sdio->cur_page_block +
+			(sdio->cur_page_len >> sdio->blkbits);
 		ret = 0;
 	} else {
 		ret = 1;
@@ -671,14 +681,14 @@ static int dio_bio_add_page(struct dio *
  * The caller of this function is responsible for removing cur_page from the
  * dio, and for dropping the refcount which came from that presence.
  */
-static int dio_send_cur_page(struct dio *dio)
+static int dio_send_cur_page(struct dio *dio, struct dio_submit *sdio)
 {
 	int ret = 0;
 
-	if (dio->bio) {
-		loff_t cur_offset = dio->cur_page_fs_offset;
-		loff_t bio_next_offset = dio->logical_offset_in_bio +
-			dio->bio->bi_size;
+	if (sdio->bio) {
+		loff_t cur_offset = sdio->cur_page_fs_offset;
+		loff_t bio_next_offset = sdio->logical_offset_in_bio +
+			sdio->bio->bi_size;
 
 		/*
 		 * See whether this new request is contiguous with the old.
@@ -694,28 +704,28 @@ static int dio_send_cur_page(struct dio 
 		 * be the next logical offset in the bio, submit the bio we
 		 * have.
 		 */
-		if (dio->final_block_in_bio != dio->cur_page_block ||
+		if (sdio->final_block_in_bio != sdio->cur_page_block ||
 		    cur_offset != bio_next_offset)
-			dio_bio_submit(dio);
+			dio_bio_submit(dio, sdio);
 		/*
 		 * Submit now if the underlying fs is about to perform a
 		 * metadata read
 		 */
-		else if (dio->boundary)
-			dio_bio_submit(dio);
+		else if (sdio->boundary)
+			dio_bio_submit(dio, sdio);
 	}
 
-	if (dio->bio == NULL) {
-		ret = dio_new_bio(dio, dio->cur_page_block);
+	if (sdio->bio == NULL) {
+		ret = dio_new_bio(dio, sdio, sdio->cur_page_block);
 		if (ret)
 			goto out;
 	}
 
-	if (dio_bio_add_page(dio) != 0) {
-		dio_bio_submit(dio);
-		ret = dio_new_bio(dio, dio->cur_page_block);
+	if (dio_bio_add_page(dio, sdio) != 0) {
+		dio_bio_submit(dio, sdio);
+		ret = dio_new_bio(dio, sdio, sdio->cur_page_block);
 		if (ret == 0) {
-			ret = dio_bio_add_page(dio);
+			ret = dio_bio_add_page(dio, sdio);
 			BUG_ON(ret != 0);
 		}
 	}
@@ -741,7 +751,7 @@ out:
  * page to the dio instead.
  */
 static int
-submit_page_section(struct dio *dio, struct page *page,
+submit_page_section(struct dio *dio, struct dio_submit *sdio, struct page *page,
 		unsigned offset, unsigned len, sector_t blocknr)
 {
 	int ret = 0;
@@ -756,20 +766,20 @@ submit_page_section(struct dio *dio, str
 	/*
 	 * Can we just grow the current page's presence in the dio?
 	 */
-	if (	(dio->cur_page == page) &&
-		(dio->cur_page_offset + dio->cur_page_len == offset) &&
-		(dio->cur_page_block +
-			(dio->cur_page_len >> dio->blkbits) == blocknr)) {
-		dio->cur_page_len += len;
+	if (	(sdio->cur_page == page) &&
+		(sdio->cur_page_offset + sdio->cur_page_len == offset) &&
+		(sdio->cur_page_block +
+			(sdio->cur_page_len >> sdio->blkbits) == blocknr)) {
+		sdio->cur_page_len += len;
 
 		/*
-		 * If dio->boundary then we want to schedule the IO now to
+		 * If sdio->boundary then we want to schedule the IO now to
 		 * avoid metadata seeks.
 		 */
-		if (dio->boundary) {
-			ret = dio_send_cur_page(dio);
-			page_cache_release(dio->cur_page);
-			dio->cur_page = NULL;
+		if (sdio->boundary) {
+			ret = dio_send_cur_page(dio, sdio);
+			page_cache_release(sdio->cur_page);
+			sdio->cur_page = NULL;
 		}
 		goto out;
 	}
@@ -777,20 +787,20 @@ submit_page_section(struct dio *dio, str
 	/*
 	 * If there's a deferred page already there then send it.
 	 */
-	if (dio->cur_page) {
-		ret = dio_send_cur_page(dio);
-		page_cache_release(dio->cur_page);
-		dio->cur_page = NULL;
+	if (sdio->cur_page) {
+		ret = dio_send_cur_page(dio, sdio);
+		page_cache_release(sdio->cur_page);
+		sdio->cur_page = NULL;
 		if (ret)
 			goto out;
 	}
 
 	page_cache_get(page);		/* It is in dio */
-	dio->cur_page = page;
-	dio->cur_page_offset = offset;
-	dio->cur_page_len = len;
-	dio->cur_page_block = blocknr;
-	dio->cur_page_fs_offset = dio->block_in_file << dio->blkbits;
+	sdio->cur_page = page;
+	sdio->cur_page_offset = offset;
+	sdio->cur_page_len = len;
+	sdio->cur_page_block = blocknr;
+	sdio->cur_page_fs_offset = sdio->block_in_file << sdio->blkbits;
 out:
 	return ret;
 }
@@ -822,19 +832,19 @@ static void clean_blockdev_aliases(struc
  * `end' is zero if we're doing the start of the IO, 1 at the end of the
  * IO.
  */
-static void dio_zero_block(struct dio *dio, int end)
+static void dio_zero_block(struct dio *dio, struct dio_submit *sdio, int end)
 {
 	unsigned dio_blocks_per_fs_block;
 	unsigned this_chunk_blocks;	/* In dio_blocks */
 	unsigned this_chunk_bytes;
 	struct page *page;
 
-	dio->start_zero_done = 1;
-	if (!dio->blkfactor || !buffer_new(&dio->map_bh))
+	sdio->start_zero_done = 1;
+	if (!sdio->blkfactor || !buffer_new(&dio->map_bh))
 		return;
 
-	dio_blocks_per_fs_block = 1 << dio->blkfactor;
-	this_chunk_blocks = dio->block_in_file & (dio_blocks_per_fs_block - 1);
+	dio_blocks_per_fs_block = 1 << sdio->blkfactor;
+	this_chunk_blocks = sdio->block_in_file & (dio_blocks_per_fs_block - 1);
 
 	if (!this_chunk_blocks)
 		return;
@@ -846,14 +856,14 @@ static void dio_zero_block(struct dio *d
 	if (end) 
 		this_chunk_blocks = dio_blocks_per_fs_block - this_chunk_blocks;
 
-	this_chunk_bytes = this_chunk_blocks << dio->blkbits;
+	this_chunk_bytes = this_chunk_blocks << sdio->blkbits;
 
 	page = ZERO_PAGE(0);
-	if (submit_page_section(dio, page, 0, this_chunk_bytes, 
-				dio->next_block_for_io))
+	if (submit_page_section(dio, sdio, page, 0, this_chunk_bytes, 
+				sdio->next_block_for_io))
 		return;
 
-	dio->next_block_for_io += this_chunk_blocks;
+	sdio->next_block_for_io += this_chunk_blocks;
 }
 
 /*
@@ -872,9 +882,9 @@ static void dio_zero_block(struct dio *d
  * it should set b_size to PAGE_SIZE or more inside get_block().  This gives
  * fine alignment but still allows this function to work in PAGE_SIZE units.
  */
-static int do_direct_IO(struct dio *dio)
+static int do_direct_IO(struct dio *dio, struct dio_submit *sdio)
 {
-	const unsigned blkbits = dio->blkbits;
+	const unsigned blkbits = sdio->blkbits;
 	const unsigned blocks_per_page = PAGE_SIZE >> blkbits;
 	struct page *page;
 	unsigned block_in_page;
@@ -882,10 +892,10 @@ static int do_direct_IO(struct dio *dio)
 	int ret = 0;
 
 	/* The I/O can start at any block offset within the first page */
-	block_in_page = dio->first_block_in_page;
+	block_in_page = sdio->first_block_in_page;
 
-	while (dio->block_in_file < dio->final_block_in_request) {
-		page = dio_get_page(dio);
+	while (sdio->block_in_file < sdio->final_block_in_request) {
+		page = dio_get_page(dio, sdio);
 		if (IS_ERR(page)) {
 			ret = PTR_ERR(page);
 			goto out;
@@ -897,14 +907,14 @@ static int do_direct_IO(struct dio *dio)
 			unsigned this_chunk_blocks;	/* # of blocks */
 			unsigned u;
 
-			if (dio->blocks_available == 0) {
+			if (sdio->blocks_available == 0) {
 				/*
 				 * Need to go and map some more disk
 				 */
 				unsigned long blkmask;
 				unsigned long dio_remainder;
 
-				ret = get_more_blocks(dio);
+				ret = get_more_blocks(dio, sdio);
 				if (ret) {
 					page_cache_release(page);
 					goto out;
@@ -912,18 +922,18 @@ static int do_direct_IO(struct dio *dio)
 				if (!buffer_mapped(map_bh))
 					goto do_holes;
 
-				dio->blocks_available =
-						map_bh->b_size >> dio->blkbits;
-				dio->next_block_for_io =
-					map_bh->b_blocknr << dio->blkfactor;
+				sdio->blocks_available =
+						map_bh->b_size >> sdio->blkbits;
+				sdio->next_block_for_io =
+					map_bh->b_blocknr << sdio->blkfactor;
 				if (buffer_new(map_bh))
 					clean_blockdev_aliases(dio);
 
-				if (!dio->blkfactor)
+				if (!sdio->blkfactor)
 					goto do_holes;
 
-				blkmask = (1 << dio->blkfactor) - 1;
-				dio_remainder = (dio->block_in_file & blkmask);
+				blkmask = (1 << sdio->blkfactor) - 1;
+				dio_remainder = (sdio->block_in_file & blkmask);
 
 				/*
 				 * If we are at the start of IO and that IO
@@ -937,8 +947,8 @@ static int do_direct_IO(struct dio *dio)
 				 * on-disk
 				 */
 				if (!buffer_new(map_bh))
-					dio->next_block_for_io += dio_remainder;
-				dio->blocks_available -= dio_remainder;
+					sdio->next_block_for_io += dio_remainder;
+				sdio->blocks_available -= dio_remainder;
 			}
 do_holes:
 			/* Handle holes */
@@ -957,7 +967,7 @@ do_holes:
 				 */
 				i_size_aligned = ALIGN(i_size_read(dio->inode),
 							1 << blkbits);
-				if (dio->block_in_file >=
+				if (sdio->block_in_file >=
 						i_size_aligned >> blkbits) {
 					/* We hit eof */
 					page_cache_release(page);
@@ -965,7 +975,7 @@ do_holes:
 				}
 				zero_user(page, block_in_page << blkbits,
 						1 << blkbits);
-				dio->block_in_file++;
+				sdio->block_in_file++;
 				block_in_page++;
 				goto next_block;
 			}
@@ -975,38 +985,38 @@ do_holes:
 			 * is finer than the underlying fs, go check to see if
 			 * we must zero out the start of this block.
 			 */
-			if (unlikely(dio->blkfactor && !dio->start_zero_done))
-				dio_zero_block(dio, 0);
+			if (unlikely(sdio->blkfactor && !sdio->start_zero_done))
+				dio_zero_block(dio, sdio, 0);
 
 			/*
 			 * Work out, in this_chunk_blocks, how much disk we
 			 * can add to this page
 			 */
-			this_chunk_blocks = dio->blocks_available;
+			this_chunk_blocks = sdio->blocks_available;
 			u = (PAGE_SIZE - offset_in_page) >> blkbits;
 			if (this_chunk_blocks > u)
 				this_chunk_blocks = u;
-			u = dio->final_block_in_request - dio->block_in_file;
+			u = sdio->final_block_in_request - sdio->block_in_file;
 			if (this_chunk_blocks > u)
 				this_chunk_blocks = u;
 			this_chunk_bytes = this_chunk_blocks << blkbits;
 			BUG_ON(this_chunk_bytes == 0);
 
-			dio->boundary = buffer_boundary(map_bh);
-			ret = submit_page_section(dio, page, offset_in_page,
-				this_chunk_bytes, dio->next_block_for_io);
+			sdio->boundary = buffer_boundary(map_bh);
+			ret = submit_page_section(dio, sdio, page, offset_in_page,
+				this_chunk_bytes, sdio->next_block_for_io);
 			if (ret) {
 				page_cache_release(page);
 				goto out;
 			}
-			dio->next_block_for_io += this_chunk_blocks;
+			sdio->next_block_for_io += this_chunk_blocks;
 
-			dio->block_in_file += this_chunk_blocks;
+			sdio->block_in_file += this_chunk_blocks;
 			block_in_page += this_chunk_blocks;
-			dio->blocks_available -= this_chunk_blocks;
+			sdio->blocks_available -= this_chunk_blocks;
 next_block:
-			BUG_ON(dio->block_in_file > dio->final_block_in_request);
-			if (dio->block_in_file == dio->final_block_in_request)
+			BUG_ON(sdio->block_in_file > sdio->final_block_in_request);
+			if (sdio->block_in_file == sdio->final_block_in_request)
 				break;
 		}
 
@@ -1022,7 +1032,7 @@ static ssize_t
 direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode, 
 	const struct iovec *iov, loff_t offset, unsigned long nr_segs, 
 	unsigned blkbits, get_block_t get_block, dio_iodone_t end_io,
-	dio_submit_t submit_io, struct dio *dio)
+	dio_submit_t submit_io, struct dio *dio, struct dio_submit *sdio)
 {
 	unsigned long user_addr; 
 	unsigned long flags;
@@ -1033,15 +1043,15 @@ direct_io_worker(int rw, struct kiocb *i
 
 	dio->inode = inode;
 	dio->rw = rw;
-	dio->blkbits = blkbits;
-	dio->blkfactor = inode->i_blkbits - blkbits;
-	dio->block_in_file = offset >> blkbits;
+	sdio->blkbits = blkbits;
+	sdio->blkfactor = inode->i_blkbits - blkbits;
+	sdio->block_in_file = offset >> blkbits;
 
-	dio->get_block = get_block;
+	sdio->get_block = get_block;
 	dio->end_io = end_io;
-	dio->submit_io = submit_io;
-	dio->final_block_in_bio = -1;
-	dio->next_block_for_io = -1;
+	sdio->submit_io = submit_io;
+	sdio->final_block_in_bio = -1;
+	sdio->next_block_for_io = -1;
 
 	dio->iocb = iocb;
 	dio->i_size = i_size_read(inode);
@@ -1053,45 +1063,45 @@ direct_io_worker(int rw, struct kiocb *i
 	 * In case of non-aligned buffers, we may need 2 more
 	 * pages since we need to zero out first and last block.
 	 */
-	if (unlikely(dio->blkfactor))
-		dio->pages_in_io = 2;
+	if (unlikely(sdio->blkfactor))
+		sdio->pages_in_io = 2;
 
 	for (seg = 0; seg < nr_segs; seg++) {
 		user_addr = (unsigned long)iov[seg].iov_base;
-		dio->pages_in_io +=
+		sdio->pages_in_io +=
 			((user_addr+iov[seg].iov_len +PAGE_SIZE-1)/PAGE_SIZE
 				- user_addr/PAGE_SIZE);
 	}
 
 	for (seg = 0; seg < nr_segs; seg++) {
 		user_addr = (unsigned long)iov[seg].iov_base;
-		dio->size += bytes = iov[seg].iov_len;
+		sdio->size += bytes = iov[seg].iov_len;
 
 		/* Index into the first page of the first block */
-		dio->first_block_in_page = (user_addr & ~PAGE_MASK) >> blkbits;
-		dio->final_block_in_request = dio->block_in_file +
+		sdio->first_block_in_page = (user_addr & ~PAGE_MASK) >> blkbits;
+		sdio->final_block_in_request = sdio->block_in_file +
 						(bytes >> blkbits);
 		/* Page fetching state */
-		dio->head = 0;
-		dio->tail = 0;
-		dio->curr_page = 0;
+		sdio->head = 0;
+		sdio->tail = 0;
+		sdio->curr_page = 0;
 
-		dio->total_pages = 0;
+		sdio->total_pages = 0;
 		if (user_addr & (PAGE_SIZE-1)) {
-			dio->total_pages++;
+			sdio->total_pages++;
 			bytes -= PAGE_SIZE - (user_addr & (PAGE_SIZE - 1));
 		}
-		dio->total_pages += (bytes + PAGE_SIZE - 1) / PAGE_SIZE;
-		dio->curr_user_address = user_addr;
+		sdio->total_pages += (bytes + PAGE_SIZE - 1) / PAGE_SIZE;
+		sdio->curr_user_address = user_addr;
 	
-		ret = do_direct_IO(dio);
+		ret = do_direct_IO(dio, sdio);
 
 		dio->result += iov[seg].iov_len -
-			((dio->final_block_in_request - dio->block_in_file) <<
+			((sdio->final_block_in_request - sdio->block_in_file) <<
 					blkbits);
 
 		if (ret) {
-			dio_cleanup(dio);
+			dio_cleanup(dio, sdio);
 			break;
 		}
 	} /* end iovec loop */
@@ -1107,23 +1117,23 @@ direct_io_worker(int rw, struct kiocb *i
 	 * There may be some unwritten disk at the end of a part-written
 	 * fs-block-sized block.  Go zero that now.
 	 */
-	dio_zero_block(dio, 1);
+	dio_zero_block(dio, sdio, 1);
 
-	if (dio->cur_page) {
-		ret2 = dio_send_cur_page(dio);
+	if (sdio->cur_page) {
+		ret2 = dio_send_cur_page(dio, sdio);
 		if (ret == 0)
 			ret = ret2;
-		page_cache_release(dio->cur_page);
-		dio->cur_page = NULL;
+		page_cache_release(sdio->cur_page);
+		sdio->cur_page = NULL;
 	}
-	if (dio->bio)
-		dio_bio_submit(dio);
+	if (sdio->bio)
+		dio_bio_submit(dio, sdio);
 
 	/*
 	 * It is possible that, we return short IO due to end of file.
 	 * In that case, we need to release all the pages we got hold on.
 	 */
-	dio_cleanup(dio);
+	dio_cleanup(dio, sdio);
 
 	/*
 	 * All block lookups have been performed. For READ requests
@@ -1142,7 +1152,7 @@ direct_io_worker(int rw, struct kiocb *i
 	 */
 	BUG_ON(ret == -EIOCBQUEUED);
 	if (dio->is_async && ret == 0 && dio->result &&
-	    ((rw & READ) || (dio->result == dio->size)))
+	    ((rw & READ) || (dio->result == sdio->size)))
 		ret = -EIOCBQUEUED;
 
 	if (ret != -EIOCBQUEUED)
@@ -1207,6 +1217,7 @@ __blockdev_direct_IO(int rw, struct kioc
 	ssize_t retval = -EINVAL;
 	loff_t end = offset;
 	struct dio *dio;
+	struct dio_submit sdio = { 0, };
 
 	if (rw & WRITE)
 		rw = WRITE_ODIRECT;
@@ -1286,7 +1297,7 @@ __blockdev_direct_IO(int rw, struct kioc
 
 	retval = direct_io_worker(rw, iocb, inode, iov, offset,
 				nr_segs, blkbits, get_block, end_io,
-				submit_io, dio);
+				  submit_io, dio, &sdio);
 
 out:
 	return retval;
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
brlocks-lglocks-clean-up-code.patch
brlocks-lglocks-clean-up-code-checkpatch-fixes.patch
hwpoison-convert-pr_debugs-to-pr_infos.patch
lib-bitmapc-quiet-sparse-noise-about-address-space.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
vfs-cache-request_queue-in-struct-block_device.patch
dio-optimize-cache-misses-in-the-submission-path-v2.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
dio-optimize-cache-misses-in-the-submission-path-v2-fix.patch

