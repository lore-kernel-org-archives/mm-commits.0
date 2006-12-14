From: akpm@osdl.org
Subject: - knfsd-svcrpc-remove-another-silent-drop-from-deferral-code.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:15:43 -0800
Message-ID: <200612140615.kBE6FgIi002219@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52514 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbWLNGQR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:16:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: svcrpc: remove another silent drop from deferral code
has been removed from the -mm tree.  Its filename was
     knfsd-svcrpc-remove-another-silent-drop-from-deferral-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 9 insertions(+), 11 deletions(-)

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


