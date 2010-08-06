From: akpm@linux-foundation.org
Subject: + mm-avoid-resetting-wb_start-after-each-writeback-round.patch added to -mm tree
Date: Thu, 05 Aug 2010 17:21:51 -0700
Message-ID: <201008060021.o760LpSl014748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934047Ab0HFAWx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Aug 2010 20:22:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, axboe@kernel.dk, fengguang.wu@intel.com, hch@lst.de


The patch titled
     mm: avoid resetting wb_start after each writeback round
has been added to the -mm tree.  Its filename is
     mm-avoid-resetting-wb_start-after-each-writeback-round.patch

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
Subject: mm: avoid resetting wb_start after each writeback round
From: Jan Kara <jack@suse.cz>

WB_SYNC_NONE writeback is done in rounds of 1024 pages so that we don't
write out some huge inode for too long while starving writeout of other
inodes.  To avoid livelocks, we record time we started writeback in
wbc->wb_start and do not write out inodes which were dirtied after this
time.  But currently, writeback_inodes_wb() resets wb_start each time it
is called thus effectively invalidating this logic and making any
WB_SYNC_NONE writeback prone to livelocks.

This patch makes sure wb_start is set only once when we start writeback.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/fs-writeback.c~mm-avoid-resetting-wb_start-after-each-writeback-round fs/fs-writeback.c
--- a/fs/fs-writeback.c~mm-avoid-resetting-wb_start-after-each-writeback-round
+++ a/fs/fs-writeback.c
@@ -524,7 +524,8 @@ void writeback_inodes_wb(struct bdi_writ
 {
 	int ret = 0;
 
-	wbc->wb_start = jiffies; /* livelock avoidance */
+	if (!wbc->wb_start)
+		wbc->wb_start = jiffies; /* livelock avoidance */
 	spin_lock(&inode_lock);
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
@@ -553,7 +554,6 @@ static void __writeback_inodes_sb(struct
 {
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	wbc->wb_start = jiffies; /* livelock avoidance */
 	spin_lock(&inode_lock);
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
@@ -619,6 +619,7 @@ static long wb_writeback(struct bdi_writ
 		wbc.range_end = LLONG_MAX;
 	}
 
+	wbc.wb_start = jiffies; /* livelock avoidance */
 	for (;;) {
 		/*
 		 * Stop writeback when nr_pages has been consumed
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch
radix-tree-implement-function-radix_tree_range_tag_if_tagged.patch
mm-implement-writeback-livelock-avoidance-using-page-tagging.patch
writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages.patch
writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages-update.patch
writeback-dont-redirty-tail-an-inode-with-dirty-pages.patch
mm-fix-writeback_in_progress.patch
mm-avoid-resetting-wb_start-after-each-writeback-round.patch
aio-do-not-return-erestartsys-and-friends-from-aio.patch
reiser4.patch

