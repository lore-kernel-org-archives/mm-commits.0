From: akpm@linux-foundation.org
Subject: [merged] vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:38:03 -0700
Message-ID: <200909241938.n8OJc3KB005804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754530AbZIXTid (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:38:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: split generic_forget_inode() so that hugetlbfs does not have to copy it
has been removed from the -mm tree.  Its filename was
     vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: split generic_forget_inode() so that hugetlbfs does not have to copy it
From: Jan Kara <jack@suse.cz>

Hugetlbfs needs to do special things instead of truncate_inode_pages().
 Currently, it copied generic_forget_inode() except for
truncate_inode_pages() call which is asking for trouble (the code there
isn't trivial).  So create a separate function generic_detach_inode()
which does all the list magic done in generic_forget_inode() and call
it from hugetlbfs_forget_inode().

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   35 +++++------------------------------
 fs/inode.c           |   21 +++++++++++++++++++--
 include/linux/fs.h   |    1 +
 3 files changed, 25 insertions(+), 32 deletions(-)

diff -puN fs/hugetlbfs/inode.c~vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it
+++ a/fs/hugetlbfs/inode.c
@@ -382,36 +382,11 @@ static void hugetlbfs_delete_inode(struc
 
 static void hugetlbfs_forget_inode(struct inode *inode) __releases(inode_lock)
 {
-	struct super_block *sb = inode->i_sb;
-
-	if (!hlist_unhashed(&inode->i_hash)) {
-		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
-			list_move(&inode->i_list, &inode_unused);
-		inodes_stat.nr_unused++;
-		if (!sb || (sb->s_flags & MS_ACTIVE)) {
-			spin_unlock(&inode_lock);
-			return;
-		}
-		inode->i_state |= I_WILL_FREE;
-		spin_unlock(&inode_lock);
-		/*
-		 * write_inode_now is a noop as we set BDI_CAP_NO_WRITEBACK
-		 * in our backing_dev_info.
-		 */
-		write_inode_now(inode, 1);
-		spin_lock(&inode_lock);
-		inode->i_state &= ~I_WILL_FREE;
-		inodes_stat.nr_unused--;
-		hlist_del_init(&inode->i_hash);
-	}
-	list_del_init(&inode->i_list);
-	list_del_init(&inode->i_sb_list);
-	inode->i_state |= I_FREEING;
-	inodes_stat.nr_inodes--;
-	spin_unlock(&inode_lock);
-	truncate_hugepages(inode, 0);
-	clear_inode(inode);
-	destroy_inode(inode);
+	if (generic_detach_inode(inode)) {
+		truncate_hugepages(inode, 0);
+		clear_inode(inode);
+		destroy_inode(inode);
+	}
 }
 
 static void hugetlbfs_drop_inode(struct inode *inode)
diff -puN fs/inode.c~vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it fs/inode.c
--- a/fs/inode.c~vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it
+++ a/fs/inode.c
@@ -1236,7 +1236,16 @@ void generic_delete_inode(struct inode *
 }
 EXPORT_SYMBOL(generic_delete_inode);
 
-static void generic_forget_inode(struct inode *inode)
+/**
+ *	generic_detach_inode - remove inode from inode lists
+ *	@inode: inode to remove
+ *
+ *	Remove inode from inode lists, write it if it's dirty. This is just an
+ *	internal VFS helper exported for hugetlbfs. Do not use!
+ *
+ *	Returns 1 if inode should be completely destroyed.
+ */
+int generic_detach_inode(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 
@@ -1246,7 +1255,7 @@ static void generic_forget_inode(struct 
 		inodes_stat.nr_unused++;
 		if (sb->s_flags & MS_ACTIVE) {
 			spin_unlock(&inode_lock);
-			return;
+			return 0;
 		}
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_WILL_FREE;
@@ -1264,6 +1273,14 @@ static void generic_forget_inode(struct 
 	inode->i_state |= I_FREEING;
 	inodes_stat.nr_inodes--;
 	spin_unlock(&inode_lock);
+	return 1;
+}
+EXPORT_SYMBOL_GPL(generic_detach_inode);
+
+static void generic_forget_inode(struct inode *inode)
+{
+	if (!generic_detach_inode(inode))
+		return;
 	if (inode->i_data.nrpages)
 		truncate_inode_pages(&inode->i_data, 0);
 	clear_inode(inode);
diff -puN include/linux/fs.h~vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it include/linux/fs.h
--- a/include/linux/fs.h~vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it
+++ a/include/linux/fs.h
@@ -2159,6 +2159,7 @@ extern ino_t iunique(struct super_block 
 extern int inode_needs_sync(struct inode *inode);
 extern void generic_delete_inode(struct inode *inode);
 extern void generic_drop_inode(struct inode *inode);
+extern int generic_detach_inode(struct inode *inode);
 
 extern struct inode *ilookup5_nowait(struct super_block *sb,
 		unsigned long hashval, int (*test)(struct inode *, void *),
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch
reiserfs-truncate-blocks-not-used-by-a-write-v2.patch
reiser4-update-names-of-quota-methods.patch

