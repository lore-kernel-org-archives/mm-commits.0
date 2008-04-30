From: akpm@linux-foundation.org
Subject: - ecryptfs-integrate-ecryptfs-device-handle-into-the-module.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:41:55 -0700
Message-ID: <200804300541.m3U5ftqQ029093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757260AbYD3Fmu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:42:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: integrate eCryptfs device handle into the module.
has been removed from the -mm tree.  Its filename was
     ecryptfs-integrate-ecryptfs-device-handle-into-the-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptfs: integrate eCryptfs device handle into the module.
From: Michael Halcrow <mhalcrow@us.ibm.com>

Update the versioning information.  Make the message types generic.  Add an
outgoing message queue to the daemon struct.  Make the functions to parse
and write the packet lengths available to the rest of the module.  Add
functions to create and destroy the daemon structs.  Clean up some of the
comments and make the code a little more consistent with itself.

[akpm@linux-foundation.org: printk fixes]
Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/Makefile          |    2 
 fs/ecryptfs/ecryptfs_kernel.h |   79 ++++-
 fs/ecryptfs/keystore.c        |   89 +++--
 fs/ecryptfs/messaging.c       |  483 +++++++++++++++++++++-----------
 fs/ecryptfs/miscdev.c         |    4 
 fs/ecryptfs/netlink.c         |    8 
 6 files changed, 437 insertions(+), 228 deletions(-)

diff -puN fs/ecryptfs/Makefile~ecryptfs-integrate-ecryptfs-device-handle-into-the-module fs/ecryptfs/Makefile
--- a/fs/ecryptfs/Makefile~ecryptfs-integrate-ecryptfs-device-handle-into-the-module
+++ a/fs/ecryptfs/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_ECRYPT_FS) += ecryptfs.o
 
-ecryptfs-objs := dentry.o file.o inode.o main.o super.o mmap.o read_write.o crypto.o keystore.o messaging.o netlink.o debug.o
+ecryptfs-objs := dentry.o file.o inode.o main.o super.o mmap.o read_write.o crypto.o keystore.o messaging.o netlink.o miscdev.o debug.o
diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-integrate-ecryptfs-device-handle-into-the-module fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-integrate-ecryptfs-device-handle-into-the-module
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -4,7 +4,7 @@
  *
  * Copyright (C) 1997-2003 Erez Zadok
  * Copyright (C) 2001-2003 Stony Brook University
- * Copyright (C) 2004-2007 International Business Machines Corp.
+ * Copyright (C) 2004-2008 International Business Machines Corp.
  *   Author(s): Michael A. Halcrow <mahalcro@us.ibm.com>
  *              Trevor S. Highland <trevor.highland@gmail.com>
  *              Tyler Hicks <tyhicks@ou.edu>
@@ -49,11 +49,13 @@
 #define ECRYPTFS_VERSIONING_POLICY                0x00000008
 #define ECRYPTFS_VERSIONING_XATTR                 0x00000010
 #define ECRYPTFS_VERSIONING_MULTKEY               0x00000020
+#define ECRYPTFS_VERSIONING_DEVMISC               0x00000040
 #define ECRYPTFS_VERSIONING_MASK (ECRYPTFS_VERSIONING_PASSPHRASE \
 				  | ECRYPTFS_VERSIONING_PLAINTEXT_PASSTHROUGH \
 				  | ECRYPTFS_VERSIONING_PUBKEY \
 				  | ECRYPTFS_VERSIONING_XATTR \
-				  | ECRYPTFS_VERSIONING_MULTKEY)
+				  | ECRYPTFS_VERSIONING_MULTKEY \
+				  | ECRYPTFS_VERSIONING_DEVMISC)
 #define ECRYPTFS_MAX_PASSWORD_LENGTH 64
 #define ECRYPTFS_MAX_PASSPHRASE_BYTES ECRYPTFS_MAX_PASSWORD_LENGTH
 #define ECRYPTFS_SALT_SIZE 8
@@ -73,17 +75,14 @@
 #define ECRYPTFS_DEFAULT_MSG_CTX_ELEMS 32
 #define ECRYPTFS_DEFAULT_SEND_TIMEOUT HZ
 #define ECRYPTFS_MAX_MSG_CTX_TTL (HZ*3)
-#define ECRYPTFS_NLMSG_HELO 100
-#define ECRYPTFS_NLMSG_QUIT 101
-#define ECRYPTFS_NLMSG_REQUEST 102
-#define ECRYPTFS_NLMSG_RESPONSE 103
 #define ECRYPTFS_MAX_PKI_NAME_BYTES 16
 #define ECRYPTFS_DEFAULT_NUM_USERS 4
 #define ECRYPTFS_MAX_NUM_USERS 32768
 #define ECRYPTFS_TRANSPORT_NETLINK 0
 #define ECRYPTFS_TRANSPORT_CONNECTOR 1
 #define ECRYPTFS_TRANSPORT_RELAYFS 2
-#define ECRYPTFS_DEFAULT_TRANSPORT ECRYPTFS_TRANSPORT_NETLINK
+#define ECRYPTFS_TRANSPORT_MISCDEV 3
+#define ECRYPTFS_DEFAULT_TRANSPORT ECRYPTFS_TRANSPORT_MISCDEV
 #define ECRYPTFS_XATTR_NAME "user.ecryptfs"
 
 #define RFC2440_CIPHER_DES3_EDE 0x02
@@ -366,32 +365,62 @@ struct ecryptfs_auth_tok_list_item {
 };
 
 struct ecryptfs_message {
+	/* Can never be greater than ecryptfs_message_buf_len */
+	/* Used to find the parent msg_ctx */
+	/* Inherits from msg_ctx->index */
 	u32 index;
 	u32 data_len;
 	u8 data[];
 };
 
 struct ecryptfs_msg_ctx {
-#define ECRYPTFS_MSG_CTX_STATE_FREE      0x0001
-#define ECRYPTFS_MSG_CTX_STATE_PENDING   0x0002
-#define ECRYPTFS_MSG_CTX_STATE_DONE      0x0003
-	u32 state;
-	unsigned int index;
-	unsigned int counter;
+#define ECRYPTFS_MSG_CTX_STATE_FREE     0x01
+#define ECRYPTFS_MSG_CTX_STATE_PENDING  0x02
+#define ECRYPTFS_MSG_CTX_STATE_DONE     0x03
+#define ECRYPTFS_MSG_CTX_STATE_NO_REPLY 0x04
+	u8 state;
+#define ECRYPTFS_MSG_HELO 100
+#define ECRYPTFS_MSG_QUIT 101
+#define ECRYPTFS_MSG_REQUEST 102
+#define ECRYPTFS_MSG_RESPONSE 103
+	u8 type;
+	u32 index;
+	/* Counter converts to a sequence number. Each message sent
+	 * out for which we expect a response has an associated
+	 * sequence number. The response must have the same sequence
+	 * number as the counter for the msg_stc for the message to be
+	 * valid. */
+	u32 counter;
+	size_t msg_size;
 	struct ecryptfs_message *msg;
 	struct task_struct *task;
 	struct list_head node;
+	struct list_head daemon_out_list;
 	struct mutex mux;
 };
 
 extern unsigned int ecryptfs_transport;
 
-struct ecryptfs_daemon_id {
+struct ecryptfs_daemon;
+
+struct ecryptfs_daemon {
+#define ECRYPTFS_DAEMON_IN_READ      0x00000001
+#define ECRYPTFS_DAEMON_IN_POLL      0x00000002
+#define ECRYPTFS_DAEMON_ZOMBIE       0x00000004
+#define ECRYPTFS_DAEMON_MISCDEV_OPEN 0x00000008
+	u32 flags;
+	u32 num_queued_msg_ctx;
 	pid_t pid;
-	uid_t uid;
-	struct hlist_node id_chain;
+	uid_t euid;
+	struct task_struct *task;
+	struct mutex mux;
+	struct list_head msg_ctx_out_queue;
+	wait_queue_head_t wait;
+	struct hlist_node euid_chain;
 };
 
+extern struct mutex ecryptfs_daemon_hash_mux;
+
 static inline struct ecryptfs_file_info *
 ecryptfs_file_to_private(struct file *file)
 {
@@ -593,13 +622,13 @@ int ecryptfs_init_messaging(unsigned int
 void ecryptfs_release_messaging(unsigned int transport);
 
 int ecryptfs_send_netlink(char *data, int data_len,
-			  struct ecryptfs_msg_ctx *msg_ctx, u16 msg_type,
+			  struct ecryptfs_msg_ctx *msg_ctx, u8 msg_type,
 			  u16 msg_flags, pid_t daemon_pid);
 int ecryptfs_init_netlink(void);
 void ecryptfs_release_netlink(void);
 
 int ecryptfs_send_connector(char *data, int data_len,
-			    struct ecryptfs_msg_ctx *msg_ctx, u16 msg_type,
+			    struct ecryptfs_msg_ctx *msg_ctx, u8 msg_type,
 			    u16 msg_flags, pid_t daemon_pid);
 int ecryptfs_init_connector(void);
 void ecryptfs_release_connector(void);
@@ -642,5 +671,19 @@ int ecryptfs_read_lower_page_segment(str
 				     size_t offset_in_page, size_t size,
 				     struct inode *ecryptfs_inode);
 struct page *ecryptfs_get_locked_page(struct file *file, loff_t index);
+int ecryptfs_exorcise_daemon(struct ecryptfs_daemon *daemon);
+int ecryptfs_find_daemon_by_euid(struct ecryptfs_daemon **daemon, uid_t euid);
+int ecryptfs_parse_packet_length(unsigned char *data, size_t *size,
+				 size_t *length_size);
+int ecryptfs_write_packet_length(char *dest, size_t size,
+				 size_t *packet_size_length);
+int ecryptfs_init_ecryptfs_miscdev(void);
+void ecryptfs_destroy_ecryptfs_miscdev(void);
+int ecryptfs_send_miscdev(char *data, size_t data_size,
+			  struct ecryptfs_msg_ctx *msg_ctx, u8 msg_type,
+			  u16 msg_flags, struct ecryptfs_daemon *daemon);
+void ecryptfs_msg_ctx_alloc_to_free(struct ecryptfs_msg_ctx *msg_ctx);
+int
+ecryptfs_spawn_daemon(struct ecryptfs_daemon **daemon, uid_t euid, pid_t pid);
 
 #endif /* #ifndef ECRYPTFS_KERNEL_H */
diff -puN fs/ecryptfs/keystore.c~ecryptfs-integrate-ecryptfs-device-handle-into-the-module fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-integrate-ecryptfs-device-handle-into-the-module
+++ a/fs/ecryptfs/keystore.c
@@ -65,7 +65,7 @@ static int process_request_key_err(long 
 }
 
 /**
- * parse_packet_length
+ * ecryptfs_parse_packet_length
  * @data: Pointer to memory containing length at offset
  * @size: This function writes the decoded size to this memory
  *        address; zero on error
@@ -73,8 +73,8 @@ static int process_request_key_err(long 
  *
  * Returns zero on success; non-zero on error
  */
-static int parse_packet_length(unsigned char *data, size_t *size,
-			       size_t *length_size)
+int ecryptfs_parse_packet_length(unsigned char *data, size_t *size,
+				 size_t *length_size)
 {
 	int rc = 0;
 
@@ -105,7 +105,7 @@ out:
 }
 
 /**
- * write_packet_length
+ * ecryptfs_write_packet_length
  * @dest: The byte array target into which to write the length. Must
  *        have at least 5 bytes allocated.
  * @size: The length to write.
@@ -114,8 +114,8 @@ out:
  *
  * Returns zero on success; non-zero on error.
  */
-static int write_packet_length(char *dest, size_t size,
-			       size_t *packet_size_length)
+int ecryptfs_write_packet_length(char *dest, size_t size,
+				 size_t *packet_size_length)
 {
 	int rc = 0;
 
@@ -162,8 +162,8 @@ write_tag_64_packet(char *signature, str
 		goto out;
 	}
 	message[i++] = ECRYPTFS_TAG_64_PACKET_TYPE;
-	rc = write_packet_length(&message[i], ECRYPTFS_SIG_SIZE_HEX,
-				 &packet_size_len);
+	rc = ecryptfs_write_packet_length(&message[i], ECRYPTFS_SIG_SIZE_HEX,
+					  &packet_size_len);
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Error generating tag 64 packet "
 				"header; cannot generate packet length\n");
@@ -172,8 +172,9 @@ write_tag_64_packet(char *signature, str
 	i += packet_size_len;
 	memcpy(&message[i], signature, ECRYPTFS_SIG_SIZE_HEX);
 	i += ECRYPTFS_SIG_SIZE_HEX;
-	rc = write_packet_length(&message[i], session_key->encrypted_key_size,
-				 &packet_size_len);
+	rc = ecryptfs_write_packet_length(&message[i],
+					  session_key->encrypted_key_size,
+					  &packet_size_len);
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Error generating tag 64 packet "
 				"header; cannot generate packet length\n");
@@ -225,7 +226,7 @@ parse_tag_65_packet(struct ecryptfs_sess
 		rc = -EIO;
 		goto out;
 	}
-	rc = parse_packet_length(&data[i], &m_size, &data_len);
+	rc = ecryptfs_parse_packet_length(&data[i], &m_size, &data_len);
 	if (rc) {
 		ecryptfs_printk(KERN_WARNING, "Error parsing packet length; "
 				"rc = [%d]\n", rc);
@@ -304,8 +305,8 @@ write_tag_66_packet(char *signature, u8 
 		goto out;
 	}
 	message[i++] = ECRYPTFS_TAG_66_PACKET_TYPE;
-	rc = write_packet_length(&message[i], ECRYPTFS_SIG_SIZE_HEX,
-				 &packet_size_len);
+	rc = ecryptfs_write_packet_length(&message[i], ECRYPTFS_SIG_SIZE_HEX,
+					  &packet_size_len);
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Error generating tag 66 packet "
 				"header; cannot generate packet length\n");
@@ -315,8 +316,8 @@ write_tag_66_packet(char *signature, u8 
 	memcpy(&message[i], signature, ECRYPTFS_SIG_SIZE_HEX);
 	i += ECRYPTFS_SIG_SIZE_HEX;
 	/* The encrypted key includes 1 byte cipher code and 2 byte checksum */
-	rc = write_packet_length(&message[i], crypt_stat->key_size + 3,
-				 &packet_size_len);
+	rc = ecryptfs_write_packet_length(&message[i], crypt_stat->key_size + 3,
+					  &packet_size_len);
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Error generating tag 66 packet "
 				"header; cannot generate packet length\n");
@@ -357,20 +358,25 @@ parse_tag_67_packet(struct ecryptfs_key_
 	/* verify that everything through the encrypted FEK size is present */
 	if (message_len < 4) {
 		rc = -EIO;
+		printk(KERN_ERR "%s: message_len is [%Zd]; minimum acceptable "
+		       "message length is [%d]\n", __func__, message_len, 4);
 		goto out;
 	}
 	if (data[i++] != ECRYPTFS_TAG_67_PACKET_TYPE) {
-		ecryptfs_printk(KERN_ERR, "Type should be ECRYPTFS_TAG_67\n");
 		rc = -EIO;
+		printk(KERN_ERR "%s: Type should be ECRYPTFS_TAG_67\n",
+		       __func__);
 		goto out;
 	}
 	if (data[i++]) {
-		ecryptfs_printk(KERN_ERR, "Status indicator has non zero value"
-				" [%d]\n", data[i-1]);
 		rc = -EIO;
+		printk(KERN_ERR "%s: Status indicator has non zero "
+		       "value [%d]\n", __func__, data[i-1]);
+
 		goto out;
 	}
-	rc = parse_packet_length(&data[i], &key_rec->enc_key_size, &data_len);
+	rc = ecryptfs_parse_packet_length(&data[i], &key_rec->enc_key_size,
+					  &data_len);
 	if (rc) {
 		ecryptfs_printk(KERN_WARNING, "Error parsing packet length; "
 				"rc = [%d]\n", rc);
@@ -378,17 +384,17 @@ parse_tag_67_packet(struct ecryptfs_key_
 	}
 	i += data_len;
 	if (message_len < (i + key_rec->enc_key_size)) {
-		ecryptfs_printk(KERN_ERR, "message_len [%d]; max len is [%d]\n",
-				message_len, (i + key_rec->enc_key_size));
 		rc = -EIO;
+		printk(KERN_ERR "%s: message_len [%Zd]; max len is [%Zd]\n",
+		       __func__, message_len, (i + key_rec->enc_key_size));
 		goto out;
 	}
 	if (key_rec->enc_key_size > ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES) {
-		ecryptfs_printk(KERN_ERR, "Encrypted key_size [%d] larger than "
-				"the maximum key size [%d]\n",
-				key_rec->enc_key_size,
-				ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES);
 		rc = -EIO;
+		printk(KERN_ERR "%s: Encrypted key_size [%Zd] larger than "
+		       "the maximum key size [%d]\n", __func__,
+		       key_rec->enc_key_size,
+		       ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES);
 		goto out;
 	}
 	memcpy(key_rec->enc_key, &data[i], key_rec->enc_key_size);
@@ -445,7 +451,7 @@ decrypt_pki_encrypted_session_key(struct
 	rc = write_tag_64_packet(auth_tok_sig, &(auth_tok->session_key),
 				 &netlink_message, &netlink_message_length);
 	if (rc) {
-		ecryptfs_printk(KERN_ERR, "Failed to write tag 64 packet");
+		ecryptfs_printk(KERN_ERR, "Failed to write tag 64 packet\n");
 		goto out;
 	}
 	rc = ecryptfs_send_message(ecryptfs_transport, netlink_message,
@@ -570,8 +576,8 @@ parse_tag_1_packet(struct ecryptfs_crypt
 		goto out;
 	}
 	(*new_auth_tok) = &auth_tok_list_item->auth_tok;
-	rc = parse_packet_length(&data[(*packet_size)], &body_size,
-				 &length_size);
+	rc = ecryptfs_parse_packet_length(&data[(*packet_size)], &body_size,
+					  &length_size);
 	if (rc) {
 		printk(KERN_WARNING "Error parsing packet length; "
 		       "rc = [%d]\n", rc);
@@ -704,8 +710,8 @@ parse_tag_3_packet(struct ecryptfs_crypt
 		goto out;
 	}
 	(*new_auth_tok) = &auth_tok_list_item->auth_tok;
-	rc = parse_packet_length(&data[(*packet_size)], &body_size,
-				 &length_size);
+	rc = ecryptfs_parse_packet_length(&data[(*packet_size)], &body_size,
+					  &length_size);
 	if (rc) {
 		printk(KERN_WARNING "Error parsing packet length; rc = [%d]\n",
 		       rc);
@@ -852,8 +858,8 @@ parse_tag_11_packet(unsigned char *data,
 		rc = -EINVAL;
 		goto out;
 	}
-	rc = parse_packet_length(&data[(*packet_size)], &body_size,
-				 &length_size);
+	rc = ecryptfs_parse_packet_length(&data[(*packet_size)], &body_size,
+					  &length_size);
 	if (rc) {
 		printk(KERN_WARNING "Invalid tag 11 packet format\n");
 		goto out;
@@ -1405,8 +1411,8 @@ write_tag_1_packet(char *dest, size_t *r
 			auth_tok->token.private_key.key_size;
 	rc = pki_encrypt_session_key(auth_tok, crypt_stat, key_rec);
 	if (rc) {
-		ecryptfs_printk(KERN_ERR, "Failed to encrypt session key "
-				"via a pki");
+		printk(KERN_ERR "Failed to encrypt session key via a key "
+		       "module; rc = [%d]\n", rc);
 		goto out;
 	}
 	if (ecryptfs_verbosity > 0) {
@@ -1430,8 +1436,9 @@ encrypted_session_key_set:
 		goto out;
 	}
 	dest[(*packet_size)++] = ECRYPTFS_TAG_1_PACKET_TYPE;
-	rc = write_packet_length(&dest[(*packet_size)], (max_packet_size - 4),
-				 &packet_size_length);
+	rc = ecryptfs_write_packet_length(&dest[(*packet_size)],
+					  (max_packet_size - 4),
+					  &packet_size_length);
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Error generating tag 1 packet "
 				"header; cannot generate packet length\n");
@@ -1489,8 +1496,9 @@ write_tag_11_packet(char *dest, size_t *
 		goto out;
 	}
 	dest[(*packet_length)++] = ECRYPTFS_TAG_11_PACKET_TYPE;
-	rc = write_packet_length(&dest[(*packet_length)],
-				 (max_packet_size - 4), &packet_size_length);
+	rc = ecryptfs_write_packet_length(&dest[(*packet_length)],
+					  (max_packet_size - 4),
+					  &packet_size_length);
 	if (rc) {
 		printk(KERN_ERR "Error generating tag 11 packet header; cannot "
 		       "generate packet length. rc = [%d]\n", rc);
@@ -1682,8 +1690,9 @@ encrypted_session_key_set:
 	dest[(*packet_size)++] = ECRYPTFS_TAG_3_PACKET_TYPE;
 	/* Chop off the Tag 3 identifier(1) and Tag 3 packet size(3)
 	 * to get the number of octets in the actual Tag 3 packet */
-	rc = write_packet_length(&dest[(*packet_size)], (max_packet_size - 4),
-				 &packet_size_length);
+	rc = ecryptfs_write_packet_length(&dest[(*packet_size)],
+					  (max_packet_size - 4),
+					  &packet_size_length);
 	if (rc) {
 		printk(KERN_ERR "Error generating tag 3 packet header; cannot "
 		       "generate packet length. rc = [%d]\n", rc);
diff -puN fs/ecryptfs/messaging.c~ecryptfs-integrate-ecryptfs-device-handle-into-the-module fs/ecryptfs/messaging.c
--- a/fs/ecryptfs/messaging.c~ecryptfs-integrate-ecryptfs-device-handle-into-the-module
+++ a/fs/ecryptfs/messaging.c
@@ -1,7 +1,7 @@
 /**
  * eCryptfs: Linux filesystem encryption layer
  *
- * Copyright (C) 2004-2006 International Business Machines Corp.
+ * Copyright (C) 2004-2008 International Business Machines Corp.
  *   Author(s): Michael A. Halcrow <mhalcrow@us.ibm.com>
  *		Tyler Hicks <tyhicks@ou.edu>
  *
@@ -26,13 +26,13 @@ static LIST_HEAD(ecryptfs_msg_ctx_free_l
 static LIST_HEAD(ecryptfs_msg_ctx_alloc_list);
 static struct mutex ecryptfs_msg_ctx_lists_mux;
 
-static struct hlist_head *ecryptfs_daemon_id_hash;
-static struct mutex ecryptfs_daemon_id_hash_mux;
+static struct hlist_head *ecryptfs_daemon_hash;
+struct mutex ecryptfs_daemon_hash_mux;
 static int ecryptfs_hash_buckets;
 #define ecryptfs_uid_hash(uid) \
         hash_long((unsigned long)uid, ecryptfs_hash_buckets)
 
-static unsigned int ecryptfs_msg_counter;
+static u32 ecryptfs_msg_counter;
 static struct ecryptfs_msg_ctx *ecryptfs_msg_ctx_arr;
 
 /**
@@ -40,9 +40,10 @@ static struct ecryptfs_msg_ctx *ecryptfs
  * @msg_ctx: The context that was acquired from the free list
  *
  * Acquires a context element from the free list and locks the mutex
- * on the context.  Returns zero on success; non-zero on error or upon
- * failure to acquire a free context element.  Be sure to lock the
- * list mutex before calling.
+ * on the context.  Sets the msg_ctx task to current.  Returns zero on
+ * success; non-zero on error or upon failure to acquire a free
+ * context element.  Must be called with ecryptfs_msg_ctx_lists_mux
+ * held.
  */
 static int ecryptfs_acquire_free_msg_ctx(struct ecryptfs_msg_ctx **msg_ctx)
 {
@@ -50,11 +51,11 @@ static int ecryptfs_acquire_free_msg_ctx
 	int rc;
 
 	if (list_empty(&ecryptfs_msg_ctx_free_list)) {
-		ecryptfs_printk(KERN_WARNING, "The eCryptfs free "
-				"context list is empty.  It may be helpful to "
-				"specify the ecryptfs_message_buf_len "
-				"parameter to be greater than the current "
-				"value of [%d]\n", ecryptfs_message_buf_len);
+		printk(KERN_WARNING "%s: The eCryptfs free "
+		       "context list is empty.  It may be helpful to "
+		       "specify the ecryptfs_message_buf_len "
+		       "parameter to be greater than the current "
+		       "value of [%d]\n", __func__, ecryptfs_message_buf_len);
 		rc = -ENOMEM;
 		goto out;
 	}
@@ -75,8 +76,7 @@ out:
  * ecryptfs_msg_ctx_free_to_alloc
  * @msg_ctx: The context to move from the free list to the alloc list
  *
- * Be sure to lock the list mutex and the context mutex before
- * calling.
+ * Must be called with ecryptfs_msg_ctx_lists_mux held.
  */
 static void ecryptfs_msg_ctx_free_to_alloc(struct ecryptfs_msg_ctx *msg_ctx)
 {
@@ -89,36 +89,37 @@ static void ecryptfs_msg_ctx_free_to_all
  * ecryptfs_msg_ctx_alloc_to_free
  * @msg_ctx: The context to move from the alloc list to the free list
  *
- * Be sure to lock the list mutex and the context mutex before
- * calling.
+ * Must be called with ecryptfs_msg_ctx_lists_mux held.
  */
-static void ecryptfs_msg_ctx_alloc_to_free(struct ecryptfs_msg_ctx *msg_ctx)
+void ecryptfs_msg_ctx_alloc_to_free(struct ecryptfs_msg_ctx *msg_ctx)
 {
 	list_move(&(msg_ctx->node), &ecryptfs_msg_ctx_free_list);
 	if (msg_ctx->msg)
 		kfree(msg_ctx->msg);
+	msg_ctx->msg = NULL;
 	msg_ctx->state = ECRYPTFS_MSG_CTX_STATE_FREE;
 }
 
 /**
- * ecryptfs_find_daemon_id
- * @uid: The user id which maps to the desired daemon id
- * @id: If return value is zero, points to the desired daemon id
- *      pointer
- *
- * Search the hash list for the given user id.  Returns zero if the
- * user id exists in the list; non-zero otherwise.  The daemon id hash
- * mutex should be held before calling this function.
+ * ecryptfs_find_daemon_by_euid
+ * @euid: The effective user id which maps to the desired daemon id
+ * @daemon: If return value is zero, points to the desired daemon pointer
+ *
+ * Must be called with ecryptfs_daemon_hash_mux held.
+ *
+ * Search the hash list for the given user id.
+ *
+ * Returns zero if the user id exists in the list; non-zero otherwise.
  */
-static int ecryptfs_find_daemon_id(uid_t uid, struct ecryptfs_daemon_id **id)
+int ecryptfs_find_daemon_by_euid(struct ecryptfs_daemon **daemon, uid_t euid)
 {
 	struct hlist_node *elem;
 	int rc;
 
-	hlist_for_each_entry(*id, elem,
-			     &ecryptfs_daemon_id_hash[ecryptfs_uid_hash(uid)],
-			     id_chain) {
-		if ((*id)->uid == uid) {
+	hlist_for_each_entry(*daemon, elem,
+			     &ecryptfs_daemon_hash[ecryptfs_uid_hash(euid)],
+			     euid_chain) {
+		if ((*daemon)->euid == euid) {
 			rc = 0;
 			goto out;
 		}
@@ -128,181 +129,291 @@ out:
 	return rc;
 }
 
-static int ecryptfs_send_raw_message(unsigned int transport, u16 msg_type,
-				     pid_t pid)
+static int
+ecryptfs_send_message_locked(unsigned int transport, char *data, int data_len,
+			     u8 msg_type, struct ecryptfs_msg_ctx **msg_ctx);
+
+/**
+ * ecryptfs_send_raw_message
+ * @transport: Transport type
+ * @msg_type: Message type
+ * @daemon: Daemon struct for recipient of message
+ *
+ * A raw message is one that does not include an ecryptfs_message
+ * struct. It simply has a type.
+ *
+ * Must be called with ecryptfs_daemon_hash_mux held.
+ *
+ * Returns zero on success; non-zero otherwise
+ */
+static int ecryptfs_send_raw_message(unsigned int transport, u8 msg_type,
+				     struct ecryptfs_daemon *daemon)
 {
+	struct ecryptfs_msg_ctx *msg_ctx;
 	int rc;
 
 	switch(transport) {
 	case ECRYPTFS_TRANSPORT_NETLINK:
-		rc = ecryptfs_send_netlink(NULL, 0, NULL, msg_type, 0, pid);
+		rc = ecryptfs_send_netlink(NULL, 0, NULL, msg_type, 0,
+					   daemon->pid);
+		break;
+	case ECRYPTFS_TRANSPORT_MISCDEV:
+		rc = ecryptfs_send_message_locked(transport, NULL, 0, msg_type,
+						  &msg_ctx);
+		if (rc) {
+			printk(KERN_ERR "%s: Error whilst attempting to send "
+			       "message via procfs; rc = [%d]\n", __func__, rc);
+			goto out;
+		}
+		/* Raw messages are logically context-free (e.g., no
+		 * reply is expected), so we set the state of the
+		 * ecryptfs_msg_ctx object to indicate that it should
+		 * be freed as soon as the transport sends out the message. */
+		mutex_lock(&msg_ctx->mux);
+		msg_ctx->state = ECRYPTFS_MSG_CTX_STATE_NO_REPLY;
+		mutex_unlock(&msg_ctx->mux);
 		break;
 	case ECRYPTFS_TRANSPORT_CONNECTOR:
 	case ECRYPTFS_TRANSPORT_RELAYFS:
 	default:
 		rc = -ENOSYS;
 	}
+out:
+	return rc;
+}
+
+/**
+ * ecryptfs_spawn_daemon - Create and initialize a new daemon struct
+ * @daemon: Pointer to set to newly allocated daemon struct
+ * @euid: Effective user id for the daemon
+ * @pid: Process id for the daemon
+ *
+ * Must be called ceremoniously while in possession of
+ * ecryptfs_sacred_daemon_hash_mux
+ *
+ * Returns zero on success; non-zero otherwise
+ */
+int
+ecryptfs_spawn_daemon(struct ecryptfs_daemon **daemon, uid_t euid, pid_t pid)
+{
+	int rc = 0;
+
+	(*daemon) = kzalloc(sizeof(**daemon), GFP_KERNEL);
+	if (!(*daemon)) {
+		rc = -ENOMEM;
+		printk(KERN_ERR "%s: Failed to allocate [%Zd] bytes of "
+		       "GFP_KERNEL memory\n", __func__, sizeof(**daemon));
+		goto out;
+	}
+	(*daemon)->euid = euid;
+	(*daemon)->pid = pid;
+	(*daemon)->task = current;
+	mutex_init(&(*daemon)->mux);
+	INIT_LIST_HEAD(&(*daemon)->msg_ctx_out_queue);
+	init_waitqueue_head(&(*daemon)->wait);
+	(*daemon)->num_queued_msg_ctx = 0;
+	hlist_add_head(&(*daemon)->euid_chain,
+		       &ecryptfs_daemon_hash[ecryptfs_uid_hash(euid)]);
+out:
 	return rc;
 }
 
 /**
  * ecryptfs_process_helo
  * @transport: The underlying transport (netlink, etc.)
- * @uid: The user ID owner of the message
+ * @euid: The user ID owner of the message
  * @pid: The process ID for the userspace program that sent the
  *       message
  *
- * Adds the uid and pid values to the daemon id hash.  If a uid
+ * Adds the euid and pid values to the daemon euid hash.  If an euid
  * already has a daemon pid registered, the daemon will be
- * unregistered before the new daemon id is put into the hash list.
- * Returns zero after adding a new daemon id to the hash list;
+ * unregistered before the new daemon is put into the hash list.
+ * Returns zero after adding a new daemon to the hash list;
  * non-zero otherwise.
  */
-int ecryptfs_process_helo(unsigned int transport, uid_t uid, pid_t pid)
+int ecryptfs_process_helo(unsigned int transport, uid_t euid, pid_t pid)
 {
-	struct ecryptfs_daemon_id *new_id;
-	struct ecryptfs_daemon_id *old_id;
+	struct ecryptfs_daemon *new_daemon;
+	struct ecryptfs_daemon *old_daemon;
 	int rc;
 
-	mutex_lock(&ecryptfs_daemon_id_hash_mux);
-	new_id = kmalloc(sizeof(*new_id), GFP_KERNEL);
-	if (!new_id) {
-		rc = -ENOMEM;
-		ecryptfs_printk(KERN_ERR, "Failed to allocate memory; unable "
-				"to register daemon [%d] for user [%d]\n",
-				pid, uid);
-		goto unlock;
-	}
-	if (!ecryptfs_find_daemon_id(uid, &old_id)) {
+	mutex_lock(&ecryptfs_daemon_hash_mux);
+	rc = ecryptfs_find_daemon_by_euid(&old_daemon, euid);
+	if (rc != 0) {
 		printk(KERN_WARNING "Received request from user [%d] "
 		       "to register daemon [%d]; unregistering daemon "
-		       "[%d]\n", uid, pid, old_id->pid);
-		hlist_del(&old_id->id_chain);
-		rc = ecryptfs_send_raw_message(transport, ECRYPTFS_NLMSG_QUIT,
-					       old_id->pid);
+		       "[%d]\n", euid, pid, old_daemon->pid);
+		rc = ecryptfs_send_raw_message(transport, ECRYPTFS_MSG_QUIT,
+					       old_daemon);
 		if (rc)
 			printk(KERN_WARNING "Failed to send QUIT "
 			       "message to daemon [%d]; rc = [%d]\n",
-			       old_id->pid, rc);
-		kfree(old_id);
+			       old_daemon->pid, rc);
+		hlist_del(&old_daemon->euid_chain);
+		kfree(old_daemon);
+	}
+	rc = ecryptfs_spawn_daemon(&new_daemon, euid, pid);
+	if (rc)
+		printk(KERN_ERR "%s: The gods are displeased with this attempt "
+		       "to create a new daemon object for euid [%d]; pid [%d]; "
+		       "rc = [%d]\n", __func__, euid, pid, rc);
+	mutex_unlock(&ecryptfs_daemon_hash_mux);
+	return rc;
+}
+
+/**
+ * ecryptfs_exorcise_daemon - Destroy the daemon struct
+ *
+ * Must be called ceremoniously while in possession of
+ * ecryptfs_daemon_hash_mux and the daemon's own mux.
+ */
+int ecryptfs_exorcise_daemon(struct ecryptfs_daemon *daemon)
+{
+	struct ecryptfs_msg_ctx *msg_ctx, *msg_ctx_tmp;
+	int rc = 0;
+
+	mutex_lock(&daemon->mux);
+	if ((daemon->flags & ECRYPTFS_DAEMON_IN_READ)
+	    || (daemon->flags & ECRYPTFS_DAEMON_IN_POLL)) {
+		rc = -EBUSY;
+		printk(KERN_WARNING "%s: Attempt to destroy daemon with pid "
+		       "[%d], but it is in the midst of a read or a poll\n",
+		       __func__, daemon->pid);
+		mutex_unlock(&daemon->mux);
+		goto out;
 	}
-	new_id->uid = uid;
-	new_id->pid = pid;
-	hlist_add_head(&new_id->id_chain,
-		       &ecryptfs_daemon_id_hash[ecryptfs_uid_hash(uid)]);
-	rc = 0;
-unlock:
-	mutex_unlock(&ecryptfs_daemon_id_hash_mux);
+	list_for_each_entry_safe(msg_ctx, msg_ctx_tmp,
+				 &daemon->msg_ctx_out_queue, daemon_out_list) {
+		list_del(&msg_ctx->daemon_out_list);
+		daemon->num_queued_msg_ctx--;
+		printk(KERN_WARNING "%s: Warning: dropping message that is in "
+		       "the out queue of a dying daemon\n", __func__);
+		ecryptfs_msg_ctx_alloc_to_free(msg_ctx);
+	}
+	hlist_del(&daemon->euid_chain);
+	if (daemon->task)
+		wake_up_process(daemon->task);
+	mutex_unlock(&daemon->mux);
+	memset(daemon, 0, sizeof(*daemon));
+	kfree(daemon);
+out:
 	return rc;
 }
 
 /**
  * ecryptfs_process_quit
- * @uid: The user ID owner of the message
+ * @euid: The user ID owner of the message
  * @pid: The process ID for the userspace program that sent the
  *       message
  *
- * Deletes the corresponding daemon id for the given uid and pid, if
+ * Deletes the corresponding daemon for the given euid and pid, if
  * it is the registered that is requesting the deletion. Returns zero
- * after deleting the desired daemon id; non-zero otherwise.
+ * after deleting the desired daemon; non-zero otherwise.
  */
-int ecryptfs_process_quit(uid_t uid, pid_t pid)
+int ecryptfs_process_quit(uid_t euid, pid_t pid)
 {
-	struct ecryptfs_daemon_id *id;
+	struct ecryptfs_daemon *daemon;
 	int rc;
 
-	mutex_lock(&ecryptfs_daemon_id_hash_mux);
-	if (ecryptfs_find_daemon_id(uid, &id)) {
-		rc = -EINVAL;
-		ecryptfs_printk(KERN_ERR, "Received request from user [%d] to "
-				"unregister unrecognized daemon [%d]\n", uid,
-				pid);
-		goto unlock;
-	}
-	if (id->pid != pid) {
+	mutex_lock(&ecryptfs_daemon_hash_mux);
+	rc = ecryptfs_find_daemon_by_euid(&daemon, euid);
+	if (rc || !daemon) {
 		rc = -EINVAL;
-		ecryptfs_printk(KERN_WARNING, "Received request from user [%d] "
-				"with pid [%d] to unregister daemon [%d]\n",
-				uid, pid, id->pid);
-		goto unlock;
-	}
-	hlist_del(&id->id_chain);
-	kfree(id);
-	rc = 0;
-unlock:
-	mutex_unlock(&ecryptfs_daemon_id_hash_mux);
+		printk(KERN_ERR "Received request from user [%d] to "
+		       "unregister unrecognized daemon [%d]\n", euid, pid);
+		goto out_unlock;
+	}
+	rc = ecryptfs_exorcise_daemon(daemon);
+out_unlock:
+	mutex_unlock(&ecryptfs_daemon_hash_mux);
 	return rc;
 }
 
 /**
  * ecryptfs_process_reponse
  * @msg: The ecryptfs message received; the caller should sanity check
- *       msg->data_len
+ *       msg->data_len and free the memory
  * @pid: The process ID of the userspace application that sent the
  *       message
- * @seq: The sequence number of the message
+ * @seq: The sequence number of the message; must match the sequence
+ *       number for the existing message context waiting for this
+ *       response
+ *
+ * Processes a response message after sending an operation request to
+ * userspace. Some other process is awaiting this response. Before
+ * sending out its first communications, the other process allocated a
+ * msg_ctx from the ecryptfs_msg_ctx_arr at a particular index. The
+ * response message contains this index so that we can copy over the
+ * response message into the msg_ctx that the process holds a
+ * reference to. The other process is going to wake up, check to see
+ * that msg_ctx->state == ECRYPTFS_MSG_CTX_STATE_DONE, and then
+ * proceed to read off and process the response message. Returns zero
+ * upon delivery to desired context element; non-zero upon delivery
+ * failure or error.
  *
- * Processes a response message after sending a operation request to
- * userspace. Returns zero upon delivery to desired context element;
- * non-zero upon delivery failure or error.
+ * Returns zero on success; non-zero otherwise
  */
-int ecryptfs_process_response(struct ecryptfs_message *msg, uid_t uid,
+int ecryptfs_process_response(struct ecryptfs_message *msg, uid_t euid,
 			      pid_t pid, u32 seq)
 {
-	struct ecryptfs_daemon_id *id;
+	struct ecryptfs_daemon *daemon;
 	struct ecryptfs_msg_ctx *msg_ctx;
-	int msg_size;
+	size_t msg_size;
 	int rc;
 
 	if (msg->index >= ecryptfs_message_buf_len) {
 		rc = -EINVAL;
-		ecryptfs_printk(KERN_ERR, "Attempt to reference "
-				"context buffer at index [%d]; maximum "
-				"allowable is [%d]\n", msg->index,
-				(ecryptfs_message_buf_len - 1));
+		printk(KERN_ERR "%s: Attempt to reference "
+		       "context buffer at index [%d]; maximum "
+		       "allowable is [%d]\n", __func__, msg->index,
+		       (ecryptfs_message_buf_len - 1));
 		goto out;
 	}
 	msg_ctx = &ecryptfs_msg_ctx_arr[msg->index];
 	mutex_lock(&msg_ctx->mux);
-	if (ecryptfs_find_daemon_id(msg_ctx->task->euid, &id)) {
+	mutex_lock(&ecryptfs_daemon_hash_mux);
+	rc = ecryptfs_find_daemon_by_euid(&daemon, msg_ctx->task->euid);
+	mutex_unlock(&ecryptfs_daemon_hash_mux);
+	if (rc) {
 		rc = -EBADMSG;
-		ecryptfs_printk(KERN_WARNING, "User [%d] received a "
-				"message response from process [%d] but does "
-				"not have a registered daemon\n",
-				msg_ctx->task->euid, pid);
+		printk(KERN_WARNING "%s: User [%d] received a "
+		       "message response from process [%d] but does "
+		       "not have a registered daemon\n", __func__,
+		       msg_ctx->task->euid, pid);
 		goto wake_up;
 	}
-	if (msg_ctx->task->euid != uid) {
+	if (msg_ctx->task->euid != euid) {
 		rc = -EBADMSG;
-		ecryptfs_printk(KERN_WARNING, "Received message from user "
-				"[%d]; expected message from user [%d]\n",
-				uid, msg_ctx->task->euid);
+		printk(KERN_WARNING "%s: Received message from user "
+		       "[%d]; expected message from user [%d]\n", __func__,
+		       euid, msg_ctx->task->euid);
 		goto unlock;
 	}
-	if (id->pid != pid) {
+	if (daemon->pid != pid) {
 		rc = -EBADMSG;
-		ecryptfs_printk(KERN_ERR, "User [%d] received a "
-				"message response from an unrecognized "
-				"process [%d]\n", msg_ctx->task->euid, pid);
+		printk(KERN_ERR "%s: User [%d] sent a message response "
+		       "from an unrecognized process [%d]\n",
+		       __func__, msg_ctx->task->euid, pid);
 		goto unlock;
 	}
 	if (msg_ctx->state != ECRYPTFS_MSG_CTX_STATE_PENDING) {
 		rc = -EINVAL;
-		ecryptfs_printk(KERN_WARNING, "Desired context element is not "
-				"pending a response\n");
+		printk(KERN_WARNING "%s: Desired context element is not "
+		       "pending a response\n", __func__);
 		goto unlock;
 	} else if (msg_ctx->counter != seq) {
 		rc = -EINVAL;
-		ecryptfs_printk(KERN_WARNING, "Invalid message sequence; "
-				"expected [%d]; received [%d]\n",
-				msg_ctx->counter, seq);
+		printk(KERN_WARNING "%s: Invalid message sequence; "
+		       "expected [%d]; received [%d]\n", __func__,
+		       msg_ctx->counter, seq);
 		goto unlock;
 	}
-	msg_size = sizeof(*msg) + msg->data_len;
+	msg_size = (sizeof(*msg) + msg->data_len);
 	msg_ctx->msg = kmalloc(msg_size, GFP_KERNEL);
 	if (!msg_ctx->msg) {
 		rc = -ENOMEM;
-		ecryptfs_printk(KERN_ERR, "Failed to allocate memory\n");
+		printk(KERN_ERR "%s: Failed to allocate [%Zd] bytes of "
+		       "GFP_KERNEL memory\n", __func__, msg_size);
 		goto unlock;
 	}
 	memcpy(msg_ctx->msg, msg, msg_size);
@@ -317,34 +428,37 @@ out:
 }
 
 /**
- * ecryptfs_send_message
+ * ecryptfs_send_message_locked
  * @transport: The transport over which to send the message (i.e.,
  *             netlink)
  * @data: The data to send
  * @data_len: The length of data
  * @msg_ctx: The message context allocated for the send
+ *
+ * Must be called with ecryptfs_daemon_hash_mux held.
+ *
+ * Returns zero on success; non-zero otherwise
  */
-int ecryptfs_send_message(unsigned int transport, char *data, int data_len,
-			  struct ecryptfs_msg_ctx **msg_ctx)
+static int
+ecryptfs_send_message_locked(unsigned int transport, char *data, int data_len,
+			     u8 msg_type, struct ecryptfs_msg_ctx **msg_ctx)
 {
-	struct ecryptfs_daemon_id *id;
+	struct ecryptfs_daemon *daemon;
 	int rc;
 
-	mutex_lock(&ecryptfs_daemon_id_hash_mux);
-	if (ecryptfs_find_daemon_id(current->euid, &id)) {
-		mutex_unlock(&ecryptfs_daemon_id_hash_mux);
+	rc = ecryptfs_find_daemon_by_euid(&daemon, current->euid);
+	if (rc || !daemon) {
 		rc = -ENOTCONN;
-		ecryptfs_printk(KERN_ERR, "User [%d] does not have a daemon "
-				"registered\n", current->euid);
+		printk(KERN_ERR "%s: User [%d] does not have a daemon "
+		       "registered\n", __func__, current->euid);
 		goto out;
 	}
-	mutex_unlock(&ecryptfs_daemon_id_hash_mux);
 	mutex_lock(&ecryptfs_msg_ctx_lists_mux);
 	rc = ecryptfs_acquire_free_msg_ctx(msg_ctx);
 	if (rc) {
 		mutex_unlock(&ecryptfs_msg_ctx_lists_mux);
-		ecryptfs_printk(KERN_WARNING, "Could not claim a free "
-				"context element\n");
+		printk(KERN_WARNING "%s: Could not claim a free "
+		       "context element\n", __func__);
 		goto out;
 	}
 	ecryptfs_msg_ctx_free_to_alloc(*msg_ctx);
@@ -352,23 +466,50 @@ int ecryptfs_send_message(unsigned int t
 	mutex_unlock(&ecryptfs_msg_ctx_lists_mux);
 	switch (transport) {
 	case ECRYPTFS_TRANSPORT_NETLINK:
-		rc = ecryptfs_send_netlink(data, data_len, *msg_ctx,
-					   ECRYPTFS_NLMSG_REQUEST, 0, id->pid);
+		rc = ecryptfs_send_netlink(data, data_len, *msg_ctx, msg_type,
+					   0, daemon->pid);
+		break;
+	case ECRYPTFS_TRANSPORT_MISCDEV:
+		rc = ecryptfs_send_miscdev(data, data_len, *msg_ctx, msg_type,
+					   0, daemon);
 		break;
 	case ECRYPTFS_TRANSPORT_CONNECTOR:
 	case ECRYPTFS_TRANSPORT_RELAYFS:
 	default:
 		rc = -ENOSYS;
 	}
-	if (rc) {
-		printk(KERN_ERR "Error attempting to send message to userspace "
-		       "daemon; rc = [%d]\n", rc);
-	}
+	if (rc)
+		printk(KERN_ERR "%s: Error attempting to send message to "
+		       "userspace daemon; rc = [%d]\n", __func__, rc);
 out:
 	return rc;
 }
 
 /**
+ * ecryptfs_send_message
+ * @transport: The transport over which to send the message (i.e.,
+ *             netlink)
+ * @data: The data to send
+ * @data_len: The length of data
+ * @msg_ctx: The message context allocated for the send
+ *
+ * Grabs ecryptfs_daemon_hash_mux.
+ *
+ * Returns zero on success; non-zero otherwise
+ */
+int ecryptfs_send_message(unsigned int transport, char *data, int data_len,
+			  struct ecryptfs_msg_ctx **msg_ctx)
+{
+	int rc;
+
+	mutex_lock(&ecryptfs_daemon_hash_mux);
+	rc = ecryptfs_send_message_locked(transport, data, data_len,
+					  ECRYPTFS_MSG_REQUEST, msg_ctx);
+	mutex_unlock(&ecryptfs_daemon_hash_mux);
+	return rc;
+}
+
+/**
  * ecryptfs_wait_for_response
  * @msg_ctx: The context that was assigned when sending a message
  * @msg: The incoming message from userspace; not set if rc != 0
@@ -377,7 +518,7 @@ out:
  * of time exceeds ecryptfs_message_wait_timeout.  If zero is
  * returned, msg will point to a valid message from userspace; a
  * non-zero value is returned upon failure to receive a message or an
- * error occurs.
+ * error occurs. Callee must free @msg on success.
  */
 int ecryptfs_wait_for_response(struct ecryptfs_msg_ctx *msg_ctx,
 			       struct ecryptfs_message **msg)
@@ -413,32 +554,32 @@ int ecryptfs_init_messaging(unsigned int
 
 	if (ecryptfs_number_of_users > ECRYPTFS_MAX_NUM_USERS) {
 		ecryptfs_number_of_users = ECRYPTFS_MAX_NUM_USERS;
-		ecryptfs_printk(KERN_WARNING, "Specified number of users is "
-				"too large, defaulting to [%d] users\n",
-				ecryptfs_number_of_users);
+		printk(KERN_WARNING "%s: Specified number of users is "
+		       "too large, defaulting to [%d] users\n", __func__,
+		       ecryptfs_number_of_users);
 	}
-	mutex_init(&ecryptfs_daemon_id_hash_mux);
-	mutex_lock(&ecryptfs_daemon_id_hash_mux);
+	mutex_init(&ecryptfs_daemon_hash_mux);
+	mutex_lock(&ecryptfs_daemon_hash_mux);
 	ecryptfs_hash_buckets = 1;
 	while (ecryptfs_number_of_users >> ecryptfs_hash_buckets)
 		ecryptfs_hash_buckets++;
-	ecryptfs_daemon_id_hash = kmalloc(sizeof(struct hlist_head)
-					  * ecryptfs_hash_buckets, GFP_KERNEL);
-	if (!ecryptfs_daemon_id_hash) {
+	ecryptfs_daemon_hash = kmalloc((sizeof(struct hlist_head)
+					* ecryptfs_hash_buckets), GFP_KERNEL);
+	if (!ecryptfs_daemon_hash) {
 		rc = -ENOMEM;
-		ecryptfs_printk(KERN_ERR, "Failed to allocate memory\n");
-		mutex_unlock(&ecryptfs_daemon_id_hash_mux);
+		printk(KERN_ERR "%s: Failed to allocate memory\n", __func__);
+		mutex_unlock(&ecryptfs_daemon_hash_mux);
 		goto out;
 	}
 	for (i = 0; i < ecryptfs_hash_buckets; i++)
-		INIT_HLIST_HEAD(&ecryptfs_daemon_id_hash[i]);
-	mutex_unlock(&ecryptfs_daemon_id_hash_mux);
-
+		INIT_HLIST_HEAD(&ecryptfs_daemon_hash[i]);
+	mutex_unlock(&ecryptfs_daemon_hash_mux);
 	ecryptfs_msg_ctx_arr = kmalloc((sizeof(struct ecryptfs_msg_ctx)
-				      * ecryptfs_message_buf_len), GFP_KERNEL);
+					* ecryptfs_message_buf_len),
+				       GFP_KERNEL);
 	if (!ecryptfs_msg_ctx_arr) {
 		rc = -ENOMEM;
-		ecryptfs_printk(KERN_ERR, "Failed to allocate memory\n");
+		printk(KERN_ERR "%s: Failed to allocate memory\n", __func__);
 		goto out;
 	}
 	mutex_init(&ecryptfs_msg_ctx_lists_mux);
@@ -446,6 +587,7 @@ int ecryptfs_init_messaging(unsigned int
 	ecryptfs_msg_counter = 0;
 	for (i = 0; i < ecryptfs_message_buf_len; i++) {
 		INIT_LIST_HEAD(&ecryptfs_msg_ctx_arr[i].node);
+		INIT_LIST_HEAD(&ecryptfs_msg_ctx_arr[i].daemon_out_list);
 		mutex_init(&ecryptfs_msg_ctx_arr[i].mux);
 		mutex_lock(&ecryptfs_msg_ctx_arr[i].mux);
 		ecryptfs_msg_ctx_arr[i].index = i;
@@ -464,6 +606,11 @@ int ecryptfs_init_messaging(unsigned int
 		if (rc)
 			ecryptfs_release_messaging(transport);
 		break;
+	case ECRYPTFS_TRANSPORT_MISCDEV:
+		rc = ecryptfs_init_ecryptfs_miscdev();
+		if (rc)
+			ecryptfs_release_messaging(transport);
+		break;
 	case ECRYPTFS_TRANSPORT_CONNECTOR:
 	case ECRYPTFS_TRANSPORT_RELAYFS:
 	default:
@@ -488,27 +635,37 @@ void ecryptfs_release_messaging(unsigned
 		kfree(ecryptfs_msg_ctx_arr);
 		mutex_unlock(&ecryptfs_msg_ctx_lists_mux);
 	}
-	if (ecryptfs_daemon_id_hash) {
+	if (ecryptfs_daemon_hash) {
 		struct hlist_node *elem;
-		struct ecryptfs_daemon_id *id;
+		struct ecryptfs_daemon *daemon;
 		int i;
 
-		mutex_lock(&ecryptfs_daemon_id_hash_mux);
+		mutex_lock(&ecryptfs_daemon_hash_mux);
 		for (i = 0; i < ecryptfs_hash_buckets; i++) {
-			hlist_for_each_entry(id, elem,
-					     &ecryptfs_daemon_id_hash[i],
-					     id_chain) {
-				hlist_del(elem);
-				kfree(id);
+			int rc;
+
+			hlist_for_each_entry(daemon, elem,
+					     &ecryptfs_daemon_hash[i],
+					     euid_chain) {
+				rc = ecryptfs_exorcise_daemon(daemon);
+				if (rc)
+					printk(KERN_ERR "%s: Error whilst "
+					       "attempting to destroy daemon; "
+					       "rc = [%d]. Dazed and confused, "
+					       "but trying to continue.\n",
+					       __func__, rc);
 			}
 		}
-		kfree(ecryptfs_daemon_id_hash);
-		mutex_unlock(&ecryptfs_daemon_id_hash_mux);
+		kfree(ecryptfs_daemon_hash);
+		mutex_unlock(&ecryptfs_daemon_hash_mux);
 	}
 	switch(transport) {
 	case ECRYPTFS_TRANSPORT_NETLINK:
 		ecryptfs_release_netlink();
 		break;
+	case ECRYPTFS_TRANSPORT_MISCDEV:
+		ecryptfs_destroy_ecryptfs_miscdev();
+		break;
 	case ECRYPTFS_TRANSPORT_CONNECTOR:
 	case ECRYPTFS_TRANSPORT_RELAYFS:
 	default:
diff -puN fs/ecryptfs/miscdev.c~ecryptfs-integrate-ecryptfs-device-handle-into-the-module fs/ecryptfs/miscdev.c
--- a/fs/ecryptfs/miscdev.c~ecryptfs-integrate-ecryptfs-device-handle-into-the-module
+++ a/fs/ecryptfs/miscdev.c
@@ -196,7 +196,7 @@ int ecryptfs_send_miscdev(char *data, si
 		if (!msg_ctx->msg) {
 			rc = -ENOMEM;
 			printk(KERN_ERR "%s: Out of memory whilst attempting "
-			       "to kmalloc(%d, GFP_KERNEL)\n", __func__,
+			       "to kmalloc(%Zd, GFP_KERNEL)\n", __func__,
 			       (sizeof(*msg_ctx->msg) + data_size));
 			goto out_unlock;
 		}
@@ -232,7 +232,7 @@ out_unlock:
  *
  * Returns the number of bytes copied into the user buffer
  */
-static int
+static ssize_t
 ecryptfs_miscdev_read(struct file *file, char __user *buf, size_t count,
 		      loff_t *ppos)
 {
diff -puN fs/ecryptfs/netlink.c~ecryptfs-integrate-ecryptfs-device-handle-into-the-module fs/ecryptfs/netlink.c
--- a/fs/ecryptfs/netlink.c~ecryptfs-integrate-ecryptfs-device-handle-into-the-module
+++ a/fs/ecryptfs/netlink.c
@@ -44,7 +44,7 @@ static struct sock *ecryptfs_nl_sock;
  * upon sending the message; non-zero upon error.
  */
 int ecryptfs_send_netlink(char *data, int data_len,
-			  struct ecryptfs_msg_ctx *msg_ctx, u16 msg_type,
+			  struct ecryptfs_msg_ctx *msg_ctx, u8 msg_type,
 			  u16 msg_flags, pid_t daemon_pid)
 {
 	struct sk_buff *skb;
@@ -176,20 +176,20 @@ static void ecryptfs_receive_nl_message(
 		goto free;
 	}
 	switch (nlh->nlmsg_type) {
-		case ECRYPTFS_NLMSG_RESPONSE:
+		case ECRYPTFS_MSG_RESPONSE:
 			if (ecryptfs_process_nl_response(skb)) {
 				ecryptfs_printk(KERN_WARNING, "Failed to "
 						"deliver netlink response to "
 						"requesting operation\n");
 			}
 			break;
-		case ECRYPTFS_NLMSG_HELO:
+		case ECRYPTFS_MSG_HELO:
 			if (ecryptfs_process_nl_helo(skb)) {
 				ecryptfs_printk(KERN_WARNING, "Failed to "
 						"fulfill HELO request\n");
 			}
 			break;
-		case ECRYPTFS_NLMSG_QUIT:
+		case ECRYPTFS_MSG_QUIT:
 			if (ecryptfs_process_nl_quit(skb)) {
 				ecryptfs_printk(KERN_WARNING, "Failed to "
 						"fulfill QUIT request\n");
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
notify_change-callers-must-hold-i_mutex.patch

