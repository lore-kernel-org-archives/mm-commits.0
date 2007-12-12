From: akpm@linux-foundation.org
Subject: - nfs-fix-nfs-mountpoint-crossing.patch removed from -mm tree
Date: Wed, 12 Dec 2007 12:59:23 -0800
Message-ID: <200712122059.lBCKxNJY029485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43084 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752434AbXLLVBB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 16:01:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: trond.myklebust@fys.uio.no, Trond.Myklebust@netapp.com, mm-commits@vger.kernel.org


The patch titled
     NFS: Fix NFS mountpoint crossing
has been removed from the -mm tree.  Its filename was
     nfs-fix-nfs-mountpoint-crossing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: NFS: Fix NFS mountpoint crossing
From: Trond Myklebust <trond.myklebust@fys.uio.no>

The check that was added to nfs_xdev_get_sb() to work around broken
servers, works fine for NFSv2, but causes mountpoint crossing on NFSv3 to
always return ESTALE.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nfs/super.c~nfs-fix-nfs-mountpoint-crossing fs/nfs/super.c
--- a/fs/nfs/super.c~nfs-fix-nfs-mountpoint-crossing
+++ a/fs/nfs/super.c
@@ -1499,7 +1499,7 @@ static int nfs_xdev_get_sb(struct file_s
 		error = PTR_ERR(mntroot);
 		goto error_splat_super;
 	}
-	if (mntroot->d_inode->i_op != &nfs_dir_inode_operations) {
+	if (mntroot->d_inode->i_op != server->nfs_client->rpc_ops->dir_inode_ops) {
 		dput(mntroot);
 		error = -ESTALE;
 		goto error_splat_super;
_

Patches currently in -mm which might be from trond.myklebust@fys.uio.no are

knfsd-change-mailing-list-for-nfsd-in-maintainers.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
git-nfsd.patch
nfs-fix-an-oops-in-nfs-unmount.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
add-lock_page_killable.patch
kernel-add-mutex_lock_killable.patch
vfs-use-mutex_lock_killable-in-vfs_readdir.patch
create-file_drop_write_access-helper.patch
fix-up-new-filp-allocators.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-nfs4-fix.patch
