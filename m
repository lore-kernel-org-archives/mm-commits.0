From: akpm@linux-foundation.org
Subject: - readahead-convert-splice-invocations.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:01:16 -0700
Message-ID: <200707192001.l6JK1GbK019522@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59250 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932258AbXGSUag (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:30:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, axboe@suse.de, linuxram@us.ibm.com, rusty@rustcorp.com.au, slpratt@austin.ibm.com, mm-commits@vger.kernel.org


The patch titled
     readahead: convert splice invocations
has been removed from the -mm tree.  Its filename was
     readahead-convert-splice-invocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: readahead: convert splice invocations
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Convert splice reads to use on-demand readahead.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Steven Pratt <slpratt@austin.ibm.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Jens Axboe <axboe@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff -puN fs/splice.c~readahead-convert-splice-invocations fs/splice.c
--- a/fs/splice.c~readahead-convert-splice-invocations
+++ a/fs/splice.c
@@ -287,12 +287,6 @@ __generic_file_splice_read(struct file *
 		nr_pages = PIPE_BUFFERS;
 
 	/*
-	 * Don't try to 2nd guess the read-ahead logic, call into
-	 * page_cache_readahead() like the page cache reads would do.
-	 */
-	page_cache_readahead(mapping, &in->f_ra, in, index, nr_pages);
-
-	/*
 	 * Lookup the (hopefully) full range of pages we need.
 	 */
 	spd.nr_pages = find_get_pages_contig(mapping, index, nr_pages, pages);
@@ -310,11 +304,8 @@ __generic_file_splice_read(struct file *
 		 */
 		page = find_get_page(mapping, index);
 		if (!page) {
-			/*
-			 * Make sure the read-ahead engine is notified
-			 * about this failure.
-			 */
-			handle_ra_miss(mapping, &in->f_ra, index);
+			page_cache_readahead_ondemand(mapping, &in->f_ra, in,
+					NULL, index, nr_pages - spd.nr_pages);
 
 			/*
 			 * page didn't exist, allocate one.
@@ -361,6 +352,10 @@ __generic_file_splice_read(struct file *
 		this_len = min_t(unsigned long, len, PAGE_CACHE_SIZE - loff);
 		page = pages[page_nr];
 
+		if (PageReadahead(page))
+			page_cache_readahead_ondemand(mapping, &in->f_ra, in,
+					page, index, nr_pages - page_nr);
+
 		/*
 		 * If the page isn't uptodate, we may need to start io on it
 		 */
@@ -453,6 +448,7 @@ fill_it:
 	 */
 	while (page_nr < nr_pages)
 		page_cache_release(pages[page_nr++]);
+	in->f_ra.prev_index = index;
 
 	if (spd.nr_pages)
 		return splice_to_pipe(pipe, &spd);
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
