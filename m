Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BDF33F8BE
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 01:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790126546; cv=none; b=bKYrwx3IoQaP2m6E2Rv0+eYr5OS7xqz/AW6g7c54A4v6Q1QTfQ8vAKvU0tDEcGdDGfy6kh+hTM2hwsyUUAAonXPMBXV6xcdjtEGrXKWeQX2EJyKnDJeiC3dYX1q3I5YOa9j+nIc5wF0rqjuiKwOfO7JYiyJRSxWKIepJZFUPU4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790126546; c=relaxed/simple;
	bh=GyKqrql8DhQVg8lZH2JGq598+a41tkr1MMGHh411EGw=;
	h=Date:To:From:Subject:Message-Id; b=KQ/HOf8vQ8yBiyeDPya8uKxI8EMsl8hb6PlLSxpjF2xIuRYzF1ptdOkgBaXKCGiQ6FchTO9YmpOFCRmNpCyBzWHAZaiFewFZMR2D4z8hun3AE7lDf2UCQb53Ce0yhFq+ea2/ukl8WpEP7e/ABp1xUWyALP1vYKP2hSVoY5skBQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KGP2pLEU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KGP2pLEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364F01F00893;
	Wed, 23 Sep 2026 01:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790126545;
	bh=rRfoSAEfFHIVa40c0fYNf5uFuZQnlEokyWgsK7yNDoE=;
	h=Date:To:From:Subject;
	b=KGP2pLEUeuQa+aQDCWBp9+kVLiMfpUqXN4KvcUgZRb/bFP3YAvvrU3LJ2a+tivyqN
	 lD/RneN4UChN9etK/1UQ/GTsXAfsveeiMseWGDTISxH+Mb/EVODU7kcbOSWWEAsc1d
	 YEVrd0YH0CD8t5Rcz0bh0Dk1uhDoQkCQYVH4sZ7w=
Date: Tue, 22 Sep 2026 18:22:24 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xlpang@linux.alibaba.com,usama.arif@linux.dev,shakeel.butt@linux.dev,ryan.roberts@arm.com,nphamcs@gmail.com,mkoutny@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,qinyuntan@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-zswap-mark-the-zswap-shrinker-shrinker_nonslab.patch removed from -mm tree
Message-Id: <20260923012225.364F01F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB
has been removed from the -mm tree.  Its filename was
     mm-zswap-mark-the-zswap-shrinker-shrinker_nonslab.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB
Date: Fri, 4 Sep 2026 11:35:03 +0800

With kmem accounting disabled (cgroup.memory=nokmem), memcg reclaim never
invokes the zswap shrinker: a cgroup under memory pressure does not write
back its own zswapped pages to make room; they are only written back by
global reclaim or once the global pool limit kicks in.

The zswap shrinker is registered memcg-aware but without SHRINKER_NONSLAB,
so under nokmem it is treated as a slab shrinker: before commit
03375203e1da ("mm: do not allocate shrinker info with
cgroup.memory=nokmem") it was skipped by the !memcg_kmem_online() check in
shrink_slab_memcg(); since that commit it is demoted to non-memcg-aware at
registration.  But the zswap shrinker is not a slab shrinker: it tracks
zswap entries and resolves the owning memcg from the folio's objcg,
independent of kmem accounting.

This was noticed by Michal during review of the patch "mm/list_lru: don't
copy stale shrinker id from non-memcg-aware shrinkers" [1].

Mark it SHRINKER_NONSLAB so it keeps its memcg awareness and runs under
memcg reclaim with nokmem.

Link: https://lore.kernel.org/20260904033503.4067283-3-qinyuntan@linux.alibaba.com
Link: https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/ [1]
Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Xunlei Pang <xlpang@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
---

 mm/zswap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-mark-the-zswap-shrinker-shrinker_nonslab
+++ a/mm/zswap.c
@@ -1251,8 +1251,8 @@ static struct shrinker *zswap_alloc_shri
 {
 	struct shrinker *shrinker;
 
-	shrinker =
-		shrinker_alloc(SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE, "mm-zswap");
+	shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE |
+				  SHRINKER_NONSLAB, "mm-zswap");
 	if (!shrinker)
 		return NULL;
 
_

Patches currently in -mm which might be from qinyuntan@linux.alibaba.com are

mm-list_lru-disable-memcg-awareness-under-cgroup_disable=memory.patch
mm-list_lru-dont-copy-stale-shrinker-id-from-non-memcg-aware-shrinkers.patch
mm-memcontrol-drop-kmemcg_id-and-use-mem_cgroup_id-for-list_lru-indexing.patch
mm-list_lru-keep-per-memcg-lists-with-nokmem-for-nonslab-backed-lrus.patch

