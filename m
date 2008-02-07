From: akpm@linux-foundation.org
Subject: - ecryptfs-set-inode-key-only-once-per-crypto-operation.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:26:44 -0800
Message-ID: <200802070026.m170QPDY006916@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37566 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760589AbYBGAoy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: trevor.highland@gmail.com, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: set inode key only once per crypto operation
has been removed from the -mm tree.  Its filename was
     ecryptfs-set-inode-key-only-once-per-crypto-operation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptfs: set inode key only once per crypto operation
From: Trevor Highland <trevor.highland@gmail.com>

There is no need to keep re-setting the same key for any given eCryptfs inode.
This patch optimizes the use of the crypto API and helps performance a bit.

Signed-off-by: Trevor Highland <trevor.highland@gmail.com>
Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c          |    7 +++++--
 fs/ecryptfs/ecryptfs_kernel.h |    1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-set-inode-key-only-once-per-crypto-operation fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-set-inode-key-only-once-per-crypto-operation
+++ a/fs/ecryptfs/crypto.c
@@ -355,8 +355,11 @@ static int encrypt_scatterlist(struct ec
 	}
 	/* Consider doing this once, when the file is opened */
 	mutex_lock(&crypt_stat->cs_tfm_mutex);
-	rc = crypto_blkcipher_setkey(crypt_stat->tfm, crypt_stat->key,
-				     crypt_stat->key_size);
+	if (!(crypt_stat->flags & ECRYPTFS_KEY_SET)) {
+		rc = crypto_blkcipher_setkey(crypt_stat->tfm, crypt_stat->key,
+					     crypt_stat->key_size);
+		crypt_stat->flags |= ECRYPTFS_KEY_SET;
+	}
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Error setting key; rc = [%d]\n",
 				rc);
diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-set-inode-key-only-once-per-crypto-operation fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-set-inode-key-only-once-per-crypto-operation
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -234,6 +234,7 @@ struct ecryptfs_crypt_stat {
 #define ECRYPTFS_KEY_VALID          0x00000080
 #define ECRYPTFS_METADATA_IN_XATTR  0x00000100
 #define ECRYPTFS_VIEW_AS_ENCRYPTED  0x00000200
+#define ECRYPTFS_KEY_SET            0x00000400
 	u32 flags;
 	unsigned int file_version;
 	size_t iv_bytes;
_

Patches currently in -mm which might be from trevor.highland@gmail.com are

origin.patch
