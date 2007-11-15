From: akpm@linux-foundation.org
Subject: - forbid-user-to-change-file-flags-on-quota-files-fix.patch removed from -mm tree
Date: Wed, 14 Nov 2007 16:41:40 -0800
Message-ID: <200711150041.lAF0feF8001873@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38060 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755476AbXKOAmZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Nov 2007 19:42:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, schwab@suse.de, mm-commits@vger.kernel.org


The patch titled
     forbid-user-to-change-file-flags-on-quota-files fix
has been removed from the -mm tree.  Its filename was
     forbid-user-to-change-file-flags-on-quota-files-fix.patch

This patch was dropped because it was folded into forbid-user-to-change-file-flags-on-quota-files.patch

------------------------------------------------------
Subject: forbid-user-to-change-file-flags-on-quota-files fix
From: Jan Kara <jack@suse.cz>

A grammar correction in a comment.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Andreas Schwab <schwab@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/ioctl.c     |    2 +-
 fs/ext3/ioctl.c     |    2 +-
 fs/ext4/ioctl.c     |    2 +-
 fs/jfs/ioctl.c      |    2 +-
 fs/reiserfs/ioctl.c |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/ext2/ioctl.c~forbid-user-to-change-file-flags-on-quota-files-fix fs/ext2/ioctl.c
--- a/fs/ext2/ioctl.c~forbid-user-to-change-file-flags-on-quota-files-fix
+++ a/fs/ext2/ioctl.c
@@ -47,7 +47,7 @@ int ext2_ioctl (struct inode * inode, st
 			flags &= ~EXT2_DIRSYNC_FL;
 
 		mutex_lock(&inode->i_mutex);
-		/* Is it quota file? Don't allow user mess with it */
+		/* Is it quota file? Do not allow user to mess with it */
 		if (IS_NOQUOTA(inode)) {
 			mutex_unlock(&inode->i_mutex);
 			return -EPERM;
diff -puN fs/ext3/ioctl.c~forbid-user-to-change-file-flags-on-quota-files-fix fs/ext3/ioctl.c
--- a/fs/ext3/ioctl.c~forbid-user-to-change-file-flags-on-quota-files-fix
+++ a/fs/ext3/ioctl.c
@@ -51,7 +51,7 @@ int ext3_ioctl (struct inode * inode, st
 			flags &= ~EXT3_DIRSYNC_FL;
 
 		mutex_lock(&inode->i_mutex);
-		/* Is it quota file? Don't allow user mess with it */
+		/* Is it quota file? Do not allow user to mess with it */
 		if (IS_NOQUOTA(inode)) {
 			mutex_unlock(&inode->i_mutex);
 			return -EPERM;
diff -puN fs/ext4/ioctl.c~forbid-user-to-change-file-flags-on-quota-files-fix fs/ext4/ioctl.c
--- a/fs/ext4/ioctl.c~forbid-user-to-change-file-flags-on-quota-files-fix
+++ a/fs/ext4/ioctl.c
@@ -51,7 +51,7 @@ int ext4_ioctl (struct inode * inode, st
 			flags &= ~EXT4_DIRSYNC_FL;
 
 		mutex_lock(&inode->i_mutex);
-		/* Is it quota file? Don't allow user mess with it */
+		/* Is it quota file? Do not allow user to mess with it */
 		if (IS_NOQUOTA(inode)) {
 			mutex_unlock(&inode->i_mutex);
 			return -EPERM;
diff -puN fs/jfs/ioctl.c~forbid-user-to-change-file-flags-on-quota-files-fix fs/jfs/ioctl.c
--- a/fs/jfs/ioctl.c~forbid-user-to-change-file-flags-on-quota-files-fix
+++ a/fs/jfs/ioctl.c
@@ -79,7 +79,7 @@ int jfs_ioctl(struct inode * inode, stru
 		if (!S_ISDIR(inode->i_mode))
 			flags &= ~JFS_DIRSYNC_FL;
 
-		/* Is it quota file? Don't allow user mess with it */
+		/* Is it quota file? Do not allow user to mess with it */
 		if (IS_NOQUOTA(inode))
 			return -EPERM;
 		jfs_get_inode_flags(jfs_inode);
diff -puN fs/reiserfs/ioctl.c~forbid-user-to-change-file-flags-on-quota-files-fix fs/reiserfs/ioctl.c
--- a/fs/reiserfs/ioctl.c~forbid-user-to-change-file-flags-on-quota-files-fix
+++ a/fs/reiserfs/ioctl.c
@@ -57,7 +57,7 @@ int reiserfs_ioctl(struct inode *inode, 
 			if (get_user(flags, (int __user *)arg))
 				return -EFAULT;
 
-			/* Is it quota file? Don't allow user mess with it. */
+			/* Is it quota file? Do not allow user to mess with it. */
 			if (IS_NOQUOTA(inode))
 				return -EPERM;
 			if (((flags ^ REISERFS_I(inode)->
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
forbid-user-to-change-file-flags-on-quota-files.patch
forbid-user-to-change-file-flags-on-quota-files-fix.patch
fix-64kb-blocksize-in-ext3-directories.patch
fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes.patch
