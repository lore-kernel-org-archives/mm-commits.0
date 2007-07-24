From: akpm@linux-foundation.org
Subject: + readahead-basic-support-of-interleaved-reads.patch added to -mm tree
Date: Mon, 23 Jul 2007 20:53:14 -0700
Message-ID: <200707240353.l6O3rEBh026881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49580 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756865AbXGXDyB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 23:54:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn, rusty@rustcorp.com.au


The patch titled
     readahead: basic support of interleaved reads
has been added to the -mm tree.  Its filename is
     readahead-basic-support-of-interleaved-reads.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead: basic support of interleaved reads
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

This is a simplified version of the pagecache context based readahead.  It
handles the case of multiple threads reading on the same fd and invalidating
each others' readahead state.  It does the trick by scanning the pagecache and
recovering the current read stream's readahead status.

The algorithm works in a opportunistic way, in that it does not try to detect
interleaved reads _actively_, which requires a probe into the page cache
(which means a little more overhead for random reads).  It only tries to
handle a previously started sequential readahead whose state was overwritten
by another concurrent stream, and it can do this job pretty well.

Negative and positive examples(or what you can expect from it):

1) it cannot detect and serve perfect request-by-request interleaved reads
   right:
	time	stream 1  stream 2
	0 	1
	1 	          1001
	2 	2
	3 	          1002
	4 	3
	5 	          1003
	6 	4
	7 	          1004
	8 	5
	9	          1005

Here no single readahead will be carried out.

2) However, if it's two concurrent reads by two threads, the chance of the
   initial sequential readahead be started is huge. Once the first sequential
   readahead is started for a stream, this patch will ensure that the readahead
   window continues to rampup and won't be disturbed by other streams.

	time	stream 1  stream 2
	0 	1
	1 	2
	2 	          1001
	3 	3
	4 	          1002
	5 	          1003
	6 	4
	7 	5
	8 	          1004
	9 	6
	10	          1005
	11	7
	12	          1006
	13	          1007

Here stream 1 will start a readahead at page 2, and stream 2 will start its
first readahead at page 1003.  From then on the two streams will be served
right.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff -puN mm/readahead.c~readahead-basic-support-of-interleaved-reads mm/readahead.c
--- a/mm/readahead.c~readahead-basic-support-of-interleaved-reads
+++ a/mm/readahead.c
@@ -379,6 +379,29 @@ ondemand_readahead(struct address_space 
 	}
 
 	/*
+	 * Hit a marked page without valid readahead state.
+	 * E.g. interleaved reads.
+	 * Query the pagecache for async_size, which normally equals to
+	 * readahead size. Ramp it up and use it as the new readahead size.
+	 */
+	if (hit_readahead_marker) {
+		pgoff_t start;
+
+		read_lock_irq(&mapping->tree_lock);
+		start = radix_tree_next_hole(&mapping->page_tree, offset, max+1);
+		read_unlock_irq(&mapping->tree_lock);
+
+		if (!start || start - offset > max)
+			return 0;
+
+		ra->start = start;
+		ra->size = start - offset;	/* old async_size */
+		ra->size = get_next_ra_size(ra, max);
+		ra->async_size = ra->size;
+		goto readit;
+	}
+
+	/*
 	 * It may be one of
 	 * 	- first read on start of file
 	 * 	- sequential cache miss
@@ -389,16 +412,6 @@ ondemand_readahead(struct address_space 
 	ra->size = get_init_ra_size(req_size, max);
 	ra->async_size = ra->size > req_size ? ra->size - req_size : ra->size;
 
-	/*
-	 * Hit on a marked page without valid readahead state.
-	 * E.g. interleaved reads.
-	 * Not knowing its readahead pos/size, bet on the minimal possible one.
-	 */
-	if (hit_readahead_marker) {
-		ra->start++;
-		ra->size = get_next_ra_size(ra, max);
-	}
-
 readit:
 	return ra_submit(ra, mapping, filp);
 }
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
