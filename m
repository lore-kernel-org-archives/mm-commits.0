Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFFE318ED6;
	Fri, 31 Jul 2026 19:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785526974; cv=none; b=dijRmr99JSnloXnEakirQ0CAKq931c5CVXVwDnD7WgvdYzf36SCy8fRNCUCyOX0WCkwzVLxXozkIT3kokDMCqVjCiYlyj13KN9Vn2WTmk3ek31zxqAH01vGB883asNumunB+17nijYe3V+boZtNb2HsjLhP8JPxHPRtiD6ikZks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785526974; c=relaxed/simple;
	bh=/8kZL39XLzvBCBAgThArjwf3yb01P+zPsosfXLTiKpA=;
	h=Date:To:From:Subject:Message-Id; b=Ks3aVS1WbaxCfpLSrbSfVKYHFBTK1NyzgJtCMMQu/fuUIbFsFQlsLy+FQPzgGmrmHMarFrQHG7pRtgMCkt5AYhpo9Fvf/yhCPinEQrb4aJsWi7N5GI5iMDNhXgTLDaMVZQYJGfr+9/Vgmtx1TzmgD9Acn7/fcEn+uL9xaZc41Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zVC75a9C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zVC75a9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679FC1F00AC4;
	Fri, 31 Jul 2026 19:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785526972;
	bh=6RKUMX2w4+7ZsKagyVfAEGv1Wf1WhG4FOO1cWAQ0qWU=;
	h=Date:To:From:Subject;
	b=zVC75a9CsBSMdgZ/tDHaHBFjzRBmwiVKmXfuRR6i412dxdKAGFB5Ap24Aq1JR13vl
	 LKEDkGYQAhQS3Jc5y029zf/zA8gW/6St/eoYZesndRF6Hj+kqNFBEwVE0W46MujDTM
	 /faDRcw6taAwxSzvWEziNKE6KS2zU5K0uJb/jLyQ=
Date: Fri, 31 Jul 2026 12:42:51 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,tj@kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,chengming.zhou@linux.dev,jiahao1@lixiang.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-zswap-fix-global-shrinker-when-memory-cgroup-is-disabled.patch removed from -mm tree
Message-Id: <20260731194252.679FC1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: fix global shrinker when memory cgroup is disabled
has been removed from the -mm tree.  Its filename was
     mm-zswap-fix-global-shrinker-when-memory-cgroup-is-disabled.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Hao Jia <jiahao1@lixiang.com>
Subject: mm/zswap: fix global shrinker when memory cgroup is disabled
Date: Wed, 29 Jul 2026 16:42:05 +0800

Patch series "mm/zswap: Fixes and improves the zswap shrink", v3.

This series fixes and improves the zswap global shrinker
(shrink_worker()).


This patch (of 2):

Zswap writeback when the global pool limit is hit fails when memory
cgroup is disabled. The pool remains full until it is organically
drained by swapins or memory freeing, leading to zswap store failures
and pages bypassing getting written directly to the backing swap device,
causing LRU inversion (hotter pages with higher fault latency).

This happens because mem_cgroup_iter() always returns NULL when
memory cgroups are disabled. As a result, the global shrinker
shrink_worker() repeatedly takes empty walks. After MAX_RECLAIM_RETRIES
failed attempts, the worker gives up without writing back any pages.

Therefore, when memory cgroup is disabled, fall through with the !memcg
branch and shrink the root memcg directly.

With memcg disabled, shrink_memcg() only returns -ENOENT when the root
LRU is empty, which means the total pages are already below thr. In the
absence of heavy concurrent zswap stores, the loop then safely bails out
via the zswap_total_pages() <= thr check; otherwise, it will resume
shrinking the memcg after processing the reschedule check. For any other
return value from shrink_memcg(), the loop is guaranteed to terminate,
either after MAX_RECLAIM_RETRIES failures or once the threshold is met.

Link: https://lore.kernel.org/20260729084206.77793-1-jiahao.kernel@gmail.com
Link: https://lore.kernel.org/20260729084206.77793-2-jiahao.kernel@gmail.com
Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
Signed-off-by: Hao Jia <jiahao1@lixiang.com>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Reported-by: Yosry Ahmed <yosry@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/zswap.c~mm-zswap-fix-global-shrinker-when-memory-cgroup-is-disabled
+++ a/mm/zswap.c
@@ -1358,11 +1358,12 @@ static void shrink_worker(struct work_st
 		} while (memcg && !mem_cgroup_tryget_online(memcg));
 		spin_unlock(&zswap_shrink_lock);
 
-		if (!memcg) {
-			/*
-			 * Continue shrinking without incrementing failures if
-			 * we found candidate memcgs in the last tree walk.
-			 */
+		/*
+		 * A NULL memcg ends a full hierarchy pass (except when memcg is
+		 * disabled, where it is always NULL: fall through to the root LRU).
+		 * Count a failure only if the last pass found no candidates.
+		 */
+		if (!memcg && !mem_cgroup_disabled()) {
 			if (!attempts && ++failures == MAX_RECLAIM_RETRIES)
 				break;
 
@@ -1381,7 +1382,7 @@ static void shrink_worker(struct work_st
 		 * and failures.
 		 */
 		if (ret == -ENOENT)
-			continue;
+			goto resched;
 		++attempts;
 
 		if (ret && ++failures == MAX_RECLAIM_RETRIES)
_

Patches currently in -mm which might be from jiahao1@lixiang.com are

mm-zswap-support-batch-writeback-in-shrink_memcg.patch

