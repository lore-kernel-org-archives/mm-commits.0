From: akpm@linux-foundation.org
Subject: [merged] reiserfs-dont-acquire-lock-recursively-in-reiserfs_acl_chmod.patch removed from -mm tree
Date: Tue, 07 Dec 2010 11:46:38 -0800
Message-ID: <201012071948.oB7JmD2U004595@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753845Ab0LGTsU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2010 14:48:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, jeffm@suse.com, pzawora@gmail.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     reiserfs: don't acquire lock recursively in reiserfs_acl_chmod
has been removed from the -mm tree.  Its filename was
     reiserfs-dont-acquire-lock-recursively-in-reiserfs_acl_chmod.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: don't acquire lock recursively in reiserfs_acl_chmod
From: Frederic Weisbecker <fweisbec@gmail.com>

reiserfs_acl_chmod() can be called by reiserfs_set_attr() and then take
the reiserfs lock a second time.  Thereafter it may call journal_begin()
that definitely requires the lock not to be nested in order to release it
before taking the journal mutex because the reiserfs lock depends on the
journal mutex already.

So, aviod nesting the lock in reiserfs_acl_chmod().

Reported-by: Pawel Zawora <pzawora@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Tested-by: Pawel Zawora <pzawora@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: <stable@kernel.org>		[2.6.32.x+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/xattr_acl.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/reiserfs/xattr_acl.c~reiserfs-dont-acquire-lock-recursively-in-reiserfs_acl_chmod fs/reiserfs/xattr_acl.c
--- a/fs/reiserfs/xattr_acl.c~reiserfs-dont-acquire-lock-recursively-in-reiserfs_acl_chmod
+++ a/fs/reiserfs/xattr_acl.c
@@ -472,7 +472,9 @@ int reiserfs_acl_chmod(struct inode *ino
 		struct reiserfs_transaction_handle th;
 		size_t size = reiserfs_xattr_nblocks(inode,
 					     reiserfs_acl_size(clone->a_count));
-		reiserfs_write_lock(inode->i_sb);
+		int depth;
+
+		depth = reiserfs_write_lock_once(inode->i_sb);
 		error = journal_begin(&th, inode->i_sb, size * 2);
 		if (!error) {
 			int error2;
@@ -482,7 +484,7 @@ int reiserfs_acl_chmod(struct inode *ino
 			if (error2)
 				error = error2;
 		}
-		reiserfs_write_unlock(inode->i_sb);
+		reiserfs_write_unlock_once(inode->i_sb, depth);
 	}
 	posix_acl_release(clone);
 	return error;
_

Patches currently in -mm which might be from fweisbec@gmail.com are

linux-next.patch

