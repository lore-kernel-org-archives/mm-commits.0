From: akpm@linux-foundation.org
Subject: - knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:46:42 -0800
Message-ID: <200702122246.l1CMkgL3013845@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45297 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030318AbXBLWqy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:46:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chuck.lever@oracle.com, aurelien.charbon@ext.bull.net, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: SUNRPC: Use sockaddr_storage to store address in svc_deferred_req
has been removed from the -mm tree.  Its filename was
     knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: SUNRPC: Use sockaddr_storage to store address in svc_deferred_req
From: Chuck Lever <chuck.lever@oracle.com>

Sockaddr_storage will allow us to store arbitrary socket addresses in the
svc_deferred_req struct.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Aurelien Charbon <aurelien.charbon@ext.bull.net>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sunrpc/svc.h |    5 +++--
 net/sunrpc/svcsock.c       |    6 ++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff -puN include/linux/sunrpc/svc.h~knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req include/linux/sunrpc/svc.h
--- a/include/linux/sunrpc/svc.h~knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req
+++ a/include/linux/sunrpc/svc.h
@@ -292,8 +292,9 @@ static inline void svc_free_res_pages(st
 
 struct svc_deferred_req {
 	u32			prot;	/* protocol (UDP or TCP) */
-	struct sockaddr_in	addr;
-	struct svc_sock		*svsk;	/* where reply must go */
+	struct svc_sock		*svsk;
+	struct sockaddr_storage	addr;	/* where reply must go */
+	size_t			addrlen;
 	__be32			daddr;	/* where reply must come from */
 	struct cache_deferred_req handle;
 	int			argslen;
diff -puN net/sunrpc/svcsock.c~knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req
+++ a/net/sunrpc/svcsock.c
@@ -1785,7 +1785,8 @@ svc_defer(struct cache_req *req)
 
 		dr->handle.owner = rqstp->rq_server;
 		dr->prot = rqstp->rq_prot;
-		dr->addr = rqstp->rq_addr;
+		memcpy(&dr->addr, &rqstp->rq_addr, rqstp->rq_addrlen);
+		dr->addrlen = rqstp->rq_addrlen;
 		dr->daddr = rqstp->rq_daddr;
 		dr->argslen = rqstp->rq_arg.len >> 2;
 		memcpy(dr->args, rqstp->rq_arg.head[0].iov_base-skip, dr->argslen<<2);
@@ -1809,7 +1810,8 @@ static int svc_deferred_recv(struct svc_
 	rqstp->rq_arg.page_len = 0;
 	rqstp->rq_arg.len = dr->argslen<<2;
 	rqstp->rq_prot        = dr->prot;
-	rqstp->rq_addr        = dr->addr;
+	memcpy(&rqstp->rq_addr, &dr->addr, dr->addrlen);
+	rqstp->rq_addrlen     = dr->addrlen;
 	rqstp->rq_daddr       = dr->daddr;
 	rqstp->rq_respages    = rqstp->rq_pages;
 	return dr->argslen<<2;
_

Patches currently in -mm which might be from chuck.lever@oracle.com are

origin.patch
git-nfs.patch
