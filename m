From: akpm@linux-foundation.org
Subject: - sunrpc-rename-rpcb_getport_external-routine.patch removed from -mm tree
Date: Tue, 29 May 2007 09:28:50 -0700
Message-ID: <200705291628.l4TGSpK6005408@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751471AbXE2Q3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 12:29:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chuck.lever@oracle.com, bfields@fieldses.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     SUNRPC: rename rpcb_getport_external routine
has been removed from the -mm tree.  Its filename was
     sunrpc-rename-rpcb_getport_external-routine.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: SUNRPC: rename rpcb_getport_external routine
From: Chuck Lever <chuck.lever@oracle.com>

In preparation for handling NFS mount option parsing in the kernel, rename
rpcb_getport_external as rpcb_get_port_sync, and make it available always
(instead of only when CONFIG_ROOT_NFS is enabled).

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/nfsroot.c            |    2 +-
 include/linux/sunrpc/clnt.h |    7 ++-----
 net/sunrpc/rpcb_clnt.c      |   21 +++++++++++----------
 3 files changed, 14 insertions(+), 16 deletions(-)

diff -puN fs/nfs/nfsroot.c~sunrpc-rename-rpcb_getport_external-routine fs/nfs/nfsroot.c
--- a/fs/nfs/nfsroot.c~sunrpc-rename-rpcb_getport_external-routine
+++ a/fs/nfs/nfsroot.c
@@ -428,7 +428,7 @@ static int __init root_nfs_getport(int p
 	printk(KERN_NOTICE "Looking up port of RPC %d/%d on %u.%u.%u.%u\n",
 		program, version, NIPQUAD(servaddr));
 	set_sockaddr(&sin, servaddr, 0);
-	return rpcb_getport_external(&sin, program, version, proto);
+	return rpcb_getport_sync(&sin, program, version, proto);
 }
 
 
diff -puN include/linux/sunrpc/clnt.h~sunrpc-rename-rpcb_getport_external-routine include/linux/sunrpc/clnt.h
--- a/include/linux/sunrpc/clnt.h~sunrpc-rename-rpcb_getport_external-routine
+++ a/include/linux/sunrpc/clnt.h
@@ -122,8 +122,10 @@ struct rpc_clnt *rpc_clone_client(struct
 int		rpc_shutdown_client(struct rpc_clnt *);
 int		rpc_destroy_client(struct rpc_clnt *);
 void		rpc_release_client(struct rpc_clnt *);
+
 int		rpcb_register(u32, u32, int, unsigned short, int *);
 void		rpcb_getport(struct rpc_task *);
+int		rpcb_getport_sync(struct sockaddr_in *, __u32, __u32, int);
 
 void		rpc_call_setup(struct rpc_task *, struct rpc_message *, int);
 
@@ -142,10 +144,5 @@ int		rpc_ping(struct rpc_clnt *clnt, int
 size_t		rpc_peeraddr(struct rpc_clnt *, struct sockaddr *, size_t);
 char *		rpc_peeraddr2str(struct rpc_clnt *, enum rpc_display_format_t);
 
-/*
- * Helper function for NFSroot support
- */
-int		rpcb_getport_external(struct sockaddr_in *, __u32, __u32, int);
-
 #endif /* __KERNEL__ */
 #endif /* _LINUX_SUNRPC_CLNT_H */
diff -puN net/sunrpc/rpcb_clnt.c~sunrpc-rename-rpcb_getport_external-routine net/sunrpc/rpcb_clnt.c
--- a/net/sunrpc/rpcb_clnt.c~sunrpc-rename-rpcb_getport_external-routine
+++ a/net/sunrpc/rpcb_clnt.c
@@ -12,6 +12,8 @@
  *  Copyright (C) 1996, Olaf Kirch <okir@monad.swb.de>
  */
 
+#include <linux/module.h>
+
 #include <linux/types.h>
 #include <linux/socket.h>
 #include <linux/kernel.h>
@@ -246,21 +248,20 @@ int rpcb_register(u32 prog, u32 vers, in
 	return error;
 }
 
-#ifdef CONFIG_ROOT_NFS
 /**
- * rpcb_getport_external - obtain the port for an RPC service on a given host
+ * rpcb_getport_sync - obtain the port for an RPC service on a given host
  * @sin: address of remote peer
  * @prog: RPC program number to bind
  * @vers: RPC version number to bind
  * @prot: transport protocol to use to make this request
  *
  * Called from outside the RPC client in a synchronous task context.
+ * Uses default timeout parameters specified by underlying transport.
  *
- * For now, this supports only version 2 queries, but is used only by
- * mount_clnt for NFS_ROOT.
+ * XXX: Needs to support IPv6, and rpcbind versions 3 and 4
  */
-int rpcb_getport_external(struct sockaddr_in *sin, __u32 prog,
-				__u32 vers, int prot)
+int rpcb_getport_sync(struct sockaddr_in *sin, __u32 prog,
+		      __u32 vers, int prot)
 {
 	struct rpcbind_args map = {
 		.r_prog		= prog,
@@ -277,10 +278,10 @@ int rpcb_getport_external(struct sockadd
 	char hostname[40];
 	int status;
 
-	dprintk("RPC:       rpcb_getport_external(%u.%u.%u.%u, %u, %u, %d)\n",
-			NIPQUAD(sin->sin_addr.s_addr), prog, vers, prot);
+	dprintk("RPC:       %s(" NIPQUAD_FMT ", %u, %u, %d)\n",
+		__FUNCTION__, NIPQUAD(sin->sin_addr.s_addr), prog, vers, prot);
 
-	sprintf(hostname, "%u.%u.%u.%u", NIPQUAD(sin->sin_addr.s_addr));
+	sprintf(hostname, NIPQUAD_FMT, NIPQUAD(sin->sin_addr.s_addr));
 	rpcb_clnt = rpcb_create(hostname, (struct sockaddr *)sin, prot, 2, 0);
 	if (IS_ERR(rpcb_clnt))
 		return PTR_ERR(rpcb_clnt);
@@ -294,7 +295,7 @@ int rpcb_getport_external(struct sockadd
 	}
 	return status;
 }
-#endif
+EXPORT_SYMBOL_GPL(rpcb_getport_sync);
 
 /**
  * rpcb_getport - obtain the port for a given RPC service on a given host
_

Patches currently in -mm which might be from chuck.lever@oracle.com are

git-nfs.patch
nfs-refactor-ip-address-sanity-checks-in-nfs-client.patch
sunrpc-rename-rpcb_getport_external-routine.patch
sunrpc-rename-rpcb_getport-to-be-consistent-with-new-rpcb_getport_sync-name.patch
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
