From: akpm@linux-foundation.org
Subject: - remove-slab_ctor_constructor.patch removed from -mm tree
Date: Fri, 18 May 2007 00:05:39 -0700
Message-ID: <200705180705.l4I75cuQ010117@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54162 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757110AbXERHU6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 03:20:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, aia21@cantab.net, bfields@fieldses.org, davem@davemloft.net, dgc@sgi.com, dhowells@redhat.com, dwmw2@infradead.org, hch@lst.de, hirofumi@mail.parknet.co.jp, jack@ucw.cz, jens.axboe@oracle.com, mark.fasheh@oracle.com, mhalcrow@us.ibm.com, miklos@szeredi.hu, paulus@samba.org, sfrench@us.ibm.com, shaggy@austin.ibm.com, swhiteho@redhat.com, trond.myklebust@fys.uio.no, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Remove SLAB_CTOR_CONSTRUCTOR
has been removed from the -mm tree.  Its filename was
     remove-slab_ctor_constructor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove SLAB_CTOR_CONSTRUCTOR
From: Christoph Lameter <clameter@sgi.com>

SLAB_CTOR_CONSTRUCTOR is always specified. No point in checking it.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Steven French <sfrench@us.ibm.com>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Anton Altaparmakov <aia21@cantab.net>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@ucw.cz>
Cc: David Chinner <dgc@sgi.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/inode.c |    4 -
 drivers/mtd/ubi/eba.c                     |    3 -
 fs/adfs/super.c                           |    3 -
 fs/affs/super.c                           |    8 +--
 fs/afs/super.c                            |   20 ++++-----
 fs/befs/linuxvfs.c                        |    6 --
 fs/bfs/inode.c                            |    3 -
 fs/block_dev.c                            |   16 +++----
 fs/buffer.c                               |   22 +---------
 fs/cifs/cifsfs.c                          |    6 --
 fs/coda/inode.c                           |    3 -
 fs/ecryptfs/main.c                        |    3 -
 fs/efs/super.c                            |    3 -
 fs/ext2/super.c                           |    8 +--
 fs/ext3/super.c                           |   10 +---
 fs/ext4/super.c                           |   10 +---
 fs/fat/cache.c                            |    3 -
 fs/fat/inode.c                            |   14 ++----
 fs/fuse/inode.c                           |    3 -
 fs/gfs2/main.c                            |   34 +++++++--------
 fs/hfs/super.c                            |    3 -
 fs/hfsplus/super.c                        |    3 -
 fs/hpfs/super.c                           |    8 +--
 fs/hugetlbfs/inode.c                      |    3 -
 fs/inode.c                                |    3 -
 fs/isofs/inode.c                          |    3 -
 fs/jffs2/super.c                          |    6 --
 fs/jfs/jfs_metapage.c                     |   18 +++-----
 fs/jfs/super.c                            |   22 ++++------
 fs/locks.c                                |    3 -
 fs/minix/inode.c                          |    3 -
 fs/ncpfs/inode.c                          |    6 --
 fs/nfs/inode.c                            |   28 +++++-------
 fs/ntfs/super.c                           |    3 -
 fs/ocfs2/dlm/dlmfs.c                      |    8 +--
 fs/ocfs2/super.c                          |   44 +++++++++-----------
 fs/openpromfs/inode.c                     |    3 -
 fs/proc/inode.c                           |    3 -
 fs/qnx4/inode.c                           |    3 -
 fs/reiserfs/super.c                       |   10 +---
 fs/romfs/inode.c                          |    7 +--
 fs/smbfs/inode.c                          |    3 -
 fs/sysv/inode.c                           |    3 -
 fs/udf/super.c                            |    6 --
 fs/ufs/super.c                            |    3 -
 fs/xfs/linux-2.6/xfs_super.c              |    3 -
 include/linux/slab.h                      |    3 -
 ipc/mqueue.c                              |    3 -
 kernel/fork.c                             |    6 --
 mm/rmap.c                                 |    8 +--
 mm/shmem.c                                |    8 +--
 mm/slab.c                                 |   12 ++---
 mm/slob.c                                 |    2 
 mm/slub.c                                 |    2 
 net/socket.c                              |    3 -
 net/sunrpc/rpc_pipe.c                     |   24 +++++-----
 56 files changed, 181 insertions(+), 280 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/inode.c~remove-slab_ctor_constructor arch/powerpc/platforms/cell/spufs/inode.c
--- a/arch/powerpc/platforms/cell/spufs/inode.c~remove-slab_ctor_constructor
+++ a/arch/powerpc/platforms/cell/spufs/inode.c
@@ -71,9 +71,7 @@ spufs_init_once(void *p, struct kmem_cac
 {
 	struct spufs_inode_info *ei = p;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		inode_init_once(&ei->vfs_inode);
-	}
+	inode_init_once(&ei->vfs_inode);
 }
 
 static struct inode *
diff -puN drivers/mtd/ubi/eba.c~remove-slab_ctor_constructor drivers/mtd/ubi/eba.c
--- a/drivers/mtd/ubi/eba.c~remove-slab_ctor_constructor
+++ a/drivers/mtd/ubi/eba.c
@@ -940,9 +940,6 @@ static void ltree_entry_ctor(void *obj, 
 {
 	struct ltree_entry *le = obj;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		return;
-
 	le->users = 0;
 	init_rwsem(&le->mutex);
 }
diff -puN fs/adfs/super.c~remove-slab_ctor_constructor fs/adfs/super.c
--- a/fs/adfs/super.c~remove-slab_ctor_constructor
+++ a/fs/adfs/super.c
@@ -232,8 +232,7 @@ static void init_once(void * foo, struct
 {
 	struct adfs_inode_info *ei = (struct adfs_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&ei->vfs_inode);
+	inode_init_once(&ei->vfs_inode);
 }
  
 static int init_inodecache(void)
diff -puN fs/affs/super.c~remove-slab_ctor_constructor fs/affs/super.c
--- a/fs/affs/super.c~remove-slab_ctor_constructor
+++ a/fs/affs/super.c
@@ -87,11 +87,9 @@ static void init_once(void * foo, struct
 {
 	struct affs_inode_info *ei = (struct affs_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		init_MUTEX(&ei->i_link_lock);
-		init_MUTEX(&ei->i_ext_lock);
-		inode_init_once(&ei->vfs_inode);
-	}
+	init_MUTEX(&ei->i_link_lock);
+	init_MUTEX(&ei->i_ext_lock);
+	inode_init_once(&ei->vfs_inode);
 }
 
 static int init_inodecache(void)
diff -puN fs/afs/super.c~remove-slab_ctor_constructor fs/afs/super.c
--- a/fs/afs/super.c~remove-slab_ctor_constructor
+++ a/fs/afs/super.c
@@ -452,17 +452,15 @@ static void afs_i_init_once(void *_vnode
 {
 	struct afs_vnode *vnode = _vnode;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		memset(vnode, 0, sizeof(*vnode));
-		inode_init_once(&vnode->vfs_inode);
-		init_waitqueue_head(&vnode->update_waitq);
-		mutex_init(&vnode->permits_lock);
-		mutex_init(&vnode->validate_lock);
-		spin_lock_init(&vnode->writeback_lock);
-		spin_lock_init(&vnode->lock);
-		INIT_LIST_HEAD(&vnode->writebacks);
-		INIT_WORK(&vnode->cb_broken_work, afs_broken_callback_work);
-	}
+	memset(vnode, 0, sizeof(*vnode));
+	inode_init_once(&vnode->vfs_inode);
+	init_waitqueue_head(&vnode->update_waitq);
+	mutex_init(&vnode->permits_lock);
+	mutex_init(&vnode->validate_lock);
+	spin_lock_init(&vnode->writeback_lock);
+	spin_lock_init(&vnode->lock);
+	INIT_LIST_HEAD(&vnode->writebacks);
+	INIT_WORK(&vnode->cb_broken_work, afs_broken_callback_work);
 }
 
 /*
diff -puN fs/befs/linuxvfs.c~remove-slab_ctor_constructor fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~remove-slab_ctor_constructor
+++ a/fs/befs/linuxvfs.c
@@ -292,10 +292,8 @@ befs_destroy_inode(struct inode *inode)
 static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
         struct befs_inode_info *bi = (struct befs_inode_info *) foo;
-	
-	        if (flags & SLAB_CTOR_CONSTRUCTOR) {
-			inode_init_once(&bi->vfs_inode);
-		}
+
+	inode_init_once(&bi->vfs_inode);
 }
 
 static void
diff -puN fs/bfs/inode.c~remove-slab_ctor_constructor fs/bfs/inode.c
--- a/fs/bfs/inode.c~remove-slab_ctor_constructor
+++ a/fs/bfs/inode.c
@@ -248,8 +248,7 @@ static void init_once(void * foo, struct
 {
 	struct bfs_inode_info *bi = foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&bi->vfs_inode);
+	inode_init_once(&bi->vfs_inode);
 }
  
 static int init_inodecache(void)
diff -puN fs/block_dev.c~remove-slab_ctor_constructor fs/block_dev.c
--- a/fs/block_dev.c~remove-slab_ctor_constructor
+++ a/fs/block_dev.c
@@ -458,17 +458,15 @@ static void init_once(void * foo, struct
 	struct bdev_inode *ei = (struct bdev_inode *) foo;
 	struct block_device *bdev = &ei->bdev;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		memset(bdev, 0, sizeof(*bdev));
-		mutex_init(&bdev->bd_mutex);
-		sema_init(&bdev->bd_mount_sem, 1);
-		INIT_LIST_HEAD(&bdev->bd_inodes);
-		INIT_LIST_HEAD(&bdev->bd_list);
+	memset(bdev, 0, sizeof(*bdev));
+	mutex_init(&bdev->bd_mutex);
+	sema_init(&bdev->bd_mount_sem, 1);
+	INIT_LIST_HEAD(&bdev->bd_inodes);
+	INIT_LIST_HEAD(&bdev->bd_list);
 #ifdef CONFIG_SYSFS
-		INIT_LIST_HEAD(&bdev->bd_holder_list);
+	INIT_LIST_HEAD(&bdev->bd_holder_list);
 #endif
-		inode_init_once(&ei->vfs_inode);
-	}
+	inode_init_once(&ei->vfs_inode);
 }
 
 static inline void __bd_forget(struct inode *inode)
diff -puN fs/buffer.c~remove-slab_ctor_constructor fs/buffer.c
--- a/fs/buffer.c~remove-slab_ctor_constructor
+++ a/fs/buffer.c
@@ -2898,8 +2898,9 @@ static void recalc_bh_state(void)
 	
 struct buffer_head *alloc_buffer_head(gfp_t gfp_flags)
 {
-	struct buffer_head *ret = kmem_cache_alloc(bh_cachep, gfp_flags);
+	struct buffer_head *ret = kmem_cache_zalloc(bh_cachep, gfp_flags);
 	if (ret) {
+		INIT_LIST_HEAD(&ret->b_assoc_buffers);
 		get_cpu_var(bh_accounting).nr++;
 		recalc_bh_state();
 		put_cpu_var(bh_accounting);
@@ -2918,17 +2919,6 @@ void free_buffer_head(struct buffer_head
 }
 EXPORT_SYMBOL(free_buffer_head);
 
-static void
-init_buffer_head(void *data, struct kmem_cache *cachep, unsigned long flags)
-{
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		struct buffer_head * bh = (struct buffer_head *)data;
-
-		memset(bh, 0, sizeof(*bh));
-		INIT_LIST_HEAD(&bh->b_assoc_buffers);
-	}
-}
-
 static void buffer_exit_cpu(int cpu)
 {
 	int i;
@@ -2955,12 +2945,8 @@ void __init buffer_init(void)
 {
 	int nrpages;
 
-	bh_cachep = kmem_cache_create("buffer_head",
-					sizeof(struct buffer_head), 0,
-					(SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|
-					SLAB_MEM_SPREAD),
-					init_buffer_head,
-					NULL);
+	bh_cachep = KMEM_CACHE(buffer_head,
+			SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD);
 
 	/*
 	 * Limit the bh occupancy to 10% of ZONE_NORMAL
diff -puN fs/cifs/cifsfs.c~remove-slab_ctor_constructor fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~remove-slab_ctor_constructor
+++ a/fs/cifs/cifsfs.c
@@ -701,10 +701,8 @@ cifs_init_once(void *inode, struct kmem_
 {
 	struct cifsInodeInfo *cifsi = inode;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		inode_init_once(&cifsi->vfs_inode);
-		INIT_LIST_HEAD(&cifsi->lockList);
-	}
+	inode_init_once(&cifsi->vfs_inode);
+	INIT_LIST_HEAD(&cifsi->lockList);
 }
 
 static int
diff -puN fs/coda/inode.c~remove-slab_ctor_constructor fs/coda/inode.c
--- a/fs/coda/inode.c~remove-slab_ctor_constructor
+++ a/fs/coda/inode.c
@@ -62,8 +62,7 @@ static void init_once(void * foo, struct
 {
 	struct coda_inode_info *ei = (struct coda_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&ei->vfs_inode);
+	inode_init_once(&ei->vfs_inode);
 }
  
 int coda_init_inodecache(void)
diff -puN fs/ecryptfs/main.c~remove-slab_ctor_constructor fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~remove-slab_ctor_constructor
+++ a/fs/ecryptfs/main.c
@@ -583,8 +583,7 @@ inode_info_init_once(void *vptr, struct 
 {
 	struct ecryptfs_inode_info *ei = (struct ecryptfs_inode_info *)vptr;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&ei->vfs_inode);
+	inode_init_once(&ei->vfs_inode);
 }
 
 static struct ecryptfs_cache_info {
diff -puN fs/efs/super.c~remove-slab_ctor_constructor fs/efs/super.c
--- a/fs/efs/super.c~remove-slab_ctor_constructor
+++ a/fs/efs/super.c
@@ -72,8 +72,7 @@ static void init_once(void * foo, struct
 {
 	struct efs_inode_info *ei = (struct efs_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&ei->vfs_inode);
+	inode_init_once(&ei->vfs_inode);
 }
  
 static int init_inodecache(void)
diff -puN fs/ext2/super.c~remove-slab_ctor_constructor fs/ext2/super.c
--- a/fs/ext2/super.c~remove-slab_ctor_constructor
+++ a/fs/ext2/super.c
@@ -160,13 +160,11 @@ static void init_once(void * foo, struct
 {
 	struct ext2_inode_info *ei = (struct ext2_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		rwlock_init(&ei->i_meta_lock);
+	rwlock_init(&ei->i_meta_lock);
 #ifdef CONFIG_EXT2_FS_XATTR
-		init_rwsem(&ei->xattr_sem);
+	init_rwsem(&ei->xattr_sem);
 #endif
-		inode_init_once(&ei->vfs_inode);
-	}
+	inode_init_once(&ei->vfs_inode);
 }
  
 static int init_inodecache(void)
diff -puN fs/ext3/super.c~remove-slab_ctor_constructor fs/ext3/super.c
--- a/fs/ext3/super.c~remove-slab_ctor_constructor
+++ a/fs/ext3/super.c
@@ -466,14 +466,12 @@ static void init_once(void * foo, struct
 {
 	struct ext3_inode_info *ei = (struct ext3_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		INIT_LIST_HEAD(&ei->i_orphan);
+	INIT_LIST_HEAD(&ei->i_orphan);
 #ifdef CONFIG_EXT3_FS_XATTR
-		init_rwsem(&ei->xattr_sem);
+	init_rwsem(&ei->xattr_sem);
 #endif
-		mutex_init(&ei->truncate_mutex);
-		inode_init_once(&ei->vfs_inode);
-	}
+	mutex_init(&ei->truncate_mutex);
+	inode_init_once(&ei->vfs_inode);
 }
 
 static int init_inodecache(void)
diff -puN fs/ext4/super.c~remove-slab_ctor_constructor fs/ext4/super.c
--- a/fs/ext4/super.c~remove-slab_ctor_constructor
+++ a/fs/ext4/super.c
@@ -517,14 +517,12 @@ static void init_once(void * foo, struct
 {
 	struct ext4_inode_info *ei = (struct ext4_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		INIT_LIST_HEAD(&ei->i_orphan);
+	INIT_LIST_HEAD(&ei->i_orphan);
 #ifdef CONFIG_EXT4DEV_FS_XATTR
-		init_rwsem(&ei->xattr_sem);
+	init_rwsem(&ei->xattr_sem);
 #endif
-		mutex_init(&ei->truncate_mutex);
-		inode_init_once(&ei->vfs_inode);
-	}
+	mutex_init(&ei->truncate_mutex);
+	inode_init_once(&ei->vfs_inode);
 }
 
 static int init_inodecache(void)
diff -puN fs/fat/cache.c~remove-slab_ctor_constructor fs/fat/cache.c
--- a/fs/fat/cache.c~remove-slab_ctor_constructor
+++ a/fs/fat/cache.c
@@ -40,8 +40,7 @@ static void init_once(void *foo, struct 
 {
 	struct fat_cache *cache = (struct fat_cache *)foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		INIT_LIST_HEAD(&cache->cache_list);
+	INIT_LIST_HEAD(&cache->cache_list);
 }
 
 int __init fat_cache_init(void)
diff -puN fs/fat/inode.c~remove-slab_ctor_constructor fs/fat/inode.c
--- a/fs/fat/inode.c~remove-slab_ctor_constructor
+++ a/fs/fat/inode.c
@@ -500,14 +500,12 @@ static void init_once(void * foo, struct
 {
 	struct msdos_inode_info *ei = (struct msdos_inode_info *)foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		spin_lock_init(&ei->cache_lru_lock);
-		ei->nr_caches = 0;
-		ei->cache_valid_id = FAT_CACHE_VALID + 1;
-		INIT_LIST_HEAD(&ei->cache_lru);
-		INIT_HLIST_NODE(&ei->i_fat_hash);
-		inode_init_once(&ei->vfs_inode);
-	}
+	spin_lock_init(&ei->cache_lru_lock);
+	ei->nr_caches = 0;
+	ei->cache_valid_id = FAT_CACHE_VALID + 1;
+	INIT_LIST_HEAD(&ei->cache_lru);
+	INIT_HLIST_NODE(&ei->i_fat_hash);
+	inode_init_once(&ei->vfs_inode);
 }
 
 static int __init fat_init_inodecache(void)
diff -puN fs/fuse/inode.c~remove-slab_ctor_constructor fs/fuse/inode.c
--- a/fs/fuse/inode.c~remove-slab_ctor_constructor
+++ a/fs/fuse/inode.c
@@ -687,8 +687,7 @@ static void fuse_inode_init_once(void *f
 {
 	struct inode * inode = foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(inode);
+	inode_init_once(inode);
 }
 
 static int __init fuse_fs_init(void)
diff -puN fs/gfs2/main.c~remove-slab_ctor_constructor fs/gfs2/main.c
--- a/fs/gfs2/main.c~remove-slab_ctor_constructor
+++ a/fs/gfs2/main.c
@@ -27,29 +27,27 @@
 static void gfs2_init_inode_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
 {
 	struct gfs2_inode *ip = foo;
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		inode_init_once(&ip->i_inode);
-		spin_lock_init(&ip->i_spin);
-		init_rwsem(&ip->i_rw_mutex);
-		memset(ip->i_cache, 0, sizeof(ip->i_cache));
-	}
+
+	inode_init_once(&ip->i_inode);
+	spin_lock_init(&ip->i_spin);
+	init_rwsem(&ip->i_rw_mutex);
+	memset(ip->i_cache, 0, sizeof(ip->i_cache));
 }
 
 static void gfs2_init_glock_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
 {
 	struct gfs2_glock *gl = foo;
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		INIT_HLIST_NODE(&gl->gl_list);
-		spin_lock_init(&gl->gl_spin);
-		INIT_LIST_HEAD(&gl->gl_holders);
-		INIT_LIST_HEAD(&gl->gl_waiters1);
-		INIT_LIST_HEAD(&gl->gl_waiters3);
-		gl->gl_lvb = NULL;
-		atomic_set(&gl->gl_lvb_count, 0);
-		INIT_LIST_HEAD(&gl->gl_reclaim);
-		INIT_LIST_HEAD(&gl->gl_ail_list);
-		atomic_set(&gl->gl_ail_count, 0);
-	}
+
+	INIT_HLIST_NODE(&gl->gl_list);
+	spin_lock_init(&gl->gl_spin);
+	INIT_LIST_HEAD(&gl->gl_holders);
+	INIT_LIST_HEAD(&gl->gl_waiters1);
+	INIT_LIST_HEAD(&gl->gl_waiters3);
+	gl->gl_lvb = NULL;
+	atomic_set(&gl->gl_lvb_count, 0);
+	INIT_LIST_HEAD(&gl->gl_reclaim);
+	INIT_LIST_HEAD(&gl->gl_ail_list);
+	atomic_set(&gl->gl_ail_count, 0);
 }
 
 /**
diff -puN fs/hfs/super.c~remove-slab_ctor_constructor fs/hfs/super.c
--- a/fs/hfs/super.c~remove-slab_ctor_constructor
+++ a/fs/hfs/super.c
@@ -434,8 +434,7 @@ static void hfs_init_once(void *p, struc
 {
 	struct hfs_inode_info *i = p;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&i->vfs_inode);
+	inode_init_once(&i->vfs_inode);
 }
 
 static int __init init_hfs_fs(void)
diff -puN fs/hfsplus/super.c~remove-slab_ctor_constructor fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~remove-slab_ctor_constructor
+++ a/fs/hfsplus/super.c
@@ -470,8 +470,7 @@ static void hfsplus_init_once(void *p, s
 {
 	struct hfsplus_inode_info *i = p;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&i->vfs_inode);
+	inode_init_once(&i->vfs_inode);
 }
 
 static int __init init_hfsplus_fs(void)
diff -puN fs/hpfs/super.c~remove-slab_ctor_constructor fs/hpfs/super.c
--- a/fs/hpfs/super.c~remove-slab_ctor_constructor
+++ a/fs/hpfs/super.c
@@ -176,11 +176,9 @@ static void init_once(void * foo, struct
 {
 	struct hpfs_inode_info *ei = (struct hpfs_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		mutex_init(&ei->i_mutex);
-		mutex_init(&ei->i_parent_mutex);
-		inode_init_once(&ei->vfs_inode);
-	}
+	mutex_init(&ei->i_mutex);
+	mutex_init(&ei->i_parent_mutex);
+	inode_init_once(&ei->vfs_inode);
 }
  
 static int init_inodecache(void)
diff -puN fs/hugetlbfs/inode.c~remove-slab_ctor_constructor fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~remove-slab_ctor_constructor
+++ a/fs/hugetlbfs/inode.c
@@ -556,8 +556,7 @@ static void init_once(void *foo, struct 
 {
 	struct hugetlbfs_inode_info *ei = (struct hugetlbfs_inode_info *)foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&ei->vfs_inode);
+	inode_init_once(&ei->vfs_inode);
 }
 
 const struct file_operations hugetlbfs_file_operations = {
diff -puN fs/inode.c~remove-slab_ctor_constructor fs/inode.c
--- a/fs/inode.c~remove-slab_ctor_constructor
+++ a/fs/inode.c
@@ -213,8 +213,7 @@ static void init_once(void * foo, struct
 {
 	struct inode * inode = (struct inode *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(inode);
+	inode_init_once(inode);
 }
 
 /*
diff -puN fs/isofs/inode.c~remove-slab_ctor_constructor fs/isofs/inode.c
--- a/fs/isofs/inode.c~remove-slab_ctor_constructor
+++ a/fs/isofs/inode.c
@@ -77,8 +77,7 @@ static void init_once(void *foo, struct 
 {
 	struct iso_inode_info *ei = foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&ei->vfs_inode);
+	inode_init_once(&ei->vfs_inode);
 }
  
 static int init_inodecache(void)
diff -puN fs/jffs2/super.c~remove-slab_ctor_constructor fs/jffs2/super.c
--- a/fs/jffs2/super.c~remove-slab_ctor_constructor
+++ a/fs/jffs2/super.c
@@ -47,10 +47,8 @@ static void jffs2_i_init_once(void * foo
 {
 	struct jffs2_inode_info *ei = (struct jffs2_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		init_MUTEX(&ei->sem);
-		inode_init_once(&ei->vfs_inode);
-	}
+	init_MUTEX(&ei->sem);
+	inode_init_once(&ei->vfs_inode);
 }
 
 static int jffs2_sync_fs(struct super_block *sb, int wait)
diff -puN fs/jfs/jfs_metapage.c~remove-slab_ctor_constructor fs/jfs/jfs_metapage.c
--- a/fs/jfs/jfs_metapage.c~remove-slab_ctor_constructor
+++ a/fs/jfs/jfs_metapage.c
@@ -184,16 +184,14 @@ static void init_once(void *foo, struct 
 {
 	struct metapage *mp = (struct metapage *)foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		mp->lid = 0;
-		mp->lsn = 0;
-		mp->flag = 0;
-		mp->data = NULL;
-		mp->clsn = 0;
-		mp->log = NULL;
-		set_bit(META_free, &mp->flag);
-		init_waitqueue_head(&mp->wait);
-	}
+	mp->lid = 0;
+	mp->lsn = 0;
+	mp->flag = 0;
+	mp->data = NULL;
+	mp->clsn = 0;
+	mp->log = NULL;
+	set_bit(META_free, &mp->flag);
+	init_waitqueue_head(&mp->wait);
 }
 
 static inline struct metapage *alloc_metapage(gfp_t gfp_mask)
diff -puN fs/jfs/super.c~remove-slab_ctor_constructor fs/jfs/super.c
--- a/fs/jfs/super.c~remove-slab_ctor_constructor
+++ a/fs/jfs/super.c
@@ -752,20 +752,18 @@ static void init_once(void *foo, struct 
 {
 	struct jfs_inode_info *jfs_ip = (struct jfs_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		memset(jfs_ip, 0, sizeof(struct jfs_inode_info));
-		INIT_LIST_HEAD(&jfs_ip->anon_inode_list);
-		init_rwsem(&jfs_ip->rdwrlock);
-		mutex_init(&jfs_ip->commit_mutex);
-		init_rwsem(&jfs_ip->xattr_sem);
-		spin_lock_init(&jfs_ip->ag_lock);
-		jfs_ip->active_ag = -1;
+	memset(jfs_ip, 0, sizeof(struct jfs_inode_info));
+	INIT_LIST_HEAD(&jfs_ip->anon_inode_list);
+	init_rwsem(&jfs_ip->rdwrlock);
+	mutex_init(&jfs_ip->commit_mutex);
+	init_rwsem(&jfs_ip->xattr_sem);
+	spin_lock_init(&jfs_ip->ag_lock);
+	jfs_ip->active_ag = -1;
 #ifdef CONFIG_JFS_POSIX_ACL
-		jfs_ip->i_acl = JFS_ACL_NOT_CACHED;
-		jfs_ip->i_default_acl = JFS_ACL_NOT_CACHED;
+	jfs_ip->i_acl = JFS_ACL_NOT_CACHED;
+	jfs_ip->i_default_acl = JFS_ACL_NOT_CACHED;
 #endif
-		inode_init_once(&jfs_ip->vfs_inode);
-	}
+	inode_init_once(&jfs_ip->vfs_inode);
 }
 
 static int __init init_jfs_fs(void)
diff -puN fs/locks.c~remove-slab_ctor_constructor fs/locks.c
--- a/fs/locks.c~remove-slab_ctor_constructor
+++ a/fs/locks.c
@@ -203,9 +203,6 @@ static void init_once(void *foo, struct 
 {
 	struct file_lock *lock = (struct file_lock *) foo;
 
-	if (!(flags & SLAB_CTOR_CONSTRUCTOR))
-		return;
-
 	locks_init_lock(lock);
 }
 
diff -puN fs/minix/inode.c~remove-slab_ctor_constructor fs/minix/inode.c
--- a/fs/minix/inode.c~remove-slab_ctor_constructor
+++ a/fs/minix/inode.c
@@ -73,8 +73,7 @@ static void init_once(void * foo, struct
 {
 	struct minix_inode_info *ei = (struct minix_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&ei->vfs_inode);
+	inode_init_once(&ei->vfs_inode);
 }
  
 static int init_inodecache(void)
diff -puN fs/ncpfs/inode.c~remove-slab_ctor_constructor fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~remove-slab_ctor_constructor
+++ a/fs/ncpfs/inode.c
@@ -60,10 +60,8 @@ static void init_once(void * foo, struct
 {
 	struct ncp_inode_info *ei = (struct ncp_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		mutex_init(&ei->open_mutex);
-		inode_init_once(&ei->vfs_inode);
-	}
+	mutex_init(&ei->open_mutex);
+	inode_init_once(&ei->vfs_inode);
 }
  
 static int init_inodecache(void)
diff -puN fs/nfs/inode.c~remove-slab_ctor_constructor fs/nfs/inode.c
--- a/fs/nfs/inode.c~remove-slab_ctor_constructor
+++ a/fs/nfs/inode.c
@@ -1164,21 +1164,19 @@ static void init_once(void * foo, struct
 {
 	struct nfs_inode *nfsi = (struct nfs_inode *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		inode_init_once(&nfsi->vfs_inode);
-		spin_lock_init(&nfsi->req_lock);
-		INIT_LIST_HEAD(&nfsi->dirty);
-		INIT_LIST_HEAD(&nfsi->commit);
-		INIT_LIST_HEAD(&nfsi->open_files);
-		INIT_LIST_HEAD(&nfsi->access_cache_entry_lru);
-		INIT_LIST_HEAD(&nfsi->access_cache_inode_lru);
-		INIT_RADIX_TREE(&nfsi->nfs_page_tree, GFP_ATOMIC);
-		atomic_set(&nfsi->data_updates, 0);
-		nfsi->ndirty = 0;
-		nfsi->ncommit = 0;
-		nfsi->npages = 0;
-		nfs4_init_once(nfsi);
-	}
+	inode_init_once(&nfsi->vfs_inode);
+	spin_lock_init(&nfsi->req_lock);
+	INIT_LIST_HEAD(&nfsi->dirty);
+	INIT_LIST_HEAD(&nfsi->commit);
+	INIT_LIST_HEAD(&nfsi->open_files);
+	INIT_LIST_HEAD(&nfsi->access_cache_entry_lru);
+	INIT_LIST_HEAD(&nfsi->access_cache_inode_lru);
+	INIT_RADIX_TREE(&nfsi->nfs_page_tree, GFP_ATOMIC);
+	atomic_set(&nfsi->data_updates, 0);
+	nfsi->ndirty = 0;
+	nfsi->ncommit = 0;
+	nfsi->npages = 0;
+	nfs4_init_once(nfsi);
 }
  
 static int __init nfs_init_inodecache(void)
diff -puN fs/ntfs/super.c~remove-slab_ctor_constructor fs/ntfs/super.c
--- a/fs/ntfs/super.c~remove-slab_ctor_constructor
+++ a/fs/ntfs/super.c
@@ -3085,8 +3085,7 @@ static void ntfs_big_inode_init_once(voi
 {
 	ntfs_inode *ni = (ntfs_inode *)foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(VFS_I(ni));
+	inode_init_once(VFS_I(ni));
 }
 
 /*
diff -puN fs/ocfs2/dlm/dlmfs.c~remove-slab_ctor_constructor fs/ocfs2/dlm/dlmfs.c
--- a/fs/ocfs2/dlm/dlmfs.c~remove-slab_ctor_constructor
+++ a/fs/ocfs2/dlm/dlmfs.c
@@ -262,12 +262,10 @@ static void dlmfs_init_once(void *foo,
 	struct dlmfs_inode_private *ip =
 		(struct dlmfs_inode_private *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		ip->ip_dlm = NULL;
-		ip->ip_parent = NULL;
+	ip->ip_dlm = NULL;
+	ip->ip_parent = NULL;
 
-		inode_init_once(&ip->ip_vfs_inode);
-	}
+	inode_init_once(&ip->ip_vfs_inode);
 }
 
 static struct inode *dlmfs_alloc_inode(struct super_block *sb)
diff -puN fs/ocfs2/super.c~remove-slab_ctor_constructor fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~remove-slab_ctor_constructor
+++ a/fs/ocfs2/super.c
@@ -937,31 +937,29 @@ static void ocfs2_inode_init_once(void *
 {
 	struct ocfs2_inode_info *oi = data;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		oi->ip_flags = 0;
-		oi->ip_open_count = 0;
-		spin_lock_init(&oi->ip_lock);
-		ocfs2_extent_map_init(&oi->vfs_inode);
-		INIT_LIST_HEAD(&oi->ip_io_markers);
-		oi->ip_created_trans = 0;
-		oi->ip_last_trans = 0;
-		oi->ip_dir_start_lookup = 0;
-
-		init_rwsem(&oi->ip_alloc_sem);
-		mutex_init(&oi->ip_io_mutex);
-
-		oi->ip_blkno = 0ULL;
-		oi->ip_clusters = 0;
-
-		ocfs2_lock_res_init_once(&oi->ip_rw_lockres);
-		ocfs2_lock_res_init_once(&oi->ip_meta_lockres);
-		ocfs2_lock_res_init_once(&oi->ip_data_lockres);
-		ocfs2_lock_res_init_once(&oi->ip_open_lockres);
+	oi->ip_flags = 0;
+	oi->ip_open_count = 0;
+	spin_lock_init(&oi->ip_lock);
+	ocfs2_extent_map_init(&oi->vfs_inode);
+	INIT_LIST_HEAD(&oi->ip_io_markers);
+	oi->ip_created_trans = 0;
+	oi->ip_last_trans = 0;
+	oi->ip_dir_start_lookup = 0;
+
+	init_rwsem(&oi->ip_alloc_sem);
+	mutex_init(&oi->ip_io_mutex);
+
+	oi->ip_blkno = 0ULL;
+	oi->ip_clusters = 0;
+
+	ocfs2_lock_res_init_once(&oi->ip_rw_lockres);
+	ocfs2_lock_res_init_once(&oi->ip_meta_lockres);
+	ocfs2_lock_res_init_once(&oi->ip_data_lockres);
+	ocfs2_lock_res_init_once(&oi->ip_open_lockres);
 
-		ocfs2_metadata_cache_init(&oi->vfs_inode);
+	ocfs2_metadata_cache_init(&oi->vfs_inode);
 
-		inode_init_once(&oi->vfs_inode);
-	}
+	inode_init_once(&oi->vfs_inode);
 }
 
 static int ocfs2_initialize_mem_caches(void)
diff -puN fs/openpromfs/inode.c~remove-slab_ctor_constructor fs/openpromfs/inode.c
--- a/fs/openpromfs/inode.c~remove-slab_ctor_constructor
+++ a/fs/openpromfs/inode.c
@@ -419,8 +419,7 @@ static void op_inode_init_once(void *dat
 {
 	struct op_inode_info *oi = (struct op_inode_info *) data;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&oi->vfs_inode);
+	inode_init_once(&oi->vfs_inode);
 }
 
 static int __init init_openprom_fs(void)
diff -puN fs/proc/inode.c~remove-slab_ctor_constructor fs/proc/inode.c
--- a/fs/proc/inode.c~remove-slab_ctor_constructor
+++ a/fs/proc/inode.c
@@ -109,8 +109,7 @@ static void init_once(void * foo, struct
 {
 	struct proc_inode *ei = (struct proc_inode *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&ei->vfs_inode);
+	inode_init_once(&ei->vfs_inode);
 }
  
 int __init proc_init_inodecache(void)
diff -puN fs/qnx4/inode.c~remove-slab_ctor_constructor fs/qnx4/inode.c
--- a/fs/qnx4/inode.c~remove-slab_ctor_constructor
+++ a/fs/qnx4/inode.c
@@ -536,8 +536,7 @@ static void init_once(void *foo, struct 
 {
 	struct qnx4_inode_info *ei = (struct qnx4_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&ei->vfs_inode);
+	inode_init_once(&ei->vfs_inode);
 }
 
 static int init_inodecache(void)
diff -puN fs/reiserfs/super.c~remove-slab_ctor_constructor fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~remove-slab_ctor_constructor
+++ a/fs/reiserfs/super.c
@@ -511,14 +511,12 @@ static void init_once(void *foo, struct 
 {
 	struct reiserfs_inode_info *ei = (struct reiserfs_inode_info *)foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		INIT_LIST_HEAD(&ei->i_prealloc_list);
-		inode_init_once(&ei->vfs_inode);
+	INIT_LIST_HEAD(&ei->i_prealloc_list);
+	inode_init_once(&ei->vfs_inode);
 #ifdef CONFIG_REISERFS_FS_POSIX_ACL
-		ei->i_acl_access = NULL;
-		ei->i_acl_default = NULL;
+	ei->i_acl_access = NULL;
+	ei->i_acl_default = NULL;
 #endif
-	}
 }
 
 static int init_inodecache(void)
diff -puN fs/romfs/inode.c~remove-slab_ctor_constructor fs/romfs/inode.c
--- a/fs/romfs/inode.c~remove-slab_ctor_constructor
+++ a/fs/romfs/inode.c
@@ -566,12 +566,11 @@ static void romfs_destroy_inode(struct i
 	kmem_cache_free(romfs_inode_cachep, ROMFS_I(inode));
 }
 
-static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
+static void init_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
 {
-	struct romfs_inode_info *ei = (struct romfs_inode_info *) foo;
+	struct romfs_inode_info *ei = foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&ei->vfs_inode);
+	inode_init_once(&ei->vfs_inode);
 }
  
 static int init_inodecache(void)
diff -puN fs/smbfs/inode.c~remove-slab_ctor_constructor fs/smbfs/inode.c
--- a/fs/smbfs/inode.c~remove-slab_ctor_constructor
+++ a/fs/smbfs/inode.c
@@ -70,8 +70,7 @@ static void init_once(void * foo, struct
 {
 	struct smb_inode_info *ei = (struct smb_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&ei->vfs_inode);
+	inode_init_once(&ei->vfs_inode);
 }
  
 static int init_inodecache(void)
diff -puN fs/sysv/inode.c~remove-slab_ctor_constructor fs/sysv/inode.c
--- a/fs/sysv/inode.c~remove-slab_ctor_constructor
+++ a/fs/sysv/inode.c
@@ -322,8 +322,7 @@ static void init_once(void *p, struct km
 {
 	struct sysv_inode_info *si = (struct sysv_inode_info *)p;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&si->vfs_inode);
+	inode_init_once(&si->vfs_inode);
 }
 
 const struct super_operations sysv_sops = {
diff -puN fs/udf/super.c~remove-slab_ctor_constructor fs/udf/super.c
--- a/fs/udf/super.c~remove-slab_ctor_constructor
+++ a/fs/udf/super.c
@@ -134,10 +134,8 @@ static void init_once(void * foo, struct
 {
 	struct udf_inode_info *ei = (struct udf_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		ei->i_ext.i_data = NULL;
-		inode_init_once(&ei->vfs_inode);
-	}
+	ei->i_ext.i_data = NULL;
+	inode_init_once(&ei->vfs_inode);
 }
 
 static int init_inodecache(void)
diff -puN fs/ufs/super.c~remove-slab_ctor_constructor fs/ufs/super.c
--- a/fs/ufs/super.c~remove-slab_ctor_constructor
+++ a/fs/ufs/super.c
@@ -1237,8 +1237,7 @@ static void init_once(void * foo, struct
 {
 	struct ufs_inode_info *ei = (struct ufs_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&ei->vfs_inode);
+	inode_init_once(&ei->vfs_inode);
 }
  
 static int init_inodecache(void)
diff -puN fs/xfs/linux-2.6/xfs_super.c~remove-slab_ctor_constructor fs/xfs/linux-2.6/xfs_super.c
--- a/fs/xfs/linux-2.6/xfs_super.c~remove-slab_ctor_constructor
+++ a/fs/xfs/linux-2.6/xfs_super.c
@@ -360,8 +360,7 @@ xfs_fs_inode_init_once(
 	kmem_zone_t		*zonep,
 	unsigned long		flags)
 {
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(vn_to_inode((bhv_vnode_t *)vnode));
+	inode_init_once(vn_to_inode((bhv_vnode_t *)vnode));
 }
 
 STATIC int
diff -puN include/linux/slab.h~remove-slab_ctor_constructor include/linux/slab.h
--- a/include/linux/slab.h~remove-slab_ctor_constructor
+++ a/include/linux/slab.h
@@ -32,9 +32,6 @@ typedef struct kmem_cache kmem_cache_t _
 #define SLAB_MEM_SPREAD		0x00100000UL	/* Spread some memory over cpuset */
 #define SLAB_TRACE		0x00200000UL	/* Trace allocations and frees */
 
-/* Flags passed to a constructor functions */
-#define SLAB_CTOR_CONSTRUCTOR	0x001UL		/* If not set, then deconstructor */
-
 /*
  * struct kmem_cache related prototypes
  */
diff -puN ipc/mqueue.c~remove-slab_ctor_constructor ipc/mqueue.c
--- a/ipc/mqueue.c~remove-slab_ctor_constructor
+++ a/ipc/mqueue.c
@@ -215,8 +215,7 @@ static void init_once(void *foo, struct 
 {
 	struct mqueue_inode_info *p = (struct mqueue_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&p->vfs_inode);
+	inode_init_once(&p->vfs_inode);
 }
 
 static struct inode *mqueue_alloc_inode(struct super_block *sb)
diff -puN kernel/fork.c~remove-slab_ctor_constructor kernel/fork.c
--- a/kernel/fork.c~remove-slab_ctor_constructor
+++ a/kernel/fork.c
@@ -1427,10 +1427,8 @@ static void sighand_ctor(void *data, str
 {
 	struct sighand_struct *sighand = data;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		spin_lock_init(&sighand->siglock);
-		INIT_LIST_HEAD(&sighand->signalfd_list);
-	}
+	spin_lock_init(&sighand->siglock);
+	INIT_LIST_HEAD(&sighand->signalfd_list);
 }
 
 void __init proc_caches_init(void)
diff -puN mm/rmap.c~remove-slab_ctor_constructor mm/rmap.c
--- a/mm/rmap.c~remove-slab_ctor_constructor
+++ a/mm/rmap.c
@@ -162,12 +162,10 @@ void anon_vma_unlink(struct vm_area_stru
 static void anon_vma_ctor(void *data, struct kmem_cache *cachep,
 			  unsigned long flags)
 {
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		struct anon_vma *anon_vma = data;
+	struct anon_vma *anon_vma = data;
 
-		spin_lock_init(&anon_vma->lock);
-		INIT_LIST_HEAD(&anon_vma->head);
-	}
+	spin_lock_init(&anon_vma->lock);
+	INIT_LIST_HEAD(&anon_vma->head);
 }
 
 void __init anon_vma_init(void)
diff -puN mm/shmem.c~remove-slab_ctor_constructor mm/shmem.c
--- a/mm/shmem.c~remove-slab_ctor_constructor
+++ a/mm/shmem.c
@@ -2358,13 +2358,11 @@ static void init_once(void *foo, struct 
 {
 	struct shmem_inode_info *p = (struct shmem_inode_info *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		inode_init_once(&p->vfs_inode);
+	inode_init_once(&p->vfs_inode);
 #ifdef CONFIG_TMPFS_POSIX_ACL
-		p->i_acl = NULL;
-		p->i_default_acl = NULL;
+	p->i_acl = NULL;
+	p->i_default_acl = NULL;
 #endif
-	}
 }
 
 static int init_inodecache(void)
diff -puN mm/slab.c~remove-slab_ctor_constructor mm/slab.c
--- a/mm/slab.c~remove-slab_ctor_constructor
+++ a/mm/slab.c
@@ -2610,7 +2610,7 @@ static inline kmem_bufctl_t *slab_bufctl
 }
 
 static void cache_init_objs(struct kmem_cache *cachep,
-			    struct slab *slabp, unsigned long ctor_flags)
+			    struct slab *slabp)
 {
 	int i;
 
@@ -2634,7 +2634,7 @@ static void cache_init_objs(struct kmem_
 		 */
 		if (cachep->ctor && !(cachep->flags & SLAB_POISON))
 			cachep->ctor(objp + obj_offset(cachep), cachep,
-				     ctor_flags);
+				     0);
 
 		if (cachep->flags & SLAB_RED_ZONE) {
 			if (*dbg_redzone2(cachep, objp) != RED_INACTIVE)
@@ -2650,7 +2650,7 @@ static void cache_init_objs(struct kmem_
 					 cachep->buffer_size / PAGE_SIZE, 0);
 #else
 		if (cachep->ctor)
-			cachep->ctor(objp, cachep, ctor_flags);
+			cachep->ctor(objp, cachep, 0);
 #endif
 		slab_bufctl(slabp)[i] = i + 1;
 	}
@@ -2739,7 +2739,6 @@ static int cache_grow(struct kmem_cache 
 	struct slab *slabp;
 	size_t offset;
 	gfp_t local_flags;
-	unsigned long ctor_flags;
 	struct kmem_list3 *l3;
 
 	/*
@@ -2748,7 +2747,6 @@ static int cache_grow(struct kmem_cache 
 	 */
 	BUG_ON(flags & ~(GFP_DMA | GFP_LEVEL_MASK));
 
-	ctor_flags = SLAB_CTOR_CONSTRUCTOR;
 	local_flags = (flags & GFP_LEVEL_MASK);
 	/* Take the l3 list lock to change the colour_next on this node */
 	check_irq_off();
@@ -2793,7 +2791,7 @@ static int cache_grow(struct kmem_cache 
 	slabp->nodeid = nodeid;
 	slab_map_pages(cachep, slabp, objp);
 
-	cache_init_objs(cachep, slabp, ctor_flags);
+	cache_init_objs(cachep, slabp);
 
 	if (local_flags & __GFP_WAIT)
 		local_irq_disable();
@@ -3077,7 +3075,7 @@ static void *cache_alloc_debugcheck_afte
 #endif
 	objp += obj_offset(cachep);
 	if (cachep->ctor && cachep->flags & SLAB_POISON)
-		cachep->ctor(objp, cachep, SLAB_CTOR_CONSTRUCTOR);
+		cachep->ctor(objp, cachep, 0);
 #if ARCH_SLAB_MINALIGN
 	if ((u32)objp & (ARCH_SLAB_MINALIGN-1)) {
 		printk(KERN_ERR "0x%p: not aligned to ARCH_SLAB_MINALIGN=%d\n",
diff -puN mm/slob.c~remove-slab_ctor_constructor mm/slob.c
--- a/mm/slob.c~remove-slab_ctor_constructor
+++ a/mm/slob.c
@@ -327,7 +327,7 @@ void *kmem_cache_alloc(struct kmem_cache
 		b = (void *)__get_free_pages(flags, get_order(c->size));
 
 	if (c->ctor)
-		c->ctor(b, c, SLAB_CTOR_CONSTRUCTOR);
+		c->ctor(b, c, 0);
 
 	return b;
 }
diff -puN mm/slub.c~remove-slab_ctor_constructor mm/slub.c
--- a/mm/slub.c~remove-slab_ctor_constructor
+++ a/mm/slub.c
@@ -994,7 +994,7 @@ static void setup_object(struct kmem_cac
 	}
 
 	if (unlikely(s->ctor))
-		s->ctor(object, s, SLAB_CTOR_CONSTRUCTOR);
+		s->ctor(object, s, 0);
 }
 
 static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
diff -puN net/socket.c~remove-slab_ctor_constructor net/socket.c
--- a/net/socket.c~remove-slab_ctor_constructor
+++ a/net/socket.c
@@ -261,8 +261,7 @@ static void init_once(void *foo, struct 
 {
 	struct socket_alloc *ei = (struct socket_alloc *)foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		inode_init_once(&ei->vfs_inode);
+	inode_init_once(&ei->vfs_inode);
 }
 
 static int init_inodecache(void)
diff -puN net/sunrpc/rpc_pipe.c~remove-slab_ctor_constructor net/sunrpc/rpc_pipe.c
--- a/net/sunrpc/rpc_pipe.c~remove-slab_ctor_constructor
+++ a/net/sunrpc/rpc_pipe.c
@@ -828,19 +828,17 @@ init_once(void * foo, struct kmem_cache 
 {
 	struct rpc_inode *rpci = (struct rpc_inode *) foo;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		inode_init_once(&rpci->vfs_inode);
-		rpci->private = NULL;
-		rpci->nreaders = 0;
-		rpci->nwriters = 0;
-		INIT_LIST_HEAD(&rpci->in_upcall);
-		INIT_LIST_HEAD(&rpci->pipe);
-		rpci->pipelen = 0;
-		init_waitqueue_head(&rpci->waitq);
-		INIT_DELAYED_WORK(&rpci->queue_timeout,
-				    rpc_timeout_upcall_queue);
-		rpci->ops = NULL;
-	}
+	inode_init_once(&rpci->vfs_inode);
+	rpci->private = NULL;
+	rpci->nreaders = 0;
+	rpci->nwriters = 0;
+	INIT_LIST_HEAD(&rpci->in_upcall);
+	INIT_LIST_HEAD(&rpci->pipe);
+	rpci->pipelen = 0;
+	init_waitqueue_head(&rpci->waitq);
+	INIT_DELAYED_WORK(&rpci->queue_timeout,
+			    rpc_timeout_upcall_queue);
+	rpci->ops = NULL;
 }
 
 int register_rpc_pipefs(void)
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-another-slabinfo-fix.patch
git-ubi.patch
quicklist-support-for-x86_64.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-mark-bio_alloc-allocations-correctly.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-rename-gfp_high_movable-to-gfp_highuser_movable.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-mark-page-cache-pages-as-__gfp_pagecache-instead-of-__gfp_movable.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
group-short-lived-and-reclaimable-kernel-allocations-do-not-annotate-shmem-allocations-explicitly.patch
group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
revoke-core-code.patch
