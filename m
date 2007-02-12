From: akpm@linux-foundation.org
Subject: - knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:46:48 -0800
Message-ID: <200702122246.l1CMkm2N013854@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45309 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030331AbXBLWq5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:46:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chuck.lever@oracle.com, aurelien.charbon@ext.bull.net, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: SUNRPC: teach svc_sendto() to deal with IPv6 addresses
has been removed from the -mm tree.  Its filename was
     knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: SUNRPC: teach svc_sendto() to deal with IPv6 addresses
From: Chuck Lever <chuck.lever@oracle.com>

CMSG_DATA comes in different sizes, depending on address family.

[akpm@linux-foundation.org: remove unneeded do/while (0)]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Aurelien Charbon <aurelien.charbon@ext.bull.net>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/svcsock.c |   65 ++++++++++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 17 deletions(-)

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
@@ -446,6 +447,43 @@ svc_wake_up(struct svc_serv *serv)
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
+	case AF_INET: {
+			struct in_pktinfo *pki = CMSG_DATA(cmh);
+
+			cmh->cmsg_level = SOL_IP;
+			cmh->cmsg_type = IP_PKTINFO;
+			pki->ipi_ifindex = 0;
+			pki->ipi_spec_dst.s_addr = rqstp->rq_daddr.addr.s_addr;
+			cmh->cmsg_len = CMSG_LEN(sizeof(*pki));
+		}
+		break;
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+	case AF_INET6: {
+			struct in6_pktinfo *pki = CMSG_DATA(cmh);
+
+			cmh->cmsg_level = SOL_IPV6;
+			cmh->cmsg_type = IPV6_PKTINFO;
+			pki->ipi6_ifindex = 0;
+			ipv6_addr_copy(&pki->ipi6_addr,
+					&rqstp->rq_daddr.addr6);
+			cmh->cmsg_len = CMSG_LEN(sizeof(*pki));
+		}
+		break;
+#endif
+	}
+	return;
+}
+
 /*
  * Generic sendto routine
  */
@@ -455,9 +493,8 @@ svc_sendto(struct svc_rqst *rqstp, struc
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
@@ -470,21 +507,15 @@ svc_sendto(struct svc_rqst *rqstp, struc
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
git-nfs.patch
