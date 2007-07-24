From: akpm@linux-foundation.org
Subject: + slab-api-remove-useless-ctor-parameter-and-reorder-parameters.patch added to -mm tree
Date: Tue, 24 Jul 2007 15:08:58 -0700
Message-ID: <200707242208.l6OM8xl6003413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44929 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755829AbXGXWJO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 18:09:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, penberg@cs.helsinki.fi


The patch titled
     Slab API: remove useless ctor parameter and reorder parameters
has been added to the -mm tree.  Its filename is
     slab-api-remove-useless-ctor-parameter-and-reorder-parameters.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Slab API: remove useless ctor parameter and reorder parameters
From: Christoph Lameter <clameter@sgi.com>

Slab constructors currently have a flags parameter that is never used. And
the order of the arguments is opposite to other slab functions. The object
pointer is placed before the kmem_cache pointer.

Convert

	ctor(void *object, struct kmem_cache *s, unsigned long flags)

to

	ctor(struct kmem_cache *s, void *object)

throughout the kernel

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-s3c24xx/dma.c      |    2 +-
 arch/arm26/mm/memc.c             |    4 ++--
 arch/i386/mm/pgtable.c           |    2 +-
 arch/powerpc/kernel/rtas_flash.c |    2 +-
 arch/powerpc/mm/hugetlbpage.c    |    2 +-
 arch/powerpc/mm/init_64.c        |    2 +-
 arch/sh/mm/pmb.c                 |    3 +--
 drivers/mtd/ubi/eba.c            |    3 +--
 drivers/usb/mon/mon_text.c       |    4 ++--
 fs/block_dev.c                   |    2 +-
 fs/cifs/cifsfs.c                 |    2 +-
 fs/ext2/super.c                  |    2 +-
 fs/ext3/super.c                  |    2 +-
 fs/fuse/inode.c                  |    3 +--
 fs/inode.c                       |    2 +-
 fs/isofs/inode.c                 |    2 +-
 fs/locks.c                       |    2 +-
 fs/nfs/inode.c                   |    2 +-
 fs/proc/inode.c                  |    2 +-
 fs/reiserfs/super.c              |    2 +-
 fs/udf/super.c                   |    2 +-
 fs/xfs/linux-2.6/kmem.h          |    2 +-
 fs/xfs/linux-2.6/xfs_super.c     |    3 +--
 include/linux/slub_def.h         |    2 +-
 ipc/mqueue.c                     |    2 +-
 kernel/fork.c                    |    3 +--
 lib/idr.c                        |    3 +--
 lib/radix-tree.c                 |    2 +-
 mm/rmap.c                        |    3 +--
 mm/shmem.c                       |    3 +--
 mm/slab.c                        |   11 +++++------
 mm/slob.c                        |    6 +++---
 mm/slub.c                        |    8 ++++----
 net/socket.c                     |    2 +-
 34 files changed, 45 insertions(+), 54 deletions(-)

diff -puN arch/arm/plat-s3c24xx/dma.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters arch/arm/plat-s3c24xx/dma.c
--- a/arch/arm/plat-s3c24xx/dma.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/arch/arm/plat-s3c24xx/dma.c
@@ -1272,7 +1272,7 @@ struct sysdev_class dma_sysclass = {
 
 /* kmem cache implementation */
 
-static void s3c2410_dma_cache_ctor(void *p, struct kmem_cache *c, unsigned long f)
+static void s3c2410_dma_cache_ctor(struct kmem_cache *c, void *p)
 {
 	memset(p, 0, sizeof(struct s3c2410_dma_buf));
 }
diff -puN arch/arm26/mm/memc.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters arch/arm26/mm/memc.c
--- a/arch/arm26/mm/memc.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/arch/arm26/mm/memc.c
@@ -162,12 +162,12 @@ void __init create_memmap_holes(struct m
 {
 }
 
-static void pte_cache_ctor(void *pte, struct kmem_cache *cache, unsigned long flags)
+static void pte_cache_ctor(struct kmem_cache *cache, void *pte)
 {
 	memzero(pte, sizeof(pte_t) * PTRS_PER_PTE);
 }
 
-static void pgd_cache_ctor(void *pgd, struct kmem_cache *cache, unsigned long flags)
+static void pgd_cache_ctor(struct kmem_cache *cache, void *pgd)
 {
 	memzero(pgd + MEMC_TABLE_SIZE, USER_PTRS_PER_PGD * sizeof(pgd_t));
 }
diff -puN arch/i386/mm/pgtable.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters arch/i386/mm/pgtable.c
--- a/arch/i386/mm/pgtable.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/arch/i386/mm/pgtable.c
@@ -193,7 +193,7 @@ struct page *pte_alloc_one(struct mm_str
 	return pte;
 }
 
-void pmd_ctor(void *pmd, struct kmem_cache *cache, unsigned long flags)
+void pmd_ctor(struct kmem_cache *cache, void *pmd)
 {
 	memset(pmd, 0, PTRS_PER_PMD*sizeof(pmd_t));
 }
diff -puN arch/powerpc/kernel/rtas_flash.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters arch/powerpc/kernel/rtas_flash.c
--- a/arch/powerpc/kernel/rtas_flash.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/arch/powerpc/kernel/rtas_flash.c
@@ -286,7 +286,7 @@ static ssize_t rtas_flash_read(struct fi
 }
 
 /* constructor for flash_block_cache */
-void rtas_block_ctor(void *ptr, struct kmem_cache *cache, unsigned long flags)
+void rtas_block_ctor(struct kmem_cache *cache, void *ptr)
 {
 	memset(ptr, 0, RTAS_BLK_SIZE);
 }
diff -puN arch/powerpc/mm/hugetlbpage.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -528,7 +528,7 @@ repeat:
 	return err;
 }
 
-static void zero_ctor(void *addr, struct kmem_cache *cache, unsigned long flags)
+static void zero_ctor(struct kmem_cache *cache, void *addr)
 {
 	memset(addr, 0, kmem_cache_size(cache));
 }
diff -puN arch/powerpc/mm/init_64.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters arch/powerpc/mm/init_64.c
--- a/arch/powerpc/mm/init_64.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/arch/powerpc/mm/init_64.c
@@ -140,7 +140,7 @@ static int __init setup_kcore(void)
 }
 module_init(setup_kcore);
 
-static void zero_ctor(void *addr, struct kmem_cache *cache, unsigned long flags)
+static void zero_ctor(struct kmem_cache *cache, void *addr)
 {
 	memset(addr, 0, kmem_cache_size(cache));
 }
diff -puN arch/sh/mm/pmb.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters arch/sh/mm/pmb.c
--- a/arch/sh/mm/pmb.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/arch/sh/mm/pmb.c
@@ -292,8 +292,7 @@ void pmb_unmap(unsigned long addr)
 	} while (pmbe);
 }
 
-static void pmb_cache_ctor(void *pmb, struct kmem_cache *cachep,
-			   unsigned long flags)
+static void pmb_cache_ctor(struct kmem_cache *cachep, void *pmb)
 {
 	struct pmb_entry *pmbe = pmb;
 
diff -puN drivers/mtd/ubi/eba.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters drivers/mtd/ubi/eba.c
--- a/drivers/mtd/ubi/eba.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/drivers/mtd/ubi/eba.c
@@ -937,8 +937,7 @@ write_error:
  * @cache: the lock tree entry slab cache
  * @flags: constructor flags
  */
-static void ltree_entry_ctor(void *obj, struct kmem_cache *cache,
-			     unsigned long flags)
+static void ltree_entry_ctor(struct kmem_cache *cache, void *obj)
 {
 	struct ltree_entry *le = obj;
 
diff -puN drivers/usb/mon/mon_text.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters drivers/usb/mon/mon_text.c
--- a/drivers/usb/mon/mon_text.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/drivers/usb/mon/mon_text.c
@@ -84,7 +84,7 @@ struct mon_reader_text {
 
 static struct dentry *mon_dir;		/* Usually /sys/kernel/debug/usbmon */
 
-static void mon_text_ctor(void *, struct kmem_cache *, unsigned long);
+static void mon_text_ctor(struct kmem_cache *, void *);
 
 struct mon_text_ptr {
 	int cnt, limit;
@@ -718,7 +718,7 @@ void mon_text_del(struct mon_bus *mbus)
 /*
  * Slab interface: constructor.
  */
-static void mon_text_ctor(void *mem, struct kmem_cache *slab, unsigned long sflags)
+static void mon_text_ctor(struct kmem_cache *slab, void *mem)
 {
 	/*
 	 * Nothing to initialize. No, really!
diff -puN fs/block_dev.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/block_dev.c
--- a/fs/block_dev.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/block_dev.c
@@ -465,7 +465,7 @@ static void bdev_destroy_inode(struct in
 	kmem_cache_free(bdev_cachep, bdi);
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache * cachep, void *foo)
 {
 	struct bdev_inode *ei = (struct bdev_inode *) foo;
 	struct block_device *bdev = &ei->bdev;
diff -puN fs/cifs/cifsfs.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/cifs/cifsfs.c
@@ -704,7 +704,7 @@ const struct file_operations cifs_dir_op
 };
 
 static void
-cifs_init_once(void *inode, struct kmem_cache *cachep, unsigned long flags)
+cifs_init_once(struct kmem_cache *cachep, void *inode)
 {
 	struct cifsInodeInfo *cifsi = inode;
 
diff -puN fs/ext2/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/ext2/super.c
--- a/fs/ext2/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/ext2/super.c
@@ -158,7 +158,7 @@ static void ext2_destroy_inode(struct in
 	kmem_cache_free(ext2_inode_cachep, EXT2_I(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache * cachep, void *foo)
 {
 	struct ext2_inode_info *ei = (struct ext2_inode_info *) foo;
 
diff -puN fs/ext3/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/ext3/super.c
--- a/fs/ext3/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/ext3/super.c
@@ -472,7 +472,7 @@ static void ext3_destroy_inode(struct in
 	kmem_cache_free(ext3_inode_cachep, EXT3_I(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache * cachep, void *foo)
 {
 	struct ext3_inode_info *ei = (struct ext3_inode_info *) foo;
 
diff -puN fs/fuse/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/fuse/inode.c
--- a/fs/fuse/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/fuse/inode.c
@@ -704,8 +704,7 @@ static inline void unregister_fuseblk(vo
 static decl_subsys(fuse, NULL, NULL);
 static decl_subsys(connections, NULL, NULL);
 
-static void fuse_inode_init_once(void *foo, struct kmem_cache *cachep,
-				 unsigned long flags)
+static void fuse_inode_init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct inode * inode = foo;
 
diff -puN fs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/inode.c
--- a/fs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/inode.c
@@ -218,7 +218,7 @@ void inode_init_once(struct inode *inode
 
 EXPORT_SYMBOL(inode_init_once);
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache * cachep, void *foo)
 {
 	struct inode * inode = (struct inode *) foo;
 
diff -puN fs/isofs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/isofs/inode.c
--- a/fs/isofs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/isofs/inode.c
@@ -73,7 +73,7 @@ static void isofs_destroy_inode(struct i
 	kmem_cache_free(isofs_inode_cachep, ISOFS_I(inode));
 }
 
-static void init_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct iso_inode_info *ei = foo;
 
diff -puN fs/locks.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/locks.c
--- a/fs/locks.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/locks.c
@@ -199,7 +199,7 @@ EXPORT_SYMBOL(locks_init_lock);
  * Initialises the fields of the file lock which are invariant for
  * free file_locks.
  */
-static void init_once(void *foo, struct kmem_cache *cache, unsigned long flags)
+static void init_once(struct kmem_cache *cache, void *foo)
 {
 	struct file_lock *lock = (struct file_lock *) foo;
 
diff -puN fs/nfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/nfs/inode.c
--- a/fs/nfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/nfs/inode.c
@@ -1151,7 +1151,7 @@ static inline void nfs4_init_once(struct
 #endif
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache * cachep, void *foo)
 {
 	struct nfs_inode *nfsi = (struct nfs_inode *) foo;
 
diff -puN fs/proc/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/proc/inode.c
--- a/fs/proc/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/proc/inode.c
@@ -106,7 +106,7 @@ static void proc_destroy_inode(struct in
 	kmem_cache_free(proc_inode_cachep, PROC_I(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache * cachep, void *foo)
 {
 	struct proc_inode *ei = (struct proc_inode *) foo;
 
diff -puN fs/reiserfs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/reiserfs/super.c
@@ -508,7 +508,7 @@ static void reiserfs_destroy_inode(struc
 	kmem_cache_free(reiserfs_inode_cachep, REISERFS_I(inode));
 }
 
-static void init_once(void *foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache * cachep, void *foo)
 {
 	struct reiserfs_inode_info *ei = (struct reiserfs_inode_info *)foo;
 
diff -puN fs/udf/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/udf/super.c
--- a/fs/udf/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/udf/super.c
@@ -134,7 +134,7 @@ static void udf_destroy_inode(struct ino
 	kmem_cache_free(udf_inode_cachep, UDF_I(inode));
 }
 
-static void init_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct udf_inode_info *ei = (struct udf_inode_info *)foo;
 
diff -puN fs/xfs/linux-2.6/kmem.h~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/xfs/linux-2.6/kmem.h
--- a/fs/xfs/linux-2.6/kmem.h~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/xfs/linux-2.6/kmem.h
@@ -79,7 +79,7 @@ kmem_zone_init(int size, char *zone_name
 
 static inline kmem_zone_t *
 kmem_zone_init_flags(int size, char *zone_name, unsigned long flags,
-		     void (*construct)(void *, kmem_zone_t *, unsigned long))
+		     void (*construct)(kmem_zone_t *, void *))
 {
 	return kmem_cache_create(zone_name, size, 0, flags, construct);
 }
diff -puN fs/xfs/linux-2.6/xfs_super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/xfs/linux-2.6/xfs_super.c
--- a/fs/xfs/linux-2.6/xfs_super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/xfs/linux-2.6/xfs_super.c
@@ -356,9 +356,8 @@ xfs_fs_destroy_inode(
 
 STATIC void
 xfs_fs_inode_init_once(
-	void			*vnode,
 	kmem_zone_t		*zonep,
-	unsigned long		flags)
+	void			*vnode)
 {
 	inode_init_once(vn_to_inode((bhv_vnode_t *)vnode));
 }
diff -puN include/linux/slub_def.h~slab-api-remove-useless-ctor-parameter-and-reorder-parameters include/linux/slub_def.h
--- a/include/linux/slub_def.h~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/include/linux/slub_def.h
@@ -41,7 +41,7 @@ struct kmem_cache {
 	/* Allocation and freeing of slabs */
 	int objects;		/* Number of objects in slab */
 	int refcount;		/* Refcount for slab cache destroy */
-	void (*ctor)(void *, struct kmem_cache *, unsigned long);
+	void (*ctor)(struct kmem_cache *, void *);
 	int inuse;		/* Offset to metadata */
 	int align;		/* Alignment */
 	const char *name;	/* Name (only for display!) */
diff -puN ipc/mqueue.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters ipc/mqueue.c
--- a/ipc/mqueue.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/ipc/mqueue.c
@@ -211,7 +211,7 @@ static int mqueue_get_sb(struct file_sys
 	return get_sb_single(fs_type, flags, data, mqueue_fill_super, mnt);
 }
 
-static void init_once(void *foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct mqueue_inode_info *p = (struct mqueue_inode_info *) foo;
 
diff -puN kernel/fork.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters kernel/fork.c
--- a/kernel/fork.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/kernel/fork.c
@@ -1450,8 +1450,7 @@ long do_fork(unsigned long clone_flags,
 #define ARCH_MIN_MMSTRUCT_ALIGN 0
 #endif
 
-static void sighand_ctor(void *data, struct kmem_cache *cachep,
-			unsigned long flags)
+static void sighand_ctor(struct kmem_cache *cachep, void *data)
 {
 	struct sighand_struct *sighand = data;
 
diff -puN lib/idr.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters lib/idr.c
--- a/lib/idr.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/lib/idr.c
@@ -580,8 +580,7 @@ void *idr_replace(struct idr *idp, void 
 }
 EXPORT_SYMBOL(idr_replace);
 
-static void idr_cache_ctor(void * idr_layer, struct kmem_cache *idr_layer_cache,
-		unsigned long flags)
+static void idr_cache_ctor(struct kmem_cache *idr_layer_cache, void *idr_layer)
 {
 	memset(idr_layer, 0, sizeof(struct idr_layer));
 }
diff -puN lib/radix-tree.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters lib/radix-tree.c
--- a/lib/radix-tree.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/lib/radix-tree.c
@@ -1012,7 +1012,7 @@ int radix_tree_tagged(struct radix_tree_
 EXPORT_SYMBOL(radix_tree_tagged);
 
 static void
-radix_tree_node_ctor(void *node, struct kmem_cache *cachep, unsigned long flags)
+radix_tree_node_ctor(struct kmem_cache *cachep, void *node)
 {
 	memset(node, 0, sizeof(struct radix_tree_node));
 }
diff -puN mm/rmap.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters mm/rmap.c
--- a/mm/rmap.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/mm/rmap.c
@@ -137,8 +137,7 @@ void anon_vma_unlink(struct vm_area_stru
 		anon_vma_free(anon_vma);
 }
 
-static void anon_vma_ctor(void *data, struct kmem_cache *cachep,
-			  unsigned long flags)
+static void anon_vma_ctor(struct kmem_cache *cachep, void *data)
 {
 	struct anon_vma *anon_vma = data;
 
diff -puN mm/shmem.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters mm/shmem.c
--- a/mm/shmem.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/mm/shmem.c
@@ -2326,8 +2326,7 @@ static void shmem_destroy_inode(struct i
 	kmem_cache_free(shmem_inode_cachep, SHMEM_I(inode));
 }
 
-static void init_once(void *foo, struct kmem_cache *cachep,
-		      unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct shmem_inode_info *p = (struct shmem_inode_info *) foo;
 
diff -puN mm/slab.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters mm/slab.c
--- a/mm/slab.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/mm/slab.c
@@ -408,7 +408,7 @@ struct kmem_cache {
 	unsigned int dflags;		/* dynamic flags */
 
 	/* constructor func */
-	void (*ctor) (void *, struct kmem_cache *, unsigned long);
+	void (*ctor)(struct kmem_cache *, void *);
 
 /* 5) cache creation/removal */
 	const char *name;
@@ -2126,7 +2126,7 @@ static int __init_refok setup_cpu_cache(
 struct kmem_cache *
 kmem_cache_create (const char *name, size_t size, size_t align,
 	unsigned long flags,
-	void (*ctor)(void*, struct kmem_cache *, unsigned long))
+	void (*ctor)(struct kmem_cache *, void *))
 {
 	size_t left_over, slab_size, ralign;
 	struct kmem_cache *cachep = NULL, *pc;
@@ -2633,8 +2633,7 @@ static void cache_init_objs(struct kmem_
 		 * They must also be threaded.
 		 */
 		if (cachep->ctor && !(cachep->flags & SLAB_POISON))
-			cachep->ctor(objp + obj_offset(cachep), cachep,
-				     0);
+			cachep->ctor(cachep, objp + obj_offset(cachep));
 
 		if (cachep->flags & SLAB_RED_ZONE) {
 			if (*dbg_redzone2(cachep, objp) != RED_INACTIVE)
@@ -2650,7 +2649,7 @@ static void cache_init_objs(struct kmem_
 					 cachep->buffer_size / PAGE_SIZE, 0);
 #else
 		if (cachep->ctor)
-			cachep->ctor(objp, cachep, 0);
+			cachep->ctor(cachep, objp);
 #endif
 		slab_bufctl(slabp)[i] = i + 1;
 	}
@@ -3075,7 +3074,7 @@ static void *cache_alloc_debugcheck_afte
 #endif
 	objp += obj_offset(cachep);
 	if (cachep->ctor && cachep->flags & SLAB_POISON)
-		cachep->ctor(objp, cachep, 0);
+		cachep->ctor(cachep, objp);
 #if ARCH_SLAB_MINALIGN
 	if ((u32)objp & (ARCH_SLAB_MINALIGN-1)) {
 		printk(KERN_ERR "0x%p: not aligned to ARCH_SLAB_MINALIGN=%d\n",
diff -puN mm/slob.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters mm/slob.c
--- a/mm/slob.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/mm/slob.c
@@ -498,12 +498,12 @@ struct kmem_cache {
 	unsigned int size, align;
 	unsigned long flags;
 	const char *name;
-	void (*ctor)(void *, struct kmem_cache *, unsigned long);
+	void (*ctor)(struct kmem_cache *, void *);
 };
 
 struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 	size_t align, unsigned long flags,
-	void (*ctor)(void*, struct kmem_cache *, unsigned long))
+	void (*ctor)(struct kmem_cache *, void *))
 {
 	struct kmem_cache *c;
 
@@ -547,7 +547,7 @@ void *kmem_cache_alloc_node(struct kmem_
 		b = slob_new_page(flags, get_order(c->size), node);
 
 	if (c->ctor)
-		c->ctor(b, c, 0);
+		c->ctor(c, b);
 
 	return b;
 }
diff -puN mm/slub.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters mm/slub.c
--- a/mm/slub.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/mm/slub.c
@@ -1076,7 +1076,7 @@ static void setup_object(struct kmem_cac
 {
 	setup_object_debug(s, page, object);
 	if (unlikely(s->ctor))
-		s->ctor(object, s, 0);
+		s->ctor(s, object);
 }
 
 static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
@@ -2088,7 +2088,7 @@ static int calculate_sizes(struct kmem_c
 static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
 		const char *name, size_t size,
 		size_t align, unsigned long flags,
-		void (*ctor)(void *, struct kmem_cache *, unsigned long))
+		void (*ctor)(struct kmem_cache *, void *))
 {
 	memset(s, 0, kmem_size);
 	s->name = name;
@@ -2650,7 +2650,7 @@ static int slab_unmergeable(struct kmem_
 
 static struct kmem_cache *find_mergeable(size_t size,
 		size_t align, unsigned long flags,
-		void (*ctor)(void *, struct kmem_cache *, unsigned long))
+		void (*ctor)(struct kmem_cache *, void *))
 {
 	struct kmem_cache *s;
 
@@ -2691,7 +2691,7 @@ static struct kmem_cache *find_mergeable
 
 struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 		size_t align, unsigned long flags,
-		void (*ctor)(void *, struct kmem_cache *, unsigned long))
+		void (*ctor)(struct kmem_cache *, void *))
 {
 	struct kmem_cache *s;
 
diff -puN net/socket.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters net/socket.c
--- a/net/socket.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/net/socket.c
@@ -257,7 +257,7 @@ static void sock_destroy_inode(struct in
 			container_of(inode, struct socket_alloc, vfs_inode));
 }
 
-static void init_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct socket_alloc *ei = (struct socket_alloc *)foo;
 
_

Patches currently in -mm which might be from clameter@sgi.com are

check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on.patch
slab-maintainer-credits-update.patch
slab-correctly-handle-__gfp_zero.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
try-parent-numa_node-at-first-before-using-default-v2.patch
try-parent-numa_node-at-first-before-using-default-v2-fix.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
memory-unplug-v7-migration-by-kernel.patch
memory-unplug-v7-isolate_lru_page-fix.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix.patch
page-owner-tracking-leak-detector.patch
