From: akpm@linux-foundation.org
Subject: [folded] nilfs2-pathname-operations-fix.patch removed from -mm tree
Date: Mon, 06 Apr 2009 15:34:24 -0700
Message-ID: <200904062234.n36MYOEx017742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756390AbZDFWf7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 18:35:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     nilfs2-continuous-snapshotting-file-system-fix
has been removed from the -mm tree.  Its filename was
     nilfs2-pathname-operations-fix.patch

This patch was dropped because it was folded into nilfs2-pathname-operations.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2-continuous-snapshotting-file-system-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/namei.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN fs/nilfs2/namei.c~nilfs2-pathname-operations-fix fs/nilfs2/namei.c
--- a/fs/nilfs2/namei.c~nilfs2-pathname-operations-fix
+++ a/fs/nilfs2/namei.c
@@ -80,7 +80,6 @@ nilfs_lookup(struct inode *dir, struct d
 struct dentry *nilfs_get_parent(struct dentry *child)
 {
 	unsigned long ino;
-	struct dentry *parent;
 	struct inode *inode;
 	struct dentry dotdot;
 
@@ -94,12 +93,7 @@ struct dentry *nilfs_get_parent(struct d
 	inode = nilfs_iget(child->d_inode->i_sb, ino);
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
-	parent = d_alloc_anon(inode);
-	if (!parent) {
-		iput(inode);
-		parent = ERR_PTR(-ENOMEM);
-	}
-	return parent;
+	return d_obtain_alias(inode);
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-add-proc-controls-for-pdflush-threads.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
nilfs2-integrated-block-mapping.patch
nilfs2-pathname-operations.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
vfs-simple_set_mnt-should-return-void-fix-nilfs.patch
nilfs2-segment-buffer-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
page-owner-tracking.patch
page-owner-tracking-checkpatch-fixes.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

