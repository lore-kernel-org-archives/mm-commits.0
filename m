From: akpm@linux-foundation.org
Subject: - slab-allocators-remove-slab_debug_initial-flag.patch removed from -mm tree
Date: Mon, 07 May 2007 17:04:21 -0700
Message-ID: <200705080004.l4804Lt9009006@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967358AbXEHAEw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:04:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slab allocators: Remove SLAB_DEBUG_INITIAL flag
has been removed from the -mm tree.  Its filename was
     slab-allocators-remove-slab_debug_initial-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab allocators: Remove SLAB_DEBUG_INITIAL flag
From: Christoph Lameter <clameter@sgi.com>

I have never seen a use of SLAB_DEBUG_INITIAL.  It is only supported by
SLAB.

I think its purpose was to have a callback after an object has been freed
to verify that the state is the constructor state again?  The callback is
performed before each freeing of an object.

I would think that it is much easier to check the object state manually
before the free.  That also places the check near the code object
manipulation of the object.

Also the SLAB_DEBUG_INITIAL callback is only performed if the kernel was
compiled with SLAB debugging on.  If there would be code in a constructor
handling SLAB_DEBUG_INITIAL then it would have to be conditional on
SLAB_DEBUG otherwise it would just be dead code.  But there is no such code
in the kernel.  I think SLUB_DEBUG_INITIAL is too problematic to make real
use of, difficult to understand and there are easier ways to accomplish the
same effect (i.e.  add debug code before kfree).

There is a related flag SLAB_CTOR_VERIFY that is frequently checked to be
clear in fs inode caches.  Remove the pointless checks (they would even be
pointless without removeal of SLAB_DEBUG_INITIAL) from the fs constructors.

This is the last slab flag that SLUB did not support.  Remove the check for
unimplemented flags from SLUB.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/inode.c |    3 +--
 drivers/mtd/ubi/eba.c                     |    3 +--
 fs/adfs/super.c                           |    3 +--
 fs/affs/super.c                           |    3 +--
 fs/afs/super.c                            |    3 +--
 fs/befs/linuxvfs.c                        |    3 +--
 fs/bfs/inode.c                            |    3 +--
 fs/block_dev.c                            |    4 +---
 fs/buffer.c                               |    3 +--
 fs/cifs/cifsfs.c                          |    3 +--
 fs/coda/inode.c                           |    3 +--
 fs/ecryptfs/main.c                        |    3 +--
 fs/efs/super.c                            |    3 +--
 fs/ext2/super.c                           |    3 +--
 fs/ext3/super.c                           |    3 +--
 fs/ext4/super.c                           |    3 +--
 fs/fat/cache.c                            |    3 +--
 fs/fat/inode.c                            |    3 +--
 fs/fuse/inode.c                           |    3 +--
 fs/gfs2/main.c                            |    6 ++----
 fs/hfs/super.c                            |    2 +-
 fs/hfsplus/super.c                        |    2 +-
 fs/hpfs/super.c                           |    3 +--
 fs/hugetlbfs/inode.c                      |    3 +--
 fs/inode.c                                |    3 +--
 fs/isofs/inode.c                          |    3 +--
 fs/jffs2/super.c                          |    3 +--
 fs/jfs/jfs_metapage.c                     |    3 +--
 fs/jfs/super.c                            |    3 +--
 fs/locks.c                                |    3 +--
 fs/minix/inode.c                          |    3 +--
 fs/ncpfs/inode.c                          |    3 +--
 fs/nfs/inode.c                            |    3 +--
 fs/ntfs/super.c                           |    3 +--
 fs/ocfs2/dlm/dlmfs.c                      |    3 +--
 fs/ocfs2/super.c                          |    3 +--
 fs/openpromfs/inode.c                     |    3 +--
 fs/proc/inode.c                           |    3 +--
 fs/qnx4/inode.c                           |    3 +--
 fs/reiserfs/super.c                       |    3 +--
 fs/romfs/inode.c                          |    3 +--
 fs/smbfs/inode.c                          |    3 +--
 fs/sysv/inode.c                           |    3 +--
 fs/udf/super.c                            |    4 +---
 fs/ufs/super.c                            |    3 +--
 fs/xfs/linux-2.6/xfs_super.c              |    3 +--
 include/linux/slab.h                      |    2 --
 ipc/mqueue.c                              |    3 +--
 kernel/fork.c                             |    3 +--
 mm/rmap.c                                 |    3 +--
 mm/shmem.c                                |    3 +--
 mm/slab.c                                 |   20 ++------------------
 net/socket.c                              |    3 +--
 net/sunrpc/rpc_pipe.c                     |    3 +--
 54 files changed, 55 insertions(+), 126 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/inode.c~slab-allocators-remove-slab_debug_initial-flag arch/powerpc/platforms/cell/spufs/inode.c
--- a/arch/powerpc/platforms/cell/spufs/inode.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/arch/powerpc/platforms/cell/spufs/inode.c
@@ -71,8 +71,7 @@ spufs_init_once(void *p, struct kmem_cac
 {
 	struct spufs_inode_info *ei = p;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		inode_init_once(&ei->vfs_inode);
 	}
 }
diff -puN drivers/mtd/ubi/eba.c~slab-allocators-remove-slab_debug_initial-flag drivers/mtd/ubi/eba.c
--- a/drivers/mtd/ubi/eba.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/drivers/mtd/ubi/eba.c
@@ -940,8 +940,7 @@ static void ltree_entry_ctor(void *obj, 
 {
 	struct ltree_entry *le = obj;
 
-	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) !=
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		return;
 
 	le->users = 0;
diff -puN fs/adfs/super.c~slab-allocators-remove-slab_debug_initial-flag fs/adfs/super.c
--- a/fs/adfs/super.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/adfs/super.c
@@ -232,8 +232,7 @@ static void init_once(void * foo, struct
 {
 	struct adfs_inode_info *ei = (struct adfs_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&ei->vfs_inode);
 }
  
diff -puN fs/affs/super.c~slab-allocators-remove-slab_debug_initial-flag fs/affs/super.c
--- a/fs/affs/super.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/affs/super.c
@@ -87,8 +87,7 @@ static void init_once(void * foo, struct
 {
 	struct affs_inode_info *ei = (struct affs_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		init_MUTEX(&ei->i_link_lock);
 		init_MUTEX(&ei->i_ext_lock);
 		inode_init_once(&ei->vfs_inode);
diff -puN fs/afs/super.c~slab-allocators-remove-slab_debug_initial-flag fs/afs/super.c
--- a/fs/afs/super.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/afs/super.c
@@ -453,8 +453,7 @@ static void afs_i_init_once(void *_vnode
 {
 	struct afs_vnode *vnode = _vnode;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		memset(vnode, 0, sizeof(*vnode));
 		inode_init_once(&vnode->vfs_inode);
 		init_waitqueue_head(&vnode->update_waitq);
diff -puN fs/befs/linuxvfs.c~slab-allocators-remove-slab_debug_initial-flag fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/befs/linuxvfs.c
@@ -293,8 +293,7 @@ static void init_once(void * foo, struct
 {
         struct befs_inode_info *bi = (struct befs_inode_info *) foo;
 	
-	        if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-		            SLAB_CTOR_CONSTRUCTOR) {
+	        if (flags & SLAB_CTOR_CONSTRUCTOR) {
 			inode_init_once(&bi->vfs_inode);
 		}
 }
diff -puN fs/bfs/inode.c~slab-allocators-remove-slab_debug_initial-flag fs/bfs/inode.c
--- a/fs/bfs/inode.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/bfs/inode.c
@@ -248,8 +248,7 @@ static void init_once(void * foo, struct
 {
 	struct bfs_inode_info *bi = foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&bi->vfs_inode);
 }
  
diff -puN fs/block_dev.c~slab-allocators-remove-slab_debug_initial-flag fs/block_dev.c
--- a/fs/block_dev.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/block_dev.c
@@ -457,9 +457,7 @@ static void init_once(void * foo, struct
 	struct bdev_inode *ei = (struct bdev_inode *) foo;
 	struct block_device *bdev = &ei->bdev;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
-	{
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		memset(bdev, 0, sizeof(*bdev));
 		mutex_init(&bdev->bd_mutex);
 		sema_init(&bdev->bd_mount_sem, 1);
diff -puN fs/buffer.c~slab-allocators-remove-slab_debug_initial-flag fs/buffer.c
--- a/fs/buffer.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/buffer.c
@@ -2953,8 +2953,7 @@ EXPORT_SYMBOL(free_buffer_head);
 static void
 init_buffer_head(void *data, struct kmem_cache *cachep, unsigned long flags)
 {
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-			    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		struct buffer_head * bh = (struct buffer_head *)data;
 
 		memset(bh, 0, sizeof(*bh));
diff -puN fs/cifs/cifsfs.c~slab-allocators-remove-slab_debug_initial-flag fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/cifs/cifsfs.c
@@ -701,8 +701,7 @@ cifs_init_once(void *inode, struct kmem_
 {
 	struct cifsInodeInfo *cifsi = inode;
 
-	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		inode_init_once(&cifsi->vfs_inode);
 		INIT_LIST_HEAD(&cifsi->lockList);
 	}
diff -puN fs/coda/inode.c~slab-allocators-remove-slab_debug_initial-flag fs/coda/inode.c
--- a/fs/coda/inode.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/coda/inode.c
@@ -62,8 +62,7 @@ static void init_once(void * foo, struct
 {
 	struct coda_inode_info *ei = (struct coda_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&ei->vfs_inode);
 }
  
diff -puN fs/ecryptfs/main.c~slab-allocators-remove-slab_debug_initial-flag fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/ecryptfs/main.c
@@ -583,8 +583,7 @@ inode_info_init_once(void *vptr, struct 
 {
 	struct ecryptfs_inode_info *ei = (struct ecryptfs_inode_info *)vptr;
 
-	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&ei->vfs_inode);
 }
 
diff -puN fs/efs/super.c~slab-allocators-remove-slab_debug_initial-flag fs/efs/super.c
--- a/fs/efs/super.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/efs/super.c
@@ -72,8 +72,7 @@ static void init_once(void * foo, struct
 {
 	struct efs_inode_info *ei = (struct efs_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&ei->vfs_inode);
 }
  
diff -puN fs/ext2/super.c~slab-allocators-remove-slab_debug_initial-flag fs/ext2/super.c
--- a/fs/ext2/super.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/ext2/super.c
@@ -160,8 +160,7 @@ static void init_once(void * foo, struct
 {
 	struct ext2_inode_info *ei = (struct ext2_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		rwlock_init(&ei->i_meta_lock);
 #ifdef CONFIG_EXT2_FS_XATTR
 		init_rwsem(&ei->xattr_sem);
diff -puN fs/ext3/super.c~slab-allocators-remove-slab_debug_initial-flag fs/ext3/super.c
--- a/fs/ext3/super.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/ext3/super.c
@@ -466,8 +466,7 @@ static void init_once(void * foo, struct
 {
 	struct ext3_inode_info *ei = (struct ext3_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		INIT_LIST_HEAD(&ei->i_orphan);
 #ifdef CONFIG_EXT3_FS_XATTR
 		init_rwsem(&ei->xattr_sem);
diff -puN fs/ext4/super.c~slab-allocators-remove-slab_debug_initial-flag fs/ext4/super.c
--- a/fs/ext4/super.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/ext4/super.c
@@ -517,8 +517,7 @@ static void init_once(void * foo, struct
 {
 	struct ext4_inode_info *ei = (struct ext4_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		INIT_LIST_HEAD(&ei->i_orphan);
 #ifdef CONFIG_EXT4DEV_FS_XATTR
 		init_rwsem(&ei->xattr_sem);
diff -puN fs/fat/cache.c~slab-allocators-remove-slab_debug_initial-flag fs/fat/cache.c
--- a/fs/fat/cache.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/fat/cache.c
@@ -40,8 +40,7 @@ static void init_once(void *foo, struct 
 {
 	struct fat_cache *cache = (struct fat_cache *)foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		INIT_LIST_HEAD(&cache->cache_list);
 }
 
diff -puN fs/fat/inode.c~slab-allocators-remove-slab_debug_initial-flag fs/fat/inode.c
--- a/fs/fat/inode.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/fat/inode.c
@@ -499,8 +499,7 @@ static void init_once(void * foo, struct
 {
 	struct msdos_inode_info *ei = (struct msdos_inode_info *)foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		spin_lock_init(&ei->cache_lru_lock);
 		ei->nr_caches = 0;
 		ei->cache_valid_id = FAT_CACHE_VALID + 1;
diff -puN fs/fuse/inode.c~slab-allocators-remove-slab_debug_initial-flag fs/fuse/inode.c
--- a/fs/fuse/inode.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/fuse/inode.c
@@ -685,8 +685,7 @@ static void fuse_inode_init_once(void *f
 {
 	struct inode * inode = foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(inode);
 }
 
diff -puN fs/gfs2/main.c~slab-allocators-remove-slab_debug_initial-flag fs/gfs2/main.c
--- a/fs/gfs2/main.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/gfs2/main.c
@@ -27,8 +27,7 @@
 static void gfs2_init_inode_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
 {
 	struct gfs2_inode *ip = foo;
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		inode_init_once(&ip->i_inode);
 		spin_lock_init(&ip->i_spin);
 		init_rwsem(&ip->i_rw_mutex);
@@ -39,8 +38,7 @@ static void gfs2_init_inode_once(void *f
 static void gfs2_init_glock_once(void *foo, struct kmem_cache *cachep, unsigned long flags)
 {
 	struct gfs2_glock *gl = foo;
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		INIT_HLIST_NODE(&gl->gl_list);
 		spin_lock_init(&gl->gl_spin);
 		INIT_LIST_HEAD(&gl->gl_holders);
diff -puN fs/hfs/super.c~slab-allocators-remove-slab_debug_initial-flag fs/hfs/super.c
--- a/fs/hfs/super.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/hfs/super.c
@@ -434,7 +434,7 @@ static void hfs_init_once(void *p, struc
 {
 	struct hfs_inode_info *i = p;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) == SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&i->vfs_inode);
 }
 
diff -puN fs/hfsplus/super.c~slab-allocators-remove-slab_debug_initial-flag fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/hfsplus/super.c
@@ -470,7 +470,7 @@ static void hfsplus_init_once(void *p, s
 {
 	struct hfsplus_inode_info *i = p;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) == SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&i->vfs_inode);
 }
 
diff -puN fs/hpfs/super.c~slab-allocators-remove-slab_debug_initial-flag fs/hpfs/super.c
--- a/fs/hpfs/super.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/hpfs/super.c
@@ -176,8 +176,7 @@ static void init_once(void * foo, struct
 {
 	struct hpfs_inode_info *ei = (struct hpfs_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		mutex_init(&ei->i_mutex);
 		mutex_init(&ei->i_parent_mutex);
 		inode_init_once(&ei->vfs_inode);
diff -puN fs/hugetlbfs/inode.c~slab-allocators-remove-slab_debug_initial-flag fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/hugetlbfs/inode.c
@@ -556,8 +556,7 @@ static void init_once(void *foo, struct 
 {
 	struct hugetlbfs_inode_info *ei = (struct hugetlbfs_inode_info *)foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&ei->vfs_inode);
 }
 
diff -puN fs/inode.c~slab-allocators-remove-slab_debug_initial-flag fs/inode.c
--- a/fs/inode.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/inode.c
@@ -213,8 +213,7 @@ static void init_once(void * foo, struct
 {
 	struct inode * inode = (struct inode *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(inode);
 }
 
diff -puN fs/isofs/inode.c~slab-allocators-remove-slab_debug_initial-flag fs/isofs/inode.c
--- a/fs/isofs/inode.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/isofs/inode.c
@@ -77,8 +77,7 @@ static void init_once(void *foo, struct 
 {
 	struct iso_inode_info *ei = foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&ei->vfs_inode);
 }
  
diff -puN fs/jffs2/super.c~slab-allocators-remove-slab_debug_initial-flag fs/jffs2/super.c
--- a/fs/jffs2/super.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/jffs2/super.c
@@ -47,8 +47,7 @@ static void jffs2_i_init_once(void * foo
 {
 	struct jffs2_inode_info *ei = (struct jffs2_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		init_MUTEX(&ei->sem);
 		inode_init_once(&ei->vfs_inode);
 	}
diff -puN fs/jfs/jfs_metapage.c~slab-allocators-remove-slab_debug_initial-flag fs/jfs/jfs_metapage.c
--- a/fs/jfs/jfs_metapage.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/jfs/jfs_metapage.c
@@ -184,8 +184,7 @@ static void init_once(void *foo, struct 
 {
 	struct metapage *mp = (struct metapage *)foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		mp->lid = 0;
 		mp->lsn = 0;
 		mp->flag = 0;
diff -puN fs/jfs/super.c~slab-allocators-remove-slab_debug_initial-flag fs/jfs/super.c
--- a/fs/jfs/super.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/jfs/super.c
@@ -752,8 +752,7 @@ static void init_once(void *foo, struct 
 {
 	struct jfs_inode_info *jfs_ip = (struct jfs_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		memset(jfs_ip, 0, sizeof(struct jfs_inode_info));
 		INIT_LIST_HEAD(&jfs_ip->anon_inode_list);
 		init_rwsem(&jfs_ip->rdwrlock);
diff -puN fs/locks.c~slab-allocators-remove-slab_debug_initial-flag fs/locks.c
--- a/fs/locks.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/locks.c
@@ -203,8 +203,7 @@ static void init_once(void *foo, struct 
 {
 	struct file_lock *lock = (struct file_lock *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) !=
-					SLAB_CTOR_CONSTRUCTOR)
+	if (!(flags & SLAB_CTOR_CONSTRUCTOR))
 		return;
 
 	locks_init_lock(lock);
diff -puN fs/minix/inode.c~slab-allocators-remove-slab_debug_initial-flag fs/minix/inode.c
--- a/fs/minix/inode.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/minix/inode.c
@@ -73,8 +73,7 @@ static void init_once(void * foo, struct
 {
 	struct minix_inode_info *ei = (struct minix_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&ei->vfs_inode);
 }
  
diff -puN fs/ncpfs/inode.c~slab-allocators-remove-slab_debug_initial-flag fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/ncpfs/inode.c
@@ -60,8 +60,7 @@ static void init_once(void * foo, struct
 {
 	struct ncp_inode_info *ei = (struct ncp_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		mutex_init(&ei->open_mutex);
 		inode_init_once(&ei->vfs_inode);
 	}
diff -puN fs/nfs/inode.c~slab-allocators-remove-slab_debug_initial-flag fs/nfs/inode.c
--- a/fs/nfs/inode.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/nfs/inode.c
@@ -1167,8 +1167,7 @@ static void init_once(void * foo, struct
 {
 	struct nfs_inode *nfsi = (struct nfs_inode *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		inode_init_once(&nfsi->vfs_inode);
 		spin_lock_init(&nfsi->req_lock);
 		INIT_LIST_HEAD(&nfsi->dirty);
diff -puN fs/ntfs/super.c~slab-allocators-remove-slab_debug_initial-flag fs/ntfs/super.c
--- a/fs/ntfs/super.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/ntfs/super.c
@@ -3085,8 +3085,7 @@ static void ntfs_big_inode_init_once(voi
 {
 	ntfs_inode *ni = (ntfs_inode *)foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-			SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(VFS_I(ni));
 }
 
diff -puN fs/ocfs2/dlm/dlmfs.c~slab-allocators-remove-slab_debug_initial-flag fs/ocfs2/dlm/dlmfs.c
--- a/fs/ocfs2/dlm/dlmfs.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/ocfs2/dlm/dlmfs.c
@@ -263,8 +263,7 @@ static void dlmfs_init_once(void *foo,
 	struct dlmfs_inode_private *ip =
 		(struct dlmfs_inode_private *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		ip->ip_dlm = NULL;
 		ip->ip_parent = NULL;
 
diff -puN fs/ocfs2/super.c~slab-allocators-remove-slab_debug_initial-flag fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/ocfs2/super.c
@@ -937,8 +937,7 @@ static void ocfs2_inode_init_once(void *
 {
 	struct ocfs2_inode_info *oi = data;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		oi->ip_flags = 0;
 		oi->ip_open_count = 0;
 		spin_lock_init(&oi->ip_lock);
diff -puN fs/openpromfs/inode.c~slab-allocators-remove-slab_debug_initial-flag fs/openpromfs/inode.c
--- a/fs/openpromfs/inode.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/openpromfs/inode.c
@@ -419,8 +419,7 @@ static void op_inode_init_once(void *dat
 {
 	struct op_inode_info *oi = (struct op_inode_info *) data;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&oi->vfs_inode);
 }
 
diff -puN fs/proc/inode.c~slab-allocators-remove-slab_debug_initial-flag fs/proc/inode.c
--- a/fs/proc/inode.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/proc/inode.c
@@ -109,8 +109,7 @@ static void init_once(void * foo, struct
 {
 	struct proc_inode *ei = (struct proc_inode *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&ei->vfs_inode);
 }
  
diff -puN fs/qnx4/inode.c~slab-allocators-remove-slab_debug_initial-flag fs/qnx4/inode.c
--- a/fs/qnx4/inode.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/qnx4/inode.c
@@ -536,8 +536,7 @@ static void init_once(void *foo, struct 
 {
 	struct qnx4_inode_info *ei = (struct qnx4_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&ei->vfs_inode);
 }
 
diff -puN fs/reiserfs/super.c~slab-allocators-remove-slab_debug_initial-flag fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/reiserfs/super.c
@@ -511,8 +511,7 @@ static void init_once(void *foo, struct 
 {
 	struct reiserfs_inode_info *ei = (struct reiserfs_inode_info *)foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		INIT_LIST_HEAD(&ei->i_prealloc_list);
 		inode_init_once(&ei->vfs_inode);
 #ifdef CONFIG_REISERFS_FS_POSIX_ACL
diff -puN fs/romfs/inode.c~slab-allocators-remove-slab_debug_initial-flag fs/romfs/inode.c
--- a/fs/romfs/inode.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/romfs/inode.c
@@ -570,8 +570,7 @@ static void init_once(void * foo, struct
 {
 	struct romfs_inode_info *ei = (struct romfs_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&ei->vfs_inode);
 }
  
diff -puN fs/smbfs/inode.c~slab-allocators-remove-slab_debug_initial-flag fs/smbfs/inode.c
--- a/fs/smbfs/inode.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/smbfs/inode.c
@@ -69,9 +69,8 @@ static void smb_destroy_inode(struct ino
 static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flags)
 {
 	struct smb_inode_info *ei = (struct smb_inode_info *) foo;
-	unsigned long flagmask = SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR;
 
-	if ((flags & flagmask) == SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&ei->vfs_inode);
 }
  
diff -puN fs/sysv/inode.c~slab-allocators-remove-slab_debug_initial-flag fs/sysv/inode.c
--- a/fs/sysv/inode.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/sysv/inode.c
@@ -322,8 +322,7 @@ static void init_once(void *p, struct km
 {
 	struct sysv_inode_info *si = (struct sysv_inode_info *)p;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-			SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&si->vfs_inode);
 }
 
diff -puN fs/udf/super.c~slab-allocators-remove-slab_debug_initial-flag fs/udf/super.c
--- a/fs/udf/super.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/udf/super.c
@@ -134,9 +134,7 @@ static void init_once(void * foo, struct
 {
 	struct udf_inode_info *ei = (struct udf_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
-	{
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		ei->i_ext.i_data = NULL;
 		inode_init_once(&ei->vfs_inode);
 	}
diff -puN fs/ufs/super.c~slab-allocators-remove-slab_debug_initial-flag fs/ufs/super.c
--- a/fs/ufs/super.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/ufs/super.c
@@ -1237,8 +1237,7 @@ static void init_once(void * foo, struct
 {
 	struct ufs_inode_info *ei = (struct ufs_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&ei->vfs_inode);
 }
  
diff -puN fs/xfs/linux-2.6/xfs_super.c~slab-allocators-remove-slab_debug_initial-flag fs/xfs/linux-2.6/xfs_super.c
--- a/fs/xfs/linux-2.6/xfs_super.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/fs/xfs/linux-2.6/xfs_super.c
@@ -360,8 +360,7 @@ xfs_fs_inode_init_once(
 	kmem_zone_t		*zonep,
 	unsigned long		flags)
 {
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-		      SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(vn_to_inode((bhv_vnode_t *)vnode));
 }
 
diff -puN include/linux/slab.h~slab-allocators-remove-slab_debug_initial-flag include/linux/slab.h
--- a/include/linux/slab.h~slab-allocators-remove-slab_debug_initial-flag
+++ a/include/linux/slab.h
@@ -21,7 +21,6 @@ typedef struct kmem_cache kmem_cache_t _
  * The ones marked DEBUG are only valid if CONFIG_SLAB_DEBUG is set.
  */
 #define SLAB_DEBUG_FREE		0x00000100UL	/* DEBUG: Perform (expensive) checks on free */
-#define SLAB_DEBUG_INITIAL	0x00000200UL	/* DEBUG: Call constructor (as verifier) */
 #define SLAB_RED_ZONE		0x00000400UL	/* DEBUG: Red zone objs in a cache */
 #define SLAB_POISON		0x00000800UL	/* DEBUG: Poison objects */
 #define SLAB_HWCACHE_ALIGN	0x00002000UL	/* Align objs on cache lines */
@@ -35,7 +34,6 @@ typedef struct kmem_cache kmem_cache_t _
 /* Flags passed to a constructor functions */
 #define SLAB_CTOR_CONSTRUCTOR	0x001UL		/* If not set, then deconstructor */
 #define SLAB_CTOR_ATOMIC	0x002UL		/* Tell constructor it can't sleep */
-#define SLAB_CTOR_VERIFY	0x004UL		/* Tell constructor it's a verify call */
 
 /*
  * struct kmem_cache related prototypes
diff -puN ipc/mqueue.c~slab-allocators-remove-slab_debug_initial-flag ipc/mqueue.c
--- a/ipc/mqueue.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/ipc/mqueue.c
@@ -215,8 +215,7 @@ static void init_once(void *foo, struct 
 {
 	struct mqueue_inode_info *p = (struct mqueue_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) ==
-		SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&p->vfs_inode);
 }
 
diff -puN kernel/fork.c~slab-allocators-remove-slab_debug_initial-flag kernel/fork.c
--- a/kernel/fork.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/kernel/fork.c
@@ -1425,8 +1425,7 @@ static void sighand_ctor(void *data, str
 {
 	struct sighand_struct *sighand = data;
 
-	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) ==
-					SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		spin_lock_init(&sighand->siglock);
 }
 
diff -puN mm/rmap.c~slab-allocators-remove-slab_debug_initial-flag mm/rmap.c
--- a/mm/rmap.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/mm/rmap.c
@@ -162,8 +162,7 @@ void anon_vma_unlink(struct vm_area_stru
 static void anon_vma_ctor(void *data, struct kmem_cache *cachep,
 			  unsigned long flags)
 {
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-						SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		struct anon_vma *anon_vma = data;
 
 		spin_lock_init(&anon_vma->lock);
diff -puN mm/shmem.c~slab-allocators-remove-slab_debug_initial-flag mm/shmem.c
--- a/mm/shmem.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/mm/shmem.c
@@ -2358,8 +2358,7 @@ static void init_once(void *foo, struct 
 {
 	struct shmem_inode_info *p = (struct shmem_inode_info *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		inode_init_once(&p->vfs_inode);
 #ifdef CONFIG_TMPFS_POSIX_ACL
 		p->i_acl = NULL;
diff -puN mm/slab.c~slab-allocators-remove-slab_debug_initial-flag mm/slab.c
--- a/mm/slab.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/mm/slab.c
@@ -116,8 +116,7 @@
 #include	<asm/page.h>
 
 /*
- * DEBUG	- 1 for kmem_cache_create() to honour; SLAB_DEBUG_INITIAL,
- *		  SLAB_RED_ZONE & SLAB_POISON.
+ * DEBUG	- 1 for kmem_cache_create() to honour; SLAB_RED_ZONE & SLAB_POISON.
  *		  0 for faster, smaller code (especially in the critical paths).
  *
  * STATS	- 1 to collect stats for /proc/slabinfo.
@@ -172,7 +171,7 @@
 
 /* Legal flag mask for kmem_cache_create(). */
 #if DEBUG
-# define CREATE_MASK	(SLAB_DEBUG_INITIAL | SLAB_RED_ZONE | \
+# define CREATE_MASK	(SLAB_RED_ZONE | \
 			 SLAB_POISON | SLAB_HWCACHE_ALIGN | \
 			 SLAB_CACHE_DMA | \
 			 SLAB_STORE_USER | \
@@ -2184,12 +2183,6 @@ kmem_cache_create (const char *name, siz
 
 #if DEBUG
 	WARN_ON(strchr(name, ' '));	/* It confuses parsers */
-	if ((flags & SLAB_DEBUG_INITIAL) && !ctor) {
-		/* No constructor, but inital state check requested */
-		printk(KERN_ERR "%s: No con, but init state check "
-		       "requested - %s\n", __FUNCTION__, name);
-		flags &= ~SLAB_DEBUG_INITIAL;
-	}
 #if FORCED_DEBUG
 	/*
 	 * Enable redzoning and last user accounting, except for caches with
@@ -2895,15 +2888,6 @@ static void *cache_free_debugcheck(struc
 	BUG_ON(objnr >= cachep->num);
 	BUG_ON(objp != index_to_obj(cachep, slabp, objnr));
 
-	if (cachep->flags & SLAB_DEBUG_INITIAL) {
-		/*
-		 * Need to call the slab's constructor so the caller can
-		 * perform a verify of its state (debugging).  Called without
-		 * the cache-lock held.
-		 */
-		cachep->ctor(objp + obj_offset(cachep),
-			     cachep, SLAB_CTOR_CONSTRUCTOR | SLAB_CTOR_VERIFY);
-	}
 	if (cachep->flags & SLAB_POISON && cachep->dtor) {
 		/* we want to cache poison the object,
 		 * call the destruction callback
diff -puN /dev/null /dev/null
diff -puN net/socket.c~slab-allocators-remove-slab_debug_initial-flag net/socket.c
--- a/net/socket.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/net/socket.c
@@ -261,8 +261,7 @@ static void init_once(void *foo, struct 
 {
 	struct socket_alloc *ei = (struct socket_alloc *)foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR))
-	    == SLAB_CTOR_CONSTRUCTOR)
+	if (flags & SLAB_CTOR_CONSTRUCTOR)
 		inode_init_once(&ei->vfs_inode);
 }
 
diff -puN net/sunrpc/rpc_pipe.c~slab-allocators-remove-slab_debug_initial-flag net/sunrpc/rpc_pipe.c
--- a/net/sunrpc/rpc_pipe.c~slab-allocators-remove-slab_debug_initial-flag
+++ a/net/sunrpc/rpc_pipe.c
@@ -828,8 +828,7 @@ init_once(void * foo, struct kmem_cache 
 {
 	struct rpc_inode *rpci = (struct rpc_inode *) foo;
 
-	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		inode_init_once(&rpci->vfs_inode);
 		rpci->private = NULL;
 		rpci->nreaders = 0;
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-i386-support.patch
remove-constructor-from-buffer_head.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
vmstat-use-our-own-timer-events.patch
make-vm-statistics-update-interval-configurable.patch
make-vm-statistics-update-interval-configurable-fix.patch
readahead-state-based-method-aging-accounting.patch
