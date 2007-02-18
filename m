From: akpm@linux-foundation.org
Subject: - ecryptfs-convert-lookup_one_len-to-lookup_one_len_nd.patch removed from -mm tree
Date: Sat, 17 Feb 2007 18:15:19 -0800
Message-ID: <200702180215.l1I2FJ9Z008379@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55670 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993108AbXBRCPY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 21:15:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: convert lookup_one_len() to lookup_one_len_nd()
has been removed from the -mm tree.  Its filename was
     ecryptfs-convert-lookup_one_len-to-lookup_one_len_nd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: eCryptfs: convert lookup_one_len() to lookup_one_len_nd()
From: Michael Halcrow <mhalcrow@us.ibm.com>

Call the new lookup_one_len_nd() rather than lookup_one_len().  This fixes an
oops when stacked on NFS.

Note that there are still some issues with eCryptfs on NFS having to do with
directory deletion (I'm not getting an oops, just an -EBUSY).

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/inode.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN fs/ecryptfs/inode.c~ecryptfs-convert-lookup_one_len-to-lookup_one_len_nd fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-convert-lookup_one_len-to-lookup_one_len_nd
+++ a/fs/ecryptfs/inode.c
@@ -283,7 +283,9 @@ static struct dentry *ecryptfs_lookup(st
 	int rc = 0;
 	struct dentry *lower_dir_dentry;
 	struct dentry *lower_dentry;
+	struct dentry *dentry_save;
 	struct vfsmount *lower_mnt;
+	struct vfsmount *mnt_save;
 	char *encoded_name;
 	unsigned int encoded_namelen;
 	struct ecryptfs_crypt_stat *crypt_stat = NULL;
@@ -311,9 +313,13 @@ static struct dentry *ecryptfs_lookup(st
 	}
 	ecryptfs_printk(KERN_DEBUG, "encoded_name = [%s]; encoded_namelen "
 			"= [%d]\n", encoded_name, encoded_namelen);
-	lower_dentry = lookup_one_len(encoded_name, lower_dir_dentry,
-				      encoded_namelen - 1);
+	dentry_save = nd->dentry;
+	mnt_save = nd->mnt;
+	lower_dentry = lookup_one_len_nd(encoded_name, lower_dir_dentry,
+					 (encoded_namelen - 1), nd);
 	kfree(encoded_name);
+	nd->mnt = mnt_save;
+	nd->dentry = dentry_save;
 	if (IS_ERR(lower_dentry)) {
 		ecryptfs_printk(KERN_ERR, "ERR from lower_dentry\n");
 		rc = PTR_ERR(lower_dentry);
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
