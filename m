From: akpm@linux-foundation.org
Subject: - nfs-improve-debugging-output-in-nfs-in-kernel-mount-client.patch removed from -mm tree
Date: Tue, 29 May 2007 09:29:04 -0700
Message-ID: <200705291629.l4TGT3sn005473@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751485AbXE2Q33 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 12:29:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chuck.lever@oracle.com, bfields@fieldses.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     NFS: improve debugging output in NFS in-kernel mount client
has been removed from the -mm tree.  Its filename was
     nfs-improve-debugging-output-in-nfs-in-kernel-mount-client.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: NFS: improve debugging output in NFS in-kernel mount client
From: Chuck Lever <chuck.lever@oracle.com>

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/mount_clnt.c    |   18 +++++++++++++-----
 include/linux/nfs_fs.h |    1 +
 2 files changed, 14 insertions(+), 5 deletions(-)

diff -puN fs/nfs/mount_clnt.c~nfs-improve-debugging-output-in-nfs-in-kernel-mount-client fs/nfs/mount_clnt.c
--- a/fs/nfs/mount_clnt.c~nfs-improve-debugging-output-in-nfs-in-kernel-mount-client
+++ a/fs/nfs/mount_clnt.c
@@ -16,7 +16,7 @@
 #include <linux/nfs_fs.h>
 
 #ifdef RPC_DEBUG
-# define NFSDBG_FACILITY	NFSDBG_ROOT
+# define NFSDBG_FACILITY	NFSDBG_MOUNT
 #endif
 
 static struct rpc_program	mnt_program;
@@ -72,8 +72,8 @@ int nfs_mount(struct sockaddr_in *addr, 
 	char			hostname[32];
 	int			status;
 
-	dprintk("NFS:      nfs_mount(%08x:%s)\n",
-			(unsigned)ntohl(addr->sin_addr.s_addr), path);
+	dprintk("NFS: %s: mounting" NIPQUAD_FMT ":%s\n",
+		__FUNCTION__, NIPQUAD(addr->sin_addr.s_addr), path);
 
 	sprintf(hostname, NIPQUAD_FMT, NIPQUAD(addr->sin_addr.s_addr));
 	mnt_clnt = mnt_create(hostname, addr, version, protocol);
@@ -86,10 +86,18 @@ int nfs_mount(struct sockaddr_in *addr, 
 		msg.rpc_proc = &mnt_clnt->cl_procinfo[MNTPROC_MNT];
 
 	status = rpc_call_sync(mnt_clnt, &msg, 0);
-	if (status < 0)
+	if (status < 0) {
+		dprintk("NFS: %s: rpc_call_sync returned %d\n",
+			__FUNCTION__, status);
 		return status;
-	if (result.status != 0)
+	}
+	if (result.status != 0) {
+		dprintk("NFS: %s: server returned %d\n",
+			__FUNCTION__, result.status);
 		return -EACCES;
+	}
+	dprintk("NFS: %s: mount request succeeded\n",
+		__FUNCTION__);
 	return 0;
 }
 
diff -puN include/linux/nfs_fs.h~nfs-improve-debugging-output-in-nfs-in-kernel-mount-client include/linux/nfs_fs.h
--- a/include/linux/nfs_fs.h~nfs-improve-debugging-output-in-nfs-in-kernel-mount-client
+++ a/include/linux/nfs_fs.h
@@ -556,6 +556,7 @@ extern void * nfs_root_data(void);
 #define NFSDBG_ROOT		0x0080
 #define NFSDBG_CALLBACK		0x0100
 #define NFSDBG_CLIENT		0x0200
+#define NFSDBG_MOUNT		0x0400
 #define NFSDBG_ALL		0xFFFF
 
 #ifdef __KERNEL__
_

Patches currently in -mm which might be from chuck.lever@oracle.com are

git-nfs.patch
nfs-refactor-ip-address-sanity-checks-in-nfs-client.patch
nfs-improve-debugging-output-in-nfs-in-kernel-mount-client.patch
nfs-new-infrastructure-for-nfs-client-in-kernel-mount-option-parsing.patch
nfs-add-functions-to-parse-nfs-mount-options-to-fs-nfs-superc.patch
nfs-implement-nfsv2-3-in-kernel-mount-option-parsing.patch
nfs-add-functions-to-parse-nfs4-mount-options-to-fs-nfs-superc.patch
nfs-move-nfs_copy_user_string.patch
nfs-more-nfs4-in-kernel-mount-option-parsing-infrastructure.patch
nfs-integrate-support-for-processing-nfs4-mount-options-in-fs-nfs-superc.patch
