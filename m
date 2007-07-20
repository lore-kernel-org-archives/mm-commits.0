From: akpm@linux-foundation.org
Subject: + ecryptfs-fix-tag-1-parsing-code.patch added to -mm tree
Date: Fri, 20 Jul 2007 15:27:02 -0700
Message-ID: <200707202227.l6KMR2Bt019746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41513 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763552AbXGTW1Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 18:27:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com, jsipek@fsl.cs.sunysb.edu


The patch titled
     eCryptfs: fix Tag 1 parsing code
has been added to the -mm tree.  Its filename is
     ecryptfs-fix-tag-1-parsing-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: fix Tag 1 parsing code
From: Michael Halcrow <mhalcrow@us.ibm.com>

Fix up the Tag 1 parsing code to handle size limits and boundaries more
explicitly.  Initialize the new auth_tok's flags.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/keystore.c |   78 ++++++++++++++++-----------------------
 1 files changed, 33 insertions(+), 45 deletions(-)

diff -puN fs/ecryptfs/keystore.c~ecryptfs-fix-tag-1-parsing-code fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-fix-tag-1-parsing-code
+++ a/fs/ecryptfs/keystore.c
@@ -512,72 +512,64 @@ parse_tag_1_packet(struct ecryptfs_crypt
 
 	(*packet_size) = 0;
 	(*new_auth_tok) = NULL;
-
-	/* we check that:
-	 *   one byte for the Tag 1 ID flag
-	 *   two bytes for the body size
-	 * do not exceed the maximum_packet_size
+	/**
+	 * This format is inspired by OpenPGP; see RFC 2440
+	 * packet tag 1
+	 *
+	 * Tag 1 identifier (1 byte)
+	 * Max Tag 1 packet size (max 3 bytes)
+	 * Version (1 byte)
+	 * Key identifier (8 bytes; ECRYPTFS_SIG_SIZE)
+	 * Cipher identifier (1 byte)
+	 * Encrypted key size (arbitrary)
+	 *
+	 * 12 bytes minimum packet size
 	 */
-	if (unlikely((*packet_size) + 3 > max_packet_size)) {
-		ecryptfs_printk(KERN_ERR, "Packet size exceeds max\n");
+	if (unlikely(max_packet_size < 12)) {
+		printk(KERN_ERR "Invalid max packet size; must be >=12\n");
 		rc = -EINVAL;
 		goto out;
 	}
-	/* check for Tag 1 identifier - one byte */
 	if (data[(*packet_size)++] != ECRYPTFS_TAG_1_PACKET_TYPE) {
-		ecryptfs_printk(KERN_ERR, "Enter w/ first byte != 0x%.2x\n",
-				ECRYPTFS_TAG_1_PACKET_TYPE);
+		printk(KERN_ERR "Enter w/ first byte != 0x%.2x\n",
+		       ECRYPTFS_TAG_1_PACKET_TYPE);
 		rc = -EINVAL;
 		goto out;
 	}
 	/* Released: wipe_auth_tok_list called in ecryptfs_parse_packet_set or
 	 * at end of function upon failure */
 	auth_tok_list_item =
-		kmem_cache_alloc(ecryptfs_auth_tok_list_item_cache,
-				 GFP_KERNEL);
+		kmem_cache_zalloc(ecryptfs_auth_tok_list_item_cache,
+				  GFP_KERNEL);
 	if (!auth_tok_list_item) {
-		ecryptfs_printk(KERN_ERR, "Unable to allocate memory\n");
+		printk(KERN_ERR "Unable to allocate memory\n");
 		rc = -ENOMEM;
 		goto out;
 	}
-	memset(auth_tok_list_item, 0,
-	       sizeof(struct ecryptfs_auth_tok_list_item));
 	(*new_auth_tok) = &auth_tok_list_item->auth_tok;
-	/* check for body size - one to two bytes
-	 *
-	 *              ***** TAG 1 Packet Format *****
-	 *    | version number                     | 1 byte       |
-	 *    | key ID                             | 8 bytes      |
-	 *    | public key algorithm               | 1 byte       |
-	 *    | encrypted session key              | arbitrary    |
-	 */
-	rc = parse_packet_length(&data[(*packet_size)], &body_size,
-				 &length_size);
-	if (rc) {
-		ecryptfs_printk(KERN_WARNING, "Error parsing packet length; "
-				"rc = [%d]\n", rc);
+	if ((rc = parse_packet_length(&data[(*packet_size)], &body_size,
+				      &length_size))) {
+		printk(KERN_WARNING "Error parsing packet length; "
+		       "rc = [%d]\n", rc);
 		goto out_free;
 	}
-	if (unlikely(body_size < (0x02 + ECRYPTFS_SIG_SIZE))) {
-		ecryptfs_printk(KERN_WARNING, "Invalid body size ([%d])\n",
-				body_size);
+	if (unlikely(body_size < (ECRYPTFS_SIG_SIZE + 2))) {
+		printk(KERN_WARNING "Invalid body size ([%d])\n", body_size);
 		rc = -EINVAL;
 		goto out_free;
 	}
 	(*packet_size) += length_size;
 	if (unlikely((*packet_size) + body_size > max_packet_size)) {
-		ecryptfs_printk(KERN_ERR, "Packet size exceeds max\n");
+		printk(KERN_WARNING "Packet size exceeds max\n");
 		rc = -EINVAL;
 		goto out_free;
 	}
-	/* Version 3 (from RFC2440) - one byte */
 	if (unlikely(data[(*packet_size)++] != 0x03)) {
-		ecryptfs_printk(KERN_DEBUG, "Unknown version number "
-				"[%d]\n", data[(*packet_size) - 1]);
+		printk(KERN_WARNING "Unknown version number [%d]\n",
+		       data[(*packet_size) - 1]);
 		rc = -EINVAL;
 		goto out_free;
 	}
-	/* Read Signature */
 	ecryptfs_to_hex((*new_auth_tok)->token.private_key.signature,
 			&data[(*packet_size)], ECRYPTFS_SIG_SIZE);
 	*packet_size += ECRYPTFS_SIG_SIZE;
@@ -585,27 +577,23 @@ parse_tag_1_packet(struct ecryptfs_crypt
 	 * know which public key encryption algorithm was used */
 	(*packet_size)++;
 	(*new_auth_tok)->session_key.encrypted_key_size =
-		body_size - (0x02 + ECRYPTFS_SIG_SIZE);
+		body_size - (ECRYPTFS_SIG_SIZE + 2);
 	if ((*new_auth_tok)->session_key.encrypted_key_size
 	    > ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES) {
-		ecryptfs_printk(KERN_ERR, "Tag 1 packet contains key larger "
-				"than ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES");
+		printk(KERN_WARNING "Tag 1 packet contains key larger "
+		       "than ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES");
 		rc = -EINVAL;
 		goto out;
 	}
-	ecryptfs_printk(KERN_DEBUG, "Encrypted key size = [%d]\n",
-			(*new_auth_tok)->session_key.encrypted_key_size);
 	memcpy((*new_auth_tok)->session_key.encrypted_key,
-	       &data[(*packet_size)], (body_size - 0x02 - ECRYPTFS_SIG_SIZE));
+	       &data[(*packet_size)], (body_size - (ECRYPTFS_SIG_SIZE + 2)));
 	(*packet_size) += (*new_auth_tok)->session_key.encrypted_key_size;
 	(*new_auth_tok)->session_key.flags &=
 		~ECRYPTFS_CONTAINS_DECRYPTED_KEY;
 	(*new_auth_tok)->session_key.flags |=
 		ECRYPTFS_CONTAINS_ENCRYPTED_KEY;
 	(*new_auth_tok)->token_type = ECRYPTFS_PRIVATE_KEY;
-	(*new_auth_tok)->flags |= ECRYPTFS_PRIVATE_KEY;
-	/* TODO: Why are we setting this flag here? Don't we want the
-	 * userspace to decrypt the session key? */
+	(*new_auth_tok)->flags = 0;
 	(*new_auth_tok)->session_key.flags &=
 		~(ECRYPTFS_USERSPACE_SHOULD_TRY_TO_DECRYPT);
 	(*new_auth_tok)->session_key.flags &=
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
