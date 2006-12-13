From: akpm@osdl.org
Subject: + knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses.patch added to -mm tree
Date: Tue, 12 Dec 2006 17:36:17 -0800
Message-ID: <200612130136.kBD1aHXM024101@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38704 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964875AbWLMBjx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 20:39:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chuck.lever@oracle.com, aurelien.charbon@ext.bull.net, neilb@suse.de


The patch titled
     knfsd: SUNRPC: teach svc_sendto() to deal with IPv6 addresses
has been added to the -mm tree.  Its filename is
     knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: SUNRPC: teach svc_sendto() to deal with IPv6 addresses
From: Chuck Lever <chuck.lever@oracle.com>

CMSG_DATA comes in different sizes, depending on address family.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Aurelien Charbon <aurelien.charbon@ext.bull.net>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 net/sunrpc/svcsock.c |   69 ++++++++++++++++++++++++++++++-----------
 1 files changed, 52 insertions(+), 17 deletions(-)

diff -puN net/sunrpc/svcsock.c~knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses
+++ a/net/sunrpc/svcsock.c
@@ -36,6 +36,7 @@
 #include <net/sock.h>
 #include <net/checksum.h>
 #include <net/ip.h>
+#include <net/ipv6.h>
 #include <net/tcp_states.h>
 #include <asm/uaccess.h>
 #include <asm/ioctls.h>
@@ -438,6 +439,47 @@ svc_wake_up(struct svc_serv *serv)
 	}
 }
 
+union svc_pktinfo_u {
+	struct in_pktinfo pkti;
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+	struct in6_pktinfo pkti6;
+#endif
+};
+
+static void svc_set_cmsg_data(struct svc_rqst *rqstp, struct cmsghdr *cmh)
+{
+	switch (rqstp->rq_sock->sk_sk->sk_family) {
+	case AF_INET:
+		do {
+			struct in_pktinfo *pki =
+					(struct in_pktinfo *) CMSG_DATA(cmh);
+
+			cmh->cmsg_level = SOL_IP;
+			cmh->cmsg_type = IP_PKTINFO;
+			pki->ipi_ifindex = 0;
+			pki->ipi_spec_dst.s_addr = rqstp->rq_daddr.addr.s_addr;
+			cmh->cmsg_len = CMSG_LEN(sizeof(*pki));
+		} while (0);
+		break;
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+	case AF_INET6:
+		do {
+			struct in6_pktinfo *pki =
+					(struct in6_pktinfo *) CMSG_DATA(cmh);
+
+			cmh->cmsg_level = SOL_IPV6;
+			cmh->cmsg_type = IPV6_PKTINFO;
+			pki->ipi6_ifindex = 0;
+			ipv6_addr_copy(&pki->ipi6_addr,
+					&rqstp->rq_daddr.addr6);
+			cmh->cmsg_len = CMSG_LEN(sizeof(*pki));
+		} while (0);
+		break;
+#endif
+	}
+	return;
+}
+
 /*
  * Generic sendto routine
  */
@@ -447,9 +489,8 @@ svc_sendto(struct svc_rqst *rqstp, struc
 	struct svc_sock	*svsk = rqstp->rq_sock;
 	struct socket	*sock = svsk->sk_sock;
 	int		slen;
-	char 		buffer[CMSG_SPACE(sizeof(struct in_pktinfo))];
+	char 		buffer[CMSG_SPACE(sizeof(union svc_pktinfo_u))];
 	struct cmsghdr *cmh = (struct cmsghdr *)buffer;
-	struct in_pktinfo *pki = (struct in_pktinfo *)CMSG_DATA(cmh);
 	int		len = 0;
 	int		result;
 	int		size;
@@ -462,21 +503,15 @@ svc_sendto(struct svc_rqst *rqstp, struc
 	slen = xdr->len;
 
 	if (rqstp->rq_prot == IPPROTO_UDP) {
-		/* set the source and destination */
-		struct msghdr	msg;
-		msg.msg_name    = &rqstp->rq_addr;
-		msg.msg_namelen = rqstp->rq_addrlen;
-		msg.msg_iov     = NULL;
-		msg.msg_iovlen  = 0;
-		msg.msg_flags	= MSG_MORE;
-
-		msg.msg_control = cmh;
-		msg.msg_controllen = sizeof(buffer);
-		cmh->cmsg_len = CMSG_LEN(sizeof(*pki));
-		cmh->cmsg_level = SOL_IP;
-		cmh->cmsg_type = IP_PKTINFO;
-		pki->ipi_ifindex = 0;
-		pki->ipi_spec_dst.s_addr = rqstp->rq_daddr.addr.s_addr;
+		struct msghdr msg = {
+			.msg_name	= &rqstp->rq_addr,
+			.msg_namelen	= rqstp->rq_addrlen,
+			.msg_control	= cmh,
+			.msg_controllen	= sizeof(buffer),
+			.msg_flags	= MSG_MORE,
+		};
+
+		svc_set_cmsg_data(rqstp, cmh);
 
 		if (sock_sendmsg(sock, &msg, 0) < 0)
 			goto out;
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

