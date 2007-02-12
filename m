From: akpm@linux-foundation.org
Subject: - knfsd-sunrpc-fix-up-svc_create_socket-to-take-a-sockaddr-struct-length.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:46:56 -0800
Message-ID: <200702122246.l1CMkuJC013869@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45325 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030337AbXBLWrD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:47:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chuck.lever@oracle.com, aurelien.charbon@ext.bull.net, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: SUNRPC: fix up svc_create_socket() to take a sockaddr struct + length
has been removed from the -mm tree.  Its filename was
     knfsd-sunrpc-fix-up-svc_create_socket-to-take-a-sockaddr-struct-length.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: SUNRPC: fix up svc_create_socket() to take a sockaddr struct + length
From: Chuck Lever <chuck.lever@oracle.com>

Replace existing svc_create_socket() API to allow callers to pass addresses
larger than a sockaddr_in.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Aurelien Charbon <aurelien.charbon@ext.bull.net>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/svcsock.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN net/sunrpc/svcsock.c~knfsd-sunrpc-fix-up-svc_create_socket-to-take-a-sockaddr-struct-length net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~knfsd-sunrpc-fix-up-svc_create_socket-to-take-a-sockaddr-struct-length
+++ a/net/sunrpc/svcsock.c
@@ -1700,7 +1700,7 @@ EXPORT_SYMBOL_GPL(svc_addsock);
  * Create socket for RPC service.
  */
 static int svc_create_socket(struct svc_serv *serv, int protocol,
-				struct sockaddr_in *sin, int flags)
+				struct sockaddr *sin, int len, int flags)
 {
 	struct svc_sock	*svsk;
 	struct socket	*sock;
@@ -1710,8 +1710,7 @@ static int svc_create_socket(struct svc_
 
 	dprintk("svc: svc_create_socket(%s, %d, %s)\n",
 			serv->sv_program->pg_name, protocol,
-			__svc_print_addr((struct sockaddr *) sin, buf,
-								sizeof(buf)));
+			__svc_print_addr(sin, buf, sizeof(buf)));
 
 	if (protocol != IPPROTO_UDP && protocol != IPPROTO_TCP) {
 		printk(KERN_WARNING "svc: only UDP and TCP "
@@ -1720,15 +1719,15 @@ static int svc_create_socket(struct svc_
 	}
 	type = (protocol == IPPROTO_UDP)? SOCK_DGRAM : SOCK_STREAM;
 
-	if ((error = sock_create_kern(PF_INET, type, protocol, &sock)) < 0)
+	error = sock_create_kern(sin->sa_family, type, protocol, &sock);
+	if (error < 0)
 		return error;
 
 	svc_reclassify_socket(sock);
 
 	if (type == SOCK_STREAM)
-		sock->sk->sk_reuse = 1; /* allow address reuse */
-	error = kernel_bind(sock, (struct sockaddr *) sin,
-					sizeof(*sin));
+		sock->sk->sk_reuse = 1;		/* allow address reuse */
+	error = kernel_bind(sock, sin, len);
 	if (error < 0)
 		goto bummer;
 
@@ -1818,7 +1817,8 @@ int svc_makesock(struct svc_serv *serv, 
 	};
 
 	dprintk("svc: creating socket proto = %d\n", protocol);
-	return svc_create_socket(serv, protocol, &sin, flags);
+	return svc_create_socket(serv, protocol, (struct sockaddr *) &sin,
+							sizeof(sin), flags);
 }
 
 /*
_

Patches currently in -mm which might be from chuck.lever@oracle.com are

origin.patch
git-nfs.patch
