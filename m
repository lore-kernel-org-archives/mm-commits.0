From: akpm@linux-foundation.org
Subject: - knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch removed from -mm tree
Date: Sun, 11 Feb 2007 23:24:09 -0800
Message-ID: <200702120724.l1C7O9lq024728@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44820 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933054AbXBLHZA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 02:25:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aurelien.charbon@ext.bull.net, chuck.lever@oracle.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy
has been removed from the -mm tree.  Its filename was
     knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch

This patch was dropped because it was folded into knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses.patch

------------------------------------------------------
Subject: knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Remove unneeded do/while (0)

Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Aurelien Charbon <aurelien.charbon@ext.bull.net>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/svcsock.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN net/sunrpc/svcsock.c~knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy
+++ a/net/sunrpc/svcsock.c
@@ -457,8 +457,7 @@ union svc_pktinfo_u {
 static void svc_set_cmsg_data(struct svc_rqst *rqstp, struct cmsghdr *cmh)
 {
 	switch (rqstp->rq_sock->sk_sk->sk_family) {
-	case AF_INET:
-		do {
+	case AF_INET: {
 			struct in_pktinfo *pki = CMSG_DATA(cmh);
 
 			cmh->cmsg_level = SOL_IP;
@@ -466,11 +465,10 @@ static void svc_set_cmsg_data(struct svc
 			pki->ipi_ifindex = 0;
 			pki->ipi_spec_dst.s_addr = rqstp->rq_daddr.addr.s_addr;
 			cmh->cmsg_len = CMSG_LEN(sizeof(*pki));
-		} while (0);
+		}
 		break;
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
-	case AF_INET6:
-		do {
+	case AF_INET6: {
 			struct in6_pktinfo *pki = CMSG_DATA(cmh);
 
 			cmh->cmsg_level = SOL_IPV6;
@@ -479,7 +477,7 @@ static void svc_set_cmsg_data(struct svc
 			ipv6_addr_copy(&pki->ipi6_addr,
 					&rqstp->rq_daddr.addr6);
 			cmh->cmsg_len = CMSG_LEN(sizeof(*pki));
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
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
deprecate-sa_interrupt-and-friends.patch
