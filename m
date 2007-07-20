From: akpm@linux-foundation.org
Subject: + ecryptfs-fix-tag-3-parsing-code.patch added to -mm tree
Date: Fri, 20 Jul 2007 15:27:04 -0700
Message-ID: <200707202227.l6KMR4fm019749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49666 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762718AbXGTW1N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 18:27:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: fix Tag 3 parsing code
has been added to the -mm tree.  Its filename is
     ecryptfs-fix-tag-3-parsing-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: fix Tag 3 parsing code
From: Michael Halcrow <mhalcrow@us.ibm.com>

Fix up the Tag 3 parsing code to handle size limits and boundaries more
explicitly.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/keystore.c |   89 +++++++++++++++------------------------
 1 files changed, 35 insertions(+), 54 deletions(-)

diff -puN fs/ecryptfs/keystore.c~ecryptfs-fix-tag-3-parsing-code fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-fix-tag-3-parsing-code
+++ a/fs/ecryptfs/keystore.c
@@ -643,22 +643,30 @@ parse_tag_3_packet(struct ecryptfs_crypt
 
 	(*packet_size) = 0;
 	(*new_auth_tok) = NULL;
-
-	/* we check that:
-	 *   one byte for the Tag 3 ID flag
-	 *   two bytes for the body size
-	 * do not exceed the maximum_packet_size
+	/**
+	 *This format is inspired by OpenPGP; see RFC 2440
+	 * packet tag 3
+	 *
+	 * Tag 3 identifier (1 byte)
+	 * Max Tag 3 packet size (max 3 bytes)
+	 * Version (1 byte)
+	 * Cipher code (1 byte)
+	 * S2K specifier (1 byte)
+	 * Hash identifier (1 byte)
+	 * Salt (ECRYPTFS_SALT_SIZE)
+	 * Hash iterations (1 byte)
+	 * Encrypted key (arbitrary)
+	 *
+	 * (ECRYPTFS_SALT_SIZE + 7) minimum packet size
 	 */
-	if (unlikely((*packet_size) + 3 > max_packet_size)) {
-		ecryptfs_printk(KERN_ERR, "Packet size exceeds max\n");
+	if (max_packet_size < (ECRYPTFS_SALT_SIZE + 7)) {
+		printk(KERN_ERR "Max packet size too large\n");
 		rc = -EINVAL;
 		goto out;
 	}
-
-	/* check for Tag 3 identifyer - one byte */
 	if (data[(*packet_size)++] != ECRYPTFS_TAG_3_PACKET_TYPE) {
-		ecryptfs_printk(KERN_ERR, "Enter w/ first byte != 0x%.2x\n",
-				ECRYPTFS_TAG_3_PACKET_TYPE);
+		printk(KERN_ERR "First byte != 0x%.2x; invalid packet\n",
+		       ECRYPTFS_TAG_3_PACKET_TYPE);
 		rc = -EINVAL;
 		goto out;
 	}
@@ -667,56 +675,36 @@ parse_tag_3_packet(struct ecryptfs_crypt
 	auth_tok_list_item =
 	    kmem_cache_zalloc(ecryptfs_auth_tok_list_item_cache, GFP_KERNEL);
 	if (!auth_tok_list_item) {
-		ecryptfs_printk(KERN_ERR, "Unable to allocate memory\n");
+		printk(KERN_ERR "Unable to allocate memory\n");
 		rc = -ENOMEM;
 		goto out;
 	}
 	(*new_auth_tok) = &auth_tok_list_item->auth_tok;
-
-	/* check for body size - one to two bytes */
-	rc = parse_packet_length(&data[(*packet_size)], &body_size,
-				 &length_size);
-	if (rc) {
-		ecryptfs_printk(KERN_WARNING, "Error parsing packet length; "
-				"rc = [%d]\n", rc);
+	if ((rc = parse_packet_length(&data[(*packet_size)], &body_size,
+				      &length_size))) {
+		printk(KERN_WARNING "Error parsing packet length; rc = [%d]\n",
+		       rc);
 		goto out_free;
 	}
-	if (unlikely(body_size < (0x05 + ECRYPTFS_SALT_SIZE))) {
-		ecryptfs_printk(KERN_WARNING, "Invalid body size ([%d])\n",
-				body_size);
+	if (unlikely(body_size < (ECRYPTFS_SALT_SIZE + 5))) {
+		printk(KERN_WARNING "Invalid body size ([%d])\n", body_size);
 		rc = -EINVAL;
 		goto out_free;
 	}
 	(*packet_size) += length_size;
-
-	/* now we know the length of the remainting Tag 3 packet size:
-	 *   5 fix bytes for: version string, cipher, S2K ID, hash algo,
-	 *                    number of hash iterations
-	 *   ECRYPTFS_SALT_SIZE bytes for salt
-	 *   body_size bytes minus the stuff above is the encrypted key size
-	 */
 	if (unlikely((*packet_size) + body_size > max_packet_size)) {
-		ecryptfs_printk(KERN_ERR, "Packet size exceeds max\n");
+		printk(KERN_ERR "Packet size exceeds max\n");
 		rc = -EINVAL;
 		goto out_free;
 	}
-
-	/* There are 5 characters of additional information in the
-	 * packet */
 	(*new_auth_tok)->session_key.encrypted_key_size =
-		body_size - (0x05 + ECRYPTFS_SALT_SIZE);
-	ecryptfs_printk(KERN_DEBUG, "Encrypted key size = [%d]\n",
-			(*new_auth_tok)->session_key.encrypted_key_size);
-
-	/* Version 4 (from RFC2440) - one byte */
+		(body_size - (ECRYPTFS_SALT_SIZE + 5));
 	if (unlikely(data[(*packet_size)++] != 0x04)) {
-		ecryptfs_printk(KERN_DEBUG, "Unknown version number "
-				"[%d]\n", data[(*packet_size) - 1]);
+		printk(KERN_WARNING "Unknown version number [%d]\n",
+		       data[(*packet_size) - 1]);
 		rc = -EINVAL;
 		goto out_free;
 	}
-
-	/* cipher - one byte */
 	ecryptfs_cipher_code_to_string(crypt_stat->cipher,
 				       (u16)data[(*packet_size)]);
 	/* A little extra work to differentiate among the AES key
@@ -730,33 +718,26 @@ parse_tag_3_packet(struct ecryptfs_crypt
 			(*new_auth_tok)->session_key.encrypted_key_size;
 	}
 	ecryptfs_init_crypt_ctx(crypt_stat);
-	/* S2K identifier 3 (from RFC2440) */
 	if (unlikely(data[(*packet_size)++] != 0x03)) {
-		ecryptfs_printk(KERN_ERR, "Only S2K ID 3 is currently "
-				"supported\n");
+		printk(KERN_WARNING "Only S2K ID 3 is currently supported\n");
 		rc = -ENOSYS;
 		goto out_free;
 	}
-
 	/* TODO: finish the hash mapping */
-	/* hash algorithm - one byte */
 	switch (data[(*packet_size)++]) {
 	case 0x01: /* See RFC2440 for these numbers and their mappings */
 		/* Choose MD5 */
-		/* salt - ECRYPTFS_SALT_SIZE bytes */
 		memcpy((*new_auth_tok)->token.password.salt,
 		       &data[(*packet_size)], ECRYPTFS_SALT_SIZE);
 		(*packet_size) += ECRYPTFS_SALT_SIZE;
-
 		/* This conversion was taken straight from RFC2440 */
-		/* number of hash iterations - one byte */
 		(*new_auth_tok)->token.password.hash_iterations =
 			((u32) 16 + (data[(*packet_size)] & 15))
 				<< ((data[(*packet_size)] >> 4) + 6);
 		(*packet_size)++;
-
-		/* encrypted session key -
-		 *   (body_size-5-ECRYPTFS_SALT_SIZE) bytes */
+		/* Friendly reminder:
+		 * (*new_auth_tok)->session_key.encrypted_key_size =
+		 *         (body_size - (ECRYPTFS_SALT_SIZE + 5)); */
 		memcpy((*new_auth_tok)->session_key.encrypted_key,
 		       &data[(*packet_size)],
 		       (*new_auth_tok)->session_key.encrypted_key_size);
@@ -766,7 +747,7 @@ parse_tag_3_packet(struct ecryptfs_crypt
 			~ECRYPTFS_CONTAINS_DECRYPTED_KEY;
 		(*new_auth_tok)->session_key.flags |=
 			ECRYPTFS_CONTAINS_ENCRYPTED_KEY;
-		(*new_auth_tok)->token.password.hash_algo = 0x01;
+		(*new_auth_tok)->token.password.hash_algo = 0x01; /* MD5 */
 		break;
 	default:
 		ecryptfs_printk(KERN_ERR, "Unsupported hash algorithm: "
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
fs-remove-some-aop_truncated_page.patch
fs-remove-some-aop_truncated_page-fix.patch
ecryptfs-add-key-list-structure-search-keyring.patch
ecryptfs-use-list_for_each_entry_safe-when-wiping-auth-toks.patch
ecryptfs-kmem_cache-objects-for-multiple-keys-init-exit-functions.patch
ecryptfs-fix-tag-1-parsing-code.patch
ecryptfs-fix-tag-3-parsing-code.patch
ecryptfs-fix-tag-11-parsing-code.patch
ecryptfs-fix-tag-11-writing-code.patch
ecryptfs-update-comment-and-debug-statement.patch
