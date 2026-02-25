Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D957C3E9F7A
	for <mm-commits@vger.kernel.org>; Wed, 25 Feb 2026 19:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772046657; cv=none; b=uG50368Z1Hjt3TbOQreIYxHUa0F/gCsLxMAETI/8f2Mr3Q1nBvI9yhi/J8jLo0ubCwN19mgwhk3vI5IU7zSfjkPtFWWrQUMWTrD+c7vI24C1s1htEzwUzOlHywMrVjDksCMpa0HKhtlhdJx2IAgsg8Bul3BkruwkIjgMdupyFm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772046657; c=relaxed/simple;
	bh=ZCpC6gmGnvoBNU4Od1RIdSoktKatHMVqkJ+7sYecqsQ=;
	h=Date:To:From:Subject:Message-Id; b=sf6CDdnSa4k4+7bUxjcLhNtyCXvDJdZ/P5BGBGHDZ9G6eBzJx3KicA2Xm0TKT723G8UR3oWWwERk1HKRdoSJlmx9OfC8vuJKIFFHZlXz77SOsXAMlx4uN/dUniFR8vl3gAARpv4cQnljqacGG/e3Vv856Mq4J7Ov/aAk5343xYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QNYAjQV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QNYAjQV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1BEC116D0;
	Wed, 25 Feb 2026 19:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772046656;
	bh=ZCpC6gmGnvoBNU4Od1RIdSoktKatHMVqkJ+7sYecqsQ=;
	h=Date:To:From:Subject:From;
	b=QNYAjQV8/k/kns/ORshLZLsq1iLYqKqhhQGHkHGz4KNkteH72870LP70fRB5V43tC
	 Dl9FStlezSxC1//JulGrRbwgmx5M3hW2R37cCWJdsY6bRalvHOrkNpcSHV+sxz3d3G
	 EgzbaWJ5YsnjuhUowPNJPtSt1oMKh08QR/Z9RXAA=
Date: Wed, 25 Feb 2026 11:10:55 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,roman.gushchin@linux.dev,muchun.song@linux.dev,jack@suse.cz,david@fromorbit.com,mkoutny@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-do-not-allocate-shrinker-info-with-cgroupmemory=nokmem.patch added to mm-new branch
Message-Id: <20260225191056.6E1BEC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: Do not allocate shrinker info with cgroup.memory=nokmem
has been added to the -mm mm-new branch.  Its filename is
     mm-do-not-allocate-shrinker-info-with-cgroupmemory=nokmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-do-not-allocate-shrinker-info-with-cgroupmemory=nokmem.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Michal Koutný <mkoutny@suse.com>
Subject: mm: Do not allocate shrinker info with cgroup.memory=nokmem
Date: Wed, 25 Feb 2026 19:38:44 +0100

There'd be no work for memcg-aware shrinkers when kernel memory is not
accounted per cgroup, so we can skip allocating per memcg shrinker data. 
This saves some memory, avoids holding shrinker_mutex with O(nr_memcgs)
and saves work in shrink_slab_memcg().

Then there are SHRINKER_NONSLAB shrinkers which handle non-kernel memory
so nokmem should not disable their per-memcg behavior.  Such shrinkers
(e.g.  deferred_split_shrinker) still need access to per-memcg data (see
also commit 0a432dcbeb32e ("mm: shrinker: make shrinker not depend on
memcg kmem")).

The savings with this patch come on container hosts that create many
superblocks (each with own shrinker) but tracking and processing per-memcg
data is pointless with nokmem (shrink_slab_memcg() is partially guarded
with !memcg_kmem_online already).

The patch uses "boottime" predicate mem_cgroup_kmem_disabled() (not
memcg_kmem_online()) to avoid mistakenly un-MEMCG_AWARE-ing shrinkers
registered before first non-root memcg is mkdir'd.

Link: https://lkml.kernel.org/r/20260225-cgroup-ml-nokmem-shrinker-v1-1-d703899bdda4@suse.com
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/shrinker.c~mm-do-not-allocate-shrinker-info-with-cgroupmemory=nokmem
+++ a/mm/shrinker.c
@@ -219,6 +219,8 @@ static int shrinker_memcg_alloc(struct s
 
 	if (mem_cgroup_disabled())
 		return -ENOSYS;
+	if (mem_cgroup_kmem_disabled() && !(shrinker->flags & SHRINKER_NONSLAB))
+		return -ENOSYS;
 
 	mutex_lock(&shrinker_mutex);
 	id = idr_alloc(&shrinker_idr, shrinker, 0, 0, GFP_KERNEL);
_

Patches currently in -mm which might be from mkoutny@suse.com are

mm-do-not-allocate-shrinker-info-with-cgroupmemory=nokmem.patch

