Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B734AEF7
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247735; cv=none; b=EM9ktfsnJBY7GHWyCbrJ3OnWPXJJjYYOmWOu5iQc0XSaVDOM2+4tDtHEVLhHSmKIOXSvA4HJcT1mDk4jL7hZUFBr0v4U5Gmx476zasLDq+XtwWBeKYZTJVouie22u1sGAgB9hPjf9NqEf3YP4FlebU5G8C38CX9BqkvYcLj5Nno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247735; c=relaxed/simple;
	bh=l4e3kI8DNXCgIgl0a/dzV7fwAEVZDlHpR2e/A7IQN58=;
	h=Date:To:From:Subject:Message-Id; b=DN+LQ3QrkJJzvUs+LEpHKNSCO4cUbGZ/wNF2fMaGyB9qKJAK/g1I1Peym5jQtOQVrSiqLY80qS67j9YoEtOTGXFYs5yVCt+izlnYIiQuigths6czR8ksT9j9Ty1DlNER1NShv53LaEe/lM1lAppWCI80mTYR9glUk4KmbeL8LsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EwOOHYFS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EwOOHYFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10672C4CEC2;
	Mon,  2 Sep 2024 03:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247735;
	bh=l4e3kI8DNXCgIgl0a/dzV7fwAEVZDlHpR2e/A7IQN58=;
	h=Date:To:From:Subject:From;
	b=EwOOHYFSW2tLEnvuS/5V0viOnLuaghlMaJxnf5WI+zjRRik9s8fext2aaLyYL68NE
	 jsRkNF9nfWkl1WCrmB3CoWEvtv0cExvPscGKIZysuGA9lm3+lekMdXxMnoZBhWzPh7
	 KNeFxWZ9/t97e8Iro78MinYp8ac7eK/pnkNT/ycA=
Date: Sun, 01 Sep 2024 20:28:54 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,flintglass@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-fix-global-shrinker-error-handling-logic.patch removed from -mm tree
Message-Id: <20240902032855.10672C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: fix global shrinker error handling logic
has been removed from the -mm tree.  Its filename was
     mm-zswap-fix-global-shrinker-error-handling-logic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Takero Funaki <flintglass@gmail.com>
Subject: mm: zswap: fix global shrinker error handling logic
Date: Wed, 31 Jul 2024 00:49:10 +0000

This patch fixes the zswap global shrinker, which did not shrink the zpool
as expected.

The issue addressed is that shrink_worker() did not distinguish between
unexpected errors and expected errors, such as failed writeback from an
empty memcg.  The shrinker would stop shrinking after iterating through
the memcg tree 16 times, even if there was only one empty memcg.

With this patch, the shrinker no longer considers encountering an empty
memcg, encountering a memcg with writeback disabled, or reaching the end
of a memcg tree walk as a failure, as long as there are memcgs that are
candidates for writeback.  Systems with one or more empty memcgs will now
observe significantly higher zswap writeback activity after the zswap pool
limit is hit.

To avoid an infinite loop when there are no writeback candidates, this
patch tracks writeback attempts during memcg tree walks and limits reties
if no writeback candidates are found.

To handle the empty memcg case, the helper function shrink_memcg() is
modified to check if the memcg is empty and then return -ENOENT.

Link: https://lkml.kernel.org/r/20240731004918.33182-3-flintglass@gmail.com
Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
Signed-off-by: Takero Funaki <flintglass@gmail.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

--- a/mm/zswap.c~mm-zswap-fix-global-shrinker-error-handling-logic
+++ a/mm/zswap.c
@@ -1287,10 +1287,10 @@ static struct shrinker *zswap_alloc_shri
 
 static int shrink_memcg(struct mem_cgroup *memcg)
 {
-	int nid, shrunk = 0;
+	int nid, shrunk = 0, scanned = 0;
 
 	if (!mem_cgroup_zswap_writeback_enabled(memcg))
-		return -EINVAL;
+		return -ENOENT;
 
 	/*
 	 * Skip zombies because their LRUs are reparented and we would be
@@ -1304,21 +1304,34 @@ static int shrink_memcg(struct mem_cgrou
 
 		shrunk += list_lru_walk_one(&zswap_list_lru, nid, memcg,
 					    &shrink_memcg_cb, NULL, &nr_to_walk);
+		scanned += 1 - nr_to_walk;
 	}
+
+	if (!scanned)
+		return -ENOENT;
+
 	return shrunk ? 0 : -EAGAIN;
 }
 
 static void shrink_worker(struct work_struct *w)
 {
 	struct mem_cgroup *memcg;
-	int ret, failures = 0;
+	int ret, failures = 0, attempts = 0;
 	unsigned long thr;
 
 	/* Reclaim down to the accept threshold */
 	thr = zswap_accept_thr_pages();
 
 	/*
-	 * Global reclaim will select cgroup in a round-robin fashion.
+	 * Global reclaim will select cgroup in a round-robin fashion from all
+	 * online memcgs, but memcgs that have no pages in zswap and
+	 * writeback-disabled memcgs (memory.zswap.writeback=0) are not
+	 * candidates for shrinking.
+	 *
+	 * Shrinking will be aborted if we encounter the following
+	 * MAX_RECLAIM_RETRIES times:
+	 * - No writeback-candidate memcgs found in a memcg tree walk.
+	 * - Shrinking a writeback-candidate memcg failed.
 	 *
 	 * We save iteration cursor memcg into zswap_next_shrink,
 	 * which can be modified by the offline memcg cleaner
@@ -1354,9 +1367,14 @@ static void shrink_worker(struct work_st
 		spin_unlock(&zswap_shrink_lock);
 
 		if (!memcg) {
-			if (++failures == MAX_RECLAIM_RETRIES)
+			/*
+			 * Continue shrinking without incrementing failures if
+			 * we found candidate memcgs in the last tree walk.
+			 */
+			if (!attempts && ++failures == MAX_RECLAIM_RETRIES)
 				break;
 
+			attempts = 0;
 			goto resched;
 		}
 
@@ -1364,8 +1382,16 @@ static void shrink_worker(struct work_st
 		/* drop the extra reference */
 		mem_cgroup_put(memcg);
 
-		if (ret == -EINVAL)
-			break;
+		/*
+		 * There are no writeback-candidate pages in the memcg.
+		 * This is not an issue as long as we can find another memcg
+		 * with pages in zswap. Skip this without incrementing attempts
+		 * and failures.
+		 */
+		if (ret == -ENOENT)
+			continue;
+		++attempts;
+
 		if (ret && ++failures == MAX_RECLAIM_RETRIES)
 			break;
 resched:
_

Patches currently in -mm which might be from flintglass@gmail.com are


