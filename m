From: akpm@linux-foundation.org
Subject: + mount-options-fix-ncpfs.patch added to -mm tree
Date: Tue, 29 Jan 2008 15:22:48 -0800
Message-ID: <200801292322.m0TNMo9A009734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52231 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754763AbYA2X0Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 18:26:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     mount options: fix ncpfs
has been added to the -mm tree.  Its filename is
     mount-options-fix-ncpfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-x86.patch
fuse-fix-attribute-caching-after-create.patch
fuse-save-space-in-struct-fuse_req.patch
fuse-limit-queued-background-requests.patch
mount-options-add-documentation.patch
mount-options-add-generic_show_options.patch
mount-options-fix-adfs.patch
mount-options-fix-affs.patch
mount-options-fix-afs.patch
mount-options-fix-autofs4.patch
mount-options-fix-autofs.patch
mount-options-fix-befs.patch
mount-options-fix-capifs.patch
mount-options-fix-devpts.patch
mount-options-fix-ext2.patch
mount-options-fix-fat.patch
mount-options-fix-fuse.patch
mount-options-fix-hostfs.patch
mount-options-fix-hpfs.patch
mount-options-fix-hugetlbfs.patch
mount-options-fix-isofs.patch
mount-options-fix-ncpfs.patch
mount-options-fix-reiserfs.patch
mount-options-fix-spufs.patch
mount-options-fix-tmpfs.patch
mount-options-fix-udf.patch
