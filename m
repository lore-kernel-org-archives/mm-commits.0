From: akpm@linux-foundation.org
Subject: + knfsd-use-recv_msg-to-get-peer-address-for-nfsd-instead-of-code-copying.patch added to -mm tree
Date: Thu, 01 Mar 2007 20:36:15 -0800
Message-ID: <200703020436.l224aFEW032574@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41463 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422864AbXCBEgU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 23:36:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     knfsd: use recv_msg to get peer address for NFSD instead of code-copying
has been added to the -mm tree.  Its filename is
     knfsd-use-recv_msg-to-get-peer-address-for-nfsd-instead-of-code-copying.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: use recv_msg to get peer address for NFSD instead of code-copying
From: NeilBrown <neilb@suse.de>

The sunrpc server code needs to know the source and destination address for
UDP packets so it can reply properly.  It currently copies code out of the
network stack to pick the pieces out of the skb.  This is ugly and causes
compile problems with the IPv6 stuff.

So, rip that out and use recv_msg instead.  This is a much cleaner interface,
but has a slight cost in that the checksum is now checked before the copy, so
we don't benefit from doing both at the same time.  This can probably be
fixed.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/svcsock.c |   63 ++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 32 deletions(-)

diff -puN net/sunrpc/svcsock.c~knfsd-use-recv_msg-to-get-peer-address-for-nfsd-instead-of-code-copying net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~knfsd-use-recv_msg-to-get-peer-address-for-nfsd-instead-of-code-copying
+++ a/net/sunrpc/svcsock.c
@@ -721,45 +721,23 @@ svc_write_space(struct sock *sk)
 	}
 }
 
-static void svc_udp_get_sender_address(struct svc_rqst *rqstp,
-					struct sk_buff *skb)
+static inline void svc_udp_get_dest_address(struct svc_rqst *rqstp,
+					    struct cmsghdr *cmh)
 {
 	switch (rqstp->rq_sock->sk_sk->sk_family) {
 	case AF_INET: {
-		/* this seems to come from net/ipv4/udp.c:udp_recvmsg */
-			struct sockaddr_in *sin = svc_addr_in(rqstp);
-
-			sin->sin_family = AF_INET;
-			sin->sin_port = skb->h.uh->source;
-			sin->sin_addr.s_addr = skb->nh.iph->saddr;
-			rqstp->rq_addrlen = sizeof(struct sockaddr_in);
-			/* Remember which interface received this request */
-			rqstp->rq_daddr.addr.s_addr = skb->nh.iph->daddr;
-		}
+		struct in_pktinfo *pki = CMSG_DATA(cmh);
+		rqstp->rq_daddr.addr.s_addr = pki->ipi_spec_dst.s_addr;
 		break;
+		}
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 	case AF_INET6: {
-		/* this is derived from net/ipv6/udp.c:udpv6_recvmesg */
-			struct sockaddr_in6 *sin6 = svc_addr_in6(rqstp);
-
-			sin6->sin6_family = AF_INET6;
-			sin6->sin6_port = skb->h.uh->source;
-			sin6->sin6_flowinfo = 0;
-			sin6->sin6_scope_id = 0;
-			if (ipv6_addr_type(&sin6->sin6_addr) &
-							IPV6_ADDR_LINKLOCAL)
-				sin6->sin6_scope_id = IP6CB(skb)->iif;
-			ipv6_addr_copy(&sin6->sin6_addr,
-							&skb->nh.ipv6h->saddr);
-			rqstp->rq_addrlen = sizeof(struct sockaddr_in);
-			/* Remember which interface received this request */
-			ipv6_addr_copy(&rqstp->rq_daddr.addr6,
-							&skb->nh.ipv6h->saddr);
-		}
+		struct in6_pktinfo *pki = CMSG_DATA(cmh);
+		ipv6_addr_copy(&rqstp->rq_daddr.addr6, &pki->ipi6_addr);
 		break;
+		}
 #endif
 	}
-	return;
 }
 
 /*
@@ -771,7 +749,15 @@ svc_udp_recvfrom(struct svc_rqst *rqstp)
 	struct svc_sock	*svsk = rqstp->rq_sock;
 	struct svc_serv	*serv = svsk->sk_server;
 	struct sk_buff	*skb;
+	char		buffer[CMSG_SPACE(sizeof(union svc_pktinfo_u))];
+	struct cmsghdr *cmh = (struct cmsghdr *)buffer;
 	int		err, len;
+	struct msghdr msg = {
+		.msg_name = svc_addr(rqstp),
+		.msg_control = cmh,
+		.msg_controllen = sizeof(buffer),
+		.msg_flags = MSG_DONTWAIT,
+	};
 
 	if (test_and_clear_bit(SK_CHNGBUF, &svsk->sk_flags))
 	    /* udp sockets need large rcvbuf as all pending
@@ -797,7 +783,9 @@ svc_udp_recvfrom(struct svc_rqst *rqstp)
 	}
 
 	clear_bit(SK_DATA, &svsk->sk_flags);
-	while ((skb = skb_recv_datagram(svsk->sk_sk, 0, 1, &err)) == NULL) {
+	while ((err == kernel_recvmsg(svsk->sk_sock, &msg, NULL,
+				      0, 0, MSG_PEEK)) < 0 ||
+	       (skb = skb_recv_datagram(svsk->sk_sk, 0, 1, &err)) == NULL) {
 		if (err == -EAGAIN) {
 			svc_sock_received(svsk);
 			return err;
@@ -805,6 +793,7 @@ svc_udp_recvfrom(struct svc_rqst *rqstp)
 		/* possibly an icmp error */
 		dprintk("svc: recvfrom returned error %d\n", -err);
 	}
+	rqstp->rq_addrlen = sizeof(rqstp->rq_addr);
 	if (skb->tstamp.off_sec == 0) {
 		struct timeval tv;
 
@@ -827,7 +816,7 @@ svc_udp_recvfrom(struct svc_rqst *rqstp)
 
 	rqstp->rq_prot = IPPROTO_UDP;
 
-	svc_udp_get_sender_address(rqstp, skb);
+	svc_udp_get_dest_address(rqstp, cmh);
 
 	if (skb_is_nonlinear(skb)) {
 		/* we have to copy */
@@ -884,6 +873,9 @@ svc_udp_sendto(struct svc_rqst *rqstp)
 static void
 svc_udp_init(struct svc_sock *svsk)
 {
+	int one = 1;
+	mm_segment_t oldfs;
+
 	svsk->sk_sk->sk_data_ready = svc_udp_data_ready;
 	svsk->sk_sk->sk_write_space = svc_write_space;
 	svsk->sk_recvfrom = svc_udp_recvfrom;
@@ -899,6 +891,13 @@ svc_udp_init(struct svc_sock *svsk)
 
 	set_bit(SK_DATA, &svsk->sk_flags); /* might have come in before data_ready set up */
 	set_bit(SK_CHNGBUF, &svsk->sk_flags);
+
+	oldfs = get_fs();
+	set_fs(KERNEL_DS);
+	/* make sure we get destination address info */
+	svsk->sk_sock->ops->setsockopt(svsk->sk_sock, IPPROTO_IP, IP_PKTINFO,
+				       (char __user *)&one, sizeof(one));
+	set_fs(oldfs);
 }
 
 /*
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
fix-failure-paths-in-modules-init-in-umemc.patch
md-fix-raid10-recovery-problem.patch
md-raid6-clean-up-cpuid-and-fpu-enter-exit-code.patch
md-move-warning-about-creating-a-raid-array-on-partitions-of-the-one-device.patch
md-clean-out-unplug-and-other-queue-function-on-md-shutdown.patch
md-restart-a-raid5-reshape-that-has-been-aborted-due-to-a-read-write-error.patch
md-add-support-for-reshape-of-a-raid6.patch
knfsd-use-recv_msg-to-get-peer-address-for-nfsd-instead-of-code-copying.patch
knfsd-avoid-checksum-checks-when-collecting-metadata-for-a-udp-packet.patch
knfsd-remove-config_ipv6-ifdefs-from-sunrpc-server-code.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous-tidy.patch
the-nfsv2-nfsv3-server-does-not-handle-zero-length-write.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
