Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3501D420889;
	Thu,  6 Aug 2026 22:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786056190; cv=none; b=mbmrm5IZzj7ZowSjbZbEjM7w0sem6ApdMIURLHYqjvDJGFCq3Y/mUa+sc2HrGbiIAiEL64CO5a/ubk6zOmXFfA7Mk3Fxd/o5bEbbhxJJ+NjIyNJPc5DFHUdujW4CF2oe+TL/bEeoJ9cAO3gAS5IfgGF6bAiSninL3h0nME/7K2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786056190; c=relaxed/simple;
	bh=9tEhRiAjdRbipUZL9sofqsAybtr1VmWdTQ3JE2pFvB0=;
	h=Date:To:From:Subject:Message-Id; b=S0vaUxNtoeV+NYi+oY/w03pVoYMFUs0OYKyxQWobfTuUj6nNcBo55vkpxCpv4eP1Cca1V+OBoiV/+KOTljIA5Ig/3cCgT2JfoGzmSZwpSNc9c10ElcAZZNPaJiXkDpVAQSMCNuvOo1N+OAHistHEP95TpSLP/Qrn7jaIuw3BgE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SfpoXNcu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SfpoXNcu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8A81F000E9;
	Thu,  6 Aug 2026 22:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786056188;
	bh=uE00ujWZAnH6Qh3BrN/zNWA3KeH4aiq9E1S5RXwug7k=;
	h=Date:To:From:Subject;
	b=SfpoXNcuFYTG35V5H1LkjLje9bdHBwixXgmaUyV68d1Hpahj//zQTN5d0xxSlGiGp
	 N+nu4R8hxfA6g46Z8Fa228d+FTWs+X6cQnyHBFn67EDWl6HgYl2aUOwI0y6uHI7BXa
	 N/4xhTFxkArVrfPGEX3MsYupaHIXH4vaxk66AUn8=
Date: Thu, 06 Aug 2026 15:43:08 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,tj@kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,chengming.zhou@linux.dev,jiahao1@lixiang.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-fix-global-shrinker-when-memory-cgroup-is-disabled.patch added to mm-new branch
Message-Id: <20260806224308.9E8A81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: fix global shrinker when memory cgroup is disabled
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-fix-global-shrinker-when-memory-cgroup-is-disabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-fix-global-shrinker-when-memory-cgroup-is-disabled.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-zswap-fix-global-shrinker-when-memory-cgroup-is-disabled.patch
mm-zswap-support-batch-writeback-in-shrink_memcg.patch

