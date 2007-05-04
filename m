From: akpm@linux-foundation.org
Subject: + reiser4-make-sync_inodes-non-void.patch added to -mm tree
Date: Fri, 04 May 2007 14:29:52 -0700
Message-ID: <200705042129.l44LTq1H014452@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161937AbXEDVaC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 17:30:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward@namesys.com


The patch titled
     reiser4 make sync_inodes non-void
has been added to the -mm tree.  Its filename is
     reiser4-make-sync_inodes-non-void.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiser4 make sync_inodes non-void
From: Edward Shishkin <edward@namesys.com>

Make reiser4_sync_inodes non-void

Signed-off-by: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/super_ops.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff -puN fs/reiser4/super_ops.c~reiser4-make-sync_inodes-non-void fs/reiser4/super_ops.c
--- a/fs/reiser4/super_ops.c~reiser4-make-sync_inodes-non-void
+++ a/fs/reiser4/super_ops.c
@@ -392,15 +392,16 @@ static void reiser4_clear_inode(struct i
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
@@ -408,14 +409,14 @@ static void reiser4_sync_inodes(struct s
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
@@ -424,6 +425,7 @@ static void reiser4_sync_inodes(struct s
 	/* avoid recursive calls to ->sync_inodes */
 	context_set_commit_async(ctx);
 	reiser4_exit_context(ctx);
+	return ret;
 }
 
 /**
_

Patches currently in -mm which might be from edward@namesys.com are

reiser4.patch
reiser4-fix-for-drop-unused-semaphorespatch.patch
reiser4-use-simple_prepare_write-to-zero-page-data.patch
reiser4-use-zero_user_page.patch
reiser4-remove-typedefs.patch
reiser4-fix-write_extent.patch
reiser4-make-sync_inodes-non-void.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
