From: akpm@linux-foundation.org
Subject: - mount-options-fix-ncpfs.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:20:07 -0800
Message-ID: <200802082019.m18KJmsd011086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54703 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752076AbYBHUc0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:32:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     mount options: fix ncpfs
has been removed from the -mm tree.  Its filename was
     mount-options-fix-ncpfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mount options: fix ncpfs
From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to ncpfs.

Small fix: add FS_BINARY_MOUNTDATA to the filesystem type flags, since
it can take binary data, as well as text (similarly to NFS).

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/inode.c |   49 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 45 insertions(+), 4 deletions(-)

diff -puN fs/ncpfs/inode.c~mount-options-fix-ncpfs fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~mount-options-fix-ncpfs
+++ a/fs/ncpfs/inode.c
@@ -28,6 +28,8 @@
 #include <linux/init.h>
 #include <linux/smp_lock.h>
 #include <linux/vfs.h>
+#include <linux/mount.h>
+#include <linux/seq_file.h>
 
 #include <linux/ncp_fs.h>
 
@@ -36,9 +38,15 @@
 #include "ncplib_kernel.h"
 #include "getopt.h"
 
+#define NCP_DEFAULT_FILE_MODE 0600
+#define NCP_DEFAULT_DIR_MODE 0700
+#define NCP_DEFAULT_TIME_OUT 10
+#define NCP_DEFAULT_RETRY_COUNT 20
+
 static void ncp_delete_inode(struct inode *);
 static void ncp_put_super(struct super_block *);
 static int  ncp_statfs(struct dentry *, struct kstatfs *);
+static int  ncp_show_options(struct seq_file *, struct vfsmount *);
 
 static struct kmem_cache * ncp_inode_cachep;
 
@@ -96,6 +104,7 @@ static const struct super_operations ncp
 	.put_super	= ncp_put_super,
 	.statfs		= ncp_statfs,
 	.remount_fs	= ncp_remount,
+	.show_options	= ncp_show_options,
 };
 
 extern struct dentry_operations ncp_root_dentry_operations;
@@ -304,6 +313,37 @@ static void ncp_stop_tasks(struct ncp_se
 	flush_scheduled_work();
 }
 
+static int  ncp_show_options(struct seq_file *seq, struct vfsmount *mnt)
+{
+	struct ncp_server *server = NCP_SBP(mnt->mnt_sb);
+	unsigned int tmp;
+
+	if (server->m.uid != 0)
+		seq_printf(seq, ",uid=%u", server->m.uid);
+	if (server->m.gid != 0)
+		seq_printf(seq, ",gid=%u", server->m.gid);
+	if (server->m.mounted_uid != 0)
+		seq_printf(seq, ",owner=%u", server->m.mounted_uid);
+	tmp = server->m.file_mode & S_IALLUGO;
+	if (tmp != NCP_DEFAULT_FILE_MODE)
+		seq_printf(seq, ",mode=0%o", tmp);
+	tmp = server->m.dir_mode & S_IALLUGO;
+	if (tmp != NCP_DEFAULT_DIR_MODE)
+		seq_printf(seq, ",dirmode=0%o", tmp);
+	if (server->m.time_out != NCP_DEFAULT_TIME_OUT * HZ / 100) {
+		tmp = server->m.time_out * 100 / HZ;
+		seq_printf(seq, ",timeout=%u", tmp);
+	}
+	if (server->m.retry_count != NCP_DEFAULT_RETRY_COUNT)
+		seq_printf(seq, ",retry=%u", server->m.retry_count);
+	if (server->m.flags != 0)
+		seq_printf(seq, ",flags=%lu", server->m.flags);
+	if (server->m.wdog_pid != NULL)
+		seq_printf(seq, ",wdogpid=%u", pid_vnr(server->m.wdog_pid));
+
+	return 0;
+}
+
 static const struct ncp_option ncp_opts[] = {
 	{ "uid",	OPT_INT,	'u' },
 	{ "gid",	OPT_INT,	'g' },
@@ -331,12 +371,12 @@ static int ncp_parse_options(struct ncp_
 	data->mounted_uid = 0;
 	data->wdog_pid = NULL;
 	data->ncp_fd = ~0;
-	data->time_out = 10;
-	data->retry_count = 20;
+	data->time_out = NCP_DEFAULT_TIME_OUT;
+	data->retry_count = NCP_DEFAULT_RETRY_COUNT;
 	data->uid = 0;
 	data->gid = 0;
-	data->file_mode = 0600;
-	data->dir_mode = 0700;
+	data->file_mode = NCP_DEFAULT_FILE_MODE;
+	data->dir_mode = NCP_DEFAULT_DIR_MODE;
 	data->info_fd = -1;
 	data->mounted_vol[0] = 0;
 	
@@ -982,6 +1022,7 @@ static struct file_system_type ncp_fs_ty
 	.name		= "ncpfs",
 	.get_sb		= ncp_get_sb,
 	.kill_sb	= kill_anon_super,
+	.fs_flags	= FS_BINARY_MOUNTDATA,
 };
 
 static int __init init_ncp_fs(void)
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
