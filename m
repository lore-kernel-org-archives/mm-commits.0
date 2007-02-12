From: akpm@linux-foundation.org
Subject: - knfsd-sunrpc-dont-set-msg_name-and-msg_namelen-when-calling-sock_recvmsg.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:46:39 -0800
Message-ID: <200702122246.l1CMkdaM013833@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45284 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030318AbXBLWqu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:46:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chuck.lever@oracle.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: SUNRPC: Don't set msg_name and msg_namelen when calling sock_recvmsg
has been removed from the -mm tree.  Its filename was
     knfsd-sunrpc-dont-set-msg_name-and-msg_namelen-when-calling-sock_recvmsg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: SUNRPC: Don't set msg_name and msg_namelen when calling sock_recvmsg
From: Chuck Lever <chuck.lever@oracle.com>

Clean-up: msg_name and msg_namelen are not used by sock_recvmsg, so don't
bother to set them in svc_recvfrom.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/svcsock.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff -puN net/sunrpc/svcsock.c~knfsd-sunrpc-dont-set-msg_name-and-msg_namelen-when-calling-sock_recvmsg net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~knfsd-sunrpc-dont-set-msg_name-and-msg_namelen-when-calling-sock_recvmsg
+++ a/net/sunrpc/svcsock.c
@@ -569,21 +569,13 @@ static int
 svc_recvfrom(struct svc_rqst *rqstp, struct kvec *iov, int nr, int buflen)
 {
 	struct svc_sock *svsk = rqstp->rq_sock;
-	struct msghdr	msg;
-	struct socket	*sock;
-	int		len;
-
-	rqstp->rq_addrlen = sizeof(rqstp->rq_addr);
-	sock = svsk->sk_sock;
-
-	msg.msg_name    = &rqstp->rq_addr;
-	msg.msg_namelen = sizeof(rqstp->rq_addr);
-	msg.msg_control = NULL;
-	msg.msg_controllen = 0;
-
-	msg.msg_flags	= MSG_DONTWAIT;
+	struct msghdr msg = {
+		.msg_flags	= MSG_DONTWAIT,
+	};
+	int len;
 
-	len = kernel_recvmsg(sock, &msg, iov, nr, buflen, MSG_DONTWAIT);
+	len = kernel_recvmsg(svsk->sk_sock, &msg, iov, nr, buflen,
+				msg.msg_flags);
 
 	/* sock_recvmsg doesn't fill in the name/namelen, so we must..
 	 */
@@ -591,7 +583,7 @@ svc_recvfrom(struct svc_rqst *rqstp, str
 	rqstp->rq_addrlen = svsk->sk_remotelen;
 
 	dprintk("svc: socket %p recvfrom(%p, %Zu) = %d\n",
-		rqstp->rq_sock, iov[0].iov_base, iov[0].iov_len, len);
+		svsk, iov[0].iov_base, iov[0].iov_len, len);
 
 	return len;
 }
_

Patches currently in -mm which might be from chuck.lever@oracle.com are

origin.patch
git-nfs.patch
