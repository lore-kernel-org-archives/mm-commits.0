From: akpm@osdl.org
Subject: + mark-struct-inode_operations-const-3.patch added to -mm tree
Date: Tue, 23 Jan 2007 11:32:22 -0800
Message-ID: <200701231932.l0NJWMRi029015@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50790 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933133AbXAWTca (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 14:32:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com


The patch titled
     mark struct inode_operations const 3
has been added to the -mm tree.  Its filename is
     mark-struct-inode_operations-const-3.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mark struct inode_operations const 3
From: Arjan van de Ven <arjan@linux.intel.com>

Many struct inode_operations in the kernel can be "const".  Marking them const
moves these to the .rodata section, which avoids false sharing with potential
dirty data.  In addition it'll catch accidental writes at compile time to
these shared resources.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/proc/base.c              |   20 ++++++++++----------
 fs/proc/generic.c           |    6 +++---
 fs/proc/root.c              |    2 +-
 fs/qnx4/dir.c               |    2 +-
 fs/qnx4/file.c              |    2 +-
 fs/ramfs/file-mmu.c         |    2 +-
 fs/ramfs/file-nommu.c       |    2 +-
 fs/ramfs/inode.c            |    4 ++--
 fs/ramfs/internal.h         |    2 +-
 fs/reiserfs/file.c          |    2 +-
 fs/reiserfs/namei.c         |    6 +++---
 fs/romfs/inode.c            |    2 +-
 fs/smbfs/dir.c              |    4 ++--
 fs/smbfs/file.c             |    2 +-
 fs/smbfs/proto.h            |    8 ++++----
 fs/smbfs/symlink.c          |    2 +-
 fs/sysfs/dir.c              |    2 +-
 fs/sysfs/inode.c            |    2 +-
 fs/sysfs/symlink.c          |    2 +-
 fs/sysfs/sysfs.h            |    4 ++--
 fs/sysv/file.c              |    2 +-
 fs/sysv/inode.c             |    2 +-
 fs/sysv/namei.c             |    2 +-
 fs/sysv/symlink.c           |    2 +-
 fs/sysv/sysv.h              |    6 +++---
 fs/udf/file.c               |    2 +-
 fs/udf/namei.c              |    2 +-
 fs/udf/udfdecl.h            |    4 ++--
 fs/ufs/namei.c              |    2 +-
 fs/ufs/symlink.c            |    2 +-
 fs/ufs/truncate.c           |    2 +-
 fs/vfat/namei.c             |    2 +-
 fs/xfs/linux-2.6/xfs_iops.c |    6 +++---
 fs/xfs/linux-2.6/xfs_iops.h |    6 +++---
 include/linux/coda_linux.h  |    6 +++---
 include/linux/efs_fs.h      |    2 +-
 include/linux/ext3_fs.h     |   10 +++++-----
 include/linux/ext4_fs.h     |   10 +++++-----
 include/linux/fs.h          |    6 +++---
 include/linux/msdos_fs.h    |    6 +++---
 include/linux/ncp_fs.h      |    4 ++--
 include/linux/nfs_fs.h      |   14 +++++++-------
 include/linux/nfs_xdr.h     |    4 ++--
 include/linux/phonedev.h    |    2 +-
 include/linux/proc_fs.h     |    2 +-
 include/linux/qnx4_fs.h     |    4 ++--
 include/linux/reiserfs_fs.h |    8 ++++----
 include/linux/ufs_fs.h      |    6 +++---
 48 files changed, 102 insertions(+), 102 deletions(-)

diff -puN fs/proc/base.c~mark-struct-inode_operations-const-3 fs/proc/base.c
--- a/fs/proc/base.c~mark-struct-inode_operations-const-3
+++ a/fs/proc/base.c
@@ -93,7 +93,7 @@ struct pid_entry {
 	int len;
 	char *name;
 	mode_t mode;
-	struct inode_operations *iop;
+	const struct inode_operations *iop;
 	const struct file_operations *fop;
 	union proc_op op;
 };
@@ -352,7 +352,7 @@ static int proc_setattr(struct dentry *d
 	return error;
 }
 
-static struct inode_operations proc_def_inode_operations = {
+static const struct inode_operations proc_def_inode_operations = {
 	.setattr	= proc_setattr,
 };
 
@@ -978,7 +978,7 @@ out:
 	return error;
 }
 
-static struct inode_operations proc_pid_link_inode_operations = {
+static const struct inode_operations proc_pid_link_inode_operations = {
 	.readlink	= proc_pid_readlink,
 	.follow_link	= proc_pid_follow_link,
 	.setattr	= proc_setattr,
@@ -1414,7 +1414,7 @@ static const struct file_operations proc
 /*
  * proc directories can do almost nothing..
  */
-static struct inode_operations proc_fd_inode_operations = {
+static const struct inode_operations proc_fd_inode_operations = {
 	.lookup		= proc_lookupfd,
 	.setattr	= proc_setattr,
 };
@@ -1654,7 +1654,7 @@ static struct dentry *proc_attr_dir_look
 				  attr_dir_stuff, ARRAY_SIZE(attr_dir_stuff));
 }
 
-static struct inode_operations proc_attr_dir_inode_operations = {
+static const struct inode_operations proc_attr_dir_inode_operations = {
 	.lookup		= proc_attr_dir_lookup,
 	.getattr	= pid_getattr,
 	.setattr	= proc_setattr,
@@ -1680,7 +1680,7 @@ static void *proc_self_follow_link(struc
 	return ERR_PTR(vfs_follow_link(nd,tmp));
 }
 
-static struct inode_operations proc_self_inode_operations = {
+static const struct inode_operations proc_self_inode_operations = {
 	.readlink	= proc_self_readlink,
 	.follow_link	= proc_self_follow_link,
 };
@@ -1829,7 +1829,7 @@ static int proc_pid_io_accounting(struct
  * Thread groups
  */
 static const struct file_operations proc_task_operations;
-static struct inode_operations proc_task_inode_operations;
+static const struct inode_operations proc_task_inode_operations;
 
 static struct pid_entry tgid_base_stuff[] = {
 	DIR("task",       S_IRUGO|S_IXUGO, task),
@@ -1898,7 +1898,7 @@ static struct dentry *proc_tgid_base_loo
 				  tgid_base_stuff, ARRAY_SIZE(tgid_base_stuff));
 }
 
-static struct inode_operations proc_tgid_base_inode_operations = {
+static const struct inode_operations proc_tgid_base_inode_operations = {
 	.lookup		= proc_tgid_base_lookup,
 	.getattr	= pid_getattr,
 	.setattr	= proc_setattr,
@@ -2176,7 +2176,7 @@ static const struct file_operations proc
 	.readdir	= proc_tid_base_readdir,
 };
 
-static struct inode_operations proc_tid_base_inode_operations = {
+static const struct inode_operations proc_tid_base_inode_operations = {
 	.lookup		= proc_tid_base_lookup,
 	.getattr	= pid_getattr,
 	.setattr	= proc_setattr,
@@ -2392,7 +2392,7 @@ static int proc_task_getattr(struct vfsm
 	return 0;
 }
 
-static struct inode_operations proc_task_inode_operations = {
+static const struct inode_operations proc_task_inode_operations = {
 	.lookup		= proc_task_lookup,
 	.getattr	= proc_task_getattr,
 	.setattr	= proc_setattr,
diff -puN fs/proc/generic.c~mark-struct-inode_operations-const-3 fs/proc/generic.c
--- a/fs/proc/generic.c~mark-struct-inode_operations-const-3
+++ a/fs/proc/generic.c
@@ -265,7 +265,7 @@ static int proc_getattr(struct vfsmount 
 	return 0;
 }
 
-static struct inode_operations proc_file_inode_operations = {
+static const struct inode_operations proc_file_inode_operations = {
 	.setattr	= proc_notify_change,
 };
 
@@ -357,7 +357,7 @@ static void *proc_follow_link(struct den
 	return NULL;
 }
 
-static struct inode_operations proc_link_inode_operations = {
+static const struct inode_operations proc_link_inode_operations = {
 	.readlink	= generic_readlink,
 	.follow_link	= proc_follow_link,
 };
@@ -508,7 +508,7 @@ static const struct file_operations proc
 /*
  * proc directories can do almost nothing..
  */
-static struct inode_operations proc_dir_inode_operations = {
+static const struct inode_operations proc_dir_inode_operations = {
 	.lookup		= proc_lookup,
 	.getattr	= proc_getattr,
 	.setattr	= proc_notify_change,
diff -puN fs/proc/root.c~mark-struct-inode_operations-const-3 fs/proc/root.c
--- a/fs/proc/root.c~mark-struct-inode_operations-const-3
+++ a/fs/proc/root.c
@@ -144,7 +144,7 @@ static const struct file_operations proc
 /*
  * proc root can do almost nothing..
  */
-static struct inode_operations proc_root_inode_operations = {
+static const struct inode_operations proc_root_inode_operations = {
 	.lookup		= proc_root_lookup,
 	.getattr	= proc_root_getattr,
 };
diff -puN fs/qnx4/dir.c~mark-struct-inode_operations-const-3 fs/qnx4/dir.c
--- a/fs/qnx4/dir.c~mark-struct-inode_operations-const-3
+++ a/fs/qnx4/dir.c
@@ -87,7 +87,7 @@ const struct file_operations qnx4_dir_op
 	.fsync		= file_fsync,
 };
 
-struct inode_operations qnx4_dir_inode_operations =
+const struct inode_operations qnx4_dir_inode_operations =
 {
 	.lookup		= qnx4_lookup,
 #ifdef CONFIG_QNX4FS_RW
diff -puN fs/qnx4/file.c~mark-struct-inode_operations-const-3 fs/qnx4/file.c
--- a/fs/qnx4/file.c~mark-struct-inode_operations-const-3
+++ a/fs/qnx4/file.c
@@ -33,7 +33,7 @@ const struct file_operations qnx4_file_o
 #endif
 };
 
-struct inode_operations qnx4_file_inode_operations =
+const struct inode_operations qnx4_file_inode_operations =
 {
 #ifdef CONFIG_QNX4FS_RW
 	.truncate	= qnx4_truncate,
diff -puN fs/ramfs/file-mmu.c~mark-struct-inode_operations-const-3 fs/ramfs/file-mmu.c
--- a/fs/ramfs/file-mmu.c~mark-struct-inode_operations-const-3
+++ a/fs/ramfs/file-mmu.c
@@ -45,6 +45,6 @@ const struct file_operations ramfs_file_
 	.llseek		= generic_file_llseek,
 };
 
-struct inode_operations ramfs_file_inode_operations = {
+const struct inode_operations ramfs_file_inode_operations = {
 	.getattr	= simple_getattr,
 };
diff -puN fs/ramfs/file-nommu.c~mark-struct-inode_operations-const-3 fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~mark-struct-inode_operations-const-3
+++ a/fs/ramfs/file-nommu.c
@@ -47,7 +47,7 @@ const struct file_operations ramfs_file_
 	.llseek			= generic_file_llseek,
 };
 
-struct inode_operations ramfs_file_inode_operations = {
+const struct inode_operations ramfs_file_inode_operations = {
 	.setattr		= ramfs_nommu_setattr,
 	.getattr		= simple_getattr,
 };
diff -puN fs/ramfs/inode.c~mark-struct-inode_operations-const-3 fs/ramfs/inode.c
--- a/fs/ramfs/inode.c~mark-struct-inode_operations-const-3
+++ a/fs/ramfs/inode.c
@@ -41,7 +41,7 @@
 #define RAMFS_MAGIC	0x858458f6
 
 static struct super_operations ramfs_ops;
-static struct inode_operations ramfs_dir_inode_operations;
+static const struct inode_operations ramfs_dir_inode_operations;
 
 static struct backing_dev_info ramfs_backing_dev_info = {
 	.ra_pages	= 0,	/* No readahead */
@@ -143,7 +143,7 @@ static int ramfs_symlink(struct inode * 
 	return error;
 }
 
-static struct inode_operations ramfs_dir_inode_operations = {
+static const struct inode_operations ramfs_dir_inode_operations = {
 	.create		= ramfs_create,
 	.lookup		= simple_lookup,
 	.link		= simple_link,
diff -puN fs/ramfs/internal.h~mark-struct-inode_operations-const-3 fs/ramfs/internal.h
--- a/fs/ramfs/internal.h~mark-struct-inode_operations-const-3
+++ a/fs/ramfs/internal.h
@@ -12,4 +12,4 @@
 
 extern const struct address_space_operations ramfs_aops;
 extern const struct file_operations ramfs_file_operations;
-extern struct inode_operations ramfs_file_inode_operations;
+extern const struct inode_operations ramfs_file_inode_operations;
diff -puN fs/reiserfs/file.c~mark-struct-inode_operations-const-3 fs/reiserfs/file.c
--- a/fs/reiserfs/file.c~mark-struct-inode_operations-const-3
+++ a/fs/reiserfs/file.c
@@ -1556,7 +1556,7 @@ const struct file_operations reiserfs_fi
 	.splice_write = generic_file_splice_write,
 };
 
-struct inode_operations reiserfs_file_inode_operations = {
+const struct inode_operations reiserfs_file_inode_operations = {
 	.truncate = reiserfs_vfs_truncate_file,
 	.setattr = reiserfs_setattr,
 	.setxattr = reiserfs_setxattr,
diff -puN fs/reiserfs/namei.c~mark-struct-inode_operations-const-3 fs/reiserfs/namei.c
--- a/fs/reiserfs/namei.c~mark-struct-inode_operations-const-3
+++ a/fs/reiserfs/namei.c
@@ -1525,7 +1525,7 @@ static int reiserfs_rename(struct inode 
 /*
  * directories can handle most operations...
  */
-struct inode_operations reiserfs_dir_inode_operations = {
+const struct inode_operations reiserfs_dir_inode_operations = {
 	//&reiserfs_dir_operations,   /* default_file_ops */
 	.create = reiserfs_create,
 	.lookup = reiserfs_lookup,
@@ -1548,7 +1548,7 @@ struct inode_operations reiserfs_dir_ino
  * symlink operations.. same as page_symlink_inode_operations, with xattr
  * stuff added
  */
-struct inode_operations reiserfs_symlink_inode_operations = {
+const struct inode_operations reiserfs_symlink_inode_operations = {
 	.readlink = generic_readlink,
 	.follow_link = page_follow_link_light,
 	.put_link = page_put_link,
@@ -1564,7 +1564,7 @@ struct inode_operations reiserfs_symlink
 /*
  * special file operations.. just xattr/acl stuff
  */
-struct inode_operations reiserfs_special_inode_operations = {
+const struct inode_operations reiserfs_special_inode_operations = {
 	.setattr = reiserfs_setattr,
 	.setxattr = reiserfs_setxattr,
 	.getxattr = reiserfs_getxattr,
diff -puN fs/romfs/inode.c~mark-struct-inode_operations-const-3 fs/romfs/inode.c
--- a/fs/romfs/inode.c~mark-struct-inode_operations-const-3
+++ a/fs/romfs/inode.c
@@ -468,7 +468,7 @@ static const struct file_operations romf
 	.readdir	= romfs_readdir,
 };
 
-static struct inode_operations romfs_dir_inode_operations = {
+static const struct inode_operations romfs_dir_inode_operations = {
 	.lookup		= romfs_lookup,
 };
 
diff -puN fs/smbfs/dir.c~mark-struct-inode_operations-const-3 fs/smbfs/dir.c
--- a/fs/smbfs/dir.c~mark-struct-inode_operations-const-3
+++ a/fs/smbfs/dir.c
@@ -42,7 +42,7 @@ const struct file_operations smb_dir_ope
 	.open		= smb_dir_open,
 };
 
-struct inode_operations smb_dir_inode_operations =
+const struct inode_operations smb_dir_inode_operations =
 {
 	.create		= smb_create,
 	.lookup		= smb_lookup,
@@ -54,7 +54,7 @@ struct inode_operations smb_dir_inode_op
 	.setattr	= smb_notify_change,
 };
 
-struct inode_operations smb_dir_inode_operations_unix =
+const struct inode_operations smb_dir_inode_operations_unix =
 {
 	.create		= smb_create,
 	.lookup		= smb_lookup,
diff -puN fs/smbfs/file.c~mark-struct-inode_operations-const-3 fs/smbfs/file.c
--- a/fs/smbfs/file.c~mark-struct-inode_operations-const-3
+++ a/fs/smbfs/file.c
@@ -418,7 +418,7 @@ const struct file_operations smb_file_op
 	.sendfile	= smb_file_sendfile,
 };
 
-struct inode_operations smb_file_inode_operations =
+const struct inode_operations smb_file_inode_operations =
 {
 	.permission	= smb_file_permission,
 	.getattr	= smb_getattr,
diff -puN fs/smbfs/proto.h~mark-struct-inode_operations-const-3 fs/smbfs/proto.h
--- a/fs/smbfs/proto.h~mark-struct-inode_operations-const-3
+++ a/fs/smbfs/proto.h
@@ -36,8 +36,8 @@ extern int smb_proc_link(struct smb_sb_i
 extern void smb_install_null_ops(struct smb_ops *ops);
 /* dir.c */
 extern const struct file_operations smb_dir_operations;
-extern struct inode_operations smb_dir_inode_operations;
-extern struct inode_operations smb_dir_inode_operations_unix;
+extern const struct inode_operations smb_dir_inode_operations;
+extern const struct inode_operations smb_dir_inode_operations_unix;
 extern void smb_new_dentry(struct dentry *dentry);
 extern void smb_renew_times(struct dentry *dentry);
 /* cache.c */
@@ -65,7 +65,7 @@ extern int smb_notify_change(struct dent
 /* file.c */
 extern const struct address_space_operations smb_file_aops;
 extern const struct file_operations smb_file_operations;
-extern struct inode_operations smb_file_inode_operations;
+extern const struct inode_operations smb_file_inode_operations;
 /* ioctl.c */
 extern int smb_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg);
 /* smbiod.c */
@@ -84,4 +84,4 @@ extern int smb_request_send_server(struc
 extern int smb_request_recv(struct smb_sb_info *server);
 /* symlink.c */
 extern int smb_symlink(struct inode *inode, struct dentry *dentry, const char *oldname);
-extern struct inode_operations smb_link_inode_operations;
+extern const struct inode_operations smb_link_inode_operations;
diff -puN fs/smbfs/symlink.c~mark-struct-inode_operations-const-3 fs/smbfs/symlink.c
--- a/fs/smbfs/symlink.c~mark-struct-inode_operations-const-3
+++ a/fs/smbfs/symlink.c
@@ -61,7 +61,7 @@ static void smb_put_link(struct dentry *
 		__putname(s);
 }
 
-struct inode_operations smb_link_inode_operations =
+const struct inode_operations smb_link_inode_operations =
 {
 	.readlink	= generic_readlink,
 	.follow_link	= smb_follow_link,
diff -puN fs/sysfs/dir.c~mark-struct-inode_operations-const-3 fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~mark-struct-inode_operations-const-3
+++ a/fs/sysfs/dir.c
@@ -266,7 +266,7 @@ static struct dentry * sysfs_lookup(stru
 	return ERR_PTR(err);
 }
 
-struct inode_operations sysfs_dir_inode_operations = {
+const struct inode_operations sysfs_dir_inode_operations = {
 	.lookup		= sysfs_lookup,
 	.setattr	= sysfs_setattr,
 };
diff -puN fs/sysfs/inode.c~mark-struct-inode_operations-const-3 fs/sysfs/inode.c
--- a/fs/sysfs/inode.c~mark-struct-inode_operations-const-3
+++ a/fs/sysfs/inode.c
@@ -28,7 +28,7 @@ static struct backing_dev_info sysfs_bac
 	.capabilities	= BDI_CAP_NO_ACCT_DIRTY | BDI_CAP_NO_WRITEBACK,
 };
 
-static struct inode_operations sysfs_inode_operations ={
+static const struct inode_operations sysfs_inode_operations ={
 	.setattr	= sysfs_setattr,
 };
 
diff -puN fs/sysfs/symlink.c~mark-struct-inode_operations-const-3 fs/sysfs/symlink.c
--- a/fs/sysfs/symlink.c~mark-struct-inode_operations-const-3
+++ a/fs/sysfs/symlink.c
@@ -180,7 +180,7 @@ static void sysfs_put_link(struct dentry
 		free_page((unsigned long)page);
 }
 
-struct inode_operations sysfs_symlink_inode_operations = {
+const struct inode_operations sysfs_symlink_inode_operations = {
 	.readlink = generic_readlink,
 	.follow_link = sysfs_follow_link,
 	.put_link = sysfs_put_link,
diff -puN fs/sysfs/sysfs.h~mark-struct-inode_operations-const-3 fs/sysfs/sysfs.h
--- a/fs/sysfs/sysfs.h~mark-struct-inode_operations-const-3
+++ a/fs/sysfs/sysfs.h
@@ -25,8 +25,8 @@ extern struct super_block * sysfs_sb;
 extern const struct file_operations sysfs_dir_operations;
 extern const struct file_operations sysfs_file_operations;
 extern const struct file_operations bin_fops;
-extern struct inode_operations sysfs_dir_inode_operations;
-extern struct inode_operations sysfs_symlink_inode_operations;
+extern const struct inode_operations sysfs_dir_inode_operations;
+extern const struct inode_operations sysfs_symlink_inode_operations;
 
 struct sysfs_symlink {
 	char * link_name;
diff -puN fs/sysv/file.c~mark-struct-inode_operations-const-3 fs/sysv/file.c
--- a/fs/sysv/file.c~mark-struct-inode_operations-const-3
+++ a/fs/sysv/file.c
@@ -30,7 +30,7 @@ const struct file_operations sysv_file_o
 	.sendfile	= generic_file_sendfile,
 };
 
-struct inode_operations sysv_file_inode_operations = {
+const struct inode_operations sysv_file_inode_operations = {
 	.truncate	= sysv_truncate,
 	.getattr	= sysv_getattr,
 };
diff -puN fs/sysv/inode.c~mark-struct-inode_operations-const-3 fs/sysv/inode.c
--- a/fs/sysv/inode.c~mark-struct-inode_operations-const-3
+++ a/fs/sysv/inode.c
@@ -142,7 +142,7 @@ static inline void write3byte(struct sys
 	}
 }
 
-static struct inode_operations sysv_symlink_inode_operations = {
+static const struct inode_operations sysv_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.follow_link	= page_follow_link_light,
 	.put_link	= page_put_link,
diff -puN fs/sysv/namei.c~mark-struct-inode_operations-const-3 fs/sysv/namei.c
--- a/fs/sysv/namei.c~mark-struct-inode_operations-const-3
+++ a/fs/sysv/namei.c
@@ -292,7 +292,7 @@ out:
 /*
  * directories can handle most operations...
  */
-struct inode_operations sysv_dir_inode_operations = {
+const struct inode_operations sysv_dir_inode_operations = {
 	.create		= sysv_create,
 	.lookup		= sysv_lookup,
 	.link		= sysv_link,
diff -puN fs/sysv/symlink.c~mark-struct-inode_operations-const-3 fs/sysv/symlink.c
--- a/fs/sysv/symlink.c~mark-struct-inode_operations-const-3
+++ a/fs/sysv/symlink.c
@@ -14,7 +14,7 @@ static void *sysv_follow_link(struct den
 	return NULL;
 }
 
-struct inode_operations sysv_fast_symlink_inode_operations = {
+const struct inode_operations sysv_fast_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.follow_link	= sysv_follow_link,
 };
diff -puN fs/sysv/sysv.h~mark-struct-inode_operations-const-3 fs/sysv/sysv.h
--- a/fs/sysv/sysv.h~mark-struct-inode_operations-const-3
+++ a/fs/sysv/sysv.h
@@ -159,9 +159,9 @@ extern struct sysv_dir_entry *sysv_dotdo
 extern ino_t sysv_inode_by_name(struct dentry *);
 
 
-extern struct inode_operations sysv_file_inode_operations;
-extern struct inode_operations sysv_dir_inode_operations;
-extern struct inode_operations sysv_fast_symlink_inode_operations;
+extern const struct inode_operations sysv_file_inode_operations;
+extern const struct inode_operations sysv_dir_inode_operations;
+extern const struct inode_operations sysv_fast_symlink_inode_operations;
 extern const struct file_operations sysv_file_operations;
 extern const struct file_operations sysv_dir_operations;
 extern const struct address_space_operations sysv_aops;
diff -puN fs/udf/file.c~mark-struct-inode_operations-const-3 fs/udf/file.c
--- a/fs/udf/file.c~mark-struct-inode_operations-const-3
+++ a/fs/udf/file.c
@@ -262,6 +262,6 @@ const struct file_operations udf_file_op
 	.sendfile		= generic_file_sendfile,
 };
 
-struct inode_operations udf_file_inode_operations = {
+const struct inode_operations udf_file_inode_operations = {
 	.truncate		= udf_truncate,
 };
diff -puN fs/udf/namei.c~mark-struct-inode_operations-const-3 fs/udf/namei.c
--- a/fs/udf/namei.c~mark-struct-inode_operations-const-3
+++ a/fs/udf/namei.c
@@ -1308,7 +1308,7 @@ end_rename:
 	return retval;
 }
 
-struct inode_operations udf_dir_inode_operations = {
+const struct inode_operations udf_dir_inode_operations = {
 	.lookup				= udf_lookup,
 	.create				= udf_create,
 	.link				= udf_link,
diff -puN fs/udf/udfdecl.h~mark-struct-inode_operations-const-3 fs/udf/udfdecl.h
--- a/fs/udf/udfdecl.h~mark-struct-inode_operations-const-3
+++ a/fs/udf/udfdecl.h
@@ -42,9 +42,9 @@ struct task_struct;
 struct buffer_head;
 struct super_block;
 
-extern struct inode_operations udf_dir_inode_operations;
+extern const struct inode_operations udf_dir_inode_operations;
 extern const struct file_operations udf_dir_operations;
-extern struct inode_operations udf_file_inode_operations;
+extern const struct inode_operations udf_file_inode_operations;
 extern const struct file_operations udf_file_operations;
 extern const struct address_space_operations udf_aops;
 extern const struct address_space_operations udf_adinicb_aops;
diff -puN fs/ufs/namei.c~mark-struct-inode_operations-const-3 fs/ufs/namei.c
--- a/fs/ufs/namei.c~mark-struct-inode_operations-const-3
+++ a/fs/ufs/namei.c
@@ -355,7 +355,7 @@ out:
 	return err;
 }
 
-struct inode_operations ufs_dir_inode_operations = {
+const struct inode_operations ufs_dir_inode_operations = {
 	.create		= ufs_create,
 	.lookup		= ufs_lookup,
 	.link		= ufs_link,
diff -puN fs/ufs/symlink.c~mark-struct-inode_operations-const-3 fs/ufs/symlink.c
--- a/fs/ufs/symlink.c~mark-struct-inode_operations-const-3
+++ a/fs/ufs/symlink.c
@@ -36,7 +36,7 @@ static void *ufs_follow_link(struct dent
 	return NULL;
 }
 
-struct inode_operations ufs_fast_symlink_inode_operations = {
+const struct inode_operations ufs_fast_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.follow_link	= ufs_follow_link,
 };
diff -puN fs/ufs/truncate.c~mark-struct-inode_operations-const-3 fs/ufs/truncate.c
--- a/fs/ufs/truncate.c~mark-struct-inode_operations-const-3
+++ a/fs/ufs/truncate.c
@@ -502,6 +502,6 @@ static int ufs_setattr(struct dentry *de
 	return inode_setattr(inode, attr);
 }
 
-struct inode_operations ufs_file_inode_operations = {
+const struct inode_operations ufs_file_inode_operations = {
 	.setattr = ufs_setattr,
 };
diff -puN fs/vfat/namei.c~mark-struct-inode_operations-const-3 fs/vfat/namei.c
--- a/fs/vfat/namei.c~mark-struct-inode_operations-const-3
+++ a/fs/vfat/namei.c
@@ -996,7 +996,7 @@ error_inode:
 	goto out;
 }
 
-static struct inode_operations vfat_dir_inode_operations = {
+static const struct inode_operations vfat_dir_inode_operations = {
 	.create		= vfat_create,
 	.lookup		= vfat_lookup,
 	.unlink		= vfat_unlink,
diff -puN fs/xfs/linux-2.6/xfs_iops.c~mark-struct-inode_operations-const-3 fs/xfs/linux-2.6/xfs_iops.c
--- a/fs/xfs/linux-2.6/xfs_iops.c~mark-struct-inode_operations-const-3
+++ a/fs/xfs/linux-2.6/xfs_iops.c
@@ -815,7 +815,7 @@ xfs_vn_removexattr(
 }
 
 
-struct inode_operations xfs_inode_operations = {
+const struct inode_operations xfs_inode_operations = {
 	.permission		= xfs_vn_permission,
 	.truncate		= xfs_vn_truncate,
 	.getattr		= xfs_vn_getattr,
@@ -826,7 +826,7 @@ struct inode_operations xfs_inode_operat
 	.removexattr		= xfs_vn_removexattr,
 };
 
-struct inode_operations xfs_dir_inode_operations = {
+const struct inode_operations xfs_dir_inode_operations = {
 	.create			= xfs_vn_create,
 	.lookup			= xfs_vn_lookup,
 	.link			= xfs_vn_link,
@@ -845,7 +845,7 @@ struct inode_operations xfs_dir_inode_op
 	.removexattr		= xfs_vn_removexattr,
 };
 
-struct inode_operations xfs_symlink_inode_operations = {
+const struct inode_operations xfs_symlink_inode_operations = {
 	.readlink		= generic_readlink,
 	.follow_link		= xfs_vn_follow_link,
 	.put_link		= xfs_vn_put_link,
diff -puN fs/xfs/linux-2.6/xfs_iops.h~mark-struct-inode_operations-const-3 fs/xfs/linux-2.6/xfs_iops.h
--- a/fs/xfs/linux-2.6/xfs_iops.h~mark-struct-inode_operations-const-3
+++ a/fs/xfs/linux-2.6/xfs_iops.h
@@ -18,9 +18,9 @@
 #ifndef __XFS_IOPS_H__
 #define __XFS_IOPS_H__
 
-extern struct inode_operations xfs_inode_operations;
-extern struct inode_operations xfs_dir_inode_operations;
-extern struct inode_operations xfs_symlink_inode_operations;
+extern const struct inode_operations xfs_inode_operations;
+extern const struct inode_operations xfs_dir_inode_operations;
+extern const struct inode_operations xfs_symlink_inode_operations;
 
 extern const struct file_operations xfs_file_operations;
 extern const struct file_operations xfs_dir_file_operations;
diff -puN include/linux/coda_linux.h~mark-struct-inode_operations-const-3 include/linux/coda_linux.h
--- a/include/linux/coda_linux.h~mark-struct-inode_operations-const-3
+++ a/include/linux/coda_linux.h
@@ -23,9 +23,9 @@
 #include <linux/coda_fs_i.h>
 
 /* operations */
-extern struct inode_operations coda_dir_inode_operations;
-extern struct inode_operations coda_file_inode_operations;
-extern struct inode_operations coda_ioctl_inode_operations;
+extern const struct inode_operations coda_dir_inode_operations;
+extern const struct inode_operations coda_file_inode_operations;
+extern const struct inode_operations coda_ioctl_inode_operations;
 
 extern const struct address_space_operations coda_file_aops;
 extern const struct address_space_operations coda_symlink_aops;
diff -puN include/linux/efs_fs.h~mark-struct-inode_operations-const-3 include/linux/efs_fs.h
--- a/include/linux/efs_fs.h~mark-struct-inode_operations-const-3
+++ a/include/linux/efs_fs.h
@@ -36,7 +36,7 @@ static inline struct efs_sb_info *SUPER_
 
 struct statfs;
 
-extern struct inode_operations efs_dir_inode_operations;
+extern const struct inode_operations efs_dir_inode_operations;
 extern const struct file_operations efs_dir_operations;
 extern const struct address_space_operations efs_symlink_aops;
 
diff -puN include/linux/ext3_fs.h~mark-struct-inode_operations-const-3 include/linux/ext3_fs.h
--- a/include/linux/ext3_fs.h~mark-struct-inode_operations-const-3
+++ a/include/linux/ext3_fs.h
@@ -868,16 +868,16 @@ do {								\
 extern const struct file_operations ext3_dir_operations;
 
 /* file.c */
-extern struct inode_operations ext3_file_inode_operations;
+extern const struct inode_operations ext3_file_inode_operations;
 extern const struct file_operations ext3_file_operations;
 
 /* namei.c */
-extern struct inode_operations ext3_dir_inode_operations;
-extern struct inode_operations ext3_special_inode_operations;
+extern const struct inode_operations ext3_dir_inode_operations;
+extern const struct inode_operations ext3_special_inode_operations;
 
 /* symlink.c */
-extern struct inode_operations ext3_symlink_inode_operations;
-extern struct inode_operations ext3_fast_symlink_inode_operations;
+extern const struct inode_operations ext3_symlink_inode_operations;
+extern const struct inode_operations ext3_fast_symlink_inode_operations;
 
 
 #endif	/* __KERNEL__ */
diff -puN include/linux/ext4_fs.h~mark-struct-inode_operations-const-3 include/linux/ext4_fs.h
--- a/include/linux/ext4_fs.h~mark-struct-inode_operations-const-3
+++ a/include/linux/ext4_fs.h
@@ -955,16 +955,16 @@ do {								\
 extern const struct file_operations ext4_dir_operations;
 
 /* file.c */
-extern struct inode_operations ext4_file_inode_operations;
+extern const struct inode_operations ext4_file_inode_operations;
 extern const struct file_operations ext4_file_operations;
 
 /* namei.c */
-extern struct inode_operations ext4_dir_inode_operations;
-extern struct inode_operations ext4_special_inode_operations;
+extern const struct inode_operations ext4_dir_inode_operations;
+extern const struct inode_operations ext4_special_inode_operations;
 
 /* symlink.c */
-extern struct inode_operations ext4_symlink_inode_operations;
-extern struct inode_operations ext4_fast_symlink_inode_operations;
+extern const struct inode_operations ext4_symlink_inode_operations;
+extern const struct inode_operations ext4_fast_symlink_inode_operations;
 
 /* extents.c */
 extern int ext4_ext_tree_init(handle_t *handle, struct inode *);
diff -puN include/linux/fs.h~mark-struct-inode_operations-const-3 include/linux/fs.h
--- a/include/linux/fs.h~mark-struct-inode_operations-const-3
+++ a/include/linux/fs.h
@@ -552,7 +552,7 @@ struct inode {
 	spinlock_t		i_lock;	/* i_blocks, i_bytes, maybe i_size */
 	struct mutex		i_mutex;
 	struct rw_semaphore	i_alloc_sem;
-	struct inode_operations	*i_op;
+	const struct inode_operations	*i_op;
 	const struct file_operations	*i_fop;	/* former ->i_op->default_file_ops */
 	struct super_block	*i_sb;
 	struct file_lock	*i_flock;
@@ -1882,7 +1882,7 @@ extern void page_put_link(struct dentry 
 extern int __page_symlink(struct inode *inode, const char *symname, int len,
 		gfp_t gfp_mask);
 extern int page_symlink(struct inode *inode, const char *symname, int len);
-extern struct inode_operations page_symlink_inode_operations;
+extern const struct inode_operations page_symlink_inode_operations;
 extern int generic_readlink(struct dentry *, char __user *, int);
 extern void generic_fillattr(struct inode *, struct kstat *);
 extern int vfs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
@@ -1927,7 +1927,7 @@ extern int simple_commit_write(struct fi
 extern struct dentry *simple_lookup(struct inode *, struct dentry *, struct nameidata *);
 extern ssize_t generic_read_dir(struct file *, char __user *, size_t, loff_t *);
 extern const struct file_operations simple_dir_operations;
-extern struct inode_operations simple_dir_inode_operations;
+extern const struct inode_operations simple_dir_inode_operations;
 struct tree_descr { char *name; const struct file_operations *ops; int mode; };
 struct dentry *d_alloc_name(struct dentry *, const char *);
 extern int simple_fill_super(struct super_block *, int, struct tree_descr *);
diff -puN include/linux/msdos_fs.h~mark-struct-inode_operations-const-3 include/linux/msdos_fs.h
--- a/include/linux/msdos_fs.h~mark-struct-inode_operations-const-3
+++ a/include/linux/msdos_fs.h
@@ -234,7 +234,7 @@ struct msdos_sb_info {
 	struct fat_mount_options options;
 	struct nls_table *nls_disk;  /* Codepage used on disk */
 	struct nls_table *nls_io;    /* Charset used for input and display */
-	void *dir_ops;		     /* Opaque; default directory operations */
+	const void *dir_ops;		     /* Opaque; default directory operations */
 	int dir_per_block;	     /* dir entries per block */
 	int dir_per_block_bits;	     /* log2(dir_per_block) */
 
@@ -399,7 +399,7 @@ extern int fat_count_free_clusters(struc
 extern int fat_generic_ioctl(struct inode *inode, struct file *filp,
 			     unsigned int cmd, unsigned long arg);
 extern const struct file_operations fat_file_operations;
-extern struct inode_operations fat_file_inode_operations;
+extern const struct inode_operations fat_file_inode_operations;
 extern int fat_notify_change(struct dentry * dentry, struct iattr * attr);
 extern void fat_truncate(struct inode *inode);
 extern int fat_getattr(struct vfsmount *mnt, struct dentry *dentry,
@@ -413,7 +413,7 @@ extern struct inode *fat_build_inode(str
 			struct msdos_dir_entry *de, loff_t i_pos);
 extern int fat_sync_inode(struct inode *inode);
 extern int fat_fill_super(struct super_block *sb, void *data, int silent,
-			struct inode_operations *fs_dir_inode_ops, int isvfat);
+			const struct inode_operations *fs_dir_inode_ops, int isvfat);
 
 extern int fat_flush_inodes(struct super_block *sb, struct inode *i1,
 		            struct inode *i2);
diff -puN include/linux/ncp_fs.h~mark-struct-inode_operations-const-3 include/linux/ncp_fs.h
--- a/include/linux/ncp_fs.h~mark-struct-inode_operations-const-3
+++ a/include/linux/ncp_fs.h
@@ -204,7 +204,7 @@ void ncp_update_inode(struct inode *, st
 void ncp_update_inode2(struct inode *, struct ncp_entry_info *);
 
 /* linux/fs/ncpfs/dir.c */
-extern struct inode_operations ncp_dir_inode_operations;
+extern const struct inode_operations ncp_dir_inode_operations;
 extern const struct file_operations ncp_dir_operations;
 int ncp_conn_logged_in(struct super_block *);
 int ncp_date_dos2unix(__le16 time, __le16 date);
@@ -226,7 +226,7 @@ void ncp_lock_server(struct ncp_server *
 void ncp_unlock_server(struct ncp_server *server);
 
 /* linux/fs/ncpfs/file.c */
-extern struct inode_operations ncp_file_inode_operations;
+extern const struct inode_operations ncp_file_inode_operations;
 extern const struct file_operations ncp_file_operations;
 int ncp_make_open(struct inode *, int);
 
diff -puN include/linux/nfs_fs.h~mark-struct-inode_operations-const-3 include/linux/nfs_fs.h
--- a/include/linux/nfs_fs.h~mark-struct-inode_operations-const-3
+++ a/include/linux/nfs_fs.h
@@ -330,9 +330,9 @@ static inline void nfs_fattr_init(struct
 /*
  * linux/fs/nfs/file.c
  */
-extern struct inode_operations nfs_file_inode_operations;
+extern const struct inode_operations nfs_file_inode_operations;
 #ifdef CONFIG_NFS_V3
-extern struct inode_operations nfs3_file_inode_operations;
+extern const struct inode_operations nfs3_file_inode_operations;
 #endif /* CONFIG_NFS_V3 */
 extern const struct file_operations nfs_file_operations;
 extern const struct address_space_operations nfs_file_aops;
@@ -379,9 +379,9 @@ extern ssize_t nfs_file_direct_write(str
 /*
  * linux/fs/nfs/dir.c
  */
-extern struct inode_operations nfs_dir_inode_operations;
+extern const struct inode_operations nfs_dir_inode_operations;
 #ifdef CONFIG_NFS_V3
-extern struct inode_operations nfs3_dir_inode_operations;
+extern const struct inode_operations nfs3_dir_inode_operations;
 #endif /* CONFIG_NFS_V3 */
 extern const struct file_operations nfs_dir_operations;
 extern struct dentry_operations nfs_dentry_operations;
@@ -391,7 +391,7 @@ extern int nfs_instantiate(struct dentry
 /*
  * linux/fs/nfs/symlink.c
  */
-extern struct inode_operations nfs_symlink_inode_operations;
+extern const struct inode_operations nfs_symlink_inode_operations;
 
 /*
  * linux/fs/nfs/sysctl.c
@@ -408,8 +408,8 @@ extern void nfs_unregister_sysctl(void);
  * linux/fs/nfs/namespace.c
  */
 extern struct list_head nfs_automount_list;
-extern struct inode_operations nfs_mountpoint_inode_operations;
-extern struct inode_operations nfs_referral_inode_operations;
+extern const struct inode_operations nfs_mountpoint_inode_operations;
+extern const struct inode_operations nfs_referral_inode_operations;
 extern int nfs_mountpoint_expiry_timeout;
 extern void nfs_release_automount_timer(void);
 
diff -puN include/linux/nfs_xdr.h~mark-struct-inode_operations-const-3 include/linux/nfs_xdr.h
--- a/include/linux/nfs_xdr.h~mark-struct-inode_operations-const-3
+++ a/include/linux/nfs_xdr.h
@@ -767,8 +767,8 @@ struct nfs_access_entry;
 struct nfs_rpc_ops {
 	int	version;		/* Protocol version */
 	struct dentry_operations *dentry_ops;
-	struct inode_operations *dir_inode_ops;
-	struct inode_operations *file_inode_ops;
+	const struct inode_operations *dir_inode_ops;
+	const struct inode_operations *file_inode_ops;
 
 	int	(*getroot) (struct nfs_server *, struct nfs_fh *,
 			    struct nfs_fsinfo *);
diff -puN include/linux/phonedev.h~mark-struct-inode_operations-const-3 include/linux/phonedev.h
--- a/include/linux/phonedev.h~mark-struct-inode_operations-const-3
+++ a/include/linux/phonedev.h
@@ -9,7 +9,7 @@
 
 struct phone_device {
 	struct phone_device *next;
-	struct file_operations *f_op;
+	const struct file_operations *f_op;
 	int (*open) (struct phone_device *, struct file *);
 	int board;		/* Device private index */
 	int minor;
diff -puN include/linux/proc_fs.h~mark-struct-inode_operations-const-3 include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~mark-struct-inode_operations-const-3
+++ a/include/linux/proc_fs.h
@@ -55,7 +55,7 @@ struct proc_dir_entry {
 	uid_t uid;
 	gid_t gid;
 	loff_t size;
-	struct inode_operations * proc_iops;
+	const struct inode_operations * proc_iops;
 	const struct file_operations * proc_fops;
 	get_info_t *get_info;
 	struct module *owner;
diff -puN include/linux/qnx4_fs.h~mark-struct-inode_operations-const-3 include/linux/qnx4_fs.h
--- a/include/linux/qnx4_fs.h~mark-struct-inode_operations-const-3
+++ a/include/linux/qnx4_fs.h
@@ -116,8 +116,8 @@ extern unsigned long qnx4_block_map(stru
 
 extern struct buffer_head *qnx4_bread(struct inode *, int, int);
 
-extern struct inode_operations qnx4_file_inode_operations;
-extern struct inode_operations qnx4_dir_inode_operations;
+extern const struct inode_operations qnx4_file_inode_operations;
+extern const struct inode_operations qnx4_dir_inode_operations;
 extern const struct file_operations qnx4_file_operations;
 extern const struct file_operations qnx4_dir_operations;
 extern int qnx4_is_free(struct super_block *sb, long block);
diff -puN include/linux/reiserfs_fs.h~mark-struct-inode_operations-const-3 include/linux/reiserfs_fs.h
--- a/include/linux/reiserfs_fs.h~mark-struct-inode_operations-const-3
+++ a/include/linux/reiserfs_fs.h
@@ -1949,9 +1949,9 @@ int reiserfs_global_version_in_proc(char
 #endif
 
 /* dir.c */
-extern struct inode_operations reiserfs_dir_inode_operations;
-extern struct inode_operations reiserfs_symlink_inode_operations;
-extern struct inode_operations reiserfs_special_inode_operations;
+extern const struct inode_operations reiserfs_dir_inode_operations;
+extern const struct inode_operations reiserfs_symlink_inode_operations;
+extern const struct inode_operations reiserfs_special_inode_operations;
 extern const struct file_operations reiserfs_dir_operations;
 
 /* tail_conversion.c */
@@ -1963,7 +1963,7 @@ int indirect2direct(struct reiserfs_tran
 void reiserfs_unmap_buffer(struct buffer_head *);
 
 /* file.c */
-extern struct inode_operations reiserfs_file_inode_operations;
+extern const struct inode_operations reiserfs_file_inode_operations;
 extern const struct file_operations reiserfs_file_operations;
 extern const struct address_space_operations reiserfs_address_space_operations;
 
diff -puN include/linux/ufs_fs.h~mark-struct-inode_operations-const-3 include/linux/ufs_fs.h
--- a/include/linux/ufs_fs.h~mark-struct-inode_operations-const-3
+++ a/include/linux/ufs_fs.h
@@ -959,7 +959,7 @@ extern struct ufs_cg_private_info * ufs_
 extern void ufs_put_cylinder (struct super_block *, unsigned);
 
 /* dir.c */
-extern struct inode_operations ufs_dir_inode_operations;
+extern const struct inode_operations ufs_dir_inode_operations;
 extern int ufs_add_link (struct dentry *, struct inode *);
 extern ino_t ufs_inode_by_name(struct inode *, struct dentry *);
 extern int ufs_make_empty(struct inode *, struct inode *);
@@ -971,7 +971,7 @@ extern void ufs_set_link(struct inode *d
 			 struct page *page, struct inode *inode);
 
 /* file.c */
-extern struct inode_operations ufs_file_inode_operations;
+extern const struct inode_operations ufs_file_inode_operations;
 extern const struct file_operations ufs_file_operations;
 
 extern const struct address_space_operations ufs_aops;
@@ -998,7 +998,7 @@ extern void ufs_error (struct super_bloc
 extern void ufs_panic (struct super_block *, const char *, const char *, ...) __attribute__ ((format (printf, 3, 4)));
 
 /* symlink.c */
-extern struct inode_operations ufs_fast_symlink_inode_operations;
+extern const struct inode_operations ufs_fast_symlink_inode_operations;
 
 /* truncate.c */
 extern int ufs_truncate (struct inode *, loff_t);
_

Patches currently in -mm which might be from arjan@linux.intel.com are

git-libata-all.patch
git-netdev-all.patch
user-of-the-jiffies-rounding-code-networking.patch
mmconfig-cleanup.patch
mmconfig-fix-unreachable_devices.patch
mark-struct-file_operations-const-1.patch
mark-struct-file_operations-const-2.patch
mark-struct-file_operations-const-3.patch
mark-struct-file_operations-const-4.patch
mark-struct-file_operations-const-5.patch
mark-struct-file_operations-const-6.patch
mark-struct-file_operations-const-7.patch
mark-struct-file_operations-const-8.patch
mark-struct-file_operations-const-9.patch
mark-struct-inode_operations-const-1.patch
mark-struct-inode_operations-const-2.patch
mark-struct-inode_operations-const-3.patch
