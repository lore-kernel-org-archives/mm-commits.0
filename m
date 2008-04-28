From: akpm@linux-foundation.org
Subject: - reiserfs-unpack-tails-on-quota-files.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:01:25 -0700
Message-ID: <200804282201.m3SM1PQZ018862@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762368AbYD1WDB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:03:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, chris.mason@oracle.com, jeffm@suse.com, urhausen@urifabi.net, mm-commits@vger.kernel.org


The patch titled
     reiserfs: unpack tails on quota files
has been removed from the -mm tree.  Its filename was
     reiserfs-unpack-tails-on-quota-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: unpack tails on quota files
From: Jan Kara <jack@suse.cz>

Quota files cannot have tails because quota_write and quota_read functions do
not support them.  So far when quota files did have tail, we just refused to
turn quotas on it.  Sadly this check has been wrong and so there are now
plenty installations where quota files don't have NOTAIL flag set and so now
after fixing the check, they suddently fail to turn quotas on.  Since it's
easy to unpack the tail from kernel, do this from reiserfs_quota_on() which
solves the problem and is generally nicer to users anyway.

Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: <urhausen@urifabi.net>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/ioctl.c         |    4 +---
 fs/reiserfs/super.c         |   17 ++++++++++++-----
 include/linux/reiserfs_fs.h |    1 +
 3 files changed, 14 insertions(+), 8 deletions(-)

diff -puN fs/reiserfs/ioctl.c~reiserfs-unpack-tails-on-quota-files fs/reiserfs/ioctl.c
--- a/fs/reiserfs/ioctl.c~reiserfs-unpack-tails-on-quota-files
+++ a/fs/reiserfs/ioctl.c
@@ -12,8 +12,6 @@
 #include <linux/smp_lock.h>
 #include <linux/compat.h>
 
-static int reiserfs_unpack(struct inode *inode, struct file *filp);
-
 /*
 ** reiserfs_ioctl - handler for ioctl for inode
 ** supported commands:
@@ -159,7 +157,7 @@ int reiserfs_prepare_write(struct file *
 ** Function try to convert tail from direct item into indirect.
 ** It set up nopack attribute in the REISERFS_I(inode)->nopack
 */
-static int reiserfs_unpack(struct inode *inode, struct file *filp)
+int reiserfs_unpack(struct inode *inode, struct file *filp)
 {
 	int retval = 0;
 	int index;
diff -puN fs/reiserfs/super.c~reiserfs-unpack-tails-on-quota-files fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~reiserfs-unpack-tails-on-quota-files
+++ a/fs/reiserfs/super.c
@@ -2025,6 +2025,7 @@ static int reiserfs_quota_on(struct supe
 {
 	int err;
 	struct nameidata nd;
+	struct inode *inode;
 
 	if (!(REISERFS_SB(sb)->s_mount_opt & (1 << REISERFS_QUOTA)))
 		return -EINVAL;
@@ -2039,12 +2040,18 @@ static int reiserfs_quota_on(struct supe
 		path_put(&nd.path);
 		return -EXDEV;
 	}
+	inode = nd.path.dentry->d_inode;
 	/* We must not pack tails for quota files on reiserfs for quota IO to work */
-	if (!(REISERFS_I(nd.path.dentry->d_inode)->i_flags & i_nopack_mask)) {
-		reiserfs_warning(sb,
-				 "reiserfs: Quota file must have tail packing disabled.");
-		path_put(&nd.path);
-		return -EINVAL;
+	if (!(REISERFS_I(inode)->i_flags & i_nopack_mask)) {
+		err = reiserfs_unpack(inode, NULL);
+		if (err) {
+			reiserfs_warning(sb,
+				"reiserfs: Unpacking tail of quota file failed"
+				" (%d). Cannot turn on quotas.", err);
+			path_put(&nd.path);
+			return -EINVAL;
+		}
+		mark_inode_dirty(inode);
 	}
 	/* Not journalling quota? No more tests needed... */
 	if (!REISERFS_SB(sb)->s_qf_names[USRQUOTA] &&
diff -puN include/linux/reiserfs_fs.h~reiserfs-unpack-tails-on-quota-files include/linux/reiserfs_fs.h
--- a/include/linux/reiserfs_fs.h~reiserfs-unpack-tails-on-quota-files
+++ a/include/linux/reiserfs_fs.h
@@ -2176,6 +2176,7 @@ int reiserfs_ioctl(struct inode *inode, 
 		   unsigned int cmd, unsigned long arg);
 long reiserfs_compat_ioctl(struct file *filp,
 		   unsigned int cmd, unsigned long arg);
+int reiserfs_unpack(struct inode *inode, struct file *filp);
 
 /* ioctl's command */
 #define REISERFS_IOC_UNPACK		_IOW(0xCD,1,long)
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
vfs-fix-lock-inversion-in-drop_pagecache_sb.patch
vfs-skip-inodes-without-pages-to-free-in-drop_pagecache_sb.patch
ext4-fix-update-of-mtime-and-ctime-on-rename.patch
ext4-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch
ext4-fix-mount-messages-when-quota-disabled.patch
quota-le_add_cpu-conversion.patch
isofs-use-get-put_unaligned_-helpers.patch

