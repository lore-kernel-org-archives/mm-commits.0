From: akpm@linux-foundation.org
Subject: + readahead-mmap-read-around-simplification.patch added to -mm tree
Date: Mon, 23 Jul 2007 20:53:06 -0700
Message-ID: <200707240353.l6O3r6wr026868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57770 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765179AbXGXDxY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 23:53:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn, rusty@rustcorp.com.au


The patch titled
     readahead: mmap read-around simplification
has been added to the -mm tree.  Its filename is
     readahead-mmap-read-around-simplification.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead: mmap read-around simplification
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Fold file_ra_state.mmap_hit into file_ra_state.mmap_miss and make it an int.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    3 +--
 mm/filemap.c       |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN include/linux/fs.h~readahead-mmap-read-around-simplification include/linux/fs.h
--- a/include/linux/fs.h~readahead-mmap-read-around-simplification
+++ a/include/linux/fs.h
@@ -703,8 +703,7 @@ struct file_ra_state {
 					   there are only # of pages ahead */
 
 	unsigned int ra_pages;		/* Maximum readahead window */
-	unsigned long mmap_hit;		/* Cache hit stat for mmap accesses */
-	unsigned long mmap_miss;	/* Cache miss stat for mmap accesses */
+	int mmap_miss;			/* Cache miss stat for mmap accesses */
 	unsigned long prev_index;	/* Cache last read() position */
 	unsigned int prev_offset;	/* Offset where last read() ended in a page */
 };
diff -puN mm/filemap.c~readahead-mmap-read-around-simplification mm/filemap.c
--- a/mm/filemap.c~readahead-mmap-read-around-simplification
+++ a/mm/filemap.c
@@ -1369,7 +1369,7 @@ retry_find:
 		 * Do we miss much more than hit in this file? If so,
 		 * stop bothering with read-ahead. It will only hurt.
 		 */
-		if (ra->mmap_miss > ra->mmap_hit + MMAP_LOTSAMISS)
+		if (ra->mmap_miss > MMAP_LOTSAMISS)
 			goto no_cached_page;
 
 		/*
@@ -1395,7 +1395,7 @@ retry_find:
 	}
 
 	if (!did_readaround)
-		ra->mmap_hit++;
+		ra->mmap_miss--;
 
 	/*
 	 * We have a locked page in the page cache, now we need to check
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
