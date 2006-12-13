From: akpm@osdl.org
Subject: + knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch added to -mm tree
Date: Tue, 12 Dec 2006 17:36:05 -0800
Message-ID: <200612130136.kBD1a5i8024076@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38735 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964878AbWLMBkI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 20:40:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chuck.lever@oracle.com, aurelien.charbon@ext.bull.net, neilb@suse.de


The patch titled
     knfsd: SUNRPC: Cache remote peer's address in svc_sock
has been added to the -mm tree.  Its filename is
     knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: SUNRPC: Cache remote peer's address in svc_sock
From: Chuck Lever <chuck.lever@oracle.com>

The remote peer's address won't change after the socket has been accepted.  We
don't need to call ->getname on every incoming request.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Aurelien Charbon <aurelien.charbon@ext.bull.net>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/sunrpc/svcsock.h |    3 +++
 net/sunrpc/svcsock.c           |   11 +++++------
 2 files changed, 8 insertions(+), 6 deletions(-)

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
@@ -577,11 +577,9 @@ svc_recvfrom(struct svc_rqst *rqstp, str
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
@@ -873,7 +871,7 @@ svc_tcp_accept(struct svc_sock *svsk)
 	struct socket	*sock = svsk->sk_sock;
 	struct socket	*newsock;
 	struct svc_sock	*newsvsk;
-	int		err, slen;
+	int		err, slen = 0;
 
 	dprintk("svc: tcp_accept %p sock %p\n", svsk, sock);
 	if (!sock)
@@ -925,7 +923,8 @@ svc_tcp_accept(struct svc_sock *svsk)
 	if (!(newsvsk = svc_setup_socket(serv, newsock, &err,
 				 (SVC_SOCK_ANONYMOUS | SVC_SOCK_TEMPORARY))))
 		goto failed;
-
+	memcpy(&newsvsk->sk_remote, &sin, slen);
+	newsvsk->sk_remotelen = slen;
 
 	/* make sure that we don't have too many active connections.
 	 * If we have, something must be dropped.
_

Patches currently in -mm which might be from chuck.lever@oracle.com are

origin.patch
knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch
knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch
knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch
knfsd-sunrpc-dont-set-msg_name-and-msg_namelen-when-calling-sock_recvmsg.patch
knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch
knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing.patch
knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses.patch
knfsd-sunrpc-make-rq_daddr-field-address-version-independent.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses.patch
knfsd-sunrpc-add-a-generic-function-to-see-if-the-peer-uses-a-secure-port.patch
knfsd-sunrpc-support-ipv6-addresses-in-svc_tcp_accept.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path.patch
knfsd-sunrpc-fix-up-svc_create_socket-to-take-a-sockaddr-struct-length.patch

