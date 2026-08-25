Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C266436197D;
	Tue, 25 Aug 2026 01:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622869; cv=none; b=XDTXqiSjWFVCiYNfzf/fxCUXcDkiptwkaaL3zqQTPK1Xenh4pVTpBO34X/ufjOQcfUgiok4ytbpjBCdVx8mZifPPPuSqEvzc5RpMdqIge3MEzHymi2ktjp9o3vPqLA4rrPWWhIp31RZ+9snDPlyZUeQFxd7u/ij2eex9eVdwSh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622869; c=relaxed/simple;
	bh=jUOUvsiw7KTQASH4xZUQqwu9/6NZruH80Eq7B6xfhmg=;
	h=Date:To:From:Subject:Message-Id; b=crQN19vtYzr+d0KuGWEj+bT/H1K3SV3a0nRZ1A64m/EtyrcDGpjE+Xc2eQYqEX7dlXtqYq4CqfJBVrS978DqPLt4fXiyRFiJ0181lqsATd63VYjoOzYqOLANJvVCE2MuBIoqEKKncQL3SVBSA9kM9ADh2nC2B/nfT0Qr90iLaVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JpAFQB1Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JpAFQB1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940B91F00A3A;
	Tue, 25 Aug 2026 01:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622867;
	bh=InSI51iKO+6wCQIfSTyEtePRWDvFwiWRP5/AWoxvDUs=;
	h=Date:To:From:Subject;
	b=JpAFQB1Y22RlT/QejSCmAd24LpemB/Vn3Pl6s3IBacr9d5FpAOm8kLXXNj47xh3cY
	 8sjIj86+p34zQR2hfhptrnNjnC/U9ksc5H0Jeu6+a9ZusCF3GzwXdq7IfGH16aWKzn
	 AdSKsvQkpl19mUI/Lar5he6YHcK3JunUTeU5Ea4g=
Date: Mon, 24 Aug 2026 18:54:26 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,tj@kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,chengming.zhou@linux.dev,jiahao1@lixiang.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-fix-global-shrinker-when-memory-cgroup-is-disabled.patch removed from -mm tree
Message-Id: <20260825015427.940B91F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: fix global shrinker when memory cgroup is disabled
has been removed from the -mm tree.  Its filename was
     mm-zswap-fix-global-shrinker-when-memory-cgroup-is-disabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Jia <jiahao1@lixiang.com>
Subject: mm/zswap: fix global shrinker when memory cgroup is disabled
Date: Thu, 6 Aug 2026 15:09:42 +0800

Patch series "mm/zswap: Fixes and improves the zswap shrink", v4.

This series fixes and improves the zswap global shrinker
(shrink_worker()): Patch 1: Fix missing global shrinker when memory cgroup
is disabled.  Patch 2: Extend shrink_memcg() to support batch writeback
and thereby improving the writeback efficiency in the shrink_worker() and
zswap_store() paths.  


This patch (of 2):

Zswap writeback when the global pool limit is hit fails when memory cgroup
is disabled.  The pool remains full until it is organically drained by
swapins or memory freeing, leading to zswap store failures and pages
bypassing getting written directly to the backing swap device, causing LRU
inversion (hotter pages with higher fault latency).

This happens because mem_cgroup_iter() always returns NULL when memory
cgroups are disabled.  As a result, the global shrinker shrink_worker()
repeatedly takes empty walks.  After MAX_RECLAIM_RETRIES failed attempts,
the worker gives up without writing back any pages.

Therefore, when memory cgroup is disabled, fall through with the !memcg
branch and shrink the root memcg directly.

With memcg disabled, shrink_memcg() only returns -ENOENT when the root LRU
is empty, which means the total pages are already below thr.  In the
absence of heavy concurrent zswap stores, the loop then safely bails out
via the zswap_total_pages() <= thr check; otherwise, it will resume
shrinking the memcg after processing the reschedule check.  For any other
return value from shrink_memcg(), the loop is guaranteed to terminate,
either after MAX_RECLAIM_RETRIES failures or once the threshold is met.

This is a potential performance regression for people using zswap
without memcg that was introduced by the commit in "Fixes".

Link: https://lore.kernel.org/20260806070943.95542-1-jiahao.kernel@gmail.com
Link: https://lore.kernel.org/20260806070943.95542-2-jiahao.kernel@gmail.com
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
@@ -1356,11 +1356,12 @@ static void shrink_worker(struct work_st
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
 
@@ -1379,7 +1380,7 @@ static void shrink_worker(struct work_st
 		 * and failures.
 		 */
 		if (ret == -ENOENT)
-			continue;
+			goto resched;
 		++attempts;
 
 		if (ret && ++failures == MAX_RECLAIM_RETRIES)
_

Patches currently in -mm which might be from jiahao1@lixiang.com are


