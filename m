From: akpm@linux-foundation.org
Subject: - slb-drop-kmem-cache-argument-from-constructor.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:16:11 -0700
Message-ID: <200807262116.m6QLGBmF019809@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757769AbYGZVVj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:21:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, cl@linux-foundation.org, kniht@linux.vnet.ibm.com, mpm@selenic.com, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     SL*B: drop kmem cache argument from constructor
has been removed from the -mm tree.  Its filename was
     slb-drop-kmem-cache-argument-from-constructor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SL*B: drop kmem cache argument from constructor
From: Alexey Dobriyan <adobriyan@gmail.com>

Kmem cache passed to constructor is only needed for constructors that are
themselves multiplexeres.  Nobody uses this "feature", nor does anybody uses
passed kmem cache in non-trivial way, so pass only pointer to object.

Non-trivial places are:
	arch/powerpc/mm/init_64.c
	arch/powerpc/mm/hugetlbpage.c

This is flag day, yes.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Jon Tollefson <kniht@linux.vnet.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Matt Mackall <mpm@selenic.com>
[akpm@linux-foundation.org: fix arch/powerpc/mm/hugetlbpage.c]
[akpm@linux-foundation.org: fix mm/slab.c]
[akpm@linux-foundation.org: fix ubifs]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-s3c24xx/dma.c               |    2 -
 arch/powerpc/kernel/rtas_flash.c          |    2 -
 arch/powerpc/mm/hugetlbpage.c             |    9 +------
 arch/powerpc/mm/init_64.c                 |   24 +++++++-------------
 arch/powerpc/platforms/cell/spufs/inode.c |    2 -
 arch/sh/mm/pmb.c                          |    2 -
 arch/xtensa/mm/init.c                     |    2 -
 drivers/usb/mon/mon_text.c                |    4 +--
 fs/adfs/super.c                           |    2 -
 fs/affs/super.c                           |    2 -
 fs/afs/super.c                            |    4 +--
 fs/befs/linuxvfs.c                        |    2 -
 fs/bfs/inode.c                            |    2 -
 fs/block_dev.c                            |    2 -
 fs/buffer.c                               |    2 -
 fs/cifs/cifsfs.c                          |    2 -
 fs/coda/inode.c                           |    2 -
 fs/ecryptfs/main.c                        |    4 +--
 fs/efs/super.c                            |    2 -
 fs/ext2/super.c                           |    2 -
 fs/ext3/super.c                           |    2 -
 fs/ext4/super.c                           |    2 -
 fs/fat/cache.c                            |    2 -
 fs/fat/inode.c                            |    2 -
 fs/fuse/inode.c                           |    2 -
 fs/gfs2/main.c                            |    4 +--
 fs/hfs/super.c                            |    2 -
 fs/hfsplus/super.c                        |    2 -
 fs/hpfs/super.c                           |    2 -
 fs/hugetlbfs/inode.c                      |    2 -
 fs/inode.c                                |    2 -
 fs/isofs/inode.c                          |    2 -
 fs/jffs2/super.c                          |    2 -
 fs/jfs/jfs_metapage.c                     |    2 -
 fs/jfs/super.c                            |    2 -
 fs/locks.c                                |    2 -
 fs/minix/inode.c                          |    2 -
 fs/ncpfs/inode.c                          |    2 -
 fs/nfs/inode.c                            |    2 -
 fs/ntfs/super.c                           |    2 -
 fs/ocfs2/dlm/dlmfs.c                      |    3 --
 fs/ocfs2/super.c                          |    2 -
 fs/openpromfs/inode.c                     |    2 -
 fs/proc/inode.c                           |    2 -
 fs/qnx4/inode.c                           |    2 -
 fs/reiserfs/super.c                       |    2 -
 fs/romfs/inode.c                          |    2 -
 fs/smbfs/inode.c                          |    2 -
 fs/sysv/inode.c                           |    2 -
 fs/ubifs/super.c                          |    2 -
 fs/udf/super.c                            |    2 -
 fs/ufs/super.c                            |    2 -
 fs/xfs/linux-2.6/kmem.h                   |    2 -
 fs/xfs/linux-2.6/xfs_super.c              |    1 
 include/linux/slab.h                      |    2 -
 include/linux/slub_def.h                  |    2 -
 ipc/mqueue.c                              |    2 -
 kernel/fork.c                             |    2 -
 lib/idr.c                                 |    2 -
 lib/radix-tree.c                          |    2 -
 mm/rmap.c                                 |    2 -
 mm/shmem.c                                |    2 -
 mm/slab.c                                 |   11 ++++-----
 mm/slob.c                                 |    7 ++---
 mm/slub.c                                 |   13 +++++-----
 net/socket.c                              |    2 -
 net/sunrpc/rpc_pipe.c                     |    2 -
 67 files changed, 90 insertions(+), 106 deletions(-)

diff -puN arch/arm/plat-s3c24xx/dma.c~slb-drop-kmem-cache-argument-from-constructor arch/arm/plat-s3c24xx/dma.c
--- a/arch/arm/plat-s3c24xx/dma.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/arch/arm/plat-s3c24xx/dma.c
@@ -1304,7 +1304,7 @@ struct sysdev_class dma_sysclass = {
 
 /* kmem cache implementation */
 
-static void s3c2410_dma_cache_ctor(struct kmem_cache *c, void *p)
+static void s3c2410_dma_cache_ctor(void *p)
 {
 	memset(p, 0, sizeof(struct s3c2410_dma_buf));
 }
diff -puN arch/powerpc/kernel/rtas_flash.c~slb-drop-kmem-cache-argument-from-constructor arch/powerpc/kernel/rtas_flash.c
--- a/arch/powerpc/kernel/rtas_flash.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/arch/powerpc/kernel/rtas_flash.c
@@ -286,7 +286,7 @@ static ssize_t rtas_flash_read(struct fi
 }
 
 /* constructor for flash_block_cache */
-void rtas_block_ctor(struct kmem_cache *cache, void *ptr)
+void rtas_block_ctor(void *ptr)
 {
 	memset(ptr, 0, RTAS_BLK_SIZE);
 }
diff -puN arch/powerpc/mm/hugetlbpage.c~slb-drop-kmem-cache-argument-from-constructor arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -113,7 +113,7 @@ static inline pte_t *hugepte_offset(huge
 static int __hugepte_alloc(struct mm_struct *mm, hugepd_t *hpdp,
 			   unsigned long address, unsigned int psize)
 {
-	pte_t *new = kmem_cache_alloc(huge_pgtable_cache(psize),
+	pte_t *new = kmem_cache_zalloc(huge_pgtable_cache(psize),
 				      GFP_KERNEL|__GFP_REPEAT);
 
 	if (! new)
@@ -730,11 +730,6 @@ static int __init hugepage_setup_sz(char
 }
 __setup("hugepagesz=", hugepage_setup_sz);
 
-static void zero_ctor(struct kmem_cache *cache, void *addr)
-{
-	memset(addr, 0, kmem_cache_size(cache));
-}
-
 static int __init hugetlbpage_init(void)
 {
 	unsigned int psize;
@@ -756,7 +751,7 @@ static int __init hugetlbpage_init(void)
 						HUGEPTE_TABLE_SIZE(psize),
 						HUGEPTE_TABLE_SIZE(psize),
 						0,
-						zero_ctor);
+						NULL);
 			if (!huge_pgtable_cache(psize))
 				panic("hugetlbpage_init(): could not create %s"\
 				      "\n", HUGEPTE_CACHE_NAME(psize));
diff -puN arch/powerpc/mm/init_64.c~slb-drop-kmem-cache-argument-from-constructor arch/powerpc/mm/init_64.c
--- a/arch/powerpc/mm/init_64.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/arch/powerpc/mm/init_64.c
@@ -136,9 +136,14 @@ static int __init setup_kcore(void)
 module_init(setup_kcore);
 #endif
 
-static void zero_ctor(struct kmem_cache *cache, void *addr)
+static void pgd_ctor(void *addr)
 {
-	memset(addr, 0, kmem_cache_size(cache));
+	memset(addr, 0, PGD_TABLE_SIZE);
+}
+
+static void pmd_ctor(void *addr)
+{
+	memset(addr, 0, PMD_TABLE_SIZE);
 }
 
 static const unsigned int pgtable_cache_size[2] = {
@@ -163,19 +168,8 @@ struct kmem_cache *pgtable_cache[ARRAY_S
 
 void pgtable_cache_init(void)
 {
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(pgtable_cache_size); i++) {
-		int size = pgtable_cache_size[i];
-		const char *name = pgtable_cache_name[i];
-
-		pr_debug("Allocating page table cache %s (#%d) "
-			"for size: %08x...\n", name, i, size);
-		pgtable_cache[i] = kmem_cache_create(name,
-						     size, size,
-						     SLAB_PANIC,
-						     zero_ctor);
-	}
+	pgtable_cache[0] = kmem_cache_create(pgtable_cache_name[0], PGD_TABLE_SIZE, PGD_TABLE_SIZE, SLAB_PANIC, pgd_ctor);
+	pgtable_cache[1] = kmem_cache_create(pgtable_cache_name[1], PMD_TABLE_SIZE, PMD_TABLE_SIZE, SLAB_PANIC, pmd_ctor);
 }
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
diff -puN arch/powerpc/platforms/cell/spufs/inode.c~slb-drop-kmem-cache-argument-from-constructor arch/powerpc/platforms/cell/spufs/inode.c
--- a/arch/powerpc/platforms/cell/spufs/inode.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/arch/powerpc/platforms/cell/spufs/inode.c
@@ -78,7 +78,7 @@ spufs_destroy_inode(struct inode *inode)
 }
 
 static void
-spufs_init_once(struct kmem_cache *cachep, void *p)
+spufs_init_once(void *p)
 {
 	struct spufs_inode_info *ei = p;
 
diff -puN arch/sh/mm/pmb.c~slb-drop-kmem-cache-argument-from-constructor arch/sh/mm/pmb.c
--- a/arch/sh/mm/pmb.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/arch/sh/mm/pmb.c
@@ -293,7 +293,7 @@ void pmb_unmap(unsigned long addr)
 	} while (pmbe);
 }
 
-static void pmb_cache_ctor(struct kmem_cache *cachep, void *pmb)
+static void pmb_cache_ctor(void *pmb)
 {
 	struct pmb_entry *pmbe = pmb;
 
diff -puN arch/xtensa/mm/init.c~slb-drop-kmem-cache-argument-from-constructor arch/xtensa/mm/init.c
--- a/arch/xtensa/mm/init.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/arch/xtensa/mm/init.c
@@ -309,7 +309,7 @@ void show_mem(void)
 
 struct kmem_cache *pgtable_cache __read_mostly;
 
-static void pgd_ctor(struct kmem_cache *cache, void* addr)
+static void pgd_ctor(void* addr)
 {
 	pte_t* ptep = (pte_t*)addr;
 	int i;
diff -puN drivers/usb/mon/mon_text.c~slb-drop-kmem-cache-argument-from-constructor drivers/usb/mon/mon_text.c
--- a/drivers/usb/mon/mon_text.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/drivers/usb/mon/mon_text.c
@@ -87,7 +87,7 @@ struct mon_reader_text {
 
 static struct dentry *mon_dir;		/* Usually /sys/kernel/debug/usbmon */
 
-static void mon_text_ctor(struct kmem_cache *, void *);
+static void mon_text_ctor(void *);
 
 struct mon_text_ptr {
 	int cnt, limit;
@@ -720,7 +720,7 @@ void mon_text_del(struct mon_bus *mbus)
 /*
  * Slab interface: constructor.
  */
-static void mon_text_ctor(struct kmem_cache *slab, void *mem)
+static void mon_text_ctor(void *mem)
 {
 	/*
 	 * Nothing to initialize. No, really!
diff -puN fs/adfs/super.c~slb-drop-kmem-cache-argument-from-constructor fs/adfs/super.c
--- a/fs/adfs/super.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/adfs/super.c
@@ -249,7 +249,7 @@ static void adfs_destroy_inode(struct in
 	kmem_cache_free(adfs_inode_cachep, ADFS_I(inode));
 }
 
-static void init_once(struct kmem_cache *cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct adfs_inode_info *ei = (struct adfs_inode_info *) foo;
 
diff -puN fs/affs/super.c~slb-drop-kmem-cache-argument-from-constructor fs/affs/super.c
--- a/fs/affs/super.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/affs/super.c
@@ -90,7 +90,7 @@ static void affs_destroy_inode(struct in
 	kmem_cache_free(affs_inode_cachep, AFFS_I(inode));
 }
 
-static void init_once(struct kmem_cache *cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct affs_inode_info *ei = (struct affs_inode_info *) foo;
 
diff -puN fs/afs/super.c~slb-drop-kmem-cache-argument-from-constructor fs/afs/super.c
--- a/fs/afs/super.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/afs/super.c
@@ -27,7 +27,7 @@
 
 #define AFS_FS_MAGIC 0x6B414653 /* 'kAFS' */
 
-static void afs_i_init_once(struct kmem_cache *cachep, void *foo);
+static void afs_i_init_once(void *foo);
 static int afs_get_sb(struct file_system_type *fs_type,
 		      int flags, const char *dev_name,
 		      void *data, struct vfsmount *mnt);
@@ -449,7 +449,7 @@ static void afs_put_super(struct super_b
 /*
  * initialise an inode cache slab element prior to any use
  */
-static void afs_i_init_once(struct kmem_cache *cachep, void *_vnode)
+static void afs_i_init_once(void *_vnode)
 {
 	struct afs_vnode *vnode = _vnode;
 
diff -puN fs/befs/linuxvfs.c~slb-drop-kmem-cache-argument-from-constructor fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/befs/linuxvfs.c
@@ -289,7 +289,7 @@ befs_destroy_inode(struct inode *inode)
         kmem_cache_free(befs_inode_cachep, BEFS_I(inode));
 }
 
-static void init_once(struct kmem_cache *cachep, void *foo)
+static void init_once(void *foo)
 {
         struct befs_inode_info *bi = (struct befs_inode_info *) foo;
 
diff -puN fs/bfs/inode.c~slb-drop-kmem-cache-argument-from-constructor fs/bfs/inode.c
--- a/fs/bfs/inode.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/bfs/inode.c
@@ -264,7 +264,7 @@ static void bfs_destroy_inode(struct ino
 	kmem_cache_free(bfs_inode_cachep, BFS_I(inode));
 }
 
-static void init_once(struct kmem_cache *cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct bfs_inode_info *bi = foo;
 
diff -puN fs/block_dev.c~slb-drop-kmem-cache-argument-from-constructor fs/block_dev.c
--- a/fs/block_dev.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/block_dev.c
@@ -271,7 +271,7 @@ static void bdev_destroy_inode(struct in
 	kmem_cache_free(bdev_cachep, bdi);
 }
 
-static void init_once(struct kmem_cache * cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct bdev_inode *ei = (struct bdev_inode *) foo;
 	struct block_device *bdev = &ei->bdev;
diff -puN fs/buffer.c~slb-drop-kmem-cache-argument-from-constructor fs/buffer.c
--- a/fs/buffer.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/buffer.c
@@ -3272,7 +3272,7 @@ int bh_submit_read(struct buffer_head *b
 EXPORT_SYMBOL(bh_submit_read);
 
 static void
-init_buffer_head(struct kmem_cache *cachep, void *data)
+init_buffer_head(void *data)
 {
 	struct buffer_head *bh = data;
 
diff -puN fs/cifs/cifsfs.c~slb-drop-kmem-cache-argument-from-constructor fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/cifs/cifsfs.c
@@ -766,7 +766,7 @@ const struct file_operations cifs_dir_op
 };
 
 static void
-cifs_init_once(struct kmem_cache *cachep, void *inode)
+cifs_init_once(void *inode)
 {
 	struct cifsInodeInfo *cifsi = inode;
 
diff -puN fs/coda/inode.c~slb-drop-kmem-cache-argument-from-constructor fs/coda/inode.c
--- a/fs/coda/inode.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/coda/inode.c
@@ -58,7 +58,7 @@ static void coda_destroy_inode(struct in
 	kmem_cache_free(coda_inode_cachep, ITOC(inode));
 }
 
-static void init_once(struct kmem_cache * cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct coda_inode_info *ei = (struct coda_inode_info *) foo;
 
diff -puN fs/ecryptfs/main.c~slb-drop-kmem-cache-argument-from-constructor fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/ecryptfs/main.c
@@ -578,7 +578,7 @@ static struct file_system_type ecryptfs_
  * Initializes the ecryptfs_inode_info_cache when it is created
  */
 static void
-inode_info_init_once(struct kmem_cache *cachep, void *vptr)
+inode_info_init_once(void *vptr)
 {
 	struct ecryptfs_inode_info *ei = (struct ecryptfs_inode_info *)vptr;
 
@@ -589,7 +589,7 @@ static struct ecryptfs_cache_info {
 	struct kmem_cache **cache;
 	const char *name;
 	size_t size;
-	void (*ctor)(struct kmem_cache *cache, void *obj);
+	void (*ctor)(void *obj);
 } ecryptfs_cache_infos[] = {
 	{
 		.cache = &ecryptfs_auth_tok_list_item_cache,
diff -puN fs/efs/super.c~slb-drop-kmem-cache-argument-from-constructor fs/efs/super.c
--- a/fs/efs/super.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/efs/super.c
@@ -70,7 +70,7 @@ static void efs_destroy_inode(struct ino
 	kmem_cache_free(efs_inode_cachep, INODE_INFO(inode));
 }
 
-static void init_once(struct kmem_cache *cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct efs_inode_info *ei = (struct efs_inode_info *) foo;
 
diff -puN fs/ext2/super.c~slb-drop-kmem-cache-argument-from-constructor fs/ext2/super.c
--- a/fs/ext2/super.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/ext2/super.c
@@ -159,7 +159,7 @@ static void ext2_destroy_inode(struct in
 	kmem_cache_free(ext2_inode_cachep, EXT2_I(inode));
 }
 
-static void init_once(struct kmem_cache * cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct ext2_inode_info *ei = (struct ext2_inode_info *) foo;
 
diff -puN fs/ext3/super.c~slb-drop-kmem-cache-argument-from-constructor fs/ext3/super.c
--- a/fs/ext3/super.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/ext3/super.c
@@ -472,7 +472,7 @@ static void ext3_destroy_inode(struct in
 	kmem_cache_free(ext3_inode_cachep, EXT3_I(inode));
 }
 
-static void init_once(struct kmem_cache * cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct ext3_inode_info *ei = (struct ext3_inode_info *) foo;
 
diff -puN fs/ext4/super.c~slb-drop-kmem-cache-argument-from-constructor fs/ext4/super.c
--- a/fs/ext4/super.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/ext4/super.c
@@ -595,7 +595,7 @@ static void ext4_destroy_inode(struct in
 	kmem_cache_free(ext4_inode_cachep, EXT4_I(inode));
 }
 
-static void init_once(struct kmem_cache *cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct ext4_inode_info *ei = (struct ext4_inode_info *) foo;
 
diff -puN fs/fat/cache.c~slb-drop-kmem-cache-argument-from-constructor fs/fat/cache.c
--- a/fs/fat/cache.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/fat/cache.c
@@ -36,7 +36,7 @@ static inline int fat_max_cache(struct i
 
 static struct kmem_cache *fat_cache_cachep;
 
-static void init_once(struct kmem_cache *cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct fat_cache *cache = (struct fat_cache *)foo;
 
diff -puN fs/fat/inode.c~slb-drop-kmem-cache-argument-from-constructor fs/fat/inode.c
--- a/fs/fat/inode.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/fat/inode.c
@@ -498,7 +498,7 @@ static void fat_destroy_inode(struct ino
 	kmem_cache_free(fat_inode_cachep, MSDOS_I(inode));
 }
 
-static void init_once(struct kmem_cache *cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct msdos_inode_info *ei = (struct msdos_inode_info *)foo;
 
diff -puN fs/fuse/inode.c~slb-drop-kmem-cache-argument-from-constructor fs/fuse/inode.c
--- a/fs/fuse/inode.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/fuse/inode.c
@@ -956,7 +956,7 @@ static inline void unregister_fuseblk(vo
 }
 #endif
 
-static void fuse_inode_init_once(struct kmem_cache *cachep, void *foo)
+static void fuse_inode_init_once(void *foo)
 {
 	struct inode * inode = foo;
 
diff -puN fs/gfs2/main.c~slb-drop-kmem-cache-argument-from-constructor fs/gfs2/main.c
--- a/fs/gfs2/main.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/gfs2/main.c
@@ -24,7 +24,7 @@
 #include "util.h"
 #include "glock.h"
 
-static void gfs2_init_inode_once(struct kmem_cache *cachep, void *foo)
+static void gfs2_init_inode_once(void *foo)
 {
 	struct gfs2_inode *ip = foo;
 
@@ -33,7 +33,7 @@ static void gfs2_init_inode_once(struct 
 	ip->i_alloc = NULL;
 }
 
-static void gfs2_init_glock_once(struct kmem_cache *cachep, void *foo)
+static void gfs2_init_glock_once(void *foo)
 {
 	struct gfs2_glock *gl = foo;
 
diff -puN fs/hfs/super.c~slb-drop-kmem-cache-argument-from-constructor fs/hfs/super.c
--- a/fs/hfs/super.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/hfs/super.c
@@ -432,7 +432,7 @@ static struct file_system_type hfs_fs_ty
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 
-static void hfs_init_once(struct kmem_cache *cachep, void *p)
+static void hfs_init_once(void *p)
 {
 	struct hfs_inode_info *i = p;
 
diff -puN fs/hfsplus/super.c~slb-drop-kmem-cache-argument-from-constructor fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/hfsplus/super.c
@@ -485,7 +485,7 @@ static struct file_system_type hfsplus_f
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 
-static void hfsplus_init_once(struct kmem_cache *cachep, void *p)
+static void hfsplus_init_once(void *p)
 {
 	struct hfsplus_inode_info *i = p;
 
diff -puN fs/hpfs/super.c~slb-drop-kmem-cache-argument-from-constructor fs/hpfs/super.c
--- a/fs/hpfs/super.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/hpfs/super.c
@@ -173,7 +173,7 @@ static void hpfs_destroy_inode(struct in
 	kmem_cache_free(hpfs_inode_cachep, hpfs_i(inode));
 }
 
-static void init_once(struct kmem_cache *cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct hpfs_inode_info *ei = (struct hpfs_inode_info *) foo;
 
diff -puN fs/hugetlbfs/inode.c~slb-drop-kmem-cache-argument-from-constructor fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/hugetlbfs/inode.c
@@ -705,7 +705,7 @@ static const struct address_space_operat
 };
 
 
-static void init_once(struct kmem_cache *cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct hugetlbfs_inode_info *ei = (struct hugetlbfs_inode_info *)foo;
 
diff -puN fs/inode.c~slb-drop-kmem-cache-argument-from-constructor fs/inode.c
--- a/fs/inode.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/inode.c
@@ -224,7 +224,7 @@ void inode_init_once(struct inode *inode
 
 EXPORT_SYMBOL(inode_init_once);
 
-static void init_once(struct kmem_cache * cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct inode * inode = (struct inode *) foo;
 
diff -puN fs/isofs/inode.c~slb-drop-kmem-cache-argument-from-constructor fs/isofs/inode.c
--- a/fs/isofs/inode.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/isofs/inode.c
@@ -73,7 +73,7 @@ static void isofs_destroy_inode(struct i
 	kmem_cache_free(isofs_inode_cachep, ISOFS_I(inode));
 }
 
-static void init_once(struct kmem_cache *cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct iso_inode_info *ei = foo;
 
diff -puN fs/jffs2/super.c~slb-drop-kmem-cache-argument-from-constructor fs/jffs2/super.c
--- a/fs/jffs2/super.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/jffs2/super.c
@@ -44,7 +44,7 @@ static void jffs2_destroy_inode(struct i
 	kmem_cache_free(jffs2_inode_cachep, JFFS2_INODE_INFO(inode));
 }
 
-static void jffs2_i_init_once(struct kmem_cache *cachep, void *foo)
+static void jffs2_i_init_once(void *foo)
 {
 	struct jffs2_inode_info *f = foo;
 
diff -puN fs/jfs/jfs_metapage.c~slb-drop-kmem-cache-argument-from-constructor fs/jfs/jfs_metapage.c
--- a/fs/jfs/jfs_metapage.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/jfs/jfs_metapage.c
@@ -182,7 +182,7 @@ static inline void remove_metapage(struc
 
 #endif
 
-static void init_once(struct kmem_cache *cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct metapage *mp = (struct metapage *)foo;
 
diff -puN fs/jfs/super.c~slb-drop-kmem-cache-argument-from-constructor fs/jfs/super.c
--- a/fs/jfs/super.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/jfs/super.c
@@ -760,7 +760,7 @@ static struct file_system_type jfs_fs_ty
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 
-static void init_once(struct kmem_cache *cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct jfs_inode_info *jfs_ip = (struct jfs_inode_info *) foo;
 
diff -puN fs/locks.c~slb-drop-kmem-cache-argument-from-constructor fs/locks.c
--- a/fs/locks.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/locks.c
@@ -201,7 +201,7 @@ EXPORT_SYMBOL(locks_init_lock);
  * Initialises the fields of the file lock which are invariant for
  * free file_locks.
  */
-static void init_once(struct kmem_cache *cache, void *foo)
+static void init_once(void *foo)
 {
 	struct file_lock *lock = (struct file_lock *) foo;
 
diff -puN fs/minix/inode.c~slb-drop-kmem-cache-argument-from-constructor fs/minix/inode.c
--- a/fs/minix/inode.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/minix/inode.c
@@ -68,7 +68,7 @@ static void minix_destroy_inode(struct i
 	kmem_cache_free(minix_inode_cachep, minix_i(inode));
 }
 
-static void init_once(struct kmem_cache * cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct minix_inode_info *ei = (struct minix_inode_info *) foo;
 
diff -puN fs/ncpfs/inode.c~slb-drop-kmem-cache-argument-from-constructor fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/ncpfs/inode.c
@@ -64,7 +64,7 @@ static void ncp_destroy_inode(struct ino
 	kmem_cache_free(ncp_inode_cachep, NCP_FINFO(inode));
 }
 
-static void init_once(struct kmem_cache *cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct ncp_inode_info *ei = (struct ncp_inode_info *) foo;
 
diff -puN fs/nfs/inode.c~slb-drop-kmem-cache-argument-from-constructor fs/nfs/inode.c
--- a/fs/nfs/inode.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/nfs/inode.c
@@ -1242,7 +1242,7 @@ static inline void nfs4_init_once(struct
 #endif
 }
 
-static void init_once(struct kmem_cache * cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct nfs_inode *nfsi = (struct nfs_inode *) foo;
 
diff -puN fs/ntfs/super.c~slb-drop-kmem-cache-argument-from-constructor fs/ntfs/super.c
--- a/fs/ntfs/super.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/ntfs/super.c
@@ -3080,7 +3080,7 @@ struct kmem_cache *ntfs_inode_cache;
 struct kmem_cache *ntfs_big_inode_cache;
 
 /* Init once constructor for the inode slab cache. */
-static void ntfs_big_inode_init_once(struct kmem_cache *cachep, void *foo)
+static void ntfs_big_inode_init_once(void *foo)
 {
 	ntfs_inode *ni = (ntfs_inode *)foo;
 
diff -puN fs/ocfs2/dlm/dlmfs.c~slb-drop-kmem-cache-argument-from-constructor fs/ocfs2/dlm/dlmfs.c
--- a/fs/ocfs2/dlm/dlmfs.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/ocfs2/dlm/dlmfs.c
@@ -267,8 +267,7 @@ static ssize_t dlmfs_file_write(struct f
 	return writelen;
 }
 
-static void dlmfs_init_once(struct kmem_cache *cachep,
-			    void *foo)
+static void dlmfs_init_once(void *foo)
 {
 	struct dlmfs_inode_private *ip =
 		(struct dlmfs_inode_private *) foo;
diff -puN fs/ocfs2/super.c~slb-drop-kmem-cache-argument-from-constructor fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/ocfs2/super.c
@@ -1118,7 +1118,7 @@ bail:
 	return status;
 }
 
-static void ocfs2_inode_init_once(struct kmem_cache *cachep, void *data)
+static void ocfs2_inode_init_once(void *data)
 {
 	struct ocfs2_inode_info *oi = data;
 
diff -puN fs/openpromfs/inode.c~slb-drop-kmem-cache-argument-from-constructor fs/openpromfs/inode.c
--- a/fs/openpromfs/inode.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/openpromfs/inode.c
@@ -430,7 +430,7 @@ static struct file_system_type openprom_
 	.kill_sb	= kill_anon_super,
 };
 
-static void op_inode_init_once(struct kmem_cache * cachep, void *data)
+static void op_inode_init_once(void *data)
 {
 	struct op_inode_info *oi = (struct op_inode_info *) data;
 
diff -puN fs/proc/inode.c~slb-drop-kmem-cache-argument-from-constructor fs/proc/inode.c
--- a/fs/proc/inode.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/proc/inode.c
@@ -94,7 +94,7 @@ static void proc_destroy_inode(struct in
 	kmem_cache_free(proc_inode_cachep, PROC_I(inode));
 }
 
-static void init_once(struct kmem_cache * cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct proc_inode *ei = (struct proc_inode *) foo;
 
diff -puN fs/qnx4/inode.c~slb-drop-kmem-cache-argument-from-constructor fs/qnx4/inode.c
--- a/fs/qnx4/inode.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/qnx4/inode.c
@@ -553,7 +553,7 @@ static void qnx4_destroy_inode(struct in
 	kmem_cache_free(qnx4_inode_cachep, qnx4_i(inode));
 }
 
-static void init_once(struct kmem_cache *cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct qnx4_inode_info *ei = (struct qnx4_inode_info *) foo;
 
diff -puN fs/reiserfs/super.c~slb-drop-kmem-cache-argument-from-constructor fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/reiserfs/super.c
@@ -521,7 +521,7 @@ static void reiserfs_destroy_inode(struc
 	kmem_cache_free(reiserfs_inode_cachep, REISERFS_I(inode));
 }
 
-static void init_once(struct kmem_cache * cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct reiserfs_inode_info *ei = (struct reiserfs_inode_info *)foo;
 
diff -puN fs/romfs/inode.c~slb-drop-kmem-cache-argument-from-constructor fs/romfs/inode.c
--- a/fs/romfs/inode.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/romfs/inode.c
@@ -577,7 +577,7 @@ static void romfs_destroy_inode(struct i
 	kmem_cache_free(romfs_inode_cachep, ROMFS_I(inode));
 }
 
-static void init_once(struct kmem_cache *cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct romfs_inode_info *ei = foo;
 
diff -puN fs/smbfs/inode.c~slb-drop-kmem-cache-argument-from-constructor fs/smbfs/inode.c
--- a/fs/smbfs/inode.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/smbfs/inode.c
@@ -67,7 +67,7 @@ static void smb_destroy_inode(struct ino
 	kmem_cache_free(smb_inode_cachep, SMB_I(inode));
 }
 
-static void init_once(struct kmem_cache *cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct smb_inode_info *ei = (struct smb_inode_info *) foo;
 
diff -puN fs/sysv/inode.c~slb-drop-kmem-cache-argument-from-constructor fs/sysv/inode.c
--- a/fs/sysv/inode.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/sysv/inode.c
@@ -326,7 +326,7 @@ static void sysv_destroy_inode(struct in
 	kmem_cache_free(sysv_inode_cachep, SYSV_I(inode));
 }
 
-static void init_once(struct kmem_cache *cachep, void *p)
+static void init_once(void *p)
 {
 	struct sysv_inode_info *si = (struct sysv_inode_info *)p;
 
diff -puN fs/ubifs/super.c~slb-drop-kmem-cache-argument-from-constructor fs/ubifs/super.c
--- a/fs/ubifs/super.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/ubifs/super.c
@@ -1841,7 +1841,7 @@ static struct file_system_type ubifs_fs_
 /*
  * Inode slab cache constructor.
  */
-static void inode_slab_ctor(struct kmem_cache *cachep, void *obj)
+static void inode_slab_ctor(void *obj)
 {
 	struct ubifs_inode *ui = obj;
 	inode_init_once(&ui->vfs_inode);
diff -puN fs/udf/super.c~slb-drop-kmem-cache-argument-from-constructor fs/udf/super.c
--- a/fs/udf/super.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/udf/super.c
@@ -148,7 +148,7 @@ static void udf_destroy_inode(struct ino
 	kmem_cache_free(udf_inode_cachep, UDF_I(inode));
 }
 
-static void init_once(struct kmem_cache *cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct udf_inode_info *ei = (struct udf_inode_info *)foo;
 
diff -puN fs/ufs/super.c~slb-drop-kmem-cache-argument-from-constructor fs/ufs/super.c
--- a/fs/ufs/super.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/ufs/super.c
@@ -1302,7 +1302,7 @@ static void ufs_destroy_inode(struct ino
 	kmem_cache_free(ufs_inode_cachep, UFS_I(inode));
 }
 
-static void init_once(struct kmem_cache * cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct ufs_inode_info *ei = (struct ufs_inode_info *) foo;
 
diff -puN fs/xfs/linux-2.6/kmem.h~slb-drop-kmem-cache-argument-from-constructor fs/xfs/linux-2.6/kmem.h
--- a/fs/xfs/linux-2.6/kmem.h~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/xfs/linux-2.6/kmem.h
@@ -79,7 +79,7 @@ kmem_zone_init(int size, char *zone_name
 
 static inline kmem_zone_t *
 kmem_zone_init_flags(int size, char *zone_name, unsigned long flags,
-		     void (*construct)(kmem_zone_t *, void *))
+		     void (*construct)(void *))
 {
 	return kmem_cache_create(zone_name, size, 0, flags, construct);
 }
diff -puN fs/xfs/linux-2.6/xfs_super.c~slb-drop-kmem-cache-argument-from-constructor fs/xfs/linux-2.6/xfs_super.c
--- a/fs/xfs/linux-2.6/xfs_super.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/fs/xfs/linux-2.6/xfs_super.c
@@ -843,7 +843,6 @@ xfs_fs_destroy_inode(
 
 STATIC void
 xfs_fs_inode_init_once(
-	kmem_zone_t		*zonep,
 	void			*vnode)
 {
 	inode_init_once(vn_to_inode((bhv_vnode_t *)vnode));
diff -puN include/linux/slab.h~slb-drop-kmem-cache-argument-from-constructor include/linux/slab.h
--- a/include/linux/slab.h~slb-drop-kmem-cache-argument-from-constructor
+++ a/include/linux/slab.h
@@ -58,7 +58,7 @@ int slab_is_available(void);
 
 struct kmem_cache *kmem_cache_create(const char *, size_t, size_t,
 			unsigned long,
-			void (*)(struct kmem_cache *, void *));
+			void (*)(void *));
 void kmem_cache_destroy(struct kmem_cache *);
 int kmem_cache_shrink(struct kmem_cache *);
 void kmem_cache_free(struct kmem_cache *, void *);
diff -puN include/linux/slub_def.h~slb-drop-kmem-cache-argument-from-constructor include/linux/slub_def.h
--- a/include/linux/slub_def.h~slb-drop-kmem-cache-argument-from-constructor
+++ a/include/linux/slub_def.h
@@ -85,7 +85,7 @@ struct kmem_cache {
 	struct kmem_cache_order_objects min;
 	gfp_t allocflags;	/* gfp flags to use on each alloc */
 	int refcount;		/* Refcount for slab cache destroy */
-	void (*ctor)(struct kmem_cache *, void *);
+	void (*ctor)(void *);
 	int inuse;		/* Offset to metadata */
 	int align;		/* Alignment */
 	const char *name;	/* Name (only for display!) */
diff -puN ipc/mqueue.c~slb-drop-kmem-cache-argument-from-constructor ipc/mqueue.c
--- a/ipc/mqueue.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/ipc/mqueue.c
@@ -207,7 +207,7 @@ static int mqueue_get_sb(struct file_sys
 	return get_sb_single(fs_type, flags, data, mqueue_fill_super, mnt);
 }
 
-static void init_once(struct kmem_cache *cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct mqueue_inode_info *p = (struct mqueue_inode_info *) foo;
 
diff -puN kernel/fork.c~slb-drop-kmem-cache-argument-from-constructor kernel/fork.c
--- a/kernel/fork.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/kernel/fork.c
@@ -1442,7 +1442,7 @@ long do_fork(unsigned long clone_flags,
 #define ARCH_MIN_MMSTRUCT_ALIGN 0
 #endif
 
-static void sighand_ctor(struct kmem_cache *cachep, void *data)
+static void sighand_ctor(void *data)
 {
 	struct sighand_struct *sighand = data;
 
diff -puN lib/idr.c~slb-drop-kmem-cache-argument-from-constructor lib/idr.c
--- a/lib/idr.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/lib/idr.c
@@ -607,7 +607,7 @@ void *idr_replace(struct idr *idp, void 
 }
 EXPORT_SYMBOL(idr_replace);
 
-static void idr_cache_ctor(struct kmem_cache *idr_layer_cache, void *idr_layer)
+static void idr_cache_ctor(void *idr_layer)
 {
 	memset(idr_layer, 0, sizeof(struct idr_layer));
 }
diff -puN lib/radix-tree.c~slb-drop-kmem-cache-argument-from-constructor lib/radix-tree.c
--- a/lib/radix-tree.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/lib/radix-tree.c
@@ -1183,7 +1183,7 @@ int radix_tree_tagged(struct radix_tree_
 EXPORT_SYMBOL(radix_tree_tagged);
 
 static void
-radix_tree_node_ctor(struct kmem_cache *cachep, void *node)
+radix_tree_node_ctor(void *node)
 {
 	memset(node, 0, sizeof(struct radix_tree_node));
 }
diff -puN mm/rmap.c~slb-drop-kmem-cache-argument-from-constructor mm/rmap.c
--- a/mm/rmap.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/mm/rmap.c
@@ -138,7 +138,7 @@ void anon_vma_unlink(struct vm_area_stru
 		anon_vma_free(anon_vma);
 }
 
-static void anon_vma_ctor(struct kmem_cache *cachep, void *data)
+static void anon_vma_ctor(void *data)
 {
 	struct anon_vma *anon_vma = data;
 
diff -puN mm/shmem.c~slb-drop-kmem-cache-argument-from-constructor mm/shmem.c
--- a/mm/shmem.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/mm/shmem.c
@@ -2352,7 +2352,7 @@ static void shmem_destroy_inode(struct i
 	kmem_cache_free(shmem_inode_cachep, SHMEM_I(inode));
 }
 
-static void init_once(struct kmem_cache *cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct shmem_inode_info *p = (struct shmem_inode_info *) foo;
 
diff -puN mm/slab.c~slb-drop-kmem-cache-argument-from-constructor mm/slab.c
--- a/mm/slab.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/mm/slab.c
@@ -406,7 +406,7 @@ struct kmem_cache {
 	unsigned int dflags;		/* dynamic flags */
 
 	/* constructor func */
-	void (*ctor)(struct kmem_cache *, void *);
+	void (*ctor)(void *obj);
 
 /* 5) cache creation/removal */
 	const char *name;
@@ -2137,8 +2137,7 @@ static int __init_refok setup_cpu_cache(
  */
 struct kmem_cache *
 kmem_cache_create (const char *name, size_t size, size_t align,
-	unsigned long flags,
-	void (*ctor)(struct kmem_cache *, void *))
+	unsigned long flags, void (*ctor)(void *))
 {
 	size_t left_over, slab_size, ralign;
 	struct kmem_cache *cachep = NULL, *pc;
@@ -2653,7 +2652,7 @@ static void cache_init_objs(struct kmem_
 		 * They must also be threaded.
 		 */
 		if (cachep->ctor && !(cachep->flags & SLAB_POISON))
-			cachep->ctor(cachep, objp + obj_offset(cachep));
+			cachep->ctor(objp + obj_offset(cachep));
 
 		if (cachep->flags & SLAB_RED_ZONE) {
 			if (*dbg_redzone2(cachep, objp) != RED_INACTIVE)
@@ -2669,7 +2668,7 @@ static void cache_init_objs(struct kmem_
 					 cachep->buffer_size / PAGE_SIZE, 0);
 #else
 		if (cachep->ctor)
-			cachep->ctor(cachep, objp);
+			cachep->ctor(objp);
 #endif
 		slab_bufctl(slabp)[i] = i + 1;
 	}
@@ -3093,7 +3092,7 @@ static void *cache_alloc_debugcheck_afte
 #endif
 	objp += obj_offset(cachep);
 	if (cachep->ctor && cachep->flags & SLAB_POISON)
-		cachep->ctor(cachep, objp);
+		cachep->ctor(objp);
 #if ARCH_SLAB_MINALIGN
 	if ((u32)objp & (ARCH_SLAB_MINALIGN-1)) {
 		printk(KERN_ERR "0x%p: not aligned to ARCH_SLAB_MINALIGN=%d\n",
diff -puN mm/slob.c~slb-drop-kmem-cache-argument-from-constructor mm/slob.c
--- a/mm/slob.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/mm/slob.c
@@ -525,12 +525,11 @@ struct kmem_cache {
 	unsigned int size, align;
 	unsigned long flags;
 	const char *name;
-	void (*ctor)(struct kmem_cache *, void *);
+	void (*ctor)(void *);
 };
 
 struct kmem_cache *kmem_cache_create(const char *name, size_t size,
-	size_t align, unsigned long flags,
-	void (*ctor)(struct kmem_cache *, void *))
+	size_t align, unsigned long flags, void (*ctor)(void *))
 {
 	struct kmem_cache *c;
 
@@ -575,7 +574,7 @@ void *kmem_cache_alloc_node(struct kmem_
 		b = slob_new_page(flags, get_order(c->size), node);
 
 	if (c->ctor)
-		c->ctor(c, b);
+		c->ctor(b);
 
 	return b;
 }
diff -puN mm/slub.c~slb-drop-kmem-cache-argument-from-constructor mm/slub.c
--- a/mm/slub.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/mm/slub.c
@@ -1012,7 +1012,7 @@ __setup("slub_debug", setup_slub_debug);
 
 static unsigned long kmem_cache_flags(unsigned long objsize,
 	unsigned long flags, const char *name,
-	void (*ctor)(struct kmem_cache *, void *))
+	void (*ctor)(void *))
 {
 	/*
 	 * Enable debugging if selected on the kernel commandline.
@@ -1040,7 +1040,7 @@ static inline int check_object(struct km
 static inline void add_full(struct kmem_cache_node *n, struct page *page) {}
 static inline unsigned long kmem_cache_flags(unsigned long objsize,
 	unsigned long flags, const char *name,
-	void (*ctor)(struct kmem_cache *, void *))
+	void (*ctor)(void *))
 {
 	return flags;
 }
@@ -1103,7 +1103,7 @@ static void setup_object(struct kmem_cac
 {
 	setup_object_debug(s, page, object);
 	if (unlikely(s->ctor))
-		s->ctor(s, object);
+		s->ctor(object);
 }
 
 static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
@@ -2286,7 +2286,7 @@ static int calculate_sizes(struct kmem_c
 static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
 		const char *name, size_t size,
 		size_t align, unsigned long flags,
-		void (*ctor)(struct kmem_cache *, void *))
+		void (*ctor)(void *))
 {
 	memset(s, 0, kmem_size);
 	s->name = name;
@@ -3042,7 +3042,7 @@ static int slab_unmergeable(struct kmem_
 
 static struct kmem_cache *find_mergeable(size_t size,
 		size_t align, unsigned long flags, const char *name,
-		void (*ctor)(struct kmem_cache *, void *))
+		void (*ctor)(void *))
 {
 	struct kmem_cache *s;
 
@@ -3082,8 +3082,7 @@ static struct kmem_cache *find_mergeable
 }
 
 struct kmem_cache *kmem_cache_create(const char *name, size_t size,
-		size_t align, unsigned long flags,
-		void (*ctor)(struct kmem_cache *, void *))
+		size_t align, unsigned long flags, void (*ctor)(void *))
 {
 	struct kmem_cache *s;
 
diff -puN net/socket.c~slb-drop-kmem-cache-argument-from-constructor net/socket.c
--- a/net/socket.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/net/socket.c
@@ -265,7 +265,7 @@ static void sock_destroy_inode(struct in
 			container_of(inode, struct socket_alloc, vfs_inode));
 }
 
-static void init_once(struct kmem_cache *cachep, void *foo)
+static void init_once(void *foo)
 {
 	struct socket_alloc *ei = (struct socket_alloc *)foo;
 
diff -puN net/sunrpc/rpc_pipe.c~slb-drop-kmem-cache-argument-from-constructor net/sunrpc/rpc_pipe.c
--- a/net/sunrpc/rpc_pipe.c~slb-drop-kmem-cache-argument-from-constructor
+++ a/net/sunrpc/rpc_pipe.c
@@ -897,7 +897,7 @@ static struct file_system_type rpc_pipe_
 };
 
 static void
-init_once(struct kmem_cache * cachep, void *foo)
+init_once(void *foo)
 {
 	struct rpc_inode *rpci = (struct rpc_inode *) foo;
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
cdc-acm-dont-unlock-acm-mutex-on-error-path.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

