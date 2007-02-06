From: akpm@linux-foundation.org
Subject: + move-remove_dquot_ref-to-dqoutc.patch added to -mm tree
Date: Tue, 06 Feb 2007 15:14:27 -0800
Message-ID: <200702062314.l16NERkF032254@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54900 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933272AbXBFXOu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 18:14:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, jack@ucw.cz


The patch titled
     move remove_dquot_ref to dqout.c
has been added to the -mm tree.  Its filename is
     move-remove_dquot_ref-to-dqoutc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: move remove_dquot_ref to dqout.c
From: Christoph Hellwig <hch@lst.de>

Remove_dquot_ref can move to dqout.c instead of beeing in inode.c under
#ifdef CONFIG_QUOTA.  Also clean the resulting code up a tiny little bit by
testing sb->dq_op earlier - it's constant over a filesystems lifetime.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c         |   24 ++++++++++++++++++++----
 fs/inode.c         |   27 ---------------------------
 include/linux/fs.h |    1 -
 3 files changed, 20 insertions(+), 32 deletions(-)

diff -puN fs/dquot.c~move-remove_dquot_ref-to-dqoutc fs/dquot.c
--- a/fs/dquot.c~move-remove_dquot_ref-to-dqoutc
+++ a/fs/dquot.c
@@ -79,6 +79,7 @@
 #include <linux/buffer_head.h>
 #include <linux/capability.h>
 #include <linux/quotaops.h>
+#include <linux/writeback.h> /* for inode_lock, oddly enough.. */
 
 #include <asm/uaccess.h>
 
@@ -755,15 +756,30 @@ static void put_dquot_list(struct list_h
 	}
 }
 
+static void remove_dquot_ref(struct super_block *sb, int type,
+		struct list_head *tofree_head)
+{
+	struct inode *inode;
+
+	spin_lock(&inode_lock);
+	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+		if (!IS_NOQUOTA(inode))
+			remove_inode_dquot_ref(inode, type, tofree_head);
+	}
+	spin_unlock(&inode_lock);
+}
+
 /* Gather all references from inodes and drop them */
 static void drop_dquot_ref(struct super_block *sb, int type)
 {
 	LIST_HEAD(tofree_head);
 
-	down_write(&sb_dqopt(sb)->dqptr_sem);
-	remove_dquot_ref(sb, type, &tofree_head);
-	up_write(&sb_dqopt(sb)->dqptr_sem);
-	put_dquot_list(&tofree_head);
+	if (sb->dq_op) {
+		down_write(&sb_dqopt(sb)->dqptr_sem);
+		remove_dquot_ref(sb, type, &tofree_head);
+		up_write(&sb_dqopt(sb)->dqptr_sem);
+		put_dquot_list(&tofree_head);
+	}
 }
 
 static inline void dquot_incr_inodes(struct dquot *dquot, unsigned long number)
diff -puN fs/inode.c~move-remove_dquot_ref-to-dqoutc fs/inode.c
--- a/fs/inode.c~move-remove_dquot_ref-to-dqoutc
+++ a/fs/inode.c
@@ -1251,33 +1251,6 @@ int inode_needs_sync(struct inode *inode
 
 EXPORT_SYMBOL(inode_needs_sync);
 
-/*
- *	Quota functions that want to walk the inode lists..
- */
-#ifdef CONFIG_QUOTA
-
-void remove_dquot_ref(struct super_block *sb, int type,
-			struct list_head *tofree_head)
-{
-	struct inode *inode;
-
-	if (!sb->dq_op)
-		return;	/* nothing to do */
-	spin_lock(&inode_lock);	/* This lock is for inodes code */
-
-	/*
-	 * We don't have to lock against quota code - test IS_QUOTAINIT is
-	 * just for speedup...
-	 */
-	list_for_each_entry(inode, &sb->s_inodes, i_sb_list)
-		if (!IS_NOQUOTA(inode))
-			remove_inode_dquot_ref(inode, type, tofree_head);
-
-	spin_unlock(&inode_lock);
-}
-
-#endif
-
 int inode_wait(void *word)
 {
 	schedule();
diff -puN include/linux/fs.h~move-remove_dquot_ref-to-dqoutc include/linux/fs.h
--- a/include/linux/fs.h~move-remove_dquot_ref-to-dqoutc
+++ a/include/linux/fs.h
@@ -1687,7 +1687,6 @@ extern struct inode *new_inode(struct su
 extern int __remove_suid(struct dentry *, int);
 extern int should_remove_suid(struct dentry *);
 extern int remove_suid(struct dentry *);
-extern void remove_dquot_ref(struct super_block *, int, struct list_head *);
 
 extern void __insert_inode_hash(struct inode *, unsigned long hashval);
 extern void remove_inode_hash(struct inode *);
_

Patches currently in -mm which might be from hch@lst.de are

git-drm.patch
git-scsi-misc.patch
slab-cache-alloc-cleanups.patch
simplify-the-stacktrace-code.patch
make-bh_unwritten-a-first-class-bufferhead-flag-v2.patch
make-xfs-use-bh_unwritten-and-bh_delay-correctly.patch
tty-cleanup-release_mem.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
fix-d_path-for-lazy-unmounts.patch
move-remove_dquot_ref-to-dqoutc.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch
aio-is-unlikely.patch
