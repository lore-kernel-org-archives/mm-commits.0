From: akpm@linux-foundation.org
Subject: - vfs-kill-put_inode.patch removed from -mm tree
Date: Mon, 05 May 2008 12:16:26 -0700
Message-ID: <200805051916.m45JGQsc032762@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763630AbYEETQq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 15:16:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, viro@zeniv.linux.org.uk, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     vfs: kill->put_inode
has been removed from the -mm tree.  Its filename was
     vfs-kill-put_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: kill->put_inode
From: Christoph Hellwig <hch@lst.de>

With the patch to affs killing the last put_inode() instance we can finally,
after many years of transition kill this racy and awkward interface.

(It's kinda funny that even the description in
Documentation/filesystems/vfs.txt was entirely wrong..)

Also remove a very misleading comment above the defintion of struct
super_operations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/Locking |    2 --
 Documentation/filesystems/vfs.txt |    4 ----
 fs/inode.c                        |    3 ---
 include/linux/fs.h                |    5 -----
 4 files changed, 14 deletions(-)

diff -puN Documentation/filesystems/Locking~vfs-kill-put_inode Documentation/filesystems/Locking
--- a/Documentation/filesystems/Locking~vfs-kill-put_inode
+++ a/Documentation/filesystems/Locking
@@ -92,7 +92,6 @@ prototypes:
 	void (*destroy_inode)(struct inode *);
 	void (*dirty_inode) (struct inode *);
 	int (*write_inode) (struct inode *, int);
-	void (*put_inode) (struct inode *);
 	void (*drop_inode) (struct inode *);
 	void (*delete_inode) (struct inode *);
 	void (*put_super) (struct super_block *);
@@ -115,7 +114,6 @@ alloc_inode:		no	no	no
 destroy_inode:		no
 dirty_inode:		no				(must not sleep)
 write_inode:		no
-put_inode:		no
 drop_inode:		no				!!!inode_lock!!!
 delete_inode:		no
 put_super:		yes	yes	no
diff -puN Documentation/filesystems/vfs.txt~vfs-kill-put_inode Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~vfs-kill-put_inode
+++ a/Documentation/filesystems/vfs.txt
@@ -205,7 +205,6 @@ struct super_operations {
 
         void (*dirty_inode) (struct inode *);
         int (*write_inode) (struct inode *, int);
-        void (*put_inode) (struct inode *);
         void (*drop_inode) (struct inode *);
         void (*delete_inode) (struct inode *);
         void (*put_super) (struct super_block *);
@@ -246,9 +245,6 @@ or bottom half).
 	inode to disc.  The second parameter indicates whether the write
 	should be synchronous or not, not all filesystems check this flag.
 
-  put_inode: called when the VFS inode is removed from the inode
-	cache.
-
   drop_inode: called when the last access to the inode is dropped,
 	with the inode_lock spinlock held.
 
diff -puN fs/inode.c~vfs-kill-put_inode fs/inode.c
--- a/fs/inode.c~vfs-kill-put_inode
+++ a/fs/inode.c
@@ -1153,9 +1153,6 @@ void iput(struct inode *inode)
 
 		BUG_ON(inode->i_state == I_CLEAR);
 
-		if (op && op->put_inode)
-			op->put_inode(inode);
-
 		if (atomic_dec_and_lock(&inode->i_count, &inode_lock))
 			iput_final(inode);
 	}
diff -puN include/linux/fs.h~vfs-kill-put_inode include/linux/fs.h
--- a/include/linux/fs.h~vfs-kill-put_inode
+++ a/include/linux/fs.h
@@ -1289,17 +1289,12 @@ extern ssize_t vfs_readv(struct file *, 
 extern ssize_t vfs_writev(struct file *, const struct iovec __user *,
 		unsigned long, loff_t *);
 
-/*
- * NOTE: write_inode, delete_inode, clear_inode, put_inode can be called
- * without the big kernel lock held in all filesystems.
- */
 struct super_operations {
    	struct inode *(*alloc_inode)(struct super_block *sb);
 	void (*destroy_inode)(struct inode *);
 
    	void (*dirty_inode) (struct inode *);
 	int (*write_inode) (struct inode *, int);
-	void (*put_inode) (struct inode *);
 	void (*drop_inode) (struct inode *);
 	void (*delete_inode) (struct inode *);
 	void (*put_super) (struct super_block *);
_

Patches currently in -mm which might be from hch@lst.de are

linux-next.patch
git-cifs.patch
git-unionfs.patch

