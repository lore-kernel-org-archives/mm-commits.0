From: akpm@linux-foundation.org
Subject: - knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:46:33 -0800
Message-ID: <200702122246.l1CMkX64013821@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45266 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030310AbXBLWql (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:46:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chuck.lever@oracle.com, aurelien.charbon@ext.bull.net, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: SUNRPC: allow creating an RPC service without registering with portmapper
has been removed from the -mm tree.  Its filename was
     knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: SUNRPC: allow creating an RPC service without registering with portmapper
From: Chuck Lever <chuck.lever@oracle.com>

Sometimes we need to create an RPC service but not register it with the local
portmapper.  NFSv4 delegation callback, for example.

Change the svc_makesock() API to allow optionally creating temporary or
permanent sockets, optionally registering with the local portmapper, and make
it return the ephemeral port of the new socket.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Aurelien Charbon <aurelien.charbon@ext.bull.net>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/lockd/svc.c                 |   26 ++++++++++++++++----------
 fs/nfs/callback.c              |   20 +++++++++-----------
 fs/nfsd/nfssvc.c               |    6 ++++--
 include/linux/sunrpc/svcsock.h |    2 +-
 net/sunrpc/svcsock.c           |    6 ++++--
 5 files changed, 34 insertions(+), 26 deletions(-)

diff -puN fs/lockd/svc.c~knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper fs/lockd/svc.c
--- a/fs/lockd/svc.c~knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper
+++ a/fs/lockd/svc.c
@@ -223,23 +223,29 @@ static int find_socket(struct svc_serv *
 	return found;
 }
 
+/*
+ * Make any sockets that are needed but not present.
+ * If nlm_udpport or nlm_tcpport were set as module
+ * options, make those sockets unconditionally
+ */
 static int make_socks(struct svc_serv *serv, int proto)
 {
-	/* Make any sockets that are needed but not present.
-	 * If nlm_udpport or nlm_tcpport were set as module
-	 * options, make those sockets unconditionally
-	 */
-	static int		warned;
+	static int warned;
 	int err = 0;
+
 	if (proto == IPPROTO_UDP || nlm_udpport)
 		if (!find_socket(serv, IPPROTO_UDP))
-			err = svc_makesock(serv, IPPROTO_UDP, nlm_udpport);
-	if (err == 0 && (proto == IPPROTO_TCP || nlm_tcpport))
+			err = svc_makesock(serv, IPPROTO_UDP, nlm_udpport,
+						SVC_SOCK_DEFAULTS);
+	if (err >= 0 && (proto == IPPROTO_TCP || nlm_tcpport))
 		if (!find_socket(serv, IPPROTO_TCP))
-			err= svc_makesock(serv, IPPROTO_TCP, nlm_tcpport);
-	if (!err)
+			err = svc_makesock(serv, IPPROTO_TCP, nlm_tcpport,
+						SVC_SOCK_DEFAULTS);
+
+	if (err >= 0) {
 		warned = 0;
-	else if (warned++ == 0)
+		err = 0;
+	} else if (warned++ == 0)
 		printk(KERN_WARNING
 		       "lockd_up: makesock failed, error=%d\n", err);
 	return err;
diff -puN fs/nfs/callback.c~knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper fs/nfs/callback.c
--- a/fs/nfs/callback.c~knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper
+++ a/fs/nfs/callback.c
@@ -106,7 +106,6 @@ static void nfs_callback_svc(struct svc_
 int nfs_callback_up(void)
 {
 	struct svc_serv *serv;
-	struct svc_sock *svsk;
 	int ret = 0;
 
 	lock_kernel();
@@ -119,17 +118,14 @@ int nfs_callback_up(void)
 	ret = -ENOMEM;
 	if (!serv)
 		goto out_err;
-	/* FIXME: We don't want to register this socket with the portmapper */
-	ret = svc_makesock(serv, IPPROTO_TCP, nfs_callback_set_tcpport);
-	if (ret < 0)
+
+	ret = svc_makesock(serv, IPPROTO_TCP, nfs_callback_set_tcpport,
+							SVC_SOCK_ANONYMOUS);
+	if (ret <= 0)
 		goto out_destroy;
-	if (!list_empty(&serv->sv_permsocks)) {
-		svsk = list_entry(serv->sv_permsocks.next,
-				struct svc_sock, sk_list);
-		nfs_callback_tcpport = ntohs(inet_sk(svsk->sk_sk)->sport);
-		dprintk ("Callback port = 0x%x\n", nfs_callback_tcpport);
-	} else
-		BUG();
+	nfs_callback_tcpport = ret;
+	dprintk("Callback port = 0x%x\n", nfs_callback_tcpport);
+
 	ret = svc_create_thread(nfs_callback_svc, serv);
 	if (ret < 0)
 		goto out_destroy;
@@ -140,6 +136,8 @@ out:
 	unlock_kernel();
 	return ret;
 out_destroy:
+	dprintk("Couldn't create callback socket or server thread; err = %d\n",
+		ret);
 	svc_destroy(serv);
 out_err:
 	nfs_callback_info.users--;
diff -puN fs/nfsd/nfssvc.c~knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper fs/nfsd/nfssvc.c
--- a/fs/nfsd/nfssvc.c~knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper
+++ a/fs/nfsd/nfssvc.c
@@ -235,7 +235,8 @@ static int nfsd_init_socks(int port)
 
 	error = lockd_up(IPPROTO_UDP);
 	if (error >= 0) {
-		error = svc_makesock(nfsd_serv, IPPROTO_UDP, port);
+		error = svc_makesock(nfsd_serv, IPPROTO_UDP, port,
+					SVC_SOCK_DEFAULTS);
 		if (error < 0)
 			lockd_down();
 	}
@@ -245,7 +246,8 @@ static int nfsd_init_socks(int port)
 #ifdef CONFIG_NFSD_TCP
 	error = lockd_up(IPPROTO_TCP);
 	if (error >= 0) {
-		error = svc_makesock(nfsd_serv, IPPROTO_TCP, port);
+		error = svc_makesock(nfsd_serv, IPPROTO_TCP, port,
+					SVC_SOCK_DEFAULTS);
 		if (error < 0)
 			lockd_down();
 	}
diff -puN include/linux/sunrpc/svcsock.h~knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper include/linux/sunrpc/svcsock.h
--- a/include/linux/sunrpc/svcsock.h~knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper
+++ a/include/linux/sunrpc/svcsock.h
@@ -62,7 +62,7 @@ struct svc_sock {
 /*
  * Function prototypes.
  */
-int		svc_makesock(struct svc_serv *, int, unsigned short);
+int		svc_makesock(struct svc_serv *, int, unsigned short, int flags);
 void		svc_close_socket(struct svc_sock *);
 int		svc_recv(struct svc_rqst *, long);
 int		svc_send(struct svc_rqst *);
diff -puN net/sunrpc/svcsock.c~knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper
+++ a/net/sunrpc/svcsock.c
@@ -1689,9 +1689,11 @@ void svc_close_socket(struct svc_sock *s
  * @serv: RPC server structure
  * @protocol: transport protocol to use
  * @port: port to use
+ * @flags: requested socket characteristics
  *
  */
-int svc_makesock(struct svc_serv *serv, int protocol, unsigned short port)
+int svc_makesock(struct svc_serv *serv, int protocol, unsigned short port,
+			int flags)
 {
 	struct sockaddr_in sin = {
 		.sin_family		= AF_INET,
@@ -1700,7 +1702,7 @@ int svc_makesock(struct svc_serv *serv, 
 	};
 
 	dprintk("svc: creating socket proto = %d\n", protocol);
-	return svc_create_socket(serv, protocol, &sin, SVC_SOCK_DEFAULTS);
+	return svc_create_socket(serv, protocol, &sin, flags);
 }
 
 /*
_

Patches currently in -mm which might be from chuck.lever@oracle.com are

origin.patch
git-nfs.patch
