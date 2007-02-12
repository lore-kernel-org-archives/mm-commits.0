From: akpm@linux-foundation.org
Subject: - knfsd-sunrpc-support-ipv6-addresses-in-svc_tcp_accept.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:46:52 -0800
Message-ID: <200702122246.l1CMkqrp013861@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45321 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030314AbXBLWrB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:47:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chuck.lever@oracle.com, aurelien.charbon@ext.bull.net, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: SUNRPC: Support IPv6 addresses in svc_tcp_accept
has been removed from the -mm tree.  Its filename was
     knfsd-sunrpc-support-ipv6-addresses-in-svc_tcp_accept.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: SUNRPC: Support IPv6 addresses in svc_tcp_accept


Modify svc_tcp_accept to support connecting on IPv6 sockets.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Aurelien Charbon <aurelien.charbon@ext.bull.net>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/svcsock.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN net/sunrpc/svcsock.c~knfsd-sunrpc-support-ipv6-addresses-in-svc_tcp_accept net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~knfsd-sunrpc-support-ipv6-addresses-in-svc_tcp_accept
+++ a/net/sunrpc/svcsock.c
@@ -960,7 +960,8 @@ static inline int svc_port_is_privileged
 static void
 svc_tcp_accept(struct svc_sock *svsk)
 {
-	struct sockaddr_in sin;
+	struct sockaddr_storage addr;
+	struct sockaddr	*sin = (struct sockaddr *) &addr;
 	struct svc_serv	*serv = svsk->sk_server;
 	struct socket	*sock = svsk->sk_sock;
 	struct socket	*newsock;
@@ -987,8 +988,7 @@ svc_tcp_accept(struct svc_sock *svsk)
 	set_bit(SK_CONN, &svsk->sk_flags);
 	svc_sock_enqueue(svsk);
 
-	slen = sizeof(sin);
-	err = kernel_getpeername(newsock, (struct sockaddr *) &sin, &slen);
+	err = kernel_getpeername(newsock, sin, &slen);
 	if (err < 0) {
 		if (net_ratelimit())
 			printk(KERN_WARNING "%s: peername failed (err %d)!\n",
@@ -1000,16 +1000,14 @@ svc_tcp_accept(struct svc_sock *svsk)
 	 * hosts here, but when we get encryption, the IP of the host won't
 	 * tell us anything.  For now just warn about unpriv connections.
 	 */
-	if (!svc_port_is_privileged((struct sockaddr *) &sin)) {
+	if (!svc_port_is_privileged(sin)) {
 		dprintk(KERN_WARNING
 			"%s: connect from unprivileged port: %s\n",
 			serv->sv_name,
-			__svc_print_addr((struct sockaddr *) &sin, buf,
-								sizeof(buf)));
+			__svc_print_addr(sin, buf, sizeof(buf)));
 	}
 	dprintk("%s: connect from %s\n", serv->sv_name,
-		__svc_print_addr((struct sockaddr *) &sin, buf,
-				 sizeof(buf)));
+		__svc_print_addr(sin, buf, sizeof(buf)));
 
 	/* make sure that a write doesn't block forever when
 	 * low on memory
@@ -1019,7 +1017,7 @@ svc_tcp_accept(struct svc_sock *svsk)
 	if (!(newsvsk = svc_setup_socket(serv, newsock, &err,
 				 (SVC_SOCK_ANONYMOUS | SVC_SOCK_TEMPORARY))))
 		goto failed;
-	memcpy(&newsvsk->sk_remote, &sin, slen);
+	memcpy(&newsvsk->sk_remote, sin, slen);
 	newsvsk->sk_remotelen = slen;
 
 	svc_sock_received(newsvsk);
_

Patches currently in -mm which might be from chuck.lever@oracle.com are

origin.patch
git-nfs.patch
