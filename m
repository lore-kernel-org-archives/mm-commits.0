From: akpm@linux-foundation.org
Subject: [merged] readahead-make-mmap_miss-an-unsigned-int.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:32:30 -0700
Message-ID: <200906171832.n5HIWUpO031075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757817AbZFQScd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:32:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     readahead: make mmap_miss an unsigned int
has been removed from the -mm tree.  Its filename was
     readahead-make-mmap_miss-an-unsigned-int.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -879,7 +879,7 @@ struct file_ra_state {
 					   there are only # of pages ahead */
 
 	unsigned int ra_pages;		/* Maximum readahead window */
-	int mmap_miss;			/* Cache miss stat for mmap accesses */
+	unsigned int mmap_miss;		/* Cache miss stat for mmap accesses */
 	loff_t prev_pos;		/* Cache last read() position */
 };
 
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch

