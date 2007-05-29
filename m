From: akpm@linux-foundation.org
Subject: - nfs-clean-up-in-kernel-nfs-mount.patch removed from -mm tree
Date: Tue, 29 May 2007 09:29:02 -0700
Message-ID: <200705291629.l4TGT1BJ005468@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753786AbXE2Q35 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 12:29:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chuck.lever@oracle.com, bfields@fieldses.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     NFS: clean up in-kernel NFS mount
has been removed from the -mm tree.  Its filename was
     nfs-clean-up-in-kernel-nfs-mount.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: NFS: clean up in-kernel NFS mount
From: Chuck Lever <chuck.lever@oracle.com>

Clean up white space and coding conventions.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/mount_clnt.c |  132 ++++++++++++++++++++----------------------
 1 files changed, 63 insertions(+), 69 deletions(-)

diff -puN fs/nfs/mount_clnt.c~nfs-clean-up-in-kernel-nfs-mount fs/nfs/mount_clnt.c
--- a/fs/nfs/mount_clnt.c~nfs-clean-up-in-kernel-nfs-mount
+++ a/fs/nfs/mount_clnt.c
@@ -1,7 +1,5 @@
 /*
- * linux/fs/nfs/mount_clnt.c
- *
- * MOUNT client to support NFSroot.
+ * In-kernel MOUNT protocol client
  *
  * Copyright (C) 1997, Olaf Kirch <okir@monad.swb.de>
  */
@@ -21,22 +19,33 @@
 # define NFSDBG_FACILITY	NFSDBG_ROOT
 #endif
 
-/*
-#define MOUNT_PROGRAM		100005
-#define MOUNT_VERSION		1
-#define MOUNT_MNT		1
-#define MOUNT_UMNT		3
- */
-
-static struct rpc_clnt *	mnt_create(char *, struct sockaddr_in *,
-								int, int);
 static struct rpc_program	mnt_program;
 
 struct mnt_fhstatus {
-	unsigned int		status;
-	struct nfs_fh *		fh;
+	u32 status;
+	struct nfs_fh *fh;
 };
 
+static struct rpc_clnt *mnt_create(char *hostname,
+				   struct sockaddr_in *srvaddr,
+				   int version,
+				   int protocol)
+{
+	struct rpc_create_args args = {
+		.protocol	= protocol,
+		.address	= (struct sockaddr *)srvaddr,
+		.addrsize	= sizeof(*srvaddr),
+		.servername	= hostname,
+		.program	= &mnt_program,
+		.version	= version,
+		.authflavor	= RPC_AUTH_UNIX,
+		.flags		= (RPC_CLNT_CREATE_ONESHOT |
+				   RPC_CLNT_CREATE_INTR),
+	};
+
+	return rpc_create(&args);
+}
+
 /**
  * nfs_mount - Obtain an NFS file handle for the given host and path
  * @addr: pointer to server's address
@@ -66,7 +75,7 @@ int nfs_mount(struct sockaddr_in *addr, 
 	dprintk("NFS:      nfs_mount(%08x:%s)\n",
 			(unsigned)ntohl(addr->sin_addr.s_addr), path);
 
-	sprintf(hostname, "%u.%u.%u.%u", NIPQUAD(addr->sin_addr.s_addr));
+	sprintf(hostname, NIPQUAD_FMT, NIPQUAD(addr->sin_addr.s_addr));
 	mnt_clnt = mnt_create(hostname, addr, version, protocol);
 	if (IS_ERR(mnt_clnt))
 		return PTR_ERR(mnt_clnt);
@@ -77,33 +86,18 @@ int nfs_mount(struct sockaddr_in *addr, 
 		msg.rpc_proc = &mnt_clnt->cl_procinfo[MNTPROC_MNT];
 
 	status = rpc_call_sync(mnt_clnt, &msg, 0);
-	return status < 0? status : (result.status? -EACCES : 0);
-}
-
-static struct rpc_clnt *
-mnt_create(char *hostname, struct sockaddr_in *srvaddr, int version,
-		int protocol)
-{
-	struct rpc_create_args args = {
-		.protocol	= protocol,
-		.address	= (struct sockaddr *)srvaddr,
-		.addrsize	= sizeof(*srvaddr),
-		.servername	= hostname,
-		.program	= &mnt_program,
-		.version	= version,
-		.authflavor	= RPC_AUTH_UNIX,
-		.flags		= (RPC_CLNT_CREATE_ONESHOT |
-				   RPC_CLNT_CREATE_INTR),
-	};
-
-	return rpc_create(&args);
+	if (status < 0)
+		return status;
+	if (result.status != 0)
+		return -EACCES;
+	return 0;
 }
 
 /*
  * XDR encode/decode functions for MOUNT
  */
-static int
-xdr_encode_dirpath(struct rpc_rqst *req, __be32 *p, const char *path)
+static int xdr_encode_dirpath(struct rpc_rqst *req, __be32 *p,
+			      const char *path)
 {
 	p = xdr_encode_string(p, path);
 
@@ -111,8 +105,8 @@ xdr_encode_dirpath(struct rpc_rqst *req,
 	return 0;
 }
 
-static int
-xdr_decode_fhstatus(struct rpc_rqst *req, __be32 *p, struct mnt_fhstatus *res)
+static int xdr_decode_fhstatus(struct rpc_rqst *req, __be32 *p,
+			       struct mnt_fhstatus *res)
 {
 	struct nfs_fh *fh = res->fh;
 
@@ -123,8 +117,8 @@ xdr_decode_fhstatus(struct rpc_rqst *req
 	return 0;
 }
 
-static int
-xdr_decode_fhstatus3(struct rpc_rqst *req, __be32 *p, struct mnt_fhstatus *res)
+static int xdr_decode_fhstatus3(struct rpc_rqst *req, __be32 *p,
+				struct mnt_fhstatus *res)
 {
 	struct nfs_fh *fh = res->fh;
 
@@ -143,53 +137,53 @@ xdr_decode_fhstatus3(struct rpc_rqst *re
 #define MNT_fhstatus_sz		(1 + 8)
 #define MNT_fhstatus3_sz	(1 + 16)
 
-static struct rpc_procinfo	mnt_procedures[] = {
-[MNTPROC_MNT] = {
-	  .p_proc		= MNTPROC_MNT,
-	  .p_encode		= (kxdrproc_t) xdr_encode_dirpath,	
-	  .p_decode		= (kxdrproc_t) xdr_decode_fhstatus,
-	  .p_arglen		= MNT_dirpath_sz,
-	  .p_replen		= MNT_fhstatus_sz,
-	  .p_statidx		= MNTPROC_MNT,
-	  .p_name		= "MOUNT",
+static struct rpc_procinfo mnt_procedures[] = {
+	[MNTPROC_MNT] = {
+		.p_proc		= MNTPROC_MNT,
+		.p_encode	= (kxdrproc_t) xdr_encode_dirpath,
+		.p_decode	= (kxdrproc_t) xdr_decode_fhstatus,
+		.p_arglen	= MNT_dirpath_sz,
+		.p_replen	= MNT_fhstatus_sz,
+		.p_statidx	= MNTPROC_MNT,
+		.p_name		= "MOUNT",
 	},
 };
 
 static struct rpc_procinfo mnt3_procedures[] = {
-[MOUNTPROC3_MNT] = {
-	  .p_proc		= MOUNTPROC3_MNT,
-	  .p_encode		= (kxdrproc_t) xdr_encode_dirpath,
-	  .p_decode		= (kxdrproc_t) xdr_decode_fhstatus3,
-	  .p_arglen		= MNT_dirpath_sz,
-	  .p_replen		= MNT_fhstatus3_sz,
-	  .p_statidx		= MOUNTPROC3_MNT,
-	  .p_name		= "MOUNT",
+	[MOUNTPROC3_MNT] = {
+		.p_proc		= MOUNTPROC3_MNT,
+		.p_encode	= (kxdrproc_t) xdr_encode_dirpath,
+		.p_decode	= (kxdrproc_t) xdr_decode_fhstatus3,
+		.p_arglen	= MNT_dirpath_sz,
+		.p_replen	= MNT_fhstatus3_sz,
+		.p_statidx	= MOUNTPROC3_MNT,
+		.p_name		= "MOUNT",
 	},
 };
 
 
-static struct rpc_version	mnt_version1 = {
-		.number		= 1,
-		.nrprocs 	= 2,
-		.procs 		= mnt_procedures
+static struct rpc_version mnt_version1 = {
+	.number		= 1,
+	.nrprocs	= 2,
+	.procs		= mnt_procedures,
 };
 
-static struct rpc_version       mnt_version3 = {
-		.number		= 3,
-		.nrprocs	= 2,
-		.procs		= mnt3_procedures
+static struct rpc_version mnt_version3 = {
+	.number		= 3,
+	.nrprocs	= 2,
+	.procs		= mnt3_procedures,
 };
 
-static struct rpc_version *	mnt_version[] = {
+static struct rpc_version *mnt_version[] = {
 	NULL,
 	&mnt_version1,
 	NULL,
 	&mnt_version3,
 };
 
-static struct rpc_stat		mnt_stats;
+static struct rpc_stat mnt_stats;
 
-static struct rpc_program	mnt_program = {
+static struct rpc_program mnt_program = {
 	.name		= "mount",
 	.number		= NFS_MNT_PROGRAM,
 	.nrvers		= ARRAY_SIZE(mnt_version),
_

Patches currently in -mm which might be from chuck.lever@oracle.com are

git-nfs.patch
nfs-refactor-ip-address-sanity-checks-in-nfs-client.patch
nfs-clean-up-in-kernel-nfs-mount.patch
nfs-improve-debugging-output-in-nfs-in-kernel-mount-client.patch
nfs-new-infrastructure-for-nfs-client-in-kernel-mount-option-parsing.patch
nfs-add-functions-to-parse-nfs-mount-options-to-fs-nfs-superc.patch
nfs-implement-nfsv2-3-in-kernel-mount-option-parsing.patch
nfs-add-functions-to-parse-nfs4-mount-options-to-fs-nfs-superc.patch
nfs-move-nfs_copy_user_string.patch
nfs-more-nfs4-in-kernel-mount-option-parsing-infrastructure.patch
nfs-integrate-support-for-processing-nfs4-mount-options-in-fs-nfs-superc.patch
