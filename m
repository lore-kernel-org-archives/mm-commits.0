From: akpm@linux-foundation.org
Subject: + writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages-update.patch added to -mm tree
Date: Thu, 05 Aug 2010 16:23:08 -0700
Message-ID: <201008052323.o75NN87D011749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757590Ab0HEXYl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Aug 2010 19:24:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, a.p.zijlstra@chello.nl, axboe@kernel.dk, jack@suse.cz, richard@rsk.demon.co.uk


The patch titled
     writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages-update
has been added to the -mm tree.  Its filename is
     writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages-update.patch

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
Subject: writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages-update
From: Wu Fengguang <fengguang.wu@intel.com>

[akpm@linux-foundation.org] fix uninitialized dirty_exceeded
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page-writeback.c~writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages-update mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages-update
+++ a/mm/page-writeback.c
@@ -464,7 +464,7 @@ static void balance_dirty_pages(struct a
 	unsigned long bdi_thresh;
 	unsigned long pages_written = 0;
 	unsigned long pause = 1;
-	int dirty_exceeded;
+	bool dirty_exceeded = false;
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 
 	for (;;) {
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
fs-inodec-work-around-bug.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
vfs-o_-bit-numbers-uniqueness-check.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages.patch
writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages-update.patch
writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds.patch
writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds-fix.patch
writeback-add-comment-to-the-dirty-limit-functions.patch
writeback-dont-redirty-tail-an-inode-with-dirty-pages.patch
writeback-fix-queue_io-ordering.patch
writeback-merge-for_kupdate-and-for_kupdate-cases.patch
vfs-add-super-operation-writeback_inodes.patch

