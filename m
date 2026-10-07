Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CB02F3C3D
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334204; cv=none; b=WH+jTblJsoRTvH5g2eLp6JPheARREq4N0CmqYT+iXcEJrW+Fa0GQHD/HnYHRJzB26CqGoMFxoZ1AHLvkJWOXGvouk4Sh2hJ90oxyCg5PcPgMPMr0FuUvtmOesSHMiN1PAvTQoo1FrQi3LW1jCUj04XLjzhgS9fIwoSs46K43t+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334204; c=relaxed/simple;
	bh=Hnp++hleA/SARF3Vo6Lj3m7gXBttX4a7a7BdL6KpYsA=;
	h=Date:To:From:Subject:Message-Id; b=HKrTUEqueUiudbTRTP7JeJhFt45vNY95N1R52rNjs7eKFqzDjQfRUfNFIlAeYvSPnzeOJzXeAXl9Tv5rV9LLJqWtEuuCJEk2aN19057vmg/rYzr4NBi89KLFZtbtAFaQ9ozE4DqHxNs33HiHX46oF2lV8bLFkEl25VoQ6ah9BTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=evT1g16r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="evT1g16r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5221F0089B;
	Wed,  7 Oct 2026 00:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334202;
	bh=RFUJPB/yzbMHlYrwK/hWio2NJP2el7sGHwCSVO2mmlU=;
	h=Date:To:From:Subject;
	b=evT1g16rHoasO6/03RTkKq9yPqhBj+I13ozcGu2QxZosOqBxrSNNG2VYFqV8T8EA/
	 iki89X8hVGimZ3P/xTu8m0cXXKhlysxF7n4uNOprknEHM+R5mWDuRs24NeEvz2tgZF
	 wQrPndhHaWJSDtYqShGlh0LbAe6M2KAOvI6cKDYc=
Date: Tue, 06 Oct 2026 17:50:01 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,brauner@kernel.org,baolin.wang@linux.alibaba.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-make-obj_cgroup_memcg-handle-null-objcg.patch removed from -mm tree
Message-Id: <20261007005002.3A5221F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: make obj_cgroup_memcg() handle NULL objcg
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-make-obj_cgroup_memcg-handle-null-objcg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: memcontrol: make obj_cgroup_memcg() handle NULL objcg
Date: Mon, 17 Aug 2026 17:03:26 +0800

Patch series "make unused huge shrinker memcg aware", v4.

The shmem unused huge shrinker maintains a per-superblock list of inodes
whose tail huge folio extends beyond i_size.  Because this list is not
memcg aware, reclaim triggered by memcg A can scan inodes across the
entire superblock and split huge folios charged to unrelated memcg B,
causing unexpected impact on it.

In the worst case, memcg A has no reclaimable shmem at all, making the
reclaim entirely useless and incurring unnecessary latency.  We observed
this in production, where page lock contention during split caused
multi-hundred-millisecond stalls:

  tid 11340 comm scanner locked a page for 182264 us! kstack:
          unlock_page+1
          split_huge_page_to_list+3135
          shmem_unused_huge_shrink+767
          super_cache_scan+329
          do_shrink_slab+291
          shrink_slab+533
          shrink_node+400
          do_try_to_free_pages+206
          try_to_free_mem_cgroup_pages+262
          try_charge_memcg+591
          mem_cgroup_charge+136
          __handle_mm_fault+2431
          handle_mm_fault+194
          do_user_addr_fault+462
          __do_page_fault+176
          do_page_fault+48
          page_fault+62

Usama's recent patch [1] prevents the shmem unused shrinker from being
invoked during memcg-level reclaim altogether, but this is overly
conservative: we can do better by reclaiming only the shmem charged to the
reclaiming memcg.

This series converts the shrinker list to a memcg-aware list_lru, so that
non-root memcg reclaim walks only candidates charged to the reclaiming
memcg.  Global reclaim, root memcg reclaim and shmem quota reclaim retain
their existing global semantics.

To avoid pinning a dying memcg through a long-lived CSS reference, each
inode stores an obj_cgroup reference instead of a mem_cgroup reference. 
The list_lru add/delete paths resolve the current memcg from the objcg
under RCU, staying consistent with list_lru's own memcg migration on
offline.


This patch (of 3):

obj_cgroup_memcg() currently requires a non-NULL objcg, so callers that
may hold a NULL objcg must guard the call with an explicit NULL check. 
This pattern is duplicated in folio_memcg(), folio_memcg_check(),
mm/page_owner.c, and mm/zswap.c.

Teach obj_cgroup_memcg() to accept NULL and return NULL in that case, then
remove the redundant NULL checks at the call sites.  Also remove the
mem_cgroup_from_entry() wrapper in zswap, which existed solely to provide
this NULL-safe behaviour, and replace its two callers with direct
obj_cgroup_memcg() calls.

No functional change intended.

Link: https://lore.kernel.org/cover.1786955972.git.zhengqi.arch@bytedance.com
Link: https://lore.kernel.org/09bcf74312246a6e4146be8a0cb9787f8beddb28.1786955972.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
---

 include/linux/memcontrol.h |   11 ++++++++---
 mm/page_owner.c            |    2 +-
 mm/zswap.c                 |   17 ++---------------
 3 files changed, 11 insertions(+), 19 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-make-obj_cgroup_memcg-handle-null-objcg
+++ a/include/linux/memcontrol.h
@@ -380,7 +380,7 @@ enum objext_flags {
 static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
 {
 	lockdep_assert_once(rcu_read_lock_held() || lockdep_is_held(&cgroup_mutex));
-	return READ_ONCE(objcg->memcg);
+	return objcg ? READ_ONCE(objcg->memcg) : NULL;
 }
 
 /*
@@ -433,7 +433,7 @@ static inline struct mem_cgroup *folio_m
 {
 	struct obj_cgroup *objcg = folio_objcg(folio);
 
-	return objcg ? obj_cgroup_memcg(objcg) : NULL;
+	return obj_cgroup_memcg(objcg);
 }
 
 /*
@@ -476,7 +476,7 @@ static inline struct mem_cgroup *folio_m
 
 	objcg = (void *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
 
-	return objcg ? obj_cgroup_memcg(objcg) : NULL;
+	return obj_cgroup_memcg(objcg);
 }
 
 static inline struct mem_cgroup *page_memcg_check(struct page *page)
@@ -1050,6 +1050,11 @@ void mem_cgroup_flush_workqueue(void);
 extern int mem_cgroup_init(void);
 #else /* CONFIG_MEMCG */
 
+static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
+{
+	return NULL;
+}
+
 #define MEM_CGROUP_ID_SHIFT	0
 
 #define root_mem_cgroup		(NULL)
--- a/mm/page_owner.c~mm-memcontrol-make-obj_cgroup_memcg-handle-null-objcg
+++ a/mm/page_owner.c
@@ -575,7 +575,7 @@ static inline int print_page_owner_memcg
 	}
 
 	objcg = (void *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
-	memcg = objcg ? obj_cgroup_memcg(objcg) : NULL;
+	memcg = obj_cgroup_memcg(objcg);
 	if (!memcg)
 		goto out_unlock;
 
--- a/mm/zswap.c~mm-memcontrol-make-obj_cgroup_memcg-handle-null-objcg
+++ a/mm/zswap.c
@@ -647,19 +647,6 @@ static int zswap_enabled_param_set(const
 * lru functions
 **********************************/
 
-/* should be called under RCU */
-#ifdef CONFIG_MEMCG
-static inline struct mem_cgroup *mem_cgroup_from_entry(struct zswap_entry *entry)
-{
-	return entry->objcg ? obj_cgroup_memcg(entry->objcg) : NULL;
-}
-#else
-static inline struct mem_cgroup *mem_cgroup_from_entry(struct zswap_entry *entry)
-{
-	return NULL;
-}
-#endif
-
 static inline int entry_to_nid(struct zswap_entry *entry)
 {
 	return page_to_nid(virt_to_page(entry));
@@ -682,7 +669,7 @@ static void zswap_lru_add(struct zswap_e
 	 * Similar reasoning holds for list_lru_del().
 	 */
 	rcu_read_lock();
-	memcg = mem_cgroup_from_entry(entry);
+	memcg = obj_cgroup_memcg(entry->objcg);
 	/* will always succeed */
 	list_lru_add(&zswap_list_lru, &entry->lru, nid, memcg);
 	rcu_read_unlock();
@@ -694,7 +681,7 @@ static void zswap_lru_del(struct zswap_e
 	struct mem_cgroup *memcg;
 
 	rcu_read_lock();
-	memcg = mem_cgroup_from_entry(entry);
+	memcg = obj_cgroup_memcg(entry->objcg);
 	/* will always succeed */
 	list_lru_del(&zswap_list_lru, &entry->lru, nid, memcg);
 	rcu_read_unlock();
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


