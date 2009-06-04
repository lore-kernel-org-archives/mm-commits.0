From: akpm@linux-foundation.org
Subject: + vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it.patch added to -mm tree
Date: Thu, 04 Jun 2009 15:18:55 -0700
Message-ID: <200906042218.n54MItZj028074@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751077AbZFDWTH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Jun 2009 18:19:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     vfs: split generic_forget_inode() so that hugetlbfs does not have to copy it
has been added to the -mm tree.  Its filename is
     vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -381,36 +381,11 @@ static void hugetlbfs_delete_inode(struc
 
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
@@ -1193,7 +1193,16 @@ void generic_delete_inode(struct inode *
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
 
@@ -1203,7 +1212,7 @@ static void generic_forget_inode(struct 
 		inodes_stat.nr_unused++;
 		if (sb->s_flags & MS_ACTIVE) {
 			spin_unlock(&inode_lock);
-			return;
+			return 0;
 		}
 		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_WILL_FREE;
@@ -1221,6 +1230,14 @@ static void generic_forget_inode(struct 
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
@@ -2136,6 +2136,7 @@ extern ino_t iunique(struct super_block 
 extern int inode_needs_sync(struct inode *inode);
 extern void generic_delete_inode(struct inode *inode);
 extern void generic_drop_inode(struct inode *inode);
+extern int generic_detach_inode(struct inode *inode);
 
 extern struct inode *ilookup5_nowait(struct super_block *sb,
 		unsigned long hashval, int (*test)(struct inode *, void *),
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it.patch
ext2-add-blk_issue_flush-to-syncing-paths.patch
mm-remove-__invalidate_mapping_pages-variant.patch
ext2-do-not-update-mtime-of-a-moved-directory.patch
ext3-fix-chain-verification-in-ext3_get_blocks.patch
isofs-let-mode-and-dmode-mount-options-override-rock-ridge-mode-setting.patch
isofs-fix-setting-of-uid-and-gid-to-0.patch
isofs-cleanup-mount-option-processing.patch
reiser4-update-names-of-quota-methods.patch

