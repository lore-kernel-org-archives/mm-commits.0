From: akpm@linux-foundation.org
Subject: - readahead-code-cleanup.patch removed from -mm tree
Date: Mon, 07 May 2007 17:02:35 -0700
Message-ID: <200705080002.l4802Zd1008854@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967323AbXEHADF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:03:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, nickpiggin@yahoo.com.au, wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: code cleanup
has been removed from the -mm tree.  Its filename was
     readahead-code-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: readahead: code cleanup
From: Jan Kara <jack@suse.cz>

Rename file_ra_state.prev_page to prev_index and file_ra_state.offset to
prev_offset.  Also update of prev_index in do_generic_mapping_read() is now
moved close to the update of prev_offset.

[wfg@mail.ustc.edu.cn: fix it]
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: WU Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    4 ++--
 mm/filemap.c       |    7 ++++---
 mm/readahead.c     |   30 +++++++++++++++---------------
 3 files changed, 21 insertions(+), 20 deletions(-)

diff -puN include/linux/fs.h~readahead-code-cleanup include/linux/fs.h
--- a/include/linux/fs.h~readahead-code-cleanup
+++ a/include/linux/fs.h
@@ -696,13 +696,13 @@ struct file_ra_state {
 	unsigned long size;
 	unsigned long flags;		/* ra flags RA_FLAG_xxx*/
 	unsigned long cache_hit;	/* cache hit count*/
-	unsigned long prev_page;	/* Cache last read() position */
+	unsigned long prev_index;	/* Cache last read() position */
 	unsigned long ahead_start;	/* Ahead window */
 	unsigned long ahead_size;
 	unsigned long ra_pages;		/* Maximum readahead window */
 	unsigned long mmap_hit;		/* Cache hit stat for mmap accesses */
 	unsigned long mmap_miss;	/* Cache miss stat for mmap accesses */
-	unsigned int offset;		/* Offset where last read() ended in a page */
+	unsigned int prev_offset;	/* Offset where last read() ended in a page */
 };
 #define RA_FLAG_MISS 0x01	/* a cache miss occured against this file */
 #define RA_FLAG_INCACHE 0x02	/* file is already in cache */
diff -puN mm/filemap.c~readahead-code-cleanup mm/filemap.c
--- a/mm/filemap.c~readahead-code-cleanup
+++ a/mm/filemap.c
@@ -877,8 +877,8 @@ void do_generic_mapping_read(struct addr
 	cached_page = NULL;
 	index = *ppos >> PAGE_CACHE_SHIFT;
 	next_index = index;
-	prev_index = ra.prev_page;
-	prev_offset = ra.offset;
+	prev_index = ra.prev_index;
+	prev_offset = ra.prev_offset;
 	last_index = (*ppos + desc->count + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
 	offset = *ppos & ~PAGE_CACHE_MASK;
 
@@ -947,7 +947,8 @@ page_ok:
 		offset += ret;
 		index += offset >> PAGE_CACHE_SHIFT;
 		offset &= ~PAGE_CACHE_MASK;
-		prev_offset = ra.offset = offset;
+		prev_offset = offset;
+		ra.prev_offset = offset;
 
 		page_cache_release(page);
 		if (ret == nr && desc->count)
diff -puN mm/readahead.c~readahead-code-cleanup mm/readahead.c
--- a/mm/readahead.c~readahead-code-cleanup
+++ a/mm/readahead.c
@@ -37,7 +37,7 @@ void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping)
 {
 	ra->ra_pages = mapping->backing_dev_info->ra_pages;
-	ra->prev_page = -1;
+	ra->prev_index = -1;
 }
 EXPORT_SYMBOL_GPL(file_ra_state_init);
 
@@ -202,19 +202,19 @@ out:
  * size:	Number of pages in that read
  *              Together, these form the "current window".
  *              Together, start and size represent the `readahead window'.
- * prev_page:   The page which the readahead algorithm most-recently inspected.
+ * prev_index:  The page which the readahead algorithm most-recently inspected.
  *              It is mainly used to detect sequential file reading.
  *              If page_cache_readahead sees that it is again being called for
  *              a page which it just looked at, it can return immediately without
  *              making any state changes.
- * offset:      Offset in the prev_page where the last read ended - used for
+ * offset:      Offset in the prev_index where the last read ended - used for
  *              detection of sequential file reading.
  * ahead_start,
  * ahead_size:  Together, these form the "ahead window".
  * ra_pages:	The externally controlled max readahead for this fd.
  *
  * When readahead is in the off state (size == 0), readahead is disabled.
- * In this state, prev_page is used to detect the resumption of sequential I/O.
+ * In this state, prev_index is used to detect the resumption of sequential I/O.
  *
  * The readahead code manages two windows - the "current" and the "ahead"
  * windows.  The intent is that while the application is walking the pages
@@ -417,7 +417,7 @@ static int make_ahead_window(struct addr
 	ra->ahead_size = get_next_ra_size(ra);
 	ra->ahead_start = ra->start + ra->size;
 
-	block = force || (ra->prev_page >= ra->ahead_start);
+	block = force || (ra->prev_index >= ra->ahead_start);
 	ret = blockable_page_cache_readahead(mapping, filp,
 			ra->ahead_start, ra->ahead_size, ra, block);
 
@@ -469,13 +469,13 @@ page_cache_readahead(struct address_spac
 	 * We avoid doing extra work and bogusly perturbing the readahead
 	 * window expansion logic.
 	 */
-	if (offset == ra->prev_page && --req_size)
+	if (offset == ra->prev_index && --req_size)
 		++offset;
 
-	/* Note that prev_page == -1 if it is a first read */
-	sequential = (offset == ra->prev_page + 1);
-	ra->prev_page = offset;
-	ra->offset = 0;
+	/* Note that prev_index == -1 if it is a first read */
+	sequential = (offset == ra->prev_index + 1);
+	ra->prev_index = offset;
+	ra->prev_offset = 0;
 
 	max = get_max_readahead(ra);
 	newsize = min(req_size, max);
@@ -484,7 +484,7 @@ page_cache_readahead(struct address_spac
 	if (newsize == 0 || (ra->flags & RA_FLAG_INCACHE))
 		goto out;
 
-	ra->prev_page += newsize - 1;
+	ra->prev_index += newsize - 1;
 
 	/*
 	 * Special case - first read at start of file. We'll assume it's
@@ -540,18 +540,18 @@ page_cache_readahead(struct address_spac
 	 * we get called back on the first page of the ahead window which
 	 * will allow us to submit more IO.
 	 */
-	if (ra->prev_page >= ra->ahead_start) {
+	if (ra->prev_index >= ra->ahead_start) {
 		ra->start = ra->ahead_start;
 		ra->size = ra->ahead_size;
 		make_ahead_window(mapping, filp, ra, 0);
 recheck:
-		/* prev_page shouldn't overrun the ahead window */
-		ra->prev_page = min(ra->prev_page,
+		/* prev_index shouldn't overrun the ahead window */
+		ra->prev_index = min(ra->prev_index,
 			ra->ahead_start + ra->ahead_size - 1);
 	}
 
 out:
-	return ra->prev_page + 1;
+	return ra->prev_index + 1;
 }
 EXPORT_SYMBOL_GPL(page_cache_readahead);
 
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
make-remove_inode_dquot_ref-static.patch
ext3-copy-i_flags-to-inode-flags-on-write.patch
copy-i_flags-to-ext2-inode-flags-on-write.patch
ext4-copy-i_flags-to-inode-flags-on-write.patch
udf-use-sector_t-and-loff_t-for-file-offsets.patch
udf-introduce-struct-extent_position.patch
udf-use-get_bh.patch
udf-add-assertions.patch
udf-support-files-larger-than-1g.patch
