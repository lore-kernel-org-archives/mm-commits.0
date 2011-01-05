From: akpm@linux-foundation.org
Subject: [folded] reiser4-remove-inode_setattr.patch removed from -mm tree
Date: Tue, 04 Jan 2011 16:35:58 -0800
Message-ID: <201101050035.p050Zwxn000701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751146Ab1AEAgA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 19:36:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: remove inode_setattr
has been removed from the -mm tree.  Its filename was
     reiser4-remove-inode_setattr.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: remove inode_setattr
From: Edward Shishkin <edward.shishkin@gmail.com>

Adjust reiser4 to vfs changes:
inode_setattr() has been removed.

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/inode_ops.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN fs/reiser4/plugin/inode_ops.c~reiser4-remove-inode_setattr fs/reiser4/plugin/inode_ops.c
--- a/fs/reiser4/plugin/inode_ops.c~reiser4-remove-inode_setattr
+++ a/fs/reiser4/plugin/inode_ops.c
@@ -446,7 +446,9 @@ int reiser4_setattr_common(struct dentry
 	assert("nikita-3119", !(attr->ia_valid & ATTR_SIZE));
 
 	/*
-	 * grab disk space and call standard inode_setattr().
+	 * grab disk space and call standard
+	 * setattr_copy();
+	 * mark_inode_dirty().
 	 */
 	result = setattr_reserve(reiser4_tree_by_inode(inode));
 	if (!result) {
@@ -460,9 +462,9 @@ int reiser4_setattr_common(struct dentry
 				return result;
 			}
 		}
-		result = inode_setattr(inode, attr);
-		if (!result)
-			reiser4_update_sd(inode);
+		setattr_copy(inode, attr);
+		mark_inode_dirty(inode);
+		result = reiser4_update_sd(inode);
 	}
 
 	context_set_commit_async(ctx);
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

linux-next.patch
reiserfs-make-sure-va_end-is-always-called-after-va_start.patch
vfs-add-super-operation-writeback_inodes.patch
vfs-add-super-operation-writeback_inodes-fix.patch
vfs-take-2add-set_page_dirty_notag.patch
vfs-change-writeback_inodes-signature.patch
reiser4.patch
reiser4-change-fsync-signature.patch
reiser4-writeback_inodes-implementation.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-writeback_inodes-implementation-adjust-to-writeback-changes.patch
reiser4-fixup-checkin-checkout-jnodes-for-entd.patch
reiser4-fixups.patch
reiser4-broke.patch

