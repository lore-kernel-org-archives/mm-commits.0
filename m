From: akpm@linux-foundation.org
Subject: + readahead-compacting-file_ra_state.patch added to -mm tree
Date: Mon, 23 Jul 2007 20:53:04 -0700
Message-ID: <200707240353.l6O3r4vR026865@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37643 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755756AbXGXDyB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 23:54:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn, andi@firstfloor.org, rusty@rustcorp.com.au


The patch titled
     readahead: compacting file_ra_state
has been added to the -mm tree.  Its filename is
     readahead-compacting-file_ra_state.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead: compacting file_ra_state
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Use 'unsigned int' instead of 'unsigned long' for readahead sizes.

This helps reduce memory consumption on 64bit CPU when a lot of files are
opened.

CC: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    8 ++++----
 mm/readahead.c     |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/fs.h~readahead-compacting-file_ra_state include/linux/fs.h
--- a/include/linux/fs.h~readahead-compacting-file_ra_state
+++ a/include/linux/fs.h
@@ -697,12 +697,12 @@ struct fown_struct {
  * Track a single file's readahead state
  */
 struct file_ra_state {
-	pgoff_t start;                  /* where readahead started */
-	unsigned long size;             /* # of readahead pages */
-	unsigned long async_size;       /* do asynchronous readahead when
+	pgoff_t start;			/* where readahead started */
+	unsigned int size;		/* # of readahead pages */
+	unsigned int async_size;	/* do asynchronous readahead when
 					   there are only # of pages ahead */
 
-	unsigned long ra_pages;		/* Maximum readahead window */
+	unsigned int ra_pages;		/* Maximum readahead window */
 	unsigned long mmap_hit;		/* Cache hit stat for mmap accesses */
 	unsigned long mmap_miss;	/* Cache miss stat for mmap accesses */
 	unsigned long prev_index;	/* Cache last read() position */
diff -puN mm/readahead.c~readahead-compacting-file_ra_state mm/readahead.c
--- a/mm/readahead.c~readahead-compacting-file_ra_state
+++ a/mm/readahead.c
@@ -350,7 +350,7 @@ ondemand_readahead(struct address_space 
 		   bool hit_readahead_marker, pgoff_t offset,
 		   unsigned long req_size)
 {
-	unsigned long max;	/* max readahead pages */
+	int max;	/* max readahead pages */
 	int sequential;
 
 	max = ra->ra_pages;
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
