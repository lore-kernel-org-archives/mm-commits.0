From: akpm@linux-foundation.org
Subject: + tmpfs-refine-shmem_file_splice_read.patch added to -mm tree
Date: Fri, 17 Jun 2011 16:39:30 -0700
Message-ID: <201106172339.p5HNdU9R008217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759575Ab1FQXjc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jun 2011 19:39:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com


The patch titled
     tmpfs: refine shmem_file_splice_read
has been added to the -mm tree.  Its filename is
     tmpfs-refine-shmem_file_splice_read.patch

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
Subject: tmpfs: refine shmem_file_splice_read
From: Hugh Dickins <hughd@google.com>

Tidy up shmem_file_splice_read():

Remove readahead: okay, we could implement shmem readahead on swap,
but have never done so before, swap being the slow exceptional path.

Use shmem_getpage() instead of find_or_create_page() plus ->readpage().

Remove several comments: sorry, I found them more distracting than
helpful, and this will not be the reference version of splice_read().

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |  138 +++++++--------------------------------------------
 1 file changed, 19 insertions(+), 119 deletions(-)

diff -puN mm/shmem.c~tmpfs-refine-shmem_file_splice_read mm/shmem.c
--- a/mm/shmem.c~tmpfs-refine-shmem_file_splice_read
+++ a/mm/shmem.c
@@ -1850,6 +1850,7 @@ static ssize_t shmem_file_splice_read(st
 				unsigned int flags)
 {
 	struct address_space *mapping = in->f_mapping;
+	struct inode *inode = mapping->host;
 	unsigned int loff, nr_pages, req_pages;
 	struct page *pages[PIPE_DEF_BUFFERS];
 	struct partial_page partial[PIPE_DEF_BUFFERS];
@@ -1865,7 +1866,7 @@ static ssize_t shmem_file_splice_read(st
 		.spd_release = spd_release_page,
 	};
 
-	isize = i_size_read(in->f_mapping->host);
+	isize = i_size_read(inode);
 	if (unlikely(*ppos >= isize))
 		return 0;
 
@@ -1881,153 +1882,57 @@ static ssize_t shmem_file_splice_read(st
 	req_pages = (len + loff + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	nr_pages = min(req_pages, pipe->buffers);
 
-	/*
-	 * Lookup the (hopefully) full range of pages we need.
-	 */
 	spd.nr_pages = find_get_pages_contig(mapping, index,
 						nr_pages, spd.pages);
 	index += spd.nr_pages;
-
-	/*
-	 * If find_get_pages_contig() returned fewer pages than we needed,
-	 * readahead/allocate the rest and fill in the holes.
-	 */
-	if (spd.nr_pages < nr_pages)
-		page_cache_sync_readahead(mapping, &in->f_ra, in,
-				index, req_pages - spd.nr_pages);
-
 	error = 0;
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
-
-			error = add_to_page_cache_lru(page, mapping, index,
-						GFP_KERNEL);
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
 
+	while (spd.nr_pages < nr_pages) {
+		page = NULL;
+		error = shmem_getpage(inode, index, &page, SGP_CACHE, NULL);
+		if (error)
+			break;
+		unlock_page(page);
 		spd.pages[spd.nr_pages++] = page;
 		index++;
 	}
 
-	/*
-	 * Now loop over the map and see if we need to start IO on any
-	 * pages, fill in the partial map, etc.
-	 */
 	index = *ppos >> PAGE_CACHE_SHIFT;
 	nr_pages = spd.nr_pages;
 	spd.nr_pages = 0;
+
 	for (page_nr = 0; page_nr < nr_pages; page_nr++) {
 		unsigned int this_len;
 
 		if (!len)
 			break;
 
-		/*
-		 * this_len is the max we'll use from this page
-		 */
 		this_len = min_t(unsigned long, len, PAGE_CACHE_SIZE - loff);
 		page = spd.pages[page_nr];
 
-		if (PageReadahead(page))
-			page_cache_async_readahead(mapping, &in->f_ra, in,
-					page, index, req_pages - page_nr);
-
-		/*
-		 * If the page isn't uptodate, we may need to start io on it
-		 */
-		if (!PageUptodate(page)) {
-			lock_page(page);
-
-			/*
-			 * Page was truncated, or invalidated by the
-			 * filesystem.  Redo the find/create, but this time the
-			 * page is kept locked, so there's no chance of another
-			 * race with truncate/invalidate.
-			 */
-			if (!page->mapping) {
-				unlock_page(page);
-				page = find_or_create_page(mapping, index,
-						mapping_gfp_mask(mapping));
-
-				if (!page) {
-					error = -ENOMEM;
-					break;
-				}
-				page_cache_release(spd.pages[page_nr]);
-				spd.pages[page_nr] = page;
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
+		if (!PageUptodate(page) || page->mapping != mapping) {
+			page = NULL;
+			error = shmem_getpage(inode, index, &page,
+							SGP_CACHE, NULL);
+			if (error)
 				break;
-			}
+			unlock_page(page);
+			page_cache_release(spd.pages[page_nr]);
+			spd.pages[page_nr] = page;
 		}
-fill_it:
-		/*
-		 * i_size must be checked after PageUptodate.
-		 */
-		isize = i_size_read(mapping->host);
+
+		isize = i_size_read(inode);
 		end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
 		if (unlikely(!isize || index > end_index))
 			break;
 
-		/*
-		 * if this is the last page, see if we need to shrink
-		 * the length and stop
-		 */
 		if (end_index == index) {
 			unsigned int plen;
 
-			/*
-			 * max good bytes in this page
-			 */
 			plen = ((isize - 1) & ~PAGE_CACHE_MASK) + 1;
 			if (plen <= loff)
 				break;
 
-			/*
-			 * force quit after adding this page
-			 */
 			this_len = min(this_len, plen - loff);
 			len = this_len;
 		}
@@ -2040,13 +1945,8 @@ fill_it:
 		index++;
 	}
 
-	/*
-	 * Release any pages at the end, if we quit early. 'page_nr' is how far
-	 * we got, 'nr_pages' is how many pages are in the map.
-	 */
 	while (page_nr < nr_pages)
 		page_cache_release(spd.pages[page_nr++]);
-	in->f_ra.prev_pos = (loff_t)index << PAGE_CACHE_SHIFT;
 
 	if (spd.nr_pages)
 		error = splice_to_pipe(pipe, &spd);
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

