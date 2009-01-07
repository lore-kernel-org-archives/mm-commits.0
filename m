From: akpm@linux-foundation.org
Subject: - shmem-unify-regular-and-tiny-shmem.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:14:28 -0800
Message-ID: <200901072214.n07MES3Y014386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761634AbZAGWOv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     shmem: unify regular and tiny shmem
has been removed from the -mm tree.  Its filename was
     shmem-unify-regular-and-tiny-shmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: shmem: unify regular and tiny shmem
From: Matt Mackall <mpm@selenic.com>

tiny-shmem shares most of its 130 lines of code with shmem and tends to
break when particular bits of shmem get modified.  Unifying saves code and
makes keeping these two in sync much easier.

before:
  14367	    392	     24	  14783	   39bf	mm/shmem.o
    396      72       8     476	    1dc	mm/tiny-shmem.o

after:
  14367	    392	     24	  14783	   39bf	mm/shmem.o
    412	     72       8     492	    1ec	mm/shmem.o tiny

Signed-off-by: Matt Mackall <mpm@selenic.com>
Acked-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig    |    4 -
 mm/Makefile     |    4 -
 mm/shmem.c      |   81 ++++++++++++++++++++++++---
 mm/tiny-shmem.c |  134 ----------------------------------------------
 4 files changed, 72 insertions(+), 151 deletions(-)

diff -puN init/Kconfig~shmem-unify-regular-and-tiny-shmem init/Kconfig
--- a/init/Kconfig~shmem-unify-regular-and-tiny-shmem
+++ a/init/Kconfig
@@ -838,10 +838,6 @@ config RT_MUTEXES
 	boolean
 	select PLIST
 
-config TINY_SHMEM
-	default !SHMEM
-	bool
-
 config BASE_SMALL
 	int
 	default 0 if BASE_FULL
diff -puN mm/Makefile~shmem-unify-regular-and-tiny-shmem mm/Makefile
--- a/mm/Makefile~shmem-unify-regular-and-tiny-shmem
+++ a/mm/Makefile
@@ -9,7 +9,7 @@ mmu-$(CONFIG_MMU)	:= fremap.o highmem.o 
 
 obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
 			   maccess.o page_alloc.o page-writeback.o pdflush.o \
-			   readahead.o swap.o truncate.o vmscan.o \
+			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
 			   page_isolation.o mm_init.o $(mmu-y)
 
@@ -21,9 +21,7 @@ obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o
 obj-$(CONFIG_NUMA) 	+= mempolicy.o
 obj-$(CONFIG_SPARSEMEM)	+= sparse.o
 obj-$(CONFIG_SPARSEMEM_VMEMMAP) += sparse-vmemmap.o
-obj-$(CONFIG_SHMEM) += shmem.o
 obj-$(CONFIG_TMPFS_POSIX_ACL) += shmem_acl.o
-obj-$(CONFIG_TINY_SHMEM) += tiny-shmem.o
 obj-$(CONFIG_SLOB) += slob.o
 obj-$(CONFIG_MMU_NOTIFIER) += mmu_notifier.o
 obj-$(CONFIG_SLAB) += slab.o
diff -puN mm/shmem.c~shmem-unify-regular-and-tiny-shmem mm/shmem.c
--- a/mm/shmem.c~shmem-unify-regular-and-tiny-shmem
+++ a/mm/shmem.c
@@ -14,31 +14,39 @@
  * Copyright (c) 2004, Luke Kenneth Casson Leighton <lkcl@lkcl.net>
  * Copyright (c) 2004 Red Hat, Inc., James Morris <jmorris@redhat.com>
  *
+ * tiny-shmem:
+ * Copyright (c) 2004, 2008 Matt Mackall <mpm@selenic.com>
+ *
  * This file is released under the GPL.
  */
 
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/vfs.h>
+#include <linux/mount.h>
+#include <linux/file.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/swap.h>
+
+static struct vfsmount *shm_mnt;
+
+#ifdef CONFIG_SHMEM
 /*
  * This virtual memory filesystem is heavily based on the ramfs. It
  * extends ramfs by the ability to use swap and honor resource limits
  * which makes it a completely usable filesystem.
  */
 
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/fs.h>
 #include <linux/xattr.h>
 #include <linux/exportfs.h>
 #include <linux/generic_acl.h>
-#include <linux/mm.h>
 #include <linux/mman.h>
-#include <linux/file.h>
-#include <linux/swap.h>
 #include <linux/pagemap.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/backing-dev.h>
 #include <linux/shmem_fs.h>
-#include <linux/mount.h>
 #include <linux/writeback.h>
 #include <linux/vfs.h>
 #include <linux/blkdev.h>
@@ -2485,7 +2493,6 @@ static struct file_system_type tmpfs_fs_
 	.get_sb		= shmem_get_sb,
 	.kill_sb	= kill_litter_super,
 };
-static struct vfsmount *shm_mnt;
 
 static int __init init_tmpfs(void)
 {
@@ -2524,7 +2531,51 @@ out4:
 	shm_mnt = ERR_PTR(error);
 	return error;
 }
-module_init(init_tmpfs)
+
+#else /* !CONFIG_SHMEM */
+
+/*
+ * tiny-shmem: simple shmemfs and tmpfs using ramfs code
+ *
+ * This is intended for small system where the benefits of the full
+ * shmem code (swap-backed and resource-limited) are outweighed by
+ * their complexity. On systems without swap this code should be
+ * effectively equivalent, but much lighter weight.
+ */
+
+#include <linux/ramfs.h>
+
+static struct file_system_type tmpfs_fs_type = {
+	.name		= "tmpfs",
+	.get_sb		= ramfs_get_sb,
+	.kill_sb	= kill_litter_super,
+};
+
+static int __init init_tmpfs(void)
+{
+	BUG_ON(register_filesystem(&tmpfs_fs_type) != 0);
+
+	shm_mnt = kern_mount(&tmpfs_fs_type);
+	BUG_ON(IS_ERR(shm_mnt));
+
+	return 0;
+}
+
+int shmem_unuse(swp_entry_t entry, struct page *page)
+{
+	return 0;
+}
+
+#define shmem_file_operations ramfs_file_operations
+#define shmem_vm_ops generic_file_vm_ops
+#define shmem_get_inode ramfs_get_inode
+#define shmem_acct_size(a, b) 0
+#define shmem_unacct_size(a, b) do {} while (0)
+#define SHMEM_MAX_BYTES LLONG_MAX
+
+#endif /* CONFIG_SHMEM */
+
+/* common code */
 
 /**
  * shmem_file_setup - get an unlinked file living in tmpfs
@@ -2568,12 +2619,20 @@ struct file *shmem_file_setup(char *name
 	if (!inode)
 		goto close_file;
 
+#ifdef CONFIG_SHMEM
 	SHMEM_I(inode)->flags = flags & VM_ACCOUNT;
+#endif
 	d_instantiate(dentry, inode);
 	inode->i_size = size;
 	inode->i_nlink = 0;	/* It is unlinked */
 	init_file(file, shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
-			&shmem_file_operations);
+		  &shmem_file_operations);
+
+#ifndef CONFIG_MMU
+	error = ramfs_nommu_expand_for_mapping(inode, size);
+	if (error)
+		goto close_file;
+#endif
 	return file;
 
 close_file:
@@ -2605,3 +2664,5 @@ int shmem_zero_setup(struct vm_area_stru
 	vma->vm_ops = &shmem_vm_ops;
 	return 0;
 }
+
+module_init(init_tmpfs)
diff -puN mm/tiny-shmem.c~shmem-unify-regular-and-tiny-shmem /dev/null
--- a/mm/tiny-shmem.c
+++ /dev/null
@@ -1,134 +0,0 @@
-/*
- * tiny-shmem.c: simple shmemfs and tmpfs using ramfs code
- *
- * Matt Mackall <mpm@selenic.com> January, 2004
- * derived from mm/shmem.c and fs/ramfs/inode.c
- *
- * This is intended for small system where the benefits of the full
- * shmem code (swap-backed and resource-limited) are outweighed by
- * their complexity. On systems without swap this code should be
- * effectively equivalent, but much lighter weight.
- */
-
-#include <linux/fs.h>
-#include <linux/init.h>
-#include <linux/vfs.h>
-#include <linux/mount.h>
-#include <linux/file.h>
-#include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/swap.h>
-#include <linux/ramfs.h>
-
-static struct file_system_type tmpfs_fs_type = {
-	.name		= "tmpfs",
-	.get_sb		= ramfs_get_sb,
-	.kill_sb	= kill_litter_super,
-};
-
-static struct vfsmount *shm_mnt;
-
-static int __init init_tmpfs(void)
-{
-	BUG_ON(register_filesystem(&tmpfs_fs_type) != 0);
-
-	shm_mnt = kern_mount(&tmpfs_fs_type);
-	BUG_ON(IS_ERR(shm_mnt));
-
-	return 0;
-}
-module_init(init_tmpfs)
-
-/**
- * shmem_file_setup - get an unlinked file living in tmpfs
- * @name: name for dentry (to be seen in /proc/<pid>/maps
- * @size: size to be set for the file
- * @flags: vm_flags
- */
-struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags)
-{
-	int error;
-	struct file *file;
-	struct inode *inode;
-	struct dentry *dentry, *root;
-	struct qstr this;
-
-	if (IS_ERR(shm_mnt))
-		return (void *)shm_mnt;
-
-	error = -ENOMEM;
-	this.name = name;
-	this.len = strlen(name);
-	this.hash = 0; /* will go */
-	root = shm_mnt->mnt_root;
-	dentry = d_alloc(root, &this);
-	if (!dentry)
-		goto put_memory;
-
-	error = -ENFILE;
-	file = get_empty_filp();
-	if (!file)
-		goto put_dentry;
-
-	error = -ENOSPC;
-	inode = ramfs_get_inode(root->d_sb, S_IFREG | S_IRWXUGO, 0);
-	if (!inode)
-		goto close_file;
-
-	d_instantiate(dentry, inode);
-	inode->i_size = size;
-	inode->i_nlink = 0;	/* It is unlinked */
-	init_file(file, shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
-			&ramfs_file_operations);
-
-#ifndef CONFIG_MMU
-	error = ramfs_nommu_expand_for_mapping(inode, size);
-	if (error)
-		goto close_file;
-#endif
-	return file;
-
-close_file:
-	put_filp(file);
-put_dentry:
-	dput(dentry);
-put_memory:
-	return ERR_PTR(error);
-}
-EXPORT_SYMBOL_GPL(shmem_file_setup);
-
-/**
- * shmem_zero_setup - setup a shared anonymous mapping
- * @vma: the vma to be mmapped is prepared by do_mmap_pgoff
- */
-int shmem_zero_setup(struct vm_area_struct *vma)
-{
-	struct file *file;
-	loff_t size = vma->vm_end - vma->vm_start;
-
-	file = shmem_file_setup("dev/zero", size, vma->vm_flags);
-	if (IS_ERR(file))
-		return PTR_ERR(file);
-
-	if (vma->vm_file)
-		fput(vma->vm_file);
-	vma->vm_file = file;
-	vma->vm_ops = &generic_file_vm_ops;
-	return 0;
-}
-
-int shmem_unuse(swp_entry_t entry, struct page *page)
-{
-	return 0;
-}
