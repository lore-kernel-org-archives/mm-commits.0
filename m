From: akpm@linux-foundation.org
Subject: - ecryptfs-fix-data-types-int-size_t.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:18:31 -0800
Message-ID: <200901072218.n07MIVjc017985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762143AbZAGWTf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:19:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, dustin.kirkland@gmail.com, sandeen@redhat.com, shaggy@us.ibm.com, tchicks@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: Fix data types (int/size_t)
has been removed from the -mm tree.  Its filename was
     ecryptfs-fix-data-types-int-size_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptfs: Fix data types (int/size_t)
From: Michael Halcrow <mhalcrow@us.ibm.com>

Correct several format string data type specifiers.  Correct filename size
data types; they should be size_t rather than int when passed as
parameters to some other functions (although note that the filenames will
never be larger than int).

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Dustin Kirkland <dustin.kirkland@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Tyler Hicks <tchicks@us.ibm.com>
Cc: David Kleikamp <shaggy@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c   |    4 ++--
 fs/ecryptfs/file.c     |    2 +-
 fs/ecryptfs/inode.c    |    2 +-
 fs/ecryptfs/keystore.c |   24 ++++++++++++------------
 4 files changed, 16 insertions(+), 16 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-fix-data-types-int-size_t fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-fix-data-types-int-size_t
+++ a/fs/ecryptfs/crypto.c
@@ -2093,7 +2093,7 @@ int ecryptfs_encrypt_and_encode_filename
 		filename = kzalloc(sizeof(*filename), GFP_KERNEL);
 		if (!filename) {
 			printk(KERN_ERR "%s: Out of memory whilst attempting "
-			       "to kzalloc [%d] bytes\n", __func__,
+			       "to kzalloc [%zd] bytes\n", __func__,
 			       sizeof(*filename));
 			rc = -ENOMEM;
 			goto out;
@@ -2127,7 +2127,7 @@ int ecryptfs_encrypt_and_encode_filename
 		(*encoded_name) = kmalloc((*encoded_name_size) + 1, GFP_KERNEL);
 		if (!(*encoded_name)) {
 			printk(KERN_ERR "%s: Out of memory whilst attempting "
-			       "to kzalloc [%d] bytes\n", __func__,
+			       "to kzalloc [%zd] bytes\n", __func__,
 			       (*encoded_name_size));
 			rc = -ENOMEM;
 			kfree(filename->encrypted_filename);
diff -puN fs/ecryptfs/file.c~ecryptfs-fix-data-types-int-size_t fs/ecryptfs/file.c
--- a/fs/ecryptfs/file.c~ecryptfs-fix-data-types-int-size_t
+++ a/fs/ecryptfs/file.c
@@ -82,7 +82,7 @@ ecryptfs_filldir(void *dirent, const cha
 {
 	struct ecryptfs_getdents_callback *buf =
 	    (struct ecryptfs_getdents_callback *)dirent;
-	int name_size;
+	size_t name_size;
 	char *name;
 	int rc;
 
diff -puN fs/ecryptfs/inode.c~ecryptfs-fix-data-types-int-size_t fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-fix-data-types-int-size_t
+++ a/fs/ecryptfs/inode.c
@@ -362,7 +362,7 @@ static struct dentry *ecryptfs_lookup(st
 				      struct nameidata *ecryptfs_nd)
 {
 	char *encrypted_and_encoded_name = NULL;
-	int encrypted_and_encoded_name_size;
+	size_t encrypted_and_encoded_name_size;
 	struct ecryptfs_crypt_stat *crypt_stat = NULL;
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat = NULL;
 	struct ecryptfs_inode_info *inode_info;
diff -puN fs/ecryptfs/keystore.c~ecryptfs-fix-data-types-int-size_t fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-fix-data-types-int-size_t
+++ a/fs/ecryptfs/keystore.c
@@ -556,8 +556,8 @@ ecryptfs_write_tag_70_packet(char *dest,
 		goto out_unlock;
 	}
 	if (s->max_packet_size > (*remaining_bytes)) {
-		printk(KERN_WARNING "%s: Require [%d] bytes to write; only "
-		       "[%d] available\n", __func__, s->max_packet_size,
+		printk(KERN_WARNING "%s: Require [%zd] bytes to write; only "
+		       "[%zd] available\n", __func__, s->max_packet_size,
 		       (*remaining_bytes));
 		rc = -EINVAL;
 		goto out_unlock;
@@ -594,7 +594,7 @@ ecryptfs_write_tag_70_packet(char *dest,
 		mount_crypt_stat->global_default_fn_cipher_key_bytes);
 	if (s->cipher_code == 0) {
 		printk(KERN_WARNING "%s: Unable to generate code for "
-		       "cipher [%s] with key bytes [%d]\n", __func__,
+		       "cipher [%s] with key bytes [%zd]\n", __func__,
 		       mount_crypt_stat->global_default_fn_cipher_name,
 		       mount_crypt_stat->global_default_fn_cipher_key_bytes);
 		rc = -EINVAL;
@@ -693,7 +693,7 @@ ecryptfs_write_tag_70_packet(char *dest,
 		printk(KERN_ERR "%s: Internal error whilst attempting to "
 		       "convert filename memory to scatterlist; "
 		       "expected rc = 1; got rc = [%d]. "
-		       "block_aligned_filename_size = [%d]\n", __func__, rc,
+		       "block_aligned_filename_size = [%zd]\n", __func__, rc,
 		       s->block_aligned_filename_size);
 		goto out_release_free_unlock;
 	}
@@ -703,7 +703,7 @@ ecryptfs_write_tag_70_packet(char *dest,
 		printk(KERN_ERR "%s: Internal error whilst attempting to "
 		       "convert encrypted filename memory to scatterlist; "
 		       "expected rc = 1; got rc = [%d]. "
-		       "block_aligned_filename_size = [%d]\n", __func__, rc,
+		       "block_aligned_filename_size = [%zd]\n", __func__, rc,
 		       s->block_aligned_filename_size);
 		goto out_release_free_unlock;
 	}
@@ -787,7 +787,7 @@ ecryptfs_parse_tag_70_packet(char **file
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s) {
 		printk(KERN_ERR "%s: Out of memory whilst trying to kmalloc "
-		       "[%d] bytes of kernel memory\n", __func__, sizeof(*s));
+		       "[%zd] bytes of kernel memory\n", __func__, sizeof(*s));
 		goto out;
 	}
 	s->desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
@@ -825,8 +825,8 @@ ecryptfs_parse_tag_70_packet(char **file
 					  - ECRYPTFS_SIG_SIZE - 1);
 	if ((1 + s->packet_size_len + s->parsed_tag_70_packet_size)
 	    > max_packet_size) {
-		printk(KERN_WARNING "%s: max_packet_size is [%d]; real packet "
-		       "size is [%d]\n", __func__, max_packet_size,
+		printk(KERN_WARNING "%s: max_packet_size is [%zd]; real packet "
+		       "size is [%zd]\n", __func__, max_packet_size,
 		       (1 + s->packet_size_len + 1
 			+ s->block_aligned_filename_size));
 		rc = -EINVAL;
@@ -860,7 +860,7 @@ ecryptfs_parse_tag_70_packet(char **file
 		printk(KERN_ERR "%s: Internal error whilst attempting to "
 		       "convert encrypted filename memory to scatterlist; "
 		       "expected rc = 1; got rc = [%d]. "
-		       "block_aligned_filename_size = [%d]\n", __func__, rc,
+		       "block_aligned_filename_size = [%zd]\n", __func__, rc,
 		       s->block_aligned_filename_size);
 		goto out_unlock;
 	}
@@ -869,7 +869,7 @@ ecryptfs_parse_tag_70_packet(char **file
 					GFP_KERNEL);
 	if (!s->decrypted_filename) {
 		printk(KERN_ERR "%s: Out of memory whilst attempting to "
-		       "kmalloc [%d] bytes\n", __func__,
+		       "kmalloc [%zd] bytes\n", __func__,
 		       s->block_aligned_filename_size);
 		rc = -ENOMEM;
 		goto out_unlock;
@@ -880,7 +880,7 @@ ecryptfs_parse_tag_70_packet(char **file
 		printk(KERN_ERR "%s: Internal error whilst attempting to "
 		       "convert decrypted filename memory to scatterlist; "
 		       "expected rc = 1; got rc = [%d]. "
-		       "block_aligned_filename_size = [%d]\n", __func__, rc,
+		       "block_aligned_filename_size = [%zd]\n", __func__, rc,
 		       s->block_aligned_filename_size);
 		goto out_free_unlock;
 	}
@@ -944,7 +944,7 @@ ecryptfs_parse_tag_70_packet(char **file
 	(*filename) = kmalloc(((*filename_size) + 1), GFP_KERNEL);
 	if (!(*filename)) {
 		printk(KERN_ERR "%s: Out of memory whilst attempting to "
-		       "kmalloc [%d] bytes\n", __func__,
+		       "kmalloc [%zd] bytes\n", __func__,
 		       ((*filename_size) + 1));
 		rc = -ENOMEM;
 		goto out_free_unlock;
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
notify_change-callers-must-hold-i_mutex.patch

