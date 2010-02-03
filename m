From: akpm@linux-foundation.org
Subject: [nacked] reiser4-generic_sync_sb_inodes-doesnt-exist-anymore.patch removed from -mm tree
Date: Wed, 03 Feb 2010 12:12:49 -0800
Message-ID: <201002032012.o13KCnK3016335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757783Ab0BCUNK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 15:13:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: buchner.johannes@gmx.at, edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: generic_sync_sb_inodes doesn't exist anymore
has been removed from the -mm tree.  Its filename was
     reiser4-generic_sync_sb_inodes-doesnt-exist-anymore.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: generic_sync_sb_inodes doesn't exist anymore
From: Johannes Buchner <buchner.johannes@gmx.at>

> generic_sync_sb_inodes was removed in d8a8559cd7a9cc,
> writeback_inodes_sb and sync_inodes_sb should replace them.
Second version, now also fixes the last comments relating to
generic_sync_sb_inodes.

Cc: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/context.h   |    2 +-
 fs/reiser4/entd.c      |    4 +++-
 fs/reiser4/super_ops.c |    6 ++++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff -puN fs/reiser4/context.h~reiser4-generic_sync_sb_inodes-doesnt-exist-anymore fs/reiser4/context.h
--- a/fs/reiser4/context.h~reiser4-generic_sync_sb_inodes-doesnt-exist-anymore
+++ a/fs/reiser4/context.h
@@ -66,7 +66,7 @@ struct reiser4_context {
 	/* count non-trivial jnode_set_dirty() calls */
 	unsigned long nr_marked_dirty;
 
-	/* reiser4_sync_inodes calls (via generic_sync_sb_inodes)
+	/* reiser4_sync_inodes calls (via writeback/sync_inodes_sb)
 	 * reiser4_writepages for each of dirty inodes. Reiser4_writepages
 	 * captures pages. When number of pages captured in one
 	 * reiser4_sync_inodes reaches some threshold - some atoms get
diff -puN fs/reiser4/entd.c~reiser4-generic_sync_sb_inodes-doesnt-exist-anymore fs/reiser4/entd.c
--- a/fs/reiser4/entd.c~reiser4-generic_sync_sb_inodes-doesnt-exist-anymore
+++ a/fs/reiser4/entd.c
@@ -241,7 +241,9 @@ static void entd_flush(struct super_bloc
 	if (rq->wbc->nr_to_write > 0) {
 		rq->wbc->range_start = 0;
 		rq->wbc->range_end = LLONG_MAX;
-		generic_sync_sb_inodes(rq->wbc);
+		writeback_inodes_sb(super);
+		if (rq->wbc->sync_mode == WB_SYNC_ALL)
+			sync_inodes_sb(super);
 	}
 	rq->wbc->nr_to_write = ENTD_CAPTURE_APAGE_BURST;
 	reiser4_writeout(super, rq->wbc);
diff -puN fs/reiser4/super_ops.c~reiser4-generic_sync_sb_inodes-doesnt-exist-anymore fs/reiser4/super_ops.c
--- a/fs/reiser4/super_ops.c~reiser4-generic_sync_sb_inodes-doesnt-exist-anymore
+++ a/fs/reiser4/super_ops.c
@@ -384,7 +384,7 @@ static void reiser4_clear_inode(struct i
  * @wbc:
  *
  * This method is called by background and non-backgound writeback. Reiser4's
- * implementation uses generic_sync_sb_inodes to call reiser4_writepages for
+ * implementation uses writeback/sync_inodes_sb to call reiser4_writepages for
  * each of dirty inodes. Reiser4_writepages handles pages dirtied via shared
  * mapping - dirty pages get into atoms. Writeout is called to flush some
  * atoms.
@@ -412,7 +412,9 @@ static void reiser4_sync_inodes(struct s
 	 * call reiser4_writepages for each of dirty inodes to turn dirty pages
 	 * into transactions if they were not yet.
 	 */
-	generic_sync_sb_inodes(wbc);
+	writeback_inodes_sb(super);
+	if (wbc->sync_mode == WB_SYNC_ALL)
+		sync_inodes_sb(super);
 
 	/* flush goes here */
 	wbc->nr_to_write = to_write;
_

Patches currently in -mm which might be from buchner.johannes@gmx.at are

reiser4-some-changes-from-reiser4-2631-patch.patch
reiser4-some-comments-were-still-mentioning-pdflush.patch
reiser4-generic_sync_sb_inodes-doesnt-exist-anymore.patch

