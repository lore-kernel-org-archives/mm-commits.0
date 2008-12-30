From: akpm@linux-foundation.org
Subject: - reiser4-fix-kill_hook_internal.patch removed from -mm tree
Date: Tue, 30 Dec 2008 15:10:44 -0800
Message-ID: <200812302310.mBUNAipu019581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752540AbYL3XLQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 18:11:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: fix kill_hook_internal
has been removed from the -mm tree.  Its filename was
     reiser4-fix-kill_hook_internal.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: fix kill_hook_internal
From: Edward Shishkin <edward.shishkin@gmail.com>

Problem:
Failed assertion (nikita-2754): child znode is not loaded
when looking at its number of items in kill_hook_internal().
Nobody cares about its loading.

Fixup:
Added missed zload/zrelse of the child.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/item/internal.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN fs/reiser4/plugin/item/internal.c~reiser4-fix-kill_hook_internal fs/reiser4/plugin/item/internal.c
--- a/fs/reiser4/plugin/item/internal.c~reiser4-fix-kill_hook_internal
+++ a/fs/reiser4/plugin/item/internal.c
@@ -308,6 +308,7 @@ int kill_hook_internal(const coord_t * i
 		       struct carry_kill_data *p UNUSED_ARG)
 {
 	znode *child;
+	int result = 0;
 
 	assert("nikita-1222", item != NULL);
 	assert("nikita-1224", from == 0);
@@ -316,7 +317,14 @@ int kill_hook_internal(const coord_t * i
 	child = znode_at(item, item->node);
 	if (IS_ERR(child))
 		return PTR_ERR(child);
-	else if (node_is_empty(child)) {
+	assert("edward-1560", child != NULL);
+
+	result = zload(child);
+	if (result) {
+		zput(child);
+		return result;
+	}
+	if (node_is_empty(child)) {
 		reiser4_tree *tree;
 
 		assert("nikita-1397", znode_is_write_locked(child));
@@ -328,14 +336,14 @@ int kill_hook_internal(const coord_t * i
 		init_parent_coord(&child->in_parent, NULL);
 		--item->node->c_count;
 		write_unlock_tree(tree);
-		zput(child);
-		return 0;
 	} else {
 		warning("nikita-1223",
 			"Cowardly refuse to remove link to non-empty node");
-		zput(child);
-		return RETERR(-EIO);
+		result = RETERR(-EIO);
 	}
+	zrelse(child);
+	zput(child);
+	return result;
 }
 
 /* hook called by ->shift() node plugin method when iternal item was just
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

reiser4-vfs-add-super_operationssync_inodes-2.patch
reiser4.patch
reiser4-fix-kill_hook_internal.patch
reiser4-semaphore-fix.patch
reiser4-compile-warning-cleanups.patch
reiser4-use-wake_up_process-instead-of-wake_up-when-possible.patch
reiser4-track-upstream-changes.patch
reiser4-adjust-to-the-new-aops.patch
reiser4-adjust-to-the-new-aops-fixup.patch
reiser4-remove-simple_prepare_write-usage.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
reiser4-handling-error-returned-by-d_obtain_alias-fixup.patch

