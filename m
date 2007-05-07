From: akpm@linux-foundation.org
Subject: + knfsd-simplify-a-while-condition-in-svcsockc.patch added to -mm tree
Date: Mon, 07 May 2007 16:08:32 -0700
Message-ID: <200705072308.l47N8WZh007834@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754747AbXEGXIg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 19:08:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     knfsd: simplify a 'while' condition in svcsock.c
has been added to the -mm tree.  Its filename is
     knfsd-simplify-a-while-condition-in-svcsockc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 13 insertions(+), 8 deletions(-)

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
fix-quadratic-behavior-of-shrink_dcache_parent.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
introduce-freezer-flags-rev-2.patch
the-nfsv2-nfsv3-server-does-not-handle-zero-length-write.patch
knfsd-rename-sk_defer_lock-to-sk_lock.patch
nfsd-nfs4state-remove-unnecessary-daemonize-call.patch
rpc-add-wrapper-for-svc_reserve-to-account-for-checksum.patch
rpc-add-wrapper-for-svc_reserve-to-account-for-checksum-fix.patch
sunrpc-fix-error-path-in-module_init.patch
knfsd-avoid-use-of-unitialised-variables-on-error-path-when-nfs-exports.patch
knfsd-rpc-fix-server-side-wrapping-of-krb5i-replies.patch
knfsd-fix-resource-leak-resulting-in-module-refcount-leak-for-rpcsec_gss_krb5ko.patch
knfsd-rpcgss-rpc_gss_proc_-destroy-request-will-get-a-bad-rpc.patch
knfsd-simplify-a-while-condition-in-svcsockc.patch
knfsd-trivial-makefile-cleanup.patch
knfsd-various-nfsd-xdr-cleanups.patch
knfsd-avoid-oops-if-buggy-userspace-performs-confusing-filehandle-dentry-mapping.patch
readahead-nfsd-case.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-cleanup-use-seq_release_private-where-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
