From: akpm@linux-foundation.org
Subject: - knfsd-sunrpc-make-rq_daddr-field-address-version-independent.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:46:46 -0800
Message-ID: <200702122246.l1CMkkYT013851@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45306 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030324AbXBLWq4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:46:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chuck.lever@oracle.com, aurelien.charbon@ext.bull.net, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: SUNRPC: Make rq_daddr field address-version independent
has been removed from the -mm tree.  Its filename was
     knfsd-sunrpc-make-rq_daddr-field-address-version-independent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: SUNRPC: Make rq_daddr field address-version independent
From: Chuck Lever <chuck.lever@oracle.com>

The rq_daddr field must support larger addresses.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Aurelien Charbon <aurelien.charbon@ext.bull.net>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sunrpc/svc.h |   15 +++++++++++----
 net/sunrpc/svcsock.c       |    4 ++--
 2 files changed, 13 insertions(+), 6 deletions(-)

diff -puN include/linux/sunrpc/svc.h~knfsd-sunrpc-make-rq_daddr-field-address-version-independent include/linux/sunrpc/svc.h
--- a/include/linux/sunrpc/svc.h~knfsd-sunrpc-make-rq_daddr-field-address-version-independent
+++ a/include/linux/sunrpc/svc.h
@@ -11,6 +11,7 @@
 #define SUNRPC_SVC_H
 
 #include <linux/in.h>
+#include <linux/in6.h>
 #include <linux/sunrpc/types.h>
 #include <linux/sunrpc/xdr.h>
 #include <linux/sunrpc/auth.h>
@@ -191,7 +192,13 @@ static inline void svc_putu32(struct kve
 	iov->iov_len += sizeof(__be32);
 }
 
-	
+union svc_addr_u {
+    struct in_addr	addr;
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+    struct in6_addr	addr6;
+#endif
+};
+
 /*
  * The context of a single thread, including the request currently being
  * processed.
@@ -227,8 +234,8 @@ struct svc_rqst {
 	unsigned short
 				rq_secure  : 1;	/* secure port */
 
-
-	__be32			rq_daddr;	/* dest addr of request - reply from here */
+	union svc_addr_u	rq_daddr;	/* dest addr of request
+						 *  - reply from here */
 
 	void *			rq_argp;	/* decoded arguments */
 	void *			rq_resp;	/* xdr'd results */
@@ -308,7 +315,7 @@ struct svc_deferred_req {
 	struct svc_sock		*svsk;
 	struct sockaddr_storage	addr;	/* where reply must go */
 	size_t			addrlen;
-	__be32			daddr;	/* where reply must come from */
+	union svc_addr_u	daddr;	/* where reply must come from */
 	struct cache_deferred_req handle;
 	int			argslen;
 	__be32			args[0];
diff -puN net/sunrpc/svcsock.c~knfsd-sunrpc-make-rq_daddr-field-address-version-independent net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~knfsd-sunrpc-make-rq_daddr-field-address-version-independent
+++ a/net/sunrpc/svcsock.c
@@ -484,7 +484,7 @@ svc_sendto(struct svc_rqst *rqstp, struc
 		cmh->cmsg_level = SOL_IP;
 		cmh->cmsg_type = IP_PKTINFO;
 		pki->ipi_ifindex = 0;
-		pki->ipi_spec_dst.s_addr = rqstp->rq_daddr;
+		pki->ipi_spec_dst.s_addr = rqstp->rq_daddr.addr.s_addr;
 
 		if (sock_sendmsg(sock, &msg, 0) < 0)
 			goto out;
@@ -763,7 +763,7 @@ svc_udp_recvfrom(struct svc_rqst *rqstp)
 	rqstp->rq_addrlen = sizeof(struct sockaddr_in);
 
 	/* Remember which interface received this request */
-	rqstp->rq_daddr = skb->nh.iph->daddr;
+	rqstp->rq_daddr.addr.s_addr = skb->nh.iph->daddr;
 
 	if (skb_is_nonlinear(skb)) {
 		/* we have to copy */
_

Patches currently in -mm which might be from chuck.lever@oracle.com are

origin.patch
git-nfs.patch
