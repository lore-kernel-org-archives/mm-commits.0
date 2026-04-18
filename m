Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA71337699
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498553; cv=none; b=Vku7QACjHmwawTusDAyzLnwSuM+nl3JsE3k46HCuKOclZh9mWWMZx6XO37/x3c98MINYYQdMMhpxmCWyfjpqFeH4BSW1rdaCllumyWr2rdwL8cPDHrqLHrFYqifju6dXk1JhzJJ6j59yPgwru5GWpTOaSN+1o/GndMf3SdWXaUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498553; c=relaxed/simple;
	bh=InHj820pE7JzMO56bkBc0sh14K3jYOaoadlU9hHYjIQ=;
	h=Date:To:From:Subject:Message-Id; b=btRVJBisFsDVdTilpsgZlQI+/5l7Y/sEaEjJaRQ1bPhR4dxZ6qz1krAje0+wea9kRbcsIg1Vf9e5TyTWUs75EBr1+ys8LRV/QGqK7L4D6kZzFy012s2KORqXm2g/YQlF9WsOuc90Ia5lf/MGNe5iPwFhid6nLIgcqNncf+8xCDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BKWTR9wo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BKWTR9wo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1485BC19424;
	Sat, 18 Apr 2026 07:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498553;
	bh=InHj820pE7JzMO56bkBc0sh14K3jYOaoadlU9hHYjIQ=;
	h=Date:To:From:Subject:From;
	b=BKWTR9woBIliAJ3SHreyLdV4CgDzQfjXPA4D+jBtute+5jKyPR5l6z1lBLr+eV9Wd
	 FVw9/2R9VxC4Ik5V0dY/IONi0AvmFnwPdoV1bEdJzjh53VtG7BlZMj/KtWsW5nOKBG
	 R6QRdxVpBGNL2VWoqfHkUoxsk5eIi4R0TQFK6R94=
Date: Sat, 18 Apr 2026 00:49:08 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,yosry@kernel.org,weixugc@google.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,chenridong@huawei.com,chengming.zhou@linux.dev,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-workingset-prevent-memory-cgroup-release-in-lru_gen_eviction.patch removed from -mm tree
Message-Id: <20260418074912.1485BC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: workingset: prevent memory cgroup release in lru_gen_eviction()
has been removed from the -mm tree.  Its filename was
     mm-workingset-prevent-memory-cgroup-release-in-lru_gen_eviction.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: workingset: prevent memory cgroup release in lru_gen_eviction()
Date: Thu, 5 Mar 2026 19:52:34 +0800

In the near future, a folio will no longer pin its corresponding memory
cgroup.  To ensure safety, it will only be appropriate to hold the rcu
read lock or acquire a reference to the memory cgroup returned by
folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard against
the release of the memory cgroup in lru_gen_eviction().

This serves as a preparatory measure for the reparenting of the LRU pages.

Link: https://lore.kernel.org/f37e8ae2d84ddc690813d834cd75735d52d1bc78.1772711148.git.zhengqi.arch@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Allen Pais <apais@linux.microsoft.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Imran Khan <imran.f.khan@oracle.com>
Cc: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/workingset.c~mm-workingset-prevent-memory-cgroup-release-in-lru_gen_eviction
+++ a/mm/workingset.c
@@ -244,12 +244,15 @@ static void *lru_gen_eviction(struct fol
 	int refs = folio_lru_refs(folio);
 	bool workingset = folio_test_workingset(folio);
 	int tier = lru_tier_from_refs(refs, workingset);
-	struct mem_cgroup *memcg = folio_memcg(folio);
+	struct mem_cgroup *memcg;
 	struct pglist_data *pgdat = folio_pgdat(folio);
+	unsigned short memcg_id;
 
 	BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_WIDTH >
 		     BITS_PER_LONG - max(EVICTION_SHIFT, EVICTION_SHIFT_ANON));
 
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 	lrugen = &lruvec->lrugen;
 	min_seq = READ_ONCE(lrugen->min_seq[type]);
@@ -257,8 +260,10 @@ static void *lru_gen_eviction(struct fol
 
 	hist = lru_hist_from_seq(min_seq);
 	atomic_long_add(delta, &lrugen->evicted[hist][type][tier]);
+	memcg_id = mem_cgroup_private_id(memcg);
+	rcu_read_unlock();
 
-	return pack_shadow(mem_cgroup_private_id(memcg), pgdat, token, workingset, type);
+	return pack_shadow(memcg_id, pgdat, token, workingset, type);
 }
 
 /*
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


