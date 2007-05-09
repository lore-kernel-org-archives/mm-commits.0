From: akpm@linux-foundation.org
Subject: - knfsd-simplify-a-while-condition-in-svcsockc.patch removed from -mm tree
Date: Wed, 09 May 2007 14:53:13 -0700
Message-ID: <200705092153.l49LrDdq003066@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759465AbXEIVxg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:53:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: simplify a 'while' condition in svcsock.c
has been removed from the -mm tree.  Its filename was
     knfsd-simplify-a-while-condition-in-svcsockc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: simplify a 'while' condition in svcsock.c
From: NeilBrown <neilb@suse.de>

This while loop has an overly complex condition, which performs a couple of
assignments.  This hurts readability.

We don't really need a loop at all.  We can just return -EAGAIN and (providing
we set SK_DATA), the function will be called again.

So discard the loop, make the complex conditional become a few clear function
calls, and hopefully improve readability.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/svcsock.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff -puN net/sunrpc/svcsock.c~knfsd-simplify-a-while-condition-in-svcsockc net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~knfsd-simplify-a-while-condition-in-svcsockc
+++ a/net/sunrpc/svcsock.c
@@ -788,15 +788,20 @@ svc_udp_recvfrom(struct svc_rqst *rqstp)
 	}
 
 	clear_bit(SK_DATA, &svsk->sk_flags);
-	while ((err = kernel_recvmsg(svsk->sk_sock, &msg, NULL,
-				     0, 0, MSG_PEEK | MSG_DONTWAIT)) < 0 ||
-	       (skb = skb_recv_datagram(svsk->sk_sk, 0, 1, &err)) == NULL) {
-		if (err == -EAGAIN) {
-			svc_sock_received(svsk);
-			return err;
+	skb = NULL;
+	err = kernel_recvmsg(svsk->sk_sock, &msg, NULL,
+			     0, 0, MSG_PEEK | MSG_DONTWAIT);
+	if (err >= 0)
+		skb = skb_recv_datagram(svsk->sk_sk, 0, 1, &err);
+
+	if (skb == NULL) {
+		if (err != -EAGAIN) {
+			/* possibly an icmp error */
+			dprintk("svc: recvfrom returned error %d\n", -err);
+			set_bit(SK_DATA, &svsk->sk_flags);
 		}
-		/* possibly an icmp error */
-		dprintk("svc: recvfrom returned error %d\n", -err);
+		svc_sock_received(svsk);
+		return -EAGAIN;
 	}
 	rqstp->rq_addrlen = sizeof(rqstp->rq_addr);
 	if (skb->tstamp.tv64 == 0) {
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
introduce-freezer-flags-rev-2.patch
git-md-accel.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
