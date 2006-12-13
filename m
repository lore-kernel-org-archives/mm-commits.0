From: akpm@osdl.org
Subject: + knfsd-sunrpc-support-ipv6-addresses-in-svc_tcp_accept.patch added to -mm tree
Date: Tue, 12 Dec 2006 17:36:21 -0800
Message-ID: <200612130136.kBD1aLUW024107@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38699 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964851AbWLMBjv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 20:39:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chuck.lever@oracle.com, aurelien.charbon@ext.bull.net, neilb@suse.de


The patch titled
     knfsd: SUNRPC: Support IPv6 addresses in svc_tcp_accept
has been added to the -mm tree.  Its filename is
     knfsd-sunrpc-support-ipv6-addresses-in-svc_tcp_accept.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: SUNRPC: Support IPv6 addresses in svc_tcp_accept
From: Chuck Lever <chuck.lever@oracle.com>

Modify svc_tcp_accept to support connecting on IPv6 sockets.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Aurelien Charbon <aurelien.charbon@ext.bull.net>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 net/sunrpc/svcsock.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff -puN net/sunrpc/svcsock.c~knfsd-sunrpc-support-ipv6-addresses-in-svc_tcp_accept net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~knfsd-sunrpc-support-ipv6-addresses-in-svc_tcp_accept
+++ a/net/sunrpc/svcsock.c
@@ -946,7 +946,8 @@ static inline int svc_port_is_privileged
 static void
 svc_tcp_accept(struct svc_sock *svsk)
 {
-	struct sockaddr_in sin;
+	struct sockaddr_storage addr;
+	struct sockaddr	*sin = (struct sockaddr *) &addr;
 	struct svc_serv	*serv = svsk->sk_server;
 	struct socket	*sock = svsk->sk_sock;
 	struct socket	*newsock;
@@ -973,8 +974,7 @@ svc_tcp_accept(struct svc_sock *svsk)
 	set_bit(SK_CONN, &svsk->sk_flags);
 	svc_sock_enqueue(svsk);
 
-	slen = sizeof(sin);
-	err = kernel_getpeername(newsock, (struct sockaddr *) &sin, &slen);
+	err = kernel_getpeername(newsock, sin, &slen);
 	if (err < 0) {
 		if (net_ratelimit())
 			printk(KERN_WARNING "%s: peername failed (err %d)!\n",
@@ -986,12 +986,11 @@ svc_tcp_accept(struct svc_sock *svsk)
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
 	dprintk("%s: connect from %s\n", serv->sv_name, buf);
 
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

