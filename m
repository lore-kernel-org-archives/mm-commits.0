From: akpm@linux-foundation.org
Subject: - nfs-stop-sillyname-renames-and-unmounts-from-racing-2.patch removed from -mm tree
Date: Mon, 07 Jan 2008 13:39:39 -0800
Message-ID: <200801072139.m07LdJHY013556@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35961 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754094AbYAGVnZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 16:43:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: SteveD@redhat.com, Trond.Myklebust@netapp.com, steved@redhat.com, mm-commits@vger.kernel.org


The patch titled
     NFS: stop sillyname renames and unmounts from racing
has been removed from the -mm tree.  Its filename was
     nfs-stop-sillyname-renames-and-unmounts-from-racing-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: NFS: stop sillyname renames and unmounts from racing
From: Steve Dickson <SteveD@redhat.com>

Added an active/deactive mechanism to the nfs_server structure allowing async
operations to hold off umount until the operations are done.

Signed-off-by: Steve Dickson <steved@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/client.c           |    4 ++++
 fs/nfs/super.c            |   13 +++++++++++++
 fs/nfs/unlink.c           |    2 ++
 include/linux/nfs_fs_sb.h |   17 +++++++++++++++++
 4 files changed, 36 insertions(+)

diff -puN fs/nfs/client.c~nfs-stop-sillyname-renames-and-unmounts-from-racing-2 fs/nfs/client.c
--- a/fs/nfs/client.c~nfs-stop-sillyname-renames-and-unmounts-from-racing-2
+++ a/fs/nfs/client.c
@@ -590,6 +590,10 @@ static int nfs_init_server(struct nfs_se
 	server->namelen  = data->namlen;
 	/* Create a client RPC handle for the NFSv3 ACL management interface */
 	nfs_init_server_aclclient(server);
+
+	init_waitqueue_head(&server->active_wq);
+	atomic_set(&server->active, 0);
+
 	dprintk("<-- nfs_init_server() = 0 [new %p]\n", clp);
 	return 0;
 
diff -puN fs/nfs/super.c~nfs-stop-sillyname-renames-and-unmounts-from-racing-2 fs/nfs/super.c
--- a/fs/nfs/super.c~nfs-stop-sillyname-renames-and-unmounts-from-racing-2
+++ a/fs/nfs/super.c
@@ -202,6 +202,7 @@ static int nfs_get_sb(struct file_system
 static int nfs_xdev_get_sb(struct file_system_type *fs_type,
 		int flags, const char *dev_name, void *raw_data, struct vfsmount *mnt);
 static void nfs_kill_super(struct super_block *);
+static void nfs_put_super(struct super_block *);
 
 static struct file_system_type nfs_fs_type = {
 	.owner		= THIS_MODULE,
@@ -223,6 +224,7 @@ static const struct super_operations nfs
 	.alloc_inode	= nfs_alloc_inode,
 	.destroy_inode	= nfs_destroy_inode,
 	.write_inode	= nfs_write_inode,
+	.put_super	= nfs_put_super,
 	.statfs		= nfs_statfs,
 	.clear_inode	= nfs_clear_inode,
 	.umount_begin	= nfs_umount_begin,
@@ -1774,6 +1776,17 @@ static void nfs4_kill_super(struct super
 	nfs_free_server(server);
 }
 
+static void nfs_put_super(struct super_block *sb)
+{
+	struct nfs_server *server = NFS_SB(sb);
+	/*
+	 * Make sure there are no outstanding ops to this server.
+	 * If so, wait for them to finish before allowing the
+	 * unmount to continue.
+	 */
+	wait_event(server->active_wq, atomic_read(&server->active) == 0);
+}
+
 /*
  * Clone an NFS4 server record on xdev traversal (FSID-change)
  */
diff -puN fs/nfs/unlink.c~nfs-stop-sillyname-renames-and-unmounts-from-racing-2 fs/nfs/unlink.c
--- a/fs/nfs/unlink.c~nfs-stop-sillyname-renames-and-unmounts-from-racing-2
+++ a/fs/nfs/unlink.c
@@ -29,6 +29,7 @@ struct nfs_unlinkdata {
 static void
 nfs_free_unlinkdata(struct nfs_unlinkdata *data)
 {
+	nfs_sb_deactive(NFS_SERVER(data->dir));
 	iput(data->dir);
 	put_rpccred(data->cred);
 	kfree(data->args.name.name);
@@ -151,6 +152,7 @@ static int nfs_do_call_unlink(struct den
 		nfs_dec_sillycount(dir);
 		return 0;
 	}
+	nfs_sb_active(NFS_SERVER(dir));
 	data->args.fh = NFS_FH(dir);
 	nfs_fattr_init(&data->res.dir_attr);
 
diff -puN include/linux/nfs_fs_sb.h~nfs-stop-sillyname-renames-and-unmounts-from-racing-2 include/linux/nfs_fs_sb.h
--- a/include/linux/nfs_fs_sb.h~nfs-stop-sillyname-renames-and-unmounts-from-racing-2
+++ a/include/linux/nfs_fs_sb.h
@@ -4,6 +4,8 @@
 #include <linux/list.h>
 #include <linux/backing-dev.h>
 
+#include <asm/atomic.h>
+
 struct nfs_iostats;
 
 /*
@@ -110,8 +112,23 @@ struct nfs_server {
 						   filesystem */
 #endif
 	void (*destroy)(struct nfs_server *);
+
+	atomic_t active; /* Keep trace of any activity to this server */
+	wait_queue_head_t active_wq;  /* Wait for any activity to stop  */
 };
 
+static inline void
+nfs_sb_active(struct nfs_server *server)
+{
+	atomic_inc(&server->active);
+}
+static inline void
+nfs_sb_deactive(struct nfs_server *server)
+{
+	if (atomic_dec_and_test(&server->active))
+		wake_up(&server->active_wq);
+}
+
 /* Server capabilities */
 #define NFS_CAP_READDIRPLUS	(1U << 0)
 #define NFS_CAP_HARDLINKS	(1U << 1)
_

Patches currently in -mm which might be from SteveD@redhat.com are

git-nfs.patch
