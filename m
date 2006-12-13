From: akpm@osdl.org
Subject: + knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path.patch added to -mm tree
Date: Tue, 12 Dec 2006 17:36:23 -0800
Message-ID: <200612130136.kBD1aNJ9024113@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38702 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964874AbWLMBjx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 20:39:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chuck.lever@oracle.com, aurelien.charbon@ext.bull.net, neilb@suse.de


The patch titled
     knfsd: SUNRPC: support IPv6 addresses in RPC server's UDP receive path
has been added to the -mm tree.  Its filename is
     knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: SUNRPC: support IPv6 addresses in RPC server's UDP receive path
From: Chuck Lever <chuck.lever@oracle.com>

Add support for IPv6 addresses in the RPC server's UDP receive path.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Aurelien Charbon <aurelien.charbon@ext.bull.net>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/sunrpc/svc.h |    5 +++
 net/sunrpc/svcsock.c       |   49 +++++++++++++++++++++++++++++------
 2 files changed, 46 insertions(+), 8 deletions(-)

diff -puN include/linux/sunrpc/svc.h~knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path include/linux/sunrpc/svc.h
--- a/include/linux/sunrpc/svc.h~knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path
+++ a/include/linux/sunrpc/svc.h
@@ -267,6 +267,11 @@ static inline struct sockaddr_in *svc_ad
 	return (struct sockaddr_in *) &rqst->rq_addr;
 }
 
+static inline struct sockaddr_in6 *svc_addr_in6(struct svc_rqst *rqst)
+{
+	return (struct sockaddr_in6 *) &rqst->rq_addr;
+}
+
 static inline struct sockaddr *svc_addr(struct svc_rqst *rqst)
 {
 	return (struct sockaddr *) &rqst->rq_addr;
diff -puN net/sunrpc/svcsock.c~knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path
+++ a/net/sunrpc/svcsock.c
@@ -717,13 +717,51 @@ svc_write_space(struct sock *sk)
 	}
 }
 
+static void svc_udp_get_sender_address(struct svc_rqst *rqstp,
+					struct sk_buff *skb)
+{
+	switch (rqstp->rq_sock->sk_sk->sk_family) {
+	case AF_INET:
+		/* this seems to come from net/ipv4/udp.c:udp_recvmsg */
+		do {
+			struct sockaddr_in *sin = svc_addr_in(rqstp);
+
+			sin->sin_family = AF_INET;
+			sin->sin_port = skb->h.uh->source;
+			sin->sin_addr.s_addr = skb->nh.iph->saddr;
+			rqstp->rq_daddr.addr.s_addr = skb->nh.iph->daddr;
+		} while (0);
+		break;
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+	case AF_INET6:
+		/* this is derived from net/ipv6/udp.c:udpv6_recvmesg */
+		do {
+			struct sockaddr_in6 *sin6 = svc_addr_in6(rqstp);
+
+			sin6->sin6_family = AF_INET6;
+			sin6->sin6_port = skb->h.uh->source;
+			sin6->sin6_flowinfo = 0;
+			sin6->sin6_scope_id = 0;
+			if (ipv6_addr_type(&sin6->sin6_addr) &
+							IPV6_ADDR_LINKLOCAL)
+				sin6->sin6_scope_id = IP6CB(skb)->iif;
+			ipv6_addr_copy(&sin6->sin6_addr,
+							&skb->nh.ipv6h->saddr);
+			ipv6_addr_copy(&rqstp->rq_daddr.addr6,
+							&skb->nh.ipv6h->saddr);
+		} while (0);
+		break;
+#endif
+	}
+	return;
+}
+
 /*
  * Receive a datagram from a UDP socket.
  */
 static int
 svc_udp_recvfrom(struct svc_rqst *rqstp)
 {
-	struct sockaddr_in *sin = svc_addr_in(rqstp);
 	struct svc_sock	*svsk = rqstp->rq_sock;
 	struct svc_serv	*serv = svsk->sk_server;
 	struct sk_buff	*skb;
@@ -775,14 +813,9 @@ svc_udp_recvfrom(struct svc_rqst *rqstp)
 
 	len  = skb->len - sizeof(struct udphdr);
 	rqstp->rq_arg.len = len;
+	rqstp->rq_prot = IPPROTO_UDP;
 
-	rqstp->rq_prot        = IPPROTO_UDP;
-
-	/* Get sender address */
-	sin->sin_family = AF_INET;
-	sin->sin_port = skb->h.uh->source;
-	sin->sin_addr.s_addr = skb->nh.iph->saddr;
-	rqstp->rq_daddr.addr.s_addr = skb->nh.iph->daddr;
+	svc_udp_get_sender_address(rqstp, skb);
 
 	if (skb_is_nonlinear(skb)) {
 		/* we have to copy */
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

