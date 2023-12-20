Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B114B126
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S7taVzNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87CAC433C8;
	Wed, 20 Dec 2023 22:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703112538;
	bh=yhVZPgllnA/4wvKiS02kYmUsdDeALFc2/gNlMb9ZMyg=;
	h=Date:To:From:Subject:From;
	b=S7taVzNWT0ufCmpNk00nEd53+C1bVJTpiuz5Loxl9XMjrxiZnVOH5E0mY6m0LjLnq
	 Xaf36uTkdL7gWortdwetxUa3soVEpwXuo4zXX6F1r9MZRD8qTQAMWgZbGnlb7ffNtw
	 A6oVFXqy/gM+If86K+vuSLUaIOd35eSKcqBfDsUY=
Date: Wed, 20 Dec 2023 14:48:57 -0800
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,lkp@intel.com,hannes@cmpxchg.org,bagasdotme@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-list_lruc-remove-unused-list_lru_from_kmem.patch removed from -mm tree
Message-Id: <20231220224857.E87CAC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/list_lru.c: remove unused list_lru_from_kmem()
has been removed from the -mm tree.  Its filename was
     mm-list_lruc-remove-unused-list_lru_from_kmem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/list_lru.c: remove unused list_lru_from_kmem()
Date: Thu Dec 14 07:32:58 AM PST 2023

Fixes: 0a97c01cd20bb ("list_lru: allow explicit memcg and NUMA node selection)
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312141318.q8b5yrAq-lkp@intel.com/
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |   31 -------------------------------
 1 file changed, 31 deletions(-)

--- a/mm/list_lru.c~mm-list_lruc-remove-unused-list_lru_from_kmem
+++ a/mm/list_lru.c
@@ -59,28 +59,6 @@ list_lru_from_memcg_idx(struct list_lru
 	}
 	return &lru->node[nid].lru;
 }
-
-static inline struct list_lru_one *
-list_lru_from_kmem(struct list_lru *lru, int nid, void *ptr,
-		   struct mem_cgroup **memcg_ptr)
-{
-	struct list_lru_node *nlru = &lru->node[nid];
-	struct list_lru_one *l = &nlru->lru;
-	struct mem_cgroup *memcg = NULL;
-
-	if (!list_lru_memcg_aware(lru))
-		goto out;
-
-	memcg = mem_cgroup_from_slab_obj(ptr);
-	if (!memcg)
-		goto out;
-
-	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
-out:
-	if (memcg_ptr)
-		*memcg_ptr = memcg;
-	return l;
-}
 #else
 static void list_lru_register(struct list_lru *lru)
 {
@@ -105,15 +83,6 @@ list_lru_from_memcg_idx(struct list_lru
 {
 	return &lru->node[nid].lru;
 }
-
-static inline struct list_lru_one *
-list_lru_from_kmem(struct list_lru *lru, int nid, void *ptr,
-		   struct mem_cgroup **memcg_ptr)
-{
-	if (memcg_ptr)
-		*memcg_ptr = NULL;
-	return &lru->node[nid].lru;
-}
 #endif /* CONFIG_MEMCG_KMEM */
 
 bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-remove-hugetlb-maintainer-mike-kravetz-fix.patch
mips-fix-r3k_cache_init-build-regression-fix.patch

