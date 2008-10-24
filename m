From: akpm@linux-foundation.org
Subject: - vfs-remove-lookup_parent-from-non-lookup_parent-lookup.patch removed from -mm tree
Date: Fri, 24 Oct 2008 12:41:11 -0700
Message-ID: <200810241941.m9OJfBKs001168@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752536AbYJXTlt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Oct 2008 15:41:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: remove LOOKUP_PARENT from non LOOKUP_PARENT lookup
has been removed from the -mm tree.  Its filename was
     vfs-remove-lookup_parent-from-non-lookup_parent-lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: remove LOOKUP_PARENT from non LOOKUP_PARENT lookup
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

lookup_hash() with LOOKUP_PARENT is bogus. And this prepares to add
new intent on those path.

The user of LOOKUP_PARENT intent is nfs only, and it checks whether
nd->flags has LOOKUP_CREATE or LOOKUP_OPEN, so the result is same.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff -puN fs/namei.c~vfs-remove-lookup_parent-from-non-lookup_parent-lookup fs/namei.c
--- a/fs/namei.c~vfs-remove-lookup_parent-from-non-lookup_parent-lookup
+++ a/fs/namei.c
@@ -2186,16 +2186,19 @@ static long do_rmdir(int dfd, const char
 		return error;
 
 	switch(nd.last_type) {
-		case LAST_DOTDOT:
-			error = -ENOTEMPTY;
-			goto exit1;
-		case LAST_DOT:
-			error = -EINVAL;
-			goto exit1;
-		case LAST_ROOT:
-			error = -EBUSY;
-			goto exit1;
+	case LAST_DOTDOT:
+		error = -ENOTEMPTY;
+		goto exit1;
+	case LAST_DOT:
+		error = -EINVAL;
+		goto exit1;
+	case LAST_ROOT:
+		error = -EBUSY;
+		goto exit1;
 	}
+
+	nd.flags &= ~LOOKUP_PARENT;
+
 	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
 	dentry = lookup_hash(&nd);
 	error = PTR_ERR(dentry);
@@ -2277,6 +2280,9 @@ static long do_unlinkat(int dfd, const c
 	error = -EISDIR;
 	if (nd.last_type != LAST_NORM)
 		goto exit1;
+
+	nd.flags &= ~LOOKUP_PARENT;
+
 	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
 	dentry = lookup_hash(&nd);
 	error = PTR_ERR(dentry);
@@ -2676,6 +2682,9 @@ asmlinkage long sys_renameat(int olddfd,
 	if (newnd.last_type != LAST_NORM)
 		goto exit2;
 
+	oldnd.flags &= ~LOOKUP_PARENT;
+	newnd.flags &= ~LOOKUP_PARENT;
+
 	trap = lock_rename(new_dir, old_dir);
 
 	old_dentry = lookup_hash(&oldnd);
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

