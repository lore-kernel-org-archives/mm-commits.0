From: akpm@osdl.org
Subject: + knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch added to -mm tree
Date: Tue, 12 Dec 2006 17:36:01 -0800
Message-ID: <200612130136.kBD1a1Zg024068@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38697 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964781AbWLMBju (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 20:39:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chuck.lever@oracle.com, aurelien.charbon@ext.bull.net, neilb@suse.de


The patch titled
     knfsd: SUNRPC: update internal API: separate pmap register and temp sockets
has been added to the -mm tree.  Its filename is
     knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@osdl.org>
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
@@ -69,7 +69,7 @@
 
 
 static struct svc_sock *svc_setup_socket(struct svc_serv *, struct socket *,
-					 int *errp, int pmap_reg);
+					 int *, int);
 static void		svc_udp_data_ready(struct sock *, int);
 static int		svc_udp_recvfrom(struct svc_rqst *);
 static int		svc_udp_sendto(struct svc_rqst *);
@@ -922,7 +922,8 @@ svc_tcp_accept(struct svc_sock *svsk)
 	 */
 	newsock->sk->sk_sndtimeo = HZ*30;
 
-	if (!(newsvsk = svc_setup_socket(serv, newsock, &err, 0)))
+	if (!(newsvsk = svc_setup_socket(serv, newsock, &err,
+				 (SVC_SOCK_ANONYMOUS | SVC_SOCK_TEMPORARY))))
 		goto failed;
 
 
@@ -1456,12 +1457,14 @@ svc_age_temp_sockets(unsigned long closu
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
@@ -1503,7 +1506,7 @@ svc_setup_socket(struct svc_serv *serv, 
 		svc_tcp_init(svsk);
 
 	spin_lock_bh(&serv->sv_lock);
-	if (!pmap_register) {
+	if (is_temporary) {
 		set_bit(SK_TEMP, &svsk->sk_flags);
 		list_add(&svsk->sk_list, &serv->sv_tempsocks);
 		serv->sv_tmpcnt++;
@@ -1547,7 +1550,7 @@ int svc_addsock(struct svc_serv *serv,
 	else if (so->state > SS_UNCONNECTED)
 		err = -EISCONN;
 	else {
-		svsk = svc_setup_socket(serv, so, &err, 1);
+		svsk = svc_setup_socket(serv, so, &err, SVC_SOCK_DEFAULTS);
 		if (svsk)
 			err = 0;
 	}
@@ -1563,8 +1566,8 @@ EXPORT_SYMBOL_GPL(svc_addsock);
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
@@ -1600,8 +1603,8 @@ svc_create_socket(struct svc_serv *serv,
 			goto bummer;
 	}
 
-	if ((svsk = svc_setup_socket(serv, sock, &error, 1)) != NULL)
-		return 0;
+	if ((svsk = svc_setup_socket(serv, sock, &error, flags)) != NULL)
+		return ntohs(inet_sk(svsk->sk_sk)->sport);
 
 bummer:
 	dprintk("svc: svc_create_socket error = %d\n", -error);
@@ -1651,19 +1654,23 @@ svc_delete_socket(struct svc_sock *svsk)
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

