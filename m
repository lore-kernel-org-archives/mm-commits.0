From: akpm@linux-foundation.org
Subject: [merged] kernfs-remove-kernfs_static_name.patch removed from -mm
 tree
Date: Mon, 16 Feb 2015 12:15:41 -0800
Message-ID: <54e24fed.G52SMVQIlHf8qsS4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbbBPUQR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:16:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, a.hajda@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernfs: remove KERNFS_STATIC_NAME
has been removed from the -mm tree.  Its filename was
     kernfs-remove-kernfs_static_name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: kernfs: remove KERNFS_STATIC_NAME

When a new kernfs node is created, KERNFS_STATIC_NAME is used to avoid
making a separate copy of its name.  It's currently only used for sysfs
attributes whose filenames are required to stay accessible and unchanged. 
There are rare exceptions where these names are allocated and formatted
dynamically but for the vast majority of cases they're consts in the
rodata section.

Now that kernfs is converted to use kstrdup_const() and kfree_const(),
there's little point in keeping KERNFS_STATIC_NAME around.  Remove it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/kernfs/dir.c        |   20 ++++++++------------
 fs/kernfs/file.c       |    4 ----
 fs/sysfs/file.c        |    2 +-
 include/linux/kernfs.h |    7 ++-----
 kernel/cgroup.c        |    2 +-
 5 files changed, 12 insertions(+), 23 deletions(-)

diff -puN fs/kernfs/dir.c~kernfs-remove-kernfs_static_name fs/kernfs/dir.c
--- a/fs/kernfs/dir.c~kernfs-remove-kernfs_static_name
+++ a/fs/kernfs/dir.c
@@ -411,8 +411,9 @@ void kernfs_put(struct kernfs_node *kn)
 
 	if (kernfs_type(kn) == KERNFS_LINK)
 		kernfs_put(kn->symlink.target_kn);
-	if (!(kn->flags & KERNFS_STATIC_NAME))
-		kfree_const(kn->name);
+
+	kfree_const(kn->name);
+
 	if (kn->iattr) {
 		if (kn->iattr->ia_secdata)
 			security_release_secctx(kn->iattr->ia_secdata,
@@ -506,15 +507,12 @@ static struct kernfs_node *__kernfs_new_
 					     const char *name, umode_t mode,
 					     unsigned flags)
 {
-	const char *dup_name = NULL;
 	struct kernfs_node *kn;
 	int ret;
 
-	if (!(flags & KERNFS_STATIC_NAME)) {
-		name = dup_name = kstrdup_const(name, GFP_KERNEL);
-		if (!name)
-			return NULL;
-	}
+	name = kstrdup_const(name, GFP_KERNEL);
+	if (!name)
+		return NULL;
 
 	kn = kmem_cache_zalloc(kernfs_node_cache, GFP_KERNEL);
 	if (!kn)
@@ -538,7 +536,7 @@ static struct kernfs_node *__kernfs_new_
  err_out2:
 	kmem_cache_free(kernfs_node_cache, kn);
  err_out1:
-	kfree_const(dup_name);
+	kfree_const(name);
 	return NULL;
 }
 
@@ -1285,9 +1283,7 @@ int kernfs_rename_ns(struct kernfs_node
 
 	kn->ns = new_ns;
 	if (new_name) {
-		if (!(kn->flags & KERNFS_STATIC_NAME))
-			old_name = kn->name;
-		kn->flags &= ~KERNFS_STATIC_NAME;
+		old_name = kn->name;
 		kn->name = new_name;
 	}
 
diff -puN fs/kernfs/file.c~kernfs-remove-kernfs_static_name fs/kernfs/file.c
--- a/fs/kernfs/file.c~kernfs-remove-kernfs_static_name
+++ a/fs/kernfs/file.c
@@ -901,7 +901,6 @@ const struct file_operations kernfs_file
  * @ops: kernfs operations for the file
  * @priv: private data for the file
  * @ns: optional namespace tag of the file
- * @name_is_static: don't copy file name
  * @key: lockdep key for the file's active_ref, %NULL to disable lockdep
  *
  * Returns the created node on success, ERR_PTR() value on error.
@@ -911,7 +910,6 @@ struct kernfs_node *__kernfs_create_file
 					 umode_t mode, loff_t size,
 					 const struct kernfs_ops *ops,
 					 void *priv, const void *ns,
-					 bool name_is_static,
 					 struct lock_class_key *key)
 {
 	struct kernfs_node *kn;
@@ -919,8 +917,6 @@ struct kernfs_node *__kernfs_create_file
 	int rc;
 
 	flags = KERNFS_FILE;
-	if (name_is_static)
-		flags |= KERNFS_STATIC_NAME;
 
 	kn = kernfs_new_node(parent, name, (mode & S_IALLUGO) | S_IFREG, flags);
 	if (!kn)
diff -puN fs/sysfs/file.c~kernfs-remove-kernfs_static_name fs/sysfs/file.c
--- a/fs/sysfs/file.c~kernfs-remove-kernfs_static_name
+++ a/fs/sysfs/file.c
@@ -295,7 +295,7 @@ int sysfs_add_file_mode_ns(struct kernfs
 		key = attr->key ?: (struct lock_class_key *)&attr->skey;
 #endif
 	kn = __kernfs_create_file(parent, attr->name, mode & 0777, size, ops,
-				  (void *)attr, ns, true, key);
+				  (void *)attr, ns, key);
 	if (IS_ERR(kn)) {
 		if (PTR_ERR(kn) == -EEXIST)
 			sysfs_warn_dup(parent, attr->name);
diff -puN include/linux/kernfs.h~kernfs-remove-kernfs_static_name include/linux/kernfs.h
--- a/include/linux/kernfs.h~kernfs-remove-kernfs_static_name
+++ a/include/linux/kernfs.h
@@ -43,7 +43,6 @@ enum kernfs_node_flag {
 	KERNFS_HAS_SEQ_SHOW	= 0x0040,
 	KERNFS_HAS_MMAP		= 0x0080,
 	KERNFS_LOCKDEP		= 0x0100,
-	KERNFS_STATIC_NAME	= 0x0200,
 	KERNFS_SUICIDAL		= 0x0400,
 	KERNFS_SUICIDED		= 0x0800,
 };
@@ -291,7 +290,6 @@ struct kernfs_node *__kernfs_create_file
 					 umode_t mode, loff_t size,
 					 const struct kernfs_ops *ops,
 					 void *priv, const void *ns,
-					 bool name_is_static,
 					 struct lock_class_key *key);
 struct kernfs_node *kernfs_create_link(struct kernfs_node *parent,
 				       const char *name,
@@ -369,8 +367,7 @@ kernfs_create_dir_ns(struct kernfs_node
 static inline struct kernfs_node *
 __kernfs_create_file(struct kernfs_node *parent, const char *name,
 		     umode_t mode, loff_t size, const struct kernfs_ops *ops,
-		     void *priv, const void *ns, bool name_is_static,
-		     struct lock_class_key *key)
+		     void *priv, const void *ns, struct lock_class_key *key)
 { return ERR_PTR(-ENOSYS); }
 
 static inline struct kernfs_node *
@@ -439,7 +436,7 @@ kernfs_create_file_ns(struct kernfs_node
 	key = (struct lock_class_key *)&ops->lockdep_key;
 #endif
 	return __kernfs_create_file(parent, name, mode, size, ops, priv, ns,
-				    false, key);
+				    key);
 }
 
 static inline struct kernfs_node *
diff -puN kernel/cgroup.c~kernfs-remove-kernfs_static_name kernel/cgroup.c
--- a/kernel/cgroup.c~kernfs-remove-kernfs_static_name
+++ a/kernel/cgroup.c
@@ -3077,7 +3077,7 @@ static int cgroup_add_file(struct cgroup
 #endif
 	kn = __kernfs_create_file(cgrp->kn, cgroup_file_name(cgrp, cft, name),
 				  cgroup_file_mode(cft), 0, cft->kf_ops, cft,
-				  NULL, false, key);
+				  NULL, key);
 	if (IS_ERR(kn))
 		return PTR_ERR(kn);
 
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch

