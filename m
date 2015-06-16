From: akpm@linux-foundation.org
Subject: [merged]
 revert-ufs-fix-deadlocks-introduced-by-sb-mutex-merge.patch removed from
 -mm tree
Date: Tue, 16 Jun 2015 12:00:30 -0700
Message-ID: <5580724e.y5bh4obdHdKvgTqP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34244 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbbFPTAb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jun 2015 15:00:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, Ian.Jackson@eu.citrix.com, dushistov@mail.ru, ian.campbell@citrix.com, jack@suse.cz, khoroshilov@ispras.ru, roger.pau@citrix.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ufs: revert "ufs: fix deadlocks introduced by sb mutex merge"
has been removed from the -mm tree.  Its filename was
     revert-ufs-fix-deadlocks-introduced-by-sb-mutex-merge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/ufs: revert "ufs: fix deadlocks introduced by sb mutex merge"

This reverts commit 9ef7db7f38d0 ("ufs: fix deadlocks introduced by sb
mutex merge") That patch tried to solve commit 0244756edc4b98c ("ufs: sb
mutex merge + mutex_destroy") which is itself partially reverted due to
multiple deadlocks.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Suggested-by: Jan Kara <jack@suse.cz>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Roger Pau Monne <roger.pau@citrix.com>
Cc: Ian Jackson <Ian.Jackson@eu.citrix.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/inode.c |    5 ++++-
 fs/ufs/namei.c |   14 ++++++++------
 2 files changed, 12 insertions(+), 7 deletions(-)

diff -puN fs/ufs/inode.c~revert-ufs-fix-deadlocks-introduced-by-sb-mutex-merge fs/ufs/inode.c
--- a/fs/ufs/inode.c~revert-ufs-fix-deadlocks-introduced-by-sb-mutex-merge
+++ a/fs/ufs/inode.c
@@ -902,6 +902,9 @@ void ufs_evict_inode(struct inode * inod
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
 
-	if (want_delete)
+	if (want_delete) {
+		lock_ufs(inode->i_sb);
 		ufs_free_inode(inode);
+		unlock_ufs(inode->i_sb);
+	}
 }
diff -puN fs/ufs/namei.c~revert-ufs-fix-deadlocks-introduced-by-sb-mutex-merge fs/ufs/namei.c
--- a/fs/ufs/namei.c~revert-ufs-fix-deadlocks-introduced-by-sb-mutex-merge
+++ a/fs/ufs/namei.c
@@ -128,12 +128,12 @@ static int ufs_symlink (struct inode * d
 	if (l > sb->s_blocksize)
 		goto out_notlocked;
 
+	lock_ufs(dir->i_sb);
 	inode = ufs_new_inode(dir, S_IFLNK | S_IRWXUGO);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
-		goto out_notlocked;
+		goto out;
 
-	lock_ufs(dir->i_sb);
 	if (l > UFS_SB(sb)->s_uspi->s_maxsymlinklen) {
 		/* slow symlink */
 		inode->i_op = &ufs_symlink_inode_operations;
@@ -184,9 +184,13 @@ static int ufs_mkdir(struct inode * dir,
 	struct inode * inode;
 	int err;
 
+	lock_ufs(dir->i_sb);
+	inode_inc_link_count(dir);
+
 	inode = ufs_new_inode(dir, S_IFDIR|mode);
+	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
-		return PTR_ERR(inode);
+		goto out_dir;
 
 	inode->i_op = &ufs_dir_inode_operations;
 	inode->i_fop = &ufs_dir_operations;
@@ -194,9 +198,6 @@ static int ufs_mkdir(struct inode * dir,
 
 	inode_inc_link_count(inode);
 
-	lock_ufs(dir->i_sb);
-	inode_inc_link_count(dir);
-
 	err = ufs_make_empty(inode, dir);
 	if (err)
 		goto out_fail;
@@ -215,6 +216,7 @@ out_fail:
 	inode_dec_link_count(inode);
 	unlock_new_inode(inode);
 	iput (inode);
+out_dir:
 	inode_dec_link_count(dir);
 	unlock_ufs(dir->i_sb);
 	goto out;
_

Patches currently in -mm which might be from fabf@skynet.be are

configfs-unexport-make-static-config_item_init.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-befs-btreec-remove-unneeded-initializations.patch
fs-affs-inodec-remove-unneeded-initialization.patch
fs-affs-amigaffsc-remove-unneeded-initialization.patch
fs-affs-symlinkc-remove-unneeded-err-variable.patch
w1-masters-omap_hdq-add-support-for-1-wire-mode.patch
linux-next.patch
mm-provide-new-get_vaddr_frames-helper.patch
media-omap_vout-convert-omap_vout_uservirt_to_phys-to-use-get_vaddr_pfns.patch
vb2-provide-helpers-for-mapping-virtual-addresses.patch
media-vb2-convert-vb2_dma_sg_get_userptr-to-use-frame-vector.patch
media-vb2-convert-vb2_vmalloc_get_userptr-to-use-frame-vector.patch
media-vb2-convert-vb2_dc_get_userptr-to-use-frame-vector.patch
media-vb2-remove-unused-functions.patch
drm-exynos-convert-g2d_userptr_get_dma_addr-to-use-get_vaddr_frames.patch
mm-move-get_vaddr_frames-behind-a-config-option.patch

