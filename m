From: akpm@osdl.org
Subject: - fuse-add-support-for-block-device-based-filesystems.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:01:41 -0800
Message-ID: <200612072301.kB7N1fld029787@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51633 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163697AbWLGXCL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:02:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miklos@szeredi.hu, mm-commits@vger.kernel.org


The patch titled
     fuse: add support for block device based filesystems
has been removed from the -mm tree.  Its filename was
     fuse-add-support-for-block-device-based-filesystems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: add support for block device based filesystems
From: Miklos Szeredi <miklos@szeredi.hu>

I never intended this, but people started using fuse to implement block device
based "real" filesystems (ntfs-3g, zfs).

The following four patches add better support for these kinds of filesystems. 
Unlike "normal" fuse filesystems, using this feature should require superuser
privileges (enforced by the fusermount utility).

Thanks to Szabolcs Szakacsits for the input and testing.

This patch adds a 'fuseblk' filesystem type, which is only different from the
'fuse' filesystem type in how the 'dev_name' mount argument is interpreted.

Signed-off-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/filesystems/fuse.txt |   16 +++++++++
 fs/fuse/inode.c                    |   48 ++++++++++++++++++++-------
 2 files changed, 53 insertions(+), 11 deletions(-)

diff -puN Documentation/filesystems/fuse.txt~fuse-add-support-for-block-device-based-filesystems Documentation/filesystems/fuse.txt
--- a/Documentation/filesystems/fuse.txt~fuse-add-support-for-block-device-based-filesystems
+++ a/Documentation/filesystems/fuse.txt
@@ -51,6 +51,22 @@ homepage:
 
   http://fuse.sourceforge.net/
 
+Filesystem type
+~~~~~~~~~~~~~~~
+
+The filesystem type given to mount(2) can be one of the following:
+
+'fuse'
+
+  This is the usual way to mount a FUSE filesystem.  The first
+  argument of the mount system call may contain an arbitrary string,
+  which is not interpreted by the kernel.
+
+'fuseblk'
+
+  The filesystem is block device based.  The first argument of the
+  mount system call is interpreted as the name of the device.
+
 Mount options
 ~~~~~~~~~~~~~
 
diff -puN fs/fuse/inode.c~fuse-add-support-for-block-device-based-filesystems fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-add-support-for-block-device-based-filesystems
+++ a/fs/fuse/inode.c
@@ -591,6 +591,14 @@ static int fuse_get_sb(struct file_syste
 	return get_sb_nodev(fs_type, flags, raw_data, fuse_fill_super, mnt);
 }
 
+static int fuse_get_sb_blk(struct file_system_type *fs_type,
+			   int flags, const char *dev_name,
+			   void *raw_data, struct vfsmount *mnt)
+{
+	return get_sb_bdev(fs_type, flags, dev_name, raw_data, fuse_fill_super,
+			   mnt);
+}
+
 static struct file_system_type fuse_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "fuse",
@@ -598,6 +606,14 @@ static struct file_system_type fuse_fs_t
 	.kill_sb	= kill_anon_super,
 };
 
+static struct file_system_type fuseblk_fs_type = {
+	.owner		= THIS_MODULE,
+	.name		= "fuseblk",
+	.get_sb		= fuse_get_sb_blk,
+	.kill_sb	= kill_block_super,
+	.fs_flags	= FS_REQUIRES_DEV,
+};
+
 static decl_subsys(fuse, NULL, NULL);
 static decl_subsys(connections, NULL, NULL);
 
@@ -617,24 +633,34 @@ static int __init fuse_fs_init(void)
 
 	err = register_filesystem(&fuse_fs_type);
 	if (err)
-		printk("fuse: failed to register filesystem\n");
-	else {
-		fuse_inode_cachep = kmem_cache_create("fuse_inode",
-						      sizeof(struct fuse_inode),
-						      0, SLAB_HWCACHE_ALIGN,
-						      fuse_inode_init_once, NULL);
-		if (!fuse_inode_cachep) {
-			unregister_filesystem(&fuse_fs_type);
-			err = -ENOMEM;
-		}
-	}
+		goto out;
 
+	err = register_filesystem(&fuseblk_fs_type);
+	if (err)
+		goto out_unreg;
+
+	fuse_inode_cachep = kmem_cache_create("fuse_inode",
+					      sizeof(struct fuse_inode),
+					      0, SLAB_HWCACHE_ALIGN,
+					      fuse_inode_init_once, NULL);
+	err = -ENOMEM;
+	if (!fuse_inode_cachep)
+		goto out_unreg2;
+
+	return 0;
+
+ out_unreg2:
+	unregister_filesystem(&fuseblk_fs_type);
+ out_unreg:
+	unregister_filesystem(&fuse_fs_type);
+ out:
 	return err;
 }
 
 static void fuse_fs_cleanup(void)
 {
 	unregister_filesystem(&fuse_fs_type);
+	unregister_filesystem(&fuseblk_fs_type);
 	kmem_cache_destroy(fuse_inode_cachep);
 }
 
_

Patches currently in -mm which might be from miklos@szeredi.hu are

origin.patch

