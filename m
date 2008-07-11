From: akpm@linux-foundation.org
Subject: + splice-fix-race-with-page-invalidation.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:38:47 -0700
Message-ID: <200807111844.m6BIiSGU030895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752645AbYGKSoi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:44:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, hugh@veritas.com, nickpiggin@yahoo.com.au


The patch titled
     splice: fix race with page invalidation
has been added to the -mm tree.  Its filename is
     splice-fix-race-with-page-invalidation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: splice: fix race with page invalidation
From: Miklos Szeredi <mszeredi@suse.cz>

Brian Wang reported that a FUSE filesystem exported through NFS could return
I/O errors on read.  This was traced to splice_direct_to_actor() returning a
short or zero count when racing with page invalidation.

However this is not FUSE or NFSD specific, other filesystems (notably NFS)
also call invalidate_inode_pages2() to purge stale data from the cache.

If this happens while such pages are sitting in a pipe buffer, then splice(2)
from the pipe can return zero, and read(2) from the pipe can return ENODATA.

The zero return is especially bad, since it implies end-of-file or
disconnected pipe/socket, and is documented as such for splice.  But returning
an error for read() is also nasty, when in fact there was no error (data
becoming stale is not an error).

The same problems can be triggered by "hole punching" with
madvise(MADV_REMOVE).

This patch simply reuses the do_generic_file_read() infrastructure to collect
pages to be spliced into the pipe buffer.  This has the advantage of using
very well tested codepaths.  Other than fixing the above problem it also fixes
smaller issues with the previous generic_file_splice_read() implementation:

 - splice into the pipe racing with invalidate, resulting in similar
   symptoms as above
 - error handling bugs for some corner cases
 - AOP_TRUNCATED_PAGE handling

There are no real disadvantages: splice() from a file was originally meant to
be asynchronous, but in reality it only did that for non-readahead pages,
which does not usually happen.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c        |  286 +++++--------------------------------------
 include/linux/fs.h |    2 
 mm/filemap.c       |    2 
 3 files changed, 41 insertions(+), 249 deletions(-)

diff -puN fs/splice.c~splice-fix-race-with-page-invalidation fs/splice.c
--- a/fs/splice.c~splice-fix-race-with-page-invalidation
+++ a/fs/splice.c
@@ -87,53 +87,11 @@ static void page_cache_pipe_buf_release(
 	buf->flags &= ~PIPE_BUF_FLAG_LRU;
 }
 
-/*
- * Check whether the contents of buf is OK to access. Since the content
- * is a page cache page, IO may be in flight.
- */
-static int page_cache_pipe_buf_confirm(struct pipe_inode_info *pipe,
-				       struct pipe_buffer *buf)
-{
-	struct page *page = buf->page;
-	int err;
-
-	if (!PageUptodate(page)) {
-		lock_page(page);
-
-		/*
-		 * Page got truncated/unhashed. This will cause a 0-byte
-		 * splice, if this is the first page.
-		 */
-		if (!page->mapping) {
-			err = -ENODATA;
-			goto error;
-		}
-
-		/*
-		 * Uh oh, read-error from disk.
-		 */
-		if (!PageUptodate(page)) {
-			err = -EIO;
-			goto error;
-		}
-
-		/*
-		 * Page is ok afterall, we are done.
-		 */
-		unlock_page(page);
-	}
-
-	return 0;
-error:
-	unlock_page(page);
-	return err;
-}
-
 static const struct pipe_buf_operations page_cache_pipe_buf_ops = {
 	.can_merge = 0,
 	.map = generic_pipe_buf_map,
 	.unmap = generic_pipe_buf_unmap,
-	.confirm = page_cache_pipe_buf_confirm,
+	.confirm = generic_pipe_buf_confirm,
 	.release = page_cache_pipe_buf_release,
 	.steal = page_cache_pipe_buf_steal,
 	.get = generic_pipe_buf_get,
@@ -265,203 +223,26 @@ static void spd_release_page(struct spli
 	page_cache_release(spd->pages[i]);
 }
 
-static int
-__generic_file_splice_read(struct file *in, loff_t *ppos,
-			   struct pipe_inode_info *pipe, size_t len,
-			   unsigned int flags)
+static int file_splice_read_actor(read_descriptor_t *desc, struct page *page,
+				  unsigned long offset, unsigned long size)
 {
-	struct address_space *mapping = in->f_mapping;
-	unsigned int loff, nr_pages, req_pages;
-	struct page *pages[PIPE_BUFFERS];
-	struct partial_page partial[PIPE_BUFFERS];
-	struct page *page;
-	pgoff_t index, end_index;
-	loff_t isize;
-	int error, page_nr;
-	struct splice_pipe_desc spd = {
-		.pages = pages,
-		.partial = partial,
-		.flags = flags,
-		.ops = &page_cache_pipe_buf_ops,
-		.spd_release = spd_release_page,
-	};
+	struct splice_pipe_desc *spd = desc->arg.data;
+	unsigned long count = desc->count;
 
-	index = *ppos >> PAGE_CACHE_SHIFT;
-	loff = *ppos & ~PAGE_CACHE_MASK;
-	req_pages = (len + loff + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-	nr_pages = min(req_pages, (unsigned)PIPE_BUFFERS);
+	BUG_ON(spd->nr_pages >= PIPE_BUFFERS);
 
-	/*
-	 * Lookup the (hopefully) full range of pages we need.
-	 */
-	spd.nr_pages = find_get_pages_contig(mapping, index, nr_pages, pages);
-	index += spd.nr_pages;
+	if (size > count)
+		size = count;
 
-	/*
-	 * If find_get_pages_contig() returned fewer pages than we needed,
-	 * readahead/allocate the rest and fill in the holes.
-	 */
-	if (spd.nr_pages < nr_pages)
-		page_cache_sync_readahead(mapping, &in->f_ra, in,
-				index, req_pages - spd.nr_pages);
+	page_cache_get(page);
+	spd->pages[spd->nr_pages] = page;
+	spd->partial[spd->nr_pages].offset = offset;
+	spd->partial[spd->nr_pages].len = size;
+	spd->nr_pages++;
 
-	error = 0;
-	while (spd.nr_pages < nr_pages) {
-		/*
-		 * Page could be there, find_get_pages_contig() breaks on
-		 * the first hole.
-		 */
-		page = find_get_page(mapping, index);
-		if (!page) {
-			/*
-			 * page didn't exist, allocate one.
-			 */
-			page = page_cache_alloc_cold(mapping);
-			if (!page)
-				break;
+	desc->count = count - size;
 
-			error = add_to_page_cache_lru(page, mapping, index,
-						mapping_gfp_mask(mapping));
-			if (unlikely(error)) {
-				page_cache_release(page);
-				if (error == -EEXIST)
-					continue;
-				break;
-			}
-			/*
-			 * add_to_page_cache() locks the page, unlock it
-			 * to avoid convoluting the logic below even more.
-			 */
-			unlock_page(page);
-		}
-
-		pages[spd.nr_pages++] = page;
-		index++;
-	}
-
-	/*
-	 * Now loop over the map and see if we need to start IO on any
-	 * pages, fill in the partial map, etc.
-	 */
-	index = *ppos >> PAGE_CACHE_SHIFT;
-	nr_pages = spd.nr_pages;
-	spd.nr_pages = 0;
-	for (page_nr = 0; page_nr < nr_pages; page_nr++) {
-		unsigned int this_len;
-
-		if (!len)
-			break;
-
-		/*
-		 * this_len is the max we'll use from this page
-		 */
-		this_len = min_t(unsigned long, len, PAGE_CACHE_SIZE - loff);
-		page = pages[page_nr];
-
-		if (PageReadahead(page))
-			page_cache_async_readahead(mapping, &in->f_ra, in,
-					page, index, req_pages - page_nr);
-
-		/*
-		 * If the page isn't uptodate, we may need to start io on it
-		 */
-		if (!PageUptodate(page)) {
-			/*
-			 * If in nonblock mode then dont block on waiting
-			 * for an in-flight io page
-			 */
-			if (flags & SPLICE_F_NONBLOCK) {
-				if (TestSetPageLocked(page)) {
-					error = -EAGAIN;
-					break;
-				}
-			} else
-				lock_page(page);
-
-			/*
-			 * page was truncated, stop here. if this isn't the
-			 * first page, we'll just complete what we already
-			 * added
-			 */
-			if (!page->mapping) {
-				unlock_page(page);
-				break;
-			}
-			/*
-			 * page was already under io and is now done, great
-			 */
-			if (PageUptodate(page)) {
-				unlock_page(page);
-				goto fill_it;
-			}
-
-			/*
-			 * need to read in the page
-			 */
-			error = mapping->a_ops->readpage(in, page);
-			if (unlikely(error)) {
-				/*
-				 * We really should re-lookup the page here,
-				 * but it complicates things a lot. Instead
-				 * lets just do what we already stored, and
-				 * we'll get it the next time we are called.
-				 */
-				if (error == AOP_TRUNCATED_PAGE)
-					error = 0;
-
-				break;
-			}
-		}
-fill_it:
-		/*
-		 * i_size must be checked after PageUptodate.
-		 */
-		isize = i_size_read(mapping->host);
-		end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
-		if (unlikely(!isize || index > end_index))
-			break;
-
-		/*
-		 * if this is the last page, see if we need to shrink
-		 * the length and stop
-		 */
-		if (end_index == index) {
-			unsigned int plen;
-
-			/*
-			 * max good bytes in this page
-			 */
-			plen = ((isize - 1) & ~PAGE_CACHE_MASK) + 1;
-			if (plen <= loff)
-				break;
-
-			/*
-			 * force quit after adding this page
-			 */
-			this_len = min(this_len, plen - loff);
-			len = this_len;
-		}
-
-		partial[page_nr].offset = loff;
-		partial[page_nr].len = this_len;
-		len -= this_len;
-		loff = 0;
-		spd.nr_pages++;
-		index++;
-	}
-
-	/*
-	 * Release any pages at the end, if we quit early. 'page_nr' is how far
-	 * we got, 'nr_pages' is how many pages are in the map.
-	 */
-	while (page_nr < nr_pages)
-		page_cache_release(pages[page_nr++]);
-	in->f_ra.prev_pos = (loff_t)index << PAGE_CACHE_SHIFT;
-
-	if (spd.nr_pages)
-		return splice_to_pipe(pipe, &spd);
-
-	return error;
+	return size;
 }
 
 /**
@@ -482,24 +263,33 @@ ssize_t generic_file_splice_read(struct 
 				 struct pipe_inode_info *pipe, size_t len,
 				 unsigned int flags)
 {
-	loff_t isize, left;
-	int ret;
-
-	isize = i_size_read(in->f_mapping->host);
-	if (unlikely(*ppos >= isize))
-		return 0;
-
-	left = isize - *ppos;
-	if (unlikely(left < len))
-		len = left;
+	ssize_t ret;
+	loff_t pos = *ppos;
+	size_t offset = pos & ~PAGE_CACHE_MASK;
+	struct page *pages[PIPE_BUFFERS];
+	struct partial_page partial[PIPE_BUFFERS];
+	struct splice_pipe_desc spd = {
+		.pages = pages,
+		.partial = partial,
+		.flags = flags,
+		.ops = &page_cache_pipe_buf_ops,
+		.spd_release = spd_release_page,
+	};
+	read_descriptor_t desc = {
+		.count = min(len, (PIPE_BUFFERS << PAGE_CACHE_SHIFT) - offset),
+		.arg.data = &spd,
+	};
 
-	ret = __generic_file_splice_read(in, ppos, pipe, len, flags);
-	if (ret > 0)
-		*ppos += ret;
+	do_generic_file_read(in, &pos, &desc, file_splice_read_actor);
+	ret = desc.error;
+	if (spd.nr_pages) {
+		ret = splice_to_pipe(pipe, &spd);
+		if (ret > 0)
+			*ppos += ret;
+	}
 
 	return ret;
 }
-
 EXPORT_SYMBOL(generic_file_splice_read);
 
 /*
diff -puN include/linux/fs.h~splice-fix-race-with-page-invalidation include/linux/fs.h
--- a/include/linux/fs.h~splice-fix-race-with-page-invalidation
+++ a/include/linux/fs.h
@@ -1855,6 +1855,8 @@ extern ssize_t do_sync_read(struct file 
 extern ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos);
 extern int generic_segment_checks(const struct iovec *iov,
 		unsigned long *nr_segs, size_t *count, int access_flags);
+extern void do_generic_file_read(struct file *filp, loff_t *ppos,
+				 read_descriptor_t *desc, read_actor_t actor);
 
 /* fs/splice.c */
 extern ssize_t generic_file_splice_read(struct file *, loff_t *,
diff -puN mm/filemap.c~splice-fix-race-with-page-invalidation mm/filemap.c
--- a/mm/filemap.c~splice-fix-race-with-page-invalidation
+++ a/mm/filemap.c
@@ -891,7 +891,7 @@ static void shrink_readahead_size_eio(st
  * This is really ugly. But the goto's actually try to clarify some
  * of the logic when it comes to error handling etc.
  */
-static void do_generic_file_read(struct file *filp, loff_t *ppos,
+void do_generic_file_read(struct file *filp, loff_t *ppos,
 		read_descriptor_t *desc, read_actor_t actor)
 {
 	struct address_space *mapping = filp->f_mapping;
_

Patches currently in -mm which might be from mszeredi@suse.cz are

linux-next.patch
splice-fix-race-with-page-invalidation.patch
git-unprivileged-mounts.patch
hppfs-remove-hppfs_permission.patch
ecryptfs-string-copy-cleanup.patch
lockd-dont-return-eagain-for-a-permanent-error.patch
locks-add-special-return-value-for-asynchronous-locks.patch
locks-cleanup-code-duplication.patch
locks-allow-lock-to-return-file_lock_deferred.patch
fuse-prepare-lookup-for-nfs-export.patch
fuse-add-export-operations.patch
fuse-add-fuse_lookup_name-helper.patch
fuse-nfs-export-special-lookups.patch
fuse-lockd-support.patch

