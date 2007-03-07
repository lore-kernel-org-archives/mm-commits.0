From: akpm@linux-foundation.org
Subject: - knfsd-fix-recently-introduced-problem-with-shutting-down-a-busy-nfs-server.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:21:52 -0800
Message-ID: <200703070421.l274LqZK018943@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47078 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213AbXCGEV4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:21:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: fix recently introduced problem with shutting down a busy NFS server
has been removed from the -mm tree.  Its filename was
     knfsd-fix-recently-introduced-problem-with-shutting-down-a-busy-nfs-server.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: fix recently introduced problem with shutting down a busy NFS server
From: NeilBrown <neilb@suse.de>

When the last thread of nfsd exits, it shuts down all related sockets.  It
currently uses svc_close_socket to do this, but that only is immediately
effective if the socket is not SK_BUSY.

If the socket is busy - i.e.  if a request has arrived that has not yet been
processes - svc_close_socket is not effective and the shutdown process spins.

So create a new svc_force_close_socket which removes the SK_BUSY flag is set
and then calls svc_close_socket.

Also change some open-codes loops in svc_destroy to use
list_for_each_entry_safe.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sunrpc/svcsock.h |    2 +-
 net/sunrpc/svc.c               |   21 +++++++++------------
 net/sunrpc/svcsock.c           |   16 +++++++++++++++-
 3 files changed, 25 insertions(+), 14 deletions(-)

diff -puN include/linux/sunrpc/svcsock.h~knfsd-fix-recently-introduced-problem-with-shutting-down-a-busy-nfs-server include/linux/sunrpc/svcsock.h
--- a/include/linux/sunrpc/svcsock.h~knfsd-fix-recently-introduced-problem-with-shutting-down-a-busy-nfs-server
+++ a/include/linux/sunrpc/svcsock.h
@@ -66,7 +66,7 @@ struct svc_sock {
  * Function prototypes.
  */
 int		svc_makesock(struct svc_serv *, int, unsigned short, int flags);
-void		svc_close_socket(struct svc_sock *);
+void		svc_force_close_socket(struct svc_sock *);
 int		svc_recv(struct svc_rqst *, long);
 int		svc_send(struct svc_rqst *);
 void		svc_drop(struct svc_rqst *);
diff -puN net/sunrpc/svc.c~knfsd-fix-recently-introduced-problem-with-shutting-down-a-busy-nfs-server net/sunrpc/svc.c
--- a/net/sunrpc/svc.c~knfsd-fix-recently-introduced-problem-with-shutting-down-a-busy-nfs-server
+++ a/net/sunrpc/svc.c
@@ -367,6 +367,7 @@ void
 svc_destroy(struct svc_serv *serv)
 {
 	struct svc_sock	*svsk;
+	struct svc_sock *tmp;
 
 	dprintk("svc: svc_destroy(%s, %d)\n",
 				serv->sv_program->pg_name,
@@ -382,21 +383,17 @@ svc_destroy(struct svc_serv *serv)
 
 	del_timer_sync(&serv->sv_temptimer);
 
-	while (!list_empty(&serv->sv_tempsocks)) {
-		svsk = list_entry(serv->sv_tempsocks.next,
-				  struct svc_sock,
-				  sk_list);
-		svc_close_socket(svsk);
-	}
+	list_for_each_entry_safe(svsk, tmp, &serv->sv_tempsocks, sk_list)
+		svc_force_close_socket(svsk);
+
 	if (serv->sv_shutdown)
 		serv->sv_shutdown(serv);
 
-	while (!list_empty(&serv->sv_permsocks)) {
-		svsk = list_entry(serv->sv_permsocks.next,
-				  struct svc_sock,
-				  sk_list);
-		svc_close_socket(svsk);
-	}
+	list_for_each_entry_safe(svsk, tmp, &serv->sv_permsocks, sk_list)
+		svc_force_close_socket(svsk);
+
+	BUG_ON(!list_empty(&serv->sv_permsocks));
+	BUG_ON(!list_empty(&serv->sv_tempsocks));
 
 	cache_clean_deferred(serv);
 
diff -puN net/sunrpc/svcsock.c~knfsd-fix-recently-introduced-problem-with-shutting-down-a-busy-nfs-server net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~knfsd-fix-recently-introduced-problem-with-shutting-down-a-busy-nfs-server
+++ a/net/sunrpc/svcsock.c
@@ -82,6 +82,7 @@ static void		svc_delete_socket(struct sv
 static void		svc_udp_data_ready(struct sock *, int);
 static int		svc_udp_recvfrom(struct svc_rqst *);
 static int		svc_udp_sendto(struct svc_rqst *);
+static void		svc_close_socket(struct svc_sock *svsk);
 
 static struct svc_deferred_req *svc_deferred_dequeue(struct svc_sock *svsk);
 static int svc_deferred_recv(struct svc_rqst *rqstp);
@@ -1787,7 +1788,7 @@ svc_delete_socket(struct svc_sock *svsk)
 	spin_unlock_bh(&serv->sv_lock);
 }
 
-void svc_close_socket(struct svc_sock *svsk)
+static void svc_close_socket(struct svc_sock *svsk)
 {
 	set_bit(SK_CLOSE, &svsk->sk_flags);
 	if (test_and_set_bit(SK_BUSY, &svsk->sk_flags))
@@ -1800,6 +1801,19 @@ void svc_close_socket(struct svc_sock *s
 	svc_sock_put(svsk);
 }
 
+void svc_force_close_socket(struct svc_sock *svsk)
+{
+	set_bit(SK_CLOSE, &svsk->sk_flags);
+	if (test_bit(SK_BUSY, &svsk->sk_flags)) {
+		/* Waiting to be processed, but no threads left,
+		 * So just remove it from the waiting list
+		 */
+		list_del_init(&svsk->sk_ready);
+		clear_bit(SK_BUSY, &svsk->sk_flags);
+	}
+	svc_close_socket(svsk);
+}
+
 /**
  * svc_makesock - Make a socket for nfsd and lockd
  * @serv: RPC server structure
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous.patch
the-nfsv2-nfsv3-server-does-not-handle-zero-length-write.patch
readahead-nfsd-case.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
