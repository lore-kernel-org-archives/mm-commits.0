From: akpm@linux-foundation.org
Subject: + readahead-move-the-random-read-case-to-bottom.patch added to -mm tree
Date: Fri, 10 Apr 2009 17:17:50 -0700
Message-ID: <200904110017.n3B0Ho7H005031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751894AbZDKAWR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 20:22:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, jens.axboe@oracle.com, jmoyer@redhat.com, nickpiggin@yahoo.com.au, vst@vlnb.net, yinghan@google.com


The patch titled
     readahead: move the random read case to bottom
has been added to the -mm tree.  Its filename is
     readahead-move-the-random-read-case-to-bottom.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: readahead: move the random read case to bottom
From: Wu Fengguang <fengguang.wu@intel.com>

Split all readahead cases, and move the random one to bottom.

No behavior changes.

This is to prepare for the introduction of context readahead, and make it
easy for inserting accounting/tracing points for each case.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   46 +++++++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff -puN mm/readahead.c~readahead-move-the-random-read-case-to-bottom mm/readahead.c
--- a/mm/readahead.c~readahead-move-the-random-read-case-to-bottom
+++ a/mm/readahead.c
@@ -339,33 +339,25 @@ ondemand_readahead(struct address_space 
 		   unsigned long req_size)
 {
 	unsigned long max = max_sane_readahead(ra->ra_pages);
-	pgoff_t prev_offset;
-	int	sequential;
+
+	/*
+	 * start of file
+	 */
+	if (!offset)
+		goto initial_readahead;
 
 	/*
 	 * It's the expected callback offset, assume sequential access.
 	 * Ramp up sizes, and push forward the readahead window.
 	 */
-	if (offset && (offset == (ra->start + ra->size - ra->async_size) ||
-			offset == (ra->start + ra->size))) {
+	if ((offset == (ra->start + ra->size - ra->async_size) ||
+	     offset == (ra->start + ra->size))) {
 		ra->start += ra->size;
 		ra->size = get_next_ra_size(ra, max);
 		ra->async_size = ra->size;
 		goto readit;
 	}
 
-	prev_offset = ra->prev_pos >> PAGE_CACHE_SHIFT;
-	sequential = offset - prev_offset <= 1UL || req_size > max;
-
-	/*
-	 * Standalone, small read.
-	 * Read as is, and do not pollute the readahead state.
-	 */
-	if (!hit_readahead_marker && !sequential) {
-		return __do_page_cache_readahead(mapping, filp,
-						offset, req_size, 0);
-	}
-
 	/*
 	 * Hit a marked page without valid readahead state.
 	 * E.g. interleaved reads.
@@ -391,12 +383,24 @@ ondemand_readahead(struct address_space 
 	}
 
 	/*
-	 * It may be one of
-	 * 	- first read on start of file
-	 * 	- sequential cache miss
-	 * 	- oversize random read
-	 * Start readahead for it.
+	 * oversize read
 	 */
+	if (req_size > max)
+		goto initial_readahead;
+
+	/*
+	 * sequential cache miss
+	 */
+	if (offset - (ra->prev_pos >> PAGE_CACHE_SHIFT) <= 1UL)
+		goto initial_readahead;
+
+	/*
+	 * standalone, small random read
+	 * Read as is, and do not pollute the readahead state.
+	 */
+	return __do_page_cache_readahead(mapping, filp, offset, req_size, 0);
+
+initial_readahead:
 	ra->start = offset;
 	ra->size = get_init_ra_size(req_size, max);
 	ra->async_size = ra->size > req_size ? ra->size - req_size : ra->size;
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
readahead-make-mmap_miss-an-unsigned-int.patch
readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead.patch
readahead-apply-max_sane_readahead-limit-in-ondemand_readahead.patch
readahead-remove-one-unnecessary-radix-tree-lookup.patch
readahead-increase-interleaved-readahead-size.patch
readahead-remove-sync-async-readahead-call-dependency.patch
readahead-clean-up-and-simplify-the-code-for-filemap-page-fault-readahead.patch
readahead-sequential-mmap-readahead.patch
readahead-enforce-full-readahead-size-on-async-mmap-readahead.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch
radix-tree-add-radix_tree_prev_hole.patch
readahead-move-the-random-read-case-to-bottom.patch
readahead-introduce-context-readahead-algorithm.patch
readahead-introduce-context-readahead-algorithm-fix.patch

