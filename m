From: akpm@linux-foundation.org
Subject: + readahead-convert-splice-invocations.patch added to -mm tree
Date: Fri, 18 May 2007 23:29:06 -0700
Message-ID: <200705190629.l4J6T51v031280@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39168 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754483AbXESGcE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 19 May 2007 02:32:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn, axboe@suse.de, linuxram@us.ibm.com, slpratt@austin.ibm.com


The patch titled
     readahead: convert splice invocations
has been added to the -mm tree.  Its filename is
     readahead-convert-splice-invocations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead: convert splice invocations
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Convert splice reads to use on-demand readahead.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Steven Pratt <slpratt@austin.ibm.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Jens Axboe <axboe@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff -puN fs/splice.c~readahead-convert-splice-invocations fs/splice.c
--- a/fs/splice.c~readahead-convert-splice-invocations
+++ a/fs/splice.c
@@ -289,12 +289,6 @@ __generic_file_splice_read(struct file *
 		nr_pages = PIPE_BUFFERS;
 
 	/*
-	 * Don't try to 2nd guess the read-ahead logic, call into
-	 * page_cache_readahead() like the page cache reads would do.
-	 */
-	page_cache_readahead(mapping, &in->f_ra, in, index, nr_pages);
-
-	/*
 	 * Now fill in the holes:
 	 */
 	error = 0;
@@ -317,11 +311,8 @@ __generic_file_splice_read(struct file *
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
@@ -368,6 +359,10 @@ __generic_file_splice_read(struct file *
 		this_len = min_t(unsigned long, len, PAGE_CACHE_SIZE - loff);
 		page = pages[page_nr];
 
+		if (PageReadahead(page))
+			page_cache_readahead_ondemand(mapping, &in->f_ra, in,
+					page, index, nr_pages - page_nr);
+
 		/*
 		 * If the page isn't uptodate, we may need to start io on it
 		 */
@@ -456,6 +451,7 @@ fill_it:
 	 */
 	while (page_nr < nr_pages)
 		page_cache_release(pages[page_nr++]);
+	in->f_ra.prev_index = index;
 
 	if (spd.nr_pages)
 		return splice_to_pipe(pipe, &spd);
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
