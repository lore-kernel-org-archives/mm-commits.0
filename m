From: akpm@linux-foundation.org
Subject: - readahead-move-synchronous-readahead-call-out-of-splice-loop.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:01:23 -0700
Message-ID: <200707192001.l6JK1NM9019531@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44258 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933067AbXGSU0w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:26:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, jens.axboe@oracle.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     readahead: move synchronous readahead call out of splice loop
has been removed from the -mm tree.  Its filename was
     readahead-move-synchronous-readahead-call-out-of-splice-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -290,13 +290,17 @@ __generic_file_splice_read(struct file *
 	 * Lookup the (hopefully) full range of pages we need.
 	 */
 	spd.nr_pages = find_get_pages_contig(mapping, index, nr_pages, pages);
+	index += spd.nr_pages;
 
 	/*
 	 * If find_get_pages_contig() returned fewer pages than we needed,
-	 * allocate the rest and fill in the holes.
+	 * readahead/allocate the rest and fill in the holes.
 	 */
+	if (spd.nr_pages < nr_pages)
+		page_cache_readahead_ondemand(mapping, &in->f_ra, in,
+				NULL, index, nr_pages - spd.nr_pages);
+
 	error = 0;
-	index += spd.nr_pages;
 	while (spd.nr_pages < nr_pages) {
 		/*
 		 * Page could be there, find_get_pages_contig() breaks on
@@ -304,9 +308,6 @@ __generic_file_splice_read(struct file *
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

origin.patch
