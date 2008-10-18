From: akpm@linux-foundation.org
Subject: - ecryptfs-remove-netlink-transport.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:14:57 -0700
Message-ID: <200810182314.m9INEvx3028505@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671AbYJRXPN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:15:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tyhicks@linux.vnet.ibm.com, kirkland@canonical.com, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: remove netlink transport
has been removed from the -mm tree.  Its filename was
     ecryptfs-remove-netlink-transport.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptfs: remove netlink transport
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

The netlink transport code has not worked for a while and the miscdev
transport is a simpler solution.  This patch removes the netlink code and
makes the miscdev transport the only eCryptfs kernel to userspace
transport.

Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Dustin Kirkland <kirkland@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/Makefile          |    2 
 fs/ecryptfs/ecryptfs_kernel.h |   28 ---
 fs/ecryptfs/keystore.c        |   32 +---
 fs/ecryptfs/main.c            |   19 +-
 fs/ecryptfs/messaging.c       |  118 +++------------
 fs/ecryptfs/netlink.c         |  249 --------------------------------
 6 files changed, 60 insertions(+), 388 deletions(-)

diff -puN fs/ecryptfs/Makefile~ecryptfs-remove-netlink-transport fs/ecryptfs/Makefile
--- a/fs/ecryptfs/Makefile~ecryptfs-remove-netlink-transport
+++ a/fs/ecryptfs/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_ECRYPT_FS) += ecryptfs.o
 
-ecryptfs-objs := dentry.o file.o inode.o main.o super.o mmap.o read_write.o crypto.o keystore.o messaging.o netlink.o miscdev.o kthread.o debug.o
+ecryptfs-objs := dentry.o file.o inode.o main.o super.o mmap.o read_write.o crypto.o keystore.o messaging.o miscdev.o kthread.o debug.o
diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-remove-netlink-transport fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-remove-netlink-transport
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -79,11 +79,6 @@
 #define ECRYPTFS_MAX_PKI_NAME_BYTES 16
 #define ECRYPTFS_DEFAULT_NUM_USERS 4
 #define ECRYPTFS_MAX_NUM_USERS 32768
-#define ECRYPTFS_TRANSPORT_NETLINK 0
-#define ECRYPTFS_TRANSPORT_CONNECTOR 1
-#define ECRYPTFS_TRANSPORT_RELAYFS 2
-#define ECRYPTFS_TRANSPORT_MISCDEV 3
-#define ECRYPTFS_DEFAULT_TRANSPORT ECRYPTFS_TRANSPORT_MISCDEV
 #define ECRYPTFS_XATTR_NAME "user.ecryptfs"
 
 #define RFC2440_CIPHER_DES3_EDE 0x02
@@ -400,8 +395,6 @@ struct ecryptfs_msg_ctx {
 	struct mutex mux;
 };
 
-extern unsigned int ecryptfs_transport;
-
 struct ecryptfs_daemon;
 
 struct ecryptfs_daemon {
@@ -627,31 +620,20 @@ int
 ecryptfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		  size_t size, int flags);
 int ecryptfs_read_xattr_region(char *page_virt, struct inode *ecryptfs_inode);
-int ecryptfs_process_helo(unsigned int transport, uid_t euid,
-			  struct user_namespace *user_ns, struct pid *pid);
+int ecryptfs_process_helo(uid_t euid, struct user_namespace *user_ns,
+			  struct pid *pid);
 int ecryptfs_process_quit(uid_t euid, struct user_namespace *user_ns,
 			  struct pid *pid);
 int ecryptfs_process_response(struct ecryptfs_message *msg, uid_t euid,
 			      struct user_namespace *user_ns, struct pid *pid,
 			      u32 seq);
-int ecryptfs_send_message(unsigned int transport, char *data, int data_len,
+int ecryptfs_send_message(char *data, int data_len,
 			  struct ecryptfs_msg_ctx **msg_ctx);
 int ecryptfs_wait_for_response(struct ecryptfs_msg_ctx *msg_ctx,
 			       struct ecryptfs_message **emsg);
-int ecryptfs_init_messaging(unsigned int transport);
-void ecryptfs_release_messaging(unsigned int transport);
+int ecryptfs_init_messaging(void);
+void ecryptfs_release_messaging(void);
 
-int ecryptfs_send_netlink(char *data, int data_len,
-			  struct ecryptfs_msg_ctx *msg_ctx, u8 msg_type,
-			  u16 msg_flags, struct pid *daemon_pid);
-int ecryptfs_init_netlink(void);
-void ecryptfs_release_netlink(void);
-
-int ecryptfs_send_connector(char *data, int data_len,
-			    struct ecryptfs_msg_ctx *msg_ctx, u8 msg_type,
-			    u16 msg_flags, struct pid *daemon_pid);
-int ecryptfs_init_connector(void);
-void ecryptfs_release_connector(void);
 void
 ecryptfs_write_header_metadata(char *virt,
 			       struct ecryptfs_crypt_stat *crypt_stat,
diff -puN fs/ecryptfs/keystore.c~ecryptfs-remove-netlink-transport fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-remove-netlink-transport
+++ a/fs/ecryptfs/keystore.c
@@ -234,8 +234,8 @@ parse_tag_65_packet(struct ecryptfs_sess
 	}
 	i += data_len;
 	if (message_len < (i + m_size)) {
-		ecryptfs_printk(KERN_ERR, "The received netlink message is "
-				"shorter than expected\n");
+		ecryptfs_printk(KERN_ERR, "The message received from ecryptfsd "
+				"is shorter than expected\n");
 		rc = -EIO;
 		goto out;
 	}
@@ -438,8 +438,8 @@ decrypt_pki_encrypted_session_key(struct
 	struct ecryptfs_msg_ctx *msg_ctx;
 	struct ecryptfs_message *msg = NULL;
 	char *auth_tok_sig;
-	char *netlink_message;
-	size_t netlink_message_length;
+	char *payload;
+	size_t payload_len;
 	int rc;
 
 	rc = ecryptfs_get_auth_tok_sig(&auth_tok_sig, auth_tok);
@@ -449,15 +449,15 @@ decrypt_pki_encrypted_session_key(struct
 		goto out;
 	}
 	rc = write_tag_64_packet(auth_tok_sig, &(auth_tok->session_key),
-				 &netlink_message, &netlink_message_length);
+				 &payload, &payload_len);
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Failed to write tag 64 packet\n");
 		goto out;
 	}
-	rc = ecryptfs_send_message(ecryptfs_transport, netlink_message,
-				   netlink_message_length, &msg_ctx);
+	rc = ecryptfs_send_message(payload, payload_len, &msg_ctx);
 	if (rc) {
-		ecryptfs_printk(KERN_ERR, "Error sending netlink message\n");
+		ecryptfs_printk(KERN_ERR, "Error sending message to "
+				"ecryptfsd\n");
 		goto out;
 	}
 	rc = ecryptfs_wait_for_response(msg_ctx, &msg);
@@ -1333,23 +1333,22 @@ pki_encrypt_session_key(struct ecryptfs_
 			struct ecryptfs_key_record *key_rec)
 {
 	struct ecryptfs_msg_ctx *msg_ctx = NULL;
-	char *netlink_payload;
-	size_t netlink_payload_length;
+	char *payload = NULL;
+	size_t payload_len;
 	struct ecryptfs_message *msg;
 	int rc;
 
 	rc = write_tag_66_packet(auth_tok->token.private_key.signature,
 				 ecryptfs_code_for_cipher_string(crypt_stat),
-				 crypt_stat, &netlink_payload,
-				 &netlink_payload_length);
+				 crypt_stat, &payload, &payload_len);
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Error generating tag 66 packet\n");
 		goto out;
 	}
-	rc = ecryptfs_send_message(ecryptfs_transport, netlink_payload,
-				   netlink_payload_length, &msg_ctx);
+	rc = ecryptfs_send_message(payload, payload_len, &msg_ctx);
 	if (rc) {
-		ecryptfs_printk(KERN_ERR, "Error sending netlink message\n");
+		ecryptfs_printk(KERN_ERR, "Error sending message to "
+				"ecryptfsd\n");
 		goto out;
 	}
 	rc = ecryptfs_wait_for_response(msg_ctx, &msg);
@@ -1364,8 +1363,7 @@ pki_encrypt_session_key(struct ecryptfs_
 		ecryptfs_printk(KERN_ERR, "Error parsing tag 67 packet\n");
 	kfree(msg);
 out:
-	if (netlink_payload)
-		kfree(netlink_payload);
+	kfree(payload);
 	return rc;
 }
 /**
diff -puN fs/ecryptfs/main.c~ecryptfs-remove-netlink-transport fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-remove-netlink-transport
+++ a/fs/ecryptfs/main.c
@@ -30,7 +30,6 @@
 #include <linux/namei.h>
 #include <linux/skbuff.h>
 #include <linux/crypto.h>
-#include <linux/netlink.h>
 #include <linux/mount.h>
 #include <linux/pagemap.h>
 #include <linux/key.h>
@@ -49,8 +48,7 @@ MODULE_PARM_DESC(ecryptfs_verbosity,
 		 "0, which is Quiet)");
 
 /**
- * Module parameter that defines the number of netlink message buffer
- * elements
+ * Module parameter that defines the number of message buffer elements
  */
 unsigned int ecryptfs_message_buf_len = ECRYPTFS_DEFAULT_MSG_CTX_ELEMS;
 
@@ -60,9 +58,9 @@ MODULE_PARM_DESC(ecryptfs_message_buf_le
 
 /**
  * Module parameter that defines the maximum guaranteed amount of time to wait
- * for a response through netlink.  The actual sleep time will be, more than
+ * for a response from ecryptfsd.  The actual sleep time will be, more than
  * likely, a small amount greater than this specified value, but only less if
- * the netlink message successfully arrives.
+ * the message successfully arrives.
  */
 signed long ecryptfs_message_wait_timeout = ECRYPTFS_MAX_MSG_CTX_TTL / HZ;
 
@@ -83,8 +81,6 @@ module_param(ecryptfs_number_of_users, u
 MODULE_PARM_DESC(ecryptfs_number_of_users, "An estimate of the number of "
 		 "concurrent users of eCryptfs");
 
-unsigned int ecryptfs_transport = ECRYPTFS_DEFAULT_TRANSPORT;
-
 void __ecryptfs_printk(const char *fmt, ...)
 {
 	va_list args;
@@ -779,10 +775,11 @@ static int __init ecryptfs_init(void)
 		       "rc = [%d]\n", __func__, rc);
 		goto out_do_sysfs_unregistration;
 	}
-	rc = ecryptfs_init_messaging(ecryptfs_transport);
+	rc = ecryptfs_init_messaging();
 	if (rc) {
 		printk(KERN_ERR "Failure occured while attempting to "
-				"initialize the eCryptfs netlink socket\n");
+				"initialize the communications channel to "
+				"ecryptfsd\n");
 		goto out_destroy_kthread;
 	}
 	rc = ecryptfs_init_crypto();
@@ -797,7 +794,7 @@ static int __init ecryptfs_init(void)
 
 	goto out;
 out_release_messaging:
-	ecryptfs_release_messaging(ecryptfs_transport);
+	ecryptfs_release_messaging();
 out_destroy_kthread:
 	ecryptfs_destroy_kthread();
 out_do_sysfs_unregistration:
@@ -818,7 +815,7 @@ static void __exit ecryptfs_exit(void)
 	if (rc)
 		printk(KERN_ERR "Failure whilst attempting to destroy crypto; "
 		       "rc = [%d]\n", rc);
-	ecryptfs_release_messaging(ecryptfs_transport);
+	ecryptfs_release_messaging();
 	ecryptfs_destroy_kthread();
 	do_sysfs_unregistration();
 	unregister_filesystem(&ecryptfs_fs_type);
diff -puN fs/ecryptfs/messaging.c~ecryptfs-remove-netlink-transport fs/ecryptfs/messaging.c
--- a/fs/ecryptfs/messaging.c~ecryptfs-remove-netlink-transport
+++ a/fs/ecryptfs/messaging.c
@@ -134,12 +134,11 @@ out:
 }
 
 static int
-ecryptfs_send_message_locked(unsigned int transport, char *data, int data_len,
-			     u8 msg_type, struct ecryptfs_msg_ctx **msg_ctx);
+ecryptfs_send_message_locked(char *data, int data_len, u8 msg_type,
+			     struct ecryptfs_msg_ctx **msg_ctx);
 
 /**
  * ecryptfs_send_raw_message
- * @transport: Transport type
  * @msg_type: Message type
  * @daemon: Daemon struct for recipient of message
  *
@@ -150,38 +149,25 @@ ecryptfs_send_message_locked(unsigned in
  *
  * Returns zero on success; non-zero otherwise
  */
-static int ecryptfs_send_raw_message(unsigned int transport, u8 msg_type,
+static int ecryptfs_send_raw_message(u8 msg_type,
 				     struct ecryptfs_daemon *daemon)
 {
 	struct ecryptfs_msg_ctx *msg_ctx;
 	int rc;
 
-	switch(transport) {
-	case ECRYPTFS_TRANSPORT_NETLINK:
-		rc = ecryptfs_send_netlink(NULL, 0, NULL, msg_type, 0,
-					   daemon->pid);
-		break;
-	case ECRYPTFS_TRANSPORT_MISCDEV:
-		rc = ecryptfs_send_message_locked(transport, NULL, 0, msg_type,
-						  &msg_ctx);
-		if (rc) {
-			printk(KERN_ERR "%s: Error whilst attempting to send "
-			       "message via procfs; rc = [%d]\n", __func__, rc);
-			goto out;
-		}
-		/* Raw messages are logically context-free (e.g., no
-		 * reply is expected), so we set the state of the
-		 * ecryptfs_msg_ctx object to indicate that it should
-		 * be freed as soon as the transport sends out the message. */
-		mutex_lock(&msg_ctx->mux);
-		msg_ctx->state = ECRYPTFS_MSG_CTX_STATE_NO_REPLY;
-		mutex_unlock(&msg_ctx->mux);
-		break;
-	case ECRYPTFS_TRANSPORT_CONNECTOR:
-	case ECRYPTFS_TRANSPORT_RELAYFS:
-	default:
-		rc = -ENOSYS;
+	rc = ecryptfs_send_message_locked(NULL, 0, msg_type, &msg_ctx);
+	if (rc) {
+		printk(KERN_ERR "%s: Error whilst attempting to send "
+		       "message to ecryptfsd; rc = [%d]\n", __func__, rc);
+		goto out;
 	}
+	/* Raw messages are logically context-free (e.g., no
+	 * reply is expected), so we set the state of the
+	 * ecryptfs_msg_ctx object to indicate that it should
+	 * be freed as soon as the message is sent. */
+	mutex_lock(&msg_ctx->mux);
+	msg_ctx->state = ECRYPTFS_MSG_CTX_STATE_NO_REPLY;
+	mutex_unlock(&msg_ctx->mux);
 out:
 	return rc;
 }
@@ -227,7 +213,6 @@ out:
 
 /**
  * ecryptfs_process_helo
- * @transport: The underlying transport (netlink, etc.)
  * @euid: The user ID owner of the message
  * @user_ns: The namespace in which @euid applies
  * @pid: The process ID for the userspace program that sent the
@@ -239,8 +224,8 @@ out:
  * Returns zero after adding a new daemon to the hash list;
  * non-zero otherwise.
  */
-int ecryptfs_process_helo(unsigned int transport, uid_t euid,
-			  struct user_namespace *user_ns, struct pid *pid)
+int ecryptfs_process_helo(uid_t euid, struct user_namespace *user_ns,
+			  struct pid *pid)
 {
 	struct ecryptfs_daemon *new_daemon;
 	struct ecryptfs_daemon *old_daemon;
@@ -252,8 +237,7 @@ int ecryptfs_process_helo(unsigned int t
 		printk(KERN_WARNING "Received request from user [%d] "
 		       "to register daemon [0x%p]; unregistering daemon "
 		       "[0x%p]\n", euid, pid, old_daemon->pid);
-		rc = ecryptfs_send_raw_message(transport, ECRYPTFS_MSG_QUIT,
-					       old_daemon);
+		rc = ecryptfs_send_raw_message(ECRYPTFS_MSG_QUIT, old_daemon);
 		if (rc)
 			printk(KERN_WARNING "Failed to send QUIT "
 			       "message to daemon [0x%p]; rc = [%d]\n",
@@ -467,8 +451,6 @@ out:
 
 /**
  * ecryptfs_send_message_locked
- * @transport: The transport over which to send the message (i.e.,
- *             netlink)
  * @data: The data to send
  * @data_len: The length of data
  * @msg_ctx: The message context allocated for the send
@@ -478,8 +460,8 @@ out:
  * Returns zero on success; non-zero otherwise
  */
 static int
-ecryptfs_send_message_locked(unsigned int transport, char *data, int data_len,
-			     u8 msg_type, struct ecryptfs_msg_ctx **msg_ctx)
+ecryptfs_send_message_locked(char *data, int data_len, u8 msg_type,
+			     struct ecryptfs_msg_ctx **msg_ctx)
 {
 	struct ecryptfs_daemon *daemon;
 	int rc;
@@ -503,20 +485,8 @@ ecryptfs_send_message_locked(unsigned in
 	ecryptfs_msg_ctx_free_to_alloc(*msg_ctx);
 	mutex_unlock(&(*msg_ctx)->mux);
 	mutex_unlock(&ecryptfs_msg_ctx_lists_mux);
-	switch (transport) {
-	case ECRYPTFS_TRANSPORT_NETLINK:
-		rc = ecryptfs_send_netlink(data, data_len, *msg_ctx, msg_type,
-					   0, daemon->pid);
-		break;
-	case ECRYPTFS_TRANSPORT_MISCDEV:
-		rc = ecryptfs_send_miscdev(data, data_len, *msg_ctx, msg_type,
-					   0, daemon);
-		break;
-	case ECRYPTFS_TRANSPORT_CONNECTOR:
-	case ECRYPTFS_TRANSPORT_RELAYFS:
-	default:
-		rc = -ENOSYS;
-	}
+	rc = ecryptfs_send_miscdev(data, data_len, *msg_ctx, msg_type, 0,
+				   daemon);
 	if (rc)
 		printk(KERN_ERR "%s: Error attempting to send message to "
 		       "userspace daemon; rc = [%d]\n", __func__, rc);
@@ -526,8 +496,6 @@ out:
 
 /**
  * ecryptfs_send_message
- * @transport: The transport over which to send the message (i.e.,
- *             netlink)
  * @data: The data to send
  * @data_len: The length of data
  * @msg_ctx: The message context allocated for the send
@@ -536,14 +504,14 @@ out:
  *
  * Returns zero on success; non-zero otherwise
  */
-int ecryptfs_send_message(unsigned int transport, char *data, int data_len,
+int ecryptfs_send_message(char *data, int data_len,
 			  struct ecryptfs_msg_ctx **msg_ctx)
 {
 	int rc;
 
 	mutex_lock(&ecryptfs_daemon_hash_mux);
-	rc = ecryptfs_send_message_locked(transport, data, data_len,
-					  ECRYPTFS_MSG_REQUEST, msg_ctx);
+	rc = ecryptfs_send_message_locked(data, data_len, ECRYPTFS_MSG_REQUEST,
+					  msg_ctx);
 	mutex_unlock(&ecryptfs_daemon_hash_mux);
 	return rc;
 }
@@ -586,7 +554,7 @@ sleep:
 	return rc;
 }
 
-int ecryptfs_init_messaging(unsigned int transport)
+int ecryptfs_init_messaging(void)
 {
 	int i;
 	int rc = 0;
@@ -639,27 +607,14 @@ int ecryptfs_init_messaging(unsigned int
 		mutex_unlock(&ecryptfs_msg_ctx_arr[i].mux);
 	}
 	mutex_unlock(&ecryptfs_msg_ctx_lists_mux);
-	switch(transport) {
-	case ECRYPTFS_TRANSPORT_NETLINK:
-		rc = ecryptfs_init_netlink();
-		if (rc)
-			ecryptfs_release_messaging(transport);
-		break;
-	case ECRYPTFS_TRANSPORT_MISCDEV:
-		rc = ecryptfs_init_ecryptfs_miscdev();
-		if (rc)
-			ecryptfs_release_messaging(transport);
-		break;
-	case ECRYPTFS_TRANSPORT_CONNECTOR:
-	case ECRYPTFS_TRANSPORT_RELAYFS:
-	default:
-		rc = -ENOSYS;
-	}
+	rc = ecryptfs_init_ecryptfs_miscdev();
+	if (rc)
+		ecryptfs_release_messaging();
 out:
 	return rc;
 }
 
-void ecryptfs_release_messaging(unsigned int transport)
+void ecryptfs_release_messaging(void)
 {
 	if (ecryptfs_msg_ctx_arr) {
 		int i;
@@ -698,17 +653,6 @@ void ecryptfs_release_messaging(unsigned
 		kfree(ecryptfs_daemon_hash);
 		mutex_unlock(&ecryptfs_daemon_hash_mux);
 	}
-	switch(transport) {
-	case ECRYPTFS_TRANSPORT_NETLINK:
-		ecryptfs_release_netlink();
-		break;
-	case ECRYPTFS_TRANSPORT_MISCDEV:
-		ecryptfs_destroy_ecryptfs_miscdev();
-		break;
-	case ECRYPTFS_TRANSPORT_CONNECTOR:
-	case ECRYPTFS_TRANSPORT_RELAYFS:
-	default:
-		break;
-	}
+	ecryptfs_destroy_ecryptfs_miscdev();
 	return;
 }
diff -puN fs/ecryptfs/netlink.c~ecryptfs-remove-netlink-transport /dev/null
--- a/fs/ecryptfs/netlink.c
+++ /dev/null
@@ -1,249 +0,0 @@
-/**
- * eCryptfs: Linux filesystem encryption layer
- *
- * Copyright (C) 2004-2006 International Business Machines Corp.
- *   Author(s): Michael A. Halcrow <mhalcrow@us.ibm.com>
- *		Tyler Hicks <tyhicks@ou.edu>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License version
- * 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
- * 02111-1307, USA.
- */
-
-#include <net/sock.h>
-#include <linux/hash.h>
-#include <linux/random.h>
-#include "ecryptfs_kernel.h"
-
-static struct sock *ecryptfs_nl_sock;
-
-/**
- * ecryptfs_send_netlink
- * @data: The data to include as the payload
- * @data_len: The byte count of the data
- * @msg_ctx: The netlink context that will be used to handle the
- *          response message
- * @msg_type: The type of netlink message to send
- * @msg_flags: The flags to include in the netlink header
- * @daemon_pid: The process id of the daemon to send the message to
- *
- * Sends the data to the specified daemon pid and uses the netlink
- * context element to store the data needed for validation upon
- * receiving the response.  The data and the netlink context can be
- * null if just sending a netlink header is sufficient.  Returns zero
- * upon sending the message; non-zero upon error.
- */
-int ecryptfs_send_netlink(char *data, int data_len,
-			  struct ecryptfs_msg_ctx *msg_ctx, u8 msg_type,
-			  u16 msg_flags, struct pid *daemon_pid)
-{
-	struct sk_buff *skb;
-	struct nlmsghdr *nlh;
-	struct ecryptfs_message *msg;
-	size_t payload_len;
-	int rc;
-
-	payload_len = ((data && data_len) ? (sizeof(*msg) + data_len) : 0);
-	skb = alloc_skb(NLMSG_SPACE(payload_len), GFP_KERNEL);
-	if (!skb) {
-		rc = -ENOMEM;
-		ecryptfs_printk(KERN_ERR, "Failed to allocate socket buffer\n");
-		goto out;
-	}
-	nlh = NLMSG_PUT(skb, pid_nr(daemon_pid), msg_ctx ? msg_ctx->counter : 0,
-			msg_type, payload_len);
-	nlh->nlmsg_flags = msg_flags;
-	if (msg_ctx && payload_len) {
-		msg = (struct ecryptfs_message *)NLMSG_DATA(nlh);
-		msg->index = msg_ctx->index;
-		msg->data_len = data_len;
-		memcpy(msg->data, data, data_len);
-	}
-	rc = netlink_unicast(ecryptfs_nl_sock, skb, pid_nr(daemon_pid), 0);
-	if (rc < 0) {
-		ecryptfs_printk(KERN_ERR, "Failed to send eCryptfs netlink "
-				"message; rc = [%d]\n", rc);
-		goto out;
-	}
-	rc = 0;
-	goto out;
-nlmsg_failure:
-	rc = -EMSGSIZE;
-	kfree_skb(skb);
-out:
-	return rc;
-}
-
-/**
- * ecryptfs_process_nl_reponse
- * @skb: The socket buffer containing the netlink message of state
- *       RESPONSE
- *
- * Processes a response message after sending a operation request to
- * userspace.  Attempts to assign the msg to a netlink context element
- * at the index specified in the msg.  The sk_buff and nlmsghdr must
- * be validated before this function. Returns zero upon delivery to
- * desired context element; non-zero upon delivery failure or error.
- */
-static int ecryptfs_process_nl_response(struct sk_buff *skb)
-{
-	struct nlmsghdr *nlh = nlmsg_hdr(skb);
-	struct ecryptfs_message *msg = NLMSG_DATA(nlh);
-	struct pid *pid;
-	int rc;
-
-	if (skb->len - NLMSG_HDRLEN - sizeof(*msg) != msg->data_len) {
-		rc = -EINVAL;
-		ecryptfs_printk(KERN_ERR, "Received netlink message with "
-				"incorrectly specified data length\n");
-		goto out;
-	}
-	pid = find_get_pid(NETLINK_CREDS(skb)->pid);
-	rc = ecryptfs_process_response(msg, NETLINK_CREDS(skb)->uid, NULL,
-				       pid, nlh->nlmsg_seq);
-	put_pid(pid);
-	if (rc)
-		printk(KERN_ERR
-		       "Error processing response message; rc = [%d]\n", rc);
-out:
-	return rc;
-}
-
-/**
- * ecryptfs_process_nl_helo
- * @skb: The socket buffer containing the nlmsghdr in HELO state
- *
- * Gets uid and pid of the skb and adds the values to the daemon id
- * hash. Returns zero after adding a new daemon id to the hash list;
- * non-zero otherwise.
- */
-static int ecryptfs_process_nl_helo(struct sk_buff *skb)
-{
-	struct pid *pid;
-	int rc;
-
-	pid = find_get_pid(NETLINK_CREDS(skb)->pid);
-	rc = ecryptfs_process_helo(ECRYPTFS_TRANSPORT_NETLINK,
-				   NETLINK_CREDS(skb)->uid, NULL, pid);
-	put_pid(pid);
-	if (rc)
-		printk(KERN_WARNING "Error processing HELO; rc = [%d]\n", rc);
-	return rc;
-}
-
-/**
- * ecryptfs_process_nl_quit
- * @skb: The socket buffer containing the nlmsghdr in QUIT state
- *
- * Gets uid and pid of the skb and deletes the corresponding daemon
- * id, if it is the registered that is requesting the
- * deletion. Returns zero after deleting the desired daemon id;
- * non-zero otherwise.
- */
-static int ecryptfs_process_nl_quit(struct sk_buff *skb)
-{
-	struct pid *pid;
-	int rc;
-
-	pid = find_get_pid(NETLINK_CREDS(skb)->pid);
-	rc = ecryptfs_process_quit(NETLINK_CREDS(skb)->uid, NULL, pid);
-	put_pid(pid);
-	if (rc)
-		printk(KERN_WARNING
-		       "Error processing QUIT message; rc = [%d]\n", rc);
-	return rc;
-}
-
-/**
- * ecryptfs_receive_nl_message
- *
- * Callback function called by netlink system when a message arrives.
- * If the message looks to be valid, then an attempt is made to assign
- * it to its desired netlink context element and wake up the process
- * that is waiting for a response.
- */
-static void ecryptfs_receive_nl_message(struct sk_buff *skb)
-{
-	struct nlmsghdr *nlh;
-
-	nlh = nlmsg_hdr(skb);
-	if (!NLMSG_OK(nlh, skb->len)) {
-		ecryptfs_printk(KERN_ERR, "Received corrupt netlink "
-				"message\n");
-		goto free;
-	}
-	switch (nlh->nlmsg_type) {
-		case ECRYPTFS_MSG_RESPONSE:
-			if (ecryptfs_process_nl_response(skb)) {
-				ecryptfs_printk(KERN_WARNING, "Failed to "
-						"deliver netlink response to "
-						"requesting operation\n");
-			}
-			break;
-		case ECRYPTFS_MSG_HELO:
-			if (ecryptfs_process_nl_helo(skb)) {
-				ecryptfs_printk(KERN_WARNING, "Failed to "
-						"fulfill HELO request\n");
-			}
-			break;
-		case ECRYPTFS_MSG_QUIT:
-			if (ecryptfs_process_nl_quit(skb)) {
-				ecryptfs_printk(KERN_WARNING, "Failed to "
-						"fulfill QUIT request\n");
-			}
-			break;
-		default:
-			ecryptfs_printk(KERN_WARNING, "Dropping netlink "
-					"message of unrecognized type [%d]\n",
-					nlh->nlmsg_type);
-			break;
-	}
-free:
-	kfree_skb(skb);
-}
-
-/**
- * ecryptfs_init_netlink
- *
- * Initializes the daemon id hash list, netlink context array, and
- * necessary locks.  Returns zero upon success; non-zero upon error.
- */
-int ecryptfs_init_netlink(void)
-{
-	int rc;
-
-	ecryptfs_nl_sock = netlink_kernel_create(&init_net, NETLINK_ECRYPTFS, 0,
-						 ecryptfs_receive_nl_message,
-						 NULL, THIS_MODULE);
-	if (!ecryptfs_nl_sock) {
-		rc = -EIO;
-		ecryptfs_printk(KERN_ERR, "Failed to create netlink socket\n");
-		goto out;
-	}
-	ecryptfs_nl_sock->sk_sndtimeo = ECRYPTFS_DEFAULT_SEND_TIMEOUT;
-	rc = 0;
-out:
-	return rc;
-}
