From: akpm@linux-foundation.org
Subject: [merged] reiserfs-truncate-blocks-not-used-by-a-write-v2.patch removed from -mm tree
Date: Fri, 18 Dec 2009 12:26:10 -0800
Message-ID: <200912182026.nBIKQAO4016443@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932818AbZLRU0Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Dec 2009 15:26:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, jeffm@suse.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: truncate blocks not used by a write
has been removed from the -mm tree.  Its filename was
     reiserfs-truncate-blocks-not-used-by-a-write-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: truncate blocks not used by a write
From: Jan Kara <jack@suse.cz>

It can happen that write does not use all the blocks allocated in
write_begin either because of some filesystem error (like ENOSPC) or
because page with data to write has been removed from memory.  We truncate
these blocks so that we don't have dangling blocks beyond i_size.

Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/inode.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff -puN fs/reiserfs/inode.c~reiserfs-truncate-blocks-not-used-by-a-write-v2 fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~reiserfs-truncate-blocks-not-used-by-a-write-v2
+++ a/fs/reiserfs/inode.c
@@ -2538,6 +2538,12 @@ static int reiserfs_writepage(struct pag
 	return reiserfs_write_full_page(page, wbc);
 }
 
+static void reiserfs_truncate_failed_write(struct inode *inode)
+{
+	truncate_inode_pages(inode->i_mapping, inode->i_size);
+	reiserfs_truncate_file(inode, 0);
+}
+
 static int reiserfs_write_begin(struct file *file,
 				struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned flags,
@@ -2604,6 +2610,8 @@ static int reiserfs_write_begin(struct f
 	if (ret) {
 		unlock_page(page);
 		page_cache_release(page);
+		/* Truncate allocated blocks */
+		reiserfs_truncate_failed_write(inode);
 	}
 	return ret;
 }
@@ -2701,9 +2709,7 @@ static int reiserfs_write_end(struct fil
 	 ** transaction tracking stuff when the size changes.  So, we have
 	 ** to do the i_size updates here.
 	 */
-	pos += copied;
-
-	if (pos > inode->i_size) {
+	if (pos + copied > inode->i_size) {
 		struct reiserfs_transaction_handle myth;
 		lock_depth = reiserfs_write_lock_once(inode->i_sb);
 		locked = true;
@@ -2721,7 +2727,7 @@ static int reiserfs_write_end(struct fil
 			goto journal_error;
 
 		reiserfs_update_inode_transaction(inode);
-		inode->i_size = pos;
+		inode->i_size = pos + copied;
 		/*
 		 * this will just nest into our transaction.  It's important
 		 * to use mark_inode_dirty so the inode gets pushed around on the
@@ -2751,6 +2757,10 @@ static int reiserfs_write_end(struct fil
 		reiserfs_write_unlock_once(inode->i_sb, lock_depth);
 	unlock_page(page);
 	page_cache_release(page);
+
+	if (pos + len > inode->i_size)
+		reiserfs_truncate_failed_write(inode);
+
 	return ret == 0 ? copied : ret;
 
       journal_error:
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
reiser4-update-names-of-quota-methods.patch

