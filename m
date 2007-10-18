From: akpm@linux-foundation.org
Subject: - fs-remove-the-unused-mempages-parameter.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:54:09 -0700
Message-ID: <200710180654.l9I6s9ia030501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36989 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932125AbXJRHhl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:37:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: crquan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fs: remove the unused mempages parameter
has been removed from the -mm tree.  Its filename was
     fs-remove-the-unused-mempages-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs: remove the unused mempages parameter
From: Denis Cheng <crquan@gmail.com>

Since the mempages parameter is actually not used, they should be removed.

Now there is only files_init use the mempages parameter,

 	files_init(mempages);

but I don't think the adaptation to mempages in files_init is really
useful; and if files_init also changed to the prototype void (*func)(void),
the wrapper vfs_caches_init would also not need the mempages parameter.

Signed-off-by: Denis Cheng <crquan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c        |    8 ++++----
 fs/inode.c         |    2 +-
 fs/namespace.c     |    2 +-
 include/linux/fs.h |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/dcache.c~fs-remove-the-unused-mempages-parameter fs/dcache.c
--- a/fs/dcache.c~fs-remove-the-unused-mempages-parameter
+++ a/fs/dcache.c
@@ -2108,7 +2108,7 @@ static void __init dcache_init_early(voi
 		INIT_HLIST_HEAD(&dentry_hashtable[loop]);
 }
 
-static void __init dcache_init(unsigned long mempages)
+static void __init dcache_init(void)
 {
 	int loop;
 
@@ -2170,10 +2170,10 @@ void __init vfs_caches_init(unsigned lon
 	filp_cachep = kmem_cache_create("filp", sizeof(struct file), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
 
-	dcache_init(mempages);
-	inode_init(mempages);
+	dcache_init();
+	inode_init();
 	files_init(mempages);
-	mnt_init(mempages);
+	mnt_init();
 	bdev_cache_init();
 	chrdev_init();
 }
diff -puN fs/inode.c~fs-remove-the-unused-mempages-parameter fs/inode.c
--- a/fs/inode.c~fs-remove-the-unused-mempages-parameter
+++ a/fs/inode.c
@@ -1396,7 +1396,7 @@ void __init inode_init_early(void)
 		INIT_HLIST_HEAD(&inode_hashtable[loop]);
 }
 
-void __init inode_init(unsigned long mempages)
+void __init inode_init(void)
 {
 	int loop;
 
diff -puN fs/namespace.c~fs-remove-the-unused-mempages-parameter fs/namespace.c
--- a/fs/namespace.c~fs-remove-the-unused-mempages-parameter
+++ a/fs/namespace.c
@@ -1791,7 +1791,7 @@ static void __init init_mount_tree(void)
 	set_fs_root(current->fs, ns->root, ns->root->mnt_root);
 }
 
-void __init mnt_init(unsigned long mempages)
+void __init mnt_init(void)
 {
 	struct list_head *d;
 	unsigned int nr_hash;
diff -puN include/linux/fs.h~fs-remove-the-unused-mempages-parameter include/linux/fs.h
--- a/include/linux/fs.h~fs-remove-the-unused-mempages-parameter
+++ a/include/linux/fs.h
@@ -300,9 +300,9 @@ struct kstatfs;
 struct vm_area_struct;
 struct vfsmount;
 
-extern void __init inode_init(unsigned long);
+extern void __init inode_init(void);
 extern void __init inode_init_early(void);
-extern void __init mnt_init(unsigned long);
+extern void __init mnt_init(void);
 extern void __init files_init(unsigned long);
 
 struct buffer_head;
_

Patches currently in -mm which might be from crquan@gmail.com are

origin.patch
