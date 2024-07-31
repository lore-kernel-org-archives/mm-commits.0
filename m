Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BF71BC40
	for <mm-commits@vger.kernel.org>; Wed, 31 Jul 2024 21:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722460357; cv=none; b=FGEbnWoSDwYvrhi+RpqLuj/uAaTmAgcienyKSNOd3rYoxTuB6GT4JU8tKrcnPVCPg74cSuTR5W+dsKABs/dqvdJ1clR8JSsjlOIQ9n/f27BxT9JwdEaJASQUP3idqygNHqXa4TClXYDA9YwN1OnneTtkWYLn51z0gIVpz/i2q94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722460357; c=relaxed/simple;
	bh=r8d52BfDLzNv8wXBEBnLHh9hhcoJYJeBvs7WF1cx+T0=;
	h=Date:To:From:Subject:Message-Id; b=uGgJuQDrGowpLycfgP3rae9KawYQYcmGBaPKxPr9STgshPaQZF1QpVWOnguNlXpLrP7PGDYuspJVa2UnerXMUBFy3m5jF2PW4uiW5+Z44ShY5fNr57Visz6NI9kzWNtAgH32DeFuRFXc059DF+9b6/09PzMDTFYB6pB+rGX3098=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wNfg5bjK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wNfg5bjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38780C116B1;
	Wed, 31 Jul 2024 21:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722460357;
	bh=r8d52BfDLzNv8wXBEBnLHh9hhcoJYJeBvs7WF1cx+T0=;
	h=Date:To:From:Subject:From;
	b=wNfg5bjK6BItsiwjgLZAG1eQ/Z6HqBigNtjuhVfeUSOfulb4UiKvEkgsjQAiA+H10
	 uMjTuneiRVMBWxNDCXnOp56RXFHszy1xQl8geb/V7YlJnBWr74rHEl8d2bVe9eeoK9
	 ZV5xFbQG6qTZpedD5lQpM5PDUZBp12gdTA56zUq0=
Date: Wed, 31 Jul 2024 14:12:36 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,flintglass@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-fix-global-shrinker-memcg-iteration.patch added to mm-unstable branch
Message-Id: <20240731211237.38780C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: fix global shrinker memcg iteration
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-fix-global-shrinker-memcg-iteration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-fix-global-shrinker-memcg-iteration.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Takero Funaki <flintglass@gmail.com>
Subject: mm: zswap: fix global shrinker memcg iteration
Date: Wed, 31 Jul 2024 00:49:09 +0000

Patch series "mm: zswap: fixes for global shrinker", v5.

This series addresses issues in the zswap global shrinker that could not
shrink stored pages.  With this series, the shrinker continues to shrink
pages until it reaches the accept threshold more reliably, gives much
higher writeback when the zswap pool limit is hit.


This patch (of 2):

This patch fixes an issue where the zswap global shrinker stopped
iterating through the memcg tree.

The problem was that shrink_worker() would restart iterating memcg tree
from the tree root, considering an offline memcg as a failure, and abort
shrinking after encountering the same offline memcg 16 times even if there
is only one offline memcg.  After this change, an offline memcg in the
tree is no longer considered a failure.  This allows the shrinker to
continue shrinking the other online memcgs regardless of whether an
offline memcg exists, gives higher zswap writeback activity.

To avoid holding refcount of offline memcg encountered during the memcg
tree walking, shrink_worker() must continue iterating to release the
offline memcg to ensure the next memcg stored in the cursor is online.

The offline memcg cleaner has also been changed to avoid the same issue. 
When the next memcg of the offlined memcg is also offline, the refcount
stored in the iteration cursor was held until the next shrink_worker()
run.  The cleaner must release the offline memcg recursively.

Link: https://lkml.kernel.org/r/20240731004918.33182-1-flintglass@gmail.com
Link: https://lkml.kernel.org/r/20240731004918.33182-2-flintglass@gmail.com
Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
Signed-off-by: Takero Funaki <flintglass@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   68 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 24 deletions(-)

--- a/mm/zswap.c~mm-zswap-fix-global-shrinker-memcg-iteration
+++ a/mm/zswap.c
@@ -756,12 +756,25 @@ void zswap_folio_swapin(struct folio *fo
 	}
 }
 
+/*
+ * This function should be called when a memcg is being offlined.
+ *
+ * Since the global shrinker shrink_worker() may hold a reference
+ * of the memcg, we must check and release the reference in
+ * zswap_next_shrink.
+ *
+ * shrink_worker() must handle the case where this function releases
+ * the reference of memcg being shrunk.
+ */
 void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg)
 {
 	/* lock out zswap shrinker walking memcg tree */
 	spin_lock(&zswap_shrink_lock);
-	if (zswap_next_shrink == memcg)
-		zswap_next_shrink = mem_cgroup_iter(NULL, zswap_next_shrink, NULL);
+	if (zswap_next_shrink == memcg) {
+		do {
+			zswap_next_shrink = mem_cgroup_iter(NULL, zswap_next_shrink, NULL);
+		} while (zswap_next_shrink && !mem_cgroup_online(zswap_next_shrink));
+	}
 	spin_unlock(&zswap_shrink_lock);
 }
 
@@ -1320,43 +1333,50 @@ static void shrink_worker(struct work_st
 	/* Reclaim down to the accept threshold */
 	thr = zswap_accept_thr_pages();
 
-	/* global reclaim will select cgroup in a round-robin fashion. */
+	/*
+	 * Global reclaim will select cgroup in a round-robin fashion.
+	 *
+	 * We save iteration cursor memcg into zswap_next_shrink,
+	 * which can be modified by the offline memcg cleaner
+	 * zswap_memcg_offline_cleanup().
+	 *
+	 * Since the offline cleaner is called only once, we cannot leave an
+	 * offline memcg reference in zswap_next_shrink.
+	 * We can rely on the cleaner only if we get online memcg under lock.
+	 *
+	 * If we get an offline memcg, we cannot determine if the cleaner has
+	 * already been called or will be called later. We must put back the
+	 * reference before returning from this function. Otherwise, the
+	 * offline memcg left in zswap_next_shrink will hold the reference
+	 * until the next run of shrink_worker().
+	 */
 	do {
 		spin_lock(&zswap_shrink_lock);
-		zswap_next_shrink = mem_cgroup_iter(NULL, zswap_next_shrink, NULL);
-		memcg = zswap_next_shrink;
 
 		/*
-		 * We need to retry if we have gone through a full round trip, or if we
-		 * got an offline memcg (or else we risk undoing the effect of the
-		 * zswap memcg offlining cleanup callback). This is not catastrophic
-		 * per se, but it will keep the now offlined memcg hostage for a while.
-		 *
+		 * Start shrinking from the next memcg after zswap_next_shrink.
+		 * When the offline cleaner has already advanced the cursor,
+		 * advancing the cursor here overlooks one memcg, but this
+		 * should be negligibly rare.
+		 */
+		do {
+			memcg = mem_cgroup_iter(NULL, zswap_next_shrink, NULL);
+			zswap_next_shrink = memcg;
+		} while (memcg && !mem_cgroup_tryget_online(memcg));
+		/*
 		 * Note that if we got an online memcg, we will keep the extra
 		 * reference in case the original reference obtained by mem_cgroup_iter
 		 * is dropped by the zswap memcg offlining callback, ensuring that the
 		 * memcg is not killed when we are reclaiming.
 		 */
-		if (!memcg) {
-			spin_unlock(&zswap_shrink_lock);
-			if (++failures == MAX_RECLAIM_RETRIES)
-				break;
-
-			goto resched;
-		}
-
-		if (!mem_cgroup_tryget_online(memcg)) {
-			/* drop the reference from mem_cgroup_iter() */
-			mem_cgroup_iter_break(NULL, memcg);
-			zswap_next_shrink = NULL;
-			spin_unlock(&zswap_shrink_lock);
+		spin_unlock(&zswap_shrink_lock);
 
+		if (!memcg) {
 			if (++failures == MAX_RECLAIM_RETRIES)
 				break;
 
 			goto resched;
 		}
-		spin_unlock(&zswap_shrink_lock);
 
 		ret = shrink_memcg(memcg);
 		/* drop the extra reference */
_

Patches currently in -mm which might be from flintglass@gmail.com are

mm-zswap-fix-global-shrinker-memcg-iteration.patch
mm-zswap-fix-global-shrinker-error-handling-logic.patch

