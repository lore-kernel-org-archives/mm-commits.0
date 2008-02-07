From: akpm@linux-foundation.org
Subject: - ecryptfs-make-show_options-reflect-actual-mount-options.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:26:46 -0800
Message-ID: <200802070026.m170QRYc006919@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35884 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934018AbYBGApf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: make show_options reflect actual mount options
has been removed from the -mm tree.  Its filename was
     ecryptfs-make-show_options-reflect-actual-mount-options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ecryptfs: make show_options reflect actual mount options
From: Eric Sandeen <sandeen@redhat.com>

Change ecryptfs_show_options to reflect the actual mount options in use. 
Note that this does away with the "dir=" output, which is not a valid mount
option and appears to be unused.

Mount options such as "ecryptfs_verbose" and "ecryptfs_xattr_metadata" are
somewhat indeterminate for a given fs, but in any case the reported mount
options can be used in a new mount command to get the same behavior.

[akpm@linux-foundation.org: fix printk warning]
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/super.c |   52 +++++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 21 deletions(-)

diff -puN fs/ecryptfs/super.c~ecryptfs-make-show_options-reflect-actual-mount-options fs/ecryptfs/super.c
--- a/fs/ecryptfs/super.c~ecryptfs-make-show_options-reflect-actual-mount-options
+++ a/fs/ecryptfs/super.c
@@ -156,32 +156,42 @@ static void ecryptfs_clear_inode(struct 
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
-	struct dentry *lower_root_dentry = ecryptfs_dentry_to_lower(sb->s_root);
-	struct vfsmount *lower_mnt = ecryptfs_dentry_to_lower_mnt(sb->s_root);
-	char *tmp_page;
-	char *path;
-	int rc = 0;
-
-	tmp_page = (char *)__get_free_page(GFP_KERNEL);
-	if (!tmp_page) {
-		rc = -ENOMEM;
-		goto out;
-	}
-	path = d_path(lower_root_dentry, lower_mnt, tmp_page, PAGE_SIZE);
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
+		seq_printf(m, ",ecryptfs_key_bytes=%zd",
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

origin.patch
reduce-large-do_mount-stack-usage-with-noinlines.patch
