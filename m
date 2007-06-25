From: akpm@linux-foundation.org
Subject: + ecryptfs-initialize-crypt_stat-in-setattr.patch added to -mm tree
Date: Mon, 25 Jun 2007 11:16:01 -0700
Message-ID: <200706251816.l5PIG1Sw007617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54777 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751607AbXFYSQR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 14:16:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: initialize crypt_stat in setattr
has been added to the -mm tree.  Its filename is
     ecryptfs-initialize-crypt_stat-in-setattr.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: initialize crypt_stat in setattr
From: Michael Halcrow <mhalcrow@us.ibm.com>

Recent changes in eCryptfs have made it possible to get to ecryptfs_setattr()
with an uninitialized crypt_stat struct.  This results in a wide and colorful
variety of unpleasantries.  This patch properly initializes the crypt_stat
structure in ecryptfs_setattr() when it is necessary to do so.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/inode.c |   47 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 46 insertions(+), 1 deletion(-)

diff -puN fs/ecryptfs/inode.c~ecryptfs-initialize-crypt_stat-in-setattr fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-initialize-crypt_stat-in-setattr
+++ a/fs/ecryptfs/inode.c
@@ -894,9 +894,54 @@ static int ecryptfs_setattr(struct dentr
 	struct ecryptfs_crypt_stat *crypt_stat;
 
 	crypt_stat = &ecryptfs_inode_to_private(dentry->d_inode)->crypt_stat;
-	lower_dentry = ecryptfs_dentry_to_lower(dentry);
+	if (!(crypt_stat->flags & ECRYPTFS_STRUCT_INITIALIZED))
+		ecryptfs_init_crypt_stat(crypt_stat);
 	inode = dentry->d_inode;
 	lower_inode = ecryptfs_inode_to_lower(inode);
+	lower_dentry = ecryptfs_dentry_to_lower(dentry);
+	mutex_lock(&crypt_stat->cs_mutex);
+	if (S_ISDIR(dentry->d_inode->i_mode))
+		crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
+	else if (!(crypt_stat->flags & ECRYPTFS_POLICY_APPLIED)
+		 || !(crypt_stat->flags & ECRYPTFS_KEY_VALID)) {
+		struct vfsmount *lower_mnt;
+		struct file *lower_file = NULL;
+		struct ecryptfs_mount_crypt_stat *mount_crypt_stat;
+		int lower_flags;
+
+		lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
+		lower_flags = O_RDONLY;
+		if ((rc = ecryptfs_open_lower_file(&lower_file, lower_dentry,
+						   lower_mnt, lower_flags))) {
+			printk(KERN_ERR
+			       "Error opening lower file; rc = [%d]\n", rc);
+			mutex_unlock(&crypt_stat->cs_mutex);
+			goto out;
+		}
+		mount_crypt_stat = &ecryptfs_superblock_to_private(
+			dentry->d_sb)->mount_crypt_stat;
+		if ((rc = ecryptfs_read_metadata(dentry, lower_file))) {
+			if (!(mount_crypt_stat->flags
+			      & ECRYPTFS_PLAINTEXT_PASSTHROUGH_ENABLED)) {
+				rc = -EIO;
+				printk(KERN_WARNING "Attempt to read file that "
+				       "is not in a valid eCryptfs format, "
+				       "and plaintext passthrough mode is not "
+				       "enabled; returning -EIO\n");
+
+				mutex_unlock(&crypt_stat->cs_mutex);
+				fput(lower_file);
+				goto out;
+			}
+			rc = 0;
+			crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
+			mutex_unlock(&crypt_stat->cs_mutex);
+			fput(lower_file);
+			goto out;
+		}
+		fput(lower_file);
+	}
+	mutex_unlock(&crypt_stat->cs_mutex);
 	if (ia->ia_valid & ATTR_SIZE) {
 		ecryptfs_printk(KERN_DEBUG,
 				"ia->ia_valid = [0x%x] ATTR_SIZE" " = [0x%x]\n",
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

ecryptfs-fix-write-zeros-behavior.patch
ecryptfs-initialize-crypt_stat-in-setattr.patch
ecryptfs-zero-out-last-page-for-llseek-write.patch
git-unionfs.patch
couple-fixes-to-fs-ecryptfs-inodec.patch
ecryptfs-move-ecryptfs-docs-into-documentation-filesystems.patch
fs-introduce-vfs_path_lookup.patch
sunrpc-use-vfs_path_lookup.patch
nfsctl-use-vfs_path_lookup.patch
fs-mark-link_path_walk-static.patch
fs-remove-path_walk-export.patch
