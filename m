From: akpm@linux-foundation.org
Subject: + ramfs-add-support-for-mode=-mount-option.patch added to -mm tree
Date: Wed, 11 Mar 2009 13:59:26 -0700
Message-ID: <200903112059.n2BKxQDL003303@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751990AbZCKVAy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 17:00:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, matimatik@gmail.com


The patch titled
     ramfs: add support for "mode=" mount option
has been added to the -mm tree.  Its filename is
     ramfs-add-support-for-mode=-mount-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ramfs: add support for "mode=" mount option
From: Wu Fengguang <fengguang.wu@intel.com>

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=12843

"I use ramfs instead of tmpfs for /tmp because I don't use swap on my
laptop.  Some apps need 1777 mode for /tmp directory, but ramfs does not
support 'mode=' mount option."

Reported-by: Avan Anishchuk <matimatik@gmail.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/inode.c |   94 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 86 insertions(+), 8 deletions(-)

diff -puN fs/ramfs/inode.c~ramfs-add-support-for-mode=-mount-option fs/ramfs/inode.c
--- a/fs/ramfs/inode.c~ramfs-add-support-for-mode=-mount-option
+++ a/fs/ramfs/inode.c
@@ -33,12 +33,15 @@
 #include <linux/backing-dev.h>
 #include <linux/ramfs.h>
 #include <linux/sched.h>
+#include <linux/parser.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
 /* some random number */
 #define RAMFS_MAGIC	0x858458f6
 
+#define RAMFS_DEFAULT_MODE	0755
+
 static const struct super_operations ramfs_ops;
 static const struct inode_operations ramfs_dir_inode_operations;
 
@@ -158,12 +161,75 @@ static const struct inode_operations ram
 static const struct super_operations ramfs_ops = {
 	.statfs		= simple_statfs,
 	.drop_inode	= generic_delete_inode,
+	.show_options	= generic_show_options,
+};
+
+struct ramfs_mount_opts {
+	umode_t mode;
+};
+
+enum {
+	Opt_mode,
+	Opt_err
+};
+
+static const match_table_t tokens = {
+	{Opt_mode, "mode=%o"},
+	{Opt_err, NULL}
 };
 
+struct ramfs_fs_info {
+	struct ramfs_mount_opts mount_opts;
+};
+
+static int ramfs_parse_options(char *data, struct ramfs_mount_opts *opts)
+{
+	substring_t args[MAX_OPT_ARGS];
+	int option;
+	int token;
+	char *p;
+
+	opts->mode = RAMFS_DEFAULT_MODE;
+
+	while ((p = strsep(&data, ",")) != NULL) {
+		if (!*p)
+			continue;
+
+		token = match_token(p, tokens, args);
+		switch (token) {
+		case Opt_mode:
+			if (match_octal(&args[0], &option))
+				return -EINVAL;
+			opts->mode = option & S_IALLUGO;
+			break;
+		default:
+			printk(KERN_ERR "ramfs: bad mount option: %s\n", p);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static int ramfs_fill_super(struct super_block * sb, void * data, int silent)
 {
-	struct inode * inode;
-	struct dentry * root;
+	struct ramfs_fs_info *fsi;
+	struct inode *inode = NULL;
+	struct dentry *root;
+	int err;
+
+	save_mount_options(sb, data);
+
+	fsi = kzalloc(sizeof(struct ramfs_fs_info), GFP_KERNEL);
+	if (!fsi) {
+		err = -ENOMEM;
+		goto fail;
+	}
+	sb->s_fs_info = fsi;
+
+	err = ramfs_parse_options(data, &fsi->mount_opts);
+	if (err)
+		goto fail;
 
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_blocksize = PAGE_CACHE_SIZE;
@@ -171,17 +237,23 @@ static int ramfs_fill_super(struct super
 	sb->s_magic = RAMFS_MAGIC;
 	sb->s_op = &ramfs_ops;
 	sb->s_time_gran = 1;
-	inode = ramfs_get_inode(sb, S_IFDIR | 0755, 0);
-	if (!inode)
-		return -ENOMEM;
+	inode = ramfs_get_inode(sb, S_IFDIR | fsi->mount_opts.mode, 0);
+	if (!inode) {
+		err = -ENOMEM;
+		goto fail;
+	}
 
 	root = d_alloc_root(inode);
 	if (!root) {
-		iput(inode);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto fail;
 	}
 	sb->s_root = root;
 	return 0;
+fail:
+	kfree(fsi);
+	iput(inode);
+	return err;
 }
 
 int ramfs_get_sb(struct file_system_type *fs_type,
@@ -197,10 +269,16 @@ static int rootfs_get_sb(struct file_sys
 			    mnt);
 }
 
+static void ramfs_kill_sb(struct super_block *sb)
+{
+	kfree(sb->s_fs_info);
+	kill_litter_super(sb);
+}
+
 static struct file_system_type ramfs_fs_type = {
 	.name		= "ramfs",
 	.get_sb		= ramfs_get_sb,
-	.kill_sb	= kill_litter_super,
+	.kill_sb	= ramfs_kill_sb,
 };
 static struct file_system_type rootfs_fs_type = {
 	.name		= "rootfs",
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

proc-fix-kflags-to-uflags-copying-in-proc-kpageflags.patch
linux-next.patch
ramfs-add-support-for-mode=-mount-option.patch

