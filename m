From: akpm@linux-foundation.org
Subject: + fuse-set-i_nlink-to-sane-value-after-mount.patch added to -mm tree
Date: Fri, 03 Aug 2007 15:55:02 -0700
Message-ID: <200708032255.l73Mt2uQ031773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40296 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763445AbXHCWzM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Aug 2007 18:55:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: set i_nlink to sane value after mount
has been added to the -mm tree.  Its filename is
     fuse-set-i_nlink-to-sane-value-after-mount.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fuse: set i_nlink to sane value after mount
From: Miklos Szeredi <mszeredi@suse.cz>

Aufs seems to depend on a positive i_nlink value.  So fill in a dummy but sane
value for the root inode at mount time.

The inode attributes are refreshed with the correct values at the first
opportunity.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/inode.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN fs/fuse/inode.c~fuse-set-i_nlink-to-sane-value-after-mount fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-set-i_nlink-to-sane-value-after-mount
+++ a/fs/fuse/inode.c
@@ -480,6 +480,7 @@ static struct inode *get_root_inode(stru
 
 	attr.mode = mode;
 	attr.ino = FUSE_ROOT_ID;
+	attr.nlink = 1;
 	return fuse_iget(sb, 1, 0, &attr);
 }
 
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
fuse-cleanup-in-release.patch
fuse-no-abort-on-interrupt.patch
fuse-no-enoent-from-fuse-device-read.patch
