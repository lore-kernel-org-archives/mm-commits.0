From: akpm@linux-foundation.org
Subject: + ecryptfs-load-each-file-decryption-key-only-once.patch added to -mm tree
Date: Sat, 22 Dec 2007 00:39:29 -0800
Message-ID: <200712220839.lBM8dT21024994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33291 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751933AbXLVIji (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 03:39:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thighlan@gmail.com, mhalcrow@us.ibm.com, trevor.highland@gmail.com


The patch titled
     eCryptfs: load each file decryption key only once
has been added to the -mm tree.  Its filename is
     ecryptfs-load-each-file-decryption-key-only-once.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptfs: load each file decryption key only once
From: Trevor Highland <thighlan@gmail.com>

There is no need to keep re-setting the same key for any given eCryptfs inode.
 This patch optimizes the use of the crypto API and helps performance a bit.

Signed-off-by: Trevor Highland <trevor.highland@gmail.com>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-load-each-file-decryption-key-only-once fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-load-each-file-decryption-key-only-once
+++ a/fs/ecryptfs/crypto.c
@@ -353,7 +353,6 @@ static int encrypt_scatterlist(struct ec
 		ecryptfs_dump_hex(crypt_stat->key,
 				  crypt_stat->key_size);
 	}
-	/* Consider doing this once, when the file is opened */
 	mutex_lock(&crypt_stat->cs_tfm_mutex);
 	if (!(crypt_stat->flags & ECRYPTFS_KEY_SET)) {
 		rc = crypto_blkcipher_setkey(crypt_stat->tfm, crypt_stat->key,
@@ -687,10 +686,12 @@ static int decrypt_scatterlist(struct ec
 	};
 	int rc = 0;
 
-	/* Consider doing this once, when the file is opened */
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
_

Patches currently in -mm which might be from thighlan@gmail.com are

ecryptfs-change-the-type-of-cipher_code-from-u16-to-u8.patch
ecryptfs-load-each-file-decryption-key-only-once.patch
