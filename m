From: akpm@linux-foundation.org
Subject: + ecryptfs-do-not-try-to-open-device-files-on-mknod.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:41:57 -0700
Message-ID: <200807111847.m6BIlcA5031057@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755762AbYGKSr7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:47:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: do not try to open device files on mknod
has been added to the -mm tree.  Its filename is
     ecryptfs-do-not-try-to-open-device-files-on-mknod.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptfs: do not try to open device files on mknod
From: Michael Halcrow <mhalcrow@us.ibm.com>

When creating device nodes, eCryptfs needs to delay actually opening the lower
persistent file until an application tries to open.  Device handles may not be
backed by anything when they first come into existence.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/ecryptfs_kernel.h |    5 ++++-
 fs/ecryptfs/file.c            |   14 ++++++++++++++
 fs/ecryptfs/inode.c           |    6 ++++--
 fs/ecryptfs/main.c            |   29 +++++++++++++++++++----------
 4 files changed, 41 insertions(+), 13 deletions(-)

diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-do-not-try-to-open-device-files-on-mknod fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-do-not-try-to-open-device-files-on-mknod
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -235,6 +235,7 @@ struct ecryptfs_crypt_stat {
 #define ECRYPTFS_METADATA_IN_XATTR  0x00000100
 #define ECRYPTFS_VIEW_AS_ENCRYPTED  0x00000200
 #define ECRYPTFS_KEY_SET            0x00000400
+#define ECRYPTFS_DELAY_PERSISTENT   0x00000800
 	u32 flags;
 	unsigned int file_version;
 	size_t iv_bytes;
@@ -574,9 +575,11 @@ struct ecryptfs_open_req {
 	struct list_head kthread_ctl_list;
 };
 
+#define ECRYPTFS_INTERPOSE_FLAG_D_ADD                 0x00000001
+#define ECRYPTFS_INTERPOSE_FLAG_DELAY_PERSISTENT_FILE 0x00000002
 int ecryptfs_interpose(struct dentry *hidden_dentry,
 		       struct dentry *this_dentry, struct super_block *sb,
-		       int flag);
+		       u32 flags);
 int ecryptfs_fill_zeros(struct file *file, loff_t new_length);
 int ecryptfs_decode_filename(struct ecryptfs_crypt_stat *crypt_stat,
 			     const char *name, int length,
diff -puN fs/ecryptfs/file.c~ecryptfs-do-not-try-to-open-device-files-on-mknod fs/ecryptfs/file.c
--- a/fs/ecryptfs/file.c~ecryptfs-do-not-try-to-open-device-files-on-mknod
+++ a/fs/ecryptfs/file.c
@@ -199,6 +199,20 @@ static int ecryptfs_open(struct inode *i
 		       "file must hence be opened RO\n", __func__);
 		goto out;
 	}
+	if (!ecryptfs_inode_to_private(inode)->lower_file) {
+		BUG_ON(!(crypt_stat->flags & ECRYPTFS_DELAY_PERSISTENT));
+		mutex_lock(&crypt_stat->cs_mutex);
+		crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
+		mutex_unlock(&crypt_stat->cs_mutex);
+		rc = ecryptfs_init_persistent_file(ecryptfs_dentry);
+		if (rc) {
+			printk(KERN_ERR "%s: Error attempting to initialize "
+			       "the persistent file for the dentry with name "
+			       "[%s]; rc = [%d]\n", __func__,
+			       ecryptfs_dentry->d_name.name, rc);
+			goto out;
+		}
+	}
 	ecryptfs_set_file_lower(
 		file, ecryptfs_inode_to_private(inode)->lower_file);
 	if (S_ISDIR(ecryptfs_dentry->d_inode->i_mode)) {
diff -puN fs/ecryptfs/inode.c~ecryptfs-do-not-try-to-open-device-files-on-mknod fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-do-not-try-to-open-device-files-on-mknod
+++ a/fs/ecryptfs/inode.c
@@ -308,7 +308,8 @@ static struct dentry *ecryptfs_lookup(st
 		d_add(dentry, NULL);
 		goto out;
 	}
-	rc = ecryptfs_interpose(lower_dentry, dentry, dir->i_sb, 1);
+	rc = ecryptfs_interpose(lower_dentry, dentry, dir->i_sb,
+				ECRYPTFS_INTERPOSE_FLAG_D_ADD);
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Error interposing\n");
 		goto out_dput;
@@ -537,7 +538,8 @@ ecryptfs_mknod(struct inode *dir, struct
 	rc = vfs_mknod(lower_dir_dentry->d_inode, lower_dentry, mode, dev);
 	if (rc || !lower_dentry->d_inode)
 		goto out;
-	rc = ecryptfs_interpose(lower_dentry, dentry, dir->i_sb, 0);
+	rc = ecryptfs_interpose(lower_dentry, dentry, dir->i_sb,
+				ECRYPTFS_INTERPOSE_FLAG_DELAY_PERSISTENT_FILE);
 	if (rc)
 		goto out;
 	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
diff -puN fs/ecryptfs/main.c~ecryptfs-do-not-try-to-open-device-files-on-mknod fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-do-not-try-to-open-device-files-on-mknod
+++ a/fs/ecryptfs/main.c
@@ -117,7 +117,7 @@ void __ecryptfs_printk(const char *fmt, 
  *
  * Returns zero on success; non-zero otherwise
  */
-static int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
+int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
 {
 	struct ecryptfs_inode_info *inode_info =
 		ecryptfs_inode_to_private(ecryptfs_dentry->d_inode);
@@ -149,14 +149,14 @@ static int ecryptfs_init_persistent_file
  * @lower_dentry: Existing dentry in the lower filesystem
  * @dentry: ecryptfs' dentry
  * @sb: ecryptfs's super_block
- * @flag: If set to true, then d_add is called, else d_instantiate is called
+ * @flags: flags to govern behavior of interpose procedure
  *
  * Interposes upper and lower dentries.
  *
  * Returns zero on success; non-zero otherwise
  */
 int ecryptfs_interpose(struct dentry *lower_dentry, struct dentry *dentry,
-		       struct super_block *sb, int flag)
+		       struct super_block *sb, u32 flags)
 {
 	struct inode *lower_inode;
 	struct inode *inode;
@@ -193,7 +193,7 @@ int ecryptfs_interpose(struct dentry *lo
 		init_special_inode(inode, lower_inode->i_mode,
 				   lower_inode->i_rdev);
 	dentry->d_op = &ecryptfs_dops;
-	if (flag)
+	if (flags & ECRYPTFS_INTERPOSE_FLAG_D_ADD)
 		d_add(dentry, inode);
 	else
 		d_instantiate(dentry, inode);
@@ -201,12 +201,21 @@ int ecryptfs_interpose(struct dentry *lo
 	/* This size will be overwritten for real files w/ headers and
 	 * other metadata */
 	fsstack_copy_inode_size(inode, lower_inode);
-	rc = ecryptfs_init_persistent_file(dentry);
-	if (rc) {
-		printk(KERN_ERR "%s: Error attempting to initialize the "
-		       "persistent file for the dentry with name [%s]; "
-		       "rc = [%d]\n", __func__, dentry->d_name.name, rc);
-		goto out;
+	if (!(flags & ECRYPTFS_INTERPOSE_FLAG_DELAY_PERSISTENT_FILE)) {
+		rc = ecryptfs_init_persistent_file(dentry);
+		if (rc) {
+			printk(KERN_ERR "%s: Error attempting to initialize "
+			       "the persistent file for the dentry with name "
+			       "[%s]; rc = [%d]\n", __func__,
+			       dentry->d_name.name, rc);
+			goto out;
+		}
+	} else {
+		struct ecryptfs_inode_info *inode_info =
+			ecryptfs_inode_to_private(dentry->d_inode);
+
+		inode_info->lower_file = NULL;
+		inode_info->crypt_stat.flags |= ECRYPTFS_DELAY_PERSISTENT;
 	}
 out:
 	return rc;
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

git-unionfs.patch
fsstack-fsstack_copy_inode_size-locking.patch
ecryptfs-privileged-kthread-for-lower-file-opens.patch
ecryptfs-discard-ecryptfsd-registration-messages-in-miscdev.patch
ecryptfs-propagate-key-errors-up-at-mount-time.patch
ecryptfs-string-copy-cleanup.patch
ecryptfs-cryptoc-use-unaligned-byteorder-helpers.patch
ecryptfs-inodec-mmapc-use-unaligned-byteorder-helpers.patch
ecryptfs-do-not-try-to-open-device-files-on-mknod.patch
tpm-use-correct-data-types-for-sizes-in-tpm_write-and-tpm_read.patch
notify_change-callers-must-hold-i_mutex.patch

