From: akpm@linux-foundation.org
Subject: - mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch removed from -mm tree
Date: Thu, 01 May 2008 02:31:41 -0700
Message-ID: <200805010931.m419VfWD030893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757071AbYEAJb6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, a.p.zijlstra@chello.nl, bfields@fieldses.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     mm: bdi: expose the BDI object in sysfs for NFS
has been removed from the -mm tree.  Its filename was
     mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: bdi: expose the BDI object in sysfs for NFS
From: Miklos Szeredi <mszeredi@suse.cz>

Register NFS' backing_dev_info under sysfs with the name "nfs-MAJOR:MINOR"

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/super.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff -puN fs/nfs/super.c~mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs fs/nfs/super.c
--- a/fs/nfs/super.c~mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs
+++ a/fs/nfs/super.c
@@ -1575,6 +1575,11 @@ static int nfs_compare_super(struct supe
 	return nfs_compare_mount_options(sb, server, mntflags);
 }
 
+static int nfs_bdi_register(struct nfs_server *server)
+{
+	return bdi_register_dev(&server->backing_dev_info, server->s_dev);
+}
+
 static int nfs_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *raw_data, struct vfsmount *mnt)
 {
@@ -1617,6 +1622,10 @@ static int nfs_get_sb(struct file_system
 	if (s->s_fs_info != server) {
 		nfs_free_server(server);
 		server = NULL;
+	} else {
+		error = nfs_bdi_register(server);
+		if (error)
+			goto error_splat_super;
 	}
 
 	if (!s->s_root) {
@@ -1664,6 +1673,7 @@ static void nfs_kill_super(struct super_
 {
 	struct nfs_server *server = NFS_SB(s);
 
+	bdi_unregister(&server->backing_dev_info);
 	kill_anon_super(s);
 	nfs_free_server(server);
 }
@@ -1708,6 +1718,10 @@ static int nfs_xdev_get_sb(struct file_s
 	if (s->s_fs_info != server) {
 		nfs_free_server(server);
 		server = NULL;
+	} else {
+		error = nfs_bdi_register(server);
+		if (error)
+			goto error_splat_super;
 	}
 
 	if (!s->s_root) {
@@ -1984,6 +1998,10 @@ static int nfs4_get_sb(struct file_syste
 	if (s->s_fs_info != server) {
 		nfs_free_server(server);
 		server = NULL;
+	} else {
+		error = nfs_bdi_register(server);
+		if (error)
+			goto error_splat_super;
 	}
 
 	if (!s->s_root) {
@@ -2070,6 +2088,10 @@ static int nfs4_xdev_get_sb(struct file_
 	if (s->s_fs_info != server) {
 		nfs_free_server(server);
 		server = NULL;
+	} else {
+		error = nfs_bdi_register(server);
+		if (error)
+			goto error_splat_super;
 	}
 
 	if (!s->s_root) {
@@ -2149,6 +2171,10 @@ static int nfs4_referral_get_sb(struct f
 	if (s->s_fs_info != server) {
 		nfs_free_server(server);
 		server = NULL;
+	} else {
+		error = nfs_bdi_register(server);
+		if (error)
+			goto error_splat_super;
 	}
 
 	if (!s->s_root) {
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
vfs-fix-permission-checking-in-sys_utimensat.patch

