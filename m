From: akpm@linux-foundation.org
Subject: - sunrpc-fix-error-path-in-module_init.patch removed from -mm tree
Date: Wed, 09 May 2007 14:52:59 -0700
Message-ID: <200705092152.l49LqxKI003041@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759470AbXEIVx2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:53:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, neilb@suse.de, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     sunrpc: fix error path in module_init
has been removed from the -mm tree.  Its filename was
     sunrpc-fix-error-path-in-module_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sunrpc: fix error path in module_init
From: Akinobu Mita <akinobu.mita@gmail.com>

register_rpc_pipefs() needs to clean up rpc_inode_cache
by kmem_cache_destroy() on register_filesystem() failure.

init_sunrpc() needs to unregister rpc_pipe_fs by unregister_rpc_pipefs()
when rpc_init_mempool() returns error.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/rpc_pipe.c    |    9 ++++++++-
 net/sunrpc/sunrpc_syms.c |    6 ++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff -puN net/sunrpc/rpc_pipe.c~sunrpc-fix-error-path-in-module_init net/sunrpc/rpc_pipe.c
--- a/net/sunrpc/rpc_pipe.c~sunrpc-fix-error-path-in-module_init
+++ a/net/sunrpc/rpc_pipe.c
@@ -845,6 +845,8 @@ init_once(void * foo, struct kmem_cache 
 
 int register_rpc_pipefs(void)
 {
+	int err;
+
 	rpc_inode_cachep = kmem_cache_create("rpc_inode_cache",
 				sizeof(struct rpc_inode),
 				0, (SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
@@ -852,7 +854,12 @@ int register_rpc_pipefs(void)
 				init_once, NULL);
 	if (!rpc_inode_cachep)
 		return -ENOMEM;
-	register_filesystem(&rpc_pipe_fs_type);
+	err = register_filesystem(&rpc_pipe_fs_type);
+	if (err) {
+		kmem_cache_destroy(rpc_inode_cachep);
+		return err;
+	}
+
 	return 0;
 }
 
diff -puN net/sunrpc/sunrpc_syms.c~sunrpc-fix-error-path-in-module_init net/sunrpc/sunrpc_syms.c
--- a/net/sunrpc/sunrpc_syms.c~sunrpc-fix-error-path-in-module_init
+++ a/net/sunrpc/sunrpc_syms.c
@@ -146,9 +146,11 @@ init_sunrpc(void)
 	int err = register_rpc_pipefs();
 	if (err)
 		goto out;
-	err = rpc_init_mempool() != 0;
-	if (err)
+	err = rpc_init_mempool();
+	if (err) {
+		unregister_rpc_pipefs();
 		goto out;
+	}
 #ifdef RPC_DEBUG
 	rpc_register_sysctl();
 #endif
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
git-alsa.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
fault-injection-disable-stacktrace-filter-for-x86-64.patch
