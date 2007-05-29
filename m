From: akpm@linux-foundation.org
Subject: + mm-buffered-write-cleanup.patch added to -mm tree
Date: Tue, 29 May 2007 14:19:45 -0700
Message-ID: <200705292119.l4TLJjZX011708@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752409AbXE2VTv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:19:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     mm: buffered write cleanup
has been added to the -mm tree.  Its filename is
     mm-buffered-write-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: buffered write cleanup
From: Nick Piggin <npiggin@suse.de>

Quite a bit of code is used in maintaining these "cached pages" that are
probably pretty unlikely to get used. It would require a narrow race where
the page is inserted concurrently while this process is allocating a page
in order to create the spare page. Then a multi-page write into an uncached
part of the file, to make use of it.

Next, the buffered write path (and others) uses its own LRU pagevec when it
should be just using the per-CPU LRU pagevec (which will cut down on both data
and code size cacheline footprint). Also, these private LRU pagevecs are
emptied after just a very short time, in contrast with the per-CPU pagevecs
that are persistent. Net result: 7.3 times fewer lru_lock acquisitions required
to add the pages to pagecache for a bulk write (in 4K chunks).

[this gets rid of some cond_resched() calls in readahead.c and mpage.c due
 to clashes in -mm. What put them there, and why? ]

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c     |   10 ---
 mm/filemap.c   |  145 ++++++++++++++++++-----------------------------
 mm/readahead.c |   24 ++-----
 3 files changed, 66 insertions(+), 113 deletions(-)

diff -puN fs/mpage.c~mm-buffered-write-cleanup fs/mpage.c
--- a/fs/mpage.c~mm-buffered-write-cleanup
+++ a/fs/mpage.c
@@ -387,31 +387,25 @@ mpage_readpages(struct address_space *ma
 	struct bio *bio = NULL;
 	unsigned page_idx;
 	sector_t last_block_in_bio = 0;
-	struct pagevec lru_pvec;
 	struct buffer_head map_bh;
 	unsigned long first_logical_block = 0;
 
 	clear_buffer_mapped(&map_bh);
-	pagevec_init(&lru_pvec, 0);
 	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
 		struct page *page = list_entry(pages->prev, struct page, lru);
 
 		prefetchw(&page->flags);
 		list_del(&page->lru);
-		if (!add_to_page_cache(page, mapping,
+		if (!add_to_page_cache_lru(page, mapping,
 					page->index, GFP_KERNEL)) {
 			bio = do_mpage_readpage(bio, page,
 					nr_pages - page_idx,
 					&last_block_in_bio, &map_bh,
 					&first_logical_block,
 					get_block);
-			if (!pagevec_add(&lru_pvec, page))
-				__pagevec_lru_add(&lru_pvec);
-		} else {
-			page_cache_release(page);
 		}
+		page_cache_release(page);
 	}
-	pagevec_lru_add(&lru_pvec);
 	BUG_ON(!list_empty(pages));
 	if (bio)
 		mpage_bio_submit(READ, bio);
diff -puN mm/filemap.c~mm-buffered-write-cleanup mm/filemap.c
--- a/mm/filemap.c~mm-buffered-write-cleanup
+++ a/mm/filemap.c
@@ -665,27 +665,22 @@ EXPORT_SYMBOL(find_lock_page);
 struct page *find_or_create_page(struct address_space *mapping,
 		unsigned long index, gfp_t gfp_mask)
 {
-	struct page *page, *cached_page = NULL;
+	struct page *page;
 	int err;
 repeat:
 	page = find_lock_page(mapping, index);
 	if (!page) {
-		if (!cached_page) {
-			cached_page =
-				__page_cache_alloc(gfp_mask);
-			if (!cached_page)
-				return NULL;
-		}
-		err = add_to_page_cache_lru(cached_page, mapping,
-					index, gfp_mask);
-		if (!err) {
-			page = cached_page;
-			cached_page = NULL;
-		} else if (err == -EEXIST)
-			goto repeat;
+		page = __page_cache_alloc(gfp_mask);
+		if (!page)
+			return NULL;
+		err = add_to_page_cache_lru(page, mapping, index, gfp_mask);
+		if (unlikely(err)) {
+			page_cache_release(page);
+			page = NULL;
+			if (err == -EEXIST)
+				goto repeat;
+		}
 	}
-	if (cached_page)
-		page_cache_release(cached_page);
 	return page;
 }
 EXPORT_SYMBOL(find_or_create_page);
@@ -874,11 +869,9 @@ void do_generic_mapping_read(struct addr
 	unsigned long prev_index;
 	unsigned int prev_offset;
 	loff_t isize;
-	struct page *cached_page;
 	int error;
 	struct file_ra_state ra = *_ra;
 
-	cached_page = NULL;
 	index = *ppos >> PAGE_CACHE_SHIFT;
 	next_index = index;
 	prev_index = ra.prev_index;
@@ -1045,23 +1038,20 @@ no_cached_page:
 		 * Ok, it wasn't cached, so we need to create a new
 		 * page..
 		 */
-		if (!cached_page) {
-			cached_page = page_cache_alloc_cold(mapping);
-			if (!cached_page) {
-				desc->error = -ENOMEM;
-				goto out;
-			}
+		page = page_cache_alloc_cold(mapping);
+		if (!page) {
+			desc->error = -ENOMEM;
+			goto out;
 		}
-		error = add_to_page_cache_lru(cached_page, mapping,
+		error = add_to_page_cache_lru(page, mapping,
 						index, GFP_KERNEL);
 		if (error) {
+			page_cache_release(page);
 			if (error == -EEXIST)
 				goto find_page;
 			desc->error = error;
 			goto out;
 		}
-		page = cached_page;
-		cached_page = NULL;
 		goto readpage;
 	}
 
@@ -1069,8 +1059,6 @@ out:
 	*_ra = ra;
 
 	*ppos = ((loff_t) index << PAGE_CACHE_SHIFT) + offset;
-	if (cached_page)
-		page_cache_release(cached_page);
 	if (filp)
 		file_accessed(filp);
 }
@@ -1553,35 +1541,28 @@ static struct page *__read_cache_page(st
 				int (*filler)(void *,struct page*),
 				void *data)
 {
-	struct page *page, *cached_page = NULL;
+	struct page *page;
 	int err;
 repeat:
 	page = find_get_page(mapping, index);
 	if (!page) {
-		if (!cached_page) {
-			cached_page = page_cache_alloc_cold(mapping);
-			if (!cached_page)
-				return ERR_PTR(-ENOMEM);
-		}
-		err = add_to_page_cache_lru(cached_page, mapping,
-					index, GFP_KERNEL);
-		if (err == -EEXIST)
-			goto repeat;
-		if (err < 0) {
+		page = page_cache_alloc_cold(mapping);
+		if (!page)
+			return ERR_PTR(-ENOMEM);
+		err = add_to_page_cache_lru(page, mapping, index, GFP_KERNEL);
+		if (unlikely(err)) {
+			page_cache_release(page);
+			if (err == -EEXIST)
+				goto repeat;
 			/* Presumably ENOMEM for radix tree node */
-			page_cache_release(cached_page);
 			return ERR_PTR(err);
 		}
-		page = cached_page;
-		cached_page = NULL;
 		err = filler(data, page);
 		if (err < 0) {
 			page_cache_release(page);
 			page = ERR_PTR(err);
 		}
 	}
-	if (cached_page)
-		page_cache_release(cached_page);
 	return page;
 }
 
@@ -1659,40 +1640,6 @@ struct page *read_cache_page(struct addr
 EXPORT_SYMBOL(read_cache_page);
 
 /*
- * If the page was newly created, increment its refcount and add it to the
- * caller's lru-buffering pagevec.  This function is specifically for
- * generic_file_write().
- */
-static inline struct page *
-__grab_cache_page(struct address_space *mapping, unsigned long index,
-			struct page **cached_page, struct pagevec *lru_pvec)
-{
-	int err;
-	struct page *page;
-repeat:
-	page = find_lock_page(mapping, index);
-	if (!page) {
-		if (!*cached_page) {
-			*cached_page = page_cache_alloc(mapping);
-			if (!*cached_page)
-				return NULL;
-		}
-		err = add_to_page_cache(*cached_page, mapping,
-					index, GFP_KERNEL);
-		if (err == -EEXIST)
-			goto repeat;
-		if (err == 0) {
-			page = *cached_page;
-			page_cache_get(page);
-			if (!pagevec_add(lru_pvec, page))
-				__pagevec_lru_add(lru_pvec);
-			*cached_page = NULL;
-		}
-	}
-	return page;
-}
-
-/*
  * The logic we want is
  *
  *	if suid or (sgid and xgrp)
@@ -1886,6 +1833,33 @@ generic_file_direct_write(struct kiocb *
 }
 EXPORT_SYMBOL(generic_file_direct_write);
 
+/*
+ * Find or create a page at the given pagecache position. Return the locked
+ * page. This function is specifically for buffered writes.
+ */
+static struct page *__grab_cache_page(struct address_space *mapping,
+							pgoff_t index)
+{
+	int status;
+	struct page *page;
+repeat:
+	page = find_lock_page(mapping, index);
+	if (likely(page))
+		return page;
+
+	page = page_cache_alloc(mapping);
+	if (!page)
+		return NULL;
+	status = add_to_page_cache_lru(page, mapping, index, GFP_KERNEL);
+	if (unlikely(status)) {
+		page_cache_release(page);
+		if (status == -EEXIST)
+			goto repeat;
+		return NULL;
+	}
+	return page;
+}
+
 ssize_t
 generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
 		unsigned long nr_segs, loff_t pos, loff_t *ppos,
@@ -1896,15 +1870,10 @@ generic_file_buffered_write(struct kiocb
 	const struct address_space_operations *a_ops = mapping->a_ops;
 	struct inode 	*inode = mapping->host;
 	long		status = 0;
-	struct page	*page;
-	struct page	*cached_page = NULL;
-	struct pagevec	lru_pvec;
 	const struct iovec *cur_iov = iov; /* current iovec */
 	size_t		iov_offset = 0;	   /* offset in the current iovec */
 	char __user	*buf;
 
-	pagevec_init(&lru_pvec, 0);
-
 	/*
 	 * handle partial DIO write.  Adjust cur_iov if needed.
 	 */
@@ -1916,6 +1885,7 @@ generic_file_buffered_write(struct kiocb
 	}
 
 	do {
+		struct page *page;
 		pgoff_t index;		/* Pagecache index for current page */
 		unsigned long offset;	/* Offset into pagecache page */
 		unsigned long maxlen;	/* Bytes remaining in current iovec */
@@ -1942,7 +1912,8 @@ generic_file_buffered_write(struct kiocb
 		fault_in_pages_readable(buf, maxlen);
 #endif
 
-		page = __grab_cache_page(mapping,index,&cached_page,&lru_pvec);
+
+		page = __grab_cache_page(mapping, index);
 		if (!page) {
 			status = -ENOMEM;
 			break;
@@ -2010,9 +1981,6 @@ fs_write_aop_error:
 	} while (count);
 	*ppos = pos;
 
-	if (cached_page)
-		page_cache_release(cached_page);
-
 	/*
 	 * For now, when the user asks for O_SYNC, we'll actually give O_DSYNC
 	 */
@@ -2032,7 +2000,6 @@ fs_write_aop_error:
 	if (unlikely(file->f_flags & O_DIRECT) && written)
 		status = filemap_write_and_wait(mapping);
 
-	pagevec_lru_add(&lru_pvec);
 	return written ? written : status;
 }
 EXPORT_SYMBOL(generic_file_buffered_write);
diff -puN mm/readahead.c~mm-buffered-write-cleanup mm/readahead.c
--- a/mm/readahead.c~mm-buffered-write-cleanup
+++ a/mm/readahead.c
@@ -133,28 +133,25 @@ int read_cache_pages(struct address_spac
 			int (*filler)(void *, struct page *), void *data)
 {
 	struct page *page;
-	struct pagevec lru_pvec;
 	int ret = 0;
 
-	pagevec_init(&lru_pvec, 0);
-
 	while (!list_empty(pages)) {
 		page = list_to_page(pages);
 		list_del(&page->lru);
-		if (add_to_page_cache(page, mapping, page->index, GFP_KERNEL)) {
+		if (add_to_page_cache_lru(page, mapping,
+					page->index, GFP_KERNEL)) {
 			page_cache_release(page);
 			continue;
 		}
+		page_cache_release(page);
+
 		ret = filler(data, page);
-		if (!pagevec_add(&lru_pvec, page))
-			__pagevec_lru_add(&lru_pvec);
-		if (ret) {
+		if (unlikely(ret)) {
 			put_pages_list(pages);
 			break;
 		}
 		task_io_account_read(PAGE_CACHE_SIZE);
 	}
-	pagevec_lru_add(&lru_pvec);
 	return ret;
 }
 
@@ -164,7 +161,6 @@ static int read_pages(struct address_spa
 		struct list_head *pages, unsigned nr_pages)
 {
 	unsigned page_idx;
-	struct pagevec lru_pvec;
 	int ret;
 
 	if (mapping->a_ops->readpages) {
@@ -174,19 +170,15 @@ static int read_pages(struct address_spa
 		goto out;
 	}
 
-	pagevec_init(&lru_pvec, 0);
 	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
 		struct page *page = list_to_page(pages);
 		list_del(&page->lru);
-		if (!add_to_page_cache(page, mapping,
+		if (!add_to_page_cache_lru(page, mapping,
 					page->index, GFP_KERNEL)) {
 			mapping->a_ops->readpage(filp, page);
-			if (!pagevec_add(&lru_pvec, page))
-				__pagevec_lru_add(&lru_pvec);
-		} else
-			page_cache_release(page);
+		}
+		page_cache_release(page);
 	}
-	pagevec_lru_add(&lru_pvec);
 	ret = 0;
 out:
 	return ret;
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
git-arm-master.patch
slob-rework-freelist-handling.patch
slob-remove-bigblock-tracking.patch
slob-improved-alignment-handling.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
mm-debug-write-deadlocks.patch
mm-trim-more-holes.patch
mm-buffered-write-cleanup.patch
mm-write-iovec-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
mm-buffered-write-iterator.patch
fs-fix-data-loss-on-error.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
mm-restore-kernel_ds-optimisations.patch
implement-simple-fs-aops.patch
block_dev-convert-to-new-aops.patch
ext2-convert-to-new-aops.patch
ext3-convert-to-new-aops.patch
ext4-convert-to-new-aops.patch
xfs-convert-to-new-aops.patch
fs-new-cont-helpers.patch
fat-convert-to-new-aops.patch
hfs-convert-to-new-aops.patch
hfsplus-convert-to-new-aops.patch
hpfs-convert-to-new-aops.patch
bfs-convert-to-new-aops.patch
qnx4-convert-to-new-aops.patch
reiserfs-use-generic-write.patch
reiserfs-convert-to-new-aops.patch
reiserfs-use-generic_cont_expand_simple.patch
with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
nfs-convert-to-new-aops.patch
smb-convert-to-new-aops.patch
fuse-convert-to-new-aops.patch
hostfs-convert-to-new-aops.patch
jffs2-convert-to-new-aops.patch
ufs-convert-to-new-aops.patch
udf-convert-to-new-aops.patch
sysv-convert-to-new-aops.patch
minix-convert-to-new-aops.patch
jfs-convert-to-new-aops.patch
mm-document-fault_data-and-flags.patch
fs-introduce-some-page-buffer-invariants.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
