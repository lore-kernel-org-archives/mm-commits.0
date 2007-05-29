From: akpm@linux-foundation.org
Subject: - nfs-remake-nfsroot_mount-as-a-permanent-part-of-nfs-client.patch removed from -mm tree
Date: Tue, 29 May 2007 09:29:00 -0700
Message-ID: <200705291628.l4TGSx2R005465@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753704AbXE2Q3w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 12:29:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chuck.lever@oracle.com, bfields@fieldses.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     NFS: remake nfsroot_mount as a permanent part of NFS client
has been removed from the -mm tree.  Its filename was
     nfs-remake-nfsroot_mount-as-a-permanent-part-of-nfs-client.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: NFS: remake nfsroot_mount as a permanent part of NFS client
From: Chuck Lever <chuck.lever@oracle.com>

In preparation for supporting NFSv2 and NFSv3 mount option handling in the
kernel NFS client, convert mount_clnt.c to be a permanent part of the NFS
client, instead of built only when CONFIG_ROOT_NFS is enabled.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/Makefile        |    4 ++--
 fs/nfs/mount_clnt.c    |   18 +++++++++++++-----
 fs/nfs/nfsroot.c       |    2 +-
 include/linux/nfs_fs.h |    4 +---
 4 files changed, 17 insertions(+), 11 deletions(-)

diff -puN fs/nfs/Makefile~nfs-remake-nfsroot_mount-as-a-permanent-part-of-nfs-client fs/nfs/Makefile
--- a/fs/nfs/Makefile~nfs-remake-nfsroot_mount-as-a-permanent-part-of-nfs-client
+++ a/fs/nfs/Makefile
@@ -6,8 +6,8 @@ obj-$(CONFIG_NFS_FS) += nfs.o
 
 nfs-y 			:= client.o dir.o file.o getroot.o inode.o super.o nfs2xdr.o \
 			   pagelist.o proc.o read.o symlink.o unlink.o \
-			   write.o namespace.o
-nfs-$(CONFIG_ROOT_NFS)	+= nfsroot.o mount_clnt.o      
+			   write.o namespace.o mount_clnt.o
+nfs-$(CONFIG_ROOT_NFS)	+= nfsroot.o
 nfs-$(CONFIG_NFS_V3)	+= nfs3proc.o nfs3xdr.o
 nfs-$(CONFIG_NFS_V3_ACL)	+= nfs3acl.o
 nfs-$(CONFIG_NFS_V4)	+= nfs4proc.o nfs4xdr.o nfs4state.o nfs4renewd.o \
diff -puN fs/nfs/mount_clnt.c~nfs-remake-nfsroot_mount-as-a-permanent-part-of-nfs-client fs/nfs/mount_clnt.c
--- a/fs/nfs/mount_clnt.c~nfs-remake-nfsroot_mount-as-a-permanent-part-of-nfs-client
+++ a/fs/nfs/mount_clnt.c
@@ -37,12 +37,20 @@ struct mnt_fhstatus {
 	struct nfs_fh *		fh;
 };
 
-/*
- * Obtain an NFS file handle for the given host and path
+/**
+ * nfs_mount - Obtain an NFS file handle for the given host and path
+ * @addr: pointer to server's address
+ * @path: pointer to string containing export path to mount
+ * @fh: pointer to location to place returned file handle
+ * @version: mount version to use for this request
+ * @protocol: transport protocol to use for thie request
+ *
+ * Uses default timeout parameters specified by underlying transport.
+ *
+ * XXX: Needs to support IPv6
  */
-int
-nfsroot_mount(struct sockaddr_in *addr, char *path, struct nfs_fh *fh,
-		int version, int protocol)
+int nfs_mount(struct sockaddr_in *addr, char *path, struct nfs_fh *fh,
+	      int version, int protocol)
 {
 	struct rpc_clnt		*mnt_clnt;
 	struct mnt_fhstatus	result = {
diff -puN fs/nfs/nfsroot.c~nfs-remake-nfsroot_mount-as-a-permanent-part-of-nfs-client fs/nfs/nfsroot.c
--- a/fs/nfs/nfsroot.c~nfs-remake-nfsroot_mount-as-a-permanent-part-of-nfs-client
+++ a/fs/nfs/nfsroot.c
@@ -496,7 +496,7 @@ static int __init root_nfs_get_handle(vo
 					NFS_MNT3_VERSION : NFS_MNT_VERSION;
 
 	set_sockaddr(&sin, servaddr, htons(mount_port));
-	status = nfsroot_mount(&sin, nfs_path, &fh, version, protocol);
+	status = nfs_mount(&sin, nfs_path, &fh, version, protocol);
 	if (status < 0)
 		printk(KERN_ERR "Root-NFS: Server returned error %d "
 				"while mounting %s\n", status, nfs_path);
diff -puN include/linux/nfs_fs.h~nfs-remake-nfsroot_mount-as-a-permanent-part-of-nfs-client include/linux/nfs_fs.h
--- a/include/linux/nfs_fs.h~nfs-remake-nfsroot_mount-as-a-permanent-part-of-nfs-client
+++ a/include/linux/nfs_fs.h
@@ -497,10 +497,8 @@ static inline void nfs3_forget_cached_ac
 
 /*
  * linux/fs/mount_clnt.c
- * (Used only by nfsroot module)
  */
-extern int  nfsroot_mount(struct sockaddr_in *, char *, struct nfs_fh *,
-		int, int);
+extern int  nfs_mount(struct sockaddr_in *, char *, struct nfs_fh *, int, int);
 
 /*
  * inline functions
_

Patches currently in -mm which might be from chuck.lever@oracle.com are

git-nfs.patch
nfs-refactor-ip-address-sanity-checks-in-nfs-client.patch
nfs-remake-nfsroot_mount-as-a-permanent-part-of-nfs-client.patch
nfs-clean-up-in-kernel-nfs-mount.patch
nfs-improve-debugging-output-in-nfs-in-kernel-mount-client.patch
nfs-new-infrastructure-for-nfs-client-in-kernel-mount-option-parsing.patch
nfs-add-functions-to-parse-nfs-mount-options-to-fs-nfs-superc.patch
nfs-implement-nfsv2-3-in-kernel-mount-option-parsing.patch
nfs-add-functions-to-parse-nfs4-mount-options-to-fs-nfs-superc.patch
nfs-move-nfs_copy_user_string.patch
nfs-more-nfs4-in-kernel-mount-option-parsing-infrastructure.patch
nfs-integrate-support-for-processing-nfs4-mount-options-in-fs-nfs-superc.patch
