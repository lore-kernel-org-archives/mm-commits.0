From: akpm@linux-foundation.org
Subject: - rpc-fix-double-free-in-portmapper-code.patch removed from -mm tree
Date: Mon, 05 Feb 2007 12:33:33 -0800
Message-ID: <200702052033.l15KXXdD030352@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60465 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933122AbXBEUez (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 15:34:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Trond.Myklebust@netapp.com, kas@fi.muni.cz, neilb@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     RPM:  fix double free in portmapper code
has been removed from the -mm tree.  Its filename was
     rpc-fix-double-free-in-portmapper-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: RPM:  fix double free in portmapper code
From: Trond Myklebust <Trond.Myklebust@netapp.com>

rpc_run_task is guaranteed to always call ->rpc_release.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Jan "Yenya" Kasprzak <kas@fi.muni.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/pmap_clnt.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN net/sunrpc/pmap_clnt.c~rpc-fix-double-free-in-portmapper-code net/sunrpc/pmap_clnt.c
--- a/net/sunrpc/pmap_clnt.c~rpc-fix-double-free-in-portmapper-code
+++ a/net/sunrpc/pmap_clnt.c
@@ -62,7 +62,10 @@ static inline void pmap_map_free(struct 
 
 static void pmap_map_release(void *data)
 {
-	pmap_map_free(data);
+	struct portmap_args *map = data;
+
+	xprt_put(map->pm_xprt);
+	pmap_map_free(map);
 }
 
 static const struct rpc_call_ops pmap_getport_ops = {
@@ -133,7 +136,7 @@ void rpc_getport(struct rpc_task *task)
 	status = -EIO;
 	child = rpc_run_task(pmap_clnt, RPC_TASK_ASYNC, &pmap_getport_ops, map);
 	if (IS_ERR(child))
-		goto bailout;
+		goto bailout_nofree;
 	rpc_put_task(child);
 
 	task->tk_xprt->stat.bind_count++;
@@ -222,7 +225,6 @@ static void pmap_getport_done(struct rpc
 			child->tk_pid, status, map->pm_port);
 
 	pmap_wake_portmap_waiters(xprt, status);
-	xprt_put(xprt);
 }
 
 /**
_

Patches currently in -mm which might be from Trond.Myklebust@netapp.com are

rpc-fix-double-free-in-portmapper-code.patch
nlm-fix-double-free-in-__nlm_async_call.patch
git-nfs.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
nfs-kill-the-obsolete-nfs_paranoia.patch
