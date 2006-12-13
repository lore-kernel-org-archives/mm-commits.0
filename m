From: akpm@osdl.org
Subject: + knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses.patch added to -mm tree
Date: Tue, 12 Dec 2006 17:36:13 -0800
Message-ID: <200612130136.kBD1aDSM024095@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38698 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964861AbWLMBjv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 20:39:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chuck.lever@oracle.com, aurelien.charbon@ext.bull.net, neilb@suse.de


The patch titled
     knfsd: SUNRPC: Provide room in svc_rqst for larger addresses
has been added to the -mm tree.  Its filename is
     knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: SUNRPC: Provide room in svc_rqst for larger addresses
From: Chuck Lever <chuck.lever@oracle.com>

Expand the rq_addr field to allow it to contain larger addresses.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Aurelien Charbon <aurelien.charbon@ext.bull.net>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/lockd/host.c            |    2 +-
 fs/lockd/svc4proc.c        |    6 ++++--
 fs/lockd/svcproc.c         |    6 ++++--
 fs/nfs/callback.c          |    2 +-
 fs/nfs/callback_xdr.c      |    4 ++--
 fs/nfsd/nfs4state.c        |   18 +++++++++---------
 fs/nfsd/nfscache.c         |    2 +-
 include/linux/sunrpc/svc.h |   15 ++++++++++++++-
 net/sunrpc/svcauth_unix.c  |    3 ++-
 net/sunrpc/svcsock.c       |   16 +++++++++-------
 10 files changed, 47 insertions(+), 27 deletions(-)

diff -puN fs/lockd/host.c~knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses fs/lockd/host.c
--- a/fs/lockd/host.c~knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses
+++ a/fs/lockd/host.c
@@ -192,7 +192,7 @@ struct nlm_host *
 nlmsvc_lookup_host(struct svc_rqst *rqstp,
 			const char *hostname, int hostname_len)
 {
-	return nlm_lookup_host(1, &rqstp->rq_addr,
+	return nlm_lookup_host(1, svc_addr_in(rqstp),
 			       rqstp->rq_prot, rqstp->rq_vers,
 			       hostname, hostname_len);
 }
diff -puN fs/lockd/svc4proc.c~knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses fs/lockd/svc4proc.c
--- a/fs/lockd/svc4proc.c~knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses
+++ a/fs/lockd/svc4proc.c
@@ -224,7 +224,7 @@ nlm4svc_proc_granted(struct svc_rqst *rq
 	resp->cookie = argp->cookie;
 
 	dprintk("lockd: GRANTED       called\n");
-	resp->status = nlmclnt_grant(&rqstp->rq_addr, &argp->lock);
+	resp->status = nlmclnt_grant(svc_addr_in(rqstp), &argp->lock);
 	dprintk("lockd: GRANTED       status %d\n", ntohl(resp->status));
 	return rpc_success;
 }
@@ -421,7 +421,9 @@ static __be32
 nlm4svc_proc_sm_notify(struct svc_rqst *rqstp, struct nlm_reboot *argp,
 					      void	        *resp)
 {
-	struct sockaddr_in	saddr = rqstp->rq_addr;
+	struct sockaddr_in	saddr;
+
+	memcpy(&saddr, svc_addr_in(rqstp), sizeof(saddr));
 
 	dprintk("lockd: SM_NOTIFY     called\n");
 	if (saddr.sin_addr.s_addr != htonl(INADDR_LOOPBACK)
diff -puN fs/lockd/svcproc.c~knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses fs/lockd/svcproc.c
--- a/fs/lockd/svcproc.c~knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses
+++ a/fs/lockd/svcproc.c
@@ -253,7 +253,7 @@ nlmsvc_proc_granted(struct svc_rqst *rqs
 	resp->cookie = argp->cookie;
 
 	dprintk("lockd: GRANTED       called\n");
-	resp->status = nlmclnt_grant(&rqstp->rq_addr, &argp->lock);
+	resp->status = nlmclnt_grant(svc_addr_in(rqstp), &argp->lock);
 	dprintk("lockd: GRANTED       status %d\n", ntohl(resp->status));
 	return rpc_success;
 }
@@ -452,7 +452,9 @@ static __be32
 nlmsvc_proc_sm_notify(struct svc_rqst *rqstp, struct nlm_reboot *argp,
 					      void	        *resp)
 {
-	struct sockaddr_in	saddr = rqstp->rq_addr;
+	struct sockaddr_in	saddr;
+
+	memcpy(&saddr, svc_addr_in(rqstp), sizeof(saddr));
 
 	dprintk("lockd: SM_NOTIFY     called\n");
 	if (saddr.sin_addr.s_addr != htonl(INADDR_LOOPBACK)
diff -puN fs/nfs/callback.c~knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses fs/nfs/callback.c
--- a/fs/nfs/callback.c~knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses
+++ a/fs/nfs/callback.c
@@ -166,7 +166,7 @@ void nfs_callback_down(void)
 
 static int nfs_callback_authenticate(struct svc_rqst *rqstp)
 {
-	struct sockaddr_in *addr = &rqstp->rq_addr;
+	struct sockaddr_in *addr = svc_addr_in(rqstp);
 	struct nfs_client *clp;
 	char buf[RPC_MAX_ADDRBUFLEN];
 
diff -puN fs/nfs/callback_xdr.c~knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses fs/nfs/callback_xdr.c
--- a/fs/nfs/callback_xdr.c~knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses
+++ a/fs/nfs/callback_xdr.c
@@ -176,7 +176,7 @@ static __be32 decode_getattr_args(struct
 	status = decode_fh(xdr, &args->fh);
 	if (unlikely(status != 0))
 		goto out;
-	args->addr = &rqstp->rq_addr;
+	args->addr = svc_addr_in(rqstp);
 	status = decode_bitmap(xdr, args->bitmap);
 out:
 	dprintk("%s: exit with status = %d\n", __FUNCTION__, status);
@@ -188,7 +188,7 @@ static __be32 decode_recall_args(struct 
 	__be32 *p;
 	__be32 status;
 
-	args->addr = &rqstp->rq_addr;
+	args->addr = svc_addr_in(rqstp);
 	status = decode_stateid(xdr, &args->stateid);
 	if (unlikely(status != 0))
 		goto out;
diff -puN fs/nfsd/nfs4state.c~knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses
+++ a/fs/nfsd/nfs4state.c
@@ -714,7 +714,7 @@ __be32
 nfsd4_setclientid(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		  struct nfsd4_setclientid *setclid)
 {
-	__be32 			ip_addr = rqstp->rq_addr.sin_addr.s_addr;
+	struct sockaddr_in	*sin = svc_addr_in(rqstp);
 	struct xdr_netobj 	clname = { 
 		.len = setclid->se_namelen,
 		.data = setclid->se_name,
@@ -749,7 +749,7 @@ nfsd4_setclientid(struct svc_rqst *rqstp
 		 */
 		status = nfserr_clid_inuse;
 		if (!cmp_creds(&conf->cl_cred, &rqstp->rq_cred)
-				|| conf->cl_addr != ip_addr) {
+				|| conf->cl_addr != sin->sin_addr.s_addr) {
 			printk("NFSD: setclientid: string in use by client"
 			"(clientid %08x/%08x)\n",
 			conf->cl_clientid.cl_boot, conf->cl_clientid.cl_id);
@@ -769,7 +769,7 @@ nfsd4_setclientid(struct svc_rqst *rqstp
 		if (new == NULL)
 			goto out;
 		copy_verf(new, &clverifier);
-		new->cl_addr = ip_addr;
+		new->cl_addr = sin->sin_addr.s_addr;
 		copy_cred(&new->cl_cred,&rqstp->rq_cred);
 		gen_clid(new);
 		gen_confirm(new);
@@ -801,7 +801,7 @@ nfsd4_setclientid(struct svc_rqst *rqstp
 		if (new == NULL)
 			goto out;
 		copy_verf(new,&conf->cl_verifier);
-		new->cl_addr = ip_addr;
+		new->cl_addr = sin->sin_addr.s_addr;
 		copy_cred(&new->cl_cred,&rqstp->rq_cred);
 		copy_clid(new, conf);
 		gen_confirm(new);
@@ -820,7 +820,7 @@ nfsd4_setclientid(struct svc_rqst *rqstp
 		if (new == NULL)
 			goto out;
 		copy_verf(new,&clverifier);
-		new->cl_addr = ip_addr;
+		new->cl_addr = sin->sin_addr.s_addr;
 		copy_cred(&new->cl_cred,&rqstp->rq_cred);
 		gen_clid(new);
 		gen_confirm(new);
@@ -847,7 +847,7 @@ nfsd4_setclientid(struct svc_rqst *rqstp
 		if (new == NULL)
 			goto out;
 		copy_verf(new,&clverifier);
-		new->cl_addr = ip_addr;
+		new->cl_addr = sin->sin_addr.s_addr;
 		copy_cred(&new->cl_cred,&rqstp->rq_cred);
 		gen_clid(new);
 		gen_confirm(new);
@@ -881,7 +881,7 @@ nfsd4_setclientid_confirm(struct svc_rqs
 			 struct nfsd4_compound_state *cstate,
 			 struct nfsd4_setclientid_confirm *setclientid_confirm)
 {
-	__be32 ip_addr = rqstp->rq_addr.sin_addr.s_addr;
+	struct sockaddr_in *sin = svc_addr_in(rqstp);
 	struct nfs4_client *conf, *unconf;
 	nfs4_verifier confirm = setclientid_confirm->sc_confirm; 
 	clientid_t * clid = &setclientid_confirm->sc_clientid;
@@ -900,9 +900,9 @@ nfsd4_setclientid_confirm(struct svc_rqs
 	unconf = find_unconfirmed_client(clid);
 
 	status = nfserr_clid_inuse;
-	if (conf && conf->cl_addr != ip_addr)
+	if (conf && conf->cl_addr != sin->sin_addr.s_addr)
 		goto out;
-	if (unconf && unconf->cl_addr != ip_addr)
+	if (unconf && unconf->cl_addr != sin->sin_addr.s_addr)
 		goto out;
 
 	if ((conf && unconf) && 
diff -puN fs/nfsd/nfscache.c~knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses fs/nfsd/nfscache.c
--- a/fs/nfsd/nfscache.c~knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses
+++ a/fs/nfsd/nfscache.c
@@ -185,7 +185,7 @@ nfsd_cache_lookup(struct svc_rqst *rqstp
 	rp->c_state = RC_INPROG;
 	rp->c_xid = xid;
 	rp->c_proc = proc;
-	rp->c_addr = rqstp->rq_addr;
+	memcpy(&rp->c_addr, svc_addr_in(rqstp), sizeof(rp->c_addr));
 	rp->c_prot = proto;
 	rp->c_vers = vers;
 	rp->c_timestamp = jiffies;
diff -puN include/linux/sunrpc/svc.h~knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses include/linux/sunrpc/svc.h
--- a/include/linux/sunrpc/svc.h~knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses
+++ a/include/linux/sunrpc/svc.h
@@ -197,7 +197,7 @@ struct svc_rqst {
 	struct list_head	rq_list;	/* idle list */
 	struct list_head	rq_all;		/* all threads list */
 	struct svc_sock *	rq_sock;	/* socket */
-	struct sockaddr_in	rq_addr;	/* peer address */
+	struct sockaddr_storage	rq_addr;	/* peer address */
 	int			rq_addrlen;
 
 	struct svc_serv *	rq_server;	/* RPC service definition */
@@ -253,6 +253,19 @@ struct svc_rqst {
 };
 
 /*
+ * Rigorous type checking on sockaddr type conversions
+ */
+static inline struct sockaddr_in *svc_addr_in(struct svc_rqst *rqst)
+{
+	return (struct sockaddr_in *) &rqst->rq_addr;
+}
+
+static inline struct sockaddr *svc_addr(struct svc_rqst *rqst)
+{
+	return (struct sockaddr *) &rqst->rq_addr;
+}
+
+/*
  * Check buffer bounds after decoding arguments
  */
 static inline int
diff -puN net/sunrpc/svcauth_unix.c~knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses net/sunrpc/svcauth_unix.c
--- a/net/sunrpc/svcauth_unix.c~knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses
+++ a/net/sunrpc/svcauth_unix.c
@@ -421,6 +421,7 @@ svcauth_unix_info_release(void *info)
 static int
 svcauth_unix_set_client(struct svc_rqst *rqstp)
 {
+	struct sockaddr_in *sin = svc_addr_in(rqstp);
 	struct ip_map *ipm;
 
 	rqstp->rq_client = NULL;
@@ -430,7 +431,7 @@ svcauth_unix_set_client(struct svc_rqst 
 	ipm = ip_map_cached_get(rqstp);
 	if (ipm == NULL)
 		ipm = ip_map_lookup(rqstp->rq_server->sv_program->pg_class,
-				    rqstp->rq_addr.sin_addr);
+				    sin->sin_addr);
 
 	if (ipm == NULL)
 		return SVC_DENIED;
diff -puN net/sunrpc/svcsock.c~knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~knfsd-sunrpc-provide-room-in-svc_rqst-for-larger-addresses
+++ a/net/sunrpc/svcsock.c
@@ -146,7 +146,7 @@ static char *__svc_print_addr(struct soc
  */
 char *svc_print_addr(struct svc_rqst *rqstp, char *buf, size_t len)
 {
-	return __svc_print_addr((struct sockaddr *) &rqstp->rq_addr, buf, len);
+	return __svc_print_addr(svc_addr(rqstp), buf, len);
 }
 EXPORT_SYMBOL_GPL(svc_print_addr);
 
@@ -465,7 +465,7 @@ svc_sendto(struct svc_rqst *rqstp, struc
 		/* set the source and destination */
 		struct msghdr	msg;
 		msg.msg_name    = &rqstp->rq_addr;
-		msg.msg_namelen = sizeof(rqstp->rq_addr);
+		msg.msg_namelen = rqstp->rq_addrlen;
 		msg.msg_iov     = NULL;
 		msg.msg_iovlen  = 0;
 		msg.msg_flags	= MSG_MORE;
@@ -688,6 +688,7 @@ svc_write_space(struct sock *sk)
 static int
 svc_udp_recvfrom(struct svc_rqst *rqstp)
 {
+	struct sockaddr_in *sin = svc_addr_in(rqstp);
 	struct svc_sock	*svsk = rqstp->rq_sock;
 	struct svc_serv	*serv = svsk->sk_server;
 	struct sk_buff	*skb;
@@ -743,9 +744,9 @@ svc_udp_recvfrom(struct svc_rqst *rqstp)
 	rqstp->rq_prot        = IPPROTO_UDP;
 
 	/* Get sender address */
-	rqstp->rq_addr.sin_family = AF_INET;
-	rqstp->rq_addr.sin_port = skb->h.uh->source;
-	rqstp->rq_addr.sin_addr.s_addr = skb->nh.iph->saddr;
+	sin->sin_family = AF_INET;
+	sin->sin_port = skb->h.uh->source;
+	sin->sin_addr.s_addr = skb->nh.iph->saddr;
 	rqstp->rq_daddr = skb->nh.iph->daddr;
 
 	if (skb_is_nonlinear(skb)) {
@@ -1276,7 +1277,8 @@ svc_sock_update_bufs(struct svc_serv *se
 int
 svc_recv(struct svc_rqst *rqstp, long timeout)
 {
-	struct svc_sock		*svsk =NULL;
+	struct svc_sock		*svsk = NULL;
+	struct sockaddr_in	*sin = svc_addr_in(rqstp);
 	struct svc_serv		*serv = rqstp->rq_server;
 	struct svc_pool		*pool = rqstp->rq_pool;
 	int			len, i;
@@ -1371,7 +1373,7 @@ svc_recv(struct svc_rqst *rqstp, long ti
 	svsk->sk_lastrecv = get_seconds();
 	clear_bit(SK_OLD, &svsk->sk_flags);
 
-	rqstp->rq_secure  = ntohs(rqstp->rq_addr.sin_port) < 1024;
+	rqstp->rq_secure = ntohs(sin->sin_port) < 1024;
 	rqstp->rq_chandle.defer = svc_defer;
 
 	if (serv->sv_stats)
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

