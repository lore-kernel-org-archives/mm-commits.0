From: akpm@linux-foundation.org
Subject: + readahead-improve-heuristic-detecting-sequential-reads.patch added to -mm tree
Date: Tue, 10 Apr 2007 19:17:54 -0700
Message-ID: <200704110217.l3B2HsvR025872@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55975 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161135AbXDKCSW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 22:18:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, nickpiggin@yahoo.com.au, wfg@mail.ustc.edu.cn


The patch titled
     readahead: improve heuristic detecting sequential reads
has been added to the -mm tree.  Its filename is
     readahead-improve-heuristic-detecting-sequential-reads.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -869,6 +869,7 @@ void do_generic_mapping_read(struct addr
 	unsigned long last_index;
 	unsigned long next_index;
 	unsigned long prev_index;
+	unsigned int prev_offset;
 	loff_t isize;
 	struct page *cached_page;
 	int error;
@@ -878,6 +879,7 @@ void do_generic_mapping_read(struct addr
 	index = *ppos >> PAGE_CACHE_SHIFT;
 	next_index = index;
 	prev_index = ra.prev_page;
+	prev_offset = ra.offset;
 	last_index = (*ppos + desc->count + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
 	offset = *ppos & ~PAGE_CACHE_MASK;
 
@@ -925,10 +927,10 @@ page_ok:
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
 
@@ -946,6 +948,7 @@ page_ok:
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

readahead-improve-heuristic-detecting-sequential-reads.patch
make-remove_inode_dquot_ref-static.patch
udf-use-sector_t-and-loff_t-for-file-offsets.patch
udf-introduce-struct-extent_position.patch
udf-use-get_bh.patch
udf-add-assertions.patch
udf-support-files-larger-than-1g.patch
udf-fix-link-counts.patch
