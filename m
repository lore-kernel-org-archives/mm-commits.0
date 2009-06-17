From: akpm@linux-foundation.org
Subject: [merged] readahead-move-the-random-read-case-to-bottom.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:32:59 -0700
Message-ID: <200906171832.n5HIWxq8031481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758410AbZFQSds (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:33:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, jens.axboe@oracle.com, jmoyer@redhat.com, nickpiggin@yahoo.com.au, vst@vlnb.net, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     readahead: move the random read case to bottom
has been removed from the -mm tree.  Its filename was
     readahead-move-the-random-read-case-to-bottom.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch

