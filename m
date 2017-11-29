From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Wed, 29 Nov 2017 12:32:16 -0800
Message-ID: <20171129203216.mcBk-Ul6m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55826 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750928AbdK2UcS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 15:32:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/super.c   |   38 --------------------------------------
 fs/cifs/cifsglob.h |    5 -----
 fs/jffs2/super.c   |    4 ----
 fs/nfs/internal.h  |    4 ----
 4 files changed, 51 deletions(-)

diff -puN fs/btrfs/super.c~linux-next-git-rejects fs/btrfs/super.c
--- a/fs/btrfs/super.c~linux-next-git-rejects
+++ a/fs/btrfs/super.c
@@ -1415,44 +1415,6 @@ static struct dentry *mount_subvol(const
 	struct dentry *root;
 	int ret;
 
-<<<<<<< HEAD
-	newargs = setup_root_args(data);
-	if (!newargs) {
-		root = ERR_PTR(-ENOMEM);
-		goto out;
-	}
-
-	mnt = vfs_kern_mount(&btrfs_fs_type, flags, device_name, newargs);
-	if (PTR_ERR_OR_ZERO(mnt) == -EBUSY) {
-		if (flags & SB_RDONLY) {
-			mnt = vfs_kern_mount(&btrfs_fs_type, flags & ~SB_RDONLY,
-					     device_name, newargs);
-		} else {
-			mnt = vfs_kern_mount(&btrfs_fs_type, flags | SB_RDONLY,
-					     device_name, newargs);
-			if (IS_ERR(mnt)) {
-				root = ERR_CAST(mnt);
-				mnt = NULL;
-				goto out;
-			}
-
-			down_write(&mnt->mnt_sb->s_umount);
-			ret = btrfs_remount(mnt->mnt_sb, &flags, NULL);
-			up_write(&mnt->mnt_sb->s_umount);
-			if (ret < 0) {
-				root = ERR_PTR(ret);
-				goto out;
-			}
-		}
-	}
-	if (IS_ERR(mnt)) {
-		root = ERR_CAST(mnt);
-		mnt = NULL;
-		goto out;
-	}
-
-=======
->>>>>>> linux-next/akpm-base
 	if (!subvol_name) {
 		if (!subvol_objectid) {
 			ret = get_default_subvol_objectid(btrfs_sb(mnt->mnt_sb),
diff -puN fs/cifs/cifsglob.h~linux-next-git-rejects fs/cifs/cifsglob.h
--- a/fs/cifs/cifsglob.h~linux-next-git-rejects
+++ a/fs/cifs/cifsglob.h
@@ -559,13 +559,8 @@ struct smb_vol {
 			 CIFS_MOUNT_MULTIUSER | CIFS_MOUNT_STRICT_IO | \
 			 CIFS_MOUNT_CIFS_BACKUPUID | CIFS_MOUNT_CIFS_BACKUPGID)
 
-<<<<<<< HEAD
-#define CIFS_MS_MASK (SB_RDONLY | SB_MANDLOCK | SB_NOEXEC | SB_NOSUID | \
-		      SB_NODEV | SB_SYNCHRONOUS)
-=======
 #define CIFS_MS_MASK (SB_RDONLY | SB_MANDLOCK | SB_SYNCHRONOUS | \
 		      SB_NOEXEC | SB_NOSUID | SB_NODEV)
->>>>>>> linux-next/akpm-base
 
 struct cifs_mnt_data {
 	struct cifs_sb_info *cifs_sb;
diff -puN fs/jffs2/super.c~linux-next-git-rejects fs/jffs2/super.c
--- a/fs/jffs2/super.c~linux-next-git-rejects
+++ a/fs/jffs2/super.c
@@ -301,11 +301,7 @@ static int jffs2_fill_super(struct super
 
 	sb->s_op = &jffs2_super_operations;
 	sb->s_export_op = &jffs2_export_ops;
-<<<<<<< HEAD
-	sb->s_flags = sb->s_flags | SB_NOATIME;
-=======
 	sb->s_flags |= SB_NOATIME;
->>>>>>> linux-next/akpm-base
 	sb->s_xattr = jffs2_xattr_handlers;
 #ifdef CONFIG_JFFS2_FS_POSIX_ACL
 	sb->s_flags |= SB_POSIXACL;
diff -puN fs/nfs/internal.h~linux-next-git-rejects fs/nfs/internal.h
--- a/fs/nfs/internal.h~linux-next-git-rejects
+++ a/fs/nfs/internal.h
@@ -10,11 +10,7 @@
 #include <linux/nfs_page.h>
 #include <linux/wait_bit.h>
 
-<<<<<<< HEAD
-#define NFS_MS_MASK (SB_RDONLY|SB_NOSUID|SB_NODEV|SB_NOEXEC|SB_SYNCHRONOUS)
-=======
 #define NFS_SB_MASK (SB_RDONLY|SB_NOSUID|SB_NODEV|SB_NOEXEC|SB_SYNCHRONOUS)
->>>>>>> linux-next/akpm-base
 
 extern const struct export_operations nfs_export_ops;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-introduce-get_user_pages_longterm-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-do-not-stall-register_shrinker-fix.patch
selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix.patch
linux-next-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

