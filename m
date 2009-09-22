From: akpm@linux-foundation.org
Subject: [merged] const-mark-remaining-inode_operations-as-const.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:37:10 -0700
Message-ID: <200909222037.n8MKbAqe031282@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752067AbZIVUhe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:37:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     const: mark remaining inode_operations as const
has been removed from the -mm tree.  Its filename was
     const-mark-remaining-inode_operations-as-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: const: mark remaining inode_operations as const
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/inode.c |    2 +-
 fs/btrfs/inode.c                          |   20 ++++++++++----------
 fs/cifs/cifs_dfs_ref.c                    |    2 +-
 fs/cifs/cifsfs.h                          |    2 +-
 fs/inode.c                                |    2 +-
 fs/nilfs2/file.c                          |    2 +-
 fs/nilfs2/mdt.c                           |    2 +-
 fs/nilfs2/namei.c                         |    6 +++---
 fs/nilfs2/nilfs.h                         |    8 ++++----
 fs/omfs/dir.c                             |    2 +-
 fs/omfs/file.c                            |    2 +-
 fs/omfs/omfs.h                            |    4 ++--
 fs/romfs/super.c                          |    2 +-
 kernel/cgroup.c                           |    4 ++--
 14 files changed, 30 insertions(+), 30 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/inode.c~const-mark-remaining-inode_operations-as-const arch/powerpc/platforms/cell/spufs/inode.c
--- a/arch/powerpc/platforms/cell/spufs/inode.c~const-mark-remaining-inode_operations-as-const
+++ a/arch/powerpc/platforms/cell/spufs/inode.c
@@ -119,7 +119,7 @@ spufs_new_file(struct super_block *sb, s
 		const struct file_operations *fops, int mode,
 		size_t size, struct spu_context *ctx)
 {
-	static struct inode_operations spufs_file_iops = {
+	static const struct inode_operations spufs_file_iops = {
 		.setattr = spufs_setattr,
 	};
 	struct inode *inode;
diff -puN fs/btrfs/inode.c~const-mark-remaining-inode_operations-as-const fs/btrfs/inode.c
--- a/fs/btrfs/inode.c~const-mark-remaining-inode_operations-as-const
+++ a/fs/btrfs/inode.c
@@ -55,11 +55,11 @@ struct btrfs_iget_args {
 	struct btrfs_root *root;
 };
 
-static struct inode_operations btrfs_dir_inode_operations;
-static struct inode_operations btrfs_symlink_inode_operations;
-static struct inode_operations btrfs_dir_ro_inode_operations;
-static struct inode_operations btrfs_special_inode_operations;
-static struct inode_operations btrfs_file_inode_operations;
+static const struct inode_operations btrfs_dir_inode_operations;
+static const struct inode_operations btrfs_symlink_inode_operations;
+static const struct inode_operations btrfs_dir_ro_inode_operations;
+static const struct inode_operations btrfs_special_inode_operations;
+static const struct inode_operations btrfs_file_inode_operations;
 static const struct address_space_operations btrfs_aops;
 static const struct address_space_operations btrfs_symlink_aops;
 static struct file_operations btrfs_dir_file_operations;
@@ -5201,7 +5201,7 @@ static int btrfs_permission(struct inode
 	return generic_permission(inode, mask, btrfs_check_acl);
 }
 
-static struct inode_operations btrfs_dir_inode_operations = {
+static const struct inode_operations btrfs_dir_inode_operations = {
 	.getattr	= btrfs_getattr,
 	.lookup		= btrfs_lookup,
 	.create		= btrfs_create,
@@ -5219,7 +5219,7 @@ static struct inode_operations btrfs_dir
 	.removexattr	= btrfs_removexattr,
 	.permission	= btrfs_permission,
 };
-static struct inode_operations btrfs_dir_ro_inode_operations = {
+static const struct inode_operations btrfs_dir_ro_inode_operations = {
 	.lookup		= btrfs_lookup,
 	.permission	= btrfs_permission,
 };
@@ -5278,7 +5278,7 @@ static const struct address_space_operat
 	.releasepage	= btrfs_releasepage,
 };
 
-static struct inode_operations btrfs_file_inode_operations = {
+static const struct inode_operations btrfs_file_inode_operations = {
 	.truncate	= btrfs_truncate,
 	.getattr	= btrfs_getattr,
 	.setattr	= btrfs_setattr,
@@ -5290,7 +5290,7 @@ static struct inode_operations btrfs_fil
 	.fallocate	= btrfs_fallocate,
 	.fiemap		= btrfs_fiemap,
 };
-static struct inode_operations btrfs_special_inode_operations = {
+static const struct inode_operations btrfs_special_inode_operations = {
 	.getattr	= btrfs_getattr,
 	.setattr	= btrfs_setattr,
 	.permission	= btrfs_permission,
@@ -5299,7 +5299,7 @@ static struct inode_operations btrfs_spe
 	.listxattr	= btrfs_listxattr,
 	.removexattr	= btrfs_removexattr,
 };
-static struct inode_operations btrfs_symlink_inode_operations = {
+static const struct inode_operations btrfs_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.follow_link	= page_follow_link_light,
 	.put_link	= page_put_link,
diff -puN fs/cifs/cifs_dfs_ref.c~const-mark-remaining-inode_operations-as-const fs/cifs/cifs_dfs_ref.c
--- a/fs/cifs/cifs_dfs_ref.c~const-mark-remaining-inode_operations-as-const
+++ a/fs/cifs/cifs_dfs_ref.c
@@ -385,7 +385,7 @@ out_err:
 	goto out;
 }
 
-struct inode_operations cifs_dfs_referral_inode_operations = {
+const struct inode_operations cifs_dfs_referral_inode_operations = {
 	.follow_link = cifs_dfs_follow_mountpoint,
 };
 
diff -puN fs/cifs/cifsfs.h~const-mark-remaining-inode_operations-as-const fs/cifs/cifsfs.h
--- a/fs/cifs/cifsfs.h~const-mark-remaining-inode_operations-as-const
+++ a/fs/cifs/cifsfs.h
@@ -67,7 +67,7 @@ extern int cifs_setattr(struct dentry *,
 
 extern const struct inode_operations cifs_file_inode_ops;
 extern const struct inode_operations cifs_symlink_inode_ops;
-extern struct inode_operations cifs_dfs_referral_inode_operations;
+extern const struct inode_operations cifs_dfs_referral_inode_operations;
 
 
 /* Functions related to files and directories */
diff -puN fs/inode.c~const-mark-remaining-inode_operations-as-const fs/inode.c
--- a/fs/inode.c~const-mark-remaining-inode_operations-as-const
+++ a/fs/inode.c
@@ -123,7 +123,7 @@ static void wake_up_inode(struct inode *
 int inode_init_always(struct super_block *sb, struct inode *inode)
 {
 	static const struct address_space_operations empty_aops;
-	static struct inode_operations empty_iops;
+	static const struct inode_operations empty_iops;
 	static const struct file_operations empty_fops;
 	struct address_space *const mapping = &inode->i_data;
 
diff -puN fs/nilfs2/file.c~const-mark-remaining-inode_operations-as-const fs/nilfs2/file.c
--- a/fs/nilfs2/file.c~const-mark-remaining-inode_operations-as-const
+++ a/fs/nilfs2/file.c
@@ -151,7 +151,7 @@ struct file_operations nilfs_file_operat
 	.splice_read	= generic_file_splice_read,
 };
 
-struct inode_operations nilfs_file_inode_operations = {
+const struct inode_operations nilfs_file_inode_operations = {
 	.truncate	= nilfs_truncate,
 	.setattr	= nilfs_setattr,
 	.permission     = nilfs_permission,
diff -puN fs/nilfs2/mdt.c~const-mark-remaining-inode_operations-as-const fs/nilfs2/mdt.c
--- a/fs/nilfs2/mdt.c~const-mark-remaining-inode_operations-as-const
+++ a/fs/nilfs2/mdt.c
@@ -432,7 +432,7 @@ static const struct address_space_operat
 	.sync_page		= block_sync_page,
 };
 
-static struct inode_operations def_mdt_iops;
+static const struct inode_operations def_mdt_iops;
 static struct file_operations def_mdt_fops;
 
 /*
diff -puN fs/nilfs2/namei.c~const-mark-remaining-inode_operations-as-const fs/nilfs2/namei.c
--- a/fs/nilfs2/namei.c~const-mark-remaining-inode_operations-as-const
+++ a/fs/nilfs2/namei.c
@@ -448,7 +448,7 @@ out:
 	return err;
 }
 
-struct inode_operations nilfs_dir_inode_operations = {
+const struct inode_operations nilfs_dir_inode_operations = {
 	.create		= nilfs_create,
 	.lookup		= nilfs_lookup,
 	.link		= nilfs_link,
@@ -462,12 +462,12 @@ struct inode_operations nilfs_dir_inode_
 	.permission	= nilfs_permission,
 };
 
-struct inode_operations nilfs_special_inode_operations = {
+const struct inode_operations nilfs_special_inode_operations = {
 	.setattr	= nilfs_setattr,
 	.permission	= nilfs_permission,
 };
 
-struct inode_operations nilfs_symlink_inode_operations = {
+const struct inode_operations nilfs_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.follow_link	= page_follow_link_light,
 	.put_link	= page_put_link,
diff -puN fs/nilfs2/nilfs.h~const-mark-remaining-inode_operations-as-const fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h~const-mark-remaining-inode_operations-as-const
+++ a/fs/nilfs2/nilfs.h
@@ -295,12 +295,12 @@ void nilfs_clear_gcdat_inode(struct the_
  * Inodes and files operations
  */
 extern struct file_operations nilfs_dir_operations;
-extern struct inode_operations nilfs_file_inode_operations;
+extern const struct inode_operations nilfs_file_inode_operations;
 extern struct file_operations nilfs_file_operations;
 extern const struct address_space_operations nilfs_aops;
-extern struct inode_operations nilfs_dir_inode_operations;
-extern struct inode_operations nilfs_special_inode_operations;
-extern struct inode_operations nilfs_symlink_inode_operations;
+extern const struct inode_operations nilfs_dir_inode_operations;
+extern const struct inode_operations nilfs_special_inode_operations;
+extern const struct inode_operations nilfs_symlink_inode_operations;
 
 /*
  * filesystem type
diff -puN fs/omfs/dir.c~const-mark-remaining-inode_operations-as-const fs/omfs/dir.c
--- a/fs/omfs/dir.c~const-mark-remaining-inode_operations-as-const
+++ a/fs/omfs/dir.c
@@ -489,7 +489,7 @@ out:
 	return ret;
 }
 
-struct inode_operations omfs_dir_inops = {
+const struct inode_operations omfs_dir_inops = {
 	.lookup = omfs_lookup,
 	.mkdir = omfs_mkdir,
 	.rename = omfs_rename,
diff -puN fs/omfs/file.c~const-mark-remaining-inode_operations-as-const fs/omfs/file.c
--- a/fs/omfs/file.c~const-mark-remaining-inode_operations-as-const
+++ a/fs/omfs/file.c
@@ -333,7 +333,7 @@ struct file_operations omfs_file_operati
 	.splice_read = generic_file_splice_read,
 };
 
-struct inode_operations omfs_file_inops = {
+const struct inode_operations omfs_file_inops = {
 	.truncate = omfs_truncate
 };
 
diff -puN fs/omfs/omfs.h~const-mark-remaining-inode_operations-as-const fs/omfs/omfs.h
--- a/fs/omfs/omfs.h~const-mark-remaining-inode_operations-as-const
+++ a/fs/omfs/omfs.h
@@ -45,14 +45,14 @@ extern int omfs_clear_range(struct super
 
 /* dir.c */
 extern struct file_operations omfs_dir_operations;
-extern struct inode_operations omfs_dir_inops;
+extern const struct inode_operations omfs_dir_inops;
 extern int omfs_make_empty(struct inode *inode, struct super_block *sb);
 extern int omfs_is_bad(struct omfs_sb_info *sbi, struct omfs_header *header,
 			u64 fsblock);
 
 /* file.c */
 extern struct file_operations omfs_file_operations;
-extern struct inode_operations omfs_file_inops;
+extern const struct inode_operations omfs_file_inops;
 extern const struct address_space_operations omfs_aops;
 extern void omfs_make_empty_table(struct buffer_head *bh, int offset);
 extern int omfs_shrink_inode(struct inode *inode);
diff -puN fs/romfs/super.c~const-mark-remaining-inode_operations-as-const fs/romfs/super.c
--- a/fs/romfs/super.c~const-mark-remaining-inode_operations-as-const
+++ a/fs/romfs/super.c
@@ -284,7 +284,7 @@ static const struct file_operations romf
 	.readdir	= romfs_readdir,
 };
 
-static struct inode_operations romfs_dir_inode_operations = {
+static const struct inode_operations romfs_dir_inode_operations = {
 	.lookup		= romfs_lookup,
 };
 
diff -puN kernel/cgroup.c~const-mark-remaining-inode_operations-as-const kernel/cgroup.c
--- a/kernel/cgroup.c~const-mark-remaining-inode_operations-as-const
+++ a/kernel/cgroup.c
@@ -596,7 +596,7 @@ void cgroup_unlock(void)
 static int cgroup_mkdir(struct inode *dir, struct dentry *dentry, int mode);
 static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry);
 static int cgroup_populate_dir(struct cgroup *cgrp);
-static struct inode_operations cgroup_dir_inode_operations;
+static const struct inode_operations cgroup_dir_inode_operations;
 static struct file_operations proc_cgroupstats_operations;
 
 static struct backing_dev_info cgroup_backing_dev_info = {
@@ -1711,7 +1711,7 @@ static struct file_operations cgroup_fil
 	.release = cgroup_file_release,
 };
 
-static struct inode_operations cgroup_dir_inode_operations = {
+static const struct inode_operations cgroup_dir_inode_operations = {
 	.lookup = simple_lookup,
 	.mkdir = cgroup_mkdir,
 	.rmdir = cgroup_rmdir,
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

