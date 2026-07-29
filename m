Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3C024DCF6;
	Wed, 29 Jul 2026 23:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785366128; cv=none; b=RbSfl2J0DOxcb/Bb7mPxaOhGN5a6xSdJxlz0kPvx8Ed7qCIMxfTTk3QXgIF1vu5uDLy35EscSe/5M9+P3JWe2232EXN0ONhV4IX0eMV5rS9O8hc8TEkVgDcLQyis2KGNevGpK08uSu4V4DK6SVMzv2KgrLUx1ADzdauN1lhEi9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785366128; c=relaxed/simple;
	bh=Hsd4LrrR27fy2wW7P0lw+esaLm3Ap/8gOMxkPxt5fCw=;
	h=Date:To:From:Subject:Message-Id; b=aLEzfLfaRqmMdQds3bNhqTxrfqP9HMwg3kxOfkp68BarwlXT5jWxk4HpZj4iBR/mfThmBWnXmivxS55RwcjzYFFYJvEBRpOrJBxwyDPraKx3o8TIXjF4pJ+USdB4vkfhujMu1nP3fFwChsVEZkwKDTq4X96fMMC1kzXt3KWiqKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k+gx/mjq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k+gx/mjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC1A1F000E9;
	Wed, 29 Jul 2026 23:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785366127;
	bh=+xvKKAaviKnSddmXSfo8kpK2NFqXXocwXINcVhjj16E=;
	h=Date:To:From:Subject;
	b=k+gx/mjquOv8DGEZXSAgTiBe9I/NFf8NF23dqGk9BW7DjnaJlX/yPejvfwVMsmGGQ
	 pXl+ehLeHS/zL/kwObPB2OJGKx03/JnOAuc/pFfvYUUp77ArVhE4onVdIzwyLG4P9E
	 0AT7khF1YACLGq4IRoYI5olhTYSfZOYznkhE+8oA=
Date: Wed, 29 Jul 2026 16:02:06 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,tj@kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,chengming.zhou@linux.dev,jiahao1@lixiang.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-fix-global-shrinker-when-memory-cgroup-is-disabled.patch added to mm-new branch
Message-Id: <20260729230207.2DC1A1F000E9@smtp.kernel.org>
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
Closes: https://lore.kernel.org/all/CAO9r8zPVzMKFbCixxD-qgtRrkFxWVrHiZZeLc=eyTPKPVQgX4g@mail.gmail.com
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

