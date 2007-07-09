From: akpm@linux-foundation.org
Subject: - reiser4-make-sync_inodes-non-void.patch removed from -mm tree
Date: Mon, 09 Jul 2007 16:58:39 -0700
Message-ID: <200707092358.l69Nwdhl021979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48336 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760236AbXGIX64 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 19:58:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4 make sync_inodes non-void
has been removed from the -mm tree.  Its filename was
     reiser4-make-sync_inodes-non-void.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4 make sync_inodes non-void
From: Edward Shishkin <edward@namesys.com>

Make reiser4_sync_inodes non-void

Signed-off-by: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/super_ops.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN fs/reiser4/super_ops.c~reiser4-make-sync_inodes-non-void fs/reiser4/super_ops.c
--- a/fs/reiser4/super_ops.c~reiser4-make-sync_inodes-non-void
+++ a/fs/reiser4/super_ops.c
@@ -390,15 +390,16 @@ static void reiser4_clear_inode(struct i
  * mapping - dirty pages get into atoms. Writeout is called to flush some
  * atoms.
  */
-static void reiser4_sync_inodes(struct super_block *super,
-				struct writeback_control *wbc)
+static int reiser4_sync_inodes(struct super_block *super,
+			       struct writeback_control *wbc)
 {
 	reiser4_context *ctx;
 	long to_write;
+	int ret;
 
 	if (wbc->for_kupdate)
 		/* reiser4 has its own means of periodical write-out */
-		return;
+		return 0;
 
 	to_write = wbc->nr_to_write;
 	assert("vs-49", wbc->older_than_this == NULL);
@@ -406,14 +407,14 @@ static void reiser4_sync_inodes(struct s
 	ctx = reiser4_init_context(super);
 	if (IS_ERR(ctx)) {
 		warning("vs-13", "failed to init context");
-		return;
+		return PTR_ERR(ctx);
 	}
 
 	/*
 	 * call reiser4_writepages for each of dirty inodes to turn dirty pages
 	 * into transactions if they were not yet.
 	 */
-	generic_sync_sb_inodes(super, wbc);
+	ret = generic_sync_sb_inodes(super, wbc);
 
 	/* flush goes here */
 	wbc->nr_to_write = to_write;
@@ -422,6 +423,7 @@ static void reiser4_sync_inodes(struct s
 	/* avoid recursive calls to ->sync_inodes */
 	context_set_commit_async(ctx);
 	reiser4_exit_context(ctx);
+	return ret;
 }
 
 /**
_

Patches currently in -mm which might be from edward@namesys.com are

reiser4.patch
reiser4-make-sync_inodes-non-void.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
reiser4-fix-for-new-aops-patches.patch
git-block-vs-reiser4.patch
