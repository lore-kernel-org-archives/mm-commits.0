From: akpm@linux-foundation.org
Subject: + slab-api-remove-useless-ctor-parameter-and-reorder-parameters.patch added to -mm tree
Date: Sat, 15 Sep 2007 00:23:46 -0700
Message-ID: <200709150723.l8F7NkN0021097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38319 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706AbXIOHXw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 15 Sep 2007 03:23:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


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

Slab constructors currently have a flags parameter that is never used.  And
the order of the arguments is opposite to other slab functions.  The object
pointer is placed before the kmem_cache pointer.

Convert

        ctor(void *object, struct kmem_cache *s, unsigned long flags)

to

        ctor(struct kmem_cache *s, void *object)

throughout the kernel

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-s3c24xx/dma.c               |    2 +-
 arch/i386/mm/pgtable.c                    |    2 +-
 arch/powerpc/kernel/rtas_flash.c          |    2 +-
 arch/powerpc/mm/hugetlbpage.c             |    2 +-
 arch/powerpc/mm/init_64.c                 |    2 +-
 arch/powerpc/platforms/cell/spufs/inode.c |    2 +-
 arch/sh/mm/pmb.c                          |    3 +--
 drivers/mtd/ubi/eba.c                     |    3 +--
 drivers/usb/mon/mon_text.c                |    4 ++--
 fs/adfs/super.c                           |    2 +-
 fs/affs/super.c                           |    2 +-
 fs/afs/super.c                            |    6 ++----
 fs/befs/linuxvfs.c                        |    2 +-
 fs/bfs/inode.c                            |    2 +-
 fs/block_dev.c                            |    2 +-
 fs/cifs/cifsfs.c                          |    2 +-
 fs/coda/inode.c                           |    2 +-
 fs/ecryptfs/main.c                        |    2 +-
 fs/efs/super.c                            |    2 +-
 fs/ext2/super.c                           |    2 +-
 fs/ext3/super.c                           |    2 +-
 fs/ext4/super.c                           |    2 +-
 fs/fat/cache.c                            |    2 +-
 fs/fat/inode.c                            |    2 +-
 fs/fuse/inode.c                           |    3 +--
 fs/gfs2/main.c                            |    4 ++--
 fs/hfs/super.c                            |    2 +-
 fs/hfsplus/super.c                        |    2 +-
 fs/hpfs/super.c                           |    2 +-
 fs/hugetlbfs/inode.c                      |    2 +-
 fs/inode.c                                |    2 +-
 fs/isofs/inode.c                          |    2 +-
 fs/jffs2/super.c                          |    2 +-
 fs/jfs/jfs_metapage.c                     |    2 +-
 fs/jfs/super.c                            |    2 +-
 fs/locks.c                                |    2 +-
 fs/minix/inode.c                          |    2 +-
 fs/ncpfs/inode.c                          |    2 +-
 fs/nfs/inode.c                            |    2 +-
 fs/ntfs/super.c                           |    3 +--
 fs/ocfs2/dlm/dlmfs.c                      |    5 ++---
 fs/ocfs2/super.c                          |    4 +---
 fs/openpromfs/inode.c                     |    2 +-
 fs/proc/inode.c                           |    2 +-
 fs/qnx4/inode.c                           |    3 +--
 fs/reiserfs/super.c                       |    2 +-
 fs/romfs/inode.c                          |    2 +-
 fs/smbfs/inode.c                          |    2 +-
 fs/sysv/inode.c                           |    2 +-
 fs/udf/super.c                            |    2 +-
 fs/ufs/super.c                            |    2 +-
 fs/xfs/linux-2.6/kmem.h                   |    2 +-
 fs/xfs/linux-2.6/xfs_super.c              |    3 +--
 include/asm-i386/pgtable.h                |    2 +-
 include/linux/slab.h                      |    2 +-
 include/linux/slub_def.h                  |    2 +-
 ipc/mqueue.c                              |    2 +-
 kernel/fork.c                             |    3 +--
 lib/idr.c                                 |    3 +--
 lib/radix-tree.c                          |    2 +-
 mm/rmap.c                                 |    3 +--
 mm/shmem.c                                |    3 +--
 mm/slab.c                                 |   11 +++++------
 mm/slob.c                                 |    6 +++---
 mm/slub.c                                 |   10 +++++-----
 net/socket.c                              |    2 +-
 net/sunrpc/rpc_pipe.c                     |    2 +-
 67 files changed, 81 insertions(+), 97 deletions(-)

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
diff -puN arch/i386/mm/pgtable.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters arch/i386/mm/pgtable.c
--- a/arch/i386/mm/pgtable.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/arch/i386/mm/pgtable.c
@@ -196,7 +196,7 @@ struct page *pte_alloc_one(struct mm_str
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
@@ -525,7 +525,7 @@ repeat:
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
diff -puN arch/powerpc/platforms/cell/spufs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters arch/powerpc/platforms/cell/spufs/inode.c
--- a/arch/powerpc/platforms/cell/spufs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/arch/powerpc/platforms/cell/spufs/inode.c
@@ -67,7 +67,7 @@ spufs_destroy_inode(struct inode *inode)
 }
 
 static void
-spufs_init_once(void *p, struct kmem_cache * cachep, unsigned long flags)
+spufs_init_once(struct kmem_cache *cachep, void *p)
 {
 	struct spufs_inode_info *ei = p;
 
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
@@ -932,8 +932,7 @@ write_error:
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
@@ -87,7 +87,7 @@ struct mon_reader_text {
 
 static struct dentry *mon_dir;		/* Usually /sys/kernel/debug/usbmon */
 
-static void mon_text_ctor(void *, struct kmem_cache *, unsigned long);
+static void mon_text_ctor(struct kmem_cache *, void *);
 
 struct mon_text_ptr {
 	int cnt, limit;
@@ -720,7 +720,7 @@ void mon_text_del(struct mon_bus *mbus)
 /*
  * Slab interface: constructor.
  */
-static void mon_text_ctor(void *mem, struct kmem_cache *slab, unsigned long sflags)
+static void mon_text_ctor(struct kmem_cache *slab, void *mem)
 {
 	/*
 	 * Nothing to initialize. No, really!
diff -puN fs/adfs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/adfs/super.c
--- a/fs/adfs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/adfs/super.c
@@ -228,7 +228,7 @@ static void adfs_destroy_inode(struct in
 	kmem_cache_free(adfs_inode_cachep, ADFS_I(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct adfs_inode_info *ei = (struct adfs_inode_info *) foo;
 
diff -puN fs/affs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/affs/super.c
--- a/fs/affs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/affs/super.c
@@ -84,7 +84,7 @@ static void affs_destroy_inode(struct in
 	kmem_cache_free(affs_inode_cachep, AFFS_I(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct affs_inode_info *ei = (struct affs_inode_info *) foo;
 
diff -puN fs/afs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/afs/super.c
--- a/fs/afs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/afs/super.c
@@ -27,8 +27,7 @@
 
 #define AFS_FS_MAGIC 0x6B414653 /* 'kAFS' */
 
-static void afs_i_init_once(void *foo, struct kmem_cache *cachep,
-			    unsigned long flags);
+static void afs_i_init_once(struct kmem_cache *cachep, void *foo);
 static int afs_get_sb(struct file_system_type *fs_type,
 		      int flags, const char *dev_name,
 		      void *data, struct vfsmount *mnt);
@@ -446,8 +445,7 @@ static void afs_put_super(struct super_b
 /*
  * initialise an inode cache slab element prior to any use
  */
-static void afs_i_init_once(void *_vnode, struct kmem_cache *cachep,
-			    unsigned long flags)
+static void afs_i_init_once(struct kmem_cache *cachep, void *_vnode)
 {
 	struct afs_vnode *vnode = _vnode;
 
diff -puN fs/befs/linuxvfs.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/befs/linuxvfs.c
@@ -289,7 +289,7 @@ befs_destroy_inode(struct inode *inode)
         kmem_cache_free(befs_inode_cachep, BEFS_I(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
         struct befs_inode_info *bi = (struct befs_inode_info *) foo;
 
diff -puN fs/bfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/bfs/inode.c
--- a/fs/bfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/bfs/inode.c
@@ -244,7 +244,7 @@ static void bfs_destroy_inode(struct ino
 	kmem_cache_free(bfs_inode_cachep, BFS_I(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct bfs_inode_info *bi = foo;
 
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
 
diff -puN fs/coda/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/coda/inode.c
--- a/fs/coda/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/coda/inode.c
@@ -58,7 +58,7 @@ static void coda_destroy_inode(struct in
 	kmem_cache_free(coda_inode_cachep, ITOC(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache * cachep, void *foo)
 {
 	struct coda_inode_info *ei = (struct coda_inode_info *) foo;
 
diff -puN fs/ecryptfs/main.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/ecryptfs/main.c
@@ -579,7 +579,7 @@ static struct file_system_type ecryptfs_
  * Initializes the ecryptfs_inode_info_cache when it is created
  */
 static void
-inode_info_init_once(void *vptr, struct kmem_cache *cachep, unsigned long flags)
+inode_info_init_once(struct kmem_cache *cachep, void *vptr)
 {
 	struct ecryptfs_inode_info *ei = (struct ecryptfs_inode_info *)vptr;
 
diff -puN fs/efs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/efs/super.c
--- a/fs/efs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/efs/super.c
@@ -69,7 +69,7 @@ static void efs_destroy_inode(struct ino
 	kmem_cache_free(efs_inode_cachep, INODE_INFO(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct efs_inode_info *ei = (struct efs_inode_info *) foo;
 
diff -puN fs/ext2/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/ext2/super.c
--- a/fs/ext2/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/ext2/super.c
@@ -157,7 +157,7 @@ static void ext2_destroy_inode(struct in
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
 
diff -puN fs/ext4/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/ext4/super.c
--- a/fs/ext4/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/ext4/super.c
@@ -523,7 +523,7 @@ static void ext4_destroy_inode(struct in
 	kmem_cache_free(ext4_inode_cachep, EXT4_I(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct ext4_inode_info *ei = (struct ext4_inode_info *) foo;
 
diff -puN fs/fat/cache.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/fat/cache.c
--- a/fs/fat/cache.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/fat/cache.c
@@ -36,7 +36,7 @@ static inline int fat_max_cache(struct i
 
 static struct kmem_cache *fat_cache_cachep;
 
-static void init_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct fat_cache *cache = (struct fat_cache *)foo;
 
diff -puN fs/fat/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/fat/inode.c
--- a/fs/fat/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/fat/inode.c
@@ -501,7 +501,7 @@ static void fat_destroy_inode(struct ino
 	kmem_cache_free(fat_inode_cachep, MSDOS_I(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct msdos_inode_info *ei = (struct msdos_inode_info *)foo;
 
diff -puN fs/fuse/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/fuse/inode.c
--- a/fs/fuse/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/fuse/inode.c
@@ -692,8 +692,7 @@ static inline void unregister_fuseblk(vo
 static decl_subsys(fuse, NULL, NULL);
 static decl_subsys(connections, NULL, NULL);
 
-static void fuse_inode_init_once(void *foo, struct kmem_cache *cachep,
-				 unsigned long flags)
+static void fuse_inode_init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct inode * inode = foo;
 
diff -puN fs/gfs2/main.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/gfs2/main.c
--- a/fs/gfs2/main.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/gfs2/main.c
@@ -24,7 +24,7 @@
 #include "util.h"
 #include "glock.h"
 
-static void gfs2_init_inode_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
+static void gfs2_init_inode_once(struct kmem_cache *cachep, void *foo)
 {
 	struct gfs2_inode *ip = foo;
 
@@ -34,7 +34,7 @@ static void gfs2_init_inode_once(void *f
 	memset(ip->i_cache, 0, sizeof(ip->i_cache));
 }
 
-static void gfs2_init_glock_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
+static void gfs2_init_glock_once(struct kmem_cache *cachep, void *foo)
 {
 	struct gfs2_glock *gl = foo;
 
diff -puN fs/hfsplus/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/hfsplus/super.c
@@ -466,7 +466,7 @@ static struct file_system_type hfsplus_f
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 
-static void hfsplus_init_once(void *p, struct kmem_cache *cachep, unsigned long flags)
+static void hfsplus_init_once(struct kmem_cache *cachep, void *p)
 {
 	struct hfsplus_inode_info *i = p;
 
diff -puN fs/hfs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/hfs/super.c
--- a/fs/hfs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/hfs/super.c
@@ -430,7 +430,7 @@ static struct file_system_type hfs_fs_ty
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 
-static void hfs_init_once(void *p, struct kmem_cache *cachep, unsigned long flags)
+static void hfs_init_once(struct kmem_cache *cachep, void *p)
 {
 	struct hfs_inode_info *i = p;
 
diff -puN fs/hpfs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/hpfs/super.c
--- a/fs/hpfs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/hpfs/super.c
@@ -173,7 +173,7 @@ static void hpfs_destroy_inode(struct in
 	kmem_cache_free(hpfs_inode_cachep, hpfs_i(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct hpfs_inode_info *ei = (struct hpfs_inode_info *) foo;
 
diff -puN fs/hugetlbfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/hugetlbfs/inode.c
@@ -687,7 +687,7 @@ static const struct address_space_operat
 };
 
 
-static void init_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct hugetlbfs_inode_info *ei = (struct hugetlbfs_inode_info *)foo;
 
diff -puN fs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/inode.c
--- a/fs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/inode.c
@@ -209,7 +209,7 @@ void inode_init_once(struct inode *inode
 
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
 
diff -puN fs/jffs2/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/jffs2/super.c
--- a/fs/jffs2/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/jffs2/super.c
@@ -43,7 +43,7 @@ static void jffs2_destroy_inode(struct i
 	kmem_cache_free(jffs2_inode_cachep, JFFS2_INODE_INFO(inode));
 }
 
-static void jffs2_i_init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void jffs2_i_init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct jffs2_inode_info *ei = (struct jffs2_inode_info *) foo;
 
diff -puN fs/jfs/jfs_metapage.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/jfs/jfs_metapage.c
--- a/fs/jfs/jfs_metapage.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/jfs/jfs_metapage.c
@@ -180,7 +180,7 @@ static inline void remove_metapage(struc
 
 #endif
 
-static void init_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct metapage *mp = (struct metapage *)foo;
 
diff -puN fs/jfs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/jfs/super.c
--- a/fs/jfs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/jfs/super.c
@@ -750,7 +750,7 @@ static struct file_system_type jfs_fs_ty
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 
-static void init_once(void *foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct jfs_inode_info *jfs_ip = (struct jfs_inode_info *) foo;
 
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
 
diff -puN fs/minix/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/minix/inode.c
--- a/fs/minix/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/minix/inode.c
@@ -69,7 +69,7 @@ static void minix_destroy_inode(struct i
 	kmem_cache_free(minix_inode_cachep, minix_i(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache * cachep, void *foo)
 {
 	struct minix_inode_info *ei = (struct minix_inode_info *) foo;
 
diff -puN fs/ncpfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/ncpfs/inode.c
@@ -56,7 +56,7 @@ static void ncp_destroy_inode(struct ino
 	kmem_cache_free(ncp_inode_cachep, NCP_FINFO(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct ncp_inode_info *ei = (struct ncp_inode_info *) foo;
 
diff -puN fs/nfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/nfs/inode.c
--- a/fs/nfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/nfs/inode.c
@@ -1145,7 +1145,7 @@ static inline void nfs4_init_once(struct
 #endif
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache * cachep, void *foo)
 {
 	struct nfs_inode *nfsi = (struct nfs_inode *) foo;
 
diff -puN fs/ntfs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/ntfs/super.c
--- a/fs/ntfs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/ntfs/super.c
@@ -3080,8 +3080,7 @@ struct kmem_cache *ntfs_inode_cache;
 struct kmem_cache *ntfs_big_inode_cache;
 
 /* Init once constructor for the inode slab cache. */
-static void ntfs_big_inode_init_once(void *foo, struct kmem_cache *cachep,
-		unsigned long flags)
+static void ntfs_big_inode_init_once(struct kmem_cache *cachep, void *foo)
 {
 	ntfs_inode *ni = (ntfs_inode *)foo;
 
diff -puN fs/ocfs2/dlm/dlmfs.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/ocfs2/dlm/dlmfs.c
--- a/fs/ocfs2/dlm/dlmfs.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/ocfs2/dlm/dlmfs.c
@@ -255,9 +255,8 @@ static ssize_t dlmfs_file_write(struct f
 	return writelen;
 }
 
-static void dlmfs_init_once(void *foo,
-			    struct kmem_cache *cachep,
-			    unsigned long flags)
+static void dlmfs_init_once(struct kmem_cache *cachep,
+			    void *foo)
 {
 	struct dlmfs_inode_private *ip =
 		(struct dlmfs_inode_private *) foo;
diff -puN fs/ocfs2/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/ocfs2/super.c
@@ -1001,9 +1001,7 @@ bail:
 	return status;
 }
 
-static void ocfs2_inode_init_once(void *data,
-				  struct kmem_cache *cachep,
-				  unsigned long flags)
+static void ocfs2_inode_init_once(struct kmem_cache *cachep, void *data)
 {
 	struct ocfs2_inode_info *oi = data;
 
diff -puN fs/openpromfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/openpromfs/inode.c
--- a/fs/openpromfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/openpromfs/inode.c
@@ -415,7 +415,7 @@ static struct file_system_type openprom_
 	.kill_sb	= kill_anon_super,
 };
 
-static void op_inode_init_once(void *data, struct kmem_cache * cachep, unsigned long flags)
+static void op_inode_init_once(struct kmem_cache * cachep, void *data)
 {
 	struct op_inode_info *oi = (struct op_inode_info *) data;
 
diff -puN fs/proc/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/proc/inode.c
--- a/fs/proc/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/proc/inode.c
@@ -107,7 +107,7 @@ static void proc_destroy_inode(struct in
 	kmem_cache_free(proc_inode_cachep, PROC_I(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache * cachep, void *foo)
 {
 	struct proc_inode *ei = (struct proc_inode *) foo;
 
diff -puN fs/qnx4/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/qnx4/inode.c
--- a/fs/qnx4/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/qnx4/inode.c
@@ -536,8 +536,7 @@ static void qnx4_destroy_inode(struct in
 	kmem_cache_free(qnx4_inode_cachep, qnx4_i(inode));
 }
 
-static void init_once(void *foo, struct kmem_cache * cachep,
-		      unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct qnx4_inode_info *ei = (struct qnx4_inode_info *) foo;
 
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
 
diff -puN fs/romfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/romfs/inode.c
--- a/fs/romfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/romfs/inode.c
@@ -566,7 +566,7 @@ static void romfs_destroy_inode(struct i
 	kmem_cache_free(romfs_inode_cachep, ROMFS_I(inode));
 }
 
-static void init_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct romfs_inode_info *ei = foo;
 
diff -puN fs/smbfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/smbfs/inode.c
--- a/fs/smbfs/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/smbfs/inode.c
@@ -67,7 +67,7 @@ static void smb_destroy_inode(struct ino
 	kmem_cache_free(smb_inode_cachep, SMB_I(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct smb_inode_info *ei = (struct smb_inode_info *) foo;
 
diff -puN fs/sysv/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/sysv/inode.c
--- a/fs/sysv/inode.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/sysv/inode.c
@@ -318,7 +318,7 @@ static void sysv_destroy_inode(struct in
 	kmem_cache_free(sysv_inode_cachep, SYSV_I(inode));
 }
 
-static void init_once(void *p, struct kmem_cache *cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *p)
 {
 	struct sysv_inode_info *si = (struct sysv_inode_info *)p;
 
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
 
diff -puN fs/ufs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters fs/ufs/super.c
--- a/fs/ufs/super.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/fs/ufs/super.c
@@ -1234,7 +1234,7 @@ static void ufs_destroy_inode(struct ino
 	kmem_cache_free(ufs_inode_cachep, UFS_I(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(struct kmem_cache * cachep, void *foo)
 {
 	struct ufs_inode_info *ei = (struct ufs_inode_info *) foo;
 
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
@@ -347,9 +347,8 @@ xfs_fs_destroy_inode(
 
 STATIC void
 xfs_fs_inode_init_once(
-	void			*vnode,
 	kmem_zone_t		*zonep,
-	unsigned long		flags)
+	void			*vnode)
 {
 	inode_init_once(vn_to_inode((bhv_vnode_t *)vnode));
 }
diff -puN include/asm-i386/pgtable.h~slab-api-remove-useless-ctor-parameter-and-reorder-parameters include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/include/asm-i386/pgtable.h
@@ -40,7 +40,7 @@ extern spinlock_t pgd_lock;
 extern struct page *pgd_list;
 void check_pgt_cache(void);
 
-void pmd_ctor(void *, struct kmem_cache *, unsigned long);
+void pmd_ctor(struct kmem_cache *, void *);
 void pgtable_cache_init(void);
 void paging_init(void);
 
diff -puN include/linux/slab.h~slab-api-remove-useless-ctor-parameter-and-reorder-parameters include/linux/slab.h
--- a/include/linux/slab.h~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/include/linux/slab.h
@@ -53,7 +53,7 @@ int slab_is_available(void);
 
 struct kmem_cache *kmem_cache_create(const char *, size_t, size_t,
 			unsigned long,
-			void (*)(void *, struct kmem_cache *, unsigned long));
+			void (*)(struct kmem_cache *, void *));
 void kmem_cache_destroy(struct kmem_cache *);
 int kmem_cache_shrink(struct kmem_cache *);
 void kmem_cache_free(struct kmem_cache *, void *);
diff -puN include/linux/slub_def.h~slab-api-remove-useless-ctor-parameter-and-reorder-parameters include/linux/slub_def.h
--- a/include/linux/slub_def.h~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/include/linux/slub_def.h
@@ -49,7 +49,7 @@ struct kmem_cache {
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
@@ -1442,8 +1442,7 @@ long do_fork(unsigned long clone_flags,
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
@@ -1042,7 +1042,7 @@ int radix_tree_tagged(struct radix_tree_
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
@@ -2328,8 +2328,7 @@ static void shmem_destroy_inode(struct i
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
@@ -2129,7 +2129,7 @@ static int __init_refok setup_cpu_cache(
 struct kmem_cache *
 kmem_cache_create (const char *name, size_t size, size_t align,
 	unsigned long flags,
-	void (*ctor)(void*, struct kmem_cache *, unsigned long))
+	void (*ctor)(struct kmem_cache *, void *))
 {
 	size_t left_over, slab_size, ralign;
 	struct kmem_cache *cachep = NULL, *pc;
@@ -2636,8 +2636,7 @@ static void cache_init_objs(struct kmem_
 		 * They must also be threaded.
 		 */
 		if (cachep->ctor && !(cachep->flags & SLAB_POISON))
-			cachep->ctor(objp + obj_offset(cachep), cachep,
-				     0);
+			cachep->ctor(cachep, objp + obj_offset(cachep));
 
 		if (cachep->flags & SLAB_RED_ZONE) {
 			if (*dbg_redzone2(cachep, objp) != RED_INACTIVE)
@@ -2653,7 +2652,7 @@ static void cache_init_objs(struct kmem_
 					 cachep->buffer_size / PAGE_SIZE, 0);
 #else
 		if (cachep->ctor)
-			cachep->ctor(objp, cachep, 0);
+			cachep->ctor(cachep, objp);
 #endif
 		slab_bufctl(slabp)[i] = i + 1;
 	}
@@ -3078,7 +3077,7 @@ static void *cache_alloc_debugcheck_afte
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
@@ -499,12 +499,12 @@ struct kmem_cache {
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
 
@@ -548,7 +548,7 @@ void *kmem_cache_alloc_node(struct kmem_
 		b = slob_new_page(flags, get_order(c->size), node);
 
 	if (c->ctor)
-		c->ctor(b, c, 0);
+		c->ctor(c, b);
 
 	return b;
 }
diff -puN mm/slub.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters mm/slub.c
--- a/mm/slub.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/mm/slub.c
@@ -987,7 +987,7 @@ __setup("slub_debug", setup_slub_debug);
 
 static unsigned long kmem_cache_flags(unsigned long objsize,
 	unsigned long flags, const char *name,
-	void (*ctor)(void *, struct kmem_cache *, unsigned long))
+	void (*ctor)(struct kmem_cache *, void *))
 {
 	/*
 	 * The page->offset field is only 16 bit wide. This is an offset
@@ -1078,7 +1078,7 @@ static void setup_object(struct kmem_cac
 {
 	setup_object_debug(s, page, object);
 	if (unlikely(s->ctor))
-		s->ctor(object, s, 0);
+		s->ctor(s, object);
 }
 
 static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
@@ -2217,7 +2217,7 @@ static int calculate_sizes(struct kmem_c
 static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
 		const char *name, size_t size,
 		size_t align, unsigned long flags,
-		void (*ctor)(void *, struct kmem_cache *, unsigned long))
+		void (*ctor)(struct kmem_cache *, void *))
 {
 	memset(s, 0, kmem_size);
 	s->name = name;
@@ -2816,7 +2816,7 @@ static int slab_unmergeable(struct kmem_
 
 static struct kmem_cache *find_mergeable(size_t size,
 		size_t align, unsigned long flags, const char *name,
-		void (*ctor)(void *, struct kmem_cache *, unsigned long))
+		void (*ctor)(struct kmem_cache *, void *))
 {
 	struct kmem_cache *s;
 
@@ -2857,7 +2857,7 @@ static struct kmem_cache *find_mergeable
 
 struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 		size_t align, unsigned long flags,
-		void (*ctor)(void *, struct kmem_cache *, unsigned long))
+		void (*ctor)(struct kmem_cache *, void *))
 {
 	struct kmem_cache *s;
 
diff -puN net/socket.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters net/socket.c
--- a/net/socket.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/net/socket.c
@@ -261,7 +261,7 @@ static void sock_destroy_inode(struct in
 			container_of(inode, struct socket_alloc, vfs_inode));
 }
 
-static void init_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
+static void init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct socket_alloc *ei = (struct socket_alloc *)foo;
 
diff -puN net/sunrpc/rpc_pipe.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters net/sunrpc/rpc_pipe.c
--- a/net/sunrpc/rpc_pipe.c~slab-api-remove-useless-ctor-parameter-and-reorder-parameters
+++ a/net/sunrpc/rpc_pipe.c
@@ -841,7 +841,7 @@ static struct file_system_type rpc_pipe_
 };
 
 static void
-init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+init_once(struct kmem_cache * cachep, void *foo)
 {
 	struct rpc_inode *rpci = (struct rpc_inode *) foo;
 
_

Patches currently in -mm which might be from clameter@sgi.com are

revert-highmem-catch-illegal-nesting.patch
slub-accurately-compare-debug-flags-during-slab-cache-merge.patch
infiniband-work-around-gcc-slub-problem.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86-fix-cpu_to_node-references.patch
x86-convert-cpu_core_map-to-be-a-per-cpu-variable.patch
convert-cpu_sibling_map-to-be-a-per-cpu-variable.patch
x86-convert-x86_cpu_to_apicid-to-be-a-per-cpu-variable.patch
x86-convert-cpu_llc_id-to-be-a-per-cpu-variable.patch
x86-acpi-use-cpu_physical_id.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch
generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch
generic-virtual-memmap-support-vmemmap-generify-initialisation-via-helpers.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation.patch
sparc64-sparsemem_vmemmap-support.patch
sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
ppc64-sparsemem_vmemmap-support-convert-to-new-config-options.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
slub-direct-pass-through-of-page-size-or-higher-kmalloc.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
slab-allocators-fail-if-ksize-is-called-with-a-null-parameter.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes-fix.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
update-n_high_memory-node-state-for-memory-hotadd.patch
memoryless-nodes-fix-interleave-behavior-for-memoryless-nodes.patch
memoryless-nodes-oom-use-n_high_memory-map-instead-of-constructing-one-on-the-fly.patch
memoryless-nodes-no-need-for-kswapd.patch
memoryless-nodes-slab-support.patch
memoryless-nodes-slub-support.patch
memoryless-nodes-uncached-allocator-updates.patch
memoryless-nodes-allow-profiling-data-to-fall-back-to-other-nodes.patch
memoryless-nodes-update-memory-policy-and-page-migration.patch
memoryless-nodes-add-n_cpu-node-state.patch
memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-n_high_memory-for-cpusets.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
categorize-gfp-flags.patch
categorize-gfp-flags-fix.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix-update.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
slub-avoid-page-struct-cacheline-bouncing-due-to-remote-frees-to-cpu-slab.patch
slub-do-not-use-page-mapping.patch
slub-do-not-use-page-mapping-fix.patch
slub-move-page-offset-to-kmem_cache_cpu-offset.patch
slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab.patch
slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way.patch
slub-optimize-cacheline-use-for-zeroing.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap-update.patch
mm-mempolicyc-cleanups.patch
mm-mempolicyc-cleanups-fix.patch
mm-vmstatc-cleanups.patch
config_zone_movable-zone-ifdef-cleanup-by-renumbering.patch
config_zone_movable-config-zone-movable.patch
add-node-states-sysfs-class-attributes-v5.patch
slub-simplify-irq-off-handling.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
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
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
bit_spin_lock-use-lock-bitops.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
page-owner-tracking-leak-detector.patch
