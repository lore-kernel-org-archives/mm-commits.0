From: akpm@linux-foundation.org
Subject: - ecryptfs-allocate-up-to-two-scatterlists-for-crypto-ops-on-keys.patch removed from -mm tree
Date: Thu, 20 Nov 2008 12:42:49 -0800
Message-ID: <200811202042.mAKKgnnY007144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755323AbYKTUnl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 15:43:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, leon.woestenberg@gmail.com, pjssilva@ime.usp.br, stable@kernel.org, tim.gardner@canonical.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: Allocate up to two scatterlists for crypto ops on keys
has been removed from the -mm tree.  Its filename was
     ecryptfs-allocate-up-to-two-scatterlists-for-crypto-ops-on-keys.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptfs: Allocate up to two scatterlists for crypto ops on keys
From: Michael Halcrow <mhalcrow@us.ibm.com>

I have received some reports of out-of-memory errors on some older AMD
architectures.  These errors are what I would expect to see if
crypt_stat->key were split between two separate pages.  eCryptfs should
not assume that any of the memory sent through virt_to_scatterlist() is
all contained in a single page, and so this patch allocates two
scatterlist structs instead of one when processing keys.  I have received
confirmation from one person affected by this bug that this patch resolves
the issue for him, and so I am submitting it for inclusion in a future
stable release.

Note that virt_to_scatterlist() runs sg_init_table() on the scatterlist
structs passed to it, so the calls to sg_init_table() in
decrypt_passphrase_encrypted_session_key() are redundant.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Reported-by: Paulo J. S. Silva <pjssilva@ime.usp.br>
Cc: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Cc: Tim Gardner <tim.gardner@canonical.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/keystore.c |   31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff -puN fs/ecryptfs/keystore.c~ecryptfs-allocate-up-to-two-scatterlists-for-crypto-ops-on-keys fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-allocate-up-to-two-scatterlists-for-crypto-ops-on-keys
+++ a/fs/ecryptfs/keystore.c
@@ -1037,17 +1037,14 @@ static int
 decrypt_passphrase_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
 					 struct ecryptfs_crypt_stat *crypt_stat)
 {
-	struct scatterlist dst_sg;
-	struct scatterlist src_sg;
+	struct scatterlist dst_sg[2];
+	struct scatterlist src_sg[2];
 	struct mutex *tfm_mutex;
 	struct blkcipher_desc desc = {
 		.flags = CRYPTO_TFM_REQ_MAY_SLEEP
 	};
 	int rc = 0;
 
-	sg_init_table(&dst_sg, 1);
-	sg_init_table(&src_sg, 1);
-
 	if (unlikely(ecryptfs_verbosity > 0)) {
 		ecryptfs_printk(
 			KERN_DEBUG, "Session key encryption key (size [%d]):\n",
@@ -1066,8 +1063,8 @@ decrypt_passphrase_encrypted_session_key
 	}
 	rc = virt_to_scatterlist(auth_tok->session_key.encrypted_key,
 				 auth_tok->session_key.encrypted_key_size,
-				 &src_sg, 1);
-	if (rc != 1) {
+				 src_sg, 2);
+	if (rc < 1 || rc > 2) {
 		printk(KERN_ERR "Internal error whilst attempting to convert "
 			"auth_tok->session_key.encrypted_key to scatterlist; "
 			"expected rc = 1; got rc = [%d]. "
@@ -1079,8 +1076,8 @@ decrypt_passphrase_encrypted_session_key
 		auth_tok->session_key.encrypted_key_size;
 	rc = virt_to_scatterlist(auth_tok->session_key.decrypted_key,
 				 auth_tok->session_key.decrypted_key_size,
-				 &dst_sg, 1);
-	if (rc != 1) {
+				 dst_sg, 2);
+	if (rc < 1 || rc > 2) {
 		printk(KERN_ERR "Internal error whilst attempting to convert "
 			"auth_tok->session_key.decrypted_key to scatterlist; "
 			"expected rc = 1; got rc = [%d]\n", rc);
@@ -1096,7 +1093,7 @@ decrypt_passphrase_encrypted_session_key
 		rc = -EINVAL;
 		goto out;
 	}
-	rc = crypto_blkcipher_decrypt(&desc, &dst_sg, &src_sg,
+	rc = crypto_blkcipher_decrypt(&desc, dst_sg, src_sg,
 				      auth_tok->session_key.encrypted_key_size);
 	mutex_unlock(tfm_mutex);
 	if (unlikely(rc)) {
@@ -1539,8 +1536,8 @@ write_tag_3_packet(char *dest, size_t *r
 	size_t i;
 	size_t encrypted_session_key_valid = 0;
 	char session_key_encryption_key[ECRYPTFS_MAX_KEY_BYTES];
-	struct scatterlist dst_sg;
-	struct scatterlist src_sg;
+	struct scatterlist dst_sg[2];
+	struct scatterlist src_sg[2];
 	struct mutex *tfm_mutex = NULL;
 	u8 cipher_code;
 	size_t packet_size_length;
@@ -1619,8 +1616,8 @@ write_tag_3_packet(char *dest, size_t *r
 		ecryptfs_dump_hex(session_key_encryption_key, 16);
 	}
 	rc = virt_to_scatterlist(crypt_stat->key, key_rec->enc_key_size,
-				 &src_sg, 1);
-	if (rc != 1) {
+				 src_sg, 2);
+	if (rc < 1 || rc > 2) {
 		ecryptfs_printk(KERN_ERR, "Error generating scatterlist "
 				"for crypt_stat session key; expected rc = 1; "
 				"got rc = [%d]. key_rec->enc_key_size = [%d]\n",
@@ -1629,8 +1626,8 @@ write_tag_3_packet(char *dest, size_t *r
 		goto out;
 	}
 	rc = virt_to_scatterlist(key_rec->enc_key, key_rec->enc_key_size,
-				 &dst_sg, 1);
-	if (rc != 1) {
+				 dst_sg, 2);
+	if (rc < 1 || rc > 2) {
 		ecryptfs_printk(KERN_ERR, "Error generating scatterlist "
 				"for crypt_stat encrypted session key; "
 				"expected rc = 1; got rc = [%d]. "
@@ -1651,7 +1648,7 @@ write_tag_3_packet(char *dest, size_t *r
 	rc = 0;
 	ecryptfs_printk(KERN_DEBUG, "Encrypting [%d] bytes of the key\n",
 			crypt_stat->key_size);
-	rc = crypto_blkcipher_encrypt(&desc, &dst_sg, &src_sg,
+	rc = crypto_blkcipher_encrypt(&desc, dst_sg, src_sg,
 				      (*key_rec).enc_key_size);
 	mutex_unlock(tfm_mutex);
 	if (rc) {
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
linux-next.patch
ecryptfs-filename-encryption-tag-70-packets.patch
ecryptfs-filename-encryption-header-updates.patch
ecryptfs-filename-encryption-encoding-and-encryption-functions.patch
ecryptfs-filename-encryption-filldir-lookup-and-readlink.patch
ecryptfs-filename-encryption-mount-option.patch
ecryptfs-replace-%z-with-%z.patch
ecryptfs-fix-data-types-int-size_t.patch
ecryptfs-kerneldoc-for-ecryptfs_parse_tag_70_packet.patch
ecryptfs-clean-up-ecryptfs_decode_from_filename.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
notify_change-callers-must-hold-i_mutex.patch

