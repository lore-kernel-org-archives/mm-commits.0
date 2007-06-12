From: akpm@linux-foundation.org
Subject: + readahead-pass-real-splice-size.patch added to -mm tree
Date: Mon, 11 Jun 2007 20:19:41 -0700
Message-ID: <200706120319.l5C3Jfm3003120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36885 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752659AbXFLDUA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2007 23:20:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn, jens.axboe@oracle.com, rusty@rustcorp.com.au


The patch titled
     readahead: pass real splice size
has been added to the -mm tree.  Its filename is
     readahead-pass-real-splice-size.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead: pass real splice size
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Pass real splice size to page_cache_readahead_ondemand().

The splice code works in chunks of 16 pages internally.  The readahead code
should be told of the overall splice size, instead of the internal chunk size.
 Otherwize bad things may happen.  Imagine some 17-page random splice reads. 
The code before this patch will result in two readahead calls: readahead(16);
readahead(1); That leads to one 16-page I/O and one 32-page I/O: one extra I/O
and 31 readahead miss pages.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN fs/splice.c~readahead-pass-real-splice-size fs/splice.c
--- a/fs/splice.c~readahead-pass-real-splice-size
+++ a/fs/splice.c
@@ -267,7 +267,7 @@ __generic_file_splice_read(struct file *
 			   unsigned int flags)
 {
 	struct address_space *mapping = in->f_mapping;
-	unsigned int loff, nr_pages;
+	unsigned int loff, nr_pages, req_pages;
 	struct page *pages[PIPE_BUFFERS];
 	struct partial_page partial[PIPE_BUFFERS];
 	struct page *page;
@@ -284,10 +284,8 @@ __generic_file_splice_read(struct file *
 
 	index = *ppos >> PAGE_CACHE_SHIFT;
 	loff = *ppos & ~PAGE_CACHE_MASK;
-	nr_pages = (len + loff + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-
-	if (nr_pages > PIPE_BUFFERS)
-		nr_pages = PIPE_BUFFERS;
+	req_pages = (len + loff + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	nr_pages = min(req_pages, (unsigned)PIPE_BUFFERS);
 
 	/*
 	 * Now fill in the holes:
@@ -307,7 +305,7 @@ __generic_file_splice_read(struct file *
 	 */
 	if (spd.nr_pages < nr_pages)
 		page_cache_readahead_ondemand(mapping, &in->f_ra, in,
-				NULL, index, nr_pages - spd.nr_pages);
+				NULL, index, req_pages - spd.nr_pages);
 
 	while (spd.nr_pages < nr_pages) {
 		/*
@@ -363,7 +361,7 @@ __generic_file_splice_read(struct file *
 
 		if (PageReadahead(page))
 			page_cache_readahead_ondemand(mapping, &in->f_ra, in,
-					page, index, nr_pages - page_nr);
+					page, index, req_pages - page_nr);
 
 		/*
 		 * If the page isn't uptodate, we may need to start io on it
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

readahead-introduce-pg_readahead.patch
readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
readahead-min_ra_pages-max_ra_pages-macros.patch
readahead-data-structure-and-routines.patch
readahead-on-demand-readahead-logic.patch
readahead-convert-filemap-invocations.patch
readahead-convert-splice-invocations.patch
readahead-convert-ext3-ext4-invocations.patch
readahead-remove-the-old-algorithm.patch
readahead-move-synchronous-readahead-call-out-of-splice-loop.patch
readahead-pass-real-splice-size.patch
mm-share-pg_readahead-and-pg_reclaim.patch
