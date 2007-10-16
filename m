From: akpm@linux-foundation.org
Subject: - ecryptfs-initialize-persistent-lower-file-on-inode-create.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:41:06 -0700
Message-ID: <200710162041.l9GKf6HR015759@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32870 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965363AbXJPVPI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:15:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: initialize persistent lower file on inode create
has been removed from the -mm tree.  Its filename was
     ecryptfs-initialize-persistent-lower-file-on-inode-create.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: eCryptfs: initialize persistent lower file on inode create
From: Michael Halcrow <mhalcrow@us.ibm.com>

Initialize persistent lower file on inode create.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/super.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN fs/ecryptfs/super.c~ecryptfs-initialize-persistent-lower-file-on-inode-create fs/ecryptfs/super.c
--- a/fs/ecryptfs/super.c~ecryptfs-initialize-persistent-lower-file-on-inode-create
+++ a/fs/ecryptfs/super.c
@@ -47,15 +47,16 @@ struct kmem_cache *ecryptfs_inode_info_c
  */
 static struct inode *ecryptfs_alloc_inode(struct super_block *sb)
 {
-	struct ecryptfs_inode_info *ecryptfs_inode;
+	struct ecryptfs_inode_info *inode_info;
 	struct inode *inode = NULL;
 
-	ecryptfs_inode = kmem_cache_alloc(ecryptfs_inode_info_cache,
-					  GFP_KERNEL);
-	if (unlikely(!ecryptfs_inode))
+	inode_info = kmem_cache_alloc(ecryptfs_inode_info_cache, GFP_KERNEL);
+	if (unlikely(!inode_info))
 		goto out;
-	ecryptfs_init_crypt_stat(&ecryptfs_inode->crypt_stat);
-	inode = &ecryptfs_inode->vfs_inode;
+	ecryptfs_init_crypt_stat(&inode_info->crypt_stat);
+	mutex_init(&inode_info->lower_file_mutex);
+	inode_info->lower_file = NULL;
+	inode = &inode_info->vfs_inode;
 out:
 	return inode;
 }
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
