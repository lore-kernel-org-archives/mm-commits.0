From: akpm@linux-foundation.org
Subject: - knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:46:40 -0800
Message-ID: <200702122246.l1CMke4k013838@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45303 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030322AbXBLWqz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:46:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chuck.lever@oracle.com, aurelien.charbon@ext.bull.net, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: SUNRPC: Add a function to format the address in an svc_rqst for printing
has been removed from the -mm tree.  Its filename was
     knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: SUNRPC: Add a function to format the address in an svc_rqst for printing
From: Chuck Lever <chuck.lever@oracle.com>

There are loads of places where the RPC server assumes that the rq_addr fields
contains an IPv4 address.  Top among these are error and debugging messages
that display the server's IP address.

Let's refactor the address printing into a separate function that's smart
enough to figure out the difference between IPv4 and IPv6 addresses.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Aurelien Charbon <aurelien.charbon@ext.bull.net>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/lockd/svc.c             |    6 +-
 fs/lockd/svc4proc.c        |    7 +--
 fs/lockd/svcproc.c         |    7 +--
 fs/nfs/callback.c          |   12 ++++-
 fs/nfsd/nfsfh.c            |    7 +--
 fs/nfsd/nfsproc.c          |    7 +--
 include/linux/sunrpc/svc.h |    3 +
 net/sunrpc/svcsock.c       |   76 ++++++++++++++++++++++++++---------
 8 files changed, 86 insertions(+), 39 deletions(-)

diff -puN fs/lockd/svc.c~knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing fs/lockd/svc.c
--- a/fs/lockd/svc.c~knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing
+++ a/fs/lockd/svc.c
@@ -141,6 +141,7 @@ lockd(struct svc_rqst *rqstp)
 	 */
 	while ((nlmsvc_users || !signalled()) && nlmsvc_pid == current->pid) {
 		long timeout = MAX_SCHEDULE_TIMEOUT;
+		char buf[RPC_MAX_ADDRBUFLEN];
 
 		if (signalled()) {
 			flush_signals(current);
@@ -175,11 +176,10 @@ lockd(struct svc_rqst *rqstp)
 			break;
 		}
 
-		dprintk("lockd: request from %08x\n",
-			(unsigned)ntohl(rqstp->rq_addr.sin_addr.s_addr));
+		dprintk("lockd: request from %s\n",
+				svc_print_addr(rqstp, buf, sizeof(buf)));
 
 		svc_process(rqstp);
-
 	}
 
 	flush_signals(current);
diff -puN fs/lockd/svc4proc.c~knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing fs/lockd/svc4proc.c
--- a/fs/lockd/svc4proc.c~knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing
+++ a/fs/lockd/svc4proc.c
@@ -426,10 +426,9 @@ nlm4svc_proc_sm_notify(struct svc_rqst *
 	dprintk("lockd: SM_NOTIFY     called\n");
 	if (saddr.sin_addr.s_addr != htonl(INADDR_LOOPBACK)
 	 || ntohs(saddr.sin_port) >= 1024) {
-		printk(KERN_WARNING
-			"lockd: rejected NSM callback from %08x:%d\n",
-			ntohl(rqstp->rq_addr.sin_addr.s_addr),
-			ntohs(rqstp->rq_addr.sin_port));
+		char buf[RPC_MAX_ADDRBUFLEN];
+		printk(KERN_WARNING "lockd: rejected NSM callback from %s\n",
+				svc_print_addr(rqstp, buf, sizeof(buf)));
 		return rpc_system_err;
 	}
 
diff -puN fs/lockd/svcproc.c~knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing fs/lockd/svcproc.c
--- a/fs/lockd/svcproc.c~knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing
+++ a/fs/lockd/svcproc.c
@@ -457,10 +457,9 @@ nlmsvc_proc_sm_notify(struct svc_rqst *r
 	dprintk("lockd: SM_NOTIFY     called\n");
 	if (saddr.sin_addr.s_addr != htonl(INADDR_LOOPBACK)
 	 || ntohs(saddr.sin_port) >= 1024) {
-		printk(KERN_WARNING
-			"lockd: rejected NSM callback from %08x:%d\n",
-			ntohl(rqstp->rq_addr.sin_addr.s_addr),
-			ntohs(rqstp->rq_addr.sin_port));
+		char buf[RPC_MAX_ADDRBUFLEN];
+		printk(KERN_WARNING "lockd: rejected NSM callback from %s\n",
+				svc_print_addr(rqstp, buf, sizeof(buf)));
 		return rpc_system_err;
 	}
 
diff -puN fs/nfs/callback.c~knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing fs/nfs/callback.c
--- a/fs/nfs/callback.c~knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing
+++ a/fs/nfs/callback.c
@@ -71,6 +71,8 @@ static void nfs_callback_svc(struct svc_
 	complete(&nfs_callback_info.started);
 
 	for(;;) {
+		char buf[RPC_MAX_ADDRBUFLEN];
+
 		if (signalled()) {
 			if (nfs_callback_info.users == 0)
 				break;
@@ -88,8 +90,8 @@ static void nfs_callback_svc(struct svc_
 					__FUNCTION__, -err);
 			break;
 		}
-		dprintk("%s: request from %u.%u.%u.%u\n", __FUNCTION__,
-				NIPQUAD(rqstp->rq_addr.sin_addr.s_addr));
+		dprintk("%s: request from %s\n", __FUNCTION__,
+				svc_print_addr(rqstp, buf, sizeof(buf)));
 		svc_process(rqstp);
 	}
 
@@ -166,13 +168,17 @@ static int nfs_callback_authenticate(str
 {
 	struct sockaddr_in *addr = &rqstp->rq_addr;
 	struct nfs_client *clp;
+	char buf[RPC_MAX_ADDRBUFLEN];
 
 	/* Don't talk to strangers */
 	clp = nfs_find_client(addr, 4);
 	if (clp == NULL)
 		return SVC_DROP;
-	dprintk("%s: %u.%u.%u.%u NFSv4 callback!\n", __FUNCTION__, NIPQUAD(addr->sin_addr));
+
+	dprintk("%s: %s NFSv4 callback!\n", __FUNCTION__,
+			svc_print_addr(rqstp, buf, sizeof(buf)));
 	nfs_put_client(clp);
+
 	switch (rqstp->rq_authop->flavour) {
 		case RPC_AUTH_NULL:
 			if (rqstp->rq_proc != CB_NULL)
diff -puN fs/nfsd/nfsfh.c~knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing fs/nfsd/nfsfh.c
--- a/fs/nfsd/nfsfh.c~knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing
+++ a/fs/nfsd/nfsfh.c
@@ -20,6 +20,7 @@
 #include <linux/mount.h>
 #include <asm/pgtable.h>
 
+#include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/nfsd/nfsd.h>
 
@@ -180,10 +181,10 @@ fh_verify(struct svc_rqst *rqstp, struct
 		/* Check if the request originated from a secure port. */
 		error = nfserr_perm;
 		if (!rqstp->rq_secure && EX_SECURE(exp)) {
+			char buf[RPC_MAX_ADDRBUFLEN];
 			printk(KERN_WARNING
-			       "nfsd: request from insecure port (%u.%u.%u.%u:%d)!\n",
-			       NIPQUAD(rqstp->rq_addr.sin_addr.s_addr),
-			       ntohs(rqstp->rq_addr.sin_port));
+			       "nfsd: request from insecure port %s!\n",
+			       svc_print_addr(rqstp, buf, sizeof(buf)));
 			goto out;
 		}
 
diff -puN fs/nfsd/nfsproc.c~knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing fs/nfsd/nfsproc.c
--- a/fs/nfsd/nfsproc.c~knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing
+++ a/fs/nfsd/nfsproc.c
@@ -19,6 +19,7 @@
 #include <linux/unistd.h>
 #include <linux/slab.h>
 
+#include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/nfsd/nfsd.h>
 #include <linux/nfsd/cache.h>
@@ -147,10 +148,10 @@ nfsd_proc_read(struct svc_rqst *rqstp, s
 	 */
 
 	if (NFSSVC_MAXBLKSIZE_V2 < argp->count) {
+		char buf[RPC_MAX_ADDRBUFLEN];
 		printk(KERN_NOTICE
-			"oversized read request from %u.%u.%u.%u:%d (%d bytes)\n",
-				NIPQUAD(rqstp->rq_addr.sin_addr.s_addr),
-				ntohs(rqstp->rq_addr.sin_port),
+			"oversized read request from %s (%d bytes)\n",
+				svc_print_addr(rqstp, buf, sizeof(buf)),
 				argp->count);
 		argp->count = NFSSVC_MAXBLKSIZE_V2;
 	}
diff -puN include/linux/sunrpc/svc.h~knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing include/linux/sunrpc/svc.h
--- a/include/linux/sunrpc/svc.h~knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing
+++ a/include/linux/sunrpc/svc.h
@@ -368,5 +368,8 @@ int		   svc_register(struct svc_serv *, 
 void		   svc_wake_up(struct svc_serv *);
 void		   svc_reserve(struct svc_rqst *rqstp, int space);
 struct svc_pool *  svc_pool_for_cpu(struct svc_serv *serv, int cpu);
+char *		   svc_print_addr(struct svc_rqst *, char *, size_t);
+
+#define	RPC_MAX_ADDRBUFLEN	(63U)
 
 #endif /* SUNRPC_SVC_H */
diff -puN net/sunrpc/svcsock.c~knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing
+++ a/net/sunrpc/svcsock.c
@@ -41,6 +41,7 @@
 #include <asm/ioctls.h>
 
 #include <linux/sunrpc/types.h>
+#include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/xdr.h>
 #include <linux/sunrpc/svcsock.h>
 #include <linux/sunrpc/stats.h>
@@ -121,6 +122,41 @@ static inline void svc_reclassify_socket
 }
 #endif
 
+static char *__svc_print_addr(struct sockaddr *addr, char *buf, size_t len)
+{
+	switch (addr->sa_family) {
+	case AF_INET:
+		snprintf(buf, len, "%u.%u.%u.%u, port=%u",
+			NIPQUAD(((struct sockaddr_in *) addr)->sin_addr),
+			htons(((struct sockaddr_in *) addr)->sin_port));
+		break;
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+	case AF_INET6:
+		snprintf(buf, len, "%x:%x:%x:%x:%x:%x:%x:%x, port=%u",
+			NIP6(((struct sockaddr_in6 *) addr)->sin6_addr),
+			htons(((struct sockaddr_in6 *) addr)->sin6_port));
+		break;
+#endif
+	default:
+		snprintf(buf, len, "unknown address type: %d", addr->sa_family);
+		break;
+	}
+	return buf;
+}
+
+/**
+ * svc_print_addr - Format rq_addr field for printing
+ * @rqstp: svc_rqst struct containing address to print
+ * @buf: target buffer for formatted address
+ * @len: length of target buffer
+ *
+ */
+char *svc_print_addr(struct svc_rqst *rqstp, char *buf, size_t len)
+{
+	return __svc_print_addr((struct sockaddr *) &rqstp->rq_addr, buf, len);
+}
+EXPORT_SYMBOL_GPL(svc_print_addr);
+
 /*
  * Queue up an idle server thread.  Must have pool->sp_lock held.
  * Note: this is really a stack rather than a queue, so that we only
@@ -429,6 +465,7 @@ svc_sendto(struct svc_rqst *rqstp, struc
 	size_t		base = xdr->page_base;
 	unsigned int	pglen = xdr->page_len;
 	unsigned int	flags = MSG_MORE;
+	char		buf[RPC_MAX_ADDRBUFLEN];
 
 	slen = xdr->len;
 
@@ -491,9 +528,9 @@ svc_sendto(struct svc_rqst *rqstp, struc
 			len += result;
 	}
 out:
-	dprintk("svc: socket %p sendto([%p %Zu... ], %d) = %d (addr %x)\n",
-			rqstp->rq_sock, xdr->head[0].iov_base, xdr->head[0].iov_len, xdr->len, len,
-		rqstp->rq_addr.sin_addr.s_addr);
+	dprintk("svc: socket %p sendto([%p %Zu... ], %d) = %d (addr %s)\n",
+		rqstp->rq_sock, xdr->head[0].iov_base, xdr->head[0].iov_len,
+		xdr->len, len, svc_print_addr(rqstp, buf, sizeof(buf)));
 
 	return len;
 }
@@ -878,6 +915,7 @@ svc_tcp_accept(struct svc_sock *svsk)
 	struct socket	*newsock;
 	struct svc_sock	*newsvsk;
 	int		err, slen;
+	char		buf[RPC_MAX_ADDRBUFLEN];
 
 	dprintk("svc: tcp_accept %p sock %p\n", svsk, sock);
 	if (!sock)
@@ -908,18 +946,19 @@ svc_tcp_accept(struct svc_sock *svsk)
 	}
 
 	/* Ideally, we would want to reject connections from unauthorized
-	 * hosts here, but when we get encription, the IP of the host won't
-	 * tell us anything. For now just warn about unpriv connections.
+	 * hosts here, but when we get encryption, the IP of the host won't
+	 * tell us anything.  For now just warn about unpriv connections.
 	 */
 	if (ntohs(sin.sin_port) >= 1024) {
 		dprintk(KERN_WARNING
-			"%s: connect from unprivileged port: %u.%u.%u.%u:%d\n",
+			"%s: connect from unprivileged port: %s\n",
 			serv->sv_name,
-			NIPQUAD(sin.sin_addr.s_addr), ntohs(sin.sin_port));
+			__svc_print_addr((struct sockaddr *) &sin, buf,
+								sizeof(buf)));
 	}
-
-	dprintk("%s: connect from %u.%u.%u.%u:%04x\n", serv->sv_name,
-			NIPQUAD(sin.sin_addr.s_addr), ntohs(sin.sin_port));
+	dprintk("%s: connect from %s\n", serv->sv_name,
+		__svc_print_addr((struct sockaddr *) &sin, buf,
+				 sizeof(buf)));
 
 	/* make sure that a write doesn't block forever when
 	 * low on memory
@@ -955,11 +994,9 @@ svc_tcp_accept(struct svc_sock *svsk)
 					"sockets, consider increasing the "
 					"number of nfsd threads\n",
 						   serv->sv_name);
-				printk(KERN_NOTICE "%s: last TCP connect from "
-					"%u.%u.%u.%u:%d\n",
-					serv->sv_name,
-					NIPQUAD(sin.sin_addr.s_addr),
-					ntohs(sin.sin_port));
+				printk(KERN_NOTICE
+				       "%s: last TCP connect from %s\n",
+				       serv->sv_name, buf);
 			}
 			/*
 			 * Always select the oldest socket. It's not fair,
@@ -1587,11 +1624,12 @@ static int svc_create_socket(struct svc_
 	struct socket	*sock;
 	int		error;
 	int		type;
+	char		buf[RPC_MAX_ADDRBUFLEN];
 
-	dprintk("svc: svc_create_socket(%s, %d, %u.%u.%u.%u:%d)\n",
-				serv->sv_program->pg_name, protocol,
-				NIPQUAD(sin->sin_addr.s_addr),
-				ntohs(sin->sin_port));
+	dprintk("svc: svc_create_socket(%s, %d, %s)\n",
+			serv->sv_program->pg_name, protocol,
+			__svc_print_addr((struct sockaddr *) sin, buf,
+								sizeof(buf)));
 
 	if (protocol != IPPROTO_UDP && protocol != IPPROTO_TCP) {
 		printk(KERN_WARNING "svc: only UDP and TCP "
_

Patches currently in -mm which might be from chuck.lever@oracle.com are

origin.patch
git-nfs.patch
