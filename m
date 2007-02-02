From: akpm@linux-foundation.org
Subject: + nlm-fix-double-free-in-__nlm_async_call.patch added to -mm tree
Date: Fri, 02 Feb 2007 15:59:03 -0800
Message-ID: <200702022359.l12Nx3x0021359@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45401 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933390AbXBBX7N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 18:59:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Trond.Myklebust@netapp.com, kas@fi.muni.cz, neilb@suse.de


The patch titled
     NLM: Fix double free in __nlm_async_call
has been added to the -mm tree.  Its filename is
     nlm-fix-double-free-in-__nlm_async_call.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NLM: Fix double free in __nlm_async_call
From: Trond Myklebust <Trond.Myklebust@netapp.com>

rpc_call_async() will always call rpc_release_calldata(), so it is an
error for __nlm_async_call() to do so as well.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=7923

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Jan "Yenya" Kasprzak <kas@fi.muni.cz>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/lockd/clntproc.c |    9 +++------
 fs/lockd/svclock.c  |    4 +---
 2 files changed, 4 insertions(+), 9 deletions(-)

diff -puN fs/lockd/clntproc.c~nlm-fix-double-free-in-__nlm_async_call fs/lockd/clntproc.c
--- a/fs/lockd/clntproc.c~nlm-fix-double-free-in-__nlm_async_call
+++ a/fs/lockd/clntproc.c
@@ -361,7 +361,6 @@ static int __nlm_async_call(struct nlm_r
 {
 	struct nlm_host	*host = req->a_host;
 	struct rpc_clnt	*clnt;
-	int status = -ENOLCK;
 
 	dprintk("lockd: call procedure %d on %s (async)\n",
 			(int)proc, host->h_name);
@@ -373,12 +372,10 @@ static int __nlm_async_call(struct nlm_r
 	msg->rpc_proc = &clnt->cl_procinfo[proc];
 
         /* bootstrap and kick off the async RPC call */
-        status = rpc_call_async(clnt, msg, RPC_TASK_ASYNC, tk_ops, req);
-	if (status == 0)
-		return 0;
+        return rpc_call_async(clnt, msg, RPC_TASK_ASYNC, tk_ops, req);
 out_err:
-	nlm_release_call(req);
-	return status;
+	tk_ops->rpc_release(req);
+	return -ENOLCK;
 }
 
 int nlm_async_call(struct nlm_rqst *req, u32 proc, const struct rpc_call_ops *tk_ops)
diff -puN fs/lockd/svclock.c~nlm-fix-double-free-in-__nlm_async_call fs/lockd/svclock.c
--- a/fs/lockd/svclock.c~nlm-fix-double-free-in-__nlm_async_call
+++ a/fs/lockd/svclock.c
@@ -593,9 +593,7 @@ callback:
 
 	/* Call the client */
 	kref_get(&block->b_count);
-	if (nlm_async_call(block->b_call, NLMPROC_GRANTED_MSG,
-						&nlmsvc_grant_ops) < 0)
-		nlmsvc_release_block(block);
+	nlm_async_call(block->b_call, NLMPROC_GRANTED_MSG, &nlmsvc_grant_ops);
 }
 
 /*
_

Patches currently in -mm which might be from Trond.Myklebust@netapp.com are

auth_gss-unregister-gss_domain-when-unloading-module.patch
nfs-kill-the-obsolete-nfs_paranoia.patch
nlm-fix-double-free-in-__nlm_async_call.patch
