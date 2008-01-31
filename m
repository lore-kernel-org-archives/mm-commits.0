From: akpm@linux-foundation.org
Subject: + mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch added to -mm tree
Date: Wed, 30 Jan 2008 16:39:54 -0800
Message-ID: <200801310039.m0V0dsca000400@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34423 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386AbYAaAky (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jan 2008 19:40:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, a.p.zijlstra@chello.nl, trond.myklebust@fys.uio.no


The patch titled
     mm: bdi: expose the BDI object in sysfs for NFS
has been added to the -mm tree.  Its filename is
     mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch

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
Subject: mm: bdi: expose the BDI object in sysfs for NFS
From: Miklos Szeredi <mszeredi@suse.cz>

Register NFS' backing_dev_info under sysfs with the name "nfs-MAJOR:MINOR"

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/super.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff -puN fs/nfs/super.c~mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs fs/nfs/super.c
--- a/fs/nfs/super.c~mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs
+++ a/fs/nfs/super.c
@@ -1462,6 +1462,12 @@ static int nfs_compare_super(struct supe
 	return nfs_compare_mount_options(sb, server, mntflags);
 }
 
+static int nfs_bdi_register(struct nfs_server *server)
+{
+	return bdi_register(&server->backing_dev_info, NULL, "nfs-%u:%u",
+			    MAJOR(server->s_dev), MINOR(server->s_dev));
+}
+
 static int nfs_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *raw_data, struct vfsmount *mnt)
 {
@@ -1502,6 +1508,10 @@ static int nfs_get_sb(struct file_system
 	if (s->s_fs_info != server) {
 		nfs_free_server(server);
 		server = NULL;
+	} else {
+		error = nfs_bdi_register(server);
+		if (error)
+			goto error_splat_super;
 	}
 
 	if (!s->s_root) {
@@ -1542,6 +1552,7 @@ static void nfs_kill_super(struct super_
 {
 	struct nfs_server *server = NFS_SB(s);
 
+	bdi_unregister(&server->backing_dev_info);
 	kill_anon_super(s);
 	nfs_free_server(server);
 }
@@ -1586,6 +1597,10 @@ static int nfs_xdev_get_sb(struct file_s
 	if (s->s_fs_info != server) {
 		nfs_free_server(server);
 		server = NULL;
+	} else {
+		error = nfs_bdi_register(server);
+		if (error)
+			goto error_splat_super;
 	}
 
 	if (!s->s_root) {
@@ -1876,6 +1891,10 @@ static int nfs4_get_sb(struct file_syste
 	if (s->s_fs_info != server) {
 		nfs_free_server(server);
 		server = NULL;
+	} else {
+		error = nfs_bdi_register(server);
+		if (error)
+			goto error_splat_super;
 	}
 
 	if (!s->s_root) {
@@ -1961,6 +1980,10 @@ static int nfs4_xdev_get_sb(struct file_
 	if (s->s_fs_info != server) {
 		nfs_free_server(server);
 		server = NULL;
+	} else {
+		error = nfs_bdi_register(server);
+		if (error)
+			goto error_splat_super;
 	}
 
 	if (!s->s_root) {
@@ -2040,6 +2063,10 @@ static int nfs4_referral_get_sb(struct f
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
vfs-create-proc-pid-mountinfo.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
