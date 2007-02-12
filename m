From: akpm@linux-foundation.org
Subject: - knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:46:31 -0800
Message-ID: <200702122246.l1CMkVem013818@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45269 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030318AbXBLWqm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:46:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chuck.lever@oracle.com, aurelien.charbon@ext.bull.net, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: SUNRPC: update internal API: separate pmap register and temp sockets
has been removed from the -mm tree.  Its filename was
     knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: SUNRPC: update internal API: separate pmap register and temp sockets
From: Chuck Lever <chuck.lever@oracle.com>

Currently in the RPC server, registering with the local portmapper and
creating "permanent" sockets are tied together.  Expand the internal APIs to
allow these two socket characteristics to be separately specified.

This will be externalized in the next patch.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Aurelien Charbon <aurelien.charbon@ext.bull.net>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sunrpc/svcsock.h |    7 ++++
 net/sunrpc/svcsock.c           |   47 +++++++++++++++++--------------
 2 files changed, 34 insertions(+), 20 deletions(-)

diff -puN include/linux/sunrpc/svcsock.h~knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets include/linux/sunrpc/svcsock.h
--- a/include/linux/sunrpc/svcsock.h~knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets
+++ a/include/linux/sunrpc/svcsock.h
@@ -74,4 +74,11 @@ int		svc_addsock(struct svc_serv *serv,
 			    char *name_return,
 			    int *proto);
 
+/*
+ * svc_makesock socket characteristics
+ */
+#define SVC_SOCK_DEFAULTS	(0U)
+#define SVC_SOCK_ANONYMOUS	(1U << 0)	/* don't register with pmap */
+#define SVC_SOCK_TEMPORARY	(1U << 1)	/* flag socket as temporary */
+
 #endif /* SUNRPC_SVCSOCK_H */
diff -puN net/sunrpc/svcsock.c~knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets
+++ a/net/sunrpc/svcsock.c
@@ -75,7 +75,7 @@
 
 
 static struct svc_sock *svc_setup_socket(struct svc_serv *, struct socket *,
-					 int *errp, int pmap_reg);
+					 int *errp, int flags);
 static void		svc_delete_socket(struct svc_sock *svsk);
 static void		svc_udp_data_ready(struct sock *, int);
 static int		svc_udp_recvfrom(struct svc_rqst *);
@@ -935,7 +935,8 @@ svc_tcp_accept(struct svc_sock *svsk)
 	 */
 	newsock->sk->sk_sndtimeo = HZ*30;
 
-	if (!(newsvsk = svc_setup_socket(serv, newsock, &err, 0)))
+	if (!(newsvsk = svc_setup_socket(serv, newsock, &err,
+				 (SVC_SOCK_ANONYMOUS | SVC_SOCK_TEMPORARY))))
 		goto failed;
 
 
@@ -1476,12 +1477,14 @@ svc_age_temp_sockets(unsigned long closu
  * Initialize socket for RPC use and create svc_sock struct
  * XXX: May want to setsockopt SO_SNDBUF and SO_RCVBUF.
  */
-static struct svc_sock *
-svc_setup_socket(struct svc_serv *serv, struct socket *sock,
-					int *errp, int pmap_register)
+static struct svc_sock *svc_setup_socket(struct svc_serv *serv,
+						struct socket *sock,
+						int *errp, int flags)
 {
 	struct svc_sock	*svsk;
 	struct sock	*inet;
+	int		pmap_register = !(flags & SVC_SOCK_ANONYMOUS);
+	int		is_temporary = flags & SVC_SOCK_TEMPORARY;
 
 	dprintk("svc: svc_setup_socket %p\n", sock);
 	if (!(svsk = kzalloc(sizeof(*svsk), GFP_KERNEL))) {
@@ -1523,7 +1526,7 @@ svc_setup_socket(struct svc_serv *serv, 
 		svc_tcp_init(svsk);
 
 	spin_lock_bh(&serv->sv_lock);
-	if (!pmap_register) {
+	if (is_temporary) {
 		set_bit(SK_TEMP, &svsk->sk_flags);
 		list_add(&svsk->sk_list, &serv->sv_tempsocks);
 		serv->sv_tmpcnt++;
@@ -1567,7 +1570,7 @@ int svc_addsock(struct svc_serv *serv,
 	else if (so->state > SS_UNCONNECTED)
 		err = -EISCONN;
 	else {
-		svsk = svc_setup_socket(serv, so, &err, 1);
+		svsk = svc_setup_socket(serv, so, &err, SVC_SOCK_DEFAULTS);
 		if (svsk)
 			err = 0;
 	}
@@ -1583,8 +1586,8 @@ EXPORT_SYMBOL_GPL(svc_addsock);
 /*
  * Create socket for RPC service.
  */
-static int
-svc_create_socket(struct svc_serv *serv, int protocol, struct sockaddr_in *sin)
+static int svc_create_socket(struct svc_serv *serv, int protocol,
+				struct sockaddr_in *sin, int flags)
 {
 	struct svc_sock	*svsk;
 	struct socket	*sock;
@@ -1620,8 +1623,8 @@ svc_create_socket(struct svc_serv *serv,
 			goto bummer;
 	}
 
-	if ((svsk = svc_setup_socket(serv, sock, &error, 1)) != NULL)
-		return 0;
+	if ((svsk = svc_setup_socket(serv, sock, &error, flags)) != NULL)
+		return ntohs(inet_sk(svsk->sk_sk)->sport);
 
 bummer:
 	dprintk("svc: svc_create_socket error = %d\n", -error);
@@ -1681,19 +1684,23 @@ void svc_close_socket(struct svc_sock *s
 	svc_sock_put(svsk);
 }
 
-/*
- * Make a socket for nfsd and lockd
+/**
+ * svc_makesock - Make a socket for nfsd and lockd
+ * @serv: RPC server structure
+ * @protocol: transport protocol to use
+ * @port: port to use
+ *
  */
-int
-svc_makesock(struct svc_serv *serv, int protocol, unsigned short port)
+int svc_makesock(struct svc_serv *serv, int protocol, unsigned short port)
 {
-	struct sockaddr_in	sin;
+	struct sockaddr_in sin = {
+		.sin_family		= AF_INET,
+		.sin_addr.s_addr	= INADDR_ANY,
+		.sin_port		= htons(port),
+	};
 
 	dprintk("svc: creating socket proto = %d\n", protocol);
-	sin.sin_family      = AF_INET;
-	sin.sin_addr.s_addr = INADDR_ANY;
-	sin.sin_port        = htons(port);
-	return svc_create_socket(serv, protocol, &sin);
+	return svc_create_socket(serv, protocol, &sin, SVC_SOCK_DEFAULTS);
 }
 
 /*
_

Patches currently in -mm which might be from chuck.lever@oracle.com are

origin.patch
git-nfs.patch
