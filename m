From: akpm@linux-foundation.org
Subject: + tmpfs-clone-shmem_file_splice_read.patch added to -mm tree
Date: Fri, 17 Jun 2011 16:39:27 -0700
Message-ID: <201106172339.p5HNdSWO008214@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757478Ab1FQXji (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jun 2011 19:39:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, jaxboe@fusionio.com


The patch titled
     tmpfs: clone shmem_file_splice_read()
has been added to the -mm tree.  Its filename is
     tmpfs-clone-shmem_file_splice_read.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs: clone shmem_file_splice_read()
From: Hugh Dickins <hughd@google.com>

Copy __generic_file_splice_read() and generic_file_splice_read() from
fs/splice.c to shmem_file_splice_read() in mm/shmem.c.  Make
page_cache_pipe_buf_ops and spd_release_page() accessible to it.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c            |    4 
 include/linux/splice.h |    2 
 mm/shmem.c             |  218 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 221 insertions(+), 3 deletions(-)

diff -puN fs/splice.c~tmpfs-clone-shmem_file_splice_read fs/splice.c
--- a/fs/splice.c~tmpfs-clone-shmem_file_splice_read
+++ a/fs/splice.c
@@ -132,7 +132,7 @@ error:
 	return err;
 }
 
-static const struct pipe_buf_operations page_cache_pipe_buf_ops = {
+const struct pipe_buf_operations page_cache_pipe_buf_ops = {
 	.can_merge = 0,
 	.map = generic_pipe_buf_map,
 	.unmap = generic_pipe_buf_unmap,
@@ -264,7 +264,7 @@ ssize_t splice_to_pipe(struct pipe_inode
 	return ret;
 }
 
-static void spd_release_page(struct splice_pipe_desc *spd, unsigned int i)
+void spd_release_page(struct splice_pipe_desc *spd, unsigned int i)
 {
 	page_cache_release(spd->pages[i]);
 }
diff -puN include/linux/splice.h~tmpfs-clone-shmem_file_splice_read include/linux/splice.h
--- a/include/linux/splice.h~tmpfs-clone-shmem_file_splice_read
+++ a/include/linux/splice.h
@@ -88,5 +88,7 @@ extern ssize_t splice_direct_to_actor(st
 extern int splice_grow_spd(struct pipe_inode_info *, struct splice_pipe_desc *);
 extern void splice_shrink_spd(struct pipe_inode_info *,
 				struct splice_pipe_desc *);
+extern void spd_release_page(struct splice_pipe_desc *, unsigned int);
 
+extern const struct pipe_buf_operations page_cache_pipe_buf_ops;
 #endif
diff -puN mm/shmem.c~tmpfs-clone-shmem_file_splice_read mm/shmem.c
--- a/mm/shmem.c~tmpfs-clone-shmem_file_splice_read
+++ a/mm/shmem.c
@@ -51,6 +51,7 @@ static struct vfsmount *shm_mnt;
 #include <linux/shmem_fs.h>
 #include <linux/writeback.h>
 #include <linux/blkdev.h>
+#include <linux/splice.h>
 #include <linux/security.h>
 #include <linux/swapops.h>
 #include <linux/mempolicy.h>
@@ -1844,6 +1845,221 @@ static ssize_t shmem_file_aio_read(struc
 	return retval;
 }
 
+static ssize_t shmem_file_splice_read(struct file *in, loff_t *ppos,
+				struct pipe_inode_info *pipe, size_t len,
+				unsigned int flags)
+{
+	struct address_space *mapping = in->f_mapping;
+	unsigned int loff, nr_pages, req_pages;
+	struct page *pages[PIPE_DEF_BUFFERS];
+	struct partial_page partial[PIPE_DEF_BUFFERS];
+	struct page *page;
+	pgoff_t index, end_index;
+	loff_t isize, left;
+	int error, page_nr;
+	struct splice_pipe_desc spd = {
+		.pages = pages,
+		.partial = partial,
+		.flags = flags,
+		.ops = &page_cache_pipe_buf_ops,
+		.spd_release = spd_release_page,
+	};
+
+	isize = i_size_read(in->f_mapping->host);
+	if (unlikely(*ppos >= isize))
+		return 0;
+
+	left = isize - *ppos;
+	if (unlikely(left < len))
+		len = left;
+
+	if (splice_grow_spd(pipe, &spd))
+		return -ENOMEM;
+
+	index = *ppos >> PAGE_CACHE_SHIFT;
+	loff = *ppos & ~PAGE_CACHE_MASK;
+	req_pages = (len + loff + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	nr_pages = min(req_pages, pipe->buffers);
+
+	/*
+	 * Lookup the (hopefully) full range of pages we need.
+	 */
+	spd.nr_pages = find_get_pages_contig(mapping, index,
+						nr_pages, spd.pages);
+	index += spd.nr_pages;
+
+	/*
+	 * If find_get_pages_contig() returned fewer pages than we needed,
+	 * readahead/allocate the rest and fill in the holes.
+	 */
+	if (spd.nr_pages < nr_pages)
+		page_cache_sync_readahead(mapping, &in->f_ra, in,
+				index, req_pages - spd.nr_pages);
+
+	error = 0;
+	while (spd.nr_pages < nr_pages) {
+		/*
+		 * Page could be there, find_get_pages_contig() breaks on
+		 * the first hole.
+		 */
+		page = find_get_page(mapping, index);
+		if (!page) {
+			/*
+			 * page didn't exist, allocate one.
+			 */
+			page = page_cache_alloc_cold(mapping);
+			if (!page)
+				break;
+
+			error = add_to_page_cache_lru(page, mapping, index,
+						GFP_KERNEL);
+			if (unlikely(error)) {
+				page_cache_release(page);
+				if (error == -EEXIST)
+					continue;
+				break;
+			}
+			/*
+			 * add_to_page_cache() locks the page, unlock it
+			 * to avoid convoluting the logic below even more.
+			 */
+			unlock_page(page);
+		}
+
+		spd.pages[spd.nr_pages++] = page;
+		index++;
+	}
+
+	/*
+	 * Now loop over the map and see if we need to start IO on any
+	 * pages, fill in the partial map, etc.
+	 */
+	index = *ppos >> PAGE_CACHE_SHIFT;
+	nr_pages = spd.nr_pages;
+	spd.nr_pages = 0;
+	for (page_nr = 0; page_nr < nr_pages; page_nr++) {
+		unsigned int this_len;
+
+		if (!len)
+			break;
+
+		/*
+		 * this_len is the max we'll use from this page
+		 */
+		this_len = min_t(unsigned long, len, PAGE_CACHE_SIZE - loff);
+		page = spd.pages[page_nr];
+
+		if (PageReadahead(page))
+			page_cache_async_readahead(mapping, &in->f_ra, in,
+					page, index, req_pages - page_nr);
+
+		/*
+		 * If the page isn't uptodate, we may need to start io on it
+		 */
+		if (!PageUptodate(page)) {
+			lock_page(page);
+
+			/*
+			 * Page was truncated, or invalidated by the
+			 * filesystem.  Redo the find/create, but this time the
+			 * page is kept locked, so there's no chance of another
+			 * race with truncate/invalidate.
+			 */
+			if (!page->mapping) {
+				unlock_page(page);
+				page = find_or_create_page(mapping, index,
+						mapping_gfp_mask(mapping));
+
+				if (!page) {
+					error = -ENOMEM;
+					break;
+				}
+				page_cache_release(spd.pages[page_nr]);
+				spd.pages[page_nr] = page;
+			}
+			/*
+			 * page was already under io and is now done, great
+			 */
+			if (PageUptodate(page)) {
+				unlock_page(page);
+				goto fill_it;
+			}
+
+			/*
+			 * need to read in the page
+			 */
+			error = mapping->a_ops->readpage(in, page);
+			if (unlikely(error)) {
+				/*
+				 * We really should re-lookup the page here,
+				 * but it complicates things a lot. Instead
+				 * lets just do what we already stored, and
+				 * we'll get it the next time we are called.
+				 */
+				if (error == AOP_TRUNCATED_PAGE)
+					error = 0;
+
+				break;
+			}
+		}
+fill_it:
+		/*
+		 * i_size must be checked after PageUptodate.
+		 */
+		isize = i_size_read(mapping->host);
+		end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
+		if (unlikely(!isize || index > end_index))
+			break;
+
+		/*
+		 * if this is the last page, see if we need to shrink
+		 * the length and stop
+		 */
+		if (end_index == index) {
+			unsigned int plen;
+
+			/*
+			 * max good bytes in this page
+			 */
+			plen = ((isize - 1) & ~PAGE_CACHE_MASK) + 1;
+			if (plen <= loff)
+				break;
+
+			/*
+			 * force quit after adding this page
+			 */
+			this_len = min(this_len, plen - loff);
+			len = this_len;
+		}
+
+		spd.partial[page_nr].offset = loff;
+		spd.partial[page_nr].len = this_len;
+		len -= this_len;
+		loff = 0;
+		spd.nr_pages++;
+		index++;
+	}
+
+	/*
+	 * Release any pages at the end, if we quit early. 'page_nr' is how far
+	 * we got, 'nr_pages' is how many pages are in the map.
+	 */
+	while (page_nr < nr_pages)
+		page_cache_release(spd.pages[page_nr++]);
+	in->f_ra.prev_pos = (loff_t)index << PAGE_CACHE_SHIFT;
+
+	if (spd.nr_pages)
+		error = splice_to_pipe(pipe, &spd);
+
+	splice_shrink_spd(pipe, &spd);
+
+	if (error > 0) {
+		*ppos += error;
+		file_accessed(in);
+	}
+	return error;
+}
+
 static int shmem_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(dentry->d_sb);
@@ -2699,7 +2915,7 @@ static const struct file_operations shme
 	.aio_read	= shmem_file_aio_read,
 	.aio_write	= generic_file_aio_write,
 	.fsync		= noop_fsync,
-	.splice_read	= generic_file_splice_read,
+	.splice_read	= shmem_file_splice_read,
 	.splice_write	= generic_file_splice_write,
 #endif
 };
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-move-vmtruncate_range-to-truncatec.patch
mm-move-shmem-prototypes-to-shmem_fsh.patch
tmpfs-take-control-of-its-truncate_range.patch
tmpfs-add-shmem_read_mapping_page_gfp.patch
drm-ttm-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_truncate_range.patch
drm-i915-more-struct_mutex-locking.patch
drm-i915-more-struct_mutex-locking-fix.patch
mm-cleanup-descriptions-of-filler-arg.patch
mm-truncate-functions-are-in-truncatec.patch
mm-tidy-vmtruncate_range-and-related-functions.patch
mm-consistent-truncate-and-invalidate-loops.patch
mm-pincer-in-truncate_inode_pages_range.patch
tmpfs-no-need-to-use-i_lock.patch
linux-next.patch
tmpfs-clone-shmem_file_splice_read.patch
tmpfs-refine-shmem_file_splice_read.patch
tmpfs-pass-gfp-to-shmem_getpage_gfp.patch
tmpfs-remove_shmem_readpage.patch
tmpfs-simplify-prealloc_page.patch
tmpfs-simplify-filepage-swappage.patch
tmpfs-simplify-unuse-and-writepage.patch
radix_tree-exceptional-entries-and-indices.patch
mm-let-swap-use-exceptional-entries.patch
tmpfs-demolish-old-swap-vector-support.patch
tmpfs-miscellaneous-trivial-cleanups.patch
tmpfs-copy-truncate_inode_pages_range.patch
tmpfs-convert-shmem_truncate_range-to-radix-swap.patch
tmpfs-convert-shmem_unuse_inode-to-radix-swap.patch
tmpfs-convert-shmem_getpage_gfp-to-radix-swap.patch
tmpfs-convert-mem_cgroup-shmem-to-radix-swap.patch
tmpfs-convert-shmem_writepage-and-enable-swap.patch
tmpfs-use-kmemdup-for-short-symlinks.patch
mm-a-few-small-updates-for-radix-swap.patch
prio_tree-debugging-patch.patch

