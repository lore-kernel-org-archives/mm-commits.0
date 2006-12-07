From: akpm@osdl.org
Subject: + ecryptfs-public-key-transport-mechanism.patch added to -mm tree
Date: Thu, 07 Dec 2006 12:44:16 -0800
Message-ID: <200612072044.kB7KiINe025001@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37381 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162461AbWLGUq2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 15:46:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com, dhowells@redhat.com


The patch titled
     eCryptfs: Public key transport mechanism
has been added to the -mm tree.  Its filename is
     ecryptfs-public-key-transport-mechanism.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: Public key transport mechanism
From: Michael Halcrow <mhalcrow@us.ibm.com>

This is the transport code for public key functionality in eCryptfs.  It
manages encryption/decryption request queues with a transport mechanism. 
Currently, netlink is the only implemented transport.


Each inode has a unique File Encryption Key (FEK).  Under passphrase, a File
Encryption Key Encryption Key (FEKEK) is generated from a salt/passphrase
combo on mount.  This FEKEK encrypts each FEK and writes it into the header of
each file using the packet format specified in RFC 2440.  This is all
symmetric key encryption, so it can all be done via the kernel crypto API.

These new patches introduce public key encryption of the FEK.  There is no
asymmetric key encryption support in the kernel crypto API, so eCryptfs pushes
the FEK encryption and decryption out to a userspace daemon.  After
considering our requirements and determining the complexity of using various
transport mechanisms, we settled on netlink for this communication.

eCryptfs stores authentication tokens into the kernel keyring.  These tokens
correlate with individual keys.  For passphrase mode of operation, the
authentication token contains the symmetric FEKEK.  For public key, the
authentication token contains a PKI type and an opaque data blob managed by
individual PKI modules in userspace.

Each user who opens a file under an eCryptfs partition mounted in public key
mode must be running a daemon.  That daemon has the user's credentials and has
access to all of the keys to which the user should have access.  The daemon,
when started, initializes the pluggable PKI modules available on the system
and registers itself with the eCryptfs kernel module.  Userspace utilities
register public key authentication tokens into the user session keyring. 
These authentication tokens correlate key signatures with PKI modules and PKI
blobs.  The PKI blobs contain PKI-specific information necessary for the PKI
module to carry out asymmetric key encryption and decryption.

When the eCryptfs module parses the header of an existing file and finds a Tag
1 (Public Key) packet (see RFC 2440), it reads in the public key identifier
(signature).  The asymmetrically encrypted FEK is in the Tag 1 packet;
eCryptfs puts together a decrypt request packet containing the signature and
the encrypted FEK, then it passes it to the daemon registered for the
current->euid via a netlink unicast to the PID of the daemon, which was
registered at the time the daemon was started by the user.

The daemon actually just makes calls to libecryptfs, which implements request
packet parsing and manages PKI modules.  libecryptfs grabs the public key
authentication token for the given signature from the user session keyring. 
This auth tok tells libecryptfs which PKI module should receive the request. 
libecryptfs then makes a decrypt() call to the PKI module, and it passes along
the PKI block from the auth tok.  The PKI uses the blob to figure out how it
should decrypt the data passed to it; it performs the decryption and passes
the decrypted data back to libecryptfs.  libecryptfs then puts together a
reply packet with the decrypted FEK and passes that back to the eCryptfs
module.

The eCryptfs module manages these request callouts to userspace code via
message context structs.  The module maintains an array of message context
structs and places the elements of the array on two lists: a free and an
allocated list.  When eCryptfs wants to make a request, it moves a msg ctx
from the free list to the allocated list, sets its state to pending, and fires
off the message to the user's registered daemon.

When eCryptfs receives a netlink message (via the callback), it correlates the
msg ctx struct in the alloc list with the data in the message itself.  The
msg->index contains the offset of the array of msg ctx structs.  It verifies
that the registered daemon PID is the same as the PID of the process that sent
the message.  It also validates a sequence number between the received packet
and the msg ctx.  Then, it copies the contents of the message (the reply
packet) into the msg ctx struct, sets the state in the msg ctx to done, and
wakes up the process that was sleeping while waiting for the reply.

The sleeping process was whatever was performing the sys_open().  This process
originally called ecryptfs_send_message(); it is now in
ecryptfs_wait_for_response().  When it wakes up and sees that the msg ctx
state was set to done, it returns a pointer to the message contents (the reply
packet) and returns.  If all went well, this packet contains the decrypted
FEK, which is then copied into the crypt_stat struct, and life continues as
normal.

The case for creation of a new file is very similar, only instead of a decrypt
request, eCryptfs sends out an encrypt request.

> - We have a great clod of key mangement code in-kernel.  Why is that
>   not suitable (or growable) for public key management?

eCryptfs uses Howells' keyring to store persistent key data and PKI state
information.  It defers public key cryptographic transformations to userspace
code.  The userspace data manipulation request really is orthogonal to key
management in and of itself.  What eCryptfs basically needs is a secure way to
communicate with a particular daemon for a particular task doing a syscall,
based on the UID.  Nothing running under another UID should be able to access
that channel of communication.

> - Is it appropriate that new infrastructure for public key
> management be private to a particular fs?

The messaging.c file contains a lot of code that, perhaps, could be extracted
into a separate kernel service.  In essence, this would be a sort of
request/reply mechanism that would involve a userspace daemon.  I am not aware
of anything that does quite what eCryptfs does, so I was not aware of any
existing tools to do just what we wanted.

>   What happens if one of these daemons exits without sending a quit
>   message?

There is a stale uid<->pid association in the hash table for that user.  When
the user registers a new daemon, eCryptfs cleans up the old association and
generates a new one.  See ecryptfs_process_helo().

> - _why_ does it use netlink?

Netlink provides the transport mechanism that would minimize the complexity of
the implementation, given that we can have multiple daemons (one per user).  I
explored the possibility of using relayfs, but that would involve having to
introduce control channels and a protocol for creating and tearing down
channels for the daemons.  We do not have to worry about any of that with
netlink.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ecryptfs/ecryptfs_kernel.h |  101 ++++++
 fs/ecryptfs/messaging.c       |  505 ++++++++++++++++++++++++++++++++
 fs/ecryptfs/netlink.c         |  255 ++++++++++++++++
 include/linux/netlink.h       |    1 
 4 files changed, 859 insertions(+), 3 deletions(-)

diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-public-key-transport-mechanism fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-public-key-transport-mechanism
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -6,6 +6,8 @@
  * Copyright (C) 2001-2003 Stony Brook University
  * Copyright (C) 2004-2006 International Business Machines Corp.
  *   Author(s): Michael A. Halcrow <mahalcro@us.ibm.com>
+ *              Trevor S. Highland <trevor.highland@gmail.com>
+ *              Tyler Hicks <tyhicks@ou.edu>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
@@ -33,7 +35,7 @@
 /* Version verification for shared data structures w/ userspace */
 #define ECRYPTFS_VERSION_MAJOR 0x00
 #define ECRYPTFS_VERSION_MINOR 0x04
-#define ECRYPTFS_SUPPORTED_FILE_VERSION 0x01
+#define ECRYPTFS_SUPPORTED_FILE_VERSION 0x02
 /* These flags indicate which features are supported by the kernel
  * module; userspace tools such as the mount helper read
  * ECRYPTFS_VERSIONING_MASK from a sysfs handle in order to determine
@@ -58,10 +60,24 @@
 #define ECRYPTFS_MAX_KEY_BYTES 64
 #define ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES 512
 #define ECRYPTFS_DEFAULT_IV_BYTES 16
-#define ECRYPTFS_FILE_VERSION 0x01
+#define ECRYPTFS_FILE_VERSION 0x02
 #define ECRYPTFS_DEFAULT_HEADER_EXTENT_SIZE 8192
 #define ECRYPTFS_DEFAULT_EXTENT_SIZE 4096
 #define ECRYPTFS_MINIMUM_HEADER_EXTENT_SIZE 8192
+#define ECRYPTFS_DEFAULT_MSG_CTX_ELEMS 32
+#define ECRYPTFS_DEFAULT_SEND_TIMEOUT HZ
+#define ECRYPTFS_MAX_MSG_CTX_TTL (HZ*3)
+#define ECRYPTFS_NLMSG_HELO 100
+#define ECRYPTFS_NLMSG_QUIT 101
+#define ECRYPTFS_NLMSG_REQUEST 102
+#define ECRYPTFS_NLMSG_RESPONSE 103
+#define ECRYPTFS_MAX_PKI_NAME_BYTES 16
+#define ECRYPTFS_DEFAULT_NUM_USERS 4
+#define ECRYPTFS_MAX_NUM_USERS 32768
+#define ECRYPTFS_TRANSPORT_NETLINK 0
+#define ECRYPTFS_TRANSPORT_CONNECTOR 1
+#define ECRYPTFS_TRANSPORT_RELAYFS 2
+#define ECRYPTFS_DEFAULT_TRANSPORT ECRYPTFS_TRANSPORT_NETLINK
 
 #define RFC2440_CIPHER_DES3_EDE 0x02
 #define RFC2440_CIPHER_CAST_5 0x03
@@ -75,6 +91,7 @@
 #define ECRYPTFS_SET_FLAG(flag_bit_vector, flag) (flag_bit_vector |= (flag))
 #define ECRYPTFS_CLEAR_FLAG(flag_bit_vector, flag) (flag_bit_vector &= ~(flag))
 #define ECRYPTFS_CHECK_FLAG(flag_bit_vector, flag) (flag_bit_vector & (flag))
+#define RFC2440_CIPHER_RSA 0x01
 
 /**
  * For convenience, we may need to pass around the encrypted session
@@ -112,6 +129,14 @@ struct ecryptfs_password {
 
 enum ecryptfs_token_types {ECRYPTFS_PASSWORD, ECRYPTFS_PRIVATE_KEY};
 
+struct ecryptfs_private_key {
+	u32 key_size;
+	u32 data_len;
+	u8 signature[ECRYPTFS_PASSWORD_SIG_SIZE + 1];
+	char pki_type[ECRYPTFS_MAX_PKI_NAME_BYTES + 1];
+	u8 data[];
+};
+
 /* May be a password or a private key */
 struct ecryptfs_auth_tok {
 	u16 version; /* 8-bit major and 8-bit minor */
@@ -121,7 +146,7 @@ struct ecryptfs_auth_tok {
 	u8 reserved[32];
 	union {
 		struct ecryptfs_password password;
-		/* Private key is in future eCryptfs releases */
+		struct ecryptfs_private_key private_key;
 	} token;
 } __attribute__ ((packed));
 
@@ -176,8 +201,13 @@ ecryptfs_get_key_payload_data(struct key
 #define ECRYPTFS_DEFAULT_KEY_BYTES 16
 #define ECRYPTFS_DEFAULT_CHAINING_MODE CRYPTO_TFM_MODE_CBC
 #define ECRYPTFS_DEFAULT_HASH "md5"
+#define ECRYPTFS_TAG_1_PACKET_TYPE 0x01
 #define ECRYPTFS_TAG_3_PACKET_TYPE 0x8C
 #define ECRYPTFS_TAG_11_PACKET_TYPE 0xED
+#define ECRYPTFS_TAG_64_PACKET_TYPE 0x40
+#define ECRYPTFS_TAG_65_PACKET_TYPE 0x41
+#define ECRYPTFS_TAG_66_PACKET_TYPE 0x42
+#define ECRYPTFS_TAG_67_PACKET_TYPE 0x43
 #define MD5_DIGEST_SIZE 16
 
 /**
@@ -271,6 +301,45 @@ struct ecryptfs_auth_tok_list_item {
 	struct ecryptfs_auth_tok auth_tok;
 };
 
+struct ecryptfs_message {
+	u32 index;
+	u32 data_len;
+	u8 data[];
+};
+
+struct ecryptfs_msg_ctx {
+#define ECRYPTFS_MSG_CTX_STATE_FREE      0x0001
+#define ECRYPTFS_MSG_CTX_STATE_PENDING   0x0002
+#define ECRYPTFS_MSG_CTX_STATE_DONE      0x0003
+	u32 state;
+	unsigned int index;
+	unsigned int counter;
+	struct ecryptfs_message *msg;
+	struct task_struct *task;
+	struct list_head node;
+	struct mutex mux;
+};
+
+extern struct list_head ecryptfs_msg_ctx_free_list;
+extern struct list_head ecryptfs_msg_ctx_alloc_list;
+extern struct mutex ecryptfs_msg_ctx_lists_mux;
+
+#define ecryptfs_uid_hash(uid) \
+        hash_long((unsigned long)uid, ecryptfs_hash_buckets)
+extern struct hlist_head *ecryptfs_daemon_id_hash;
+extern struct mutex ecryptfs_daemon_id_hash_mux;
+extern int ecryptfs_hash_buckets;
+
+extern unsigned int ecryptfs_msg_counter;
+extern struct ecryptfs_msg_ctx *ecryptfs_msg_ctx_arr;
+extern unsigned int ecryptfs_transport;
+
+struct ecryptfs_daemon_id {
+	pid_t pid;
+	uid_t uid;
+	struct hlist_node id_chain;
+};
+
 static inline struct ecryptfs_file_info *
 ecryptfs_file_to_private(struct file *file)
 {
@@ -391,6 +460,9 @@ extern struct super_operations ecryptfs_
 extern struct dentry_operations ecryptfs_dops;
 extern struct address_space_operations ecryptfs_aops;
 extern int ecryptfs_verbosity;
+extern unsigned int ecryptfs_message_buf_len;
+extern signed long ecryptfs_message_wait_timeout;
+extern unsigned int ecryptfs_number_of_users;
 
 extern struct kmem_cache *ecryptfs_auth_tok_list_item_cache;
 extern struct kmem_cache *ecryptfs_file_info_cache;
@@ -487,4 +559,27 @@ int ecryptfs_open_lower_file(struct file
 			     struct vfsmount *lower_mnt, int flags);
 int ecryptfs_close_lower_file(struct file *lower_file);
 
+int ecryptfs_process_helo(unsigned int transport, uid_t uid, pid_t pid);
+int ecryptfs_process_quit(uid_t uid, pid_t pid);
+int ecryptfs_process_response(struct ecryptfs_message *msg, pid_t pid, u32 seq);
+int ecryptfs_send_message(unsigned int transport, char *data, int data_len,
+			  struct ecryptfs_msg_ctx **msg_ctx);
+int ecryptfs_wait_for_response(struct ecryptfs_msg_ctx *msg_ctx,
+			       struct ecryptfs_message **emsg);
+int ecryptfs_init_messaging(unsigned int transport);
+void ecryptfs_release_messaging(unsigned int transport);
+
+int ecryptfs_send_netlink(char *data, int data_len,
+			  struct ecryptfs_msg_ctx *msg_ctx, u16 msg_type,
+			  u16 msg_flags, pid_t daemon_pid);
+int ecryptfs_init_netlink(void);
+void ecryptfs_release_netlink(void);
+
+int ecryptfs_send_connector(char *data, int data_len,
+			    struct ecryptfs_msg_ctx *msg_ctx, u16 msg_type,
+			    u16 msg_flags, pid_t daemon_pid);
+int ecryptfs_init_connector(void);
+void ecryptfs_release_connector(void);
+
+
 #endif /* #ifndef ECRYPTFS_KERNEL_H */
diff -puN /dev/null fs/ecryptfs/messaging.c
--- /dev/null
+++ a/fs/ecryptfs/messaging.c
@@ -0,0 +1,505 @@
+/**
+ * eCryptfs: Linux filesystem encryption layer
+ *
+ * Copyright (C) 2004-2006 International Business Machines Corp.
+ *   Author(s): Michael A. Halcrow <mhalcrow@us.ibm.com>
+ *		Tyler Hicks <tyhicks@ou.edu>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
+ * 02111-1307, USA.
+ */
+
+#include "ecryptfs_kernel.h"
+
+LIST_HEAD(ecryptfs_msg_ctx_free_list);
+LIST_HEAD(ecryptfs_msg_ctx_alloc_list);
+struct mutex ecryptfs_msg_ctx_lists_mux;
+
+struct hlist_head *ecryptfs_daemon_id_hash;
+struct mutex ecryptfs_daemon_id_hash_mux;
+int ecryptfs_hash_buckets;
+
+unsigned int ecryptfs_msg_counter;
+struct ecryptfs_msg_ctx *ecryptfs_msg_ctx_arr;
+
+/**
+ * ecryptfs_acquire_free_msg_ctx
+ * @msg_ctx: The context that was acquired from the free list
+ *
+ * Acquires a context element from the free list and locks the mutex
+ * on the context.  Returns zero on success; non-zero on error or upon
+ * failure to acquire a free context element.  Be sure to lock the
+ * list mutex before calling.
+ */
+static int ecryptfs_acquire_free_msg_ctx(struct ecryptfs_msg_ctx **msg_ctx)
+{
+	struct list_head *p;
+	int rc;
+
+	if (list_empty(&ecryptfs_msg_ctx_free_list)) {
+		ecryptfs_printk(KERN_WARNING, "The eCryptfs free "
+				"context list is empty.  It may be helpful to "
+				"specify the ecryptfs_message_buf_len "
+				"parameter to be greater than the current "
+				"value of [%d]\n", ecryptfs_message_buf_len);
+		rc = -ENOMEM;
+		goto out;
+	}
+	list_for_each(p, &ecryptfs_msg_ctx_free_list) {
+		*msg_ctx = list_entry(p, struct ecryptfs_msg_ctx, node);
+		if (mutex_trylock(&(*msg_ctx)->mux)) {
+			(*msg_ctx)->task = current;
+			rc = 0;
+			goto out;
+		}
+	}
+	rc = -ENOMEM;
+out:
+	return rc;
+}
+
+/**
+ * ecryptfs_msg_ctx_free_to_alloc
+ * @msg_ctx: The context to move from the free list to the alloc list
+ *
+ * Be sure to lock the list mutex and the context mutex before
+ * calling.
+ */
+static void ecryptfs_msg_ctx_free_to_alloc(struct ecryptfs_msg_ctx *msg_ctx)
+{
+	list_move(&msg_ctx->node, &ecryptfs_msg_ctx_alloc_list);
+	msg_ctx->state = ECRYPTFS_MSG_CTX_STATE_PENDING;
+	msg_ctx->counter = ++ecryptfs_msg_counter;
+}
+
+/**
+ * ecryptfs_msg_ctx_alloc_to_free
+ * @msg_ctx: The context to move from the alloc list to the free list
+ *
+ * Be sure to lock the list mutex and the context mutex before
+ * calling.
+ */
+static void ecryptfs_msg_ctx_alloc_to_free(struct ecryptfs_msg_ctx *msg_ctx)
+{
+	list_move(&(msg_ctx->node), &ecryptfs_msg_ctx_free_list);
+	if (msg_ctx->msg)
+		kfree(msg_ctx->msg);
+	msg_ctx->state = ECRYPTFS_MSG_CTX_STATE_FREE;
+}
+
+/**
+ * ecryptfs_find_daemon_id
+ * @uid: The user id which maps to the desired daemon id
+ * @id: If return value is zero, points to the desired daemon id
+ *      pointer
+ *
+ * Search the hash list for the given user id.  Returns zero if the
+ * user id exists in the list; non-zero otherwise.  The daemon id hash
+ * mutex should be held before calling this function.
+ */
+static int ecryptfs_find_daemon_id(uid_t uid, struct ecryptfs_daemon_id **id)
+{
+	struct hlist_node *elem;
+	int rc;
+
+	hlist_for_each_entry(*id, elem,
+			     &ecryptfs_daemon_id_hash[ecryptfs_uid_hash(uid)],
+			     id_chain) {
+		if ((*id)->uid == uid) {
+			rc = 0;
+			goto out;
+		}
+	}
+	rc = -EINVAL;
+out:
+	return rc;
+}
+
+static int ecryptfs_send_raw_message(unsigned int transport, u16 msg_type,
+				     pid_t pid)
+{
+	int rc;
+
+	switch(transport) {
+	case ECRYPTFS_TRANSPORT_NETLINK:
+		rc = ecryptfs_send_netlink(NULL, 0, NULL, msg_type, 0, pid);
+		break;
+	case ECRYPTFS_TRANSPORT_CONNECTOR:
+	case ECRYPTFS_TRANSPORT_RELAYFS:
+	default:
+		rc = -ENOSYS;
+	}
+	return rc;
+}
+
+/**
+ * ecryptfs_process_helo
+ * @transport: The underlying transport (netlink, etc.)
+ * @uid: The user ID owner of the message
+ * @pid: The process ID for the userspace program that sent the
+ *       message
+ *
+ * Adds the uid and pid values to the daemon id hash.  If a uid
+ * already has a daemon pid registered, the daemon will be
+ * unregistered before the new daemon id is put into the hash list.
+ * Returns zero after adding a new daemon id to the hash list;
+ * non-zero otherwise.
+ */
+int ecryptfs_process_helo(unsigned int transport, uid_t uid, pid_t pid)
+{
+	struct ecryptfs_daemon_id *new_id;
+	struct ecryptfs_daemon_id *old_id;
+	int rc;
+
+	mutex_lock(&ecryptfs_daemon_id_hash_mux);
+	new_id = kmalloc(sizeof(*new_id), GFP_KERNEL);
+	if (!new_id) {
+		rc = -ENOMEM;
+		ecryptfs_printk(KERN_ERR, "Failed to allocate memory; unable "
+				"to register daemon [%d] for user\n", pid, uid);
+		goto unlock;
+	}
+	if (!ecryptfs_find_daemon_id(uid, &old_id)) {
+		printk(KERN_WARNING "Received request from user [%d] "
+		       "to register daemon [%d]; unregistering daemon "
+		       "[%d]\n", uid, pid, old_id->pid);
+		hlist_del(&old_id->id_chain);
+		rc = ecryptfs_send_raw_message(transport, ECRYPTFS_NLMSG_QUIT,
+					       old_id->pid);
+		if (rc)
+			printk(KERN_WARNING "Failed to send QUIT "
+			       "message to daemon [%d]; rc = [%d]\n",
+			       old_id->pid, rc);
+		kfree(old_id);
+	}
+	new_id->uid = uid;
+	new_id->pid = pid;
+	hlist_add_head(&new_id->id_chain,
+		       &ecryptfs_daemon_id_hash[ecryptfs_uid_hash(uid)]);
+	rc = 0;
+unlock:
+	mutex_unlock(&ecryptfs_daemon_id_hash_mux);
+	return rc;
+}
+
+/**
+ * ecryptfs_process_quit
+ * @uid: The user ID owner of the message
+ * @pid: The process ID for the userspace program that sent the
+ *       message
+ *
+ * Deletes the corresponding daemon id for the given uid and pid, if
+ * it is the registered that is requesting the deletion. Returns zero
+ * after deleting the desired daemon id; non-zero otherwise.
+ */
+int ecryptfs_process_quit(uid_t uid, pid_t pid)
+{
+	struct ecryptfs_daemon_id *id;
+	int rc;
+
+	mutex_lock(&ecryptfs_daemon_id_hash_mux);
+	if (ecryptfs_find_daemon_id(uid, &id)) {
+		rc = -EINVAL;
+		ecryptfs_printk(KERN_ERR, "Received request from user [%d] to "
+				"unregister unrecognized daemon [%d]\n", uid,
+				pid);
+		goto unlock;
+	}
+	if (id->pid != pid) {
+		rc = -EINVAL;
+		ecryptfs_printk(KERN_WARNING, "Received request from user [%d] "
+				"with pid [%d] to unregister daemon [%d]\n",
+				uid, pid, id->pid);
+		goto unlock;
+	}
+	hlist_del(&id->id_chain);
+	kfree(id);
+	rc = 0;
+unlock:
+	mutex_unlock(&ecryptfs_daemon_id_hash_mux);
+	return rc;
+}
+
+/**
+ * ecryptfs_process_reponse
+ * @msg: The ecryptfs message received; the caller should sanity check
+ *       msg->data_len
+ * @pid: The process ID of the userspace application that sent the
+ *       message
+ * @seq: The sequence number of the message
+ *
+ * Processes a response message after sending a operation request to
+ * userspace. Returns zero upon delivery to desired context element;
+ * non-zero upon delivery failure or error.
+ */
+int ecryptfs_process_response(struct ecryptfs_message *msg, pid_t pid, u32 seq)
+{
+	struct ecryptfs_daemon_id *id;
+	struct ecryptfs_msg_ctx *msg_ctx;
+	int msg_size;
+	int rc;
+
+	if (msg->index >= ecryptfs_message_buf_len) {
+		rc = -EINVAL;
+		ecryptfs_printk(KERN_ERR, "Attempt to reference "
+				"context buffer at index [%d]; maximum "
+				"allowable is [%d]\n", msg->index,
+				(ecryptfs_message_buf_len - 1));
+		goto out;
+	}
+	msg_ctx = &ecryptfs_msg_ctx_arr[msg->index];
+	mutex_lock(&msg_ctx->mux);
+	if (ecryptfs_find_daemon_id(msg_ctx->task->euid, &id)) {
+		rc = -EBADMSG;
+		ecryptfs_printk(KERN_WARNING, "User [%d] received a "
+				"message response from process [%d] but does "
+				"not have a registered daemon\n",
+				msg_ctx->task->euid, pid);
+		goto wake_up;
+	}
+	if (id->pid != pid) {
+		rc = -EBADMSG;
+		ecryptfs_printk(KERN_ERR, "User [%d] received a "
+				"message response from an unrecognized "
+				"process [%d]\n", msg_ctx->task->euid, pid);
+		goto unlock;
+	}
+	if (msg_ctx->state != ECRYPTFS_MSG_CTX_STATE_PENDING) {
+		rc = -EINVAL;
+		ecryptfs_printk(KERN_WARNING, "Desired context element is not "
+				"pending a response\n");
+		goto unlock;
+	} else if (msg_ctx->counter != seq) {
+		rc = -EINVAL;
+		ecryptfs_printk(KERN_WARNING, "Invalid message sequence; "
+				"expected [%d]; received [%d]\n",
+				msg_ctx->counter, seq);
+		goto unlock;
+	}
+	msg_size = sizeof(*msg) + msg->data_len;
+	msg_ctx->msg = kmalloc(msg_size, GFP_KERNEL);
+	if (!msg_ctx->msg) {
+		rc = -ENOMEM;
+		ecryptfs_printk(KERN_ERR, "Failed to allocate memory\n");
+		goto unlock;
+	}
+	memcpy(msg_ctx->msg, msg, msg_size);
+	msg_ctx->state = ECRYPTFS_MSG_CTX_STATE_DONE;
+	rc = 0;
+wake_up:
+	wake_up_process(msg_ctx->task);
+unlock:
+	mutex_unlock(&msg_ctx->mux);
+out:
+	return rc;
+}
+
+/**
+ * ecryptfs_send_message
+ * @transport: The transport over which to send the message (i.e.,
+ *             netlink)
+ * @data: The data to send
+ * @data_len: The length of data
+ * @msg_ctx: The message context allocated for the send
+ */
+int ecryptfs_send_message(unsigned int transport, char *data, int data_len,
+			  struct ecryptfs_msg_ctx **msg_ctx)
+{
+	struct ecryptfs_daemon_id *id;
+	int rc;
+
+	mutex_lock(&ecryptfs_daemon_id_hash_mux);
+	if (ecryptfs_find_daemon_id(current->euid, &id)) {
+		mutex_unlock(&ecryptfs_daemon_id_hash_mux);
+		rc = -ENOTCONN;
+		ecryptfs_printk(KERN_ERR, "User [%d] does not have a daemon "
+				"registered\n", current->euid);
+		goto out;
+	}
+	mutex_unlock(&ecryptfs_daemon_id_hash_mux);
+	mutex_lock(&ecryptfs_msg_ctx_lists_mux);
+	rc = ecryptfs_acquire_free_msg_ctx(msg_ctx);
+	if (rc) {
+		mutex_unlock(&ecryptfs_msg_ctx_lists_mux);
+		ecryptfs_printk(KERN_WARNING, "Could not claim a free "
+				"context element\n");
+		goto out;
+	}
+	ecryptfs_msg_ctx_free_to_alloc(*msg_ctx);
+	mutex_unlock(&(*msg_ctx)->mux);
+	mutex_unlock(&ecryptfs_msg_ctx_lists_mux);
+	switch (transport) {
+	case ECRYPTFS_TRANSPORT_NETLINK:
+		rc = ecryptfs_send_netlink(data, data_len, *msg_ctx,
+					   ECRYPTFS_NLMSG_REQUEST, 0, id->pid);
+		break;
+	case ECRYPTFS_TRANSPORT_CONNECTOR:
+	case ECRYPTFS_TRANSPORT_RELAYFS:
+	default:
+		rc = -ENOSYS;
+	}
+	if (rc) {
+		printk(KERN_ERR "Error attempting to send message to userspace "
+		       "daemon; rc = [%d]\n", rc);
+	}
+out:
+	return rc;
+}
+
+/**
+ * ecryptfs_wait_for_response
+ * @msg_ctx: The context that was assigned when sending a message
+ * @msg: The incoming message from userspace; not set if rc != 0
+ *
+ * Sleeps until awaken by ecryptfs_receive_message or until the amount
+ * of time exceeds ecryptfs_message_wait_timeout.  If zero is
+ * returned, msg will point to a valid message from userspace; a
+ * non-zero value is returned upon failure to receive a message or an
+ * error occurs.
+ */
+int ecryptfs_wait_for_response(struct ecryptfs_msg_ctx *msg_ctx,
+			       struct ecryptfs_message **msg)
+{
+	signed long timeout = ecryptfs_message_wait_timeout * HZ;
+	int rc = 0;
+
+sleep:
+	timeout = schedule_timeout_interruptible(timeout);
+	mutex_lock(&ecryptfs_msg_ctx_lists_mux);
+	mutex_lock(&msg_ctx->mux);
+	if (msg_ctx->state != ECRYPTFS_MSG_CTX_STATE_DONE) {
+		if (timeout) {
+			mutex_unlock(&msg_ctx->mux);
+			mutex_unlock(&ecryptfs_msg_ctx_lists_mux);
+			goto sleep;
+		}
+		rc = -ENOMSG;
+	} else {
+		*msg = msg_ctx->msg;
+		msg_ctx->msg = NULL;
+	}
+	ecryptfs_msg_ctx_alloc_to_free(msg_ctx);
+	mutex_unlock(&msg_ctx->mux);
+	mutex_unlock(&ecryptfs_msg_ctx_lists_mux);
+	return rc;
+}
+
+int ecryptfs_init_messaging(unsigned int transport)
+{
+	int i;
+	int rc = 0;
+
+	if (ecryptfs_number_of_users > ECRYPTFS_MAX_NUM_USERS) {
+		ecryptfs_number_of_users = ECRYPTFS_MAX_NUM_USERS;
+		ecryptfs_printk(KERN_WARNING, "Specified number of users is "
+				"too large, defaulting to [%d] users\n",
+				ecryptfs_number_of_users);
+	}
+	mutex_init(&ecryptfs_daemon_id_hash_mux);
+	mutex_lock(&ecryptfs_daemon_id_hash_mux);
+	ecryptfs_hash_buckets = 0;
+	while (ecryptfs_number_of_users >> ++ecryptfs_hash_buckets);
+	ecryptfs_daemon_id_hash = kmalloc(sizeof(struct hlist_head)
+					  * ecryptfs_hash_buckets, GFP_KERNEL);
+	if (!ecryptfs_daemon_id_hash) {
+		rc = -ENOMEM;
+		ecryptfs_printk(KERN_ERR, "Failed to allocate memory\n");
+		goto out;
+	}
+	for (i = 0; i < ecryptfs_hash_buckets; i++)
+		INIT_HLIST_HEAD(&ecryptfs_daemon_id_hash[i]);
+	mutex_unlock(&ecryptfs_daemon_id_hash_mux);
+
+	ecryptfs_msg_ctx_arr = kmalloc((sizeof(struct ecryptfs_msg_ctx)
+				      * ecryptfs_message_buf_len), GFP_KERNEL);
+	if (!ecryptfs_msg_ctx_arr) {
+		rc = -ENOMEM;
+		ecryptfs_printk(KERN_ERR, "Failed to allocate memory\n");
+		goto out;
+	}
+	mutex_init(&ecryptfs_msg_ctx_lists_mux);
+	mutex_lock(&ecryptfs_msg_ctx_lists_mux);
+	ecryptfs_msg_counter = 0;
+	for (i = 0; i < ecryptfs_message_buf_len; i++) {
+		INIT_LIST_HEAD(&ecryptfs_msg_ctx_arr[i].node);
+		mutex_init(&ecryptfs_msg_ctx_arr[i].mux);
+		mutex_lock(&ecryptfs_msg_ctx_arr[i].mux);
+		ecryptfs_msg_ctx_arr[i].index = i;
+		ecryptfs_msg_ctx_arr[i].state = ECRYPTFS_MSG_CTX_STATE_FREE;
+		ecryptfs_msg_ctx_arr[i].counter = 0;
+		ecryptfs_msg_ctx_arr[i].task = NULL;
+		ecryptfs_msg_ctx_arr[i].msg = NULL;
+		list_add_tail(&ecryptfs_msg_ctx_arr[i].node,
+			      &ecryptfs_msg_ctx_free_list);
+		mutex_unlock(&ecryptfs_msg_ctx_arr[i].mux);
+	}
+	mutex_unlock(&ecryptfs_msg_ctx_lists_mux);
+	switch(transport) {
+	case ECRYPTFS_TRANSPORT_NETLINK:
+		rc = ecryptfs_init_netlink();
+		if (rc)
+			ecryptfs_release_messaging(transport);
+		break;
+	case ECRYPTFS_TRANSPORT_CONNECTOR:
+	case ECRYPTFS_TRANSPORT_RELAYFS:
+	default:
+		rc = -ENOSYS;
+	}
+out:
+	return rc;
+}
+
+void ecryptfs_release_messaging(unsigned int transport)
+{
+	if (ecryptfs_msg_ctx_arr) {
+		int i;
+
+		mutex_lock(&ecryptfs_msg_ctx_lists_mux);
+		for (i = 0; i < ecryptfs_message_buf_len; i++) {
+			mutex_lock(&ecryptfs_msg_ctx_arr[i].mux);
+			if (ecryptfs_msg_ctx_arr[i].msg)
+				kfree(ecryptfs_msg_ctx_arr[i].msg);
+			mutex_unlock(&ecryptfs_msg_ctx_arr[i].mux);
+		}
+		kfree(ecryptfs_msg_ctx_arr);
+		mutex_unlock(&ecryptfs_msg_ctx_lists_mux);
+	}
+	if (ecryptfs_daemon_id_hash) {
+		struct hlist_node *elem;
+		struct ecryptfs_daemon_id *id;
+		int i;
+
+		mutex_lock(&ecryptfs_daemon_id_hash_mux);
+		for (i = 0; i < ecryptfs_hash_buckets; i++) {
+			hlist_for_each_entry(id, elem,
+					     &ecryptfs_daemon_id_hash[i],
+					     id_chain) {
+				hlist_del(elem);
+				kfree(id);
+			}
+		}
+		kfree(ecryptfs_daemon_id_hash);
+		mutex_unlock(&ecryptfs_daemon_id_hash_mux);
+	}
+	switch(transport) {
+	case ECRYPTFS_TRANSPORT_NETLINK:
+		ecryptfs_release_netlink();
+		break;
+	case ECRYPTFS_TRANSPORT_CONNECTOR:
+	case ECRYPTFS_TRANSPORT_RELAYFS:
+	default:
+		break;
+	}
+	return;
+}
diff -puN /dev/null fs/ecryptfs/netlink.c
--- /dev/null
+++ a/fs/ecryptfs/netlink.c
@@ -0,0 +1,255 @@
+/**
+ * eCryptfs: Linux filesystem encryption layer
+ *
+ * Copyright (C) 2004-2006 International Business Machines Corp.
+ *   Author(s): Michael A. Halcrow <mhalcrow@us.ibm.com>
+ *		Tyler Hicks <tyhicks@ou.edu>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
+ * 02111-1307, USA.
+ */
+
+#include <net/sock.h>
+#include <linux/hash.h>
+#include <linux/random.h>
+#include "ecryptfs_kernel.h"
+
+static struct sock *ecryptfs_nl_sock;
+
+/**
+ * ecryptfs_send_netlink
+ * @data: The data to include as the payload
+ * @data_len: The byte count of the data
+ * @msg_ctx: The netlink context that will be used to handle the
+ *          response message
+ * @msg_type: The type of netlink message to send
+ * @msg_flags: The flags to include in the netlink header
+ * @daemon_pid: The process id of the daemon to send the message to
+ *
+ * Sends the data to the specified daemon pid and uses the netlink
+ * context element to store the data needed for validation upon
+ * receiving the response.  The data and the netlink context can be
+ * null if just sending a netlink header is sufficient.  Returns zero
+ * upon sending the message; non-zero upon error.
+ */
+int ecryptfs_send_netlink(char *data, int data_len,
+			  struct ecryptfs_msg_ctx *msg_ctx, u16 msg_type,
+			  u16 msg_flags, pid_t daemon_pid)
+{
+	struct sk_buff *skb;
+	struct nlmsghdr *nlh;
+	struct ecryptfs_message *msg;
+	size_t payload_len;
+	int rc;
+
+	payload_len = ((data && data_len) ? (sizeof(*msg) + data_len) : 0);
+	skb = alloc_skb(NLMSG_SPACE(payload_len), GFP_KERNEL);
+	if (!skb) {
+		rc = -ENOMEM;
+		ecryptfs_printk(KERN_ERR, "Failed to allocate socket buffer\n");
+		goto out;
+	}
+	nlh = NLMSG_PUT(skb, daemon_pid, msg_ctx ? msg_ctx->counter : 0,
+			msg_type, payload_len);
+	nlh->nlmsg_flags = msg_flags;
+	if (msg_ctx && payload_len) {
+		msg = (struct ecryptfs_message *)NLMSG_DATA(nlh);
+		msg->index = msg_ctx->index;
+		msg->data_len = data_len;
+		memcpy(msg->data, data, data_len);
+	}
+	rc = netlink_unicast(ecryptfs_nl_sock, skb, daemon_pid, 0);
+	if (rc < 0) {
+		ecryptfs_printk(KERN_ERR, "Failed to send eCryptfs netlink "
+				"message; rc = [%d]\n", rc);
+		goto out;
+	}
+	rc = 0;
+	goto out;
+nlmsg_failure:
+	rc = -EMSGSIZE;
+	kfree_skb(skb);
+out:
+	return rc;
+}
+
+/**
+ * ecryptfs_process_nl_reponse
+ * @skb: The socket buffer containing the netlink message of state
+ *       RESPONSE
+ *
+ * Processes a response message after sending a operation request to
+ * userspace.  Attempts to assign the msg to a netlink context element
+ * at the index specified in the msg.  The sk_buff and nlmsghdr must
+ * be validated before this function. Returns zero upon delivery to
+ * desired context element; non-zero upon delivery failure or error.
+ */
+static int ecryptfs_process_nl_response(struct sk_buff *skb)
+{
+	struct nlmsghdr *nlh = (struct nlmsghdr*)skb->data;
+	struct ecryptfs_message *msg = NLMSG_DATA(nlh);
+	int rc;
+
+	if (skb->len - NLMSG_HDRLEN - sizeof(*msg) != msg->data_len) {
+		rc = -EINVAL;
+		ecryptfs_printk(KERN_ERR, "Received netlink message with "
+				"incorrectly specified data length\n");
+		goto out;
+	}
+	rc = ecryptfs_process_response(msg, NETLINK_CREDS(skb)->pid,
+				       nlh->nlmsg_seq);
+	if (rc)
+		printk(KERN_ERR
+		       "Error processing response message; rc = [%d]\n", rc);
+out:
+	return rc;
+}
+
+/**
+ * ecryptfs_process_nl_helo
+ * @skb: The socket buffer containing the nlmsghdr in HELO state
+ *
+ * Gets uid and pid of the skb and adds the values to the daemon id
+ * hash. Returns zero after adding a new daemon id to the hash list;
+ * non-zero otherwise.
+ */
+static int ecryptfs_process_nl_helo(struct sk_buff *skb)
+{
+	int rc;
+
+	rc = ecryptfs_process_helo(ECRYPTFS_TRANSPORT_NETLINK,
+				   NETLINK_CREDS(skb)->uid,
+				   NETLINK_CREDS(skb)->pid);
+	if (rc)
+		printk(KERN_WARNING "Error processing HELO; rc = [%d]\n", rc);
+	return rc;
+}
+
+/**
+ * ecryptfs_process_nl_quit
+ * @skb: The socket buffer containing the nlmsghdr in QUIT state
+ *
+ * Gets uid and pid of the skb and deletes the corresponding daemon
+ * id, if it is the registered that is requesting the
+ * deletion. Returns zero after deleting the desired daemon id;
+ * non-zero otherwise.
+ */
+static int ecryptfs_process_nl_quit(struct sk_buff *skb)
+{
+	int rc;
+
+	rc = ecryptfs_process_quit(NETLINK_CREDS(skb)->uid,
+				   NETLINK_CREDS(skb)->pid);
+	if (rc)
+		printk(KERN_WARNING
+		       "Error processing QUIT message; rc = [%d]\n", rc);
+	return rc;
+}
+
+/**
+ * ecryptfs_receive_nl_message
+ *
+ * Callback function called by netlink system when a message arrives.
+ * If the message looks to be valid, then an attempt is made to assign
+ * it to its desired netlink context element and wake up the process
+ * that is waiting for a response.
+ */
+static void ecryptfs_receive_nl_message(struct sock *sk, int len)
+{
+	struct sk_buff *skb;
+	struct nlmsghdr *nlh;
+	int rc = 0;	/* skb_recv_datagram requires this */
+
+receive:
+	skb = skb_recv_datagram(sk, 0, 0, &rc);
+	if (rc == -EINTR)
+		goto receive;
+	else if (rc < 0) {
+		ecryptfs_printk(KERN_ERR, "Error occurred while "
+				"receiving eCryptfs netlink message; "
+				"rc = [%d]\n", rc);
+		return;
+	}
+	nlh = (struct nlmsghdr *)skb->data;
+	if (!NLMSG_OK(nlh, skb->len)) {
+		ecryptfs_printk(KERN_ERR, "Received corrupt netlink "
+				"message\n");
+		goto free;
+	}
+	switch (nlh->nlmsg_type) {
+		case ECRYPTFS_NLMSG_RESPONSE:
+			if (ecryptfs_process_nl_response(skb)) {
+				ecryptfs_printk(KERN_WARNING, "Failed to "
+						"deliver netlink response to "
+						"requesting operation\n");
+			}
+			break;
+		case ECRYPTFS_NLMSG_HELO:
+			if (ecryptfs_process_nl_helo(skb)) {
+				ecryptfs_printk(KERN_WARNING, "Failed to "
+						"fulfill HELO request\n");
+			}
+			break;
+		case ECRYPTFS_NLMSG_QUIT:
+			if (ecryptfs_process_nl_quit(skb)) {
+				ecryptfs_printk(KERN_WARNING, "Failed to "
+						"fulfill QUIT request\n");
+			}
+			break;
+		default:
+			ecryptfs_printk(KERN_WARNING, "Dropping netlink "
+					"message of unrecognized type [%d]\n",
+					nlh->nlmsg_type);
+			break;
+	}
+free:
+	kfree_skb(skb);
+}
+
+/**
+ * ecryptfs_init_netlink
+ *
+ * Initializes the daemon id hash list, netlink context array, and
+ * necessary locks.  Returns zero upon success; non-zero upon error.
+ */
+int ecryptfs_init_netlink(void)
+{
+	int rc;
+
+	ecryptfs_nl_sock = netlink_kernel_create(NETLINK_ECRYPTFS, 0,
+						 ecryptfs_receive_nl_message,
+						 THIS_MODULE);
+	if (!ecryptfs_nl_sock) {
+		rc = -EIO;
+		ecryptfs_printk(KERN_ERR, "Failed to create netlink socket\n");
+		goto out;
+	}
+	ecryptfs_nl_sock->sk_sndtimeo = ECRYPTFS_DEFAULT_SEND_TIMEOUT;
+	rc = 0;
+out:
+	return rc;
+}
+
+/**
+ * ecryptfs_release_netlink
+ *
+ * Frees all memory used by the netlink context array and releases the
+ * netlink socket.
+ */
+void ecryptfs_release_netlink(void)
+{
+	if (ecryptfs_nl_sock && ecryptfs_nl_sock->sk_socket)
+		sock_release(ecryptfs_nl_sock->sk_socket);
+	ecryptfs_nl_sock = NULL;
+}
diff -puN include/linux/netlink.h~ecryptfs-public-key-transport-mechanism include/linux/netlink.h
--- a/include/linux/netlink.h~ecryptfs-public-key-transport-mechanism
+++ a/include/linux/netlink.h
@@ -23,6 +23,7 @@
 #define NETLINK_GENERIC		16
 /* leave room for NETLINK_DM (DM Events) */
 #define NETLINK_SCSITRANSPORT	18	/* SCSI Transports */
+#define NETLINK_ECRYPTFS	19
 
 #define MAX_LINKS 32		
 
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

make-ecryptfs_version_str_map-static.patch
ecryptfs-public-key-transport-mechanism.patch
ecryptfs-public-key-packet-management.patch
fsstack-introduce-fsstack_copy_attrinode_.patch
fsstack-introduce-fsstack_copy_attrinode_-tidy.patch
ecryptfs-use-fsstacks-generic-copy-inode-attr.patch
ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix.patch
ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix-fix.patch
struct-path-make-ecryptfs-a-user-of-struct-path.patch

