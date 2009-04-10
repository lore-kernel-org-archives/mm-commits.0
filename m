From: akpm@linux-foundation.org
Subject: + readahead-make-mmap_miss-an-unsigned-int.patch added to -mm tree
Date: Fri, 10 Apr 2009 16:39:04 -0700
Message-ID: <200904102339.n3ANd4UE021091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42448 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259AbZDJXlK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 19:41:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, yinghan@google.com


The patch titled
     readahead: make mmap_miss an unsigned int
has been added to the -mm tree.  Its filename is
     readahead-make-mmap_miss-an-unsigned-int.patch

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
Subject: readahead: make mmap_miss an unsigned int
From: Wu Fengguang <fengguang.wu@intel.com>

This makes the performance impact of possible mmap_miss wrap around to be
temporary and tolerable: i.e.  MMAP_LOTSAMISS=100 extra readarounds.

Otherwise if ever mmap_miss wraps around to negative, it takes INT_MAX
cache misses to bring it back to normal state.  During the time mmap
readaround will be _enabled_ for whatever wild random workload.  That's
almost permanent performance impact.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/fs.h~readahead-make-mmap_miss-an-unsigned-int include/linux/fs.h
--- a/include/linux/fs.h~readahead-make-mmap_miss-an-unsigned-int
+++ a/include/linux/fs.h
@@ -824,7 +824,7 @@ struct file_ra_state {
 					   there are only # of pages ahead */
 
 	unsigned int ra_pages;		/* Maximum readahead window */
-	int mmap_miss;			/* Cache miss stat for mmap accesses */
+	unsigned int mmap_miss;		/* Cache miss stat for mmap accesses */
 	loff_t prev_pos;		/* Cache last read() position */
 };
 
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

