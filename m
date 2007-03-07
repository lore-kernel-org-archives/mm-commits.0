From: akpm@linux-foundation.org
Subject: + vfs-remove-superflous-sb-==-null-checks.patch added to -mm tree
Date: Wed, 07 Mar 2007 13:04:07 -0800
Message-ID: <200703072104.l27L47H4008783@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57132 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423001AbXCGVEM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 16:04:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de


The patch titled
     vfs: remove superflous sb == NULL checks
has been added to the -mm tree.  Its filename is
     vfs-remove-superflous-sb-==-null-checks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -251,7 +251,7 @@ void clear_inode(struct inode *inode)
 	BUG_ON(inode->i_state & I_CLEAR);
 	wait_on_inode(inode);
 	DQUOT_DROP(inode);
-	if (inode->i_sb && inode->i_sb->s_op->clear_inode)
+	if (inode->i_sb->s_op->clear_inode)
 		inode->i_sb->s_op->clear_inode(inode);
 	if (S_ISBLK(inode->i_mode) && inode->i_bdev)
 		bd_forget(inode);
@@ -1047,7 +1047,7 @@ static void generic_forget_inode(struct 
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

xfs-use-xfs_get_buf_noaddr-for-iclogs.patch
xfs-stop-using-kmalloc-in-xfs_buf_get_noaddr.patch
simplify-the-stacktrace-code.patch
allow-access-to-proc-pid-fd-after-setuid.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
freevxfs-possible-null-pointer-dereference-fix.patch
vfs-remove-superflous-sb-==-null-checks.patch
nameic-remove-utterly-outdated-comment.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch
aio-is-unlikely.patch
ps3fb-thread-updates.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3av-misc-updates.patch
