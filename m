From: akpm@linux-foundation.org
Subject: - knfsd-sunrpc-aplit-svc_sock_enqueue-out-of-svc_setup_socket.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:46:35 -0800
Message-ID: <200702122246.l1CMkZ0g013827@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45258 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030309AbXBLWqj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:46:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: SUNRPC: aplit svc_sock_enqueue out of svc_setup_socket
has been removed from the -mm tree.  Its filename was
     knfsd-sunrpc-aplit-svc_sock_enqueue-out-of-svc_setup_socket.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: SUNRPC: aplit svc_sock_enqueue out of svc_setup_socket
From: NeilBrown <neilb@suse.de>

Rather than calling svc_sock_enqueue at the end of svc_setup_socket, we now
call it (via svc_sock_recieved) after calling svc_setup_socket at each call
site.

We do this because a subsequent patch will insert some code between the two
calls at one call site.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/svcsock.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN net/sunrpc/svcsock.c~knfsd-sunrpc-aplit-svc_sock_enqueue-out-of-svc_setup_socket net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~knfsd-sunrpc-aplit-svc_sock_enqueue-out-of-svc_setup_socket
+++ a/net/sunrpc/svcsock.c
@@ -938,7 +938,7 @@ svc_tcp_accept(struct svc_sock *svsk)
 	if (!(newsvsk = svc_setup_socket(serv, newsock, &err,
 				 (SVC_SOCK_ANONYMOUS | SVC_SOCK_TEMPORARY))))
 		goto failed;
-
+	svc_sock_received(newsvsk);
 
 	/* make sure that we don't have too many active connections.
 	 * If we have, something must be dropped.
@@ -1546,8 +1546,6 @@ static struct svc_sock *svc_setup_socket
 	dprintk("svc: svc_setup_socket created %p (inet %p)\n",
 				svsk, svsk->sk_sk);
 
-	clear_bit(SK_BUSY, &svsk->sk_flags);
-	svc_sock_enqueue(svsk);
 	return svsk;
 }
 
@@ -1571,8 +1569,10 @@ int svc_addsock(struct svc_serv *serv,
 		err = -EISCONN;
 	else {
 		svsk = svc_setup_socket(serv, so, &err, SVC_SOCK_DEFAULTS);
-		if (svsk)
+		if (svsk) {
+			svc_sock_received(svsk);
 			err = 0;
+		}
 	}
 	if (err) {
 		sockfd_put(so);
@@ -1623,8 +1623,10 @@ static int svc_create_socket(struct svc_
 			goto bummer;
 	}
 
-	if ((svsk = svc_setup_socket(serv, sock, &error, flags)) != NULL)
+	if ((svsk = svc_setup_socket(serv, sock, &error, flags)) != NULL) {
+		svc_sock_received(svsk);
 		return ntohs(inet_sk(svsk->sk_sk)->sport);
+	}
 
 bummer:
 	dprintk("svc: svc_create_socket error = %d\n", -error);
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
convert-highest_possible_processor_id-to-nr_cpu_ids.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
sysctl-remove-insert_at_head-from-register_sysctl.patch
