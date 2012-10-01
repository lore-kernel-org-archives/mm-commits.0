From: akpm@linux-foundation.org
Subject: [merged] fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems.patch removed from -mm tree
Date: Mon, 01 Oct 2012 12:29:00 -0700
Message-ID: <20121001192900.9F536100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:57603 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2JAT3C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 15:29:02 -0400
Received: by mail-yx0-f202.google.com with SMTP id r11so688532yen.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 12:29:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: push rcu_barrier() from deactivate_locked_super() to filesystems
has been removed from the -mm tree.  Its filename was
     fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: fs: push rcu_barrier() from deactivate_locked_super() to filesystems

There's no reason to call rcu_barrier() on every
deactivate_locked_super().  We only need to make sure that all delayed rcu
free inodes are flushed before we destroy related cache.

Removing rcu_barrier() from deactivate_locked_super() affects some fast
paths.  E.g.  on my machine exit_group() of a last process in IPC
namespace takes 0.07538s.  rcu_barrier() takes 0.05188s of that time.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/v9fs.c             |    5 +++++
 fs/adfs/super.c          |    5 +++++
 fs/affs/super.c          |    5 +++++
 fs/afs/super.c           |    5 +++++
 fs/befs/linuxvfs.c       |    5 +++++
 fs/bfs/inode.c           |    5 +++++
 fs/btrfs/extent_io.c     |    6 ++++++
 fs/btrfs/inode.c         |    5 +++++
 fs/ceph/super.c          |    5 +++++
 fs/cifs/cifsfs.c         |    5 +++++
 fs/coda/inode.c          |    5 +++++
 fs/ecryptfs/main.c       |    6 ++++++
 fs/efs/super.c           |    5 +++++
 fs/exofs/super.c         |    5 +++++
 fs/ext2/super.c          |    5 +++++
 fs/ext3/super.c          |    5 +++++
 fs/ext4/super.c          |    5 +++++
 fs/fat/inode.c           |    5 +++++
 fs/freevxfs/vxfs_super.c |    5 +++++
 fs/fuse/inode.c          |    6 ++++++
 fs/hfs/super.c           |    6 ++++++
 fs/hfsplus/super.c       |    6 ++++++
 fs/hpfs/super.c          |    5 +++++
 fs/hugetlbfs/inode.c     |    5 +++++
 fs/isofs/inode.c         |    5 +++++
 fs/jffs2/super.c         |    6 ++++++
 fs/jfs/super.c           |    6 ++++++
 fs/logfs/inode.c         |    5 +++++
 fs/minix/inode.c         |    5 +++++
 fs/ncpfs/inode.c         |    5 +++++
 fs/nfs/inode.c           |    5 +++++
 fs/nilfs2/super.c        |    6 ++++++
 fs/ntfs/super.c          |    6 ++++++
 fs/ocfs2/dlmfs/dlmfs.c   |    5 +++++
 fs/ocfs2/super.c         |    5 +++++
 fs/openpromfs/inode.c    |    5 +++++
 fs/qnx4/inode.c          |    5 +++++
 fs/qnx6/inode.c          |    5 +++++
 fs/reiserfs/super.c      |    5 +++++
 fs/romfs/super.c         |    5 +++++
 fs/squashfs/super.c      |    5 +++++
 fs/super.c               |    6 ------
 fs/sysv/inode.c          |    5 +++++
 fs/ubifs/super.c         |    6 ++++++
 fs/udf/super.c           |    5 +++++
 fs/ufs/super.c           |    5 +++++
 fs/xfs/xfs_super.c       |    5 +++++
 47 files changed, 240 insertions(+), 6 deletions(-)

diff -puN fs/9p/v9fs.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/9p/v9fs.c
--- a/fs/9p/v9fs.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/9p/v9fs.c
@@ -568,6 +568,11 @@ static int v9fs_init_inode_cache(void)
  */
 static void v9fs_destroy_inode_cache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(v9fs_inode_cache);
 }
 
diff -puN fs/adfs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/adfs/super.c
--- a/fs/adfs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/adfs/super.c
@@ -280,6 +280,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(adfs_inode_cachep);
 }
 
diff -puN fs/affs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/affs/super.c
--- a/fs/affs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/affs/super.c
@@ -147,6 +147,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(affs_inode_cachep);
 }
 
diff -puN fs/afs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/afs/super.c
--- a/fs/afs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/afs/super.c
@@ -123,6 +123,11 @@ void __exit afs_fs_exit(void)
 		BUG();
 	}
 
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(afs_inode_cachep);
 	_leave("");
 }
diff -puN fs/befs/linuxvfs.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/befs/linuxvfs.c
@@ -457,6 +457,11 @@ befs_init_inodecache(void)
 static void
 befs_destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(befs_inode_cachep);
 }
 
diff -puN fs/bfs/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/bfs/inode.c
--- a/fs/bfs/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/bfs/inode.c
@@ -280,6 +280,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(bfs_inode_cachep);
 }
 
diff -puN fs/btrfs/extent_io.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/btrfs/extent_io.c
--- a/fs/btrfs/extent_io.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/btrfs/extent_io.c
@@ -107,6 +107,12 @@ void extent_io_exit(void)
 		list_del(&eb->leak_list);
 		kmem_cache_free(extent_buffer_cache, eb);
 	}
+
+	/*
+	 * Make sure all delayed rcu free are flushed before we
+	 * destroy caches.
+	 */
+	rcu_barrier();
 	if (extent_state_cache)
 		kmem_cache_destroy(extent_state_cache);
 	if (extent_buffer_cache)
diff -puN fs/btrfs/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/btrfs/inode.c
--- a/fs/btrfs/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/btrfs/inode.c
@@ -7076,6 +7076,11 @@ static void init_once(void *foo)
 
 void btrfs_destroy_cachep(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	if (btrfs_inode_cachep)
 		kmem_cache_destroy(btrfs_inode_cachep);
 	if (btrfs_trans_handle_cachep)
diff -puN fs/ceph/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/ceph/super.c
--- a/fs/ceph/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/ceph/super.c
@@ -603,6 +603,11 @@ bad_cap:
 
 static void destroy_caches(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(ceph_inode_cachep);
 	kmem_cache_destroy(ceph_cap_cachep);
 	kmem_cache_destroy(ceph_dentry_cachep);
diff -puN fs/cifs/cifsfs.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/cifs/cifsfs.c
@@ -968,6 +968,11 @@ cifs_init_inodecache(void)
 static void
 cifs_destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(cifs_inode_cachep);
 }
 
diff -puN fs/coda/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/coda/inode.c
--- a/fs/coda/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/coda/inode.c
@@ -85,6 +85,11 @@ int coda_init_inodecache(void)
 
 void coda_destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(coda_inode_cachep);
 }
 
diff -puN fs/ecryptfs/main.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/ecryptfs/main.c
@@ -711,6 +711,12 @@ static void ecryptfs_free_kmem_caches(vo
 {
 	int i;
 
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
+
 	for (i = 0; i < ARRAY_SIZE(ecryptfs_cache_infos); i++) {
 		struct ecryptfs_cache_info *info;
 
diff -puN fs/efs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/efs/super.c
--- a/fs/efs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/efs/super.c
@@ -96,6 +96,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(efs_inode_cachep);
 }
 
diff -puN fs/exofs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/exofs/super.c
--- a/fs/exofs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/exofs/super.c
@@ -206,6 +206,11 @@ static int init_inodecache(void)
  */
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(exofs_inode_cachep);
 }
 
diff -puN fs/ext2/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/ext2/super.c
--- a/fs/ext2/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/ext2/super.c
@@ -206,6 +206,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(ext2_inode_cachep);
 }
 
diff -puN fs/ext3/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/ext3/super.c
--- a/fs/ext3/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/ext3/super.c
@@ -532,6 +532,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(ext3_inode_cachep);
 }
 
diff -puN fs/ext4/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/ext4/super.c
--- a/fs/ext4/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/ext4/super.c
@@ -1019,6 +1019,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(ext4_inode_cachep);
 }
 
diff -puN fs/fat/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/fat/inode.c
--- a/fs/fat/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/fat/inode.c
@@ -521,6 +521,11 @@ static int __init fat_init_inodecache(vo
 
 static void __exit fat_destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(fat_inode_cachep);
 }
 
diff -puN fs/freevxfs/vxfs_super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/freevxfs/vxfs_super.c
--- a/fs/freevxfs/vxfs_super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/freevxfs/vxfs_super.c
@@ -279,6 +279,11 @@ static void __exit
 vxfs_cleanup(void)
 {
 	unregister_filesystem(&vxfs_fs_type);
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(vxfs_inode_cachep);
 }
 
diff -puN fs/fuse/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/fuse/inode.c
--- a/fs/fuse/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/fuse/inode.c
@@ -1200,6 +1200,12 @@ static void fuse_fs_cleanup(void)
 {
 	unregister_filesystem(&fuse_fs_type);
 	unregister_fuseblk();
+
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(fuse_inode_cachep);
 }
 
diff -puN fs/hfs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/hfs/super.c
--- a/fs/hfs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/hfs/super.c
@@ -492,6 +492,12 @@ static int __init init_hfs_fs(void)
 static void __exit exit_hfs_fs(void)
 {
 	unregister_filesystem(&hfs_fs_type);
+
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(hfs_inode_cachep);
 }
 
diff -puN fs/hfsplus/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/hfsplus/super.c
@@ -635,6 +635,12 @@ static int __init init_hfsplus_fs(void)
 static void __exit exit_hfsplus_fs(void)
 {
 	unregister_filesystem(&hfsplus_fs_type);
+
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(hfsplus_inode_cachep);
 }
 
diff -puN fs/hpfs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/hpfs/super.c
--- a/fs/hpfs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/hpfs/super.c
@@ -210,6 +210,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(hpfs_inode_cachep);
 }
 
diff -puN fs/hugetlbfs/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/hugetlbfs/inode.c
@@ -1048,6 +1048,11 @@ static int __init init_hugetlbfs_fs(void
 
 static void __exit exit_hugetlbfs_fs(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(hugetlbfs_inode_cachep);
 	kern_unmount(hugetlbfs_vfsmount);
 	unregister_filesystem(&hugetlbfs_fs_type);
diff -puN fs/isofs/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/isofs/inode.c
--- a/fs/isofs/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/isofs/inode.c
@@ -115,6 +115,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(isofs_inode_cachep);
 }
 
diff -puN fs/jffs2/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/jffs2/super.c
--- a/fs/jffs2/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/jffs2/super.c
@@ -422,6 +422,12 @@ static void __exit exit_jffs2_fs(void)
 	unregister_filesystem(&jffs2_fs_type);
 	jffs2_destroy_slab_caches();
 	jffs2_compressors_exit();
+
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(jffs2_inode_cachep);
 }
 
diff -puN fs/jfs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/jfs/super.c
--- a/fs/jfs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/jfs/super.c
@@ -952,6 +952,12 @@ static void __exit exit_jfs_fs(void)
 	jfs_proc_clean();
 #endif
 	unregister_filesystem(&jfs_fs_type);
+
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(jfs_inode_cachep);
 }
 
diff -puN fs/logfs/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/logfs/inode.c
--- a/fs/logfs/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/logfs/inode.c
@@ -417,5 +417,10 @@ int logfs_init_inode_cache(void)
 
 void logfs_destroy_inode_cache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(logfs_inode_cache);
 }
diff -puN fs/minix/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/minix/inode.c
--- a/fs/minix/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/minix/inode.c
@@ -100,6 +100,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(minix_inode_cachep);
 }
 
diff -puN fs/ncpfs/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/ncpfs/inode.c
@@ -89,6 +89,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(ncp_inode_cachep);
 }
 
diff -puN fs/nfs/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/nfs/inode.c
--- a/fs/nfs/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/nfs/inode.c
@@ -1571,6 +1571,11 @@ static int __init nfs_init_inodecache(vo
 
 static void nfs_destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(nfs_inode_cachep);
 }
 
diff -puN fs/nilfs2/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/nilfs2/super.c
@@ -1382,6 +1382,12 @@ static void nilfs_segbuf_init_once(void 
 
 static void nilfs_destroy_cachep(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
+
 	if (nilfs_inode_cachep)
 		kmem_cache_destroy(nilfs_inode_cachep);
 	if (nilfs_transaction_cachep)
diff -puN fs/ntfs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/ntfs/super.c
--- a/fs/ntfs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/ntfs/super.c
@@ -3193,6 +3193,12 @@ static void __exit exit_ntfs_fs(void)
 	ntfs_debug("Unregistering NTFS driver.");
 
 	unregister_filesystem(&ntfs_fs_type);
+
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(ntfs_big_inode_cache);
 	kmem_cache_destroy(ntfs_inode_cache);
 	kmem_cache_destroy(ntfs_name_cache);
diff -puN fs/ocfs2/dlmfs/dlmfs.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/ocfs2/dlmfs/dlmfs.c
--- a/fs/ocfs2/dlmfs/dlmfs.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/ocfs2/dlmfs/dlmfs.c
@@ -691,6 +691,11 @@ static void __exit exit_dlmfs_fs(void)
 	flush_workqueue(user_dlm_worker);
 	destroy_workqueue(user_dlm_worker);
 
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(dlmfs_inode_cache);
 
 	bdi_destroy(&dlmfs_backing_dev_info);
diff -puN fs/ocfs2/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/ocfs2/super.c
@@ -1818,6 +1818,11 @@ static int ocfs2_initialize_mem_caches(v
 
 static void ocfs2_free_mem_caches(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	if (ocfs2_inode_cachep)
 		kmem_cache_destroy(ocfs2_inode_cachep);
 	ocfs2_inode_cachep = NULL;
diff -puN fs/openpromfs/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/openpromfs/inode.c
--- a/fs/openpromfs/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/openpromfs/inode.c
@@ -463,6 +463,11 @@ static int __init init_openprom_fs(void)
 static void __exit exit_openprom_fs(void)
 {
 	unregister_filesystem(&openprom_fs_type);
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(op_inode_cachep);
 }
 
diff -puN fs/qnx4/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/qnx4/inode.c
--- a/fs/qnx4/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/qnx4/inode.c
@@ -391,6 +391,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(qnx4_inode_cachep);
 }
 
diff -puN fs/qnx6/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/qnx6/inode.c
--- a/fs/qnx6/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/qnx6/inode.c
@@ -651,6 +651,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(qnx6_inode_cachep);
 }
 
diff -puN fs/reiserfs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/reiserfs/super.c
@@ -608,6 +608,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(reiserfs_inode_cachep);
 }
 
diff -puN fs/romfs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/romfs/super.c
--- a/fs/romfs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/romfs/super.c
@@ -648,6 +648,11 @@ error_register:
 static void __exit exit_romfs_fs(void)
 {
 	unregister_filesystem(&romfs_fs_type);
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(romfs_inode_cachep);
 }
 
diff -puN fs/squashfs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/squashfs/super.c
--- a/fs/squashfs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/squashfs/super.c
@@ -425,6 +425,11 @@ static int __init init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(squashfs_inode_cachep);
 }
 
diff -puN fs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/super.c
--- a/fs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/super.c
@@ -307,12 +307,6 @@ void deactivate_locked_super(struct supe
 
 		/* caches are now gone, we can safely kill the shrinker now */
 		unregister_shrinker(&s->s_shrink);
-
-		/*
-		 * We need to call rcu_barrier so all the delayed rcu free
-		 * inodes are flushed before we release the fs module.
-		 */
-		rcu_barrier();
 		put_filesystem(fs);
 		put_super(s);
 	} else {
diff -puN fs/sysv/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/sysv/inode.c
--- a/fs/sysv/inode.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/sysv/inode.c
@@ -360,5 +360,10 @@ int __init sysv_init_icache(void)
 
 void sysv_destroy_icache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(sysv_inode_cachep);
 }
diff -puN fs/ubifs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/ubifs/super.c
--- a/fs/ubifs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/ubifs/super.c
@@ -2289,6 +2289,12 @@ static void __exit ubifs_exit(void)
 	dbg_debugfs_exit();
 	ubifs_compressors_exit();
 	unregister_shrinker(&ubifs_shrinker_info);
+
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(ubifs_inode_slab);
 	unregister_filesystem(&ubifs_fs_type);
 }
diff -puN fs/udf/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/udf/super.c
--- a/fs/udf/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/udf/super.c
@@ -171,6 +171,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(udf_inode_cachep);
 }
 
diff -puN fs/ufs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/ufs/super.c
--- a/fs/ufs/super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/ufs/super.c
@@ -1466,6 +1466,11 @@ static int init_inodecache(void)
 
 static void destroy_inodecache(void)
 {
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(ufs_inode_cachep);
 }
 
diff -puN fs/xfs/xfs_super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems fs/xfs/xfs_super.c
--- a/fs/xfs/xfs_super.c~fs-push-rcu_barrier-from-deactivate_locked_super-to-filesystems
+++ a/fs/xfs/xfs_super.c
@@ -1599,6 +1599,11 @@ xfs_init_zones(void)
 STATIC void
 xfs_destroy_zones(void)
 {
+	/*
+	 * Make sure all delayed rcu free are flushed before we
+	 * destroy caches.
+	 */
+	rcu_barrier();
 	kmem_zone_destroy(xfs_ili_zone);
 	kmem_zone_destroy(xfs_inode_zone);
 	kmem_zone_destroy(xfs_efi_zone);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

linux-next.patch

