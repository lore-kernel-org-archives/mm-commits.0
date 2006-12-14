From: akpm@osdl.org
Subject: - knfsd-nfsd-dont-drop-silently-on-upcall-deferral.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:15:30 -0800
Message-ID: <200612140615.kBE6FUYs002213@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52494 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbWLNGQG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:16:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd: don't drop silently on upcall deferral
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd-dont-drop-silently-on-upcall-deferral.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd: don't drop silently on upcall deferral
From: J.Bruce Fields <bfields@fieldses.org>

To avoid tying up server threads when nfsd makes an upcall (to mountd, to get
export options, to idmapd, for nfsv4 name<->id mapping, etc.), we temporarily
"drop" the request and save enough information so that we can revisit it
later.

Certain failures during the deferral process can cause us to really drop the
request and never revisit it.

This is often less than ideal, and is unacceptable in the NFSv4 case--rfc 3530
forbids the server from dropping a request without also closing the
connection.

As a first step, we modify the deferral code to return -ETIMEDOUT (which is
translated to nfserr_jukebox in the v3 and v4 cases, and remains a drop in the
v2 case).

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/export.c                  |   11 ++++++++---
 fs/nfsd/nfsfh.c                   |    6 ++++--
 fs/nfsd/vfs.c                     |    2 +-
 net/sunrpc/auth_gss/svcauth_gss.c |    2 +-
 net/sunrpc/cache.c                |   11 +++++++----
 net/sunrpc/svcauth_unix.c         |    1 +
 6 files changed, 22 insertions(+), 11 deletions(-)

diff -puN fs/nfsd/export.c~knfsd-nfsd-dont-drop-silently-on-upcall-deferral fs/nfsd/export.c
--- a/fs/nfsd/export.c~knfsd-nfsd-dont-drop-silently-on-upcall-deferral
+++ a/fs/nfsd/export.c
@@ -787,15 +787,20 @@ exp_get_by_name(svc_client *clp, struct 
 	key.ex_dentry = dentry;
 
 	exp = svc_export_lookup(&key);
-	if (exp != NULL) 
-		switch (cache_check(&svc_export_cache, &exp->h, reqp)) {
+	if (exp != NULL)  {
+		int err;
+
+		err = cache_check(&svc_export_cache, &exp->h, reqp);
+		switch (err) {
 		case 0: break;
 		case -EAGAIN:
-			exp = ERR_PTR(-EAGAIN);
+		case -ETIMEDOUT:
+			exp = ERR_PTR(err);
 			break;
 		default:
 			exp = NULL;
 		}
+	}
 
 	return exp;
 }
diff -puN fs/nfsd/nfsfh.c~knfsd-nfsd-dont-drop-silently-on-upcall-deferral fs/nfsd/nfsfh.c
--- a/fs/nfsd/nfsfh.c~knfsd-nfsd-dont-drop-silently-on-upcall-deferral
+++ a/fs/nfsd/nfsfh.c
@@ -169,9 +169,11 @@ fh_verify(struct svc_rqst *rqstp, struct
 			exp = exp_find(rqstp->rq_client, 0, tfh, &rqstp->rq_chandle);
 		}
 
-		error = nfserr_dropit;
-		if (IS_ERR(exp) && PTR_ERR(exp) == -EAGAIN)
+		if (IS_ERR(exp) && (PTR_ERR(exp) == -EAGAIN
+				|| PTR_ERR(exp) == -ETIMEDOUT)) {
+			error = nfserrno(PTR_ERR(exp));
 			goto out;
+		}
 
 		error = nfserr_stale; 
 		if (!exp || IS_ERR(exp))
diff -puN fs/nfsd/vfs.c~knfsd-nfsd-dont-drop-silently-on-upcall-deferral fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~knfsd-nfsd-dont-drop-silently-on-upcall-deferral
+++ a/fs/nfsd/vfs.c
@@ -99,7 +99,7 @@ static struct raparm_hbucket	raparm_hash
 /* 
  * Called from nfsd_lookup and encode_dirent. Check if we have crossed 
  * a mount point.
- * Returns -EAGAIN leaving *dpp and *expp unchanged, 
+ * Returns -EAGAIN or -ETIMEDOUT leaving *dpp and *expp unchanged,
  *  or nfs_ok having possibly changed *dpp and *expp
  */
 int
diff -puN net/sunrpc/auth_gss/svcauth_gss.c~knfsd-nfsd-dont-drop-silently-on-upcall-deferral net/sunrpc/auth_gss/svcauth_gss.c
--- a/net/sunrpc/auth_gss/svcauth_gss.c~knfsd-nfsd-dont-drop-silently-on-upcall-deferral
+++ a/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1066,7 +1066,7 @@ svcauth_gss_accept(struct svc_rqst *rqst
 		}
 		switch(cache_check(&rsi_cache, &rsip->h, &rqstp->rq_chandle)) {
 		case -EAGAIN:
-			goto drop;
+		case -ETIMEDOUT:
 		case -ENOENT:
 			goto drop;
 		case 0:
diff -puN net/sunrpc/cache.c~knfsd-nfsd-dont-drop-silently-on-upcall-deferral net/sunrpc/cache.c
--- a/net/sunrpc/cache.c~knfsd-nfsd-dont-drop-silently-on-upcall-deferral
+++ a/net/sunrpc/cache.c
@@ -34,7 +34,7 @@
 
 #define	 RPCDBG_FACILITY RPCDBG_CACHE
 
-static void cache_defer_req(struct cache_req *req, struct cache_head *item);
+static int cache_defer_req(struct cache_req *req, struct cache_head *item);
 static void cache_revisit_request(struct cache_head *item);
 
 static void cache_init(struct cache_head *h)
@@ -185,6 +185,7 @@ static int cache_make_upcall(struct cach
  *
  * Returns 0 if the cache_head can be used, or cache_puts it and returns
  * -EAGAIN if upcall is pending,
+ * -ETIMEDOUT if upcall failed and should be retried,
  * -ENOENT if cache entry was negative
  */
 int cache_check(struct cache_detail *detail,
@@ -236,7 +237,8 @@ int cache_check(struct cache_detail *det
 	}
 
 	if (rv == -EAGAIN)
-		cache_defer_req(rqstp, h);
+		if (cache_defer_req(rqstp, h) != 0)
+			rv = -ETIMEDOUT;
 
 	if (rv)
 		cache_put(h, detail);
@@ -523,14 +525,14 @@ static LIST_HEAD(cache_defer_list);
 static struct list_head cache_defer_hash[DFR_HASHSIZE];
 static int cache_defer_cnt;
 
-static void cache_defer_req(struct cache_req *req, struct cache_head *item)
+static int cache_defer_req(struct cache_req *req, struct cache_head *item)
 {
 	struct cache_deferred_req *dreq;
 	int hash = DFR_HASH(item);
 
 	dreq = req->defer(req);
 	if (dreq == NULL)
-		return;
+		return -ETIMEDOUT;
 
 	dreq->item = item;
 	dreq->recv_time = get_seconds();
@@ -571,6 +573,7 @@ static void cache_defer_req(struct cache
 		/* must have just been validated... */
 		cache_revisit_request(item);
 	}
+	return 0;
 }
 
 static void cache_revisit_request(struct cache_head *item)
diff -puN net/sunrpc/svcauth_unix.c~knfsd-nfsd-dont-drop-silently-on-upcall-deferral net/sunrpc/svcauth_unix.c
--- a/net/sunrpc/svcauth_unix.c~knfsd-nfsd-dont-drop-silently-on-upcall-deferral
+++ a/net/sunrpc/svcauth_unix.c
@@ -435,6 +435,7 @@ svcauth_unix_set_client(struct svc_rqst 
 		default:
 			BUG();
 		case -EAGAIN:
+		case -ETIMEDOUT:
 			return SVC_DROP;
 		case -ENOENT:
 			return SVC_DENIED;
_

Patches currently in -mm which might be from bfields@fieldses.org are


