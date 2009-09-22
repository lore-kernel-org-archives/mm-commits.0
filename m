From: akpm@linux-foundation.org
Subject: [merged] const-mark-remaining-super_operations-const.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:37:04 -0700
Message-ID: <200909222037.n8MKb4Cx031116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752064AbZIVUhb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:37:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     const: mark remaining super_operations const
has been removed from the -mm tree.  Its filename was
     const-mark-remaining-super_operations-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: const: mark remaining super_operations const
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/inode.c |    2 +-
 arch/s390/hypfs/inode.c                   |    4 ++--
 drivers/isdn/capi/capifs.c                |    2 +-
 drivers/misc/ibmasm/ibmasmfs.c            |    2 +-
 drivers/oprofile/oprofilefs.c             |    2 +-
 drivers/usb/core/inode.c                  |    3 +--
 drivers/usb/gadget/inode.c                |    2 +-
 fs/befs/linuxvfs.c                        |    2 +-
 fs/btrfs/super.c                          |    4 ++--
 fs/nilfs2/super.c                         |    2 +-
 fs/omfs/inode.c                           |    2 +-
 fs/squashfs/super.c                       |    4 ++--
 fs/super.c                                |    2 +-
 fs/xfs/linux-2.6/xfs_super.c              |    4 ++--
 ipc/mqueue.c                              |    4 ++--
 kernel/cgroup.c                           |    2 +-
 net/socket.c                              |    2 +-
 net/sunrpc/rpc_pipe.c                     |    2 +-
 18 files changed, 23 insertions(+), 24 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/inode.c~const-mark-remaining-super_operations-const arch/powerpc/platforms/cell/spufs/inode.c
--- a/arch/powerpc/platforms/cell/spufs/inode.c~const-mark-remaining-super_operations-const
+++ a/arch/powerpc/platforms/cell/spufs/inode.c
@@ -773,7 +773,7 @@ static int
 spufs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct spufs_sb_info *info;
-	static struct super_operations s_ops = {
+	static const struct super_operations s_ops = {
 		.alloc_inode = spufs_alloc_inode,
 		.destroy_inode = spufs_destroy_inode,
 		.statfs = simple_statfs,
diff -puN arch/s390/hypfs/inode.c~const-mark-remaining-super_operations-const arch/s390/hypfs/inode.c
--- a/arch/s390/hypfs/inode.c~const-mark-remaining-super_operations-const
+++ a/arch/s390/hypfs/inode.c
@@ -41,7 +41,7 @@ struct hypfs_sb_info {
 
 static const struct file_operations hypfs_file_ops;
 static struct file_system_type hypfs_type;
-static struct super_operations hypfs_s_ops;
+static const struct super_operations hypfs_s_ops;
 
 /* start of list of all dentries, which have to be deleted on update */
 static struct dentry *hypfs_last_dentry;
@@ -472,7 +472,7 @@ static struct file_system_type hypfs_typ
 	.kill_sb	= hypfs_kill_super
 };
 
-static struct super_operations hypfs_s_ops = {
+static const struct super_operations hypfs_s_ops = {
 	.statfs		= simple_statfs,
 	.drop_inode	= hypfs_drop_inode,
 	.show_options	= hypfs_show_options,
diff -puN drivers/isdn/capi/capifs.c~const-mark-remaining-super_operations-const drivers/isdn/capi/capifs.c
--- a/drivers/isdn/capi/capifs.c~const-mark-remaining-super_operations-const
+++ a/drivers/isdn/capi/capifs.c
@@ -89,7 +89,7 @@ static int capifs_remount(struct super_b
 	return 0;
 }
 
-static struct super_operations capifs_sops =
+static const struct super_operations capifs_sops =
 {
 	.statfs		= simple_statfs,
 	.remount_fs	= capifs_remount,
diff -puN drivers/misc/ibmasm/ibmasmfs.c~const-mark-remaining-super_operations-const drivers/misc/ibmasm/ibmasmfs.c
--- a/drivers/misc/ibmasm/ibmasmfs.c~const-mark-remaining-super_operations-const
+++ a/drivers/misc/ibmasm/ibmasmfs.c
@@ -97,7 +97,7 @@ static int ibmasmfs_get_super(struct fil
 	return get_sb_single(fst, flags, data, ibmasmfs_fill_super, mnt);
 }
 
-static struct super_operations ibmasmfs_s_ops = {
+static const struct super_operations ibmasmfs_s_ops = {
 	.statfs		= simple_statfs,
 	.drop_inode	= generic_delete_inode,
 };
diff -puN drivers/oprofile/oprofilefs.c~const-mark-remaining-super_operations-const drivers/oprofile/oprofilefs.c
--- a/drivers/oprofile/oprofilefs.c~const-mark-remaining-super_operations-const
+++ a/drivers/oprofile/oprofilefs.c
@@ -35,7 +35,7 @@ static struct inode *oprofilefs_get_inod
 }
 
 
-static struct super_operations s_ops = {
+static const struct super_operations s_ops = {
 	.statfs		= simple_statfs,
 	.drop_inode 	= generic_delete_inode,
 };
diff -puN drivers/usb/core/inode.c~const-mark-remaining-super_operations-const drivers/usb/core/inode.c
--- a/drivers/usb/core/inode.c~const-mark-remaining-super_operations-const
+++ a/drivers/usb/core/inode.c
@@ -48,7 +48,6 @@
 #define USBFS_DEFAULT_BUSMODE (S_IXUGO | S_IRUGO)
 #define USBFS_DEFAULT_LISTMODE S_IRUGO
 
-static struct super_operations usbfs_ops;
 static const struct file_operations default_file_operations;
 static struct vfsmount *usbfs_mount;
 static int usbfs_mount_count;	/* = 0 */
@@ -449,7 +448,7 @@ static const struct file_operations defa
 	.llseek =	default_file_lseek,
 };
 
-static struct super_operations usbfs_ops = {
+static const struct super_operations usbfs_ops = {
 	.statfs =	simple_statfs,
 	.drop_inode =	generic_delete_inode,
 	.remount_fs =	remount,
diff -puN drivers/usb/gadget/inode.c~const-mark-remaining-super_operations-const drivers/usb/gadget/inode.c
--- a/drivers/usb/gadget/inode.c~const-mark-remaining-super_operations-const
+++ a/drivers/usb/gadget/inode.c
@@ -2033,7 +2033,7 @@ gadgetfs_create_file (struct super_block
 	return inode;
 }
 
-static struct super_operations gadget_fs_operations = {
+static const struct super_operations gadget_fs_operations = {
 	.statfs =	simple_statfs,
 	.drop_inode =	generic_delete_inode,
 };
diff -puN fs/befs/linuxvfs.c~const-mark-remaining-super_operations-const fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~const-mark-remaining-super_operations-const
+++ a/fs/befs/linuxvfs.c
@@ -842,7 +842,7 @@ befs_fill_super(struct super_block *sb, 
 	sb->s_magic = BEFS_SUPER_MAGIC;
 	/* Set real blocksize of fs */
 	sb_set_blocksize(sb, (ulong) befs_sb->block_size);
-	sb->s_op = (struct super_operations *) &befs_sops;
+	sb->s_op = &befs_sops;
 	root = befs_iget(sb, iaddr2blockno(sb, &(befs_sb->root_dir)));
 	if (IS_ERR(root)) {
 		ret = PTR_ERR(root);
diff -puN fs/btrfs/super.c~const-mark-remaining-super_operations-const fs/btrfs/super.c
--- a/fs/btrfs/super.c~const-mark-remaining-super_operations-const
+++ a/fs/btrfs/super.c
@@ -51,7 +51,7 @@
 #include "export.h"
 #include "compression.h"
 
-static struct super_operations btrfs_super_ops;
+static const struct super_operations btrfs_super_ops;
 
 static void btrfs_put_super(struct super_block *sb)
 {
@@ -675,7 +675,7 @@ static int btrfs_unfreeze(struct super_b
 	return 0;
 }
 
-static struct super_operations btrfs_super_ops = {
+static const struct super_operations btrfs_super_ops = {
 	.delete_inode	= btrfs_delete_inode,
 	.put_super	= btrfs_put_super,
 	.sync_fs	= btrfs_sync_fs,
diff -puN fs/nilfs2/super.c~const-mark-remaining-super_operations-const fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~const-mark-remaining-super_operations-const
+++ a/fs/nilfs2/super.c
@@ -504,7 +504,7 @@ static int nilfs_show_options(struct seq
 	return 0;
 }
 
-static struct super_operations nilfs_sops = {
+static const struct super_operations nilfs_sops = {
 	.alloc_inode    = nilfs_alloc_inode,
 	.destroy_inode  = nilfs_destroy_inode,
 	.dirty_inode    = nilfs_dirty_inode,
diff -puN fs/omfs/inode.c~const-mark-remaining-super_operations-const fs/omfs/inode.c
--- a/fs/omfs/inode.c~const-mark-remaining-super_operations-const
+++ a/fs/omfs/inode.c
@@ -278,7 +278,7 @@ static int omfs_statfs(struct dentry *de
 	return 0;
 }
 
-static struct super_operations omfs_sops = {
+static const struct super_operations omfs_sops = {
 	.write_inode	= omfs_write_inode,
 	.delete_inode	= omfs_delete_inode,
 	.put_super	= omfs_put_super,
diff -puN fs/squashfs/super.c~const-mark-remaining-super_operations-const fs/squashfs/super.c
--- a/fs/squashfs/super.c~const-mark-remaining-super_operations-const
+++ a/fs/squashfs/super.c
@@ -44,7 +44,7 @@
 #include "squashfs.h"
 
 static struct file_system_type squashfs_fs_type;
-static struct super_operations squashfs_super_ops;
+static const struct super_operations squashfs_super_ops;
 
 static int supported_squashfs_filesystem(short major, short minor, short comp)
 {
@@ -444,7 +444,7 @@ static struct file_system_type squashfs_
 	.fs_flags = FS_REQUIRES_DEV
 };
 
-static struct super_operations squashfs_super_ops = {
+static const struct super_operations squashfs_super_ops = {
 	.alloc_inode = squashfs_alloc_inode,
 	.destroy_inode = squashfs_destroy_inode,
 	.statfs = squashfs_statfs,
diff -puN fs/super.c~const-mark-remaining-super_operations-const fs/super.c
--- a/fs/super.c~const-mark-remaining-super_operations-const
+++ a/fs/super.c
@@ -54,7 +54,7 @@ DEFINE_SPINLOCK(sb_lock);
 static struct super_block *alloc_super(struct file_system_type *type)
 {
 	struct super_block *s = kzalloc(sizeof(struct super_block),  GFP_USER);
-	static struct super_operations default_op;
+	static const struct super_operations default_op;
 
 	if (s) {
 		if (security_sb_alloc(s)) {
diff -puN fs/xfs/linux-2.6/xfs_super.c~const-mark-remaining-super_operations-const fs/xfs/linux-2.6/xfs_super.c
--- a/fs/xfs/linux-2.6/xfs_super.c~const-mark-remaining-super_operations-const
+++ a/fs/xfs/linux-2.6/xfs_super.c
@@ -67,7 +67,7 @@
 #include <linux/freezer.h>
 #include <linux/parser.h>
 
-static struct super_operations xfs_super_operations;
+static const struct super_operations xfs_super_operations;
 static kmem_zone_t *xfs_ioend_zone;
 mempool_t *xfs_ioend_pool;
 
@@ -1536,7 +1536,7 @@ xfs_fs_get_sb(
 			   mnt);
 }
 
-static struct super_operations xfs_super_operations = {
+static const struct super_operations xfs_super_operations = {
 	.alloc_inode		= xfs_fs_alloc_inode,
 	.destroy_inode		= xfs_fs_destroy_inode,
 	.write_inode		= xfs_fs_write_inode,
diff -puN ipc/mqueue.c~const-mark-remaining-super_operations-const ipc/mqueue.c
--- a/ipc/mqueue.c~const-mark-remaining-super_operations-const
+++ a/ipc/mqueue.c
@@ -77,7 +77,7 @@ struct mqueue_inode_info {
 
 static const struct inode_operations mqueue_dir_inode_operations;
 static const struct file_operations mqueue_file_operations;
-static struct super_operations mqueue_super_ops;
+static const struct super_operations mqueue_super_ops;
 static void remove_notification(struct mqueue_inode_info *info);
 
 static struct kmem_cache *mqueue_inode_cachep;
@@ -1224,7 +1224,7 @@ static const struct file_operations mque
 	.read = mqueue_read_file,
 };
 
-static struct super_operations mqueue_super_ops = {
+static const struct super_operations mqueue_super_ops = {
 	.alloc_inode = mqueue_alloc_inode,
 	.destroy_inode = mqueue_destroy_inode,
 	.statfs = simple_statfs,
diff -puN kernel/cgroup.c~const-mark-remaining-super_operations-const kernel/cgroup.c
--- a/kernel/cgroup.c~const-mark-remaining-super_operations-const
+++ a/kernel/cgroup.c
@@ -961,7 +961,7 @@ static int cgroup_remount(struct super_b
 	return ret;
 }
 
-static struct super_operations cgroup_ops = {
+static const struct super_operations cgroup_ops = {
 	.statfs = simple_statfs,
 	.drop_inode = generic_delete_inode,
 	.show_options = cgroup_show_options,
diff -puN net/socket.c~const-mark-remaining-super_operations-const net/socket.c
--- a/net/socket.c~const-mark-remaining-super_operations-const
+++ a/net/socket.c
@@ -285,7 +285,7 @@ static int init_inodecache(void)
 	return 0;
 }
 
-static struct super_operations sockfs_ops = {
+static const struct super_operations sockfs_ops = {
 	.alloc_inode =	sock_alloc_inode,
 	.destroy_inode =sock_destroy_inode,
 	.statfs =	simple_statfs,
diff -puN net/sunrpc/rpc_pipe.c~const-mark-remaining-super_operations-const net/sunrpc/rpc_pipe.c
--- a/net/sunrpc/rpc_pipe.c~const-mark-remaining-super_operations-const
+++ a/net/sunrpc/rpc_pipe.c
@@ -930,7 +930,7 @@ void rpc_remove_cache_dir(struct dentry 
 /*
  * populate the filesystem
  */
-static struct super_operations s_ops = {
+static const struct super_operations s_ops = {
 	.alloc_inode	= rpc_alloc_inode,
 	.destroy_inode	= rpc_destroy_inode,
 	.statfs		= simple_statfs,
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
acpi-switch-proc-acpi-debug_layerdebug_level-to-seq_file.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
cpqarray-switch-to-seq_file.patch
dac960-switch-to-seq_file.patch
proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch
procfs-provide-stack-information-for-threads-v08.patch
procfs-provide-stack-information-for-threads-v011.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
viafb-switch-to-seq_file.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
sysctl-remove-struct-file-argument-of-proc_handler.patch
aio-ifdef-fields-in-mm_struct.patch
gru-use-proc_create.patch

