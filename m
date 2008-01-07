From: akpm@linux-foundation.org
Subject: + ecryptfs-check-for-existing-key_tfm-at-mount-time.patch added to -mm tree
Date: Mon, 07 Jan 2008 14:38:15 -0800
Message-ID: <200801072238.m07McHFC015661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34348 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753483AbYAGWjn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 17:39:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com, jmoyer@redhat.com, mhalcrow@us.ibm.com


The patch titled
     ecryptfs: check for existing key_tfm at mount time
has been added to the -mm tree.  Its filename is
     ecryptfs-check-for-existing-key_tfm-at-mount-time.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ecryptfs: check for existing key_tfm at mount time
From: Eric Sandeen <sandeen@redhat.com>

Jeff Moyer pointed out that a mount; umount loop of ecryptfs, with the same
cipher & other mount options, created a new ecryptfs_key_tfm_cache item
each time, and the cache could grow quite large this way.

Looking at this with mhalcrow, we saw that ecryptfs_parse_options()
unconditionally called ecryptfs_add_new_key_tfm(), which is what was adding
these items.

Refactor ecryptfs_get_tfm_and_mutex_for_cipher_name() to create a new
helper function, ecryptfs_tfm_exists(), which checks for the cipher on the
cached key_tfm_list, and sets a pointer to it if it exists.  This can then
be called from ecryptfs_parse_options(), and new key_tfm's can be added
only when a cached one is not found.

With list locking changes suggested by akpm.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c          |   67 +++++++++++++++++++++++++-------
 fs/ecryptfs/ecryptfs_kernel.h |    3 +
 fs/ecryptfs/main.c            |   10 +++-
 3 files changed, 63 insertions(+), 17 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-check-for-existing-key_tfm-at-mount-time fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-check-for-existing-key_tfm-at-mount-time
+++ a/fs/ecryptfs/crypto.c
@@ -1780,7 +1780,7 @@ out:
 
 struct kmem_cache *ecryptfs_key_tfm_cache;
 static struct list_head key_tfm_list;
-static struct mutex key_tfm_list_mutex;
+struct mutex key_tfm_list_mutex;
 
 int ecryptfs_init_crypto(void)
 {
@@ -1789,6 +1789,11 @@ int ecryptfs_init_crypto(void)
 	return 0;
 }
 
+/**
+ * ecryptfs_destroy_crypto - free all cached key_tfms on key_tfm_list
+ *
+ * Called only at module unload time
+ */
 int ecryptfs_destroy_crypto(void)
 {
 	struct ecryptfs_key_tfm *key_tfm, *key_tfm_tmp;
@@ -1812,6 +1817,8 @@ ecryptfs_add_new_key_tfm(struct ecryptfs
 	struct ecryptfs_key_tfm *tmp_tfm;
 	int rc = 0;
 
+	BUG_ON(!mutex_is_locked(&key_tfm_list_mutex));
+
 	tmp_tfm = kmem_cache_alloc(ecryptfs_key_tfm_cache, GFP_KERNEL);
 	if (key_tfm != NULL)
 		(*key_tfm) = tmp_tfm;
@@ -1838,13 +1845,50 @@ ecryptfs_add_new_key_tfm(struct ecryptfs
 			(*key_tfm) = NULL;
 		goto out;
 	}
-	mutex_lock(&key_tfm_list_mutex);
 	list_add(&tmp_tfm->key_tfm_list, &key_tfm_list);
-	mutex_unlock(&key_tfm_list_mutex);
 out:
 	return rc;
 }
 
+/**
+ * ecryptfs_tfm_exists - Search for existing tfm for cipher_name.
+ * @cipher_name: the name of the cipher to search for
+ * @key_tfm: set to corresponding tfm if found
+ *
+ * Searches for cached key_tfm matching @cipher_name
+ * Must be called with &key_tfm_list_mutex held
+ * Returns 1 if found, with @key_tfm set
+ * Returns 0 if not found, with @key_tfm set to NULL
+ */
+int ecryptfs_tfm_exists(char *cipher_name, struct ecryptfs_key_tfm **key_tfm)
+{
+	struct ecryptfs_key_tfm *tmp_key_tfm;
+
+	BUG_ON(!mutex_is_locked(&key_tfm_list_mutex));
+
+	list_for_each_entry(tmp_key_tfm, &key_tfm_list, key_tfm_list) {
+		if (strcmp(tmp_key_tfm->cipher_name, cipher_name) == 0) {
+			if (key_tfm)
+				(*key_tfm) = tmp_key_tfm;
+			return 1;
+		}
+	}
+	if (key_tfm)
+		(*key_tfm) = NULL;
+	return 0;
+}
+
+/**
+ * ecryptfs_get_tfm_and_mutex_for_cipher_name
+ *
+ * @tfm: set to cached tfm found, or new tfm created
+ * @tfm_mutex: set to mutex for cached tfm found, or new tfm created
+ * @cipher_name: the name of the cipher to search for and/or add
+ *
+ * Sets pointers to @tfm & @tfm_mutex matching @cipher_name.
+ * Searches for cached item first, and creates new if not found.
+ * Returns 0 on success, non-zero if adding new cipher failed
+ */
 int ecryptfs_get_tfm_and_mutex_for_cipher_name(struct crypto_blkcipher **tfm,
 					       struct mutex **tfm_mutex,
 					       char *cipher_name)
@@ -1854,22 +1898,17 @@ int ecryptfs_get_tfm_and_mutex_for_ciphe
 
 	(*tfm) = NULL;
 	(*tfm_mutex) = NULL;
+
 	mutex_lock(&key_tfm_list_mutex);
-	list_for_each_entry(key_tfm, &key_tfm_list, key_tfm_list) {
-		if (strcmp(key_tfm->cipher_name, cipher_name) == 0) {
-			(*tfm) = key_tfm->key_tfm;
-			(*tfm_mutex) = &key_tfm->key_tfm_mutex;
-			mutex_unlock(&key_tfm_list_mutex);
+	if (!ecryptfs_tfm_exists(cipher_name, &key_tfm)) {
+		rc = ecryptfs_add_new_key_tfm(&key_tfm, cipher_name, 0);
+		if (rc) {
+			printk(KERN_ERR "Error adding new key_tfm to list; "
+					"rc = [%d]\n", rc);
 			goto out;
 		}
 	}
 	mutex_unlock(&key_tfm_list_mutex);
-	rc = ecryptfs_add_new_key_tfm(&key_tfm, cipher_name, 0);
-	if (rc) {
-		printk(KERN_ERR "Error adding new key_tfm to list; rc = [%d]\n",
-		       rc);
-		goto out;
-	}
 	(*tfm) = key_tfm->key_tfm;
 	(*tfm_mutex) = &key_tfm->key_tfm_mutex;
 out:
diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-check-for-existing-key_tfm-at-mount-time fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-check-for-existing-key_tfm-at-mount-time
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -323,6 +323,8 @@ struct ecryptfs_key_tfm {
 	unsigned char cipher_name[ECRYPTFS_MAX_CIPHER_NAME_SIZE + 1];
 };
 
+extern struct mutex key_tfm_list_mutex;
+
 /**
  * This struct is to enable a mount-wide passphrase/salt combo. This
  * is more or less a stopgap to provide similar functionality to other
@@ -617,6 +619,7 @@ ecryptfs_add_new_key_tfm(struct ecryptfs
 			 size_t key_size);
 int ecryptfs_init_crypto(void);
 int ecryptfs_destroy_crypto(void);
+int ecryptfs_tfm_exists(char *cipher_name, struct ecryptfs_key_tfm **key_tfm);
 int ecryptfs_get_tfm_and_mutex_for_cipher_name(struct crypto_blkcipher **tfm,
 					       struct mutex **tfm_mutex,
 					       char *cipher_name);
diff -puN fs/ecryptfs/main.c~ecryptfs-check-for-existing-key_tfm-at-mount-time fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-check-for-existing-key_tfm-at-mount-time
+++ a/fs/ecryptfs/main.c
@@ -410,9 +410,13 @@ static int ecryptfs_parse_options(struct
 	if (!cipher_key_bytes_set) {
 		mount_crypt_stat->global_default_cipher_key_size = 0;
 	}
-	rc = ecryptfs_add_new_key_tfm(
-		NULL, mount_crypt_stat->global_default_cipher_name,
-		mount_crypt_stat->global_default_cipher_key_size);
+	mutex_lock(&key_tfm_list_mutex);
+	if (!ecryptfs_tfm_exists(mount_crypt_stat->global_default_cipher_name,
+				 NULL))
+		rc = ecryptfs_add_new_key_tfm(
+			NULL, mount_crypt_stat->global_default_cipher_name,
+			mount_crypt_stat->global_default_cipher_key_size);
+	mutex_unlock(&key_tfm_list_mutex);
 	if (rc) {
 		printk(KERN_ERR "Error attempting to initialize cipher with "
 		       "name = [%s] and key size = [%td]; rc = [%d]\n",
_

Patches currently in -mm which might be from sandeen@redhat.com are

hfs-handle-more-on-disk-corruptions-without-oopsing.patch
hfs-handle-more-on-disk-corruptions-without-oopsing-fix.patch
git-kbuild.patch
ext2-change-the-default-behaviour-on-error.patch
export-iov_shorten-for-ext4s-use.patch
export-iov_shorten-for-ext4s-use-fix.patch
ecryptfs-make-show_options-reflect-actual-mount-options.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
ecryptfs-remove-debug-as-mount-option-and-warn-if-set-via-modprobe.patch
ecryptfs-check-for-existing-key_tfm-at-mount-time.patch
ext4-mm-ext4_store_maxbytes_for_bitmaped_files-warning-fix.patch
ext3-change-the-default-behaviour-on-error.patch
