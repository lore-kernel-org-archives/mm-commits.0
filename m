From: akpm@linux-foundation.org
Subject: [merged] ext3-make-sure-inode-is-deleted-from-orphan-list-after-truncate.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:44:55 -0700
Message-ID: <200906182244.n5IMitFF003951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755107AbZFRWpZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:45:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     ext3: make sure inode is deleted from orphan list after truncate
has been removed from the -mm tree.  Its filename was
     ext3-make-sure-inode-is-deleted-from-orphan-list-after-truncate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: make sure inode is deleted from orphan list after truncate
From: Jan Kara <jack@suse.cz>

As Ted pointed out, it can happen that ext3_truncate() returns without
removing inode from orphan list.  This way we could in some rare cases
(like when we get ENOMEM from an allocation in ext3_truncate called
because of failed ext3_write_begin) leave the inode on orphan list and
that triggers assertion failure on umount.

So make ext3_truncate() always remove inode from in-memory orphan list.

Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/inode.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN fs/ext3/inode.c~ext3-make-sure-inode-is-deleted-from-orphan-list-after-truncate fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext3-make-sure-inode-is-deleted-from-orphan-list-after-truncate
+++ a/fs/ext3/inode.c
@@ -2374,7 +2374,7 @@ void ext3_truncate(struct inode *inode)
 	struct page *page;
 
 	if (!ext3_can_truncate(inode))
-		return;
+		goto out_notrans;
 
 	if (inode->i_size == 0 && ext3_should_writeback_data(inode))
 		ei->i_state |= EXT3_STATE_FLUSH_ON_CLOSE;
@@ -2390,7 +2390,7 @@ void ext3_truncate(struct inode *inode)
 		page = grab_cache_page(mapping,
 				inode->i_size >> PAGE_CACHE_SHIFT);
 		if (!page)
-			return;
+			goto out_notrans;
 	}
 
 	handle = start_transaction(inode);
@@ -2401,7 +2401,7 @@ void ext3_truncate(struct inode *inode)
 			unlock_page(page);
 			page_cache_release(page);
 		}
-		return;		/* AKPM: return what? */
+		goto out_notrans;
 	}
 
 	last_block = (inode->i_size + blocksize-1)
@@ -2525,6 +2525,14 @@ out_stop:
 		ext3_orphan_del(handle, inode);
 
 	ext3_journal_stop(handle);
+	return;
+out_notrans:
+	/*
+	 * Delete the inode from orphan list so that it doesn't stay there
+	 * forever and trigger assertion on umount.
+	 */
+	if (inode->i_nlink)
+		ext3_orphan_del(NULL, inode);
 }
 
 static ext3_fsblk_t ext3_get_inode_block(struct super_block *sb,
@@ -3122,12 +3130,6 @@ int ext3_setattr(struct dentry *dentry, 
 
 	rc = inode_setattr(inode, attr);
 
-	/* If inode_setattr's call to ext3_truncate failed to get a
-	 * transaction handle at all, we need to clean up the in-core
-	 * orphan list manually. */
-	if (inode->i_nlink)
-		ext3_orphan_del(NULL, inode);
