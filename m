From: akpm@linux-foundation.org
Subject: - knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch removed from -mm tree
Date: Sun, 11 Feb 2007 23:24:19 -0800
Message-ID: <200702120724.l1C7OJUP024735@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44809 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933055AbXBLHYq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 02:24:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aurelien.charbon@ext.bull.net, chuck.lever@oracle.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy
has been removed from the -mm tree.  Its filename was
     knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch

This patch was dropped because it was folded into knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path.patch

------------------------------------------------------
Subject: knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Aurelien Charbon <aurelien.charbon@ext.bull.net>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/svcsock.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN net/sunrpc/svcsock.c~knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy
+++ a/net/sunrpc/svcsock.c
@@ -725,9 +725,8 @@ static void svc_udp_get_sender_address(s
 					struct sk_buff *skb)
 {
 	switch (rqstp->rq_sock->sk_sk->sk_family) {
-	case AF_INET:
+	case AF_INET: {
 		/* this seems to come from net/ipv4/udp.c:udp_recvmsg */
-		do {
 			struct sockaddr_in *sin = svc_addr_in(rqstp);
 
 			sin->sin_family = AF_INET;
@@ -736,12 +735,11 @@ static void svc_udp_get_sender_address(s
 			rqstp->rq_addrlen = sizeof(struct sockaddr_in);
 			/* Remember which interface received this request */
 			rqstp->rq_daddr.addr.s_addr = skb->nh.iph->daddr;
-		} while (0);
+		}
 		break;
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
-	case AF_INET6:
+	case AF_INET6: {
 		/* this is derived from net/ipv6/udp.c:udpv6_recvmesg */
-		do {
 			struct sockaddr_in6 *sin6 = svc_addr_in6(rqstp);
 
 			sin6->sin6_family = AF_INET6;
@@ -757,7 +755,7 @@ static void svc_udp_get_sender_address(s
 			/* Remember which interface received this request */
 			ipv6_addr_copy(&rqstp->rq_daddr.addr6,
 							&skb->nh.ipv6h->saddr);
-		} while (0);
+		}
 		break;
 #endif
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
add-vm_insert_pfn.patch
swiotlb-uninlinings.patch
kprobes-list-all-active-probes-in-the-system.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
deprecate-sa_interrupt-and-friends.patch
