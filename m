From: akpm@linux-foundation.org
Subject: + account-certain-kmem-allocations-to-memcg.patch added to -mm
 tree
Date: Wed, 11 Nov 2015 13:52:14 -0800
Message-ID: <5643b88e.smgMOyU+xwuO6Hsd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56496 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbbKKVwP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 16:52:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, cl@linux.com, gthelen@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@kernel.org, penberg@kernel.org, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kmemcg: account certain kmem allocations to memcg
has been added to the -mm tree.  Its filename is
     account-certain-kmem-allocations-to-memcg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/account-certain-kmem-allocations-to-memcg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/account-certain-kmem-allocations-to-memcg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: kmemcg: account certain kmem allocations to memcg

Mark those kmem allocations that are known to be easily triggered from
userspace as __GFP_ACCOUNT/SLAB_ACCOUNT, which makes them accounted to
memcg.  For the list, see below:

 - threadinfo
 - task_struct
 - task_delay_info
 - pid
 - cred
 - mm_struct
 - vm_area_struct and vm_region (nommu)
 - anon_vma and anon_vma_chain
 - signal_struct
 - sighand_struct
 - fs_struct
 - files_struct
 - fdtable and fdtable->full_fds_bits
 - dentry and external_name
 - inode for all filesystems. This is the most tedious part, because
   most filesystems overwrite the alloc_inode method.

The list is far fromcomplete, so feel free to add more objects. 
Nevertheless, it should be close to "account everything" approach and keep
most workloads within bounds.  Malevolent users will be able to breach the
limit, but this was possible even with the former "account everything"
approach (simply because it did not account everything in fact).

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/inode.c     |    2 -
 drivers/staging/lustre/lustre/llite/super25.c |    3 +-
 fs/9p/v9fs.c                                  |    2 -
 fs/adfs/super.c                               |    2 -
 fs/affs/super.c                               |    2 -
 fs/afs/super.c                                |    2 -
 fs/befs/linuxvfs.c                            |    2 -
 fs/bfs/inode.c                                |    2 -
 fs/block_dev.c                                |    2 -
 fs/btrfs/inode.c                              |    3 +-
 fs/ceph/super.c                               |    4 +-
 fs/cifs/cifsfs.c                              |    2 -
 fs/coda/inode.c                               |    6 ++--
 fs/dcache.c                                   |    5 ++-
 fs/ecryptfs/main.c                            |    6 ++--
 fs/efs/super.c                                |    6 ++--
 fs/exofs/super.c                              |    4 +-
 fs/ext2/super.c                               |    2 -
 fs/ext4/super.c                               |    2 -
 fs/f2fs/super.c                               |    5 ++-
 fs/fat/inode.c                                |    2 -
 fs/file.c                                     |    7 ++---
 fs/fuse/inode.c                               |    4 +-
 fs/gfs2/main.c                                |    3 +-
 fs/hfs/super.c                                |    4 +-
 fs/hfsplus/super.c                            |    2 -
 fs/hostfs/hostfs_kern.c                       |    2 -
 fs/hpfs/super.c                               |    2 -
 fs/hugetlbfs/inode.c                          |    2 -
 fs/inode.c                                    |    2 -
 fs/isofs/inode.c                              |    2 -
 fs/jffs2/super.c                              |    2 -
 fs/jfs/super.c                                |    2 -
 fs/logfs/inode.c                              |    3 +-
 fs/minix/inode.c                              |    2 -
 fs/ncpfs/inode.c                              |    2 -
 fs/nfs/inode.c                                |    2 -
 fs/nilfs2/super.c                             |    3 +-
 fs/ntfs/super.c                               |    4 +-
 fs/ocfs2/dlmfs/dlmfs.c                        |    2 -
 fs/ocfs2/super.c                              |    2 -
 fs/openpromfs/inode.c                         |    2 -
 fs/proc/inode.c                               |    3 +-
 fs/qnx4/inode.c                               |    2 -
 fs/qnx6/inode.c                               |    2 -
 fs/reiserfs/super.c                           |    3 +-
 fs/romfs/super.c                              |    4 +-
 fs/squashfs/super.c                           |    3 +-
 fs/sysv/inode.c                               |    2 -
 fs/ubifs/super.c                              |    4 +-
 fs/udf/super.c                                |    3 +-
 fs/ufs/super.c                                |    2 -
 fs/xfs/kmem.h                                 |    1 
 fs/xfs/xfs_super.c                            |    4 +-
 include/linux/thread_info.h                   |    5 ++-
 ipc/mqueue.c                                  |    2 -
 kernel/cred.c                                 |    4 +-
 kernel/delayacct.c                            |    2 -
 kernel/fork.c                                 |   22 +++++++++-------
 kernel/pid.c                                  |    2 -
 mm/nommu.c                                    |    2 -
 mm/rmap.c                                     |    6 ++--
 mm/shmem.c                                    |    2 -
 net/socket.c                                  |    2 -
 net/sunrpc/rpc_pipe.c                         |    2 -
 65 files changed, 114 insertions(+), 92 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/inode.c~account-certain-kmem-allocations-to-memcg arch/powerpc/platforms/cell/spufs/inode.c
--- a/arch/powerpc/platforms/cell/spufs/inode.c~account-certain-kmem-allocations-to-memcg
+++ a/arch/powerpc/platforms/cell/spufs/inode.c
@@ -767,7 +767,7 @@ static int __init spufs_init(void)
 	ret = -ENOMEM;
 	spufs_inode_cache = kmem_cache_create("spufs_inode_cache",
 			sizeof(struct spufs_inode_info), 0,
-			SLAB_HWCACHE_ALIGN, spufs_init_once);
+			SLAB_HWCACHE_ALIGN|SLAB_ACCOUNT, spufs_init_once);
 
 	if (!spufs_inode_cache)
 		goto out;
diff -puN drivers/staging/lustre/lustre/llite/super25.c~account-certain-kmem-allocations-to-memcg drivers/staging/lustre/lustre/llite/super25.c
--- a/drivers/staging/lustre/lustre/llite/super25.c~account-certain-kmem-allocations-to-memcg
+++ a/drivers/staging/lustre/lustre/llite/super25.c
@@ -106,7 +106,8 @@ static int __init init_lustre_lite(void)
 	rc = -ENOMEM;
 	ll_inode_cachep = kmem_cache_create("lustre_inode_cache",
 					    sizeof(struct ll_inode_info),
-					    0, SLAB_HWCACHE_ALIGN, NULL);
+					    0, SLAB_HWCACHE_ALIGN|SLAB_ACCOUNT,
+					    NULL);
 	if (ll_inode_cachep == NULL)
 		goto out_cache;
 
diff -puN fs/9p/v9fs.c~account-certain-kmem-allocations-to-memcg fs/9p/v9fs.c
--- a/fs/9p/v9fs.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/9p/v9fs.c
@@ -575,7 +575,7 @@ static int v9fs_init_inode_cache(void)
 	v9fs_inode_cache = kmem_cache_create("v9fs_inode_cache",
 					  sizeof(struct v9fs_inode),
 					  0, (SLAB_RECLAIM_ACCOUNT|
-					      SLAB_MEM_SPREAD),
+					      SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 					  v9fs_inode_init_once);
 	if (!v9fs_inode_cache)
 		return -ENOMEM;
diff -puN fs/adfs/super.c~account-certain-kmem-allocations-to-memcg fs/adfs/super.c
--- a/fs/adfs/super.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/adfs/super.c
@@ -271,7 +271,7 @@ static int __init init_inodecache(void)
 	adfs_inode_cachep = kmem_cache_create("adfs_inode_cache",
 					     sizeof(struct adfs_inode_info),
 					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 					     init_once);
 	if (adfs_inode_cachep == NULL)
 		return -ENOMEM;
diff -puN fs/affs/super.c~account-certain-kmem-allocations-to-memcg fs/affs/super.c
--- a/fs/affs/super.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/affs/super.c
@@ -132,7 +132,7 @@ static int __init init_inodecache(void)
 	affs_inode_cachep = kmem_cache_create("affs_inode_cache",
 					     sizeof(struct affs_inode_info),
 					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 					     init_once);
 	if (affs_inode_cachep == NULL)
 		return -ENOMEM;
diff -puN fs/afs/super.c~account-certain-kmem-allocations-to-memcg fs/afs/super.c
--- a/fs/afs/super.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/afs/super.c
@@ -91,7 +91,7 @@ int __init afs_fs_init(void)
 	afs_inode_cachep = kmem_cache_create("afs_inode_cache",
 					     sizeof(struct afs_vnode),
 					     0,
-					     SLAB_HWCACHE_ALIGN,
+					     SLAB_HWCACHE_ALIGN|SLAB_ACCOUNT,
 					     afs_i_init_once);
 	if (!afs_inode_cachep) {
 		printk(KERN_NOTICE "kAFS: Failed to allocate inode cache\n");
diff -puN fs/befs/linuxvfs.c~account-certain-kmem-allocations-to-memcg fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/befs/linuxvfs.c
@@ -434,7 +434,7 @@ befs_init_inodecache(void)
 	befs_inode_cachep = kmem_cache_create("befs_inode_cache",
 					      sizeof (struct befs_inode_info),
 					      0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 					      init_once);
 	if (befs_inode_cachep == NULL) {
 		pr_err("%s: Couldn't initialize inode slabcache\n", __func__);
diff -puN fs/bfs/inode.c~account-certain-kmem-allocations-to-memcg fs/bfs/inode.c
--- a/fs/bfs/inode.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/bfs/inode.c
@@ -270,7 +270,7 @@ static int __init init_inodecache(void)
 	bfs_inode_cachep = kmem_cache_create("bfs_inode_cache",
 					     sizeof(struct bfs_inode_info),
 					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 					     init_once);
 	if (bfs_inode_cachep == NULL)
 		return -ENOMEM;
diff -puN fs/block_dev.c~account-certain-kmem-allocations-to-memcg fs/block_dev.c
--- a/fs/block_dev.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/block_dev.c
@@ -567,7 +567,7 @@ void __init bdev_cache_init(void)
 
 	bdev_cachep = kmem_cache_create("bdev_cache", sizeof(struct bdev_inode),
 			0, (SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
-				SLAB_MEM_SPREAD|SLAB_PANIC),
+				SLAB_MEM_SPREAD|SLAB_ACCOUNT|SLAB_PANIC),
 			init_once);
 	err = register_filesystem(&bd_type);
 	if (err)
diff -puN fs/btrfs/inode.c~account-certain-kmem-allocations-to-memcg fs/btrfs/inode.c
--- a/fs/btrfs/inode.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/btrfs/inode.c
@@ -9154,7 +9154,8 @@ int btrfs_init_cachep(void)
 {
 	btrfs_inode_cachep = kmem_cache_create("btrfs_inode",
 			sizeof(struct btrfs_inode), 0,
-			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, init_once);
+			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD | SLAB_ACCOUNT,
+			init_once);
 	if (!btrfs_inode_cachep)
 		goto fail;
 
diff -puN fs/ceph/super.c~account-certain-kmem-allocations-to-memcg fs/ceph/super.c
--- a/fs/ceph/super.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/ceph/super.c
@@ -639,8 +639,8 @@ static int __init init_caches(void)
 	ceph_inode_cachep = kmem_cache_create("ceph_inode_info",
 				      sizeof(struct ceph_inode_info),
 				      __alignof__(struct ceph_inode_info),
-				      (SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD),
-				      ceph_inode_init_once);
+				      SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD|
+				      SLAB_ACCOUNT, ceph_inode_init_once);
 	if (ceph_inode_cachep == NULL)
 		return -ENOMEM;
 
diff -puN fs/cifs/cifsfs.c~account-certain-kmem-allocations-to-memcg fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/cifs/cifsfs.c
@@ -1040,7 +1040,7 @@ cifs_init_inodecache(void)
 	cifs_inode_cachep = kmem_cache_create("cifs_inode_cache",
 					      sizeof(struct cifsInodeInfo),
 					      0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 					      cifs_init_once);
 	if (cifs_inode_cachep == NULL)
 		return -ENOMEM;
diff -puN fs/coda/inode.c~account-certain-kmem-allocations-to-memcg fs/coda/inode.c
--- a/fs/coda/inode.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/coda/inode.c
@@ -74,9 +74,9 @@ static void init_once(void *foo)
 int __init coda_init_inodecache(void)
 {
 	coda_inode_cachep = kmem_cache_create("coda_inode_cache",
-				sizeof(struct coda_inode_info),
-				0, SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD,
-				init_once);
+				sizeof(struct coda_inode_info), 0,
+				SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD|
+				SLAB_ACCOUNT, init_once);
 	if (coda_inode_cachep == NULL)
 		return -ENOMEM;
 	return 0;
diff -puN fs/dcache.c~account-certain-kmem-allocations-to-memcg fs/dcache.c
--- a/fs/dcache.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/dcache.c
@@ -1571,7 +1571,8 @@ struct dentry *__d_alloc(struct super_bl
 	dentry->d_iname[DNAME_INLINE_LEN-1] = 0;
 	if (name->len > DNAME_INLINE_LEN-1) {
 		size_t size = offsetof(struct external_name, name[1]);
-		struct external_name *p = kmalloc(size + name->len, GFP_KERNEL);
+		struct external_name *p = kmalloc(size + name->len,
+						  GFP_KERNEL_ACCOUNT);
 		if (!p) {
 			kmem_cache_free(dentry_cache, dentry); 
 			return NULL;
@@ -3415,7 +3416,7 @@ static void __init dcache_init(void)
 	 * of the dcache. 
 	 */
 	dentry_cache = KMEM_CACHE(dentry,
-		SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD);
+		SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD|SLAB_ACCOUNT);
 
 	/* Hash may have been set up in dcache_init_early */
 	if (!hashdist)
diff -puN fs/ecryptfs/main.c~account-certain-kmem-allocations-to-memcg fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/ecryptfs/main.c
@@ -663,6 +663,7 @@ static struct ecryptfs_cache_info {
 	struct kmem_cache **cache;
 	const char *name;
 	size_t size;
+	unsigned long flags;
 	void (*ctor)(void *obj);
 } ecryptfs_cache_infos[] = {
 	{
@@ -684,6 +685,7 @@ static struct ecryptfs_cache_info {
 		.cache = &ecryptfs_inode_info_cache,
 		.name = "ecryptfs_inode_cache",
 		.size = sizeof(struct ecryptfs_inode_info),
+		.flags = SLAB_ACCOUNT,
 		.ctor = inode_info_init_once,
 	},
 	{
@@ -755,8 +757,8 @@ static int ecryptfs_init_kmem_caches(voi
 		struct ecryptfs_cache_info *info;
 
 		info = &ecryptfs_cache_infos[i];
-		*(info->cache) = kmem_cache_create(info->name, info->size,
-				0, SLAB_HWCACHE_ALIGN, info->ctor);
+		*(info->cache) = kmem_cache_create(info->name, info->size, 0,
+				SLAB_HWCACHE_ALIGN | info->flags, info->ctor);
 		if (!*(info->cache)) {
 			ecryptfs_free_kmem_caches();
 			ecryptfs_printk(KERN_WARNING, "%s: "
diff -puN fs/efs/super.c~account-certain-kmem-allocations-to-memcg fs/efs/super.c
--- a/fs/efs/super.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/efs/super.c
@@ -94,9 +94,9 @@ static void init_once(void *foo)
 static int __init init_inodecache(void)
 {
 	efs_inode_cachep = kmem_cache_create("efs_inode_cache",
-				sizeof(struct efs_inode_info),
-				0, SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD,
-				init_once);
+				sizeof(struct efs_inode_info), 0,
+				SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD|
+				SLAB_ACCOUNT, init_once);
 	if (efs_inode_cachep == NULL)
 		return -ENOMEM;
 	return 0;
diff -puN fs/exofs/super.c~account-certain-kmem-allocations-to-memcg fs/exofs/super.c
--- a/fs/exofs/super.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/exofs/super.c
@@ -194,8 +194,8 @@ static int init_inodecache(void)
 {
 	exofs_inode_cachep = kmem_cache_create("exofs_inode_cache",
 				sizeof(struct exofs_i_info), 0,
-				SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
-				exofs_init_once);
+				SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD |
+				SLAB_ACCOUNT, exofs_init_once);
 	if (exofs_inode_cachep == NULL)
 		return -ENOMEM;
 	return 0;
diff -puN fs/ext2/super.c~account-certain-kmem-allocations-to-memcg fs/ext2/super.c
--- a/fs/ext2/super.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/ext2/super.c
@@ -203,7 +203,7 @@ static int __init init_inodecache(void)
 	ext2_inode_cachep = kmem_cache_create("ext2_inode_cache",
 					     sizeof(struct ext2_inode_info),
 					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 					     init_once);
 	if (ext2_inode_cachep == NULL)
 		return -ENOMEM;
diff -puN fs/ext4/super.c~account-certain-kmem-allocations-to-memcg fs/ext4/super.c
--- a/fs/ext4/super.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/ext4/super.c
@@ -966,7 +966,7 @@ static int __init init_inodecache(void)
 	ext4_inode_cachep = kmem_cache_create("ext4_inode_cache",
 					     sizeof(struct ext4_inode_info),
 					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 					     init_once);
 	if (ext4_inode_cachep == NULL)
 		return -ENOMEM;
diff -puN fs/f2fs/super.c~account-certain-kmem-allocations-to-memcg fs/f2fs/super.c
--- a/fs/f2fs/super.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/f2fs/super.c
@@ -1424,8 +1424,9 @@ MODULE_ALIAS_FS("f2fs");
 
 static int __init init_inodecache(void)
 {
-	f2fs_inode_cachep = f2fs_kmem_cache_create("f2fs_inode_cache",
-			sizeof(struct f2fs_inode_info));
+	f2fs_inode_cachep = kmem_cache_create("f2fs_inode_cache",
+			sizeof(struct f2fs_inode_info), 0,
+			SLAB_RECLAIM_ACCOUNT|SLAB_ACCOUNT, NULL);
 	if (!f2fs_inode_cachep)
 		return -ENOMEM;
 	return 0;
diff -puN fs/fat/inode.c~account-certain-kmem-allocations-to-memcg fs/fat/inode.c
--- a/fs/fat/inode.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/fat/inode.c
@@ -677,7 +677,7 @@ static int __init fat_init_inodecache(vo
 	fat_inode_cachep = kmem_cache_create("fat_inode_cache",
 					     sizeof(struct msdos_inode_info),
 					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 					     init_once);
 	if (fat_inode_cachep == NULL)
 		return -ENOMEM;
diff -puN fs/file.c~account-certain-kmem-allocations-to-memcg fs/file.c
--- a/fs/file.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/file.c
@@ -37,11 +37,12 @@ static void *alloc_fdmem(size_t size)
 	 * vmalloc() if the allocation size will be considered "large" by the VM.
 	 */
 	if (size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)) {
-		void *data = kmalloc(size, GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY);
+		void *data = kmalloc(size, GFP_KERNEL_ACCOUNT |
+				     __GFP_NOWARN | __GFP_NORETRY);
 		if (data != NULL)
 			return data;
 	}
-	return vmalloc(size);
+	return __vmalloc(size, GFP_KERNEL_ACCOUNT | __GFP_HIGHMEM, PAGE_KERNEL);
 }
 
 static void __free_fdtable(struct fdtable *fdt)
@@ -126,7 +127,7 @@ static struct fdtable * alloc_fdtable(un
 	if (unlikely(nr > sysctl_nr_open))
 		nr = ((sysctl_nr_open - 1) | (BITS_PER_LONG - 1)) + 1;
 
-	fdt = kmalloc(sizeof(struct fdtable), GFP_KERNEL);
+	fdt = kmalloc(sizeof(struct fdtable), GFP_KERNEL_ACCOUNT);
 	if (!fdt)
 		goto out;
 	fdt->max_fds = nr;
diff -puN fs/fuse/inode.c~account-certain-kmem-allocations-to-memcg fs/fuse/inode.c
--- a/fs/fuse/inode.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/fuse/inode.c
@@ -1255,8 +1255,8 @@ static int __init fuse_fs_init(void)
 	int err;
 
 	fuse_inode_cachep = kmem_cache_create("fuse_inode",
-					      sizeof(struct fuse_inode),
-					      0, SLAB_HWCACHE_ALIGN,
+					      sizeof(struct fuse_inode), 0,
+					      SLAB_HWCACHE_ALIGN|SLAB_ACCOUNT,
 					      fuse_inode_init_once);
 	err = -ENOMEM;
 	if (!fuse_inode_cachep)
diff -puN fs/gfs2/main.c~account-certain-kmem-allocations-to-memcg fs/gfs2/main.c
--- a/fs/gfs2/main.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/gfs2/main.c
@@ -112,7 +112,8 @@ static int __init init_gfs2_fs(void)
 	gfs2_inode_cachep = kmem_cache_create("gfs2_inode",
 					      sizeof(struct gfs2_inode),
 					      0,  SLAB_RECLAIM_ACCOUNT|
-					          SLAB_MEM_SPREAD,
+					          SLAB_MEM_SPREAD|
+						  SLAB_ACCOUNT,
 					      gfs2_init_inode_once);
 	if (!gfs2_inode_cachep)
 		goto fail;
diff -puN fs/hfs/super.c~account-certain-kmem-allocations-to-memcg fs/hfs/super.c
--- a/fs/hfs/super.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/hfs/super.c
@@ -483,8 +483,8 @@ static int __init init_hfs_fs(void)
 	int err;
 
 	hfs_inode_cachep = kmem_cache_create("hfs_inode_cache",
-		sizeof(struct hfs_inode_info), 0, SLAB_HWCACHE_ALIGN,
-		hfs_init_once);
+		sizeof(struct hfs_inode_info), 0,
+		SLAB_HWCACHE_ALIGN|SLAB_ACCOUNT, hfs_init_once);
 	if (!hfs_inode_cachep)
 		return -ENOMEM;
 	err = register_filesystem(&hfs_fs_type);
diff -puN fs/hfsplus/super.c~account-certain-kmem-allocations-to-memcg fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/hfsplus/super.c
@@ -663,7 +663,7 @@ static int __init init_hfsplus_fs(void)
 	int err;
 
 	hfsplus_inode_cachep = kmem_cache_create("hfsplus_icache",
-		HFSPLUS_INODE_SIZE, 0, SLAB_HWCACHE_ALIGN,
+		HFSPLUS_INODE_SIZE, 0, SLAB_HWCACHE_ALIGN|SLAB_ACCOUNT,
 		hfsplus_init_once);
 	if (!hfsplus_inode_cachep)
 		return -ENOMEM;
diff -puN fs/hostfs/hostfs_kern.c~account-certain-kmem-allocations-to-memcg fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/hostfs/hostfs_kern.c
@@ -223,7 +223,7 @@ static struct inode *hostfs_alloc_inode(
 {
 	struct hostfs_inode_info *hi;
 
-	hi = kmalloc(sizeof(*hi), GFP_KERNEL);
+	hi = kmalloc(sizeof(*hi), GFP_KERNEL_ACCOUNT);
 	if (hi == NULL)
 		return NULL;
 	hi->fd = -1;
diff -puN fs/hpfs/super.c~account-certain-kmem-allocations-to-memcg fs/hpfs/super.c
--- a/fs/hpfs/super.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/hpfs/super.c
@@ -261,7 +261,7 @@ static int init_inodecache(void)
 	hpfs_inode_cachep = kmem_cache_create("hpfs_inode_cache",
 					     sizeof(struct hpfs_inode_info),
 					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 					     init_once);
 	if (hpfs_inode_cachep == NULL)
 		return -ENOMEM;
diff -puN fs/hugetlbfs/inode.c~account-certain-kmem-allocations-to-memcg fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/hugetlbfs/inode.c
@@ -1322,7 +1322,7 @@ static int __init init_hugetlbfs_fs(void
 	error = -ENOMEM;
 	hugetlbfs_inode_cachep = kmem_cache_create("hugetlbfs_inode_cache",
 					sizeof(struct hugetlbfs_inode_info),
-					0, 0, init_once);
+					0, SLAB_ACCOUNT, init_once);
 	if (hugetlbfs_inode_cachep == NULL)
 		goto out2;
 
diff -puN fs/inode.c~account-certain-kmem-allocations-to-memcg fs/inode.c
--- a/fs/inode.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/inode.c
@@ -1883,7 +1883,7 @@ void __init inode_init(void)
 					 sizeof(struct inode),
 					 0,
 					 (SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|
-					 SLAB_MEM_SPREAD),
+					 SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 					 init_once);
 
 	/* Hash may have been set up in inode_init_early */
diff -puN fs/isofs/inode.c~account-certain-kmem-allocations-to-memcg fs/isofs/inode.c
--- a/fs/isofs/inode.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/isofs/inode.c
@@ -94,7 +94,7 @@ static int __init init_inodecache(void)
 	isofs_inode_cachep = kmem_cache_create("isofs_inode_cache",
 					sizeof(struct iso_inode_info),
 					0, (SLAB_RECLAIM_ACCOUNT|
-					SLAB_MEM_SPREAD),
+					SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 					init_once);
 	if (isofs_inode_cachep == NULL)
 		return -ENOMEM;
diff -puN fs/jffs2/super.c~account-certain-kmem-allocations-to-memcg fs/jffs2/super.c
--- a/fs/jffs2/super.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/jffs2/super.c
@@ -387,7 +387,7 @@ static int __init init_jffs2_fs(void)
 	jffs2_inode_cachep = kmem_cache_create("jffs2_i",
 					     sizeof(struct jffs2_inode_info),
 					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 					     jffs2_i_init_once);
 	if (!jffs2_inode_cachep) {
 		pr_err("error: Failed to initialise inode cache\n");
diff -puN fs/jfs/super.c~account-certain-kmem-allocations-to-memcg fs/jfs/super.c
--- a/fs/jfs/super.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/jfs/super.c
@@ -898,7 +898,7 @@ static int __init init_jfs_fs(void)
 
 	jfs_inode_cachep =
 	    kmem_cache_create("jfs_ip", sizeof(struct jfs_inode_info), 0,
-			    SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD,
+			    SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD|SLAB_ACCOUNT,
 			    init_once);
 	if (jfs_inode_cachep == NULL)
 		return -ENOMEM;
diff -puN fs/logfs/inode.c~account-certain-kmem-allocations-to-memcg fs/logfs/inode.c
--- a/fs/logfs/inode.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/logfs/inode.c
@@ -408,7 +408,8 @@ const struct super_operations logfs_supe
 int logfs_init_inode_cache(void)
 {
 	logfs_inode_cache = kmem_cache_create("logfs_inode_cache",
-			sizeof(struct logfs_inode), 0, SLAB_RECLAIM_ACCOUNT,
+			sizeof(struct logfs_inode), 0,
+			SLAB_RECLAIM_ACCOUNT|SLAB_ACCOUNT,
 			logfs_init_once);
 	if (!logfs_inode_cache)
 		return -ENOMEM;
diff -puN fs/minix/inode.c~account-certain-kmem-allocations-to-memcg fs/minix/inode.c
--- a/fs/minix/inode.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/minix/inode.c
@@ -91,7 +91,7 @@ static int __init init_inodecache(void)
 	minix_inode_cachep = kmem_cache_create("minix_inode_cache",
 					     sizeof(struct minix_inode_info),
 					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 					     init_once);
 	if (minix_inode_cachep == NULL)
 		return -ENOMEM;
diff -puN fs/ncpfs/inode.c~account-certain-kmem-allocations-to-memcg fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/ncpfs/inode.c
@@ -82,7 +82,7 @@ static int init_inodecache(void)
 	ncp_inode_cachep = kmem_cache_create("ncp_inode_cache",
 					     sizeof(struct ncp_inode_info),
 					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 					     init_once);
 	if (ncp_inode_cachep == NULL)
 		return -ENOMEM;
diff -puN fs/nfs/inode.c~account-certain-kmem-allocations-to-memcg fs/nfs/inode.c
--- a/fs/nfs/inode.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/nfs/inode.c
@@ -1904,7 +1904,7 @@ static int __init nfs_init_inodecache(vo
 	nfs_inode_cachep = kmem_cache_create("nfs_inode_cache",
 					     sizeof(struct nfs_inode),
 					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 					     init_once);
 	if (nfs_inode_cachep == NULL)
 		return -ENOMEM;
diff -puN fs/nilfs2/super.c~account-certain-kmem-allocations-to-memcg fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/nilfs2/super.c
@@ -1418,7 +1418,8 @@ static int __init nilfs_init_cachep(void
 {
 	nilfs_inode_cachep = kmem_cache_create("nilfs2_inode_cache",
 			sizeof(struct nilfs_inode_info), 0,
-			SLAB_RECLAIM_ACCOUNT, nilfs_inode_init_once);
+			SLAB_RECLAIM_ACCOUNT|SLAB_ACCOUNT,
+			nilfs_inode_init_once);
 	if (!nilfs_inode_cachep)
 		goto fail;
 
diff -puN fs/ntfs/super.c~account-certain-kmem-allocations-to-memcg fs/ntfs/super.c
--- a/fs/ntfs/super.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/ntfs/super.c
@@ -3139,8 +3139,8 @@ static int __init init_ntfs_fs(void)
 
 	ntfs_big_inode_cache = kmem_cache_create(ntfs_big_inode_cache_name,
 			sizeof(big_ntfs_inode), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD,
-			ntfs_big_inode_init_once);
+			SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD|
+			SLAB_ACCOUNT, ntfs_big_inode_init_once);
 	if (!ntfs_big_inode_cache) {
 		pr_crit("Failed to create %s!\n", ntfs_big_inode_cache_name);
 		goto big_inode_err_out;
diff -puN fs/ocfs2/dlmfs/dlmfs.c~account-certain-kmem-allocations-to-memcg fs/ocfs2/dlmfs/dlmfs.c
--- a/fs/ocfs2/dlmfs/dlmfs.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/ocfs2/dlmfs/dlmfs.c
@@ -638,7 +638,7 @@ static int __init init_dlmfs_fs(void)
 	dlmfs_inode_cache = kmem_cache_create("dlmfs_inode_cache",
 				sizeof(struct dlmfs_inode_private),
 				0, (SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
-					SLAB_MEM_SPREAD),
+					SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 				dlmfs_init_once);
 	if (!dlmfs_inode_cache) {
 		status = -ENOMEM;
diff -puN fs/ocfs2/super.c~account-certain-kmem-allocations-to-memcg fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/ocfs2/super.c
@@ -1753,7 +1753,7 @@ static int ocfs2_initialize_mem_caches(v
 				       sizeof(struct ocfs2_inode_info),
 				       0,
 				       (SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 				       ocfs2_inode_init_once);
 	ocfs2_dquot_cachep = kmem_cache_create("ocfs2_dquot_cache",
 					sizeof(struct ocfs2_dquot),
diff -puN fs/openpromfs/inode.c~account-certain-kmem-allocations-to-memcg fs/openpromfs/inode.c
--- a/fs/openpromfs/inode.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/openpromfs/inode.c
@@ -443,7 +443,7 @@ static int __init init_openprom_fs(void)
 					    sizeof(struct op_inode_info),
 					    0,
 					    (SLAB_RECLAIM_ACCOUNT |
-					     SLAB_MEM_SPREAD),
+					     SLAB_MEM_SPREAD | SLAB_ACCOUNT),
 					    op_inode_init_once);
 	if (!op_inode_cachep)
 		return -ENOMEM;
diff -puN fs/proc/inode.c~account-certain-kmem-allocations-to-memcg fs/proc/inode.c
--- a/fs/proc/inode.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/proc/inode.c
@@ -95,7 +95,8 @@ void __init proc_init_inodecache(void)
 	proc_inode_cachep = kmem_cache_create("proc_inode_cache",
 					     sizeof(struct proc_inode),
 					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD|SLAB_PANIC),
+						SLAB_MEM_SPREAD|SLAB_ACCOUNT|
+						SLAB_PANIC),
 					     init_once);
 }
 
diff -puN fs/qnx4/inode.c~account-certain-kmem-allocations-to-memcg fs/qnx4/inode.c
--- a/fs/qnx4/inode.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/qnx4/inode.c
@@ -364,7 +364,7 @@ static int init_inodecache(void)
 	qnx4_inode_cachep = kmem_cache_create("qnx4_inode_cache",
 					     sizeof(struct qnx4_inode_info),
 					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 					     init_once);
 	if (qnx4_inode_cachep == NULL)
 		return -ENOMEM;
diff -puN fs/qnx6/inode.c~account-certain-kmem-allocations-to-memcg fs/qnx6/inode.c
--- a/fs/qnx6/inode.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/qnx6/inode.c
@@ -624,7 +624,7 @@ static int init_inodecache(void)
 	qnx6_inode_cachep = kmem_cache_create("qnx6_inode_cache",
 					     sizeof(struct qnx6_inode_info),
 					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 					     init_once);
 	if (!qnx6_inode_cachep)
 		return -ENOMEM;
diff -puN fs/reiserfs/super.c~account-certain-kmem-allocations-to-memcg fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/reiserfs/super.c
@@ -626,7 +626,8 @@ static int __init init_inodecache(void)
 						  sizeof(struct
 							 reiserfs_inode_info),
 						  0, (SLAB_RECLAIM_ACCOUNT|
-							SLAB_MEM_SPREAD),
+						      SLAB_MEM_SPREAD|
+						      SLAB_ACCOUNT),
 						  init_once);
 	if (reiserfs_inode_cachep == NULL)
 		return -ENOMEM;
diff -puN fs/romfs/super.c~account-certain-kmem-allocations-to-memcg fs/romfs/super.c
--- a/fs/romfs/super.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/romfs/super.c
@@ -618,8 +618,8 @@ static int __init init_romfs_fs(void)
 	romfs_inode_cachep =
 		kmem_cache_create("romfs_i",
 				  sizeof(struct romfs_inode_info), 0,
-				  SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
-				  romfs_i_init_once);
+				  SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD |
+				  SLAB_ACCOUNT, romfs_i_init_once);
 
 	if (!romfs_inode_cachep) {
 		pr_err("Failed to initialise inode cache\n");
diff -puN fs/squashfs/super.c~account-certain-kmem-allocations-to-memcg fs/squashfs/super.c
--- a/fs/squashfs/super.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/squashfs/super.c
@@ -420,7 +420,8 @@ static int __init init_inodecache(void)
 {
 	squashfs_inode_cachep = kmem_cache_create("squashfs_inode_cache",
 		sizeof(struct squashfs_inode_info), 0,
-		SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT, init_once);
+		SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|SLAB_ACCOUNT,
+		init_once);
 
 	return squashfs_inode_cachep ? 0 : -ENOMEM;
 }
diff -puN fs/sysv/inode.c~account-certain-kmem-allocations-to-memcg fs/sysv/inode.c
--- a/fs/sysv/inode.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/sysv/inode.c
@@ -353,7 +353,7 @@ int __init sysv_init_icache(void)
 {
 	sysv_inode_cachep = kmem_cache_create("sysv_inode_cache",
 			sizeof(struct sysv_inode_info), 0,
-			SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD,
+			SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD|SLAB_ACCOUNT,
 			init_once);
 	if (!sysv_inode_cachep)
 		return -ENOMEM;
diff -puN fs/ubifs/super.c~account-certain-kmem-allocations-to-memcg fs/ubifs/super.c
--- a/fs/ubifs/super.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/ubifs/super.c
@@ -2249,8 +2249,8 @@ static int __init ubifs_init(void)
 
 	ubifs_inode_slab = kmem_cache_create("ubifs_inode_slab",
 				sizeof(struct ubifs_inode), 0,
-				SLAB_MEM_SPREAD | SLAB_RECLAIM_ACCOUNT,
-				&inode_slab_ctor);
+				SLAB_MEM_SPREAD | SLAB_RECLAIM_ACCOUNT |
+				SLAB_ACCOUNT, &inode_slab_ctor);
 	if (!ubifs_inode_slab)
 		return -ENOMEM;
 
diff -puN fs/udf/super.c~account-certain-kmem-allocations-to-memcg fs/udf/super.c
--- a/fs/udf/super.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/udf/super.c
@@ -179,7 +179,8 @@ static int __init init_inodecache(void)
 	udf_inode_cachep = kmem_cache_create("udf_inode_cache",
 					     sizeof(struct udf_inode_info),
 					     0, (SLAB_RECLAIM_ACCOUNT |
-						 SLAB_MEM_SPREAD),
+						 SLAB_MEM_SPREAD |
+						 SLAB_ACCOUNT),
 					     init_once);
 	if (!udf_inode_cachep)
 		return -ENOMEM;
diff -puN fs/ufs/super.c~account-certain-kmem-allocations-to-memcg fs/ufs/super.c
--- a/fs/ufs/super.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/ufs/super.c
@@ -1427,7 +1427,7 @@ static int __init init_inodecache(void)
 	ufs_inode_cachep = kmem_cache_create("ufs_inode_cache",
 					     sizeof(struct ufs_inode_info),
 					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 					     init_once);
 	if (ufs_inode_cachep == NULL)
 		return -ENOMEM;
diff -puN fs/xfs/kmem.h~account-certain-kmem-allocations-to-memcg fs/xfs/kmem.h
--- a/fs/xfs/kmem.h~account-certain-kmem-allocations-to-memcg
+++ a/fs/xfs/kmem.h
@@ -84,6 +84,7 @@ kmem_zalloc(size_t size, xfs_km_flags_t
 #define KM_ZONE_HWALIGN	SLAB_HWCACHE_ALIGN
 #define KM_ZONE_RECLAIM	SLAB_RECLAIM_ACCOUNT
 #define KM_ZONE_SPREAD	SLAB_MEM_SPREAD
+#define KM_ZONE_ACCOUNT	SLAB_ACCOUNT
 
 #define kmem_zone	kmem_cache
 #define kmem_zone_t	struct kmem_cache
diff -puN fs/xfs/xfs_super.c~account-certain-kmem-allocations-to-memcg fs/xfs/xfs_super.c
--- a/fs/xfs/xfs_super.c~account-certain-kmem-allocations-to-memcg
+++ a/fs/xfs/xfs_super.c
@@ -1703,8 +1703,8 @@ xfs_init_zones(void)
 
 	xfs_inode_zone =
 		kmem_zone_init_flags(sizeof(xfs_inode_t), "xfs_inode",
-			KM_ZONE_HWALIGN | KM_ZONE_RECLAIM | KM_ZONE_SPREAD,
-			xfs_fs_inode_init_once);
+			KM_ZONE_HWALIGN | KM_ZONE_RECLAIM | KM_ZONE_SPREAD |
+			KM_ZONE_ACCOUNT, xfs_fs_inode_init_once);
 	if (!xfs_inode_zone)
 		goto out_destroy_efi_zone;
 
diff -puN include/linux/thread_info.h~account-certain-kmem-allocations-to-memcg include/linux/thread_info.h
--- a/include/linux/thread_info.h~account-certain-kmem-allocations-to-memcg
+++ a/include/linux/thread_info.h
@@ -56,9 +56,10 @@ extern long do_no_restart_syscall(struct
 #ifdef __KERNEL__
 
 #ifdef CONFIG_DEBUG_STACK_USAGE
-# define THREADINFO_GFP		(GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO)
+# define THREADINFO_GFP		(GFP_KERNEL_ACCOUNT | __GFP_NOTRACK | \
+				 __GFP_ZERO)
 #else
-# define THREADINFO_GFP		(GFP_KERNEL | __GFP_NOTRACK)
+# define THREADINFO_GFP		(GFP_KERNEL_ACCOUNT | __GFP_NOTRACK)
 #endif
 
 /*
diff -puN ipc/mqueue.c~account-certain-kmem-allocations-to-memcg ipc/mqueue.c
--- a/ipc/mqueue.c~account-certain-kmem-allocations-to-memcg
+++ a/ipc/mqueue.c
@@ -1438,7 +1438,7 @@ static int __init init_mqueue_fs(void)
 
 	mqueue_inode_cachep = kmem_cache_create("mqueue_inode_cache",
 				sizeof(struct mqueue_inode_info), 0,
-				SLAB_HWCACHE_ALIGN, init_once);
+				SLAB_HWCACHE_ALIGN|SLAB_ACCOUNT, init_once);
 	if (mqueue_inode_cachep == NULL)
 		return -ENOMEM;
 
diff -puN kernel/cred.c~account-certain-kmem-allocations-to-memcg kernel/cred.c
--- a/kernel/cred.c~account-certain-kmem-allocations-to-memcg
+++ a/kernel/cred.c
@@ -569,8 +569,8 @@ EXPORT_SYMBOL(revert_creds);
 void __init cred_init(void)
 {
 	/* allocate a slab in which we can store credentials */
-	cred_jar = kmem_cache_create("cred_jar", sizeof(struct cred),
-				     0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+	cred_jar = kmem_cache_create("cred_jar", sizeof(struct cred), 0,
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT, NULL);
 }
 
 /**
diff -puN kernel/delayacct.c~account-certain-kmem-allocations-to-memcg kernel/delayacct.c
--- a/kernel/delayacct.c~account-certain-kmem-allocations-to-memcg
+++ a/kernel/delayacct.c
@@ -34,7 +34,7 @@ __setup("nodelayacct", delayacct_setup_d
 
 void delayacct_init(void)
 {
-	delayacct_cache = KMEM_CACHE(task_delay_info, SLAB_PANIC);
+	delayacct_cache = KMEM_CACHE(task_delay_info, SLAB_PANIC|SLAB_ACCOUNT);
 	delayacct_tsk_init(&init_task);
 }
 
diff -puN kernel/fork.c~account-certain-kmem-allocations-to-memcg kernel/fork.c
--- a/kernel/fork.c~account-certain-kmem-allocations-to-memcg
+++ a/kernel/fork.c
@@ -300,9 +300,9 @@ void __init fork_init(void)
 #define ARCH_MIN_TASKALIGN	L1_CACHE_BYTES
 #endif
 	/* create a slab on which task_structs can be allocated */
-	task_struct_cachep =
-		kmem_cache_create("task_struct", arch_task_struct_size,
-			ARCH_MIN_TASKALIGN, SLAB_PANIC | SLAB_NOTRACK, NULL);
+	task_struct_cachep = kmem_cache_create("task_struct",
+			arch_task_struct_size, ARCH_MIN_TASKALIGN,
+			SLAB_PANIC|SLAB_NOTRACK|SLAB_ACCOUNT, NULL);
 #endif
 
 	/* do the arch specific task caches init */
@@ -1851,16 +1851,19 @@ void __init proc_caches_init(void)
 	sighand_cachep = kmem_cache_create("sighand_cache",
 			sizeof(struct sighand_struct), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_DESTROY_BY_RCU|
-			SLAB_NOTRACK, sighand_ctor);
+			SLAB_NOTRACK|SLAB_ACCOUNT, sighand_ctor);
 	signal_cachep = kmem_cache_create("signal_cache",
 			sizeof(struct signal_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK|SLAB_ACCOUNT,
+			NULL);
 	files_cachep = kmem_cache_create("files_cache",
 			sizeof(struct files_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK|SLAB_ACCOUNT,
+			NULL);
 	fs_cachep = kmem_cache_create("fs_cache",
 			sizeof(struct fs_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK|SLAB_ACCOUNT,
+			NULL);
 	/*
 	 * FIXME! The "sizeof(struct mm_struct)" currently includes the
 	 * whole struct cpumask for the OFFSTACK case. We could change
@@ -1870,8 +1873,9 @@ void __init proc_caches_init(void)
 	 */
 	mm_cachep = kmem_cache_create("mm_struct",
 			sizeof(struct mm_struct), ARCH_MIN_MMSTRUCT_ALIGN,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
-	vm_area_cachep = KMEM_CACHE(vm_area_struct, SLAB_PANIC);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK|SLAB_ACCOUNT,
+			NULL);
+	vm_area_cachep = KMEM_CACHE(vm_area_struct, SLAB_PANIC|SLAB_ACCOUNT);
 	mmap_init();
 	nsproxy_cache_init();
 }
diff -puN kernel/pid.c~account-certain-kmem-allocations-to-memcg kernel/pid.c
--- a/kernel/pid.c~account-certain-kmem-allocations-to-memcg
+++ a/kernel/pid.c
@@ -604,5 +604,5 @@ void __init pidmap_init(void)
 	atomic_dec(&init_pid_ns.pidmap[0].nr_free);
 
 	init_pid_ns.pid_cachep = KMEM_CACHE(pid,
-			SLAB_HWCACHE_ALIGN | SLAB_PANIC);
+			SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT);
 }
diff -puN mm/nommu.c~account-certain-kmem-allocations-to-memcg mm/nommu.c
--- a/mm/nommu.c~account-certain-kmem-allocations-to-memcg
+++ a/mm/nommu.c
@@ -560,7 +560,7 @@ void __init mmap_init(void)
 
 	ret = percpu_counter_init(&vm_committed_as, 0, GFP_KERNEL);
 	VM_BUG_ON(ret);
-	vm_region_jar = KMEM_CACHE(vm_region, SLAB_PANIC);
+	vm_region_jar = KMEM_CACHE(vm_region, SLAB_PANIC|SLAB_ACCOUNT);
 }
 
 /*
diff -puN mm/rmap.c~account-certain-kmem-allocations-to-memcg mm/rmap.c
--- a/mm/rmap.c~account-certain-kmem-allocations-to-memcg
+++ a/mm/rmap.c
@@ -428,8 +428,10 @@ static void anon_vma_ctor(void *data)
 void __init anon_vma_init(void)
 {
 	anon_vma_cachep = kmem_cache_create("anon_vma", sizeof(struct anon_vma),
-			0, SLAB_DESTROY_BY_RCU|SLAB_PANIC, anon_vma_ctor);
-	anon_vma_chain_cachep = KMEM_CACHE(anon_vma_chain, SLAB_PANIC);
+			0, SLAB_DESTROY_BY_RCU|SLAB_PANIC|SLAB_ACCOUNT,
+			anon_vma_ctor);
+	anon_vma_chain_cachep = KMEM_CACHE(anon_vma_chain,
+			SLAB_PANIC|SLAB_ACCOUNT);
 }
 
 /*
diff -puN mm/shmem.c~account-certain-kmem-allocations-to-memcg mm/shmem.c
--- a/mm/shmem.c~account-certain-kmem-allocations-to-memcg
+++ a/mm/shmem.c
@@ -3109,7 +3109,7 @@ static int shmem_init_inodecache(void)
 {
 	shmem_inode_cachep = kmem_cache_create("shmem_inode_cache",
 				sizeof(struct shmem_inode_info),
-				0, SLAB_PANIC, shmem_init_inode);
+				0, SLAB_PANIC|SLAB_ACCOUNT, shmem_init_inode);
 	return 0;
 }
 
diff -puN net/socket.c~account-certain-kmem-allocations-to-memcg net/socket.c
--- a/net/socket.c~account-certain-kmem-allocations-to-memcg
+++ a/net/socket.c
@@ -293,7 +293,7 @@ static int init_inodecache(void)
 					      0,
 					      (SLAB_HWCACHE_ALIGN |
 					       SLAB_RECLAIM_ACCOUNT |
-					       SLAB_MEM_SPREAD),
+					       SLAB_MEM_SPREAD | SLAB_ACCOUNT),
 					      init_once);
 	if (sock_inode_cachep == NULL)
 		return -ENOMEM;
diff -puN net/sunrpc/rpc_pipe.c~account-certain-kmem-allocations-to-memcg net/sunrpc/rpc_pipe.c
--- a/net/sunrpc/rpc_pipe.c~account-certain-kmem-allocations-to-memcg
+++ a/net/sunrpc/rpc_pipe.c
@@ -1500,7 +1500,7 @@ int register_rpc_pipefs(void)
 	rpc_inode_cachep = kmem_cache_create("rpc_inode_cache",
 				sizeof(struct rpc_inode),
 				0, (SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 				init_once);
 	if (!rpc_inode_cachep)
 		return -ENOMEM;
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

revert-kernfs-do-not-account-ino_ida-allocations-to-memcg.patch
revert-gfp-add-__gfp_noaccount.patch
memcg-only-account-kmem-allocations-marked-as-__gfp_account.patch
slab-add-slab_account-flag.patch
vmalloc-allow-to-account-vmalloc-to-memcg.patch
account-certain-kmem-allocations-to-memcg.patch

