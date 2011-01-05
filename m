From: akpm@linux-foundation.org
Subject: [folded] reiser4-writeback_inodes-implementation.patch removed from -mm tree
Date: Tue, 04 Jan 2011 16:36:03 -0800
Message-ID: <201101050036.p050a32R000713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486Ab1AEAgG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 19:36:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: writeback_inodes() implementation
has been removed from the -mm tree.  Its filename was
     reiser4-writeback_inodes-implementation.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: writeback_inodes() implementation
From: Edward Shishkin <edward.shishkin@gmail.com>

. add reiser4 implementation of ->writeback_inodes()
  super operation;
. cleanup comments.

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/context.c    |    3 +-
 fs/reiser4/context.h    |    2 -
 fs/reiser4/entd.c       |    7 +++--
 fs/reiser4/page_cache.c |   12 ++++-----
 fs/reiser4/super_ops.c  |   49 +++++++++++++++++++++++---------------
 fs/reiser4/txnmgr.c     |    2 -
 6 files changed, 45 insertions(+), 30 deletions(-)

diff -puN fs/reiser4/context.c~reiser4-writeback_inodes-implementation fs/reiser4/context.c
--- a/fs/reiser4/context.c~reiser4-writeback_inodes-implementation
+++ a/fs/reiser4/context.c
@@ -151,7 +151,8 @@ static void reiser4_throttle_write_at(re
 	 */
 	if (sbinfo != NULL && sbinfo->fake != NULL &&
 	    context->nr_marked_dirty != 0 &&
-	    !(current->flags & PF_MEMALLOC))
+	    !(current->flags & PF_MEMALLOC) &&
+	    !current_is_flush_bd_task())
 		/* FIXME-EDWARD: throttle with nr_marked_dirty? */
 		reiser4_throttle_write(sbinfo->fake, 1);
 }
diff -puN fs/reiser4/context.h~reiser4-writeback_inodes-implementation fs/reiser4/context.h
--- a/fs/reiser4/context.h~reiser4-writeback_inodes-implementation
+++ a/fs/reiser4/context.h
@@ -66,7 +66,7 @@ struct reiser4_context {
 	/* count non-trivial jnode_set_dirty() calls */
 	unsigned long nr_marked_dirty;
 
-	/* reiser4_sync_inodes calls (via generic_sync_sb_inodes)
+	/* reiser4_writeback_inodes calls (via generic_writeback_sb_inodes)
 	 * reiser4_writepages for each of dirty inodes. Reiser4_writepages
 	 * captures pages. When number of pages captured in one
 	 * reiser4_sync_inodes reaches some threshold - some atoms get
diff -puN fs/reiser4/entd.c~reiser4-writeback_inodes-implementation fs/reiser4/entd.c
--- a/fs/reiser4/entd.c~reiser4-writeback_inodes-implementation
+++ a/fs/reiser4/entd.c
@@ -236,16 +236,19 @@ static void entd_flush(struct super_bloc
 	rq->wbc->range_end = rq->wbc->range_start +
 		(ENTD_CAPTURE_APAGE_BURST << PAGE_CACHE_SHIFT);
 	tmp = rq->wbc->nr_to_write;
+
+	assert("edward-1561", super == rq->wbc->sb);
+
 	rq->mapping->a_ops->writepages(rq->mapping, rq->wbc);
 
 	if (rq->wbc->nr_to_write > 0) {
 		rq->wbc->range_start = 0;
 		rq->wbc->range_end = LLONG_MAX;
-		generic_sync_sb_inodes(rq->wbc);
+		writeback_inodes_wbc(rq->wbc);
 	}
 	rq->wbc->nr_to_write = ENTD_CAPTURE_APAGE_BURST;
-	reiser4_writeout(super, rq->wbc);
 
+	reiser4_writeout(super, rq->wbc);
 	context_set_commit_async(&ctx);
 	reiser4_exit_context(&ctx);
 }
diff -puN fs/reiser4/page_cache.c~reiser4-writeback_inodes-implementation fs/reiser4/page_cache.c
--- a/fs/reiser4/page_cache.c~reiser4-writeback_inodes-implementation
+++ a/fs/reiser4/page_cache.c
@@ -486,15 +486,15 @@ static int can_hit_entd(reiser4_context 
 int reiser4_writepage(struct page *page,
 		      struct writeback_control *wbc)
 {
-	struct super_block *s;
-	reiser4_context *ctx;
-
+	/*
+	 * assert("edward-1562",
+	 * can_hit_entd(get_current_context_check(), sb));
+	 */
 	assert("vs-828", PageLocked(page));
 
-	s = page->mapping->host->i_sb;
-	ctx = get_current_context_check();
+	wbc->sb = page->mapping->host->i_sb;
+	wbc->bdi = page->mapping->backing_dev_info;
 
-	/* assert("", can_hit_entd(ctx, s)); */
 	return write_page_by_ent(page, wbc);
 }
 
diff -puN fs/reiser4/super_ops.c~reiser4-writeback_inodes-implementation fs/reiser4/super_ops.c
--- a/fs/reiser4/super_ops.c~reiser4-writeback_inodes-implementation
+++ a/fs/reiser4/super_ops.c
@@ -379,48 +379,59 @@ static void reiser4_clear_inode(struct i
 }
 
 /**
- * reiser4_sync_inodes - sync_inodes of super operations
+ * reiser4_writeback_inodes - writeback_inodes of super operations
  * @super:
+ * @wb:
  * @wbc:
  *
  * This method is called by background and non-backgound writeback. Reiser4's
- * implementation uses generic_sync_sb_inodes to call reiser4_writepages for
- * each of dirty inodes. Reiser4_writepages handles pages dirtied via shared
- * mapping - dirty pages get into atoms. Writeout is called to flush some
- * atoms.
+ * implementation uses generic_writeback_sb_inodes to call reiser4_writepages
+ * for each of dirty inodes. reiser4_writepages handles pages dirtied via shared
+ * mapping - dirty pages get into atoms. Writeout is called to flush some atoms.
  */
-static void reiser4_sync_inodes(struct super_block *super,
-			       struct writeback_control *wbc)
+static int reiser4_writeback_inodes(struct super_block *super,
+				    struct bdi_writeback *wb,
+				    struct writeback_control *wbc)
 {
-	reiser4_context *ctx;
+	int ret;
 	long to_write;
+	reiser4_context *ctx;
 
 	if (wbc->for_kupdate)
 		/* reiser4 has its own means of periodical write-out */
-		return;
-
-	to_write = wbc->nr_to_write;
+		goto skip;
 	assert("vs-49", wbc->older_than_this == NULL);
 
+	spin_unlock(&inode_lock);
 	ctx = reiser4_init_context(super);
 	if (IS_ERR(ctx)) {
 		warning("vs-13", "failed to init context");
-		return;
+		spin_lock(&inode_lock);
+		goto skip;
 	}
-
+	to_write = wbc->nr_to_write;
 	/*
-	 * call reiser4_writepages for each of dirty inodes to turn dirty pages
-	 * into transactions if they were not yet.
+	 * call reiser4_writepages for each of dirty inodes to turn
+	 * dirty pages into transactions if they were not yet.
 	 */
-	generic_sync_sb_inodes(wbc);
+	spin_lock(&inode_lock);
+	ret = generic_writeback_sb_inodes(super, wb, wbc);
+	spin_unlock(&inode_lock);
 
-	/* flush goes here */
 	wbc->nr_to_write = to_write;
+
+	/* flush goes here */
 	reiser4_writeout(super, wbc);
 
-	/* avoid recursive calls to ->sync_inodes */
+	/* avoid recursive calls to ->writeback_inodes */
 	context_set_commit_async(ctx);
 	reiser4_exit_context(ctx);
+	spin_lock(&inode_lock);
+
+	return wbc->nr_to_write <= 0 ? 1 : ret;
+ skip:
+	writeback_skip_sb_inodes(super, wb);
+	return 0;
 }
 
 /**
@@ -458,7 +469,7 @@ struct super_operations reiser4_super_op
 	.write_super = reiser4_write_super,
 	.statfs = reiser4_statfs,
 	.clear_inode = reiser4_clear_inode,
-	.sync_inodes = reiser4_sync_inodes,
+	.writeback_inodes = reiser4_writeback_inodes,
 	.show_options = reiser4_show_options
 };
 
diff -puN fs/reiser4/txnmgr.c~reiser4-writeback_inodes-implementation fs/reiser4/txnmgr.c
--- a/fs/reiser4/txnmgr.c~reiser4-writeback_inodes-implementation
+++ a/fs/reiser4/txnmgr.c
@@ -1410,7 +1410,7 @@ flush_some_atom(jnode * start, long *nr_
 		 * Write throttling is case of no one atom can be
 		 * flushed/committed.
 		 */
-		if (!wbc->nonblocking) {
+		if (!wbc->nonblocking && !current_is_flush_bd_task()) {
 			list_for_each_entry(atom, &tmgr->atoms_list, atom_link) {
 				spin_lock_atom(atom);
 				/* Repeat the check from the above. */
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

linux-next.patch
reiserfs-make-sure-va_end-is-always-called-after-va_start.patch
vfs-add-super-operation-writeback_inodes.patch
vfs-add-super-operation-writeback_inodes-fix.patch
vfs-take-2add-set_page_dirty_notag.patch
vfs-change-writeback_inodes-signature.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-writeback_inodes-implementation-adjust-to-writeback-changes.patch
reiser4-fixup-checkin-checkout-jnodes-for-entd.patch
reiser4-fixups.patch
reiser4-broke.patch

