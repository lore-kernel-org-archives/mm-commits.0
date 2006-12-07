From: akpm@osdl.org
Subject: - fuse-fix-compile-without-config_block.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:01:49 -0800
Message-ID: <200612072301.kB7N1nSn029810@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51706 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163795AbWLGXCf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:02:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miklos@szeredi.hu, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     fuse: fix compile without CONFIG_BLOCK
has been removed from the -mm tree.  Its filename was
     fuse-fix-compile-without-config_block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: fix compile without CONFIG_BLOCK
From: Miklos Szeredi <miklos@szeredi.hu>

Randy Dunlap wote:
> Should FUSE depend on BLOCK?  Without that and with BLOCK=n, I get:
>
> inode.c:(.text+0x3acc5): undefined reference to `sb_set_blocksize'
> inode.c:(.text+0x3a393): undefined reference to `get_sb_bdev'
> fs/built-in.o:(.data+0xd718): undefined reference to `kill_block_super

Most fuse filesystems work fine without block device support, so I
think a better solution is to disable the 'fuseblk' filesystem type if
BLOCK=n.

Signed-off-by: Miklos Szeredi <miklos@szeredi.hu>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/fuse/inode.c |   43 +++++++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 10 deletions(-)

diff -puN fs/fuse/inode.c~fuse-fix-compile-without-config_block fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-fix-compile-without-config_block
+++ a/fs/fuse/inode.c
@@ -535,8 +535,10 @@ static int fuse_fill_super(struct super_
 		return -EINVAL;
 
 	if (is_bdev) {
+#ifdef CONFIG_BLOCK
 		if (!sb_set_blocksize(sb, d.blksize))
 			return -EINVAL;
+#endif
 	} else {
 		sb->s_blocksize = PAGE_CACHE_SIZE;
 		sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
@@ -629,6 +631,14 @@ static int fuse_get_sb(struct file_syste
 	return get_sb_nodev(fs_type, flags, raw_data, fuse_fill_super, mnt);
 }
 
+static struct file_system_type fuse_fs_type = {
+	.owner		= THIS_MODULE,
+	.name		= "fuse",
+	.get_sb		= fuse_get_sb,
+	.kill_sb	= kill_anon_super,
+};
+
+#ifdef CONFIG_BLOCK
 static int fuse_get_sb_blk(struct file_system_type *fs_type,
 			   int flags, const char *dev_name,
 			   void *raw_data, struct vfsmount *mnt)
@@ -637,13 +647,6 @@ static int fuse_get_sb_blk(struct file_s
 			   mnt);
 }
 
-static struct file_system_type fuse_fs_type = {
-	.owner		= THIS_MODULE,
-	.name		= "fuse",
-	.get_sb		= fuse_get_sb,
-	.kill_sb	= kill_anon_super,
-};
-
 static struct file_system_type fuseblk_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "fuseblk",
@@ -652,6 +655,26 @@ static struct file_system_type fuseblk_f
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 
+static inline int register_fuseblk(void)
+{
+	return register_filesystem(&fuseblk_fs_type);
+}
+
+static inline void unregister_fuseblk(void)
+{
+	unregister_filesystem(&fuseblk_fs_type);
+}
+#else
+static inline int register_fuseblk(void)
+{
+	return 0;
+}
+
+static inline void unregister_fuseblk(void)
+{
+}
+#endif
+
 static decl_subsys(fuse, NULL, NULL);
 static decl_subsys(connections, NULL, NULL);
 
@@ -673,7 +696,7 @@ static int __init fuse_fs_init(void)
 	if (err)
 		goto out;
 
-	err = register_filesystem(&fuseblk_fs_type);
+	err = register_fuseblk();
 	if (err)
 		goto out_unreg;
 
@@ -688,7 +711,7 @@ static int __init fuse_fs_init(void)
 	return 0;
 
  out_unreg2:
-	unregister_filesystem(&fuseblk_fs_type);
+	unregister_fuseblk();
  out_unreg:
 	unregister_filesystem(&fuse_fs_type);
  out:
@@ -698,7 +721,7 @@ static int __init fuse_fs_init(void)
 static void fuse_fs_cleanup(void)
 {
 	unregister_filesystem(&fuse_fs_type);
-	unregister_filesystem(&fuseblk_fs_type);
+	unregister_fuseblk();
 	kmem_cache_destroy(fuse_inode_cachep);
 }
 
_

Patches currently in -mm which might be from miklos@szeredi.hu are

origin.patch

