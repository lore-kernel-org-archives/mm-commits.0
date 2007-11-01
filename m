From: akpm@linux-foundation.org
Subject: + fs-ecryptfs-possible-cleanups.patch added to -mm tree
Date: Thu, 01 Nov 2007 00:18:53 -0700
Message-ID: <200711010718.lA17Irxr017825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36872 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753554AbXKAHTT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 03:19:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, mhalcrow@us.ibm.com


The patch titled
     fs/ecryptfs/: possible cleanups
has been added to the -mm tree.  Its filename is
     fs-ecryptfs-possible-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs/ecryptfs/: possible cleanups
From: Adrian Bunk <bunk@kernel.org>

- make the following needlessly global code static:
  - crypto.c:ecryptfs_lower_offset_for_extent()
  - crypto.c:key_tfm_list
  - crypto.c:key_tfm_list_mutex
  - inode.c:ecryptfs_getxattr()
  - main.c:ecryptfs_init_persistent_file()

- remove the no longer used mmap.c:ecryptfs_lower_page_cache

- #if 0 the unused read_write.c:ecryptfs_read()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c          |    8 ++++----
 fs/ecryptfs/ecryptfs_kernel.h |   10 ----------
 fs/ecryptfs/inode.c           |    2 +-
 fs/ecryptfs/main.c            |    2 +-
 fs/ecryptfs/mmap.c            |    2 --
 fs/ecryptfs/read_write.c      |    2 ++
 6 files changed, 8 insertions(+), 18 deletions(-)

diff -puN fs/ecryptfs/crypto.c~fs-ecryptfs-possible-cleanups fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~fs-ecryptfs-possible-cleanups
+++ a/fs/ecryptfs/crypto.c
@@ -358,8 +358,8 @@ out:
  *
  * Convert an eCryptfs page index into a lower byte offset
  */
-void ecryptfs_lower_offset_for_extent(loff_t *offset, loff_t extent_num,
-				      struct ecryptfs_crypt_stat *crypt_stat)
+static void ecryptfs_lower_offset_for_extent(loff_t *offset, loff_t extent_num,
+					     struct ecryptfs_crypt_stat *crypt_stat)
 {
 	(*offset) = ((crypt_stat->extent_size
 		      * crypt_stat->num_header_extents_at_front)
@@ -1786,8 +1786,8 @@ out:
 }
 
 struct kmem_cache *ecryptfs_key_tfm_cache;
-struct list_head key_tfm_list;
-struct mutex key_tfm_list_mutex;
+static struct list_head key_tfm_list;
+static struct mutex key_tfm_list_mutex;
 
 int ecryptfs_init_crypto(void)
 {
diff -puN fs/ecryptfs/ecryptfs_kernel.h~fs-ecryptfs-possible-cleanups fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~fs-ecryptfs-possible-cleanups
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -322,9 +322,6 @@ struct ecryptfs_key_tfm {
 	unsigned char cipher_name[ECRYPTFS_MAX_CIPHER_NAME_SIZE + 1];
 };
 
-extern struct list_head key_tfm_list;
-extern struct mutex key_tfm_list_mutex;
-
 /**
  * This struct is to enable a mount-wide passphrase/salt combo. This
  * is more or less a stopgap to provide similar functionality to other
@@ -525,7 +522,6 @@ extern struct kmem_cache *ecryptfs_heade
 extern struct kmem_cache *ecryptfs_header_cache_1;
 extern struct kmem_cache *ecryptfs_header_cache_2;
 extern struct kmem_cache *ecryptfs_xattr_cache;
-extern struct kmem_cache *ecryptfs_lower_page_cache;
 extern struct kmem_cache *ecryptfs_key_record_cache;
 extern struct kmem_cache *ecryptfs_key_sig_cache;
 extern struct kmem_cache *ecryptfs_global_auth_tok_cache;
@@ -576,8 +572,6 @@ int ecryptfs_truncate(struct dentry *den
 int ecryptfs_inode_test(struct inode *inode, void *candidate_lower_inode);
 int ecryptfs_inode_set(struct inode *inode, void *lower_inode);
 void ecryptfs_init_inode(struct inode *inode, struct inode *lower_inode);
-ssize_t ecryptfs_getxattr(struct dentry *dentry, const char *name, void *value,
-			  size_t size);
 ssize_t
 ecryptfs_getxattr_lower(struct dentry *lower_dentry, const char *name,
 			void *value, size_t size);
@@ -631,8 +625,6 @@ int ecryptfs_keyring_auth_tok_for_sig(st
 				      char *sig);
 int ecryptfs_write_zeros(struct file *file, pgoff_t index, int start,
 			 int num_zeros);
-void ecryptfs_lower_offset_for_extent(loff_t *offset, loff_t extent_num,
-				      struct ecryptfs_crypt_stat *crypt_stat);
 int ecryptfs_write_lower(struct inode *ecryptfs_inode, char *data,
 			 loff_t offset, size_t size);
 int ecryptfs_write_lower_page_segment(struct inode *ecryptfs_inode,
@@ -646,8 +638,6 @@ int ecryptfs_read_lower_page_segment(str
 				     pgoff_t page_index,
 				     size_t offset_in_page, size_t size,
 				     struct inode *ecryptfs_inode);
-int ecryptfs_read(char *data, loff_t offset, size_t size,
-		  struct file *ecryptfs_file);
 struct page *ecryptfs_get_locked_page(struct file *file, loff_t index);
 
 #endif /* #ifndef ECRYPTFS_KERNEL_H */
diff -puN fs/ecryptfs/inode.c~fs-ecryptfs-possible-cleanups fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~fs-ecryptfs-possible-cleanups
+++ a/fs/ecryptfs/inode.c
@@ -966,7 +966,7 @@ out:
 	return rc;
 }
 
-ssize_t
+static ssize_t
 ecryptfs_getxattr(struct dentry *dentry, const char *name, void *value,
 		  size_t size)
 {
diff -puN fs/ecryptfs/main.c~fs-ecryptfs-possible-cleanups fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~fs-ecryptfs-possible-cleanups
+++ a/fs/ecryptfs/main.c
@@ -117,7 +117,7 @@ void __ecryptfs_printk(const char *fmt, 
  *
  * Returns zero on success; non-zero otherwise
  */
-int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
+static int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
 {
 	struct ecryptfs_inode_info *inode_info =
 		ecryptfs_inode_to_private(ecryptfs_dentry->d_inode);
diff -puN fs/ecryptfs/mmap.c~fs-ecryptfs-possible-cleanups fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~fs-ecryptfs-possible-cleanups
+++ a/fs/ecryptfs/mmap.c
@@ -34,8 +34,6 @@
 #include <linux/scatterlist.h>
 #include "ecryptfs_kernel.h"
 
-struct kmem_cache *ecryptfs_lower_page_cache;
-
 /**
  * ecryptfs_get_locked_page
  *
diff -puN fs/ecryptfs/read_write.c~fs-ecryptfs-possible-cleanups fs/ecryptfs/read_write.c
--- a/fs/ecryptfs/read_write.c~fs-ecryptfs-possible-cleanups
+++ a/fs/ecryptfs/read_write.c
@@ -278,6 +278,7 @@ int ecryptfs_read_lower_page_segment(str
 	return rc;
 }
 
+#if 0
 /**
  * ecryptfs_read
  * @data: The virtual address into which to write the data read (and
@@ -356,3 +357,4 @@ int ecryptfs_read(char *data, loff_t off
 out:
 	return rc;
 }
+#endif  /*  0  */
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-hwmon.patch
git-input.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-ocfs2.patch
git-sh64.patch
scsi-advansysc-make-3-functions-static.patch
git-block.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
kill-udffs_dateversion.patch
fs-ecryptfs-possible-cleanups.patch
make-jbd-journalc__journal_abort_hard-static.patch
kernel-cgroupc-remove-dead-code.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
reiser4.patch
