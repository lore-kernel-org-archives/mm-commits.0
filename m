From: akpm@linux-foundation.org
Subject: + readahead-move-synchronous-readahead-call-out-of-splice-loop.patch added to -mm tree
Date: Mon, 11 Jun 2007 20:19:57 -0700
Message-ID: <200706120319.l5C3JvhR003127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47548 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753065AbXFLDUO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2007 23:20:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn, jens.axboe@oracle.com, rusty@rustcorp.com.au


The patch titled
     readahead: move synchronous readahead call out of splice loop
has been added to the -mm tree.  Its filename is
     readahead-move-synchronous-readahead-call-out-of-splice-loop.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead: move synchronous readahead call out of splice loop
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Move synchronous page_cache_readahead_ondemand() call out of splice loop.

This avoids one pointless page allocation/insertion in case of non-zero
ra_pages, or many pointless readahead calls in case of zero ra_pages.

Note that if a user sets ra_pages to less than PIPE_BUFFERS=16 pages, he will
not get expected readahead behavior anyway.  The splice code works in batches
of 16 pages, which can be taken as another form of synchronous readahead.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/splice.c~readahead-move-synchronous-readahead-call-out-of-splice-loop fs/splice.c
--- a/fs/splice.c~readahead-move-synchronous-readahead-call-out-of-splice-loop
+++ a/fs/splice.c
@@ -299,12 +299,16 @@ __generic_file_splice_read(struct file *
 	 * Lookup the (hopefully) full range of pages we need.
 	 */
 	spd.nr_pages = find_get_pages_contig(mapping, index, nr_pages, pages);
+	index += spd.nr_pages;
 
 	/*
 	 * If find_get_pages_contig() returned fewer pages than we needed,
-	 * allocate the rest.
+	 * readahead/allocate the rest.
 	 */
-	index += spd.nr_pages;
+	if (spd.nr_pages < nr_pages)
+		page_cache_readahead_ondemand(mapping, &in->f_ra, in,
+				NULL, index, nr_pages - spd.nr_pages);
+
 	while (spd.nr_pages < nr_pages) {
 		/*
 		 * Page could be there, find_get_pages_contig() breaks on
@@ -312,9 +316,6 @@ __generic_file_splice_read(struct file *
 		 */
 		page = find_get_page(mapping, index);
 		if (!page) {
-			page_cache_readahead_ondemand(mapping, &in->f_ra, in,
-					NULL, index, nr_pages - spd.nr_pages);
-
 			/*
 			 * page didn't exist, allocate one.
 			 */
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
