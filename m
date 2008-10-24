From: akpm@linux-foundation.org
Subject: - vfs-replace-parent-==-dentry-d_parent-by-is_root.patch removed from -mm tree
Date: Fri, 24 Oct 2008 12:41:02 -0700
Message-ID: <200810241941.m9OJf2Ni001125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610AbYJXTlO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Oct 2008 15:41:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: replace parent == dentry->d_parent by IS_ROOT()
has been removed from the -mm tree.  Its filename was
     vfs-replace-parent-==-dentry-d_parent-by-is_root.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: replace parent == dentry->d_parent by IS_ROOT()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |   21 ++++++++++++---------
 fs/namei.c  |    4 ++--
 2 files changed, 14 insertions(+), 11 deletions(-)

diff -puN fs/dcache.c~vfs-replace-parent-==-dentry-d_parent-by-is_root fs/dcache.c
--- a/fs/dcache.c~vfs-replace-parent-==-dentry-d_parent-by-is_root
+++ a/fs/dcache.c
@@ -174,9 +174,12 @@ static struct dentry *d_kill(struct dent
 	dentry_stat.nr_dentry--;	/* For d_free, below */
 	/*drops the locks, at that point nobody can reach this dentry */
 	dentry_iput(dentry);
-	parent = dentry->d_parent;
+	if (IS_ROOT(dentry))
+		parent = NULL;
+	else
+		parent = dentry->d_parent;
 	d_free(dentry);
-	return dentry == parent ? NULL : parent;
+	return parent;
 }
 
 /* 
@@ -666,11 +669,12 @@ static void shrink_dcache_for_umount_sub
 				BUG();
 			}
 
-			parent = dentry->d_parent;
-			if (parent == dentry)
+			if (IS_ROOT(dentry))
 				parent = NULL;
-			else
+			else {
+				parent = dentry->d_parent;
 				atomic_dec(&parent->d_count);
+			}
 
 			list_del(&dentry->d_u.d_child);
 			detached++;
@@ -1723,7 +1727,7 @@ static int d_isparent(struct dentry *p1,
 {
 	struct dentry *p;
 
-	for (p = p2; p->d_parent != p; p = p->d_parent) {
+	for (p = p2; !IS_ROOT(p); p = p->d_parent) {
 		if (p->d_parent == p1)
 			return 1;
 	}
@@ -2168,10 +2172,9 @@ int is_subdir(struct dentry * new_dentry
 		seq = read_seqbegin(&rename_lock);
 		for (;;) {
 			if (new_dentry != old_dentry) {
-				struct dentry * parent = new_dentry->d_parent;
-				if (parent == new_dentry)
+				if (IS_ROOT(new_dentry))
 					break;
-				new_dentry = parent;
+				new_dentry = new_dentry->d_parent;
 				continue;
 			}
 			result = 1;
diff -puN fs/namei.c~vfs-replace-parent-==-dentry-d_parent-by-is_root fs/namei.c
--- a/fs/namei.c~vfs-replace-parent-==-dentry-d_parent-by-is_root
+++ a/fs/namei.c
@@ -1456,7 +1456,7 @@ struct dentry *lock_rename(struct dentry
 
 	mutex_lock(&p1->d_inode->i_sb->s_vfs_rename_mutex);
 
-	for (p = p1; p->d_parent != p; p = p->d_parent) {
+	for (p = p1; !IS_ROOT(p); p = p->d_parent) {
 		if (p->d_parent == p2) {
 			mutex_lock_nested(&p2->d_inode->i_mutex, I_MUTEX_PARENT);
 			mutex_lock_nested(&p1->d_inode->i_mutex, I_MUTEX_CHILD);
@@ -1464,7 +1464,7 @@ struct dentry *lock_rename(struct dentry
 		}
 	}
 
-	for (p = p2; p->d_parent != p; p = p->d_parent) {
+	for (p = p2; !IS_ROOT(p); p = p->d_parent) {
 		if (p->d_parent == p1) {
 			mutex_lock_nested(&p1->d_inode->i_mutex, I_MUTEX_PARENT);
 			mutex_lock_nested(&p2->d_inode->i_mutex, I_MUTEX_CHILD);
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

linux-next.patch
fat-document-additional-vfat-mount-options.patch
fat-move-fs-vfat-and-fs-msdos-to-fs-fat.patch
fat-split-include-msdos_fsh.patch
fat-fix-and-cleanup-timestamp-conversion.patch
fat-use-generic_file_llseek-for-directory.patch
fat-cleanup-fat_parse_long-error-handling.patch
fat-improve-fat_hash.patch
fat-fix-fat_ent_update_ptr-for-fat12.patch
fat-use-fat_detach-in-fat_clear_inode.patch
vfat-fix-vfat_find-error-path-in-vfat_lookup.patch
fat-fix-cleanup-dcache-handling-for-vfat.patch
fat-kill-d_invalidate-in-vfat_lookup.patch
fat-cleanup-msdos_lookup.patch
fat-cleanup-fat-attribute-stuff.patch
fat-fix-attr_ro-in-the-case-of-umask-s_wugo-==-0.patch
fat-fix-attr_ro-for-directory.patch
fat-fix-_fat_bmap-race.patch
fat-add-printf-attribute-to-fat_fs_panic.patch
fat-mmu_private-race-fix.patch
fat-i_pos-race-fix.patch
fat-i_blocks-warning-fix.patch

