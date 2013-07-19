From: akpm@linux-foundation.org
Subject: + initmpfs-move-rootfs-code-from-fs-ramfs-to-init.patch added to
 -mm tree
Date: Fri, 19 Jul 2013 12:57:50 -0700
Message-ID: <51e99a3e.z4NVetM+xuhA6Q/4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab3GST5v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jul 2013 15:57:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, swarren@nvidia.com, sam@ravnborg.org, rusty@rustcorp.com.au, jlayton@redhat.com, jim.cromie@gmail.com, hpa@zytor.com, gregkh@linuxfoundation.org, ebiederm@xmission.com, axboe@kernel.dk, rob@landley.net

Subject: + initmpfs-move-rootfs-code-from-fs-ramfs-to-init.patch added to -mm tree
To: rob@landley.net,axboe@kernel.dk,ebiederm@xmission.com,gregkh@linuxfoundation.org,hpa@zytor.com,jim.cromie@gmail.com,jlayton@redhat.com,rusty@rustcorp.com.au,sam@ravnborg.org,swarren@nvidia.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Fri, 19 Jul 2013 12:57:50 -0700


The patch titled
     Subject: initmpfs: move rootfs code from fs/ramfs/ to init/
has been added to the -mm tree.  Its filename is
     initmpfs-move-rootfs-code-from-fs-ramfs-to-init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/initmpfs-move-rootfs-code-from-fs-ramfs-to-init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/initmpfs-move-rootfs-code-from-fs-ramfs-to-init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rob Landley <rob@landley.net>
Subject: initmpfs: move rootfs code from fs/ramfs/ to init/

When the rootfs code was a wrapper around ramfs, having them in the same
file made sense.  Now that it can wrap another filesystem type, move it in
with the init code instead.

This also allows a subsequent patch to access rootfstype= command line
arg.

Signed-off-by: Rob Landley <rob@landley.net>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jim Cromie <jim.cromie@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c        |    2 +-
 fs/ramfs/inode.c      |   32 +-------------------------------
 include/linux/init.h  |    1 +
 include/linux/ramfs.h |    2 +-
 init/do_mounts.c      |   32 ++++++++++++++++++++++++++++++++
 5 files changed, 36 insertions(+), 33 deletions(-)

diff -puN fs/namespace.c~initmpfs-move-rootfs-code-from-fs-ramfs-to-init fs/namespace.c
--- a/fs/namespace.c~initmpfs-move-rootfs-code-from-fs-ramfs-to-init
+++ a/fs/namespace.c
@@ -17,7 +17,7 @@
 #include <linux/security.h>
 #include <linux/idr.h>
 #include <linux/acct.h>		/* acct_auto_close_mnt */
-#include <linux/ramfs.h>	/* init_rootfs */
+#include <linux/init.h>		/* init_rootfs */
 #include <linux/fs_struct.h>	/* get_fs_root et.al. */
 #include <linux/fsnotify.h>	/* fsnotify_vfsmount_delete */
 #include <linux/uaccess.h>
diff -puN fs/ramfs/inode.c~initmpfs-move-rootfs-code-from-fs-ramfs-to-init fs/ramfs/inode.c
--- a/fs/ramfs/inode.c~initmpfs-move-rootfs-code-from-fs-ramfs-to-init
+++ a/fs/ramfs/inode.c
@@ -244,17 +244,6 @@ struct dentry *ramfs_mount(struct file_s
 	return mount_nodev(fs_type, flags, data, ramfs_fill_super);
 }
 
-static struct dentry *rootfs_mount(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data)
-{
-	static unsigned long once;
-
-	if (test_and_set_bit(0, &once))
-		return ERR_PTR(-ENODEV);
-
-	return mount_nodev(fs_type, flags, data, ramfs_fill_super);
-}
-
 static void ramfs_kill_sb(struct super_block *sb)
 {
 	kfree(sb->s_fs_info);
@@ -267,13 +256,8 @@ static struct file_system_type ramfs_fs_
 	.kill_sb	= ramfs_kill_sb,
 	.fs_flags	= FS_USERNS_MOUNT,
 };
-static struct file_system_type rootfs_fs_type = {
-	.name		= "rootfs",
-	.mount		= rootfs_mount,
-	.kill_sb	= kill_litter_super,
-};
 
-static int __init init_ramfs_fs(void)
+int __init init_ramfs_fs(void)
 {
 	static unsigned long once;
 	int err;
@@ -292,17 +276,3 @@ static int __init init_ramfs_fs(void)
 	return err;
 }
 module_init(init_ramfs_fs)
-
-int __init init_rootfs(void)
-{
-	int err = register_filesystem(&rootfs_fs_type);
-
-	if (err)
-		return err;
-
-	err = init_ramfs_fs();
-	if (err)
-		unregister_filesystem(&rootfs_fs_type);
-
-	return err;
-}
diff -puN include/linux/init.h~initmpfs-move-rootfs-code-from-fs-ramfs-to-init include/linux/init.h
--- a/include/linux/init.h~initmpfs-move-rootfs-code-from-fs-ramfs-to-init
+++ a/include/linux/init.h
@@ -153,6 +153,7 @@ extern unsigned int reset_devices;
 void setup_arch(char **);
 void prepare_namespace(void);
 void __init load_default_modules(void);
+int __init init_rootfs(void);
 
 extern void (*late_time_init)(void);
 
diff -puN include/linux/ramfs.h~initmpfs-move-rootfs-code-from-fs-ramfs-to-init include/linux/ramfs.h
--- a/include/linux/ramfs.h~initmpfs-move-rootfs-code-from-fs-ramfs-to-init
+++ a/include/linux/ramfs.h
@@ -25,7 +25,7 @@ extern int ramfs_nommu_mmap(struct file
 
 extern const struct file_operations ramfs_file_operations;
 extern const struct vm_operations_struct generic_file_vm_ops;
-extern int __init init_rootfs(void);
+extern int __init init_ramfs_fs(void);
 
 int ramfs_fill_super(struct super_block *sb, void *data, int silent);
 
diff -puN init/do_mounts.c~initmpfs-move-rootfs-code-from-fs-ramfs-to-init init/do_mounts.c
--- a/init/do_mounts.c~initmpfs-move-rootfs-code-from-fs-ramfs-to-init
+++ a/init/do_mounts.c
@@ -26,6 +26,7 @@
 #include <linux/async.h>
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
+#include <linux/ramfs.h>
 
 #include <linux/nfs_fs.h>
 #include <linux/nfs_fs_sb.h>
@@ -588,3 +589,34 @@ out:
 	sys_mount(".", "/", NULL, MS_MOVE, NULL);
 	sys_chroot(".");
 }
+
+static struct dentry *rootfs_mount(struct file_system_type *fs_type,
+	int flags, const char *dev_name, void *data)
+{
+	static unsigned long once;
+
+	if (test_and_set_bit(0, &once))
+		return ERR_PTR(-ENODEV);
+
+	return mount_nodev(fs_type, flags, data, ramfs_fill_super);
+}
+
+static struct file_system_type rootfs_fs_type = {
+	.name		= "rootfs",
+	.mount		= rootfs_mount,
+	.kill_sb	= kill_litter_super,
+};
+
+int __init init_rootfs(void)
+{
+	int err = register_filesystem(&rootfs_fs_type);
+
+	if (err)
+		return err;
+
+	err = init_ramfs_fs();
+	if (err)
+		unregister_filesystem(&rootfs_fs_type);
+
+	return err;
+}
_

Patches currently in -mm which might be from rob@landley.net are

x86-make-mem=-option-to-work-for-efi-platform.patch
initmpfs-replace-ms_nouser-in-initramfs.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-move-rootfs-code-from-fs-ramfs-to-init.patch
initmpfs-make-rootfs-use-tmpfs-when-config_tmpfs-enabled.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified.patch

