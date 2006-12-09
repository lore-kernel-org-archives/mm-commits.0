From: akpm@osdl.org
Subject: + knfsd-svcrpc-remove-another-silent-drop-from-deferral-code.patch added to -mm tree
Date: Fri, 08 Dec 2006 16:09:34 -0800
Message-ID: <200612090009.kB909YX0010401@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55587 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947577AbWLIAJs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 19:09:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: svcrpc: remove another silent drop from deferral code
has been added to the -mm tree.  Its filename is
     knfsd-svcrpc-remove-another-silent-drop-from-deferral-code.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: svcrpc: remove another silent drop from deferral code
From: J.Bruce Fields <bfields@fieldses.org>

There's no point deferring something just to immediately fail the deferral,
especially now that we can do something more useful in the failure case by
returning an error.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 net/sunrpc/cache.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff -puN net/sunrpc/cache.c~knfsd-svcrpc-remove-another-silent-drop-from-deferral-code net/sunrpc/cache.c
--- a/net/sunrpc/cache.c~knfsd-svcrpc-remove-another-silent-drop-from-deferral-code
+++ a/net/sunrpc/cache.c
@@ -530,6 +530,13 @@ static int cache_defer_req(struct cache_
 	struct cache_deferred_req *dreq;
 	int hash = DFR_HASH(item);
 
+	if (cache_defer_cnt >= DFR_MAX) {
+		/* too much in the cache, randomly drop this one,
+		 * or continue and drop the oldest below
+		 */
+		if (net_random()&1)
+			return -ETIMEDOUT;
+	}
 	dreq = req->defer(req);
 	if (dreq == NULL)
 		return -ETIMEDOUT;
@@ -548,17 +555,8 @@ static int cache_defer_req(struct cache_
 	/* it is in, now maybe clean up */
 	dreq = NULL;
 	if (++cache_defer_cnt > DFR_MAX) {
-		/* too much in the cache, randomly drop
-		 * first or last
-		 */
-		if (net_random()&1) 
-			dreq = list_entry(cache_defer_list.next,
-					  struct cache_deferred_req,
-					  recent);
-		else
-			dreq = list_entry(cache_defer_list.prev,
-					  struct cache_deferred_req,
-					  recent);
+		dreq = list_entry(cache_defer_list.prev,
+				  struct cache_deferred_req, recent);
 		list_del(&dreq->recent);
 		list_del(&dreq->hash);
 		cache_defer_cnt--;
_

Patches currently in -mm which might be from bfields@fieldses.org are

origin.patch
knfsd-nfsd4-remove-a-dprink-from-nfsd4_lock.patch
knfsd-svcrpc-fix-gss-krb5i-memory-leak.patch
knfsd-nfsd4-clarify-units-of-compound_slack_space.patch
knfsd-nfsd-make-exp_rootfh-handle-exp_parent-errors.patch
knfsd-nfsd-simplify-exp_pseudoroot.patch
knfsd-nfsd4-handling-more-nfsd_cross_mnt-errors-in-nfsd4-readdir.patch
knfsd-nfsd-dont-drop-silently-on-upcall-deferral.patch
knfsd-svcrpc-remove-another-silent-drop-from-deferral-code.patch
knfsd-nfsd4-pass-saved-and-current-fh-together-into-nfsd4-operations.patch
knfsd-nfsd4-remove-spurious-replay_owner-check.patch
knfsd-nfsd4-move-replay_owner-to-cstate.patch
knfsd-nfsd4-dont-inline-nfsd4-compound-op-functions.patch
knfsd-nfsd4-make-verify-and-nverify-wrappers.patch
knfsd-nfsd4-reorganize-compound-ops.patch
knfsd-nfsd4-simplify-migration-op-check.patch
knfsd-nfsd4-simplify-filehandle-check.patch

