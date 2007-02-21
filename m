From: akpm@linux-foundation.org
Subject: - affs-implement-drop_inode.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:46:18 -0800
Message-ID: <200702211046.l1LAkIkh006457@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46952 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932602AbXBUKqc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:46:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     affs: implement ->drop_inode
has been removed from the -mm tree.  Its filename was
     affs-implement-drop_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: affs: implement ->drop_inode
From: Christoph Hellwig <hch@lst.de>

affs wants to truncate the inode when the last user goes away, currently it
does that through a potentially racy i_count check in ->put_inode.  But we
already have a method that's called just after the we dropped the last
reference, ->drop_inode.  This patch implements affs_drop_inode to take
advantage of this.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/affs.h  |    1 +
 fs/affs/inode.c |   17 +++++++++++------
 fs/affs/super.c |    1 +
 3 files changed, 13 insertions(+), 6 deletions(-)

diff -puN fs/affs/affs.h~affs-implement-drop_inode fs/affs/affs.h
--- a/fs/affs/affs.h~affs-implement-drop_inode
+++ a/fs/affs/affs.h
@@ -171,6 +171,7 @@ extern unsigned long		 affs_parent_ino(s
 extern struct inode		*affs_new_inode(struct inode *dir);
 extern int			 affs_notify_change(struct dentry *dentry, struct iattr *attr);
 extern void			 affs_put_inode(struct inode *inode);
+extern void			 affs_drop_inode(struct inode *inode);
 extern void			 affs_delete_inode(struct inode *inode);
 extern void			 affs_clear_inode(struct inode *inode);
 extern void			 affs_read_inode(struct inode *inode);
diff -puN fs/affs/inode.c~affs-implement-drop_inode fs/affs/inode.c
--- a/fs/affs/inode.c~affs-implement-drop_inode
+++ a/fs/affs/inode.c
@@ -243,12 +243,17 @@ affs_put_inode(struct inode *inode)
 {
 	pr_debug("AFFS: put_inode(ino=%lu, nlink=%u)\n", inode->i_ino, inode->i_nlink);
 	affs_free_prealloc(inode);
-	if (atomic_read(&inode->i_count) == 1) {
-		mutex_lock(&inode->i_mutex);
-		if (inode->i_size != AFFS_I(inode)->mmu_private)
-			affs_truncate(inode);
-		mutex_unlock(&inode->i_mutex);
-	}
+}
+
+void
+affs_drop_inode(struct inode *inode)
+{
+	mutex_lock(&inode->i_mutex);
+	if (inode->i_size != AFFS_I(inode)->mmu_private)
+		affs_truncate(inode);
+	mutex_unlock(&inode->i_mutex);
+
+	generic_drop_inode(inode);
 }
 
 void
diff -puN fs/affs/super.c~affs-implement-drop_inode fs/affs/super.c
--- a/fs/affs/super.c~affs-implement-drop_inode
+++ a/fs/affs/super.c
@@ -118,6 +118,7 @@ static const struct super_operations aff
 	.read_inode	= affs_read_inode,
 	.write_inode	= affs_write_inode,
 	.put_inode	= affs_put_inode,
+	.drop_inode	= affs_drop_inode,
 	.delete_inode	= affs_delete_inode,
 	.clear_inode	= affs_clear_inode,
 	.put_super	= affs_put_super,
_

Patches currently in -mm which might be from hch@lst.de are

simplify-the-stacktrace-code.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch
aio-is-unlikely.patch
ps3fb-thread-updates.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3av-misc-updates.patch
