From: akpm@osdl.org
Subject: + knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch added to -mm tree
Date: Tue, 12 Dec 2006 17:36:09 -0800
Message-ID: <200612130136.kBD1a9mm024085@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38703 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964876AbWLMBjy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 20:39:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chuck.lever@oracle.com, aurelien.charbon@ext.bull.net, neilb@suse.de


The patch titled
     knfsd: SUNRPC: Use sockaddr_storage to store address in svc_deferred_req
has been added to the -mm tree.  Its filename is
     knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: SUNRPC: Use sockaddr_storage to store address in svc_deferred_req
From: Chuck Lever <chuck.lever@oracle.com>

Sockaddr_storage will allow us to store arbitrary socket addresses in the
svc_deferred_req struct.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Aurelien Charbon <aurelien.charbon@ext.bull.net>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/sunrpc/svc.h |    3 ++-
 net/sunrpc/svcsock.c       |    6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN include/linux/sunrpc/svc.h~knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req include/linux/sunrpc/svc.h
--- a/include/linux/sunrpc/svc.h~knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req
+++ a/include/linux/sunrpc/svc.h
@@ -289,7 +289,8 @@ static inline void svc_free_res_pages(st
 
 struct svc_deferred_req {
 	u32			prot;	/* protocol (UDP or TCP) */
-	struct sockaddr_in	addr;
+	struct sockaddr_storage	addr;
+	int			addrlen;
 	struct svc_sock		*svsk;	/* where reply must go */
 	__be32			daddr;	/* where reply must come from */
 	struct cache_deferred_req handle;
diff -puN net/sunrpc/svcsock.c~knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req
+++ a/net/sunrpc/svcsock.c
@@ -1713,7 +1713,8 @@ svc_defer(struct cache_req *req)
 
 		dr->handle.owner = rqstp->rq_server;
 		dr->prot = rqstp->rq_prot;
-		dr->addr = rqstp->rq_addr;
+		memcpy(&dr->addr, &rqstp->rq_addr, rqstp->rq_addrlen);
+		dr->addrlen = rqstp->rq_addrlen;
 		dr->daddr = rqstp->rq_daddr;
 		dr->argslen = rqstp->rq_arg.len >> 2;
 		memcpy(dr->args, rqstp->rq_arg.head[0].iov_base-skip, dr->argslen<<2);
@@ -1737,7 +1738,8 @@ static int svc_deferred_recv(struct svc_
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
knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch
knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch
knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch
knfsd-sunrpc-dont-set-msg_name-and-msg_namelen-when-calling-sock_recvmsg.patch
knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch
knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing.patch
knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses.patch
knfsd-sunrpc-make-rq_daddr-field-address-version-independent.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses.patch
knfsd-sunrpc-add-a-generic-function-to-see-if-the-peer-uses-a-secure-port.patch
knfsd-sunrpc-support-ipv6-addresses-in-svc_tcp_accept.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path.patch
knfsd-sunrpc-fix-up-svc_create_socket-to-take-a-sockaddr-struct-length.patch

