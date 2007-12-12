From: akpm@linux-foundation.org
Subject: + ecryptfs-make-show_options-reflect-actual-mount-options.patch added to -mm tree
Date: Tue, 11 Dec 2007 19:42:43 -0800
Message-ID: <200712120342.lBC3ghco023841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51255 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865AbXLLDxs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Dec 2007 22:53:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com, mhalcrow@us.ibm.com


The patch titled
     ecryptfs: make show_options reflect actual mount options
has been added to the -mm tree.  Its filename is
     ecryptfs-make-show_options-reflect-actual-mount-options.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ecryptfs: make show_options reflect actual mount options
From: Eric Sandeen <sandeen@redhat.com>

Change ecryptfs_show_options to reflect the actual mount options in use. 
Note that this does away with the "dir=" output, which is not a valid mount
option and appears to be unused.

Mount options such as "ecryptfs_verbose" and "ecryptfs_xattr_metadata" are
somewhat indeterminate for a given fs, but in any case the reported mount
options can be used in a new mount command to get the same behavior.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/super.c |   51 +++++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff -puN fs/ecryptfs/super.c~ecryptfs-make-show_options-reflect-actual-mount-options fs/ecryptfs/super.c
--- a/fs/ecryptfs/super.c~ecryptfs-make-show_options-reflect-actual-mount-options
+++ a/fs/ecryptfs/super.c
@@ -157,31 +157,42 @@ static void ecryptfs_clear_inode(struct 
 /**
  * ecryptfs_show_options
  *
- * Prints the directory we are currently mounted over.
- * Returns zero on success; non-zero otherwise
+ * Prints the mount options for a given superblock.
+ * Returns zero; does not fail.
  */
 static int ecryptfs_show_options(struct seq_file *m, struct vfsmount *mnt)
 {
 	struct super_block *sb = mnt->mnt_sb;
-	struct path *lower_root = &ecryptfs_dentry_to_private(sb->s_root)->lower_path;
-	char *tmp_page;
-	char *path;
-	int rc = 0;
-
-	tmp_page = (char *)__get_free_page(GFP_KERNEL);
-	if (!tmp_page) {
-		rc = -ENOMEM;
-		goto out;
-	}
-	path = d_path(lower_root, tmp_page, PAGE_SIZE);
-	if (IS_ERR(path)) {
-		rc = PTR_ERR(path);
-		goto out;
+	struct ecryptfs_mount_crypt_stat *mount_crypt_stat =
+		&ecryptfs_superblock_to_private(sb)->mount_crypt_stat;
+	struct ecryptfs_global_auth_tok *walker;
+
+	mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);
+	list_for_each_entry(walker,
+			    &mount_crypt_stat->global_auth_tok_list,
+			    mount_crypt_stat_list) {
+		seq_printf(m, ",ecryptfs_sig=%s", walker->sig);
 	}
-	seq_printf(m, ",dir=%s", path);
-	free_page((unsigned long)tmp_page);
-out:
-	return rc;
+	mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);
+
+	/* Note this is global and probably shouldn't be a mount option */
+	if (ecryptfs_verbosity)
+		seq_printf(m, ",ecryptfs_debug=%d\n", ecryptfs_verbosity);
+
+	seq_printf(m, ",ecryptfs_cipher=%s",
+		mount_crypt_stat->global_default_cipher_name);
+
+	if (mount_crypt_stat->global_default_cipher_key_size)
+		seq_printf(m, ",ecryptfs_key_bytes=%d",
+			   mount_crypt_stat->global_default_cipher_key_size);
+	if (mount_crypt_stat->flags & ECRYPTFS_PLAINTEXT_PASSTHROUGH_ENABLED)
+		seq_printf(m, ",ecryptfs_passthrough");
+	if (mount_crypt_stat->flags & ECRYPTFS_XATTR_METADATA_ENABLED)
+		seq_printf(m, ",ecryptfs_xattr_metadata");
+	if (mount_crypt_stat->flags & ECRYPTFS_ENCRYPTED_VIEW_ENABLED)
+		seq_printf(m, ",ecryptfs_encrypted_view");
+
+	return 0;
 }
 
 const struct super_operations ecryptfs_sops = {
_

Patches currently in -mm which might be from sandeen@redhat.com are

ecryptfs-initialize-new-auth_tokens-before-teardown.patch
ext2-change-the-default-behaviour-on-error.patch
ecryptfs-make-show_options-reflect-actual-mount-options.patch
ext4-fix-mb_debug-format-warnings.patch
ext4-fix-freespace-accounting-with-mballoc-on-32bit-machines.patch
ext4-fix-oops-with-jbd-stats-through-procfs-and-external.patch
ext4-fix-up-ext4fs_debug-builds.patch
ext3-change-the-default-behaviour-on-error.patch
