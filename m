From: akpm@linux-foundation.org
Subject: - readahead-improve-heuristic-detecting-sequential-reads.patch removed from -mm tree
Date: Mon, 07 May 2007 17:02:32 -0700
Message-ID: <200705080002.l4802W8P008851@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967322AbXEHADF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:03:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, nickpiggin@yahoo.com.au, wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: improve heuristic detecting sequential reads
has been removed from the -mm tree.  Its filename was
     readahead-improve-heuristic-detecting-sequential-reads.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: readahead: improve heuristic detecting sequential reads
From: Jan Kara <jack@suse.cz>

Introduce ra.offset and store in it an offset where the previous read
ended.  This way we can detect whether reads are really sequential (and
thus we should not mark the page as accessed repeatedly) or whether they
are random and just happen to be in the same page (and the page should
really be marked accessed again).

Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: WU Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    1 +
 mm/filemap.c       |    9 ++++++---
 mm/readahead.c     |    3 +++
 3 files changed, 10 insertions(+), 3 deletions(-)

diff -puN include/linux/fs.h~readahead-improve-heuristic-detecting-sequential-reads include/linux/fs.h
--- a/include/linux/fs.h~readahead-improve-heuristic-detecting-sequential-reads
+++ a/include/linux/fs.h
@@ -702,6 +702,7 @@ struct file_ra_state {
 	unsigned long ra_pages;		/* Maximum readahead window */
 	unsigned long mmap_hit;		/* Cache hit stat for mmap accesses */
 	unsigned long mmap_miss;	/* Cache miss stat for mmap accesses */
+	unsigned int offset;		/* Offset where last read() ended in a page */
 };
 #define RA_FLAG_MISS 0x01	/* a cache miss occured against this file */
 #define RA_FLAG_INCACHE 0x02	/* file is already in cache */
diff -puN mm/filemap.c~readahead-improve-heuristic-detecting-sequential-reads mm/filemap.c
--- a/mm/filemap.c~readahead-improve-heuristic-detecting-sequential-reads
+++ a/mm/filemap.c
@@ -868,6 +868,7 @@ void do_generic_mapping_read(struct addr
 	unsigned long last_index;
 	unsigned long next_index;
 	unsigned long prev_index;
+	unsigned int prev_offset;
 	loff_t isize;
 	struct page *cached_page;
 	int error;
@@ -877,6 +878,7 @@ void do_generic_mapping_read(struct addr
 	index = *ppos >> PAGE_CACHE_SHIFT;
 	next_index = index;
 	prev_index = ra.prev_page;
+	prev_offset = ra.offset;
 	last_index = (*ppos + desc->count + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
 	offset = *ppos & ~PAGE_CACHE_MASK;
 
@@ -924,10 +926,10 @@ page_ok:
 			flush_dcache_page(page);
 
 		/*
-		 * When (part of) the same page is read multiple times
-		 * in succession, only mark it as accessed the first time.
+		 * When a sequential read accesses a page several times,
+		 * only mark it as accessed the first time.
 		 */
-		if (prev_index != index)
+		if (prev_index != index || offset != prev_offset)
 			mark_page_accessed(page);
 		prev_index = index;
 
@@ -945,6 +947,7 @@ page_ok:
 		offset += ret;
 		index += offset >> PAGE_CACHE_SHIFT;
 		offset &= ~PAGE_CACHE_MASK;
+		prev_offset = ra.offset = offset;
 
 		page_cache_release(page);
 		if (ret == nr && desc->count)
diff -puN mm/readahead.c~readahead-improve-heuristic-detecting-sequential-reads mm/readahead.c
--- a/mm/readahead.c~readahead-improve-heuristic-detecting-sequential-reads
+++ a/mm/readahead.c
@@ -207,6 +207,8 @@ out:
  *              If page_cache_readahead sees that it is again being called for
  *              a page which it just looked at, it can return immediately without
  *              making any state changes.
+ * offset:      Offset in the prev_page where the last read ended - used for
+ *              detection of sequential file reading.
  * ahead_start,
  * ahead_size:  Together, these form the "ahead window".
  * ra_pages:	The externally controlled max readahead for this fd.
@@ -473,6 +475,7 @@ page_cache_readahead(struct address_spac
 	/* Note that prev_page == -1 if it is a first read */
 	sequential = (offset == ra->prev_page + 1);
 	ra->prev_page = offset;
+	ra->offset = 0;
 
 	max = get_max_readahead(ra);
 	newsize = min(req_size, max);
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
