From: akpm@linux-foundation.org
Subject: + sunrpc-rename-rpcb_getport-to-be-consistent-with-new-rpcb_getport_sync-name.patch added to -mm tree
Date: Mon, 21 May 2007 14:41:12 -0700
Message-ID: <200705212141.l4LLfCDQ020692@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57299 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755185AbXEUVnr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 17:43:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chuck.lever@oracle.com, bfields@fieldses.org, trond.myklebust@fys.uio.no


The patch titled
     SUNRPC: rename rpcb_getport to be consistent with new rpcb_getport_sync name
has been added to the -mm tree.  Its filename is
     sunrpc-rename-rpcb_getport-to-be-consistent-with-new-rpcb_getport_sync-name.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SUNRPC: rename rpcb_getport to be consistent with new rpcb_getport_sync name
From: Chuck Lever <chuck.lever@oracle.com>

Clean up, for consistency.  Rename rpcb_getport as rpcb_getport_async, to
match the naming scheme of rpcb_getport_sync.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sunrpc/clnt.h |    2 -
 net/sunrpc/rpcb_clnt.c      |   37 +++++++++++++++++-----------------
 net/sunrpc/xprtsock.c       |    4 +--
 3 files changed, 22 insertions(+), 21 deletions(-)

diff -puN include/linux/sunrpc/clnt.h~sunrpc-rename-rpcb_getport-to-be-consistent-with-new-rpcb_getport_sync-name include/linux/sunrpc/clnt.h
--- a/include/linux/sunrpc/clnt.h~sunrpc-rename-rpcb_getport-to-be-consistent-with-new-rpcb_getport_sync-name
+++ a/include/linux/sunrpc/clnt.h
@@ -124,8 +124,8 @@ int		rpc_destroy_client(struct rpc_clnt 
 void		rpc_release_client(struct rpc_clnt *);
 
 int		rpcb_register(u32, u32, int, unsigned short, int *);
-void		rpcb_getport(struct rpc_task *);
 int		rpcb_getport_sync(struct sockaddr_in *, __u32, __u32, int);
+void		rpcb_getport_async(struct rpc_task *);
 
 void		rpc_call_setup(struct rpc_task *, struct rpc_message *, int);
 
diff -puN net/sunrpc/rpcb_clnt.c~sunrpc-rename-rpcb_getport-to-be-consistent-with-new-rpcb_getport_sync-name net/sunrpc/rpcb_clnt.c
--- a/net/sunrpc/rpcb_clnt.c~sunrpc-rename-rpcb_getport-to-be-consistent-with-new-rpcb_getport_sync-name
+++ a/net/sunrpc/rpcb_clnt.c
@@ -298,13 +298,13 @@ int rpcb_getport_sync(struct sockaddr_in
 EXPORT_SYMBOL_GPL(rpcb_getport_sync);
 
 /**
- * rpcb_getport - obtain the port for a given RPC service on a given host
+ * rpcb_getport_async - obtain the port for a given RPC service on a given host
  * @task: task that is waiting for portmapper request
  *
  * This one can be called for an ongoing RPC request, and can be used in
  * an async (rpciod) context.
  */
-void rpcb_getport(struct rpc_task *task)
+void rpcb_getport_async(struct rpc_task *task)
 {
 	struct rpc_clnt *clnt = task->tk_client;
 	int bind_version;
@@ -315,17 +315,17 @@ void rpcb_getport(struct rpc_task *task)
 	struct sockaddr addr;
 	int status;
 
-	dprintk("RPC: %5u rpcb_getport(%s, %u, %u, %d)\n",
-			task->tk_pid, clnt->cl_server,
-			clnt->cl_prog, clnt->cl_vers, xprt->prot);
+	dprintk("RPC: %5u %s(%s, %u, %u, %d)\n",
+		task->tk_pid, __FUNCTION__,
+		clnt->cl_server, clnt->cl_prog, clnt->cl_vers, xprt->prot);
 
 	/* Autobind on cloned rpc clients is discouraged */
 	BUG_ON(clnt->cl_parent != clnt);
 
 	if (xprt_test_and_set_binding(xprt)) {
 		status = -EACCES;		/* tell caller to check again */
-		dprintk("RPC: %5u rpcb_getport waiting for another binder\n",
-				task->tk_pid);
+		dprintk("RPC: %5u %s: waiting for another binder\n",
+			task->tk_pid, __FUNCTION__);
 		goto bailout_nowake;
 	}
 
@@ -336,27 +336,28 @@ void rpcb_getport(struct rpc_task *task)
 	/* Someone else may have bound if we slept */
 	if (xprt_bound(xprt)) {
 		status = 0;
-		dprintk("RPC: %5u rpcb_getport already bound\n", task->tk_pid);
+		dprintk("RPC: %5u %s: already bound\n",
+			task->tk_pid, __FUNCTION__);
 		goto bailout_nofree;
 	}
 
 	if (rpcb_next_version[xprt->bind_index].rpc_proc == NULL) {
 		xprt->bind_index = 0;
 		status = -EACCES;	/* tell caller to try again later */
-		dprintk("RPC: %5u rpcb_getport no more getport versions "
-				"available\n", task->tk_pid);
+ 		dprintk("RPC: %5u %s: no more getport versions available\n",
+ 			task->tk_pid, __FUNCTION__);
 		goto bailout_nofree;
 	}
 	bind_version = rpcb_next_version[xprt->bind_index].rpc_vers;
 
-	dprintk("RPC: %5u rpcb_getport trying rpcbind version %u\n",
-			task->tk_pid, bind_version);
+ 	dprintk("RPC: %5u %s: trying rpcbind version %u\n",
+ 		task->tk_pid, __FUNCTION__, bind_version);
 
 	map = kzalloc(sizeof(struct rpcbind_args), GFP_ATOMIC);
 	if (!map) {
 		status = -ENOMEM;
-		dprintk("RPC: %5u rpcb_getport no memory available\n",
-				task->tk_pid);
+ 		dprintk("RPC: %5u %s: no memory available\n",
+ 			task->tk_pid, __FUNCTION__);
 		goto bailout_nofree;
 	}
 	map->r_prog = clnt->cl_prog;
@@ -374,16 +375,16 @@ void rpcb_getport(struct rpc_task *task)
 	rpcb_clnt = rpcb_create(clnt->cl_server, &addr, xprt->prot, bind_version, 0);
 	if (IS_ERR(rpcb_clnt)) {
 		status = PTR_ERR(rpcb_clnt);
-		dprintk("RPC: %5u rpcb_getport rpcb_create failed, error %ld\n",
-				task->tk_pid, PTR_ERR(rpcb_clnt));
+		dprintk("RPC: %5u %s: rpcb_create failed, error %ld\n",
+			task->tk_pid, __FUNCTION__, PTR_ERR(rpcb_clnt));
 		goto bailout;
 	}
 
 	child = rpc_run_task(rpcb_clnt, RPC_TASK_ASYNC, &rpcb_getport_ops, map);
 	if (IS_ERR(child)) {
 		status = -EIO;
-		dprintk("RPC: %5u rpcb_getport rpc_run_task failed\n",
-				task->tk_pid);
+		dprintk("RPC: %5u %s: rpc_run_task failed\n",
+			task->tk_pid, __FUNCTION__);
 		goto bailout_nofree;
 	}
 	rpc_put_task(child);
diff -puN net/sunrpc/xprtsock.c~sunrpc-rename-rpcb_getport-to-be-consistent-with-new-rpcb_getport_sync-name net/sunrpc/xprtsock.c
--- a/net/sunrpc/xprtsock.c~sunrpc-rename-rpcb_getport-to-be-consistent-with-new-rpcb_getport_sync-name
+++ a/net/sunrpc/xprtsock.c
@@ -1476,7 +1476,7 @@ static struct rpc_xprt_ops xs_udp_ops = 
 	.set_buffer_size	= xs_udp_set_buffer_size,
 	.reserve_xprt		= xprt_reserve_xprt_cong,
 	.release_xprt		= xprt_release_xprt_cong,
-	.rpcbind		= rpcb_getport,
+	.rpcbind		= rpcb_getport_async,
 	.set_port		= xs_set_port,
 	.connect		= xs_connect,
 	.buf_alloc		= rpc_malloc,
@@ -1493,7 +1493,7 @@ static struct rpc_xprt_ops xs_udp_ops = 
 static struct rpc_xprt_ops xs_tcp_ops = {
 	.reserve_xprt		= xprt_reserve_xprt,
 	.release_xprt		= xs_tcp_release_xprt,
-	.rpcbind		= rpcb_getport,
+	.rpcbind		= rpcb_getport_async,
 	.set_port		= xs_set_port,
 	.connect		= xs_connect,
 	.buf_alloc		= rpc_malloc,
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
