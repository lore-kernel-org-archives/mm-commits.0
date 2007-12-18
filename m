From: akpm@linux-foundation.org
Subject: + ecryptfs-fix-unlocking-in-error-paths.patch added to -mm tree
Date: Tue, 18 Dec 2007 13:01:55 -0800
Message-ID: <200712182101.lBIL1tba021495@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58551 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752675AbXLRVCo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 16:02:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com, jbacik@redhat.com, mhalcrow@us.ibm.com


The patch titled
     ecryptfs: fix unlocking in error paths
has been added to the -mm tree.  Its filename is
     ecryptfs-fix-unlocking-in-error-paths.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ecryptfs-initialize-new-auth_tokens-before-teardown.patch
ecryptfs-set-s_blocksize-from-lower-fs-in-sb.patch
ecryptfs-fix-fsx-data-corruption-problems.patch
ecryptfs-fix-string-overflow-on-long-cipher-names.patch
ecryptfs-fix-unlocking-in-error-paths.patch
ext2-change-the-default-behaviour-on-error.patch
ecryptfs-make-show_options-reflect-actual-mount-options.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
ext4-fix-mb_debug-format-warnings.patch
ext4-fix-freespace-accounting-with-mballoc-on-32bit-machines.patch
ext4-fix-oops-with-jbd-stats-through-procfs-and-external.patch
ext4-fix-up-ext4fs_debug-builds.patch
ext3-change-the-default-behaviour-on-error.patch
