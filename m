From: akpm@linux-foundation.org
Subject: - ecryptfs-fix-unlocking-in-error-paths.patch removed from -mm tree
Date: Mon, 07 Jan 2008 13:39:10 -0800
Message-ID: <200801072138.m07Lco5g013505@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36725 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753223AbYAGVjd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 16:39:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, jbacik@redhat.com, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: fix unlocking in error paths
has been removed from the -mm tree.  Its filename was
     ecryptfs-fix-unlocking-in-error-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ecryptfs: fix unlocking in error paths
From: Eric Sandeen <sandeen@redhat.com>

Thanks to Josef Bacik for finding these.

A couple of ecryptfs error paths don't properly unlock things they locked.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Josef Bacik <jbacik@redhat.com>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c    |    8 ++++----
 fs/ecryptfs/messaging.c |    1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-fix-unlocking-in-error-paths fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-fix-unlocking-in-error-paths
+++ a/fs/ecryptfs/crypto.c
@@ -799,7 +799,7 @@ int ecryptfs_init_crypt_ctx(struct ecryp
 	rc = ecryptfs_crypto_api_algify_cipher_name(&full_alg_name,
 						    crypt_stat->cipher, "cbc");
 	if (rc)
-		goto out;
+		goto out_unlock;
 	crypt_stat->tfm = crypto_alloc_blkcipher(full_alg_name, 0,
 						 CRYPTO_ALG_ASYNC);
 	kfree(full_alg_name);
@@ -808,12 +808,12 @@ int ecryptfs_init_crypt_ctx(struct ecryp
 		ecryptfs_printk(KERN_ERR, "cryptfs: init_crypt_ctx(): "
 				"Error initializing cipher [%s]\n",
 				crypt_stat->cipher);
-		mutex_unlock(&crypt_stat->cs_tfm_mutex);
-		goto out;
+		goto out_unlock;
 	}
 	crypto_blkcipher_set_flags(crypt_stat->tfm, CRYPTO_TFM_REQ_WEAK_KEY);
-	mutex_unlock(&crypt_stat->cs_tfm_mutex);
 	rc = 0;
+out_unlock:
+	mutex_unlock(&crypt_stat->cs_tfm_mutex);
 out:
 	return rc;
 }
diff -puN fs/ecryptfs/messaging.c~ecryptfs-fix-unlocking-in-error-paths fs/ecryptfs/messaging.c
--- a/fs/ecryptfs/messaging.c~ecryptfs-fix-unlocking-in-error-paths
+++ a/fs/ecryptfs/messaging.c
@@ -427,6 +427,7 @@ int ecryptfs_init_messaging(unsigned int
 	if (!ecryptfs_daemon_id_hash) {
 		rc = -ENOMEM;
 		ecryptfs_printk(KERN_ERR, "Failed to allocate memory\n");
+		mutex_unlock(&ecryptfs_daemon_id_hash_mux);
 		goto out;
 	}
 	for (i = 0; i < ecryptfs_hash_buckets; i++)
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
ext4-mm-ext4_store_maxbytes_for_bitmaped_files-warning-fix.patch
ext3-change-the-default-behaviour-on-error.patch
