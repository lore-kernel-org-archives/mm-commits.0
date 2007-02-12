From: akpm@linux-foundation.org
Subject: - knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:46:38 -0800
Message-ID: <200702122246.l1CMkc1u013830@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45285 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030319AbXBLWqu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:46:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chuck.lever@oracle.com, aurelien.charbon@ext.bull.net, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: SUNRPC: Cache remote peer's address in svc_sock
has been removed from the -mm tree.  Its filename was
     knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: SUNRPC: Cache remote peer's address in svc_sock
From: Chuck Lever <chuck.lever@oracle.com>

The remote peer's address won't change after the socket has been accepted.  We
don't need to call ->getname on every incoming request.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Aurelien Charbon <aurelien.charbon@ext.bull.net>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sunrpc/svcsock.h |    3 +++
 net/sunrpc/svcsock.c           |   14 ++++++++------
 2 files changed, 11 insertions(+), 6 deletions(-)

diff -puN include/linux/sunrpc/svcsock.h~knfsd-sunrpc-cache-remote-peers-address-in-svc_sock include/linux/sunrpc/svcsock.h
--- a/include/linux/sunrpc/svcsock.h~knfsd-sunrpc-cache-remote-peers-address-in-svc_sock
+++ a/include/linux/sunrpc/svcsock.h
@@ -57,6 +57,9 @@ struct svc_sock {
 
 	/* cache of various info for TCP sockets */
 	void			*sk_info_authunix;
+
+	struct sockaddr_storage	sk_remote;	/* remote peer's address */
+	int			sk_remotelen;	/* length of address */
 };
 
 /*
diff -puN net/sunrpc/svcsock.c~knfsd-sunrpc-cache-remote-peers-address-in-svc_sock net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~knfsd-sunrpc-cache-remote-peers-address-in-svc_sock
+++ a/net/sunrpc/svcsock.c
@@ -568,12 +568,13 @@ svc_recv_available(struct svc_sock *svsk
 static int
 svc_recvfrom(struct svc_rqst *rqstp, struct kvec *iov, int nr, int buflen)
 {
+	struct svc_sock *svsk = rqstp->rq_sock;
 	struct msghdr	msg;
 	struct socket	*sock;
-	int		len, alen;
+	int		len;
 
 	rqstp->rq_addrlen = sizeof(rqstp->rq_addr);
-	sock = rqstp->rq_sock->sk_sock;
+	sock = svsk->sk_sock;
 
 	msg.msg_name    = &rqstp->rq_addr;
 	msg.msg_namelen = sizeof(rqstp->rq_addr);
@@ -585,11 +586,9 @@ svc_recvfrom(struct svc_rqst *rqstp, str
 	len = kernel_recvmsg(sock, &msg, iov, nr, buflen, MSG_DONTWAIT);
 
 	/* sock_recvmsg doesn't fill in the name/namelen, so we must..
-	 * possibly we should cache this in the svc_sock structure
-	 * at accept time. FIXME
 	 */
-	alen = sizeof(rqstp->rq_addr);
-	kernel_getpeername(sock, (struct sockaddr *)&rqstp->rq_addr, &alen);
+	memcpy(&rqstp->rq_addr, &svsk->sk_remote, svsk->sk_remotelen);
+	rqstp->rq_addrlen = svsk->sk_remotelen;
 
 	dprintk("svc: socket %p recvfrom(%p, %Zu) = %d\n",
 		rqstp->rq_sock, iov[0].iov_base, iov[0].iov_len, len);
@@ -938,6 +937,9 @@ svc_tcp_accept(struct svc_sock *svsk)
 	if (!(newsvsk = svc_setup_socket(serv, newsock, &err,
 				 (SVC_SOCK_ANONYMOUS | SVC_SOCK_TEMPORARY))))
 		goto failed;
+	memcpy(&newsvsk->sk_remote, &sin, slen);
+	newsvsk->sk_remotelen = slen;
+
 	svc_sock_received(newsvsk);
 
 	/* make sure that we don't have too many active connections.
_

Patches currently in -mm which might be from chuck.lever@oracle.com are

origin.patch
git-nfs.patch
