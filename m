Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FD2380FC1
	for <mm-commits@vger.kernel.org>; Sat, 26 Sep 2026 20:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790456381; cv=none; b=mp3cRxcLL9ss0CtVJxGpnQoChb9HhbJBAxJLxFaQUiBx5fdmTuiSNUq/yZv0SEEpj3S8HmqY4ZuFjhBhBEaryEV9DgSSBV+d0vopsBqd0WHAC1IYBJvPQsLl7AyP3mYemGwU46XgqbCOrhi9XDIbmi6V1GdI2oi2T9Qo/q86Nj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790456381; c=relaxed/simple;
	bh=3vM+TbJJRFr5dToTBoy9uqYsqsJNjd1M2EqsY2l4FBM=;
	h=Date:To:From:Subject:Message-Id; b=fxYIkrGJAdaBPgzdkYQn3QHFbNCzpbkBNBp2AJQooL9DndAbBWWslk2ABphbnsoSTf58778QUgoJA742U2lU5PdSVfrjSlhVi0N6/MjYe1oOjUJBm1CekcK3D+oNcDASwYaNPaHx2WNpKjHekJdO+p1wkHc3nIKdVAxqEgfJDvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YqEk0twO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YqEk0twO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA2D1F000FF;
	Sat, 26 Sep 2026 20:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790456379;
	bh=hB6R1xRWPcCP8m2ocoDesDzezpDSE3WhozftuidMg2I=;
	h=Date:To:From:Subject;
	b=YqEk0twO4z1MamPMLADnePsbKMrwDe2I1zOzpytZnCfF42iszO5C2AidIoEg9Za/F
	 8bB1mIoabdPl292b3Abti/RWEm1d88uG6y/lVVoWoKPoMD4lp4gpxNkVb+LzUngCV8
	 Vj6KgvnvvKN5LH8QVCUTaIT7w7Gu8ru5aUKzVHDo=
Date: Sat, 26 Sep 2026 13:59:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosry@kernel.org,xlpang@linux.alibaba.com,usama.arif@linux.dev,shakeel.butt@linux.dev,ryncsn@gmail.com,roman.gushchin@linux.dev,qi.zheng@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,qinyuntan@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-thp-restore-shrinker_nonslab-on-the-deferred-split-shrinker.patch removed from -mm tree
Message-Id: <20260926205939.9DA2D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: thp: restore SHRINKER_NONSLAB on the deferred split shrinker
has been removed from the -mm tree.  Its filename was
     mm-thp-restore-shrinker_nonslab-on-the-deferred-split-shrinker.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: mm: thp: restore SHRINKER_NONSLAB on the deferred split shrinker
Date: Thu, 10 Sep 2026 16:07:21 +0800

On a system booted with cgroup.memory=nokmem, the deferred split shrinker
is demoted to a non-memcg-aware one.  As a result, partially unmapped THPs
are only split under global reclaim; memcg (limit-induced) reclaim never
splits them, so a cgroup under memory pressure keeps its underused THPs
intact.

The shrinker has carried SHRINKER_NONSLAB since commit 0a432dcbeb32 ("mm:
shrinker: make shrinker not depend on memcg kmem") precisely so it would
keep working with kmem accounting disabled.  Commit fafaeceb89a5 ("mm:
switch deferred split shrinker to list_lru") dropped it knowingly: under
nokmem the list_lru collapses into a shared per-node list while
__list_lru_add() still sets the shrinker bit on whichever memcg happens to
add the first item, and with the flag set the shrinker would run twice per
reclaim cycle [1].

NONSLAB-backed lrus keep their per-memcg lists under nokmem now, so the
shrinker bit identifies the owning memcg again.  Restore the flag.

This was noticed by Michal during review of the patch "mm/list_lru: don't
copy stale shrinker id from non-memcg-aware shrinkers" [2].

Link: https://lore.kernel.org/20260910080722.3961351-4-qinyuntan@linux.alibaba.com
Link: https://lore.kernel.org/all/ah9PGv12mqai84ES@cmpxchg.org/ [1]
Link: https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/ [2]
Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Xunlei Pang <xlpang@linux.alibaba.com>
Cc: Kairui Song <ryncsn@gmail.com>
---

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-thp-restore-shrinker_nonslab-on-the-deferred-split-shrinker
+++ a/mm/huge_memory.c
@@ -1059,7 +1059,8 @@ int folio_memcg_alloc_deferred(struct fo
 static int __init thp_shrinker_init(void)
 {
 	deferred_split_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
-						 SHRINKER_MEMCG_AWARE,
+						 SHRINKER_MEMCG_AWARE |
+						 SHRINKER_NONSLAB,
 						 "thp-deferred_split");
 	if (!deferred_split_shrinker)
 		return -ENOMEM;
_

Patches currently in -mm which might be from qinyuntan@linux.alibaba.com are

mm-list_lru-disable-memcg-awareness-under-cgroup_disable=memory.patch
mm-list_lru-dont-copy-stale-shrinker-id-from-non-memcg-aware-shrinkers.patch
mm-zswap-mark-the-zswap-shrinker-shrinker_nonslab.patch

