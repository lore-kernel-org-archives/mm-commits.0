From: akpm@linux-foundation.org
Subject: - ecryptfs-clean-up-ecryptfs_decode_from_filename.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:18:35 -0800
Message-ID: <200901072218.n07MIZft018046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46272 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762033AbZAGWTk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:19:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, dustin.kirkland@gmail.com, sandeen@redhat.com, shaggy@us.ibm.com, tchicks@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: Clean up ecryptfs_decode_from_filename()
has been removed from the -mm tree.  Its filename was
     ecryptfs-clean-up-ecryptfs_decode_from_filename.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptfs: Clean up ecryptfs_decode_from_filename()
From: Michael Halcrow <mhalcrow@us.ibm.com>

Flesh out the comments for ecryptfs_decode_from_filename(). Remove the
return condition, since it is always 0.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Dustin Kirkland <dustin.kirkland@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Tyler Hicks <tchicks@us.ibm.com>
Cc: David Kleikamp <shaggy@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c |   51 +++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-clean-up-ecryptfs_decode_from_filename fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-clean-up-ecryptfs_decode_from_filename
+++ a/fs/ecryptfs/crypto.c
@@ -1931,7 +1931,7 @@ static unsigned char *portable_filename_
 
 /* We could either offset on every reverse map or just pad some 0x00's
  * at the front here */
-static unsigned char filename_rev_map[] = {
+static const unsigned char filename_rev_map[] = {
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 7 */
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 15 */
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 23 */
@@ -2012,16 +2012,30 @@ out:
 	return;
 }
 
-int ecryptfs_decode_from_filename(unsigned char *dst, size_t *dst_size,
-				  const unsigned char *src, size_t src_size)
+/**
+ * ecryptfs_decode_from_filename
+ * @dst: If NULL, this function only sets @dst_size and returns. If
+ *       non-NULL, this function decodes the encoded octets in @src
+ *       into the memory that @dst points to.
+ * @dst_size: Set to the size of the decoded string.
+ * @src: The encoded set of octets to decode.
+ * @src_size: The size of the encoded set of octets to decode.
+ */
+static void
+ecryptfs_decode_from_filename(unsigned char *dst, size_t *dst_size,
+			      const unsigned char *src, size_t src_size)
 {
 	u8 current_bit_offset = 0;
 	size_t src_byte_offset = 0;
 	size_t dst_byte_offset = 0;
-	int rc = 0;
 
 	if (dst == NULL) {
-		/* Not exact; conservatively long */
+		/* Not exact; conservatively long. Every block of 4
+		 * encoded characters decodes into a block of 3
+		 * decoded characters. This segment of code provides
+		 * the caller with the maximum amount of allocated
+		 * space that @dst will need to point to in a
+		 * subsequent call. */
 		(*dst_size) = (((src_size + 1) * 3) / 4);
 		goto out;
 	}
@@ -2055,7 +2069,7 @@ int ecryptfs_decode_from_filename(unsign
 	}
 	(*dst_size) = dst_byte_offset;
 out:
-	return rc;
+	return;
 }
 
 /**
@@ -2208,16 +2222,8 @@ int ecryptfs_decode_and_decrypt_filename
 
 		name += ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE;
 		name_size -= ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE;
-		rc = ecryptfs_decode_from_filename(NULL, &decoded_name_size,
-						   name, name_size);
-		if (rc) {
-			printk(KERN_ERR "%s: Error attempting to decode "
-			       "filename; rc = [%d]\n", __func__, rc);
-			rc = ecryptfs_copy_filename(plaintext_name,
-						    plaintext_name_size,
-						    orig_name, orig_name_size);
-			goto out;
-		}
+		ecryptfs_decode_from_filename(NULL, &decoded_name_size,
+					      name, name_size);
 		decoded_name = kmalloc(decoded_name_size, GFP_KERNEL);
 		if (!decoded_name) {
 			printk(KERN_ERR "%s: Out of memory whilst attempting "
@@ -2226,17 +2232,8 @@ int ecryptfs_decode_and_decrypt_filename
 			rc = -ENOMEM;
 			goto out;
 		}
-		rc = ecryptfs_decode_from_filename(decoded_name,
-						   &decoded_name_size,
-						   name, name_size);
-		if (rc) {
-			printk(KERN_ERR "%s: Error attempting to decode "
-			       "filename; rc = [%d]\n", __func__, rc);
-			rc = ecryptfs_copy_filename(plaintext_name,
-						    plaintext_name_size,
-						    orig_name, orig_name_size);
-			goto out_free;
-		}
+		ecryptfs_decode_from_filename(decoded_name, &decoded_name_size,
+					      name, name_size);
 		rc = ecryptfs_parse_tag_70_packet(plaintext_name,
 						  plaintext_name_size,
 						  &packet_size,
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
notify_change-callers-must-hold-i_mutex.patch

