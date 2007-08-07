From: akpm@linux-foundation.org
Subject: + fuse-fix-permission-checking-on-sticky-directories-fix.patch added to -mm tree
Date: Tue, 07 Aug 2007 13:07:47 -0700
Message-ID: <200708072007.l77K7lp0001603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39355 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751874AbXHGUID (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 16:08:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, jengelh@linux01.gwdg.de


The patch titled
     fuse-fix-permission-checking-on-sticky-directories fix
has been added to the -mm tree.  Its filename is
     fuse-fix-permission-checking-on-sticky-directories-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fuse-fix-permission-checking-on-sticky-directories fix
From: Miklos Szeredi <mszeredi@suse.cz>

[Jan Engelhardt] cosmetic fixes

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/fuse_i.h |    2 +-
 fs/fuse/inode.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/fuse/fuse_i.h~fuse-fix-permission-checking-on-sticky-directories-fix fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-fix-permission-checking-on-sticky-directories-fix
+++ a/fs/fuse/fuse_i.h
@@ -64,7 +64,7 @@ struct fuse_inode {
 	/** Time in jiffies until the file attributes are valid */
 	u64 i_time;
 
-	/** The sticky bit in inode->i_mode may have been remved, so
+	/** The sticky bit in inode->i_mode may have been removed, so
 	    preserve the original mode */
 	mode_t orig_i_mode;
 };
diff -puN fs/fuse/inode.c~fuse-fix-permission-checking-on-sticky-directories-fix fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-fix-permission-checking-on-sticky-directories-fix
+++ a/fs/fuse/inode.c
@@ -124,7 +124,7 @@ void fuse_change_attributes(struct inode
 	loff_t oldsize;
 
 	inode->i_ino     = attr->ino;
-	fi->orig_i_mode  = (inode->i_mode & S_IFMT) + (attr->mode & 07777);
+	fi->orig_i_mode  = (inode->i_mode & S_IFMT) | (attr->mode & 07777);
 	/*
 	 * Don't set the mode bits in i_mode, unless we want the VFS
 	 * to check permissions.  This prevents failures due to the
_

Patches currently in -mm which might be from mszeredi@suse.cz are

fuse-convert-to-new-aops.patch
ext2-show-all-mount-options.patch
ext3-show-all-mount-options.patch
ext4-show-all-mount-options.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-propagation-inherit-owner-from-parent-fix-for-git-audit.patch
unprivileged-mounts-add-no-submounts-flag.patch
fuse-update-backing_dev_info-congestion-state.patch
fuse-fix-reserved-request-wake-up.patch
fuse-add-reference-counting-to-fuse_file.patch
fuse-truncate-on-spontaneous-size-change.patch
fuse-fix-page-invalidation.patch
fuse-set-i_nlink-to-sane-value-after-mount.patch
fuse-refresh-stale-attributes-in-fuse_permission.patch
fuse-fix-permission-checking-on-sticky-directories.patch
fuse-fix-permission-checking-on-sticky-directories-fix.patch
fuse-cleanup-in-release.patch
fuse-no-abort-on-interrupt.patch
fuse-no-enoent-from-fuse-device-read.patch
