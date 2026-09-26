Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896F13A1A22
	for <mm-commits@vger.kernel.org>; Sat, 26 Sep 2026 20:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790456379; cv=none; b=IT1wICulQG+zMy722qmdRbAcdz4jScNS4NVQzrRjpf08zH+t5dTAa8WXpadKYqqCZyLtxilXStiDO8KxVS/KwW6rqslgjRxwAljJcBzhY8LhFDIUHq00aKdeYccoLHfQ0hpdLlNz400dx7zJ8gaV2948noOzXKY8kcrQI8s462Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790456379; c=relaxed/simple;
	bh=VhUkqyidQkasmQN7dvUajpeRgsWgj5hTm20d4G7YmRs=;
	h=Date:To:From:Subject:Message-Id; b=Jw3V2K/xljBYDu2yXeKVjvYMIaGEbfJqbDViZoKBi9LFoWfCjhGRoDyqgH4yTsxx9zkjZMwhKlMCWkvlXl+G56qgmP8IzSnCZGzuLTxRlGBBQtf93iabuEQKQb1rCpnYLg7NEbw7zrHhe8Io3QGgs3j4KeZWyBga8+hlz8ywOZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mur4ptpo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mur4ptpo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E181F00893;
	Sat, 26 Sep 2026 20:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790456377;
	bh=l+32rV2Ih8DjwCc/Qu0bYdlsmtPRIVOGtbMZA9GZWf4=;
	h=Date:To:From:Subject;
	b=Mur4ptpo8OqKkqeysmOChQlT8gg3X6fcr7mdkhfW53+ExnQY/5JYGAqJX42KIaXNc
	 GnAbEgxcHPFTyx4x8u2opOyKji7s+yejgk61Xu+wesR4tGtdw9jRK+GMg3GRaVGXq7
	 evd/oGwRuuGICFemxiNHb9Qo0GxJITrZEtJ5axlA=
Date: Sat, 26 Sep 2026 13:59:37 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosry@kernel.org,xlpang@linux.alibaba.com,usama.arif@linux.dev,shakeel.butt@linux.dev,ryncsn@gmail.com,roman.gushchin@linux.dev,qi.zheng@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,qinyuntan@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-list_lru-keep-per-memcg-lists-with-nokmem-for-nonslab-backed-lrus.patch removed from -mm tree
Message-Id: <20260926205937.63E181F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: list_lru: keep per-memcg lists with nokmem for NONSLAB-backed lrus
has been removed from the -mm tree.  Its filename was
     mm-list_lru-keep-per-memcg-lists-with-nokmem-for-nonslab-backed-lrus.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: mm: list_lru: keep per-memcg lists with nokmem for NONSLAB-backed lrus
Date: Thu, 10 Sep 2026 16:07:20 +0800

With cgroup.memory=nokmem, __list_lru_init() collapses every list_lru into
per-node lists.  That is fine for slab objects, which are not charged per
memcg without kmem accounting.  But a lru backed by a SHRINKER_NONSLAB
shrinker, e.g.  the THP deferred split queue or the zswap entries, holds
user memory, which is charged regardless of nokmem.  Collapsing such an
lru loses the per-memcg view of its objects.  Reclaim can no longer target
just the cgroup under pressure.

Keep such lrus memcg aware under nokmem when their backing shrinker is
registered SHRINKER_NONSLAB.

This leaves the savings of nokmem intact: slab-backed lrus (e.g.  the
superblock dentry/inode lrus) still fall back to the per-node lists, and
the per-memcg lists are allocated only when a memcg actually holds such
objects.

Link: https://lore.kernel.org/20260910080722.3961351-3-qinyuntan@linux.alibaba.com
Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Xunlei Pang <xlpang@linux.alibaba.com>
Cc: Kairui Song <ryncsn@gmail.com>
---

 mm/list_lru.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/list_lru.c~mm-list_lru-keep-per-memcg-lists-with-nokmem-for-nonslab-backed-lrus
+++ a/mm/list_lru.c
@@ -677,7 +677,9 @@ int __list_lru_init(struct list_lru *lru
 	else
 		lru->shrinker_id = -1;
 
-	if (mem_cgroup_disabled() || mem_cgroup_kmem_disabled())
+	if (mem_cgroup_disabled() ||
+	    (mem_cgroup_kmem_disabled() &&
+	     (!shrinker || !(shrinker->flags & SHRINKER_NONSLAB))))
 		memcg_aware = false;
 #endif
 
_

Patches currently in -mm which might be from qinyuntan@linux.alibaba.com are

mm-list_lru-disable-memcg-awareness-under-cgroup_disable=memory.patch
mm-list_lru-dont-copy-stale-shrinker-id-from-non-memcg-aware-shrinkers.patch
mm-thp-restore-shrinker_nonslab-on-the-deferred-split-shrinker.patch
mm-zswap-mark-the-zswap-shrinker-shrinker_nonslab.patch

