From: akpm@linux-foundation.org
Subject: - consolidate-generic_writepages-and-mpage_writepages.patch removed from -mm tree
Date: Fri, 11 May 2007 22:34:07 -0700
Message-ID: <200705120534.l4C5Y7Tb002172@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755157AbXELFeV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:34:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     consolidate generic_writepages and mpage_writepages
has been removed from the -mm tree.  Its filename was
     consolidate-generic_writepages-and-mpage_writepages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: consolidate generic_writepages and mpage_writepages
From: Miklos Szeredi <mszeredi@suse.cz>

Clean up massive code duplication between mpage_writepages() and
generic_writepages().

The new generic function, write_cache_pages() takes a function pointer
argument, which will be called for each page to be written.

Maybe cifs_writepages() too can use this infrastructure, but I'm not
touching that with a ten-foot pole.

The upcoming page writeback support in fuse will also want this.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c                |  172 +++++++++---------------------------
 include/linux/mpage.h     |    1 
 include/linux/writeback.h |   10 +-
 mm/page-writeback.c       |   59 ++++++++----
 4 files changed, 92 insertions(+), 150 deletions(-)

diff -puN fs/mpage.c~consolidate-generic_writepages-and-mpage_writepages fs/mpage.c
--- a/fs/mpage.c~consolidate-generic_writepages-and-mpage_writepages
+++ a/fs/mpage.c
@@ -454,11 +454,18 @@ EXPORT_SYMBOL(mpage_readpage);
  * written, so it can intelligently allocate a suitably-sized BIO.  For now,
  * just allocate full-size (16-page) BIOs.
  */
-static struct bio *
-__mpage_writepage(struct bio *bio, struct page *page, get_block_t get_block,
-	sector_t *last_block_in_bio, int *ret, struct writeback_control *wbc,
-	writepage_t writepage_fn)
+struct mpage_data {
+	struct bio *bio;
+	sector_t last_block_in_bio;
+	get_block_t *get_block;
+	unsigned use_writepage;
+};
+
+static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
+			     void *data)
 {
+	struct mpage_data *mpd = data;
+	struct bio *bio = mpd->bio;
 	struct address_space *mapping = page->mapping;
 	struct inode *inode = page->mapping->host;
 	const unsigned blkbits = inode->i_blkbits;
@@ -476,6 +483,7 @@ __mpage_writepage(struct bio *bio, struc
 	int length;
 	struct buffer_head map_bh;
 	loff_t i_size = i_size_read(inode);
+	int ret = 0;
 
 	if (page_has_buffers(page)) {
 		struct buffer_head *head = page_buffers(page);
@@ -538,7 +546,7 @@ __mpage_writepage(struct bio *bio, struc
 
 		map_bh.b_state = 0;
 		map_bh.b_size = 1 << blkbits;
-		if (get_block(inode, block_in_file, &map_bh, 1))
+		if (mpd->get_block(inode, block_in_file, &map_bh, 1))
 			goto confused;
 		if (buffer_new(&map_bh))
 			unmap_underlying_metadata(map_bh.b_bdev,
@@ -584,7 +592,7 @@ page_is_mapped:
 	/*
 	 * This page will go to BIO.  Do we need to send this BIO off first?
 	 */
-	if (bio && *last_block_in_bio != blocks[0] - 1)
+	if (bio && mpd->last_block_in_bio != blocks[0] - 1)
 		bio = mpage_bio_submit(WRITE, bio);
 
 alloc_new:
@@ -641,7 +649,7 @@ alloc_new:
 					boundary_block, 1 << blkbits);
 		}
 	} else {
-		*last_block_in_bio = blocks[blocks_per_page - 1];
+		mpd->last_block_in_bio = blocks[blocks_per_page - 1];
 	}
 	goto out;
 
@@ -649,18 +657,19 @@ confused:
 	if (bio)
 		bio = mpage_bio_submit(WRITE, bio);
 
-	if (writepage_fn) {
-		*ret = (*writepage_fn)(page, wbc);
+	if (mpd->use_writepage) {
+		ret = mapping->a_ops->writepage(page, wbc);
 	} else {
-		*ret = -EAGAIN;
+		ret = -EAGAIN;
 		goto out;
 	}
 	/*
 	 * The caller has a ref on the inode, so *mapping is stable
 	 */
-	mapping_set_error(mapping, *ret);
+	mapping_set_error(mapping, ret);
 out:
-	return bio;
+	mpd->bio = bio;
+	return ret;
 }
 
 /**
@@ -683,120 +692,27 @@ out:
  * the call was made get new I/O started against them.  If wbc->sync_mode is
  * WB_SYNC_ALL then we were called for data integrity and we must wait for
  * existing IO to complete.
- *
- * If you fix this you should check generic_writepages() also!
  */
 int
 mpage_writepages(struct address_space *mapping,
 		struct writeback_control *wbc, get_block_t get_block)
 {
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
-	struct bio *bio = NULL;
-	sector_t last_block_in_bio = 0;
-	int ret = 0;
-	int done = 0;
-	int (*writepage)(struct page *page, struct writeback_control *wbc);
-	struct pagevec pvec;
-	int nr_pages;
-	pgoff_t index;
-	pgoff_t end;		/* Inclusive */
-	int scanned = 0;
-	int range_whole = 0;
-
-	if (wbc->nonblocking && bdi_write_congested(bdi)) {
-		wbc->encountered_congestion = 1;
-		return 0;
-	}
+	int ret;
 
-	writepage = NULL;
-	if (get_block == NULL)
-		writepage = mapping->a_ops->writepage;
-
-	pagevec_init(&pvec, 0);
-	if (wbc->range_cyclic) {
-		index = mapping->writeback_index; /* Start from prev offset */
-		end = -1;
-	} else {
-		index = wbc->range_start >> PAGE_CACHE_SHIFT;
-		end = wbc->range_end >> PAGE_CACHE_SHIFT;
-		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
-			range_whole = 1;
-		scanned = 1;
+	if (!get_block)
+		ret = generic_writepages(mapping, wbc);
+	else {
+		struct mpage_data mpd = {
+			.bio = NULL,
+			.last_block_in_bio = 0,
+			.get_block = get_block,
+			.use_writepage = 1,
+		};
+
+		ret = write_cache_pages(mapping, wbc, __mpage_writepage, &mpd);
+		if (mpd.bio)
+			mpage_bio_submit(WRITE, mpd.bio);
 	}
-retry:
-	while (!done && (index <= end) &&
-			(nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
-			PAGECACHE_TAG_DIRTY,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
-		unsigned i;
-
-		scanned = 1;
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
-
-			/*
-			 * At this point we hold neither mapping->tree_lock nor
-			 * lock on the page itself: the page may be truncated or
-			 * invalidated (changing page->mapping to NULL), or even
-			 * swizzled back from swapper_space to tmpfs file
-			 * mapping
-			 */
-
-			lock_page(page);
-
-			if (unlikely(page->mapping != mapping)) {
-				unlock_page(page);
-				continue;
-			}
-
-			if (!wbc->range_cyclic && page->index > end) {
-				done = 1;
-				unlock_page(page);
-				continue;
-			}
-
-			if (wbc->sync_mode != WB_SYNC_NONE)
-				wait_on_page_writeback(page);
-
-			if (PageWriteback(page) ||
-					!clear_page_dirty_for_io(page)) {
-				unlock_page(page);
-				continue;
-			}
-
-			if (writepage) {
-				ret = (*writepage)(page, wbc);
-				mapping_set_error(mapping, ret);
-			} else {
-				bio = __mpage_writepage(bio, page, get_block,
-						&last_block_in_bio, &ret, wbc,
-						page->mapping->a_ops->writepage);
-			}
-			if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE))
-				unlock_page(page);
-			if (ret || (--(wbc->nr_to_write) <= 0))
-				done = 1;
-			if (wbc->nonblocking && bdi_write_congested(bdi)) {
-				wbc->encountered_congestion = 1;
-				done = 1;
-			}
-		}
-		pagevec_release(&pvec);
-		cond_resched();
-	}
-	if (!scanned && !done) {
-		/*
-		 * We hit the last page and there is more work to be done: wrap
-		 * back to the start of the file
-		 */
-		scanned = 1;
-		index = 0;
-		goto retry;
-	}
-	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
-		mapping->writeback_index = index;
-	if (bio)
-		mpage_bio_submit(WRITE, bio);
 	return ret;
 }
 EXPORT_SYMBOL(mpage_writepages);
@@ -804,15 +720,15 @@ EXPORT_SYMBOL(mpage_writepages);
 int mpage_writepage(struct page *page, get_block_t get_block,
 	struct writeback_control *wbc)
 {
-	int ret = 0;
-	struct bio *bio;
-	sector_t last_block_in_bio = 0;
-
-	bio = __mpage_writepage(NULL, page, get_block,
-			&last_block_in_bio, &ret, wbc, NULL);
-	if (bio)
-		mpage_bio_submit(WRITE, bio);
-
+	struct mpage_data mpd = {
+		.bio = NULL,
+		.last_block_in_bio = 0,
+		.get_block = get_block,
+		.use_writepage = 0,
+	};
+	int ret = __mpage_writepage(page, wbc, &mpd);
+	if (mpd.bio)
+		mpage_bio_submit(WRITE, mpd.bio);
 	return ret;
 }
 EXPORT_SYMBOL(mpage_writepage);
diff -puN include/linux/mpage.h~consolidate-generic_writepages-and-mpage_writepages include/linux/mpage.h
--- a/include/linux/mpage.h~consolidate-generic_writepages-and-mpage_writepages
+++ a/include/linux/mpage.h
@@ -12,7 +12,6 @@
 #ifdef CONFIG_BLOCK
 
 struct writeback_control;
-typedef int (writepage_t)(struct page *page, struct writeback_control *wbc);
 
 int mpage_readpages(struct address_space *mapping, struct list_head *pages,
 				unsigned nr_pages, get_block_t get_block);
diff -puN include/linux/writeback.h~consolidate-generic_writepages-and-mpage_writepages include/linux/writeback.h
--- a/include/linux/writeback.h~consolidate-generic_writepages-and-mpage_writepages
+++ a/include/linux/writeback.h
@@ -111,9 +111,15 @@ balance_dirty_pages_ratelimited(struct a
 	balance_dirty_pages_ratelimited_nr(mapping, 1);
 }
 
+typedef int (*writepage_t)(struct page *page, struct writeback_control *wbc,
+				void *data);
+
 int pdflush_operation(void (*fn)(unsigned long), unsigned long arg0);
-extern int generic_writepages(struct address_space *mapping,
-			      struct writeback_control *wbc);
+int generic_writepages(struct address_space *mapping,
+		       struct writeback_control *wbc);
+int write_cache_pages(struct address_space *mapping,
+		      struct writeback_control *wbc, writepage_t writepage,
+		      void *data);
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc);
 int sync_page_range(struct inode *inode, struct address_space *mapping,
 			loff_t pos, loff_t count);
diff -puN mm/page-writeback.c~consolidate-generic_writepages-and-mpage_writepages mm/page-writeback.c
--- a/mm/page-writeback.c~consolidate-generic_writepages-and-mpage_writepages
+++ a/mm/page-writeback.c
@@ -588,31 +588,27 @@ void __init page_writeback_init(void)
 }
 
 /**
- * generic_writepages - walk the list of dirty pages of the given address space and writepage() all of them.
+ * write_cache_pages - walk the list of dirty pages of the given address space and write all of them.
  * @mapping: address space structure to write
  * @wbc: subtract the number of written pages from *@wbc->nr_to_write
+ * @writepage: function called for each page
+ * @data: data passed to writepage function
  *
- * This is a library function, which implements the writepages()
- * address_space_operation.
- *
- * If a page is already under I/O, generic_writepages() skips it, even
+ * If a page is already under I/O, write_cache_pages() skips it, even
  * if it's dirty.  This is desirable behaviour for memory-cleaning writeback,
  * but it is INCORRECT for data-integrity system calls such as fsync().  fsync()
  * and msync() need to guarantee that all the data which was dirty at the time
  * the call was made get new I/O started against them.  If wbc->sync_mode is
  * WB_SYNC_ALL then we were called for data integrity and we must wait for
  * existing IO to complete.
- *
- * Derived from mpage_writepages() - if you fix this you should check that
- * also!
  */
-int generic_writepages(struct address_space *mapping,
-		       struct writeback_control *wbc)
+int write_cache_pages(struct address_space *mapping,
+		      struct writeback_control *wbc, writepage_t writepage,
+		      void *data)
 {
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	int ret = 0;
 	int done = 0;
-	int (*writepage)(struct page *page, struct writeback_control *wbc);
 	struct pagevec pvec;
 	int nr_pages;
 	pgoff_t index;
@@ -625,12 +621,6 @@ int generic_writepages(struct address_sp
 		return 0;
 	}
 
-	writepage = mapping->a_ops->writepage;
-
-	/* deal with chardevs and other special file */
-	if (!writepage)
-		return 0;
-
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */
@@ -682,8 +672,7 @@ retry:
 				continue;
 			}
 
-			ret = (*writepage)(page, wbc);
-			mapping_set_error(mapping, ret);
+			ret = (*writepage)(page, wbc, data);
 
 			if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE))
 				unlock_page(page);
@@ -710,6 +699,38 @@ retry:
 		mapping->writeback_index = index;
 	return ret;
 }
+EXPORT_SYMBOL(write_cache_pages);
+
+/*
+ * Function used by generic_writepages to call the real writepage
+ * function and set the mapping flags on error
+ */
+static int __writepage(struct page *page, struct writeback_control *wbc,
+		       void *data)
+{
+	struct address_space *mapping = data;
+	int ret = mapping->a_ops->writepage(page, wbc);
+	mapping_set_error(mapping, ret);
+	return ret;
+}
+
+/**
+ * generic_writepages - walk the list of dirty pages of the given address space and writepage() all of them.
+ * @mapping: address space structure to write
+ * @wbc: subtract the number of written pages from *@wbc->nr_to_write
+ *
+ * This is a library function, which implements the writepages()
+ * address_space_operation.
+ */
+int generic_writepages(struct address_space *mapping,
+		       struct writeback_control *wbc)
+{
+	/* deal with chardevs and other special file */
+	if (!mapping->a_ops->writepage)
+		return 0;
+
+	return write_cache_pages(mapping, wbc, __writepage, mapping);
+}
 
 EXPORT_SYMBOL(generic_writepages);
 
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
