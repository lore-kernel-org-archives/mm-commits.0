From: akpm@linux-foundation.org
Subject: + knfsd-use-a-spinlock-to-protect-sk_info_authunix.patch added to -mm tree
Date: Mon, 16 Apr 2007 19:13:07 -0700
Message-ID: <200704170213.l3H2D7ah017897@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60507 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272AbXDQCNy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Apr 2007 22:13:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, gabriel@oxeva.fr, gnb@melbourne.sgi.com


The patch titled
     knfsd: use a spinlock to protect sk_info_authunix
has been added to the -mm tree.  Its filename is
     knfsd-use-a-spinlock-to-protect-sk_info_authunix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: use a spinlock to protect sk_info_authunix
From: NeilBrown <neilb@suse.de>

sk_info_authunix is not being protected properly so the object that it
points to can be cache_put twice, leading to corruption.

We borrow svsk->sk_defer_lock to provide the protection.  We should
probably rename that lock to have a more generic name - later.

Thanks to Gabriel for reporting this.

Cc: Greg Banks <gnb@melbourne.sgi.com>
Cc: Gabriel Barazer <gabriel@oxeva.fr>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/svcauth_unix.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff -puN net/sunrpc/svcauth_unix.c~knfsd-use-a-spinlock-to-protect-sk_info_authunix net/sunrpc/svcauth_unix.c
--- a/net/sunrpc/svcauth_unix.c~knfsd-use-a-spinlock-to-protect-sk_info_authunix
+++ a/net/sunrpc/svcauth_unix.c
@@ -383,7 +383,10 @@ void svcauth_unix_purge(void)
 static inline struct ip_map *
 ip_map_cached_get(struct svc_rqst *rqstp)
 {
-	struct ip_map *ipm = rqstp->rq_sock->sk_info_authunix;
+	struct ip_map *ipm;
+	struct svc_sock *svsk = rqstp->rq_sock;
+	spin_lock_bh(&svsk->sk_defer_lock);
+	ipm = svsk->sk_info_authunix;
 	if (ipm != NULL) {
 		if (!cache_valid(&ipm->h)) {
 			/*
@@ -391,12 +394,14 @@ ip_map_cached_get(struct svc_rqst *rqstp
 			 * remembered, e.g. by a second mount from the
 			 * same IP address.
 			 */
-			rqstp->rq_sock->sk_info_authunix = NULL;
+			svsk->sk_info_authunix = NULL;
+			spin_unlock_bh(&svsk->sk_defer_lock);
 			cache_put(&ipm->h, &ip_map_cache);
 			return NULL;
 		}
 		cache_get(&ipm->h);
 	}
+	spin_unlock_bh(&svsk->sk_defer_lock);
 	return ipm;
 }
 
@@ -405,9 +410,15 @@ ip_map_cached_put(struct svc_rqst *rqstp
 {
 	struct svc_sock *svsk = rqstp->rq_sock;
 
-	if (svsk->sk_sock->type == SOCK_STREAM && svsk->sk_info_authunix == NULL)
-		svsk->sk_info_authunix = ipm;	/* newly cached, keep the reference */
-	else
+	spin_lock_bh(&svsk->sk_defer_lock);
+	if (svsk->sk_sock->type == SOCK_STREAM &&
+	    svsk->sk_info_authunix == NULL) {
+		/* newly cached, keep the reference */
+		svsk->sk_info_authunix = ipm;
+		ipm = NULL;
+	}
+	spin_unlock_bh(&svsk->sk_defer_lock);
+	if (ipm)
 		cache_put(&ipm->h, &ip_map_cache);
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
readahead-nfsd-case.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-cleanup-use-seq_release_private-where-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
