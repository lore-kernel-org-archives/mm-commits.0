From: akpm@linux-foundation.org
Subject: - iget-stop-freevxfs-from-using-iget-and-read_inode-fix.patch removed from -mm tree
Date: Wed, 06 Feb 2008 19:35:02 -0800
Message-ID: <200802070334.m173YibE014086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39504 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751877AbYBGDfi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 22:35:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, hch@lst.de, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     IGET: Use ino_t consistently for vxfs_iget() and its declaration
has been removed from the -mm tree.  Its filename was
     iget-stop-freevxfs-from-using-iget-and-read_inode-fix.patch

This patch was dropped because it was folded into iget-stop-freevxfs-from-using-iget-and-read_inode.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: IGET: Use ino_t consistently for vxfs_iget() and its declaration
From: David Howells <dhowells@redhat.com>

Use ino_t consistently for vxfs_iget() and its declaration, rather than using
ino_t for one and unsigned long for the other.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/freevxfs/vxfs_extern.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/freevxfs/vxfs_extern.h~iget-stop-freevxfs-from-using-iget-and-read_inode-fix fs/freevxfs/vxfs_extern.h
--- a/fs/freevxfs/vxfs_extern.h~iget-stop-freevxfs-from-using-iget-and-read_inode-fix
+++ a/fs/freevxfs/vxfs_extern.h
@@ -58,7 +58,7 @@ extern struct inode *		vxfs_get_fake_ino
 extern void			vxfs_put_fake_inode(struct inode *);
 extern struct vxfs_inode_info *	vxfs_blkiget(struct super_block *, u_long, ino_t);
 extern struct vxfs_inode_info *	vxfs_stiget(struct super_block *, ino_t);
-extern struct inode *		vxfs_iget(struct super_block *, unsigned long);
+extern struct inode *		vxfs_iget(struct super_block *, ino_t);
 extern void			vxfs_clear_inode(struct inode *);
 
 /* vxfs_lookup.c */
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
add-an-err_cast-function-to-complement-err_ptr-and-co.patch
convert-err_ptrptr_errp-instances-to-err_castp.patch
iget-introduce-a-function-to-register-iget-failure.patch
iget-use-iget_failed-in-afs.patch
iget-use-iget_failed-in-gfs2.patch
iget-stop-affs-from-using-iget-and-read_inode-try.patch
iget-stop-autofs-from-using-iget-and-read_inode.patch
iget-stop-befs-from-using-iget-and-read_inode-try.patch
iget-stop-bfs-from-using-iget-and-read_inode-try.patch
iget-stop-cifs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
iget-stop-fat-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-fix.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
iget-stop-hfsplus-from-using-iget-and-read_inode.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-isofs-from-using-read_inode-fix-2.patch
iget-stop-isofs-from-using-read_inode-fix-2-update.patch
iget-stop-isofs-from-using-read_inode-fix-2-update-fix.patch
iget-stop-isofs-from-using-read_inode-fix-3.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
iget-stop-jfs-from-using-iget-and-read_inode-try.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
unexport-asm-pageh.patch
add-cmpxchg_local-to-frv.patch
