From: akpm@linux-foundation.org
Subject: + knfsd-rename-sk_defer_lock-to-sk_lock.patch added to -mm tree
Date: Mon, 16 Apr 2007 19:15:23 -0700
Message-ID: <200704170215.l3H2FNQs017951@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60535 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284AbXDQCPi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Apr 2007 22:15:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     knfsd: rename sk_defer_lock to sk_lock
has been added to the -mm tree.  Its filename is
     knfsd-rename-sk_defer_lock-to-sk_lock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: rename sk_defer_lock to sk_lock
From: NeilBrown <neilb@suse.de>

Now that sk_defer_lock protects two different things, make the name more
generic.

Also don't bother with disabling _bh as the lock is only ever taken from
process context.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sunrpc/svcsock.h |    3 ++-
 net/sunrpc/svcauth_unix.c      |   10 +++++-----
 net/sunrpc/svcsock.c           |   13 +++++++------
 3 files changed, 14 insertions(+), 12 deletions(-)

diff -puN include/linux/sunrpc/svcsock.h~knfsd-rename-sk_defer_lock-to-sk_lock include/linux/sunrpc/svcsock.h
--- a/include/linux/sunrpc/svcsock.h~knfsd-rename-sk_defer_lock-to-sk_lock
+++ a/include/linux/sunrpc/svcsock.h
@@ -37,7 +37,8 @@ struct svc_sock {
 
 	atomic_t    	    	sk_reserved;	/* space on outq that is reserved */
 
-	spinlock_t		sk_defer_lock;	/* protects sk_deferred */
+	spinlock_t		sk_lock;	/* protects sk_deferred and
+						 * sk_info_authunix */
 	struct list_head	sk_deferred;	/* deferred requests that need to
 						 * be revisted */
 	struct mutex		sk_mutex;	/* to serialize sending data */
diff -puN net/sunrpc/svcauth_unix.c~knfsd-rename-sk_defer_lock-to-sk_lock net/sunrpc/svcauth_unix.c
--- a/net/sunrpc/svcauth_unix.c~knfsd-rename-sk_defer_lock-to-sk_lock
+++ a/net/sunrpc/svcauth_unix.c
@@ -385,7 +385,7 @@ ip_map_cached_get(struct svc_rqst *rqstp
 {
 	struct ip_map *ipm;
 	struct svc_sock *svsk = rqstp->rq_sock;
-	spin_lock_bh(&svsk->sk_defer_lock);
+	spin_lock(&svsk->sk_lock);
 	ipm = svsk->sk_info_authunix;
 	if (ipm != NULL) {
 		if (!cache_valid(&ipm->h)) {
@@ -395,13 +395,13 @@ ip_map_cached_get(struct svc_rqst *rqstp
 			 * same IP address.
 			 */
 			svsk->sk_info_authunix = NULL;
-			spin_unlock_bh(&svsk->sk_defer_lock);
+			spin_unlock(&svsk->sk_lock);
 			cache_put(&ipm->h, &ip_map_cache);
 			return NULL;
 		}
 		cache_get(&ipm->h);
 	}
-	spin_unlock_bh(&svsk->sk_defer_lock);
+	spin_unlock(&svsk->sk_lock);
 	return ipm;
 }
 
@@ -410,14 +410,14 @@ ip_map_cached_put(struct svc_rqst *rqstp
 {
 	struct svc_sock *svsk = rqstp->rq_sock;
 
-	spin_lock_bh(&svsk->sk_defer_lock);
+	spin_lock(&svsk->sk_lock);
 	if (svsk->sk_sock->type == SOCK_STREAM &&
 	    svsk->sk_info_authunix == NULL) {
 		/* newly cached, keep the reference */
 		svsk->sk_info_authunix = ipm;
 		ipm = NULL;
 	}
-	spin_unlock_bh(&svsk->sk_defer_lock);
+	spin_unlock(&svsk->sk_lock);
 	if (ipm)
 		cache_put(&ipm->h, &ip_map_cache);
 }
diff -puN net/sunrpc/svcsock.c~knfsd-rename-sk_defer_lock-to-sk_lock net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~knfsd-rename-sk_defer_lock-to-sk_lock
+++ a/net/sunrpc/svcsock.c
@@ -53,7 +53,8 @@
  * 	svc_serv->sv_lock protects sv_tempsocks, sv_permsocks, sv_tmpcnt.
  *	when both need to be taken (rare), svc_serv->sv_lock is first.
  *	BKL protects svc_serv->sv_nrthread.
- *	svc_sock->sk_defer_lock protects the svc_sock->sk_deferred list
+ *	svc_sock->sk_lock protects the svc_sock->sk_deferred list
+ *             and the ->sk_info_authunix cache.
  *	svc_sock->sk_flags.SK_BUSY prevents a svc_sock being enqueued multiply.
  *
  *	Some flags can be set to certain values at any time
@@ -1625,7 +1626,7 @@ static struct svc_sock *svc_setup_socket
 	svsk->sk_server = serv;
 	atomic_set(&svsk->sk_inuse, 1);
 	svsk->sk_lastrecv = get_seconds();
-	spin_lock_init(&svsk->sk_defer_lock);
+	spin_lock_init(&svsk->sk_lock);
 	INIT_LIST_HEAD(&svsk->sk_deferred);
 	INIT_LIST_HEAD(&svsk->sk_ready);
 	mutex_init(&svsk->sk_mutex);
@@ -1849,9 +1850,9 @@ static void svc_revisit(struct cache_def
 	dprintk("revisit queued\n");
 	svsk = dr->svsk;
 	dr->svsk = NULL;
-	spin_lock_bh(&svsk->sk_defer_lock);
+	spin_lock(&svsk->sk_lock);
 	list_add(&dr->handle.recent, &svsk->sk_deferred);
-	spin_unlock_bh(&svsk->sk_defer_lock);
+	spin_unlock(&svsk->sk_lock);
 	set_bit(SK_DEFERRED, &svsk->sk_flags);
 	svc_sock_enqueue(svsk);
 	svc_sock_put(svsk);
@@ -1917,7 +1918,7 @@ static struct svc_deferred_req *svc_defe
 
 	if (!test_bit(SK_DEFERRED, &svsk->sk_flags))
 		return NULL;
-	spin_lock_bh(&svsk->sk_defer_lock);
+	spin_lock(&svsk->sk_lock);
 	clear_bit(SK_DEFERRED, &svsk->sk_flags);
 	if (!list_empty(&svsk->sk_deferred)) {
 		dr = list_entry(svsk->sk_deferred.next,
@@ -1926,6 +1927,6 @@ static struct svc_deferred_req *svc_defe
 		list_del_init(&dr->handle.recent);
 		set_bit(SK_DEFERRED, &svsk->sk_flags);
 	}
-	spin_unlock_bh(&svsk->sk_defer_lock);
+	spin_unlock(&svsk->sk_lock);
 	return dr;
 }
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
knfsd-use-a-spinlock-to-protect-sk_info_authunix.patch
device_schedule_callback-needs-a-module-reference.patch
device_schedule_callback-needs-a-module-reference-fix.patch
sunrpc-cleanup-use-seq_release_private-where-appropriate.patch
slub-core-fix-kmem_cache_destroy.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
the-nfsv2-nfsv3-server-does-not-handle-zero-length-write.patch
knfsd-rename-sk_defer_lock-to-sk_lock.patch
readahead-nfsd-case.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-cleanup-use-seq_release_private-where-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
