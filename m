From: akpm@linux-foundation.org
Subject: + ecryptfs-replace-%z-with-%z.patch added to -mm tree
Date: Wed, 12 Nov 2008 11:46:06 -0800
Message-ID: <200811121946.mACJk6Av008758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752766AbYKLTqz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 14:46:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com, dustin.kirkland@gmail.com, sandeen@redhat.com, shaggy@us.ibm.com, tchicks@us.ibm.com


The patch titled
     eCryptfs: Replace %Z with %z
has been added to the -mm tree.  Its filename is
     ecryptfs-replace-%z-with-%z.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptfs: Replace %Z with %z
From: Michael Halcrow <mhalcrow@us.ibm.com>

%Z is a gcc-ism. Using %z instead.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Dustin Kirkland <dustin.kirkland@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Tyler Hicks <tchicks@us.ibm.com>
Cc: David Kleikamp <shaggy@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c    |    8 ++++----
 fs/ecryptfs/keystore.c  |   18 +++++++++---------
 fs/ecryptfs/messaging.c |    4 ++--
 fs/ecryptfs/miscdev.c   |   18 +++++++++---------
 4 files changed, 24 insertions(+), 24 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-replace-%z-with-%z fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-replace-%z-with-%z
+++ a/fs/ecryptfs/crypto.c
@@ -1679,7 +1679,7 @@ ecryptfs_encrypt_filename(struct ecryptf
 			kmalloc(filename->encrypted_filename_size, GFP_KERNEL);
 		if (!filename->encrypted_filename) {
 			printk(KERN_ERR "%s: Out of memory whilst attempting "
-			       "to kmalloc [%Zd] bytes\n", __func__,
+			       "to kmalloc [%zd] bytes\n", __func__,
 			       filename->encrypted_filename_size);
 			rc = -ENOMEM;
 			goto out;
@@ -1752,7 +1752,7 @@ ecryptfs_process_key_cipher(struct crypt
 	*key_tfm = NULL;
 	if (*key_size > ECRYPTFS_MAX_KEY_BYTES) {
 		rc = -EINVAL;
-		printk(KERN_ERR "Requested key size is [%Zd] bytes; maximum "
+		printk(KERN_ERR "Requested key size is [%zd] bytes; maximum "
 		      "allowable is [%d]\n", *key_size, ECRYPTFS_MAX_KEY_BYTES);
 		goto out;
 	}
@@ -1777,7 +1777,7 @@ ecryptfs_process_key_cipher(struct crypt
 	get_random_bytes(dummy_key, *key_size);
 	rc = crypto_blkcipher_setkey(*key_tfm, dummy_key, *key_size);
 	if (rc) {
-		printk(KERN_ERR "Error attempting to set key of size [%Zd] for "
+		printk(KERN_ERR "Error attempting to set key of size [%zd] for "
 		       "cipher [%s]; rc = [%d]\n", *key_size, cipher_name, rc);
 		rc = -EINVAL;
 		goto out;
@@ -2221,7 +2221,7 @@ int ecryptfs_decode_and_decrypt_filename
 		decoded_name = kmalloc(decoded_name_size, GFP_KERNEL);
 		if (!decoded_name) {
 			printk(KERN_ERR "%s: Out of memory whilst attempting "
-			       "to kmalloc [%Zd] bytes\n", __func__,
+			       "to kmalloc [%zd] bytes\n", __func__,
 			       decoded_name_size);
 			rc = -ENOMEM;
 			goto out;
diff -puN fs/ecryptfs/keystore.c~ecryptfs-replace-%z-with-%z fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-replace-%z-with-%z
+++ a/fs/ecryptfs/keystore.c
@@ -358,7 +358,7 @@ parse_tag_67_packet(struct ecryptfs_key_
 	/* verify that everything through the encrypted FEK size is present */
 	if (message_len < 4) {
 		rc = -EIO;
-		printk(KERN_ERR "%s: message_len is [%Zd]; minimum acceptable "
+		printk(KERN_ERR "%s: message_len is [%zd]; minimum acceptable "
 		       "message length is [%d]\n", __func__, message_len, 4);
 		goto out;
 	}
@@ -385,13 +385,13 @@ parse_tag_67_packet(struct ecryptfs_key_
 	i += data_len;
 	if (message_len < (i + key_rec->enc_key_size)) {
 		rc = -EIO;
-		printk(KERN_ERR "%s: message_len [%Zd]; max len is [%Zd]\n",
+		printk(KERN_ERR "%s: message_len [%zd]; max len is [%zd]\n",
 		       __func__, message_len, (i + key_rec->enc_key_size));
 		goto out;
 	}
 	if (key_rec->enc_key_size > ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES) {
 		rc = -EIO;
-		printk(KERN_ERR "%s: Encrypted key_size [%Zd] larger than "
+		printk(KERN_ERR "%s: Encrypted key_size [%zd] larger than "
 		       "the maximum key size [%d]\n", __func__,
 		       key_rec->enc_key_size,
 		       ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES);
@@ -511,7 +511,7 @@ ecryptfs_write_tag_70_packet(char *dest,
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s) {
 		printk(KERN_ERR "%s: Out of memory whilst trying to kmalloc "
-		       "[%d] bytes of kernel memory\n", __func__, sizeof(*s));
+		       "[%zd] bytes of kernel memory\n", __func__, sizeof(*s));
 		goto out;
 	}
 	s->desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
@@ -566,7 +566,7 @@ ecryptfs_write_tag_70_packet(char *dest,
 					    GFP_KERNEL);
 	if (!s->block_aligned_filename) {
 		printk(KERN_ERR "%s: Out of kernel memory whilst attempting to "
-		       "kzalloc [%Zd] bytes\n", __func__,
+		       "kzalloc [%zd] bytes\n", __func__,
 		       s->block_aligned_filename_size);
 		rc = -ENOMEM;
 		goto out_unlock;
@@ -721,7 +721,7 @@ ecryptfs_write_tag_70_packet(char *dest,
 		printk(KERN_ERR "%s: Error setting key for crypto context; "
 		       "rc = [%d]. s->auth_tok->token.password.session_key_"
 		       "encryption_key = [0x%p]; mount_crypt_stat->"
-		       "global_default_fn_cipher_key_bytes = [%Zd]\n", __func__,
+		       "global_default_fn_cipher_key_bytes = [%zd]\n", __func__,
 		       rc,
 		       s->auth_tok->token.password.session_key_encryption_key,
 		       mount_crypt_stat->global_default_fn_cipher_key_bytes);
@@ -792,7 +792,7 @@ ecryptfs_parse_tag_70_packet(char **file
 	}
 	s->desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 	if (max_packet_size < (1 + 1 + ECRYPTFS_SIG_SIZE + 1 + 1)) {
-		printk(KERN_WARNING "%s: max_packet_size is [%Zd]; it must be "
+		printk(KERN_WARNING "%s: max_packet_size is [%zd]; it must be "
 		       "at least [%d]\n", __func__, max_packet_size,
 			(1 + 1 + ECRYPTFS_SIG_SIZE + 1 + 1));
 		rc = -EINVAL;
@@ -909,7 +909,7 @@ ecryptfs_parse_tag_70_packet(char **file
 		printk(KERN_ERR "%s: Error setting key for crypto context; "
 		       "rc = [%d]. s->auth_tok->token.password.session_key_"
 		       "encryption_key = [0x%p]; mount_crypt_stat->"
-		       "global_default_fn_cipher_key_bytes = [%Zd]\n", __func__,
+		       "global_default_fn_cipher_key_bytes = [%zd]\n", __func__,
 		       rc,
 		       s->auth_tok->token.password.session_key_encryption_key,
 		       mount_crypt_stat->global_default_fn_cipher_key_bytes);
@@ -936,7 +936,7 @@ ecryptfs_parse_tag_70_packet(char **file
 	s->i++;
 	(*filename_size) = (s->block_aligned_filename_size - s->i);
 	if (!((*filename_size) > 0 && (*filename_size < PATH_MAX))) {
-		printk(KERN_WARNING "%s: Filename size is [%Zd], which is "
+		printk(KERN_WARNING "%s: Filename size is [%zd], which is "
 		       "invalid\n", __func__, (*filename_size));
 		rc = -EINVAL;
 		goto out_free_unlock;
diff -puN fs/ecryptfs/messaging.c~ecryptfs-replace-%z-with-%z fs/ecryptfs/messaging.c
--- a/fs/ecryptfs/messaging.c~ecryptfs-replace-%z-with-%z
+++ a/fs/ecryptfs/messaging.c
@@ -193,7 +193,7 @@ ecryptfs_spawn_daemon(struct ecryptfs_da
 	(*daemon) = kzalloc(sizeof(**daemon), GFP_KERNEL);
 	if (!(*daemon)) {
 		rc = -ENOMEM;
-		printk(KERN_ERR "%s: Failed to allocate [%Zd] bytes of "
+		printk(KERN_ERR "%s: Failed to allocate [%zd] bytes of "
 		       "GFP_KERNEL memory\n", __func__, sizeof(**daemon));
 		goto out;
 	}
@@ -435,7 +435,7 @@ int ecryptfs_process_response(struct ecr
 	msg_ctx->msg = kmalloc(msg_size, GFP_KERNEL);
 	if (!msg_ctx->msg) {
 		rc = -ENOMEM;
-		printk(KERN_ERR "%s: Failed to allocate [%Zd] bytes of "
+		printk(KERN_ERR "%s: Failed to allocate [%zd] bytes of "
 		       "GFP_KERNEL memory\n", __func__, msg_size);
 		goto unlock;
 	}
diff -puN fs/ecryptfs/miscdev.c~ecryptfs-replace-%z-with-%z fs/ecryptfs/miscdev.c
--- a/fs/ecryptfs/miscdev.c~ecryptfs-replace-%z-with-%z
+++ a/fs/ecryptfs/miscdev.c
@@ -199,7 +199,7 @@ int ecryptfs_send_miscdev(char *data, si
 		if (!msg_ctx->msg) {
 			rc = -ENOMEM;
 			printk(KERN_ERR "%s: Out of memory whilst attempting "
-			       "to kmalloc(%Zd, GFP_KERNEL)\n", __func__,
+			       "to kmalloc(%zd, GFP_KERNEL)\n", __func__,
 			       (sizeof(*msg_ctx->msg) + data_size));
 			goto out_unlock;
 		}
@@ -322,7 +322,7 @@ check_list:
 	if (count < total_length) {
 		rc = 0;
 		printk(KERN_WARNING "%s: Only given user buffer of "
-		       "size [%Zd], but we need [%Zd] to read the "
+		       "size [%zd], but we need [%zd] to read the "
 		       "pending message\n", __func__, count, total_length);
 		goto out_unlock_msg_ctx;
 	}
@@ -376,7 +376,7 @@ static int ecryptfs_miscdev_response(cha
 
 	if ((sizeof(*msg) + msg->data_len) != data_size) {
 		printk(KERN_WARNING "%s: (sizeof(*msg) + msg->data_len) = "
-		       "[%Zd]; data_size = [%Zd]. Invalid packet.\n", __func__,
+		       "[%zd]; data_size = [%zd]. Invalid packet.\n", __func__,
 		       (sizeof(*msg) + msg->data_len), data_size);
 		rc = -EINVAL;
 		goto out;
@@ -421,7 +421,7 @@ ecryptfs_miscdev_write(struct file *file
 	data = kmalloc(count, GFP_KERNEL);
 	if (!data) {
 		printk(KERN_ERR "%s: Out of memory whilst attempting to "
-		       "kmalloc([%Zd], GFP_KERNEL)\n", __func__, count);
+		       "kmalloc([%zd], GFP_KERNEL)\n", __func__, count);
 		goto out;
 	}
 	rc = copy_from_user(data, buf, count);
@@ -436,8 +436,8 @@ ecryptfs_miscdev_write(struct file *file
 	case ECRYPTFS_MSG_RESPONSE:
 		if (count < (1 + 4 + 1 + sizeof(struct ecryptfs_message))) {
 			printk(KERN_WARNING "%s: Minimum acceptable packet "
-			       "size is [%Zd], but amount of data written is "
-			       "only [%Zd]. Discarding response packet.\n",
+			       "size is [%zd], but amount of data written is "
+			       "only [%zd]. Discarding response packet.\n",
 			       __func__,
 			       (1 + 4 + 1 + sizeof(struct ecryptfs_message)),
 			       count);
@@ -455,9 +455,9 @@ ecryptfs_miscdev_write(struct file *file
 		}
 		i += packet_size_length;
 		if ((1 + 4 + packet_size_length + packet_size) != count) {
-			printk(KERN_WARNING "%s: (1 + packet_size_length([%Zd])"
-			       " + packet_size([%Zd]))([%Zd]) != "
-			       "count([%Zd]). Invalid packet format.\n",
+			printk(KERN_WARNING "%s: (1 + packet_size_length([%zd])"
+			       " + packet_size([%zd]))([%zd]) != "
+			       "count([%zd]). Invalid packet format.\n",
 			       __func__, packet_size_length, packet_size,
 			       (1 + packet_size_length + packet_size), count);
 			goto out_free;
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

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
notify_change-callers-must-hold-i_mutex.patch

