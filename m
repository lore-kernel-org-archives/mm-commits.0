From: akpm@linux-foundation.org
Subject: - mount-options-fix-hostfs.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:19:57 -0800
Message-ID: <200802082019.m18KJcMj011074@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42496 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935486AbYBHUiL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:38:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     mount options: fix hostfs
has been removed from the -mm tree.  Its filename was
     mount-options-fix-hostfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mount options: fix hostfs
From: Miklos Szeredi <mszeredi@suse.cz>

Add the "host path" option to /proc/mounts for UML hostfs filesystems.

The mount source (mnt_devname) should really be used for this, but not
easy to change now in a backward compatible way.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hostfs/hostfs_kern.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN fs/hostfs/hostfs_kern.c~mount-options-fix-hostfs fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~mount-options-fix-hostfs
+++ a/fs/hostfs/hostfs_kern.c
@@ -11,6 +11,7 @@
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/statfs.h>
+#include <linux/seq_file.h>
 #include "hostfs.h"
 #include "init.h"
 #include "kern.h"
@@ -322,12 +323,25 @@ static void hostfs_destroy_inode(struct 
 	kfree(HOSTFS_I(inode));
 }
 
+static int hostfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
+{
+	struct inode *root = vfs->mnt_sb->s_root->d_inode;
+	const char *root_path = HOSTFS_I(root)->host_filename;
+	size_t offset = strlen(root_ino) + 1;
+
+	if (strlen(root_path) > offset)
+		seq_printf(seq, ",%s", root_path + offset);
+
+	return 0;
+}
+
 static const struct super_operations hostfs_sbops = {
 	.alloc_inode	= hostfs_alloc_inode,
 	.drop_inode	= generic_delete_inode,
 	.delete_inode   = hostfs_delete_inode,
 	.destroy_inode	= hostfs_destroy_inode,
 	.statfs		= hostfs_statfs,
+	.show_options	= hostfs_show_options,
 };
 
 int hostfs_readdir(struct file *file, void *ent, filldir_t filldir)
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
vfs-create-proc-pid-mountinfo.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-2.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-3.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse-fix.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch
mm-bdi-move-statistics-to-debugfs.patch
