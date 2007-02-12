From: akpm@linux-foundation.org
Subject: - ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static.patch removed from -mm tree
Date: Sun, 11 Feb 2007 23:24:51 -0800
Message-ID: <200702120724.l1C7OqGP024771@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45019 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933068AbXBLHbT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 02:31:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     fs/ecryptfs/: make code static
has been removed from the -mm tree.  Its filename was
     ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static.patch

This patch was dropped because it was folded into ecryptfs-generalize-metadata-read-write.patch

------------------------------------------------------
Subject: fs/ecryptfs/: make code static
From: Adrian Bunk <bunk@stusta.de>

This patch makes some needlessly global code static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c          |   24 ++++++++++++------------
 fs/ecryptfs/ecryptfs_kernel.h |   18 ------------------
 fs/ecryptfs/messaging.c       |   20 +++++++++++---------
 3 files changed, 23 insertions(+), 39 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static
+++ a/fs/ecryptfs/crypto.c
@@ -1024,7 +1024,7 @@ int ecryptfs_new_file_context(struct den
  *
  * Returns one if marker found; zero if not found
  */
-int contains_ecryptfs_marker(char *data)
+static int contains_ecryptfs_marker(char *data)
 {
 	u32 m_1, m_2;
 
@@ -1211,8 +1211,8 @@ int ecryptfs_cipher_code_to_string(char 
  *
  * Returns zero on success; non-zero otherwise
  */
-int ecryptfs_read_header_region(char *data, struct dentry *dentry,
-				struct vfsmount *mnt)
+static int ecryptfs_read_header_region(char *data, struct dentry *dentry,
+				       struct vfsmount *mnt)
 {
 	struct file *lower_file;
 	mm_segment_t oldfs;
@@ -1307,9 +1307,9 @@ struct kmem_cache *ecryptfs_header_cache
  *
  * Returns zero on success
  */
-int ecryptfs_write_headers_virt(char *page_virt, size_t *size,
-				struct ecryptfs_crypt_stat *crypt_stat,
-				struct dentry *ecryptfs_dentry)
+static int ecryptfs_write_headers_virt(char *page_virt, size_t *size,
+				       struct ecryptfs_crypt_stat *crypt_stat,
+				       struct dentry *ecryptfs_dentry)
 {
 	int rc;
 	size_t written;
@@ -1335,9 +1335,9 @@ int ecryptfs_write_headers_virt(char *pa
 	return rc;
 }
 
-int ecryptfs_write_metadata_to_contents(struct ecryptfs_crypt_stat *crypt_stat,
-					struct file *lower_file,
-					char *page_virt)
+static int ecryptfs_write_metadata_to_contents(struct ecryptfs_crypt_stat *crypt_stat,
+					       struct file *lower_file,
+					       char *page_virt)
 {
 	mm_segment_t oldfs;
 	int current_header_page;
@@ -1362,9 +1362,9 @@ int ecryptfs_write_metadata_to_contents(
 	return 0;
 }
 
-int ecryptfs_write_metadata_to_xattr(struct dentry *ecryptfs_dentry,
-				     struct ecryptfs_crypt_stat *crypt_stat,
-				     char *page_virt, size_t size)
+static int ecryptfs_write_metadata_to_xattr(struct dentry *ecryptfs_dentry,
+					    struct ecryptfs_crypt_stat *crypt_stat,
+					    char *page_virt, size_t size)
 {
 	int rc;
 
diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -328,18 +328,6 @@ struct ecryptfs_msg_ctx {
 	struct mutex mux;
 };
 
-extern struct list_head ecryptfs_msg_ctx_free_list;
-extern struct list_head ecryptfs_msg_ctx_alloc_list;
-extern struct mutex ecryptfs_msg_ctx_lists_mux;
-
-#define ecryptfs_uid_hash(uid) \
-        hash_long((unsigned long)uid, ecryptfs_hash_buckets)
-extern struct hlist_head *ecryptfs_daemon_id_hash;
-extern struct mutex ecryptfs_daemon_id_hash_mux;
-extern int ecryptfs_hash_buckets;
-
-extern unsigned int ecryptfs_msg_counter;
-extern struct ecryptfs_msg_ctx *ecryptfs_msg_ctx_arr;
 extern unsigned int ecryptfs_transport;
 
 struct ecryptfs_daemon_id {
@@ -537,15 +525,9 @@ int ecryptfs_encrypt_page(struct ecryptf
 int ecryptfs_decrypt_page(struct file *file, struct page *page);
 int ecryptfs_write_metadata(struct dentry *ecryptfs_dentry,
 			    struct file *lower_file);
-int ecryptfs_write_headers_virt(char *page_virt, size_t *size,
-				struct ecryptfs_crypt_stat *crypt_stat,
-				struct dentry *ecryptfs_dentry);
 int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry,
 			   struct file *lower_file);
 int ecryptfs_new_file_context(struct dentry *ecryptfs_dentry);
-int contains_ecryptfs_marker(char *data);
-int ecryptfs_read_header_region(char *data, struct dentry *dentry,
-				struct vfsmount *mnt);
 int ecryptfs_read_and_validate_header_region(char *data, struct dentry *dentry,
 					     struct vfsmount *mnt);
 int ecryptfs_read_and_validate_xattr_region(char *page_virt,
diff -puN fs/ecryptfs/messaging.c~ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static fs/ecryptfs/messaging.c
--- a/fs/ecryptfs/messaging.c~ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static
+++ a/fs/ecryptfs/messaging.c
@@ -22,16 +22,18 @@
 
 #include "ecryptfs_kernel.h"
 
-LIST_HEAD(ecryptfs_msg_ctx_free_list);
-LIST_HEAD(ecryptfs_msg_ctx_alloc_list);
-struct mutex ecryptfs_msg_ctx_lists_mux;
-
-struct hlist_head *ecryptfs_daemon_id_hash;
-struct mutex ecryptfs_daemon_id_hash_mux;
-int ecryptfs_hash_buckets;
+static LIST_HEAD(ecryptfs_msg_ctx_free_list);
+static LIST_HEAD(ecryptfs_msg_ctx_alloc_list);
+static struct mutex ecryptfs_msg_ctx_lists_mux;
+
+static struct hlist_head *ecryptfs_daemon_id_hash;
+static struct mutex ecryptfs_daemon_id_hash_mux;
+static int ecryptfs_hash_buckets;
+#define ecryptfs_uid_hash(uid) \
+        hash_long((unsigned long)uid, ecryptfs_hash_buckets)
 
-unsigned int ecryptfs_msg_counter;
-struct ecryptfs_msg_ctx *ecryptfs_msg_ctx_arr;
+static unsigned int ecryptfs_msg_counter;
+static struct ecryptfs_msg_ctx *ecryptfs_msg_ctx_arr;
 
 /**
  * ecryptfs_acquire_free_msg_ctx
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
debug-shared-irqs.patch
drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
drivers-isdn-sc-proper-prototypes.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
ecryptfs-generalize-metadata-read-write.patch
ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static.patch
remove-broken-video-drivers-v4.patch
remove-bogus-con_is_present-prototypes.patch
proper-prototype-for-tosh_smm.patch
remove-the-broken-fb_s3trio-driver.patch
