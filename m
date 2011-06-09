From: akpm@linux-foundation.org
Subject: [merged] writeback-sync-expired-inodes-first-in-background-writeback.patch removed from -mm tree
Date: Thu, 09 Jun 2011 12:05:30 -0700
Message-ID: <201106091904.p59J4HWX025386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752963Ab1FITFJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 15:05:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, david@fromorbit.com, jack@suse.cz, kitayama@cl.bb4u.ne.jp, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     writeback: sync expired inodes first in background writeback
has been removed from the -mm tree.  Its filename was
     writeback-sync-expired-inodes-first-in-background-writeback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback: sync expired inodes first in background writeback
From: Wu Fengguang <fengguang.wu@intel.com>

A background flush work may run for ever.  So it's reasonable for it to
mimic the kupdate behavior of syncing old/expired inodes first.

At each queue_io() time, first try enqueuing only newly expired inodes. 
If there are zero expired inodes to work with, then relax the rule and
enqueue all dirty inodes.

This will help reduce the number of dirty pages encountered by page
reclaim, eg.  the pageout() calls.  Normally older inodes contain older
dirty pages, which are more close to the end of the LRU lists.  So syncing
older inodes first helps reducing the dirty pages reached by the page
reclaim code.

More background: as Mel put it, "it makes sense to write old pages first
to reduce the chances page reclaim is initiating IO."

Rik also presented the situation with a graph:

LRU head                                 [*] dirty page
[                          *              *      * *  *  * * * * * *]

Ideally, most dirty pages should lie close to the LRU tail instead of LRU
head.  That requires the flusher thread to sync old/expired inodes first
(as there are obvious correlations between inode age and page age), and to
give fair opportunities to newly expired inodes rather than sticking with
some large eldest inodes (as larger inodes have weaker correlations in the
inode<=>page ages).

This patch helps the flusher to meet both the above requirements.

Side effects: it might reduce the batch size and hence reduce
inode_wb_list_lock hold time, but in turn make the cluster-by-partition
logic in the same function less effective on reducing disk seeks.

v2: keep policy changes inside wb_writeback() and keep the
wbc.older_than_this visibility as suggested by Dave.

[akpm@linux-foundation.org: tweak a comment]
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff -puN fs/fs-writeback.c~writeback-sync-expired-inodes-first-in-background-writeback fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-sync-expired-inodes-first-in-background-writeback
+++ a/fs/fs-writeback.c
@@ -709,7 +709,7 @@ static long wb_writeback(struct bdi_writ
 		if (work->for_background && !over_bground_thresh())
 			break;
 
-		if (work->for_kupdate) {
+		if (work->for_kupdate || work->for_background) {
 			oldest_jif = jiffies -
 				msecs_to_jiffies(dirty_expire_interval * 10);
 			wbc.older_than_this = &oldest_jif;
@@ -720,6 +720,7 @@ static long wb_writeback(struct bdi_writ
 		wbc.pages_skipped = 0;
 		wbc.inodes_cleaned = 0;
 
+retry:
 		trace_wbc_writeback_start(&wbc, wb->bdi);
 		if (work->sb)
 			__writeback_inodes_sb(work->sb, wb, &wbc);
@@ -743,6 +744,19 @@ static long wb_writeback(struct bdi_writ
 		if (wbc.inodes_cleaned)
 			continue;
 		/*
+		 * background writeback will start with expired inodes and if
+		 * none are found, fall back to all inodes. This order helps
+		 * reduce the number of dirty pages reaching the end of LRU lists
+		 * and causing difficulty in page reclaim.
+		 */
+		if (work->for_background &&
+		    wbc.older_than_this &&
+		    list_empty(&wb->b_io) &&
+		    list_empty(&wb->b_more_io)) {
+			wbc.older_than_this = NULL;
+			goto retry;
+		}
+		/*
 		 * No more inodes for IO, bail
 		 */
 		if (!wbc.more_io)
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
bdi_min_ratio-never-shrinks-ultimately-preventing-valid-setting-of-min_ratio.patch

