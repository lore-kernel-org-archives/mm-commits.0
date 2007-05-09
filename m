From: akpm@linux-foundation.org
Subject: - vfs-remove-superflous-sb-==-null-checks.patch removed from -mm tree
Date: Tue, 08 May 2007 19:46:05 -0700
Message-ID: <200705090246.l492k5j5008812@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031745AbXEICqP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:46:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     vfs: remove superflous sb == NULL checks
has been removed from the -mm tree.  Its filename was
     vfs-remove-superflous-sb-==-null-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: vfs: remove superflous sb == NULL checks
From: Christoph Hellwig <hch@lst.de>

inode->i_sb is always set, not need to check for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |    4 ++--
 fs/ioctl.c |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/inode.c~vfs-remove-superflous-sb-==-null-checks fs/inode.c
--- a/fs/inode.c~vfs-remove-superflous-sb-==-null-checks
+++ a/fs/inode.c
@@ -250,7 +250,7 @@ void clear_inode(struct inode *inode)
 	BUG_ON(inode->i_state & I_CLEAR);
 	wait_on_inode(inode);
 	DQUOT_DROP(inode);
-	if (inode->i_sb && inode->i_sb->s_op->clear_inode)
+	if (inode->i_sb->s_op->clear_inode)
 		inode->i_sb->s_op->clear_inode(inode);
 	if (S_ISBLK(inode->i_mode) && inode->i_bdev)
 		bd_forget(inode);
@@ -1040,7 +1040,7 @@ static void generic_forget_inode(struct 
 		if (!(inode->i_state & (I_DIRTY|I_LOCK)))
 			list_move(&inode->i_list, &inode_unused);
 		inodes_stat.nr_unused++;
-		if (!sb || (sb->s_flags & MS_ACTIVE)) {
+		if (sb->s_flags & MS_ACTIVE) {
 			spin_unlock(&inode_lock);
 			return;
 		}
diff -puN fs/ioctl.c~vfs-remove-superflous-sb-==-null-checks fs/ioctl.c
--- a/fs/ioctl.c~vfs-remove-superflous-sb-==-null-checks
+++ a/fs/ioctl.c
@@ -67,8 +67,6 @@ static int file_ioctl(struct file *filp,
 			return put_user(res, p);
 		}
 		case FIGETBSZ:
-			if (inode->i_sb == NULL)
-				return -EBADF;
 			return put_user(inode->i_sb->s_blocksize, p);
 		case FIONREAD:
 			return put_user(i_size_read(inode) - filp->f_pos, p);
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
dont-force-uclinux-mtd-map-to-be-root-dev.patch
git-scsi-misc.patch
knfsd-trivial-makefile-cleanup.patch
aio-is-unlikely.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
