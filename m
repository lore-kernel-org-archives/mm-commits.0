From: akpm@linux-foundation.org
Subject: + readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch added to -mm tree
Date: Mon, 23 Jul 2007 20:53:08 -0700
Message-ID: <200707240353.l6O3r8Jq026872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41936 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751021AbXGXDx7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 23:53:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn, peterz@infradead.org, rusty@rustcorp.com.au


The patch titled
     readahead: combine file_ra_state.prev_index/prev_offset into prev_pos
has been added to the -mm tree.  Its filename is
     readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead: combine file_ra_state.prev_index/prev_offset into prev_pos
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Combine the file_ra_state members
				unsigned long prev_index
				unsigned int prev_offset
into
				loff_t prev_pos

It is more consistent and better supports huge files.

Thanks to Peter for the nice proposal!

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/dir.c      |    2 +-
 fs/ext4/dir.c      |    2 +-
 fs/splice.c        |    2 +-
 include/linux/fs.h |    3 +--
 mm/filemap.c       |   11 ++++++-----
 mm/readahead.c     |   15 ++++++++-------
 6 files changed, 18 insertions(+), 17 deletions(-)

diff -puN fs/ext3/dir.c~readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos fs/ext3/dir.c
--- a/fs/ext3/dir.c~readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos
+++ a/fs/ext3/dir.c
@@ -143,7 +143,7 @@ static int ext3_readdir(struct file * fi
 					sb->s_bdev->bd_inode->i_mapping,
 					&filp->f_ra, filp,
 					index, 1);
-			filp->f_ra.prev_index = index;
+			filp->f_ra.prev_pos = index << PAGE_CACHE_SHIFT;
 			bh = ext3_bread(NULL, inode, blk, 0, &err);
 		}
 
diff -puN fs/ext4/dir.c~readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos fs/ext4/dir.c
--- a/fs/ext4/dir.c~readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos
+++ a/fs/ext4/dir.c
@@ -142,7 +142,7 @@ static int ext4_readdir(struct file * fi
 					sb->s_bdev->bd_inode->i_mapping,
 					&filp->f_ra, filp,
 					index, 1);
-			filp->f_ra.prev_index = index;
+			filp->f_ra.prev_pos = index << PAGE_CACHE_SHIFT;
 			bh = ext4_bread(NULL, inode, blk, 0, &err);
 		}
 
diff -puN fs/splice.c~readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos fs/splice.c
--- a/fs/splice.c~readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos
+++ a/fs/splice.c
@@ -454,7 +454,7 @@ fill_it:
 	 */
 	while (page_nr < nr_pages)
 		page_cache_release(pages[page_nr++]);
-	in->f_ra.prev_index = index;
+	in->f_ra.prev_pos = index << PAGE_CACHE_SHIFT;
 
 	if (spd.nr_pages)
 		return splice_to_pipe(pipe, &spd);
diff -puN include/linux/fs.h~readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos include/linux/fs.h
--- a/include/linux/fs.h~readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos
+++ a/include/linux/fs.h
@@ -704,8 +704,7 @@ struct file_ra_state {
 
 	unsigned int ra_pages;		/* Maximum readahead window */
 	int mmap_miss;			/* Cache miss stat for mmap accesses */
-	unsigned long prev_index;	/* Cache last read() position */
-	unsigned int prev_offset;	/* Offset where last read() ended in a page */
+	loff_t prev_pos;		/* Cache last read() position */
 };
 
 /*
diff -puN mm/filemap.c~readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos mm/filemap.c
--- a/mm/filemap.c~readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos
+++ a/mm/filemap.c
@@ -879,8 +879,8 @@ void do_generic_mapping_read(struct addr
 	cached_page = NULL;
 	index = *ppos >> PAGE_CACHE_SHIFT;
 	next_index = index;
-	prev_index = ra.prev_index;
-	prev_offset = ra.prev_offset;
+	prev_index = ra.prev_pos >> PAGE_CACHE_SHIFT;
+	prev_offset = ra.prev_pos & (PAGE_CACHE_SIZE-1);
 	last_index = (*ppos + desc->count + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
 	offset = *ppos & ~PAGE_CACHE_MASK;
 
@@ -966,7 +966,6 @@ page_ok:
 		index += offset >> PAGE_CACHE_SHIFT;
 		offset &= ~PAGE_CACHE_MASK;
 		prev_offset = offset;
-		ra.prev_offset = offset;
 
 		page_cache_release(page);
 		if (ret == nr && desc->count)
@@ -1056,7 +1055,9 @@ no_cached_page:
 
 out:
 	*_ra = ra;
-	_ra->prev_index = prev_index;
+	_ra->prev_pos = prev_index;
+	_ra->prev_pos <<= PAGE_CACHE_SHIFT;
+	_ra->prev_pos |= prev_offset;
 
 	*ppos = ((loff_t) index << PAGE_CACHE_SHIFT) + offset;
 	if (cached_page)
@@ -1415,7 +1416,7 @@ retry_find:
 	 * Found the page and have a reference on it.
 	 */
 	mark_page_accessed(page);
-	ra->prev_index = page->index;
+	ra->prev_pos = page->index << PAGE_CACHE_SHIFT;
 	vmf->page = page;
 	return ret | VM_FAULT_LOCKED;
 
diff -puN mm/readahead.c~readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos mm/readahead.c
--- a/mm/readahead.c~readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos
+++ a/mm/readahead.c
@@ -45,7 +45,7 @@ void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping)
 {
 	ra->ra_pages = mapping->backing_dev_info->ra_pages;
-	ra->prev_index = -1;
+	ra->prev_pos = -1;
 }
 EXPORT_SYMBOL_GPL(file_ra_state_init);
 
@@ -326,7 +326,7 @@ static unsigned long get_next_ra_size(st
  * indicator. The flag won't be set on already cached pages, to avoid the
  * readahead-for-nothing fuss, saving pointless page cache lookups.
  *
- * prev_index tracks the last visited page in the _previous_ read request.
+ * prev_pos tracks the last visited byte in the _previous_ read request.
  * It should be maintained by the caller, and will be used for detecting
  * small random reads. Note that the readahead algorithm checks loosely
  * for sequential patterns. Hence interleaved reads might be served as
@@ -350,11 +350,9 @@ ondemand_readahead(struct address_space 
 		   bool hit_readahead_marker, pgoff_t offset,
 		   unsigned long req_size)
 {
-	int max;	/* max readahead pages */
-	int sequential;
-
-	max = ra->ra_pages;
-	sequential = (offset - ra->prev_index <= 1UL) || (req_size > max);
+	int	max = ra->ra_pages;	/* max readahead pages */
+	pgoff_t prev_offset;
+	int	sequential;
 
 	/*
 	 * It's the expected callback offset, assume sequential access.
@@ -368,6 +366,9 @@ ondemand_readahead(struct address_space 
 		goto readit;
 	}
 
+	prev_offset = ra->prev_pos >> PAGE_CACHE_SHIFT;
+	sequential = offset - prev_offset <= 1UL || req_size > max;
+
 	/*
 	 * Standalone, small read.
 	 * Read as is, and do not pollute the readahead state.
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

readahead-compacting-file_ra_state.patch
readahead-mmap-read-around-simplification.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
radixtree-introduce-radix_tree_scan_hole.patch
readahead-basic-support-of-interleaved-reads.patch
readahead-remove-the-local-copy-of-ra-in-do_generic_mapping_read.patch
readahead-remove-several-readahead-macros.patch
readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb.patch
filemap-trivial-code-cleanups.patch
filemap-convert-some-unsigned-long-to-pgoff_t.patch
convert-ill-defined-log2-to-ilog2.patch
