From: akpm@linux-foundation.org
Subject: - reiserfs-discard-prealloc-in-reiserfs_delete_inode.patch removed from -mm tree
Date: Fri, 11 Jul 2008 16:50:53 -0700
Message-ID: <200807112350.m6BNorgV010988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754494AbYGKXvI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 19:51:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     reiserfs: discard prealloc in reiserfs_delete_inode
has been removed from the -mm tree.  Its filename was
     reiserfs-discard-prealloc-in-reiserfs_delete_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: discard prealloc in reiserfs_delete_inode
From: Jeff Mahoney <jeffm@suse.com>

With the removal of struct file from the xattr code, reiserfs_file_release()
isn't used anymore, so the prealloc isn't discarded.  This causes hangs later
down the line.

This patch adds it to reiserfs_delete_inode.  In most cases it will be a no-op
due to it already having been called, but will avoid hangs with xattrs.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/reiserfs/inode.c~reiserfs-discard-prealloc-in-reiserfs_delete_inode fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~reiserfs-discard-prealloc-in-reiserfs_delete_inode
+++ a/fs/reiserfs/inode.c
@@ -45,6 +45,8 @@ void reiserfs_delete_inode(struct inode 
 			goto out;
 		reiserfs_update_inode_transaction(inode);
 
+		reiserfs_discard_prealloc(&th, inode);
+
 		err = reiserfs_delete_object(&th, inode);
 
 		/* Do quota update inside a transaction for journaled quotas. We must do that
_

Patches currently in -mm which might be from jeffm@suse.com are

origin.patch
reiserfs-convert-j_lock-to-mutex.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch

