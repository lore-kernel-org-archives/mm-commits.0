From: akpm@linux-foundation.org
Subject: - integrity-fs-hook-placement.patch removed from -mm tree
Date: Tue, 22 May 2007 14:24:33 -0700
Message-ID: <200705222124.l4MLOXpL010112@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57582 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757829AbXEVV0y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 17:26:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zohar@linux.vnet.ibm.com, kjhall@us.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     integrity: fs hook placement
has been removed from the -mm tree.  Its filename was
     integrity-fs-hook-placement.patch

This patch was dropped because this work seems to be stalled

------------------------------------------------------
Subject: integrity: fs hook placement
From: Mimi Zohar <zohar@linux.vnet.ibm.com>

This patch places calls to the new integrity hooks in the appropriate places
in the fs directory.  It is not meant in any way to be viewed as a complete
set, but used as a basis for an initial discussion.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Kylene Hall <kjhall@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c              |    6 ++++++
 fs/ext3/xattr_security.c |    8 ++++++++
 fs/file_table.c          |    3 +++
 fs/inode.c               |   10 ++++++++++
 fs/xattr.c               |    9 +++++++++
 include/linux/fs.h       |    3 +++
 6 files changed, 39 insertions(+)

diff -puN fs/dcache.c~integrity-fs-hook-placement fs/dcache.c
--- a/fs/dcache.c~integrity-fs-hook-placement
+++ a/fs/dcache.c
@@ -28,6 +28,7 @@
 #include <linux/file.h>
 #include <asm/uaccess.h>
 #include <linux/security.h>
+#include <linux/integrity.h>
 #include <linux/seqlock.h>
 #include <linux/swap.h>
 #include <linux/bootmem.h>
@@ -990,6 +991,7 @@ void d_instantiate(struct dentry *entry,
 	entry->d_inode = inode;
 	fsnotify_d_instantiate(entry, inode);
 	spin_unlock(&dcache_lock);
+	integrity_d_instantiate(entry, inode);
 	security_d_instantiate(entry, inode);
 }
 
@@ -1054,6 +1056,7 @@ struct dentry *d_instantiate_unique(stru
 	spin_unlock(&dcache_lock);
 
 	if (!result) {
+		integrity_d_instantiate(entry, inode);
 		security_d_instantiate(entry, inode);
 		return NULL;
 	}
@@ -1191,6 +1194,7 @@ struct dentry *d_splice_alias(struct ino
 			BUG_ON(!(new->d_flags & DCACHE_DISCONNECTED));
 			fsnotify_d_instantiate(new, inode);
 			spin_unlock(&dcache_lock);
+			integrity_d_instantiate(new, inode);
 			security_d_instantiate(new, inode);
 			d_rehash(dentry);
 			d_move(new, dentry);
@@ -1201,6 +1205,7 @@ struct dentry *d_splice_alias(struct ino
 			dentry->d_inode = inode;
 			fsnotify_d_instantiate(dentry, inode);
 			spin_unlock(&dcache_lock);
+			integrity_d_instantiate(dentry, inode);
 			security_d_instantiate(dentry, inode);
 			d_rehash(dentry);
 		}
@@ -1752,6 +1757,7 @@ found:
 	spin_unlock(&dcache_lock);
 out_nolock:
 	if (actual == dentry) {
+		integrity_d_instantiate(dentry, inode);
 		security_d_instantiate(dentry, inode);
 		return NULL;
 	}
diff -puN fs/ext3/xattr_security.c~integrity-fs-hook-placement fs/ext3/xattr_security.c
--- a/fs/ext3/xattr_security.c~integrity-fs-hook-placement
+++ a/fs/ext3/xattr_security.c
@@ -9,6 +9,7 @@
 #include <linux/ext3_jbd.h>
 #include <linux/ext3_fs.h>
 #include <linux/security.h>
+#include <linux/integrity.h>
 #include "xattr.h"
 
 static size_t
@@ -57,12 +58,19 @@ ext3_init_security(handle_t *handle, str
 
 	err = security_inode_init_security(inode, dir, &name, &value, &len);
 	if (err) {
+		/* Even if creation of the security xattr fails, must
+		 * indicate this is a new inode. */
+		integrity_inode_init_integrity(inode, dir, NULL, NULL, NULL);
 		if (err == -EOPNOTSUPP)
 			return 0;
 		return err;
 	}
 	err = ext3_xattr_set_handle(handle, inode, EXT3_XATTR_INDEX_SECURITY,
 				    name, value, len, 0);
+
+	integrity_inode_init_integrity(inode, dir, &name, &value, &len);
+	err = ext3_xattr_set_handle(handle, inode, EXT3_XATTR_INDEX_SECURITY,
+				    name, value, len, 0);
 	kfree(name);
 	kfree(value);
 	return err;
diff -puN fs/file_table.c~integrity-fs-hook-placement fs/file_table.c
--- a/fs/file_table.c~integrity-fs-hook-placement
+++ a/fs/file_table.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/security.h>
+#include <linux/integrity.h>
 #include <linux/eventpoll.h>
 #include <linux/rcupdate.h>
 #include <linux/mount.h>
@@ -168,6 +169,7 @@ void fastcall __fput(struct file *file)
 	if (file->f_op && file->f_op->release)
 		file->f_op->release(inode, file);
 	security_file_free(file);
+	integrity_file_free(file);
 	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL))
 		cdev_put(inode->i_cdev);
 	fops_put(file->f_op);
@@ -239,6 +241,7 @@ void put_filp(struct file *file)
 {
 	if (atomic_dec_and_test(&file->f_count)) {
 		security_file_free(file);
+		integrity_file_free(file);
 		file_kill(file);
 		file_free(file);
 	}
diff -puN fs/inode.c~integrity-fs-hook-placement fs/inode.c
--- a/fs/inode.c~integrity-fs-hook-placement
+++ a/fs/inode.c
@@ -17,6 +17,7 @@
 #include <linux/hash.h>
 #include <linux/swap.h>
 #include <linux/security.h>
+#include <linux/integrity.h>
 #include <linux/pagemap.h>
 #include <linux/cdev.h>
 #include <linux/bootmem.h>
@@ -142,6 +143,14 @@ static struct inode *alloc_inode(struct 
 			return NULL;
 		}
 
+		if (integrity_inode_alloc(inode)) {
+			if (inode->i_sb->s_op->destroy_inode)
+				inode->i_sb->s_op->destroy_inode(inode);
+			else
+				kmem_cache_free(inode_cachep, (inode));
+			return NULL;
+		}
+
 		mapping->a_ops = &empty_aops;
  		mapping->host = inode;
 		mapping->flags = 0;
@@ -172,6 +181,7 @@ void destroy_inode(struct inode *inode) 
 {
 	BUG_ON(inode_has_buffers(inode));
 	security_inode_free(inode);
+	integrity_inode_free(inode);
 	if (inode->i_sb->s_op->destroy_inode)
 		inode->i_sb->s_op->destroy_inode(inode);
 	else
diff -puN fs/xattr.c~integrity-fs-hook-placement fs/xattr.c
--- a/fs/xattr.c~integrity-fs-hook-placement
+++ a/fs/xattr.c
@@ -13,6 +13,7 @@
 #include <linux/xattr.h>
 #include <linux/namei.h>
 #include <linux/security.h>
+#include <linux/integrity.h>
 #include <linux/syscalls.h>
 #include <linux/module.h>
 #include <linux/fsnotify.h>
@@ -83,11 +84,17 @@ vfs_setxattr(struct dentry *dentry, char
 	error = security_inode_setxattr(dentry, name, value, size, flags);
 	if (error)
 		goto out;
+
+	error = integrity_inode_setxattr(dentry, name, value, size, flags);
+	if (error)
+		goto out;
+
 	error = -EOPNOTSUPP;
 	if (inode->i_op->setxattr) {
 		error = inode->i_op->setxattr(dentry, name, value, size, flags);
 		if (!error) {
 			fsnotify_xattr(dentry);
+			integrity_inode_post_setxattr(dentry, name);
 			security_inode_post_setxattr(dentry, name, value,
 						     size, flags);
 		}
@@ -180,6 +187,8 @@ vfs_removexattr(struct dentry *dentry, c
 
 	mutex_lock(&inode->i_mutex);
 	error = inode->i_op->removexattr(dentry, name);
+	if (!error)
+		integrity_inode_post_setxattr(dentry, name);
 	mutex_unlock(&inode->i_mutex);
 
 	if (!error)
diff -puN include/linux/fs.h~integrity-fs-hook-placement include/linux/fs.h
--- a/include/linux/fs.h~integrity-fs-hook-placement
+++ a/include/linux/fs.h
@@ -609,6 +609,9 @@ struct inode {
 #ifdef CONFIG_SECURITY
 	void			*i_security;
 #endif
+#ifdef CONFIG_INTEGRITY
+	void			*i_integrity;
+#endif
 	void			*i_private; /* fs or device private pointer */
 };
 
_

Patches currently in -mm which might be from zohar@linux.vnet.ibm.com are

integrity-fs-hook-placement.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-ima-identifiers.patch
integrity-ima-cleanup.patch
integrity-tpm-internal-kernel-interface.patch
ibac-patch.patch
